"use client";

import { useEffect, useState, useCallback } from "react";
import { createWalletClient, custom, type WalletClient } from "viem";
import { celo } from "viem/chains";

/**
 * MiniPay integration — detects and connects to MiniPay wallet.
 * MiniPay injects window.ethereum with isMiniPay = true.
 * @see https://docs.celo.org/developer/minipay/overview
 */
export function useMiniPay() {
  const [isMiniPay, setIsMiniPay] = useState(false);
  const [address, setAddress]     = useState<`0x${string}` | null>(null);
  const [client, setClient]       = useState<WalletClient | null>(null);

  useEffect(() => {
    const ethereum = (window as any).ethereum;
    if (!ethereum?.isMiniPay) return;

    setIsMiniPay(true);

    const walletClient = createWalletClient({
      chain: celo,
      transport: custom(ethereum),
    });
    setClient(walletClient);

    // MiniPay auto-connects — grab address immediately
    walletClient.getAddresses().then(([addr]) => {
      if (addr) setAddress(addr);
    });
  }, []);

  const connect = useCallback(async () => {
    if (!client) return null;
    const [addr] = await client.requestAddresses();
    setAddress(addr);
    return addr;
  }, [client]);

  return { isMiniPay, address, client, connect };
}
