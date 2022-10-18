%lang starknet

from warplib.memory import (
    wm_read_felt,
    wm_alloc,
    wm_read_256,
    wm_write_felt,
    wm_new,
    wm_dyn_array_length,
    wm_index_dyn,
)
from starkware.cairo.common.dict import dict_write, dict_read
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_sub,
    uint256_add,
    uint256_le,
    uint256_lt,
    uint256_mul,
)
from starkware.cairo.common.alloc import alloc
from warplib.maths.utils import narrow_safe, felt_to_uint256
from starkware.cairo.common.math import split_felt
from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int32,
    warp_external_input_check_int24,
    warp_external_input_check_int128,
    warp_external_input_check_int16,
    warp_external_input_check_int256,
)
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from warplib.maths.lt import warp_lt256, warp_lt
from warplib.maths.add_unsafe import (
    warp_add_unsafe256,
    warp_add_unsafe16,
    warp_add_unsafe32,
    warp_add_unsafe160,
    warp_add_unsafe40,
)
from warplib.maths.sub_unsafe import (
    warp_sub_unsafe256,
    warp_sub_unsafe16,
    warp_sub_unsafe32,
    warp_sub_unsafe160,
)
from warplib.maths.div_unsafe import warp_div_unsafe256, warp_div_unsafe
from warplib.maths.int_conversions import (
    warp_uint256,
    warp_int256_to_int248,
    warp_int24_to_int56,
    warp_int32_to_int56,
    warp_int256_to_int160,
)
from warplib.maths.mod import warp_mod256, warp_mod
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from warplib.maths.eq import warp_eq
from warplib.maths.mul_signed_unsafe import warp_mul_signed_unsafe56
from warplib.maths.add_signed_unsafe import warp_add_signed_unsafe56
from warplib.maths.shl import warp_shl160
from warplib.maths.gt import warp_gt
from warplib.maths.and_ import warp_and_
from warplib.maths.le import warp_le, warp_le256
from warplib.maths.neq import warp_neq
from warplib.maths.sub_signed_unsafe import warp_sub_signed_unsafe56
from warplib.maths.div_signed_unsafe import warp_div_signed_unsafe56
from warplib.maths.mul_unsafe import warp_mul_unsafe256

struct Observation_2cc4d695 {
    __warp_usrid_00_blockTimestamp: felt,
    __warp_usrid_01_tickCumulative: felt,
    __warp_usrid_02_secondsPerLiquidityCumulativeX128: felt,
    __warp_usrid_03_initialized: felt,
}

struct InitializeParams_62e4fbcc {
    __warp_usrid_00_time: felt,
    __warp_usrid_01_tick: felt,
    __warp_usrid_02_liquidity: felt,
}

struct UpdateParams_a5eebe58 {
    __warp_usrid_03_advanceTimeBy: felt,
    __warp_usrid_04_tick: felt,
    __warp_usrid_05_liquidity: felt,
}

struct cd_dynarray_UpdateParams_a5eebe58 {
    len: felt,
    ptr: UpdateParams_a5eebe58*,
}

struct cd_dynarray_felt {
    len: felt,
    ptr: felt*,
}

func WM0_Observation_2cc4d695___warp_usrid_03_initialized(loc: felt) -> (memberLoc: felt) {
    return (loc + 3,);
}

func WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 2,);
}

func WM0_struct_Observation_2cc4d695{range_check_ptr, warp_memory: DictAccess*}(
    __warp_usrid_00_blockTimestamp: felt,
    __warp_usrid_01_tickCumulative: felt,
    __warp_usrid_02_secondsPerLiquidityCumulativeX128: felt,
    __warp_usrid_03_initialized: felt,
) -> (res: felt) {
    alloc_locals;
    let (start) = wm_alloc(Uint256(0x4, 0x0));
    dict_write{dict_ptr=warp_memory}(start, __warp_usrid_00_blockTimestamp);
    dict_write{dict_ptr=warp_memory}(start + 1, __warp_usrid_01_tickCumulative);
    dict_write{dict_ptr=warp_memory}(start + 2, __warp_usrid_02_secondsPerLiquidityCumulativeX128);
    dict_write{dict_ptr=warp_memory}(start + 3, __warp_usrid_03_initialized);
    return (start,);
}

func wm_to_calldata0{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(mem_loc: felt) -> (retData: cd_dynarray_felt) {
    alloc_locals;
    let (len_256) = wm_read_256(mem_loc);
    let (ptr: felt*) = alloc();
    let (len_felt) = narrow_safe(len_256);
    wm_to_calldata1(len_felt, ptr, mem_loc + 2);
    return (cd_dynarray_felt(len=len_felt, ptr=ptr),);
}

func wm_to_calldata1{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(len: felt, ptr: felt*, mem_loc: felt) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    let (mem_read0) = wm_read_felt(mem_loc);
    assert ptr[0] = mem_read0;
    wm_to_calldata1(len=len - 1, ptr=ptr + 1, mem_loc=mem_loc + 1);
    return ();
}

func wm_to_calldata3{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(mem_loc: felt) -> (retData: cd_dynarray_felt) {
    alloc_locals;
    let (len_256) = wm_read_256(mem_loc);
    let (ptr: felt*) = alloc();
    let (len_felt) = narrow_safe(len_256);
    wm_to_calldata4(len_felt, ptr, mem_loc + 2);
    return (cd_dynarray_felt(len=len_felt, ptr=ptr),);
}

func wm_to_calldata4{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(len: felt, ptr: felt*, mem_loc: felt) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    let (mem_read0) = wm_read_felt(mem_loc);
    assert ptr[0] = mem_read0;
    wm_to_calldata4(len=len - 1, ptr=ptr + 1, mem_loc=mem_loc + 1);
    return ();
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
    return (loc,);
}

func WSM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WSM1_Observation_2cc4d695___warp_usrid_01_tickCumulative(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WSM2_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 2,);
}

func WSM3_Observation_2cc4d695___warp_usrid_03_initialized(loc: felt) -> (memberLoc: felt) {
    return (loc + 3,);
}

func WS0_READ_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) -> (val: felt) {
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func WS0_IDX{range_check_ptr}(loc: felt, index: Uint256, size: Uint256, limit: Uint256) -> (
    resLoc: felt
) {
    alloc_locals;
    let (inRange) = uint256_lt(index, limit);
    assert inRange = 1;
    let (locHigh, locLow) = split_felt(loc);
    let (offset, overflow) = uint256_mul(index, size);
    assert overflow.low = 0;
    assert overflow.high = 0;
    let (res256, carry) = uint256_add(Uint256(locLow, locHigh), offset);
    assert carry = 0;
    let (feltLimitHigh, feltLimitLow) = split_felt(-1);
    let (narrowable) = uint256_le(res256, Uint256(feltLimitLow, feltLimitHigh));
    assert narrowable = 1;
    return (res256.low + 2 ** 128 * res256.high,);
}

func ws_to_memory0{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(loc: felt) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0x4, 0x0));
    let (copy0) = WARP_STORAGE.read(loc);
    dict_write{dict_ptr=warp_memory}(mem_start, copy0);
    let (copy1) = WARP_STORAGE.read(loc + 1);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, copy1);
    let (copy2) = WARP_STORAGE.read(loc + 2);
    dict_write{dict_ptr=warp_memory}(mem_start + 2, copy2);
    let (copy3) = WARP_STORAGE.read(loc + 3);
    dict_write{dict_ptr=warp_memory}(mem_start + 3, copy3);
    return (mem_start,);
}

func WS_WRITE0{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt, value: felt
) -> (res: felt) {
    WARP_STORAGE.write(loc, value);
    return (value,);
}

func extern_input_check0{range_check_ptr: felt}(arg: InitializeParams_62e4fbcc) -> () {
    alloc_locals;
    warp_external_input_check_int32(arg.__warp_usrid_00_time);
    warp_external_input_check_int24(arg.__warp_usrid_01_tick);
    warp_external_input_check_int128(arg.__warp_usrid_02_liquidity);
    return ();
}

func extern_input_check1{range_check_ptr: felt}(arg: UpdateParams_a5eebe58) -> () {
    alloc_locals;
    warp_external_input_check_int32(arg.__warp_usrid_03_advanceTimeBy);
    warp_external_input_check_int24(arg.__warp_usrid_04_tick);
    warp_external_input_check_int128(arg.__warp_usrid_05_liquidity);
    return ();
}

func extern_input_check2{range_check_ptr: felt}(len: felt, ptr: UpdateParams_a5eebe58*) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    extern_input_check1(ptr[0]);
    extern_input_check2(len=len - 1, ptr=ptr + 3);
    return ();
}

func extern_input_check3{range_check_ptr: felt}(len: felt, ptr: felt*) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    warp_external_input_check_int32(ptr[0]);
    extern_input_check3(len=len - 1, ptr=ptr + 1);
    return ();
}

func cd_to_memory0_elem{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: felt*, mem_start: felt, length: felt) {
    alloc_locals;
    if (length == 0) {
        return ();
    }
    dict_write{dict_ptr=warp_memory}(mem_start, calldata[0]);
    return cd_to_memory0_elem(calldata + 1, mem_start + 1, length - 1);
}
func cd_to_memory0{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: cd_dynarray_felt) -> (mem_loc: felt) {
    alloc_locals;
    let (len256) = felt_to_uint256(calldata.len);
    let (mem_start) = wm_new(len256, Uint256(0x1, 0x0));
    cd_to_memory0_elem(calldata.ptr, mem_start + 2, calldata.len);
    return (mem_start,);
}

// Contract Def OracleTest

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

