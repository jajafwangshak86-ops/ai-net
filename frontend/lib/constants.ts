export const CONTRACTS = {
  AGENT_REGISTRY:    process.env.NEXT_PUBLIC_AGENT_REGISTRY    as `0x${string}`,
  GUILD_PERMISSIONS: process.env.NEXT_PUBLIC_GUILD_PERMISSIONS as `0x${string}`,
  TASK_COORDINATOR:  process.env.NEXT_PUBLIC_TASK_COORDINATOR  as `0x${string}`,
};

export const CHAIN_ID = Number(process.env.NEXT_PUBLIC_CHAIN_ID ?? 44787);

export const BACKEND_URL = process.env.NEXT_PUBLIC_BACKEND_URL ?? "http://localhost:3000";

export const CAPABILITIES = ["research", "risk", "coding", "design", "audit", "report"] as const;
export type Capability = (typeof CAPABILITIES)[number];

/** cUSD on Celo Mainnet */
export const CUSD_ADDRESS = "0x765DE816845861e75A25fCA122bb6898B8B1282a" as const;

/** Task price: 0.001 cUSD (18 decimals) */
export const TASK_PRICE_CUSD = BigInt("1000000000000000");

/** Task price in CELO wei (~0.0008 CELO ≈ $0.001) */
export const TASK_PRICE_CELO = BigInt("800000000000000");

/** Default task duration: 7 days in seconds */
export const TASK_DURATION_SECONDS = BigInt(7 * 24 * 60 * 60);
