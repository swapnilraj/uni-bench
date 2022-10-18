%lang starknet

from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int24,
    warp_external_input_check_int160,
)
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.sub_signed import warp_sub_signed24, warp_sub_signed256
from warplib.maths.lt import warp_lt
from warplib.maths.add_signed import warp_add_signed24, warp_add_signed256
from warplib.maths.and_ import warp_and_
from warplib.maths.ge import warp_ge, warp_ge256
from warplib.maths.le import warp_le, warp_le256
from warplib.maths.ge_signed import warp_ge_signed24
from warplib.maths.lt_signed import warp_lt_signed24
from warplib.maths.int_conversions import (
    warp_int24_to_int256,
    warp_uint256,
    warp_int256_to_int160,
    warp_int256_to_int24,
)
from warplib.maths.negate import warp_negate256
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.neq import warp_neq256
from warplib.maths.mul import warp_mul256
from warplib.maths.shr import warp_shr256, warp_shr256_256
from warplib.maths.gt_signed import warp_gt_signed24
from warplib.maths.div import warp_div256
from warplib.maths.mod import warp_mod256
from warplib.maths.eq import warp_eq256, warp_eq
from warplib.maths.add import warp_add256
from warplib.maths.shl import warp_shl256, warp_shl256_256
from warplib.maths.gt import warp_gt256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.sub import warp_sub256
from warplib.maths.mul_signed import warp_mul_signed256
from warplib.maths.shr_signed import warp_shr_signed256

// Contract Def TickMathEchidnaTest

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

namespace TickMathEchidnaTest {
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

        let (__warp_se_17) = warp_lt_signed24(__warp_usrid_06_tick, 0);

