/**
 * switchToCelo — ensures window.ethereum is on Celo Mainnet (42220).
 *
 * Tries wallet_switchEthereumChain first. If the chain is not added to the
 * wallet yet, falls back to wallet_addEthereumChain to register it, then
 * switches. Safe to call before every transaction.
 */
export async function switchToCelo(): Promise<void> {
  if (typeof window === "undefined") return;
  const eth = (window as any).ethereum;
  if (!eth) return;

  const CELO_CHAIN_ID = "0xa4ec"; // 42220 in hex

  try {
    await eth.request({
      method: "wallet_switchEthereumChain",
      params: [{ chainId: CELO_CHAIN_ID }],
    });
  } catch (switchError: any) {
    // 4902 = chain not added to wallet yet
    if (switchError?.code === 4902 || switchError?.code === -32603) {
      await eth.request({
        method: "wallet_addEthereumChain",
        params: [
          {
            chainId: CELO_CHAIN_ID,
            chainName: "Celo Mainnet",
            nativeCurrency: { name: "Celo", symbol: "CELO", decimals: 18 },
            rpcUrls: ["https://forno.celo.org"],
            blockExplorerUrls: ["https://celoscan.io"],
          },
        ],
      });
      // Switch again after adding
      await eth.request({
        method: "wallet_switchEthereumChain",
        params: [{ chainId: CELO_CHAIN_ID }],
      });
    } else {
      throw switchError;
    }
  }
}
