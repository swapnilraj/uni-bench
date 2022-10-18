%lang starknet

from warplib.memory import wm_read_felt, wm_read_256, wm_write_felt, wm_new, wm_index_dyn
from starkware.cairo.common.uint256 import uint256_sub, uint256_add, Uint256
from starkware.cairo.common.alloc import alloc
from warplib.maths.utils import narrow_safe, felt_to_uint256
from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int32,
    warp_external_input_check_int24,
    warp_external_input_check_int128,
    warp_external_input_check_int16,
)
from starkware.cairo.common.dict import dict_write
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.starknet.common.syscalls import deploy
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from warplib.maths.add import warp_add32, warp_add16
from warplib.maths.ge import warp_ge
from warplib.maths.lt import warp_lt
from warplib.maths.or import warp_or
from warplib.maths.eq import warp_eq
from warplib.maths.le import warp_le, warp_le256
from warplib.maths.mod import warp_mod
from warplib.maths.neq import warp_neq
from warplib.maths.and_ import warp_and_
from warplib.maths.int_conversions import warp_uint256, warp_int24_to_int56
from warplib.maths.sub import warp_sub
from warplib.maths.gt import warp_gt
from warplib.maths.sub_signed import warp_sub_signed56
from warplib.maths.mod_signed import warp_mod_signed56
from warplib.maths.div_signed import warp_div_signed56
from warplib.maths.lt_signed import warp_lt_signed56
from warplib.maths.add_signed import warp_add_signed56
from warplib.maths.le_signed import warp_le_signed56
from warplib.maths.ge_signed import warp_ge_signed56
from warplib.maths.mul import warp_mul256
from warplib.maths.shl import warp_shl256
from warplib.maths.div import warp_div256

// @declare contracts/test/OracleTest__WC__OracleTest.cairo
const contracts_test_OracleTest_OracleTest_a842409dbedefa33 = 0x483961fd4e54eef3841aa716129a1384387cdba5db8867611ef4f8b9977421b;

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

