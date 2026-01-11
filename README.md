# Uniswap AMM Demo (x * y = k)

使用 Zig 语言实现的 Uniswap V2 风格自动做市商 (AMM) 智能合约 Demo。

## 项目介绍

### 什么是 AMM？

**自动做市商 (Automated Market Maker, AMM)** 是一种去中心化交易协议，它使用数学公式来定价资产，而不是像传统交易所那样使用订单簿。AMM 允许用户在没有中介的情况下直接与智能合约交易。

### 什么是 Uniswap？

**Uniswap** 是以太坊上最著名的 AMM 协议，由 Hayden Adams 于 2018 年创建。它使用恒定乘积公式 `x * y = k` 来确定代币价格，开创了 DeFi（去中心化金融）的新时代。

### x * y = k 公式解析

```
x = reserve0 (池中 token0 的数量)
y = reserve1 (池中 token1 的数量)
k = 常数 (恒定乘积)
```

**工作原理:**
- 当用户用 token0 换 token1 时，token0 增加，token1 减少
- 但 `x * y` 的乘积必须保持不变（或因手续费略微增加）
- 这自动调节了价格：买入越多，价格越高

**示例:**
```
初始状态: x=1000, y=4000, k=4,000,000
价格: 1 token0 = 4 token1

用户用 100 token0 换 token1:
新 x = 1100
新 y = k / x = 4,000,000 / 1100 ≈ 3636
用户获得: 4000 - 3636 = 364 token1

交换后价格: 1 token0 = 3636/1100 ≈ 3.3 token1
```

### 流动性提供者 (LP)

- **LP** 是向池中存入两种代币的用户
- LP 获得 **LP 代币** 作为凭证，代表其在池中的份额
- LP 赚取每笔交易 **0.3%** 的手续费
- LP 可以随时销毁 LP 代币，按比例取回两种代币

### 滑点与价格影响

- **滑点**: 交易量越大，实际价格与预期价格偏差越大
- **公式**: `价格影响 ≈ 交易量 / (2 × 储备量)`
- 这保护了流动性提供者免受大额交易的损失

## 核心算法

恒定乘积公式：**x × y = k**

```
// 交换公式 (含 0.3% 手续费)
amount_out = (amount_in × 997 × reserve_out) / (reserve_in × 1000 + amount_in × 997)

// K 值在每次交换后保持不变（手续费使其略微增长）
```

## 项目结构

```
├── src/
│   ├── Contract.zig      # AMM 合约主文件
│   └── evm.zig           # EVM SDK 封装
├── out/
│   ├── Contract.bin      # 编译后的字节码
│   ├── Contract.abi.json # ABI 接口定义
│   └── Contract.yul      # 中间 Yul 代码
├── index.html            # AMM 交互前端
├── explorer.html         # 区块浏览器前端
├── build.zig             # 构建配置
└── build.zig.zon         # 依赖配置
```

## 合约功能

| 函数 | 说明 |
|------|------|
| `setFee(fee_num, fee_denom)` | 设置手续费 (3, 1000 = 0.3%) |
| `setReserves(r0, r1)` | 设置初始储备量 |
| `mintLP(to, amount)` | 铸造 LP 代币 |
| `burnLP(from, amount)` | 销毁 LP 代币 |
| `swap0For1(amount0_in)` | 用 token0 换 token1 |
| `swap1For0(amount1_in)` | 用 token1 换 token0 |
| `addLiquidity(amount0, amount1, to)` | 添加流动性 |
| `removeLiquidity(liquidity, from)` | 移除流动性 |
| `getK()` | 获取 k = reserve0 × reserve1 |
| `getReserve0()` / `getReserve1()` | 获取储备量 |
| `getAmountOut0To1(amount_in)` | 预估 token0→token1 输出 |
| `getAmountOut1To0(amount_in)` | 预估 token1→token0 输出 |
| `quote(amount0)` | 计算等比例 token1 数量 |
| `getPrice0(scale)` / `getPrice1(scale)` | 获取价格 |

## 快速开始

### 前置要求

- [Zig](https://ziglang.org/) >= 0.15.2
- [Foundry](https://getfoundry.sh/) (anvil, cast)
- Python 3 (用于前端服务器)

### 1. 编译合约

```bash
zig build
```

### 2. 启动本地节点

```bash
anvil --host 0.0.0.0 --port 8545
```

### 3. 部署合约

```bash
BYTECODE=$(cat out/Contract.bin)
cast send --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
  --rpc-url http://127.0.0.1:8545 --create $BYTECODE
```

合约地址: `0x5FbDB2315678afecb367f032d93F642f64180aa3`

### 4. 初始化合约

```bash
CONTRACT="0x5FbDB2315678afecb367f032d93F642f64180aa3"
PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
RPC="http://127.0.0.1:8545"

# 设置手续费 0.3%
cast send --private-key $PRIVATE_KEY --rpc-url $RPC $CONTRACT \
  "setFee(uint256,uint256)" 3 1000

# 设置初始储备: 1000 token0, 4000 token1
cast send --private-key $PRIVATE_KEY --rpc-url $RPC $CONTRACT \
  "setReserves(uint256,uint256)" 1000000000000000000000 4000000000000000000000

# 铸造 LP 代币
cast send --private-key $PRIVATE_KEY --rpc-url $RPC $CONTRACT \
  "mintLP(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 2000000000000000000000
```

### 5. 启动前端

```bash
python3 -m http.server 3000
```

### 6. 访问界面

| 页面 | 地址 | 功能 |
|------|------|------|
| AMM 交互界面 | http://localhost:3000/index.html | Swap、添加/移除流动性 |
| 区块浏览器 | http://localhost:3000/explorer.html | 查看区块、交易、账户 |

## 测试交换

```bash
CONTRACT="0x5FbDB2315678afecb367f032d93F642f64180aa3"
PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
RPC="http://127.0.0.1:8545"

# 查询预估输出
cast call --rpc-url $RPC $CONTRACT "getAmountOut0To1(uint256)(uint256)" 100000000000000000000

# 执行交换: 100 token0 -> token1
cast send --private-key $PRIVATE_KEY --rpc-url $RPC $CONTRACT \
  "swap0For1(uint256)" 100000000000000000000

# 查看新的 K 值
cast call --rpc-url $RPC $CONTRACT "getK()(uint256)"
```

## 可选: Otterscan 区块浏览器

```bash
sudo docker run --name otterscan -d --rm \
  --network host \
  -e ERIGON_URL="http://127.0.0.1:8545" \
  otterscan/otterscan:latest

# 访问: http://localhost:80
# 停止: sudo docker stop otterscan
```

## 停止所有服务

```bash
pkill anvil
pkill -f "http.server"
sudo docker stop otterscan 2>/dev/null
```

## 测试账户

Anvil 默认测试账户:

| # | 地址 | 私钥 |
|---|------|------|
| 0 | 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 | 0xac0974bec...f2ff80 |
| 1 | 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 | 0x59c6995e9...8690d |
| 2 | 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC | 0x5de4111af...b365a |

每个账户初始有 10000 ETH。

## 技术栈

- **合约语言**: Zig + zig_to_yul
- **本地节点**: Foundry Anvil
- **部署工具**: Foundry Cast
- **前端**: HTML + ethers.js
- **区块浏览器**: Otterscan (可选)

## License

MIT
