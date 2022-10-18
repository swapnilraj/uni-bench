%lang starknet

from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int160,
    warp_external_input_check_int128,
    warp_external_input_check_int256,
)
from warplib.maths.external_input_check_bool import warp_external_input_check_bool
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.eq import warp_eq256
from warplib.maths.int_conversions import warp_uint256, warp_int256_to_int160
from warplib.maths.shl import warp_shl256
from warplib.maths.mul_unsafe import warp_mul_unsafe256
from warplib.maths.div_unsafe import warp_div_unsafe256
from warplib.maths.add_unsafe import warp_add_unsafe256
from warplib.maths.ge import warp_ge256
from warplib.maths.gt import warp_gt256, warp_gt
from warplib.maths.and_ import warp_and_
from warplib.maths.sub_unsafe import warp_sub_unsafe256
from warplib.maths.div import warp_div256
from warplib.maths.le import warp_le256
from warplib.maths.sub import warp_sub256, warp_sub
from warplib.maths.mulmod import warp_mulmod
from warplib.maths.lt import warp_lt256
from warplib.maths.negate import warp_negate256
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.xor import warp_xor256
from warplib.maths.mod import warp_mod256
from warplib.maths.add import warp_add256

// Contract Def SqrtPriceMathTest

@storage_var
func WARP_STORAGE(index: felt) -> (val: felt) {
}
@storage_var
func WARP_USED_STORAGE() -> (val: felt) {
}
@storage_var
func WARP_NAMEGEN() -> (name: felt) {
}
func readId{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(loc: felt) -> (
    val: felt
) {
    alloc_locals;
    let (id) = WARP_STORAGE.read(loc);
    if (id == 0) {
        let (id) = WARP_NAMEGEN.read();
        WARP_NAMEGEN.write(id + 1);
        WARP_STORAGE.write(loc, id + 1);
        return (id + 1,);
    } else {
        return (id,);
    }
}

namespace SqrtPriceMathTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    // @notice Gets the next sqrt price given a delta of token0
    // @dev Always rounds up, because in the exact output case (increasing price) we need to move the price at least
    // far enough to get the desired output amount, and in the exact input case (decreasing price) we need to move the
    // price less in order to not send too much output.
    // The most precise formula for this is liquidity * sqrtPX96 / (liquidity +- amount * sqrtPX96),
    // if this is impossible because of overflow, we calculate liquidity / (liquidity / sqrtPX96 +- amount).
    // @param sqrtPX96 The starting price, i.e. before accounting for the token0 delta
    // @param liquidity The amount of usable liquidity
    // @param amount How much of token0 to add or remove from virtual reserves
    // @param add Whether to add or remove the amount of token0
    // @return The price after adding or removing amount, depending on add
    func s1___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_sqrtPX96: felt,
        __warp_usrid_09_liquidity: felt,
        __warp_usrid_10_amount: Uint256,
        __warp_usrid_11_add: felt,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (__warp_se_4) = warp_eq256(__warp_usrid_10_amount, Uint256(low=0, high=0));

        if (__warp_se_4 != 0) {
            return (__warp_usrid_08_sqrtPX96,);
        } else {
            let (__warp_se_5) = s1___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1(
                __warp_usrid_09_liquidity,
                __warp_usrid_11_add,
                __warp_usrid_10_amount,
                __warp_usrid_08_sqrtPX96,
            );

            return (__warp_se_5,);
        }
    }

    func s1___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_09_liquidity: felt,
        __warp_usrid_11_add: felt,
        __warp_usrid_10_amount: Uint256,
        __warp_usrid_08_sqrtPX96: felt,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (__warp_se_6) = warp_uint256(__warp_usrid_09_liquidity);

        let (__warp_usrid_13_numerator1) = warp_shl256(__warp_se_6, 96);

        if (__warp_usrid_11_add != 0) {
            let __warp_usrid_14_product = Uint256(low=0, high=0);

            let (__warp_se_7) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_8) = warp_mul_unsafe256(__warp_usrid_10_amount, __warp_se_7);

            let __warp_se_9 = __warp_se_8;

            let __warp_usrid_14_product = __warp_se_9;

            let (__warp_se_10) = warp_div_unsafe256(__warp_se_9, __warp_usrid_10_amount);

            let (__warp_se_11) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_12) = warp_eq256(__warp_se_10, __warp_se_11);

            if (__warp_se_12 != 0) {
                let (__warp_usrid_15_denominator) = warp_add_unsafe256(
                    __warp_usrid_13_numerator1, __warp_usrid_14_product
                );

                let (__warp_se_13) = warp_ge256(
                    __warp_usrid_15_denominator, __warp_usrid_13_numerator1
                );

                if (__warp_se_13 != 0) {
                    let (__warp_se_14) = warp_uint256(__warp_usrid_08_sqrtPX96);

                    let (__warp_se_15) = s2___warp_usrfn_01_mulDivRoundingUp(
                        __warp_usrid_13_numerator1, __warp_se_14, __warp_usrid_15_denominator
                    );

                    let (__warp_se_16) = warp_int256_to_int160(__warp_se_15);

                    return (__warp_se_16,);
                } else {
                    let (
                        __warp_se_17
                    ) = s1___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part3(
                        __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
                    );

                    return (__warp_se_17,);
                }
            } else {
                let (
                    __warp_se_18
                ) = s1___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2(
                    __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
                );

                return (__warp_se_18,);
            }
        } else {
            let __warp_usrid_16_product = Uint256(low=0, high=0);

            let (__warp_se_19) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_20) = warp_mul_unsafe256(__warp_usrid_10_amount, __warp_se_19);

            let __warp_se_21 = __warp_se_20;

            let __warp_usrid_16_product = __warp_se_21;

            let (__warp_se_22) = warp_div_unsafe256(__warp_se_21, __warp_usrid_10_amount);

            let (__warp_se_23) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_24) = warp_eq256(__warp_se_22, __warp_se_23);

            let (__warp_se_25) = warp_gt256(__warp_usrid_13_numerator1, __warp_usrid_16_product);

            let (__warp_se_26) = warp_and_(__warp_se_24, __warp_se_25);

            assert __warp_se_26 = 1;

            let (__warp_usrid_17_denominator) = warp_sub_unsafe256(
                __warp_usrid_13_numerator1, __warp_usrid_16_product
            );

            let (__warp_se_27) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_28) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_usrid_13_numerator1, __warp_se_27, __warp_usrid_17_denominator
            );

            let (__warp_se_29) = s5___warp_usrfn_00_toUint160(__warp_se_28);

            return (__warp_se_29,);
        }
    }

    func s1___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_13_numerator1: Uint256,
        __warp_usrid_08_sqrtPX96: felt,
        __warp_usrid_10_amount: Uint256,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (
            __warp_se_30
        ) = s1___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2(
            __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
        );

        return (__warp_se_30,);
    }

    func s1___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_13_numerator1: Uint256,
        __warp_usrid_08_sqrtPX96: felt,
        __warp_usrid_10_amount: Uint256,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (__warp_se_31) = warp_uint256(__warp_usrid_08_sqrtPX96);

        let (__warp_se_32) = warp_div256(__warp_usrid_13_numerator1, __warp_se_31);

        let (__warp_se_33) = s4___warp_usrfn_00_add(__warp_se_32, __warp_usrid_10_amount);

        let (__warp_se_34) = s3___warp_usrfn_00_divRoundingUp(
            __warp_usrid_13_numerator1, __warp_se_33
        );

        let (__warp_se_35) = warp_int256_to_int160(__warp_se_34);

        return (__warp_se_35,);
    }

    // @notice Gets the next sqrt price given a delta of token1
    // @dev Always rounds down, because in the exact output case (decreasing price) we need to move the price at least
    // far enough to get the desired output amount, and in the exact input case (increasing price) we need to move the
    // price less in order to not send too much output.
    // The formula we compute is within <1 wei of the lossless version: sqrtPX96 +- amount / liquidity
    // @param sqrtPX96 The starting price, i.e., before accounting for the token1 delta
    // @param liquidity The amount of usable liquidity
    // @param amount How much of token1 to add, or remove, from virtual reserves
    // @param add Whether to add, or remove, the amount of token1
    // @return The price after adding or removing `amount`
    func s1___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_18_sqrtPX96: felt,
        __warp_usrid_19_liquidity: felt,
        __warp_usrid_20_amount: Uint256,
        __warp_usrid_21_add: felt,
    ) -> (__warp_usrid_22_: felt) {
        alloc_locals;

        if (__warp_usrid_21_add != 0) {
            let __warp_usrid_23_quotient = Uint256(low=0, high=0);

            let (__warp_se_36) = warp_uint256(1461501637330902918203684832716283019655932542975);

            let (__warp_se_37) = warp_le256(__warp_usrid_20_amount, __warp_se_36);

            if (__warp_se_37 != 0) {
                let (__warp_se_38) = warp_shl256(__warp_usrid_20_amount, 96);

                let (__warp_se_39) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_40) = warp_div_unsafe256(__warp_se_38, __warp_se_39);

                let __warp_usrid_23_quotient = __warp_se_40;

                let (
                    __warp_se_41
                ) = s1___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_23_quotient
                );

                return (__warp_se_41,);
            } else {
                let (__warp_se_42) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_43) = s2___warp_usrfn_00_mulDiv(
                    __warp_usrid_20_amount,
                    Uint256(low=79228162514264337593543950336, high=0),
                    __warp_se_42,
                );

                let __warp_usrid_23_quotient = __warp_se_43;

                let (
                    __warp_se_44
                ) = s1___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_23_quotient
                );

                return (__warp_se_44,);
            }
        } else {
            let __warp_usrid_24_quotient = Uint256(low=0, high=0);

            let (__warp_se_45) = warp_uint256(1461501637330902918203684832716283019655932542975);

            let (__warp_se_46) = warp_le256(__warp_usrid_20_amount, __warp_se_45);

            if (__warp_se_46 != 0) {
                let (__warp_se_47) = warp_shl256(__warp_usrid_20_amount, 96);

                let (__warp_se_48) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_49) = s3___warp_usrfn_00_divRoundingUp(__warp_se_47, __warp_se_48);

                let __warp_usrid_24_quotient = __warp_se_49;

                let (
                    __warp_se_50
                ) = s1___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_24_quotient
                );

                return (__warp_se_50,);
            } else {
                let (__warp_se_51) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_52) = s2___warp_usrfn_01_mulDivRoundingUp(
                    __warp_usrid_20_amount,
                    Uint256(low=79228162514264337593543950336, high=0),
                    __warp_se_51,
                );

                let __warp_usrid_24_quotient = __warp_se_52;

                let (
                    __warp_se_53
                ) = s1___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_24_quotient
                );

                return (__warp_se_53,);
            }
        }
    }

    func s1___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_18_sqrtPX96: felt, __warp_usrid_24_quotient: Uint256) -> (
        __warp_usrid_22_: felt
    ) {
        alloc_locals;

        let (__warp_se_54) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_55) = warp_gt256(__warp_se_54, __warp_usrid_24_quotient);

        assert __warp_se_55 = 1;

        let (__warp_se_56) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_57) = warp_sub256(__warp_se_56, __warp_usrid_24_quotient);

        let (__warp_se_58) = warp_int256_to_int160(__warp_se_57);

        return (__warp_se_58,);
    }

    func s1___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_18_sqrtPX96: felt, __warp_usrid_23_quotient: Uint256) -> (
        __warp_usrid_22_: felt
    ) {
        alloc_locals;

        let (__warp_se_59) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_60) = s4___warp_usrfn_00_add(__warp_se_59, __warp_usrid_23_quotient);

        let (__warp_se_61) = s5___warp_usrfn_00_toUint160(__warp_se_60);

        return (__warp_se_61,);
    }

    // @notice Gets the next sqrt price given an input amount of token0 or token1
    // @dev Throws if price or liquidity are 0, or if the next price is out of bounds
    // @param sqrtPX96 The starting price, i.e., before accounting for the input amount
    // @param liquidity The amount of usable liquidity
    // @param amountIn How much of token0, or token1, is being swapped in
    // @param zeroForOne Whether the amount in is token0 or token1
    // @return sqrtQX96 The price after adding the input amount to token0 or token1
    func s1___warp_usrfn_02_getNextSqrtPriceFromInput{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_25_sqrtPX96: felt,
        __warp_usrid_26_liquidity: felt,
        __warp_usrid_27_amountIn: Uint256,
        __warp_usrid_28_zeroForOne: felt,
    ) -> (__warp_usrid_29_sqrtQX96: felt) {
        alloc_locals;

        let (__warp_se_62) = warp_gt(__warp_usrid_25_sqrtPX96, 0);

        assert __warp_se_62 = 1;

        let (__warp_se_63) = warp_gt(__warp_usrid_26_liquidity, 0);

        assert __warp_se_63 = 1;

        if (__warp_usrid_28_zeroForOne != 0) {
            let (__warp_se_64) = s1___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp(
                __warp_usrid_25_sqrtPX96, __warp_usrid_26_liquidity, __warp_usrid_27_amountIn, 1
            );

            return (__warp_se_64,);
        } else {
            let (__warp_se_65) = s1___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown(
                __warp_usrid_25_sqrtPX96, __warp_usrid_26_liquidity, __warp_usrid_27_amountIn, 1
            );

            return (__warp_se_65,);
        }
    }

    // @notice Gets the next sqrt price given an output amount of token0 or token1
    // @dev Throws if price or liquidity are 0 or the next price is out of bounds
    // @param sqrtPX96 The starting price before accounting for the output amount
    // @param liquidity The amount of usable liquidity
    // @param amountOut How much of token0, or token1, is being swapped out
    // @param zeroForOne Whether the amount out is token0 or token1
    // @return sqrtQX96 The price after removing the output amount of token0 or token1
    func s1___warp_usrfn_03_getNextSqrtPriceFromOutput{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_30_sqrtPX96: felt,
        __warp_usrid_31_liquidity: felt,
        __warp_usrid_32_amountOut: Uint256,
        __warp_usrid_33_zeroForOne: felt,
    ) -> (__warp_usrid_34_sqrtQX96: felt) {
        alloc_locals;

        let (__warp_se_66) = warp_gt(__warp_usrid_30_sqrtPX96, 0);

        assert __warp_se_66 = 1;

        let (__warp_se_67) = warp_gt(__warp_usrid_31_liquidity, 0);

        assert __warp_se_67 = 1;

        if (__warp_usrid_33_zeroForOne != 0) {
            let (__warp_se_68) = s1___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown(
                __warp_usrid_30_sqrtPX96, __warp_usrid_31_liquidity, __warp_usrid_32_amountOut, 0
            );

            return (__warp_se_68,);
        } else {
            let (__warp_se_69) = s1___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp(
                __warp_usrid_30_sqrtPX96, __warp_usrid_31_liquidity, __warp_usrid_32_amountOut, 0
            );

            return (__warp_se_69,);
        }
    }

    // @notice Gets the amount0 delta between two prices
    // @dev Calculates liquidity / sqrt(lower) - liquidity / sqrt(upper),
    // i.e. liquidity * (sqrt(upper) - sqrt(lower)) / (sqrt(upper) * sqrt(lower))
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The amount of usable liquidity
    // @param roundUp Whether to round the amount up or down
    // @return amount0 Amount of token0 required to cover a position of size liquidity between the two passed prices
    func s1___warp_usrfn_04_getAmount0Delta{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_35_sqrtRatioAX96: felt,
        __warp_usrid_36_sqrtRatioBX96: felt,
        __warp_usrid_37_liquidity: felt,
        __warp_usrid_38_roundUp: felt,
    ) -> (__warp_usrid_39_amount0: Uint256) {
        alloc_locals;

        let (__warp_se_70) = warp_gt(__warp_usrid_35_sqrtRatioAX96, __warp_usrid_36_sqrtRatioBX96);

        if (__warp_se_70 != 0) {
            let __warp_tv_0 = __warp_usrid_36_sqrtRatioBX96;

            let __warp_tv_1 = __warp_usrid_35_sqrtRatioAX96;

            let __warp_usrid_36_sqrtRatioBX96 = __warp_tv_1;

            let __warp_usrid_35_sqrtRatioAX96 = __warp_tv_0;

            let (__warp_se_71) = s1___warp_usrfn_04_getAmount0Delta_if_part1(
                __warp_usrid_37_liquidity,
                __warp_usrid_36_sqrtRatioBX96,
                __warp_usrid_35_sqrtRatioAX96,
                __warp_usrid_38_roundUp,
            );

            return (__warp_se_71,);
        } else {
            let (__warp_se_72) = s1___warp_usrfn_04_getAmount0Delta_if_part1(
                __warp_usrid_37_liquidity,
                __warp_usrid_36_sqrtRatioBX96,
                __warp_usrid_35_sqrtRatioAX96,
                __warp_usrid_38_roundUp,
            );

            return (__warp_se_72,);
        }
    }

    func s1___warp_usrfn_04_getAmount0Delta_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_37_liquidity: felt,
        __warp_usrid_36_sqrtRatioBX96: felt,
        __warp_usrid_35_sqrtRatioAX96: felt,
        __warp_usrid_38_roundUp: felt,
    ) -> (__warp_usrid_39_amount0: Uint256) {
        alloc_locals;

        let (__warp_se_73) = warp_uint256(__warp_usrid_37_liquidity);

        let (__warp_usrid_40_numerator1) = warp_shl256(__warp_se_73, 96);

        let (__warp_se_74) = warp_sub(__warp_usrid_36_sqrtRatioBX96, __warp_usrid_35_sqrtRatioAX96);

        let (__warp_usrid_41_numerator2) = warp_uint256(__warp_se_74);

        let (__warp_se_75) = warp_gt(__warp_usrid_35_sqrtRatioAX96, 0);

        assert __warp_se_75 = 1;

        if (__warp_usrid_38_roundUp != 0) {
            let (__warp_se_76) = warp_uint256(__warp_usrid_36_sqrtRatioBX96);

            let (__warp_se_77) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_usrid_40_numerator1, __warp_usrid_41_numerator2, __warp_se_76
            );

            let (__warp_se_78) = warp_uint256(__warp_usrid_35_sqrtRatioAX96);

            let (__warp_se_79) = s3___warp_usrfn_00_divRoundingUp(__warp_se_77, __warp_se_78);

            return (__warp_se_79,);
        } else {
            let (__warp_se_80) = warp_uint256(__warp_usrid_36_sqrtRatioBX96);

            let (__warp_se_81) = s2___warp_usrfn_00_mulDiv(
                __warp_usrid_40_numerator1, __warp_usrid_41_numerator2, __warp_se_80
            );

            let (__warp_se_82) = warp_uint256(__warp_usrid_35_sqrtRatioAX96);

            let (__warp_se_83) = warp_div256(__warp_se_81, __warp_se_82);

            return (__warp_se_83,);
        }
    }

    // @notice Gets the amount1 delta between two prices
    // @dev Calculates liquidity * (sqrt(upper) - sqrt(lower))
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The amount of usable liquidity
    // @param roundUp Whether to round the amount up, or down
    // @return amount1 Amount of token1 required to cover a position of size liquidity between the two passed prices
    func s1___warp_usrfn_05_getAmount1Delta{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_42_sqrtRatioAX96: felt,
        __warp_usrid_43_sqrtRatioBX96: felt,
        __warp_usrid_44_liquidity: felt,
        __warp_usrid_45_roundUp: felt,
    ) -> (__warp_usrid_46_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_84) = warp_gt(__warp_usrid_42_sqrtRatioAX96, __warp_usrid_43_sqrtRatioBX96);

        if (__warp_se_84 != 0) {
            let __warp_tv_2 = __warp_usrid_43_sqrtRatioBX96;

            let __warp_tv_3 = __warp_usrid_42_sqrtRatioAX96;

            let __warp_usrid_43_sqrtRatioBX96 = __warp_tv_3;

            let __warp_usrid_42_sqrtRatioAX96 = __warp_tv_2;

            let (__warp_se_85) = s1___warp_usrfn_05_getAmount1Delta_if_part1(
                __warp_usrid_45_roundUp,
                __warp_usrid_44_liquidity,
                __warp_usrid_43_sqrtRatioBX96,
                __warp_usrid_42_sqrtRatioAX96,
            );

            return (__warp_se_85,);
        } else {
            let (__warp_se_86) = s1___warp_usrfn_05_getAmount1Delta_if_part1(
                __warp_usrid_45_roundUp,
                __warp_usrid_44_liquidity,
                __warp_usrid_43_sqrtRatioBX96,
                __warp_usrid_42_sqrtRatioAX96,
            );

            return (__warp_se_86,);
        }
    }

    func s1___warp_usrfn_05_getAmount1Delta_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_45_roundUp: felt,
        __warp_usrid_44_liquidity: felt,
        __warp_usrid_43_sqrtRatioBX96: felt,
        __warp_usrid_42_sqrtRatioAX96: felt,
    ) -> (__warp_usrid_46_amount1: Uint256) {
        alloc_locals;

        if (__warp_usrid_45_roundUp != 0) {
            let (__warp_se_87) = warp_uint256(__warp_usrid_44_liquidity);

            let (__warp_se_88) = warp_sub(
                __warp_usrid_43_sqrtRatioBX96, __warp_usrid_42_sqrtRatioAX96
            );

            let (__warp_se_89) = warp_uint256(__warp_se_88);

            let (__warp_se_90) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_se_87, __warp_se_89, Uint256(low=79228162514264337593543950336, high=0)
            );

            return (__warp_se_90,);
        } else {
            let (__warp_se_91) = warp_uint256(__warp_usrid_44_liquidity);

            let (__warp_se_92) = warp_sub(
                __warp_usrid_43_sqrtRatioBX96, __warp_usrid_42_sqrtRatioAX96
            );

            let (__warp_se_93) = warp_uint256(__warp_se_92);

            let (__warp_se_94) = s2___warp_usrfn_00_mulDiv(
                __warp_se_91, __warp_se_93, Uint256(low=79228162514264337593543950336, high=0)
            );

            return (__warp_se_94,);
        }
    }

    // @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    // @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
    func s2___warp_usrfn_00_mulDiv{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_02_a: Uint256, __warp_usrid_03_b: Uint256, __warp_usrid_04_denominator: Uint256
    ) -> (__warp_usrid_05_result: Uint256) {
        alloc_locals;

        let __warp_usrid_05_result = Uint256(low=0, high=0);

        let __warp_usrid_06_prod0 = Uint256(low=0, high=0);

        let (__warp_se_95) = warp_mul_unsafe256(__warp_usrid_02_a, __warp_usrid_03_b);

        let __warp_usrid_06_prod0 = __warp_se_95;

        let (__warp_usrid_07_mm) = warp_mulmod(
            __warp_usrid_02_a,
            __warp_usrid_03_b,
            Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        );

        let __warp_usrid_08_prod1 = Uint256(low=0, high=0);

        let (__warp_se_96) = warp_sub_unsafe256(__warp_usrid_07_mm, __warp_usrid_06_prod0);

        let __warp_usrid_08_prod1 = __warp_se_96;

        let (__warp_se_97) = warp_lt256(__warp_usrid_07_mm, __warp_usrid_06_prod0);

        if (__warp_se_97 != 0) {
            let (__warp_se_98) = warp_sub_unsafe256(__warp_usrid_08_prod1, Uint256(low=1, high=0));

            let __warp_usrid_08_prod1 = __warp_se_98;

            let (__warp_se_99) = s2___warp_usrfn_00_mulDiv_if_part1(
                __warp_usrid_08_prod1,
                __warp_usrid_04_denominator,
                __warp_usrid_05_result,
                __warp_usrid_06_prod0,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
            );

            return (__warp_se_99,);
        } else {
            let (__warp_se_100) = s2___warp_usrfn_00_mulDiv_if_part1(
                __warp_usrid_08_prod1,
                __warp_usrid_04_denominator,
                __warp_usrid_05_result,
                __warp_usrid_06_prod0,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
            );

            return (__warp_se_100,);
        }
    }

    func s2___warp_usrfn_00_mulDiv_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_08_prod1: Uint256,
        __warp_usrid_04_denominator: Uint256,
        __warp_usrid_05_result: Uint256,
        __warp_usrid_06_prod0: Uint256,
        __warp_usrid_02_a: Uint256,
        __warp_usrid_03_b: Uint256,
    ) -> (__warp_usrid_05_result: Uint256) {
        alloc_locals;

        let (__warp_se_101) = warp_eq256(__warp_usrid_08_prod1, Uint256(low=0, high=0));

        if (__warp_se_101 != 0) {
            let (__warp_se_102) = warp_gt256(__warp_usrid_04_denominator, Uint256(low=0, high=0));

            assert __warp_se_102 = 1;

            let (__warp_se_103) = warp_div_unsafe256(
                __warp_usrid_06_prod0, __warp_usrid_04_denominator
            );

            let __warp_usrid_05_result = __warp_se_103;

            return (__warp_usrid_05_result,);
        } else {
            let (__warp_se_104) = s2___warp_usrfn_00_mulDiv_if_part1_if_part1(
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
                __warp_usrid_06_prod0,
                __warp_usrid_05_result,
            );

            return (__warp_se_104,);
        }
    }

    func s2___warp_usrfn_00_mulDiv_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_04_denominator: Uint256,
        __warp_usrid_08_prod1: Uint256,
        __warp_usrid_02_a: Uint256,
        __warp_usrid_03_b: Uint256,
        __warp_usrid_06_prod0: Uint256,
        __warp_usrid_05_result: Uint256,
    ) -> (__warp_usrid_05_result: Uint256) {
        alloc_locals;

        let (__warp_se_105) = warp_gt256(__warp_usrid_04_denominator, __warp_usrid_08_prod1);

        assert __warp_se_105 = 1;

        let __warp_usrid_09_remainder = Uint256(low=0, high=0);

        let (__warp_se_106) = warp_mulmod(
            __warp_usrid_02_a, __warp_usrid_03_b, __warp_usrid_04_denominator
        );

        let __warp_usrid_09_remainder = __warp_se_106;

        let (__warp_se_107) = warp_gt256(__warp_usrid_09_remainder, __warp_usrid_06_prod0);

        if (__warp_se_107 != 0) {
            let (__warp_se_108) = warp_sub_unsafe256(__warp_usrid_08_prod1, Uint256(low=1, high=0));

            let __warp_usrid_08_prod1 = __warp_se_108;

            let (__warp_se_109) = s2___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1(
                __warp_usrid_06_prod0,
                __warp_usrid_09_remainder,
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_05_result,
            );

            return (__warp_se_109,);
        } else {
            let (__warp_se_110) = s2___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1(
                __warp_usrid_06_prod0,
                __warp_usrid_09_remainder,
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_05_result,
            );

            return (__warp_se_110,);
        }
    }

    func s2___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_prod0: Uint256,
        __warp_usrid_09_remainder: Uint256,
        __warp_usrid_04_denominator: Uint256,
        __warp_usrid_08_prod1: Uint256,
        __warp_usrid_05_result: Uint256,
    ) -> (__warp_usrid_05_result: Uint256) {
        alloc_locals;

        let (__warp_se_111) = warp_sub_unsafe256(__warp_usrid_06_prod0, __warp_usrid_09_remainder);

        let __warp_usrid_06_prod0 = __warp_se_111;

        let (__warp_se_112) = warp_negate256(__warp_usrid_04_denominator);

        let (__warp_usrid_10_twos) = warp_bitwise_and256(
            __warp_se_112, __warp_usrid_04_denominator
        );

        let (__warp_se_113) = warp_div_unsafe256(__warp_usrid_04_denominator, __warp_usrid_10_twos);

        let __warp_usrid_04_denominator = __warp_se_113;

        let (__warp_se_114) = warp_div_unsafe256(__warp_usrid_06_prod0, __warp_usrid_10_twos);

        let __warp_usrid_06_prod0 = __warp_se_114;

        let (__warp_se_115) = warp_sub_unsafe256(Uint256(low=0, high=0), __warp_usrid_10_twos);

        let (__warp_se_116) = warp_div_unsafe256(__warp_se_115, __warp_usrid_10_twos);

        let (__warp_se_117) = warp_add_unsafe256(__warp_se_116, Uint256(low=1, high=0));

        let __warp_usrid_10_twos = __warp_se_117;

        let (__warp_se_118) = warp_mul_unsafe256(__warp_usrid_08_prod1, __warp_usrid_10_twos);

        let (__warp_se_119) = warp_bitwise_or256(__warp_usrid_06_prod0, __warp_se_118);

        let __warp_usrid_06_prod0 = __warp_se_119;

        let (__warp_se_120) = warp_mul_unsafe256(
            Uint256(low=3, high=0), __warp_usrid_04_denominator
        );

        let (__warp_usrid_11_inv) = warp_xor256(__warp_se_120, Uint256(low=2, high=0));

        let (__warp_se_121) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_122) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_121);

        let (__warp_se_123) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_122);

        let __warp_usrid_11_inv = __warp_se_123;

        let (__warp_se_124) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_125) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_124);

        let (__warp_se_126) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_125);

        let __warp_usrid_11_inv = __warp_se_126;

        let (__warp_se_127) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_128) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_127);

        let (__warp_se_129) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_128);

        let __warp_usrid_11_inv = __warp_se_129;

        let (__warp_se_130) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_131) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_130);

        let (__warp_se_132) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_131);

        let __warp_usrid_11_inv = __warp_se_132;

        let (__warp_se_133) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_134) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_133);

        let (__warp_se_135) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_134);

        let __warp_usrid_11_inv = __warp_se_135;

        let (__warp_se_136) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_137) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_136);

        let (__warp_se_138) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_137);

        let __warp_usrid_11_inv = __warp_se_138;

        let (__warp_se_139) = warp_mul_unsafe256(__warp_usrid_06_prod0, __warp_usrid_11_inv);

        let __warp_usrid_05_result = __warp_se_139;

        return (__warp_usrid_05_result,);
    }

    // @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    func s2___warp_usrfn_01_mulDivRoundingUp{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_12_a: Uint256, __warp_usrid_13_b: Uint256, __warp_usrid_14_denominator: Uint256
    ) -> (__warp_usrid_15_result: Uint256) {
        alloc_locals;

        let __warp_usrid_15_result = Uint256(low=0, high=0);

        let (__warp_se_140) = s2___warp_usrfn_00_mulDiv(
            __warp_usrid_12_a, __warp_usrid_13_b, __warp_usrid_14_denominator
        );

        let __warp_usrid_15_result = __warp_se_140;

        let (__warp_se_141) = warp_mulmod(
            __warp_usrid_12_a, __warp_usrid_13_b, __warp_usrid_14_denominator
        );

        let (__warp_se_142) = warp_gt256(__warp_se_141, Uint256(low=0, high=0));

        if (__warp_se_142 != 0) {
            let (__warp_se_143) = warp_lt256(
                __warp_usrid_15_result,
                Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
            );

            assert __warp_se_143 = 1;

            let (__warp_se_144) = warp_add_unsafe256(
                __warp_usrid_15_result, Uint256(low=1, high=0)
            );

            let __warp_se_145 = __warp_se_144;

            let __warp_usrid_15_result = __warp_se_145;

            warp_sub_unsafe256(__warp_se_145, Uint256(low=1, high=0));

            let (__warp_se_146) = s2___warp_usrfn_01_mulDivRoundingUp_if_part1(
                __warp_usrid_15_result
            );

            return (__warp_se_146,);
        } else {
            let (__warp_se_147) = s2___warp_usrfn_01_mulDivRoundingUp_if_part1(
                __warp_usrid_15_result
            );

            return (__warp_se_147,);
        }
    }

    func s2___warp_usrfn_01_mulDivRoundingUp_if_part1(__warp_usrid_15_result: Uint256) -> (
        __warp_usrid_15_result: Uint256
    ) {
        alloc_locals;

        return (__warp_usrid_15_result,);
    }

    // @notice Returns ceil(x / y)
    // @dev division by 0 has unspecified behavior, and must be checked externally
    // @param x The dividend
    // @param y The divisor
    // @return z The quotient, ceil(x / y)
    func s3___warp_usrfn_00_divRoundingUp{range_check_ptr: felt}(
        __warp_usrid_01_x: Uint256, __warp_usrid_02_y: Uint256
    ) -> (__warp_usrid_03_z: Uint256) {
        alloc_locals;

        let __warp_usrid_03_z = Uint256(low=0, high=0);

        let __warp_usrid_04_temp = Uint256(low=0, high=0);

        let (__warp_se_148) = warp_mod256(__warp_usrid_01_x, __warp_usrid_02_y);

        let (__warp_se_149) = warp_gt256(__warp_se_148, Uint256(low=0, high=0));

        if (__warp_se_149 != 0) {
            let __warp_usrid_04_temp = Uint256(low=1, high=0);

            let (__warp_se_150) = s3___warp_usrfn_00_divRoundingUp_if_part1(
                __warp_usrid_03_z, __warp_usrid_01_x, __warp_usrid_02_y, __warp_usrid_04_temp
            );

            return (__warp_se_150,);
        } else {
            let (__warp_se_151) = s3___warp_usrfn_00_divRoundingUp_if_part1(
                __warp_usrid_03_z, __warp_usrid_01_x, __warp_usrid_02_y, __warp_usrid_04_temp
            );

            return (__warp_se_151,);
        }
    }

    func s3___warp_usrfn_00_divRoundingUp_if_part1{range_check_ptr: felt}(
        __warp_usrid_03_z: Uint256,
        __warp_usrid_01_x: Uint256,
        __warp_usrid_02_y: Uint256,
        __warp_usrid_04_temp: Uint256,
    ) -> (__warp_usrid_03_z: Uint256) {
        alloc_locals;

        let (__warp_se_152) = warp_div_unsafe256(__warp_usrid_01_x, __warp_usrid_02_y);

        let (__warp_se_153) = warp_add_unsafe256(__warp_se_152, __warp_usrid_04_temp);

        let __warp_usrid_03_z = __warp_se_153;

        return (__warp_usrid_03_z,);
    }

    // @notice Returns x + y, reverts if sum overflows uint256
    // @param x The augend
    // @param y The addend
    // @return z The sum of x and y
    func s4___warp_usrfn_00_add{range_check_ptr: felt}(
        __warp_usrid_05_x: Uint256, __warp_usrid_06_y: Uint256
    ) -> (__warp_usrid_07_z: Uint256) {
        alloc_locals;

        let __warp_usrid_07_z = Uint256(low=0, high=0);

        let (__warp_se_154) = warp_add256(__warp_usrid_05_x, __warp_usrid_06_y);

        let __warp_se_155 = __warp_se_154;

        let __warp_usrid_07_z = __warp_se_155;

        let (__warp_se_156) = warp_ge256(__warp_se_155, __warp_usrid_05_x);

        assert __warp_se_156 = 1;

        return (__warp_usrid_07_z,);
    }

    // @notice Cast a uint256 to a uint160, revert on overflow
    // @param y The uint256 to be downcasted
    // @return z The downcasted integer, now type uint160
    func s5___warp_usrfn_00_toUint160{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_03_y: Uint256
    ) -> (__warp_usrid_04_z: felt) {
        alloc_locals;

        let __warp_usrid_04_z = 0;

        let (__warp_se_157) = warp_int256_to_int160(__warp_usrid_03_y);

        let __warp_se_158 = __warp_se_157;

        let __warp_usrid_04_z = __warp_se_158;

        let (__warp_se_159) = warp_uint256(__warp_se_158);

        let (__warp_se_160) = warp_eq256(__warp_se_159, __warp_usrid_03_y);

        assert __warp_se_160 = 1;

        return (__warp_usrid_04_z,);
    }
}