struct cd_dynarray_felt {
    len: felt,
    ptr: felt*,
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

func WS0_READ_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) -> (val: felt) {
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func WS_WRITE0{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt, value: felt
) -> (res: felt) {
    WARP_STORAGE.write(loc, value);
    return (value,);
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

func cd_to_memory1_elem{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: felt*, mem_start: felt, length: felt) {
    alloc_locals;
    if (length == 0) {
        return ();
    }
    dict_write{dict_ptr=warp_memory}(mem_start, calldata[0]);
    return cd_to_memory1_elem(calldata + 1, mem_start + 1, length - 1);
}
func cd_to_memory1{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: cd_dynarray_felt) -> (mem_loc: felt) {
    alloc_locals;
    let (len256) = felt_to_uint256(calldata.len);
    let (mem_start) = wm_new(len256, Uint256(0x1, 0x0));
    cd_to_memory1_elem(calldata.ptr, mem_start + 2, calldata.len);
    return (mem_start,);
}

func encode_as_felt0() -> (calldata_array: cd_dynarray_felt) {
    alloc_locals;
    let total_size: felt = 0;
    let (decode_array: felt*) = alloc();
    let result = cd_dynarray_felt(total_size, decode_array);
    return (result,);
}

// Contract Def OracleEchidnaTest

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

namespace OracleEchidnaTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    const __warp_usrid_03_oracle = 0;

    const __warp_usrid_04_initialized = 1;

    const __warp_usrid_05_timePassed = 2;

    func __warp_constructor_0{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }() -> () {
        alloc_locals;

        let (__warp_se_0) = encode_as_felt0();

        let (__warp_se_1) = deploy(
            contracts_test_OracleTest_OracleTest_a842409dbedefa33,
            0,
            __warp_se_0.len,
            __warp_se_0.ptr,
            0,
        );

        WS_WRITE0(__warp_usrid_03_oracle, __warp_se_1);

        return ();
    }

    func __warp_usrfn_00_limitTimePassed{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }(__warp_usrid_09_by: felt) -> () {
        alloc_locals;

        let (__warp_se_3) = WS0_READ_felt(__warp_usrid_05_timePassed);

        let (__warp_se_4) = warp_add32(__warp_se_3, __warp_usrid_09_by);

        let (__warp_se_5) = WS0_READ_felt(__warp_usrid_05_timePassed);

        let (__warp_se_6) = warp_ge(__warp_se_4, __warp_se_5);

        assert __warp_se_6 = 1;

        let (__warp_se_7) = WS0_READ_felt(__warp_usrid_05_timePassed);

        let (__warp_se_8) = warp_add32(__warp_se_7, __warp_usrid_09_by);

        WS_WRITE0(__warp_usrid_05_timePassed, __warp_se_8);

        return ();
    }

    func echidna_canAlwaysObserve0IfInitialized_ae505b52_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }() -> (__warp_usrid_27_: felt) {
        alloc_locals;

        let (__warp_usrid_28_arr) = wm_new(Uint256(low=1, high=0), Uint256(low=1, high=0));

        let (__warp_se_31) = wm_index_dyn(
            __warp_usrid_28_arr, Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        wm_write_felt(__warp_se_31, 0);

        let (__warp_se_32) = WS0_READ_felt(__warp_usrid_03_oracle);

        let (__warp_se_33) = wm_to_calldata0(__warp_usrid_28_arr);

        OracleTest_warped_interface.observe_883bdbfd(
            __warp_se_32, __warp_se_33.len, __warp_se_33.ptr
        );

        return (1,);
    }

    func __warp_usrfn_02_conditional{range_check_ptr: felt}(
        __warp_usrid_38_index: felt, __warp_usrid_39_cardinality: felt
    ) -> (__warp_usrid_40_: felt) {
        alloc_locals;

        let (__warp_se_51) = warp_eq(__warp_usrid_38_index, 0);

        if (__warp_se_51 != 0) {
            let (__warp_se_52) = warp_sub(__warp_usrid_39_cardinality, 1);

            return (__warp_se_52,);
        } else {
            let (__warp_se_53) = warp_sub(__warp_usrid_38_index, 1);

            return (__warp_se_53,);
        }
    }

    func _conditional0{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_46_timeWeightedTick: felt
    ) -> (ret_conditional0: felt, __warp_usrid_46_timeWeightedTick: felt) {
        alloc_locals;

        let (__warp_se_70) = warp_int24_to_int56(8388607);

        let (__warp_se_71) = warp_le_signed56(__warp_usrid_46_timeWeightedTick, __warp_se_70);

        if (__warp_se_71 != 0) {
            let (__warp_se_72) = warp_int24_to_int56(8388608);

            let (__warp_se_73) = warp_ge_signed56(__warp_usrid_46_timeWeightedTick, __warp_se_72);

            let ret_conditional0 = __warp_se_73;

            return (ret_conditional0, __warp_usrid_46_timeWeightedTick);
        } else {
            let ret_conditional0 = 0;

            return (ret_conditional0, __warp_usrid_46_timeWeightedTick);
        }
    }

    func checkTimeWeightedAveragesAlwaysFitsType_a9583576_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        __warp_usrid_46_timeWeightedTick: felt,
        __warp_usrid_41_secondsAgo: felt,
        __warp_usrid_44_secondsPerLiquidityCumulativeX128s: felt,
    ) -> () {
        alloc_locals;

        let ret_conditional1 = 0;

        let (ret_conditional1, __warp_usrid_46_timeWeightedTick) = _conditional0(
            __warp_usrid_46_timeWeightedTick
        );

        assert ret_conditional1 = 1;

        let (__warp_se_74) = warp_uint256(__warp_usrid_41_secondsAgo);

        let (__warp_se_75) = warp_uint256(1461501637330902918203684832716283019655932542975);

        let (__warp_se_76) = warp_mul256(__warp_se_74, __warp_se_75);

        let (__warp_se_77) = wm_index_dyn(
            __warp_usrid_44_secondsPerLiquidityCumulativeX128s,
            Uint256(low=1, high=0),
            Uint256(low=1, high=0),
        );

        let (__warp_se_78) = wm_read_felt(__warp_se_77);

        let (__warp_se_79) = wm_index_dyn(
            __warp_usrid_44_secondsPerLiquidityCumulativeX128s,
            Uint256(low=0, high=0),
            Uint256(low=1, high=0),
        );

        let (__warp_se_80) = wm_read_felt(__warp_se_79);

        let (__warp_se_81) = warp_sub(__warp_se_78, __warp_se_80);

        let (__warp_se_82) = warp_uint256(__warp_se_81);

        let (__warp_se_83) = warp_shl256(__warp_se_82, 32);

        let (__warp_usrid_47_timeWeightedHarmonicMeanLiquidity) = warp_div256(
            __warp_se_76, __warp_se_83
        );

        let (__warp_se_84) = warp_uint256(340282366920938463463374607431768211455);

        let (__warp_se_85) = warp_le256(
            __warp_usrid_47_timeWeightedHarmonicMeanLiquidity, __warp_se_84
        );

        assert __warp_se_85 = 1;

        return ();
    }
}

