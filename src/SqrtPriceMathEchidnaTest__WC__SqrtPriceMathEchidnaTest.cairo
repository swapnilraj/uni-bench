%lang starknet

from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int256,
    warp_external_input_check_int160,
    warp_external_input_check_int128,
)
from warplib.maths.external_input_check_bool import warp_external_input_check_bool
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.gt import warp_gt256, warp_gt
from warplib.maths.ge import warp_ge256, warp_ge
from warplib.maths.sub import warp_sub256, warp_sub
from warplib.maths.lt import warp_lt256, warp_lt
from warplib.maths.eq import warp_eq256, warp_eq
from warplib.maths.mulmod import warp_mulmod
from warplib.maths.le import warp_le, warp_le256
from warplib.maths.and_ import warp_and_
from warplib.maths.mul import warp_mul160, warp_mul256
from warplib.maths.div import warp_div, warp_div256
from warplib.maths.int_conversions import warp_uint256, warp_int256_to_int160
from warplib.maths.shl import warp_shl256
from warplib.maths.lt_signed import warp_lt_signed128
from warplib.maths.le_signed import warp_le_signed256
from warplib.maths.gt_signed import warp_gt_signed128, warp_gt_signed256
from warplib.maths.or import warp_or
from warplib.maths.mul_unsafe import warp_mul_unsafe256
from warplib.maths.sub_unsafe import warp_sub_unsafe256
from warplib.maths.div_unsafe import warp_div_unsafe256
from warplib.maths.negate import warp_negate256, warp_negate128
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.add_unsafe import warp_add_unsafe256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.xor import warp_xor256
from warplib.maths.mod import warp_mod256
from warplib.maths.add import warp_add256

// Contract Def SqrtPriceMathEchidnaTest

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

namespace SqrtPriceMathEchidnaTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    func mulDivRoundingUpInvariants_3d729147_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func getNextSqrtPriceFromInputInvariants_1faf4a39_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func getNextSqrtPriceFromOutputInvariants_f157fb50_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func getNextSqrtPriceFromAmount0RoundingUpInvariants_b46e6714_if_part1{range_check_ptr: felt}(
        __warp_usrid_17_amount: Uint256,
        __warp_usrid_15_sqrtPX96: felt,
        __warp_usrid_19_sqrtQX96: felt,
    ) -> () {
        alloc_locals;

        let (__warp_se_27) = warp_eq256(__warp_usrid_17_amount, Uint256(low=0, high=0));

        if (__warp_se_27 != 0) {
            let (__warp_se_28) = warp_eq(__warp_usrid_15_sqrtPX96, __warp_usrid_19_sqrtQX96);

            assert __warp_se_28 = 1;

            getNextSqrtPriceFromAmount0RoundingUpInvariants_b46e6714_if_part1_if_part1();

            return ();
        } else {
            getNextSqrtPriceFromAmount0RoundingUpInvariants_b46e6714_if_part1_if_part1();

            return ();
        }
    }

    func getNextSqrtPriceFromAmount0RoundingUpInvariants_b46e6714_if_part1_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func getNextSqrtPriceFromAmount1RoundingDownInvariants_21e14f8b_if_part1{range_check_ptr: felt}(
        __warp_usrid_22_amount: Uint256,
        __warp_usrid_20_sqrtPX96: felt,
        __warp_usrid_24_sqrtQX96: felt,
    ) -> () {
        alloc_locals;

        let (__warp_se_33) = warp_eq256(__warp_usrid_22_amount, Uint256(low=0, high=0));

        if (__warp_se_33 != 0) {
            let (__warp_se_34) = warp_eq(__warp_usrid_20_sqrtPX96, __warp_usrid_24_sqrtQX96);

            assert __warp_se_34 = 1;

            getNextSqrtPriceFromAmount1RoundingDownInvariants_21e14f8b_if_part1_if_part1();

            return ();
        } else {
            getNextSqrtPriceFromAmount1RoundingDownInvariants_21e14f8b_if_part1_if_part1();

            return ();
        }
    }

    func getNextSqrtPriceFromAmount1RoundingDownInvariants_21e14f8b_if_part1_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func getAmount0DeltaEquivalency_8e13a4b9_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_31_sqrtQ: felt,
        __warp_usrid_30_sqrtP: felt,
        __warp_usrid_32_liquidity: felt,
        __warp_usrid_33_roundUp: felt,
        __warp_usrid_37_safeResult: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_usrid_38_fullResult) = s2___warp_usrfn_04_getAmount0Delta(
            __warp_usrid_31_sqrtQ,
            __warp_usrid_30_sqrtP,
            __warp_usrid_32_liquidity,
            __warp_usrid_33_roundUp,
        );

        let (__warp_se_58) = warp_eq256(__warp_usrid_37_safeResult, __warp_usrid_38_fullResult);

        assert __warp_se_58 = 1;

        return ();
    }

    func getAmount0DeltaSignedInvariants_b29f199e_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_46_liquidity: felt,
        __warp_usrid_44_sqrtP: felt,
        __warp_usrid_45_sqrtQ: felt,
        __warp_usrid_47_amount0: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_74) = warp_gt_signed128(__warp_usrid_46_liquidity, 0);

        if (__warp_se_74 != 0) {
            let (__warp_se_75) = warp_eq(__warp_usrid_44_sqrtP, __warp_usrid_45_sqrtQ);

            if (__warp_se_75 != 0) {
                let (__warp_se_76) = warp_eq256(__warp_usrid_47_amount0, Uint256(low=0, high=0));

                assert __warp_se_76 = 1;

                getAmount0DeltaSignedInvariants_b29f199e_if_part1_if_part2(
                    __warp_usrid_46_liquidity, __warp_usrid_47_amount0
                );

                return ();
            } else {
                let (__warp_se_77) = warp_gt_signed256(
                    __warp_usrid_47_amount0, Uint256(low=0, high=0)
                );

                assert __warp_se_77 = 1;

                getAmount0DeltaSignedInvariants_b29f199e_if_part1_if_part2(
                    __warp_usrid_46_liquidity, __warp_usrid_47_amount0
                );

                return ();
            }
        } else {
            getAmount0DeltaSignedInvariants_b29f199e_if_part1_if_part1(
                __warp_usrid_46_liquidity, __warp_usrid_47_amount0
            );

            return ();
        }
    }

    func getAmount0DeltaSignedInvariants_b29f199e_if_part1_if_part2{range_check_ptr: felt}(
        __warp_usrid_46_liquidity: felt, __warp_usrid_47_amount0: Uint256
    ) -> () {
        alloc_locals;

        getAmount0DeltaSignedInvariants_b29f199e_if_part1_if_part1(
            __warp_usrid_46_liquidity, __warp_usrid_47_amount0
        );

        return ();
    }

    func getAmount0DeltaSignedInvariants_b29f199e_if_part1_if_part1{range_check_ptr: felt}(
        __warp_usrid_46_liquidity: felt, __warp_usrid_47_amount0: Uint256
    ) -> () {
        alloc_locals;

        let (__warp_se_78) = warp_eq(__warp_usrid_46_liquidity, 0);

        if (__warp_se_78 != 0) {
            let (__warp_se_79) = warp_eq256(__warp_usrid_47_amount0, Uint256(low=0, high=0));

            assert __warp_se_79 = 1;

            getAmount0DeltaSignedInvariants_b29f199e_if_part1_if_part1_if_part1();

            return ();
        } else {
            getAmount0DeltaSignedInvariants_b29f199e_if_part1_if_part1_if_part1();

            return ();
        }
    }

    func getAmount0DeltaSignedInvariants_b29f199e_if_part1_if_part1_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func getAmount1DeltaSignedInvariants_6e6238d7_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_50_liquidity: felt,
        __warp_usrid_48_sqrtP: felt,
        __warp_usrid_49_sqrtQ: felt,
        __warp_usrid_51_amount1: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_85) = warp_gt_signed128(__warp_usrid_50_liquidity, 0);

        if (__warp_se_85 != 0) {
            let (__warp_se_86) = warp_eq(__warp_usrid_48_sqrtP, __warp_usrid_49_sqrtQ);

            if (__warp_se_86 != 0) {
                let (__warp_se_87) = warp_eq256(__warp_usrid_51_amount1, Uint256(low=0, high=0));

                assert __warp_se_87 = 1;

                getAmount1DeltaSignedInvariants_6e6238d7_if_part1_if_part2(
                    __warp_usrid_50_liquidity, __warp_usrid_51_amount1
                );

                return ();
            } else {
                let (__warp_se_88) = warp_gt_signed256(
                    __warp_usrid_51_amount1, Uint256(low=0, high=0)
                );

                assert __warp_se_88 = 1;

                getAmount1DeltaSignedInvariants_6e6238d7_if_part1_if_part2(
                    __warp_usrid_50_liquidity, __warp_usrid_51_amount1
                );

                return ();
            }
        } else {
            getAmount1DeltaSignedInvariants_6e6238d7_if_part1_if_part1(
                __warp_usrid_50_liquidity, __warp_usrid_51_amount1
            );

            return ();
        }
    }

    func getAmount1DeltaSignedInvariants_6e6238d7_if_part1_if_part2{range_check_ptr: felt}(
        __warp_usrid_50_liquidity: felt, __warp_usrid_51_amount1: Uint256
    ) -> () {
        alloc_locals;

        getAmount1DeltaSignedInvariants_6e6238d7_if_part1_if_part1(
            __warp_usrid_50_liquidity, __warp_usrid_51_amount1
        );

        return ();
    }

    func getAmount1DeltaSignedInvariants_6e6238d7_if_part1_if_part1{range_check_ptr: felt}(
        __warp_usrid_50_liquidity: felt, __warp_usrid_51_amount1: Uint256
    ) -> () {
        alloc_locals;

        let (__warp_se_89) = warp_eq(__warp_usrid_50_liquidity, 0);

        if (__warp_se_89 != 0) {
            let (__warp_se_90) = warp_eq256(__warp_usrid_51_amount1, Uint256(low=0, high=0));

            assert __warp_se_90 = 1;

            getAmount1DeltaSignedInvariants_6e6238d7_if_part1_if_part1_if_part1();

            return ();
        } else {
            getAmount1DeltaSignedInvariants_6e6238d7_if_part1_if_part1_if_part1();

            return ();
        }
    }

    func getAmount1DeltaSignedInvariants_6e6238d7_if_part1_if_part1_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func getOutOfRangeMintInvariants_b712c47c_if_part1() -> () {
        alloc_locals;

        return ();
    }

    // @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    // @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
    func s1___warp_usrfn_00_mulDiv{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_02_a: Uint256, __warp_usrid_03_b: Uint256, __warp_usrid_04_denominator: Uint256
    ) -> (__warp_usrid_05_result: Uint256) {
        alloc_locals;

        let __warp_usrid_05_result = Uint256(low=0, high=0);

        let __warp_usrid_06_prod0 = Uint256(low=0, high=0);

        let (__warp_se_109) = warp_mul_unsafe256(__warp_usrid_02_a, __warp_usrid_03_b);

        let __warp_usrid_06_prod0 = __warp_se_109;

        let (__warp_usrid_07_mm) = warp_mulmod(
            __warp_usrid_02_a,
            __warp_usrid_03_b,
            Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        );

        let __warp_usrid_08_prod1 = Uint256(low=0, high=0);

        let (__warp_se_110) = warp_sub_unsafe256(__warp_usrid_07_mm, __warp_usrid_06_prod0);

        let __warp_usrid_08_prod1 = __warp_se_110;

        let (__warp_se_111) = warp_lt256(__warp_usrid_07_mm, __warp_usrid_06_prod0);

        if (__warp_se_111 != 0) {
            let (__warp_se_112) = warp_sub_unsafe256(__warp_usrid_08_prod1, Uint256(low=1, high=0));

            let __warp_usrid_08_prod1 = __warp_se_112;

            let (__warp_se_113) = s1___warp_usrfn_00_mulDiv_if_part1(
                __warp_usrid_08_prod1,
                __warp_usrid_04_denominator,
                __warp_usrid_05_result,
                __warp_usrid_06_prod0,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
            );

            return (__warp_se_113,);
        } else {
            let (__warp_se_114) = s1___warp_usrfn_00_mulDiv_if_part1(
                __warp_usrid_08_prod1,
                __warp_usrid_04_denominator,
                __warp_usrid_05_result,
                __warp_usrid_06_prod0,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
            );

            return (__warp_se_114,);
        }
    }

    func s1___warp_usrfn_00_mulDiv_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_08_prod1: Uint256,
        __warp_usrid_04_denominator: Uint256,
        __warp_usrid_05_result: Uint256,
        __warp_usrid_06_prod0: Uint256,
        __warp_usrid_02_a: Uint256,
        __warp_usrid_03_b: Uint256,
    ) -> (__warp_usrid_05_result: Uint256) {
        alloc_locals;

        let (__warp_se_115) = warp_eq256(__warp_usrid_08_prod1, Uint256(low=0, high=0));

        if (__warp_se_115 != 0) {
            let (__warp_se_116) = warp_gt256(__warp_usrid_04_denominator, Uint256(low=0, high=0));

            assert __warp_se_116 = 1;

            let (__warp_se_117) = warp_div_unsafe256(
                __warp_usrid_06_prod0, __warp_usrid_04_denominator
            );

            let __warp_usrid_05_result = __warp_se_117;

            return (__warp_usrid_05_result,);
        } else {
            let (__warp_se_118) = s1___warp_usrfn_00_mulDiv_if_part1_if_part1(
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
                __warp_usrid_06_prod0,
                __warp_usrid_05_result,
            );

            return (__warp_se_118,);
        }
    }

    func s1___warp_usrfn_00_mulDiv_if_part1_if_part1{
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

        let (__warp_se_119) = warp_gt256(__warp_usrid_04_denominator, __warp_usrid_08_prod1);

        assert __warp_se_119 = 1;

        let __warp_usrid_09_remainder = Uint256(low=0, high=0);

        let (__warp_se_120) = warp_mulmod(
            __warp_usrid_02_a, __warp_usrid_03_b, __warp_usrid_04_denominator
        );

        let __warp_usrid_09_remainder = __warp_se_120;

        let (__warp_se_121) = warp_gt256(__warp_usrid_09_remainder, __warp_usrid_06_prod0);

        if (__warp_se_121 != 0) {
            let (__warp_se_122) = warp_sub_unsafe256(__warp_usrid_08_prod1, Uint256(low=1, high=0));

            let __warp_usrid_08_prod1 = __warp_se_122;

            let (__warp_se_123) = s1___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1(
                __warp_usrid_06_prod0,
                __warp_usrid_09_remainder,
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_05_result,
            );

            return (__warp_se_123,);
        } else {
            let (__warp_se_124) = s1___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1(
                __warp_usrid_06_prod0,
                __warp_usrid_09_remainder,
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_05_result,
            );

            return (__warp_se_124,);
        }
    }

    func s1___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_prod0: Uint256,
        __warp_usrid_09_remainder: Uint256,
        __warp_usrid_04_denominator: Uint256,
        __warp_usrid_08_prod1: Uint256,
        __warp_usrid_05_result: Uint256,
    ) -> (__warp_usrid_05_result: Uint256) {
        alloc_locals;

        let (__warp_se_125) = warp_sub_unsafe256(__warp_usrid_06_prod0, __warp_usrid_09_remainder);

        let __warp_usrid_06_prod0 = __warp_se_125;

        let (__warp_se_126) = warp_negate256(__warp_usrid_04_denominator);

        let (__warp_usrid_10_twos) = warp_bitwise_and256(
            __warp_se_126, __warp_usrid_04_denominator
        );

        let (__warp_se_127) = warp_div_unsafe256(__warp_usrid_04_denominator, __warp_usrid_10_twos);

        let __warp_usrid_04_denominator = __warp_se_127;

        let (__warp_se_128) = warp_div_unsafe256(__warp_usrid_06_prod0, __warp_usrid_10_twos);

        let __warp_usrid_06_prod0 = __warp_se_128;

        let (__warp_se_129) = warp_sub_unsafe256(Uint256(low=0, high=0), __warp_usrid_10_twos);

        let (__warp_se_130) = warp_div_unsafe256(__warp_se_129, __warp_usrid_10_twos);

        let (__warp_se_131) = warp_add_unsafe256(__warp_se_130, Uint256(low=1, high=0));

        let __warp_usrid_10_twos = __warp_se_131;

        let (__warp_se_132) = warp_mul_unsafe256(__warp_usrid_08_prod1, __warp_usrid_10_twos);

        let (__warp_se_133) = warp_bitwise_or256(__warp_usrid_06_prod0, __warp_se_132);

        let __warp_usrid_06_prod0 = __warp_se_133;

        let (__warp_se_134) = warp_mul_unsafe256(
            Uint256(low=3, high=0), __warp_usrid_04_denominator
        );

        let (__warp_usrid_11_inv) = warp_xor256(__warp_se_134, Uint256(low=2, high=0));

        let (__warp_se_135) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_136) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_135);

        let (__warp_se_137) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_136);

        let __warp_usrid_11_inv = __warp_se_137;

        let (__warp_se_138) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_139) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_138);

        let (__warp_se_140) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_139);

        let __warp_usrid_11_inv = __warp_se_140;

        let (__warp_se_141) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_142) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_141);

        let (__warp_se_143) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_142);

        let __warp_usrid_11_inv = __warp_se_143;

        let (__warp_se_144) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_145) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_144);

        let (__warp_se_146) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_145);

        let __warp_usrid_11_inv = __warp_se_146;

        let (__warp_se_147) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_148) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_147);

        let (__warp_se_149) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_148);

        let __warp_usrid_11_inv = __warp_se_149;

        let (__warp_se_150) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_151) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_150);

        let (__warp_se_152) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_151);

        let __warp_usrid_11_inv = __warp_se_152;

        let (__warp_se_153) = warp_mul_unsafe256(__warp_usrid_06_prod0, __warp_usrid_11_inv);

        let __warp_usrid_05_result = __warp_se_153;

        return (__warp_usrid_05_result,);
    }

    // @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    func s1___warp_usrfn_01_mulDivRoundingUp{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_12_a: Uint256, __warp_usrid_13_b: Uint256, __warp_usrid_14_denominator: Uint256
    ) -> (__warp_usrid_15_result: Uint256) {
        alloc_locals;

        let __warp_usrid_15_result = Uint256(low=0, high=0);

        let (__warp_se_154) = s1___warp_usrfn_00_mulDiv(
            __warp_usrid_12_a, __warp_usrid_13_b, __warp_usrid_14_denominator
        );

        let __warp_usrid_15_result = __warp_se_154;

        let (__warp_se_155) = warp_mulmod(
            __warp_usrid_12_a, __warp_usrid_13_b, __warp_usrid_14_denominator
        );

        let (__warp_se_156) = warp_gt256(__warp_se_155, Uint256(low=0, high=0));

        if (__warp_se_156 != 0) {
            let (__warp_se_157) = warp_lt256(
                __warp_usrid_15_result,
                Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
            );

            assert __warp_se_157 = 1;

            let (__warp_se_158) = warp_add_unsafe256(
                __warp_usrid_15_result, Uint256(low=1, high=0)
            );

            let __warp_se_159 = __warp_se_158;

            let __warp_usrid_15_result = __warp_se_159;

            warp_sub_unsafe256(__warp_se_159, Uint256(low=1, high=0));

            let (__warp_se_160) = s1___warp_usrfn_01_mulDivRoundingUp_if_part1(
                __warp_usrid_15_result
            );

            return (__warp_se_160,);
        } else {
            let (__warp_se_161) = s1___warp_usrfn_01_mulDivRoundingUp_if_part1(
                __warp_usrid_15_result
            );

            return (__warp_se_161,);
        }
    }

    func s1___warp_usrfn_01_mulDivRoundingUp_if_part1(__warp_usrid_15_result: Uint256) -> (
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
    func s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_08_sqrtPX96: felt,
        __warp_usrid_09_liquidity: felt,
        __warp_usrid_10_amount: Uint256,
        __warp_usrid_11_add: felt,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (__warp_se_162) = warp_eq256(__warp_usrid_10_amount, Uint256(low=0, high=0));

        if (__warp_se_162 != 0) {
            return (__warp_usrid_08_sqrtPX96,);
        } else {
            let (__warp_se_163) = s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1(
                __warp_usrid_09_liquidity,
                __warp_usrid_11_add,
                __warp_usrid_10_amount,
                __warp_usrid_08_sqrtPX96,
            );

            return (__warp_se_163,);
        }
    }

    func s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_09_liquidity: felt,
        __warp_usrid_11_add: felt,
        __warp_usrid_10_amount: Uint256,
        __warp_usrid_08_sqrtPX96: felt,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (__warp_se_164) = warp_uint256(__warp_usrid_09_liquidity);

        let (__warp_usrid_13_numerator1) = warp_shl256(__warp_se_164, 96);

        if (__warp_usrid_11_add != 0) {
            let __warp_usrid_14_product = Uint256(low=0, high=0);

            let (__warp_se_165) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_166) = warp_mul_unsafe256(__warp_usrid_10_amount, __warp_se_165);

            let __warp_se_167 = __warp_se_166;

            let __warp_usrid_14_product = __warp_se_167;

            let (__warp_se_168) = warp_div_unsafe256(__warp_se_167, __warp_usrid_10_amount);

            let (__warp_se_169) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_170) = warp_eq256(__warp_se_168, __warp_se_169);

            if (__warp_se_170 != 0) {
                let (__warp_usrid_15_denominator) = warp_add_unsafe256(
                    __warp_usrid_13_numerator1, __warp_usrid_14_product
                );

                let (__warp_se_171) = warp_ge256(
                    __warp_usrid_15_denominator, __warp_usrid_13_numerator1
                );

                if (__warp_se_171 != 0) {
                    let (__warp_se_172) = warp_uint256(__warp_usrid_08_sqrtPX96);

                    let (__warp_se_173) = s1___warp_usrfn_01_mulDivRoundingUp(
                        __warp_usrid_13_numerator1, __warp_se_172, __warp_usrid_15_denominator
                    );

                    let (__warp_se_174) = warp_int256_to_int160(__warp_se_173);

                    return (__warp_se_174,);
                } else {
                    let (
                        __warp_se_175
                    ) = s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part3(
                        __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
                    );

                    return (__warp_se_175,);
                }
            } else {
                let (
                    __warp_se_176
                ) = s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2(
                    __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
                );

                return (__warp_se_176,);
            }
        } else {
            let __warp_usrid_16_product = Uint256(low=0, high=0);

            let (__warp_se_177) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_178) = warp_mul_unsafe256(__warp_usrid_10_amount, __warp_se_177);

            let __warp_se_179 = __warp_se_178;

            let __warp_usrid_16_product = __warp_se_179;

            let (__warp_se_180) = warp_div_unsafe256(__warp_se_179, __warp_usrid_10_amount);

            let (__warp_se_181) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_182) = warp_eq256(__warp_se_180, __warp_se_181);

            let (__warp_se_183) = warp_gt256(__warp_usrid_13_numerator1, __warp_usrid_16_product);

            let (__warp_se_184) = warp_and_(__warp_se_182, __warp_se_183);

            assert __warp_se_184 = 1;

            let (__warp_usrid_17_denominator) = warp_sub_unsafe256(
                __warp_usrid_13_numerator1, __warp_usrid_16_product
            );

            let (__warp_se_185) = warp_uint256(__warp_usrid_08_sqrtPX96);

            let (__warp_se_186) = s1___warp_usrfn_01_mulDivRoundingUp(
                __warp_usrid_13_numerator1, __warp_se_185, __warp_usrid_17_denominator
            );

            let (__warp_se_187) = s5___warp_usrfn_00_toUint160(__warp_se_186);

            return (__warp_se_187,);
        }
    }

    func s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_13_numerator1: Uint256,
        __warp_usrid_08_sqrtPX96: felt,
        __warp_usrid_10_amount: Uint256,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (
            __warp_se_188
        ) = s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2(
            __warp_usrid_13_numerator1, __warp_usrid_08_sqrtPX96, __warp_usrid_10_amount
        );

        return (__warp_se_188,);
    }

    func s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp_if_part1_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_13_numerator1: Uint256,
        __warp_usrid_08_sqrtPX96: felt,
        __warp_usrid_10_amount: Uint256,
    ) -> (__warp_usrid_12_: felt) {
        alloc_locals;

        let (__warp_se_189) = warp_uint256(__warp_usrid_08_sqrtPX96);

        let (__warp_se_190) = warp_div256(__warp_usrid_13_numerator1, __warp_se_189);

        let (__warp_se_191) = s4___warp_usrfn_00_add(__warp_se_190, __warp_usrid_10_amount);

        let (__warp_se_192) = s3___warp_usrfn_00_divRoundingUp(
            __warp_usrid_13_numerator1, __warp_se_191
        );

        let (__warp_se_193) = warp_int256_to_int160(__warp_se_192);

        return (__warp_se_193,);
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
    func s2___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown{
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

            let (__warp_se_194) = warp_uint256(1461501637330902918203684832716283019655932542975);

            let (__warp_se_195) = warp_le256(__warp_usrid_20_amount, __warp_se_194);

            if (__warp_se_195 != 0) {
                let (__warp_se_196) = warp_shl256(__warp_usrid_20_amount, 96);

                let (__warp_se_197) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_198) = warp_div_unsafe256(__warp_se_196, __warp_se_197);

                let __warp_usrid_23_quotient = __warp_se_198;

                let (
                    __warp_se_199
                ) = s2___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_23_quotient
                );

                return (__warp_se_199,);
            } else {
                let (__warp_se_200) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_201) = s1___warp_usrfn_00_mulDiv(
                    __warp_usrid_20_amount,
                    Uint256(low=79228162514264337593543950336, high=0),
                    __warp_se_200,
                );

                let __warp_usrid_23_quotient = __warp_se_201;

                let (
                    __warp_se_202
                ) = s2___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_23_quotient
                );

                return (__warp_se_202,);
            }
        } else {
            let __warp_usrid_24_quotient = Uint256(low=0, high=0);

            let (__warp_se_203) = warp_uint256(1461501637330902918203684832716283019655932542975);

            let (__warp_se_204) = warp_le256(__warp_usrid_20_amount, __warp_se_203);

            if (__warp_se_204 != 0) {
                let (__warp_se_205) = warp_shl256(__warp_usrid_20_amount, 96);

                let (__warp_se_206) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_207) = s3___warp_usrfn_00_divRoundingUp(
                    __warp_se_205, __warp_se_206
                );

                let __warp_usrid_24_quotient = __warp_se_207;

                let (
                    __warp_se_208
                ) = s2___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_24_quotient
                );

                return (__warp_se_208,);
            } else {
                let (__warp_se_209) = warp_uint256(__warp_usrid_19_liquidity);

                let (__warp_se_210) = s1___warp_usrfn_01_mulDivRoundingUp(
                    __warp_usrid_20_amount,
                    Uint256(low=79228162514264337593543950336, high=0),
                    __warp_se_209,
                );

                let __warp_usrid_24_quotient = __warp_se_210;

                let (
                    __warp_se_211
                ) = s2___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3(
                    __warp_usrid_18_sqrtPX96, __warp_usrid_24_quotient
                );

                return (__warp_se_211,);
            }
        }
    }

    func s2___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_18_sqrtPX96: felt, __warp_usrid_24_quotient: Uint256) -> (
        __warp_usrid_22_: felt
    ) {
        alloc_locals;

        let (__warp_se_212) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_213) = warp_gt256(__warp_se_212, __warp_usrid_24_quotient);

        assert __warp_se_213 = 1;

        let (__warp_se_214) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_215) = warp_sub256(__warp_se_214, __warp_usrid_24_quotient);

        let (__warp_se_216) = warp_int256_to_int160(__warp_se_215);

        return (__warp_se_216,);
    }

    func s2___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_18_sqrtPX96: felt, __warp_usrid_23_quotient: Uint256) -> (
        __warp_usrid_22_: felt
    ) {
        alloc_locals;

        let (__warp_se_217) = warp_uint256(__warp_usrid_18_sqrtPX96);

        let (__warp_se_218) = s4___warp_usrfn_00_add(__warp_se_217, __warp_usrid_23_quotient);

        let (__warp_se_219) = s5___warp_usrfn_00_toUint160(__warp_se_218);

        return (__warp_se_219,);
    }

    // @notice Gets the next sqrt price given an input amount of token0 or token1
    // @dev Throws if price or liquidity are 0, or if the next price is out of bounds
    // @param sqrtPX96 The starting price, i.e., before accounting for the input amount
    // @param liquidity The amount of usable liquidity
    // @param amountIn How much of token0, or token1, is being swapped in
    // @param zeroForOne Whether the amount in is token0 or token1
    // @return sqrtQX96 The price after adding the input amount to token0 or token1
    func s2___warp_usrfn_02_getNextSqrtPriceFromInput{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_25_sqrtPX96: felt,
        __warp_usrid_26_liquidity: felt,
        __warp_usrid_27_amountIn: Uint256,
        __warp_usrid_28_zeroForOne: felt,
    ) -> (__warp_usrid_29_sqrtQX96: felt) {
        alloc_locals;

        let (__warp_se_220) = warp_gt(__warp_usrid_25_sqrtPX96, 0);

        assert __warp_se_220 = 1;

        let (__warp_se_221) = warp_gt(__warp_usrid_26_liquidity, 0);

        assert __warp_se_221 = 1;

        if (__warp_usrid_28_zeroForOne != 0) {
            let (__warp_se_222) = s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp(
                __warp_usrid_25_sqrtPX96, __warp_usrid_26_liquidity, __warp_usrid_27_amountIn, 1
            );

            return (__warp_se_222,);
        } else {
            let (__warp_se_223) = s2___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown(
                __warp_usrid_25_sqrtPX96, __warp_usrid_26_liquidity, __warp_usrid_27_amountIn, 1
            );

            return (__warp_se_223,);
        }
    }

    // @notice Gets the next sqrt price given an output amount of token0 or token1
    // @dev Throws if price or liquidity are 0 or the next price is out of bounds
    // @param sqrtPX96 The starting price before accounting for the output amount
    // @param liquidity The amount of usable liquidity
    // @param amountOut How much of token0, or token1, is being swapped out
    // @param zeroForOne Whether the amount out is token0 or token1
    // @return sqrtQX96 The price after removing the output amount of token0 or token1
    func s2___warp_usrfn_03_getNextSqrtPriceFromOutput{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_30_sqrtPX96: felt,
        __warp_usrid_31_liquidity: felt,
        __warp_usrid_32_amountOut: Uint256,
        __warp_usrid_33_zeroForOne: felt,
    ) -> (__warp_usrid_34_sqrtQX96: felt) {
        alloc_locals;

        let (__warp_se_224) = warp_gt(__warp_usrid_30_sqrtPX96, 0);

        assert __warp_se_224 = 1;

        let (__warp_se_225) = warp_gt(__warp_usrid_31_liquidity, 0);

        assert __warp_se_225 = 1;

        if (__warp_usrid_33_zeroForOne != 0) {
            let (__warp_se_226) = s2___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown(
                __warp_usrid_30_sqrtPX96, __warp_usrid_31_liquidity, __warp_usrid_32_amountOut, 0
            );

            return (__warp_se_226,);
        } else {
            let (__warp_se_227) = s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp(
                __warp_usrid_30_sqrtPX96, __warp_usrid_31_liquidity, __warp_usrid_32_amountOut, 0
            );

            return (__warp_se_227,);
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
    func s2___warp_usrfn_04_getAmount0Delta{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_35_sqrtRatioAX96: felt,
        __warp_usrid_36_sqrtRatioBX96: felt,
        __warp_usrid_37_liquidity: felt,
        __warp_usrid_38_roundUp: felt,
    ) -> (__warp_usrid_39_amount0: Uint256) {
        alloc_locals;

        let (__warp_se_228) = warp_gt(__warp_usrid_35_sqrtRatioAX96, __warp_usrid_36_sqrtRatioBX96);

        if (__warp_se_228 != 0) {
            let __warp_tv_0 = __warp_usrid_36_sqrtRatioBX96;

            let __warp_tv_1 = __warp_usrid_35_sqrtRatioAX96;

            let __warp_usrid_36_sqrtRatioBX96 = __warp_tv_1;

            let __warp_usrid_35_sqrtRatioAX96 = __warp_tv_0;

            let (__warp_se_229) = s2___warp_usrfn_04_getAmount0Delta_if_part1(
                __warp_usrid_37_liquidity,
                __warp_usrid_36_sqrtRatioBX96,
                __warp_usrid_35_sqrtRatioAX96,
                __warp_usrid_38_roundUp,
            );

            return (__warp_se_229,);
        } else {
            let (__warp_se_230) = s2___warp_usrfn_04_getAmount0Delta_if_part1(
                __warp_usrid_37_liquidity,
                __warp_usrid_36_sqrtRatioBX96,
                __warp_usrid_35_sqrtRatioAX96,
                __warp_usrid_38_roundUp,
            );

            return (__warp_se_230,);
        }
    }

    func s2___warp_usrfn_04_getAmount0Delta_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_37_liquidity: felt,
        __warp_usrid_36_sqrtRatioBX96: felt,
        __warp_usrid_35_sqrtRatioAX96: felt,
        __warp_usrid_38_roundUp: felt,
    ) -> (__warp_usrid_39_amount0: Uint256) {
        alloc_locals;

        let (__warp_se_231) = warp_uint256(__warp_usrid_37_liquidity);

        let (__warp_usrid_40_numerator1) = warp_shl256(__warp_se_231, 96);

        let (__warp_se_232) = warp_sub(
            __warp_usrid_36_sqrtRatioBX96, __warp_usrid_35_sqrtRatioAX96
        );

        let (__warp_usrid_41_numerator2) = warp_uint256(__warp_se_232);

        let (__warp_se_233) = warp_gt(__warp_usrid_35_sqrtRatioAX96, 0);

        assert __warp_se_233 = 1;

        if (__warp_usrid_38_roundUp != 0) {
            let (__warp_se_234) = warp_uint256(__warp_usrid_36_sqrtRatioBX96);

            let (__warp_se_235) = s1___warp_usrfn_01_mulDivRoundingUp(
                __warp_usrid_40_numerator1, __warp_usrid_41_numerator2, __warp_se_234
            );

            let (__warp_se_236) = warp_uint256(__warp_usrid_35_sqrtRatioAX96);

            let (__warp_se_237) = s3___warp_usrfn_00_divRoundingUp(__warp_se_235, __warp_se_236);

            return (__warp_se_237,);
        } else {
            let (__warp_se_238) = warp_uint256(__warp_usrid_36_sqrtRatioBX96);

            let (__warp_se_239) = s1___warp_usrfn_00_mulDiv(
                __warp_usrid_40_numerator1, __warp_usrid_41_numerator2, __warp_se_238
            );

            let (__warp_se_240) = warp_uint256(__warp_usrid_35_sqrtRatioAX96);

            let (__warp_se_241) = warp_div256(__warp_se_239, __warp_se_240);

            return (__warp_se_241,);
        }
    }

    // @notice Gets the amount1 delta between two prices
    // @dev Calculates liquidity * (sqrt(upper) - sqrt(lower))
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The amount of usable liquidity
    // @param roundUp Whether to round the amount up, or down
    // @return amount1 Amount of token1 required to cover a position of size liquidity between the two passed prices
    func s2___warp_usrfn_05_getAmount1Delta{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_42_sqrtRatioAX96: felt,
        __warp_usrid_43_sqrtRatioBX96: felt,
        __warp_usrid_44_liquidity: felt,
        __warp_usrid_45_roundUp: felt,
    ) -> (__warp_usrid_46_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_242) = warp_gt(__warp_usrid_42_sqrtRatioAX96, __warp_usrid_43_sqrtRatioBX96);

        if (__warp_se_242 != 0) {
            let __warp_tv_2 = __warp_usrid_43_sqrtRatioBX96;

            let __warp_tv_3 = __warp_usrid_42_sqrtRatioAX96;

            let __warp_usrid_43_sqrtRatioBX96 = __warp_tv_3;

            let __warp_usrid_42_sqrtRatioAX96 = __warp_tv_2;

            let (__warp_se_243) = s2___warp_usrfn_05_getAmount1Delta_if_part1(
                __warp_usrid_45_roundUp,
                __warp_usrid_44_liquidity,
                __warp_usrid_43_sqrtRatioBX96,
                __warp_usrid_42_sqrtRatioAX96,
            );

            return (__warp_se_243,);
        } else {
            let (__warp_se_244) = s2___warp_usrfn_05_getAmount1Delta_if_part1(
                __warp_usrid_45_roundUp,
                __warp_usrid_44_liquidity,
                __warp_usrid_43_sqrtRatioBX96,
                __warp_usrid_42_sqrtRatioAX96,
            );

            return (__warp_se_244,);
        }
    }

    func s2___warp_usrfn_05_getAmount1Delta_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_45_roundUp: felt,
        __warp_usrid_44_liquidity: felt,
        __warp_usrid_43_sqrtRatioBX96: felt,
        __warp_usrid_42_sqrtRatioAX96: felt,
    ) -> (__warp_usrid_46_amount1: Uint256) {
        alloc_locals;

        if (__warp_usrid_45_roundUp != 0) {
            let (__warp_se_245) = warp_uint256(__warp_usrid_44_liquidity);

            let (__warp_se_246) = warp_sub(
                __warp_usrid_43_sqrtRatioBX96, __warp_usrid_42_sqrtRatioAX96
            );

            let (__warp_se_247) = warp_uint256(__warp_se_246);

            let (__warp_se_248) = s1___warp_usrfn_01_mulDivRoundingUp(
                __warp_se_245, __warp_se_247, Uint256(low=79228162514264337593543950336, high=0)
            );

            return (__warp_se_248,);
        } else {
            let (__warp_se_249) = warp_uint256(__warp_usrid_44_liquidity);

            let (__warp_se_250) = warp_sub(
                __warp_usrid_43_sqrtRatioBX96, __warp_usrid_42_sqrtRatioAX96
            );

            let (__warp_se_251) = warp_uint256(__warp_se_250);

            let (__warp_se_252) = s1___warp_usrfn_00_mulDiv(
                __warp_se_249, __warp_se_251, Uint256(low=79228162514264337593543950336, high=0)
            );

            return (__warp_se_252,);
        }
    }

    // @notice Helper that gets signed token0 delta
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The change in liquidity for which to compute the amount0 delta
    // @return amount0 Amount of token0 corresponding to the passed liquidityDelta between the two prices
    func s2___warp_usrfn_06_getAmount0Delta{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_47_sqrtRatioAX96: felt,
        __warp_usrid_48_sqrtRatioBX96: felt,
        __warp_usrid_49_liquidity: felt,
    ) -> (__warp_usrid_50_amount0: Uint256) {
        alloc_locals;

        let (__warp_se_253) = warp_lt_signed128(__warp_usrid_49_liquidity, 0);

        if (__warp_se_253 != 0) {
            let (__warp_se_254) = warp_negate128(__warp_usrid_49_liquidity);

            let (__warp_se_255) = s2___warp_usrfn_04_getAmount0Delta(
                __warp_usrid_47_sqrtRatioAX96, __warp_usrid_48_sqrtRatioBX96, __warp_se_254, 0
            );

            let (__warp_se_256) = s5___warp_usrfn_02_toInt256(__warp_se_255);

            let (__warp_se_257) = warp_negate256(__warp_se_256);

            return (__warp_se_257,);
        } else {
            let (__warp_se_258) = s2___warp_usrfn_04_getAmount0Delta(
                __warp_usrid_47_sqrtRatioAX96,
                __warp_usrid_48_sqrtRatioBX96,
                __warp_usrid_49_liquidity,
                1,
            );

            let (__warp_se_259) = s5___warp_usrfn_02_toInt256(__warp_se_258);

            return (__warp_se_259,);
        }
    }

    // @notice Helper that gets signed token1 delta
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The change in liquidity for which to compute the amount1 delta
    // @return amount1 Amount of token1 corresponding to the passed liquidityDelta between the two prices
    func s2___warp_usrfn_07_getAmount1Delta{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_51_sqrtRatioAX96: felt,
        __warp_usrid_52_sqrtRatioBX96: felt,
        __warp_usrid_53_liquidity: felt,
    ) -> (__warp_usrid_54_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_260) = warp_lt_signed128(__warp_usrid_53_liquidity, 0);

        if (__warp_se_260 != 0) {
            let (__warp_se_261) = warp_negate128(__warp_usrid_53_liquidity);

            let (__warp_se_262) = s2___warp_usrfn_05_getAmount1Delta(
                __warp_usrid_51_sqrtRatioAX96, __warp_usrid_52_sqrtRatioBX96, __warp_se_261, 0
            );

            let (__warp_se_263) = s5___warp_usrfn_02_toInt256(__warp_se_262);

            let (__warp_se_264) = warp_negate256(__warp_se_263);

            return (__warp_se_264,);
        } else {
            let (__warp_se_265) = s2___warp_usrfn_05_getAmount1Delta(
                __warp_usrid_51_sqrtRatioAX96,
                __warp_usrid_52_sqrtRatioBX96,
                __warp_usrid_53_liquidity,
                1,
            );

            let (__warp_se_266) = s5___warp_usrfn_02_toInt256(__warp_se_265);

            return (__warp_se_266,);
        }
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

        let (__warp_se_267) = warp_mod256(__warp_usrid_01_x, __warp_usrid_02_y);

        let (__warp_se_268) = warp_gt256(__warp_se_267, Uint256(low=0, high=0));

        if (__warp_se_268 != 0) {
            let __warp_usrid_04_temp = Uint256(low=1, high=0);

            let (__warp_se_269) = s3___warp_usrfn_00_divRoundingUp_if_part1(
                __warp_usrid_03_z, __warp_usrid_01_x, __warp_usrid_02_y, __warp_usrid_04_temp
            );

            return (__warp_se_269,);
        } else {
            let (__warp_se_270) = s3___warp_usrfn_00_divRoundingUp_if_part1(
                __warp_usrid_03_z, __warp_usrid_01_x, __warp_usrid_02_y, __warp_usrid_04_temp
            );

            return (__warp_se_270,);
        }
    }

    func s3___warp_usrfn_00_divRoundingUp_if_part1{range_check_ptr: felt}(
        __warp_usrid_03_z: Uint256,
        __warp_usrid_01_x: Uint256,
        __warp_usrid_02_y: Uint256,
        __warp_usrid_04_temp: Uint256,
    ) -> (__warp_usrid_03_z: Uint256) {
        alloc_locals;

        let (__warp_se_271) = warp_div_unsafe256(__warp_usrid_01_x, __warp_usrid_02_y);

        let (__warp_se_272) = warp_add_unsafe256(__warp_se_271, __warp_usrid_04_temp);

        let __warp_usrid_03_z = __warp_se_272;

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

        let (__warp_se_273) = warp_add256(__warp_usrid_05_x, __warp_usrid_06_y);

        let __warp_se_274 = __warp_se_273;

        let __warp_usrid_07_z = __warp_se_274;

        let (__warp_se_275) = warp_ge256(__warp_se_274, __warp_usrid_05_x);

        assert __warp_se_275 = 1;

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

        let (__warp_se_276) = warp_int256_to_int160(__warp_usrid_03_y);

        let __warp_se_277 = __warp_se_276;

        let __warp_usrid_04_z = __warp_se_277;

        let (__warp_se_278) = warp_uint256(__warp_se_277);

        let (__warp_se_279) = warp_eq256(__warp_se_278, __warp_usrid_03_y);

        assert __warp_se_279 = 1;

        return (__warp_usrid_04_z,);
    }

    // @notice Cast a uint256 to a int256, revert on overflow
    // @param y The uint256 to be casted
    // @return z The casted integer, now type int256
    func s5___warp_usrfn_02_toInt256{range_check_ptr: felt}(__warp_usrid_07_y: Uint256) -> (
        __warp_usrid_08_z: Uint256
    ) {
        alloc_locals;

        let __warp_usrid_08_z = Uint256(low=0, high=0);

        let (__warp_se_280) = warp_lt256(
            __warp_usrid_07_y, Uint256(low=0, high=170141183460469231731687303715884105728)
        );

        assert __warp_se_280 = 1;

        let __warp_usrid_08_z = __warp_usrid_07_y;

        return (__warp_usrid_08_z,);
    }
}

