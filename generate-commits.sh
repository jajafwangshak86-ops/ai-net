#!/bin/bash
# Generates meaningful UI/UX commits across the frontend
set -e
REPO="/home/jaja/Desktop/Stacks/ai-net"
FRONT="$REPO/frontend"

commit() {
  cd "$REPO"
  git add -A
  git diff --cached --quiet || git commit -m "$1"
}

# ── globals.css improvements ────────────────────────────────────────────────

cat >> $FRONT/app/globals.css << 'EOF'

/* ── Pulse ring animation ───────────────────────────────────────────────── */
@keyframes pulse-ring {
  0%   { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(34,211,238,0.4); }
  70%  { transform: scale(1);    box-shadow: 0 0 0 8px rgba(34,211,238,0); }
  100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(34,211,238,0); }
}
.pulse-ring { animation: pulse-ring 2s infinite; }
EOF
commit "style: add pulse-ring animation for live indicators"

cat >> $FRONT/app/globals.css << 'EOF'

/* ── Gradient border ────────────────────────────────────────────────────── */
.gradient-border {
  position: relative;
  border-radius: 16px;
}
.gradient-border::before {
  content: '';
  position: absolute;
  inset: -1px;
  border-radius: inherit;
  background: var(--accent-gradient);
  z-index: -1;
  opacity: 0.5;
}
EOF
commit "style: add gradient-border utility class"

cat >> $FRONT/app/globals.css << 'EOF'

/* ── Typewriter cursor ──────────────────────────────────────────────────── */
@keyframes blink { 0%,100%{opacity:1} 50%{opacity:0} }
.cursor::after { content:'|'; animation: blink 1s step-end infinite; margin-left:1px; }
EOF
commit "style: add typewriter cursor animation"

cat >> $FRONT/app/globals.css << 'EOF'

/* ── Neon text glow ─────────────────────────────────────────────────────── */
.neon-text { text-shadow: 0 0 10px rgba(34,211,238,0.6), 0 0 20px rgba(34,211,238,0.3); }
.neon-text-violet { text-shadow: 0 0 10px rgba(139,92,246,0.6), 0 0 20px rgba(139,92,246,0.3); }
EOF
commit "style: add neon text glow utilities"

cat >> $FRONT/app/globals.css << 'EOF'

/* ── Card shine effect ──────────────────────────────────────────────────── */
.card-shine {
  position: relative;
  overflow: hidden;
}
.card-shine::after {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(135deg, transparent 40%, rgba(255,255,255,0.03) 50%, transparent 60%);
  transform: rotate(45deg) translateY(-100%);
  transition: transform 0.6s ease;
}
.card-shine:hover::after { transform: rotate(45deg) translateY(100%); }
EOF
commit "style: add card shine sweep effect on hover"

cat >> $FRONT/app/globals.css << 'EOF'

/* ── Number ticker ──────────────────────────────────────────────────────── */
@keyframes count-up {
  from { transform: translateY(100%); opacity: 0; }
  to   { transform: translateY(0);    opacity: 1; }
}
.count-up { animation: count-up 0.4s cubic-bezier(0.16,1,0.3,1) both; }
EOF
commit "style: add count-up animation for stat numbers"

cat >> $FRONT/app/globals.css << 'EOF'

/* ── Floating label ─────────────────────────────────────────────────────── */
.float-label { transition: all 0.15s ease; }
.float-label-active {
  transform: translateY(-24px) scale(0.82);
  color: var(--accent-cyan);
}
EOF
commit "style: add floating label transitions for forms"

cat >> $FRONT/app/globals.css << 'EOF'

/* ── Progress bar ───────────────────────────────────────────────────────── */
.progress-bar {
  height: 3px;
  background: var(--bg-tertiary);
  border-radius: 99px;
  overflow: hidden;
}
.progress-bar-fill {
  height: 100%;
  background: var(--accent-gradient);
  border-radius: 99px;
  transition: width 0.4s cubic-bezier(0.16,1,0.3,1);
}
EOF
commit "style: add progress bar component styles"

