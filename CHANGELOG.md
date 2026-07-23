# Changelog

## 2026-07-23 — Professional Enhancement

### Project Setup
- **chore**: Added root `package.json` with workspace scripts for dev, build, lint, and test
- **chore**: Added `.prettierrc` and `.editorconfig` for consistent formatting across codebase
- **chore**: Updated `.gitignore` with comprehensive coverage patterns
- **chore**: Added `backend/.env.example` with documented environment variables

### Backend Security & Quality
- **security(backend)**: Added CORS origin restrictions — only allows `ai-net.vercel.app` and `localhost:3000`
- **security(backend)**: Added security headers (`X-Content-Type-Options`, `X-Frame-Options`, `X-XSS-Protection`, `Referrer-Policy`)
- **feat(backend)**: Added input sanitization for all user inputs with length limits
- **feat(backend)**: Added structured logging with request IDs and timing
- **feat(backend)**: Added API version header (`X-API-Version: 1.1.0`)
- **feat(backend)**: Added 404 handler for unknown routes
- **feat(backend)**: Added `ALLOWED_ORIGINS` config option
- **feat(backend)**: Improved health check with version, uptime, and timestamp
- **feat(backend)**: Added separate rate limiters for task submission (5/min) vs general API (10/min)
- **refactor(backend)**: Improved error handler with specific status codes for timeouts and reverts
- **chore(backend)**: Enhanced TypeScript config with `noUnusedLocals`, `noUnusedParameters`, `sourceMap`
- **chore(backend)**: Added `typecheck` script

### Frontend Professional
- **feat(frontend)**: Added `ErrorBoundary` component with recovery UI
- **feat(frontend)**: Added `Skeleton`, `CardSkeleton`, `StatCardSkeleton`, and `TableSkeleton` components
- **feat(frontend)**: Added `robots.txt` for SEO crawl directives
- **feat(frontend)**: Added SEO metadata to dashboard and agents pages
- **feat(frontend)**: Added ARIA attributes to sidebar, header, and app-shell for accessibility
- **refactor(frontend)**: Extracted shared ABIs to `lib/abis.ts` — eliminates duplicate ABI definitions
- **refactor(frontend)**: Added shared TypeScript types in `lib/types.ts` (TaskResult, PipelineStep, labels)
- **refactor(frontend)**: Added MiniPay constants (CUSD address, task price, duration) to shared constants
- **refactor(frontend)**: Updated mini page to use shared types and constants
- **refactor(frontend)**: Updated task-creator to use shared types and constants
- **fix(frontend)**: Fixed invalid CSS in `.ring-accent` and `.avatar` classes
- **fix(frontend)**: Renamed dashboard `celoAlfajores` to `celoMainnet` (was misleading)
- **refactor(frontend)**: Removed unused hooks (`use-agents`, `use-network`, `use-scroll`)
- **refactor(frontend)**: Removed unused `@metamask/smart-accounts-kit` dependency

### Security (Vercel)
- **security(vercel)**: Added security headers (`X-Content-Type-Options`, `X-Frame-Options`, `Permissions-Policy`)

## 2026-07-04 — Chain Switch, Error Handling & Polish

- **feat**: `lib/chain.ts` — `switchToCelo()` utility; auto-adds Celo to wallet if needed
- **fix**: Chain mismatch error — `switchToCelo()` called before every transaction
  in `use-wallet`, `/mini`, `task-creator`, and `register` page
- **fix**: `chainChanged` event listener in `use-wallet` — resets walletClient on
  network switch so next tx always triggers chain check
- **feat**: `lib/errors.ts` — `parseError()` maps raw RPC/viem errors to plain English
  - user rejected, insufficient funds, wrong network, timeout, contract reverts
  - truncates unknown errors at 120 chars
- **fix**: `WalletConnect` — shows `connectError` inline with AlertCircle icon
  (replaces `alert()`)
- **fix**: Payments page — `celoscan.io` mainnet links (was alfajores testnet)
- **fix**: Payments page — amounts show `0.0008 CELO` and `0.001 cUSD` (not ETH)
- **fix**: Dashboard — "Your Spend" stat shows `$X.XXX cUSD` (not CELO)
- **fix**: `use-chain-agents` — silent error handling on registry fetch failure

## 2026-07-03 — MiniPay Mini App

- **feat**: `/mini` route — consumer-grade MiniPay entry point
  - Pay-per-question UI: $0.001 cUSD per question, no subscription
  - Example prompts for emerging market users (East Africa, Ghana, DeFi)
  - Step-by-step progress indicator through agent pipeline
  - Collapsible result sections; report expanded by default
  - "Ask another question" reset flow
- **feat**: `manifest.json` — MiniPay web app manifest
  - `start_url: /mini`, `display: standalone`
  - Correct icons (192×192, 512×512), theme/background color
- **feat**: Public assets — `logo.png` (500×500) and `og-image.png` (1200×630)
- **feat**: Celo fee abstraction — gas paid in cUSD on `createTask` tx
  - Users don't need a CELO balance for gas inside MiniPay
- **feat**: Auto-redirect — MiniPay users sent to `/mini` on any page load
- **feat**: Flash suppression — `detected` flag prevents desktop shell rendering
  before MiniPay detection completes
- **fix**: `useMiniPay` hook — use `eth_requestAccounts` per official MiniPay docs
  (was incorrectly using `walletClient.getAddresses()`)
- **fix**: SSR guard — `typeof window === 'undefined'` check in hook and connect()
- **fix**: `MiniPayBanner` — hidden on `/mini`, removed duplicate connect button,
  added error guard on `readContract`
- **fix**: `handleSubmit` stale closure — `isMiniPay` added to `useCallback` deps
- **fix**: cUSD payment path — was trying to use ERC-20 transfer to trigger
  `createTask`; contract requires `msg.value > 0` (native CELO)
- **docs**: README rewritten with consumer-facing tagline and MiniPay section
- **chore**: `NEXT_PUBLIC_APP_URL` added to `.env.example`

## 2026-06-21
- MiniPay banner component for mobile-first UX
- Published `@ai-net/sdk` package with contract ABIs and MiniPay utilities
- 949+ tasks completed on Celo mainnet (2,847+ transactions)
- Optimized bulk transaction script with retry logic and minimum gas pricing

## 2026-06-12
- Full MiniPay wallet integration: detection, connect, transaction signing
- Deployed all 3 contracts to Celo mainnet (chain 42220)
- Registered 5 agents on-chain
- Updated all chain configs from Base → Celo

## 2026-06-11
- Renamed project GuildNet → AI-Net
- Migrated from Base → Celo blockchain
- Initial deployment to Celo Alfajores testnet
- Added `@celo/rainbowkit-celo` dependency

## 2026-06-09
- Initial commit: AgentRegistry, GuildPermissions, TaskCoordinator contracts
- 17/17 tests passing
- Frontend with Next.js, Privy wallet, task creator UI
- Backend coordinator with Venice AI integration

## 2026-06-22
- Redesigned homepage with 6-feature grid and stats bar
- Added 8 reusable UI components (Spinner, Badge, Alert, Address, etc.)
- Added 6 utility hooks (useCopy, useDebounce, useLocalStorage, etc.)
- 50+ new CSS utility classes for consistent design system
- Improved dashboard stat cards with colored borders
- SEO: Added OpenGraph, Twitter cards, meta keywords
