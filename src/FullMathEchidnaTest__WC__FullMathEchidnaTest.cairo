%lang starknet

from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.gt import warp_gt256
from warplib.maths.mulmod import warp_mulmod
from warplib.maths.sub import warp_sub256
from warplib.maths.eq import warp_eq256
from warplib.maths.or import warp_or
from warplib.maths.le import warp_le256
from warplib.maths.lt import warp_lt256
from warplib.maths.ge import warp_ge256
from warplib.maths.mul_unsafe import warp_mul_unsafe256
from warplib.maths.sub_unsafe import warp_sub_unsafe256
from warplib.maths.div_unsafe import warp_div_unsafe256
from warplib.maths.negate import warp_negate256
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.add_unsafe import warp_add_unsafe256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.xor import warp_xor256

// Contract Def FullMathEchidnaTest

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

namespace FullMathEchidnaTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    func checkMulDivRounding_695363a3_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func checkMulDiv_bf08c391_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_08_z: Uint256,
        __warp_usrid_07_d: Uint256,
        __warp_usrid_06_y: Uint256,
        __warp_usrid_05_x: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_usrid_09_x2) = s1___warp_usrfn_00_mulDiv(
            __warp_usrid_08_z, __warp_usrid_07_d, __warp_usrid_06_y
        );

        let (__warp_usrid_10_y2) = s1___warp_usrfn_00_mulDiv(
            __warp_usrid_08_z, __warp_usrid_07_d, __warp_usrid_05_x
        );

        let (__warp_se_11) = warp_le256(__warp_usrid_09_x2, __warp_usrid_05_x);

        assert __warp_se_11 = 1;

        let (__warp_se_12) = warp_le256(__warp_usrid_10_y2, __warp_usrid_06_y);

        assert __warp_se_12 = 1;

        let (__warp_se_13) = warp_sub256(__warp_usrid_05_x, __warp_usrid_09_x2);

        let (__warp_se_14) = warp_lt256(__warp_se_13, __warp_usrid_07_d);

        assert __warp_se_14 = 1;

        let (__warp_se_15) = warp_sub256(__warp_usrid_06_y, __warp_usrid_10_y2);

        let (__warp_se_16) = warp_lt256(__warp_se_15, __warp_usrid_07_d);

        assert __warp_se_16 = 1;

        return ();
    }

    func checkMulDivRoundingUp_79eee487_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_14_z: Uint256,
        __warp_usrid_13_d: Uint256,
        __warp_usrid_12_y: Uint256,
        __warp_usrid_11_x: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_usrid_15_x2) = s1___warp_usrfn_00_mulDiv(
            __warp_usrid_14_z, __warp_usrid_13_d, __warp_usrid_12_y
        );

        let (__warp_usrid_16_y2) = s1___warp_usrfn_00_mulDiv(
            __warp_usrid_14_z, __warp_usrid_13_d, __warp_usrid_11_x
        );

        let (__warp_se_22) = warp_ge256(__warp_usrid_15_x2, __warp_usrid_11_x);

        assert __warp_se_22 = 1;

        let (__warp_se_23) = warp_ge256(__warp_usrid_16_y2, __warp_usrid_12_y);

        assert __warp_se_23 = 1;

        let (__warp_se_24) = warp_sub256(__warp_usrid_15_x2, __warp_usrid_11_x);

        let (__warp_se_25) = warp_lt256(__warp_se_24, __warp_usrid_13_d);

        assert __warp_se_25 = 1;

        let (__warp_se_26) = warp_sub256(__warp_usrid_16_y2, __warp_usrid_12_y);

        let (__warp_se_27) = warp_lt256(__warp_se_26, __warp_usrid_13_d);

        assert __warp_se_27 = 1;

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

        let (__warp_se_28) = warp_mul_unsafe256(__warp_usrid_02_a, __warp_usrid_03_b);

        let __warp_usrid_06_prod0 = __warp_se_28;

        let (__warp_usrid_07_mm) = warp_mulmod(
            __warp_usrid_02_a,
            __warp_usrid_03_b,
            Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        );

        let __warp_usrid_08_prod1 = Uint256(low=0, high=0);

        let (__warp_se_29) = warp_sub_unsafe256(__warp_usrid_07_mm, __warp_usrid_06_prod0);

        let __warp_usrid_08_prod1 = __warp_se_29;

        let (__warp_se_30) = warp_lt256(__warp_usrid_07_mm, __warp_usrid_06_prod0);

        if (__warp_se_30 != 0) {
            let (__warp_se_31) = warp_sub_unsafe256(__warp_usrid_08_prod1, Uint256(low=1, high=0));

            let __warp_usrid_08_prod1 = __warp_se_31;

            let (__warp_se_32) = s1___warp_usrfn_00_mulDiv_if_part1(
                __warp_usrid_08_prod1,
                __warp_usrid_04_denominator,
                __warp_usrid_05_result,
                __warp_usrid_06_prod0,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
            );

            return (__warp_se_32,);
        } else {
            let (__warp_se_33) = s1___warp_usrfn_00_mulDiv_if_part1(
                __warp_usrid_08_prod1,
                __warp_usrid_04_denominator,
                __warp_usrid_05_result,
                __warp_usrid_06_prod0,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
            );

            return (__warp_se_33,);
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

        let (__warp_se_34) = warp_eq256(__warp_usrid_08_prod1, Uint256(low=0, high=0));

        if (__warp_se_34 != 0) {
            let (__warp_se_35) = warp_gt256(__warp_usrid_04_denominator, Uint256(low=0, high=0));

            assert __warp_se_35 = 1;

            let (__warp_se_36) = warp_div_unsafe256(
                __warp_usrid_06_prod0, __warp_usrid_04_denominator
            );

            let __warp_usrid_05_result = __warp_se_36;

            return (__warp_usrid_05_result,);
        } else {
            let (__warp_se_37) = s1___warp_usrfn_00_mulDiv_if_part1_if_part1(
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_02_a,
                __warp_usrid_03_b,
                __warp_usrid_06_prod0,
                __warp_usrid_05_result,
            );

            return (__warp_se_37,);
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

        let (__warp_se_38) = warp_gt256(__warp_usrid_04_denominator, __warp_usrid_08_prod1);

        assert __warp_se_38 = 1;

        let __warp_usrid_09_remainder = Uint256(low=0, high=0);

        let (__warp_se_39) = warp_mulmod(
            __warp_usrid_02_a, __warp_usrid_03_b, __warp_usrid_04_denominator
        );

        let __warp_usrid_09_remainder = __warp_se_39;

        let (__warp_se_40) = warp_gt256(__warp_usrid_09_remainder, __warp_usrid_06_prod0);

        if (__warp_se_40 != 0) {
            let (__warp_se_41) = warp_sub_unsafe256(__warp_usrid_08_prod1, Uint256(low=1, high=0));

            let __warp_usrid_08_prod1 = __warp_se_41;

            let (__warp_se_42) = s1___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1(
                __warp_usrid_06_prod0,
                __warp_usrid_09_remainder,
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_05_result,
            );

            return (__warp_se_42,);
        } else {
            let (__warp_se_43) = s1___warp_usrfn_00_mulDiv_if_part1_if_part1_if_part1(
                __warp_usrid_06_prod0,
                __warp_usrid_09_remainder,
                __warp_usrid_04_denominator,
                __warp_usrid_08_prod1,
                __warp_usrid_05_result,
            );

            return (__warp_se_43,);
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

        let (__warp_se_44) = warp_sub_unsafe256(__warp_usrid_06_prod0, __warp_usrid_09_remainder);

        let __warp_usrid_06_prod0 = __warp_se_44;

        let (__warp_se_45) = warp_negate256(__warp_usrid_04_denominator);

        let (__warp_usrid_10_twos) = warp_bitwise_and256(__warp_se_45, __warp_usrid_04_denominator);

        let (__warp_se_46) = warp_div_unsafe256(__warp_usrid_04_denominator, __warp_usrid_10_twos);

        let __warp_usrid_04_denominator = __warp_se_46;

        let (__warp_se_47) = warp_div_unsafe256(__warp_usrid_06_prod0, __warp_usrid_10_twos);

        let __warp_usrid_06_prod0 = __warp_se_47;

        let (__warp_se_48) = warp_sub_unsafe256(Uint256(low=0, high=0), __warp_usrid_10_twos);

        let (__warp_se_49) = warp_div_unsafe256(__warp_se_48, __warp_usrid_10_twos);

        let (__warp_se_50) = warp_add_unsafe256(__warp_se_49, Uint256(low=1, high=0));

        let __warp_usrid_10_twos = __warp_se_50;

        let (__warp_se_51) = warp_mul_unsafe256(__warp_usrid_08_prod1, __warp_usrid_10_twos);

        let (__warp_se_52) = warp_bitwise_or256(__warp_usrid_06_prod0, __warp_se_51);

        let __warp_usrid_06_prod0 = __warp_se_52;

        let (__warp_se_53) = warp_mul_unsafe256(
            Uint256(low=3, high=0), __warp_usrid_04_denominator
        );

        let (__warp_usrid_11_inv) = warp_xor256(__warp_se_53, Uint256(low=2, high=0));

        let (__warp_se_54) = warp_mul_unsafe256(__warp_usrid_04_denominator, __warp_usrid_11_inv);

        let (__warp_se_55) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_54);

        let (__warp_se_56) = warp_mul_unsafe256(__warp_usrid_11_inv, __warp_se_55);

        let __warp_usrid_11_inv = __warp_se_56;

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

        let (__warp_se_72) = warp_mul_unsafe256(__warp_usrid_06_prod0, __warp_usrid_11_inv);

        let __warp_usrid_05_result = __warp_se_72;

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

        let (__warp_se_73) = s1___warp_usrfn_00_mulDiv(
            __warp_usrid_12_a, __warp_usrid_13_b, __warp_usrid_14_denominator
        );

        let __warp_usrid_15_result = __warp_se_73;

        let (__warp_se_74) = warp_mulmod(
            __warp_usrid_12_a, __warp_usrid_13_b, __warp_usrid_14_denominator
        );

        let (__warp_se_75) = warp_gt256(__warp_se_74, Uint256(low=0, high=0));

        if (__warp_se_75 != 0) {
            let (__warp_se_76) = warp_lt256(
                __warp_usrid_15_result,
                Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
            );

            assert __warp_se_76 = 1;

            let (__warp_se_77) = warp_add_unsafe256(__warp_usrid_15_result, Uint256(low=1, high=0));

            let __warp_se_78 = __warp_se_77;

            let __warp_usrid_15_result = __warp_se_78;

            warp_sub_unsafe256(__warp_se_78, Uint256(low=1, high=0));

            let (__warp_se_79) = s1___warp_usrfn_01_mulDivRoundingUp_if_part1(
                __warp_usrid_15_result
            );

            return (__warp_se_79,);
        } else {
            let (__warp_se_80) = s1___warp_usrfn_01_mulDivRoundingUp_if_part1(
                __warp_usrid_15_result
            );

            return (__warp_se_80,);
        }
    }

    func s1___warp_usrfn_01_mulDivRoundingUp_if_part1(__warp_usrid_15_result: Uint256) -> (
        __warp_usrid_15_result: Uint256
    ) {
        alloc_locals;

        return (__warp_usrid_15_result,);
    }
}