@view
func mulDivRoundingUpInvariants_3d729147{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_00_x: Uint256, __warp_usrid_01_y: Uint256, __warp_usrid_02_z: Uint256) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_02_z);

    warp_external_input_check_int256(__warp_usrid_01_y);

    warp_external_input_check_int256(__warp_usrid_00_x);

    let (__warp_se_0) = warp_gt256(__warp_usrid_02_z, Uint256(low=0, high=0));

    assert __warp_se_0 = 1;

    let (__warp_usrid_03_notRoundedUp) = SqrtPriceMathEchidnaTest.s1___warp_usrfn_00_mulDiv(
        __warp_usrid_00_x, __warp_usrid_01_y, __warp_usrid_02_z
    );

    let (__warp_usrid_04_roundedUp) = SqrtPriceMathEchidnaTest.s1___warp_usrfn_01_mulDivRoundingUp(
        __warp_usrid_00_x, __warp_usrid_01_y, __warp_usrid_02_z
    );

    let (__warp_se_1) = warp_ge256(__warp_usrid_04_roundedUp, __warp_usrid_03_notRoundedUp);

    assert __warp_se_1 = 1;

    let (__warp_se_2) = warp_sub256(__warp_usrid_04_roundedUp, __warp_usrid_03_notRoundedUp);

    let (__warp_se_3) = warp_lt256(__warp_se_2, Uint256(low=2, high=0));

    assert __warp_se_3 = 1;

    let (__warp_se_4) = warp_sub256(__warp_usrid_04_roundedUp, __warp_usrid_03_notRoundedUp);

    let (__warp_se_5) = warp_eq256(__warp_se_4, Uint256(low=1, high=0));

    if (__warp_se_5 != 0) {
        let (__warp_se_6) = warp_mulmod(__warp_usrid_00_x, __warp_usrid_01_y, __warp_usrid_02_z);

        let (__warp_se_7) = warp_gt256(__warp_se_6, Uint256(low=0, high=0));

        assert __warp_se_7 = 1;

        SqrtPriceMathEchidnaTest.mulDivRoundingUpInvariants_3d729147_if_part1();

        return ();
    } else {
        let (__warp_se_8) = warp_mulmod(__warp_usrid_00_x, __warp_usrid_01_y, __warp_usrid_02_z);

        let (__warp_se_9) = warp_eq256(__warp_se_8, Uint256(low=0, high=0));

        assert __warp_se_9 = 1;

        SqrtPriceMathEchidnaTest.mulDivRoundingUpInvariants_3d729147_if_part1();

        return ();
    }
}