        if (__warp_se_17 != 0) {
            let (__warp_se_18) = warp_int24_to_int256(__warp_usrid_06_tick);

            let (__warp_se_19) = warp_negate256(__warp_se_18);

            let __warp_usrid_08_absTick = __warp_se_19;

            let (__warp_se_20) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1(
                __warp_usrid_08_absTick, __warp_usrid_06_tick, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_20,);
        } else {
            let (__warp_se_21) = warp_int24_to_int256(__warp_usrid_06_tick);

            let __warp_usrid_08_absTick = __warp_se_21;

            let (__warp_se_22) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1(
                __warp_usrid_08_absTick, __warp_usrid_06_tick, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_22,);
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

        let (__warp_se_23) = warp_uint256(887272);

        let (__warp_se_24) = warp_le256(__warp_usrid_08_absTick, __warp_se_23);

        with_attr error_message("T") {
            assert __warp_se_24 = 1;
        }

        let __warp_usrid_09_ratio = Uint256(low=0, high=1);

        let (__warp_se_25) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=1, high=0));

        let (__warp_se_26) = warp_neq256(__warp_se_25, Uint256(low=0, high=0));

        if (__warp_se_26 != 0) {
            let __warp_usrid_09_ratio = Uint256(
                low=340265354078544963557816517032075149313, high=0
            );

            let (__warp_se_27) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_27,);
        } else {
            let (__warp_se_28) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_28,);
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

        let (__warp_se_29) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=2, high=0));

        let (__warp_se_30) = warp_neq256(__warp_se_29, Uint256(low=0, high=0));

        if (__warp_se_30 != 0) {
            let (__warp_se_31) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=340248342086729790484326174814286782778, high=0)
            );

            let (__warp_se_32) = warp_shr256(__warp_se_31, 128);

            let __warp_usrid_09_ratio = __warp_se_32;

            let (__warp_se_33) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_33,);
        } else {
            let (__warp_se_34) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_34,);
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

        let (__warp_se_35) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=4, high=0));

        let (__warp_se_36) = warp_neq256(__warp_se_35, Uint256(low=0, high=0));

        if (__warp_se_36 != 0) {
            let (__warp_se_37) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=340214320654664324051920982716015181260, high=0)
            );

            let (__warp_se_38) = warp_shr256(__warp_se_37, 128);

            let __warp_usrid_09_ratio = __warp_se_38;

            let (
                __warp_se_39
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_39,);
        } else {
            let (
                __warp_se_40
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_40,);
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

        let (__warp_se_41) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=8, high=0));

        let (__warp_se_42) = warp_neq256(__warp_se_41, Uint256(low=0, high=0));

        if (__warp_se_42 != 0) {
            let (__warp_se_43) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=340146287995602323631171512101879684304, high=0)
            );

            let (__warp_se_44) = warp_shr256(__warp_se_43, 128);

            let __warp_usrid_09_ratio = __warp_se_44;

            let (
                __warp_se_45
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_45,);
        } else {
            let (
                __warp_se_46
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_46,);
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

        let (__warp_se_47) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=16, high=0));

        let (__warp_se_48) = warp_neq256(__warp_se_47, Uint256(low=0, high=0));

        if (__warp_se_48 != 0) {
            let (__warp_se_49) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=340010263488231146823593991679159461444, high=0)
            );

            let (__warp_se_50) = warp_shr256(__warp_se_49, 128);

            let __warp_usrid_09_ratio = __warp_se_50;

            let (
                __warp_se_51
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_51,);
        } else {
            let (
                __warp_se_52
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_52,);
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

        let (__warp_se_53) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=32, high=0));

        let (__warp_se_54) = warp_neq256(__warp_se_53, Uint256(low=0, high=0));

        if (__warp_se_54 != 0) {
            let (__warp_se_55) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=339738377640345403697157401104375502016, high=0)
            );

            let (__warp_se_56) = warp_shr256(__warp_se_55, 128);

            let __warp_usrid_09_ratio = __warp_se_56;

            let (
                __warp_se_57
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_57,);
        } else {
            let (
                __warp_se_58
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_58,);
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

        let (__warp_se_59) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=64, high=0));

        let (__warp_se_60) = warp_neq256(__warp_se_59, Uint256(low=0, high=0));

        if (__warp_se_60 != 0) {
            let (__warp_se_61) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=339195258003219555707034227454543997025, high=0)
            );

            let (__warp_se_62) = warp_shr256(__warp_se_61, 128);

            let __warp_usrid_09_ratio = __warp_se_62;

            let (
                __warp_se_63
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_63,);
        } else {
            let (
                __warp_se_64
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_64,);
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

        let (__warp_se_65) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=128, high=0));

        let (__warp_se_66) = warp_neq256(__warp_se_65, Uint256(low=0, high=0));

        if (__warp_se_66 != 0) {
            let (__warp_se_67) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=338111622100601834656805679988414885971, high=0)
            );

            let (__warp_se_68) = warp_shr256(__warp_se_67, 128);

            let __warp_usrid_09_ratio = __warp_se_68;

            let (
                __warp_se_69
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_69,);
        } else {
            let (
                __warp_se_70
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_70,);
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

        let (__warp_se_71) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=256, high=0));

        let (__warp_se_72) = warp_neq256(__warp_se_71, Uint256(low=0, high=0));

        if (__warp_se_72 != 0) {
            let (__warp_se_73) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=335954724994790223023589805789778977700, high=0)
            );

            let (__warp_se_74) = warp_shr256(__warp_se_73, 128);

            let __warp_usrid_09_ratio = __warp_se_74;

            let (
                __warp_se_75
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_75,);
        } else {
            let (
                __warp_se_76
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_76,);
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

        let (__warp_se_77) = warp_bitwise_and256(__warp_usrid_08_absTick, Uint256(low=512, high=0));

        let (__warp_se_78) = warp_neq256(__warp_se_77, Uint256(low=0, high=0));

        if (__warp_se_78 != 0) {
            let (__warp_se_79) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=331682121138379247127172139078559817300, high=0)
            );

            let (__warp_se_80) = warp_shr256(__warp_se_79, 128);

            let __warp_usrid_09_ratio = __warp_se_80;

            let (
                __warp_se_81
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_81,);
        } else {
            let (
                __warp_se_82
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_82,);
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

        let (__warp_se_83) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=1024, high=0)
        );

        let (__warp_se_84) = warp_neq256(__warp_se_83, Uint256(low=0, high=0));

        if (__warp_se_84 != 0) {
            let (__warp_se_85) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=323299236684853023288211250268160618739, high=0)
            );

            let (__warp_se_86) = warp_shr256(__warp_se_85, 128);

            let __warp_usrid_09_ratio = __warp_se_86;

            let (
                __warp_se_87
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_87,);
        } else {
            let (
                __warp_se_88
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_88,);
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

        let (__warp_se_89) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=2048, high=0)
        );

        let (__warp_se_90) = warp_neq256(__warp_se_89, Uint256(low=0, high=0));

        if (__warp_se_90 != 0) {
            let (__warp_se_91) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=307163716377032989948697243942600083929, high=0)
            );

            let (__warp_se_92) = warp_shr256(__warp_se_91, 128);

            let __warp_usrid_09_ratio = __warp_se_92;

            let (
                __warp_se_93
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_93,);
        } else {
            let (
                __warp_se_94
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_94,);
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

        let (__warp_se_95) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=4096, high=0)
        );

        let (__warp_se_96) = warp_neq256(__warp_se_95, Uint256(low=0, high=0));

        if (__warp_se_96 != 0) {
            let (__warp_se_97) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=277268403626896220162999269216087595045, high=0)
            );

            let (__warp_se_98) = warp_shr256(__warp_se_97, 128);

            let __warp_usrid_09_ratio = __warp_se_98;

            let (
                __warp_se_99
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_99,);
        } else {
            let (
                __warp_se_100
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_100,);
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

        let (__warp_se_101) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=8192, high=0)
        );

        let (__warp_se_102) = warp_neq256(__warp_se_101, Uint256(low=0, high=0));

        if (__warp_se_102 != 0) {
            let (__warp_se_103) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=225923453940442621947126027127485391333, high=0)
            );

            let (__warp_se_104) = warp_shr256(__warp_se_103, 128);

            let __warp_usrid_09_ratio = __warp_se_104;

            let (
                __warp_se_105
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_105,);
        } else {
            let (
                __warp_se_106
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_106,);
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

        let (__warp_se_107) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=16384, high=0)
        );

        let (__warp_se_108) = warp_neq256(__warp_se_107, Uint256(low=0, high=0));

        if (__warp_se_108 != 0) {
            let (__warp_se_109) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=149997214084966997727330242082538205943, high=0)
            );

            let (__warp_se_110) = warp_shr256(__warp_se_109, 128);

            let __warp_usrid_09_ratio = __warp_se_110;

            let (
                __warp_se_111
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_111,);
        } else {
            let (
                __warp_se_112
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_112,);
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

        let (__warp_se_113) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=32768, high=0)
        );

        let (__warp_se_114) = warp_neq256(__warp_se_113, Uint256(low=0, high=0));

        if (__warp_se_114 != 0) {
            let (__warp_se_115) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=66119101136024775622716233608466517926, high=0)
            );

            let (__warp_se_116) = warp_shr256(__warp_se_115, 128);

            let __warp_usrid_09_ratio = __warp_se_116;

            let (
                __warp_se_117
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_117,);
        } else {
            let (
                __warp_se_118
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_118,);
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

        let (__warp_se_119) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=65536, high=0)
        );

        let (__warp_se_120) = warp_neq256(__warp_se_119, Uint256(low=0, high=0));

        if (__warp_se_120 != 0) {
            let (__warp_se_121) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=12847376061809297530290974190478138313, high=0)
            );

            let (__warp_se_122) = warp_shr256(__warp_se_121, 128);

            let __warp_usrid_09_ratio = __warp_se_122;

            let (
                __warp_se_123
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_123,);
        } else {
            let (
                __warp_se_124
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_124,);
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

        let (__warp_se_125) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=131072, high=0)
        );

        let (__warp_se_126) = warp_neq256(__warp_se_125, Uint256(low=0, high=0));

        if (__warp_se_126 != 0) {
            let (__warp_se_127) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=485053260817066172746253684029974020, high=0)
            );

            let (__warp_se_128) = warp_shr256(__warp_se_127, 128);

            let __warp_usrid_09_ratio = __warp_se_128;

            let (
                __warp_se_129
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_129,);
        } else {
            let (
                __warp_se_130
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_130,);
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

        let (__warp_se_131) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=262144, high=0)
        );

        let (__warp_se_132) = warp_neq256(__warp_se_131, Uint256(low=0, high=0));

        if (__warp_se_132 != 0) {
            let (__warp_se_133) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=691415978906521570653435304214168, high=0)
            );

            let (__warp_se_134) = warp_shr256(__warp_se_133, 128);

            let __warp_usrid_09_ratio = __warp_se_134;

            let (
                __warp_se_135
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_135,);
        } else {
            let (
                __warp_se_136
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_08_absTick,
                __warp_usrid_09_ratio,
                __warp_usrid_06_tick,
                __warp_usrid_07_sqrtPriceX96,
            );

            return (__warp_se_136,);
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

        let (__warp_se_137) = warp_bitwise_and256(
            __warp_usrid_08_absTick, Uint256(low=524288, high=0)
        );

        let (__warp_se_138) = warp_neq256(__warp_se_137, Uint256(low=0, high=0));

        if (__warp_se_138 != 0) {
            let (__warp_se_139) = warp_mul256(
                __warp_usrid_09_ratio, Uint256(low=1404880482679654955896180642, high=0)
            );

            let (__warp_se_140) = warp_shr256(__warp_se_139, 128);

            let __warp_usrid_09_ratio = __warp_se_140;

            let (
                __warp_se_141
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_tick, __warp_usrid_09_ratio, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_141,);
        } else {
            let (
                __warp_se_142
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_tick, __warp_usrid_09_ratio, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_142,);
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

        let (__warp_se_143) = warp_gt_signed24(__warp_usrid_06_tick, 0);

        if (__warp_se_143 != 0) {
            let (__warp_se_144) = warp_div256(
                Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
                __warp_usrid_09_ratio,
            );

            let __warp_usrid_09_ratio = __warp_se_144;

            let (
                __warp_se_145
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_09_ratio, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_145,);
        } else {
            let (
                __warp_se_146
            ) = s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_09_ratio, __warp_usrid_07_sqrtPriceX96
            );

            return (__warp_se_146,);
        }
    }

    func s1___warp_usrfn_00_getSqrtRatioAtTick_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_09_ratio: Uint256, __warp_usrid_07_sqrtPriceX96: felt) -> (
        __warp_usrid_07_sqrtPriceX96: felt
    ) {
        alloc_locals;

        let (__warp_se_147) = warp_mod256(__warp_usrid_09_ratio, Uint256(low=4294967296, high=0));

        let (__warp_se_148) = warp_eq256(__warp_se_147, Uint256(low=0, high=0));

        if (__warp_se_148 != 0) {
            let (__warp_se_149) = warp_shr256(__warp_usrid_09_ratio, 32);

            let (__warp_se_150) = warp_int256_to_int160(__warp_se_149);

            let __warp_usrid_07_sqrtPriceX96 = __warp_se_150;

            return (__warp_usrid_07_sqrtPriceX96,);
        } else {
            let (__warp_se_151) = warp_shr256(__warp_usrid_09_ratio, 32);

            let (__warp_se_152) = warp_add256(__warp_se_151, Uint256(low=1, high=0));

            let (__warp_se_153) = warp_int256_to_int160(__warp_se_152);

            let __warp_usrid_07_sqrtPriceX96 = __warp_se_153;

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

        let (__warp_se_154) = warp_ge(__warp_usrid_10_sqrtPriceX96, 4295128739);

        let (__warp_se_155) = warp_lt(
            __warp_usrid_10_sqrtPriceX96, 1461446703485210103287273052203988822378723970342
        );

        let (__warp_se_156) = warp_and_(__warp_se_154, __warp_se_155);

        with_attr error_message("R") {
            assert __warp_se_156 = 1;
        }

        let (__warp_se_157) = warp_uint256(__warp_usrid_10_sqrtPriceX96);

        let (__warp_usrid_12_ratio) = warp_shl256(__warp_se_157, 32);

        let __warp_usrid_13_r = __warp_usrid_12_ratio;

        let __warp_usrid_14_msb = Uint256(low=0, high=0);

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_158) = warp_gt256(
            __warp_usrid_13_r, Uint256(low=340282366920938463463374607431768211455, high=0)
        );

        if (__warp_se_158 != 0) {
            let __warp_usrid_15_f = Uint256(low=128, high=0);

            let (__warp_se_159) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_159,);
        } else {
            let (__warp_se_160) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1(
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

        let (__warp_se_161) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_161;

        let (__warp_se_162) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_162;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_163) = warp_gt256(
            __warp_usrid_13_r, Uint256(low=18446744073709551615, high=0)
        );

        if (__warp_se_163 != 0) {
            let __warp_usrid_15_f = Uint256(low=64, high=0);

            let (__warp_se_164) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_164,);
        } else {
            let (__warp_se_165) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1(
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

        let (__warp_se_166) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_166;

        let (__warp_se_167) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_167;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_168) = warp_gt256(__warp_usrid_13_r, Uint256(low=4294967295, high=0));

        if (__warp_se_168 != 0) {
            let __warp_usrid_15_f = Uint256(low=32, high=0);

            let (__warp_se_169) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_169,);
        } else {
            let (__warp_se_170) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1(
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

        let (__warp_se_171) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_171;

        let (__warp_se_172) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_172;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_173) = warp_gt256(__warp_usrid_13_r, Uint256(low=65535, high=0));

        if (__warp_se_173 != 0) {
            let __warp_usrid_15_f = Uint256(low=16, high=0);

            let (
                __warp_se_174
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1(
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
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1(
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

        let (__warp_se_176) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_176;

        let (__warp_se_177) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_177;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_178) = warp_gt256(__warp_usrid_13_r, Uint256(low=255, high=0));

        if (__warp_se_178 != 0) {
            let __warp_usrid_15_f = Uint256(low=8, high=0);

            let (
                __warp_se_179
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1(
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
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1(
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

        let (__warp_se_181) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_181;

        let (__warp_se_182) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_182;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_183) = warp_gt256(__warp_usrid_13_r, Uint256(low=15, high=0));

        if (__warp_se_183 != 0) {
            let __warp_usrid_15_f = Uint256(low=4, high=0);

            let (
                __warp_se_184
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_184,);
        } else {
            let (
                __warp_se_185
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_185,);
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

        let (__warp_se_186) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_186;

        let (__warp_se_187) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_187;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_188) = warp_gt256(__warp_usrid_13_r, Uint256(low=3, high=0));

        if (__warp_se_188 != 0) {
            let __warp_usrid_15_f = Uint256(low=2, high=0);

            let (
                __warp_se_189
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_189,);
        } else {
            let (
                __warp_se_190
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_190,);
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

        let (__warp_se_191) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_191;

        let (__warp_se_192) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_192;

        let __warp_usrid_15_f = Uint256(low=0, high=0);

        let (__warp_se_193) = warp_gt256(__warp_usrid_13_r, Uint256(low=1, high=0));

        if (__warp_se_193 != 0) {
            let __warp_usrid_15_f = Uint256(low=1, high=0);

            let (
                __warp_se_194
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_194,);
        } else {
            let (
                __warp_se_195
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_15_f,
                __warp_usrid_13_r,
                __warp_usrid_12_ratio,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_195,);
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

        let (__warp_se_196) = warp_bitwise_or256(__warp_usrid_14_msb, __warp_usrid_15_f);

        let __warp_usrid_14_msb = __warp_se_196;

        let (__warp_se_197) = warp_ge256(__warp_usrid_14_msb, Uint256(low=128, high=0));

        if (__warp_se_197 != 0) {
            let (__warp_se_198) = warp_sub256(__warp_usrid_14_msb, Uint256(low=127, high=0));

            let (__warp_se_199) = warp_shr256_256(__warp_usrid_12_ratio, __warp_se_198);

            let __warp_usrid_13_r = __warp_se_199;

            let (
                __warp_se_200
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_13_r,
                __warp_usrid_15_f,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_200,);
        } else {
            let (__warp_se_201) = warp_sub256(Uint256(low=127, high=0), __warp_usrid_14_msb);

            let (__warp_se_202) = warp_shl256_256(__warp_usrid_12_ratio, __warp_se_201);

            let __warp_usrid_13_r = __warp_se_202;

            let (
                __warp_se_203
            ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_14_msb,
                __warp_usrid_13_r,
                __warp_usrid_15_f,
                __warp_usrid_11_tick,
                __warp_usrid_10_sqrtPriceX96,
            );

            return (__warp_se_203,);
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

        let (__warp_se_204) = warp_sub_signed256(__warp_usrid_14_msb, Uint256(low=128, high=0));

        let (__warp_usrid_16_log_2) = warp_shl256(__warp_se_204, 64);

        let (__warp_se_205) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_206) = warp_shr256(__warp_se_205, 127);

        let __warp_usrid_13_r = __warp_se_206;

        let (__warp_se_207) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_207;

        let (__warp_se_208) = warp_shl256(__warp_usrid_15_f, 63);

        let (__warp_se_209) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_208);

        let __warp_usrid_16_log_2 = __warp_se_209;

        let (__warp_se_210) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_210;

        let (__warp_se_211) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_212) = warp_shr256(__warp_se_211, 127);

        let __warp_usrid_13_r = __warp_se_212;

        let (__warp_se_213) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_213;

        let (__warp_se_214) = warp_shl256(__warp_usrid_15_f, 62);

        let (__warp_se_215) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_214);

        let __warp_usrid_16_log_2 = __warp_se_215;

        let (__warp_se_216) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_216;

        let (__warp_se_217) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_218) = warp_shr256(__warp_se_217, 127);

        let __warp_usrid_13_r = __warp_se_218;

        let (__warp_se_219) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_219;

        let (__warp_se_220) = warp_shl256(__warp_usrid_15_f, 61);

        let (__warp_se_221) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_220);

        let __warp_usrid_16_log_2 = __warp_se_221;

        let (__warp_se_222) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_222;

        let (__warp_se_223) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_224) = warp_shr256(__warp_se_223, 127);

        let __warp_usrid_13_r = __warp_se_224;

        let (__warp_se_225) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_225;

        let (__warp_se_226) = warp_shl256(__warp_usrid_15_f, 60);

        let (__warp_se_227) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_226);

        let __warp_usrid_16_log_2 = __warp_se_227;

        let (__warp_se_228) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_228;

        let (__warp_se_229) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_230) = warp_shr256(__warp_se_229, 127);

        let __warp_usrid_13_r = __warp_se_230;

        let (__warp_se_231) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_231;

        let (__warp_se_232) = warp_shl256(__warp_usrid_15_f, 59);

        let (__warp_se_233) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_232);

        let __warp_usrid_16_log_2 = __warp_se_233;

        let (__warp_se_234) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_234;

        let (__warp_se_235) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_236) = warp_shr256(__warp_se_235, 127);

        let __warp_usrid_13_r = __warp_se_236;

        let (__warp_se_237) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_237;

        let (__warp_se_238) = warp_shl256(__warp_usrid_15_f, 58);

        let (__warp_se_239) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_238);

        let __warp_usrid_16_log_2 = __warp_se_239;

        let (__warp_se_240) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_240;

        let (__warp_se_241) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_242) = warp_shr256(__warp_se_241, 127);

        let __warp_usrid_13_r = __warp_se_242;

        let (__warp_se_243) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_243;

        let (__warp_se_244) = warp_shl256(__warp_usrid_15_f, 57);

        let (__warp_se_245) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_244);

        let __warp_usrid_16_log_2 = __warp_se_245;

        let (__warp_se_246) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_246;

        let (__warp_se_247) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_248) = warp_shr256(__warp_se_247, 127);

        let __warp_usrid_13_r = __warp_se_248;

        let (__warp_se_249) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_249;

        let (__warp_se_250) = warp_shl256(__warp_usrid_15_f, 56);

        let (__warp_se_251) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_250);

        let __warp_usrid_16_log_2 = __warp_se_251;

        let (__warp_se_252) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_252;

        let (__warp_se_253) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_254) = warp_shr256(__warp_se_253, 127);

        let __warp_usrid_13_r = __warp_se_254;

        let (__warp_se_255) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_255;

        let (__warp_se_256) = warp_shl256(__warp_usrid_15_f, 55);

        let (__warp_se_257) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_256);

        let __warp_usrid_16_log_2 = __warp_se_257;

        let (__warp_se_258) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_258;

        let (__warp_se_259) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_260) = warp_shr256(__warp_se_259, 127);

        let __warp_usrid_13_r = __warp_se_260;

        let (__warp_se_261) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_261;

        let (__warp_se_262) = warp_shl256(__warp_usrid_15_f, 54);

        let (__warp_se_263) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_262);

        let __warp_usrid_16_log_2 = __warp_se_263;

        let (__warp_se_264) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_264;

        let (__warp_se_265) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_266) = warp_shr256(__warp_se_265, 127);

        let __warp_usrid_13_r = __warp_se_266;

        let (__warp_se_267) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_267;

        let (__warp_se_268) = warp_shl256(__warp_usrid_15_f, 53);

        let (__warp_se_269) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_268);

        let __warp_usrid_16_log_2 = __warp_se_269;

        let (__warp_se_270) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_270;

        let (__warp_se_271) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_272) = warp_shr256(__warp_se_271, 127);

        let __warp_usrid_13_r = __warp_se_272;

        let (__warp_se_273) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_273;

        let (__warp_se_274) = warp_shl256(__warp_usrid_15_f, 52);

        let (__warp_se_275) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_274);

        let __warp_usrid_16_log_2 = __warp_se_275;

        let (__warp_se_276) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_276;

        let (__warp_se_277) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_278) = warp_shr256(__warp_se_277, 127);

        let __warp_usrid_13_r = __warp_se_278;

        let (__warp_se_279) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_279;

        let (__warp_se_280) = warp_shl256(__warp_usrid_15_f, 51);

        let (__warp_se_281) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_280);

        let __warp_usrid_16_log_2 = __warp_se_281;

        let (__warp_se_282) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_282;

        let (__warp_se_283) = warp_mul256(__warp_usrid_13_r, __warp_usrid_13_r);

        let (__warp_se_284) = warp_shr256(__warp_se_283, 127);

        let __warp_usrid_13_r = __warp_se_284;

        let (__warp_se_285) = warp_shr256(__warp_usrid_13_r, 128);

        let __warp_usrid_15_f = __warp_se_285;

        let (__warp_se_286) = warp_shl256(__warp_usrid_15_f, 50);

        let (__warp_se_287) = warp_bitwise_or256(__warp_usrid_16_log_2, __warp_se_286);

        let __warp_usrid_16_log_2 = __warp_se_287;

        let (__warp_se_288) = warp_shr256_256(__warp_usrid_13_r, __warp_usrid_15_f);

        let __warp_usrid_13_r = __warp_se_288;

        let (__warp_usrid_17_log_sqrt10001) = warp_mul_signed256(
            __warp_usrid_16_log_2, Uint256(low=255738958999603826347141, high=0)
        );

        let (__warp_se_289) = warp_sub_signed256(
            __warp_usrid_17_log_sqrt10001,
            Uint256(low=3402992956809132418596140100660247210, high=0),
        );

        let (__warp_se_290) = warp_shr_signed256(__warp_se_289, 128);

        let (__warp_usrid_18_tickLow) = warp_int256_to_int24(__warp_se_290);

        let (__warp_se_291) = warp_add_signed256(
            __warp_usrid_17_log_sqrt10001,
            Uint256(low=291339464771989622907027621153398088495, high=0),
        );

        let (__warp_se_292) = warp_shr_signed256(__warp_se_291, 128);

        let (__warp_usrid_19_tickHi) = warp_int256_to_int24(__warp_se_292);

        let (__warp_se_293) = warp_eq(__warp_usrid_18_tickLow, __warp_usrid_19_tickHi);

        if (__warp_se_293 != 0) {
            let __warp_usrid_11_tick = __warp_usrid_18_tickLow;

            return (__warp_usrid_11_tick,);
        } else {
            let (__warp_se_294) = s1___warp_usrfn_00_getSqrtRatioAtTick(__warp_usrid_19_tickHi);

            let (__warp_se_295) = warp_le(__warp_se_294, __warp_usrid_10_sqrtPriceX96);

            if (__warp_se_295 != 0) {
                let __warp_usrid_11_tick = __warp_usrid_19_tickHi;

                let (
                    __warp_se_296
                ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_11_tick
                );

                return (__warp_se_296,);
            } else {
                let __warp_usrid_11_tick = __warp_usrid_18_tickLow;

                let (
                    __warp_se_297
                ) = s1___warp_usrfn_01_getTickAtSqrtRatio_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_11_tick
                );

                return (__warp_se_297,);
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
func checkGetSqrtRatioAtTickInvariants_47d38f4d{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_00_tick: felt) -> () {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_00_tick);

    let (__warp_usrid_01_ratio) = TickMathEchidnaTest.s1___warp_usrfn_00_getSqrtRatioAtTick(
        __warp_usrid_00_tick
    );

    let (__warp_se_0) = warp_sub_signed24(__warp_usrid_00_tick, 1);

    let (__warp_se_1) = TickMathEchidnaTest.s1___warp_usrfn_00_getSqrtRatioAtTick(__warp_se_0);

    let (__warp_se_2) = warp_lt(__warp_se_1, __warp_usrid_01_ratio);

    let (__warp_se_3) = warp_add_signed24(__warp_usrid_00_tick, 1);

    let (__warp_se_4) = TickMathEchidnaTest.s1___warp_usrfn_00_getSqrtRatioAtTick(__warp_se_3);

    let (__warp_se_5) = warp_lt(__warp_usrid_01_ratio, __warp_se_4);

    let (__warp_se_6) = warp_and_(__warp_se_2, __warp_se_5);

    assert __warp_se_6 = 1;

    let (__warp_se_7) = warp_ge(__warp_usrid_01_ratio, 4295128739);

    assert __warp_se_7 = 1;

    let (__warp_se_8) = warp_le(
        __warp_usrid_01_ratio, 1461446703485210103287273052203988822378723970342
    );

    assert __warp_se_8 = 1;

    return ();
}

