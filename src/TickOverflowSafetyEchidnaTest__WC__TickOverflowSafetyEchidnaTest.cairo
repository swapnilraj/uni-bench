%lang starknet

from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int256,
    warp_external_input_check_int24,
    warp_external_input_check_int128,
)
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from warplib.maths.neq import warp_neq
from warplib.maths.lt_signed import warp_lt_signed24, warp_lt_signed128
from warplib.maths.add_signed import warp_add_signed24, warp_add_signed256
from warplib.maths.gt import warp_gt, warp_gt256
from warplib.block_methods import warp_block_timestamp
from warplib.maths.int_conversions import (
    warp_int256_to_int32,
    warp_int128_to_int256,
    warp_int256_to_int128,
)
from warplib.maths.sub_signed import warp_sub_signed24, warp_sub_signed56, warp_sub_signed256
from warplib.maths.add import warp_add256, warp_add128
from warplib.maths.gt_signed import warp_gt_signed24
from warplib.maths.eq import warp_eq, warp_eq256
from warplib.maths.ge_signed import warp_ge_signed256
from warplib.maths.div import warp_div, warp_div256
from warplib.maths.le import warp_le
from warplib.maths.le_signed import warp_le_signed24, warp_le_signed256
from warplib.maths.sub import warp_sub256, warp_sub
from warplib.maths.negate import warp_negate128
from warplib.maths.lt import warp_lt
from warplib.maths.ge import warp_ge

struct Info_39bc053d {
    __warp_usrid_00_liquidityGross: felt,
    __warp_usrid_01_liquidityNet: felt,
    __warp_usrid_02_feeGrowthOutside0X128: Uint256,
    __warp_usrid_03_feeGrowthOutside1X128: Uint256,
    __warp_usrid_04_tickCumulativeOutside: felt,
    __warp_usrid_05_secondsPerLiquidityOutsideX128: felt,
    __warp_usrid_06_secondsOutside: felt,
    __warp_usrid_07_initialized: felt,
}

func WS_STRUCT_Info_DELETE{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) {
    alloc_locals;
    WS1_DELETE(loc);
    WS2_DELETE(loc + 1);
    WS3_DELETE(loc + 2);
    WS3_DELETE(loc + 4);
    WS4_DELETE(loc + 6);
    WS5_DELETE(loc + 7);
    WS6_DELETE(loc + 8);
    WS7_DELETE(loc + 9);
    return ();
}

