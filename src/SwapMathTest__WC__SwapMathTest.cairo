%lang starknet

from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int160,
    warp_external_input_check_int128,
    warp_external_input_check_int256,
    warp_external_input_check_int24,
)
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.ge import warp_ge, warp_ge256
from warplib.maths.ge_signed import warp_ge_signed256
from warplib.maths.sub import warp_sub, warp_sub256
from warplib.maths.int_conversions import warp_uint256, warp_int256_to_int160
from warplib.maths.negate import warp_negate256
from warplib.maths.eq import warp_eq, warp_eq256
from warplib.maths.and_ import warp_and_
from warplib.maths.gt import warp_gt256, warp_gt
from warplib.maths.neq import warp_neq
from warplib.maths.mul_unsafe import warp_mul_unsafe256
from warplib.maths.mulmod import warp_mulmod
from warplib.maths.sub_unsafe import warp_sub_unsafe256
from warplib.maths.lt import warp_lt256
from warplib.maths.div_unsafe import warp_div_unsafe256
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.add_unsafe import warp_add_unsafe256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.xor import warp_xor256
from warplib.maths.shl import warp_shl256
from warplib.maths.div import warp_div256
from warplib.maths.le import warp_le256
from warplib.maths.mod import warp_mod256
from warplib.maths.add import warp_add256

// Contract Def SwapMathTest

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