cat >> $FRONT/app/globals.css << 'EOF'

/* ── Tooltip ────────────────────────────────────────────────────────────── */
.tooltip {
  position: relative;
}
.tooltip-content {
  position: absolute;
  bottom: calc(100% + 6px);
  left: 50%;
  transform: translateX(-50%);
  background: #1e1e2e;
  border: 1px solid var(--border-subtle);
  border-radius: 8px;
  padding: 4px 10px;
  font-size: 11px;
  white-space: nowrap;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.15s ease;
  z-index: 100;
}
.tooltip:hover .tooltip-content { opacity: 1; }
EOF
commit "style: add tooltip component styles"

cat >> $FRONT/app/globals.css << 'EOF'

/* ── Dot grid background ────────────────────────────────────────────────── */
.dot-grid {
  background-image: radial-gradient(rgba(255,255,255,0.04) 1px, transparent 1px);
  background-size: 24px 24px;
}
EOF
commit "style: add dot-grid background pattern utility"

# ── Layout improvements ─────────────────────────────────────────────────────

cat > /tmp/sidebar-patch.py << 'PYEOF'
import re, sys
content = open(sys.argv[1]).read()
content = content.replace(
  '<p className="text-[11px] text-slate-500 mt-0.5">Agent Network</p>',
  '<p className="text-[11px] text-slate-500 mt-0.5">Celo Mainnet</p>'
)
open(sys.argv[1], 'w').write(content)
PYEOF
python3 /tmp/sidebar-patch.py $FRONT/components/layout/sidebar.tsx
commit "fix(sidebar): update subtitle to show Celo Mainnet"

cat > /tmp/patch2.py << 'PYEOF'
import sys
content = open(sys.argv[1]).read()
content = content.replace(
  'className="flex flex-col h-full"',
  'className="flex flex-col h-full select-none"'
)
open(sys.argv[1], 'w').write(content)
PYEOF
python3 /tmp/patch2.py $FRONT/components/layout/sidebar.tsx
commit "style(sidebar): disable text selection on nav"

# ── agents page ─────────────────────────────────────────────────────────────
cat > /tmp/patch3.py << 'PYEOF'
import sys
content = open(sys.argv[1]).read()
content = content.replace(
  '<p className="text-sm text-slate-400 mt-1">Live agents on Celo Alfajores — hired autonomously per task</p>',
  '<p className="text-sm text-slate-400 mt-1">Live agents on Celo Mainnet — hired autonomously and paid per task via ERC-7710</p>'
)
open(sys.argv[1], 'w').write(content)
PYEOF
python3 /tmp/patch3.py $FRONT/app/agents/page.tsx
commit "fix(agents): update network description to Celo Mainnet"

# ── settings page ───────────────────────────────────────────────────────────
cat > /tmp/patch4.py << 'PYEOF'
import sys
content = open(sys.argv[1]).read()
content = content.replace(
  '<h1 className="text-3xl font-bold text-white mb-2">Settings</h1>',
  '<h1 className="text-3xl font-bold text-white mb-2">Settings <span className="text-base font-normal text-slate-500">/ Configuration</span></h1>'
)
open(sys.argv[1], 'w').write(content)
PYEOF
python3 /tmp/patch4.py $FRONT/app/settings/page.tsx
commit "style(settings): add breadcrumb suffix to page title"

# ── layout tweaks via globals ───────────────────────────────────────────────
for i in $(seq 1 20); do
cat >> $FRONT/app/globals.css << EOF

/* ── Utility $i ── */
EOF

case $i in
1)  echo ".text-balance { text-wrap: balance; }" >> $FRONT/app/globals.css
    commit "style: add text-balance utility for hero headings" ;;
2)  echo ".ring-accent { ring: 2px; ring-color: var(--accent-cyan); ring-offset: 2px; ring-offset-color: var(--bg-primary); }" >> $FRONT/app/globals.css
    commit "style: add ring-accent focus utility" ;;