namespace OracleTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    const __warp_usrid_06_observations = 0;

    const __warp_usrid_07_time = 262140;

    const __warp_usrid_08_tick = 262141;

    const __warp_usrid_09_liquidity = 262142;

    const __warp_usrid_10_index = 262143;

    const __warp_usrid_11_cardinality = 262144;

    const __warp_usrid_12_cardinalityNext = 262145;

    func __warp_while6{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_81_i: Uint256,
        __warp_usrid_74_secondsAgos: felt,
        __warp_usrid_79_tickCumulatives: felt,
        __warp_usrid_80_secondsPerLiquidityCumulativeX128s: felt,
        __warp_usrid_72_self: felt,
        __warp_usrid_73_time: felt,
        __warp_usrid_75_tick: felt,
        __warp_usrid_76_index: felt,
        __warp_usrid_77_liquidity: felt,
        __warp_usrid_78_cardinality: felt,
    ) -> (
        __warp_usrid_81_i: Uint256,
        __warp_usrid_74_secondsAgos: felt,
        __warp_usrid_79_tickCumulatives: felt,
        __warp_usrid_80_secondsPerLiquidityCumulativeX128s: felt,
        __warp_usrid_72_self: felt,
        __warp_usrid_73_time: felt,
        __warp_usrid_75_tick: felt,
        __warp_usrid_76_index: felt,
        __warp_usrid_77_liquidity: felt,
        __warp_usrid_78_cardinality: felt,
    ) {
        alloc_locals;

        let (__warp_se_0) = wm_dyn_array_length(__warp_usrid_74_secondsAgos);

        let (__warp_se_1) = warp_lt256(__warp_usrid_81_i, __warp_se_0);

        if (__warp_se_1 != 0) {
            let (__warp_se_2) = wm_index_dyn(
                __warp_usrid_74_secondsAgos, __warp_usrid_81_i, Uint256(low=1, high=0)
            );

            let (__warp_se_3) = wm_read_felt(__warp_se_2);

            let (__warp_tv_0, __warp_tv_1) = observeSingle_f7f8d6a0(
                __warp_usrid_72_self,
                __warp_usrid_73_time,
                __warp_se_3,
                __warp_usrid_75_tick,
                __warp_usrid_76_index,
                __warp_usrid_77_liquidity,
                __warp_usrid_78_cardinality,
            );

            let (__warp_se_4) = wm_index_dyn(
                __warp_usrid_80_secondsPerLiquidityCumulativeX128s,
                __warp_usrid_81_i,
                Uint256(low=1, high=0),
            );

            wm_write_felt(__warp_se_4, __warp_tv_1);

            let (__warp_se_5) = wm_index_dyn(
                __warp_usrid_79_tickCumulatives, __warp_usrid_81_i, Uint256(low=1, high=0)
            );

            wm_write_felt(__warp_se_5, __warp_tv_0);

            let (__warp_se_6) = warp_add_unsafe256(__warp_usrid_81_i, Uint256(low=1, high=0));

            let __warp_se_7 = __warp_se_6;

            let __warp_usrid_81_i = __warp_se_7;

            warp_sub_unsafe256(__warp_se_7, Uint256(low=1, high=0));

            let (
                __warp_usrid_81_i,
                __warp_td_0,
                __warp_td_1,
                __warp_td_2,
                __warp_td_3,
                __warp_usrid_73_time,
                __warp_usrid_75_tick,
                __warp_usrid_76_index,
                __warp_usrid_77_liquidity,
                __warp_usrid_78_cardinality,
            ) = __warp_while6_if_part1(
                __warp_usrid_81_i,
                __warp_usrid_74_secondsAgos,
                __warp_usrid_79_tickCumulatives,
                __warp_usrid_80_secondsPerLiquidityCumulativeX128s,
                __warp_usrid_72_self,
                __warp_usrid_73_time,
                __warp_usrid_75_tick,
                __warp_usrid_76_index,
                __warp_usrid_77_liquidity,
                __warp_usrid_78_cardinality,
            );

            let __warp_usrid_74_secondsAgos = __warp_td_0;

            let __warp_usrid_79_tickCumulatives = __warp_td_1;

            let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_td_2;

            let __warp_usrid_72_self = __warp_td_3;

            return (
                __warp_usrid_81_i,
                __warp_usrid_74_secondsAgos,
                __warp_usrid_79_tickCumulatives,
                __warp_usrid_80_secondsPerLiquidityCumulativeX128s,
                __warp_usrid_72_self,
                __warp_usrid_73_time,
                __warp_usrid_75_tick,
                __warp_usrid_76_index,
                __warp_usrid_77_liquidity,
                __warp_usrid_78_cardinality,
            );
        } else {
            let __warp_usrid_81_i = __warp_usrid_81_i;

            let __warp_usrid_74_secondsAgos = __warp_usrid_74_secondsAgos;

            let __warp_usrid_79_tickCumulatives = __warp_usrid_79_tickCumulatives;

            let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_usrid_80_secondsPerLiquidityCumulativeX128s;

            let __warp_usrid_72_self = __warp_usrid_72_self;

            let __warp_usrid_73_time = __warp_usrid_73_time;

            let __warp_usrid_75_tick = __warp_usrid_75_tick;

            let __warp_usrid_76_index = __warp_usrid_76_index;

            let __warp_usrid_77_liquidity = __warp_usrid_77_liquidity;

            let __warp_usrid_78_cardinality = __warp_usrid_78_cardinality;

            return (
                __warp_usrid_81_i,
                __warp_usrid_74_secondsAgos,
                __warp_usrid_79_tickCumulatives,
                __warp_usrid_80_secondsPerLiquidityCumulativeX128s,
                __warp_usrid_72_self,
                __warp_usrid_73_time,
                __warp_usrid_75_tick,
                __warp_usrid_76_index,
                __warp_usrid_77_liquidity,
                __warp_usrid_78_cardinality,
            );
        }
    }

    func __warp_while6_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_81_i: Uint256,
        __warp_usrid_74_secondsAgos: felt,
        __warp_usrid_79_tickCumulatives: felt,
        __warp_usrid_80_secondsPerLiquidityCumulativeX128s: felt,
        __warp_usrid_72_self: felt,
        __warp_usrid_73_time: felt,
        __warp_usrid_75_tick: felt,
        __warp_usrid_76_index: felt,
        __warp_usrid_77_liquidity: felt,
        __warp_usrid_78_cardinality: felt,
    ) -> (
        __warp_usrid_81_i: Uint256,
        __warp_usrid_74_secondsAgos: felt,
        __warp_usrid_79_tickCumulatives: felt,
        __warp_usrid_80_secondsPerLiquidityCumulativeX128s: felt,
        __warp_usrid_72_self: felt,
        __warp_usrid_73_time: felt,
        __warp_usrid_75_tick: felt,
        __warp_usrid_76_index: felt,
        __warp_usrid_77_liquidity: felt,
        __warp_usrid_78_cardinality: felt,
    ) {
        alloc_locals;

        let (
            __warp_usrid_81_i,
            __warp_td_8,
            __warp_td_9,
            __warp_td_10,
            __warp_td_11,
            __warp_usrid_73_time,
            __warp_usrid_75_tick,
            __warp_usrid_76_index,
            __warp_usrid_77_liquidity,
            __warp_usrid_78_cardinality,
        ) = __warp_while6(
            __warp_usrid_81_i,
            __warp_usrid_74_secondsAgos,
            __warp_usrid_79_tickCumulatives,
            __warp_usrid_80_secondsPerLiquidityCumulativeX128s,
            __warp_usrid_72_self,
            __warp_usrid_73_time,
            __warp_usrid_75_tick,
            __warp_usrid_76_index,
            __warp_usrid_77_liquidity,
            __warp_usrid_78_cardinality,
        );

        let __warp_usrid_74_secondsAgos = __warp_td_8;

        let __warp_usrid_79_tickCumulatives = __warp_td_9;

        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_td_10;

        let __warp_usrid_72_self = __warp_td_11;

        return (
            __warp_usrid_81_i,
            __warp_usrid_74_secondsAgos,
            __warp_usrid_79_tickCumulatives,
            __warp_usrid_80_secondsPerLiquidityCumulativeX128s,
            __warp_usrid_72_self,
            __warp_usrid_73_time,
            __warp_usrid_75_tick,
            __warp_usrid_76_index,
            __warp_usrid_77_liquidity,
            __warp_usrid_78_cardinality,
        );
    }

    func __warp_while5{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_46_i: Uint256,
        __warp_usrid_44_l: Uint256,
        __warp_usrid_45_r: Uint256,
        __warp_usrid_42_beforeOrAt: felt,
        __warp_usrid_37_self: felt,
        __warp_usrid_41_cardinality: felt,
        __warp_usrid_43_atOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
    ) -> (
        __warp_usrid_46_i: Uint256,
        __warp_usrid_44_l: Uint256,
        __warp_usrid_45_r: Uint256,
        __warp_usrid_42_beforeOrAt: felt,
        __warp_usrid_37_self: felt,
        __warp_usrid_41_cardinality: felt,
        __warp_usrid_43_atOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
    ) {
        alloc_locals;

        if (1 != 0) {
            let (__warp_se_8) = warp_add_unsafe256(__warp_usrid_44_l, __warp_usrid_45_r);

            let (__warp_se_9) = warp_div_unsafe256(__warp_se_8, Uint256(low=2, high=0));

            let __warp_usrid_46_i = __warp_se_9;

            let (__warp_se_10) = warp_uint256(__warp_usrid_41_cardinality);

            let (__warp_se_11) = warp_mod256(__warp_usrid_46_i, __warp_se_10);

            let (__warp_se_12) = WS0_IDX(
                __warp_usrid_37_self,
                __warp_se_11,
                Uint256(low=4, high=0),
                Uint256(low=65535, high=0),
            );

            let (__warp_se_13) = ws_to_memory0(__warp_se_12);

            let __warp_usrid_42_beforeOrAt = __warp_se_13;

            let (__warp_se_14) = WM0_Observation_2cc4d695___warp_usrid_03_initialized(
                __warp_usrid_42_beforeOrAt
            );

            let (__warp_se_15) = wm_read_felt(__warp_se_14);

            if (1 - __warp_se_15 != 0) {
                let (__warp_se_16) = warp_add_unsafe256(__warp_usrid_46_i, Uint256(low=1, high=0));

                let __warp_usrid_44_l = __warp_se_16;

                let (
                    __warp_usrid_46_i,
                    __warp_usrid_44_l,
                    __warp_usrid_45_r,
                    __warp_td_12,
                    __warp_td_13,
                    __warp_usrid_41_cardinality,
                    __warp_td_14,
                    __warp_usrid_38_time,
                    __warp_usrid_39_target,
                ) = __warp_while5(
                    __warp_usrid_46_i,
                    __warp_usrid_44_l,
                    __warp_usrid_45_r,
                    __warp_usrid_42_beforeOrAt,
                    __warp_usrid_37_self,
                    __warp_usrid_41_cardinality,
                    __warp_usrid_43_atOrAfter,
                    __warp_usrid_38_time,
                    __warp_usrid_39_target,
                );

                let __warp_usrid_42_beforeOrAt = __warp_td_12;

                let __warp_usrid_37_self = __warp_td_13;

                let __warp_usrid_43_atOrAfter = __warp_td_14;

                return (
                    __warp_usrid_46_i,
                    __warp_usrid_44_l,
                    __warp_usrid_45_r,
                    __warp_usrid_42_beforeOrAt,
                    __warp_usrid_37_self,
                    __warp_usrid_41_cardinality,
                    __warp_usrid_43_atOrAfter,
                    __warp_usrid_38_time,
                    __warp_usrid_39_target,
                );
            } else {
                let (
                    __warp_usrid_46_i,
                    __warp_usrid_44_l,
                    __warp_usrid_45_r,
                    __warp_td_18,
                    __warp_td_19,
                    __warp_usrid_41_cardinality,
                    __warp_td_20,
                    __warp_usrid_38_time,
                    __warp_usrid_39_target,
                ) = __warp_while5_if_part2(
                    __warp_usrid_43_atOrAfter,
                    __warp_usrid_37_self,
                    __warp_usrid_46_i,
                    __warp_usrid_41_cardinality,
                    __warp_usrid_38_time,
                    __warp_usrid_42_beforeOrAt,
                    __warp_usrid_39_target,
                    __warp_usrid_44_l,
                    __warp_usrid_45_r,
                );

                let __warp_usrid_42_beforeOrAt = __warp_td_18;

                let __warp_usrid_37_self = __warp_td_19;

                let __warp_usrid_43_atOrAfter = __warp_td_20;

                return (
                    __warp_usrid_46_i,
                    __warp_usrid_44_l,
                    __warp_usrid_45_r,
                    __warp_usrid_42_beforeOrAt,
                    __warp_usrid_37_self,
                    __warp_usrid_41_cardinality,
                    __warp_usrid_43_atOrAfter,
                    __warp_usrid_38_time,
                    __warp_usrid_39_target,
                );
            }
        } else {
            let __warp_usrid_46_i = __warp_usrid_46_i;

            let __warp_usrid_44_l = __warp_usrid_44_l;

            let __warp_usrid_45_r = __warp_usrid_45_r;

            let __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;

            let __warp_usrid_37_self = __warp_usrid_37_self;

            let __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;

            let __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;

            let __warp_usrid_38_time = __warp_usrid_38_time;

            let __warp_usrid_39_target = __warp_usrid_39_target;

            return (
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_45_r,
                __warp_usrid_42_beforeOrAt,
                __warp_usrid_37_self,
                __warp_usrid_41_cardinality,
                __warp_usrid_43_atOrAfter,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            );
        }
    }

    func _conditional0{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        __warp_usrid_47_targetAtOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
        __warp_usrid_43_atOrAfter: felt,
    ) -> (
        ret_conditional0: felt,
        __warp_usrid_47_targetAtOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
        __warp_usrid_43_atOrAfter: felt,
    ) {
        alloc_locals;

        if (__warp_usrid_47_targetAtOrAfter != 0) {
            let (__warp_se_24) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                __warp_usrid_43_atOrAfter
            );

            let (__warp_se_25) = wm_read_felt(__warp_se_24);

            let (__warp_se_26) = lte_34209030(
                __warp_usrid_38_time, __warp_usrid_39_target, __warp_se_25
            );

            let ret_conditional0 = __warp_se_26;

            return (
                ret_conditional0,
                __warp_usrid_47_targetAtOrAfter,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
                __warp_usrid_43_atOrAfter,
            );
        } else {
            let ret_conditional0 = 0;

            return (
                ret_conditional0,
                __warp_usrid_47_targetAtOrAfter,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
                __warp_usrid_43_atOrAfter,
            );
        }
    }

    func __warp_while5_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_43_atOrAfter: felt,
        __warp_usrid_37_self: felt,
        __warp_usrid_46_i: Uint256,
        __warp_usrid_41_cardinality: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_42_beforeOrAt: felt,
        __warp_usrid_39_target: felt,
        __warp_usrid_44_l: Uint256,
        __warp_usrid_45_r: Uint256,
    ) -> (
        __warp_usrid_46_i: Uint256,
        __warp_usrid_44_l: Uint256,
        __warp_usrid_45_r: Uint256,
        __warp_usrid_42_beforeOrAt: felt,
        __warp_usrid_37_self: felt,
        __warp_usrid_41_cardinality: felt,
        __warp_usrid_43_atOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
    ) {
        alloc_locals;

        let (__warp_se_17) = warp_add_unsafe256(__warp_usrid_46_i, Uint256(low=1, high=0));

        let (__warp_se_18) = warp_uint256(__warp_usrid_41_cardinality);

        let (__warp_se_19) = warp_mod256(__warp_se_17, __warp_se_18);

        let (__warp_se_20) = WS0_IDX(
            __warp_usrid_37_self, __warp_se_19, Uint256(low=4, high=0), Uint256(low=65535, high=0)
        );

        let (__warp_se_21) = ws_to_memory0(__warp_se_20);

        let __warp_usrid_43_atOrAfter = __warp_se_21;

        let (__warp_se_22) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_42_beforeOrAt
        );

        let (__warp_se_23) = wm_read_felt(__warp_se_22);

        let (__warp_usrid_47_targetAtOrAfter) = lte_34209030(
            __warp_usrid_38_time, __warp_se_23, __warp_usrid_39_target
        );

        let ret_conditional1 = 0;

        let (
            ret_conditional1,
            __warp_usrid_47_targetAtOrAfter,
            __warp_usrid_38_time,
            __warp_usrid_39_target,
            __warp_usrid_43_atOrAfter,
        ) = _conditional0(
            __warp_usrid_47_targetAtOrAfter,
            __warp_usrid_38_time,
            __warp_usrid_39_target,
            __warp_usrid_43_atOrAfter,
        );

        if (ret_conditional1 != 0) {
            let __warp_usrid_46_i = __warp_usrid_46_i;

            let __warp_usrid_44_l = __warp_usrid_44_l;

            let __warp_usrid_45_r = __warp_usrid_45_r;

            let __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;

            let __warp_usrid_37_self = __warp_usrid_37_self;

            let __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;

            let __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;

            let __warp_usrid_38_time = __warp_usrid_38_time;

            let __warp_usrid_39_target = __warp_usrid_39_target;

            return (
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_45_r,
                __warp_usrid_42_beforeOrAt,
                __warp_usrid_37_self,
                __warp_usrid_41_cardinality,
                __warp_usrid_43_atOrAfter,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            );
        } else {
            let (
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_45_r,
                __warp_td_27,
                __warp_td_28,
                __warp_usrid_41_cardinality,
                __warp_td_29,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            ) = __warp_while5_if_part2_if_part1(
                __warp_usrid_47_targetAtOrAfter,
                __warp_usrid_45_r,
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_42_beforeOrAt,
                __warp_usrid_37_self,
                __warp_usrid_41_cardinality,
                __warp_usrid_43_atOrAfter,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            );

            let __warp_usrid_42_beforeOrAt = __warp_td_27;

            let __warp_usrid_37_self = __warp_td_28;

            let __warp_usrid_43_atOrAfter = __warp_td_29;

            return (
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_45_r,
                __warp_usrid_42_beforeOrAt,
                __warp_usrid_37_self,
                __warp_usrid_41_cardinality,
                __warp_usrid_43_atOrAfter,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            );
        }
    }

    func __warp_while5_if_part2_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_47_targetAtOrAfter: felt,
        __warp_usrid_45_r: Uint256,
        __warp_usrid_46_i: Uint256,
        __warp_usrid_44_l: Uint256,
        __warp_usrid_42_beforeOrAt: felt,
        __warp_usrid_37_self: felt,
        __warp_usrid_41_cardinality: felt,
        __warp_usrid_43_atOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
    ) -> (
        __warp_usrid_46_i: Uint256,
        __warp_usrid_44_l: Uint256,
        __warp_usrid_45_r: Uint256,
        __warp_usrid_42_beforeOrAt: felt,
        __warp_usrid_37_self: felt,
        __warp_usrid_41_cardinality: felt,
        __warp_usrid_43_atOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
    ) {
        alloc_locals;

        if (1 - __warp_usrid_47_targetAtOrAfter != 0) {
            let (__warp_se_27) = warp_sub_unsafe256(__warp_usrid_46_i, Uint256(low=1, high=0));

            let __warp_usrid_45_r = __warp_se_27;

            let (
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_45_r,
                __warp_td_30,
                __warp_td_31,
                __warp_usrid_41_cardinality,
                __warp_td_32,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            ) = __warp_while5_if_part2_if_part1_if_part1(
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_45_r,
                __warp_usrid_42_beforeOrAt,
                __warp_usrid_37_self,
                __warp_usrid_41_cardinality,
                __warp_usrid_43_atOrAfter,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            );

            let __warp_usrid_42_beforeOrAt = __warp_td_30;

            let __warp_usrid_37_self = __warp_td_31;

            let __warp_usrid_43_atOrAfter = __warp_td_32;

            return (
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_45_r,
                __warp_usrid_42_beforeOrAt,
                __warp_usrid_37_self,
                __warp_usrid_41_cardinality,
                __warp_usrid_43_atOrAfter,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            );
        } else {
            let (__warp_se_28) = warp_add_unsafe256(__warp_usrid_46_i, Uint256(low=1, high=0));

            let __warp_usrid_44_l = __warp_se_28;

            let (
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_45_r,
                __warp_td_33,
                __warp_td_34,
                __warp_usrid_41_cardinality,
                __warp_td_35,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            ) = __warp_while5_if_part2_if_part1_if_part1(
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_45_r,
                __warp_usrid_42_beforeOrAt,
                __warp_usrid_37_self,
                __warp_usrid_41_cardinality,
                __warp_usrid_43_atOrAfter,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            );

            let __warp_usrid_42_beforeOrAt = __warp_td_33;

            let __warp_usrid_37_self = __warp_td_34;

            let __warp_usrid_43_atOrAfter = __warp_td_35;

            return (
                __warp_usrid_46_i,
                __warp_usrid_44_l,
                __warp_usrid_45_r,
                __warp_usrid_42_beforeOrAt,
                __warp_usrid_37_self,
                __warp_usrid_41_cardinality,
                __warp_usrid_43_atOrAfter,
                __warp_usrid_38_time,
                __warp_usrid_39_target,
            );
        }
    }

    func __warp_while5_if_part2_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_46_i: Uint256,
        __warp_usrid_44_l: Uint256,
        __warp_usrid_45_r: Uint256,
        __warp_usrid_42_beforeOrAt: felt,
        __warp_usrid_37_self: felt,
        __warp_usrid_41_cardinality: felt,
        __warp_usrid_43_atOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
    ) -> (
        __warp_usrid_46_i: Uint256,
        __warp_usrid_44_l: Uint256,
        __warp_usrid_45_r: Uint256,
        __warp_usrid_42_beforeOrAt: felt,
        __warp_usrid_37_self: felt,
        __warp_usrid_41_cardinality: felt,
        __warp_usrid_43_atOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
    ) {
        alloc_locals;

        let (
            __warp_usrid_46_i,
            __warp_usrid_44_l,
            __warp_usrid_45_r,
            __warp_td_36,
            __warp_td_37,
            __warp_usrid_41_cardinality,
            __warp_td_38,
            __warp_usrid_38_time,
            __warp_usrid_39_target,
        ) = __warp_while5_if_part1(
            __warp_usrid_46_i,
            __warp_usrid_44_l,
            __warp_usrid_45_r,
            __warp_usrid_42_beforeOrAt,
            __warp_usrid_37_self,
            __warp_usrid_41_cardinality,
            __warp_usrid_43_atOrAfter,
            __warp_usrid_38_time,
            __warp_usrid_39_target,
        );

        let __warp_usrid_42_beforeOrAt = __warp_td_36;

        let __warp_usrid_37_self = __warp_td_37;

        let __warp_usrid_43_atOrAfter = __warp_td_38;

        return (
            __warp_usrid_46_i,
            __warp_usrid_44_l,
            __warp_usrid_45_r,
            __warp_usrid_42_beforeOrAt,
            __warp_usrid_37_self,
            __warp_usrid_41_cardinality,
            __warp_usrid_43_atOrAfter,
            __warp_usrid_38_time,
            __warp_usrid_39_target,
        );
    }

    func __warp_while5_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_46_i: Uint256,
        __warp_usrid_44_l: Uint256,
        __warp_usrid_45_r: Uint256,
        __warp_usrid_42_beforeOrAt: felt,
        __warp_usrid_37_self: felt,
        __warp_usrid_41_cardinality: felt,
        __warp_usrid_43_atOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
    ) -> (
        __warp_usrid_46_i: Uint256,
        __warp_usrid_44_l: Uint256,
        __warp_usrid_45_r: Uint256,
        __warp_usrid_42_beforeOrAt: felt,
        __warp_usrid_37_self: felt,
        __warp_usrid_41_cardinality: felt,
        __warp_usrid_43_atOrAfter: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
    ) {
        alloc_locals;

        let (
            __warp_usrid_46_i,
            __warp_usrid_44_l,
            __warp_usrid_45_r,
            __warp_td_39,
            __warp_td_40,
            __warp_usrid_41_cardinality,
            __warp_td_41,
            __warp_usrid_38_time,
            __warp_usrid_39_target,
        ) = __warp_while5(
            __warp_usrid_46_i,
            __warp_usrid_44_l,
            __warp_usrid_45_r,
            __warp_usrid_42_beforeOrAt,
            __warp_usrid_37_self,
            __warp_usrid_41_cardinality,
            __warp_usrid_43_atOrAfter,
            __warp_usrid_38_time,
            __warp_usrid_39_target,
        );

        let __warp_usrid_42_beforeOrAt = __warp_td_39;

        let __warp_usrid_37_self = __warp_td_40;

        let __warp_usrid_43_atOrAfter = __warp_td_41;

        return (
            __warp_usrid_46_i,
            __warp_usrid_44_l,
            __warp_usrid_45_r,
            __warp_usrid_42_beforeOrAt,
            __warp_usrid_37_self,
            __warp_usrid_41_cardinality,
            __warp_usrid_43_atOrAfter,
            __warp_usrid_38_time,
            __warp_usrid_39_target,
        );
    }

    func __warp_while4{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_30_i: felt, __warp_usrid_28_next: felt, __warp_usrid_26_self: felt) -> (
        __warp_usrid_30_i: felt, __warp_usrid_28_next: felt, __warp_usrid_26_self: felt
    ) {
        alloc_locals;

        let (__warp_se_29) = warp_lt(__warp_usrid_30_i, __warp_usrid_28_next);

        if (__warp_se_29 != 0) {
            let (__warp_se_30) = warp_uint256(__warp_usrid_30_i);

            let (__warp_se_31) = WS0_IDX(
                __warp_usrid_26_self,
                __warp_se_30,
                Uint256(low=4, high=0),
                Uint256(low=65535, high=0),
            );

            let (__warp_se_32) = WSM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                __warp_se_31
            );

            WS_WRITE0(__warp_se_32, 1);

            let (__warp_se_33) = warp_add_unsafe16(__warp_usrid_30_i, 1);

            let __warp_se_34 = __warp_se_33;

            let __warp_usrid_30_i = __warp_se_34;

            warp_sub_unsafe16(__warp_se_34, 1);

            let (__warp_usrid_30_i, __warp_usrid_28_next, __warp_td_42) = __warp_while4_if_part1(
                __warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self
            );

            let __warp_usrid_26_self = __warp_td_42;

            return (__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);
        } else {
            let __warp_usrid_30_i = __warp_usrid_30_i;

            let __warp_usrid_28_next = __warp_usrid_28_next;

            let __warp_usrid_26_self = __warp_usrid_26_self;

            return (__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);
        }
    }

    func __warp_while4_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_30_i: felt, __warp_usrid_28_next: felt, __warp_usrid_26_self: felt) -> (
        __warp_usrid_30_i: felt, __warp_usrid_28_next: felt, __warp_usrid_26_self: felt
    ) {
        alloc_locals;

        let (__warp_usrid_30_i, __warp_usrid_28_next, __warp_td_44) = __warp_while4(
            __warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self
        );

        let __warp_usrid_26_self = __warp_td_44;

        return (__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);
    }

    func __warp_while3{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_23_i: Uint256,
        __warp_usrid_16_params_dstruct: cd_dynarray_UpdateParams_a5eebe58,
        __warp_usrid_22__time: felt,
        __warp_usrid_19__index: felt,
        __warp_usrid_20__cardinality: felt,
        __warp_usrid_17__tick: felt,
        __warp_usrid_18__liquidity: felt,
        __warp_usrid_21__cardinalityNext: felt,
    ) -> (
        __warp_usrid_23_i: Uint256,
        __warp_usrid_16_params_dstruct: cd_dynarray_UpdateParams_a5eebe58,
        __warp_usrid_22__time: felt,
        __warp_usrid_19__index: felt,
        __warp_usrid_20__cardinality: felt,
        __warp_usrid_17__tick: felt,
        __warp_usrid_18__liquidity: felt,
        __warp_usrid_21__cardinalityNext: felt,
    ) {
        alloc_locals;

        let (__warp_se_35) = felt_to_uint256(__warp_usrid_16_params_dstruct.len);

        let (__warp_se_36) = warp_lt256(__warp_usrid_23_i, __warp_se_35);

        if (__warp_se_36 != 0) {
            let (__warp_se_37) = warp_int256_to_int248(__warp_usrid_23_i);

            let (__warp_se_38) = warp_add_unsafe32(
                __warp_usrid_22__time,
                __warp_usrid_16_params_dstruct.ptr[__warp_se_37].__warp_usrid_03_advanceTimeBy,
            );

            let __warp_usrid_22__time = __warp_se_38;

            let (__warp_tv_2, __warp_tv_3) = write_9b9fd24c(
                __warp_usrid_06_observations,
                __warp_usrid_19__index,
                __warp_usrid_22__time,
                __warp_usrid_17__tick,
                __warp_usrid_18__liquidity,
                __warp_usrid_20__cardinality,
                __warp_usrid_21__cardinalityNext,
            );

            let __warp_usrid_20__cardinality = __warp_tv_3;

            let __warp_usrid_19__index = __warp_tv_2;

            let (__warp_se_39) = warp_int256_to_int248(__warp_usrid_23_i);

            let __warp_usrid_17__tick = __warp_usrid_16_params_dstruct.ptr[__warp_se_39].__warp_usrid_04_tick;

            let (__warp_se_40) = warp_int256_to_int248(__warp_usrid_23_i);

            let __warp_usrid_18__liquidity = __warp_usrid_16_params_dstruct.ptr[__warp_se_40].__warp_usrid_05_liquidity;

            let (__warp_se_41) = warp_add_unsafe256(__warp_usrid_23_i, Uint256(low=1, high=0));

            let __warp_se_42 = __warp_se_41;

            let __warp_usrid_23_i = __warp_se_42;

            warp_sub_unsafe256(__warp_se_42, Uint256(low=1, high=0));

            let (
                __warp_usrid_23_i,
                __warp_td_45,
                __warp_usrid_22__time,
                __warp_usrid_19__index,
                __warp_usrid_20__cardinality,
                __warp_usrid_17__tick,
                __warp_usrid_18__liquidity,
                __warp_usrid_21__cardinalityNext,
            ) = __warp_while3_if_part1(
                __warp_usrid_23_i,
                __warp_usrid_16_params_dstruct,
                __warp_usrid_22__time,
                __warp_usrid_19__index,
                __warp_usrid_20__cardinality,
                __warp_usrid_17__tick,
                __warp_usrid_18__liquidity,
                __warp_usrid_21__cardinalityNext,
            );

            let __warp_usrid_16_params_dstruct = __warp_td_45;

            return (
                __warp_usrid_23_i,
                __warp_usrid_16_params_dstruct,
                __warp_usrid_22__time,
                __warp_usrid_19__index,
                __warp_usrid_20__cardinality,
                __warp_usrid_17__tick,
                __warp_usrid_18__liquidity,
                __warp_usrid_21__cardinalityNext,
            );
        } else {
            let __warp_usrid_23_i = __warp_usrid_23_i;

            let __warp_usrid_16_params_dstruct = __warp_usrid_16_params_dstruct;

            let __warp_usrid_22__time = __warp_usrid_22__time;

            let __warp_usrid_19__index = __warp_usrid_19__index;

            let __warp_usrid_20__cardinality = __warp_usrid_20__cardinality;

            let __warp_usrid_17__tick = __warp_usrid_17__tick;

            let __warp_usrid_18__liquidity = __warp_usrid_18__liquidity;

            let __warp_usrid_21__cardinalityNext = __warp_usrid_21__cardinalityNext;

            return (
                __warp_usrid_23_i,
                __warp_usrid_16_params_dstruct,
                __warp_usrid_22__time,
                __warp_usrid_19__index,
                __warp_usrid_20__cardinality,
                __warp_usrid_17__tick,
                __warp_usrid_18__liquidity,
                __warp_usrid_21__cardinalityNext,
            );
        }
    }

    func __warp_while3_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_23_i: Uint256,
        __warp_usrid_16_params_dstruct: cd_dynarray_UpdateParams_a5eebe58,
        __warp_usrid_22__time: felt,
        __warp_usrid_19__index: felt,
        __warp_usrid_20__cardinality: felt,
        __warp_usrid_17__tick: felt,
        __warp_usrid_18__liquidity: felt,
        __warp_usrid_21__cardinalityNext: felt,
    ) -> (
        __warp_usrid_23_i: Uint256,
        __warp_usrid_16_params_dstruct: cd_dynarray_UpdateParams_a5eebe58,
        __warp_usrid_22__time: felt,
        __warp_usrid_19__index: felt,
        __warp_usrid_20__cardinality: felt,
        __warp_usrid_17__tick: felt,
        __warp_usrid_18__liquidity: felt,
        __warp_usrid_21__cardinalityNext: felt,
    ) {
        alloc_locals;

        let (
            __warp_usrid_23_i,
            __warp_td_47,
            __warp_usrid_22__time,
            __warp_usrid_19__index,
            __warp_usrid_20__cardinality,
            __warp_usrid_17__tick,
            __warp_usrid_18__liquidity,
            __warp_usrid_21__cardinalityNext,
        ) = __warp_while3(
            __warp_usrid_23_i,
            __warp_usrid_16_params_dstruct,
            __warp_usrid_22__time,
            __warp_usrid_19__index,
            __warp_usrid_20__cardinality,
            __warp_usrid_17__tick,
            __warp_usrid_18__liquidity,
            __warp_usrid_21__cardinalityNext,
        );

        let __warp_usrid_16_params_dstruct = __warp_td_47;

        return (
            __warp_usrid_23_i,
            __warp_usrid_16_params_dstruct,
            __warp_usrid_22__time,
            __warp_usrid_19__index,
            __warp_usrid_20__cardinality,
            __warp_usrid_17__tick,
            __warp_usrid_18__liquidity,
            __warp_usrid_21__cardinalityNext,
        );
    }

    func advanceTime_f7fd2cfa_internal{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_14_by: felt) -> () {
        alloc_locals;

        let (__warp_se_45) = WS0_READ_felt(__warp_usrid_07_time);

        let (__warp_se_46) = warp_add_unsafe32(__warp_se_45, __warp_usrid_14_by);

        WS_WRITE0(__warp_usrid_07_time, __warp_se_46);

        return ();
    }

    // @notice Transforms a previous observation into a new observation, given the passage of time and the current tick and liquidity values
    // @dev blockTimestamp _must_ be chronologically equal to or greater than last.blockTimestamp, safe for 0 or 1 overflows
    // @param last The specified observation to be transformed
    // @param blockTimestamp The timestamp of the new observation
    // @param tick The active tick at the time of the new observation
    // @param liquidity The total in-range liquidity at the time of the new observation
    // @return Observation The newly populated observation
    func transform_44108314{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        __warp_usrid_04_last: felt,
        __warp_usrid_05_blockTimestamp: felt,
        __warp_usrid_06_tick: felt,
        __warp_usrid_07_liquidity: felt,
    ) -> (__warp_usrid_08_: felt) {
        alloc_locals;

        let (__warp_se_73) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_04_last
        );

        let (__warp_se_74) = wm_read_felt(__warp_se_73);

        let (__warp_usrid_09_delta) = warp_sub_unsafe32(
            __warp_usrid_05_blockTimestamp, __warp_se_74
        );

        let (__warp_se_75) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(
            __warp_usrid_04_last
        );

        let (__warp_se_76) = wm_read_felt(__warp_se_75);

        let (__warp_se_77) = warp_int24_to_int56(__warp_usrid_06_tick);

        let (__warp_se_78) = warp_mul_signed_unsafe56(__warp_se_77, __warp_usrid_09_delta);

        let (__warp_se_79) = warp_add_signed_unsafe56(__warp_se_76, __warp_se_78);

        let (
            __warp_se_80
        ) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
            __warp_usrid_04_last
        );

        let (__warp_se_81) = wm_read_felt(__warp_se_80);

        let (__warp_se_82) = warp_shl160(__warp_usrid_09_delta, 128);

        let (__warp_se_83) = conditional0_5bba3b34(__warp_usrid_07_liquidity);

        let (__warp_se_84) = warp_div_unsafe(__warp_se_82, __warp_se_83);

        let (__warp_se_85) = warp_add_unsafe160(__warp_se_81, __warp_se_84);

        let (__warp_se_86) = WM0_struct_Observation_2cc4d695(
            __warp_usrid_05_blockTimestamp, __warp_se_79, __warp_se_85, 1
        );

        return (__warp_se_86,);
    }

    func conditional0_5bba3b34{range_check_ptr: felt}(__warp_usrid_10_liquidity: felt) -> (
        __warp_usrid_11_: felt
    ) {
        alloc_locals;

        let (__warp_se_87) = warp_gt(__warp_usrid_10_liquidity, 0);

        if (__warp_se_87 != 0) {
            return (__warp_usrid_10_liquidity,);
        } else {
            return (1,);
        }
    }

    // @notice Initialize the oracle array by writing the first slot. Called once for the lifecycle of the observations array
    // @param self The stored oracle array
    // @param time The time of the oracle initialization, via block.timestamp truncated to uint32
    // @return cardinality The number of populated elements in the oracle array
    // @return cardinalityNext The new length of the oracle array, independent of population
    func initialize_286f3ae4{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        warp_memory: DictAccess*,
    }(__warp_usrid_12_self: felt, __warp_usrid_13_time: felt) -> (
        __warp_usrid_14_cardinality: felt, __warp_usrid_15_cardinalityNext: felt
    ) {
        alloc_locals;

        let (__warp_se_88) = WS0_IDX(
            __warp_usrid_12_self,
            Uint256(low=0, high=0),
            Uint256(low=4, high=0),
            Uint256(low=65535, high=0),
        );

        let (__warp_se_89) = WM0_struct_Observation_2cc4d695(__warp_usrid_13_time, 0, 0, 1);

        wm_to_storage0(__warp_se_88, __warp_se_89);

        let __warp_usrid_14_cardinality = 1;

        let __warp_usrid_15_cardinalityNext = 1;

        return (__warp_usrid_14_cardinality, __warp_usrid_15_cardinalityNext);
    }

    // @notice Writes an oracle observation to the array
    // @dev Writable at most once per block. Index represents the most recently written element. cardinality and index must be tracked externally.
    // If the index is at the end of the allowable array length (according to cardinality), and the next cardinality
    // is greater than the current one, cardinality may be increased. This restriction is created to preserve ordering.
    // @param self The stored oracle array
    // @param index The index of the observation that was most recently written to the observations array
    // @param blockTimestamp The timestamp of the new observation
    // @param tick The active tick at the time of the new observation
    // @param liquidity The total in-range liquidity at the time of the new observation
    // @param cardinality The number of populated elements in the oracle array
    // @param cardinalityNext The new length of the oracle array, independent of population
    // @return indexUpdated The new index of the most recently written element in the oracle array
    // @return cardinalityUpdated The new cardinality of the oracle array
    func write_9b9fd24c{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_16_self: felt,
        __warp_usrid_17_index: felt,
        __warp_usrid_18_blockTimestamp: felt,
        __warp_usrid_19_tick: felt,
        __warp_usrid_20_liquidity: felt,
        __warp_usrid_21_cardinality: felt,
        __warp_usrid_22_cardinalityNext: felt,
    ) -> (__warp_usrid_23_indexUpdated: felt, __warp_usrid_24_cardinalityUpdated: felt) {
        alloc_locals;

        let __warp_usrid_23_indexUpdated = 0;

        let __warp_usrid_24_cardinalityUpdated = 0;

        let (__warp_se_90) = warp_uint256(__warp_usrid_17_index);

        let (__warp_se_91) = WS0_IDX(
            __warp_usrid_16_self, __warp_se_90, Uint256(low=4, high=0), Uint256(low=65535, high=0)
        );

        let (__warp_usrid_25_last) = ws_to_memory0(__warp_se_91);

        let (__warp_se_92) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_25_last
        );

        let (__warp_se_93) = wm_read_felt(__warp_se_92);

        let (__warp_se_94) = warp_eq(__warp_se_93, __warp_usrid_18_blockTimestamp);

        if (__warp_se_94 != 0) {
            let __warp_usrid_23_indexUpdated = __warp_usrid_17_index;

            let __warp_usrid_24_cardinalityUpdated = __warp_usrid_21_cardinality;

            return (__warp_usrid_23_indexUpdated, __warp_usrid_24_cardinalityUpdated);
        } else {
            let (
                __warp_usrid_23_indexUpdated, __warp_usrid_24_cardinalityUpdated
            ) = write_9b9fd24c_if_part1(
                __warp_usrid_22_cardinalityNext,
                __warp_usrid_21_cardinality,
                __warp_usrid_17_index,
                __warp_usrid_24_cardinalityUpdated,
                __warp_usrid_23_indexUpdated,
                __warp_usrid_16_self,
                __warp_usrid_25_last,
                __warp_usrid_18_blockTimestamp,
                __warp_usrid_19_tick,
                __warp_usrid_20_liquidity,
            );

            return (__warp_usrid_23_indexUpdated, __warp_usrid_24_cardinalityUpdated);
        }
    }

    func write_9b9fd24c_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_22_cardinalityNext: felt,
        __warp_usrid_21_cardinality: felt,
        __warp_usrid_17_index: felt,
        __warp_usrid_24_cardinalityUpdated: felt,
        __warp_usrid_23_indexUpdated: felt,
        __warp_usrid_16_self: felt,
        __warp_usrid_25_last: felt,
        __warp_usrid_18_blockTimestamp: felt,
        __warp_usrid_19_tick: felt,
        __warp_usrid_20_liquidity: felt,
    ) -> (__warp_usrid_23_indexUpdated: felt, __warp_usrid_24_cardinalityUpdated: felt) {
        alloc_locals;

        let (__warp_se_95) = warp_gt(__warp_usrid_22_cardinalityNext, __warp_usrid_21_cardinality);

        let (__warp_se_96) = warp_sub_unsafe16(__warp_usrid_21_cardinality, 1);

        let (__warp_se_97) = warp_eq(__warp_usrid_17_index, __warp_se_96);

        let (__warp_se_98) = warp_and_(__warp_se_95, __warp_se_97);

        if (__warp_se_98 != 0) {
            let __warp_usrid_24_cardinalityUpdated = __warp_usrid_22_cardinalityNext;

            let (
                __warp_usrid_23_indexUpdated, __warp_usrid_24_cardinalityUpdated
            ) = write_9b9fd24c_if_part1_if_part1(
                __warp_usrid_23_indexUpdated,
                __warp_usrid_17_index,
                __warp_usrid_24_cardinalityUpdated,
                __warp_usrid_16_self,
                __warp_usrid_25_last,
                __warp_usrid_18_blockTimestamp,
                __warp_usrid_19_tick,
                __warp_usrid_20_liquidity,
            );

            return (__warp_usrid_23_indexUpdated, __warp_usrid_24_cardinalityUpdated);
        } else {
            let __warp_usrid_24_cardinalityUpdated = __warp_usrid_21_cardinality;

            let (
                __warp_usrid_23_indexUpdated, __warp_usrid_24_cardinalityUpdated
            ) = write_9b9fd24c_if_part1_if_part1(
                __warp_usrid_23_indexUpdated,
                __warp_usrid_17_index,
                __warp_usrid_24_cardinalityUpdated,
                __warp_usrid_16_self,
                __warp_usrid_25_last,
                __warp_usrid_18_blockTimestamp,
                __warp_usrid_19_tick,
                __warp_usrid_20_liquidity,
            );

            return (__warp_usrid_23_indexUpdated, __warp_usrid_24_cardinalityUpdated);
        }
    }

    func write_9b9fd24c_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_23_indexUpdated: felt,
        __warp_usrid_17_index: felt,
        __warp_usrid_24_cardinalityUpdated: felt,
        __warp_usrid_16_self: felt,
        __warp_usrid_25_last: felt,
        __warp_usrid_18_blockTimestamp: felt,
        __warp_usrid_19_tick: felt,
        __warp_usrid_20_liquidity: felt,
    ) -> (__warp_usrid_23_indexUpdated: felt, __warp_usrid_24_cardinalityUpdated: felt) {
        alloc_locals;

        let (__warp_se_99) = warp_add_unsafe16(__warp_usrid_17_index, 1);

        let (__warp_se_100) = warp_mod(__warp_se_99, __warp_usrid_24_cardinalityUpdated);

        let __warp_usrid_23_indexUpdated = __warp_se_100;

        let (__warp_se_101) = warp_uint256(__warp_usrid_23_indexUpdated);

        let (__warp_se_102) = WS0_IDX(
            __warp_usrid_16_self, __warp_se_101, Uint256(low=4, high=0), Uint256(low=65535, high=0)
        );

        let (__warp_se_103) = transform_44108314(
            __warp_usrid_25_last,
            __warp_usrid_18_blockTimestamp,
            __warp_usrid_19_tick,
            __warp_usrid_20_liquidity,
        );

        wm_to_storage0(__warp_se_102, __warp_se_103);

        let __warp_usrid_23_indexUpdated = __warp_usrid_23_indexUpdated;

        let __warp_usrid_24_cardinalityUpdated = __warp_usrid_24_cardinalityUpdated;

        return (__warp_usrid_23_indexUpdated, __warp_usrid_24_cardinalityUpdated);
    }

    // @notice Prepares the oracle array to store up to `next` observations
    // @param self The stored oracle array
    // @param current The current next cardinality of the oracle array
    // @param next The proposed next cardinality which will be populated in the oracle array
    // @return next The next cardinality which will be populated in the oracle array
    func grow_48fc651e{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_26_self: felt, __warp_usrid_27_current: felt, __warp_usrid_28_next: felt) -> (
        __warp_usrid_29_: felt
    ) {
        alloc_locals;

        let (__warp_se_104) = warp_gt(__warp_usrid_27_current, 0);

        with_attr error_message("I") {
            assert __warp_se_104 = 1;
        }

        let (__warp_se_105) = warp_le(__warp_usrid_28_next, __warp_usrid_27_current);

        if (__warp_se_105 != 0) {
            return (__warp_usrid_27_current,);
        } else {
            let (__warp_se_106) = grow_48fc651e_if_part1(
                __warp_usrid_27_current, __warp_usrid_28_next, __warp_usrid_26_self
            );

            return (__warp_se_106,);
        }
    }

    func grow_48fc651e_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_27_current: felt, __warp_usrid_28_next: felt, __warp_usrid_26_self: felt) -> (
        __warp_usrid_29_: felt
    ) {
        alloc_locals;

        let __warp_usrid_30_i = __warp_usrid_27_current;

        let (__warp_tv_16, __warp_tv_17, __warp_td_51) = __warp_while4(
            __warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self
        );

        let __warp_tv_18 = __warp_td_51;

        let __warp_usrid_26_self = __warp_tv_18;

        let __warp_usrid_28_next = __warp_tv_17;

        let __warp_usrid_30_i = __warp_tv_16;

        return (__warp_usrid_28_next,);
    }

    // @notice comparator for 32-bit timestamps
    // @dev safe for 0 or 1 overflows, a and b _must_ be chronologically before or equal to time
    // @param time A timestamp truncated to 32 bits
    // @param a A comparison timestamp from which to determine the relative position of `time`
    // @param b From which to determine the relative position of `time`
    // @return bool Whether `a` is chronologically <= `b`
    func lte_34209030{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_31_time: felt, __warp_usrid_32_a: felt, __warp_usrid_33_b: felt
    ) -> (__warp_usrid_34_: felt) {
        alloc_locals;

        let (__warp_se_107) = warp_le(__warp_usrid_32_a, __warp_usrid_31_time);

        let (__warp_se_108) = warp_le(__warp_usrid_33_b, __warp_usrid_31_time);

        let (__warp_se_109) = warp_and_(__warp_se_107, __warp_se_108);

        if (__warp_se_109 != 0) {
            let (__warp_se_110) = warp_le(__warp_usrid_32_a, __warp_usrid_33_b);

            return (__warp_se_110,);
        } else {
            let (__warp_se_111) = lte_34209030_if_part1(
                __warp_usrid_32_a, __warp_usrid_31_time, __warp_usrid_33_b
            );

            return (__warp_se_111,);
        }
    }

    func lte_34209030_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_32_a: felt, __warp_usrid_31_time: felt, __warp_usrid_33_b: felt
    ) -> (__warp_usrid_34_: felt) {
        alloc_locals;

        let (__warp_se_112) = warp_add_unsafe40(__warp_usrid_32_a, 4294967296);

        let (__warp_usrid_35_aAdjusted) = warp_uint256(__warp_se_112);

        let (__warp_se_113) = warp_gt(__warp_usrid_32_a, __warp_usrid_31_time);

        if (__warp_se_113 != 0) {
            let (__warp_se_114) = warp_uint256(__warp_usrid_32_a);

            let __warp_usrid_35_aAdjusted = __warp_se_114;

            let (__warp_se_115) = lte_34209030_if_part1_if_part1(
                __warp_usrid_33_b, __warp_usrid_31_time, __warp_usrid_35_aAdjusted
            );

            return (__warp_se_115,);
        } else {
            let (__warp_se_116) = lte_34209030_if_part1_if_part1(
                __warp_usrid_33_b, __warp_usrid_31_time, __warp_usrid_35_aAdjusted
            );

            return (__warp_se_116,);
        }
    }

    func lte_34209030_if_part1_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_33_b: felt, __warp_usrid_31_time: felt, __warp_usrid_35_aAdjusted: Uint256
    ) -> (__warp_usrid_34_: felt) {
        alloc_locals;

        let (__warp_se_117) = warp_add_unsafe40(__warp_usrid_33_b, 4294967296);

        let (__warp_usrid_36_bAdjusted) = warp_uint256(__warp_se_117);

        let (__warp_se_118) = warp_gt(__warp_usrid_33_b, __warp_usrid_31_time);

        if (__warp_se_118 != 0) {
            let (__warp_se_119) = warp_uint256(__warp_usrid_33_b);

            let __warp_usrid_36_bAdjusted = __warp_se_119;

            let (__warp_se_120) = lte_34209030_if_part1_if_part1_if_part1(
                __warp_usrid_35_aAdjusted, __warp_usrid_36_bAdjusted
            );

            return (__warp_se_120,);
        } else {
            let (__warp_se_121) = lte_34209030_if_part1_if_part1_if_part1(
                __warp_usrid_35_aAdjusted, __warp_usrid_36_bAdjusted
            );

            return (__warp_se_121,);
        }
    }

    func lte_34209030_if_part1_if_part1_if_part1{range_check_ptr: felt}(
        __warp_usrid_35_aAdjusted: Uint256, __warp_usrid_36_bAdjusted: Uint256
    ) -> (__warp_usrid_34_: felt) {
        alloc_locals;

        let (__warp_se_122) = warp_le256(__warp_usrid_35_aAdjusted, __warp_usrid_36_bAdjusted);

        return (__warp_se_122,);
    }

    // @notice Fetches the observations beforeOrAt and atOrAfter a target, i.e. where [beforeOrAt, atOrAfter] is satisfied.
    // The result may be the same observation, or adjacent observations.
    // @dev The answer must be contained in the array, used when the target is located within the stored observation
    // boundaries: older than the most recent observation and younger, or the same age as, the oldest observation
    // @param self The stored oracle array
    // @param time The current block.timestamp
    // @param target The timestamp at which the reserved observation should be for
    // @param index The index of the observation that was most recently written to the observations array
    // @param cardinality The number of populated elements in the oracle array
    // @return beforeOrAt The observation recorded before, or at, the target
    // @return atOrAfter The observation recorded at, or after, the target
    func binarySearch_c698fcdd{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_37_self: felt,
        __warp_usrid_38_time: felt,
        __warp_usrid_39_target: felt,
        __warp_usrid_40_index: felt,
        __warp_usrid_41_cardinality: felt,
    ) -> (__warp_usrid_42_beforeOrAt: felt, __warp_usrid_43_atOrAfter: felt) {
        alloc_locals;

        let (__warp_usrid_43_atOrAfter) = WM0_struct_Observation_2cc4d695(0, 0, 0, 0);

        let (__warp_usrid_42_beforeOrAt) = WM0_struct_Observation_2cc4d695(0, 0, 0, 0);

        let (__warp_se_123) = warp_add_unsafe16(__warp_usrid_40_index, 1);

        let (__warp_se_124) = warp_mod(__warp_se_123, __warp_usrid_41_cardinality);

        let (__warp_usrid_44_l) = warp_uint256(__warp_se_124);

        let (__warp_se_125) = warp_uint256(__warp_usrid_41_cardinality);

        let (__warp_se_126) = warp_add_unsafe256(__warp_usrid_44_l, __warp_se_125);

        let (__warp_usrid_45_r) = warp_sub_unsafe256(__warp_se_126, Uint256(low=1, high=0));

        let __warp_usrid_46_i = Uint256(low=0, high=0);

        let (
            __warp_tv_19,
            __warp_tv_20,
            __warp_tv_21,
            __warp_td_52,
            __warp_td_53,
            __warp_tv_24,
            __warp_td_54,
            __warp_tv_26,
            __warp_tv_27,
        ) = __warp_while5(
            __warp_usrid_46_i,
            __warp_usrid_44_l,
            __warp_usrid_45_r,
            __warp_usrid_42_beforeOrAt,
            __warp_usrid_37_self,
            __warp_usrid_41_cardinality,
            __warp_usrid_43_atOrAfter,
            __warp_usrid_38_time,
            __warp_usrid_39_target,
        );

        let __warp_tv_22 = __warp_td_52;

        let __warp_tv_23 = __warp_td_53;

        let __warp_tv_25 = __warp_td_54;

        let __warp_usrid_39_target = __warp_tv_27;

        let __warp_usrid_38_time = __warp_tv_26;

        let __warp_usrid_43_atOrAfter = __warp_tv_25;

        let __warp_usrid_41_cardinality = __warp_tv_24;

        let __warp_usrid_37_self = __warp_tv_23;

        let __warp_usrid_42_beforeOrAt = __warp_tv_22;

        let __warp_usrid_45_r = __warp_tv_21;

        let __warp_usrid_44_l = __warp_tv_20;

        let __warp_usrid_46_i = __warp_tv_19;

        let __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;

        let __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;

        return (__warp_usrid_42_beforeOrAt, __warp_usrid_43_atOrAfter);
    }

    // @notice Fetches the observations beforeOrAt and atOrAfter a given target, i.e. where [beforeOrAt, atOrAfter] is satisfied
    // @dev Assumes there is at least 1 initialized observation.
    // Used by observeSingle() to compute the counterfactual accumulator values as of a given block timestamp.
    // @param self The stored oracle array
    // @param time The current block.timestamp
    // @param target The timestamp at which the reserved observation should be for
    // @param tick The active tick at the time of the returned or simulated observation
    // @param index The index of the observation that was most recently written to the observations array
    // @param liquidity The total pool liquidity at the time of the call
    // @param cardinality The number of populated elements in the oracle array
    // @return beforeOrAt The observation which occurred at, or before, the given timestamp
    // @return atOrAfter The observation which occurred at, or after, the given timestamp
    func getSurroundingObservations_68850d1b{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_48_self: felt,
        __warp_usrid_49_time: felt,
        __warp_usrid_50_target: felt,
        __warp_usrid_51_tick: felt,
        __warp_usrid_52_index: felt,
        __warp_usrid_53_liquidity: felt,
        __warp_usrid_54_cardinality: felt,
    ) -> (__warp_usrid_55_beforeOrAt: felt, __warp_usrid_56_atOrAfter: felt) {
        alloc_locals;

        let (__warp_usrid_56_atOrAfter) = WM0_struct_Observation_2cc4d695(0, 0, 0, 0);

        let (__warp_usrid_55_beforeOrAt) = WM0_struct_Observation_2cc4d695(0, 0, 0, 0);

        let (__warp_se_127) = warp_uint256(__warp_usrid_52_index);

        let (__warp_se_128) = WS0_IDX(
            __warp_usrid_48_self, __warp_se_127, Uint256(low=4, high=0), Uint256(low=65535, high=0)
        );

        let (__warp_se_129) = ws_to_memory0(__warp_se_128);

        let __warp_usrid_55_beforeOrAt = __warp_se_129;

        let (__warp_se_130) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_55_beforeOrAt
        );

        let (__warp_se_131) = wm_read_felt(__warp_se_130);

        let (__warp_se_132) = lte_34209030(
            __warp_usrid_49_time, __warp_se_131, __warp_usrid_50_target
        );

        if (__warp_se_132 != 0) {
            let (__warp_se_133) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                __warp_usrid_55_beforeOrAt
            );

            let (__warp_se_134) = wm_read_felt(__warp_se_133);

            let (__warp_se_135) = warp_eq(__warp_se_134, __warp_usrid_50_target);

            if (__warp_se_135 != 0) {
                let __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;

                let __warp_usrid_56_atOrAfter = __warp_usrid_56_atOrAfter;

                return (__warp_usrid_55_beforeOrAt, __warp_usrid_56_atOrAfter);
            } else {
                let __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;

                let (__warp_usrid_56_atOrAfter) = transform_44108314(
                    __warp_usrid_55_beforeOrAt,
                    __warp_usrid_50_target,
                    __warp_usrid_51_tick,
                    __warp_usrid_53_liquidity,
                );

                return (__warp_usrid_55_beforeOrAt, __warp_usrid_56_atOrAfter);
            }
        } else {
            let (__warp_td_59, __warp_td_60) = getSurroundingObservations_68850d1b_if_part1(
                __warp_usrid_55_beforeOrAt,
                __warp_usrid_48_self,
                __warp_usrid_52_index,
                __warp_usrid_54_cardinality,
                __warp_usrid_49_time,
                __warp_usrid_50_target,
            );

            let __warp_usrid_55_beforeOrAt = __warp_td_59;

            let __warp_usrid_56_atOrAfter = __warp_td_60;

            return (__warp_usrid_55_beforeOrAt, __warp_usrid_56_atOrAfter);
        }
    }

    func getSurroundingObservations_68850d1b_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_55_beforeOrAt: felt,
        __warp_usrid_48_self: felt,
        __warp_usrid_52_index: felt,
        __warp_usrid_54_cardinality: felt,
        __warp_usrid_49_time: felt,
        __warp_usrid_50_target: felt,
    ) -> (__warp_usrid_55_beforeOrAt: felt, __warp_usrid_56_atOrAfter: felt) {
        alloc_locals;

        let (__warp_se_136) = warp_add_unsafe16(__warp_usrid_52_index, 1);

        let (__warp_se_137) = warp_mod(__warp_se_136, __warp_usrid_54_cardinality);

        let (__warp_se_138) = warp_uint256(__warp_se_137);

        let (__warp_se_139) = WS0_IDX(
            __warp_usrid_48_self, __warp_se_138, Uint256(low=4, high=0), Uint256(low=65535, high=0)
        );

        let (__warp_se_140) = ws_to_memory0(__warp_se_139);

        let __warp_usrid_55_beforeOrAt = __warp_se_140;

        let (__warp_se_141) = WM0_Observation_2cc4d695___warp_usrid_03_initialized(
            __warp_usrid_55_beforeOrAt
        );

        let (__warp_se_142) = wm_read_felt(__warp_se_141);

        if (1 - __warp_se_142 != 0) {
            let (__warp_se_143) = WS0_IDX(
                __warp_usrid_48_self,
                Uint256(low=0, high=0),
                Uint256(low=4, high=0),
                Uint256(low=65535, high=0),
            );

            let (__warp_se_144) = ws_to_memory0(__warp_se_143);

            let __warp_usrid_55_beforeOrAt = __warp_se_144;

            let (
                __warp_td_63, __warp_td_64
            ) = getSurroundingObservations_68850d1b_if_part1_if_part1(
                __warp_usrid_49_time,
                __warp_usrid_55_beforeOrAt,
                __warp_usrid_50_target,
                __warp_usrid_48_self,
                __warp_usrid_52_index,
                __warp_usrid_54_cardinality,
            );

            let __warp_usrid_55_beforeOrAt = __warp_td_63;

            let __warp_usrid_56_atOrAfter = __warp_td_64;

            return (__warp_usrid_55_beforeOrAt, __warp_usrid_56_atOrAfter);
        } else {
            let (
                __warp_td_65, __warp_td_66
            ) = getSurroundingObservations_68850d1b_if_part1_if_part1(
                __warp_usrid_49_time,
                __warp_usrid_55_beforeOrAt,
                __warp_usrid_50_target,
                __warp_usrid_48_self,
                __warp_usrid_52_index,
                __warp_usrid_54_cardinality,
            );

            let __warp_usrid_55_beforeOrAt = __warp_td_65;

            let __warp_usrid_56_atOrAfter = __warp_td_66;

            return (__warp_usrid_55_beforeOrAt, __warp_usrid_56_atOrAfter);
        }
    }

    func getSurroundingObservations_68850d1b_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_49_time: felt,
        __warp_usrid_55_beforeOrAt: felt,
        __warp_usrid_50_target: felt,
        __warp_usrid_48_self: felt,
        __warp_usrid_52_index: felt,
        __warp_usrid_54_cardinality: felt,
    ) -> (__warp_usrid_55_beforeOrAt: felt, __warp_usrid_56_atOrAfter: felt) {
        alloc_locals;

        let (__warp_se_145) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_55_beforeOrAt
        );

        let (__warp_se_146) = wm_read_felt(__warp_se_145);

        let (__warp_se_147) = lte_34209030(
            __warp_usrid_49_time, __warp_se_146, __warp_usrid_50_target
        );

        with_attr error_message("OLD") {
            assert __warp_se_147 = 1;
        }

        let (__warp_td_67, __warp_td_68) = binarySearch_c698fcdd(
            __warp_usrid_48_self,
            __warp_usrid_49_time,
            __warp_usrid_50_target,
            __warp_usrid_52_index,
            __warp_usrid_54_cardinality,
        );

        let __warp_usrid_55_beforeOrAt = __warp_td_67;

        let __warp_usrid_56_atOrAfter = __warp_td_68;

        return (__warp_usrid_55_beforeOrAt, __warp_usrid_56_atOrAfter);
    }

    // @dev Reverts if an observation at or before the desired observation timestamp does not exist.
    // 0 may be passed as `secondsAgo' to return the current cumulative values.
    // If called with a timestamp falling between two observations, returns the counterfactual accumulator values
    // at exactly the timestamp between the two observations.
    // @param self The stored oracle array
    // @param time The current block timestamp
    // @param secondsAgo The amount of time to look back, in seconds, at which point to return an observation
    // @param tick The current tick
    // @param index The index of the observation that was most recently written to the observations array
    // @param liquidity The current in-range pool liquidity
    // @param cardinality The number of populated elements in the oracle array
    // @return tickCumulative The tick * time elapsed since the pool was first initialized, as of `secondsAgo`
    // @return secondsPerLiquidityCumulativeX128 The time elapsed / max(1, liquidity) since the pool was first initialized, as of `secondsAgo`
    func observeSingle_f7f8d6a0{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_57_self: felt,
        __warp_usrid_58_time: felt,
        __warp_usrid_59_secondsAgo: felt,
        __warp_usrid_60_tick: felt,
        __warp_usrid_61_index: felt,
        __warp_usrid_62_liquidity: felt,
        __warp_usrid_63_cardinality: felt,
    ) -> (
        __warp_usrid_64_tickCumulative: felt,
        __warp_usrid_65_secondsPerLiquidityCumulativeX128: felt,
    ) {
        alloc_locals;

        let (__warp_se_148) = warp_eq(__warp_usrid_59_secondsAgo, 0);

        if (__warp_se_148 != 0) {
            let (__warp_se_149) = warp_uint256(__warp_usrid_61_index);

            let (__warp_se_150) = WS0_IDX(
                __warp_usrid_57_self,
                __warp_se_149,
                Uint256(low=4, high=0),
                Uint256(low=65535, high=0),
            );

            let (__warp_usrid_66_last) = ws_to_memory0(__warp_se_150);

            let (__warp_se_151) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                __warp_usrid_66_last
            );

            let (__warp_se_152) = wm_read_felt(__warp_se_151);

            let (__warp_se_153) = warp_neq(__warp_se_152, __warp_usrid_58_time);

            if (__warp_se_153 != 0) {
                let (__warp_se_154) = transform_44108314(
                    __warp_usrid_66_last,
                    __warp_usrid_58_time,
                    __warp_usrid_60_tick,
                    __warp_usrid_62_liquidity,
                );

                let __warp_usrid_66_last = __warp_se_154;

                let (
                    __warp_usrid_64_tickCumulative,
                    __warp_usrid_65_secondsPerLiquidityCumulativeX128,
                ) = observeSingle_f7f8d6a0_if_part2(
                    __warp_usrid_66_last,
                    __warp_usrid_58_time,
                    __warp_usrid_59_secondsAgo,
                    __warp_usrid_57_self,
                    __warp_usrid_60_tick,
                    __warp_usrid_61_index,
                    __warp_usrid_62_liquidity,
                    __warp_usrid_63_cardinality,
                );

                return (
                    __warp_usrid_64_tickCumulative,
                    __warp_usrid_65_secondsPerLiquidityCumulativeX128,
                );
            } else {
                let (
                    __warp_usrid_64_tickCumulative,
                    __warp_usrid_65_secondsPerLiquidityCumulativeX128,
                ) = observeSingle_f7f8d6a0_if_part2(
                    __warp_usrid_66_last,
                    __warp_usrid_58_time,
                    __warp_usrid_59_secondsAgo,
                    __warp_usrid_57_self,
                    __warp_usrid_60_tick,
                    __warp_usrid_61_index,
                    __warp_usrid_62_liquidity,
                    __warp_usrid_63_cardinality,
                );

                return (
                    __warp_usrid_64_tickCumulative,
                    __warp_usrid_65_secondsPerLiquidityCumulativeX128,
                );
            }
        } else {
            let (
                __warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128
            ) = observeSingle_f7f8d6a0_if_part1(
                __warp_usrid_58_time,
                __warp_usrid_59_secondsAgo,
                __warp_usrid_57_self,
                __warp_usrid_60_tick,
                __warp_usrid_61_index,
                __warp_usrid_62_liquidity,
                __warp_usrid_63_cardinality,
            );

            return (
                __warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128
            );
        }
    }

    func observeSingle_f7f8d6a0_if_part2{range_check_ptr: felt, warp_memory: DictAccess*}(
        __warp_usrid_66_last: felt,
        __warp_usrid_58_time: felt,
        __warp_usrid_59_secondsAgo: felt,
        __warp_usrid_57_self: felt,
        __warp_usrid_60_tick: felt,
        __warp_usrid_61_index: felt,
        __warp_usrid_62_liquidity: felt,
        __warp_usrid_63_cardinality: felt,
    ) -> (
        __warp_usrid_64_tickCumulative: felt,
        __warp_usrid_65_secondsPerLiquidityCumulativeX128: felt,
    ) {
        alloc_locals;

        let (__warp_se_155) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(
            __warp_usrid_66_last
        );

        let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_155);

        let (
            __warp_se_156
        ) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
            __warp_usrid_66_last
        );

        let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(__warp_se_156);

        return (__warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128);
    }

    func observeSingle_f7f8d6a0_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_58_time: felt,
        __warp_usrid_59_secondsAgo: felt,
        __warp_usrid_57_self: felt,
        __warp_usrid_60_tick: felt,
        __warp_usrid_61_index: felt,
        __warp_usrid_62_liquidity: felt,
        __warp_usrid_63_cardinality: felt,
    ) -> (
        __warp_usrid_64_tickCumulative: felt,
        __warp_usrid_65_secondsPerLiquidityCumulativeX128: felt,
    ) {
        alloc_locals;

        let (__warp_usrid_67_target) = warp_sub_unsafe32(
            __warp_usrid_58_time, __warp_usrid_59_secondsAgo
        );

        let (__warp_td_69, __warp_td_70) = getSurroundingObservations_68850d1b(
            __warp_usrid_57_self,
            __warp_usrid_58_time,
            __warp_usrid_67_target,
            __warp_usrid_60_tick,
            __warp_usrid_61_index,
            __warp_usrid_62_liquidity,
            __warp_usrid_63_cardinality,
        );

        let __warp_usrid_68_beforeOrAt = __warp_td_69;

        let __warp_usrid_69_atOrAfter = __warp_td_70;

        let (__warp_se_157) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_68_beforeOrAt
        );

        let (__warp_se_158) = wm_read_felt(__warp_se_157);

        let (__warp_se_159) = warp_eq(__warp_usrid_67_target, __warp_se_158);

        if (__warp_se_159 != 0) {
            let (__warp_se_160) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(
                __warp_usrid_68_beforeOrAt
            );

            let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_160);

            let (
                __warp_se_161
            ) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
                __warp_usrid_68_beforeOrAt
            );

            let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(__warp_se_161);

            return (
                __warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128
            );
        } else {
            let (__warp_se_162) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                __warp_usrid_69_atOrAfter
            );

            let (__warp_se_163) = wm_read_felt(__warp_se_162);

            let (__warp_se_164) = warp_eq(__warp_usrid_67_target, __warp_se_163);

            if (__warp_se_164 != 0) {
                let (__warp_se_165) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(
                    __warp_usrid_69_atOrAfter
                );

                let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_165);

                let (
                    __warp_se_166
                ) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
                    __warp_usrid_69_atOrAfter
                );

                let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(
                    __warp_se_166
                );

                return (
                    __warp_usrid_64_tickCumulative,
                    __warp_usrid_65_secondsPerLiquidityCumulativeX128,
                );
            } else {
                let (__warp_se_167) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                    __warp_usrid_69_atOrAfter
                );

                let (__warp_se_168) = wm_read_felt(__warp_se_167);

                let (__warp_se_169) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_170) = wm_read_felt(__warp_se_169);

                let (__warp_usrid_70_observationTimeDelta) = warp_sub_unsafe32(
                    __warp_se_168, __warp_se_170
                );

                let (__warp_se_171) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_172) = wm_read_felt(__warp_se_171);

                let (__warp_usrid_71_targetDelta) = warp_sub_unsafe32(
                    __warp_usrid_67_target, __warp_se_172
                );

                let (__warp_se_173) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_174) = wm_read_felt(__warp_se_173);

                let (__warp_se_175) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(
                    __warp_usrid_69_atOrAfter
                );

                let (__warp_se_176) = wm_read_felt(__warp_se_175);

                let (__warp_se_177) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_178) = wm_read_felt(__warp_se_177);

                let (__warp_se_179) = warp_sub_signed_unsafe56(__warp_se_176, __warp_se_178);

                let (__warp_se_180) = warp_int32_to_int56(__warp_usrid_70_observationTimeDelta);

                let (__warp_se_181) = warp_div_signed_unsafe56(__warp_se_179, __warp_se_180);

                let (__warp_se_182) = warp_int32_to_int56(__warp_usrid_71_targetDelta);

                let (__warp_se_183) = warp_mul_signed_unsafe56(__warp_se_181, __warp_se_182);

                let (__warp_usrid_64_tickCumulative) = warp_add_signed_unsafe56(
                    __warp_se_174, __warp_se_183
                );

                let (
                    __warp_se_184
                ) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_185) = wm_read_felt(__warp_se_184);

                let (
                    __warp_se_186
                ) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
                    __warp_usrid_69_atOrAfter
                );

                let (__warp_se_187) = wm_read_felt(__warp_se_186);

                let (
                    __warp_se_188
                ) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_189) = wm_read_felt(__warp_se_188);

                let (__warp_se_190) = warp_sub_unsafe160(__warp_se_187, __warp_se_189);

                let (__warp_se_191) = warp_uint256(__warp_se_190);

                let (__warp_se_192) = warp_uint256(__warp_usrid_71_targetDelta);

                let (__warp_se_193) = warp_mul_unsafe256(__warp_se_191, __warp_se_192);

                let (__warp_se_194) = warp_uint256(__warp_usrid_70_observationTimeDelta);

                let (__warp_se_195) = warp_div_unsafe256(__warp_se_193, __warp_se_194);

                let (__warp_se_196) = warp_int256_to_int160(__warp_se_195);

                let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = warp_add_unsafe160(
                    __warp_se_185, __warp_se_196
                );

                return (
                    __warp_usrid_64_tickCumulative,
                    __warp_usrid_65_secondsPerLiquidityCumulativeX128,
                );
            }
        }
    }

    // @notice Returns the accumulator values as of each time seconds ago from the given time in the array of `secondsAgos`
    // @dev Reverts if `secondsAgos` > oldest observation
    // @param self The stored oracle array
    // @param time The current block.timestamp
    // @param secondsAgos Each amount of time to look back, in seconds, at which point to return an observation
    // @param tick The current tick
    // @param index The index of the observation that was most recently written to the observations array
    // @param liquidity The current in-range pool liquidity
    // @param cardinality The number of populated elements in the oracle array
    // @return tickCumulatives The tick * time elapsed since the pool was first initialized, as of each `secondsAgo`
    // @return secondsPerLiquidityCumulativeX128s The cumulative seconds / max(1, liquidity) since the pool was first initialized, as of each `secondsAgo`
    func observe_1ce1e7a5{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_72_self: felt,
        __warp_usrid_73_time: felt,
        __warp_usrid_74_secondsAgos: felt,
        __warp_usrid_75_tick: felt,
        __warp_usrid_76_index: felt,
        __warp_usrid_77_liquidity: felt,
        __warp_usrid_78_cardinality: felt,
    ) -> (
        __warp_usrid_79_tickCumulatives: felt,
        __warp_usrid_80_secondsPerLiquidityCumulativeX128s: felt,
    ) {
        alloc_locals;

        let (__warp_usrid_80_secondsPerLiquidityCumulativeX128s) = wm_new(
            Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        let (__warp_usrid_79_tickCumulatives) = wm_new(
            Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        let (__warp_se_197) = warp_gt(__warp_usrid_78_cardinality, 0);

        with_attr error_message("I") {
            assert __warp_se_197 = 1;
        }

        let (__warp_se_198) = wm_dyn_array_length(__warp_usrid_74_secondsAgos);

        let (__warp_se_199) = wm_new(__warp_se_198, Uint256(low=1, high=0));

        let __warp_usrid_79_tickCumulatives = __warp_se_199;

        let (__warp_se_200) = wm_dyn_array_length(__warp_usrid_74_secondsAgos);

        let (__warp_se_201) = wm_new(__warp_se_200, Uint256(low=1, high=0));

        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_se_201;

        let __warp_usrid_81_i = Uint256(low=0, high=0);

        let (
            __warp_tv_28,
            __warp_td_71,
            __warp_td_72,
            __warp_td_73,
            __warp_td_74,
            __warp_tv_33,
            __warp_tv_34,
            __warp_tv_35,
            __warp_tv_36,
            __warp_tv_37,
        ) = __warp_while6(
            __warp_usrid_81_i,
            __warp_usrid_74_secondsAgos,
            __warp_usrid_79_tickCumulatives,
            __warp_usrid_80_secondsPerLiquidityCumulativeX128s,
            __warp_usrid_72_self,
            __warp_usrid_73_time,
            __warp_usrid_75_tick,
            __warp_usrid_76_index,
            __warp_usrid_77_liquidity,
            __warp_usrid_78_cardinality,
        );

        let __warp_tv_29 = __warp_td_71;

        let __warp_tv_30 = __warp_td_72;

        let __warp_tv_31 = __warp_td_73;

        let __warp_tv_32 = __warp_td_74;

        let __warp_usrid_78_cardinality = __warp_tv_37;

        let __warp_usrid_77_liquidity = __warp_tv_36;

        let __warp_usrid_76_index = __warp_tv_35;

        let __warp_usrid_75_tick = __warp_tv_34;

        let __warp_usrid_73_time = __warp_tv_33;

        let __warp_usrid_72_self = __warp_tv_32;

        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_tv_31;

        let __warp_usrid_79_tickCumulatives = __warp_tv_30;

        let __warp_usrid_74_secondsAgos = __warp_tv_29;

        let __warp_usrid_81_i = __warp_tv_28;

        let __warp_usrid_79_tickCumulatives = __warp_usrid_79_tickCumulatives;

        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_usrid_80_secondsPerLiquidityCumulativeX128s;

        return (
            __warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s
        );
    }
}

@external
func initialize_daf50f6b{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_13_params: InitializeParams_62e4fbcc
) -> () {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check0(__warp_usrid_13_params);

        let (__warp_se_43) = WS0_READ_felt(OracleTest.__warp_usrid_11_cardinality);

        let (__warp_se_44) = warp_eq(__warp_se_43, 0);

        with_attr error_message("already initialized") {
            assert __warp_se_44 = 1;
        }

        WS_WRITE0(OracleTest.__warp_usrid_07_time, __warp_usrid_13_params.__warp_usrid_00_time);

        WS_WRITE0(OracleTest.__warp_usrid_08_tick, __warp_usrid_13_params.__warp_usrid_01_tick);

        WS_WRITE0(
            OracleTest.__warp_usrid_09_liquidity, __warp_usrid_13_params.__warp_usrid_02_liquidity
        );

        let (__warp_tv_4, __warp_tv_5) = OracleTest.initialize_286f3ae4(
            OracleTest.__warp_usrid_06_observations, __warp_usrid_13_params.__warp_usrid_00_time
        );

        WS_WRITE0(OracleTest.__warp_usrid_12_cardinalityNext, __warp_tv_5);

        WS_WRITE0(OracleTest.__warp_usrid_11_cardinality, __warp_tv_4);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return ();
    }
}