@view
func getNextSqrtPriceFromInputInvariants_1faf4a39{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_05_sqrtP: felt,
    __warp_usrid_06_liquidity: felt,
    __warp_usrid_07_amountIn: Uint256,
    __warp_usrid_08_zeroForOne: felt,
) -> () {
    alloc_locals;

    warp_external_input_check_bool(__warp_usrid_08_zeroForOne);

    warp_external_input_check_int256(__warp_usrid_07_amountIn);

    warp_external_input_check_int128(__warp_usrid_06_liquidity);

    warp_external_input_check_int160(__warp_usrid_05_sqrtP);

    let (
        __warp_usrid_09_sqrtQ
    ) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_02_getNextSqrtPriceFromInput(
        __warp_usrid_05_sqrtP,
        __warp_usrid_06_liquidity,
        __warp_usrid_07_amountIn,
        __warp_usrid_08_zeroForOne,
    );

    if (__warp_usrid_08_zeroForOne != 0) {
        let (__warp_se_10) = warp_le(__warp_usrid_09_sqrtQ, __warp_usrid_05_sqrtP);

        assert __warp_se_10 = 1;

        let (__warp_se_11) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_04_getAmount0Delta(
            __warp_usrid_09_sqrtQ, __warp_usrid_05_sqrtP, __warp_usrid_06_liquidity, 1
        );

        let (__warp_se_12) = warp_ge256(__warp_usrid_07_amountIn, __warp_se_11);

        assert __warp_se_12 = 1;

        SqrtPriceMathEchidnaTest.getNextSqrtPriceFromInputInvariants_1faf4a39_if_part1();

        return ();
    } else {
        let (__warp_se_13) = warp_ge(__warp_usrid_09_sqrtQ, __warp_usrid_05_sqrtP);

        assert __warp_se_13 = 1;

        let (__warp_se_14) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_05_getAmount1Delta(
            __warp_usrid_05_sqrtP, __warp_usrid_09_sqrtQ, __warp_usrid_06_liquidity, 1
        );

        let (__warp_se_15) = warp_ge256(__warp_usrid_07_amountIn, __warp_se_14);

        assert __warp_se_15 = 1;

        SqrtPriceMathEchidnaTest.getNextSqrtPriceFromInputInvariants_1faf4a39_if_part1();

        return ();
    }
}