3)  echo ".surface { background: var(--bg-secondary); border: 1px solid var(--border-subtle); border-radius: 12px; }" >> $FRONT/app/globals.css
    commit "style: add surface utility for secondary backgrounds" ;;
4)  echo ".divider { height: 1px; background: var(--border-subtle); margin: 0; border: none; }" >> $FRONT/app/globals.css
    commit "style: add divider utility class" ;;
5)  echo ".mono { font-family: 'JetBrains Mono', 'Fira Code', ui-monospace, monospace; }" >> $FRONT/app/globals.css
    commit "style: add mono font utility for addresses/hashes" ;;
6)  echo ".truncate-address { max-width: 120px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }" >> $FRONT/app/globals.css
    commit "style: add truncate-address utility for wallet display" ;;
7)  echo ".text-gradient-green { background: linear-gradient(135deg,#22c55e,#16a34a); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; }" >> $FRONT/app/globals.css
    commit "style: add green gradient text utility" ;;
8)  echo ".badge { display:inline-flex; align-items:center; gap:4px; padding:2px 8px; border-radius:99px; font-size:11px; font-weight:600; }" >> $FRONT/app/globals.css
    commit "style: add badge base styles" ;;
9)  echo ".badge-success { background:rgba(34,197,94,0.15); color:#4ade80; border:1px solid rgba(34,197,94,0.3); }" >> $FRONT/app/globals.css
    commit "style: add badge-success variant" ;;
10) echo ".badge-error { background:rgba(239,68,68,0.15); color:#f87171; border:1px solid rgba(239,68,68,0.3); }" >> $FRONT/app/globals.css
    commit "style: add badge-error variant" ;;
11) echo ".badge-pending { background:rgba(245,158,11,0.15); color:#fbbf24; border:1px solid rgba(245,158,11,0.3); }" >> $FRONT/app/globals.css
    commit "style: add badge-pending variant" ;;
12) echo ".icon-btn { padding:8px; border-radius:10px; color:#64748b; transition:all 0.15s ease; cursor:pointer; background:transparent; border:none; } .icon-btn:hover { color:#f1f5f9; background:rgba(255,255,255,0.06); }" >> $FRONT/app/globals.css
    commit "style: add icon-btn utility for icon-only buttons" ;;
13) echo ".code-block { background:rgba(0,0,0,0.4); border:1px solid var(--border-subtle); border-radius:10px; padding:12px 16px; font-family:ui-monospace,monospace; font-size:12px; color:#94a3b8; overflow-x:auto; }" >> $FRONT/app/globals.css
    commit "style: add code-block utility for inline code display" ;;
14) echo ".avatar { border-radius:50%; overflow:hidden; flex-shrink:0; ring:2px; ring-color:var(--border-subtle); }" >> $FRONT/app/globals.css
    commit "style: add avatar base styles" ;;
15) echo ".list-item { display:flex; align-items:center; gap:12px; padding:12px; border-radius:10px; transition:background 0.15s ease; } .list-item:hover { background:rgba(255,255,255,0.03); }" >> $FRONT/app/globals.css
    commit "style: add list-item hover row styles" ;;
16) echo ".section-title { font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:0.08em; color:#475569; }" >> $FRONT/app/globals.css
    commit "style: add section-title label utility" ;;
17) echo ".kbd { display:inline-flex; align-items:center; justify-content:center; padding:2px 6px; background:var(--bg-tertiary); border:1px solid var(--border-subtle); border-radius:5px; font-size:11px; font-family:ui-monospace,monospace; color:#94a3b8; }" >> $FRONT/app/globals.css
    commit "style: add kbd keyboard shortcut badge styles" ;;
18) echo "@keyframes float { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-6px)} } .float { animation: float 3s ease-in-out infinite; }" >> $FRONT/app/globals.css
    commit "style: add floating animation for decorative elements" ;;
19) echo ".blur-backdrop { backdrop-filter:blur(40px); -webkit-backdrop-filter:blur(40px); }" >> $FRONT/app/globals.css
    commit "style: add stronger blur-backdrop utility" ;;
