%lang starknet

from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int24,
    warp_external_input_check_int160,
)
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.lt_signed import warp_lt_signed24
from warplib.maths.int_conversions import (
    warp_int24_to_int256,
    warp_uint256,
    warp_int256_to_int160,
    warp_int256_to_int24,
)
from warplib.maths.negate import warp_negate256
from warplib.maths.le import warp_le256, warp_le
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.neq import warp_neq256
from warplib.maths.mul import warp_mul256
from warplib.maths.shr import warp_shr256, warp_shr256_256
from warplib.maths.gt_signed import warp_gt_signed24
from warplib.maths.div import warp_div256
from warplib.maths.mod import warp_mod256
from warplib.maths.eq import warp_eq256, warp_eq
from warplib.maths.add import warp_add256
from warplib.maths.ge import warp_ge, warp_ge256
from warplib.maths.lt import warp_lt
from warplib.maths.and_ import warp_and_
from warplib.maths.shl import warp_shl256, warp_shl256_256
from warplib.maths.gt import warp_gt256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.sub import warp_sub256
from warplib.maths.sub_signed import warp_sub_signed256
from warplib.maths.mul_signed import warp_mul_signed256
from warplib.maths.shr_signed import warp_shr_signed256
from warplib.maths.add_signed import warp_add_signed256

// Contract Def TickMathTest

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

