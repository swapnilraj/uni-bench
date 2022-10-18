%lang starknet

from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.mul_unsafe import warp_mul_unsafe256
from warplib.maths.mulmod import warp_mulmod
from warplib.maths.sub_unsafe import warp_sub_unsafe256
from warplib.maths.lt import warp_lt256
from warplib.maths.eq import warp_eq256
from warplib.maths.gt import warp_gt256
from warplib.maths.div_unsafe import warp_div_unsafe256
from warplib.maths.negate import warp_negate256
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.add_unsafe import warp_add_unsafe256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.xor import warp_xor256

// Contract Def FullMathTest

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

namespace FullMathTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    func s1_mulDiv_aa9a0912{range_check_ptr: felt}(
        a: Uint256, b: Uint256, denominator: Uint256
    ) -> (result: Uint256) {
        from starkware.cairo.common.uint256 import uint256_mul_div_mod
        from starkware.cairo.common.math import assert_not_zero
        if (denominator.low == 0) {
            assert_not_zero(denominator.high);
        }
        let (quotientLow, quotientHigh, _) = uint256_mul_div_mod(a, b, denominator);
        assert quotientHigh.low = 0;
        assert quotientHigh.high = 0;
        return (quotientLow,);
    }

    func s1_mulDiv_aa9a0912_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_06_prod1: Uint256,
        __warp_usrid_02_denominator: Uint256,
        __warp_usrid_03_result: Uint256,
        __warp_usrid_04_prod0: Uint256,
        __warp_usrid_00_a: Uint256,
        __warp_usrid_01_b: Uint256,
    ) -> (__warp_usrid_03_result: Uint256) {
        alloc_locals;

        let (__warp_se_8) = warp_eq256(__warp_usrid_06_prod1, Uint256(low=0, high=0));

        if (__warp_se_8 != 0) {
            let (__warp_se_9) = warp_gt256(__warp_usrid_02_denominator, Uint256(low=0, high=0));

            assert __warp_se_9 = 1;

            let (__warp_se_10) = warp_div_unsafe256(
                __warp_usrid_04_prod0, __warp_usrid_02_denominator
            );

            let __warp_usrid_03_result = __warp_se_10;

            return (__warp_usrid_03_result,);
        } else {
            let (__warp_se_11) = s1_mulDiv_aa9a0912_if_part1_if_part1(
                __warp_usrid_02_denominator,
                __warp_usrid_06_prod1,
                __warp_usrid_00_a,
                __warp_usrid_01_b,
                __warp_usrid_04_prod0,
                __warp_usrid_03_result,
            );

            return (__warp_se_11,);
        }
    }

    func s1_mulDiv_aa9a0912_if_part1_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_02_denominator: Uint256,
        __warp_usrid_06_prod1: Uint256,
        __warp_usrid_00_a: Uint256,
        __warp_usrid_01_b: Uint256,
        __warp_usrid_04_prod0: Uint256,
        __warp_usrid_03_result: Uint256,
    ) -> (__warp_usrid_03_result: Uint256) {
        alloc_locals;

        let (__warp_se_12) = warp_gt256(__warp_usrid_02_denominator, __warp_usrid_06_prod1);

        assert __warp_se_12 = 1;

        let __warp_usrid_07_remainder = Uint256(low=0, high=0);

        let (__warp_se_13) = warp_mulmod(
            __warp_usrid_00_a, __warp_usrid_01_b, __warp_usrid_02_denominator
        );

        let __warp_usrid_07_remainder = __warp_se_13;

        let (__warp_se_14) = warp_gt256(__warp_usrid_07_remainder, __warp_usrid_04_prod0);

        if (__warp_se_14 != 0) {
            let (__warp_se_15) = warp_sub_unsafe256(__warp_usrid_06_prod1, Uint256(low=1, high=0));

            let __warp_usrid_06_prod1 = __warp_se_15;

            let (__warp_se_16) = s1_mulDiv_aa9a0912_if_part1_if_part1_if_part1(
                __warp_usrid_04_prod0,
                __warp_usrid_07_remainder,
                __warp_usrid_02_denominator,
                __warp_usrid_06_prod1,
                __warp_usrid_03_result,
            );

            return (__warp_se_16,);
        } else {
            let (__warp_se_17) = s1_mulDiv_aa9a0912_if_part1_if_part1_if_part1(
                __warp_usrid_04_prod0,
                __warp_usrid_07_remainder,
                __warp_usrid_02_denominator,
                __warp_usrid_06_prod1,
                __warp_usrid_03_result,
            );

            return (__warp_se_17,);
        }
    }

    func s1_mulDiv_aa9a0912_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_04_prod0: Uint256,
        __warp_usrid_07_remainder: Uint256,
        __warp_usrid_02_denominator: Uint256,
        __warp_usrid_06_prod1: Uint256,
        __warp_usrid_03_result: Uint256,
    ) -> (__warp_usrid_03_result: Uint256) {
        alloc_locals;

        let (__warp_se_18) = warp_sub_unsafe256(__warp_usrid_04_prod0, __warp_usrid_07_remainder);

        let __warp_usrid_04_prod0 = __warp_se_18;

        let (__warp_se_19) = warp_negate256(__warp_usrid_02_denominator);

        let (__warp_usrid_08_twos) = warp_bitwise_and256(__warp_se_19, __warp_usrid_02_denominator);

        let (__warp_se_20) = warp_div_unsafe256(__warp_usrid_02_denominator, __warp_usrid_08_twos);

        let __warp_usrid_02_denominator = __warp_se_20;

        let (__warp_se_21) = warp_div_unsafe256(__warp_usrid_04_prod0, __warp_usrid_08_twos);

        let __warp_usrid_04_prod0 = __warp_se_21;

        let (__warp_se_22) = warp_sub_unsafe256(Uint256(low=0, high=0), __warp_usrid_08_twos);

        let (__warp_se_23) = warp_div_unsafe256(__warp_se_22, __warp_usrid_08_twos);

        let (__warp_se_24) = warp_add_unsafe256(__warp_se_23, Uint256(low=1, high=0));

        let __warp_usrid_08_twos = __warp_se_24;

        let (__warp_se_25) = warp_mul_unsafe256(__warp_usrid_06_prod1, __warp_usrid_08_twos);

        let (__warp_se_26) = warp_bitwise_or256(__warp_usrid_04_prod0, __warp_se_25);

        let __warp_usrid_04_prod0 = __warp_se_26;

        let (__warp_se_27) = warp_mul_unsafe256(
            Uint256(low=3, high=0), __warp_usrid_02_denominator
        );

        let (__warp_usrid_09_inv) = warp_xor256(__warp_se_27, Uint256(low=2, high=0));

        let (__warp_se_28) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_29) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_28);

        let (__warp_se_30) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_29);

        let __warp_usrid_09_inv = __warp_se_30;

        let (__warp_se_31) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_32) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_31);

        let (__warp_se_33) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_32);

        let __warp_usrid_09_inv = __warp_se_33;

        let (__warp_se_34) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_35) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_34);

        let (__warp_se_36) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_35);

        let __warp_usrid_09_inv = __warp_se_36;

        let (__warp_se_37) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_38) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_37);

        let (__warp_se_39) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_38);

        let __warp_usrid_09_inv = __warp_se_39;

        let (__warp_se_40) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_41) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_40);

        let (__warp_se_42) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_41);

        let __warp_usrid_09_inv = __warp_se_42;

        let (__warp_se_43) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_44) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_43);

        let (__warp_se_45) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_44);

        let __warp_usrid_09_inv = __warp_se_45;

        let (__warp_se_46) = warp_mul_unsafe256(__warp_usrid_04_prod0, __warp_usrid_09_inv);

        let __warp_usrid_03_result = __warp_se_46;

        return (__warp_usrid_03_result,);
    }

    // @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    func s1_mulDivRoundingUp_0af8b27f{
        syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_10_a: Uint256, __warp_usrid_11_b: Uint256, __warp_usrid_12_denominator: Uint256
    ) -> (__warp_usrid_13_result: Uint256) {
        alloc_locals;

        let __warp_usrid_13_result = Uint256(low=0, high=0);

        let (__warp_se_47) = mulDiv_aa9a0912(
            __warp_usrid_10_a, __warp_usrid_11_b, __warp_usrid_12_denominator
        );

        let __warp_usrid_13_result = __warp_se_47;

        let (__warp_se_48) = warp_mulmod(
            __warp_usrid_10_a, __warp_usrid_11_b, __warp_usrid_12_denominator
        );

        let (__warp_se_49) = warp_gt256(__warp_se_48, Uint256(low=0, high=0));

        if (__warp_se_49 != 0) {
            let (__warp_se_50) = warp_lt256(
                __warp_usrid_13_result,
                Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
            );

            assert __warp_se_50 = 1;

            let (__warp_se_51) = warp_add_unsafe256(__warp_usrid_13_result, Uint256(low=1, high=0));

            let __warp_se_52 = __warp_se_51;

            let __warp_usrid_13_result = __warp_se_52;

            warp_sub_unsafe256(__warp_se_52, Uint256(low=1, high=0));

            let (__warp_se_53) = s1_mulDivRoundingUp_0af8b27f_if_part1(__warp_usrid_13_result);

            return (__warp_se_53,);
        } else {
            let (__warp_se_54) = s1_mulDivRoundingUp_0af8b27f_if_part1(__warp_usrid_13_result);

            return (__warp_se_54,);
        }
    }

    func s1_mulDivRoundingUp_0af8b27f_if_part1(__warp_usrid_13_result: Uint256) -> (
        __warp_usrid_13_result: Uint256
    ) {
        alloc_locals;

        return (__warp_usrid_13_result,);
    }
}