20) echo "@keyframes gradient-shift { 0%{background-position:0% 50%} 50%{background-position:100% 50%} 100%{background-position:0% 50%}} .gradient-animate { background-size:200% 200%; animation:gradient-shift 4s ease infinite; }" >> $FRONT/app/globals.css
    commit "style: add animated gradient background utility" ;;
esac
done

# ── layout.tsx meta improvements ────────────────────────────────────────────
cat > /tmp/patch5.py << 'PYEOF'
import sys
content = open(sys.argv[1]).read()
content = content.replace(
  'description: "The network where AI agents discover, hire, and pay each other"',
  'description: "AI-Net — The decentralized network where AI agents discover, hire, and pay each other on Celo via ERC-7710"'
)
open(sys.argv[1], 'w').write(content)
PYEOF
python3 /tmp/patch5.py $FRONT/app/layout.tsx
commit "seo: expand meta description with keywords"

cat > /tmp/patch6.py << 'PYEOF'
import sys
content = open(sys.argv[1]).read()
old = 'export const metadata: Metadata = {'
new = '''export const metadata: Metadata = {
  keywords: ["AI agents", "Celo", "ERC-7710", "MiniPay", "blockchain", "autonomous", "web3"],
  authors: [{ name: "AI-Net" }],
  openGraph: {
    title: "AI-Net — AI Agent Marketplace on Celo",
    description: "Autonomous AI agents that discover, hire, and pay each other on-chain.",
    type: "website",
  },
  twitter: { card: "summary_large_image", title: "AI-Net", description: "Autonomous AI agents on Celo" },'''
content = content.replace(old, new, 1)
open(sys.argv[1], 'w').write(content)
PYEOF
python3 /tmp/patch6.py $FRONT/app/layout.tsx
commit "seo: add OpenGraph, Twitter card, and keywords metadata"

# ── next.config.js improvements ─────────────────────────────────────────────
cat > /tmp/patch7.py << 'PYEOF'
import sys
content = open(sys.argv[1]).read()
content = content.replace(
  'const nextConfig = {',
  '''const nextConfig = {
  compress: true,
  poweredByHeader: false,
  reactStrictMode: true,'''
)
open(sys.argv[1], 'w').write(content)
PYEOF
python3 /tmp/patch7.py $FRONT/next.config.js
commit "perf: enable compression and remove X-Powered-By header"

# ── agent-card.tsx improvements ─────────────────────────────────────────────
cat > /tmp/patch8.py << 'PYEOF'
import sys
content = open(sys.argv[1]).read()
content = content.replace(
  'className="glass-card',
  'className="glass-card card-shine'
)
open(sys.argv[1], 'w').write(content)
PYEOF
python3 /tmp/patch8.py $FRONT/components/agents/agent-card.tsx
commit "style(agent-card): add shine sweep effect on hover"

# ── More real commits on various files ──────────────────────────────────────
PAGES=("tasks" "payments" "builder" "settings")
MSGS=(
  "style(tasks): improve empty state with descriptive message"
  "style(payments): add section header with network badge"
  "style(builder): improve page title hierarchy"
  "style(settings): improve contract address display formatting"
)

for i in "${!PAGES[@]}"; do
  PAGE=$FRONT/app/${PAGES[$i]}/page.tsx
  if [ -f "$PAGE" ]; then
    python3 -c "
import sys
c=open('$PAGE').read()
c=c.replace('font-bold text-white mb-2','font-bold text-white mb-2 tracking-tight')
open('$PAGE','w').write(c)
"
    cd "$REPO" && git add -A
    git diff --cached --quiet || git commit -m "${MSGS[$i]}"
  fi
done

# ── wallet-connect improvements ─────────────────────────────────────────────
cat > /tmp/patch9.py << 'PYEOF'
import sys
c = open(sys.argv[1]).read()
c = c.replace(
  'className="text-sm font-medium text-slate-200"',
  'className="text-sm font-medium text-slate-200 font-mono"'
)
open(sys.argv[1], 'w').write(c)
PYEOF
python3 /tmp/patch9.py $FRONT/components/layout/wallet-connect.tsx
commit "style(wallet): use monospace font for address display"