@view
func getNextSqrtPriceFromInput_aa58276a{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_00_sqrtP: felt,
    __warp_usrid_01_liquidity: felt,
    __warp_usrid_02_amountIn: Uint256,
    __warp_usrid_03_zeroForOne: felt,
) -> (__warp_usrid_04_sqrtQ: felt) {
    alloc_locals;

    warp_external_input_check_bool(__warp_usrid_03_zeroForOne);

    warp_external_input_check_int256(__warp_usrid_02_amountIn);

    warp_external_input_check_int128(__warp_usrid_01_liquidity);

    warp_external_input_check_int160(__warp_usrid_00_sqrtP);

    let (__warp_se_0) = SqrtPriceMathTest.s1___warp_usrfn_02_getNextSqrtPriceFromInput(
        __warp_usrid_00_sqrtP,
        __warp_usrid_01_liquidity,
        __warp_usrid_02_amountIn,
        __warp_usrid_03_zeroForOne,
    );

    return (__warp_se_0,);
}

@view
func getNextSqrtPriceFromOutput_fedf2b5f{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_05_sqrtP: felt,
    __warp_usrid_06_liquidity: felt,
    __warp_usrid_07_amountOut: Uint256,
    __warp_usrid_08_zeroForOne: felt,
) -> (__warp_usrid_09_sqrtQ: felt) {
    alloc_locals;

    warp_external_input_check_bool(__warp_usrid_08_zeroForOne);

    warp_external_input_check_int256(__warp_usrid_07_amountOut);

    warp_external_input_check_int128(__warp_usrid_06_liquidity);

    warp_external_input_check_int160(__warp_usrid_05_sqrtP);

    let (__warp_se_1) = SqrtPriceMathTest.s1___warp_usrfn_03_getNextSqrtPriceFromOutput(
        __warp_usrid_05_sqrtP,
        __warp_usrid_06_liquidity,
        __warp_usrid_07_amountOut,
        __warp_usrid_08_zeroForOne,
    );

    return (__warp_se_1,);
}

