%lang starknet

from starkware.cairo.common.dict import dict_read, dict_write
from starkware.cairo.common.uint256 import Uint256
from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int24,
    warp_external_input_check_int128,
    warp_external_input_check_int256,
    warp_external_input_check_int56,
    warp_external_input_check_int160,
    warp_external_input_check_int32,
)
from warplib.maths.external_input_check_bool import warp_external_input_check_bool
from warplib.memory import wm_alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from warplib.maths.div_signed import warp_div_signed24
from warplib.maths.mul_signed import warp_mul_signed24
from warplib.maths.sub_signed import warp_sub_signed24, warp_sub_signed56, warp_sub_signed256
from warplib.maths.div import warp_div
from warplib.maths.add import warp_add24, warp_add128
from warplib.maths.ge_signed import warp_ge_signed24, warp_ge_signed256
from warplib.maths.sub_unsafe import warp_sub_unsafe256
from warplib.maths.lt_signed import warp_lt_signed24, warp_lt_signed128
from warplib.maths.le import warp_le
from warplib.maths.eq import warp_eq, warp_eq256
from warplib.maths.neq import warp_neq
from warplib.maths.le_signed import warp_le_signed24, warp_le_signed256
from warplib.maths.int_conversions import warp_int128_to_int256, warp_int256_to_int128
from warplib.maths.sub import warp_sub256, warp_sub
from warplib.maths.negate import warp_negate128
from warplib.maths.lt import warp_lt
from warplib.maths.ge import warp_ge
from warplib.maths.add_signed import warp_add_signed256

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

func wm_to_storage0{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(loc: felt, mem_loc: felt) -> (loc: felt) {
    alloc_locals;
    let (elem_mem_loc_0) = dict_read{dict_ptr=warp_memory}(mem_loc);
    WARP_STORAGE.write(loc, elem_mem_loc_0);
    let (elem_mem_loc_1) = dict_read{dict_ptr=warp_memory}(mem_loc + 1);
    WARP_STORAGE.write(loc + 1, elem_mem_loc_1);
    let (elem_mem_loc_2) = dict_read{dict_ptr=warp_memory}(mem_loc + 2);
    WARP_STORAGE.write(loc + 2, elem_mem_loc_2);
    let (elem_mem_loc_3) = dict_read{dict_ptr=warp_memory}(mem_loc + 3);
    WARP_STORAGE.write(loc + 3, elem_mem_loc_3);
    let (elem_mem_loc_4) = dict_read{dict_ptr=warp_memory}(mem_loc + 4);
    WARP_STORAGE.write(loc + 4, elem_mem_loc_4);
    let (elem_mem_loc_5) = dict_read{dict_ptr=warp_memory}(mem_loc + 5);
    WARP_STORAGE.write(loc + 5, elem_mem_loc_5);
    let (elem_mem_loc_6) = dict_read{dict_ptr=warp_memory}(mem_loc + 6);
    WARP_STORAGE.write(loc + 6, elem_mem_loc_6);
    let (elem_mem_loc_7) = dict_read{dict_ptr=warp_memory}(mem_loc + 7);
    WARP_STORAGE.write(loc + 7, elem_mem_loc_7);
    let (elem_mem_loc_8) = dict_read{dict_ptr=warp_memory}(mem_loc + 8);
    WARP_STORAGE.write(loc + 8, elem_mem_loc_8);
    let (elem_mem_loc_9) = dict_read{dict_ptr=warp_memory}(mem_loc + 9);
    WARP_STORAGE.write(loc + 9, elem_mem_loc_9);
    return (loc,);
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

func WSM1_Info_39bc053d___warp_usrid_01_liquidityNet(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WSM2_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func WSM3_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(loc: felt) -> (memberLoc: felt) {
    return (loc + 4,);
}

func WSM4_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(loc: felt) -> (memberLoc: felt) {
    return (loc + 6,);
}

func WSM5_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 7,);
}

func WSM6_Info_39bc053d___warp_usrid_06_secondsOutside(loc: felt) -> (memberLoc: felt) {
    return (loc + 8,);
}

func WSM7_Info_39bc053d___warp_usrid_07_initialized(loc: felt) -> (memberLoc: felt) {
    return (loc + 9,);
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
    loc: felt, value: Uint256
) -> (res: Uint256) {
    WARP_STORAGE.write(loc, value.low);
    WARP_STORAGE.write(loc + 1, value.high);
    return (value,);
}

func WS_WRITE1{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt, value: felt
) -> (res: felt) {
    WARP_STORAGE.write(loc, value);
    return (value,);
}

func extern_input_check0{range_check_ptr: felt}(arg: Info_39bc053d) -> () {
    alloc_locals;
    warp_external_input_check_int128(arg.__warp_usrid_00_liquidityGross);
    warp_external_input_check_int128(arg.__warp_usrid_01_liquidityNet);
    warp_external_input_check_int256(arg.__warp_usrid_02_feeGrowthOutside0X128);
    warp_external_input_check_int256(arg.__warp_usrid_03_feeGrowthOutside1X128);
    warp_external_input_check_int56(arg.__warp_usrid_04_tickCumulativeOutside);
    warp_external_input_check_int160(arg.__warp_usrid_05_secondsPerLiquidityOutsideX128);
    warp_external_input_check_int32(arg.__warp_usrid_06_secondsOutside);
    warp_external_input_check_bool(arg.__warp_usrid_07_initialized);
    return ();
}

func cd_to_memory0{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: Info_39bc053d) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0xa, 0x0));
    dict_write{dict_ptr=warp_memory}(mem_start, calldata.__warp_usrid_00_liquidityGross);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, calldata.__warp_usrid_01_liquidityNet);
    dict_write{dict_ptr=warp_memory}(
        mem_start + 2, calldata.__warp_usrid_02_feeGrowthOutside0X128.low
    );
    dict_write{dict_ptr=warp_memory}(
        mem_start + 3, calldata.__warp_usrid_02_feeGrowthOutside0X128.high
    );
    dict_write{dict_ptr=warp_memory}(
        mem_start + 4, calldata.__warp_usrid_03_feeGrowthOutside1X128.low
    );
    dict_write{dict_ptr=warp_memory}(
        mem_start + 5, calldata.__warp_usrid_03_feeGrowthOutside1X128.high
    );
    dict_write{dict_ptr=warp_memory}(mem_start + 6, calldata.__warp_usrid_04_tickCumulativeOutside);
    dict_write{dict_ptr=warp_memory}(
        mem_start + 7, calldata.__warp_usrid_05_secondsPerLiquidityOutsideX128
    );
    dict_write{dict_ptr=warp_memory}(mem_start + 8, calldata.__warp_usrid_06_secondsOutside);
    dict_write{dict_ptr=warp_memory}(mem_start + 9, calldata.__warp_usrid_07_initialized);
    return (mem_start,);
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