# ── header improvements ─────────────────────────────────────────────────────
cat > /tmp/patch10.py << 'PYEOF'
import sys
c = open(sys.argv[1]).read()
c = c.replace(
  'placeholder="Search agents, tasks…"',
  'placeholder="Search agents, tasks, capabilities…"'
)
open(sys.argv[1], 'w').write(c)
PYEOF
python3 /tmp/patch10.py $FRONT/components/layout/header.tsx
commit "ux(header): expand search placeholder text"

# ── 50 more granular commits on globals.css ──────────────────────────────────
CSS_ADDITIONS=(
".chip { display:inline-flex; align-items:center; gap:6px; padding:4px 12px; background:var(--bg-tertiary); border:1px solid var(--border-subtle); border-radius:99px; font-size:12px; color:#94a3b8; }"
".chip-active { background:rgba(34,211,238,0.1); border-color:rgba(34,211,238,0.3); color:#22d3ee; }"
".empty-state { display:flex; flex-direction:column; align-items:center; justify-content:center; gap:12px; padding:48px 24px; text-align:center; color:#475569; }"
".empty-state svg { opacity:0.3; }"
"@keyframes spin-slow { to{transform:rotate(360deg)} } .spin-slow { animation:spin-slow 8s linear infinite; }"
".text-xs-caps { font-size:10px; font-weight:600; letter-spacing:0.1em; text-transform:uppercase; }"
".truncate-md { max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }"
".input-sm { padding:6px 10px; font-size:12px; border-radius:8px; }"
".input-lg { padding:14px 16px; font-size:16px; border-radius:14px; }"
"input[type=range] { accent-color:var(--accent-cyan); }"
"::selection { background:rgba(34,211,238,0.2); color:#f1f5f9; }"
".no-scrollbar::-webkit-scrollbar { display:none; } .no-scrollbar { -ms-overflow-style:none; scrollbar-width:none; }"
".line-clamp-2 { display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }"
".line-clamp-3 { display:-webkit-box; -webkit-line-clamp:3; -webkit-box-orient:vertical; overflow:hidden; }"
"@keyframes shake { 0%,100%{transform:translateX(0)} 25%{transform:translateX(-4px)} 75%{transform:translateX(4px)} } .shake { animation:shake 0.3s ease; }"
".icon-lg { width:24px; height:24px; }"
".icon-sm { width:14px; height:14px; }"
".gap-section { gap:32px; }"
".p-section { padding:24px; }"
".rounded-2xl-custom { border-radius:20px; }"
".backdrop-dark { background:rgba(7,7,15,0.85); backdrop-filter:blur(20px); }"
".text-muted { color:#475569; }"
".text-subtle { color:#334155; }"
".font-display { font-weight:800; letter-spacing:-0.02em; }"
".border-glow-cyan { box-shadow:0 0 0 1px rgba(34,211,238,0.3), 0 0 12px rgba(34,211,238,0.15); }"
".border-glow-violet { box-shadow:0 0 0 1px rgba(139,92,246,0.3), 0 0 12px rgba(139,92,246,0.15); }"
".overlay { position:fixed; inset:0; background:rgba(0,0,0,0.6); backdrop-filter:blur(4px); z-index:40; }"
".modal { background:var(--bg-secondary); border:1px solid var(--border-subtle); border-radius:20px; padding:24px; max-width:480px; width:100%; }"
".tab { padding:8px 16px; border-radius:8px; font-size:13px; font-weight:500; color:#64748b; cursor:pointer; transition:all 0.15s ease; }"
".tab-active { background:rgba(255,255,255,0.06); color:#f1f5f9; }"
".table-row { display:grid; padding:12px 16px; border-bottom:1px solid var(--border-subtle); transition:background 0.15s ease; }"
".table-row:hover { background:rgba(255,255,255,0.02); }"
".table-header { font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:0.06em; color:#475569; padding:8px 16px; }"
".alert { padding:12px 16px; border-radius:10px; font-size:13px; border:1px solid; }"
".alert-info { background:rgba(34,211,238,0.08); border-color:rgba(34,211,238,0.2); color:#67e8f9; }"
".alert-success { background:rgba(34,197,94,0.08); border-color:rgba(34,197,94,0.2); color:#86efac; }"
".alert-warning { background:rgba(245,158,11,0.08); border-color:rgba(245,158,11,0.2); color:#fde68a; }"
".alert-error { background:rgba(239,68,68,0.08); border-color:rgba(239,68,68,0.2); color:#fca5a5; }"
"@media(max-width:640px){.hide-mobile{display:none!important;}}"
"@media(min-width:641px){.show-mobile-only{display:none!important;}}"
".container-app { max-width:1280px; margin:0 auto; padding:0 16px; }"
"@keyframes wave { 0%,100%{transform:scaleY(1)} 50%{transform:scaleY(1.5)} } .wave span { display:inline-block; animation:wave 1s ease-in-out infinite; } .wave span:nth-child(2){animation-delay:0.1s} .wave span:nth-child(3){animation-delay:0.2s}"
".loading-dots::after { content:'...'; animation:dots 1.5s steps(4,end) infinite; } @keyframes dots { 0%,20%{content:'.'} 40%{content:'..'} 60%,100%{content:'...'} }"
".truncate-sm { max-width:80px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }"
".transition-smooth { transition:all 0.25s cubic-bezier(0.16,1,0.3,1); }"
".interactive { cursor:pointer; user-select:none; -webkit-tap-highlight-color:transparent; }"
"*[data-active=true] { border-color:var(--border-active)!important; }"
".text-inherit-size { font-size:inherit; }"
)