@view
func getNextSqrtPriceFromOutputInvariants_f157fb50{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_10_sqrtP: felt,
    __warp_usrid_11_liquidity: felt,
    __warp_usrid_12_amountOut: Uint256,
    __warp_usrid_13_zeroForOne: felt,
) -> () {
    alloc_locals;

    warp_external_input_check_bool(__warp_usrid_13_zeroForOne);

    warp_external_input_check_int256(__warp_usrid_12_amountOut);

    warp_external_input_check_int128(__warp_usrid_11_liquidity);

    warp_external_input_check_int160(__warp_usrid_10_sqrtP);

    let (
        __warp_usrid_14_sqrtQ
    ) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_03_getNextSqrtPriceFromOutput(
        __warp_usrid_10_sqrtP,
        __warp_usrid_11_liquidity,
        __warp_usrid_12_amountOut,
        __warp_usrid_13_zeroForOne,
    );

    if (__warp_usrid_13_zeroForOne != 0) {
        let (__warp_se_16) = warp_le(__warp_usrid_14_sqrtQ, __warp_usrid_10_sqrtP);

        assert __warp_se_16 = 1;

        let (__warp_se_17) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_05_getAmount1Delta(
            __warp_usrid_14_sqrtQ, __warp_usrid_10_sqrtP, __warp_usrid_11_liquidity, 0
        );

        let (__warp_se_18) = warp_le256(__warp_usrid_12_amountOut, __warp_se_17);

        assert __warp_se_18 = 1;

        SqrtPriceMathEchidnaTest.getNextSqrtPriceFromOutputInvariants_f157fb50_if_part1();

        return ();
    } else {
        let (__warp_se_19) = warp_gt(__warp_usrid_14_sqrtQ, 0);

        assert __warp_se_19 = 1;

        let (__warp_se_20) = warp_ge(__warp_usrid_14_sqrtQ, __warp_usrid_10_sqrtP);

        assert __warp_se_20 = 1;

        let (__warp_se_21) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_04_getAmount0Delta(
            __warp_usrid_10_sqrtP, __warp_usrid_14_sqrtQ, __warp_usrid_11_liquidity, 0
        );

        let (__warp_se_22) = warp_le256(__warp_usrid_12_amountOut, __warp_se_21);

        assert __warp_se_22 = 1;

        SqrtPriceMathEchidnaTest.getNextSqrtPriceFromOutputInvariants_f157fb50_if_part1();

        return ();
    }
}