// Contract Def TickTest

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

namespace TickTest {
    // Dynamic variables - Arrays and Maps

    const __warp_usrid_00_ticks = 1;

    // Static variables

    // @notice Derives max liquidity per tick from given tick spacing
    // @dev Executed within the pool constructor
    // @param tickSpacing The amount of required tick separation, realized in multiples of `tickSpacing`
    //     e.g., a tickSpacing of 3 requires ticks to be initialized every 3rd tick i.e., ..., -6, -3, 0, 3, 6, ...
    // @return The max liquidity per tick
    func s1___warp_usrfn_08_tickSpacingToMaxLiquidityPerTick{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_13_tickSpacing: felt) -> (__warp_usrid_14_: felt) {
        alloc_locals;

        let (__warp_se_12) = warp_div_signed24(15889944, __warp_usrid_13_tickSpacing);

        let (__warp_usrid_15_minTick) = warp_mul_signed24(
            __warp_se_12, __warp_usrid_13_tickSpacing
        );

        let (__warp_se_13) = warp_div_signed24(887272, __warp_usrid_13_tickSpacing);

        let (__warp_usrid_16_maxTick) = warp_mul_signed24(
            __warp_se_13, __warp_usrid_13_tickSpacing
        );

        let (__warp_se_14) = warp_sub_signed24(__warp_usrid_16_maxTick, __warp_usrid_15_minTick);

        let (__warp_se_15) = warp_div(__warp_se_14, __warp_usrid_13_tickSpacing);

        let (__warp_usrid_17_numTicks) = warp_add24(__warp_se_15, 1);

        let (__warp_se_16) = warp_div(
            340282366920938463463374607431768211455, __warp_usrid_17_numTicks
        );

        return (__warp_se_16,);
    }

    // @notice Retrieves fee growth data
    // @param self The mapping containing all tick information for initialized ticks
    // @param tickLower The lower tick boundary of the position
    // @param tickUpper The upper tick boundary of the position
    // @param tickCurrent The current tick
    // @param feeGrowthGlobal0X128 The all-time global fee growth, per unit of liquidity, in token0
    // @param feeGrowthGlobal1X128 The all-time global fee growth, per unit of liquidity, in token1
    // @return feeGrowthInside0X128 The all-time fee growth in token0, per unit of liquidity, inside the position's tick boundaries
    // @return feeGrowthInside1X128 The all-time fee growth in token1, per unit of liquidity, inside the position's tick boundaries
    func s1___warp_usrfn_09_getFeeGrowthInside{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_18_self: felt,
        __warp_usrid_19_tickLower: felt,
        __warp_usrid_20_tickUpper: felt,
        __warp_usrid_21_tickCurrent: felt,
        __warp_usrid_22_feeGrowthGlobal0X128: Uint256,
        __warp_usrid_23_feeGrowthGlobal1X128: Uint256,
    ) -> (
        __warp_usrid_24_feeGrowthInside0X128: Uint256, __warp_usrid_25_feeGrowthInside1X128: Uint256
    ) {
        alloc_locals;

        let __warp_usrid_25_feeGrowthInside1X128 = Uint256(low=0, high=0);

        let __warp_usrid_24_feeGrowthInside0X128 = Uint256(low=0, high=0);

        let (__warp_usrid_26_lower) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_18_self, __warp_usrid_19_tickLower
        );

