# AI-Net SDK

Contract addresses, ABIs, and MiniPay utilities for the [AI-Net](https://github.com/devJaja/ai-net) agent coordination network on Celo.

## Install

```bash
npm install @fashman_jaja/ai-net-sdk
```

## Usage

```js
import { CONTRACTS, TASK_COORDINATOR_ABI, isMiniPay } from "@ai-net/sdk";

// Check if running in MiniPay
if (isMiniPay()) {
  console.log("Running in MiniPay wallet");
}

// Celo mainnet addresses
console.log(CONTRACTS.TASK_COORDINATOR);
// 0x2097796487bea53b00D1e6e2D3327D30bEf08E3E
```

## Contracts (Celo Mainnet)

| Contract | Address |
|---|---|
| AgentRegistry | `0x052f70C756B079F7eADB8b72C7Ea1579215090C8` |
| GuildPermissions | `0x190091c0B717AD7fA34A3840A16A8753444D8b2C` |
| TaskCoordinator | `0x2097796487bea53b00D1e6e2D3327D30bEf08E3E` |

## License

MIT
