// // SPDX-License-Identifier: GPL-3.0-or-later
// pragma solidity ^0.8.20;

// import '../interfaces/ISunswapV2Router02.sol';
// import '../interfaces/IERC20.sol';
// import '../interfaces/ISunswapV2Factory.sol';
// import '../interfaces/ISunswapV2ERC20.sol';
// import '../interfaces/IWETH.sol';
// import '../lib/TransferHelper.sol';
// import '../libraries/SafeMath.sol';
// import '../libraries/SunswapV2Library.sol';

// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// contract XANATokenDEXRouterUpgradeable is Initializable, UUPSUpgradeable, OwnableUpgradeable, ISunswapV2Router02 {
//     using SafeMath for uint;

//     address public override factory;
//     address public override WETH;

//     modifier ensure(uint deadline) {
//         require(deadline >= block.timestamp, 'SunswapV2Router: EXPIRED');
//         _;
//     }

//     function initialize(address _factory, address _WETH, address _initialOwner) public initializer {
//         __Ownable_init(_initialOwner);
//         factory = _factory;
//         WETH = _WETH;
//     }

//     function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

//     receive() external payable {
//         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
//     }

//     // **** ADD LIQUIDITY ****
//     // **** ADD LIQUIDITY ****
//     function _addLiquidity(
//         address tokenA,
//         address tokenB,
//         uint amountADesired,
//         uint amountBDesired,
//         uint amountAMin,
//         uint amountBMin
//     ) internal virtual returns (uint amountA, uint amountB) {
//         // create the pair if it doesn't exist yet
//         if (ISunswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
//             ISunswapV2Factory(factory).createPair(tokenA, tokenB);
//         }
//         (uint reserveA, uint reserveB) = SunswapV2Library.getReserves(factory, tokenA, tokenB);
//         if (reserveA == 0 && reserveB == 0) {
//             (amountA, amountB) = (amountADesired, amountBDesired);
//         } else {
//             uint amountBOptimal = SunswapV2Library.quote(amountADesired, reserveA, reserveB);
//             if (amountBOptimal <= amountBDesired) {
//                 require(amountBOptimal >= amountBMin, 'SunswapV2Router: INSUFFICIENT_B_AMOUNT');
//                 (amountA, amountB) = (amountADesired, amountBOptimal);
//             } else {
//                 uint amountAOptimal = SunswapV2Library.quote(amountBDesired, reserveB, reserveA);
//                 assert(amountAOptimal <= amountADesired);
//                 require(amountAOptimal >= amountAMin, 'SunswapV2Router: INSUFFICIENT_A_AMOUNT');
//                 (amountA, amountB) = (amountAOptimal, amountBDesired);
//             }
//         }
//     }

//     function addLiquidity(
//         address tokenA,
//         address tokenB,
//         uint amountADesired,
//         uint amountBDesired,
//         uint amountAMin,
//         uint amountBMin,
//         address to,
//         uint deadline
//     ) external virtual payable override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
//         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
//         address pair = SunswapV2Library.pairFor(factory, tokenA, tokenB);
//         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
//         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
//         liquidity = ISunswapV2Pair(pair).mint(to);
//     }

//     function addLiquidityETH(
//         address token,
//         uint amountTokenDesired,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline
//     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
//         (amountToken, amountETH) = _addLiquidity(
//             token,
//             WETH,
//             amountTokenDesired,
//             msg.value,
//             amountTokenMin,
//             amountETHMin
//         );
//         address pair = SunswapV2Library.pairFor(factory, token, WETH);
//         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
//         IWETH(WETH).deposit{value: amountETH}();
//         assert(IWETH(WETH).transfer(pair, amountETH));
//         liquidity = ISunswapV2Pair(pair).mint(to);
//         // refund dust eth, if any
//         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
//     }

//     // **** REMOVE LIQUIDITY ****
//     function removeLiquidity(
//         address tokenA,
//         address tokenB,
//         uint liquidity,
//         uint amountAMin,
//         uint amountBMin,
//         address to,
//         uint deadline
//     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
//         address pair = SunswapV2Library.pairFor(factory, tokenA, tokenB);
//         ISunswapV2ERC20(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
//         (uint amount0, uint amount1) = ISunswapV2Pair(pair).burn(to);
//         (address token0,) = SunswapV2Library.sortTokens(tokenA, tokenB);
//         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
//         require(amountA >= amountAMin, 'SunswapV2Router: INSUFFICIENT_A_AMOUNT');
//         require(amountB >= amountBMin, 'SunswapV2Router: INSUFFICIENT_B_AMOUNT');
//     }