namespace SwapMathTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

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
            let (__warp_se_0) = warp_sub(1000000, __warp_usrid_05_feePips);

            let (__warp_se_1) = warp_uint256(__warp_se_0);

            let (__warp_usrid_12_amountRemainingLessFee) = s2___warp_usrfn_00_mulDiv(
                __warp_usrid_04_amountRemaining, __warp_se_1, Uint256(low=1000000, high=0)
            );

            if (__warp_usrid_10_zeroForOne != 0) {
                let (__warp_se_2) = s3___warp_usrfn_04_getAmount0Delta(
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    1,
                );

                let __warp_usrid_07_amountIn = __warp_se_2;

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
                let (__warp_se_3) = s3___warp_usrfn_05_getAmount1Delta(
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_03_liquidity,
                    1,
                );

                let __warp_usrid_07_amountIn = __warp_se_3;

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
                let (__warp_se_4) = s3___warp_usrfn_05_getAmount1Delta(
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    0,
                );

                let __warp_usrid_08_amountOut = __warp_se_4;

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
                let (__warp_se_5) = s3___warp_usrfn_04_getAmount0Delta(
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_02_sqrtRatioTargetX96,
                    __warp_usrid_03_liquidity,
                    0,
                );

                let __warp_usrid_08_amountOut = __warp_se_5;

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

        let (__warp_se_6) = warp_negate256(__warp_usrid_04_amountRemaining);

        let (__warp_se_7) = warp_ge256(__warp_se_6, __warp_usrid_08_amountOut);

        if (__warp_se_7 != 0) {
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
            let (__warp_se_8) = warp_negate256(__warp_usrid_04_amountRemaining);

            let (__warp_se_9) = s3___warp_usrfn_03_getNextSqrtPriceFromOutput(
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_03_liquidity,
                __warp_se_8,
                __warp_usrid_10_zeroForOne,
            );

            let __warp_usrid_06_sqrtRatioNextX96 = __warp_se_9;

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

        let (__warp_se_10) = warp_ge256(
            __warp_usrid_12_amountRemainingLessFee, __warp_usrid_07_amountIn
        );

        if (__warp_se_10 != 0) {
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
            let (__warp_se_11) = s3___warp_usrfn_02_getNextSqrtPriceFromInput(
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_03_liquidity,
                __warp_usrid_12_amountRemainingLessFee,
                __warp_usrid_10_zeroForOne,
            );

            let __warp_usrid_06_sqrtRatioNextX96 = __warp_se_11;

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
            let (__warp_se_12) = warp_and_(__warp_usrid_13_max, __warp_usrid_11_exactIn);

            if (1 - __warp_se_12 != 0) {
                let (__warp_se_13) = s3___warp_usrfn_04_getAmount0Delta(
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_03_liquidity,
                    1,
                );

                let __warp_usrid_07_amountIn = __warp_se_13;

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
            let (__warp_se_14) = warp_and_(__warp_usrid_13_max, __warp_usrid_11_exactIn);

            if (1 - __warp_se_14 != 0) {
                let (__warp_se_15) = s3___warp_usrfn_05_getAmount1Delta(
                    __warp_usrid_01_sqrtRatioCurrentX96,
                    __warp_usrid_06_sqrtRatioNextX96,
                    __warp_usrid_03_liquidity,
                    1,
                );

                let __warp_usrid_07_amountIn = __warp_se_15;

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

        let (__warp_se_16) = warp_and_(__warp_usrid_13_max, 1 - __warp_usrid_11_exactIn);

        if (1 - __warp_se_16 != 0) {
            let (__warp_se_17) = s3___warp_usrfn_04_getAmount0Delta(
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_03_liquidity,
                0,
            );

            let __warp_usrid_08_amountOut = __warp_se_17;

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

        let (__warp_se_18) = warp_and_(__warp_usrid_13_max, 1 - __warp_usrid_11_exactIn);

        if (1 - __warp_se_18 != 0) {
            let (__warp_se_19) = s3___warp_usrfn_05_getAmount1Delta(
                __warp_usrid_06_sqrtRatioNextX96,
                __warp_usrid_01_sqrtRatioCurrentX96,
                __warp_usrid_03_liquidity,
                0,
            );

            let __warp_usrid_08_amountOut = __warp_se_19;

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

        let (__warp_se_20) = warp_negate256(__warp_usrid_04_amountRemaining);

        let (__warp_se_21) = warp_gt256(__warp_usrid_08_amountOut, __warp_se_20);

        let (__warp_se_22) = warp_and_(1 - __warp_usrid_11_exactIn, __warp_se_21);

        if (__warp_se_22 != 0) {
            let (__warp_se_23) = warp_negate256(__warp_usrid_04_amountRemaining);

            let __warp_usrid_08_amountOut = __warp_se_23;

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

        let (__warp_se_24) = warp_neq(
            __warp_usrid_06_sqrtRatioNextX96, __warp_usrid_02_sqrtRatioTargetX96
        );

        let (__warp_se_25) = warp_and_(__warp_usrid_11_exactIn, __warp_se_24);

        if (__warp_se_25 != 0) {
            let (__warp_se_26) = warp_sub256(
                __warp_usrid_04_amountRemaining, __warp_usrid_07_amountIn
            );

            let __warp_usrid_09_feeAmount = __warp_se_26;

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
            let (__warp_se_27) = warp_uint256(__warp_usrid_05_feePips);

            let (__warp_se_28) = warp_sub(1000000, __warp_usrid_05_feePips);

            let (__warp_se_29) = warp_uint256(__warp_se_28);

            let (__warp_se_30) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_usrid_07_amountIn, __warp_se_27, __warp_se_29
            );

            let __warp_usrid_09_feeAmount = __warp_se_30;

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

        let (__warp_se_31) = warp_mul_unsafe256(__warp_usrid_02_a, __warp_usrid_03_b);

        let __warp_usrid_06_prod0 = __warp_se_31;

        let (__warp_usrid_07_mm) = warp_mulmod(
            __warp_usrid_02_a,
            __warp_usrid_03_b,
            Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        );

        let __warp_usrid_08_prod1 = Uint256(low=0, high=0);

        let (__warp_se_32) = warp_sub_unsafe256(__warp_usrid_07_mm, __warp_usrid_06_prod0);

        let __warp_usrid_08_prod1 = __warp_se_32;

        let (__warp_se_33) = warp_lt256(__warp_usrid_07_mm, __warp_usrid_06_prod0);

        if (__warp_se_33 != 0) {
            let (__warp_se_34) = warp_sub_unsafe256(__warp_usrid_08_prod1, Uint256(low=1, high=0));

            let __warp_usrid_08_prod1 = __warp_se_34;

            let (__warp_se_35) = s2___warp_usrfn_00_mulDiv_if_part1(
                __warp_usrid_08_prod1,
                __warp_usrid_04_denominator,
                __warp_usrid_05_result,
                __warp_usrid_06_prod0,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
            );

            return (__warp_se_35,);
        } else {
            let (__warp_se_36) = s2___warp_usrfn_00_mulDiv_if_part1(
                __warp_usrid_08_prod1,
                __warp_usrid_04_denominator,
                __warp_usrid_05_result,
                __warp_usrid_06_prod0,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
            );

            return (__warp_se_36,);
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

        let (__warp_se_37) = warp_eq256(__warp_usrid_08_prod1, Uint256(low=0, high=0));

        if (__warp_se_37 != 0) {
            let (__warp_se_38) = warp_gt256(__warp_usrid_04_denominator, Uint256(low=0, high=0));

            assert __warp_se_38 = 1;

            let (__warp_se_39) = warp_div_unsafe256(
                __warp_usrid_06_prod0, __warp_usrid_04_denominator
            );

            let __warp_usrid_05_result = __warp_se_39;

            return (__warp_usrid_05_result,);
        } else {
            let (__warp_se_40) = s2___warp_usrfn_00_mulDiv_if_part1_if_part1(
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
                __warp_usrid_06_prod0,
                __warp_usrid_05_result,
            );

            return (__warp_se_40,);
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

        let (__warp_se_41) = warp_gt256(__warp_usrid_04_denominator, __warp_usrid_08_prod1);

        assert __warp_se_41 = 1;

        let __warp_usrid_09_remainder = Uint256(low=0, high=0);

        let (__warp_se_42) = warp_mulmod(
            __warp_usrid_02_a, __warp_usrid_03_b, __warp_usrid_04_denominator
        );

        let __warp_usrid_09_remainder = __warp_se_42;

        let (__warp_se_43) = warp_gt256(__warp_usrid_09_remainder, __warp_usrid_06_prod0);

        if (__warp_se_43 != 0) {
            let (__warp_se_44) = warp_sub_unsafe256(__warp_usrid_08_prod1, Uint256(low=1, high=0));

            let __warp_usrid_08_prod1 = __warp_se_44;

            let (__warp_se_45) = s2___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1(
                __warp_usrid_06_prod0,
                __warp_usrid_09_remainder,
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_05_result,
            );

            return (__warp_se_45,);
        } else {
            let (__warp_se_46) = s2___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1(
                __warp_usrid_06_prod0,
                __warp_usrid_09_remainder,
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_05_result,
            );

            return (__warp_se_46,);
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

        let (__warp_se_47) = warp_sub_unsafe256(__warp_usrid_06_prod0, __warp_usrid_09_remainder);

        let __warp_usrid_06_prod0 = __warp_se_47;

        let (__warp_se_48) = warp_negate256(__warp_usrid_04_denominator);

        let (__warp_usrid_10_twos) = warp_bitwise_and256(__warp_se_48, __warp_usrid_04_denominator);

        let (__warp_se_49) = warp_div_unsafe256(__warp_usrid_04_denominator, __warp_usrid_10_twos);

        let __warp_usrid_04_denominator = __warp_se_49;

        let (__warp_se_50) = warp_div_unsafe256(__warp_usrid_06_prod0, __warp_usrid_10_twos);

        let __warp_usrid_06_prod0 = __warp_se_50;

        let (__warp_se_51) = warp_sub_unsafe256(Uint256(low=0, high=0), __warp_usrid_10_twos);

        let (__warp_se_52) = warp_div_unsafe256(__warp_se_51, __warp_usrid_10_twos);

        let (__warp_se_53) = warp_add_unsafe256(__warp_se_52, Uint256(low=1, high=0));

        let __warp_usrid_10_twos = __warp_se_53;

        let (__warp_se_54) = warp_mul_unsafe256(__warp_usrid_08_prod1, __warp_usrid_10_twos);

        let (__warp_se_55) = warp_bitwise_or256(__warp_usrid_06_prod0, __warp_se_54);

        let __warp_usrid_06_prod0 = __warp_se_55;

        let (__warp_se_56) = warp_mul_unsafe256(
            Uint256(low=3, high=0), __warp_usrid_04_denominator
        );

        let (__warp_usrid_11_inv) = warp_xor256(__warp_se_56, Uint256(low=2, high=0));

        let (__warp_se_57) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_58) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_57);

        let (__warp_se_59) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_58);

        let __warp_usrid_11_inv = __warp_se_59;

        let (__warp_se_60) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_61) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_60);

        let (__warp_se_62) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_61);

        let __warp_usrid_11_inv = __warp_se_62;

        let (__warp_se_63) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_64) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_63);

        let (__warp_se_65) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_64);

        let __warp_usrid_11_inv = __warp_se_65;

        let (__warp_se_66) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_67) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_66);

        let (__warp_se_68) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_67);

        let __warp_usrid_11_inv = __warp_se_68;

        let (__warp_se_69) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_70) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_69);

        let (__warp_se_71) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_70);

        let __warp_usrid_11_inv = __warp_se_71;

        let (__warp_se_72) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_73) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_72);

        let (__warp_se_74) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_73);

        let __warp_usrid_11_inv = __warp_se_74;

        let (__warp_se_75) = warp_mul_unsafe256(__warp_usrid_06_prod0, __warp_usrid_11_inv);

        let __warp_usrid_05_result = __warp_se_75;

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

        let (__warp_se_76) = s2___warp_usrfn_00_mulDiv(
            __warp_usrid_12_a, __warp_usrid_13_b, __warp_usrid_14_denominator
        );

        let __warp_usrid_15_result = __warp_se_76;

        let (__warp_se_77) = warp_mulmod(
            __warp_usrid_12_a, __warp_usrid_13_b, __warp_usrid_14_denominator
        );

        let (__warp_se_78) = warp_gt256(__warp_se_77, Uint256(low=0, high=0));

        if (__warp_se_78 != 0) {
            let (__warp_se_79) = warp_lt256(
                __warp_usrid_15_result,
                Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
            );

            assert __warp_se_79 = 1;

            let (__warp_se_80) = warp_add_unsafe256(__warp_usrid_15_result, Uint256(low=1, high=0));

            let __warp_se_81 = __warp_se_80;

            let __warp_usrid_15_result = __warp_se_81;

            warp_sub_unsafe256(__warp_se_81, Uint256(low=1, high=0));

            let (__warp_se_82) = s2___warp_usrfn_01_mulDivRoundingUp_if_part1(
                __warp_usrid_15_result
            );

            return (__warp_se_82,);
        } else {
            let (__warp_se_83) = s2___warp_usrfn_01_mulDivRoundingUp_if_part1(
                __warp_usrid_15_result
            );

            return (__warp_se_83,);
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

        let (__warp_se_84) = warp_eq256(__warp_usrid_10_amount, Uint256(low=0, high=0));

        if (__warp_se_84 != 0) {
            return (__warp_usrid_08_sqrtPX96,);
        } else {
            let (__warp_se_85) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1(
                __warp_usrid_09_liquidity,
                __warp_usrid_11_add,
                __warp_usrid_10_amount,
                __warp_usrid_08_sqrtPX96,
            );

            return (__warp_se_85,);
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

        let (__warp_se_86) = warp_uint256(__warp_usrid_09_liquidity);

        let (__warp_usrid_13_numerator1) = warp_shl256(__warp_se_86, 96);

        if (__warp_usrid_11_add != 0) {
            let __warp_usrid_14_product = Uint256(low=0, high=0);

            let (__warp_se_87) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_88) = warp_mul_unsafe256(__warp_usrid_10_amount, __warp_se_87);

            let __warp_se_89 = __warp_se_88;

            let __warp_usrid_14_product = __warp_se_89;

            let (__warp_se_90) = warp_div_unsafe256(__warp_se_89, __warp_usrid_10_amount);

            let (__warp_se_91) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_92) = warp_eq256(__warp_se_90, __warp_se_91);

            if (__warp_se_92 != 0) {
                let (__warp_usrid_15_denominator) = warp_add_unsafe256(
                    __warp_usrid_13_numerator1, __warp_usrid_14_product
                );

                let (__warp_se_93) = warp_ge256(
                    __warp_usrid_15_denominator, __warp_usrid_13_numerator1
                );

                if (__warp_se_93 != 0) {
                    let (__warp_se_94) = warp_uint256(__warp_usrid_08_sqrtPX96);

                    let (__warp_se_95) = s2___warp_usrfn_01_mulDivRoundingUp(
                        __warp_usrid_13_numerator1, __warp_se_94, __warp_usrid_15_denominator
                    );

                    let (__warp_se_96) = warp_int256_to_int160(__warp_se_95);

                    return (__warp_se_96,);
                } else {
                    let (
                        __warp_se_97
                    ) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part3(
                        __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
                    );

                    return (__warp_se_97,);
                }
            } else {
                let (
                    __warp_se_98
                ) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2(
                    __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
                );

                return (__warp_se_98,);
            }
        } else {
            let __warp_usrid_16_product = Uint256(low=0, high=0);

            let (__warp_se_99) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_100) = warp_mul_unsafe256(__warp_usrid_10_amount, __warp_se_99);

            let __warp_se_101 = __warp_se_100;

            let __warp_usrid_16_product = __warp_se_101;

            let (__warp_se_102) = warp_div_unsafe256(__warp_se_101, __warp_usrid_10_amount);

            let (__warp_se_103) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_104) = warp_eq256(__warp_se_102, __warp_se_103);

            let (__warp_se_105) = warp_gt256(__warp_usrid_13_numerator1, __warp_usrid_16_product);

            let (__warp_se_106) = warp_and_(__warp_se_104, __warp_se_105);

            assert __warp_se_106 = 1;

            let (__warp_usrid_17_denominator) = warp_sub_unsafe256(
                __warp_usrid_13_numerator1, __warp_usrid_16_product
            );

            let (__warp_se_107) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_108) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_usrid_13_numerator1, __warp_se_107, __warp_usrid_17_denominator
            );

            let (__warp_se_109) = s6___warp_usrfn_00_toUint160(__warp_se_108);

            return (__warp_se_109,);
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
            __warp_se_110
        ) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2(
            __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
        );

        return (__warp_se_110,);
    }

    func s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_13_numerator1: Uint256,
        __warp_usrid_08_sqrtPX96: felt,
        __warp_usrid_10_amount: Uint256,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (__warp_se_111) = warp_uint256(__warp_usrid_08_sqrtPX96);

        let (__warp_se_112) = warp_div256(__warp_usrid_13_numerator1, __warp_se_111);

        let (__warp_se_113) = s5___warp_usrfn_00_add(__warp_se_112, __warp_usrid_10_amount);

        let (__warp_se_114) = s4___warp_usrfn_00_divRoundingUp(
            __warp_usrid_13_numerator1, __warp_se_113
        );

        let (__warp_se_115) = warp_int256_to_int160(__warp_se_114);

        return (__warp_se_115,);
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

            let (__warp_se_116) = warp_uint256(1461501637330902918203684832716283019655932542975);

            let (__warp_se_117) = warp_le256(__warp_usrid_20_amount, __warp_se_116);

            if (__warp_se_117 != 0) {
                let (__warp_se_118) = warp_shl256(__warp_usrid_20_amount, 96);

                let (__warp_se_119) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_120) = warp_div_unsafe256(__warp_se_118, __warp_se_119);

                let __warp_usrid_23_quotient = __warp_se_120;

                let (
                    __warp_se_121
                ) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_23_quotient
                );

                return (__warp_se_121,);
            } else {
                let (__warp_se_122) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_123) = s2___warp_usrfn_00_mulDiv(
                    __warp_usrid_20_amount,
                    Uint256(low=79228162514264337593543950336, high=0),
                    __warp_se_122,
                );

                let __warp_usrid_23_quotient = __warp_se_123;

                let (
                    __warp_se_124
                ) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_23_quotient
                );

                return (__warp_se_124,);
            }
        } else {
            let __warp_usrid_24_quotient = Uint256(low=0, high=0);

            let (__warp_se_125) = warp_uint256(1461501637330902918203684832716283019655932542975);

            let (__warp_se_126) = warp_le256(__warp_usrid_20_amount, __warp_se_125);

            if (__warp_se_126 != 0) {
                let (__warp_se_127) = warp_shl256(__warp_usrid_20_amount, 96);

                let (__warp_se_128) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_129) = s4___warp_usrfn_00_divRoundingUp(
                    __warp_se_127, __warp_se_128
                );

                let __warp_usrid_24_quotient = __warp_se_129;

                let (
                    __warp_se_130
                ) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_24_quotient
                );

                return (__warp_se_130,);
            } else {
                let (__warp_se_131) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_132) = s2___warp_usrfn_01_mulDivRoundingUp(
                    __warp_usrid_20_amount,
                    Uint256(low=79228162514264337593543950336, high=0),
                    __warp_se_131,
                );

                let __warp_usrid_24_quotient = __warp_se_132;

                let (
                    __warp_se_133
                ) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_24_quotient
                );

                return (__warp_se_133,);
            }
        }
    }

    func s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_18_sqrtPX96: felt, __warp_usrid_24_quotient: Uint256) -> (
        __warp_usrid_22_: felt
    ) {
        alloc_locals;

        let (__warp_se_134) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_135) = warp_gt256(__warp_se_134, __warp_usrid_24_quotient);

        assert __warp_se_135 = 1;

        let (__warp_se_136) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_137) = warp_sub256(__warp_se_136, __warp_usrid_24_quotient);

        let (__warp_se_138) = warp_int256_to_int160(__warp_se_137);

        return (__warp_se_138,);
    }

    func s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_18_sqrtPX96: felt, __warp_usrid_23_quotient: Uint256) -> (
        __warp_usrid_22_: felt
    ) {
        alloc_locals;

        let (__warp_se_139) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_140) = s5___warp_usrfn_00_add(__warp_se_139, __warp_usrid_23_quotient);

        let (__warp_se_141) = s6___warp_usrfn_00_toUint160(__warp_se_140);

        return (__warp_se_141,);
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

        let (__warp_se_142) = warp_gt(__warp_usrid_25_sqrtPX96, 0);

        assert __warp_se_142 = 1;

        let (__warp_se_143) = warp_gt(__warp_usrid_26_liquidity, 0);

        assert __warp_se_143 = 1;

        if (__warp_usrid_28_zeroForOne != 0) {
            let (__warp_se_144) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp(
                __warp_usrid_25_sqrtPX96, __warp_usrid_26_liquidity, __warp_usrid_27_amountIn, 1
            );

            return (__warp_se_144,);
        } else {
            let (__warp_se_145) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown(
                __warp_usrid_25_sqrtPX96, __warp_usrid_26_liquidity, __warp_usrid_27_amountIn, 1
            );

            return (__warp_se_145,);
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

        let (__warp_se_146) = warp_gt(__warp_usrid_30_sqrtPX96, 0);

        assert __warp_se_146 = 1;

        let (__warp_se_147) = warp_gt(__warp_usrid_31_liquidity, 0);

        assert __warp_se_147 = 1;

        if (__warp_usrid_33_zeroForOne != 0) {
            let (__warp_se_148) = s3___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown(
                __warp_usrid_30_sqrtPX96, __warp_usrid_31_liquidity, __warp_usrid_32_amountOut, 0
            );

            return (__warp_se_148,);
        } else {
            let (__warp_se_149) = s3___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp(
                __warp_usrid_30_sqrtPX96, __warp_usrid_31_liquidity, __warp_usrid_32_amountOut, 0
            );

            return (__warp_se_149,);
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

        let (__warp_se_150) = warp_gt(__warp_usrid_35_sqrtRatioAX96, __warp_usrid_36_sqrtRatioBX96);

        if (__warp_se_150 != 0) {
            let __warp_tv_0 = __warp_usrid_36_sqrtRatioBX96;

            let __warp_tv_1 = __warp_usrid_35_sqrtRatioAX96;

            let __warp_usrid_36_sqrtRatioBX96 = __warp_tv_1;

            let __warp_usrid_35_sqrtRatioAX96 = __warp_tv_0;

            let (__warp_se_151) = s3___warp_usrfn_04_getAmount0Delta_if_part1(
                __warp_usrid_37_liquidity,
                __warp_usrid_36_sqrtRatioBX96,
                __warp_usrid_35_sqrtRatioAX96,
                __warp_usrid_38_roundUp,
            );

            return (__warp_se_151,);
        } else {
            let (__warp_se_152) = s3___warp_usrfn_04_getAmount0Delta_if_part1(
                __warp_usrid_37_liquidity,
                __warp_usrid_36_sqrtRatioBX96,
                __warp_usrid_35_sqrtRatioAX96,
                __warp_usrid_38_roundUp,
            );

            return (__warp_se_152,);
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

        let (__warp_se_153) = warp_uint256(__warp_usrid_37_liquidity);

        let (__warp_usrid_40_numerator1) = warp_shl256(__warp_se_153, 96);

        let (__warp_se_154) = warp_sub(
            __warp_usrid_36_sqrtRatioBX96, __warp_usrid_35_sqrtRatioAX96
        );

        let (__warp_usrid_41_numerator2) = warp_uint256(__warp_se_154);

        let (__warp_se_155) = warp_gt(__warp_usrid_35_sqrtRatioAX96, 0);

        assert __warp_se_155 = 1;

        if (__warp_usrid_38_roundUp != 0) {
            let (__warp_se_156) = warp_uint256(__warp_usrid_36_sqrtRatioBX96);

            let (__warp_se_157) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_usrid_40_numerator1, __warp_usrid_41_numerator2, __warp_se_156
            );

            let (__warp_se_158) = warp_uint256(__warp_usrid_35_sqrtRatioAX96);

            let (__warp_se_159) = s4___warp_usrfn_00_divRoundingUp(__warp_se_157, __warp_se_158);

            return (__warp_se_159,);
        } else {
            let (__warp_se_160) = warp_uint256(__warp_usrid_36_sqrtRatioBX96);

            let (__warp_se_161) = s2___warp_usrfn_00_mulDiv(
                __warp_usrid_40_numerator1, __warp_usrid_41_numerator2, __warp_se_160
            );

            let (__warp_se_162) = warp_uint256(__warp_usrid_35_sqrtRatioAX96);

            let (__warp_se_163) = warp_div256(__warp_se_161, __warp_se_162);

            return (__warp_se_163,);
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

        let (__warp_se_164) = warp_gt(__warp_usrid_42_sqrtRatioAX96, __warp_usrid_43_sqrtRatioBX96);

        if (__warp_se_164 != 0) {
            let __warp_tv_2 = __warp_usrid_43_sqrtRatioBX96;

            let __warp_tv_3 = __warp_usrid_42_sqrtRatioAX96;

            let __warp_usrid_43_sqrtRatioBX96 = __warp_tv_3;

            let __warp_usrid_42_sqrtRatioAX96 = __warp_tv_2;

            let (__warp_se_165) = s3___warp_usrfn_05_getAmount1Delta_if_part1(
                __warp_usrid_45_roundUp,
                __warp_usrid_44_liquidity,
                __warp_usrid_43_sqrtRatioBX96,
                __warp_usrid_42_sqrtRatioAX96,
            );

            return (__warp_se_165,);
        } else {
            let (__warp_se_166) = s3___warp_usrfn_05_getAmount1Delta_if_part1(
                __warp_usrid_45_roundUp,
                __warp_usrid_44_liquidity,
                __warp_usrid_43_sqrtRatioBX96,
                __warp_usrid_42_sqrtRatioAX96,
            );

            return (__warp_se_166,);
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
            let (__warp_se_167) = warp_uint256(__warp_usrid_44_liquidity);

            let (__warp_se_168) = warp_sub(
                __warp_usrid_43_sqrtRatioBX96, __warp_usrid_42_sqrtRatioAX96
            );

            let (__warp_se_169) = warp_uint256(__warp_se_168);

            let (__warp_se_170) = s2___warp_usrfn_01_mulDivRoundingUp(
                __warp_se_167, __warp_se_169, Uint256(low=79228162514264337593543950336, high=0)
            );

            return (__warp_se_170,);
        } else {
            let (__warp_se_171) = warp_uint256(__warp_usrid_44_liquidity);

            let (__warp_se_172) = warp_sub(
                __warp_usrid_43_sqrtRatioBX96, __warp_usrid_42_sqrtRatioAX96
            );

            let (__warp_se_173) = warp_uint256(__warp_se_172);

            let (__warp_se_174) = s2___warp_usrfn_00_mulDiv(
                __warp_se_171, __warp_se_173, Uint256(low=79228162514264337593543950336, high=0)
            );

            return (__warp_se_174,);
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

        let (__warp_se_175) = warp_mod256(__warp_usrid_01_x, __warp_usrid_02_y);

        let (__warp_se_176) = warp_gt256(__warp_se_175, Uint256(low=0, high=0));

        if (__warp_se_176 != 0) {
            let __warp_usrid_04_temp = Uint256(low=1, high=0);

            let (__warp_se_177) = s4___warp_usrfn_00_divRoundingUp_if_part1(
                __warp_usrid_03_z, __warp_usrid_01_x, __warp_usrid_02_y, __warp_usrid_04_temp
            );

            return (__warp_se_177,);
        } else {
            let (__warp_se_178) = s4___warp_usrfn_00_divRoundingUp_if_part1(
                __warp_usrid_03_z, __warp_usrid_01_x, __warp_usrid_02_y, __warp_usrid_04_temp
            );

            return (__warp_se_178,);
        }
    }

    func s4___warp_usrfn_00_divRoundingUp_if_part1{range_check_ptr: felt}(
        __warp_usrid_03_z: Uint256,
        __warp_usrid_01_x: Uint256,
        __warp_usrid_02_y: Uint256,
        __warp_usrid_04_temp: Uint256,
    ) -> (__warp_usrid_03_z: Uint256) {
        alloc_locals;

        let (__warp_se_179) = warp_div_unsafe256(__warp_usrid_01_x, __warp_usrid_02_y);

        let (__warp_se_180) = warp_add_unsafe256(__warp_se_179, __warp_usrid_04_temp);

        let __warp_usrid_03_z = __warp_se_180;

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

        let (__warp_se_181) = warp_add256(__warp_usrid_05_x, __warp_usrid_06_y);

        let __warp_se_182 = __warp_se_181;

        let __warp_usrid_07_z = __warp_se_182;

        let (__warp_se_183) = warp_ge256(__warp_se_182, __warp_usrid_05_x);

        assert __warp_se_183 = 1;

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

        let (__warp_se_184) = warp_int256_to_int160(__warp_usrid_03_y);

        let __warp_se_185 = __warp_se_184;

        let __warp_usrid_04_z = __warp_se_185;

        let (__warp_se_186) = warp_uint256(__warp_se_185);

        let (__warp_se_187) = warp_eq256(__warp_se_186, __warp_usrid_03_y);

        assert __warp_se_187 = 1;

        return (__warp_usrid_04_z,);
    }
}

@view
func computeSwapStep_100d3f74{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_00_sqrtP: felt,
    __warp_usrid_01_sqrtPTarget: felt,
    __warp_usrid_02_liquidity: felt,
    __warp_usrid_03_amountRemaining: Uint256,
    __warp_usrid_04_feePips: felt,
) -> (
    __warp_usrid_05_sqrtQ: felt,
    __warp_usrid_06_amountIn: Uint256,
    __warp_usrid_07_amountOut: Uint256,
    __warp_usrid_08_feeAmount: Uint256,
) {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_04_feePips);

    warp_external_input_check_int256(__warp_usrid_03_amountRemaining);

    warp_external_input_check_int128(__warp_usrid_02_liquidity);

    warp_external_input_check_int160(__warp_usrid_01_sqrtPTarget);

    warp_external_input_check_int160(__warp_usrid_00_sqrtP);

    let (
        __warp_usrid_05_sqrtQ,
        __warp_usrid_06_amountIn,
        __warp_usrid_07_amountOut,
        __warp_usrid_08_feeAmount,
    ) = SwapMathTest.s1___warp_usrfn_00_computeSwapStep(
        __warp_usrid_00_sqrtP,
        __warp_usrid_01_sqrtPTarget,
        __warp_usrid_02_liquidity,
        __warp_usrid_03_amountRemaining,
        __warp_usrid_04_feePips,
    );

    return (
        __warp_usrid_05_sqrtQ,
        __warp_usrid_06_amountIn,
        __warp_usrid_07_amountOut,
        __warp_usrid_08_feeAmount,
    );
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","computeSwapStep(uint160,uint160,uint128,int256,uint24)"]