@view
func checkMulDivRounding_695363a3{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_00_x: Uint256, __warp_usrid_01_y: Uint256, __warp_usrid_02_d: Uint256) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_02_d);

    warp_external_input_check_int256(__warp_usrid_01_y);

    warp_external_input_check_int256(__warp_usrid_00_x);

    let (__warp_se_0) = warp_gt256(__warp_usrid_02_d, Uint256(low=0, high=0));

    assert __warp_se_0 = 1;

    let (__warp_usrid_03_ceiled) = FullMathEchidnaTest.s1___warp_usrfn_01_mulDivRoundingUp(
        __warp_usrid_00_x, __warp_usrid_01_y, __warp_usrid_02_d
    );

    let (__warp_usrid_04_floored) = FullMathEchidnaTest.s1___warp_usrfn_00_mulDiv(
        __warp_usrid_00_x, __warp_usrid_01_y, __warp_usrid_02_d
    );

    let (__warp_se_1) = warp_mulmod(__warp_usrid_00_x, __warp_usrid_01_y, __warp_usrid_02_d);

    let (__warp_se_2) = warp_gt256(__warp_se_1, Uint256(low=0, high=0));

    if (__warp_se_2 != 0) {
        let (__warp_se_3) = warp_sub256(__warp_usrid_03_ceiled, __warp_usrid_04_floored);

        let (__warp_se_4) = warp_eq256(__warp_se_3, Uint256(low=1, high=0));

        assert __warp_se_4 = 1;

        FullMathEchidnaTest.checkMulDivRounding_695363a3_if_part1();

        return ();
    } else {
        let (__warp_se_5) = warp_eq256(__warp_usrid_03_ceiled, __warp_usrid_04_floored);

        assert __warp_se_5 = 1;

        FullMathEchidnaTest.checkMulDivRounding_695363a3_if_part1();

        return ();
    }
}

