"use client";

import { PrivyProvider } from "@privy-io/react-auth";
import { CHAIN_ID } from "@/lib/constants";
import { usePathname } from "next/navigation";

const celoMainnet = {
  id: CHAIN_ID,
  name: "Celo Mainnet",
  nativeCurrency: { name: "Celo", symbol: "CELO", decimals: 18 },
  rpcUrls: { default: { http: ["https://forno.celo.org"] } },
  blockExplorers: { default: { name: "Celoscan", url: "https://celoscan.io" } },
};

export function ProvidersInner({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const appId = process.env.NEXT_PUBLIC_PRIVY_APP_ID;

  // /mini uses useMiniPay directly — no Privy needed.
  // Also skip if no valid app ID is configured (avoids crash during local dev).
  if (pathname === "/mini" || !appId || appId === "placeholder") {
    return <>{children}</>;
  }

  return (
    <PrivyProvider
      appId={appId}
      config={{
        loginMethods: ["wallet", "email"],
        appearance: { theme: "dark", accentColor: "#00d4ff" },
        defaultChain: celoMainnet as never,
        supportedChains: [celoMainnet as never],
        embeddedWallets: {
          ethereum: { createOnLogin: "users-without-wallets" },
        },
      }}
    >
      {children}
    </PrivyProvider>
  );
}