@external
func update_65829dc5{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_15_params: UpdateParams_a5eebe58) -> () {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check1(__warp_usrid_15_params);

        OracleTest.advanceTime_f7fd2cfa_internal(
            __warp_usrid_15_params.__warp_usrid_03_advanceTimeBy
        );

        let (__warp_se_47) = WS0_READ_felt(OracleTest.__warp_usrid_10_index);

        let (__warp_se_48) = WS0_READ_felt(OracleTest.__warp_usrid_07_time);

        let (__warp_se_49) = WS0_READ_felt(OracleTest.__warp_usrid_08_tick);

        let (__warp_se_50) = WS0_READ_felt(OracleTest.__warp_usrid_09_liquidity);

        let (__warp_se_51) = WS0_READ_felt(OracleTest.__warp_usrid_11_cardinality);

        let (__warp_se_52) = WS0_READ_felt(OracleTest.__warp_usrid_12_cardinalityNext);

        let (__warp_tv_6, __warp_tv_7) = OracleTest.write_9b9fd24c(
            OracleTest.__warp_usrid_06_observations,
            __warp_se_47,
            __warp_se_48,
            __warp_se_49,
            __warp_se_50,
            __warp_se_51,
            __warp_se_52,
        );

        WS_WRITE0(OracleTest.__warp_usrid_11_cardinality, __warp_tv_7);

        WS_WRITE0(OracleTest.__warp_usrid_10_index, __warp_tv_6);

        WS_WRITE0(OracleTest.__warp_usrid_08_tick, __warp_usrid_15_params.__warp_usrid_04_tick);

        WS_WRITE0(
            OracleTest.__warp_usrid_09_liquidity, __warp_usrid_15_params.__warp_usrid_05_liquidity
        );

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return ();
    }
}

