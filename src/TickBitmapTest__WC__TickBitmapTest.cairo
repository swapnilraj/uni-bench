%lang starknet

from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int24,
    warp_external_input_check_int16,
)
from warplib.maths.external_input_check_bool import warp_external_input_check_bool
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.eq import warp_eq
from warplib.maths.shr_signed import warp_shr_signed24
from warplib.maths.int_conversions import warp_int24_to_int16, warp_int24_to_int8, warp_uint256
from warplib.maths.mod import warp_mod
from warplib.maths.mod_signed import warp_mod_signed24
from warplib.maths.div_signed import warp_div_signed24
from warplib.maths.shl import warp_shl256
from warplib.maths.xor import warp_xor256
from warplib.maths.lt_signed import warp_lt_signed24
from warplib.maths.neq import warp_neq, warp_neq256
from warplib.maths.and_ import warp_and_
from warplib.maths.sub_signed import warp_sub_signed24
from warplib.maths.add_signed import warp_add_signed24
from warplib.maths.sub import warp_sub256, warp_sub
from warplib.maths.add import warp_add256, warp_add8
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.mul_signed import warp_mul_signed24
from warplib.maths.bitwise_not import warp_bitwise_not256
from warplib.maths.gt import warp_gt256
from warplib.maths.ge import warp_ge256
from warplib.maths.shr import warp_shr256

func WS0_READ_Uint256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) -> (val: Uint256) {
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0, high=read1),);
}

func WS_WRITE0{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt, value: Uint256
) -> (res: Uint256) {
    WARP_STORAGE.write(loc, value.low);
    WARP_STORAGE.write(loc + 1, value.high);
    return (value,);
}

@storage_var
func WARP_MAPPING0(name: felt, index: felt) -> (resLoc: felt) {
}
func WS0_INDEX_felt_to_Uint256{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}(name: felt, index: felt) -> (res: felt) {
    alloc_locals;
    let (existing) = WARP_MAPPING0.read(name, index);
    if (existing == 0) {
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING0.write(name, index, used);
        return (used,);
    } else {
        return (existing,);
    }
}

// Contract Def TickBitmapTest

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

namespace TickBitmapTest {
    // Dynamic variables - Arrays and Maps

    const __warp_usrid_00_bitmap = 1;

    // Static variables

    // @notice Computes the position in the mapping where the initialized bit for a tick lives
    // @param tick The tick for which to compute the position
    // @return wordPos The key in the mapping containing the word in which the bit is stored
    // @return bitPos The bit position in the word where the flag is stored
    func s1___warp_usrfn_00_position{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_03_tick: felt
    ) -> (__warp_usrid_04_wordPos: felt, __warp_usrid_05_bitPos: felt) {
        alloc_locals;

        let __warp_usrid_05_bitPos = 0;

        let __warp_usrid_04_wordPos = 0;

        let (__warp_se_3) = warp_shr_signed24(__warp_usrid_03_tick, 8);

        let (__warp_se_4) = warp_int24_to_int16(__warp_se_3);

        let __warp_usrid_04_wordPos = __warp_se_4;

        let (__warp_se_5) = warp_mod(__warp_usrid_03_tick, 256);

        let (__warp_se_6) = warp_int24_to_int8(__warp_se_5);

        let __warp_usrid_05_bitPos = __warp_se_6;

        let __warp_usrid_04_wordPos = __warp_usrid_04_wordPos;

        let __warp_usrid_05_bitPos = __warp_usrid_05_bitPos;

        return (__warp_usrid_04_wordPos, __warp_usrid_05_bitPos);
    }

    // @notice Flips the initialized state for a given tick from false to true, or vice versa
    // @param self The mapping in which to flip the tick
    // @param tick The tick to flip
    // @param tickSpacing The spacing between usable ticks
    func s1___warp_usrfn_01_flipTick{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_06_self: felt, __warp_usrid_07_tick: felt, __warp_usrid_08_tickSpacing: felt
    ) -> () {
        alloc_locals;

        let (__warp_se_7) = warp_mod_signed24(__warp_usrid_07_tick, __warp_usrid_08_tickSpacing);

        let (__warp_se_8) = warp_eq(__warp_se_7, 0);

        assert __warp_se_8 = 1;

        let (__warp_se_9) = warp_div_signed24(__warp_usrid_07_tick, __warp_usrid_08_tickSpacing);

        let (__warp_usrid_09_wordPos, __warp_usrid_10_bitPos) = s1___warp_usrfn_00_position(
            __warp_se_9
        );

        let (__warp_usrid_11_mask) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_10_bitPos);

