// AI-Net SDK — contract addresses and ABIs for Celo mainnet

export const CONTRACTS = {
  AGENT_REGISTRY:    "0x052f70C756B079F7eADB8b72C7Ea1579215090C8",
  GUILD_PERMISSIONS: "0x190091c0B717AD7fA34A3840A16A8753444D8b2C",
  TASK_COORDINATOR:  "0x2097796487bea53b00D1e6e2D3327D30bEf08E3E",
  CHAIN_ID: 42220,
};

export const AGENT_REGISTRY_ABI = [
  { name: "register",          type: "function", stateMutability: "nonpayable", inputs: [{ name: "endpoint", type: "string" }, { name: "capability", type: "string" }, { name: "pricePerTask", type: "uint256" }], outputs: [] },
  { name: "update",            type: "function", stateMutability: "nonpayable", inputs: [{ name: "endpoint", type: "string" }, { name: "pricePerTask", type: "uint256" }], outputs: [] },
  { name: "deactivate",        type: "function", stateMutability: "nonpayable", inputs: [], outputs: [] },
  { name: "findByCapability",  type: "function", stateMutability: "view",       inputs: [{ name: "capability", type: "string" }], outputs: [{ name: "", type: "address[]" }] },
  { name: "agents",            type: "function", stateMutability: "view",       inputs: [{ name: "a", type: "address" }], outputs: [{ name: "", type: "tuple", components: [{ name: "wallet", type: "address" }, { name: "endpoint", type: "string" }, { name: "capability", type: "string" }, { name: "pricePerTask", type: "uint256" }, { name: "active", type: "bool" }] }] },
  { name: "totalAgents",       type: "function", stateMutability: "view",       inputs: [], outputs: [{ name: "", type: "uint256" }] },
];

export const TASK_COORDINATOR_ABI = [
  { name: "createTask",        type: "function", stateMutability: "payable",    inputs: [{ name: "description", type: "string" }, { name: "duration", type: "uint256" }], outputs: [{ name: "", type: "uint256" }] },
  { name: "hireAgent",         type: "function", stateMutability: "nonpayable", inputs: [{ name: "taskId", type: "uint256" }, { name: "agent", type: "address" }], outputs: [] },
  { name: "completeTask",      type: "function", stateMutability: "nonpayable", inputs: [{ name: "taskId", type: "uint256" }], outputs: [] },
  { name: "getAssignedAgents", type: "function", stateMutability: "view",       inputs: [{ name: "taskId", type: "uint256" }], outputs: [{ name: "", type: "address[]" }] },
];

export const GUILD_PERMISSIONS_ABI = [
  { name: "grantPermission",   type: "function", stateMutability: "payable",    inputs: [{ name: "grantee", type: "address" }, { name: "allowance", type: "uint256" }, { name: "duration", type: "uint256" }], outputs: [{ name: "", type: "uint256" }] },
  { name: "usePermission",     type: "function", stateMutability: "nonpayable", inputs: [{ name: "permId", type: "uint256" }, { name: "recipient", type: "address" }, { name: "amount", type: "uint256" }], outputs: [] },
  { name: "revokePermission",  type: "function", stateMutability: "nonpayable", inputs: [{ name: "permId", type: "uint256" }], outputs: [] },
  { name: "getGranteePerms",   type: "function", stateMutability: "view",       inputs: [{ name: "grantee", type: "address" }], outputs: [{ name: "", type: "uint256[]" }] },
];

/** Detect MiniPay wallet environment */
export function isMiniPay() {
  return typeof window !== "undefined" && !!(window).ethereum?.isMiniPay;
}
