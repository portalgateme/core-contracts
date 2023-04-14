// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./interfaces/IERC20.sol";
import "./libs/ERC20.sol";
import "./libs/ERC20Burnable.sol";
import "./libs/SafeERC20.sol";
import "./libs/Ownable.sol";
import "./libs/Pausable.sol";
import "./libs/Math.sol";
import "./libs/ERC20Permit.sol";
import "./libs/ENS.sol";

contract TORN is ERC20("PortalGate", "PGT"), ERC20Burnable, ERC20Permit, Pausable, EnsResolve {
  using SafeERC20 for IERC20;
  mapping(address => bool) public allowedTransferee;

  event Allowed(address target);
  event Disallowed(address target);

  constructor() public {
    _pause();
    allowedTransferee[msg.sender] = true;
    _mint(msg.sender, 1000000 ether);
  }

  function changeTransferability(bool decision) public {
    if (decision) {
      _unpause();
    } else {
      _pause();
    }
  }

  function addToAllowedList(address[] memory target) public {
    for (uint256 i = 0; i < target.length; i++) {
      allowedTransferee[target[i]] = true;
      emit Allowed(target[i]);
    }
  }

  function removeFromAllowedList(address[] memory target) public {
    for (uint256 i = 0; i < target.length; i++) {
      allowedTransferee[target[i]] = false;
      emit Disallowed(target[i]);
    }
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal override {
    super._beforeTokenTransfer(from, to, amount);
    require(allowedTransferee[from] || allowedTransferee[to], "TORN: paused");
    require(to != address(this), "TORN: invalid recipient");
  }
}