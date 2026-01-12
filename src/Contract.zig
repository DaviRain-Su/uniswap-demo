//! Uniswap V2 Style AMM Contract
//! Implements the constant product formula: x * y = k
//! Source: z2y template (no Rust reference)

const evm = @import("evm.zig");
const U256 = evm.U256;
const Address = evm.Address;
const Mapping = evm.Mapping;

/// UniswapPair - AMM liquidity pool implementing x*y=k
pub const Contract = struct {
    // Owner for access control
    owner: Address,

    // Reserves for the constant product formula
    reserve0: U256,
    reserve1: U256,

    // LP Token State
    total_supply: U256,
    balances: Mapping(Address, U256),

    // Fee: 3/1000 = 0.3%
    fee_numerator: U256,
    fee_denominator: U256,

    // ============ View Functions ============

    /// Get contract owner
    pub fn getOwner(self: *Contract) Address {
        return self.owner;
    }

    /// Get reserve0
    pub fn getReserve0(self: *Contract) U256 {
        return self.reserve0;
    }

    /// Get reserve1
    pub fn getReserve1(self: *Contract) U256 {
        return self.reserve1;
    }

    /// Calculate the constant product k = x * y
    pub fn getK(self: *Contract) U256 {
        return self.reserve0 * self.reserve1;
    }

    /// Get LP token balance
    pub fn balanceOf(self: *Contract, account: Address) U256 {
        return self.balances.get(account);
    }

    /// Get total LP token supply
    pub fn totalSupply(self: *Contract) U256 {
        return self.total_supply;
    }

    // ============ Owner Functions ============

    /// Initialize owner (can only be called once when owner is zero)
    pub fn initialize(self: *Contract, new_owner: Address) void {
        if (self.owner != 0) @panic("already initialized");
        if (new_owner == 0) @panic("invalid owner");
        self.owner = new_owner;
    }

    /// Transfer ownership (only current owner)
    pub fn transferOwnership(self: *Contract, new_owner: Address) void {
        if (evm.caller() != self.owner) @panic("not owner");
        if (new_owner == 0) @panic("invalid owner");
        self.owner = new_owner;
    }

    /// Set fee (only owner, fee_num=3, fee_denom=1000 for 0.3%)
    pub fn setFee(self: *Contract, fee_num: U256, fee_denom: U256) void {
        if (evm.caller() != self.owner) @panic("not owner");
        if (fee_denom == 0) @panic("invalid fee denom");
        if (fee_num >= fee_denom) @panic("fee too high");
        self.fee_numerator = fee_num;
        self.fee_denominator = fee_denom;
    }

    /// Set initial reserves directly (only owner, for first liquidity)
    pub fn setReserves(self: *Contract, r0: U256, r1: U256) void {
        if (evm.caller() != self.owner) @panic("not owner");
        if (r0 == 0) @panic("invalid reserve0");
        if (r1 == 0) @panic("invalid reserve1");
        self.reserve0 = r0;
        self.reserve1 = r1;
    }

    /// Mint LP tokens to an address (only owner)
    pub fn mintLP(self: *Contract, to: Address, amount: U256) void {
        if (evm.caller() != self.owner) @panic("not owner");
        if (to == 0) @panic("invalid recipient");
        if (amount == 0) @panic("invalid amount");

        self.total_supply = self.total_supply + amount;
        self.balances.set(to, self.balances.get(to) + amount);
    }

    /// Burn LP tokens from an address (only owner)
    pub fn burnLP(self: *Contract, from: Address, amount: U256) void {
        if (evm.caller() != self.owner) @panic("not owner");
        if (amount == 0) @panic("invalid amount");
        if (self.balances.get(from) < amount) @panic("insufficient balance");

        self.balances.set(from, self.balances.get(from) - amount);
        self.total_supply = self.total_supply - amount;
    }

    // ============ Core AMM Functions ============

    /// Add liquidity: deposit token0 and token1, receive LP tokens
    /// IMPORTANT: Caller must provide balanced amounts (use quote() to calculate)
    /// LP amount = amount0 * totalSupply / reserve0
    /// For initial liquidity, use setReserves + mintLP directly
    pub fn addLiquidity(
        self: *Contract,
        amount0: U256,
        amount1: U256,
        to: Address,
    ) U256 {
        // Input validation
        if (amount0 == 0) @panic("invalid amount0");
        if (amount1 == 0) @panic("invalid amount1");
        if (to == 0) @panic("invalid recipient");
        if (self.reserve0 == 0) @panic("no liquidity");
        if (self.total_supply == 0) @panic("no supply");

        // Calculate LP tokens based on token0 ratio
        const liquidity = (amount0 * self.total_supply) / self.reserve0;
        if (liquidity == 0) @panic("insufficient liquidity minted");

        // Mint LP tokens
        self.total_supply = self.total_supply + liquidity;
        self.balances.set(to, self.balances.get(to) + liquidity);

        // Update reserves
        self.reserve0 = self.reserve0 + amount0;
        self.reserve1 = self.reserve1 + amount1;

        return liquidity;
    }

    /// Quote: given amount0, calculate required amount1 to maintain ratio
    /// Use this before addLiquidity to get the correct amount1
    pub fn quote(self: *Contract, amount0: U256) U256 {
        if (self.reserve0 == 0) @panic("no liquidity");
        return (amount0 * self.reserve1) / self.reserve0;
    }

    /// Remove liquidity: burn LP tokens, receive token0 and token1
    /// Returns amount0 (amount1 can be calculated: amount1 = liquidity * reserve1 / totalSupply)
    pub fn removeLiquidity(self: *Contract, liquidity: U256) U256 {
        const from = evm.caller();

        // Input validation
        if (liquidity == 0) @panic("invalid liquidity");
        if (self.balances.get(from) < liquidity) @panic("insufficient balance");
        if (self.total_supply == 0) @panic("no supply");

        // Calculate amounts to return
        const amount0 = (liquidity * self.reserve0) / self.total_supply;
        const amount1 = (liquidity * self.reserve1) / self.total_supply;

        // Burn LP tokens
        self.balances.set(from, self.balances.get(from) - liquidity);
        self.total_supply = self.total_supply - liquidity;

        // Update reserves
        self.reserve0 = self.reserve0 - amount0;
        self.reserve1 = self.reserve1 - amount1;

        return amount0;
    }

    /// Swap token0 for token1 using x*y=k formula
    /// Returns amount of token1 received
    pub fn swap0For1(self: *Contract, amount0_in: U256) U256 {
        // Input validation
        if (amount0_in == 0) @panic("invalid input amount");
        if (self.reserve0 == 0) @panic("no liquidity");
        if (self.reserve1 == 0) @panic("no liquidity");
        if (self.fee_denominator == 0) @panic("fee not set");

        // Calculate output with 0.3% fee
        const fee_adjusted = self.fee_denominator - self.fee_numerator;
        const amount_in_with_fee = amount0_in * fee_adjusted;
        const numerator = amount_in_with_fee * self.reserve1;
        const denominator = (self.reserve0 * self.fee_denominator) + amount_in_with_fee;
        const amount1_out = numerator / denominator;

        // Output validation
        if (amount1_out == 0) @panic("insufficient output");
        if (amount1_out >= self.reserve1) @panic("exceeds reserves");

        // Update reserves (x increases, y decreases)
        self.reserve0 = self.reserve0 + amount0_in;
        self.reserve1 = self.reserve1 - amount1_out;

        return amount1_out;
    }

    /// Swap token1 for token0 using x*y=k formula
    /// Returns amount of token0 received
    pub fn swap1For0(self: *Contract, amount1_in: U256) U256 {
        // Input validation
        if (amount1_in == 0) @panic("invalid input amount");
        if (self.reserve0 == 0) @panic("no liquidity");
        if (self.reserve1 == 0) @panic("no liquidity");
        if (self.fee_denominator == 0) @panic("fee not set");

        // Calculate output with 0.3% fee
        const fee_adjusted = self.fee_denominator - self.fee_numerator;
        const amount_in_with_fee = amount1_in * fee_adjusted;
        const numerator = amount_in_with_fee * self.reserve0;
        const denominator = (self.reserve1 * self.fee_denominator) + amount_in_with_fee;
        const amount0_out = numerator / denominator;

        // Output validation
        if (amount0_out == 0) @panic("insufficient output");
        if (amount0_out >= self.reserve0) @panic("exceeds reserves");

        // Update reserves (y increases, x decreases)
        self.reserve1 = self.reserve1 + amount1_in;
        self.reserve0 = self.reserve0 - amount0_out;

        return amount0_out;
    }

    /// Get expected output for swap0For1 (view function)
    pub fn getAmountOut0To1(self: *Contract, amount_in: U256) U256 {
        if (self.fee_denominator == 0) @panic("fee not set");
        if (self.reserve0 == 0) @panic("no liquidity");
        const fee_adjusted = self.fee_denominator - self.fee_numerator;
        const amount_in_with_fee = amount_in * fee_adjusted;
        const numerator = amount_in_with_fee * self.reserve1;
        const denominator = (self.reserve0 * self.fee_denominator) + amount_in_with_fee;
        return numerator / denominator;
    }

    /// Get expected output for swap1For0 (view function)
    pub fn getAmountOut1To0(self: *Contract, amount_in: U256) U256 {
        if (self.fee_denominator == 0) @panic("fee not set");
        if (self.reserve1 == 0) @panic("no liquidity");
        const fee_adjusted = self.fee_denominator - self.fee_numerator;
        const amount_in_with_fee = amount_in * fee_adjusted;
        const numerator = amount_in_with_fee * self.reserve0;
        const denominator = (self.reserve1 * self.fee_denominator) + amount_in_with_fee;
        return numerator / denominator;
    }

    /// Get spot price of token0 in terms of token1 (reserve1/reserve0)
    pub fn getPrice0(self: *Contract, scale: U256) U256 {
        if (self.reserve0 == 0) @panic("no liquidity");
        return (self.reserve1 * scale) / self.reserve0;
    }

    /// Get spot price of token1 in terms of token0 (reserve0/reserve1)
    pub fn getPrice1(self: *Contract, scale: U256) U256 {
        if (self.reserve1 == 0) @panic("no liquidity");
        return (self.reserve0 * scale) / self.reserve1;
    }

    // ============ LP Token Functions ============

    /// Transfer LP tokens to another address
    /// Uses caller() as the sender for security
    pub fn transfer(self: *Contract, to: Address, amount: U256) void {
        const from = evm.caller();

        // Input validation
        if (to == 0) @panic("invalid recipient");
        if (amount == 0) @panic("invalid amount");
        if (self.balances.get(from) < amount) @panic("insufficient balance");

        self.balances.set(from, self.balances.get(from) - amount);
        self.balances.set(to, self.balances.get(to) + amount);
    }

    /// Transfer LP tokens from one address to another
    /// Only owner can transfer on behalf of others
    pub fn transferFrom(self: *Contract, from: Address, to: Address, amount: U256) void {
        if (evm.caller() != self.owner) @panic("not owner");
        if (to == 0) @panic("invalid recipient");
        if (amount == 0) @panic("invalid amount");
        if (self.balances.get(from) < amount) @panic("insufficient balance");

        self.balances.set(from, self.balances.get(from) - amount);
        self.balances.set(to, self.balances.get(to) + amount);
    }
};