        let (__warp_usrid_27_upper) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_18_self, __warp_usrid_20_tickUpper
        );

        let __warp_usrid_28_feeGrowthBelow0X128 = Uint256(low=0, high=0);

        let __warp_usrid_29_feeGrowthBelow1X128 = Uint256(low=0, high=0);

        let (__warp_se_17) = warp_ge_signed24(
            __warp_usrid_21_tickCurrent, __warp_usrid_19_tickLower
        );

        if (__warp_se_17 != 0) {
            let (__warp_se_18) = WSM2_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                __warp_usrid_26_lower
            );

            let (__warp_se_19) = WS1_READ_Uint256(__warp_se_18);

            let __warp_usrid_28_feeGrowthBelow0X128 = __warp_se_19;

            let (__warp_se_20) = WSM3_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                __warp_usrid_26_lower
            );

            let (__warp_se_21) = WS1_READ_Uint256(__warp_se_20);

            let __warp_usrid_29_feeGrowthBelow1X128 = __warp_se_21;

            let (
                __warp_usrid_24_feeGrowthInside0X128, __warp_usrid_25_feeGrowthInside1X128
            ) = s1___warp_usrfn_09_getFeeGrowthInside_if_part1(
                __warp_usrid_21_tickCurrent,
                __warp_usrid_20_tickUpper,
                __warp_usrid_27_upper,
                __warp_usrid_22_feeGrowthGlobal0X128,
                __warp_usrid_23_feeGrowthGlobal1X128,
                __warp_usrid_24_feeGrowthInside0X128,
                __warp_usrid_28_feeGrowthBelow0X128,
                __warp_usrid_25_feeGrowthInside1X128,
                __warp_usrid_29_feeGrowthBelow1X128,
            );

            return (__warp_usrid_24_feeGrowthInside0X128, __warp_usrid_25_feeGrowthInside1X128);
        } else {
            let (__warp_se_22) = WSM2_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                __warp_usrid_26_lower
            );

            let (__warp_se_23) = WS1_READ_Uint256(__warp_se_22);

            let (__warp_se_24) = warp_sub_unsafe256(
                __warp_usrid_22_feeGrowthGlobal0X128, __warp_se_23
            );

            let __warp_usrid_28_feeGrowthBelow0X128 = __warp_se_24;

            let (__warp_se_25) = WSM3_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                __warp_usrid_26_lower
            );

            let (__warp_se_26) = WS1_READ_Uint256(__warp_se_25);

            let (__warp_se_27) = warp_sub_unsafe256(
                __warp_usrid_23_feeGrowthGlobal1X128, __warp_se_26
            );

            let __warp_usrid_29_feeGrowthBelow1X128 = __warp_se_27;

            let (
                __warp_usrid_24_feeGrowthInside0X128, __warp_usrid_25_feeGrowthInside1X128
            ) = s1___warp_usrfn_09_getFeeGrowthInside_if_part1(
                __warp_usrid_21_tickCurrent,
                __warp_usrid_20_tickUpper,
                __warp_usrid_27_upper,
                __warp_usrid_22_feeGrowthGlobal0X128,
                __warp_usrid_23_feeGrowthGlobal1X128,
                __warp_usrid_24_feeGrowthInside0X128,
                __warp_usrid_28_feeGrowthBelow0X128,
                __warp_usrid_25_feeGrowthInside1X128,
                __warp_usrid_29_feeGrowthBelow1X128,
            );

            return (__warp_usrid_24_feeGrowthInside0X128, __warp_usrid_25_feeGrowthInside1X128);
        }
    }

    func s1___warp_usrfn_09_getFeeGrowthInside_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_21_tickCurrent: felt,
        __warp_usrid_20_tickUpper: felt,
        __warp_usrid_27_upper: felt,
        __warp_usrid_22_feeGrowthGlobal0X128: Uint256,
        __warp_usrid_23_feeGrowthGlobal1X128: Uint256,
        __warp_usrid_24_feeGrowthInside0X128: Uint256,
        __warp_usrid_28_feeGrowthBelow0X128: Uint256,
        __warp_usrid_25_feeGrowthInside1X128: Uint256,
        __warp_usrid_29_feeGrowthBelow1X128: Uint256,
    ) -> (
        __warp_usrid_24_feeGrowthInside0X128: Uint256, __warp_usrid_25_feeGrowthInside1X128: Uint256
    ) {
        alloc_locals;

        let __warp_usrid_30_feeGrowthAbove0X128 = Uint256(low=0, high=0);

        let __warp_usrid_31_feeGrowthAbove1X128 = Uint256(low=0, high=0);

        let (__warp_se_28) = warp_lt_signed24(
            __warp_usrid_21_tickCurrent, __warp_usrid_20_tickUpper
        );

        if (__warp_se_28 != 0) {
            let (__warp_se_29) = WSM2_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                __warp_usrid_27_upper
            );

            let (__warp_se_30) = WS1_READ_Uint256(__warp_se_29);

            let __warp_usrid_30_feeGrowthAbove0X128 = __warp_se_30;

            let (__warp_se_31) = WSM3_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                __warp_usrid_27_upper
            );

            let (__warp_se_32) = WS1_READ_Uint256(__warp_se_31);

            let __warp_usrid_31_feeGrowthAbove1X128 = __warp_se_32;

            let (
                __warp_usrid_24_feeGrowthInside0X128, __warp_usrid_25_feeGrowthInside1X128
            ) = s1___warp_usrfn_09_getFeeGrowthInside_if_part1_if_part1(
                __warp_usrid_24_feeGrowthInside0X128,
                __warp_usrid_22_feeGrowthGlobal0X128,
                __warp_usrid_28_feeGrowthBelow0X128,
                __warp_usrid_30_feeGrowthAbove0X128,
                __warp_usrid_25_feeGrowthInside1X128,
                __warp_usrid_23_feeGrowthGlobal1X128,
                __warp_usrid_29_feeGrowthBelow1X128,
                __warp_usrid_31_feeGrowthAbove1X128,
            );

            return (__warp_usrid_24_feeGrowthInside0X128, __warp_usrid_25_feeGrowthInside1X128);
        } else {
            let (__warp_se_33) = WSM2_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                __warp_usrid_27_upper
            );

            let (__warp_se_34) = WS1_READ_Uint256(__warp_se_33);

            let (__warp_se_35) = warp_sub_unsafe256(
                __warp_usrid_22_feeGrowthGlobal0X128, __warp_se_34
            );

            let __warp_usrid_30_feeGrowthAbove0X128 = __warp_se_35;

            let (__warp_se_36) = WSM3_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                __warp_usrid_27_upper
            );

            let (__warp_se_37) = WS1_READ_Uint256(__warp_se_36);

            let (__warp_se_38) = warp_sub_unsafe256(
                __warp_usrid_23_feeGrowthGlobal1X128, __warp_se_37
            );

            let __warp_usrid_31_feeGrowthAbove1X128 = __warp_se_38;

            let (
                __warp_usrid_24_feeGrowthInside0X128, __warp_usrid_25_feeGrowthInside1X128
            ) = s1___warp_usrfn_09_getFeeGrowthInside_if_part1_if_part1(
                __warp_usrid_24_feeGrowthInside0X128,
                __warp_usrid_22_feeGrowthGlobal0X128,
                __warp_usrid_28_feeGrowthBelow0X128,
                __warp_usrid_30_feeGrowthAbove0X128,
                __warp_usrid_25_feeGrowthInside1X128,
                __warp_usrid_23_feeGrowthGlobal1X128,
                __warp_usrid_29_feeGrowthBelow1X128,
                __warp_usrid_31_feeGrowthAbove1X128,
            );

            return (__warp_usrid_24_feeGrowthInside0X128, __warp_usrid_25_feeGrowthInside1X128);
        }
    }

    func s1___warp_usrfn_09_getFeeGrowthInside_if_part1_if_part1{bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_24_feeGrowthInside0X128: Uint256,
        __warp_usrid_22_feeGrowthGlobal0X128: Uint256,
        __warp_usrid_28_feeGrowthBelow0X128: Uint256,
        __warp_usrid_30_feeGrowthAbove0X128: Uint256,
        __warp_usrid_25_feeGrowthInside1X128: Uint256,
        __warp_usrid_23_feeGrowthGlobal1X128: Uint256,
        __warp_usrid_29_feeGrowthBelow1X128: Uint256,
        __warp_usrid_31_feeGrowthAbove1X128: Uint256,
    ) -> (
        __warp_usrid_24_feeGrowthInside0X128: Uint256, __warp_usrid_25_feeGrowthInside1X128: Uint256
    ) {
        alloc_locals;

        let (__warp_se_39) = warp_sub_unsafe256(
            __warp_usrid_22_feeGrowthGlobal0X128, __warp_usrid_28_feeGrowthBelow0X128
        );

        let (__warp_se_40) = warp_sub_unsafe256(__warp_se_39, __warp_usrid_30_feeGrowthAbove0X128);

        let __warp_usrid_24_feeGrowthInside0X128 = __warp_se_40;

        let (__warp_se_41) = warp_sub_unsafe256(
            __warp_usrid_23_feeGrowthGlobal1X128, __warp_usrid_29_feeGrowthBelow1X128
        );

        let (__warp_se_42) = warp_sub_unsafe256(__warp_se_41, __warp_usrid_31_feeGrowthAbove1X128);

        let __warp_usrid_25_feeGrowthInside1X128 = __warp_se_42;

        let __warp_usrid_24_feeGrowthInside0X128 = __warp_usrid_24_feeGrowthInside0X128;

        let __warp_usrid_25_feeGrowthInside1X128 = __warp_usrid_25_feeGrowthInside1X128;

        return (__warp_usrid_24_feeGrowthInside0X128, __warp_usrid_25_feeGrowthInside1X128);
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

        let (__warp_se_43) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(
            __warp_usrid_44_info
        );

        let (__warp_usrid_45_liquidityGrossBefore) = WS0_READ_felt(__warp_se_43);

        let (__warp_usrid_46_liquidityGrossAfter) = s2___warp_usrfn_00_addDelta(
            __warp_usrid_45_liquidityGrossBefore, __warp_usrid_35_liquidityDelta
        );

        let (__warp_se_44) = warp_le(
            __warp_usrid_46_liquidityGrossAfter, __warp_usrid_42_maxLiquidity
        );

        with_attr error_message("LO") {
            assert __warp_se_44 = 1;
        }

        let (__warp_se_45) = warp_eq(__warp_usrid_46_liquidityGrossAfter, 0);

        let (__warp_se_46) = warp_eq(__warp_usrid_45_liquidityGrossBefore, 0);

        let (__warp_se_47) = warp_neq(__warp_se_45, __warp_se_46);

        let __warp_usrid_43_flipped = __warp_se_47;

        let (__warp_se_48) = warp_eq(__warp_usrid_45_liquidityGrossBefore, 0);

        if (__warp_se_48 != 0) {
            let (__warp_se_49) = warp_le_signed24(
                __warp_usrid_33_tick, __warp_usrid_34_tickCurrent
            );

            if (__warp_se_49 != 0) {
                let (__warp_se_50) = WSM2_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                    __warp_usrid_44_info
                );

                WS_WRITE0(__warp_se_50, __warp_usrid_36_feeGrowthGlobal0X128);

                let (__warp_se_51) = WSM3_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                    __warp_usrid_44_info
                );

                WS_WRITE0(__warp_se_51, __warp_usrid_37_feeGrowthGlobal1X128);

                let (
                    __warp_se_52
                ) = WSM5_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
                    __warp_usrid_44_info
                );

                WS_WRITE1(__warp_se_52, __warp_usrid_38_secondsPerLiquidityCumulativeX128);

                let (__warp_se_53) = WSM4_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
                    __warp_usrid_44_info
                );

                WS_WRITE1(__warp_se_53, __warp_usrid_39_tickCumulative);

                let (__warp_se_54) = WSM6_Info_39bc053d___warp_usrid_06_secondsOutside(
                    __warp_usrid_44_info
                );

                WS_WRITE1(__warp_se_54, __warp_usrid_40_time);

                let (__warp_se_55) = s1___warp_usrfn_10_update_if_part2(
                    __warp_usrid_44_info,
                    __warp_usrid_46_liquidityGrossAfter,
                    __warp_usrid_41_upper,
                    __warp_usrid_35_liquidityDelta,
                    __warp_usrid_43_flipped,
                );

                return (__warp_se_55,);
            } else {
                let (__warp_se_56) = s1___warp_usrfn_10_update_if_part2(
                    __warp_usrid_44_info,
                    __warp_usrid_46_liquidityGrossAfter,
                    __warp_usrid_41_upper,
                    __warp_usrid_35_liquidityDelta,
                    __warp_usrid_43_flipped,
                );

                return (__warp_se_56,);
            }
        } else {
            let (__warp_se_57) = s1___warp_usrfn_10_update_if_part1(
                __warp_usrid_44_info,
                __warp_usrid_46_liquidityGrossAfter,
                __warp_usrid_41_upper,
                __warp_usrid_35_liquidityDelta,
                __warp_usrid_43_flipped,
            );

            return (__warp_se_57,);
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

        let (__warp_se_58) = WSM7_Info_39bc053d___warp_usrid_07_initialized(__warp_usrid_44_info);

        WS_WRITE1(__warp_se_58, 1);

        let (__warp_se_59) = s1___warp_usrfn_10_update_if_part1(
            __warp_usrid_44_info,
            __warp_usrid_46_liquidityGrossAfter,
            __warp_usrid_41_upper,
            __warp_usrid_35_liquidityDelta,
            __warp_usrid_43_flipped,
        );

        return (__warp_se_59,);
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

        let (__warp_se_60) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(
            __warp_usrid_44_info
        );

        WS_WRITE1(__warp_se_60, __warp_usrid_46_liquidityGrossAfter);

        if (__warp_usrid_41_upper != 0) {
            let (__warp_se_61) = WSM1_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_44_info
            );

            let (__warp_se_62) = WSM1_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_44_info
            );

            let (__warp_se_63) = WS0_READ_felt(__warp_se_62);

            let (__warp_se_64) = warp_int128_to_int256(__warp_se_63);

            let (__warp_se_65) = warp_int128_to_int256(__warp_usrid_35_liquidityDelta);

            let (__warp_se_66) = s4___warp_usrfn_04_sub(__warp_se_64, __warp_se_65);

            let (__warp_se_67) = s3___warp_usrfn_01_toInt128(__warp_se_66);

            WS_WRITE1(__warp_se_61, __warp_se_67);

            return (__warp_usrid_43_flipped,);
        } else {
            let (__warp_se_68) = WSM1_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_44_info
            );

            let (__warp_se_69) = WSM1_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_44_info
            );

            let (__warp_se_70) = WS0_READ_felt(__warp_se_69);

            let (__warp_se_71) = warp_int128_to_int256(__warp_se_70);

            let (__warp_se_72) = warp_int128_to_int256(__warp_usrid_35_liquidityDelta);

            let (__warp_se_73) = s4___warp_usrfn_03_add(__warp_se_71, __warp_se_72);

            let (__warp_se_74) = s3___warp_usrfn_01_toInt128(__warp_se_73);

            WS_WRITE1(__warp_se_68, __warp_se_74);

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

        let (__warp_se_75) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_47_self, __warp_usrid_48_tick
        );

        WS_STRUCT_Info_DELETE(__warp_se_75);

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

        let (__warp_se_76) = WSM2_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
            __warp_usrid_57_info
        );

        let (__warp_se_77) = WSM2_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
            __warp_usrid_57_info
        );

        let (__warp_se_78) = WS1_READ_Uint256(__warp_se_77);

        let (__warp_se_79) = warp_sub256(__warp_usrid_51_feeGrowthGlobal0X128, __warp_se_78);

        WS_WRITE0(__warp_se_76, __warp_se_79);

        let (__warp_se_80) = WSM3_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
            __warp_usrid_57_info
        );

        let (__warp_se_81) = WSM3_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
            __warp_usrid_57_info
        );

        let (__warp_se_82) = WS1_READ_Uint256(__warp_se_81);

        let (__warp_se_83) = warp_sub256(__warp_usrid_52_feeGrowthGlobal1X128, __warp_se_82);

        WS_WRITE0(__warp_se_80, __warp_se_83);

        let (__warp_se_84) = WSM5_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
            __warp_usrid_57_info
        );

        let (__warp_se_85) = WSM5_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
            __warp_usrid_57_info
        );

        let (__warp_se_86) = WS0_READ_felt(__warp_se_85);

        let (__warp_se_87) = warp_sub(
            __warp_usrid_53_secondsPerLiquidityCumulativeX128, __warp_se_86
        );

        WS_WRITE1(__warp_se_84, __warp_se_87);

        let (__warp_se_88) = WSM4_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
            __warp_usrid_57_info
        );

        let (__warp_se_89) = WSM4_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
            __warp_usrid_57_info
        );

        let (__warp_se_90) = WS0_READ_felt(__warp_se_89);

        let (__warp_se_91) = warp_sub_signed56(__warp_usrid_54_tickCumulative, __warp_se_90);

        WS_WRITE1(__warp_se_88, __warp_se_91);

        let (__warp_se_92) = WSM6_Info_39bc053d___warp_usrid_06_secondsOutside(
            __warp_usrid_57_info
        );

        let (__warp_se_93) = WSM6_Info_39bc053d___warp_usrid_06_secondsOutside(
            __warp_usrid_57_info
        );

        let (__warp_se_94) = WS0_READ_felt(__warp_se_93);

        let (__warp_se_95) = warp_sub(__warp_usrid_55_time, __warp_se_94);

        WS_WRITE1(__warp_se_92, __warp_se_95);

        let (__warp_se_96) = WSM1_Info_39bc053d___warp_usrid_01_liquidityNet(__warp_usrid_57_info);

        let (__warp_se_97) = WS0_READ_felt(__warp_se_96);

        let __warp_usrid_56_liquidityNet = __warp_se_97;

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

        let (__warp_se_98) = warp_lt_signed128(__warp_usrid_02_y, 0);

        if (__warp_se_98 != 0) {
            let (__warp_se_99) = warp_negate128(__warp_usrid_02_y);

            let (__warp_se_100) = warp_sub(__warp_usrid_01_x, __warp_se_99);

            let __warp_se_101 = __warp_se_100;

            let __warp_usrid_03_z = __warp_se_101;

            let (__warp_se_102) = warp_lt(__warp_se_101, __warp_usrid_01_x);

            with_attr error_message("LS") {
                assert __warp_se_102 = 1;
            }

            return (__warp_usrid_03_z,);
        } else {
            let (__warp_se_103) = warp_add128(__warp_usrid_01_x, __warp_usrid_02_y);

            let __warp_se_104 = __warp_se_103;

            let __warp_usrid_03_z = __warp_se_104;

            let (__warp_se_105) = warp_ge(__warp_se_104, __warp_usrid_01_x);

            with_attr error_message("LA") {
                assert __warp_se_105 = 1;
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

        let (__warp_se_106) = warp_int256_to_int128(__warp_usrid_05_y);

        let __warp_se_107 = __warp_se_106;

        let __warp_usrid_06_z = __warp_se_107;

        let (__warp_se_108) = warp_int128_to_int256(__warp_se_107);

        let (__warp_se_109) = warp_eq256(__warp_se_108, __warp_usrid_05_y);

        assert __warp_se_109 = 1;

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

        let (__warp_se_110) = warp_add_signed256(__warp_usrid_14_x, __warp_usrid_15_y);

        let __warp_se_111 = __warp_se_110;

        let __warp_usrid_16_z = __warp_se_111;

        let (__warp_se_112) = warp_ge_signed256(__warp_se_111, __warp_usrid_14_x);

        let (__warp_se_113) = warp_ge_signed256(__warp_usrid_15_y, Uint256(low=0, high=0));

        let (__warp_se_114) = warp_eq(__warp_se_112, __warp_se_113);

        assert __warp_se_114 = 1;

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

        let (__warp_se_115) = warp_sub_signed256(__warp_usrid_17_x, __warp_usrid_18_y);

        let __warp_se_116 = __warp_se_115;

        let __warp_usrid_19_z = __warp_se_116;

        let (__warp_se_117) = warp_le_signed256(__warp_se_116, __warp_usrid_17_x);

        let (__warp_se_118) = warp_ge_signed256(__warp_usrid_18_y, Uint256(low=0, high=0));

        let (__warp_se_119) = warp_eq(__warp_se_117, __warp_se_118);

        assert __warp_se_119 = 1;

        return (__warp_usrid_19_z,);
    }
}