@view
func checkMulDiv_bf08c391{syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
    __warp_usrid_05_x: Uint256, __warp_usrid_06_y: Uint256, __warp_usrid_07_d: Uint256
) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_07_d);

    warp_external_input_check_int256(__warp_usrid_06_y);

    warp_external_input_check_int256(__warp_usrid_05_x);

    let (__warp_se_6) = warp_gt256(__warp_usrid_07_d, Uint256(low=0, high=0));

    assert __warp_se_6 = 1;

    let (__warp_usrid_08_z) = FullMathEchidnaTest.s1___warp_usrfn_00_mulDiv(
        __warp_usrid_05_x, __warp_usrid_06_y, __warp_usrid_07_d
    );

    let (__warp_se_7) = warp_eq256(__warp_usrid_05_x, Uint256(low=0, high=0));

    let (__warp_se_8) = warp_eq256(__warp_usrid_06_y, Uint256(low=0, high=0));

    let (__warp_se_9) = warp_or(__warp_se_7, __warp_se_8);

    if (__warp_se_9 != 0) {
        let (__warp_se_10) = warp_eq256(__warp_usrid_08_z, Uint256(low=0, high=0));

        assert __warp_se_10 = 1;

        return ();
    } else {
        FullMathEchidnaTest.checkMulDiv_bf08c391_if_part1(
            __warp_usrid_08_z, __warp_usrid_07_d, __warp_usrid_06_y, __warp_usrid_05_x
        );

        return ();
    }
}

