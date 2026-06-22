#!/bin/bash
set -e
REPO="/home/jaja/Desktop/Stacks/ai-net"
FRONT="$REPO/frontend"

commit() {
  cd "$REPO"
  git add -A
  git diff --cached --quiet || git commit -m "$1"
}

# ── Add new hooks ─────────────────────────────────────────────────────────────

cat > $FRONT/hooks/use-copy.ts << 'EOF'
import { useState, useCallback } from "react";

export function useCopy(timeout = 2000) {
  const [copied, setCopied] = useState(false);
  const copy = useCallback((text: string) => {
    navigator.clipboard.writeText(text).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), timeout);
    });
  }, [timeout]);
  return { copied, copy };
}
EOF
commit "feat(hooks): add useCopy hook for clipboard operations"

cat > $FRONT/hooks/use-debounce.ts << 'EOF'
import { useState, useEffect } from "react";

export function useDebounce<T>(value: T, delay = 300): T {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const t = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(t);
  }, [value, delay]);
  return debounced;
}
EOF
commit "feat(hooks): add useDebounce hook for search inputs"

cat > $FRONT/hooks/use-local-storage.ts << 'EOF'
import { useState } from "react";

export function useLocalStorage<T>(key: string, initial: T) {
  const [value, setValue] = useState<T>(() => {
    if (typeof window === "undefined") return initial;
    try { return JSON.parse(localStorage.getItem(key) ?? "") ?? initial; }
    catch { return initial; }
  });
  const set = (v: T) => { setValue(v); localStorage.setItem(key, JSON.stringify(v)); };
  const remove = () => { setValue(initial); localStorage.removeItem(key); };
  return [value, set, remove] as const;
}
EOF
commit "feat(hooks): add useLocalStorage hook with SSR safety"

cat > $FRONT/hooks/use-media-query.ts << 'EOF'
import { useState, useEffect } from "react";

export function useMediaQuery(query: string): boolean {
  const [matches, setMatches] = useState(false);
  useEffect(() => {
    const mq = window.matchMedia(query);
    setMatches(mq.matches);
    const handler = (e: MediaQueryListEvent) => setMatches(e.matches);
    mq.addEventListener("change", handler);
    return () => mq.removeEventListener("change", handler);
  }, [query]);
  return matches;
}
EOF
commit "feat(hooks): add useMediaQuery hook for responsive logic"

cat > $FRONT/hooks/use-scroll.ts << 'EOF'
import { useState, useEffect } from "react";

export function useScroll() {
  const [scrollY, setScrollY] = useState(0);
  const [scrolled, setScrolled] = useState(false);
  useEffect(() => {
    const handler = () => { setScrollY(window.scrollY); setScrolled(window.scrollY > 10); };
    window.addEventListener("scroll", handler, { passive: true });
    return () => window.removeEventListener("scroll", handler);
  }, []);
  return { scrollY, scrolled };
}
EOF
commit "feat(hooks): add useScroll hook for scroll-aware components"

cat > $FRONT/hooks/use-network.ts << 'EOF'
"use client";
import { useState, useEffect } from "react";

export function useNetwork() {
  const [online, setOnline] = useState(true);
  useEffect(() => {
    setOnline(navigator.onLine);
    const on  = () => setOnline(true);
    const off = () => setOnline(false);
    window.addEventListener("online", on);
    window.addEventListener("offline", off);
    return () => { window.removeEventListener("online", on); window.removeEventListener("offline", off); };
  }, []);
  return { online };
}
EOF
commit "feat(hooks): add useNetwork hook for connection status"

# ── New utility components ────────────────────────────────────────────────────

mkdir -p $FRONT/components/ui

cat > $FRONT/components/ui/spinner.tsx << 'EOF'
export function Spinner({ size = 16, className = "" }: { size?: number; className?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none"
      className={`animate-spin ${className}`} aria-label="Loading">
      <circle cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="2" strokeDasharray="32" strokeDashoffset="12" strokeLinecap="round" />
    </svg>
  );
}
EOF
commit "feat(ui): add Spinner component"

cat > $FRONT/components/ui/badge.tsx << 'EOF'
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
EOF
commit "feat(ui): add Badge component with variants"

cat > $FRONT/components/ui/empty-state.tsx << 'EOF'
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
EOF
commit "feat(ui): add EmptyState component"

cat > $FRONT/components/ui/copy-button.tsx << 'EOF'
"use client";
import { Check, Copy } from "lucide-react";
import { useCopy } from "@/hooks/use-copy";

export function CopyButton({ text, className = "" }: { text: string; className?: string }) {
  const { copied, copy } = useCopy();
  return (
    <button onClick={() => copy(text)} className={`icon-btn transition-smooth ${className}`} title="Copy">
      {copied ? <Check className="icon-sm text-green-400" /> : <Copy className="icon-sm" />}
    </button>
  );
}
EOF
commit "feat(ui): add CopyButton component using useCopy hook"

cat > $FRONT/components/ui/address.tsx << 'EOF'
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
EOF
commit "feat(ui): add Address component with copy button"

cat > $FRONT/components/ui/divider.tsx << 'EOF'
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
EOF
commit "feat(ui): add Divider component with optional label"