        let __warp_cs_0 = __warp_usrid_09_wordPos;

        let (__warp_se_10) = WS0_INDEX_felt_to_Uint256(__warp_usrid_06_self, __warp_cs_0);

        let (__warp_se_11) = WS0_INDEX_felt_to_Uint256(__warp_usrid_06_self, __warp_cs_0);

        let (__warp_se_12) = WS0_READ_Uint256(__warp_se_11);

        let (__warp_se_13) = warp_xor256(__warp_se_12, __warp_usrid_11_mask);

        WS_WRITE0(__warp_se_10, __warp_se_13);

        return ();
    }

    // @notice Returns the next initialized tick contained in the same word (or adjacent word) as the tick that is either
    // to the left (less than or equal to) or right (greater than) of the given tick
    // @param self The mapping in which to compute the next initialized tick
    // @param tick The starting tick
    // @param tickSpacing The spacing between usable ticks
    // @param lte Whether to search for the next initialized tick to the left (less than or equal to the starting tick)
    // @return next The next initialized or uninitialized tick up to 256 ticks away from the current tick
    // @return initialized Whether the next tick is initialized, as the function only searches within up to 256 ticks
    func s1___warp_usrfn_02_nextInitializedTickWithinOneWord{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_12_self: felt,
        __warp_usrid_13_tick: felt,
        __warp_usrid_14_tickSpacing: felt,
        __warp_usrid_15_lte: felt,
    ) -> (__warp_usrid_16_next: felt, __warp_usrid_17_initialized: felt) {
        alloc_locals;

        let __warp_usrid_16_next = 0;

        let __warp_usrid_17_initialized = 0;

        let (__warp_usrid_18_compressed) = warp_div_signed24(
            __warp_usrid_13_tick, __warp_usrid_14_tickSpacing
        );

        let (__warp_se_14) = warp_lt_signed24(__warp_usrid_13_tick, 0);

        let (__warp_se_15) = warp_mod_signed24(__warp_usrid_13_tick, __warp_usrid_14_tickSpacing);

        let (__warp_se_16) = warp_neq(__warp_se_15, 0);

        let (__warp_se_17) = warp_and_(__warp_se_14, __warp_se_16);

        if (__warp_se_17 != 0) {
            let (__warp_se_18) = warp_sub_signed24(__warp_usrid_18_compressed, 1);

            let __warp_se_19 = __warp_se_18;

            let __warp_usrid_18_compressed = __warp_se_19;

            warp_add_signed24(__warp_se_19, 1);

            let (
                __warp_usrid_16_next, __warp_usrid_17_initialized
            ) = s1___warp_usrfn_02_nextInitializedTickWithinOneWord_if_part1(
                __warp_usrid_15_lte,
                __warp_usrid_18_compressed,
                __warp_usrid_12_self,
                __warp_usrid_17_initialized,
                __warp_usrid_16_next,
                __warp_usrid_14_tickSpacing,
            );

            return (__warp_usrid_16_next, __warp_usrid_17_initialized);
        } else {
            let (
                __warp_usrid_16_next, __warp_usrid_17_initialized
            ) = s1___warp_usrfn_02_nextInitializedTickWithinOneWord_if_part1(
                __warp_usrid_15_lte,
                __warp_usrid_18_compressed,
                __warp_usrid_12_self,
                __warp_usrid_17_initialized,
                __warp_usrid_16_next,
                __warp_usrid_14_tickSpacing,
            );

            return (__warp_usrid_16_next, __warp_usrid_17_initialized);
        }
    }

    func s1___warp_usrfn_02_nextInitializedTickWithinOneWord_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_15_lte: felt,
        __warp_usrid_18_compressed: felt,
        __warp_usrid_12_self: felt,
        __warp_usrid_17_initialized: felt,
        __warp_usrid_16_next: felt,
        __warp_usrid_14_tickSpacing: felt,
    ) -> (__warp_usrid_16_next: felt, __warp_usrid_17_initialized: felt) {
        alloc_locals;

        if (__warp_usrid_15_lte != 0) {
            let (__warp_usrid_19_wordPos, __warp_usrid_20_bitPos) = s1___warp_usrfn_00_position(
                __warp_usrid_18_compressed
            );

            let (__warp_se_20) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_20_bitPos);

            let (__warp_se_21) = warp_sub256(__warp_se_20, Uint256(low=1, high=0));

            let (__warp_se_22) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_20_bitPos);

            let (__warp_usrid_21_mask) = warp_add256(__warp_se_21, __warp_se_22);

            let (__warp_se_23) = WS0_INDEX_felt_to_Uint256(
                __warp_usrid_12_self, __warp_usrid_19_wordPos
            );

            let (__warp_se_24) = WS0_READ_Uint256(__warp_se_23);

            let (__warp_usrid_22_masked) = warp_bitwise_and256(__warp_se_24, __warp_usrid_21_mask);

            let (__warp_se_25) = warp_neq256(__warp_usrid_22_masked, Uint256(low=0, high=0));

            let __warp_usrid_17_initialized = __warp_se_25;

            if (__warp_usrid_17_initialized != 0) {
                let (__warp_se_26) = s2___warp_usrfn_00_mostSignificantBit(__warp_usrid_22_masked);

                let (__warp_se_27) = warp_sub_signed24(__warp_usrid_20_bitPos, __warp_se_26);

                let (__warp_se_28) = warp_sub_signed24(__warp_usrid_18_compressed, __warp_se_27);

                let (__warp_se_29) = warp_mul_signed24(__warp_se_28, __warp_usrid_14_tickSpacing);

                let __warp_usrid_16_next = __warp_se_29;

                let (
                    __warp_usrid_16_next, __warp_usrid_17_initialized
                ) = s1___warp_usrfn_02_nextInitializedTickWithinOneWord_if_part1_if_part2(
                    __warp_usrid_16_next, __warp_usrid_17_initialized
                );

                return (__warp_usrid_16_next, __warp_usrid_17_initialized);
            } else {
                let (__warp_se_30) = warp_sub_signed24(
                    __warp_usrid_18_compressed, __warp_usrid_20_bitPos
                );

                let (__warp_se_31) = warp_mul_signed24(__warp_se_30, __warp_usrid_14_tickSpacing);

                let __warp_usrid_16_next = __warp_se_31;

                let (
                    __warp_usrid_16_next, __warp_usrid_17_initialized
                ) = s1___warp_usrfn_02_nextInitializedTickWithinOneWord_if_part1_if_part2(
                    __warp_usrid_16_next, __warp_usrid_17_initialized
                );

                return (__warp_usrid_16_next, __warp_usrid_17_initialized);
            }
        } else {
            let (__warp_se_32) = warp_add_signed24(__warp_usrid_18_compressed, 1);

            let (__warp_usrid_23_wordPos, __warp_usrid_24_bitPos) = s1___warp_usrfn_00_position(
                __warp_se_32
            );

            let (__warp_se_33) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_24_bitPos);

            let (__warp_se_34) = warp_sub256(__warp_se_33, Uint256(low=1, high=0));

            let (__warp_usrid_25_mask) = warp_bitwise_not256(__warp_se_34);

            let (__warp_se_35) = WS0_INDEX_felt_to_Uint256(
                __warp_usrid_12_self, __warp_usrid_23_wordPos
            );

            let (__warp_se_36) = WS0_READ_Uint256(__warp_se_35);

            let (__warp_usrid_26_masked) = warp_bitwise_and256(__warp_se_36, __warp_usrid_25_mask);

            let (__warp_se_37) = warp_neq256(__warp_usrid_26_masked, Uint256(low=0, high=0));

            let __warp_usrid_17_initialized = __warp_se_37;

            if (__warp_usrid_17_initialized != 0) {
                let (__warp_se_38) = warp_add_signed24(__warp_usrid_18_compressed, 1);

                let (__warp_se_39) = s2___warp_usrfn_01_leastSignificantBit(__warp_usrid_26_masked);

                let (__warp_se_40) = warp_sub_signed24(__warp_se_39, __warp_usrid_24_bitPos);

                let (__warp_se_41) = warp_add_signed24(__warp_se_38, __warp_se_40);

                let (__warp_se_42) = warp_mul_signed24(__warp_se_41, __warp_usrid_14_tickSpacing);

                let __warp_usrid_16_next = __warp_se_42;

                let (
                    __warp_usrid_16_next, __warp_usrid_17_initialized
                ) = s1___warp_usrfn_02_nextInitializedTickWithinOneWord_if_part1_if_part3(
                    __warp_usrid_16_next, __warp_usrid_17_initialized
                );

                return (__warp_usrid_16_next, __warp_usrid_17_initialized);
            } else {
                let (__warp_se_43) = warp_add_signed24(__warp_usrid_18_compressed, 1);

                let (__warp_se_44) = warp_sub_signed24(255, __warp_usrid_24_bitPos);

                let (__warp_se_45) = warp_add_signed24(__warp_se_43, __warp_se_44);

                let (__warp_se_46) = warp_mul_signed24(__warp_se_45, __warp_usrid_14_tickSpacing);

                let __warp_usrid_16_next = __warp_se_46;

                let (
                    __warp_usrid_16_next, __warp_usrid_17_initialized
                ) = s1___warp_usrfn_02_nextInitializedTickWithinOneWord_if_part1_if_part3(
                    __warp_usrid_16_next, __warp_usrid_17_initialized
                );

                return (__warp_usrid_16_next, __warp_usrid_17_initialized);
            }
        }
    }

    func s1___warp_usrfn_02_nextInitializedTickWithinOneWord_if_part1_if_part3(
        __warp_usrid_16_next: felt, __warp_usrid_17_initialized: felt
    ) -> (__warp_usrid_16_next: felt, __warp_usrid_17_initialized: felt) {
        alloc_locals;

        let __warp_usrid_16_next = __warp_usrid_16_next;

        let __warp_usrid_17_initialized = __warp_usrid_17_initialized;

        return (__warp_usrid_16_next, __warp_usrid_17_initialized);
    }

    func s1___warp_usrfn_02_nextInitializedTickWithinOneWord_if_part1_if_part2(
        __warp_usrid_16_next: felt, __warp_usrid_17_initialized: felt
    ) -> (__warp_usrid_16_next: felt, __warp_usrid_17_initialized: felt) {
        alloc_locals;

        let __warp_usrid_16_next = __warp_usrid_16_next;

        let __warp_usrid_17_initialized = __warp_usrid_17_initialized;

        return (__warp_usrid_16_next, __warp_usrid_17_initialized);
    }

    // @notice Returns the index of the most significant bit of the number,
    //     where the least significant bit is at index 0 and the most significant bit is at index 255
    // @dev The function satisfies the property:
    //     x >= 2**mostSignificantBit(x) and x < 2**(mostSignificantBit(x)+1)
    // @param x the value for which to compute the most significant bit, must be greater than 0
    // @return r the index of the most significant bit
    func s2___warp_usrfn_00_mostSignificantBit{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_02_x: Uint256
    ) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let __warp_usrid_03_r = 0;

        let (__warp_se_47) = warp_gt256(__warp_usrid_02_x, Uint256(low=0, high=0));

        assert __warp_se_47 = 1;

        let (__warp_se_48) = warp_ge256(__warp_usrid_02_x, Uint256(low=0, high=1));

        if (__warp_se_48 != 0) {
            let (__warp_se_49) = warp_shr256(__warp_usrid_02_x, 128);

            let __warp_usrid_02_x = __warp_se_49;

            let (__warp_se_50) = warp_add8(__warp_usrid_03_r, 128);

            let __warp_usrid_03_r = __warp_se_50;

            let (__warp_se_51) = s2___warp_usrfn_00_mostSignificantBit_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_51,);
        } else {
            let (__warp_se_52) = s2___warp_usrfn_00_mostSignificantBit_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_52,);
        }
    }

    func s2___warp_usrfn_00_mostSignificantBit_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_53) = warp_ge256(
            __warp_usrid_02_x, Uint256(low=18446744073709551616, high=0)
        );

        if (__warp_se_53 != 0) {
            let (__warp_se_54) = warp_shr256(__warp_usrid_02_x, 64);

            let __warp_usrid_02_x = __warp_se_54;

            let (__warp_se_55) = warp_add8(__warp_usrid_03_r, 64);

            let __warp_usrid_03_r = __warp_se_55;

            let (__warp_se_56) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_56,);
        } else {
            let (__warp_se_57) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_57,);
        }
    }

    func s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_58) = warp_ge256(__warp_usrid_02_x, Uint256(low=4294967296, high=0));

        if (__warp_se_58 != 0) {
            let (__warp_se_59) = warp_shr256(__warp_usrid_02_x, 32);

            let __warp_usrid_02_x = __warp_se_59;

            let (__warp_se_60) = warp_add8(__warp_usrid_03_r, 32);

            let __warp_usrid_03_r = __warp_se_60;

            let (__warp_se_61) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_61,);
        } else {
            let (__warp_se_62) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_62,);
        }
    }

    func s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_63) = warp_ge256(__warp_usrid_02_x, Uint256(low=65536, high=0));

        if (__warp_se_63 != 0) {
            let (__warp_se_64) = warp_shr256(__warp_usrid_02_x, 16);

            let __warp_usrid_02_x = __warp_se_64;

            let (__warp_se_65) = warp_add8(__warp_usrid_03_r, 16);

            let __warp_usrid_03_r = __warp_se_65;

            let (
                __warp_se_66
            ) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_66,);
        } else {
            let (
                __warp_se_67
            ) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_67,);
        }
    }

    func s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_68) = warp_ge256(__warp_usrid_02_x, Uint256(low=256, high=0));

        if (__warp_se_68 != 0) {
            let (__warp_se_69) = warp_shr256(__warp_usrid_02_x, 8);

            let __warp_usrid_02_x = __warp_se_69;

            let (__warp_se_70) = warp_add8(__warp_usrid_03_r, 8);

            let __warp_usrid_03_r = __warp_se_70;

            let (
                __warp_se_71
            ) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_71,);
        } else {
            let (
                __warp_se_72
            ) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_72,);
        }
    }

    func s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_73) = warp_ge256(__warp_usrid_02_x, Uint256(low=16, high=0));

        if (__warp_se_73 != 0) {
            let (__warp_se_74) = warp_shr256(__warp_usrid_02_x, 4);

            let __warp_usrid_02_x = __warp_se_74;

            let (__warp_se_75) = warp_add8(__warp_usrid_03_r, 4);

            let __warp_usrid_03_r = __warp_se_75;

            let (
                __warp_se_76
            ) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_76,);
        } else {
            let (
                __warp_se_77
            ) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_77,);
        }
    }

    func s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_78) = warp_ge256(__warp_usrid_02_x, Uint256(low=4, high=0));

        if (__warp_se_78 != 0) {
            let (__warp_se_79) = warp_shr256(__warp_usrid_02_x, 2);

            let __warp_usrid_02_x = __warp_se_79;

            let (__warp_se_80) = warp_add8(__warp_usrid_03_r, 2);

            let __warp_usrid_03_r = __warp_se_80;

            let (
                __warp_se_81
            ) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_81,);
        } else {
            let (
                __warp_se_82
            ) = s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_82,);
        }
    }

    func s2___warp_usrfn_00_mostSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_83) = warp_ge256(__warp_usrid_02_x, Uint256(low=2, high=0));

        if (__warp_se_83 != 0) {
            let (__warp_se_84) = warp_add8(__warp_usrid_03_r, 1);

            let __warp_usrid_03_r = __warp_se_84;

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
    func s2___warp_usrfn_01_leastSignificantBit{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let __warp_usrid_05_r = 0;

        let (__warp_se_85) = warp_gt256(__warp_usrid_04_x, Uint256(low=0, high=0));

        assert __warp_se_85 = 1;

        let __warp_usrid_05_r = 255;

        let (__warp_se_86) = warp_uint256(340282366920938463463374607431768211455);

        let (__warp_se_87) = warp_bitwise_and256(__warp_usrid_04_x, __warp_se_86);

        let (__warp_se_88) = warp_gt256(__warp_se_87, Uint256(low=0, high=0));

        if (__warp_se_88 != 0) {
            let (__warp_se_89) = warp_sub(__warp_usrid_05_r, 128);

            let __warp_usrid_05_r = __warp_se_89;

            let (__warp_se_90) = s2___warp_usrfn_01_leastSignificantBit_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_90,);
        } else {
            let (__warp_se_91) = warp_shr256(__warp_usrid_04_x, 128);

            let __warp_usrid_04_x = __warp_se_91;

            let (__warp_se_92) = s2___warp_usrfn_01_leastSignificantBit_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_92,);
        }
    }

    func s2___warp_usrfn_01_leastSignificantBit_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_93) = warp_uint256(18446744073709551615);

        let (__warp_se_94) = warp_bitwise_and256(__warp_usrid_04_x, __warp_se_93);

        let (__warp_se_95) = warp_gt256(__warp_se_94, Uint256(low=0, high=0));

        if (__warp_se_95 != 0) {
            let (__warp_se_96) = warp_sub(__warp_usrid_05_r, 64);

            let __warp_usrid_05_r = __warp_se_96;

            let (__warp_se_97) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_97,);
        } else {
            let (__warp_se_98) = warp_shr256(__warp_usrid_04_x, 64);

            let __warp_usrid_04_x = __warp_se_98;

            let (__warp_se_99) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_99,);
        }
    }

    func s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_100) = warp_uint256(4294967295);

        let (__warp_se_101) = warp_bitwise_and256(__warp_usrid_04_x, __warp_se_100);

        let (__warp_se_102) = warp_gt256(__warp_se_101, Uint256(low=0, high=0));

        if (__warp_se_102 != 0) {
            let (__warp_se_103) = warp_sub(__warp_usrid_05_r, 32);

            let __warp_usrid_05_r = __warp_se_103;

            let (__warp_se_104) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_104,);
        } else {
            let (__warp_se_105) = warp_shr256(__warp_usrid_04_x, 32);

            let __warp_usrid_04_x = __warp_se_105;

            let (__warp_se_106) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_106,);
        }
    }

    func s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_107) = warp_uint256(65535);

        let (__warp_se_108) = warp_bitwise_and256(__warp_usrid_04_x, __warp_se_107);

        let (__warp_se_109) = warp_gt256(__warp_se_108, Uint256(low=0, high=0));

        if (__warp_se_109 != 0) {
            let (__warp_se_110) = warp_sub(__warp_usrid_05_r, 16);

            let __warp_usrid_05_r = __warp_se_110;

            let (
                __warp_se_111
            ) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_111,);
        } else {
            let (__warp_se_112) = warp_shr256(__warp_usrid_04_x, 16);

            let __warp_usrid_04_x = __warp_se_112;

            let (
                __warp_se_113
            ) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_113,);
        }
    }

    func s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_114) = warp_uint256(255);

        let (__warp_se_115) = warp_bitwise_and256(__warp_usrid_04_x, __warp_se_114);

        let (__warp_se_116) = warp_gt256(__warp_se_115, Uint256(low=0, high=0));

        if (__warp_se_116 != 0) {
            let (__warp_se_117) = warp_sub(__warp_usrid_05_r, 8);

            let __warp_usrid_05_r = __warp_se_117;

            let (
                __warp_se_118
            ) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_118,);
        } else {
            let (__warp_se_119) = warp_shr256(__warp_usrid_04_x, 8);

            let __warp_usrid_04_x = __warp_se_119;

            let (
                __warp_se_120
            ) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_120,);
        }
    }

    func s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_121) = warp_bitwise_and256(__warp_usrid_04_x, Uint256(low=15, high=0));

        let (__warp_se_122) = warp_gt256(__warp_se_121, Uint256(low=0, high=0));

        if (__warp_se_122 != 0) {
            let (__warp_se_123) = warp_sub(__warp_usrid_05_r, 4);

            let __warp_usrid_05_r = __warp_se_123;

            let (
                __warp_se_124
            ) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_124,);
        } else {
            let (__warp_se_125) = warp_shr256(__warp_usrid_04_x, 4);

            let __warp_usrid_04_x = __warp_se_125;

            let (
                __warp_se_126
            ) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_126,);
        }
    }

    func s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_127) = warp_bitwise_and256(__warp_usrid_04_x, Uint256(low=3, high=0));

        let (__warp_se_128) = warp_gt256(__warp_se_127, Uint256(low=0, high=0));

        if (__warp_se_128 != 0) {
            let (__warp_se_129) = warp_sub(__warp_usrid_05_r, 2);

            let __warp_usrid_05_r = __warp_se_129;

            let (
                __warp_se_130
            ) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_130,);
        } else {
            let (__warp_se_131) = warp_shr256(__warp_usrid_04_x, 2);

            let __warp_usrid_04_x = __warp_se_131;

            let (
                __warp_se_132
            ) = s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_x, __warp_usrid_05_r
            );

            return (__warp_se_132,);
        }
    }

    func s2___warp_usrfn_01_leastSignificantBit_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_04_x: Uint256, __warp_usrid_05_r: felt) -> (__warp_usrid_05_r: felt) {
        alloc_locals;

        let (__warp_se_133) = warp_bitwise_and256(__warp_usrid_04_x, Uint256(low=1, high=0));

        let (__warp_se_134) = warp_gt256(__warp_se_133, Uint256(low=0, high=0));

        if (__warp_se_134 != 0) {
            let (__warp_se_135) = warp_sub(__warp_usrid_05_r, 1);

            let __warp_usrid_05_r = __warp_se_135;

            return (__warp_usrid_05_r,);
        } else {
            return (__warp_usrid_05_r,);
        }
    }
}

