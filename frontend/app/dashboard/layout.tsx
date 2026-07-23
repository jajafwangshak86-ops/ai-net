import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Dashboard — AI-Net",
  description:
    "View your AI-Net dashboard: task history, live agents, and on-chain statistics. Monitor autonomous AI agent activity on Celo.",
  openGraph: {
    title: "Dashboard — AI-Net",
    description: "View your AI-Net dashboard with task history and live agent statistics.",
  },
};

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
