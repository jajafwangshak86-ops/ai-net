import { type ReactNode } from "react";

type Variant = "default" | "success" | "error" | "warning" | "cyan" | "violet";

const variants: Record<Variant, string> = {
  default: "bg-white/5 text-slate-400 border-white/10",
  success: "badge-success",
  error:   "badge-error",
  warning: "badge-pending",
  cyan:    "tag-cyan",
  violet:  "tag-violet",
};

export function Badge({ children, variant = "default" }: { children: ReactNode; variant?: Variant }) {
  return <span className={`badge ${variants[variant]}`}>{children}</span>;
}
