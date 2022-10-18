%lang starknet

from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int160,
    warp_external_input_check_int128,
    warp_external_input_check_int256,
    warp_external_input_check_int24,
)
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.gt import warp_gt, warp_gt256
from warplib.maths.lt import warp_lt, warp_lt256
from warplib.maths.sub import warp_sub256, warp_sub
from warplib.maths.le import warp_le256, warp_le
from warplib.maths.lt_signed import warp_lt_signed256
from warplib.maths.negate import warp_negate256
from warplib.maths.add import warp_add256
from warplib.maths.eq import warp_eq, warp_eq256
from warplib.maths.neq import warp_neq
from warplib.maths.ge import warp_ge, warp_ge256
from warplib.maths.ge_signed import warp_ge_signed256
from warplib.maths.int_conversions import warp_uint256, warp_int256_to_int160
from warplib.maths.and_ import warp_and_
from warplib.maths.mul_unsafe import warp_mul_unsafe256
from warplib.maths.mulmod import warp_mulmod
from warplib.maths.sub_unsafe import warp_sub_unsafe256
from warplib.maths.div_unsafe import warp_div_unsafe256
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.add_unsafe import warp_add_unsafe256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.xor import warp_xor256
from warplib.maths.shl import warp_shl256
from warplib.maths.div import warp_div256
from warplib.maths.mod import warp_mod256

// Contract Def SwapMathEchidnaTest

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