@external
func initialize_4d50e016{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_06_time: felt, __warp_usrid_07_tick: felt, __warp_usrid_08_liquidity: felt
) -> () {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        warp_external_input_check_int128(__warp_usrid_08_liquidity);

        warp_external_input_check_int24(__warp_usrid_07_tick);

        warp_external_input_check_int32(__warp_usrid_06_time);

        let (__warp_se_2) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

        OracleTest_warped_interface.initialize_daf50f6b(
            __warp_se_2,
            InitializeParams_62e4fbcc(__warp_usrid_06_time, __warp_usrid_07_tick, __warp_usrid_08_liquidity),
        );

        WS_WRITE0(OracleEchidnaTest.__warp_usrid_04_initialized, 1);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return ();
    }
}

@external
func advanceTime_f7fd2cfa{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_10_by: felt
) -> () {
    alloc_locals;

    warp_external_input_check_int32(__warp_usrid_10_by);

    OracleEchidnaTest.__warp_usrfn_00_limitTimePassed(__warp_usrid_10_by);

    let (__warp_se_9) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    OracleTest_warped_interface.advanceTime_f7fd2cfa(__warp_se_9, __warp_usrid_10_by);

    return ();
}

@external
func update_f7fe5510{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_11_advanceTimeBy: felt, __warp_usrid_12_tick: felt, __warp_usrid_13_liquidity: felt
) -> () {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        warp_external_input_check_int128(__warp_usrid_13_liquidity);

        warp_external_input_check_int24(__warp_usrid_12_tick);

        warp_external_input_check_int32(__warp_usrid_11_advanceTimeBy);

        OracleEchidnaTest.__warp_usrfn_00_limitTimePassed(__warp_usrid_11_advanceTimeBy);

        let (__warp_se_10) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

        OracleTest_warped_interface.update_65829dc5(
            __warp_se_10,
            UpdateParams_a5eebe58(__warp_usrid_11_advanceTimeBy, __warp_usrid_12_tick, __warp_usrid_13_liquidity),
        );

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return ();
    }
}

@external
func grow_761eb23e{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_14_cardinality: felt
) -> () {
    alloc_locals;

    warp_external_input_check_int16(__warp_usrid_14_cardinality);

    let (__warp_se_11) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    OracleTest_warped_interface.grow_761eb23e(__warp_se_11, __warp_usrid_14_cardinality);

    return ();
}

@view
func echidna_indexAlwaysLtCardinality_ae13714b{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}() -> (__warp_usrid_23_: felt) {
    alloc_locals;

    let (__warp_se_12) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    let (__warp_se_13) = OracleTest_warped_interface.index_2986c0e5(__warp_se_12);

    let (__warp_se_14) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    let (__warp_se_15) = OracleTest_warped_interface.cardinality_dbffe9ad(__warp_se_14);

    let (__warp_se_16) = warp_lt(__warp_se_13, __warp_se_15);

    let (__warp_se_17) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_04_initialized);

    let (__warp_se_18) = warp_or(__warp_se_16, 1 - __warp_se_17);

    return (__warp_se_18,);
}