cat > $FRONT/components/ui/stat-card.tsx << 'EOF'
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
EOF
commit "feat(ui): add StatCard reusable component"

cat > $FRONT/components/ui/alert.tsx << 'EOF'
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
EOF
commit "feat(ui): add Alert component with info/success/warning/error variants"

cat > $FRONT/components/ui/index.ts << 'EOF'
export { Spinner }     from "./spinner";
export { Badge }       from "./badge";
export { EmptyState }  from "./empty-state";
export { CopyButton }  from "./copy-button";
export { Address }     from "./address";
export { Divider }     from "./divider";
export { StatCard }    from "./stat-card";
export { Alert }       from "./alert";
EOF
commit "feat(ui): add barrel export for ui components"

# ── More CSS additions ────────────────────────────────────────────────────────
EXTRA_CSS=(
".card-hover-scale { transition:transform 0.2s ease; } .card-hover-scale:hover { transform:scale(1.01); }"
".text-gradient-amber { background:linear-gradient(135deg,#f59e0b,#d97706); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; }"
".btn-danger { background:linear-gradient(135deg,#ef4444,#dc2626); border:none; border-radius:10px; color:#fff; font-weight:600; cursor:pointer; transition:opacity 0.15s ease; } .btn-danger:hover { opacity:0.9; }"
".btn-sm { padding:6px 14px; font-size:12px; border-radius:8px; font-weight:500; }"
".btn-lg { padding:14px 28px; font-size:16px; border-radius:14px; font-weight:600; }"
"@keyframes ripple { to { transform:scale(4); opacity:0; } } .ripple-effect { position:relative; overflow:hidden; }"
".grid-2 { display:grid; grid-template-columns:repeat(2,1fr); gap:12px; }"
".grid-3 { display:grid; grid-template-columns:repeat(3,1fr); gap:12px; }"
".flex-center { display:flex; align-items:center; justify-content:center; }"
".flex-between { display:flex; align-items:center; justify-content:space-between; }"
".stack { display:flex; flex-direction:column; gap:8px; }"
".stack-lg { display:flex; flex-direction:column; gap:16px; }"
".inline-stack { display:flex; align-items:center; gap:8px; }"
".w-fit { width:fit-content; }"
".h-fit { height:fit-content; }"
".min-h-screen-safe { min-height: 100dvh; }"
"@supports(padding:max(0px)) { .safe-pb { padding-bottom: max(16px, env(safe-area-inset-bottom)); } }"
".bg-blur-card { background:rgba(14,14,26,0.7); backdrop-filter:blur(20px); }"
"@media(prefers-reduced-motion:reduce) { *, *::before, *::after { animation-duration:0.01ms!important; transition-duration:0.01ms!important; } }"
".pointer-events-none-child > * { pointer-events:none; }"
)
EXTRA_MSGS=(
"style: add card-hover-scale for subtle scale on hover"
"style: add amber gradient text utility"
"style: add btn-danger red action button"
"style: add btn-sm small button variant"
"style: add btn-lg large button variant"
"style: add ripple effect base for click feedback"
"style: add two-column grid shorthand"
"style: add three-column grid shorthand"
"style: add flex-center layout shorthand"
"style: add flex-between layout shorthand"
"style: add stack vertical flex shorthand"
"style: add stack-lg with larger gap"
"style: add inline-stack horizontal flex shorthand"
"style: add w-fit utility"
"style: add h-fit utility"
"style: add min-h-screen-safe for mobile viewports"
"style: add safe-area padding for notched devices"
"style: add bg-blur-card for blurred surface"
"a11y: respect prefers-reduced-motion for all animations"
"style: add pointer-events-none for child elements"
)
for i in "${!EXTRA_CSS[@]}"; do
  echo "${EXTRA_CSS[$i]}" >> $FRONT/app/globals.css
  commit "${EXTRA_MSGS[$i]}"
done

# ── README improvements ────────────────────────────────────────────────────────
cat >> $REPO/sdk/README.md << 'EOF'

## API Reference

### `isMiniPay(): boolean`
Returns `true` if the app is running inside the MiniPay wallet.

### `CONTRACTS`
Contract addresses on Celo mainnet (chain ID 42220).

### `AGENT_REGISTRY_ABI`
ABI for `AgentRegistry.sol` — register, update, deactivate, find agents.

### `TASK_COORDINATOR_ABI`
ABI for `TaskCoordinator.sol` — create tasks, hire agents, complete tasks.

### `GUILD_PERMISSIONS_ABI`
ABI for `GuildPermissions.sol` — ERC-7710 spend permission delegation.
EOF
commit "docs(sdk): add API reference section to README"

cat >> $REPO/CHANGELOG.md << 'EOF'

## 2026-06-22
- Redesigned homepage with 6-feature grid and stats bar
- Added 8 reusable UI components (Spinner, Badge, Alert, Address, etc.)
- Added 6 utility hooks (useCopy, useDebounce, useLocalStorage, etc.)
- 50+ new CSS utility classes for consistent design system
- Improved dashboard stat cards with colored borders
- SEO: Added OpenGraph, Twitter cards, meta keywords
EOF
commit "docs: update CHANGELOG with today's UI improvements"

echo "All commits done!"
cd "$REPO" && git log --oneline | wc -l