func WS1_DELETE{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(loc: felt) {
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS2_DELETE{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(loc: felt) {
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS3_DELETE{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(loc: felt) {
    WARP_STORAGE.write(loc, 0);
    WARP_STORAGE.write(loc + 1, 0);
    return ();
}

func WS4_DELETE{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(loc: felt) {
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS5_DELETE{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(loc: felt) {
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS6_DELETE{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(loc: felt) {
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS7_DELETE{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(loc: felt) {
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WSM1_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func WSM2_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(loc: felt) -> (memberLoc: felt) {
    return (loc + 4,);
}

func WSM3_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 7,);
}

func WSM4_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(loc: felt) -> (memberLoc: felt) {
    return (loc + 6,);
}

func WSM5_Info_39bc053d___warp_usrid_06_secondsOutside(loc: felt) -> (memberLoc: felt) {
    return (loc + 8,);
}

func WSM6_Info_39bc053d___warp_usrid_07_initialized(loc: felt) -> (memberLoc: felt) {
    return (loc + 9,);
}

func WSM7_Info_39bc053d___warp_usrid_01_liquidityNet(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WS0_READ_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) -> (val: felt) {
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func WS1_READ_Uint256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) -> (val: Uint256) {
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0, high=read1),);
}

func WS_WRITE0{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt, value: felt
) -> (res: felt) {
    WARP_STORAGE.write(loc, value);
    return (value,);
}

func WS_WRITE1{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt, value: Uint256
) -> (res: Uint256) {
    WARP_STORAGE.write(loc, value.low);
    WARP_STORAGE.write(loc + 1, value.high);
    return (value,);
}

@storage_var
func WARP_MAPPING0(name: felt, index: felt) -> (resLoc: felt) {
}
func WS0_INDEX_felt_to_Info_39bc053d{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}(name: felt, index: felt) -> (res: felt) {
    alloc_locals;
    let (existing) = WARP_MAPPING0.read(name, index);
    if (existing == 0) {
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 10);
        WARP_MAPPING0.write(name, index, used);
        return (used,);
    } else {
        return (existing,);
    }
}

// Contract Def TickOverflowSafetyEchidnaTest

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

namespace TickOverflowSafetyEchidnaTest {
    // Dynamic variables - Arrays and Maps

    const __warp_usrid_03_ticks = 1;

    // Static variables

    const __warp_usrid_02_MAX_LIQUIDITY = 0;

    const __warp_usrid_04_tick = 2;

    const __warp_usrid_05_totalLiquidity = 3;

    const __warp_usrid_06_feeGrowthGlobal0X128 = 5;

    const __warp_usrid_07_feeGrowthGlobal1X128 = 7;

    const __warp_usrid_08_totalGrowth0 = 9;

    const __warp_usrid_09_totalGrowth1 = 11;

    func __warp_while41{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_17_target: felt) -> (__warp_usrid_17_target: felt) {
        alloc_locals;

        let (__warp_se_0) = WS0_READ_felt(__warp_usrid_04_tick);

        let (__warp_se_1) = warp_neq(__warp_se_0, __warp_usrid_17_target);

        if (__warp_se_1 != 0) {
            let (__warp_se_2) = WS0_READ_felt(__warp_usrid_04_tick);

            let (__warp_se_3) = warp_lt_signed24(__warp_se_2, __warp_usrid_17_target);

            if (__warp_se_3 != 0) {
                let (__warp_se_4) = WS0_READ_felt(__warp_usrid_04_tick);

                let (__warp_se_5) = warp_add_signed24(__warp_se_4, 1);

                let (__warp_se_6) = WS0_INDEX_felt_to_Info_39bc053d(
                    __warp_usrid_03_ticks, __warp_se_5
                );

                let (__warp_se_7) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(__warp_se_6);

                let (__warp_se_8) = WS0_READ_felt(__warp_se_7);

                let (__warp_se_9) = warp_gt(__warp_se_8, 0);

                if (__warp_se_9 != 0) {
                    let (__warp_se_10) = WS0_READ_felt(__warp_usrid_04_tick);

                    let (__warp_se_11) = warp_add_signed24(__warp_se_10, 1);

                    let (__warp_se_12) = WS1_READ_Uint256(__warp_usrid_06_feeGrowthGlobal0X128);

                    let (__warp_se_13) = WS1_READ_Uint256(__warp_usrid_07_feeGrowthGlobal1X128);

                    let (__warp_se_14) = warp_block_timestamp();

                    let (__warp_se_15) = warp_int256_to_int32(__warp_se_14);

                    s1___warp_usrfn_12_cross(
                        __warp_usrid_03_ticks,
                        __warp_se_11,
                        __warp_se_12,
                        __warp_se_13,
                        0,
                        0,
                        __warp_se_15,
                    );

                    let (__warp_se_16) = __warp_while41_if_part3(__warp_usrid_17_target);

                    return (__warp_se_16,);
                } else {
                    let (__warp_se_17) = __warp_while41_if_part3(__warp_usrid_17_target);

                    return (__warp_se_17,);
                }
            } else {
                let (__warp_se_18) = WS0_READ_felt(__warp_usrid_04_tick);

                let (__warp_se_19) = WS0_INDEX_felt_to_Info_39bc053d(
                    __warp_usrid_03_ticks, __warp_se_18
                );

                let (__warp_se_20) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(
                    __warp_se_19
                );

                let (__warp_se_21) = WS0_READ_felt(__warp_se_20);

                let (__warp_se_22) = warp_gt(__warp_se_21, 0);

                if (__warp_se_22 != 0) {
                    let (__warp_se_23) = WS0_READ_felt(__warp_usrid_04_tick);

                    let (__warp_se_24) = WS1_READ_Uint256(__warp_usrid_06_feeGrowthGlobal0X128);

                    let (__warp_se_25) = WS1_READ_Uint256(__warp_usrid_07_feeGrowthGlobal1X128);

                    let (__warp_se_26) = warp_block_timestamp();

                    let (__warp_se_27) = warp_int256_to_int32(__warp_se_26);

                    s1___warp_usrfn_12_cross(
                        __warp_usrid_03_ticks,
                        __warp_se_23,
                        __warp_se_24,
                        __warp_se_25,
                        0,
                        0,
                        __warp_se_27,
                    );

                    let (__warp_se_28) = __warp_while41_if_part4(__warp_usrid_17_target);

                    return (__warp_se_28,);
                } else {
                    let (__warp_se_29) = __warp_while41_if_part4(__warp_usrid_17_target);

                    return (__warp_se_29,);
                }
            }
        } else {
            return (__warp_usrid_17_target,);
        }
    }

    func __warp_while41_if_part4{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_17_target: felt) -> (__warp_usrid_17_target: felt) {
        alloc_locals;

        let (__warp_se_30) = WS0_READ_felt(__warp_usrid_04_tick);

        let (__warp_se_31) = warp_sub_signed24(__warp_se_30, 1);

        let (__warp_se_32) = WS_WRITE0(__warp_usrid_04_tick, __warp_se_31);

        warp_add_signed24(__warp_se_32, 1);

        let (__warp_se_33) = __warp_while41_if_part2(__warp_usrid_17_target);

        return (__warp_se_33,);
    }

    func __warp_while41_if_part3{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_17_target: felt) -> (__warp_usrid_17_target: felt) {
        alloc_locals;

        let (__warp_se_34) = WS0_READ_felt(__warp_usrid_04_tick);

        let (__warp_se_35) = warp_add_signed24(__warp_se_34, 1);

        let (__warp_se_36) = WS_WRITE0(__warp_usrid_04_tick, __warp_se_35);

        warp_sub_signed24(__warp_se_36, 1);

        let (__warp_se_37) = __warp_while41_if_part2(__warp_usrid_17_target);

        return (__warp_se_37,);
    }

    func __warp_while41_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_17_target: felt) -> (__warp_usrid_17_target: felt) {
        alloc_locals;

        let (__warp_se_38) = __warp_while41_if_part1(__warp_usrid_17_target);

        return (__warp_se_38,);
    }

    func __warp_while41_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_17_target: felt) -> (__warp_usrid_17_target: felt) {
        alloc_locals;

        let (__warp_se_39) = __warp_while41(__warp_usrid_17_target);

        return (__warp_se_39,);
    }

    func setPosition_541bdfb1_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_16_flippedUpper: felt,
        __warp_usrid_14_liquidityDelta: felt,
        __warp_usrid_13_tickUpper: felt,
    ) -> () {
        alloc_locals;

        setPosition_541bdfb1_if_part1(
            __warp_usrid_16_flippedUpper, __warp_usrid_14_liquidityDelta, __warp_usrid_13_tickUpper
        );

        return ();
    }

    func setPosition_541bdfb1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_16_flippedUpper: felt,
        __warp_usrid_14_liquidityDelta: felt,
        __warp_usrid_13_tickUpper: felt,
    ) -> () {
        alloc_locals;

        if (__warp_usrid_16_flippedUpper != 0) {
            let (__warp_se_80) = warp_lt_signed128(__warp_usrid_14_liquidityDelta, 0);

            if (__warp_se_80 != 0) {
                let (__warp_se_81) = WS0_INDEX_felt_to_Info_39bc053d(
                    __warp_usrid_03_ticks, __warp_usrid_13_tickUpper
                );

                let (__warp_se_82) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(
                    __warp_se_81
                );

                let (__warp_se_83) = WS0_READ_felt(__warp_se_82);

                let (__warp_se_84) = warp_eq(__warp_se_83, 0);

                assert __warp_se_84 = 1;

                s1___warp_usrfn_11_clear(__warp_usrid_03_ticks, __warp_usrid_13_tickUpper);

                setPosition_541bdfb1_if_part1_if_part2(__warp_usrid_14_liquidityDelta);

                return ();
            } else {
                let (__warp_se_85) = WS0_INDEX_felt_to_Info_39bc053d(
                    __warp_usrid_03_ticks, __warp_usrid_13_tickUpper
                );

                let (__warp_se_86) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(
                    __warp_se_85
                );

                let (__warp_se_87) = WS0_READ_felt(__warp_se_86);

                let (__warp_se_88) = warp_gt(__warp_se_87, 0);

                assert __warp_se_88 = 1;

                setPosition_541bdfb1_if_part1_if_part2(__warp_usrid_14_liquidityDelta);

                return ();
            }
        } else {
            setPosition_541bdfb1_if_part1_if_part1(__warp_usrid_14_liquidityDelta);

            return ();
        }
    }

    func setPosition_541bdfb1_if_part1_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_14_liquidityDelta: felt) -> () {
        alloc_locals;

        setPosition_541bdfb1_if_part1_if_part1(__warp_usrid_14_liquidityDelta);

        return ();
    }

    func setPosition_541bdfb1_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_14_liquidityDelta: felt) -> () {
        alloc_locals;

        let (__warp_se_89) = WS1_READ_Uint256(__warp_usrid_05_totalLiquidity);

        let (__warp_se_90) = warp_int128_to_int256(__warp_usrid_14_liquidityDelta);

        let (__warp_se_91) = warp_add_signed256(__warp_se_89, __warp_se_90);

        WS_WRITE1(__warp_usrid_05_totalLiquidity, __warp_se_91);

        let (__warp_se_92) = WS1_READ_Uint256(__warp_usrid_05_totalLiquidity);

        let (__warp_se_93) = warp_ge_signed256(__warp_se_92, Uint256(low=0, high=0));

        assert __warp_se_93 = 1;

        let (__warp_se_94) = WS1_READ_Uint256(__warp_usrid_05_totalLiquidity);

        let (__warp_se_95) = warp_eq256(__warp_se_94, Uint256(low=0, high=0));

        if (__warp_se_95 != 0) {
            WS_WRITE1(__warp_usrid_08_totalGrowth0, Uint256(low=0, high=0));

            WS_WRITE1(__warp_usrid_09_totalGrowth1, Uint256(low=0, high=0));

            setPosition_541bdfb1_if_part1_if_part1_if_part1();

            return ();
        } else {
            setPosition_541bdfb1_if_part1_if_part1_if_part1();

            return ();
        }
    }

    func setPosition_541bdfb1_if_part1_if_part1_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func __warp_init_TickOverflowSafetyEchidnaTest{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }() -> () {
        alloc_locals;

        let (__warp_se_99) = warp_div(340282366920938463463374607431768211455, 32);

        WS_WRITE0(__warp_usrid_02_MAX_LIQUIDITY, __warp_se_99);

        WS_WRITE0(__warp_usrid_04_tick, 0);

        WS_WRITE1(__warp_usrid_05_totalLiquidity, Uint256(low=0, high=0));

        let (__warp_se_100) = warp_div256(
            Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
            Uint256(low=2, high=0),
        );

        WS_WRITE1(__warp_usrid_06_feeGrowthGlobal0X128, __warp_se_100);

        let (__warp_se_101) = warp_div256(
            Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
            Uint256(low=2, high=0),
        );

        WS_WRITE1(__warp_usrid_07_feeGrowthGlobal1X128, __warp_se_101);

        WS_WRITE1(__warp_usrid_08_totalGrowth0, Uint256(low=0, high=0));

        WS_WRITE1(__warp_usrid_09_totalGrowth1, Uint256(low=0, high=0));

        return ();
    }

    // @notice Updates a tick and returns true if the tick was flipped from initialized to uninitialized, or vice versa
    // @param self The mapping containing all tick information for initialized ticks
    // @param tick The tick that will be updated
    // @param tickCurrent The current tick
    // @param liquidityDelta A new amount of liquidity to be added (subtracted) when tick is crossed from left to right (right to left)
    // @param feeGrowthGlobal0X128 The all-time global fee growth, per unit of liquidity, in token0
    // @param feeGrowthGlobal1X128 The all-time global fee growth, per unit of liquidity, in token1
    // @param secondsPerLiquidityCumulativeX128 The all-time seconds per max(1, liquidity) of the pool
    // @param tickCumulative The tick * time elapsed since the pool was first initialized
    // @param time The current block timestamp cast to a uint32
    // @param upper true for updating a position's upper tick, or false for updating a position's lower tick
    // @param maxLiquidity The maximum liquidity allocation for a single tick
    // @return flipped Whether the tick was flipped from initialized to uninitialized, or vice versa
    func s1___warp_usrfn_10_update{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_32_self: felt,
        __warp_usrid_33_tick: felt,
        __warp_usrid_34_tickCurrent: felt,
        __warp_usrid_35_liquidityDelta: felt,
        __warp_usrid_36_feeGrowthGlobal0X128: Uint256,
        __warp_usrid_37_feeGrowthGlobal1X128: Uint256,
        __warp_usrid_38_secondsPerLiquidityCumulativeX128: felt,
        __warp_usrid_39_tickCumulative: felt,
        __warp_usrid_40_time: felt,
        __warp_usrid_41_upper: felt,
        __warp_usrid_42_maxLiquidity: felt,
    ) -> (__warp_usrid_43_flipped: felt) {
        alloc_locals;

        let __warp_usrid_43_flipped = 0;

        let (__warp_usrid_44_info) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_32_self, __warp_usrid_33_tick
        );

        let (__warp_se_102) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(
            __warp_usrid_44_info
        );

        let (__warp_usrid_45_liquidityGrossBefore) = WS0_READ_felt(__warp_se_102);

        let (__warp_usrid_46_liquidityGrossAfter) = s2___warp_usrfn_00_addDelta(
            __warp_usrid_45_liquidityGrossBefore, __warp_usrid_35_liquidityDelta
        );

        let (__warp_se_103) = warp_le(
            __warp_usrid_46_liquidityGrossAfter, __warp_usrid_42_maxLiquidity
        );

        with_attr error_message("LO") {
            assert __warp_se_103 = 1;
        }

        let (__warp_se_104) = warp_eq(__warp_usrid_46_liquidityGrossAfter, 0);

        let (__warp_se_105) = warp_eq(__warp_usrid_45_liquidityGrossBefore, 0);

        let (__warp_se_106) = warp_neq(__warp_se_104, __warp_se_105);

        let __warp_usrid_43_flipped = __warp_se_106;

        let (__warp_se_107) = warp_eq(__warp_usrid_45_liquidityGrossBefore, 0);

        if (__warp_se_107 != 0) {
            let (__warp_se_108) = warp_le_signed24(
                __warp_usrid_33_tick, __warp_usrid_34_tickCurrent
            );

            if (__warp_se_108 != 0) {
                let (__warp_se_109) = WSM1_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                    __warp_usrid_44_info
                );

                WS_WRITE1(__warp_se_109, __warp_usrid_36_feeGrowthGlobal0X128);

                let (__warp_se_110) = WSM2_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                    __warp_usrid_44_info
                );

                WS_WRITE1(__warp_se_110, __warp_usrid_37_feeGrowthGlobal1X128);

                let (
                    __warp_se_111
                ) = WSM3_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
                    __warp_usrid_44_info
                );

                WS_WRITE0(__warp_se_111, __warp_usrid_38_secondsPerLiquidityCumulativeX128);

                let (__warp_se_112) = WSM4_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
                    __warp_usrid_44_info
                );

                WS_WRITE0(__warp_se_112, __warp_usrid_39_tickCumulative);

                let (__warp_se_113) = WSM5_Info_39bc053d___warp_usrid_06_secondsOutside(
                    __warp_usrid_44_info
                );

                WS_WRITE0(__warp_se_113, __warp_usrid_40_time);

                let (__warp_se_114) = s1___warp_usrfn_10_update_if_part2(
                    __warp_usrid_44_info,
                    __warp_usrid_46_liquidityGrossAfter,
                    __warp_usrid_41_upper,
                    __warp_usrid_35_liquidityDelta,
                    __warp_usrid_43_flipped,
                );

                return (__warp_se_114,);
            } else {
                let (__warp_se_115) = s1___warp_usrfn_10_update_if_part2(
                    __warp_usrid_44_info,
                    __warp_usrid_46_liquidityGrossAfter,
                    __warp_usrid_41_upper,
                    __warp_usrid_35_liquidityDelta,
                    __warp_usrid_43_flipped,
                );

                return (__warp_se_115,);
            }
        } else {
            let (__warp_se_116) = s1___warp_usrfn_10_update_if_part1(
                __warp_usrid_44_info,
                __warp_usrid_46_liquidityGrossAfter,
                __warp_usrid_41_upper,
                __warp_usrid_35_liquidityDelta,
                __warp_usrid_43_flipped,
            );

            return (__warp_se_116,);
        }
    }

    func s1___warp_usrfn_10_update_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_44_info: felt,
        __warp_usrid_46_liquidityGrossAfter: felt,
        __warp_usrid_41_upper: felt,
        __warp_usrid_35_liquidityDelta: felt,
        __warp_usrid_43_flipped: felt,
    ) -> (__warp_usrid_43_flipped: felt) {
        alloc_locals;

        let (__warp_se_117) = WSM6_Info_39bc053d___warp_usrid_07_initialized(__warp_usrid_44_info);

        WS_WRITE0(__warp_se_117, 1);

        let (__warp_se_118) = s1___warp_usrfn_10_update_if_part1(
            __warp_usrid_44_info,
            __warp_usrid_46_liquidityGrossAfter,
            __warp_usrid_41_upper,
            __warp_usrid_35_liquidityDelta,
            __warp_usrid_43_flipped,
        );

        return (__warp_se_118,);
    }

    func s1___warp_usrfn_10_update_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_44_info: felt,
        __warp_usrid_46_liquidityGrossAfter: felt,
        __warp_usrid_41_upper: felt,
        __warp_usrid_35_liquidityDelta: felt,
        __warp_usrid_43_flipped: felt,
    ) -> (__warp_usrid_43_flipped: felt) {
        alloc_locals;

        let (__warp_se_119) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(
            __warp_usrid_44_info
        );

        WS_WRITE0(__warp_se_119, __warp_usrid_46_liquidityGrossAfter);

        if (__warp_usrid_41_upper != 0) {
            let (__warp_se_120) = WSM7_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_44_info
            );

            let (__warp_se_121) = WSM7_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_44_info
            );

            let (__warp_se_122) = WS0_READ_felt(__warp_se_121);

            let (__warp_se_123) = warp_int128_to_int256(__warp_se_122);

            let (__warp_se_124) = warp_int128_to_int256(__warp_usrid_35_liquidityDelta);

            let (__warp_se_125) = s4___warp_usrfn_04_sub(__warp_se_123, __warp_se_124);

            let (__warp_se_126) = s3___warp_usrfn_01_toInt128(__warp_se_125);

            WS_WRITE0(__warp_se_120, __warp_se_126);

            return (__warp_usrid_43_flipped,);
        } else {
            let (__warp_se_127) = WSM7_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_44_info
            );

            let (__warp_se_128) = WSM7_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_44_info
            );

            let (__warp_se_129) = WS0_READ_felt(__warp_se_128);

            let (__warp_se_130) = warp_int128_to_int256(__warp_se_129);

            let (__warp_se_131) = warp_int128_to_int256(__warp_usrid_35_liquidityDelta);

            let (__warp_se_132) = s4___warp_usrfn_03_add(__warp_se_130, __warp_se_131);

            let (__warp_se_133) = s3___warp_usrfn_01_toInt128(__warp_se_132);

            WS_WRITE0(__warp_se_127, __warp_se_133);

            return (__warp_usrid_43_flipped,);
        }
    }

    // @notice Clears tick data
    // @param self The mapping containing all initialized tick information for initialized ticks
    // @param tick The tick that will be cleared
    func s1___warp_usrfn_11_clear{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }(__warp_usrid_47_self: felt, __warp_usrid_48_tick: felt) -> () {
        alloc_locals;

        let (__warp_se_134) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_47_self, __warp_usrid_48_tick
        );

        WS_STRUCT_Info_DELETE(__warp_se_134);

        return ();
    }

    // @notice Transitions to next tick as needed by price movement
    // @param self The mapping containing all tick information for initialized ticks
    // @param tick The destination tick of the transition
    // @param feeGrowthGlobal0X128 The all-time global fee growth, per unit of liquidity, in token0
    // @param feeGrowthGlobal1X128 The all-time global fee growth, per unit of liquidity, in token1
    // @param secondsPerLiquidityCumulativeX128 The current seconds per liquidity
    // @param tickCumulative The tick * time elapsed since the pool was first initialized
    // @param time The current block.timestamp
    // @return liquidityNet The amount of liquidity added (subtracted) when tick is crossed from left to right (right to left)
    func s1___warp_usrfn_12_cross{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_49_self: felt,
        __warp_usrid_50_tick: felt,
        __warp_usrid_51_feeGrowthGlobal0X128: Uint256,
        __warp_usrid_52_feeGrowthGlobal1X128: Uint256,
        __warp_usrid_53_secondsPerLiquidityCumulativeX128: felt,
        __warp_usrid_54_tickCumulative: felt,
        __warp_usrid_55_time: felt,
    ) -> (__warp_usrid_56_liquidityNet: felt) {
        alloc_locals;

        let __warp_usrid_56_liquidityNet = 0;

        let (__warp_usrid_57_info) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_49_self, __warp_usrid_50_tick
        );

        let (__warp_se_135) = WSM1_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
            __warp_usrid_57_info
        );

        let (__warp_se_136) = WSM1_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
            __warp_usrid_57_info
        );

        let (__warp_se_137) = WS1_READ_Uint256(__warp_se_136);

        let (__warp_se_138) = warp_sub256(__warp_usrid_51_feeGrowthGlobal0X128, __warp_se_137);

        WS_WRITE1(__warp_se_135, __warp_se_138);

        let (__warp_se_139) = WSM2_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
            __warp_usrid_57_info
        );

        let (__warp_se_140) = WSM2_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
            __warp_usrid_57_info
        );

        let (__warp_se_141) = WS1_READ_Uint256(__warp_se_140);

        let (__warp_se_142) = warp_sub256(__warp_usrid_52_feeGrowthGlobal1X128, __warp_se_141);

        WS_WRITE1(__warp_se_139, __warp_se_142);

        let (__warp_se_143) = WSM3_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
            __warp_usrid_57_info
        );

        let (__warp_se_144) = WSM3_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
            __warp_usrid_57_info
        );

        let (__warp_se_145) = WS0_READ_felt(__warp_se_144);

        let (__warp_se_146) = warp_sub(
            __warp_usrid_53_secondsPerLiquidityCumulativeX128, __warp_se_145
        );

        WS_WRITE0(__warp_se_143, __warp_se_146);

        let (__warp_se_147) = WSM4_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
            __warp_usrid_57_info
        );

        let (__warp_se_148) = WSM4_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
            __warp_usrid_57_info
        );

        let (__warp_se_149) = WS0_READ_felt(__warp_se_148);

        let (__warp_se_150) = warp_sub_signed56(__warp_usrid_54_tickCumulative, __warp_se_149);

        WS_WRITE0(__warp_se_147, __warp_se_150);

        let (__warp_se_151) = WSM5_Info_39bc053d___warp_usrid_06_secondsOutside(
            __warp_usrid_57_info
        );

        let (__warp_se_152) = WSM5_Info_39bc053d___warp_usrid_06_secondsOutside(
            __warp_usrid_57_info
        );

        let (__warp_se_153) = WS0_READ_felt(__warp_se_152);

        let (__warp_se_154) = warp_sub(__warp_usrid_55_time, __warp_se_153);

        WS_WRITE0(__warp_se_151, __warp_se_154);

        let (__warp_se_155) = WSM7_Info_39bc053d___warp_usrid_01_liquidityNet(__warp_usrid_57_info);

        let (__warp_se_156) = WS0_READ_felt(__warp_se_155);

        let __warp_usrid_56_liquidityNet = __warp_se_156;

        return (__warp_usrid_56_liquidityNet,);
    }

    // @notice Add a signed liquidity delta to liquidity and revert if it overflows or underflows
    // @param x The liquidity before change
    // @param y The delta by which liquidity should be changed
    // @return z The liquidity delta
    func s2___warp_usrfn_00_addDelta{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_01_x: felt, __warp_usrid_02_y: felt
    ) -> (__warp_usrid_03_z: felt) {
        alloc_locals;

        let __warp_usrid_03_z = 0;

        let (__warp_se_157) = warp_lt_signed128(__warp_usrid_02_y, 0);

        if (__warp_se_157 != 0) {
            let (__warp_se_158) = warp_negate128(__warp_usrid_02_y);

            let (__warp_se_159) = warp_sub(__warp_usrid_01_x, __warp_se_158);

            let __warp_se_160 = __warp_se_159;

            let __warp_usrid_03_z = __warp_se_160;

            let (__warp_se_161) = warp_lt(__warp_se_160, __warp_usrid_01_x);

            with_attr error_message("LS") {
                assert __warp_se_161 = 1;
            }

            return (__warp_usrid_03_z,);
        } else {
            let (__warp_se_162) = warp_add128(__warp_usrid_01_x, __warp_usrid_02_y);

            let __warp_se_163 = __warp_se_162;

            let __warp_usrid_03_z = __warp_se_163;

            let (__warp_se_164) = warp_ge(__warp_se_163, __warp_usrid_01_x);

            with_attr error_message("LA") {
                assert __warp_se_164 = 1;
            }

            return (__warp_usrid_03_z,);
        }
    }

    // @notice Cast a int256 to a int128, revert on overflow or underflow
    // @param y The int256 to be downcasted
    // @return z The downcasted integer, now type int128
    func s3___warp_usrfn_01_toInt128{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_05_y: Uint256
    ) -> (__warp_usrid_06_z: felt) {
        alloc_locals;

        let __warp_usrid_06_z = 0;

        let (__warp_se_165) = warp_int256_to_int128(__warp_usrid_05_y);

        let __warp_se_166 = __warp_se_165;

        let __warp_usrid_06_z = __warp_se_166;

        let (__warp_se_167) = warp_int128_to_int256(__warp_se_166);

        let (__warp_se_168) = warp_eq256(__warp_se_167, __warp_usrid_05_y);

        assert __warp_se_168 = 1;

        return (__warp_usrid_06_z,);
    }

    // @notice Returns x + y, reverts if overflows or underflows
    // @param x The augend
    // @param y The addend
    // @return z The sum of x and y
    func s4___warp_usrfn_03_add{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_14_x: Uint256, __warp_usrid_15_y: Uint256
    ) -> (__warp_usrid_16_z: Uint256) {
        alloc_locals;

        let __warp_usrid_16_z = Uint256(low=0, high=0);

        let (__warp_se_169) = warp_add_signed256(__warp_usrid_14_x, __warp_usrid_15_y);

        let __warp_se_170 = __warp_se_169;

        let __warp_usrid_16_z = __warp_se_170;

        let (__warp_se_171) = warp_ge_signed256(__warp_se_170, __warp_usrid_14_x);

        let (__warp_se_172) = warp_ge_signed256(__warp_usrid_15_y, Uint256(low=0, high=0));

        let (__warp_se_173) = warp_eq(__warp_se_171, __warp_se_172);

        assert __warp_se_173 = 1;

        return (__warp_usrid_16_z,);
    }

    // @notice Returns x - y, reverts if overflows or underflows
    // @param x The minuend
    // @param y The subtrahend
    // @return z The difference of x and y
    func s4___warp_usrfn_04_sub{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_17_x: Uint256, __warp_usrid_18_y: Uint256
    ) -> (__warp_usrid_19_z: Uint256) {
        alloc_locals;

        let __warp_usrid_19_z = Uint256(low=0, high=0);

        let (__warp_se_174) = warp_sub_signed256(__warp_usrid_17_x, __warp_usrid_18_y);

        let __warp_se_175 = __warp_se_174;

        let __warp_usrid_19_z = __warp_se_175;

        let (__warp_se_176) = warp_le_signed256(__warp_se_175, __warp_usrid_17_x);

        let (__warp_se_177) = warp_ge_signed256(__warp_usrid_18_y, Uint256(low=0, high=0));

        let (__warp_se_178) = warp_eq(__warp_se_176, __warp_se_177);

        assert __warp_se_178 = 1;

        return (__warp_usrid_19_z,);
    }
}