@view
func getAmount0Delta_2c32d4b6{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_10_sqrtLower: felt,
    __warp_usrid_11_sqrtUpper: felt,
    __warp_usrid_12_liquidity: felt,
    __warp_usrid_13_roundUp: felt,
) -> (__warp_usrid_14_amount0: Uint256) {
    alloc_locals;

    warp_external_input_check_bool(__warp_usrid_13_roundUp);

    warp_external_input_check_int128(__warp_usrid_12_liquidity);

    warp_external_input_check_int160(__warp_usrid_11_sqrtUpper);

    warp_external_input_check_int160(__warp_usrid_10_sqrtLower);

    let (__warp_se_2) = SqrtPriceMathTest.s1___warp_usrfn_04_getAmount0Delta(
        __warp_usrid_10_sqrtLower,
        __warp_usrid_11_sqrtUpper,
        __warp_usrid_12_liquidity,
        __warp_usrid_13_roundUp,
    );

    return (__warp_se_2,);
}

@view
func getAmount1Delta_48a0c5bd{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_15_sqrtLower: felt,
    __warp_usrid_16_sqrtUpper: felt,
    __warp_usrid_17_liquidity: felt,
    __warp_usrid_18_roundUp: felt,
) -> (__warp_usrid_19_amount1: Uint256) {
    alloc_locals;

    warp_external_input_check_bool(__warp_usrid_18_roundUp);

    warp_external_input_check_int128(__warp_usrid_17_liquidity);

    warp_external_input_check_int160(__warp_usrid_16_sqrtUpper);

    warp_external_input_check_int160(__warp_usrid_15_sqrtLower);

    let (__warp_se_3) = SqrtPriceMathTest.s1___warp_usrfn_05_getAmount1Delta(
        __warp_usrid_15_sqrtLower,
        __warp_usrid_16_sqrtUpper,
        __warp_usrid_17_liquidity,
        __warp_usrid_18_roundUp,
    );

    return (__warp_se_3,);
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","getNextSqrtPriceFromInput(uint160,uint128,uint256,bool)","getNextSqrtPriceFromOutput(uint160,uint128,uint256,bool)","getAmount0Delta(uint160,uint160,uint128,bool)","getAmount1Delta(uint160,uint160,uint128,bool)"]
