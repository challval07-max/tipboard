// SPDX-License-Identifier: MIT
// TipBoard — tip + message board for Binance Agent ID holders
// Binance Agent ID Hackathon (submission 18 Nov – 9 Dec 2026, 08:00 UTC)
// DRAFT starter, prepared 2026-11-19. NOT deployed. Deploy only from the user's own wallet.
//
// Why this design:
// - "Actively uses Agent ID": BOTH sender and recipient must hold an Agent ID.
//   Checked on-chain via balanceOf() on the official SPACE ID Agent ID contract
//   (0x60b9262456de011f7d15a54cdd8c48baaa8b022f, ERC-721, non-transferable),
//   exactly as the Binance announcement instructs.
// - Every tip / message is one on-chain interaction by an Agent ID address —
//   that is what the Pioneer Award ranks on (interactions + volume/tx count)
//   and what the Innovation Award requires (live product + >= 30 Agent ID
//   addresses interacting during the submission period).
// - No owner, no admin keys, no server, no QR login, no auto-signing:
//   users confirm every transaction themselves in their own wallet, and only
//   the recipient can withdraw their own tips. This stays clear of the
//   hackathon safety red lines (no web QR login, no bypassing user
//   confirmation, no unauthorized asset transfers).
// - No external imports, so it compiles as-is in Remix (Solidity 0.8.20).
//   Name (.ai) -> address resolution is a frontend stretch goal, NOT in v1:
//   v1 tips by wallet address; the .ai name is carried in the message/event.

pragma solidity ^0.8.20;

interface IAgentID {
    function balanceOf(address owner) external view returns (uint256);
}

contract TipBoard {
    IAgentID public constant AGENT_ID =
        IAgentID(0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F);

    mapping(address => uint256) public credits;
    uint256 public totalTips;
    uint256 public totalTippedWei;

    event TipSent(
        address indexed from,
        address indexed to,
        uint256 amount,
        string message
    );
    event MessagePosted(address indexed from, string message);
    event Withdrawn(address indexed to, uint256 amount);

    modifier onlyAgentIDHolder(address account) {
        require(
            AGENT_ID.balanceOf(account) > 0,
            "TipBoard: account holds no Agent ID"
        );
        _;
    }

    /// @notice Tip an Agent ID holder and leave a public on-chain message.
    /// @param recipient Wallet address of the Agent ID holder receiving the tip.
    /// @param message Public message stored in the event log (keep it short).
    function tip(address recipient, string calldata message)
        external
        payable
        onlyAgentIDHolder(msg.sender)
        onlyAgentIDHolder(recipient)
    {
        require(msg.value > 0, "TipBoard: tip must be > 0");
        require(recipient != msg.sender, "TipBoard: cannot tip yourself");
        require(bytes(message).length <= 280, "TipBoard: message too long");

        credits[recipient] += msg.value;
        totalTips += 1;
        totalTippedWei += msg.value;

        emit TipSent(msg.sender, recipient, msg.value, message);
    }

    /// @notice Free interaction (gas only): post a message to the board.
    /// Counts as an Agent ID interaction without moving any funds.
    function postMessage(string calldata message)
        external
        onlyAgentIDHolder(msg.sender)
    {
        require(bytes(message).length > 0, "TipBoard: empty message");
        require(bytes(message).length <= 280, "TipBoard: message too long");
        emit MessagePosted(msg.sender, message);
    }

    /// @notice Withdraw tips sent to the caller. Only the recipient can call
    /// this for their own balance — nobody else can move these funds.
    function withdraw() external {
        uint256 amount = credits[msg.sender];
        require(amount > 0, "TipBoard: nothing to withdraw");
        credits[msg.sender] = 0;
        (bool ok, ) = payable(msg.sender).call{value: amount}("");
        require(ok, "TipBoard: transfer failed");
        emit Withdrawn(msg.sender, amount);
    }
}
