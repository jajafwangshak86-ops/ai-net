export function Divider({ label }: { label?: string }) {
  if (!label) return <hr className="divider" />;
  return (
    <div className="flex items-center gap-3">
      <hr className="divider flex-1" />
      <span className="text-xs text-slate-600 whitespace-nowrap">{label}</span>
      <hr className="divider flex-1" />
    </div>
  );
}