namespace SwapMathEchidnaTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    func checkComputeSwapStepInvariants_d7e3056f_if_part1{range_check_ptr: felt}(
        __warp_usrid_00_sqrtPriceRaw: felt,
        __warp_usrid_01_sqrtPriceTargetRaw: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_05_sqrtQ: felt,
        __warp_usrid_03_amountRemaining: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_11) = warp_eq(
            __warp_usrid_00_sqrtPriceRaw, __warp_usrid_01_sqrtPriceTargetRaw
        );

        if (__warp_se_11 != 0) {
            let (__warp_se_12) = warp_eq256(__warp_usrid_06_amountIn, Uint256(low=0, high=0));

            assert __warp_se_12 = 1;

            let (__warp_se_13) = warp_eq256(__warp_usrid_07_amountOut, Uint256(low=0, high=0));

            assert __warp_se_13 = 1;

            let (__warp_se_14) = warp_eq256(__warp_usrid_08_feeAmount, Uint256(low=0, high=0));

            assert __warp_se_14 = 1;

            let (__warp_se_15) = warp_eq(__warp_usrid_05_sqrtQ, __warp_usrid_01_sqrtPriceTargetRaw);

            assert __warp_se_15 = 1;

            checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1(
                __warp_usrid_05_sqrtQ,
                __warp_usrid_01_sqrtPriceTargetRaw,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_07_amountOut,
                __warp_usrid_06_amountIn,
                __warp_usrid_08_feeAmount,
                __warp_usrid_00_sqrtPriceRaw,
            );

            return ();
        } else {
            checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1(
                __warp_usrid_05_sqrtQ,
                __warp_usrid_01_sqrtPriceTargetRaw,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_07_amountOut,
                __warp_usrid_06_amountIn,
                __warp_usrid_08_feeAmount,
                __warp_usrid_00_sqrtPriceRaw,
            );

            return ();
        }
    }

    func checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1{range_check_ptr: felt}(
        __warp_usrid_05_sqrtQ: felt,
        __warp_usrid_01_sqrtPriceTargetRaw: felt,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_00_sqrtPriceRaw: felt,
    ) -> () {
        alloc_locals;

        let (__warp_se_16) = warp_neq(__warp_usrid_05_sqrtQ, __warp_usrid_01_sqrtPriceTargetRaw);

        if (__warp_se_16 != 0) {
            let (__warp_se_17) = warp_lt_signed256(
                __warp_usrid_03_amountRemaining, Uint256(low=0, high=0)
            );

            if (__warp_se_17 != 0) {
                let (__warp_se_18) = warp_negate256(__warp_usrid_03_amountRemaining);

                let (__warp_se_19) = warp_eq256(__warp_usrid_07_amountOut, __warp_se_18);

                assert __warp_se_19 = 1;

                checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1_if_part2(
                    __warp_usrid_01_sqrtPriceTargetRaw,
                    __warp_usrid_00_sqrtPriceRaw,
                    __warp_usrid_05_sqrtQ,
                );

                return ();
            } else {
                let (__warp_se_20) = warp_add256(
                    __warp_usrid_06_amountIn, __warp_usrid_08_feeAmount
                );

                let (__warp_se_21) = warp_eq256(__warp_se_20, __warp_usrid_03_amountRemaining);

                assert __warp_se_21 = 1;

                checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1_if_part2(
                    __warp_usrid_01_sqrtPriceTargetRaw,
                    __warp_usrid_00_sqrtPriceRaw,
                    __warp_usrid_05_sqrtQ,
                );

                return ();
            }
        } else {
            checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1_if_part1(
                __warp_usrid_01_sqrtPriceTargetRaw,
                __warp_usrid_00_sqrtPriceRaw,
                __warp_usrid_05_sqrtQ,
            );

            return ();
        }
    }

    func checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1_if_part2{range_check_ptr: felt}(
        __warp_usrid_01_sqrtPriceTargetRaw: felt,
        __warp_usrid_00_sqrtPriceRaw: felt,
        __warp_usrid_05_sqrtQ: felt,
    ) -> () {
        alloc_locals;

        checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1_if_part1(
            __warp_usrid_01_sqrtPriceTargetRaw, __warp_usrid_00_sqrtPriceRaw, __warp_usrid_05_sqrtQ
        );

        return ();
    }

    func checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1_if_part1{range_check_ptr: felt}(
        __warp_usrid_01_sqrtPriceTargetRaw: felt,
        __warp_usrid_00_sqrtPriceRaw: felt,
        __warp_usrid_05_sqrtQ: felt,
    ) -> () {
        alloc_locals;

        let (__warp_se_22) = warp_le(
            __warp_usrid_01_sqrtPriceTargetRaw, __warp_usrid_00_sqrtPriceRaw
        );

        if (__warp_se_22 != 0) {
            let (__warp_se_23) = warp_le(__warp_usrid_05_sqrtQ, __warp_usrid_00_sqrtPriceRaw);

            assert __warp_se_23 = 1;

            let (__warp_se_24) = warp_ge(__warp_usrid_05_sqrtQ, __warp_usrid_01_sqrtPriceTargetRaw);

            assert __warp_se_24 = 1;

            checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1_if_part1_if_part1();

            return ();
        } else {
            let (__warp_se_25) = warp_ge(__warp_usrid_05_sqrtQ, __warp_usrid_00_sqrtPriceRaw);

            assert __warp_se_25 = 1;

            let (__warp_se_26) = warp_le(__warp_usrid_05_sqrtQ, __warp_usrid_01_sqrtPriceTargetRaw);

            assert __warp_se_26 = 1;

            checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1_if_part1_if_part1();

            return ();
        }
    }

    func checkComputeSwapStepInvariants_d7e3056f_if_part1_if_part1_if_part1_if_part1() -> () {
        alloc_locals;

        return ();
    }

    // @notice Computes the result of swapping some amount in, or amount out, given the parameters of the swap
    // @dev The fee, plus the amount in, will never exceed the amount remaining if the swap's `amountSpecified` is positive
    // @param sqrtRatioCurrentX96 The current sqrt price of the pool
    // @param sqrtRatioTargetX96 The price that cannot be exceeded, from which the direction of the swap is inferred
    // @param liquidity The usable liquidity
    // @param amountRemaining How much input or output amount is remaining to be swapped in/out
    // @param feePips The fee taken from the input amount, expressed in hundredths of a bip
    // @return sqrtRatioNextX96 The price after swapping the amount in/out, not to exceed the price target
    // @return amountIn The amount to be swapped in, of either token0 or token1, based on the direction of the swap
    // @return amountOut The amount to be received, of either token0 or token1, based on the direction of the swap
    // @return feeAmount The amount of input that will be taken as a fee
    func s1___warp_usrfn_00_computeSwapStep{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_01_sqrtRatioCurrentX96: felt,
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_03_liquidity: felt,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let __warp_usrid_09_feeAmount = Uint256(low=0, high=0);

        let __warp_usrid_08_amountOut = Uint256(low=0, high=0);

        let __warp_usrid_06_sqrtRatioNextX96 = 0;

        let __warp_usrid_07_amountIn = Uint256(low=0, high=0);

        let (__warp_usrid_10_zeroForOne) = warp_ge(
            __warp_usrid_01_sqrtRatioCurrentX96, __warp_usrid_02_sqrtRatioTargetX96
        );

        let (__warp_usrid_11_exactIn) = warp_ge_signed256(
            __warp_usrid_04_amountRemaining, Uint256(low=0, high=0)
        );

        if (__warp_usrid_11_exactIn != 0) {
            let (__warp_se_27) = warp_sub(1000000, __warp_usrid_05_feePips);

            let (__warp_se_28) = warp_uint256(__warp_se_27);

            let (__warp_usrid_12_amountRemainingLessFee) = s2___warp_usrfn_00_mulDiv(
                __warp_usrid_04_amountRemaining, __warp_se_28, Uint256(low=1000000, high=0)
            );

            if (__warp_usrid_10_zeroForOne != 0) {
                let (__warp_se_29) = s3___warp_usrfn_04_getAmount0Delta(
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    1,
                );

                let __warp_usrid_07_amountIn = __warp_se_29;

                let (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                ) = s1___warp_usrfn_00_computeSwapStep_if_part2(
                    __warp_usrid_12_amountRemainingLessFee,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    __warp_usrid_10_zeroForOne,
                    __warp_usrid_11_exactIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_04_amountRemaining,
                    __warp_usrid_09_feeAmount,
                    __warp_usrid_05_feePips,
                );

                return (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                );
            } else {
                let (__warp_se_30) = s3___warp_usrfn_05_getAmount1Delta(
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_03_liquidity,
                    1,
                );

                let __warp_usrid_07_amountIn = __warp_se_30;

                let (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                ) = s1___warp_usrfn_00_computeSwapStep_if_part2(
                    __warp_usrid_12_amountRemainingLessFee,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    __warp_usrid_10_zeroForOne,
                    __warp_usrid_11_exactIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_04_amountRemaining,
                    __warp_usrid_09_feeAmount,
                    __warp_usrid_05_feePips,
                );

                return (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                );
            }
        } else {
            if (__warp_usrid_10_zeroForOne != 0) {
                let (__warp_se_31) = s3___warp_usrfn_05_getAmount1Delta(
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    0,
                );

                let __warp_usrid_08_amountOut = __warp_se_31;

                let (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                ) = s1___warp_usrfn_00_computeSwapStep_if_part3(
                    __warp_usrid_04_amountRemaining,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    __warp_usrid_10_zeroForOne,
                    __warp_usrid_11_exactIn,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_09_feeAmount,
                    __warp_usrid_05_feePips,
                );

                return (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                );
            } else {
                let (__warp_se_32) = s3___warp_usrfn_04_getAmount0Delta(
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_03_liquidity,
                    0,
                );

                let __warp_usrid_08_amountOut = __warp_se_32;

                let (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                ) = s1___warp_usrfn_00_computeSwapStep_if_part3(
                    __warp_usrid_04_amountRemaining,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    __warp_usrid_10_zeroForOne,
                    __warp_usrid_11_exactIn,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_09_feeAmount,
                    __warp_usrid_05_feePips,
                );

                return (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                );
            }
        }
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_01_sqrtRatioCurrentX96: felt,
        __warp_usrid_03_liquidity: felt,
        __warp_usrid_10_zeroForOne: felt,
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_33) = warp_negate256(__warp_usrid_04_amountRemaining);

        let (__warp_se_34) = warp_ge256(__warp_se_33, __warp_usrid_08_amountOut);

        if (__warp_se_34 != 0) {
            let __warp_usrid_06_sqrtRatioNextX96 = __warp_usrid_02_sqrtRatioTargetX96;

            let (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            ) = s1___warp_usrfn_00_computeSwapStep_if_part3_if_part1(
                __warp_usrid_02_sqrtRatioTargetX96,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_10_zeroForOne,
                __warp_usrid_11_exactIn,
                __warp_usrid_07_amountIn,
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_03_liquidity,
                __warp_usrid_08_amountOut,
                __warp_usrid_04_amountRemaining,
                __warp_usrid_09_feeAmount,
                __warp_usrid_05_feePips,
            );

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        } else {
            let (__warp_se_35) = warp_negate256(__warp_usrid_04_amountRemaining);

            let (__warp_se_36) = s3___warp_usrfn_03_getNextSqrtPriceFromOutput(
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_03_liquidity,
                __warp_se_35,
                __warp_usrid_10_zeroForOne,
            );

            let __warp_usrid_06_sqrtRatioNextX96 = __warp_se_36;

            let (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            ) = s1___warp_usrfn_00_computeSwapStep_if_part3_if_part1(
                __warp_usrid_02_sqrtRatioTargetX96,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_10_zeroForOne,
                __warp_usrid_11_exactIn,
                __warp_usrid_07_amountIn,
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_03_liquidity,
                __warp_usrid_08_amountOut,
                __warp_usrid_04_amountRemaining,
                __warp_usrid_09_feeAmount,
                __warp_usrid_05_feePips,
            );

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        }
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part3_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_10_zeroForOne: felt,
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_01_sqrtRatioCurrentX96: felt,
        __warp_usrid_03_liquidity: felt,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_07_amountIn,
            __warp_usrid_08_amountOut,
            __warp_usrid_09_feeAmount,
        ) = s1___warp_usrfn_00_computeSwapStep_if_part1(
            __warp_usrid_02_sqrtRatioTargetX96,
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_10_zeroForOne,
            __warp_usrid_11_exactIn,
            __warp_usrid_07_amountIn,
            __warp_usrid_01_sqrtRatioCurrentX96,
            __warp_usrid_03_liquidity,
            __warp_usrid_08_amountOut,
            __warp_usrid_04_amountRemaining,
            __warp_usrid_09_feeAmount,
            __warp_usrid_05_feePips,
        );

        return (
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_07_amountIn,
            __warp_usrid_08_amountOut,
            __warp_usrid_09_feeAmount,
        );
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_amountRemainingLessFee: Uint256,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_01_sqrtRatioCurrentX96: felt,
        __warp_usrid_03_liquidity: felt,
        __warp_usrid_10_zeroForOne: felt,
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_37) = warp_ge256(
            __warp_usrid_12_amountRemainingLessFee, __warp_usrid_07_amountIn
        );

        if (__warp_se_37 != 0) {
            let __warp_usrid_06_sqrtRatioNextX96 = __warp_usrid_02_sqrtRatioTargetX96;

            let (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            ) = s1___warp_usrfn_00_computeSwapStep_if_part2_if_part1(
                __warp_usrid_02_sqrtRatioTargetX96,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_10_zeroForOne,
                __warp_usrid_11_exactIn,
                __warp_usrid_07_amountIn,
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_03_liquidity,
                __warp_usrid_08_amountOut,
                __warp_usrid_04_amountRemaining,
                __warp_usrid_09_feeAmount,
                __warp_usrid_05_feePips,
            );

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        } else {
            let (__warp_se_38) = s3___warp_usrfn_02_getNextSqrtPriceFromInput(
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_03_liquidity,
                __warp_usrid_12_amountRemainingLessFee,
                __warp_usrid_10_zeroForOne,
            );

            let __warp_usrid_06_sqrtRatioNextX96 = __warp_se_38;

            let (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            ) = s1___warp_usrfn_00_computeSwapStep_if_part2_if_part1(
                __warp_usrid_02_sqrtRatioTargetX96,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_10_zeroForOne,
                __warp_usrid_11_exactIn,
                __warp_usrid_07_amountIn,
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_03_liquidity,
                __warp_usrid_08_amountOut,
                __warp_usrid_04_amountRemaining,
                __warp_usrid_09_feeAmount,
                __warp_usrid_05_feePips,
            );

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        }
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part2_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_10_zeroForOne: felt,
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_01_sqrtRatioCurrentX96: felt,
        __warp_usrid_03_liquidity: felt,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_07_amountIn,
            __warp_usrid_08_amountOut,
            __warp_usrid_09_feeAmount,
        ) = s1___warp_usrfn_00_computeSwapStep_if_part1(
            __warp_usrid_02_sqrtRatioTargetX96,
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_10_zeroForOne,
            __warp_usrid_11_exactIn,
            __warp_usrid_07_amountIn,
            __warp_usrid_01_sqrtRatioCurrentX96,
            __warp_usrid_03_liquidity,
            __warp_usrid_08_amountOut,
            __warp_usrid_04_amountRemaining,
            __warp_usrid_09_feeAmount,
            __warp_usrid_05_feePips,
        );

        return (
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_07_amountIn,
            __warp_usrid_08_amountOut,
            __warp_usrid_09_feeAmount,
        );
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_10_zeroForOne: felt,
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_01_sqrtRatioCurrentX96: felt,
        __warp_usrid_03_liquidity: felt,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_usrid_13_max) = warp_eq(
            __warp_usrid_02_sqrtRatioTargetX96, __warp_usrid_06_sqrtRatioNextX96
        );

        if (__warp_usrid_10_zeroForOne != 0) {
            let (__warp_se_39) = warp_and_(__warp_usrid_13_max, __warp_usrid_11_exactIn);

            if (1 - __warp_se_39 != 0) {
                let (__warp_se_40) = s3___warp_usrfn_04_getAmount0Delta(
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    1,
                );

                let __warp_usrid_07_amountIn = __warp_se_40;

                let (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part2(
                    __warp_usrid_13_max,
                    __warp_usrid_11_exactIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    __warp_usrid_04_amountRemaining,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_09_feeAmount,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_05_feePips,
                );

                return (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                );
            } else {
                let (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part2(
                    __warp_usrid_13_max,
                    __warp_usrid_11_exactIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    __warp_usrid_04_amountRemaining,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_09_feeAmount,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_05_feePips,
                );

                return (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                );
            }
        } else {
            let (__warp_se_41) = warp_and_(__warp_usrid_13_max, __warp_usrid_11_exactIn);

            if (1 - __warp_se_41 != 0) {
                let (__warp_se_42) = s3___warp_usrfn_05_getAmount1Delta(
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_03_liquidity,
                    1,
                );

                let __warp_usrid_07_amountIn = __warp_se_42;

                let (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part3(
                    __warp_usrid_13_max,
                    __warp_usrid_11_exactIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_03_liquidity,
                    __warp_usrid_04_amountRemaining,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_09_feeAmount,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_05_feePips,
                );

                return (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                );
            } else {
                let (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part3(
                    __warp_usrid_13_max,
                    __warp_usrid_11_exactIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_03_liquidity,
                    __warp_usrid_04_amountRemaining,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_09_feeAmount,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_05_feePips,
                );

                return (
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_07_amountIn,
                    __warp_usrid_08_amountOut,
                    __warp_usrid_09_feeAmount,
                );
            }
        }
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part1_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_13_max: felt,
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_01_sqrtRatioCurrentX96: felt,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_03_liquidity: felt,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_43) = warp_and_(__warp_usrid_13_max, 1 - __warp_usrid_11_exactIn);

        if (1 - __warp_se_43 != 0) {
            let (__warp_se_44) = s3___warp_usrfn_04_getAmount0Delta(
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_03_liquidity,
                0,
            );

            let __warp_usrid_08_amountOut = __warp_se_44;

            let (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part3_if_part1(
                __warp_usrid_11_exactIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_04_amountRemaining,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_02_sqrtRatioTargetX96,
                __warp_usrid_09_feeAmount,
                __warp_usrid_07_amountIn,
                __warp_usrid_05_feePips,
            );

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        } else {
            let (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part3_if_part1(
                __warp_usrid_11_exactIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_04_amountRemaining,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_02_sqrtRatioTargetX96,
                __warp_usrid_09_feeAmount,
                __warp_usrid_07_amountIn,
                __warp_usrid_05_feePips,
            );

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        }
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part1_if_part3_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_07_amountIn,
            __warp_usrid_08_amountOut,
            __warp_usrid_09_feeAmount,
        ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part1(
            __warp_usrid_11_exactIn,
            __warp_usrid_08_amountOut,
            __warp_usrid_04_amountRemaining,
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_02_sqrtRatioTargetX96,
            __warp_usrid_09_feeAmount,
            __warp_usrid_07_amountIn,
            __warp_usrid_05_feePips,
        );

        return (
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_07_amountIn,
            __warp_usrid_08_amountOut,
            __warp_usrid_09_feeAmount,
        );
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part1_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_13_max: felt,
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_01_sqrtRatioCurrentX96: felt,
        __warp_usrid_03_liquidity: felt,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_45) = warp_and_(__warp_usrid_13_max, 1 - __warp_usrid_11_exactIn);

        if (1 - __warp_se_45 != 0) {
            let (__warp_se_46) = s3___warp_usrfn_05_getAmount1Delta(
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_03_liquidity,
                0,
            );

            let __warp_usrid_08_amountOut = __warp_se_46;

            let (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part2_if_part1(
                __warp_usrid_11_exactIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_04_amountRemaining,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_02_sqrtRatioTargetX96,
                __warp_usrid_09_feeAmount,
                __warp_usrid_07_amountIn,
                __warp_usrid_05_feePips,
            );

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        } else {
            let (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part2_if_part1(
                __warp_usrid_11_exactIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_04_amountRemaining,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_02_sqrtRatioTargetX96,
                __warp_usrid_09_feeAmount,
                __warp_usrid_07_amountIn,
                __warp_usrid_05_feePips,
            );

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        }
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part1_if_part2_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_07_amountIn,
            __warp_usrid_08_amountOut,
            __warp_usrid_09_feeAmount,
        ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part1(
            __warp_usrid_11_exactIn,
            __warp_usrid_08_amountOut,
            __warp_usrid_04_amountRemaining,
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_02_sqrtRatioTargetX96,
            __warp_usrid_09_feeAmount,
            __warp_usrid_07_amountIn,
            __warp_usrid_05_feePips,
        );

        return (
            __warp_usrid_06_sqrtRatioNextX96,
            __warp_usrid_07_amountIn,
            __warp_usrid_08_amountOut,
            __warp_usrid_09_feeAmount,
        );
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_05_feePips: felt,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_47) = warp_negate256(__warp_usrid_04_amountRemaining);

        let (__warp_se_48) = warp_gt256(__warp_usrid_08_amountOut, __warp_se_47);

        let (__warp_se_49) = warp_and_(1 - __warp_usrid_11_exactIn, __warp_se_48);

        if (__warp_se_49 != 0) {
            let (__warp_se_50) = warp_negate256(__warp_usrid_04_amountRemaining);

            let __warp_usrid_08_amountOut = __warp_se_50;

            let (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part1_if_part1(
                __warp_usrid_11_exactIn,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_02_sqrtRatioTargetX96,
                __warp_usrid_09_feeAmount,
                __warp_usrid_04_amountRemaining,
                __warp_usrid_07_amountIn,
                __warp_usrid_05_feePips,
                __warp_usrid_08_amountOut,
            );

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        } else {
            let (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            ) = s1___warp_usrfn_00_computeSwapStep_if_part1_if_part1_if_part1(
                __warp_usrid_11_exactIn,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_02_sqrtRatioTargetX96,
                __warp_usrid_09_feeAmount,
                __warp_usrid_04_amountRemaining,
                __warp_usrid_07_amountIn,
                __warp_usrid_05_feePips,
                __warp_usrid_08_amountOut,
            );

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        }
    }

    func s1___warp_usrfn_00_computeSwapStep_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_11_exactIn: felt,
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_02_sqrtRatioTargetX96: felt,
        __warp_usrid_09_feeAmount: Uint256,
        __warp_usrid_04_amountRemaining: Uint256,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_05_feePips: felt,
        __warp_usrid_08_amountOut: Uint256,
    ) -> (
        __warp_usrid_06_sqrtRatioNextX96: felt,
        __warp_usrid_07_amountIn: Uint256,
        __warp_usrid_08_amountOut: Uint256,
        __warp_usrid_09_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_51) = warp_neq(
            __warp_usrid_06_sqrtRatioNextX96, __warp_usrid_02_sqrtRatioTargetX96
        );

        let (__warp_se_52) = warp_and_(__warp_usrid_11_exactIn, __warp_se_51);

        if (__warp_se_52 != 0) {
            let (__warp_se_53) = warp_sub256(
                __warp_usrid_04_amountRemaining, __warp_usrid_07_amountIn
            );

            let __warp_usrid_09_feeAmount = __warp_se_53;

            let __warp_usrid_06_sqrtRatioNextX96 = __warp_usrid_06_sqrtRatioNextX96;

            let __warp_usrid_07_amountIn = __warp_usrid_07_amountIn;

            let __warp_usrid_08_amountOut = __warp_usrid_08_amountOut;

            let __warp_usrid_09_feeAmount = __warp_usrid_09_feeAmount;

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
        } else {
            let (__warp_se_54) = warp_uint256(__warp_usrid_05_feePips);

            let (__warp_se_55) = warp_sub(1000000, __warp_usrid_05_feePips);

            let (__warp_se_56) = warp_uint256(__warp_se_55);

            let (__warp_se_57) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_usrid_07_amountIn, __warp_se_54, __warp_se_56
            );

            let __warp_usrid_09_feeAmount = __warp_se_57;

            let __warp_usrid_06_sqrtRatioNextX96 = __warp_usrid_06_sqrtRatioNextX96;

            let __warp_usrid_07_amountIn = __warp_usrid_07_amountIn;

            let __warp_usrid_08_amountOut = __warp_usrid_08_amountOut;

            let __warp_usrid_09_feeAmount = __warp_usrid_09_feeAmount;

            return (
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_07_amountIn,
                __warp_usrid_08_amountOut,
                __warp_usrid_09_feeAmount,
            );
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

        let (__warp_se_58) = warp_mul_unsafe256(__warp_usrid_02_a, __warp_usrid_03_b);

        let __warp_usrid_06_prod0 = __warp_se_58;

        let (__warp_usrid_07_mm) = warp_mulmod(
            __warp_usrid_02_a,
            __warp_usrid_03_b,
            Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        );

        let __warp_usrid_08_prod1 = Uint256(low=0, high=0);

        let (__warp_se_59) = warp_sub_unsafe256(__warp_usrid_07_mm, __warp_usrid_06_prod0);

        let __warp_usrid_08_prod1 = __warp_se_59;

        let (__warp_se_60) = warp_lt256(__warp_usrid_07_mm, __warp_usrid_06_prod0);

        if (__warp_se_60 != 0) {
            let (__warp_se_61) = warp_sub_unsafe256(__warp_usrid_08_prod1, Uint256(low=1, high=0));

            let __warp_usrid_08_prod1 = __warp_se_61;

            let (__warp_se_62) = s2___warp_usrfn_00_mulDiv_if_part1(
                __warp_usrid_08_prod1,
                __warp_usrid_04_denominator,
                __warp_usrid_05_result,
                __warp_usrid_06_prod0,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
            );

            return (__warp_se_62,);
        } else {
            let (__warp_se_63) = s2___warp_usrfn_00_mulDiv_if_part1(
                __warp_usrid_08_prod1,
                __warp_usrid_04_denominator,
                __warp_usrid_05_result,
                __warp_usrid_06_prod0,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
            );

            return (__warp_se_63,);
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

        let (__warp_se_64) = warp_eq256(__warp_usrid_08_prod1, Uint256(low=0, high=0));

        if (__warp_se_64 != 0) {
            let (__warp_se_65) = warp_gt256(__warp_usrid_04_denominator, Uint256(low=0, high=0));

            assert __warp_se_65 = 1;

            let (__warp_se_66) = warp_div_unsafe256(
                __warp_usrid_06_prod0, __warp_usrid_04_denominator
            );

            let __warp_usrid_05_result = __warp_se_66;

            return (__warp_usrid_05_result,);
        } else {
            let (__warp_se_67) = s2___warp_usrfn_00_mulDiv_if_part1_if_part1(
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
                __warp_usrid_06_prod0,
                __warp_usrid_05_result,
            );

            return (__warp_se_67,);
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

        let (__warp_se_68) = warp_gt256(__warp_usrid_04_denominator, __warp_usrid_08_prod1);

        assert __warp_se_68 = 1;

        let __warp_usrid_09_remainder = Uint256(low=0, high=0);

        let (__warp_se_69) = warp_mulmod(
            __warp_usrid_02_a, __warp_usrid_03_b, __warp_usrid_04_denominator
        );

        let __warp_usrid_09_remainder = __warp_se_69;

        let (__warp_se_70) = warp_gt256(__warp_usrid_09_remainder, __warp_usrid_06_prod0);

        if (__warp_se_70 != 0) {
            let (__warp_se_71) = warp_sub_unsafe256(__warp_usrid_08_prod1, Uint256(low=1, high=0));

            let __warp_usrid_08_prod1 = __warp_se_71;

            let (__warp_se_72) = s2___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1(
                __warp_usrid_06_prod0,
                __warp_usrid_09_remainder,
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_05_result,
            );

            return (__warp_se_72,);
        } else {
            let (__warp_se_73) = s2___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1(
                __warp_usrid_06_prod0,
                __warp_usrid_09_remainder,
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_05_result,
            );

            return (__warp_se_73,);
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

        let (__warp_se_74) = warp_sub_unsafe256(__warp_usrid_06_prod0, __warp_usrid_09_remainder);

        let __warp_usrid_06_prod0 = __warp_se_74;

        let (__warp_se_75) = warp_negate256(__warp_usrid_04_denominator);

        let (__warp_usrid_10_twos) = warp_bitwise_and256(__warp_se_75, __warp_usrid_04_denominator);

        let (__warp_se_76) = warp_div_unsafe256(__warp_usrid_04_denominator, __warp_usrid_10_twos);

        let __warp_usrid_04_denominator = __warp_se_76;

        let (__warp_se_77) = warp_div_unsafe256(__warp_usrid_06_prod0, __warp_usrid_10_twos);

        let __warp_usrid_06_prod0 = __warp_se_77;

        let (__warp_se_78) = warp_sub_unsafe256(Uint256(low=0, high=0), __warp_usrid_10_twos);

        let (__warp_se_79) = warp_div_unsafe256(__warp_se_78, __warp_usrid_10_twos);

        let (__warp_se_80) = warp_add_unsafe256(__warp_se_79, Uint256(low=1, high=0));

        let __warp_usrid_10_twos = __warp_se_80;

        let (__warp_se_81) = warp_mul_unsafe256(__warp_usrid_08_prod1, __warp_usrid_10_twos);

        let (__warp_se_82) = warp_bitwise_or256(__warp_usrid_06_prod0, __warp_se_81);

        let __warp_usrid_06_prod0 = __warp_se_82;

        let (__warp_se_83) = warp_mul_unsafe256(
            Uint256(low=3, high=0), __warp_usrid_04_denominator
        );

        let (__warp_usrid_11_inv) = warp_xor256(__warp_se_83, Uint256(low=2, high=0));

        let (__warp_se_84) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_85) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_84);

        let (__warp_se_86) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_85);

        let __warp_usrid_11_inv = __warp_se_86;

        let (__warp_se_87) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_88) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_87);

        let (__warp_se_89) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_88);

        let __warp_usrid_11_inv = __warp_se_89;

        let (__warp_se_90) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_91) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_90);

        let (__warp_se_92) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_91);

        let __warp_usrid_11_inv = __warp_se_92;

        let (__warp_se_93) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_94) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_93);

        let (__warp_se_95) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_94);

        let __warp_usrid_11_inv = __warp_se_95;

        let (__warp_se_96) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_97) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_96);

        let (__warp_se_98) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_97);

        let __warp_usrid_11_inv = __warp_se_98;

        let (__warp_se_99) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_100) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_99);

        let (__warp_se_101) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_100);

        let __warp_usrid_11_inv = __warp_se_101;

        let (__warp_se_102) = warp_mul_unsafe256(__warp_usrid_06_prod0, __warp_usrid_11_inv);

        let __warp_usrid_05_result = __warp_se_102;

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

        let (__warp_se_103) = s2___warp_usrfn_00_mulDiv(
            __warp_usrid_12_a, __warp_usrid_13_b, __warp_usrid_14_denominator
        );

        let __warp_usrid_15_result = __warp_se_103;

        let (__warp_se_104) = warp_mulmod(
            __warp_usrid_12_a, __warp_usrid_13_b, __warp_usrid_14_denominator
        );

        let (__warp_se_105) = warp_gt256(__warp_se_104, Uint256(low=0, high=0));

        if (__warp_se_105 != 0) {
            let (__warp_se_106) = warp_lt256(
                __warp_usrid_15_result,
                Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
            );

            assert __warp_se_106 = 1;

            let (__warp_se_107) = warp_add_unsafe256(
                __warp_usrid_15_result, Uint256(low=1, high=0)
            );

            let __warp_se_108 = __warp_se_107;

            let __warp_usrid_15_result = __warp_se_108;

            warp_sub_unsafe256(__warp_se_108, Uint256(low=1, high=0));

            let (__warp_se_109) = s2___warp_usrfn_01_mulDivRoundingUp_if_part1(
                __warp_usrid_15_result
            );

            return (__warp_se_109,);
        } else {
            let (__warp_se_110) = s2___warp_usrfn_01_mulDivRoundingUp_if_part1(
                __warp_usrid_15_result
            );

            return (__warp_se_110,);
        }
    }

    func s2___warp_usrfn_01_mulDivRoundingUp_if_part1(__warp_usrid_15_result: Uint256) -> (
        __warp_usrid_15_result: Uint256
    ) {
        alloc_locals;

        return (__warp_usrid_15_result,);
    }

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
    func s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_sqrtPX96: felt,
        __warp_usrid_09_liquidity: felt,
        __warp_usrid_10_amount: Uint256,
        __warp_usrid_11_add: felt,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (__warp_se_111) = warp_eq256(__warp_usrid_10_amount, Uint256(low=0, high=0));

        if (__warp_se_111 != 0) {
            return (__warp_usrid_08_sqrtPX96,);
        } else {
            let (__warp_se_112) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1(
                __warp_usrid_09_liquidity,
                __warp_usrid_11_add,
                __warp_usrid_10_amount,
                __warp_usrid_08_sqrtPX96,
            );

            return (__warp_se_112,);
        }
    }

    func s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_09_liquidity: felt,
        __warp_usrid_11_add: felt,
        __warp_usrid_10_amount: Uint256,
        __warp_usrid_08_sqrtPX96: felt,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (__warp_se_113) = warp_uint256(__warp_usrid_09_liquidity);

        let (__warp_usrid_13_numerator1) = warp_shl256(__warp_se_113, 96);

        if (__warp_usrid_11_add != 0) {
            let __warp_usrid_14_product = Uint256(low=0, high=0);

            let (__warp_se_114) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_115) = warp_mul_unsafe256(__warp_usrid_10_amount, __warp_se_114);

            let __warp_se_116 = __warp_se_115;

            let __warp_usrid_14_product = __warp_se_116;

            let (__warp_se_117) = warp_div_unsafe256(__warp_se_116, __warp_usrid_10_amount);

            let (__warp_se_118) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_119) = warp_eq256(__warp_se_117, __warp_se_118);

            if (__warp_se_119 != 0) {
                let (__warp_usrid_15_denominator) = warp_add_unsafe256(
                    __warp_usrid_13_numerator1, __warp_usrid_14_product
                );

                let (__warp_se_120) = warp_ge256(
                    __warp_usrid_15_denominator, __warp_usrid_13_numerator1
                );

                if (__warp_se_120 != 0) {
                    let (__warp_se_121) = warp_uint256(__warp_usrid_08_sqrtPX96);

                    let (__warp_se_122) = s2___warp_usrfn_01_mulDivRoundingUp(
                        __warp_usrid_13_numerator1, __warp_se_121, __warp_usrid_15_denominator
                    );

                    let (__warp_se_123) = warp_int256_to_int160(__warp_se_122);

                    return (__warp_se_123,);
                } else {
                    let (
                        __warp_se_124
                    ) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part3(
                        __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
                    );

                    return (__warp_se_124,);
                }
            } else {
                let (
                    __warp_se_125
                ) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2(
                    __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
                );

                return (__warp_se_125,);
            }
        } else {
            let __warp_usrid_16_product = Uint256(low=0, high=0);

            let (__warp_se_126) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_127) = warp_mul_unsafe256(__warp_usrid_10_amount, __warp_se_126);

            let __warp_se_128 = __warp_se_127;

            let __warp_usrid_16_product = __warp_se_128;

            let (__warp_se_129) = warp_div_unsafe256(__warp_se_128, __warp_usrid_10_amount);

            let (__warp_se_130) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_131) = warp_eq256(__warp_se_129, __warp_se_130);

            let (__warp_se_132) = warp_gt256(__warp_usrid_13_numerator1, __warp_usrid_16_product);

            let (__warp_se_133) = warp_and_(__warp_se_131, __warp_se_132);

            assert __warp_se_133 = 1;

            let (__warp_usrid_17_denominator) = warp_sub_unsafe256(
                __warp_usrid_13_numerator1, __warp_usrid_16_product
            );

            let (__warp_se_134) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_135) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_usrid_13_numerator1, __warp_se_134, __warp_usrid_17_denominator
            );

            let (__warp_se_136) = s6___warp_usrfn_00_toUint160(__warp_se_135);

            return (__warp_se_136,);
        }
    }

    func s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_13_numerator1: Uint256,
        __warp_usrid_08_sqrtPX96: felt,
        __warp_usrid_10_amount: Uint256,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (
            __warp_se_137
        ) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2(
            __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
        );

        return (__warp_se_137,);
    }

    func s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_13_numerator1: Uint256,
        __warp_usrid_08_sqrtPX96: felt,
        __warp_usrid_10_amount: Uint256,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (__warp_se_138) = warp_uint256(__warp_usrid_08_sqrtPX96);

        let (__warp_se_139) = warp_div256(__warp_usrid_13_numerator1, __warp_se_138);

        let (__warp_se_140) = s5___warp_usrfn_00_add(__warp_se_139, __warp_usrid_10_amount);

        let (__warp_se_141) = s4___warp_usrfn_00_divRoundingUp(
            __warp_usrid_13_numerator1, __warp_se_140
        );

        let (__warp_se_142) = warp_int256_to_int160(__warp_se_141);

        return (__warp_se_142,);
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
    func s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown{
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

            let (__warp_se_143) = warp_uint256(1461501637330902918203684832716283019655932542975);

            let (__warp_se_144) = warp_le256(__warp_usrid_20_amount, __warp_se_143);

            if (__warp_se_144 != 0) {
                let (__warp_se_145) = warp_shl256(__warp_usrid_20_amount, 96);

                let (__warp_se_146) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_147) = warp_div_unsafe256(__warp_se_145, __warp_se_146);

                let __warp_usrid_23_quotient = __warp_se_147;

                let (
                    __warp_se_148
                ) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_23_quotient
                );

                return (__warp_se_148,);
            } else {
                let (__warp_se_149) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_150) = s2___warp_usrfn_00_mulDiv(
                    __warp_usrid_20_amount,
                    Uint256(low=79228162514264337593543950336, high=0),
                    __warp_se_149,
                );

                let __warp_usrid_23_quotient = __warp_se_150;

                let (
                    __warp_se_151
                ) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_23_quotient
                );

                return (__warp_se_151,);
            }
        } else {
            let __warp_usrid_24_quotient = Uint256(low=0, high=0);

            let (__warp_se_152) = warp_uint256(1461501637330902918203684832716283019655932542975);

            let (__warp_se_153) = warp_le256(__warp_usrid_20_amount, __warp_se_152);

            if (__warp_se_153 != 0) {
                let (__warp_se_154) = warp_shl256(__warp_usrid_20_amount, 96);

                let (__warp_se_155) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_156) = s4___warp_usrfn_00_divRoundingUp(
                    __warp_se_154, __warp_se_155
                );

                let __warp_usrid_24_quotient = __warp_se_156;

                let (
                    __warp_se_157
                ) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_24_quotient
                );

                return (__warp_se_157,);
            } else {
                let (__warp_se_158) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_159) = s2___warp_usrfn_01_mulDivRoundingUp(
                    __warp_usrid_20_amount,
                    Uint256(low=79228162514264337593543950336, high=0),
                    __warp_se_158,
                );

                let __warp_usrid_24_quotient = __warp_se_159;

                let (
                    __warp_se_160
                ) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_24_quotient
                );

                return (__warp_se_160,);
            }
        }
    }

    func s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_18_sqrtPX96: felt, __warp_usrid_24_quotient: Uint256) -> (
        __warp_usrid_22_: felt
    ) {
        alloc_locals;

        let (__warp_se_161) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_162) = warp_gt256(__warp_se_161, __warp_usrid_24_quotient);

        assert __warp_se_162 = 1;

        let (__warp_se_163) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_164) = warp_sub256(__warp_se_163, __warp_usrid_24_quotient);

        let (__warp_se_165) = warp_int256_to_int160(__warp_se_164);

        return (__warp_se_165,);
    }

    func s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_18_sqrtPX96: felt, __warp_usrid_23_quotient: Uint256) -> (
        __warp_usrid_22_: felt
    ) {
        alloc_locals;

        let (__warp_se_166) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_167) = s5___warp_usrfn_00_add(__warp_se_166, __warp_usrid_23_quotient);

        let (__warp_se_168) = s6___warp_usrfn_00_toUint160(__warp_se_167);

        return (__warp_se_168,);
    }

    // @notice Gets the next sqrt price given an input amount of token0 or token1
    // @dev Throws if price or liquidity are 0, or if the next price is out of bounds
    // @param sqrtPX96 The starting price, i.e., before accounting for the input amount
    // @param liquidity The amount of usable liquidity
    // @param amountIn How much of token0, or token1, is being swapped in
    // @param zeroForOne Whether the amount in is token0 or token1
    // @return sqrtQX96 The price after adding the input amount to token0 or token1
    func s3___warp_usrfn_02_getNextSqrtPriceFromInput{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_25_sqrtPX96: felt,
        __warp_usrid_26_liquidity: felt,
        __warp_usrid_27_amountIn: Uint256,
        __warp_usrid_28_zeroForOne: felt,
    ) -> (__warp_usrid_29_sqrtQX96: felt) {
        alloc_locals;

        let (__warp_se_169) = warp_gt(__warp_usrid_25_sqrtPX96, 0);

        assert __warp_se_169 = 1;

        let (__warp_se_170) = warp_gt(__warp_usrid_26_liquidity, 0);

        assert __warp_se_170 = 1;

        if (__warp_usrid_28_zeroForOne != 0) {
            let (__warp_se_171) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp(
                __warp_usrid_25_sqrtPX96, __warp_usrid_26_liquidity, __warp_usrid_27_amountIn, 1
            );

            return (__warp_se_171,);
        } else {
            let (__warp_se_172) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown(
                __warp_usrid_25_sqrtPX96, __warp_usrid_26_liquidity, __warp_usrid_27_amountIn, 1
            );

            return (__warp_se_172,);
        }
    }

    // @notice Gets the next sqrt price given an output amount of token0 or token1
    // @dev Throws if price or liquidity are 0 or the next price is out of bounds
    // @param sqrtPX96 The starting price before accounting for the output amount
    // @param liquidity The amount of usable liquidity
    // @param amountOut How much of token0, or token1, is being swapped out
    // @param zeroForOne Whether the amount out is token0 or token1
    // @return sqrtQX96 The price after removing the output amount of token0 or token1
    func s3___warp_usrfn_03_getNextSqrtPriceFromOutput{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_30_sqrtPX96: felt,
        __warp_usrid_31_liquidity: felt,
        __warp_usrid_32_amountOut: Uint256,
        __warp_usrid_33_zeroForOne: felt,
    ) -> (__warp_usrid_34_sqrtQX96: felt) {
        alloc_locals;

        let (__warp_se_173) = warp_gt(__warp_usrid_30_sqrtPX96, 0);

        assert __warp_se_173 = 1;

        let (__warp_se_174) = warp_gt(__warp_usrid_31_liquidity, 0);

        assert __warp_se_174 = 1;

        if (__warp_usrid_33_zeroForOne != 0) {
            let (__warp_se_175) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown(
                __warp_usrid_30_sqrtPX96, __warp_usrid_31_liquidity, __warp_usrid_32_amountOut, 0
            );

            return (__warp_se_175,);
        } else {
            let (__warp_se_176) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp(
                __warp_usrid_30_sqrtPX96, __warp_usrid_31_liquidity, __warp_usrid_32_amountOut, 0
            );

            return (__warp_se_176,);
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
    func s3___warp_usrfn_04_getAmount0Delta{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_35_sqrtRatioAX96: felt,
        __warp_usrid_36_sqrtRatioBX96: felt,
        __warp_usrid_37_liquidity: felt,
        __warp_usrid_38_roundUp: felt,
    ) -> (__warp_usrid_39_amount0: Uint256) {
        alloc_locals;

        let (__warp_se_177) = warp_gt(__warp_usrid_35_sqrtRatioAX96, __warp_usrid_36_sqrtRatioBX96);

        if (__warp_se_177 != 0) {
            let __warp_tv_0 = __warp_usrid_36_sqrtRatioBX96;

            let __warp_tv_1 = __warp_usrid_35_sqrtRatioAX96;

            let __warp_usrid_36_sqrtRatioBX96 = __warp_tv_1;

            let __warp_usrid_35_sqrtRatioAX96 = __warp_tv_0;

            let (__warp_se_178) = s3___warp_usrfn_04_getAmount0Delta_if_part1(
                __warp_usrid_37_liquidity,
                __warp_usrid_36_sqrtRatioBX96,
                __warp_usrid_35_sqrtRatioAX96,
                __warp_usrid_38_roundUp,
            );

            return (__warp_se_178,);
        } else {
            let (__warp_se_179) = s3___warp_usrfn_04_getAmount0Delta_if_part1(
                __warp_usrid_37_liquidity,
                __warp_usrid_36_sqrtRatioBX96,
                __warp_usrid_35_sqrtRatioAX96,
                __warp_usrid_38_roundUp,
            );

            return (__warp_se_179,);
        }
    }

    func s3___warp_usrfn_04_getAmount0Delta_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_37_liquidity: felt,
        __warp_usrid_36_sqrtRatioBX96: felt,
        __warp_usrid_35_sqrtRatioAX96: felt,
        __warp_usrid_38_roundUp: felt,
    ) -> (__warp_usrid_39_amount0: Uint256) {
        alloc_locals;

        let (__warp_se_180) = warp_uint256(__warp_usrid_37_liquidity);

        let (__warp_usrid_40_numerator1) = warp_shl256(__warp_se_180, 96);

        let (__warp_se_181) = warp_sub(
            __warp_usrid_36_sqrtRatioBX96, __warp_usrid_35_sqrtRatioAX96
        );

        let (__warp_usrid_41_numerator2) = warp_uint256(__warp_se_181);

        let (__warp_se_182) = warp_gt(__warp_usrid_35_sqrtRatioAX96, 0);

        assert __warp_se_182 = 1;

        if (__warp_usrid_38_roundUp != 0) {
            let (__warp_se_183) = warp_uint256(__warp_usrid_36_sqrtRatioBX96);

            let (__warp_se_184) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_usrid_40_numerator1, __warp_usrid_41_numerator2, __warp_se_183
            );

            let (__warp_se_185) = warp_uint256(__warp_usrid_35_sqrtRatioAX96);

            let (__warp_se_186) = s4___warp_usrfn_00_divRoundingUp(__warp_se_184, __warp_se_185);

            return (__warp_se_186,);
        } else {
            let (__warp_se_187) = warp_uint256(__warp_usrid_36_sqrtRatioBX96);

            let (__warp_se_188) = s2___warp_usrfn_00_mulDiv(
                __warp_usrid_40_numerator1, __warp_usrid_41_numerator2, __warp_se_187
            );

            let (__warp_se_189) = warp_uint256(__warp_usrid_35_sqrtRatioAX96);

            let (__warp_se_190) = warp_div256(__warp_se_188, __warp_se_189);

            return (__warp_se_190,);
        }
    }

    // @notice Gets the amount1 delta between two prices
    // @dev Calculates liquidity * (sqrt(upper) - sqrt(lower))
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The amount of usable liquidity
    // @param roundUp Whether to round the amount up, or down
    // @return amount1 Amount of token1 required to cover a position of size liquidity between the two passed prices
    func s3___warp_usrfn_05_getAmount1Delta{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_42_sqrtRatioAX96: felt,
        __warp_usrid_43_sqrtRatioBX96: felt,
        __warp_usrid_44_liquidity: felt,
        __warp_usrid_45_roundUp: felt,
    ) -> (__warp_usrid_46_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_191) = warp_gt(__warp_usrid_42_sqrtRatioAX96, __warp_usrid_43_sqrtRatioBX96);

        if (__warp_se_191 != 0) {
            let __warp_tv_2 = __warp_usrid_43_sqrtRatioBX96;

            let __warp_tv_3 = __warp_usrid_42_sqrtRatioAX96;

            let __warp_usrid_43_sqrtRatioBX96 = __warp_tv_3;

            let __warp_usrid_42_sqrtRatioAX96 = __warp_tv_2;

            let (__warp_se_192) = s3___warp_usrfn_05_getAmount1Delta_if_part1(
                __warp_usrid_45_roundUp,
                __warp_usrid_44_liquidity,
                __warp_usrid_43_sqrtRatioBX96,
                __warp_usrid_42_sqrtRatioAX96,
            );

            return (__warp_se_192,);
        } else {
            let (__warp_se_193) = s3___warp_usrfn_05_getAmount1Delta_if_part1(
                __warp_usrid_45_roundUp,
                __warp_usrid_44_liquidity,
                __warp_usrid_43_sqrtRatioBX96,
                __warp_usrid_42_sqrtRatioAX96,
            );

            return (__warp_se_193,);
        }
    }

    func s3___warp_usrfn_05_getAmount1Delta_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_45_roundUp: felt,
        __warp_usrid_44_liquidity: felt,
        __warp_usrid_43_sqrtRatioBX96: felt,
        __warp_usrid_42_sqrtRatioAX96: felt,
    ) -> (__warp_usrid_46_amount1: Uint256) {
        alloc_locals;

        if (__warp_usrid_45_roundUp != 0) {
            let (__warp_se_194) = warp_uint256(__warp_usrid_44_liquidity);

            let (__warp_se_195) = warp_sub(
                __warp_usrid_43_sqrtRatioBX96, __warp_usrid_42_sqrtRatioAX96
            );

            let (__warp_se_196) = warp_uint256(__warp_se_195);

            let (__warp_se_197) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_se_194, __warp_se_196, Uint256(low=79228162514264337593543950336, high=0)
            );

            return (__warp_se_197,);
        } else {
            let (__warp_se_198) = warp_uint256(__warp_usrid_44_liquidity);

            let (__warp_se_199) = warp_sub(
                __warp_usrid_43_sqrtRatioBX96, __warp_usrid_42_sqrtRatioAX96
            );

            let (__warp_se_200) = warp_uint256(__warp_se_199);

            let (__warp_se_201) = s2___warp_usrfn_00_mulDiv(
                __warp_se_198, __warp_se_200, Uint256(low=79228162514264337593543950336, high=0)
            );

            return (__warp_se_201,);
        }
    }

    // @notice Returns ceil(x / y)
    // @dev division by 0 has unspecified behavior, and must be checked externally
    // @param x The dividend
    // @param y The divisor
    // @return z The quotient, ceil(x / y)
    func s4___warp_usrfn_00_divRoundingUp{range_check_ptr: felt}(
        __warp_usrid_01_x: Uint256, __warp_usrid_02_y: Uint256
    ) -> (__warp_usrid_03_z: Uint256) {
        alloc_locals;

        let __warp_usrid_03_z = Uint256(low=0, high=0);

        let __warp_usrid_04_temp = Uint256(low=0, high=0);

        let (__warp_se_202) = warp_mod256(__warp_usrid_01_x, __warp_usrid_02_y);

        let (__warp_se_203) = warp_gt256(__warp_se_202, Uint256(low=0, high=0));

        if (__warp_se_203 != 0) {
            let __warp_usrid_04_temp = Uint256(low=1, high=0);

            let (__warp_se_204) = s4___warp_usrfn_00_divRoundingUp_if_part1(
                __warp_usrid_03_z, __warp_usrid_01_x, __warp_usrid_02_y, __warp_usrid_04_temp
            );

            return (__warp_se_204,);
        } else {
            let (__warp_se_205) = s4___warp_usrfn_00_divRoundingUp_if_part1(
                __warp_usrid_03_z, __warp_usrid_01_x, __warp_usrid_02_y, __warp_usrid_04_temp
            );

            return (__warp_se_205,);
        }
    }

    func s4___warp_usrfn_00_divRoundingUp_if_part1{range_check_ptr: felt}(
        __warp_usrid_03_z: Uint256,
        __warp_usrid_01_x: Uint256,
        __warp_usrid_02_y: Uint256,
        __warp_usrid_04_temp: Uint256,
    ) -> (__warp_usrid_03_z: Uint256) {
        alloc_locals;

        let (__warp_se_206) = warp_div_unsafe256(__warp_usrid_01_x, __warp_usrid_02_y);

        let (__warp_se_207) = warp_add_unsafe256(__warp_se_206, __warp_usrid_04_temp);

        let __warp_usrid_03_z = __warp_se_207;

        return (__warp_usrid_03_z,);
    }

    // @notice Returns x + y, reverts if sum overflows uint256
    // @param x The augend
    // @param y The addend
    // @return z The sum of x and y
    func s5___warp_usrfn_00_add{range_check_ptr: felt}(
        __warp_usrid_05_x: Uint256, __warp_usrid_06_y: Uint256
    ) -> (__warp_usrid_07_z: Uint256) {
        alloc_locals;

        let __warp_usrid_07_z = Uint256(low=0, high=0);

        let (__warp_se_208) = warp_add256(__warp_usrid_05_x, __warp_usrid_06_y);

        let __warp_se_209 = __warp_se_208;

        let __warp_usrid_07_z = __warp_se_209;

        let (__warp_se_210) = warp_ge256(__warp_se_209, __warp_usrid_05_x);

        assert __warp_se_210 = 1;

        return (__warp_usrid_07_z,);
    }

    // @notice Cast a uint256 to a uint160, revert on overflow
    // @param y The uint256 to be downcasted
    // @return z The downcasted integer, now type uint160
    func s6___warp_usrfn_00_toUint160{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_03_y: Uint256
    ) -> (__warp_usrid_04_z: felt) {
        alloc_locals;

        let __warp_usrid_04_z = 0;

        let (__warp_se_211) = warp_int256_to_int160(__warp_usrid_03_y);

        let __warp_se_212 = __warp_se_211;

        let __warp_usrid_04_z = __warp_se_212;

        let (__warp_se_213) = warp_uint256(__warp_se_212);

        let (__warp_se_214) = warp_eq256(__warp_se_213, __warp_usrid_03_y);

        assert __warp_se_214 = 1;

        return (__warp_usrid_04_z,);
    }
}

