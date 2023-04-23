// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./GovernanceAggregator.sol";
import "./RelayerAggregator.sol";
import "./libs/ENS.sol";

contract Aggregator is EnsResolve, GovernanceAggregator, RelayerAggregator {}