@view
func tickSpacingToMaxLiquidityPerTick_82c66f87{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_01_tickSpacing: felt) -> (__warp_usrid_02_: felt) {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_01_tickSpacing);

    let (__warp_se_0) = TickTest.s1___warp_usrfn_08_tickSpacingToMaxLiquidityPerTick(
        __warp_usrid_01_tickSpacing
    );

    return (__warp_se_0,);
}

@external
func setTick_5cb083ce{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_03_tick: felt, __warp_usrid_04_info: Info_39bc053d
) -> () {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check0(__warp_usrid_04_info);

        warp_external_input_check_int24(__warp_usrid_03_tick);

        let (__warp_usrid_04_infocd_to_wm_param_) = cd_to_memory0(__warp_usrid_04_info);

        let (__warp_se_1) = WS0_INDEX_felt_to_Info_39bc053d(
            TickTest.__warp_usrid_00_ticks, __warp_usrid_03_tick
        );

        wm_to_storage0(__warp_se_1, __warp_usrid_04_infocd_to_wm_param_);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return ();
    }
}

@view
func getFeeGrowthInside_30e3ff4c{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_05_tickLower: felt,
    __warp_usrid_06_tickUpper: felt,
    __warp_usrid_07_tickCurrent: felt,
    __warp_usrid_08_feeGrowthGlobal0X128: Uint256,
    __warp_usrid_09_feeGrowthGlobal1X128: Uint256,
) -> (
    __warp_usrid_10_feeGrowthInside0X128: Uint256, __warp_usrid_11_feeGrowthInside1X128: Uint256
) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_09_feeGrowthGlobal1X128);

    warp_external_input_check_int256(__warp_usrid_08_feeGrowthGlobal0X128);

    warp_external_input_check_int24(__warp_usrid_07_tickCurrent);

    warp_external_input_check_int24(__warp_usrid_06_tickUpper);

    warp_external_input_check_int24(__warp_usrid_05_tickLower);

    let (
        __warp_usrid_10_feeGrowthInside0X128, __warp_usrid_11_feeGrowthInside1X128
    ) = TickTest.s1___warp_usrfn_09_getFeeGrowthInside(
        TickTest.__warp_usrid_00_ticks,
        __warp_usrid_05_tickLower,
        __warp_usrid_06_tickUpper,
        __warp_usrid_07_tickCurrent,
        __warp_usrid_08_feeGrowthGlobal0X128,
        __warp_usrid_09_feeGrowthGlobal1X128,
    );

    return (__warp_usrid_10_feeGrowthInside0X128, __warp_usrid_11_feeGrowthInside1X128);
}