@view
func echidna_AlwaysInitialized_91e2b63c{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}() -> (__warp_usrid_24_: felt) {
    alloc_locals;

    let (__warp_se_19) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    let (
        __warp_gv0, __warp_gv1, __warp_gv2, __warp_usrid_25_isInitialized
    ) = OracleTest_warped_interface.observations_252c09d7(__warp_se_19, Uint256(low=0, high=0));

    let (__warp_se_20) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    let (__warp_se_21) = OracleTest_warped_interface.cardinality_dbffe9ad(__warp_se_20);

    let (__warp_se_22) = warp_eq(__warp_se_21, 0);

    let (__warp_se_23) = warp_or(__warp_se_22, __warp_usrid_25_isInitialized);

    return (__warp_se_23,);
}

@view
func echidna_cardinalityAlwaysLteNext_de327739{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}() -> (__warp_usrid_26_: felt) {
    alloc_locals;

    let (__warp_se_24) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    let (__warp_se_25) = OracleTest_warped_interface.cardinality_dbffe9ad(__warp_se_24);

    let (__warp_se_26) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    let (__warp_se_27) = OracleTest_warped_interface.cardinalityNext_dd158c18(__warp_se_26);

    let (__warp_se_28) = warp_le(__warp_se_25, __warp_se_27);

    return (__warp_se_28,);
}

@view
func echidna_canAlwaysObserve0IfInitialized_ae505b52{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}() -> (__warp_usrid_27_: felt) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        let (__warp_se_29) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_04_initialized);

        if (1 - __warp_se_29 != 0) {
            default_dict_finalize(warp_memory_start, warp_memory, 0);

            return (1,);
        } else {
            let (
                __warp_se_30
            ) = OracleEchidnaTest.echidna_canAlwaysObserve0IfInitialized_ae505b52_if_part1();

            default_dict_finalize(warp_memory_start, warp_memory, 0);

            return (__warp_se_30,);
        }
    }
}

@view
func checkTwoAdjacentObservationsTickCumulativeModTimeElapsedAlways0_e9f71da9{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_29_index: felt) -> () {
    alloc_locals;

    warp_external_input_check_int16(__warp_usrid_29_index);

    let (__warp_se_34) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    let (__warp_usrid_30_cardinality) = OracleTest_warped_interface.cardinality_dbffe9ad(
        __warp_se_34
    );

    let (__warp_se_35) = warp_lt(__warp_usrid_29_index, __warp_usrid_30_cardinality);

    let (__warp_se_36) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    let (__warp_se_37) = OracleTest_warped_interface.index_2986c0e5(__warp_se_36);

    let (__warp_se_38) = warp_add16(__warp_se_37, 1);

    let (__warp_se_39) = warp_mod(__warp_se_38, __warp_usrid_30_cardinality);

    let (__warp_se_40) = warp_neq(__warp_usrid_29_index, __warp_se_39);

    let (__warp_se_41) = warp_and_(__warp_se_35, __warp_se_40);

    assert __warp_se_41 = 1;

    let (__warp_se_42) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    let (__warp_se_43) = OracleEchidnaTest.__warp_usrfn_02_conditional(
        __warp_usrid_29_index, __warp_usrid_30_cardinality
    );

    let (__warp_se_44) = warp_uint256(__warp_se_43);

    let (
        __warp_usrid_31_blockTimestamp0,
        __warp_usrid_32_tickCumulative0,
        __warp_gv3,
        __warp_usrid_33_initialized0,
    ) = OracleTest_warped_interface.observations_252c09d7(__warp_se_42, __warp_se_44);

    let (__warp_se_45) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

    let (__warp_se_46) = warp_uint256(__warp_usrid_29_index);

    let (
        __warp_usrid_34_blockTimestamp1,
        __warp_usrid_35_tickCumulative1,
        __warp_gv4,
        __warp_usrid_36_initialized1,
    ) = OracleTest_warped_interface.observations_252c09d7(__warp_se_45, __warp_se_46);

    assert __warp_usrid_33_initialized0 = 1;

    assert __warp_usrid_36_initialized1 = 1;

    let (__warp_usrid_37_timeElapsed) = warp_sub(
        __warp_usrid_34_blockTimestamp1, __warp_usrid_31_blockTimestamp0
    );

    let (__warp_se_47) = warp_gt(__warp_usrid_37_timeElapsed, 0);

    assert __warp_se_47 = 1;

    let (__warp_se_48) = warp_sub_signed56(
        __warp_usrid_35_tickCumulative1, __warp_usrid_32_tickCumulative0
    );

    let (__warp_se_49) = warp_mod_signed56(__warp_se_48, __warp_usrid_37_timeElapsed);

    let (__warp_se_50) = warp_eq(__warp_se_49, 0);

    assert __warp_se_50 = 1;

    return ();
}

