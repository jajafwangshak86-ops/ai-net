import { type ReactNode } from "react";
type AlertVariant = "info" | "success" | "warning" | "error";
const cls: Record<AlertVariant, string> = {
  info:    "alert alert-info",
  success: "alert alert-success",
  warning: "alert alert-warning",
  error:   "alert alert-error",
};
export function Alert({ children, variant = "info" }: { children: ReactNode; variant?: AlertVariant }) {
  return <div className={cls[variant]}>{children}</div>;
}