@view
func checkMulDivRoundingUp_79eee487{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_11_x: Uint256, __warp_usrid_12_y: Uint256, __warp_usrid_13_d: Uint256) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_13_d);

    warp_external_input_check_int256(__warp_usrid_12_y);

    warp_external_input_check_int256(__warp_usrid_11_x);

    let (__warp_se_17) = warp_gt256(__warp_usrid_13_d, Uint256(low=0, high=0));

    assert __warp_se_17 = 1;

    let (__warp_usrid_14_z) = FullMathEchidnaTest.s1___warp_usrfn_01_mulDivRoundingUp(
        __warp_usrid_11_x, __warp_usrid_12_y, __warp_usrid_13_d
    );

    let (__warp_se_18) = warp_eq256(__warp_usrid_11_x, Uint256(low=0, high=0));

    let (__warp_se_19) = warp_eq256(__warp_usrid_12_y, Uint256(low=0, high=0));

    let (__warp_se_20) = warp_or(__warp_se_18, __warp_se_19);

    if (__warp_se_20 != 0) {
        let (__warp_se_21) = warp_eq256(__warp_usrid_14_z, Uint256(low=0, high=0));

        assert __warp_se_21 = 1;

        return ();
    } else {
        FullMathEchidnaTest.checkMulDivRoundingUp_79eee487_if_part1(
            __warp_usrid_14_z, __warp_usrid_13_d, __warp_usrid_12_y, __warp_usrid_11_x
        );

        return ();
    }
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","checkMulDivRounding(uint256,uint256,uint256)","checkMulDiv(uint256,uint256,uint256)","checkMulDivRoundingUp(uint256,uint256,uint256)"]
