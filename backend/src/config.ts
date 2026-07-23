import "dotenv/config";

function required(key: string): string {
  const val = process.env[key];
  if (!val) throw new Error(`Missing env var: ${key}`);
  return val;
}

function optional(key: string, fallback: string): string {
  return process.env[key] ?? fallback;
}

export const config = {
  rpcUrl:               required("RPC_URL"),
  chainId:              Number(required("CHAIN_ID")),
  coordinatorKey:       required("COORDINATOR_PRIVATE_KEY") as `0x${string}`,
  veniceApiKey:         required("VENICE_API_KEY"),
  veniceBaseUrl:        optional("VENICE_BASE_URL", "https://api.venice.ai/api/v1"),
  oneshotApiKey:        required("ONESHOT_API_KEY"),
  oneshotBaseUrl:       optional("ONESHOT_BASE_URL", "https://api.1shot.link/v1"),
  port:                 Number(optional("PORT", "3000")),
  allowedOrigins:       optional("ALLOWED_ORIGINS", "https://ai-net.vercel.app,http://localhost:3000")
    .split(",")
    .map((s) => s.trim()),
  contracts: {
    agentRegistry:      required("AGENT_REGISTRY_ADDRESS") as `0x${string}`,
    guildPermissions:   required("GUILD_PERMISSIONS_ADDRESS") as `0x${string}`,
    taskCoordinator:    required("TASK_COORDINATOR_ADDRESS") as `0x${string}`,
  },
} as const;

// ── Minimal ABIs (only functions the backend calls) ───────────────────────────

export const agentRegistryAbi = [
  {
    name: "findByCapability",
    type: "function",
    stateMutability: "view",
    inputs: [{ name: "capability", type: "string" }],
    outputs: [{ name: "", type: "address[]" }],
  },
  {
    name: "agents",
    type: "function",
    stateMutability: "view",
    inputs: [{ name: "a", type: "address" }],
    outputs: [
      {
        name: "",
        type: "tuple",
        components: [
          { name: "wallet",       type: "address" },
          { name: "endpoint",     type: "string"  },
          { name: "capability",   type: "string"  },
          { name: "pricePerTask", type: "uint256" },
          { name: "active",       type: "bool"    },
        ],
      },
    ],
  },
] as const;

export const taskCoordinatorAbi = [
  {
    name: "createTask",
    type: "function",
    stateMutability: "payable",
    inputs: [
      { name: "description", type: "string"  },
      { name: "duration",    type: "uint256" },
    ],
    outputs: [{ name: "", type: "uint256" }],
  },
  {
    name: "hireAgent",
    type: "function",
    stateMutability: "nonpayable",
    inputs: [
      { name: "taskId", type: "uint256" },
      { name: "agent",  type: "address" },
    ],
    outputs: [],
  },
  {
    name: "completeTask",
    type: "function",
    stateMutability: "nonpayable",
    inputs: [{ name: "taskId", type: "uint256" }],
    outputs: [],
  },
  {
    name: "getAssignedAgents",
    type: "function",
    stateMutability: "view",
    inputs: [{ name: "taskId", type: "uint256" }],
    outputs: [{ name: "", type: "address[]" }],
  },
] as const;
