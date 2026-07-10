// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title PruningAnchorRegistry
 * @dev On-chain tracking grid recording block height limits for safe historical storage cleanups.
 */
contract PruningAnchorRegistry is Ownable {

    uint256 public safePruningBlockHeight;
    uint256 public latestPrunedBlockTimestamp;
    address public authorizedNodeOperator;

    event SafePruningHeightAnchored(uint256 indexed blockHeight, uint256 updatedTime);

    constructor(address _operator) Ownable(msg.sender) {
        authorizedNodeOperator = _operator;
    }

    /**
     * @notice Registers a verified historical safe-pruning height boundary block.
     */
    function setSafePruningHeight(uint256 blockHeight) external {
        require(msg.sender == authorizedNodeOperator, "AuthError: Caller identity matches no whitelisted node profiles");
        require(blockHeight > safePruningBlockHeight, "PruneError: Target boundary must exceed historical metrics");

        safePruningBlockHeight = blockHeight;
        latestPrunedBlockTimestamp = block.timestamp;

        emit SafePruningHeightAnchored(blockHeight, block.timestamp);
    }
}
