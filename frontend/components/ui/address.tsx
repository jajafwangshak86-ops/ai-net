import { CopyButton } from "./copy-button";

export function Address({ address, short = true }: { address: string; short?: boolean }) {
  const display = short ? `${address.slice(0,6)}…${address.slice(-4)}` : address;
  return (
    <span className="inline-flex items-center gap-1 font-mono text-sm">
      <span className="text-slate-300">{display}</span>
      <CopyButton text={address} />
    </span>
  );
}