@view
func checkTimeWeightedAveragesAlwaysFitsType_a9583576{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_41_secondsAgo: felt) -> () {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        warp_external_input_check_int32(__warp_usrid_41_secondsAgo);

        let (__warp_se_54) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_04_initialized);

        assert __warp_se_54 = 1;

        let (__warp_se_55) = warp_gt(__warp_usrid_41_secondsAgo, 0);

        assert __warp_se_55 = 1;

        let (__warp_usrid_42_secondsAgos) = wm_new(Uint256(low=2, high=0), Uint256(low=1, high=0));

        let (__warp_se_56) = wm_index_dyn(
            __warp_usrid_42_secondsAgos, Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        wm_write_felt(__warp_se_56, __warp_usrid_41_secondsAgo);

        let (__warp_se_57) = wm_index_dyn(
            __warp_usrid_42_secondsAgos, Uint256(low=1, high=0), Uint256(low=1, high=0)
        );

        wm_write_felt(__warp_se_57, 0);

        let (__warp_se_58) = WS0_READ_felt(OracleEchidnaTest.__warp_usrid_03_oracle);

        let (__warp_se_59) = wm_to_calldata0(__warp_usrid_42_secondsAgos);

        let (
            __warp_td_2_cd_raw_len, __warp_td_2_cd_raw, __warp_td_3_cd_raw_len, __warp_td_3_cd_raw
        ) = OracleTest_warped_interface.observe_883bdbfd(
            __warp_se_58, __warp_se_59.len, __warp_se_59.ptr
        );

        local __warp_td_3_cd: cd_dynarray_felt = cd_dynarray_felt(__warp_td_3_cd_raw_len, __warp_td_3_cd_raw);

        local __warp_td_2_cd: cd_dynarray_felt = cd_dynarray_felt(__warp_td_2_cd_raw_len, __warp_td_2_cd_raw);

        let (__warp_td_3) = cd_to_memory0(__warp_td_3_cd);

        let (__warp_td_2) = cd_to_memory1(__warp_td_2_cd);

        let __warp_usrid_43_tickCumulatives = __warp_td_2;

        let __warp_usrid_44_secondsPerLiquidityCumulativeX128s = __warp_td_3;

        let (__warp_se_60) = wm_index_dyn(
            __warp_usrid_43_tickCumulatives, Uint256(low=1, high=0), Uint256(low=1, high=0)
        );

        let (__warp_se_61) = wm_read_felt(__warp_se_60);

        let (__warp_se_62) = wm_index_dyn(
            __warp_usrid_43_tickCumulatives, Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        let (__warp_se_63) = wm_read_felt(__warp_se_62);

        let (__warp_usrid_45_numerator) = warp_sub_signed56(__warp_se_61, __warp_se_63);

        let (__warp_usrid_46_timeWeightedTick) = warp_div_signed56(
            __warp_usrid_45_numerator, __warp_usrid_41_secondsAgo
        );

        let (__warp_se_64) = warp_lt_signed56(__warp_usrid_45_numerator, 0);

        let (__warp_se_65) = warp_mod_signed56(
            __warp_usrid_45_numerator, __warp_usrid_41_secondsAgo
        );

        let (__warp_se_66) = warp_neq(__warp_se_65, 0);

        let (__warp_se_67) = warp_and_(__warp_se_64, __warp_se_66);

        if (__warp_se_67 != 0) {
            let (__warp_se_68) = warp_sub_signed56(__warp_usrid_46_timeWeightedTick, 1);

            let __warp_se_69 = __warp_se_68;

            let __warp_usrid_46_timeWeightedTick = __warp_se_69;

            warp_add_signed56(__warp_se_69, 1);

            OracleEchidnaTest.checkTimeWeightedAveragesAlwaysFitsType_a9583576_if_part1(
                __warp_usrid_46_timeWeightedTick,
                __warp_usrid_41_secondsAgo,
                __warp_usrid_44_secondsPerLiquidityCumulativeX128s,
            );

            default_dict_finalize(warp_memory_start, warp_memory, 0);

            return ();
        } else {
            OracleEchidnaTest.checkTimeWeightedAveragesAlwaysFitsType_a9583576_if_part1(
                __warp_usrid_46_timeWeightedTick,
                __warp_usrid_41_secondsAgo,
                __warp_usrid_44_secondsPerLiquidityCumulativeX128s,
            );

            default_dict_finalize(warp_memory_start, warp_memory, 0);

            return ();
        }
    }
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;
    WARP_USED_STORAGE.write(3);

    OracleEchidnaTest.__warp_constructor_0();

    return ();
}

