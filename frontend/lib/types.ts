/** Shared type definitions for AI-Net task results and agent data */

export interface TaskResult {
  taskId: string;
  agentsHired: string[];
  txHashes: string[];
  research?: string;
  riskAnalysis?: string;
  coding?: string;
  design?: string;
  audit?: string;
  report?: string;
}

export type AgentCapability =
  | "research"
  | "risk"
  | "coding"
  | "design"
  | "audit"
  | "report";

export type PipelineStep =
  | "idle"
  | "creating"
  | AgentCapability
  | "done"
  | "error";

export const PIPELINE_LABELS: Record<string, string> = {
  creating: "Sending payment",
  research: "Researching",
  risk: "Analyzing risks",
  coding: "Writing code",
  design: "Designing",
  audit: "Auditing",
  report: "Writing report",
};

export const OUTPUT_LABELS: Record<string, string> = {
  research: "Research",
  riskAnalysis: "Risk Analysis",
  coding: "Code",
  design: "Design",
  audit: "Audit",
  report: "Final Report",
};

export const ALL_OUTPUT_KEYS: (keyof TaskResult)[] = [
  "report",
  "research",
  "riskAnalysis",
  "coding",
  "design",
  "audit",
];