namespace TickMathTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    // @notice Calculates sqrt(1.0001^tick) * 2^96
    // @dev Throws if |tick| > max tick
    // @param tick The input tick for the above formula
    // @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
    // at the given tick
    func s1___warp_usrfn_00_getSqrtRatioAtTick{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_06_tick: felt
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let __warp_usrid_07_sqrtPriceX96 = 0;

        let __warp_usrid_08_absTick = Uint256(low=0, high=0);

        let (__warp_se_2) = warp_lt_signed24(__warp_usrid_06_tick, 0);

        if (__warp_se_2 != 0) {
            let (__warp_se_3) = warp_int24_to_int256(__warp_usrid_06_tick);

            let (__warp_se_4) = warp_negate256(__warp_se_3);

            let __warp_usrid_08_absTick = __warp_se_4;

            let (__warp_se_5) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1(
                __warp_usrid_08_absTick, __warp_usrid_06_tick, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_5,);
        } else {
            let (__warp_se_6) = warp_int24_to_int256(__warp_usrid_06_tick);

            let __warp_usrid_08_absTick = __warp_se_6;

            let (__warp_se_7) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1(
                __warp_usrid_08_absTick, __warp_usrid_06_tick, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_7,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_8) = warp_uint256(887272);

        let (__warp_se_9) = warp_le256(__warp_usrid_08_absTick, __warp_se_8);

        with_attr error_message("T") {
            assert __warp_se_9 = 1;
        }

        let __warp_usrid_09_ratio = Uint256(low=0, high=1);

        let (__warp_se_10) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=1, high=0));

        let (__warp_se_11) = warp_neq256(__warp_se_10, Uint256(low=0, high=0));

        if (__warp_se_11 != 0) {
            let __warp_usrid_09_ratio = Uint256(
                low=340265354078544963557816517032075149313, high=0
            );

            let (__warp_se_12) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_12,);
        } else {
            let (__warp_se_13) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_13,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_14) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=2, high=0));

        let (__warp_se_15) = warp_neq256(__warp_se_14, Uint256(low=0, high=0));

        if (__warp_se_15 != 0) {
            let (__warp_se_16) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=340248342086729790484326174814286782778, high=0)
            );

            let (__warp_se_17) = warp_shr256(__warp_se_16, 128);

            let __warp_usrid_09_ratio = __warp_se_17;

            let (__warp_se_18) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_18,);
        } else {
            let (__warp_se_19) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_19,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_20) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=4, high=0));

        let (__warp_se_21) = warp_neq256(__warp_se_20, Uint256(low=0, high=0));

        if (__warp_se_21 != 0) {
            let (__warp_se_22) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=340214320654664324051920982716015181260, high=0)
            );

            let (__warp_se_23) = warp_shr256(__warp_se_22, 128);

            let __warp_usrid_09_ratio = __warp_se_23;

            let (
                __warp_se_24
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_24,);
        } else {
            let (
                __warp_se_25
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_25,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_26) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=8, high=0));

        let (__warp_se_27) = warp_neq256(__warp_se_26, Uint256(low=0, high=0));

        if (__warp_se_27 != 0) {
            let (__warp_se_28) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=340146287995602323631171512101879684304, high=0)
            );

            let (__warp_se_29) = warp_shr256(__warp_se_28, 128);

            let __warp_usrid_09_ratio = __warp_se_29;

            let (
                __warp_se_30
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_30,);
        } else {
            let (
                __warp_se_31
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_31,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_32) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=16, high=0));

        let (__warp_se_33) = warp_neq256(__warp_se_32, Uint256(low=0, high=0));

        if (__warp_se_33 != 0) {
            let (__warp_se_34) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=340010263488231146823593991679159461444, high=0)
            );

            let (__warp_se_35) = warp_shr256(__warp_se_34, 128);

            let __warp_usrid_09_ratio = __warp_se_35;

            let (
                __warp_se_36
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_36,);
        } else {
            let (
                __warp_se_37
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_37,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_38) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=32, high=0));

        let (__warp_se_39) = warp_neq256(__warp_se_38, Uint256(low=0, high=0));

        if (__warp_se_39 != 0) {
            let (__warp_se_40) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=339738377640345403697157401104375502016, high=0)
            );

            let (__warp_se_41) = warp_shr256(__warp_se_40, 128);

            let __warp_usrid_09_ratio = __warp_se_41;

            let (
                __warp_se_42
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_42,);
        } else {
            let (
                __warp_se_43
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_43,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_44) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=64, high=0));

        let (__warp_se_45) = warp_neq256(__warp_se_44, Uint256(low=0, high=0));

        if (__warp_se_45 != 0) {
            let (__warp_se_46) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=339195258003219555707034227454543997025, high=0)
            );

            let (__warp_se_47) = warp_shr256(__warp_se_46, 128);

            let __warp_usrid_09_ratio = __warp_se_47;

            let (
                __warp_se_48
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_48,);
        } else {
            let (
                __warp_se_49
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_49,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_50) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=128, high=0));

        let (__warp_se_51) = warp_neq256(__warp_se_50, Uint256(low=0, high=0));

        if (__warp_se_51 != 0) {
            let (__warp_se_52) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=338111622100601834656805679988414885971, high=0)
            );

            let (__warp_se_53) = warp_shr256(__warp_se_52, 128);

            let __warp_usrid_09_ratio = __warp_se_53;

            let (
                __warp_se_54
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_54,);
        } else {
            let (
                __warp_se_55
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_55,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_56) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=256, high=0));

        let (__warp_se_57) = warp_neq256(__warp_se_56, Uint256(low=0, high=0));

        if (__warp_se_57 != 0) {
            let (__warp_se_58) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=335954724994790223023589805789778977700, high=0)
            );

            let (__warp_se_59) = warp_shr256(__warp_se_58, 128);

            let __warp_usrid_09_ratio = __warp_se_59;

            let (
                __warp_se_60
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_60,);
        } else {
            let (
                __warp_se_61
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_61,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_62) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=512, high=0));

        let (__warp_se_63) = warp_neq256(__warp_se_62, Uint256(low=0, high=0));

        if (__warp_se_63 != 0) {
            let (__warp_se_64) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=331682121138379247127172139078559817300, high=0)
            );

            let (__warp_se_65) = warp_shr256(__warp_se_64, 128);

            let __warp_usrid_09_ratio = __warp_se_65;

            let (
                __warp_se_66
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_66,);
        } else {
            let (
                __warp_se_67
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_67,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_68) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=1024, high=0)
        );

        let (__warp_se_69) = warp_neq256(__warp_se_68, Uint256(low=0, high=0));

        if (__warp_se_69 != 0) {
            let (__warp_se_70) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=323299236684853023288211250268160618739, high=0)
            );

            let (__warp_se_71) = warp_shr256(__warp_se_70, 128);

            let __warp_usrid_09_ratio = __warp_se_71;

            let (
                __warp_se_72
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_72,);
        } else {
            let (
                __warp_se_73
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_73,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_74) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=2048, high=0)
        );

        let (__warp_se_75) = warp_neq256(__warp_se_74, Uint256(low=0, high=0));

        if (__warp_se_75 != 0) {
            let (__warp_se_76) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=307163716377032989948697243942600083929, high=0)
            );

            let (__warp_se_77) = warp_shr256(__warp_se_76, 128);

            let __warp_usrid_09_ratio = __warp_se_77;

            let (
                __warp_se_78
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_78,);
        } else {
            let (
                __warp_se_79
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_79,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_80) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=4096, high=0)
        );

        let (__warp_se_81) = warp_neq256(__warp_se_80, Uint256(low=0, high=0));

        if (__warp_se_81 != 0) {
            let (__warp_se_82) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=277268403626896220162999269216087595045, high=0)
            );

            let (__warp_se_83) = warp_shr256(__warp_se_82, 128);

            let __warp_usrid_09_ratio = __warp_se_83;

            let (
                __warp_se_84
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_84,);
        } else {
            let (
                __warp_se_85
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_85,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_86) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=8192, high=0)
        );

        let (__warp_se_87) = warp_neq256(__warp_se_86, Uint256(low=0, high=0));

        if (__warp_se_87 != 0) {
            let (__warp_se_88) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=225923453940442621947126027127485391333, high=0)
            );

            let (__warp_se_89) = warp_shr256(__warp_se_88, 128);

            let __warp_usrid_09_ratio = __warp_se_89;

            let (
                __warp_se_90
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_90,);
        } else {
            let (
                __warp_se_91
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_91,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_92) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=16384, high=0)
        );

        let (__warp_se_93) = warp_neq256(__warp_se_92, Uint256(low=0, high=0));

        if (__warp_se_93 != 0) {
            let (__warp_se_94) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=149997214084966997727330242082538205943, high=0)
            );

            let (__warp_se_95) = warp_shr256(__warp_se_94, 128);

            let __warp_usrid_09_ratio = __warp_se_95;

            let (
                __warp_se_96
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_96,);
        } else {
            let (
                __warp_se_97
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_97,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_98) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=32768, high=0)
        );

        let (__warp_se_99) = warp_neq256(__warp_se_98, Uint256(low=0, high=0));

        if (__warp_se_99 != 0) {
            let (__warp_se_100) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=66119101136024775622716233608466517926, high=0)
            );

            let (__warp_se_101) = warp_shr256(__warp_se_100, 128);

            let __warp_usrid_09_ratio = __warp_se_101;

            let (
                __warp_se_102
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_102,);
        } else {
            let (
                __warp_se_103
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_103,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_104) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=65536, high=0)
        );

        let (__warp_se_105) = warp_neq256(__warp_se_104, Uint256(low=0, high=0));

        if (__warp_se_105 != 0) {
            let (__warp_se_106) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=12847376061809297530290974190478138313, high=0)
            );

            let (__warp_se_107) = warp_shr256(__warp_se_106, 128);

            let __warp_usrid_09_ratio = __warp_se_107;

            let (
                __warp_se_108
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_108,);
        } else {
            let (
                __warp_se_109
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_109,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_110) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=131072, high=0)
        );

        let (__warp_se_111) = warp_neq256(__warp_se_110, Uint256(low=0, high=0));

        if (__warp_se_111 != 0) {
            let (__warp_se_112) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=485053260817066172746253684029974020, high=0)
            );

            let (__warp_se_113) = warp_shr256(__warp_se_112, 128);

            let __warp_usrid_09_ratio = __warp_se_113;

            let (
                __warp_se_114
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_114,);
        } else {
            let (
                __warp_se_115
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_115,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_116) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=262144, high=0)
        );

        let (__warp_se_117) = warp_neq256(__warp_se_116, Uint256(low=0, high=0));

        if (__warp_se_117 != 0) {
            let (__warp_se_118) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=691415978906521570653435304214168, high=0)
            );

            let (__warp_se_119) = warp_shr256(__warp_se_118, 128);

            let __warp_usrid_09_ratio = __warp_se_119;

            let (
                __warp_se_120
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_120,);
        } else {
            let (
                __warp_se_121
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_121,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_absTick: Uint256,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_122) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=524288, high=0)
        );

        let (__warp_se_123) = warp_neq256(__warp_se_122, Uint256(low=0, high=0));

        if (__warp_se_123 != 0) {
            let (__warp_se_124) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=1404880482679654955896180642, high=0)
            );

            let (__warp_se_125) = warp_shr256(__warp_se_124, 128);

            let __warp_usrid_09_ratio = __warp_se_125;

            let (
                __warp_se_126
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_tick, __warp_usrid_09_ratio, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_126,);
        } else {
            let (
                __warp_se_127
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_tick, __warp_usrid_09_ratio, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_127,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_tick: felt,
        __warp_usrid_09_ratio: Uint256,
        __warp_usrid_07_sqrtPriceX96: felt,
    ) -> (__warp_usrid_07_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_128) = warp_gt_signed24(__warp_usrid_06_tick, 0);

        if (__warp_se_128 != 0) {
            let (__warp_se_129) = warp_div256(
                Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
                __warp_usrid_09_ratio,
            );

            let __warp_usrid_09_ratio = __warp_se_129;

            let (
                __warp_se_130
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_09_ratio, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_130,);
        } else {
            let (
                __warp_se_131
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_09_ratio, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_131,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_09_ratio: Uint256, __warp_usrid_07_sqrtPriceX96: felt) -> (
        __warp_usrid_07_sqrtPriceX96: felt
    ) {
        alloc_locals;

        let (__warp_se_132) = warp_mod256(__warp_usrid_09_ratio, Uint256(low=4294967296, high=0));

        let (__warp_se_133) = warp_eq256(__warp_se_132, Uint256(low=0, high=0));

        if (__warp_se_133 != 0) {
            let (__warp_se_134) = warp_shr256(__warp_usrid_09_ratio, 32);

            let (__warp_se_135) = warp_int256_to_int160(__warp_se_134);

            let __warp_usrid_07_sqrtPriceX96 = __warp_se_135;

            return (__warp_usrid_07_sqrtPriceX96,);
        } else {
            let (__warp_se_136) = warp_shr256(__warp_usrid_09_ratio, 32);

            let (__warp_se_137) = warp_add256(__warp_se_136, Uint256(low=1, high=0));

            let (__warp_se_138) = warp_int256_to_int160(__warp_se_137);

            let __warp_usrid_07_sqrtPriceX96 = __warp_se_138;

            return (__warp_usrid_07_sqrtPriceX96,);
        }
    }

    // @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
    // @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
    // ever return.
    // @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
    // @return tick The greatest tick for which the ratio is less than or equal to the input ratio
    func s1___warp_usrfn_01_getTickAtSqrtRatio{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_10_sqrtPriceX96: felt
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        let __warp_usrid_11_tick = 0;

        let (__warp_se_139) = warp_ge(__warp_usrid_10_sqrtPriceX96, 4295128739);

        let (__warp_se_140) = warp_lt(
            __warp_usrid_10_sqrtPriceX96, 1461446703485210103287273052203988822378723970342
        );

        let (__warp_se_141) = warp_and_(__warp_se_139, __warp_se_140);

        with_attr error_message("R") {
            assert __warp_se_141 = 1;
        }

        let (__warp_se_142) = warp_uint256(__warp_usrid_10_sqrtPriceX96);

        let (__warp_usrid_12_ratio) = warp_shl256(__warp_se_142, 32);

        let __warp_usrid_13_r = __warp_usrid_12_ratio;

        let __warp_usrid_14_msb = Uint256(low=0, high=0);

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_143) = warp_gt256(
            __warp_usrid_13_r, Uint256(low=340282366920938463463374607431768211455, high=0)
        );

        if (__warp_se_143 != 0) {
            let __warp_usrid_15_f = Uint256(low=128, high=0);

            let (__warp_se_144) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_144,);
        } else {
            let (__warp_se_145) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_145,);
        }
    }

    func s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_14_msb: Uint256,
        __warp_usrid_15_f: Uint256,
        __warp_usrid_13_r: Uint256,
        __warp_usrid_12_ratio: Uint256,
        __warp_usrid_11_tick: felt,
        __warp_usrid_10_sqrtPriceX96: felt,
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        let (__warp_se_146) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_146;

        let (__warp_se_147) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_147;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_148) = warp_gt256(
            __warp_usrid_13_r, Uint256(low=18446744073709551615, high=0)
        );

        if (__warp_se_148 != 0) {
            let __warp_usrid_15_f = Uint256(low=64, high=0);

            let (__warp_se_149) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_149,);
        } else {
            let (__warp_se_150) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_150,);
        }
    }

    func s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_14_msb: Uint256,
        __warp_usrid_15_f: Uint256,
        __warp_usrid_13_r: Uint256,
        __warp_usrid_12_ratio: Uint256,
        __warp_usrid_11_tick: felt,
        __warp_usrid_10_sqrtPriceX96: felt,
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        let (__warp_se_151) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_151;

        let (__warp_se_152) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_152;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_153) = warp_gt256(__warp_usrid_13_r, Uint256(low=4294967295, high=0));

        if (__warp_se_153 != 0) {
            let __warp_usrid_15_f = Uint256(low=32, high=0);

            let (__warp_se_154) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_154,);
        } else {
            let (__warp_se_155) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_155,);
        }
    }

    func s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_14_msb: Uint256,
        __warp_usrid_15_f: Uint256,
        __warp_usrid_13_r: Uint256,
        __warp_usrid_12_ratio: Uint256,
        __warp_usrid_11_tick: felt,
        __warp_usrid_10_sqrtPriceX96: felt,
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        let (__warp_se_156) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_156;

        let (__warp_se_157) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_157;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_158) = warp_gt256(__warp_usrid_13_r, Uint256(low=65535, high=0));

        if (__warp_se_158 != 0) {
            let __warp_usrid_15_f = Uint256(low=16, high=0);

            let (
                __warp_se_159
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_159,);
        } else {
            let (
                __warp_se_160
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_160,);
        }
    }

    func s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_14_msb: Uint256,
        __warp_usrid_15_f: Uint256,
        __warp_usrid_13_r: Uint256,
        __warp_usrid_12_ratio: Uint256,
        __warp_usrid_11_tick: felt,
        __warp_usrid_10_sqrtPriceX96: felt,
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        let (__warp_se_161) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_161;

        let (__warp_se_162) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_162;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_163) = warp_gt256(__warp_usrid_13_r, Uint256(low=255, high=0));

        if (__warp_se_163 != 0) {
            let __warp_usrid_15_f = Uint256(low=8, high=0);

            let (
                __warp_se_164
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_164,);
        } else {
            let (
                __warp_se_165
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_165,);
        }
    }

    func s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_14_msb: Uint256,
        __warp_usrid_15_f: Uint256,
        __warp_usrid_13_r: Uint256,
        __warp_usrid_12_ratio: Uint256,
        __warp_usrid_11_tick: felt,
        __warp_usrid_10_sqrtPriceX96: felt,
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        let (__warp_se_166) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_166;

        let (__warp_se_167) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_167;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_168) = warp_gt256(__warp_usrid_13_r, Uint256(low=15, high=0));

        if (__warp_se_168 != 0) {
            let __warp_usrid_15_f = Uint256(low=4, high=0);

            let (
                __warp_se_169
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_169,);
        } else {
            let (
                __warp_se_170
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_170,);
        }
    }

    func s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_14_msb: Uint256,
        __warp_usrid_15_f: Uint256,
        __warp_usrid_13_r: Uint256,
        __warp_usrid_12_ratio: Uint256,
        __warp_usrid_11_tick: felt,
        __warp_usrid_10_sqrtPriceX96: felt,
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        let (__warp_se_171) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_171;

        let (__warp_se_172) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_172;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_173) = warp_gt256(__warp_usrid_13_r, Uint256(low=3, high=0));

        if (__warp_se_173 != 0) {
            let __warp_usrid_15_f = Uint256(low=2, high=0);

            let (
                __warp_se_174
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_174,);
        } else {
            let (
                __warp_se_175
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_175,);
        }
    }

    func s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_14_msb: Uint256,
        __warp_usrid_15_f: Uint256,
        __warp_usrid_13_r: Uint256,
        __warp_usrid_12_ratio: Uint256,
        __warp_usrid_11_tick: felt,
        __warp_usrid_10_sqrtPriceX96: felt,
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        let (__warp_se_176) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_176;

        let (__warp_se_177) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_177;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_178) = warp_gt256(__warp_usrid_13_r, Uint256(low=1, high=0));

        if (__warp_se_178 != 0) {
            let __warp_usrid_15_f = Uint256(low=1, high=0);

            let (
                __warp_se_179
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_179,);
        } else {
            let (
                __warp_se_180
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_180,);
        }
    }

    func s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_14_msb: Uint256,
        __warp_usrid_15_f: Uint256,
        __warp_usrid_13_r: Uint256,
        __warp_usrid_12_ratio: Uint256,
        __warp_usrid_11_tick: felt,
        __warp_usrid_10_sqrtPriceX96: felt,
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        let (__warp_se_181) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_181;

        let (__warp_se_182) = warp_ge256(__warp_usrid_14_msb, Uint256(low=128, high=0));

        if (__warp_se_182 != 0) {
            let (__warp_se_183) = warp_sub256(__warp_usrid_14_msb, Uint256(low=127, high=0));

            let (__warp_se_184) = warp_shr256_256(__warp_usrid_12_ratio, __warp_se_183);

            let __warp_usrid_13_r = __warp_se_184;

            let (
                __warp_se_185
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_13_r,
                __warp_usrid_15_f,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_185,);
        } else {
            let (__warp_se_186) = warp_sub256(Uint256(low=127, high=0), __warp_usrid_14_msb);

            let (__warp_se_187) = warp_shl256_256(__warp_usrid_12_ratio, __warp_se_186);

            let __warp_usrid_13_r = __warp_se_187;

            let (
                __warp_se_188
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_13_r,
                __warp_usrid_15_f,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_188,);
        }
    }

    func s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_14_msb: Uint256,
        __warp_usrid_13_r: Uint256,
        __warp_usrid_15_f: Uint256,
        __warp_usrid_11_tick: felt,
        __warp_usrid_10_sqrtPriceX96: felt,
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        let (__warp_se_189) = warp_sub_signed256(__warp_usrid_14_msb, Uint256(low=128, high=0));

        let (__warp_usrid_16_log_2) = warp_shl256(__warp_se_189, 64);

        let (__warp_se_190) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_191) = warp_shr256(__warp_se_190, 127);

        let __warp_usrid_13_r = __warp_se_191;

        let (__warp_se_192) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_192;

        let (__warp_se_193) = warp_shl256(__warp_usrid_15_f, 63);

        let (__warp_se_194) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_193);

        let __warp_usrid_16_log_2 = __warp_se_194;

        let (__warp_se_195) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_195;

        let (__warp_se_196) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_197) = warp_shr256(__warp_se_196, 127);

        let __warp_usrid_13_r = __warp_se_197;

        let (__warp_se_198) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_198;

        let (__warp_se_199) = warp_shl256(__warp_usrid_15_f, 62);

        let (__warp_se_200) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_199);

        let __warp_usrid_16_log_2 = __warp_se_200;

        let (__warp_se_201) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_201;

        let (__warp_se_202) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_203) = warp_shr256(__warp_se_202, 127);

        let __warp_usrid_13_r = __warp_se_203;

        let (__warp_se_204) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_204;

        let (__warp_se_205) = warp_shl256(__warp_usrid_15_f, 61);

        let (__warp_se_206) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_205);

        let __warp_usrid_16_log_2 = __warp_se_206;

        let (__warp_se_207) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_207;

        let (__warp_se_208) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_209) = warp_shr256(__warp_se_208, 127);

        let __warp_usrid_13_r = __warp_se_209;

        let (__warp_se_210) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_210;

        let (__warp_se_211) = warp_shl256(__warp_usrid_15_f, 60);

        let (__warp_se_212) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_211);

        let __warp_usrid_16_log_2 = __warp_se_212;

        let (__warp_se_213) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_213;

        let (__warp_se_214) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_215) = warp_shr256(__warp_se_214, 127);

        let __warp_usrid_13_r = __warp_se_215;

        let (__warp_se_216) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_216;

        let (__warp_se_217) = warp_shl256(__warp_usrid_15_f, 59);

        let (__warp_se_218) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_217);

        let __warp_usrid_16_log_2 = __warp_se_218;

        let (__warp_se_219) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_219;

        let (__warp_se_220) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_221) = warp_shr256(__warp_se_220, 127);

        let __warp_usrid_13_r = __warp_se_221;

        let (__warp_se_222) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_222;

        let (__warp_se_223) = warp_shl256(__warp_usrid_15_f, 58);

        let (__warp_se_224) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_223);

        let __warp_usrid_16_log_2 = __warp_se_224;

        let (__warp_se_225) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_225;

        let (__warp_se_226) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_227) = warp_shr256(__warp_se_226, 127);

        let __warp_usrid_13_r = __warp_se_227;

        let (__warp_se_228) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_228;

        let (__warp_se_229) = warp_shl256(__warp_usrid_15_f, 57);

        let (__warp_se_230) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_229);

        let __warp_usrid_16_log_2 = __warp_se_230;

        let (__warp_se_231) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_231;

        let (__warp_se_232) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_233) = warp_shr256(__warp_se_232, 127);

        let __warp_usrid_13_r = __warp_se_233;

        let (__warp_se_234) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_234;

        let (__warp_se_235) = warp_shl256(__warp_usrid_15_f, 56);

        let (__warp_se_236) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_235);

        let __warp_usrid_16_log_2 = __warp_se_236;

        let (__warp_se_237) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_237;

        let (__warp_se_238) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_239) = warp_shr256(__warp_se_238, 127);

        let __warp_usrid_13_r = __warp_se_239;

        let (__warp_se_240) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_240;

        let (__warp_se_241) = warp_shl256(__warp_usrid_15_f, 55);

        let (__warp_se_242) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_241);

        let __warp_usrid_16_log_2 = __warp_se_242;

        let (__warp_se_243) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_243;

        let (__warp_se_244) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_245) = warp_shr256(__warp_se_244, 127);

        let __warp_usrid_13_r = __warp_se_245;

        let (__warp_se_246) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_246;

        let (__warp_se_247) = warp_shl256(__warp_usrid_15_f, 54);

        let (__warp_se_248) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_247);

        let __warp_usrid_16_log_2 = __warp_se_248;

        let (__warp_se_249) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_249;

        let (__warp_se_250) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_251) = warp_shr256(__warp_se_250, 127);

        let __warp_usrid_13_r = __warp_se_251;

        let (__warp_se_252) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_252;

        let (__warp_se_253) = warp_shl256(__warp_usrid_15_f, 53);

        let (__warp_se_254) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_253);

        let __warp_usrid_16_log_2 = __warp_se_254;

        let (__warp_se_255) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_255;

        let (__warp_se_256) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_257) = warp_shr256(__warp_se_256, 127);

        let __warp_usrid_13_r = __warp_se_257;

        let (__warp_se_258) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_258;

        let (__warp_se_259) = warp_shl256(__warp_usrid_15_f, 52);

        let (__warp_se_260) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_259);

        let __warp_usrid_16_log_2 = __warp_se_260;

        let (__warp_se_261) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_261;

        let (__warp_se_262) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_263) = warp_shr256(__warp_se_262, 127);

        let __warp_usrid_13_r = __warp_se_263;

        let (__warp_se_264) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_264;

        let (__warp_se_265) = warp_shl256(__warp_usrid_15_f, 51);

        let (__warp_se_266) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_265);

        let __warp_usrid_16_log_2 = __warp_se_266;

        let (__warp_se_267) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_267;

        let (__warp_se_268) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_269) = warp_shr256(__warp_se_268, 127);

        let __warp_usrid_13_r = __warp_se_269;

        let (__warp_se_270) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_270;

        let (__warp_se_271) = warp_shl256(__warp_usrid_15_f, 50);

        let (__warp_se_272) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_271);

        let __warp_usrid_16_log_2 = __warp_se_272;

        let (__warp_se_273) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_273;

        let (__warp_usrid_17_log_sqrt10001) = warp_mul_signed256(
            __warp_usrid_16_log_2, Uint256(low=255738958999603826347141, high=0)
        );

        let (__warp_se_274) = warp_sub_signed256(
            __warp_usrid_17_log_sqrt10001,
            Uint256(low=3402992956809132418596140100660247210, high=0),
        );

        let (__warp_se_275) = warp_shr_signed256(__warp_se_274, 128);

        let (__warp_usrid_18_tickLow) = warp_int256_to_int24(__warp_se_275);

        let (__warp_se_276) = warp_add_signed256(
            __warp_usrid_17_log_sqrt10001,
            Uint256(low=291339464771989622907027621153398088495, high=0),
        );

        let (__warp_se_277) = warp_shr_signed256(__warp_se_276, 128);

        let (__warp_usrid_19_tickHi) = warp_int256_to_int24(__warp_se_277);

        let (__warp_se_278) = warp_eq(__warp_usrid_18_tickLow, __warp_usrid_19_tickHi);

        if (__warp_se_278 != 0) {
            let __warp_usrid_11_tick = __warp_usrid_18_tickLow;

            return (__warp_usrid_11_tick,);
        } else {
            let (__warp_se_279) = s1___warp_usrfn_00_getSqrtRatioAtTick(__warp_usrid_19_tickHi);

            let (__warp_se_280) = warp_le(__warp_se_279, __warp_usrid_10_sqrtPriceX96);

            if (__warp_se_280 != 0) {
                let __warp_usrid_11_tick = __warp_usrid_19_tickHi;

                let (
                    __warp_se_281
                ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_11_tick
                );

                return (__warp_se_281,);
            } else {
                let __warp_usrid_11_tick = __warp_usrid_18_tickLow;

                let (
                    __warp_se_282
                ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_11_tick
                );

                return (__warp_se_282,);
            }
        }
    }

    func s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2(
        __warp_usrid_11_tick: felt
    ) -> (__warp_usrid_11_tick: felt) {
        alloc_locals;

        return (__warp_usrid_11_tick,);
    }
}

