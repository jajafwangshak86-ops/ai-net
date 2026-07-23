import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "AI Agents — AI-Net",
  description:
    "Browse the AI-Net agent marketplace. Find specialized AI agents for research, risk analysis, coding, design, and more.",
  openGraph: {
    title: "AI Agents — AI-Net",
    description: "Browse specialized AI agents on the AI-Net marketplace.",
  },
};

export default function AgentsLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