//     function removeLiquidityETH(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline
//     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
//         (amountToken, amountETH) = removeLiquidity(
//             token,
//             WETH,
//             liquidity,
//             amountTokenMin,
//             amountETHMin,
//             address(this),
//             deadline
//         );
//         TransferHelper.safeTransfer(token, to, amountToken);
//         IWETH(WETH).withdraw(amountETH);
//         TransferHelper.safeTransferETH(to, amountETH);
//     }

//     function removeLiquidityWithPermit(
//         address tokenA,
//         address tokenB,
//         uint liquidity,
//         uint amountAMin,
//         uint amountBMin,
//         address to,
//         uint deadline,
//         bool approveMax, uint8 v, bytes32 r, bytes32 s
//     ) external virtual override returns (uint amountA, uint amountB) {
//         address pair = SunswapV2Library.pairFor(factory, tokenA, tokenB);
//         uint value = approveMax ? type(uint).max  : liquidity;
//         ISunswapV2ERC20(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
//         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
//     }

//     function removeLiquidityETHWithPermit(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline,
//         bool approveMax, uint8 v, bytes32 r, bytes32 s
//     ) external virtual override returns (uint amountToken, uint amountETH) {
//         address pair = SunswapV2Library.pairFor(factory, token, WETH);
//         uint value = approveMax ? type(uint).max  : liquidity;
//         ISunswapV2ERC20(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
//         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
//     }

//     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
//     function removeLiquidityETHSupportingFeeOnTransferTokens(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline
//     ) public virtual override ensure(deadline) returns (uint amountETH) {
//         (, amountETH) = removeLiquidity(
//             token,
//             WETH,
//             liquidity,
//             amountTokenMin,
//             amountETHMin,
//             address(this),
//             deadline
//         );
//         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
//         IWETH(WETH).withdraw(amountETH);
//         TransferHelper.safeTransferETH(to, amountETH);
//     }

//     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline,
//         bool approveMax, uint8 v, bytes32 r, bytes32 s
//     ) external virtual override returns (uint amountETH) {
//         address pair = SunswapV2Library.pairFor(factory, token, WETH);
//         uint value = approveMax ? type(uint).max  : liquidity;
//         ISunswapV2ERC20(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
//         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
//             token, liquidity, amountTokenMin, amountETHMin, to, deadline
//         );
//     }

//     // **** SWAP ****
//     // requires the initial amount to have already been sent to the first pair
//     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
//         for (uint i; i < path.length - 1; i++) {
//             (address input, address output) = (path[i], path[i + 1]);
//             (address token0,) = SunswapV2Library.sortTokens(input, output);
//             uint amountOut = amounts[i + 1];
//             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
//             address to = i < path.length - 2 ? SunswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
//             ISunswapV2Pair(SunswapV2Library.pairFor(factory, input, output)).swap(
//                 amount0Out, amount1Out, to, new bytes(0)
//             );
//         }
//     }

//     function swapExactTokensForTokens(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
//         amounts = SunswapV2Library.getAmountsOut(factory, amountIn, path);
//         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
//         TransferHelper.safeTransferFrom(
//             path[0], msg.sender, SunswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
//         );
//         _swap(amounts, path, to);
//     }

//     function swapTokensForExactTokens(
//         uint amountOut,
//         uint amountInMax,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
//         amounts = SunswapV2Library.getAmountsIn(factory, amountOut, path);
//         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
//         TransferHelper.safeTransferFrom(
//             path[0], msg.sender, SunswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
//         );
//         _swap(amounts, path, to);
//     }

//     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
//         external
//         virtual
//         override
//         payable
//         ensure(deadline)
//         returns (uint[] memory amounts)
//     {
//         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
//         amounts = SunswapV2Library.getAmountsOut(factory, msg.value, path);
//         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
//         IWETH(WETH).deposit{value: amounts[0]}();
//         assert(IWETH(WETH).transfer(SunswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
//         _swap(amounts, path, to);
//     }