@view
func mulDiv_aa9a0912{syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
    __warp_usrid_00_x: Uint256, __warp_usrid_01_y: Uint256, __warp_usrid_02_z: Uint256
) -> (__warp_usrid_03_: Uint256) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_02_z);

    warp_external_input_check_int256(__warp_usrid_01_y);

    warp_external_input_check_int256(__warp_usrid_00_x);

    let (__warp_se_0) = FullMathTest.s1_mulDiv_aa9a0912(
        __warp_usrid_00_x, __warp_usrid_01_y, __warp_usrid_02_z
    );

    return (__warp_se_0,);
}

@view
func mulDivRoundingUp_0af8b27f{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_04_x: Uint256, __warp_usrid_05_y: Uint256, __warp_usrid_06_z: Uint256) -> (
    __warp_usrid_07_: Uint256
) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_06_z);

    warp_external_input_check_int256(__warp_usrid_05_y);

    warp_external_input_check_int256(__warp_usrid_04_x);

    let (__warp_se_1) = FullMathTest.s1_mulDivRoundingUp_0af8b27f(
        __warp_usrid_04_x, __warp_usrid_05_y, __warp_usrid_06_z
    );

    return (__warp_se_1,);
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","mulDiv(uint256,uint256,uint256)","mulDivRoundingUp(uint256,uint256,uint256)"]