@external
func batchUpdate_d81740db{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_16_params_len: felt, __warp_usrid_16_params: UpdateParams_a5eebe58*) -> () {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check2(__warp_usrid_16_params_len, __warp_usrid_16_params);

        local __warp_usrid_16_params_dstruct: cd_dynarray_UpdateParams_a5eebe58 = cd_dynarray_UpdateParams_a5eebe58(__warp_usrid_16_params_len, __warp_usrid_16_params);

        let (__warp_usrid_17__tick) = WS0_READ_felt(OracleTest.__warp_usrid_08_tick);

        let (__warp_usrid_18__liquidity) = WS0_READ_felt(OracleTest.__warp_usrid_09_liquidity);

        let (__warp_usrid_19__index) = WS0_READ_felt(OracleTest.__warp_usrid_10_index);

        let (__warp_usrid_20__cardinality) = WS0_READ_felt(OracleTest.__warp_usrid_11_cardinality);

        let (__warp_usrid_21__cardinalityNext) = WS0_READ_felt(
            OracleTest.__warp_usrid_12_cardinalityNext
        );

        let (__warp_usrid_22__time) = WS0_READ_felt(OracleTest.__warp_usrid_07_time);

        let __warp_usrid_23_i = Uint256(low=0, high=0);

        let (
            __warp_tv_8,
            __warp_td_48,
            __warp_tv_10,
            __warp_tv_11,
            __warp_tv_12,
            __warp_tv_13,
            __warp_tv_14,
            __warp_tv_15,
        ) = OracleTest.__warp_while3(
            __warp_usrid_23_i,
            __warp_usrid_16_params_dstruct,
            __warp_usrid_22__time,
            __warp_usrid_19__index,
            __warp_usrid_20__cardinality,
            __warp_usrid_17__tick,
            __warp_usrid_18__liquidity,
            __warp_usrid_21__cardinalityNext,
        );

        let __warp_tv_9 = __warp_td_48;

        let __warp_usrid_21__cardinalityNext = __warp_tv_15;

        let __warp_usrid_18__liquidity = __warp_tv_14;

        let __warp_usrid_17__tick = __warp_tv_13;

        let __warp_usrid_20__cardinality = __warp_tv_12;

        let __warp_usrid_19__index = __warp_tv_11;

        let __warp_usrid_22__time = __warp_tv_10;

        let __warp_usrid_23_i = __warp_tv_8;

        WS_WRITE0(OracleTest.__warp_usrid_08_tick, __warp_usrid_17__tick);

        WS_WRITE0(OracleTest.__warp_usrid_09_liquidity, __warp_usrid_18__liquidity);

        WS_WRITE0(OracleTest.__warp_usrid_10_index, __warp_usrid_19__index);

        WS_WRITE0(OracleTest.__warp_usrid_11_cardinality, __warp_usrid_20__cardinality);

        WS_WRITE0(OracleTest.__warp_usrid_07_time, __warp_usrid_22__time);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return ();
    }
}