@view
func getSqrtRatioAtTick_986cfba3{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_00_tick: felt) -> (__warp_usrid_01_: felt) {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_00_tick);

    let (__warp_se_0) = TickMathTest.s1___warp_usrfn_00_getSqrtRatioAtTick(__warp_usrid_00_tick);

    return (__warp_se_0,);
}

@view
func getTickAtSqrtRatio_4f76c058{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_02_sqrtPriceX96: felt) -> (__warp_usrid_03_: felt) {
    alloc_locals;

    warp_external_input_check_int160(__warp_usrid_02_sqrtPriceX96);

    let (__warp_se_1) = TickMathTest.s1___warp_usrfn_01_getTickAtSqrtRatio(
        __warp_usrid_02_sqrtPriceX96
    );

    return (__warp_se_1,);
}

@view
func MIN_SQRT_RATIO_ee8847ff{syscall_ptr: felt*, range_check_ptr: felt}() -> (
    __warp_usrid_04_: felt
) {
    alloc_locals;

    return (4295128739,);
}

@view
func MAX_SQRT_RATIO_6d2cc304{syscall_ptr: felt*, range_check_ptr: felt}() -> (
    __warp_usrid_05_: felt
) {
    alloc_locals;

    return (1461446703485210103287273052203988822378723970342,);
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","getSqrtRatioAtTick(int24)","getTickAtSqrtRatio(uint160)","MIN_SQRT_RATIO()","MAX_SQRT_RATIO()"]
