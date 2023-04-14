// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import { IERC20 } from "./interfaces/IERC20.sol";
import { SafeERC20 } from "./libs/SafeERC20.sol";

/// @title Vault which holds user funds
contract TornadoVault {
  using SafeERC20 for IERC20;

  address public GovernanceAddress;
  address internal constant TornTokenAddress = 0xbe690bE6781188c8305D596c22D4d6b8DdED40D7;

  function updateGovernanceAddress(address _governance) external{
      GovernanceAddress = _governance;
  }
  
  /// @notice withdraws TORN from the contract
  /// @param amount amount to withdraw
  function withdrawTorn(address recipient, uint256 amount) external {
    require(msg.sender == GovernanceAddress, "only gov");
    IERC20(TornTokenAddress).safeTransfer(recipient, amount);
  }
}