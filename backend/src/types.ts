/** Standard API response envelope for consistent client-side handling */

export interface ApiResponse<T = unknown> {
  success: boolean;
  data?: T;
  error?: string;
  requestId?: string;
  timestamp: string;
}

export function successResponse<T>(data: T, statusCode = 200): ApiResponse<T> {
  return {
    success: true,
    data,
    timestamp: new Date().toISOString(),
  };
}

export function errorResponse(error: string, statusCode = 500): ApiResponse<never> {
  return {
    success: false,
    error,
    timestamp: new Date().toISOString(),
  };
}

/** Valid capability strings for agent routing */
export const VALID_CAPABILITIES = ["research", "risk", "coding", "design", "audit", "report"] as const;

export type ValidCapability = (typeof VALID_CAPABILITIES)[number];

/** Validate a capability string against the allowed list */
export function isValidCapability(cap: string): cap is ValidCapability {
  return (VALID_CAPABILITIES as readonly string[]).includes(cap);
}

/** Maximum allowed input lengths */
export const MAX_INPUT_LENGTHS = {
  description: 10_000,
  feedback: 2_000,
  context: 5_000,
  capability: 50,
  prompt: 5_000,
} as const;