@external
func grow_761eb23e{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_24__cardinalityNext: felt) -> () {
    alloc_locals;

    warp_external_input_check_int16(__warp_usrid_24__cardinalityNext);

    let (__warp_se_53) = WS0_READ_felt(OracleTest.__warp_usrid_12_cardinalityNext);

    let (__warp_se_54) = OracleTest.grow_48fc651e(
        OracleTest.__warp_usrid_06_observations, __warp_se_53, __warp_usrid_24__cardinalityNext
    );

    WS_WRITE0(OracleTest.__warp_usrid_12_cardinalityNext, __warp_se_54);

    return ();
}

@view
func observe_883bdbfd{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_25_secondsAgos_len: felt, __warp_usrid_25_secondsAgos: felt*) -> (
    __warp_usrid_26_tickCumulatives_len: felt,
    __warp_usrid_26_tickCumulatives: felt*,
    __warp_usrid_27_secondsPerLiquidityCumulativeX128s_len: felt,
    __warp_usrid_27_secondsPerLiquidityCumulativeX128s: felt*,
) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check3(__warp_usrid_25_secondsAgos_len, __warp_usrid_25_secondsAgos);

        local __warp_usrid_25_secondsAgos_dstruct: cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_25_secondsAgos_len, __warp_usrid_25_secondsAgos);

        let (__warp_se_55) = WS0_READ_felt(OracleTest.__warp_usrid_07_time);

        let (__warp_se_56) = cd_to_memory0(__warp_usrid_25_secondsAgos_dstruct);

        let (__warp_se_57) = WS0_READ_felt(OracleTest.__warp_usrid_08_tick);

        let (__warp_se_58) = WS0_READ_felt(OracleTest.__warp_usrid_10_index);

        let (__warp_se_59) = WS0_READ_felt(OracleTest.__warp_usrid_09_liquidity);

        let (__warp_se_60) = WS0_READ_felt(OracleTest.__warp_usrid_11_cardinality);

        let (__warp_td_49, __warp_td_50) = OracleTest.observe_1ce1e7a5(
            OracleTest.__warp_usrid_06_observations,
            __warp_se_55,
            __warp_se_56,
            __warp_se_57,
            __warp_se_58,
            __warp_se_59,
            __warp_se_60,
        );

        let __warp_usrid_26_tickCumulatives = __warp_td_49;

        let __warp_usrid_27_secondsPerLiquidityCumulativeX128s = __warp_td_50;

        let (__warp_se_61) = wm_to_calldata0(__warp_usrid_26_tickCumulatives);

        let (__warp_se_62) = wm_to_calldata3(__warp_usrid_27_secondsPerLiquidityCumulativeX128s);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (__warp_se_61.len, __warp_se_61.ptr, __warp_se_62.len, __warp_se_62.ptr);
    }
}

