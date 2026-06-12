"use client";

import { useEffect, useState } from "react";

/**
 * Detects if the app is running inside MiniPay (Celo's mobile wallet).
 * MiniPay injects window.ethereum with isMiniPay = true.
 * @see https://docs.celo.org/developer/minipay/overview
 */
export function useMiniPay() {
  const [isMiniPay, setIsMiniPay] = useState(false);

  useEffect(() => {
    const ethereum = (window as any).ethereum;
    setIsMiniPay(!!ethereum?.isMiniPay);
  }, []);

  return { isMiniPay };
}