@view
func getNextSqrtPriceFromAmount0RoundingUpInvariants_b46e6714{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_15_sqrtPX96: felt,
    __warp_usrid_16_liquidity: felt,
    __warp_usrid_17_amount: Uint256,
    __warp_usrid_18_add: felt,
) -> () {
    alloc_locals;

    warp_external_input_check_bool(__warp_usrid_18_add);

    warp_external_input_check_int256(__warp_usrid_17_amount);

    warp_external_input_check_int128(__warp_usrid_16_liquidity);

    warp_external_input_check_int160(__warp_usrid_15_sqrtPX96);

    let (__warp_se_23) = warp_gt(__warp_usrid_15_sqrtPX96, 0);

    assert __warp_se_23 = 1;

    let (__warp_se_24) = warp_gt(__warp_usrid_16_liquidity, 0);

    assert __warp_se_24 = 1;

    let (
        __warp_usrid_19_sqrtQX96
    ) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_00_getNextSqrtPriceFromAmount0RoundingUp(
        __warp_usrid_15_sqrtPX96,
        __warp_usrid_16_liquidity,
        __warp_usrid_17_amount,
        __warp_usrid_18_add,
    );

    if (__warp_usrid_18_add != 0) {
        let (__warp_se_25) = warp_le(__warp_usrid_19_sqrtQX96, __warp_usrid_15_sqrtPX96);

        assert __warp_se_25 = 1;

        SqrtPriceMathEchidnaTest.getNextSqrtPriceFromAmount0RoundingUpInvariants_b46e6714_if_part1(
            __warp_usrid_17_amount, __warp_usrid_15_sqrtPX96, __warp_usrid_19_sqrtQX96
        );

        return ();
    } else {
        let (__warp_se_26) = warp_ge(__warp_usrid_19_sqrtQX96, __warp_usrid_15_sqrtPX96);

        assert __warp_se_26 = 1;

        SqrtPriceMathEchidnaTest.getNextSqrtPriceFromAmount0RoundingUpInvariants_b46e6714_if_part1(
            __warp_usrid_17_amount, __warp_usrid_15_sqrtPX96, __warp_usrid_19_sqrtQX96
        );

        return ();
    }
}

@view
func getNextSqrtPriceFromAmount1RoundingDownInvariants_21e14f8b{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_20_sqrtPX96: felt,
    __warp_usrid_21_liquidity: felt,
    __warp_usrid_22_amount: Uint256,
    __warp_usrid_23_add: felt,
) -> () {
    alloc_locals;

    warp_external_input_check_bool(__warp_usrid_23_add);

    warp_external_input_check_int256(__warp_usrid_22_amount);

    warp_external_input_check_int128(__warp_usrid_21_liquidity);

    warp_external_input_check_int160(__warp_usrid_20_sqrtPX96);

    let (__warp_se_29) = warp_gt(__warp_usrid_20_sqrtPX96, 0);

    assert __warp_se_29 = 1;

    let (__warp_se_30) = warp_gt(__warp_usrid_21_liquidity, 0);

    assert __warp_se_30 = 1;

    let (
        __warp_usrid_24_sqrtQX96
    ) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_01_getNextSqrtPriceFromAmount1RoundingDown(
        __warp_usrid_20_sqrtPX96,
        __warp_usrid_21_liquidity,
        __warp_usrid_22_amount,
        __warp_usrid_23_add,
    );

    if (__warp_usrid_23_add != 0) {
        let (__warp_se_31) = warp_ge(__warp_usrid_24_sqrtQX96, __warp_usrid_20_sqrtPX96);

        assert __warp_se_31 = 1;

        SqrtPriceMathEchidnaTest.getNextSqrtPriceFromAmount1RoundingDownInvariants_21e14f8b_if_part1(
            __warp_usrid_22_amount, __warp_usrid_20_sqrtPX96, __warp_usrid_24_sqrtQX96
        );

        return ();
    } else {
        let (__warp_se_32) = warp_le(__warp_usrid_24_sqrtQX96, __warp_usrid_20_sqrtPX96);

        assert __warp_se_32 = 1;

        SqrtPriceMathEchidnaTest.getNextSqrtPriceFromAmount1RoundingDownInvariants_21e14f8b_if_part1(
            __warp_usrid_22_amount, __warp_usrid_20_sqrtPX96, __warp_usrid_24_sqrtQX96
        );

        return ();
    }
}