@view
func observations_252c09d7{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_28__i0: Uint256
) -> (
    __warp_usrid_29_: felt, __warp_usrid_30_: felt, __warp_usrid_31_: felt, __warp_usrid_32_: felt
) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_28__i0);

    let (__warp_usrid_33__temp0) = WS0_IDX(
        OracleTest.__warp_usrid_06_observations,
        __warp_usrid_28__i0,
        Uint256(low=4, high=0),
        Uint256(low=65535, high=0),
    );

    let (__warp_se_63) = WSM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
        __warp_usrid_33__temp0
    );

    let (__warp_usrid_29_) = WS0_READ_felt(__warp_se_63);

    let (__warp_se_64) = WSM1_Observation_2cc4d695___warp_usrid_01_tickCumulative(
        __warp_usrid_33__temp0
    );

    let (__warp_usrid_30_) = WS0_READ_felt(__warp_se_64);

    let (
        __warp_se_65
    ) = WSM2_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
        __warp_usrid_33__temp0
    );

    let (__warp_usrid_31_) = WS0_READ_felt(__warp_se_65);

    let (__warp_se_66) = WSM3_Observation_2cc4d695___warp_usrid_03_initialized(
        __warp_usrid_33__temp0
    );

    let (__warp_usrid_32_) = WS0_READ_felt(__warp_se_66);

    return (__warp_usrid_29_, __warp_usrid_30_, __warp_usrid_31_, __warp_usrid_32_);
}

