
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.14;

import "./IKycETH.sol";
import "./KeyringGuardV1Immutable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Wrapper.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KycETH is KeyringGuardV1Immutable {
    string public name     = "KYC Ether";
    string public symbol   = "kycETH";
    uint8  public decimals = 18;

    event  Approval(address indexed owner, address indexed spender, uint amount);
    event  Transfer(address indexed from, address indexed to, uint amount);
    event  Deposit(address indexed to, uint amount);
    event  Withdrawal(address indexed from, uint amount);

    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;

    /**
     @notice Specify the token to wrap and the new name / symbol of the wrapped token - then good to go!
     @param keyringCredentials The address for the deployed KeyringCredentials contract.
     @param policyManager The address for the deployed PolicyManager contract.
     @param policyId The unique identifier of a Policy.
     */
    constructor(
        address keyringCredentials,
        address policyManager,
        bytes32 policyId
    )
        KeyringGuardV1Immutable(keyringCredentials, policyManager, policyId)
    {}

    function depositFor()
        public
        keyringCompliance(msg.sender)
        payable
    {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdrawTo(uint amount)
        public
        keyringCompliance(msg.sender)
    {
        require(balanceOf[msg.sender] >= amount);
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function totalSupply() public view returns (uint) {
        return address(this).balance;
    }

    function approve(address spender, uint amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint amount)
        public
        keyringCompliance(to)
        keyringCompliance(msg.sender)
        returns (bool)
    {
        return transferFrom(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint amount)
        public
        keyringCompliance(from)
        keyringCompliance(to)
        returns (bool)
    {
        require(balanceOf[from] >= amount);

        if (from != msg.sender && allowance[from][msg.sender] > 0) {
            require(allowance[from][msg.sender] >= amount);
            allowance[from][msg.sender] -= amount;
        }

        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);

        return true;
    }
}