@view
func checkGetTickAtSqrtRatioInvariants_df01e52d{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_02_ratio: felt) -> () {
    alloc_locals;

    warp_external_input_check_int160(__warp_usrid_02_ratio);

    let (__warp_usrid_03_tick) = TickMathEchidnaTest.s1___warp_usrfn_01_getTickAtSqrtRatio(
        __warp_usrid_02_ratio
    );

    let (__warp_se_9) = TickMathEchidnaTest.s1___warp_usrfn_00_getSqrtRatioAtTick(
        __warp_usrid_03_tick
    );

    let (__warp_se_10) = warp_ge(__warp_usrid_02_ratio, __warp_se_9);

    let (__warp_se_11) = warp_add_signed24(__warp_usrid_03_tick, 1);

    let (__warp_se_12) = TickMathEchidnaTest.s1___warp_usrfn_00_getSqrtRatioAtTick(__warp_se_11);

    let (__warp_se_13) = warp_lt(__warp_usrid_02_ratio, __warp_se_12);

    let (__warp_se_14) = warp_and_(__warp_se_10, __warp_se_13);

    assert __warp_se_14 = 1;

    let (__warp_se_15) = warp_ge_signed24(__warp_usrid_03_tick, 15889944);

    assert __warp_se_15 = 1;

    let (__warp_se_16) = warp_lt_signed24(__warp_usrid_03_tick, 887272);

    assert __warp_se_16 = 1;

    return ();
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","checkGetSqrtRatioAtTickInvariants(int24)","checkGetTickAtSqrtRatioInvariants(uint160)"]