@view
func time_16ada547{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_34_: felt
) {
    alloc_locals;

    let (__warp_se_67) = WS0_READ_felt(OracleTest.__warp_usrid_07_time);

    return (__warp_se_67,);
}

@view
func tick_3eaf5d9f{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_35_: felt
) {
    alloc_locals;

    let (__warp_se_68) = WS0_READ_felt(OracleTest.__warp_usrid_08_tick);

    return (__warp_se_68,);
}

@view
func liquidity_1a686502{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    ) -> (__warp_usrid_36_: felt) {
    alloc_locals;

    let (__warp_se_69) = WS0_READ_felt(OracleTest.__warp_usrid_09_liquidity);

    return (__warp_se_69,);
}

@view
func index_2986c0e5{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_37_: felt
) {
    alloc_locals;

    let (__warp_se_70) = WS0_READ_felt(OracleTest.__warp_usrid_10_index);

    return (__warp_se_70,);
}

@view
func cardinality_dbffe9ad{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    ) -> (__warp_usrid_38_: felt) {
    alloc_locals;

    let (__warp_se_71) = WS0_READ_felt(OracleTest.__warp_usrid_11_cardinality);

    return (__warp_se_71,);
}

@view
func cardinalityNext_dd158c18{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}() -> (__warp_usrid_39_: felt) {
    alloc_locals;

    let (__warp_se_72) = WS0_READ_felt(OracleTest.__warp_usrid_12_cardinalityNext);

    return (__warp_se_72,);
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;
    WARP_USED_STORAGE.write(262146);

    return ();
}

@external
func advanceTime_f7fd2cfa{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_14_by: felt) -> () {
    alloc_locals;

    warp_external_input_check_int32(__warp_usrid_14_by);

    OracleTest.advanceTime_f7fd2cfa_internal(__warp_usrid_14_by);

    return ();
}

// Original soldity abi: ["constructor()","initialize((uint32,int24,uint128))","advanceTime(uint32)","update((uint32,int24,uint128))","batchUpdate((uint32,int24,uint128)[])","grow(uint16)","observe(uint32[])","observations(uint256)","time()","tick()","liquidity()","index()","cardinality()","cardinalityNext()"]