@external
func flipTick_8815912f{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_01_tick: felt) -> () {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_01_tick);

    TickBitmapTest.s1___warp_usrfn_01_flipTick(
        TickBitmapTest.__warp_usrid_00_bitmap, __warp_usrid_01_tick, 1
    );

    return ();
}

@view
func nextInitializedTickWithinOneWord_3e7ba228{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_02_tick: felt, __warp_usrid_03_lte: felt) -> (
    __warp_usrid_04_next: felt, __warp_usrid_05_initialized: felt
) {
    alloc_locals;

    warp_external_input_check_bool(__warp_usrid_03_lte);

    warp_external_input_check_int24(__warp_usrid_02_tick);

    let (
        __warp_usrid_04_next, __warp_usrid_05_initialized
    ) = TickBitmapTest.s1___warp_usrfn_02_nextInitializedTickWithinOneWord(
        TickBitmapTest.__warp_usrid_00_bitmap, __warp_usrid_02_tick, 1, __warp_usrid_03_lte
    );

    return (__warp_usrid_04_next, __warp_usrid_05_initialized);
}

@view
func isInitialized_2bdc2fd3{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_06_tick: felt) -> (__warp_usrid_07_: felt) {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_06_tick);

    let (
        __warp_usrid_08_next, __warp_usrid_09_initialized
    ) = TickBitmapTest.s1___warp_usrfn_02_nextInitializedTickWithinOneWord(
        TickBitmapTest.__warp_usrid_00_bitmap, __warp_usrid_06_tick, 1, 1
    );

    let (__warp_se_0) = warp_eq(__warp_usrid_08_next, __warp_usrid_06_tick);

    if (__warp_se_0 != 0) {
        return (__warp_usrid_09_initialized,);
    } else {
        return (0,);
    }
}

@view
func bitmap_3ffc81ee{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_10__i0: felt
) -> (__warp_usrid_11_: Uint256) {
    alloc_locals;

    warp_external_input_check_int16(__warp_usrid_10__i0);

    let (__warp_se_1) = WS0_INDEX_felt_to_Uint256(
        TickBitmapTest.__warp_usrid_00_bitmap, __warp_usrid_10__i0
    );

    let (__warp_se_2) = WS0_READ_Uint256(__warp_se_1);

    return (__warp_se_2,);
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;
    WARP_USED_STORAGE.write(1);
    WARP_NAMEGEN.write(1);

    return ();
}

// Original soldity abi: ["constructor()","flipTick(int24)","nextInitializedTickWithinOneWord(int24,bool)","isInitialized(int24)","bitmap(int16)"]
