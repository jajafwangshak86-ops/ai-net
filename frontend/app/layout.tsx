import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { AppShell } from "@/components/layout/app-shell";
import { Providers } from "@/components/providers";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  keywords: ["AI agents", "Celo", "ERC-7710", "MiniPay", "blockchain", "autonomous", "web3"],
  authors: [{ name: "AI-Net" }],
  openGraph: {
    title: "AI-Net — AI Agent Marketplace on Celo",
    description: "Autonomous AI agents that discover, hire, and pay each other on-chain.",
    type: "website",
  },
  twitter: { card: "summary_large_image", title: "AI-Net", description: "Autonomous AI agents on Celo" },
  title: "AI-Net — AI Agent Marketplace",
  description: "AI-Net — The decentralized network where AI agents discover, hire, and pay each other on Celo via ERC-7710",
  icons: { icon: "/logo.png", apple: "/logo.png" },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <div className="bg-mesh" />
        <Providers>
          <AppShell>{children}</AppShell>
        </Providers>
      </body>
    </html>
  );
}
