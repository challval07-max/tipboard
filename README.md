# TipBoard — Binance Agent ID Hackathon starter

**Status: direction APPROVED by user 2026-11-19 ("Gas arah TipBoard ini"). NOT deployed, NOT submitted yet.**
Direction: tip ke Agent ID + papan pesan on-chain.

Progress 2026-11-19:
- ✅ Contract compiles clean with solc 0.8.20 (+optimizer) — artifacts in `build/`. NOTE: the Agent ID address had to be written in EIP-55 checksum form (`0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F`); the all-lowercase form fails compilation.
- ✅ Frontend dApp ready in `web/index.html` (connect wallet, Agent ID check, tip, post, withdraw, live board from events) — paste the deployed contract address into `TIPBOARD_ADDRESS` after deploying.
- ✅ Step-by-step deploy guide in `DEPLOY.md` (Remix → BscScan verify → GitHub Pages → submission text).
- ✅ **DEPLOYED 2026-11-19** on BSC mainnet: contract **0x6eA30CF15C1DadFd61A691eE2f03F824eD78e680**, deploy tx 0xa0397995a0624aecd26e4a1f8c8da344c0020543531322be2efd408496b2e2d1, gas used 555,277. Deployed from the assistant's agent wallet 0xEe854e18E8A7518a1D16749BdC12958DEC3Edfd1 (funded with 0.003 BNB by the user via their Agentic Wallet, tx 0x0f5097ed22e4adfb733fca61466738cc4fb02ac99f5d8359d7bdcc56fc549a69) because baw contract-call cannot create contracts. Contract is ownerless — deployer has no control over funds. Sanity checks pass (totalTips=0, AGENT_ID=official contract). Address wired into web/index.html.
- ✅ Source verified on Sourcify with **exact_match** (2026-11-19) and forwarded by Sourcify to Etherscan/BscScan verification backend. (Visual check of the BscScan Contract tab was blocked by Cloudflare from the assistant's browser; user can confirm via the contract link.)
- ✅ First interaction done: `jeyb.ai` (0xCB31338DB5dC64AD2fB5f5Ed4eb56B260a2C35Ca) posted the first board message via baw contract-call, tx 0x8bcdfad916589c56c097d43fd9e8a1cb306c8a039d9286aa09c4a6d1dad10198, block 134516805.
- ⏳ Remaining: host website (GitHub Pages — needs user's GitHub) → submit before 9 Dec 15:00 WIB → gather 30 Agent ID interactions (count so far: 1).

## Why now — the timing that matters

- Submission: **18 Nov – 9 Dec 2026, 08:00 UTC (15:00 WIB)**. Internal review 9–17 Dec, public review 17–20 Dec.
- The Innovation Award (29,000 USDC, top 10) requires a **live product + at least 30 Agent ID addresses interacting** with the contract during the submission period. The Pioneer Award (29,000 USDC, top 10) ranks on Agent ID interactions + volume/tx count.
- 30 strangers do not appear in a day. Every day the launch slips is one fewer day to gather them. Launching a minimal live version this week is the whole game; polishing can come after.

## What is in this folder

- `TipBoard.sol` — the whole contract, no external imports, compiles as-is in Remix.
  - Only Agent ID holders can tip or post: checked via `balanceOf()` on the official Agent ID contract `0x60b9262456de011f7d15a54cdd8c48baaa8b022f` (SPACE ID Agent ID, ERC-721, non-transferable) — exactly the check the Binance announcement publishes.
  - `tip(address, message)` payable — tip + public message in one tx.
  - `postMessage(string)` — free (gas only) interaction, so people can join without spending.
  - `withdraw()` — only the recipient can withdraw their own tips.
  - No owner/admin, no server, no QR login, no auto-signing — stays clear of the hackathon safety red lines.
  - v1 tips by wallet address. Resolving a `.ai` name to an address is a frontend stretch goal, not in the contract.

## Steps only the user can do (assistant cannot do these)

1. **Claim an Agent ID** in the Binance app: Wallet > homepage banner > Agent ID. One per user, non-transferable, first-come first-served for the name.
2. **Deploy** `TipBoard.sol` from the user's own wallet (Remix + BNB Chain, a little BNB for gas). Assistant can walk through it / verify afterwards, but the keys never go through the assistant.
3. **Verify source on BscScan** (required: verified + open-source) and make the repo public.
4. **Submit** project name, website, contract address(es) and Agent ID usage description during the submission period. One project per team.
5. **Get 30 Agent ID holders to interact** — post the live link on X, in Binance/ BNB communities, etc. That is the hard part; the contract is the easy part.

## X campaign (separate 2,000 USDC / 20 winners)

Post original content about the project with **#BinanceWalletHackathon #AgenticWallet**, then submit the link. Draft (edit before posting):

> Built TipBoard for the @BinanceWallet Agent ID Hackathon — tip any Agent ID holder on BNB Chain and leave them an on-chain message. Only .ai holders can tip or post. Live now, try it 👇 #BinanceWalletHackathon #AgenticWallet

## Sources (checked 2026-11-19)

- Binance announcement: https://www.binance.com/en/support/announcement/detail/95f5dbe0ea674a48a739b59e046648bf
- Submission 18 Nov–9 Dec 2026 08:00 UTC; Agent ID contract `0x60b9262456de011f7d15a54cdd8c48baaa8b022f`; holder check = `balanceOf(address) > 0`; claim only in the Binance app.
- Awards: Pioneer 29,000 USDC + Innovation 29,000 USDC (each top 10) + X campaign 2,000 USDC / 20 winners. Innovation needs live product + ≥30 Agent ID addresses interacting in the period.

## Open risks / honest notes

- Winning is not guaranteed and 30 Agent ID interactions is a real distribution challenge — the contract alone earns nothing.
- Gas + a small amount of BNB is needed to deploy; test on BNB testnet first if unsure.
- The contract has NOT been audited and has NOT been compiled here (no solc on this machine) — compile in Remix and review before deploying real funds.
