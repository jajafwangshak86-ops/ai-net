"use client";

import { PrivyProvider } from "@privy-io/react-auth";
import { CHAIN_ID } from "@/lib/constants";

const baseSepolia = {
  id: CHAIN_ID,
  name: "Celo Mainnet",
  nativeCurrency: { name: "Celo", symbol: "CELO", decimals: 18 },
  rpcUrls: { default: { http: ["https://forno.celo.org"] } },
  blockExplorers: { default: { name: "Celoscan", url: "https://celoscan.io" } },
};

export function ProvidersInner({ children }: { children: React.ReactNode }) {
  return (
    <PrivyProvider
      appId={process.env.NEXT_PUBLIC_PRIVY_APP_ID ?? "placeholder"}
      config={{
        loginMethods: ["wallet", "email"],
        appearance: { theme: "dark", accentColor: "#00d4ff" },
        defaultChain: baseSepolia as never,
        supportedChains: [baseSepolia as never],
        embeddedWallets: {
          ethereum: { createOnLogin: "users-without-wallets" },
        },
      }}
    >
      {children}
    </PrivyProvider>
  );
}
