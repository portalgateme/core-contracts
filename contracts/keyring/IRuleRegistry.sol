// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.14;

import "./Bytes32Set.sol";

interface IRuleRegistry {
    enum Operator {
        Base,
        Union,
        Intersection,
        Complement
    }

    struct Rule {
        string description;
        string uri;
        Operator operator;
        Bytes32Set.Set operandSet;
    }

    error Unacceptable(address sender, string module, string method, string reason);

    event RuleRegistryDeployed(address deployer, address trustedForwarder);

    event RuleRegistryInitialized(
        address admin,
        string universeDescription,
        string universeUri,
        string emptyDescription,
        string emptyUri,
        bytes32 universeRule,
        bytes32 emptyRule
    );

    event CreateRule(
        address indexed user,
        bytes32 indexed ruleId,
        string description,
        string uri,
        Operator operator,
        bytes32[] operands
    );

    event UpdateRuleUri(address indexed admin, bytes32 indexed ruleId, string uri);

    function init(
        string calldata universeDescription,
        string calldata universeUri,
        string calldata emptyDescription,
        string calldata emptyUri
    ) external;

    function createRule(
        string calldata description,
        string calldata uri,
        Operator operator,
        bytes32[] calldata operands
    ) external returns (bytes32 ruleId);

    function updateRuleUri(bytes32 ruleId, string memory uri) external;

    function genesis() external view returns (bytes32 universeRule, bytes32 emptyRule);

    function ruleCount() external view returns (uint256 count);

    function ruleAtIndex(uint256 index) external view returns (bytes32 ruleId);

    function isRule(bytes32 ruleId) external view returns (bool isIndeed);

    function rule(bytes32 ruleId)
        external
        view
        returns (
            string memory description,
            string memory uri,
            Operator operator,
            uint256 operandCount
        );

    function ruleDescription(bytes32 ruleId) external view returns (string memory description);

    function ruleUri(bytes32 ruleId) external view returns (string memory uri);

    function ruleOperator(bytes32 ruleId) external view returns (Operator operator);

    function ruleOperandCount(bytes32 ruleId) external view returns (uint256 count);

    function ruleOperandAtIndex(bytes32 ruleId, uint256 index)
        external
        view
        returns (bytes32 operandId);

    function generateRuleId(
        string calldata description,
        Operator operator,
        bytes32[] calldata operands
    ) external pure returns (bytes32 ruleId);

    function roleRuleAdmin() external pure returns (bytes32 role);
}