@view
func getAmount0DeltaInvariants_3001e65e{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_25_sqrtP: felt, __warp_usrid_26_sqrtQ: felt, __warp_usrid_27_liquidity: felt) -> () {
    alloc_locals;

    warp_external_input_check_int128(__warp_usrid_27_liquidity);

    warp_external_input_check_int160(__warp_usrid_26_sqrtQ);

    warp_external_input_check_int160(__warp_usrid_25_sqrtP);

    let (__warp_se_35) = warp_gt(__warp_usrid_25_sqrtP, 0);

    let (__warp_se_36) = warp_gt(__warp_usrid_26_sqrtQ, 0);

    let (__warp_se_37) = warp_and_(__warp_se_35, __warp_se_36);

    assert __warp_se_37 = 1;

    let (__warp_usrid_28_amount0Down) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_04_getAmount0Delta(
        __warp_usrid_26_sqrtQ, __warp_usrid_25_sqrtP, __warp_usrid_27_liquidity, 0
    );

    let (__warp_se_38) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_04_getAmount0Delta(
        __warp_usrid_25_sqrtP, __warp_usrid_26_sqrtQ, __warp_usrid_27_liquidity, 0
    );

    let (__warp_se_39) = warp_eq256(__warp_usrid_28_amount0Down, __warp_se_38);

    assert __warp_se_39 = 1;

    let (__warp_usrid_29_amount0Up) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_04_getAmount0Delta(
        __warp_usrid_26_sqrtQ, __warp_usrid_25_sqrtP, __warp_usrid_27_liquidity, 1
    );

    let (__warp_se_40) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_04_getAmount0Delta(
        __warp_usrid_25_sqrtP, __warp_usrid_26_sqrtQ, __warp_usrid_27_liquidity, 1
    );

    let (__warp_se_41) = warp_eq256(__warp_usrid_29_amount0Up, __warp_se_40);

    assert __warp_se_41 = 1;

    let (__warp_se_42) = warp_le256(__warp_usrid_28_amount0Down, __warp_usrid_29_amount0Up);

    assert __warp_se_42 = 1;

    let (__warp_se_43) = warp_sub256(__warp_usrid_29_amount0Up, __warp_usrid_28_amount0Down);

    let (__warp_se_44) = warp_lt256(__warp_se_43, Uint256(low=2, high=0));

    assert __warp_se_44 = 1;

    return ();
}

@view
func getAmount0DeltaEquivalency_8e13a4b9{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_30_sqrtP: felt,
    __warp_usrid_31_sqrtQ: felt,
    __warp_usrid_32_liquidity: felt,
    __warp_usrid_33_roundUp: felt,
) -> () {
    alloc_locals;

    warp_external_input_check_bool(__warp_usrid_33_roundUp);

    warp_external_input_check_int128(__warp_usrid_32_liquidity);

    warp_external_input_check_int160(__warp_usrid_31_sqrtQ);

    warp_external_input_check_int160(__warp_usrid_30_sqrtP);

    let (__warp_se_45) = warp_ge(__warp_usrid_30_sqrtP, __warp_usrid_31_sqrtQ);

    assert __warp_se_45 = 1;

    let (__warp_se_46) = warp_gt(__warp_usrid_30_sqrtP, 0);

    let (__warp_se_47) = warp_gt(__warp_usrid_31_sqrtQ, 0);

    let (__warp_se_48) = warp_and_(__warp_se_46, __warp_se_47);

    assert __warp_se_48 = 1;

    let (__warp_se_49) = warp_mul160(__warp_usrid_30_sqrtP, __warp_usrid_31_sqrtQ);

    let (__warp_se_50) = warp_div(__warp_se_49, __warp_usrid_30_sqrtP);

    let (__warp_se_51) = warp_eq(__warp_se_50, __warp_usrid_31_sqrtQ);

    assert __warp_se_51 = 1;

    let (__warp_se_52) = warp_uint256(__warp_usrid_32_liquidity);

    let (__warp_usrid_34_numerator1) = warp_shl256(__warp_se_52, 96);

    let (__warp_se_53) = warp_sub(__warp_usrid_30_sqrtP, __warp_usrid_31_sqrtQ);

    let (__warp_usrid_35_numerator2) = warp_uint256(__warp_se_53);

    let (__warp_se_54) = warp_uint256(__warp_usrid_30_sqrtP);

    let (__warp_se_55) = warp_uint256(__warp_usrid_31_sqrtQ);

    let (__warp_usrid_36_denominator) = warp_mul256(__warp_se_54, __warp_se_55);

    let __warp_usrid_37_safeResult = Uint256(low=0, high=0);

    if (__warp_usrid_33_roundUp != 0) {
        let (__warp_se_56) = SqrtPriceMathEchidnaTest.s1___warp_usrfn_01_mulDivRoundingUp(
            __warp_usrid_34_numerator1, __warp_usrid_35_numerator2, __warp_usrid_36_denominator
        );

        let __warp_usrid_37_safeResult = __warp_se_56;

        SqrtPriceMathEchidnaTest.getAmount0DeltaEquivalency_8e13a4b9_if_part1(
            __warp_usrid_31_sqrtQ,
            __warp_usrid_30_sqrtP,
            __warp_usrid_32_liquidity,
            __warp_usrid_33_roundUp,
            __warp_usrid_37_safeResult,
        );

        return ();
    } else {
        let (__warp_se_57) = SqrtPriceMathEchidnaTest.s1___warp_usrfn_00_mulDiv(
            __warp_usrid_34_numerator1, __warp_usrid_35_numerator2, __warp_usrid_36_denominator
        );

        let __warp_usrid_37_safeResult = __warp_se_57;

        SqrtPriceMathEchidnaTest.getAmount0DeltaEquivalency_8e13a4b9_if_part1(
            __warp_usrid_31_sqrtQ,
            __warp_usrid_30_sqrtP,
            __warp_usrid_32_liquidity,
            __warp_usrid_33_roundUp,
            __warp_usrid_37_safeResult,
        );

        return ();
    }
}

@view
func getAmount1DeltaInvariants_c8569d88{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_39_sqrtP: felt, __warp_usrid_40_sqrtQ: felt, __warp_usrid_41_liquidity: felt) -> () {
    alloc_locals;

    warp_external_input_check_int128(__warp_usrid_41_liquidity);

    warp_external_input_check_int160(__warp_usrid_40_sqrtQ);

    warp_external_input_check_int160(__warp_usrid_39_sqrtP);

    let (__warp_se_59) = warp_gt(__warp_usrid_39_sqrtP, 0);

    let (__warp_se_60) = warp_gt(__warp_usrid_40_sqrtQ, 0);

    let (__warp_se_61) = warp_and_(__warp_se_59, __warp_se_60);

    assert __warp_se_61 = 1;

    let (__warp_usrid_42_amount1Down) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_05_getAmount1Delta(
        __warp_usrid_39_sqrtP, __warp_usrid_40_sqrtQ, __warp_usrid_41_liquidity, 0
    );

    let (__warp_se_62) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_05_getAmount1Delta(
        __warp_usrid_40_sqrtQ, __warp_usrid_39_sqrtP, __warp_usrid_41_liquidity, 0
    );

    let (__warp_se_63) = warp_eq256(__warp_usrid_42_amount1Down, __warp_se_62);

    assert __warp_se_63 = 1;

    let (__warp_usrid_43_amount1Up) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_05_getAmount1Delta(
        __warp_usrid_39_sqrtP, __warp_usrid_40_sqrtQ, __warp_usrid_41_liquidity, 1
    );

    let (__warp_se_64) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_05_getAmount1Delta(
        __warp_usrid_40_sqrtQ, __warp_usrid_39_sqrtP, __warp_usrid_41_liquidity, 1
    );

    let (__warp_se_65) = warp_eq256(__warp_usrid_43_amount1Up, __warp_se_64);

    assert __warp_se_65 = 1;

    let (__warp_se_66) = warp_le256(__warp_usrid_42_amount1Down, __warp_usrid_43_amount1Up);

    assert __warp_se_66 = 1;

    let (__warp_se_67) = warp_sub256(__warp_usrid_43_amount1Up, __warp_usrid_42_amount1Down);

    let (__warp_se_68) = warp_lt256(__warp_se_67, Uint256(low=2, high=0));

    assert __warp_se_68 = 1;

    return ();
}