@external
func update_20b90da9{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_12_tick: felt,
    __warp_usrid_13_tickCurrent: felt,
    __warp_usrid_14_liquidityDelta: felt,
    __warp_usrid_15_feeGrowthGlobal0X128: Uint256,
    __warp_usrid_16_feeGrowthGlobal1X128: Uint256,
    __warp_usrid_17_secondsPerLiquidityCumulativeX128: felt,
    __warp_usrid_18_tickCumulative: felt,
    __warp_usrid_19_time: felt,
    __warp_usrid_20_upper: felt,
    __warp_usrid_21_maxLiquidity: felt,
) -> (__warp_usrid_22_flipped: felt) {
    alloc_locals;

    warp_external_input_check_int128(__warp_usrid_21_maxLiquidity);

    warp_external_input_check_bool(__warp_usrid_20_upper);

    warp_external_input_check_int32(__warp_usrid_19_time);

    warp_external_input_check_int56(__warp_usrid_18_tickCumulative);

    warp_external_input_check_int160(__warp_usrid_17_secondsPerLiquidityCumulativeX128);

    warp_external_input_check_int256(__warp_usrid_16_feeGrowthGlobal1X128);

    warp_external_input_check_int256(__warp_usrid_15_feeGrowthGlobal0X128);

    warp_external_input_check_int128(__warp_usrid_14_liquidityDelta);

    warp_external_input_check_int24(__warp_usrid_13_tickCurrent);

    warp_external_input_check_int24(__warp_usrid_12_tick);

    let (__warp_se_2) = TickTest.s1___warp_usrfn_10_update(
        TickTest.__warp_usrid_00_ticks,
        __warp_usrid_12_tick,
        __warp_usrid_13_tickCurrent,
        __warp_usrid_14_liquidityDelta,
        __warp_usrid_15_feeGrowthGlobal0X128,
        __warp_usrid_16_feeGrowthGlobal1X128,
        __warp_usrid_17_secondsPerLiquidityCumulativeX128,
        __warp_usrid_18_tickCumulative,
        __warp_usrid_19_time,
        __warp_usrid_20_upper,
        __warp_usrid_21_maxLiquidity,
    );

    return (__warp_se_2,);
}