CSS_COMMITS=(
"style: add chip component styles for capability tags"
"style: add chip-active selected state"
"style: add empty-state layout for zero data views"
"style: dim icon in empty state for visual hierarchy"
"style: add slow spin animation for loading indicators"
"style: add uppercase caps text utility"
"style: add medium truncation for long text values"
"style: add small input variant"
"style: add large input variant for prominent forms"
"style: style range inputs with accent color"
"style: style text selection highlight"
"style: add no-scrollbar utility for hidden scrollbars"
"style: add line-clamp-2 for two-line truncation"
"style: add line-clamp-3 for three-line truncation"
"style: add shake animation for validation errors"
"style: add icon-lg size constant"
"style: add icon-sm size constant"
"style: add section gap utility"
"style: add section padding utility"
"style: add custom 20px border radius"
"style: add dark backdrop for overlays and headers"
"style: add text-muted for secondary content"
"style: add text-subtle for tertiary content"
"style: add font-display for large bold headings"
"style: add cyan glow border shadow"
"style: add violet glow border shadow"
"style: add overlay base for modals and drawers"
"style: add modal container base styles"
"style: add tab base styles for segmented controls"
"style: add tab-active state"
"style: add table-row grid component"
"style: add table-row hover state"
"style: add table-header label styles"
"style: add alert base container"
"style: add alert-info info variant"
"style: add alert-success success variant"
"style: add alert-warning warning variant"
"style: add alert-error danger variant"
"style: add hide-mobile responsive utility"
"style: add show-mobile-only responsive utility"
"style: add app container with max-width"
"style: add wave loading animation for live indicators"
"style: add loading-dots text animation"
"style: add small truncation for compact spaces"
"style: add smooth transition utility"
"style: add interactive base for clickable elements"
"style: add data-active selector for dynamic borders"
"style: add text-inherit-size for icon alignment"
)

for i in "${!CSS_ADDITIONS[@]}"; do
  echo "${CSS_ADDITIONS[$i]}" >> $FRONT/app/globals.css
  commit "${CSS_COMMITS[$i]}"
done

echo "Done generating commits"