@external
func increaseFeeGrowthGlobal0X128_0b0c061f{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}(__warp_usrid_10_amount: Uint256) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_10_amount);

    let (__warp_se_40) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_08_totalGrowth0
    );

    let (__warp_se_41) = warp_add256(__warp_se_40, __warp_usrid_10_amount);

    let (__warp_se_42) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_08_totalGrowth0
    );

    let (__warp_se_43) = warp_gt256(__warp_se_41, __warp_se_42);

    assert __warp_se_43 = 1;

    let (__warp_se_44) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_06_feeGrowthGlobal0X128
    );

    let (__warp_se_45) = warp_add256(__warp_se_44, __warp_usrid_10_amount);

    WS_WRITE1(TickOverflowSafetyEchidnaTest.__warp_usrid_06_feeGrowthGlobal0X128, __warp_se_45);

    let (__warp_se_46) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_08_totalGrowth0
    );

    let (__warp_se_47) = warp_add256(__warp_se_46, __warp_usrid_10_amount);

    WS_WRITE1(TickOverflowSafetyEchidnaTest.__warp_usrid_08_totalGrowth0, __warp_se_47);

    return ();
}

@external
func increaseFeeGrowthGlobal1X128_3f03e194{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}(__warp_usrid_11_amount: Uint256) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_11_amount);

    let (__warp_se_48) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_09_totalGrowth1
    );

    let (__warp_se_49) = warp_add256(__warp_se_48, __warp_usrid_11_amount);

    let (__warp_se_50) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_09_totalGrowth1
    );

    let (__warp_se_51) = warp_gt256(__warp_se_49, __warp_se_50);

    assert __warp_se_51 = 1;

    let (__warp_se_52) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_07_feeGrowthGlobal1X128
    );

    let (__warp_se_53) = warp_add256(__warp_se_52, __warp_usrid_11_amount);

    WS_WRITE1(TickOverflowSafetyEchidnaTest.__warp_usrid_07_feeGrowthGlobal1X128, __warp_se_53);

    let (__warp_se_54) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_09_totalGrowth1
    );

    let (__warp_se_55) = warp_add256(__warp_se_54, __warp_usrid_11_amount);

    WS_WRITE1(TickOverflowSafetyEchidnaTest.__warp_usrid_09_totalGrowth1, __warp_se_55);

    return ();
}

