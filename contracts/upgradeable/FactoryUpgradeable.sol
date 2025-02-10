// // SPDX-License-Identifier: GPL-3.0-or-later
// pragma solidity ^0.8.20;

// import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
// import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
// import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';

// import '../V2Pair.sol';
// import '../interfaces/ISunswapV2Factory.sol';

// contract XANATokenDexFactoryUpgradeable is Initializable, UUPSUpgradeable, OwnableUpgradeable, ISunswapV2Factory {
//     address public override feeTo;
//     address public override feeToSetter;
//     address internal _router;

//     mapping(address => mapping(address => address)) public override getPair;
//     address[] public override allPairs;

//     event PairCreated(address indexed token0, address indexed token1, address pair, uint);

//     /// @custom:oz-upgrades-unsafe-allow constructor
//     constructor() {
//         _disableInitializers(); // Disable initializers to prevent direct deployment
//     }

//     function initialize(address _feeToSetter, address _initialOwner) public initializer {
//         __Ownable_init(_initialOwner); // Initialize OwnableUpgradeable
//         feeToSetter = _feeToSetter;
//     }

//     function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

//     function allPairsLength() external view override returns (uint) {
//         return allPairs.length;
//     }

//     function createPair(address tokenA, address tokenB) external override returns (address pair) {
//         require(tokenA != tokenB, 'SunswapV2: IDENTICAL_ADDRESSES');

//         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

//         require(token0 != address(0), 'SunswapV2: ZERO_ADDRESS');
//         require(getPair[token0][token1] == address(0), 'SunswapV2: PAIR_EXISTS');

//         // Single check is sufficient
//         bytes memory bytecode = type(SunswapV2Pair).creationCode;

//         bytes32 salt = keccak256(abi.encodePacked(token0, token1));

//         assembly {
//             pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
//         }

//         ISunswapV2Pair(pair).initialize(token0, token1);

//         getPair[token0][token1] = pair;
//         getPair[token1][token0] = pair; // Populate mapping in the reverse direction

//         allPairs.push(pair);

//         emit PairCreated(token0, token1, pair, allPairs.length);
//     }

//     function setFeeTo(address _feeTo) external override {
//         require(msg.sender == feeToSetter, 'SunswapV2: FORBIDDEN');
//         feeTo = _feeTo;
//     }

//     function setFeeToSetter(address _feeToSetter) external override {
//         require(msg.sender == feeToSetter, 'SunswapV2: FORBIDDEN');
//         feeToSetter = _feeToSetter;
//     }

//     function getPairHash() public pure returns (bytes32) {
//         return keccak256(type(SunswapV2Pair).creationCode);
//     }

//     function setRouter(address _r) external onlyOwner {
//         _router = _r;
//     }

//     function router() external view override returns (address) {
//         return _router;
//     }
// }