@view
func getAmount0DeltaSignedInvariants_b29f199e{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_44_sqrtP: felt, __warp_usrid_45_sqrtQ: felt, __warp_usrid_46_liquidity: felt) -> () {
    alloc_locals;

    warp_external_input_check_int128(__warp_usrid_46_liquidity);

    warp_external_input_check_int160(__warp_usrid_45_sqrtQ);

    warp_external_input_check_int160(__warp_usrid_44_sqrtP);

    let (__warp_se_69) = warp_gt(__warp_usrid_44_sqrtP, 0);

    let (__warp_se_70) = warp_gt(__warp_usrid_45_sqrtQ, 0);

    let (__warp_se_71) = warp_and_(__warp_se_69, __warp_se_70);

    assert __warp_se_71 = 1;

    let (__warp_usrid_47_amount0) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_06_getAmount0Delta(
        __warp_usrid_45_sqrtQ, __warp_usrid_44_sqrtP, __warp_usrid_46_liquidity
    );

    let (__warp_se_72) = warp_lt_signed128(__warp_usrid_46_liquidity, 0);

    if (__warp_se_72 != 0) {
        let (__warp_se_73) = warp_le_signed256(__warp_usrid_47_amount0, Uint256(low=0, high=0));

        assert __warp_se_73 = 1;

        SqrtPriceMathEchidnaTest.getAmount0DeltaSignedInvariants_b29f199e_if_part1(
            __warp_usrid_46_liquidity,
            __warp_usrid_44_sqrtP,
            __warp_usrid_45_sqrtQ,
            __warp_usrid_47_amount0,
        );

        return ();
    } else {
        SqrtPriceMathEchidnaTest.getAmount0DeltaSignedInvariants_b29f199e_if_part1(
            __warp_usrid_46_liquidity,
            __warp_usrid_44_sqrtP,
            __warp_usrid_45_sqrtQ,
            __warp_usrid_47_amount0,
        );

        return ();
    }
}

@view
func getAmount1DeltaSignedInvariants_6e6238d7{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_48_sqrtP: felt, __warp_usrid_49_sqrtQ: felt, __warp_usrid_50_liquidity: felt) -> () {
    alloc_locals;

    warp_external_input_check_int128(__warp_usrid_50_liquidity);

    warp_external_input_check_int160(__warp_usrid_49_sqrtQ);

    warp_external_input_check_int160(__warp_usrid_48_sqrtP);

    let (__warp_se_80) = warp_gt(__warp_usrid_48_sqrtP, 0);

    let (__warp_se_81) = warp_gt(__warp_usrid_49_sqrtQ, 0);

    let (__warp_se_82) = warp_and_(__warp_se_80, __warp_se_81);

    assert __warp_se_82 = 1;

    let (__warp_usrid_51_amount1) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_07_getAmount1Delta(
        __warp_usrid_48_sqrtP, __warp_usrid_49_sqrtQ, __warp_usrid_50_liquidity
    );

    let (__warp_se_83) = warp_lt_signed128(__warp_usrid_50_liquidity, 0);

    if (__warp_se_83 != 0) {
        let (__warp_se_84) = warp_le_signed256(__warp_usrid_51_amount1, Uint256(low=0, high=0));

        assert __warp_se_84 = 1;

        SqrtPriceMathEchidnaTest.getAmount1DeltaSignedInvariants_6e6238d7_if_part1(
            __warp_usrid_50_liquidity,
            __warp_usrid_48_sqrtP,
            __warp_usrid_49_sqrtQ,
            __warp_usrid_51_amount1,
        );

        return ();
    } else {
        SqrtPriceMathEchidnaTest.getAmount1DeltaSignedInvariants_6e6238d7_if_part1(
            __warp_usrid_50_liquidity,
            __warp_usrid_48_sqrtP,
            __warp_usrid_49_sqrtQ,
            __warp_usrid_51_amount1,
        );

        return ();
    }
}

@view
func getOutOfRangeMintInvariants_b712c47c{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_52_sqrtA: felt, __warp_usrid_53_sqrtB: felt, __warp_usrid_54_liquidity: felt) -> () {
    alloc_locals;

    warp_external_input_check_int128(__warp_usrid_54_liquidity);

    warp_external_input_check_int160(__warp_usrid_53_sqrtB);

    warp_external_input_check_int160(__warp_usrid_52_sqrtA);

    let (__warp_se_91) = warp_gt(__warp_usrid_52_sqrtA, 0);

    let (__warp_se_92) = warp_gt(__warp_usrid_53_sqrtB, 0);

    let (__warp_se_93) = warp_and_(__warp_se_91, __warp_se_92);

    assert __warp_se_93 = 1;

    let (__warp_se_94) = warp_gt_signed128(__warp_usrid_54_liquidity, 0);

    assert __warp_se_94 = 1;

    let (__warp_usrid_55_amount0) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_06_getAmount0Delta(
        __warp_usrid_52_sqrtA, __warp_usrid_53_sqrtB, __warp_usrid_54_liquidity
    );

    let (__warp_usrid_56_amount1) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_07_getAmount1Delta(
        __warp_usrid_52_sqrtA, __warp_usrid_53_sqrtB, __warp_usrid_54_liquidity
    );

    let (__warp_se_95) = warp_eq(__warp_usrid_52_sqrtA, __warp_usrid_53_sqrtB);

    if (__warp_se_95 != 0) {
        let (__warp_se_96) = warp_eq256(__warp_usrid_55_amount0, Uint256(low=0, high=0));

        assert __warp_se_96 = 1;

        let (__warp_se_97) = warp_eq256(__warp_usrid_56_amount1, Uint256(low=0, high=0));

        assert __warp_se_97 = 1;

        SqrtPriceMathEchidnaTest.getOutOfRangeMintInvariants_b712c47c_if_part1();

        return ();
    } else {
        let (__warp_se_98) = warp_gt_signed256(__warp_usrid_55_amount0, Uint256(low=0, high=0));

        assert __warp_se_98 = 1;

        let (__warp_se_99) = warp_gt_signed256(__warp_usrid_56_amount1, Uint256(low=0, high=0));

        assert __warp_se_99 = 1;

        SqrtPriceMathEchidnaTest.getOutOfRangeMintInvariants_b712c47c_if_part1();

        return ();
    }
}

@view
func getInRangeMintInvariants_39933d51{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(
    __warp_usrid_57_sqrtLower: felt,
    __warp_usrid_58_sqrtCurrent: felt,
    __warp_usrid_59_sqrtUpper: felt,
    __warp_usrid_60_liquidity: felt,
) -> () {
    alloc_locals;

    warp_external_input_check_int128(__warp_usrid_60_liquidity);

    warp_external_input_check_int160(__warp_usrid_59_sqrtUpper);

    warp_external_input_check_int160(__warp_usrid_58_sqrtCurrent);

    warp_external_input_check_int160(__warp_usrid_57_sqrtLower);

    let (__warp_se_100) = warp_gt(__warp_usrid_57_sqrtLower, 0);

    assert __warp_se_100 = 1;

    let (__warp_se_101) = warp_lt(__warp_usrid_57_sqrtLower, __warp_usrid_59_sqrtUpper);

    assert __warp_se_101 = 1;

    let (__warp_se_102) = warp_le(__warp_usrid_57_sqrtLower, __warp_usrid_58_sqrtCurrent);

    let (__warp_se_103) = warp_le(__warp_usrid_58_sqrtCurrent, __warp_usrid_59_sqrtUpper);

    let (__warp_se_104) = warp_and_(__warp_se_102, __warp_se_103);

    assert __warp_se_104 = 1;

    let (__warp_se_105) = warp_gt_signed128(__warp_usrid_60_liquidity, 0);

    assert __warp_se_105 = 1;

    let (__warp_usrid_61_amount0) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_06_getAmount0Delta(
        __warp_usrid_58_sqrtCurrent, __warp_usrid_59_sqrtUpper, __warp_usrid_60_liquidity
    );

    let (__warp_usrid_62_amount1) = SqrtPriceMathEchidnaTest.s2___warp_usrfn_07_getAmount1Delta(
        __warp_usrid_57_sqrtLower, __warp_usrid_58_sqrtCurrent, __warp_usrid_60_liquidity
    );

    let (__warp_se_106) = warp_gt_signed256(__warp_usrid_61_amount0, Uint256(low=0, high=0));

    let (__warp_se_107) = warp_gt_signed256(__warp_usrid_62_amount1, Uint256(low=0, high=0));

    let (__warp_se_108) = warp_or(__warp_se_106, __warp_se_107);

    assert __warp_se_108 = 1;

    return ();
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","mulDivRoundingUpInvariants(uint256,uint256,uint256)","getNextSqrtPriceFromInputInvariants(uint160,uint128,uint256,bool)","getNextSqrtPriceFromOutputInvariants(uint160,uint128,uint256,bool)","getNextSqrtPriceFromAmount0RoundingUpInvariants(uint160,uint128,uint256,bool)","getNextSqrtPriceFromAmount1RoundingDownInvariants(uint160,uint128,uint256,bool)","getAmount0DeltaInvariants(uint160,uint160,uint128)","getAmount0DeltaEquivalency(uint160,uint160,uint128,bool)","getAmount1DeltaInvariants(uint160,uint160,uint128)","getAmount0DeltaSignedInvariants(uint160,uint160,int128)","getAmount1DeltaSignedInvariants(uint160,uint160,int128)","getOutOfRangeMintInvariants(uint160,uint160,int128)","getInRangeMintInvariants(uint160,uint160,uint160,int128)"]
