// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    // --------------------
    // Token Metadata
    // --------------------
    string public name = "MyToken";      // Token name
    string public symbol = "MTK";        // Token symbol
    uint8 public decimals = 18;          // Decimal places
    uint256 public totalSupply;          // Total supply of tokens

    // --------------------
    // Mappings
    // --------------------

    // Track balances of each address
    mapping(address => uint256) public balanceOf;

    // Track allowances: owner => (spender => amount)
    mapping(address => mapping(address => uint256)) public allowance;

    // --------------------
    // Events
    // --------------------

    // Emitted when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Emitted when an approval is made
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // --------------------
    // Constructor
    // --------------------

    // _initialSupply should include decimals
    // Example for 1,000,000 tokens: 1_000_000 * 10**18
    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply;
        // Assign all tokens to the contract deployer
        balanceOf[msg.sender] = _initialSupply;

        // Emit a Transfer event from "zero address" to show minting
        emit Transfer(address(0), msg.sender, _initialSupply);
    }

    // --------------------
    // Core ERC-20 Functions
    // --------------------

    // Transfer tokens from caller to another address
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // Cannot send to zero address
        require(_to != address(0), "Cannot transfer to zero address");
        // Must have enough balance
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        // Update balances
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Emit transfer event
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Approve another address to spend tokens on your behalf
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Cannot approve zero address");

        // Set allowance
        allowance[msg.sender][_spender] = _value;

        // Emit approval event
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Transfer tokens using an allowance (owner -> to, called by spender)
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Cannot transfer to zero address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");

        // Update balances
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        // Reduce allowance
        allowance[_from][msg.sender] -= _value;

        // Emit transfer event
        emit Transfer(_from, _to, _value);
        return true;
    }

    // --------------------
    // Helper / View Functions
    // --------------------

    // Optional explicit total supply getter
    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    // Return token info in one call
    function getTokenInfo()
        public
        view
        returns (string memory, string memory, uint8, uint256)
    {
        return (name, symbol, decimals, totalSupply);
    }
}
