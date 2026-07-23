import "dotenv/config";
import express, { type Request, type Response, type NextFunction } from "express";
import cors from "cors";
import rateLimit from "express-rate-limit";
import { config } from "./config";
import { runCoordinator } from "./coordinator";
import { runAgent, type Capability } from "./agentRunner";
import { buildProject } from "./builder";

const app = express();

// ── Security middleware ────────────────────────────────────────────────────────

const ALLOWED_ORIGINS = config.allowedOrigins;

app.use(
  cors({
    origin: ALLOWED_ORIGINS,
    methods: ["GET", "POST"],
    allowedHeaders: ["Content-Type", "Authorization"],
    maxAge: 86400,
  }),
);

app.use(express.json({ limit: "1mb" }));

// Security headers
app.use((_req: Request, res: Response, next: NextFunction) => {
  res.setHeader("X-Content-Type-Options", "nosniff");
  res.setHeader("X-Frame-Options", "DENY");
  res.setHeader("X-XSS-Protection", "1; mode=block");
  res.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
  next();
});

const limiter = rateLimit({
  windowMs: 60_000,
  max: 10,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: "Too many requests, please try again later" },
});

const taskLimiter = rateLimit({
  windowMs: 60_000,
  max: 5,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: "Task rate limit exceeded, please wait before submitting" },
});

// ── Request logging middleware ─────────────────────────────────────────────────

app.use((req: Request, res: Response, next: NextFunction) => {
  const start = Date.now();
  const requestId = Math.random().toString(36).slice(2, 10);
  req.headers["x-request-id"] = requestId;
  res.setHeader("X-Request-Id", requestId);
  res.setHeader("X-API-Version", "1.1.0");
  console.log(`[${requestId}] ${req.method} ${req.path}`);
  res.on("finish", () => {
    console.log(`[${requestId}] ${res.statusCode} ${Date.now() - start}ms`);
  });
  next();
});

// ── Input sanitization ─────────────────────────────────────────────────────────

function sanitize(input: string, maxLength = 10_000): string {
  return input.trim().slice(0, maxLength);
}

function validateCapability(cap: string): cap is Capability {
  return ["research", "risk", "report", "coding", "design", "audit"].includes(cap);
}

// ── Routes ────────────────────────────────────────────────────────────────────

app.get("/health", (_req: Request, res: Response) => {
  res.json({
    status: "ok",
    chain: config.chainId,
    version: process.env.npm_package_version ?? "1.1.0",
    uptime: Math.floor(process.uptime()),
    timestamp: new Date().toISOString(),
  });
});

/**
 * POST /task
 * Full coordinator loop: discover all agents → hire → Venice AI → complete
 */
app.post("/task", taskLimiter, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { description, budgetEth = "0.05", durationDays = 7, capabilities } = req.body as {
      description: string;
      budgetEth?: string;
      durationDays?: number;
      capabilities?: string[];
    };

    if (!description?.trim()) {
      res.status(400).json({ error: "description is required" });
      return;
    }

    const sanitized = sanitize(description);
    const validCapabilities = capabilities?.filter(validateCapability);

    const result = await runCoordinator(sanitized, budgetEth, durationDays, validCapabilities);
    res.json({
      taskId: result.taskId.toString(),
      agentsHired: result.agentsHired,
      txHashes: result.txHashes,
      research: result.research,
      riskAnalysis: result.riskAnalysis,
      coding: result.coding,
      design: result.design,
      audit: result.audit,
      report: result.report,
    });
  } catch (err) {
    next(err);
  }
});

/**
 * POST /agent/:capability/run
 * A2A route: run a specific agent directly.
 */
app.post("/agent/:capability/run", limiter, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const capability = req.params.capability;
    const { taskId, description, context = "" } = req.body as {
      taskId: string;
      description: string;
      context?: string;
    };

    if (!validateCapability(capability)) {
      res.status(400).json({ error: `Unknown capability: ${capability}` });
      return;
    }
    if (!taskId || !description?.trim()) {
      res.status(400).json({ error: "taskId and description are required" });
      return;
    }

    const sanitized = sanitize(description);
    const sanitizedContext = sanitize(context, 5_000);

    const result = await runAgent(capability, BigInt(taskId), sanitized, sanitizedContext);
    res.json({
      capability: result.capability,
      agentAddress: result.agentAddress,
      output: result.output,
      subAgentsHired: result.subAgentsHired,
      txHashes: result.txHashes,
    });
  } catch (err) {
    next(err);
  }
});

/**
 * POST /verify-endpoint
 * Probes an agent endpoint to confirm it's reachable.
 */
