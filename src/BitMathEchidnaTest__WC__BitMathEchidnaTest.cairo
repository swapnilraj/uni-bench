%lang starknet

from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.exp import warp_exp256
from warplib.maths.ge import warp_ge256
from warplib.maths.eq import warp_eq, warp_eq256
from warplib.maths.add import warp_add8
from warplib.maths.lt import warp_lt256
from warplib.maths.or import warp_or
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.neq import warp_neq256
from warplib.maths.sub import warp_sub256, warp_sub
from warplib.maths.gt import warp_gt256
from warplib.maths.shr import warp_shr256
from warplib.maths.int_conversions import warp_uint256

// Contract Def BitMathEchidnaTest

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

namespace BitMathEchidnaTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    // @notice Returns the index of the most significant bit of the number,
    //     where the least significant bit is at index 0 and the most significant bit is at index 255
    // @dev The function satisfies the property:
    //     x >= 2**mostSignificantBit(x) and x < 2**(mostSignificantBit(x)+1)
    // @param x the value for which to compute the most significant bit, must be greater than 0
    // @return r the index of the most significant bit
    func s1___warp_usrfn_00_mostSignificantBit{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_02_x: Uint256
    ) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let __warp_usrid_03_r = 0;

        let (__warp_se_14) = warp_gt256(__warp_usrid_02_x, Uint256(low=0, high=0));

        assert __warp_se_14 = 1;

        let (__warp_se_15) = warp_ge256(__warp_usrid_02_x, Uint256(low=0, high=1));

        if (__warp_se_15 != 0) {
            let (__warp_se_16) = warp_shr256(__warp_usrid_02_x, 128);

            let __warp_usrid_02_x = __warp_se_16;

            let (__warp_se_17) = warp_add8(__warp_usrid_03_r, 128);

            let __warp_usrid_03_r = __warp_se_17;

            let (__warp_se_18) = s1___warp_usrfn_00_mostSignificantBit_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_18,);
        } else {
            let (__warp_se_19) = s1___warp_usrfn_00_mostSignificantBit_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_19,);
        }
    }

    func s1___warp_usrfn_00_mostSignificantBit_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_20) = warp_ge256(
            __warp_usrid_02_x, Uint256(low=18446744073709551616, high=0)
        );

        if (__warp_se_20 != 0) {
            let (__warp_se_21) = warp_shr256(__warp_usrid_02_x, 64);

            let __warp_usrid_02_x = __warp_se_21;

            let (__warp_se_22) = warp_add8(__warp_usrid_03_r, 64);

            let __warp_usrid_03_r = __warp_se_22;

            let (__warp_se_23) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_23,);
        } else {
            let (__warp_se_24) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_24,);
        }
    }

    func s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_25) = warp_ge256(__warp_usrid_02_x, Uint256(low=4294967296, high=0));

        if (__warp_se_25 != 0) {
            let (__warp_se_26) = warp_shr256(__warp_usrid_02_x, 32);

            let __warp_usrid_02_x = __warp_se_26;

            let (__warp_se_27) = warp_add8(__warp_usrid_03_r, 32);

            let __warp_usrid_03_r = __warp_se_27;

            let (__warp_se_28) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_28,);
        } else {
            let (__warp_se_29) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_29,);
        }
    }

    func s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_30) = warp_ge256(__warp_usrid_02_x, Uint256(low=65536, high=0));

        if (__warp_se_30 != 0) {
            let (__warp_se_31) = warp_shr256(__warp_usrid_02_x, 16);

            let __warp_usrid_02_x = __warp_se_31;

            let (__warp_se_32) = warp_add8(__warp_usrid_03_r, 16);

            let __warp_usrid_03_r = __warp_se_32;

            let (
                __warp_se_33
            ) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_33,);
        } else {
            let (
                __warp_se_34
            ) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_34,);
        }
    }

    func s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_35) = warp_ge256(__warp_usrid_02_x, Uint256(low=256, high=0));

        if (__warp_se_35 != 0) {
            let (__warp_se_36) = warp_shr256(__warp_usrid_02_x, 8);

            let __warp_usrid_02_x = __warp_se_36;

            let (__warp_se_37) = warp_add8(__warp_usrid_03_r, 8);

            let __warp_usrid_03_r = __warp_se_37;

            let (
                __warp_se_38
            ) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_38,);
        } else {
            let (
                __warp_se_39
            ) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_39,);
        }
    }

    func s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_40) = warp_ge256(__warp_usrid_02_x, Uint256(low=16, high=0));

        if (__warp_se_40 != 0) {
            let (__warp_se_41) = warp_shr256(__warp_usrid_02_x, 4);

            let __warp_usrid_02_x = __warp_se_41;

            let (__warp_se_42) = warp_add8(__warp_usrid_03_r, 4);

            let __warp_usrid_03_r = __warp_se_42;

            let (
                __warp_se_43
            ) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_43,);
        } else {
            let (
                __warp_se_44
            ) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_44,);
        }
    }

    func s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_45) = warp_ge256(__warp_usrid_02_x, Uint256(low=4, high=0));

        if (__warp_se_45 != 0) {
            let (__warp_se_46) = warp_shr256(__warp_usrid_02_x, 2);

            let __warp_usrid_02_x = __warp_se_46;

            let (__warp_se_47) = warp_add8(__warp_usrid_03_r, 2);

            let __warp_usrid_03_r = __warp_se_47;

            let (
                __warp_se_48
            ) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_48,);
        } else {
            let (
                __warp_se_49
            ) = s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_49,);
        }
    }

    func s1___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_50) = warp_ge256(__warp_usrid_02_x, Uint256(low=2, high=0));

        if (__warp_se_50 != 0) {
            let (__warp_se_51) = warp_add8(__warp_usrid_03_r, 1);

            let __warp_usrid_03_r = __warp_se_51;

            return (__warp_usrid_03_r,);
        } else {
            return (__warp_usrid_03_r,);
        }
    }

    // @notice Returns the index of the least significant bit of the number,
    //     where the least significant bit is at index 0 and the most significant bit is at index 255
    // @dev The function satisfies the property:
    //     (x & 2**leastSignificantBit(x)) != 0 and (x & (2**(leastSignificantBit(x)) - 1)) == 0)
    // @param x the value for which to compute the least significant bit, must be greater than 0
    // @return r the index of the least significant bit
    func s1___warp_usrfn_01_leastSignificantBit{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let __warp_usrid_05_r = 0;

        let (__warp_se_52) = warp_gt256(__warp_usrid_04_x, Uint256(low=0, high=0));

        assert __warp_se_52 = 1;

        let __warp_usrid_05_r = 255;

        let (__warp_se_53) = warp_uint256(340282366920938463463374607431768211455);

        let (__warp_se_54) = warp_bitwise_and256(__warp_usrid_04_x, __warp_se_53);

        let (__warp_se_55) = warp_gt256(__warp_se_54, Uint256(low=0, high=0));

        if (__warp_se_55 != 0) {
            let (__warp_se_56) = warp_sub(__warp_usrid_05_r, 128);

            let __warp_usrid_05_r = __warp_se_56;

            let (__warp_se_57) = s1___warp_usrfn_01_leastSignificantBit_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_57,);
        } else {
            let (__warp_se_58) = warp_shr256(__warp_usrid_04_x, 128);

            let __warp_usrid_04_x = __warp_se_58;

            let (__warp_se_59) = s1___warp_usrfn_01_leastSignificantBit_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_59,);
        }
    }

    func s1___warp_usrfn_01_leastSignificantBit_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_60) = warp_uint256(18446744073709551615);

        let (__warp_se_61) = warp_bitwise_and256(__warp_usrid_04_x, __warp_se_60);

        let (__warp_se_62) = warp_gt256(__warp_se_61, Uint256(low=0, high=0));

        if (__warp_se_62 != 0) {
            let (__warp_se_63) = warp_sub(__warp_usrid_05_r, 64);

            let __warp_usrid_05_r = __warp_se_63;

            let (__warp_se_64) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_64,);
        } else {
            let (__warp_se_65) = warp_shr256(__warp_usrid_04_x, 64);

            let __warp_usrid_04_x = __warp_se_65;

            let (__warp_se_66) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_66,);
        }
    }

    func s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_67) = warp_uint256(4294967295);

        let (__warp_se_68) = warp_bitwise_and256(__warp_usrid_04_x, __warp_se_67);

        let (__warp_se_69) = warp_gt256(__warp_se_68, Uint256(low=0, high=0));

        if (__warp_se_69 != 0) {
            let (__warp_se_70) = warp_sub(__warp_usrid_05_r, 32);

            let __warp_usrid_05_r = __warp_se_70;

            let (__warp_se_71) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_71,);
        } else {
            let (__warp_se_72) = warp_shr256(__warp_usrid_04_x, 32);

            let __warp_usrid_04_x = __warp_se_72;

            let (__warp_se_73) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_73,);
        }
    }

    func s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_74) = warp_uint256(65535);

        let (__warp_se_75) = warp_bitwise_and256(__warp_usrid_04_x, __warp_se_74);

        let (__warp_se_76) = warp_gt256(__warp_se_75, Uint256(low=0, high=0));

        if (__warp_se_76 != 0) {
            let (__warp_se_77) = warp_sub(__warp_usrid_05_r, 16);

            let __warp_usrid_05_r = __warp_se_77;

            let (
                __warp_se_78
            ) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_78,);
        } else {
            let (__warp_se_79) = warp_shr256(__warp_usrid_04_x, 16);

            let __warp_usrid_04_x = __warp_se_79;

            let (
                __warp_se_80
            ) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_80,);
        }
    }

    func s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_81) = warp_uint256(255);

        let (__warp_se_82) = warp_bitwise_and256(__warp_usrid_04_x, __warp_se_81);

        let (__warp_se_83) = warp_gt256(__warp_se_82, Uint256(low=0, high=0));

        if (__warp_se_83 != 0) {
            let (__warp_se_84) = warp_sub(__warp_usrid_05_r, 8);

            let __warp_usrid_05_r = __warp_se_84;

            let (
                __warp_se_85
            ) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_85,);
        } else {
            let (__warp_se_86) = warp_shr256(__warp_usrid_04_x, 8);

            let __warp_usrid_04_x = __warp_se_86;

            let (
                __warp_se_87
            ) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_87,);
        }
    }

    func s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_88) = warp_bitwise_and256(__warp_usrid_04_x, Uint256(low=15, high=0));

        let (__warp_se_89) = warp_gt256(__warp_se_88, Uint256(low=0, high=0));

        if (__warp_se_89 != 0) {
            let (__warp_se_90) = warp_sub(__warp_usrid_05_r, 4);

            let __warp_usrid_05_r = __warp_se_90;

            let (
                __warp_se_91
            ) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_91,);
        } else {
            let (__warp_se_92) = warp_shr256(__warp_usrid_04_x, 4);

            let __warp_usrid_04_x = __warp_se_92;

            let (
                __warp_se_93
            ) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_93,);
        }
    }

    func s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_94) = warp_bitwise_and256(__warp_usrid_04_x, Uint256(low=3, high=0));

        let (__warp_se_95) = warp_gt256(__warp_se_94, Uint256(low=0, high=0));

        if (__warp_se_95 != 0) {
            let (__warp_se_96) = warp_sub(__warp_usrid_05_r, 2);

            let __warp_usrid_05_r = __warp_se_96;

            let (
                __warp_se_97
            ) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_97,);
        } else {
            let (__warp_se_98) = warp_shr256(__warp_usrid_04_x, 2);

            let __warp_usrid_04_x = __warp_se_98;

            let (
                __warp_se_99
            ) = s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_99,);
        }
    }

    func s1___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_100) = warp_bitwise_and256(__warp_usrid_04_x, Uint256(low=1, high=0));

        let (__warp_se_101) = warp_gt256(__warp_se_100, Uint256(low=0, high=0));

        if (__warp_se_101 != 0) {
            let (__warp_se_102) = warp_sub(__warp_usrid_05_r, 1);

            let __warp_usrid_05_r = __warp_se_102;

            return (__warp_usrid_05_r,);
        } else {
            return (__warp_usrid_05_r,);
        }
    }
}

