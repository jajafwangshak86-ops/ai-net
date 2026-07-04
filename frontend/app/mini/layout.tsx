import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "AI-Net — Ask AI, Pay Per Question",
  description: "Get full AI research reports for $0.001. No subscription needed.",
};

export default function MiniLayout({ children }: { children: React.ReactNode }) {
  return children;
}
