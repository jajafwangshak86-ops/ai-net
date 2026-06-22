import { type ReactNode } from "react";

export function StatCard({ label, value, sub, icon, color = "text-cyan-400", bg = "from-cyan-500/20 to-cyan-500/5" }: {
  label: string; value: string; sub?: string;
  icon?: ReactNode; color?: string; bg?: string;
}) {
  return (
    <div className="glass-card p-5 glow-hover">
      {icon && (
        <div className={`w-9 h-9 rounded-lg bg-gradient-to-br ${bg} flex items-center justify-center mb-3`}>
          <span className={color}>{icon}</span>
        </div>
      )}
      <p className="text-2xl font-bold text-white tabular-nums count-up">{value}</p>
      <p className="text-xs font-medium text-slate-300 mt-1">{label}</p>
      {sub && <p className="text-[11px] text-slate-600 mt-0.5">{sub}</p>}
    </div>
  );
}