@view
func mostSignificantBitInvariant_f94ac90e{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_00_input: Uint256) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_00_input);

    let (__warp_usrid_01_msb) = BitMathEchidnaTest.s1___warp_usrfn_00_mostSignificantBit(
        __warp_usrid_00_input
    );

    let (__warp_se_0) = warp_exp256(Uint256(low=2, high=0), __warp_usrid_01_msb);

    let (__warp_se_1) = warp_ge256(__warp_usrid_00_input, __warp_se_0);

    assert __warp_se_1 = 1;

    let (__warp_se_2) = warp_eq(__warp_usrid_01_msb, 255);

    let (__warp_se_3) = warp_add8(__warp_usrid_01_msb, 1);

    let (__warp_se_4) = warp_exp256(Uint256(low=2, high=0), __warp_se_3);

    let (__warp_se_5) = warp_lt256(__warp_usrid_00_input, __warp_se_4);

    let (__warp_se_6) = warp_or(__warp_se_2, __warp_se_5);

    assert __warp_se_6 = 1;

    return ();
}

@view
func leastSignificantBitInvariant_2d711e0c{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_02_input: Uint256) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_02_input);

    let (__warp_usrid_03_lsb) = BitMathEchidnaTest.s1___warp_usrfn_01_leastSignificantBit(
        __warp_usrid_02_input
    );

    let (__warp_se_7) = warp_exp256(Uint256(low=2, high=0), __warp_usrid_03_lsb);

    let (__warp_se_8) = warp_bitwise_and256(__warp_usrid_02_input, __warp_se_7);

    let (__warp_se_9) = warp_neq256(__warp_se_8, Uint256(low=0, high=0));

    assert __warp_se_9 = 1;

    let (__warp_se_10) = warp_exp256(Uint256(low=2, high=0), __warp_usrid_03_lsb);

    let (__warp_se_11) = warp_sub256(__warp_se_10, Uint256(low=1, high=0));

    let (__warp_se_12) = warp_bitwise_and256(__warp_usrid_02_input, __warp_se_11);

    let (__warp_se_13) = warp_eq256(__warp_se_12, Uint256(low=0, high=0));

    assert __warp_se_13 = 1;

    return ();
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","mostSignificantBitInvariant(uint256)","leastSignificantBitInvariant(uint256)"]