// Contract Def OracleTest@interface

@contract_interface
namespace OracleTest_warped_interface {
    func initialize_daf50f6b(__warp_usrid_13_params: InitializeParams_62e4fbcc) -> () {
    }

    func advanceTime_f7fd2cfa(__warp_usrid_14_by: felt) -> () {
    }

    func update_65829dc5(__warp_usrid_15_params: UpdateParams_a5eebe58) -> () {
    }

    func batchUpdate_d81740db(
        __warp_usrid_16_params_len: felt, __warp_usrid_16_params: UpdateParams_a5eebe58*
    ) -> () {
    }

    func grow_761eb23e(__warp_usrid_24__cardinalityNext: felt) -> () {
    }

    func observe_883bdbfd(
        __warp_usrid_25_secondsAgos_len: felt, __warp_usrid_25_secondsAgos: felt*
    ) -> (
        __warp_usrid_26_tickCumulatives_len: felt,
        __warp_usrid_26_tickCumulatives: felt*,
        __warp_usrid_27_secondsPerLiquidityCumulativeX128s_len: felt,
        __warp_usrid_27_secondsPerLiquidityCumulativeX128s: felt*,
    ) {
    }

    func observations_252c09d7(__warp_usrid_28__i0: Uint256) -> (
        __warp_usrid_29_: felt,
        __warp_usrid_30_: felt,
        __warp_usrid_31_: felt,
        __warp_usrid_32_: felt,
    ) {
    }

    func time_16ada547() -> (__warp_usrid_34_: felt) {
    }

    func tick_3eaf5d9f() -> (__warp_usrid_35_: felt) {
    }

    func liquidity_1a686502() -> (__warp_usrid_36_: felt) {
    }

    func index_2986c0e5() -> (__warp_usrid_37_: felt) {
    }

    func cardinality_dbffe9ad() -> (__warp_usrid_38_: felt) {
    }

    func cardinalityNext_dd158c18() -> (__warp_usrid_39_: felt) {
    }
}

// Original soldity abi: ["constructor()","","initialize(uint32,int24,uint128)","advanceTime(uint32)","update(uint32,int24,uint128)","grow(uint16)","echidna_indexAlwaysLtCardinality()","echidna_AlwaysInitialized()","echidna_cardinalityAlwaysLteNext()","echidna_canAlwaysObserve0IfInitialized()","checkTwoAdjacentObservationsTickCumulativeModTimeElapsedAlways0(uint16)","checkTimeWeightedAveragesAlwaysFitsType(uint32)"]