//     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
//         external
//         virtual
//         override
//         ensure(deadline)
//         returns (uint[] memory amounts)
//     {
//         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
//         amounts = SunswapV2Library.getAmountsIn(factory, amountOut, path);
//         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
//         TransferHelper.safeTransferFrom(
//             path[0], msg.sender, SunswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
//         );
//         _swap(amounts, path, address(this));
//         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
//         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
//     }

//     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
//         external
//         virtual
//         override
//         ensure(deadline)
//         returns (uint[] memory amounts)
//     {
//         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
//         amounts = SunswapV2Library.getAmountsOut(factory, amountIn, path);
//         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
//         TransferHelper.safeTransferFrom(
//             path[0], msg.sender, SunswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
//         );
//         _swap(amounts, path, address(this));
//         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
//         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
//     }

//     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
//         external
//         virtual
//         override
//         payable
//         ensure(deadline)
//         returns (uint[] memory amounts)
//     {
//         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
//         amounts = SunswapV2Library.getAmountsIn(factory, amountOut, path);
//         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
//         IWETH(WETH).deposit{value: amounts[0]}();
//         assert(IWETH(WETH).transfer(SunswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
//         _swap(amounts, path, to);
//         // refund dust eth, if any
//         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
//     }

//     // **** SWAP (supporting fee-on-transfer tokens) ****
//     // requires the initial amount to have already been sent to the first pair
//     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
//         for (uint i; i < path.length - 1; i++) {
//             (address input, address output) = (path[i], path[i + 1]);
//             (address token0,) = SunswapV2Library.sortTokens(input, output);
//             ISunswapV2Pair pair = ISunswapV2Pair(SunswapV2Library.pairFor(factory, input, output));
//             uint amountInput;
//             uint amountOutput;
//             { // scope to avoid stack too deep errors
//             (uint reserve0, uint reserve1,) = pair.getReserves();
//             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
//             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
//             amountOutput = SunswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
//             }
//             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
//             address to = i < path.length - 2 ? SunswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
//             pair.swap(amount0Out, amount1Out, to, new bytes(0));
//         }
//     }

//     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external virtual override ensure(deadline) {
//         TransferHelper.safeTransferFrom(
//             path[0], msg.sender, SunswapV2Library.pairFor(factory, path[0], path[1]), amountIn
//         );
//         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
//         _swapSupportingFeeOnTransferTokens(path, to);
//         require(
//             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
//             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
//         );
//     }

//     function swapExactETHForTokensSupportingFeeOnTransferTokens(
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     )
//         external
//         virtual
//         override
//         payable
//         ensure(deadline)
//     {
//         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
//         uint amountIn = msg.value;
//         IWETH(WETH).deposit{value: amountIn}();
//         assert(IWETH(WETH).transfer(SunswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
//         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
//         _swapSupportingFeeOnTransferTokens(path, to);
//         require(
//             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
//             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
//         );
//     }

//     function swapExactTokensForETHSupportingFeeOnTransferTokens(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     )
//         external
//         virtual
//         override
//         ensure(deadline)
//     {
//         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
//         TransferHelper.safeTransferFrom(
//             path[0], msg.sender, SunswapV2Library.pairFor(factory, path[0], path[1]), amountIn
//         );
//         _swapSupportingFeeOnTransferTokens(path, address(this));
//         uint amountOut = IERC20(WETH).balanceOf(address(this));
//         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
//         IWETH(WETH).withdraw(amountOut);
//         TransferHelper.safeTransferETH(to, amountOut);
//     }

//     // **** LIBRARY FUNCTIONS ****
//     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
//         return SunswapV2Library.quote(amountA, reserveA, reserveB);
//     }

//     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
//         public
//         pure
//         virtual
//         override
//         returns (uint amountOut)
//     {
//         return SunswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
//     }

//     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
//         public
//         pure
//         virtual
//         override
//         returns (uint amountIn)
//     {
//         return SunswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
//     }

//     function getAmountsOut(uint amountIn, address[] memory path)
//         public
//         view
//         virtual
//         override
//         returns (uint[] memory amounts)
//     {
//         return SunswapV2Library.getAmountsOut(factory, amountIn, path);
//     }

//     function getAmountsIn(uint amountOut, address[] memory path)
//         public
//         view
//         virtual
//         override
//         returns (uint[] memory amounts)
//     {
//         return SunswapV2Library.getAmountsIn(factory, amountOut, path);
//     }
// }