@external
func clear_b613524a{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_23_tick: felt
) -> () {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_23_tick);

    TickTest.s1___warp_usrfn_11_clear(TickTest.__warp_usrid_00_ticks, __warp_usrid_23_tick);

    return ();
}

@external
func cross_df33fa88{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_24_tick: felt,
    __warp_usrid_25_feeGrowthGlobal0X128: Uint256,
    __warp_usrid_26_feeGrowthGlobal1X128: Uint256,
    __warp_usrid_27_secondsPerLiquidityCumulativeX128: felt,
    __warp_usrid_28_tickCumulative: felt,
    __warp_usrid_29_time: felt,
) -> (__warp_usrid_30_liquidityNet: felt) {
    alloc_locals;

    warp_external_input_check_int32(__warp_usrid_29_time);

    warp_external_input_check_int56(__warp_usrid_28_tickCumulative);

    warp_external_input_check_int160(__warp_usrid_27_secondsPerLiquidityCumulativeX128);

    warp_external_input_check_int256(__warp_usrid_26_feeGrowthGlobal1X128);

    warp_external_input_check_int256(__warp_usrid_25_feeGrowthGlobal0X128);

    warp_external_input_check_int24(__warp_usrid_24_tick);

    let (__warp_se_3) = TickTest.s1___warp_usrfn_12_cross(
        TickTest.__warp_usrid_00_ticks,
        __warp_usrid_24_tick,
        __warp_usrid_25_feeGrowthGlobal0X128,
        __warp_usrid_26_feeGrowthGlobal1X128,
        __warp_usrid_27_secondsPerLiquidityCumulativeX128,
        __warp_usrid_28_tickCumulative,
        __warp_usrid_29_time,
    );

    return (__warp_se_3,);
}

