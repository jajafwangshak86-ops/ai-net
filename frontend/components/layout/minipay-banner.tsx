"use client";

import { useEffect, useState } from "react";
import { useMiniPay } from "@/hooks/use-minipay";
import { CONTRACTS } from "@/lib/constants";
import { createPublicClient, http } from "viem";
import { celo } from "viem/chains";

const client = createPublicClient({ chain: celo, transport: http("https://forno.celo.org") });
const ABI = [{ name: "taskCount", type: "function", stateMutability: "view", inputs: [], outputs: [{ type: "uint256" }] }] as const;

export function MiniPayBanner() {
  const { isMiniPay, address, connect } = useMiniPay();
  const [taskCount, setTaskCount] = useState<number | null>(null);

  useEffect(() => {
    client.readContract({ address: CONTRACTS.TASK_COORDINATOR, abi: ABI, functionName: "taskCount" })
      .then(n => setTaskCount(Number(n)));
  }, []);

  if (!isMiniPay) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 p-4 bg-gradient-to-t from-black/90 to-transparent z-50">
      <div className="glass-card p-4 text-center space-y-2">
        <p className="text-sm text-slate-400">
          {taskCount !== null ? `${taskCount} tasks completed on AI-Net` : "Loading..."}
        </p>
        {!address ? (
          <button onClick={connect} className="btn-primary w-full py-3 text-sm font-semibold">
            Connect MiniPay to Start
          </button>
        ) : (
          <p className="text-xs text-green-400">✓ Connected: {address.slice(0,6)}…{address.slice(-4)}</p>
        )}
      </div>
    </div>
  );
}