@view
func checkComputeSwapStepInvariants_d7e3056f{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_00_sqrtPriceRaw: felt,
    __warp_usrid_01_sqrtPriceTargetRaw: felt,
    __warp_usrid_02_liquidity: felt,
    __warp_usrid_03_amountRemaining: Uint256,
    __warp_usrid_04_feePips: felt,
) -> () {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_04_feePips);

    warp_external_input_check_int256(__warp_usrid_03_amountRemaining);

    warp_external_input_check_int128(__warp_usrid_02_liquidity);

    warp_external_input_check_int160(__warp_usrid_01_sqrtPriceTargetRaw);

    warp_external_input_check_int160(__warp_usrid_00_sqrtPriceRaw);

    let (__warp_se_0) = warp_gt(__warp_usrid_00_sqrtPriceRaw, 0);

    assert __warp_se_0 = 1;

    let (__warp_se_1) = warp_gt(__warp_usrid_01_sqrtPriceTargetRaw, 0);

    assert __warp_se_1 = 1;

    let (__warp_se_2) = warp_gt(__warp_usrid_04_feePips, 0);

    assert __warp_se_2 = 1;

    let (__warp_se_3) = warp_lt(__warp_usrid_04_feePips, 1000000);

    assert __warp_se_3 = 1;

    let (
        __warp_usrid_05_sqrtQ,
        __warp_usrid_06_amountIn,
        __warp_usrid_07_amountOut,
        __warp_usrid_08_feeAmount,
    ) = SwapMathEchidnaTest.s1___warp_usrfn_00_computeSwapStep(
        __warp_usrid_00_sqrtPriceRaw,
        __warp_usrid_01_sqrtPriceTargetRaw,
        __warp_usrid_02_liquidity,
        __warp_usrid_03_amountRemaining,
        __warp_usrid_04_feePips,
    );

    let (__warp_se_4) = warp_sub256(
        Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        __warp_usrid_08_feeAmount,
    );

    let (__warp_se_5) = warp_le256(__warp_usrid_06_amountIn, __warp_se_4);

    assert __warp_se_5 = 1;

    let (__warp_se_6) = warp_lt_signed256(__warp_usrid_03_amountRemaining, Uint256(low=0, high=0));

    if (__warp_se_6 != 0) {
        let (__warp_se_7) = warp_negate256(__warp_usrid_03_amountRemaining);

        let (__warp_se_8) = warp_le256(__warp_usrid_07_amountOut, __warp_se_7);

        assert __warp_se_8 = 1;

        SwapMathEchidnaTest.checkComputeSwapStepInvariants_d7e3056f_if_part1(
            __warp_usrid_00_sqrtPriceRaw,
            __warp_usrid_01_sqrtPriceTargetRaw,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
            __warp_usrid_05_sqrtQ,
            __warp_usrid_03_amountRemaining,
        );

        return ();
    } else {
        let (__warp_se_9) = warp_add256(__warp_usrid_06_amountIn, __warp_usrid_08_feeAmount);

        let (__warp_se_10) = warp_le256(__warp_se_9, __warp_usrid_03_amountRemaining);

        assert __warp_se_10 = 1;

        SwapMathEchidnaTest.checkComputeSwapStepInvariants_d7e3056f_if_part1(
            __warp_usrid_00_sqrtPriceRaw,
            __warp_usrid_01_sqrtPriceTargetRaw,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
            __warp_usrid_05_sqrtQ,
            __warp_usrid_03_amountRemaining,
        );

        return ();
    }
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","checkComputeSwapStepInvariants(uint160,uint160,uint128,int256,uint24)"]