@view
func ticks_f30dba93{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_31__i0: felt
) -> (
    __warp_usrid_32_: felt,
    __warp_usrid_33_: felt,
    __warp_usrid_34_: Uint256,
    __warp_usrid_35_: Uint256,
    __warp_usrid_36_: felt,
    __warp_usrid_37_: felt,
    __warp_usrid_38_: felt,
    __warp_usrid_39_: felt,
) {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_31__i0);

    let (__warp_usrid_40__temp0) = WS0_INDEX_felt_to_Info_39bc053d(
        TickTest.__warp_usrid_00_ticks, __warp_usrid_31__i0
    );

    let (__warp_se_4) = WSM0_Info_39bc053d___warp_usrid_00_liquidityGross(__warp_usrid_40__temp0);

    let (__warp_usrid_32_) = WS0_READ_felt(__warp_se_4);

    let (__warp_se_5) = WSM1_Info_39bc053d___warp_usrid_01_liquidityNet(__warp_usrid_40__temp0);

    let (__warp_usrid_33_) = WS0_READ_felt(__warp_se_5);

    let (__warp_se_6) = WSM2_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
        __warp_usrid_40__temp0
    );

    let (__warp_usrid_34_) = WS1_READ_Uint256(__warp_se_6);

    let (__warp_se_7) = WSM3_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
        __warp_usrid_40__temp0
    );

    let (__warp_usrid_35_) = WS1_READ_Uint256(__warp_se_7);

    let (__warp_se_8) = WSM4_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
        __warp_usrid_40__temp0
    );

    let (__warp_usrid_36_) = WS0_READ_felt(__warp_se_8);

    let (__warp_se_9) = WSM5_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
        __warp_usrid_40__temp0
    );

    let (__warp_usrid_37_) = WS0_READ_felt(__warp_se_9);

    let (__warp_se_10) = WSM6_Info_39bc053d___warp_usrid_06_secondsOutside(__warp_usrid_40__temp0);

    let (__warp_usrid_38_) = WS0_READ_felt(__warp_se_10);

    let (__warp_se_11) = WSM7_Info_39bc053d___warp_usrid_07_initialized(__warp_usrid_40__temp0);

    let (__warp_usrid_39_) = WS0_READ_felt(__warp_se_11);

    return (
        __warp_usrid_32_,
        __warp_usrid_33_,
        __warp_usrid_34_,
        __warp_usrid_35_,
        __warp_usrid_36_,
        __warp_usrid_37_,
        __warp_usrid_38_,
        __warp_usrid_39_,
    );
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;
    WARP_USED_STORAGE.write(1);
    WARP_NAMEGEN.write(1);

    return ();
}

// Original soldity abi: ["constructor()","tickSpacingToMaxLiquidityPerTick(int24)","setTick(int24,(uint128,int128,uint256,uint256,int56,uint160,uint32,bool))","getFeeGrowthInside(int24,int24,int24,uint256,uint256)","update(int24,int24,int128,uint256,uint256,uint160,int56,uint32,bool,uint128)","clear(int24)","cross(int24,uint256,uint256,uint160,int56,uint32)","ticks(int24)"]
