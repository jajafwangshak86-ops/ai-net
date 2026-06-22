import { type ReactNode } from "react";

export function EmptyState({ icon, title, description, action }: {
  icon?: ReactNode; title: string; description?: string; action?: ReactNode;
}) {
  return (
    <div className="empty-state py-16">
      {icon && <div className="text-slate-600 mb-4">{icon}</div>}
      <p className="font-semibold text-slate-400">{title}</p>
      {description && <p className="text-sm text-slate-600 max-w-xs">{description}</p>}
      {action && <div className="mt-4">{action}</div>}
    </div>
  );
}
