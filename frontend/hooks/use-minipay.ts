"use client";

import { useEffect, useState, useCallback } from "react";
import { createWalletClient, custom, type WalletClient } from "viem";
import { celo } from "viem/chains";

/**
 * MiniPay integration — detects and connects to MiniPay wallet.
 *
 * MiniPay injects window.ethereum with isMiniPay = true.
 * Address is retrieved via eth_requestAccounts (MiniPay injects one address
 * as an array — accounts[0] is the user's address).
 *
 * @see https://docs.celo.org/build-on-celo/build-on-minipay/code-library
 */
export function useMiniPay() {
  const [isMiniPay, setIsMiniPay] = useState(false);
  const [address, setAddress]     = useState<`0x${string}` | null>(null);
  const [client, setClient]       = useState<WalletClient | null>(null);

  useEffect(() => {
    // Guard: this must run in a browser environment, not in Node/SSR
    if (typeof window === "undefined") return;

    const ethereum = (window as any).ethereum;
    if (!ethereum?.isMiniPay) return;

    setIsMiniPay(true);

    const walletClient = createWalletClient({
      chain: celo,
      transport: custom(ethereum),
    });
    setClient(walletClient);

    // MiniPay auto-connects on load.
    // Use eth_requestAccounts as documented — MiniPay returns one address in an array.
    ethereum
      .request({ method: "eth_requestAccounts", params: [] })
      .then((accounts: string[]) => {
        if (accounts[0]) setAddress(accounts[0] as `0x${string}`);
      })
      .catch(() => {
        // MiniPay may reject if called too early — silently ignore,
        // the user can trigger connect() manually.
      });
  }, []);

  /**
   * Manually trigger address request — call this if address is still null
   * after mount (e.g. user tapped "Connect" button).
   */
  const connect = useCallback(async () => {
    if (typeof window === "undefined") return null;
    const ethereum = (window as any).ethereum;
    if (!ethereum) return null;

    try {
      const accounts: string[] = await ethereum.request({
        method: "eth_requestAccounts",
        params: [],
      });
      const addr = accounts[0] as `0x${string}` | undefined;
      if (addr) setAddress(addr);
      return addr ?? null;
    } catch {
      return null;
    }
  }, []);

  return { isMiniPay, address, client, connect };
}