@external
func setPosition_541bdfb1{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_12_tickLower: felt,
    __warp_usrid_13_tickUpper: felt,
    __warp_usrid_14_liquidityDelta: felt,
) -> () {
    alloc_locals;

    warp_external_input_check_int128(__warp_usrid_14_liquidityDelta);

    warp_external_input_check_int24(__warp_usrid_13_tickUpper);

    warp_external_input_check_int24(__warp_usrid_12_tickLower);

    let (__warp_se_56) = warp_gt_signed24(__warp_usrid_12_tickLower, 16777200);

    assert __warp_se_56 = 1;

    let (__warp_se_57) = warp_lt_signed24(__warp_usrid_13_tickUpper, 16);

    assert __warp_se_57 = 1;

    let (__warp_se_58) = warp_lt_signed24(__warp_usrid_12_tickLower, __warp_usrid_13_tickUpper);

    assert __warp_se_58 = 1;

    let (__warp_se_59) = WS0_READ_felt(TickOverflowSafetyEchidnaTest.__warp_usrid_04_tick);

    let (__warp_se_60) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_06_feeGrowthGlobal0X128
    );

    let (__warp_se_61) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_07_feeGrowthGlobal1X128
    );

    let (__warp_se_62) = warp_block_timestamp();

    let (__warp_se_63) = warp_int256_to_int32(__warp_se_62);

    let (__warp_se_64) = WS0_READ_felt(TickOverflowSafetyEchidnaTest.__warp_usrid_02_MAX_LIQUIDITY);

    let (__warp_usrid_15_flippedLower) = TickOverflowSafetyEchidnaTest.s1___warp_usrfn_10_update(
        TickOverflowSafetyEchidnaTest.__warp_usrid_03_ticks,
        __warp_usrid_12_tickLower,
        __warp_se_59,
        __warp_usrid_14_liquidityDelta,
        __warp_se_60,
        __warp_se_61,
        0,
        0,
        __warp_se_63,
        0,
        __warp_se_64,
    );

    let (__warp_se_65) = WS0_READ_felt(TickOverflowSafetyEchidnaTest.__warp_usrid_04_tick);

    let (__warp_se_66) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_06_feeGrowthGlobal0X128
    );

    let (__warp_se_67) = WS1_READ_Uint256(
        TickOverflowSafetyEchidnaTest.__warp_usrid_07_feeGrowthGlobal1X128
    );

    let (__warp_se_68) = warp_block_timestamp();

    let (__warp_se_69) = warp_int256_to_int32(__warp_se_68);

    let (__warp_se_70) = WS0_READ_felt(TickOverflowSafetyEchidnaTest.__warp_usrid_02_MAX_LIQUIDITY);

    let (__warp_usrid_16_flippedUpper) = TickOverflowSafetyEchidnaTest.s1___warp_usrfn_10_update(
        TickOverflowSafetyEchidnaTest.__warp_usrid_03_ticks,
        __warp_usrid_13_tickUpper,
        __warp_se_65,
        __warp_usrid_14_liquidityDelta,
        __warp_se_66,
        __warp_se_67,
        0,
        0,
        __warp_se_69,
        1,
        __warp_se_70,
    );

    if (__warp_usrid_15_flippedLower != 0) {
        let (__warp_se_71) = warp_lt_signed128(__warp_usrid_14_liquidityDelta, 0);

        if (__warp_se_71 != 0) {
            let (__warp_se_72) = WS0_INDEX_felt_to_Info_39bc053d(
                TickOverflowSafetyEchidnaTest.__warp_usrid_03_ticks, __warp_usrid_12_tickLower
            );

            let (__warp_se_73) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(__warp_se_72);

            let (__warp_se_74) = WS0_READ_felt(__warp_se_73);

            let (__warp_se_75) = warp_eq(__warp_se_74, 0);

            assert __warp_se_75 = 1;

            TickOverflowSafetyEchidnaTest.s1___warp_usrfn_11_clear(
                TickOverflowSafetyEchidnaTest.__warp_usrid_03_ticks, __warp_usrid_12_tickLower
            );

            TickOverflowSafetyEchidnaTest.setPosition_541bdfb1_if_part2(
                __warp_usrid_16_flippedUpper,
                __warp_usrid_14_liquidityDelta,
                __warp_usrid_13_tickUpper,
            );

            return ();
        } else {
            let (__warp_se_76) = WS0_INDEX_felt_to_Info_39bc053d(
                TickOverflowSafetyEchidnaTest.__warp_usrid_03_ticks, __warp_usrid_12_tickLower
            );

            let (__warp_se_77) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(__warp_se_76);

            let (__warp_se_78) = WS0_READ_felt(__warp_se_77);

            let (__warp_se_79) = warp_gt(__warp_se_78, 0);

            assert __warp_se_79 = 1;

            TickOverflowSafetyEchidnaTest.setPosition_541bdfb1_if_part2(
                __warp_usrid_16_flippedUpper,
                __warp_usrid_14_liquidityDelta,
                __warp_usrid_13_tickUpper,
            );

            return ();
        }
    } else {
        TickOverflowSafetyEchidnaTest.setPosition_541bdfb1_if_part1(
            __warp_usrid_16_flippedUpper, __warp_usrid_14_liquidityDelta, __warp_usrid_13_tickUpper
        );

        return ();
    }
}

@external
func moveToTick_af759368{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_17_target: felt) -> () {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_17_target);

    let (__warp_se_96) = warp_gt_signed24(__warp_usrid_17_target, 16777200);

    assert __warp_se_96 = 1;

    let (__warp_se_97) = warp_lt_signed24(__warp_usrid_17_target, 16);

    assert __warp_se_97 = 1;

    let (__warp_se_98) = TickOverflowSafetyEchidnaTest.__warp_while41(__warp_usrid_17_target);

    let __warp_usrid_17_target = __warp_se_98;

    return ();
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;
    WARP_USED_STORAGE.write(13);
    WARP_NAMEGEN.write(1);

    TickOverflowSafetyEchidnaTest.__warp_init_TickOverflowSafetyEchidnaTest();

    return ();
}

// Original soldity abi: ["constructor()","increaseFeeGrowthGlobal0X128(uint256)","increaseFeeGrowthGlobal1X128(uint256)","setPosition(int24,int24,int128)","moveToTick(int24)"]