app.post("/verify-endpoint", limiter, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { endpoint } = req.body as { endpoint: string };
    if (!endpoint?.trim()) {
      res.status(400).json({ error: "endpoint is required" });
      return;
    }

    let url: URL;
    try {
      url = new URL(endpoint);
    } catch {
      res.status(400).json({ ok: false, reason: "Invalid URL" });
      return;
    }
    if (!["http:", "https:"].includes(url.protocol)) {
      res.status(400).json({ ok: false, reason: "URL must be http or https" });
      return;
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 10_000);
    try {
      const probe = await fetch(endpoint, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ task: "ping", description: "AI-Net endpoint verification" }),
        signal: controller.signal,
      });
      clearTimeout(timeout);
      if (!probe.ok) {
        res.json({ ok: false, reason: `Endpoint returned HTTP ${probe.status}` });
        return;
      }
      const text = await probe.text().catch(() => "");
      res.json({ ok: true, status: probe.status, preview: text.slice(0, 200) });
    } catch (e: unknown) {
      clearTimeout(timeout);
      const msg = (e as Error).message ?? "Connection failed";
      res.json({ ok: false, reason: msg.includes("abort") ? "Endpoint timed out (>10s)" : msg });
    }
  } catch (err) {
    next(err);
  }
});

/**
 * POST /suggest-agents
 * Given a task description, returns the optimal capability pipeline.
 */
app.post("/suggest-agents", limiter, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { description } = req.body as { description: string };
    if (!description?.trim()) {
      res.status(400).json({ error: "description is required" });
      return;
    }

    const sanitized = sanitize(description, 2_000);
    const { veniceChat } = await import("./agents/venice.js");
    const SYSTEM = `You are a task router. Given a task description, return ONLY a JSON array of capability strings needed, in execution order.

Available: ["research","risk","coding","design","audit","report"]

Rules:
- For CODE tasks: return ["coding","report"]
- For BUSINESS/STRATEGY tasks: ["research","risk","audit","report"]
- For DESIGN tasks: ["design","report"]
- For MIXED tasks: ["research","coding","design","report"]
- Always end with "report"
- Output ONLY the JSON array, nothing else`;

    const raw = await veniceChat(SYSTEM, sanitized, "mistral-small-3-2-24b-instruct");
    const cleaned = raw.replace(/```[a-z]*\n?/g, "").replace(/```/g, "").trim();
    const match = cleaned.match(/\[.*?\]/s);
    let capabilities: string[];
    try {
      capabilities = JSON.parse(match?.[0] ?? cleaned) as string[];
    } catch {
      const d = sanitized.toLowerCase();
      const isCoding = /build|code|implement|contract|solidity|script|app|cli/.test(d);
      const isDesign = /design|ui|ux|frontend|layout/.test(d);
      capabilities = isCoding
        ? isDesign
          ? ["coding", "design", "report"]
          : ["coding", "report"]
        : ["research", "risk", "audit", "report"];
    }
    res.json({ capabilities });
  } catch (err) {
    next(err);
  }
});

/**
 * POST /enhance
 * Refine a specific agent output with a follow-up prompt.
 */
app.post("/enhance", limiter, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { capability, originalOutput, feedback } = req.body as {
      capability: string;
      originalOutput: string;
      feedback: string;
    };
    if (!originalOutput?.trim() || !feedback?.trim()) {
      res.status(400).json({ error: "originalOutput and feedback are required" });
      return;
    }

    const sanitizedFeedback = sanitize(feedback, 2_000);
    const { veniceChat } = await import("./agents/venice.js");
    const SYSTEM = `You are a ${sanitize(capability, 50)} specialist. You previously produced an output. The user wants it improved. Apply their feedback precisely and return the complete revised output — no explanations, just the improved content.`;
    const enhanced = await veniceChat(
      SYSTEM,
      `Original output:\n${originalOutput}\n\nUser feedback:\n${sanitizedFeedback}\n\nRevised output:`,
      "mistral-small-3-2-24b-instruct",
    );
    res.json({ enhanced });
  } catch (err) {
    next(err);
  }
});

app.post("/build", limiter, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { prompt } = req.body as { prompt: string };
    if (!prompt?.trim()) {
      res.status(400).json({ error: "prompt is required" });
      return;
    }
    const sanitized = sanitize(prompt, 5_000);
    const result = await buildProject(sanitized);
    res.json({
      success: result.success,
      outputDir: result.outputDir,
      plan: result.plan,
      files: result.files.map((f) => ({ path: f.path, size: f.content.length })),
      buildLog: result.buildLog.slice(-2000),
    });
  } catch (err) {
    next(err);
  }
});

// ── 404 handler ──────────────────────────────────────────────────────────────

app.use((_req: Request, res: Response) => {
  res.status(404).json({ error: "Not found", path: _req.path });
});

// ── Error handler ─────────────────────────────────────────────────────────────

app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  const requestId = _req.headers["x-request-id"] ?? "unknown";
  console.error(`[${requestId}] Error:`, err.message);

  if (err.message.includes("timeout")) {
    res.status(504).json({ error: "Request timed out" });
    return;
  }
  if (err.message.includes("revert")) {
    res.status(422).json({ error: "Transaction reverted", detail: err.message.slice(0, 200) });
    return;
  }
  res.status(500).json({ error: "Internal server error" });
});

export default app;

if (!process.env.VERCEL) {
  app.listen(config.port, () => {
    console.log(`[AI-Net] Backend running on port ${config.port}`);
    console.log(`[AI-Net] Chain ID: ${config.chainId}`);
    console.log(`[AI-Net] TaskCoordinator: ${config.contracts.taskCoordinator}`);
  });
}
