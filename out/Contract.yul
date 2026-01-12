object "Contract" {
    code {
        datacopy(0, dataoffset("Contract_deployed"), datasize("Contract_deployed"))
        return(0, datasize("Contract_deployed"))
    }
    object "Contract_deployed" {
        code {
            switch shr(224, calldataload(0))
            case 2302484712 {
                let _result := getOwner()
                mstore(0, _result)
                return(0, 32)
            }
            case 2569101039 {
                let _result := getReserve0()
                mstore(0, _result)
                return(0, 32)
            }
            case 2430363622 {
                let _result := getReserve1()
                mstore(0, _result)
                return(0, 32)
            }
            case 3996772256 {
                let _result := getK()
                mstore(0, _result)
                return(0, 32)
            }
            case 1889567281 {
                let account := and(calldataload(4), 1461501637330902918203684832716283019655932542975)
                let _result := balanceOf(account)
                mstore(0, _result)
                return(0, 32)
            }
            case 404098525 {
                let _result := totalSupply()
                mstore(0, _result)
                return(0, 32)
            }
            case 3302387176 {
                let new_owner := and(calldataload(4), 1461501637330902918203684832716283019655932542975)
                initialize(new_owner)
                return(0, 0)
            }
            case 4076725131 {
                let new_owner := and(calldataload(4), 1461501637330902918203684832716283019655932542975)
                transferOwnership(new_owner)
                return(0, 0)
            }
            case 1391970696 {
                let fee_num := calldataload(4)
                let fee_denom := calldataload(36)
                setFee(fee_num, fee_denom)
                return(0, 0)
            }
            case 2207430848 {
                let r0 := calldataload(4)
                let r1 := calldataload(36)
                setReserves(r0, r1)
                return(0, 0)
            }
            case 2579311525 {
                let to := and(calldataload(4), 1461501637330902918203684832716283019655932542975)
                let amount := calldataload(36)
                mintLP(to, amount)
                return(0, 0)
            }
            case 3387032947 {
                let from := and(calldataload(4), 1461501637330902918203684832716283019655932542975)
                let amount := calldataload(36)
                burnLP(from, amount)
                return(0, 0)
            }
            case 2276597500 {
                calldatacopy(0, 4, 96)
                let amount0 := mload(0)
                let amount1 := mload(32)
                let to := and(mload(64), 1461501637330902918203684832716283019655932542975)
                let _result := addLiquidity(amount0, amount1, to)
                mstore(0, _result)
                return(0, 32)
            }
            case 3978024812 {
                let amount0 := calldataload(4)
                let _result := quote(amount0)
                mstore(0, _result)
                return(0, 32)
            }
            case 2626658083 {
                let liquidity := calldataload(4)
                let _result := removeLiquidity(liquidity)
                mstore(0, _result)
                return(0, 32)
            }
            case 848531232 {
                let amount0_in := calldataload(4)
                let _result := swap0For1(amount0_in)
                mstore(0, _result)
                return(0, 32)
            }
            case 3995843741 {
                let amount1_in := calldataload(4)
                let _result := swap1For0(amount1_in)
                mstore(0, _result)
                return(0, 32)
            }
            case 3763380832 {
                let amount_in := calldataload(4)
                let _result := getAmountOut0To1(amount_in)
                mstore(0, _result)
                return(0, 32)
            }
            case 2107358911 {
                let amount_in := calldataload(4)
                let _result := getAmountOut1To0(amount_in)
                mstore(0, _result)
                return(0, 32)
            }
            case 2659173149 {
                let scale := calldataload(4)
                let _result := getPrice0(scale)
                mstore(0, _result)
                return(0, 32)
            }
            case 3000804309 {
                let scale := calldataload(4)
                let _result := getPrice1(scale)
                mstore(0, _result)
                return(0, 32)
            }
            case 2835717307 {
                let to := and(calldataload(4), 1461501637330902918203684832716283019655932542975)
                let amount := calldataload(36)
                transfer(to, amount)
                return(0, 0)
            }
            case 599290589 {
                calldatacopy(0, 4, 96)
                let from := and(mload(0), 1461501637330902918203684832716283019655932542975)
                let to := and(mload(32), 1461501637330902918203684832716283019655932542975)
                let amount := mload(64)
                transferFrom(from, to, amount)
                return(0, 0)
            }
            default {
                mstore(0, 1934809372)
                revert(28, 4)
            }
            function getOwner() -> result {
                result := and(sload(0), 1461501637330902918203684832716283019655932542975)
                leave
            }
            function getReserve0() -> result {
                result := sload(1)
                leave
            }
            function getReserve1() -> result {
                result := sload(2)
                leave
            }
            function getK() -> result {
                result := mul(sload(1), sload(2))
                leave
            }
            function balanceOf(account) -> result {
                result := sload(__zig2yul$mapping_slot(account, 4))
                leave
            }
            function totalSupply() -> result {
                result := sload(3)
                leave
            }
            function initialize(new_owner) {
                if iszero(eq(and(sload(0), 1461501637330902918203684832716283019655932542975), 0)) {
                    __zig2yul$panic_ef51f71cc65462d6()
                }
                if eq(new_owner, 0) {
                    __zig2yul$panic_752e83bf9c1d33ef()
                }
                sstore(0, or(and(sload(0), 115792089237316195423570985007226406215939081747436879206741300988257197096960), and(new_owner, 1461501637330902918203684832716283019655932542975)))
            }
            function transferOwnership(new_owner) {
                if iszero(eq(caller(), and(sload(0), 1461501637330902918203684832716283019655932542975))) {
                    __zig2yul$panic_b48ddbc8414ee64a()
                }
                if eq(new_owner, 0) {
                    __zig2yul$panic_752e83bf9c1d33ef()
                }
                sstore(0, or(and(sload(0), 115792089237316195423570985007226406215939081747436879206741300988257197096960), and(new_owner, 1461501637330902918203684832716283019655932542975)))
            }
            function setFee(fee_num, fee_denom) {
                if iszero(eq(caller(), and(sload(0), 1461501637330902918203684832716283019655932542975))) {
                    __zig2yul$panic_b48ddbc8414ee64a()
                }
                if eq(fee_denom, 0) {
                    __zig2yul$panic_bb203838accf2c6d()
                }
                if iszero(lt(fee_num, fee_denom)) {
                    __zig2yul$panic_1e7c1d2f8aae88c8()
                }
                sstore(5, fee_num)
                sstore(6, fee_denom)
            }
            function setReserves(r0, r1) {
                if iszero(eq(caller(), and(sload(0), 1461501637330902918203684832716283019655932542975))) {
                    __zig2yul$panic_b48ddbc8414ee64a()
                }
                if eq(r0, 0) {
                    __zig2yul$panic_1bba2d04277af3b()
                }
                if eq(r1, 0) {
                    __zig2yul$panic_ff88f4be2ff3c3f3()
                }
                sstore(1, r0)
                sstore(2, r1)
            }
            function mintLP(to, amount) {
                if iszero(eq(caller(), and(sload(0), 1461501637330902918203684832716283019655932542975))) {
                    __zig2yul$panic_b48ddbc8414ee64a()
                }
                if eq(to, 0) {
                    __zig2yul$panic_aaacd97e262f7b80()
                }
                if eq(amount, 0) {
                    __zig2yul$panic_2b535ed5636fae76()
                }
                sstore(3, add(sload(3), amount))
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(to, 4), 4, to, add(sload(__zig2yul$mapping_slot(to, 4)), amount))
            }
            function burnLP(from, amount) {
                if iszero(eq(caller(), and(sload(0), 1461501637330902918203684832716283019655932542975))) {
                    __zig2yul$panic_b48ddbc8414ee64a()
                }
                if eq(amount, 0) {
                    __zig2yul$panic_2b535ed5636fae76()
                }
                if lt(sload(__zig2yul$mapping_slot(from, 4)), amount) {
                    __zig2yul$panic_bfbfe24ddbc6254b()
                }
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(from, 4), 4, from, sub(sload(__zig2yul$mapping_slot(from, 4)), amount))
                sstore(3, sub(sload(3), amount))
            }
            function addLiquidity(amount0, amount1, to) -> result {
                if eq(amount0, 0) {
                    __zig2yul$panic_603d4acfa87fee60()
                }
                if eq(amount1, 0) {
                    __zig2yul$panic_f73a60ffefad4fbf()
                }
                if eq(to, 0) {
                    __zig2yul$panic_aaacd97e262f7b80()
                }
                if eq(sload(1), 0) {
                    __zig2yul$panic_c384845389ec208f()
                }
                if eq(sload(3), 0) {
                    __zig2yul$panic_60e1392268f00ca1()
                }
                let liquidity := div(mul(amount0, sload(3)), sload(1))
                if eq(liquidity, 0) {
                    __zig2yul$panic_42d16e06b401cb5d()
                }
                sstore(3, add(sload(3), liquidity))
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(to, 4), 4, to, add(sload(__zig2yul$mapping_slot(to, 4)), liquidity))
                sstore(1, add(sload(1), amount0))
                sstore(2, add(sload(2), amount1))
                result := liquidity
                leave
            }
            function quote(amount0) -> result {
                if eq(sload(1), 0) {
                    __zig2yul$panic_c384845389ec208f()
                }
                result := div(mul(amount0, sload(2)), sload(1))
                leave
            }
            function removeLiquidity(liquidity) -> result {
                let from := caller()
                if eq(liquidity, 0) {
                    __zig2yul$panic_dfb9c0276bbfd073()
                }
                if lt(sload(__zig2yul$mapping_slot(from, 4)), liquidity) {
                    __zig2yul$panic_bfbfe24ddbc6254b()
                }
                if eq(sload(3), 0) {
                    __zig2yul$panic_60e1392268f00ca1()
                }
                let amount0 := div(mul(liquidity, sload(1)), sload(3))
                let amount1 := div(mul(liquidity, sload(2)), sload(3))
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(from, 4), 4, from, sub(sload(__zig2yul$mapping_slot(from, 4)), liquidity))
                sstore(3, sub(sload(3), liquidity))
                sstore(1, sub(sload(1), amount0))
                sstore(2, sub(sload(2), amount1))
                result := amount0
                leave
            }
            function swap0For1(amount0_in) -> result {
                if eq(amount0_in, 0) {
                    __zig2yul$panic_f1274481664c0835()
                }
                if eq(sload(1), 0) {
                    __zig2yul$panic_c384845389ec208f()
                }
                if eq(sload(2), 0) {
                    __zig2yul$panic_c384845389ec208f()
                }
                if eq(sload(6), 0) {
                    __zig2yul$panic_f88084a463f6a34c()
                }
                let fee_adjusted := sub(sload(6), sload(5))
                let amount_in_with_fee := mul(amount0_in, fee_adjusted)
                let numerator := mul(amount_in_with_fee, sload(2))
                let denominator := add(mul(sload(1), sload(6)), amount_in_with_fee)
                let amount1_out := div(numerator, denominator)
                if eq(amount1_out, 0) {
                    __zig2yul$panic_ac26bf0f73b4ee8f()
                }
                if iszero(lt(amount1_out, sload(2))) {
                    __zig2yul$panic_1b320e78343fa8c0()
                }
                sstore(1, add(sload(1), amount0_in))
                sstore(2, sub(sload(2), amount1_out))
                result := amount1_out
                leave
            }
            function swap1For0(amount1_in) -> result {
                if eq(amount1_in, 0) {
                    __zig2yul$panic_f1274481664c0835()
                }
                if eq(sload(1), 0) {
                    __zig2yul$panic_c384845389ec208f()
                }
                if eq(sload(2), 0) {
                    __zig2yul$panic_c384845389ec208f()
                }
                if eq(sload(6), 0) {
                    __zig2yul$panic_f88084a463f6a34c()
                }
                let fee_adjusted := sub(sload(6), sload(5))
                let amount_in_with_fee := mul(amount1_in, fee_adjusted)
                let numerator := mul(amount_in_with_fee, sload(1))
                let denominator := add(mul(sload(2), sload(6)), amount_in_with_fee)
                let amount0_out := div(numerator, denominator)
                if eq(amount0_out, 0) {
                    __zig2yul$panic_ac26bf0f73b4ee8f()
                }
                if iszero(lt(amount0_out, sload(1))) {
                    __zig2yul$panic_1b320e78343fa8c0()
                }
                sstore(2, add(sload(2), amount1_in))
                sstore(1, sub(sload(1), amount0_out))
                result := amount0_out
                leave
            }
            function getAmountOut0To1(amount_in) -> result {
                if eq(sload(6), 0) {
                    __zig2yul$panic_f88084a463f6a34c()
                }
                if eq(sload(1), 0) {
                    __zig2yul$panic_c384845389ec208f()
                }
                let fee_adjusted := sub(sload(6), sload(5))
                let amount_in_with_fee := mul(amount_in, fee_adjusted)
                let numerator := mul(amount_in_with_fee, sload(2))
                let denominator := add(mul(sload(1), sload(6)), amount_in_with_fee)
                result := div(numerator, denominator)
                leave
            }
            function getAmountOut1To0(amount_in) -> result {
                if eq(sload(6), 0) {
                    __zig2yul$panic_f88084a463f6a34c()
                }
                if eq(sload(2), 0) {
                    __zig2yul$panic_c384845389ec208f()
                }
                let fee_adjusted := sub(sload(6), sload(5))
                let amount_in_with_fee := mul(amount_in, fee_adjusted)
                let numerator := mul(amount_in_with_fee, sload(1))
                let denominator := add(mul(sload(2), sload(6)), amount_in_with_fee)
                result := div(numerator, denominator)
                leave
            }
            function getPrice0(scale) -> result {
                if eq(sload(1), 0) {
                    __zig2yul$panic_c384845389ec208f()
                }
                result := div(mul(sload(2), scale), sload(1))
                leave
            }
            function getPrice1(scale) -> result {
                if eq(sload(2), 0) {
                    __zig2yul$panic_c384845389ec208f()
                }
                result := div(mul(sload(1), scale), sload(2))
                leave
            }
            function transfer(to, amount) {
                let from := caller()
                if eq(to, 0) {
                    __zig2yul$panic_aaacd97e262f7b80()
                }
                if eq(amount, 0) {
                    __zig2yul$panic_2b535ed5636fae76()
                }
                if lt(sload(__zig2yul$mapping_slot(from, 4)), amount) {
                    __zig2yul$panic_bfbfe24ddbc6254b()
                }
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(from, 4), 4, from, sub(sload(__zig2yul$mapping_slot(from, 4)), amount))
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(to, 4), 4, to, add(sload(__zig2yul$mapping_slot(to, 4)), amount))
            }
            function transferFrom(from, to, amount) {
                if iszero(eq(caller(), and(sload(0), 1461501637330902918203684832716283019655932542975))) {
                    __zig2yul$panic_b48ddbc8414ee64a()
                }
                if eq(to, 0) {
                    __zig2yul$panic_aaacd97e262f7b80()
                }
                if eq(amount, 0) {
                    __zig2yul$panic_2b535ed5636fae76()
                }
                if lt(sload(__zig2yul$mapping_slot(from, 4)), amount) {
                    __zig2yul$panic_bfbfe24ddbc6254b()
                }
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(from, 4), 4, from, sub(sload(__zig2yul$mapping_slot(from, 4)), amount))
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(to, 4), 4, to, add(sload(__zig2yul$mapping_slot(to, 4)), amount))
            }
            function __zig2yul$mapping_slot(key, base) -> slot {
                mstore(0, key)
                mstore(32, base)
                slot := keccak256(0, 64)
            }
            function __zig2yul$panic_ef51f71cc65462d6() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 19)
                mstore(68, 0x616c726561647920696e697469616c697a656400000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_752e83bf9c1d33ef() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 13)
                mstore(68, 0x696e76616c6964206f776e657200000000000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_b48ddbc8414ee64a() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 9)
                mstore(68, 0x6e6f74206f776e65720000000000000000000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_bb203838accf2c6d() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 17)
                mstore(68, 0x696e76616c6964206665652064656e6f6d000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_1e7c1d2f8aae88c8() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 12)
                mstore(68, 0x66656520746f6f20686967680000000000000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_1bba2d04277af3b() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 16)
                mstore(68, 0x696e76616c696420726573657276653000000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_ff88f4be2ff3c3f3() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 16)
                mstore(68, 0x696e76616c696420726573657276653100000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_aaacd97e262f7b80() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 17)
                mstore(68, 0x696e76616c696420726563697069656e74000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_2b535ed5636fae76() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 14)
                mstore(68, 0x696e76616c696420616d6f756e74000000000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$map_setv$Address_U256_1(slot, base, key, value) {
                sstore(__zig2yul$mapping_slot(key, add(base, 3)), 1)
                if iszero(sload(__zig2yul$mapping_slot(key, add(base, 3)))) {
                    sstore(__zig2yul$mapping_slot(key, add(base, 1)), add(sload(base), 1))
                    sstore(add(add(base, 2), sload(base)), key)
                }
                sstore(base, add(sload(base), iszero(sload(__zig2yul$mapping_slot(key, add(base, 3))))))
                sstore(slot, value)
            }
            function __zig2yul$panic_bfbfe24ddbc6254b() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 20)
                mstore(68, 0x696e73756666696369656e742062616c616e6365000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_603d4acfa87fee60() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 15)
                mstore(68, 0x696e76616c696420616d6f756e74300000000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_f73a60ffefad4fbf() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 15)
                mstore(68, 0x696e76616c696420616d6f756e74310000000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_c384845389ec208f() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 12)
                mstore(68, 0x6e6f206c69717569646974790000000000000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_60e1392268f00ca1() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 9)
                mstore(68, 0x6e6f20737570706c790000000000000000000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_42d16e06b401cb5d() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 29)
                mstore(68, 0x696e73756666696369656e74206c6971756964697479206d696e746564000000)
                revert(0, 100)
            }
            function __zig2yul$panic_dfb9c0276bbfd073() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 17)
                mstore(68, 0x696e76616c6964206c6971756964697479000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_f1274481664c0835() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 20)
                mstore(68, 0x696e76616c696420696e70757420616d6f756e74000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_f88084a463f6a34c() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 11)
                mstore(68, 0x666565206e6f7420736574000000000000000000000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_ac26bf0f73b4ee8f() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 19)
                mstore(68, 0x696e73756666696369656e74206f757470757400000000000000000000000000)
                revert(0, 100)
            }
            function __zig2yul$panic_1b320e78343fa8c0() {
                mstore(0, shl(224, 0x8c379a0))
                mstore(4, 32)
                mstore(36, 16)
                mstore(68, 0x6578636565647320726573657276657300000000000000000000000000000000)
                revert(0, 100)
            }
        }
    }
}