object "Contract" {
    code {
        datacopy(0, dataoffset("Contract_deployed"), datasize("Contract_deployed"))
        return(0, datasize("Contract_deployed"))
    }
    object "Contract_deployed" {
        code {
            switch shr(224, calldataload(0))
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
                let owner := shr(96, calldataload(4))
                let _result := balanceOf(owner)
                mstore(0, _result)
                return(0, 32)
            }
            case 404098525 {
                let _result := totalSupply()
                mstore(0, _result)
                return(0, 32)
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
                let to := shr(96, calldataload(4))
                let amount := calldataload(36)
                mintLP(to, amount)
                return(0, 0)
            }
            case 3387032947 {
                let from := shr(96, calldataload(4))
                let amount := calldataload(36)
                burnLP(from, amount)
                return(0, 0)
            }
            case 2276597500 {
                calldatacopy(0, 4, 96)
                let amount0 := mload(0)
                let amount1 := mload(32)
                let to := shr(96, mload(64))
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
            case 100537227 {
                let liquidity := calldataload(4)
                let from := shr(96, calldataload(36))
                let _result := removeLiquidity(liquidity, from)
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
            case 3198921928 {
                calldatacopy(0, 4, 96)
                let from := shr(96, mload(0))
                let to := shr(96, mload(32))
                let amount := mload(64)
                transfer(from, to, amount)
                return(0, 0)
            }
            default {
                mstore(0, 1934809372)
                revert(28, 4)
            }
            function getReserve0() -> result {
                result := sload(0)
                leave
            }
            function getReserve1() -> result {
                result := sload(1)
                leave
            }
            function getK() -> result {
                result := mul(sload(0), sload(1))
                leave
            }
            function balanceOf(owner) -> result {
                result := sload(__zig2yul$mapping_slot(owner, 3))
                leave
            }
            function totalSupply() -> result {
                result := sload(2)
                leave
            }
            function setFee(fee_num, fee_denom) {
                sstore(4, fee_num)
                sstore(5, fee_denom)
            }
            function setReserves(r0, r1) {
                sstore(0, r0)
                sstore(1, r1)
            }
            function mintLP(to, amount) {
                sstore(2, add(sload(2), amount))
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(to, 3), 3, to, add(sload(__zig2yul$mapping_slot(to, 3)), amount))
            }
            function burnLP(from, amount) {
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(from, 3), 3, from, sub(sload(__zig2yul$mapping_slot(from, 3)), amount))
                sstore(2, sub(sload(2), amount))
            }
            function addLiquidity(amount0, amount1, to) -> result {
                let liquidity := div(mul(amount0, sload(2)), sload(0))
                sstore(2, add(sload(2), liquidity))
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(to, 3), 3, to, add(sload(__zig2yul$mapping_slot(to, 3)), liquidity))
                sstore(0, add(sload(0), amount0))
                sstore(1, add(sload(1), amount1))
                result := liquidity
                leave
            }
            function quote(amount0) -> result {
                result := div(mul(amount0, sload(1)), sload(0))
                leave
            }
            function removeLiquidity(liquidity, from) -> result {
                let amount0 := div(mul(liquidity, sload(0)), sload(2))
                let amount1 := div(mul(liquidity, sload(1)), sload(2))
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(from, 3), 3, from, sub(sload(__zig2yul$mapping_slot(from, 3)), liquidity))
                sstore(2, sub(sload(2), liquidity))
                sstore(0, sub(sload(0), amount0))
                sstore(1, sub(sload(1), amount1))
                result := amount0
                leave
            }
            function swap0For1(amount0_in) -> result {
                let fee_adjusted := sub(sload(5), sload(4))
                let amount_in_with_fee := mul(amount0_in, fee_adjusted)
                let numerator := mul(amount_in_with_fee, sload(1))
                let denominator := add(mul(sload(0), sload(5)), amount_in_with_fee)
                let amount1_out := div(numerator, denominator)
                sstore(0, add(sload(0), amount0_in))
                sstore(1, sub(sload(1), amount1_out))
                result := amount1_out
                leave
            }
            function swap1For0(amount1_in) -> result {
                let fee_adjusted := sub(sload(5), sload(4))
                let amount_in_with_fee := mul(amount1_in, fee_adjusted)
                let numerator := mul(amount_in_with_fee, sload(0))
                let denominator := add(mul(sload(1), sload(5)), amount_in_with_fee)
                let amount0_out := div(numerator, denominator)
                sstore(1, add(sload(1), amount1_in))
                sstore(0, sub(sload(0), amount0_out))
                result := amount0_out
                leave
            }
            function getAmountOut0To1(amount_in) -> result {
                let fee_adjusted := sub(sload(5), sload(4))
                let amount_in_with_fee := mul(amount_in, fee_adjusted)
                let numerator := mul(amount_in_with_fee, sload(1))
                let denominator := add(mul(sload(0), sload(5)), amount_in_with_fee)
                result := div(numerator, denominator)
                leave
            }
            function getAmountOut1To0(amount_in) -> result {
                let fee_adjusted := sub(sload(5), sload(4))
                let amount_in_with_fee := mul(amount_in, fee_adjusted)
                let numerator := mul(amount_in_with_fee, sload(0))
                let denominator := add(mul(sload(1), sload(5)), amount_in_with_fee)
                result := div(numerator, denominator)
                leave
            }
            function getPrice0(scale) -> result {
                result := div(mul(sload(1), scale), sload(0))
                leave
            }
            function getPrice1(scale) -> result {
                result := div(mul(sload(0), scale), sload(1))
                leave
            }
            function transfer(from, to, amount) {
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(from, 3), 3, from, sub(sload(__zig2yul$mapping_slot(from, 3)), amount))
                __zig2yul$map_setv$Address_U256_1(__zig2yul$mapping_slot(to, 3), 3, to, add(sload(__zig2yul$mapping_slot(to, 3)), amount))
            }
            function __zig2yul$mapping_slot(key, base) -> slot {
                mstore(0, key)
                mstore(32, base)
                slot := keccak256(0, 64)
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
        }
    }
}