%lang starknet

from warplib.memory import (
    wm_read_felt,
    wm_read_256,
    wm_alloc,
    wm_write_felt,
    wm_write_256,
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
    warp_external_input_check_int256,
    warp_external_input_check_int24,
    warp_external_input_check_int32,
    warp_external_input_check_int16,
    warp_external_input_check_int160,
    warp_external_input_check_int128,
    warp_external_input_check_int8,
)
from warplib.maths.external_input_check_address import warp_external_input_check_address
from warplib.maths.external_input_check_bool import warp_external_input_check_bool
from warplib.dynamic_arrays_util import (
    fixed_bytes256_to_felt_dynamic_array,
    fixed_bytes_to_felt_dynamic_array,
    felt_array_to_warp_memory_array,
)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.lt import warp_lt256, warp_lt
from warplib.maths.add_unsafe import (
    warp_add_unsafe256,
    warp_add_unsafe16,
    warp_add_unsafe128,
    warp_add_unsafe8,
    warp_add_unsafe24,
    warp_add_unsafe160,
    warp_add_unsafe40,
)
from warplib.maths.sub_unsafe import (
    warp_sub_unsafe256,
    warp_sub_unsafe16,
    warp_sub_unsafe128,
    warp_sub_unsafe160,
    warp_sub_unsafe32,
    warp_sub_unsafe8,
    warp_sub_unsafe24,
)
from warplib.maths.div_unsafe import warp_div_unsafe256, warp_div_unsafe
from warplib.maths.int_conversions import (
    warp_uint256,
    warp_int256_to_int128,
    warp_int256_to_int32,
    warp_int128_to_int256,
    warp_int256_to_int160,
    warp_int24_to_int56,
    warp_int32_to_int56,
    warp_int24_to_int256,
    warp_int256_to_int24,
    warp_int24_to_int16,
    warp_int24_to_int8,
)
from warplib.maths.mod import warp_mod256, warp_mod
from warplib.maths.neq import warp_neq256, warp_neq
from warplib.maths.lt_signed import warp_lt_signed24, warp_lt_signed256, warp_lt_signed128
from warplib.maths.gt_signed import warp_gt_signed24, warp_gt_signed256
from warplib.maths.sub_signed_unsafe import (
    warp_sub_signed_unsafe256,
    warp_sub_signed_unsafe24,
    warp_sub_signed_unsafe56,
)
from warplib.maths.add_signed_unsafe import (
    warp_add_signed_unsafe256,
    warp_add_signed_unsafe56,
    warp_add_signed_unsafe24,
)
from warplib.maths.gt import warp_gt, warp_gt256
from warplib.maths.eq import warp_eq, warp_eq256
from warplib.maths.negate import warp_negate128, warp_negate256
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address
from warplib.maths.ge import warp_ge, warp_ge256
from warplib.maths.le import warp_le, warp_le256
from warplib.maths.and_ import warp_and_
from warplib.maths.or import warp_or
from warplib.maths.shl import warp_shl8, warp_shl160, warp_shl256, warp_shl256_256
from warplib.maths.shr import warp_shr8, warp_shr256, warp_shr256_256
from warplib.maths.ge_signed import warp_ge_signed24, warp_ge_signed256
from warplib.maths.le_signed import warp_le_signed24, warp_le_signed256
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.cairo_keccak.keccak import finalize_keccak
from warplib.maths.div_signed_unsafe import warp_div_signed_unsafe24, warp_div_signed_unsafe56
from warplib.maths.mul_signed_unsafe import (
    warp_mul_signed_unsafe24,
    warp_mul_signed_unsafe56,
    warp_mul_signed_unsafe256,
)
from warplib.maths.mul_unsafe import warp_mul_unsafe256
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.shr_signed import warp_shr_signed256, warp_shr_signed24
from warplib.maths.mulmod import warp_mulmod
from warplib.maths.xor import warp_xor256
from warplib.keccak import warp_keccak
from warplib.maths.mod_signed import warp_mod_signed24
from warplib.maths.bitwise_not import warp_bitwise_not256

struct Info_d529aac3 {
    __warp_usrid_00_liquidity: felt,
    __warp_usrid_01_feeGrowthInside0LastX128: Uint256,
    __warp_usrid_02_feeGrowthInside1LastX128: Uint256,
    __warp_usrid_03_tokensOwed0: felt,
    __warp_usrid_04_tokensOwed1: felt,
}

struct Observation_2cc4d695 {
    __warp_usrid_00_blockTimestamp: felt,
    __warp_usrid_01_tickCumulative: felt,
    __warp_usrid_02_secondsPerLiquidityCumulativeX128: felt,
    __warp_usrid_03_initialized: felt,
}

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

struct ProtocolFees_bf8b310b {
    __warp_usrid_007_token0: felt,
    __warp_usrid_008_token1: felt,
}

struct Slot0_930d2817 {
    __warp_usrid_000_sqrtPriceX96: felt,
    __warp_usrid_001_tick: felt,
    __warp_usrid_002_observationIndex: felt,
    __warp_usrid_003_observationCardinality: felt,
    __warp_usrid_004_observationCardinalityNext: felt,
    __warp_usrid_005_feeProtocol: felt,
    __warp_usrid_006_unlocked: felt,
}

struct SwapState_eba3c779 {
    __warp_usrid_019_amountSpecifiedRemaining: Uint256,
    __warp_usrid_020_amountCalculated: Uint256,
    __warp_usrid_021_sqrtPriceX96: felt,
    __warp_usrid_022_tick: felt,
    __warp_usrid_023_feeGrowthGlobalX128: Uint256,
    __warp_usrid_024_protocolFee: felt,
    __warp_usrid_025_liquidity: felt,
}

struct StepComputations_cf1844f5 {
    __warp_usrid_026_sqrtPriceStartX96: felt,
    __warp_usrid_027_tickNext: felt,
    __warp_usrid_028_initialized: felt,
    __warp_usrid_029_sqrtPriceNextX96: felt,
    __warp_usrid_030_amountIn: Uint256,
    __warp_usrid_031_amountOut: Uint256,
    __warp_usrid_032_feeAmount: Uint256,
}

struct ModifyPositionParams_82bf7b1b {
    __warp_usrid_009_owner: felt,
    __warp_usrid_010_tickLower: felt,
    __warp_usrid_011_tickUpper: felt,
    __warp_usrid_012_liquidityDelta: felt,
}

struct SwapCache_7600c2b6 {
    __warp_usrid_013_feeProtocol: felt,
    __warp_usrid_014_liquidityStart: felt,
    __warp_usrid_015_blockTimestamp: felt,
    __warp_usrid_016_tickCumulative: felt,
    __warp_usrid_017_secondsPerLiquidityCumulativeX128: felt,
    __warp_usrid_018_computedLatestObservation: felt,
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

func WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 2,);
}

func WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(loc: felt) -> (
    memberLoc: felt
) {
    return (loc,);
}

func WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(loc: felt) -> (memberLoc: felt) {
    return (loc + 4,);
}

func WM5_SwapState_eba3c779___warp_usrid_022_tick(loc: felt) -> (memberLoc: felt) {
    return (loc + 5,);
}

func WM9_SwapState_eba3c779___warp_usrid_025_liquidity(loc: felt) -> (memberLoc: felt) {
    return (loc + 9,);
}

func WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(loc: felt) -> (memberLoc: felt) {
    return (loc + 8,);
}

func WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(loc: felt) -> (memberLoc: felt) {
    return (loc + 6,);
}

func WM4_StepComputations_cf1844f5___warp_usrid_026_sqrtPriceStartX96(loc: felt) -> (
    memberLoc: felt
) {
    return (loc,);
}

func WM6_StepComputations_cf1844f5___warp_usrid_028_initialized(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 3,);
}

func WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(loc: felt) -> (memberLoc: felt) {
    return (loc + 8,);
}

func WM11_StepComputations_cf1844f5___warp_usrid_031_amountOut(loc: felt) -> (memberLoc: felt) {
    return (loc + 6,);
}

func WM12_StepComputations_cf1844f5___warp_usrid_030_amountIn(loc: felt) -> (memberLoc: felt) {
    return (loc + 4,);
}

func WM14_SwapCache_7600c2b6___warp_usrid_013_feeProtocol(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WM17_SwapCache_7600c2b6___warp_usrid_018_computedLatestObservation(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 5,);
}

func WM18_SwapCache_7600c2b6___warp_usrid_015_blockTimestamp(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func WM21_SwapCache_7600c2b6___warp_usrid_014_liquidityStart(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WM23_SwapCache_7600c2b6___warp_usrid_017_secondsPerLiquidityCumulativeX128(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 4,);
}

func WM24_SwapCache_7600c2b6___warp_usrid_016_tickCumulative(loc: felt) -> (memberLoc: felt) {
    return (loc + 3,);
}

func WM19_Slot0_930d2817___warp_usrid_001_tick(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WM20_Slot0_930d2817___warp_usrid_002_observationIndex(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func WM22_Slot0_930d2817___warp_usrid_003_observationCardinality(loc: felt) -> (memberLoc: felt) {
    return (loc + 3,);
}

func WM25_Slot0_930d2817___warp_usrid_006_unlocked(loc: felt) -> (memberLoc: felt) {
    return (loc + 6,);
}

func WM26_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WM27_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 4,);
}

func WM32_Slot0_930d2817___warp_usrid_005_feeProtocol(loc: felt) -> (memberLoc: felt) {
    return (loc + 5,);
}

func WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func WM30_ModifyPositionParams_82bf7b1b___warp_usrid_009_owner(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 3,);
}

func WM35_Info_d529aac3___warp_usrid_00_liquidity(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WM36_Info_d529aac3___warp_usrid_01_feeGrowthInside0LastX128(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WM37_Info_d529aac3___warp_usrid_02_feeGrowthInside1LastX128(loc: felt) -> (memberLoc: felt) {
    return (loc + 3,);
}

func WM0_struct_StepComputations_cf1844f5{range_check_ptr, warp_memory: DictAccess*}(
    __warp_usrid_026_sqrtPriceStartX96: felt,
    __warp_usrid_027_tickNext: felt,
    __warp_usrid_028_initialized: felt,
    __warp_usrid_029_sqrtPriceNextX96: felt,
    __warp_usrid_030_amountIn: Uint256,
    __warp_usrid_031_amountOut: Uint256,
    __warp_usrid_032_feeAmount: Uint256,
) -> (res: felt) {
    alloc_locals;
    let (start) = wm_alloc(Uint256(0xa, 0x0));
    dict_write{dict_ptr=warp_memory}(start, __warp_usrid_026_sqrtPriceStartX96);
    dict_write{dict_ptr=warp_memory}(start + 1, __warp_usrid_027_tickNext);
    dict_write{dict_ptr=warp_memory}(start + 2, __warp_usrid_028_initialized);
    dict_write{dict_ptr=warp_memory}(start + 3, __warp_usrid_029_sqrtPriceNextX96);
    dict_write{dict_ptr=warp_memory}(start + 4, __warp_usrid_030_amountIn.low);
    dict_write{dict_ptr=warp_memory}(start + 5, __warp_usrid_030_amountIn.high);
    dict_write{dict_ptr=warp_memory}(start + 6, __warp_usrid_031_amountOut.low);
    dict_write{dict_ptr=warp_memory}(start + 7, __warp_usrid_031_amountOut.high);
    dict_write{dict_ptr=warp_memory}(start + 8, __warp_usrid_032_feeAmount.low);
    dict_write{dict_ptr=warp_memory}(start + 9, __warp_usrid_032_feeAmount.high);
    return (start,);
}

func WM1_struct_SwapCache_7600c2b6{range_check_ptr, warp_memory: DictAccess*}(
    __warp_usrid_013_feeProtocol: felt,
    __warp_usrid_014_liquidityStart: felt,
    __warp_usrid_015_blockTimestamp: felt,
    __warp_usrid_016_tickCumulative: felt,
    __warp_usrid_017_secondsPerLiquidityCumulativeX128: felt,
    __warp_usrid_018_computedLatestObservation: felt,
) -> (res: felt) {
    alloc_locals;
    let (start) = wm_alloc(Uint256(0x6, 0x0));
    dict_write{dict_ptr=warp_memory}(start, __warp_usrid_013_feeProtocol);
    dict_write{dict_ptr=warp_memory}(start + 1, __warp_usrid_014_liquidityStart);
    dict_write{dict_ptr=warp_memory}(start + 2, __warp_usrid_015_blockTimestamp);
    dict_write{dict_ptr=warp_memory}(start + 3, __warp_usrid_016_tickCumulative);
    dict_write{dict_ptr=warp_memory}(start + 4, __warp_usrid_017_secondsPerLiquidityCumulativeX128);
    dict_write{dict_ptr=warp_memory}(start + 5, __warp_usrid_018_computedLatestObservation);
    return (start,);
}

func WM2_struct_SwapState_eba3c779{range_check_ptr, warp_memory: DictAccess*}(
    __warp_usrid_019_amountSpecifiedRemaining: Uint256,
    __warp_usrid_020_amountCalculated: Uint256,
    __warp_usrid_021_sqrtPriceX96: felt,
    __warp_usrid_022_tick: felt,
    __warp_usrid_023_feeGrowthGlobalX128: Uint256,
    __warp_usrid_024_protocolFee: felt,
    __warp_usrid_025_liquidity: felt,
) -> (res: felt) {
    alloc_locals;
    let (start) = wm_alloc(Uint256(0xa, 0x0));
    dict_write{dict_ptr=warp_memory}(start, __warp_usrid_019_amountSpecifiedRemaining.low);
    dict_write{dict_ptr=warp_memory}(start + 1, __warp_usrid_019_amountSpecifiedRemaining.high);
    dict_write{dict_ptr=warp_memory}(start + 2, __warp_usrid_020_amountCalculated.low);
    dict_write{dict_ptr=warp_memory}(start + 3, __warp_usrid_020_amountCalculated.high);
    dict_write{dict_ptr=warp_memory}(start + 4, __warp_usrid_021_sqrtPriceX96);
    dict_write{dict_ptr=warp_memory}(start + 5, __warp_usrid_022_tick);
    dict_write{dict_ptr=warp_memory}(start + 6, __warp_usrid_023_feeGrowthGlobalX128.low);
    dict_write{dict_ptr=warp_memory}(start + 7, __warp_usrid_023_feeGrowthGlobalX128.high);
    dict_write{dict_ptr=warp_memory}(start + 8, __warp_usrid_024_protocolFee);
    dict_write{dict_ptr=warp_memory}(start + 9, __warp_usrid_025_liquidity);
    return (start,);
}

func WM3_struct_ModifyPositionParams_82bf7b1b{range_check_ptr, warp_memory: DictAccess*}(
    __warp_usrid_009_owner: felt,
    __warp_usrid_010_tickLower: felt,
    __warp_usrid_011_tickUpper: felt,
    __warp_usrid_012_liquidityDelta: felt,
) -> (res: felt) {
    alloc_locals;
    let (start) = wm_alloc(Uint256(0x4, 0x0));
    dict_write{dict_ptr=warp_memory}(start, __warp_usrid_009_owner);
    dict_write{dict_ptr=warp_memory}(start + 1, __warp_usrid_010_tickLower);
    dict_write{dict_ptr=warp_memory}(start + 2, __warp_usrid_011_tickUpper);
    dict_write{dict_ptr=warp_memory}(start + 3, __warp_usrid_012_liquidityDelta);
    return (start,);
}

func WM4_struct_Slot0_930d2817{range_check_ptr, warp_memory: DictAccess*}(
    __warp_usrid_000_sqrtPriceX96: felt,
    __warp_usrid_001_tick: felt,
    __warp_usrid_002_observationIndex: felt,
    __warp_usrid_003_observationCardinality: felt,
    __warp_usrid_004_observationCardinalityNext: felt,
    __warp_usrid_005_feeProtocol: felt,
    __warp_usrid_006_unlocked: felt,
) -> (res: felt) {
    alloc_locals;
    let (start) = wm_alloc(Uint256(0x7, 0x0));
    dict_write{dict_ptr=warp_memory}(start, __warp_usrid_000_sqrtPriceX96);
    dict_write{dict_ptr=warp_memory}(start + 1, __warp_usrid_001_tick);
    dict_write{dict_ptr=warp_memory}(start + 2, __warp_usrid_002_observationIndex);
    dict_write{dict_ptr=warp_memory}(start + 3, __warp_usrid_003_observationCardinality);
    dict_write{dict_ptr=warp_memory}(start + 4, __warp_usrid_004_observationCardinalityNext);
    dict_write{dict_ptr=warp_memory}(start + 5, __warp_usrid_005_feeProtocol);
    dict_write{dict_ptr=warp_memory}(start + 6, __warp_usrid_006_unlocked);
    return (start,);
}

func WM5_struct_Observation_2cc4d695{range_check_ptr, warp_memory: DictAccess*}(
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
    let (elem_mem_loc_4) = dict_read{dict_ptr=warp_memory}(mem_loc + 4);
    WARP_STORAGE.write(loc + 4, elem_mem_loc_4);
    let (elem_mem_loc_5) = dict_read{dict_ptr=warp_memory}(mem_loc + 5);
    WARP_STORAGE.write(loc + 5, elem_mem_loc_5);
    let (elem_mem_loc_6) = dict_read{dict_ptr=warp_memory}(mem_loc + 6);
    WARP_STORAGE.write(loc + 6, elem_mem_loc_6);
    return (loc,);
}

func wm_to_storage1{
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

func WSM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WSM23_Observation_2cc4d695___warp_usrid_01_tickCumulative(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WSM24_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 2,);
}

func WSM25_Observation_2cc4d695___warp_usrid_03_initialized(loc: felt) -> (memberLoc: felt) {
    return (loc + 3,);
}

func WSM1_Slot0_930d2817___warp_usrid_006_unlocked(loc: felt) -> (memberLoc: felt) {
    return (loc + 6,);
}

func WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(loc: felt) -> (memberLoc: felt) {
    return (loc + 5,);
}

func WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(loc: felt) -> (memberLoc: felt) {
    return (loc + 3,);
}

func WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func WSM7_Slot0_930d2817___warp_usrid_001_tick(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WSM8_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WSM11_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 4,);
}

func WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(loc: felt) -> (memberLoc: felt) {
    return (loc + 5,);
}

func WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(loc: felt) -> (memberLoc: felt) {
    return (loc + 6,);
}

func WSM20_Info_d529aac3___warp_usrid_00_liquidity(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WSM21_Info_d529aac3___warp_usrid_01_feeGrowthInside0LastX128(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WSM22_Info_d529aac3___warp_usrid_02_feeGrowthInside1LastX128(loc: felt) -> (memberLoc: felt) {
    return (loc + 3,);
}

func WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(loc: felt) -> (memberLoc: felt) {
    return (loc + 6,);
}

func WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(loc: felt) -> (
    memberLoc: felt
) {
    return (loc + 7,);
}

func WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(loc: felt) -> (memberLoc: felt) {
    return (loc + 8,);
}

func WSM15_Info_39bc053d___warp_usrid_07_initialized(loc: felt) -> (memberLoc: felt) {
    return (loc + 9,);
}

func WSM16_Info_39bc053d___warp_usrid_00_liquidityGross(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(loc: felt) -> (memberLoc: felt) {
    return (loc + 1,);
}

func WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(loc: felt) -> (memberLoc: felt) {
    return (loc + 4,);
}

func WS0_READ_Uint256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) -> (val: Uint256) {
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0, high=read1),);
}

func WS1_READ_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
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

func ws_to_memory1{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(loc: felt) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0x7, 0x0));
    let (copy0) = WARP_STORAGE.read(loc);
    dict_write{dict_ptr=warp_memory}(mem_start, copy0);
    let (copy1) = WARP_STORAGE.read(loc + 1);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, copy1);
    let (copy2) = WARP_STORAGE.read(loc + 2);
    dict_write{dict_ptr=warp_memory}(mem_start + 2, copy2);
    let (copy3) = WARP_STORAGE.read(loc + 3);
    dict_write{dict_ptr=warp_memory}(mem_start + 3, copy3);
    let (copy4) = WARP_STORAGE.read(loc + 4);
    dict_write{dict_ptr=warp_memory}(mem_start + 4, copy4);
    let (copy5) = WARP_STORAGE.read(loc + 5);
    dict_write{dict_ptr=warp_memory}(mem_start + 5, copy5);
    let (copy6) = WARP_STORAGE.read(loc + 6);
    dict_write{dict_ptr=warp_memory}(mem_start + 6, copy6);
    return (mem_start,);
}

func ws_to_memory2{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(loc: felt) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0x7, 0x0));
    let (copy0) = WARP_STORAGE.read(loc);
    dict_write{dict_ptr=warp_memory}(mem_start, copy0);
    let (copy1) = WARP_STORAGE.read(loc + 1);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, copy1);
    let (copy2) = WARP_STORAGE.read(loc + 2);
    dict_write{dict_ptr=warp_memory}(mem_start + 2, copy2);
    let (copy3) = WARP_STORAGE.read(loc + 3);
    dict_write{dict_ptr=warp_memory}(mem_start + 3, copy3);
    let (copy4) = WARP_STORAGE.read(loc + 4);
    dict_write{dict_ptr=warp_memory}(mem_start + 4, copy4);
    let (copy5) = WARP_STORAGE.read(loc + 5);
    dict_write{dict_ptr=warp_memory}(mem_start + 5, copy5);
    let (copy6) = WARP_STORAGE.read(loc + 6);
    dict_write{dict_ptr=warp_memory}(mem_start + 6, copy6);
    return (mem_start,);
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

func extern_input_check0{range_check_ptr: felt}(len: felt, ptr: felt*) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    warp_external_input_check_int32(ptr[0]);
    extern_input_check0(len=len - 1, ptr=ptr + 1);
    return ();
}

func extern_input_check1{range_check_ptr: felt}(len: felt, ptr: felt*) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    warp_external_input_check_int8(ptr[0]);
    extern_input_check1(len=len - 1, ptr=ptr + 1);
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

func abi_encode_packed0{
    bitwise_ptr: BitwiseBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(param0: felt, param1: felt, param2: felt) -> (result_ptr: felt) {
    alloc_locals;
    let bytes_index: felt = 0;
    let (bytes_array: felt*) = alloc();
    let (param0256) = felt_to_uint256(param0);
    fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param0256);
    let bytes_index = bytes_index + 32;
    fixed_bytes_to_felt_dynamic_array(bytes_index, bytes_array, 0, param1, 3);
    let bytes_index = bytes_index + 3;
    fixed_bytes_to_felt_dynamic_array(bytes_index, bytes_array, 0, param2, 3);
    let bytes_index = bytes_index + 3;
    let (max_length256) = felt_to_uint256(bytes_index);
    let (mem_ptr) = wm_new(max_length256, Uint256(0x1, 0x0));
    felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_index);
    return (mem_ptr,);
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

@storage_var
func WARP_MAPPING1(name: felt, index: felt) -> (resLoc: felt) {
}
func WS1_INDEX_felt_to_Uint256{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}(name: felt, index: felt) -> (res: felt) {
    alloc_locals;
    let (existing) = WARP_MAPPING1.read(name, index);
    if (existing == 0) {
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING1.write(name, index, used);
        return (used,);
    } else {
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING2(name: felt, index: Uint256) -> (resLoc: felt) {
}
func WS2_INDEX_Uint256_to_Info_d529aac3{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}(name: felt, index: Uint256) -> (res: felt) {
    alloc_locals;
    let (existing) = WARP_MAPPING2.read(name, index);
    if (existing == 0) {
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 7);
        WARP_MAPPING2.write(name, index, used);
        return (used,);
    } else {
        return (existing,);
    }
}

// Contract Def MockTimeUniswapV3Pool

// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
// @param sender The address that collects the protocol fees
// @param recipient The address that receives the collected protocol fees
// @param amount0 The amount of token0 protocol fees that is withdrawn
// @param amount0 The amount of token1 protocol fees that is withdrawn
@event
func CollectProtocol_596b5739(
    __warp_usrid_40_sender: felt,
    __warp_usrid_41_recipient: felt,
    __warp_usrid_42_amount0: felt,
    __warp_usrid_43_amount1: felt,
) {
}

// @notice Emitted when the protocol fee is changed by the pool
// @param feeProtocol0Old The previous value of the token0 protocol fee
// @param feeProtocol1Old The previous value of the token1 protocol fee
// @param feeProtocol0New The updated value of the token0 protocol fee
// @param feeProtocol1New The updated value of the token1 protocol fee
@event
func SetFeeProtocol_973d8d92(
    __warp_usrid_36_feeProtocol0Old: felt,
    __warp_usrid_37_feeProtocol1Old: felt,
    __warp_usrid_38_feeProtocol0New: felt,
    __warp_usrid_39_feeProtocol1New: felt,
) {
}

// @notice Emitted by the pool for increases to the number of observations that can be stored
// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
// just before a mint/swap/burn.
// @param observationCardinalityNextOld The previous value of the next observation cardinality
// @param observationCardinalityNextNew The updated value of the next observation cardinality
@event
func IncreaseObservationCardinalityNext_ac49e518(
    __warp_usrid_34_observationCardinalityNextOld: felt,
    __warp_usrid_35_observationCardinalityNextNew: felt,
) {
}

// @notice Emitted by the pool for any flashes of token0/token1
// @param sender The address that initiated the swap call, and that received the callback
// @param recipient The address that received the tokens from flash
// @param amount0 The amount of token0 that was flashed
// @param amount1 The amount of token1 that was flashed
// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
@event
func Flash_bdbdb71d(
    __warp_usrid_28_sender: felt,
    __warp_usrid_29_recipient: felt,
    __warp_usrid_30_amount0: Uint256,
    __warp_usrid_31_amount1: Uint256,
    __warp_usrid_32_paid0: Uint256,
    __warp_usrid_33_paid1: Uint256,
) {
}

// @notice Emitted by the pool for any swaps between token0 and token1
// @param sender The address that initiated the swap call, and that received the callback
// @param recipient The address that received the output of the swap
// @param amount0 The delta of the token0 balance of the pool
// @param amount1 The delta of the token1 balance of the pool
// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
// @param liquidity The liquidity of the pool after the swap
// @param tick The log base 1.0001 of price of the pool after the swap
@event
func Swap_c42079f9(
    __warp_usrid_21_sender: felt,
    __warp_usrid_22_recipient: felt,
    __warp_usrid_23_amount0: Uint256,
    __warp_usrid_24_amount1: Uint256,
    __warp_usrid_25_sqrtPriceX96: felt,
    __warp_usrid_26_liquidity: felt,
    __warp_usrid_27_tick: felt,
) {
}

// @notice Emitted when a position's liquidity is removed
// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
// @param owner The owner of the position for which liquidity is removed
// @param tickLower The lower tick of the position
// @param tickUpper The upper tick of the position
// @param amount The amount of liquidity to remove
// @param amount0 The amount of token0 withdrawn
// @param amount1 The amount of token1 withdrawn
@event
func Burn_0c396cd9(
    __warp_usrid_15_owner: felt,
    __warp_usrid_16_tickLower: felt,
    __warp_usrid_17_tickUpper: felt,
    __warp_usrid_18_amount: felt,
    __warp_usrid_19_amount0: Uint256,
    __warp_usrid_20_amount1: Uint256,
) {
}

// @notice Emitted when fees are collected by the owner of a position
// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
// @param owner The owner of the position for which fees are collected
// @param tickLower The lower tick of the position
// @param tickUpper The upper tick of the position
// @param amount0 The amount of token0 fees collected
// @param amount1 The amount of token1 fees collected
@event
func Collect_70935338(
    __warp_usrid_09_owner: felt,
    __warp_usrid_10_recipient: felt,
    __warp_usrid_11_tickLower: felt,
    __warp_usrid_12_tickUpper: felt,
    __warp_usrid_13_amount0: felt,
    __warp_usrid_14_amount1: felt,
) {
}

// @notice Emitted when liquidity is minted for a given position
// @param sender The address that minted the liquidity
// @param owner The owner of the position and recipient of any minted liquidity
// @param tickLower The lower tick of the position
// @param tickUpper The upper tick of the position
// @param amount The amount of liquidity minted to the position range
// @param amount0 How much token0 was required for the minted liquidity
// @param amount1 How much token1 was required for the minted liquidity
@event
func Mint_7a53080b(
    __warp_usrid_02_sender: felt,
    __warp_usrid_03_owner: felt,
    __warp_usrid_04_tickLower: felt,
    __warp_usrid_05_tickUpper: felt,
    __warp_usrid_06_amount: felt,
    __warp_usrid_07_amount0: Uint256,
    __warp_usrid_08_amount1: Uint256,
) {
}

// @notice Emitted exactly once by a pool when #initialize is first called on the pool
// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
@event
func Initialize_98636036(__warp_usrid_00_sqrtPriceX96: felt, __warp_usrid_01_tick: felt) {
}

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

namespace MockTimeUniswapV3Pool {
    // Dynamic variables - Arrays and Maps

    const __warp_usrid_045_ticks = 1;

    const __warp_usrid_046_tickBitmap = 2;

    const __warp_usrid_047_positions = 3;

    // Static variables

    const __warp_usrid_00_time = 0;

    const __warp_usrid_00_original = 2;

    const __warp_usrid_033_loopRuns = 3;

    const __warp_usrid_034_factory = 5;

    const __warp_usrid_035_token0 = 6;

    const __warp_usrid_036_token1 = 7;

    const __warp_usrid_037_fee = 8;

    const __warp_usrid_038_tickSpacing = 9;

    const __warp_usrid_039_maxLiquidityPerTick = 10;

    const __warp_usrid_040_slot0 = 11;

    const __warp_usrid_041_feeGrowthGlobal0X128 = 18;

    const __warp_usrid_042_feeGrowthGlobal1X128 = 20;

    const __warp_usrid_043_protocolFees = 22;

    const __warp_usrid_044_liquidity = 24;

    const __warp_usrid_048_observations = 28;

    func __warp_while10{
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
            ) = __warp_while10_if_part1(
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

    func __warp_while10_if_part1{
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
        ) = __warp_while10(
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

    func __warp_while9{
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
                ) = __warp_while9(
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
                ) = __warp_while9_if_part2(
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

    func __warp_while9_if_part2{
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
            ) = __warp_while9_if_part2_if_part1(
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

    func __warp_while9_if_part2_if_part1{
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
            ) = __warp_while9_if_part2_if_part1_if_part1(
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
            ) = __warp_while9_if_part2_if_part1_if_part1(
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

    func __warp_while9_if_part2_if_part1_if_part1{
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
        ) = __warp_while9_if_part1(
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

    func __warp_while9_if_part1{
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
        ) = __warp_while9(
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

    func __warp_while8{
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

            let (__warp_usrid_30_i, __warp_usrid_28_next, __warp_td_42) = __warp_while8_if_part1(
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

    func __warp_while8_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_30_i: felt, __warp_usrid_28_next: felt, __warp_usrid_26_self: felt) -> (
        __warp_usrid_30_i: felt, __warp_usrid_28_next: felt, __warp_usrid_26_self: felt
    ) {
        alloc_locals;

        let (__warp_usrid_30_i, __warp_usrid_28_next, __warp_td_44) = __warp_while8(
            __warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self
        );

        let __warp_usrid_26_self = __warp_td_44;

        return (__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);
    }

    func _conditional1{range_check_ptr: felt, warp_memory: DictAccess*}(
        __warp_usrid_146_state: felt, __warp_usrid_139_sqrtPriceLimitX96: felt
    ) -> (
        ret_conditional2: felt,
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
    ) {
        alloc_locals;

        let (__warp_se_35) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(
            __warp_usrid_146_state
        );

        let (__warp_se_36) = wm_read_256(__warp_se_35);

        let (__warp_se_37) = warp_neq256(__warp_se_36, Uint256(low=0, high=0));

        if (__warp_se_37 != 0) {
            let (__warp_se_38) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(
                __warp_usrid_146_state
            );

            let (__warp_se_39) = wm_read_felt(__warp_se_38);

            let (__warp_se_40) = warp_neq(__warp_se_39, __warp_usrid_139_sqrtPriceLimitX96);

            let ret_conditional2 = __warp_se_40;

            return (ret_conditional2, __warp_usrid_146_state, __warp_usrid_139_sqrtPriceLimitX96);
        } else {
            let ret_conditional2 = 0;

            return (ret_conditional2, __warp_usrid_146_state, __warp_usrid_139_sqrtPriceLimitX96);
        }
    }

    func __warp_while7{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let ret_conditional3 = 0;

        let (
            ret_conditional3, __warp_usrid_146_state, __warp_usrid_139_sqrtPriceLimitX96
        ) = _conditional1(__warp_usrid_146_state, __warp_usrid_139_sqrtPriceLimitX96);

        if (ret_conditional3 != 0) {
            let (__warp_se_41) = WS0_READ_Uint256(__warp_usrid_033_loopRuns);

            let (__warp_se_42) = warp_add_unsafe256(__warp_se_41, Uint256(low=1, high=0));

            let (__warp_se_43) = WS_WRITE1(__warp_usrid_033_loopRuns, __warp_se_42);

            warp_sub_unsafe256(__warp_se_43, Uint256(low=1, high=0));

            let (__warp_usrid_147_step) = WM0_struct_StepComputations_cf1844f5(
                0, 0, 0, 0, Uint256(low=0, high=0), Uint256(low=0, high=0), Uint256(low=0, high=0)
            );

            let (__warp_se_44) = WM4_StepComputations_cf1844f5___warp_usrid_026_sqrtPriceStartX96(
                __warp_usrid_147_step
            );

            let (__warp_se_45) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(
                __warp_usrid_146_state
            );

            let (__warp_se_46) = wm_read_felt(__warp_se_45);

            wm_write_felt(__warp_se_44, __warp_se_46);

            let (__warp_se_47) = WM5_SwapState_eba3c779___warp_usrid_022_tick(
                __warp_usrid_146_state
            );

            let (__warp_se_48) = wm_read_felt(__warp_se_47);

            let (__warp_se_49) = WS1_READ_felt(__warp_usrid_038_tickSpacing);

            let (__warp_tv_2, __warp_tv_3) = nextInitializedTickWithinOneWord_a52a(
                __warp_usrid_046_tickBitmap, __warp_se_48, __warp_se_49, __warp_usrid_137_zeroForOne
            );

            let (__warp_se_50) = WM6_StepComputations_cf1844f5___warp_usrid_028_initialized(
                __warp_usrid_147_step
            );

            wm_write_felt(__warp_se_50, __warp_tv_3);

            let (__warp_se_51) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(
                __warp_usrid_147_step
            );

            wm_write_felt(__warp_se_51, __warp_tv_2);

            let (__warp_se_52) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(
                __warp_usrid_147_step
            );

            let (__warp_se_53) = wm_read_felt(__warp_se_52);

            let (__warp_se_54) = warp_lt_signed24(__warp_se_53, 15889944);

            if (__warp_se_54 != 0) {
                let (__warp_se_55) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(
                    __warp_usrid_147_step
                );

                wm_write_felt(__warp_se_55, 15889944);

                let (
                    __warp_td_45,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_td_46,
                    __warp_td_47,
                ) = __warp_while7_if_part2(
                    __warp_usrid_147_step,
                    __warp_usrid_146_state,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_144_cache,
                    __warp_usrid_143_slot0Start,
                );

                let __warp_usrid_146_state = __warp_td_45;

                let __warp_usrid_144_cache = __warp_td_46;

                let __warp_usrid_143_slot0Start = __warp_td_47;

                return (
                    __warp_usrid_146_state,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_144_cache,
                    __warp_usrid_143_slot0Start,
                );
            } else {
                let (__warp_se_56) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(
                    __warp_usrid_147_step
                );

                let (__warp_se_57) = wm_read_felt(__warp_se_56);

                let (__warp_se_58) = warp_gt_signed24(__warp_se_57, 887272);

                if (__warp_se_58 != 0) {
                    let (__warp_se_59) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(
                        __warp_usrid_147_step
                    );

                    wm_write_felt(__warp_se_59, 887272);

                    let (
                        __warp_td_48,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_145_exactInput,
                        __warp_td_49,
                        __warp_td_50,
                    ) = __warp_while7_if_part3(
                        __warp_usrid_147_step,
                        __warp_usrid_146_state,
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_145_exactInput,
                        __warp_usrid_144_cache,
                        __warp_usrid_143_slot0Start,
                    );

                    let __warp_usrid_146_state = __warp_td_48;

                    let __warp_usrid_144_cache = __warp_td_49;

                    let __warp_usrid_143_slot0Start = __warp_td_50;

                    return (
                        __warp_usrid_146_state,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_145_exactInput,
                        __warp_usrid_144_cache,
                        __warp_usrid_143_slot0Start,
                    );
                } else {
                    let (
                        __warp_td_51,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_145_exactInput,
                        __warp_td_52,
                        __warp_td_53,
                    ) = __warp_while7_if_part3(
                        __warp_usrid_147_step,
                        __warp_usrid_146_state,
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_145_exactInput,
                        __warp_usrid_144_cache,
                        __warp_usrid_143_slot0Start,
                    );

                    let __warp_usrid_146_state = __warp_td_51;

                    let __warp_usrid_144_cache = __warp_td_52;

                    let __warp_usrid_143_slot0Start = __warp_td_53;

                    return (
                        __warp_usrid_146_state,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_145_exactInput,
                        __warp_usrid_144_cache,
                        __warp_usrid_143_slot0Start,
                    );
                }
            }
        } else {
            let __warp_usrid_146_state = __warp_usrid_146_state;

            let __warp_usrid_139_sqrtPriceLimitX96 = __warp_usrid_139_sqrtPriceLimitX96;

            let __warp_usrid_137_zeroForOne = __warp_usrid_137_zeroForOne;

            let __warp_usrid_145_exactInput = __warp_usrid_145_exactInput;

            let __warp_usrid_144_cache = __warp_usrid_144_cache;

            let __warp_usrid_143_slot0Start = __warp_usrid_143_slot0Start;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        }
    }

    func __warp_while7_if_part3{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_147_step: felt,
        __warp_usrid_146_state: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (
            __warp_td_57,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_td_58,
            __warp_td_59,
        ) = __warp_while7_if_part2(
            __warp_usrid_147_step,
            __warp_usrid_146_state,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );

        let __warp_usrid_146_state = __warp_td_57;

        let __warp_usrid_144_cache = __warp_td_58;

        let __warp_usrid_143_slot0Start = __warp_td_59;

        return (
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );
    }

    func __warp_while7_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_147_step: felt,
        __warp_usrid_146_state: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (__warp_se_60) = WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(
            __warp_usrid_147_step
        );

        let (__warp_se_61) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(
            __warp_usrid_147_step
        );

        let (__warp_se_62) = wm_read_felt(__warp_se_61);

        let (__warp_se_63) = getSqrtRatioAtTick_986cfba3(__warp_se_62);

        wm_write_felt(__warp_se_60, __warp_se_63);

        let (__warp_se_64) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(
            __warp_usrid_146_state
        );

        let (__warp_se_65) = wm_read_felt(__warp_se_64);

        let (__warp_se_66) = conditional3_e92662c8(
            __warp_usrid_137_zeroForOne, __warp_usrid_139_sqrtPriceLimitX96, __warp_usrid_147_step
        );

        let (__warp_se_67) = conditional2_a88d8ea4(
            __warp_se_66, __warp_usrid_139_sqrtPriceLimitX96, __warp_usrid_147_step
        );

        let (__warp_se_68) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(
            __warp_usrid_146_state
        );

        let (__warp_se_69) = wm_read_felt(__warp_se_68);

        let (__warp_se_70) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(
            __warp_usrid_146_state
        );

        let (__warp_se_71) = wm_read_256(__warp_se_70);

        let (__warp_se_72) = WS1_READ_felt(__warp_usrid_037_fee);

        let (__warp_tv_4, __warp_tv_5, __warp_tv_6, __warp_tv_7) = computeSwapStep_100d3f74(
            __warp_se_65, __warp_se_67, __warp_se_69, __warp_se_71, __warp_se_72
        );

        let (__warp_se_73) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(
            __warp_usrid_147_step
        );

        wm_write_256(__warp_se_73, __warp_tv_7);

        let (__warp_se_74) = WM11_StepComputations_cf1844f5___warp_usrid_031_amountOut(
            __warp_usrid_147_step
        );

        wm_write_256(__warp_se_74, __warp_tv_6);

        let (__warp_se_75) = WM12_StepComputations_cf1844f5___warp_usrid_030_amountIn(
            __warp_usrid_147_step
        );

        wm_write_256(__warp_se_75, __warp_tv_5);

        let (__warp_se_76) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(
            __warp_usrid_146_state
        );

        wm_write_felt(__warp_se_76, __warp_tv_4);

        if (__warp_usrid_145_exactInput != 0) {
            let (__warp_se_77) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(
                __warp_usrid_146_state
            );

            let (__warp_se_78) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(
                __warp_usrid_146_state
            );

            let (__warp_se_79) = wm_read_256(__warp_se_78);

            let (__warp_se_80) = WM12_StepComputations_cf1844f5___warp_usrid_030_amountIn(
                __warp_usrid_147_step
            );

            let (__warp_se_81) = wm_read_256(__warp_se_80);

            let (__warp_se_82) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(
                __warp_usrid_147_step
            );

            let (__warp_se_83) = wm_read_256(__warp_se_82);

            let (__warp_se_84) = warp_add_unsafe256(__warp_se_81, __warp_se_83);

            let (__warp_se_85) = toInt256_dfbe873b(__warp_se_84);

            let (__warp_se_86) = warp_sub_signed_unsafe256(__warp_se_79, __warp_se_85);

            wm_write_256(__warp_se_77, __warp_se_86);

            let (__warp_se_87) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(
                __warp_usrid_146_state
            );

            let (__warp_se_88) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(
                __warp_usrid_146_state
            );

            let (__warp_se_89) = wm_read_256(__warp_se_88);

            let (__warp_se_90) = WM11_StepComputations_cf1844f5___warp_usrid_031_amountOut(
                __warp_usrid_147_step
            );

            let (__warp_se_91) = wm_read_256(__warp_se_90);

            let (__warp_se_92) = toInt256_dfbe873b(__warp_se_91);

            let (__warp_se_93) = sub_adefc37b(__warp_se_89, __warp_se_92);

            wm_write_256(__warp_se_87, __warp_se_93);

            let (
                __warp_td_60,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_td_61,
                __warp_td_62,
            ) = __warp_while7_if_part2_if_part1(
                __warp_usrid_144_cache,
                __warp_usrid_147_step,
                __warp_usrid_146_state,
                __warp_usrid_143_slot0Start,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_145_exactInput,
            );

            let __warp_usrid_146_state = __warp_td_60;

            let __warp_usrid_144_cache = __warp_td_61;

            let __warp_usrid_143_slot0Start = __warp_td_62;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        } else {
            let (__warp_se_94) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(
                __warp_usrid_146_state
            );

            let (__warp_se_95) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(
                __warp_usrid_146_state
            );

            let (__warp_se_96) = wm_read_256(__warp_se_95);

            let (__warp_se_97) = WM11_StepComputations_cf1844f5___warp_usrid_031_amountOut(
                __warp_usrid_147_step
            );

            let (__warp_se_98) = wm_read_256(__warp_se_97);

            let (__warp_se_99) = toInt256_dfbe873b(__warp_se_98);

            let (__warp_se_100) = warp_add_signed_unsafe256(__warp_se_96, __warp_se_99);

            wm_write_256(__warp_se_94, __warp_se_100);

            let (__warp_se_101) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(
                __warp_usrid_146_state
            );

            let (__warp_se_102) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(
                __warp_usrid_146_state
            );

            let (__warp_se_103) = wm_read_256(__warp_se_102);

            let (__warp_se_104) = WM12_StepComputations_cf1844f5___warp_usrid_030_amountIn(
                __warp_usrid_147_step
            );

            let (__warp_se_105) = wm_read_256(__warp_se_104);

            let (__warp_se_106) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(
                __warp_usrid_147_step
            );

            let (__warp_se_107) = wm_read_256(__warp_se_106);

            let (__warp_se_108) = warp_add_unsafe256(__warp_se_105, __warp_se_107);

            let (__warp_se_109) = toInt256_dfbe873b(__warp_se_108);

            let (__warp_se_110) = add_a5f3c23b(__warp_se_103, __warp_se_109);

            wm_write_256(__warp_se_101, __warp_se_110);

            let (
                __warp_td_63,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_td_64,
                __warp_td_65,
            ) = __warp_while7_if_part2_if_part1(
                __warp_usrid_144_cache,
                __warp_usrid_147_step,
                __warp_usrid_146_state,
                __warp_usrid_143_slot0Start,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_145_exactInput,
            );

            let __warp_usrid_146_state = __warp_td_63;

            let __warp_usrid_144_cache = __warp_td_64;

            let __warp_usrid_143_slot0Start = __warp_td_65;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        }
    }

    func __warp_while7_if_part2_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_144_cache: felt,
        __warp_usrid_147_step: felt,
        __warp_usrid_146_state: felt,
        __warp_usrid_143_slot0Start: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_145_exactInput: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (__warp_se_111) = WM14_SwapCache_7600c2b6___warp_usrid_013_feeProtocol(
            __warp_usrid_144_cache
        );

        let (__warp_se_112) = wm_read_felt(__warp_se_111);

        let (__warp_se_113) = warp_gt(__warp_se_112, 0);

        if (__warp_se_113 != 0) {
            let (__warp_se_114) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(
                __warp_usrid_147_step
            );

            let (__warp_se_115) = wm_read_256(__warp_se_114);

            let (__warp_se_116) = WM14_SwapCache_7600c2b6___warp_usrid_013_feeProtocol(
                __warp_usrid_144_cache
            );

            let (__warp_se_117) = wm_read_felt(__warp_se_116);

            let (__warp_se_118) = warp_uint256(__warp_se_117);

            let (__warp_usrid_148_delta) = warp_div_unsafe256(__warp_se_115, __warp_se_118);

            let (__warp_se_119) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(
                __warp_usrid_147_step
            );

            let (__warp_se_120) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(
                __warp_usrid_147_step
            );

            let (__warp_se_121) = wm_read_256(__warp_se_120);

            let (__warp_se_122) = warp_sub_unsafe256(__warp_se_121, __warp_usrid_148_delta);

            wm_write_256(__warp_se_119, __warp_se_122);

            let (__warp_se_123) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(
                __warp_usrid_146_state
            );

            let (__warp_se_124) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(
                __warp_usrid_146_state
            );

            let (__warp_se_125) = wm_read_felt(__warp_se_124);

            let (__warp_se_126) = warp_int256_to_int128(__warp_usrid_148_delta);

            let (__warp_se_127) = warp_add_unsafe128(__warp_se_125, __warp_se_126);

            wm_write_felt(__warp_se_123, __warp_se_127);

            let (
                __warp_td_66,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_td_67,
                __warp_td_68,
            ) = __warp_while7_if_part2_if_part1_if_part1(
                __warp_usrid_146_state,
                __warp_usrid_147_step,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_145_exactInput,
            );

            let __warp_usrid_146_state = __warp_td_66;

            let __warp_usrid_144_cache = __warp_td_67;

            let __warp_usrid_143_slot0Start = __warp_td_68;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        } else {
            let (
                __warp_td_69,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_td_70,
                __warp_td_71,
            ) = __warp_while7_if_part2_if_part1_if_part1(
                __warp_usrid_146_state,
                __warp_usrid_147_step,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_145_exactInput,
            );

            let __warp_usrid_146_state = __warp_td_69;

            let __warp_usrid_144_cache = __warp_td_70;

            let __warp_usrid_143_slot0Start = __warp_td_71;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        }
    }

    func __warp_while7_if_part2_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_146_state: felt,
        __warp_usrid_147_step: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_145_exactInput: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (__warp_se_128) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(
            __warp_usrid_146_state
        );

        let (__warp_se_129) = wm_read_felt(__warp_se_128);

        let (__warp_se_130) = warp_gt(__warp_se_129, 0);

        if (__warp_se_130 != 0) {
            let (__warp_se_131) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(
                __warp_usrid_146_state
            );

            let (__warp_se_132) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(
                __warp_usrid_146_state
            );

            let (__warp_se_133) = wm_read_256(__warp_se_132);

            let (__warp_se_134) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(
                __warp_usrid_147_step
            );

            let (__warp_se_135) = wm_read_256(__warp_se_134);

            let (__warp_se_136) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(
                __warp_usrid_146_state
            );

            let (__warp_se_137) = wm_read_felt(__warp_se_136);

            let (__warp_se_138) = warp_uint256(__warp_se_137);

            let (__warp_se_139) = mulDiv_aa9a0912(
                __warp_se_135, Uint256(low=0, high=1), __warp_se_138
            );

            let (__warp_se_140) = warp_add_unsafe256(__warp_se_133, __warp_se_139);

            wm_write_256(__warp_se_131, __warp_se_140);

            let (
                __warp_td_72,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_td_73,
                __warp_td_74,
            ) = __warp_while7_if_part2_if_part1_if_part1_if_part1(
                __warp_usrid_146_state,
                __warp_usrid_147_step,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_145_exactInput,
            );

            let __warp_usrid_146_state = __warp_td_72;

            let __warp_usrid_144_cache = __warp_td_73;

            let __warp_usrid_143_slot0Start = __warp_td_74;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        } else {
            let (
                __warp_td_75,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_td_76,
                __warp_td_77,
            ) = __warp_while7_if_part2_if_part1_if_part1_if_part1(
                __warp_usrid_146_state,
                __warp_usrid_147_step,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_145_exactInput,
            );

            let __warp_usrid_146_state = __warp_td_75;

            let __warp_usrid_144_cache = __warp_td_76;

            let __warp_usrid_143_slot0Start = __warp_td_77;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        }
    }

    func __warp_while7_if_part2_if_part1_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_146_state: felt,
        __warp_usrid_147_step: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_145_exactInput: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (__warp_se_141) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(
            __warp_usrid_146_state
        );

        let (__warp_se_142) = wm_read_felt(__warp_se_141);

        let (__warp_se_143) = WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(
            __warp_usrid_147_step
        );

        let (__warp_se_144) = wm_read_felt(__warp_se_143);

        let (__warp_se_145) = warp_eq(__warp_se_142, __warp_se_144);

        if (__warp_se_145 != 0) {
            let (__warp_se_146) = WM6_StepComputations_cf1844f5___warp_usrid_028_initialized(
                __warp_usrid_147_step
            );

            let (__warp_se_147) = wm_read_felt(__warp_se_146);

            if (__warp_se_147 != 0) {
                let (
                    __warp_se_148
                ) = WM17_SwapCache_7600c2b6___warp_usrid_018_computedLatestObservation(
                    __warp_usrid_144_cache
                );

                let (__warp_se_149) = wm_read_felt(__warp_se_148);

                if (1 - __warp_se_149 != 0) {
                    let (__warp_se_150) = WM18_SwapCache_7600c2b6___warp_usrid_015_blockTimestamp(
                        __warp_usrid_144_cache
                    );

                    let (__warp_se_151) = wm_read_felt(__warp_se_150);

                    let (__warp_se_152) = WM19_Slot0_930d2817___warp_usrid_001_tick(
                        __warp_usrid_143_slot0Start
                    );

                    let (__warp_se_153) = wm_read_felt(__warp_se_152);

                    let (__warp_se_154) = WM20_Slot0_930d2817___warp_usrid_002_observationIndex(
                        __warp_usrid_143_slot0Start
                    );

                    let (__warp_se_155) = wm_read_felt(__warp_se_154);

                    let (__warp_se_156) = WM21_SwapCache_7600c2b6___warp_usrid_014_liquidityStart(
                        __warp_usrid_144_cache
                    );

                    let (__warp_se_157) = wm_read_felt(__warp_se_156);

                    let (
                        __warp_se_158
                    ) = WM22_Slot0_930d2817___warp_usrid_003_observationCardinality(
                        __warp_usrid_143_slot0Start
                    );

                    let (__warp_se_159) = wm_read_felt(__warp_se_158);

                    let (__warp_tv_8, __warp_tv_9) = observeSingle_f7f8d6a0(
                        __warp_usrid_048_observations,
                        __warp_se_151,
                        0,
                        __warp_se_153,
                        __warp_se_155,
                        __warp_se_157,
                        __warp_se_159,
                    );

                    let (
                        __warp_se_160
                    ) = WM23_SwapCache_7600c2b6___warp_usrid_017_secondsPerLiquidityCumulativeX128(
                        __warp_usrid_144_cache
                    );

                    wm_write_felt(__warp_se_160, __warp_tv_9);

                    let (__warp_se_161) = WM24_SwapCache_7600c2b6___warp_usrid_016_tickCumulative(
                        __warp_usrid_144_cache
                    );

                    wm_write_felt(__warp_se_161, __warp_tv_8);

                    let (
                        __warp_se_162
                    ) = WM17_SwapCache_7600c2b6___warp_usrid_018_computedLatestObservation(
                        __warp_usrid_144_cache
                    );

                    wm_write_felt(__warp_se_162, 1);

                    let (
                        __warp_td_78,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_145_exactInput,
                        __warp_td_79,
                        __warp_td_80,
                    ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part3(
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_146_state,
                        __warp_usrid_147_step,
                        __warp_usrid_144_cache,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_145_exactInput,
                        __warp_usrid_143_slot0Start,
                    );

                    let __warp_usrid_146_state = __warp_td_78;

                    let __warp_usrid_144_cache = __warp_td_79;

                    let __warp_usrid_143_slot0Start = __warp_td_80;

                    return (
                        __warp_usrid_146_state,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_145_exactInput,
                        __warp_usrid_144_cache,
                        __warp_usrid_143_slot0Start,
                    );
                } else {
                    let (
                        __warp_td_81,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_145_exactInput,
                        __warp_td_82,
                        __warp_td_83,
                    ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part3(
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_146_state,
                        __warp_usrid_147_step,
                        __warp_usrid_144_cache,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_145_exactInput,
                        __warp_usrid_143_slot0Start,
                    );

                    let __warp_usrid_146_state = __warp_td_81;

                    let __warp_usrid_144_cache = __warp_td_82;

                    let __warp_usrid_143_slot0Start = __warp_td_83;

                    return (
                        __warp_usrid_146_state,
                        __warp_usrid_139_sqrtPriceLimitX96,
                        __warp_usrid_137_zeroForOne,
                        __warp_usrid_145_exactInput,
                        __warp_usrid_144_cache,
                        __warp_usrid_143_slot0Start,
                    );
                }
            } else {
                let (
                    __warp_td_84,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_td_85,
                    __warp_td_86,
                ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_146_state,
                    __warp_usrid_147_step,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_144_cache,
                    __warp_usrid_143_slot0Start,
                );

                let __warp_usrid_146_state = __warp_td_84;

                let __warp_usrid_144_cache = __warp_td_85;

                let __warp_usrid_143_slot0Start = __warp_td_86;

                return (
                    __warp_usrid_146_state,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_144_cache,
                    __warp_usrid_143_slot0Start,
                );
            }
        } else {
            let (__warp_se_163) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(
                __warp_usrid_146_state
            );

            let (__warp_se_164) = wm_read_felt(__warp_se_163);

            let (__warp_se_165) = WM4_StepComputations_cf1844f5___warp_usrid_026_sqrtPriceStartX96(
                __warp_usrid_147_step
            );

            let (__warp_se_166) = wm_read_felt(__warp_se_165);

            let (__warp_se_167) = warp_neq(__warp_se_164, __warp_se_166);

            if (__warp_se_167 != 0) {
                let (__warp_se_168) = WM5_SwapState_eba3c779___warp_usrid_022_tick(
                    __warp_usrid_146_state
                );

                let (__warp_se_169) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(
                    __warp_usrid_146_state
                );

                let (__warp_se_170) = wm_read_felt(__warp_se_169);

                let (__warp_se_171) = getTickAtSqrtRatio_4f76c058(__warp_se_170);

                wm_write_felt(__warp_se_168, __warp_se_171);

                let (
                    __warp_td_87,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_td_88,
                    __warp_td_89,
                ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part4(
                    __warp_usrid_146_state,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_144_cache,
                    __warp_usrid_143_slot0Start,
                );

                let __warp_usrid_146_state = __warp_td_87;

                let __warp_usrid_144_cache = __warp_td_88;

                let __warp_usrid_143_slot0Start = __warp_td_89;

                return (
                    __warp_usrid_146_state,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_144_cache,
                    __warp_usrid_143_slot0Start,
                );
            } else {
                let (
                    __warp_td_90,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_td_91,
                    __warp_td_92,
                ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part4(
                    __warp_usrid_146_state,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_144_cache,
                    __warp_usrid_143_slot0Start,
                );

                let __warp_usrid_146_state = __warp_td_90;

                let __warp_usrid_144_cache = __warp_td_91;

                let __warp_usrid_143_slot0Start = __warp_td_92;

                return (
                    __warp_usrid_146_state,
                    __warp_usrid_139_sqrtPriceLimitX96,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_144_cache,
                    __warp_usrid_143_slot0Start,
                );
            }
        }
    }

    func __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part4{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (
            __warp_td_93,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_td_94,
            __warp_td_95,
        ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part1(
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );

        let __warp_usrid_146_state = __warp_td_93;

        let __warp_usrid_144_cache = __warp_td_94;

        let __warp_usrid_143_slot0Start = __warp_td_95;

        return (
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );
    }

    func __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part3{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_146_state: felt,
        __warp_usrid_147_step: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_143_slot0Start: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (__warp_usrid_149_aux0) = conditional4_9427c021(
            __warp_usrid_137_zeroForOne, __warp_usrid_146_state
        );

        let (__warp_usrid_150_aux1) = conditional5_28dc1807(
            __warp_usrid_137_zeroForOne, __warp_usrid_146_state
        );

        let (__warp_se_172) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(
            __warp_usrid_147_step
        );

        let (__warp_se_173) = wm_read_felt(__warp_se_172);

        let (
            __warp_se_174
        ) = WM23_SwapCache_7600c2b6___warp_usrid_017_secondsPerLiquidityCumulativeX128(
            __warp_usrid_144_cache
        );

        let (__warp_se_175) = wm_read_felt(__warp_se_174);

        let (__warp_se_176) = WM24_SwapCache_7600c2b6___warp_usrid_016_tickCumulative(
            __warp_usrid_144_cache
        );

        let (__warp_se_177) = wm_read_felt(__warp_se_176);

        let (__warp_se_178) = WM18_SwapCache_7600c2b6___warp_usrid_015_blockTimestamp(
            __warp_usrid_144_cache
        );

        let (__warp_se_179) = wm_read_felt(__warp_se_178);

        let (__warp_usrid_151_liquidityNet) = cross_5d47(
            __warp_usrid_045_ticks,
            __warp_se_173,
            __warp_usrid_149_aux0,
            __warp_usrid_150_aux1,
            __warp_se_175,
            __warp_se_177,
            __warp_se_179,
        );

        if (__warp_usrid_137_zeroForOne != 0) {
            let (__warp_se_180) = warp_negate128(__warp_usrid_151_liquidityNet);

            let __warp_usrid_151_liquidityNet = __warp_se_180;

            let (
                __warp_td_96,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_td_97,
                __warp_td_98,
            ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part3_if_part1(
                __warp_usrid_146_state,
                __warp_usrid_151_liquidityNet,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_147_step,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );

            let __warp_usrid_146_state = __warp_td_96;

            let __warp_usrid_144_cache = __warp_td_97;

            let __warp_usrid_143_slot0Start = __warp_td_98;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        } else {
            let (
                __warp_td_99,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_td_100,
                __warp_td_101,
            ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part3_if_part1(
                __warp_usrid_146_state,
                __warp_usrid_151_liquidityNet,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_147_step,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );

            let __warp_usrid_146_state = __warp_td_99;

            let __warp_usrid_144_cache = __warp_td_100;

            let __warp_usrid_143_slot0Start = __warp_td_101;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        }
    }

    func __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part3_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_146_state: felt,
        __warp_usrid_151_liquidityNet: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_147_step: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (__warp_se_181) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(
            __warp_usrid_146_state
        );

        let (__warp_se_182) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(
            __warp_usrid_146_state
        );

        let (__warp_se_183) = wm_read_felt(__warp_se_182);

        let (__warp_se_184) = addDelta_402d44fb(__warp_se_183, __warp_usrid_151_liquidityNet);

        wm_write_felt(__warp_se_181, __warp_se_184);

        let (
            __warp_td_102,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_td_103,
            __warp_td_104,
        ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part2(
            __warp_usrid_137_zeroForOne,
            __warp_usrid_146_state,
            __warp_usrid_147_step,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );

        let __warp_usrid_146_state = __warp_td_102;

        let __warp_usrid_144_cache = __warp_td_103;

        let __warp_usrid_143_slot0Start = __warp_td_104;

        return (
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );
    }

    func __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_146_state: felt,
        __warp_usrid_147_step: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        if (__warp_usrid_137_zeroForOne != 0) {
            let (__warp_se_185) = WM5_SwapState_eba3c779___warp_usrid_022_tick(
                __warp_usrid_146_state
            );

            let (__warp_se_186) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(
                __warp_usrid_147_step
            );

            let (__warp_se_187) = wm_read_felt(__warp_se_186);

            let (__warp_se_188) = warp_sub_signed_unsafe24(__warp_se_187, 1);

            wm_write_felt(__warp_se_185, __warp_se_188);

            let (
                __warp_td_105,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_td_106,
                __warp_td_107,
            ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part2_if_part1(
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );

            let __warp_usrid_146_state = __warp_td_105;

            let __warp_usrid_144_cache = __warp_td_106;

            let __warp_usrid_143_slot0Start = __warp_td_107;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        } else {
            let (__warp_se_189) = WM5_SwapState_eba3c779___warp_usrid_022_tick(
                __warp_usrid_146_state
            );

            let (__warp_se_190) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(
                __warp_usrid_147_step
            );

            let (__warp_se_191) = wm_read_felt(__warp_se_190);

            wm_write_felt(__warp_se_189, __warp_se_191);

            let (
                __warp_td_108,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_td_109,
                __warp_td_110,
            ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part2_if_part1(
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );

            let __warp_usrid_146_state = __warp_td_108;

            let __warp_usrid_144_cache = __warp_td_109;

            let __warp_usrid_143_slot0Start = __warp_td_110;

            return (
                __warp_usrid_146_state,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_145_exactInput,
                __warp_usrid_144_cache,
                __warp_usrid_143_slot0Start,
            );
        }
    }

    func __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part2_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (
            __warp_td_111,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_td_112,
            __warp_td_113,
        ) = __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part1(
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );

        let __warp_usrid_146_state = __warp_td_111;

        let __warp_usrid_144_cache = __warp_td_112;

        let __warp_usrid_143_slot0Start = __warp_td_113;

        return (
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );
    }

    func __warp_while7_if_part2_if_part1_if_part1_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (
            __warp_td_114,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_td_115,
            __warp_td_116,
        ) = __warp_while7_if_part1(
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );

        let __warp_usrid_146_state = __warp_td_114;

        let __warp_usrid_144_cache = __warp_td_115;

        let __warp_usrid_143_slot0Start = __warp_td_116;

        return (
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );
    }

    func __warp_while7_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) -> (
        __warp_usrid_146_state: felt,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_144_cache: felt,
        __warp_usrid_143_slot0Start: felt,
    ) {
        alloc_locals;

        let (
            __warp_td_117,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_td_118,
            __warp_td_119,
        ) = __warp_while7(
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );

        let __warp_usrid_146_state = __warp_td_117;

        let __warp_usrid_144_cache = __warp_td_118;

        let __warp_usrid_143_slot0Start = __warp_td_119;

        return (
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );
    }

    func __warp_modifier_lock_collectProtocol_85b66729_107{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_parameter___warp_parameter___warp_usrid_195_recipient92100: felt,
        __warp_parameter___warp_parameter___warp_usrid_196_amount0Requested93101: felt,
        __warp_parameter___warp_parameter___warp_usrid_197_amount1Requested94102: felt,
        __warp_parameter___warp_parameter___warp_usrid_198_amount0_m_capture95103: felt,
        __warp_parameter___warp_parameter___warp_usrid_199_amount1_m_capture96104: felt,
    ) -> (
        __warp_ret_parameter___warp_usrid_198_amount0105: felt,
        __warp_ret_parameter___warp_usrid_199_amount1106: felt,
    ) {
        alloc_locals;

        let __warp_ret_parameter___warp_usrid_199_amount1106 = 0;

        let __warp_ret_parameter___warp_usrid_198_amount0105 = 0;

        let (__warp_se_192) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        let (__warp_se_193) = WS1_READ_felt(__warp_se_192);

        with_attr error_message("LOK") {
            assert __warp_se_193 = 1;
        }

        let (__warp_se_194) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_194, 0);

        let (
            __warp_tv_10, __warp_tv_11
        ) = __warp_modifier_onlyFactoryOwner_collectProtocol_85b66729_99(
            __warp_parameter___warp_parameter___warp_usrid_195_recipient92100,
            __warp_parameter___warp_parameter___warp_usrid_196_amount0Requested93101,
            __warp_parameter___warp_parameter___warp_usrid_197_amount1Requested94102,
            __warp_parameter___warp_parameter___warp_usrid_198_amount0_m_capture95103,
            __warp_parameter___warp_parameter___warp_usrid_199_amount1_m_capture96104,
        );

        let __warp_ret_parameter___warp_usrid_199_amount1106 = __warp_tv_11;

        let __warp_ret_parameter___warp_usrid_198_amount0105 = __warp_tv_10;

        let (__warp_se_195) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_195, 1);

        let __warp_ret_parameter___warp_usrid_198_amount0105 = __warp_ret_parameter___warp_usrid_198_amount0105;

        let __warp_ret_parameter___warp_usrid_199_amount1106 = __warp_ret_parameter___warp_usrid_199_amount1106;

        return (
            __warp_ret_parameter___warp_usrid_198_amount0105,
            __warp_ret_parameter___warp_usrid_199_amount1106,
        );
    }

    func __warp_modifier_onlyFactoryOwner_collectProtocol_85b66729_99{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_parameter___warp_usrid_195_recipient92: felt,
        __warp_parameter___warp_usrid_196_amount0Requested93: felt,
        __warp_parameter___warp_usrid_197_amount1Requested94: felt,
        __warp_parameter___warp_usrid_198_amount0_m_capture95: felt,
        __warp_parameter___warp_usrid_199_amount1_m_capture96: felt,
    ) -> (
        __warp_ret_parameter___warp_usrid_198_amount097: felt,
        __warp_ret_parameter___warp_usrid_199_amount198: felt,
    ) {
        alloc_locals;

        let __warp_ret_parameter___warp_usrid_199_amount198 = 0;

        let __warp_ret_parameter___warp_usrid_198_amount097 = 0;

        let (__warp_se_196) = get_caller_address();

        let (__warp_se_197) = WS1_READ_felt(__warp_usrid_034_factory);

        let (__warp_se_198) = IUniswapV3Factory_warped_interface.owner_8da5cb5b(__warp_se_197);

        let (__warp_se_199) = warp_eq(__warp_se_196, __warp_se_198);

        assert __warp_se_199 = 1;

        let (__warp_tv_12, __warp_tv_13) = __warp_original_function_collectProtocol_85b66729_91(
            __warp_parameter___warp_usrid_195_recipient92,
            __warp_parameter___warp_usrid_196_amount0Requested93,
            __warp_parameter___warp_usrid_197_amount1Requested94,
            __warp_parameter___warp_usrid_198_amount0_m_capture95,
            __warp_parameter___warp_usrid_199_amount1_m_capture96,
        );

        let __warp_ret_parameter___warp_usrid_199_amount198 = __warp_tv_13;

        let __warp_ret_parameter___warp_usrid_198_amount097 = __warp_tv_12;

        let __warp_ret_parameter___warp_usrid_198_amount097 = __warp_ret_parameter___warp_usrid_198_amount097;

        let __warp_ret_parameter___warp_usrid_199_amount198 = __warp_ret_parameter___warp_usrid_199_amount198;

        return (
            __warp_ret_parameter___warp_usrid_198_amount097,
            __warp_ret_parameter___warp_usrid_199_amount198,
        );
    }

    // @inheritdoc IUniswapV3PoolOwnerActions
    func __warp_original_function_collectProtocol_85b66729_91{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_195_recipient: felt,
        __warp_usrid_196_amount0Requested: felt,
        __warp_usrid_197_amount1Requested: felt,
        __warp_usrid_198_amount0_m_capture: felt,
        __warp_usrid_199_amount1_m_capture: felt,
    ) -> (__warp_usrid_198_amount0: felt, __warp_usrid_199_amount1: felt) {
        alloc_locals;

        let __warp_usrid_198_amount0 = 0;

        let __warp_usrid_199_amount1 = 0;

        let __warp_usrid_199_amount1 = __warp_usrid_199_amount1_m_capture;

        let __warp_usrid_198_amount0 = __warp_usrid_198_amount0_m_capture;

        let (__warp_se_200) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(
            __warp_usrid_043_protocolFees
        );

        let (__warp_se_201) = WS1_READ_felt(__warp_se_200);

        let (__warp_se_202) = warp_gt(__warp_usrid_196_amount0Requested, __warp_se_201);

        if (__warp_se_202 != 0) {
            let (__warp_se_203) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(
                __warp_usrid_043_protocolFees
            );

            let (__warp_se_204) = WS1_READ_felt(__warp_se_203);

            let __warp_usrid_198_amount0 = __warp_se_204;

            let (
                __warp_usrid_198_amount0, __warp_usrid_199_amount1
            ) = __warp_original_function_collectProtocol_85b66729_91_if_part1(
                __warp_usrid_197_amount1Requested,
                __warp_usrid_199_amount1,
                __warp_usrid_198_amount0,
                __warp_usrid_195_recipient,
            );

            return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
        } else {
            let __warp_usrid_198_amount0 = __warp_usrid_196_amount0Requested;

            let (
                __warp_usrid_198_amount0, __warp_usrid_199_amount1
            ) = __warp_original_function_collectProtocol_85b66729_91_if_part1(
                __warp_usrid_197_amount1Requested,
                __warp_usrid_199_amount1,
                __warp_usrid_198_amount0,
                __warp_usrid_195_recipient,
            );

            return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
        }
    }

    func __warp_original_function_collectProtocol_85b66729_91_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_197_amount1Requested: felt,
        __warp_usrid_199_amount1: felt,
        __warp_usrid_198_amount0: felt,
        __warp_usrid_195_recipient: felt,
    ) -> (__warp_usrid_198_amount0: felt, __warp_usrid_199_amount1: felt) {
        alloc_locals;

        let (__warp_se_205) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(
            __warp_usrid_043_protocolFees
        );

        let (__warp_se_206) = WS1_READ_felt(__warp_se_205);

        let (__warp_se_207) = warp_gt(__warp_usrid_197_amount1Requested, __warp_se_206);

        if (__warp_se_207 != 0) {
            let (__warp_se_208) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(
                __warp_usrid_043_protocolFees
            );

            let (__warp_se_209) = WS1_READ_felt(__warp_se_208);

            let __warp_usrid_199_amount1 = __warp_se_209;

            let (
                __warp_usrid_198_amount0, __warp_usrid_199_amount1
            ) = __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1(
                __warp_usrid_198_amount0, __warp_usrid_195_recipient, __warp_usrid_199_amount1
            );

            return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
        } else {
            let __warp_usrid_199_amount1 = __warp_usrid_197_amount1Requested;

            let (
                __warp_usrid_198_amount0, __warp_usrid_199_amount1
            ) = __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1(
                __warp_usrid_198_amount0, __warp_usrid_195_recipient, __warp_usrid_199_amount1
            );

            return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
        }
    }

    func __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_198_amount0: felt,
        __warp_usrid_195_recipient: felt,
        __warp_usrid_199_amount1: felt,
    ) -> (__warp_usrid_198_amount0: felt, __warp_usrid_199_amount1: felt) {
        alloc_locals;

        let (__warp_se_210) = warp_gt(__warp_usrid_198_amount0, 0);

        if (__warp_se_210 != 0) {
            let (__warp_se_211) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(
                __warp_usrid_043_protocolFees
            );

            let (__warp_se_212) = WS1_READ_felt(__warp_se_211);

            let (__warp_se_213) = warp_eq(__warp_usrid_198_amount0, __warp_se_212);

            if (__warp_se_213 != 0) {
                let (__warp_se_214) = warp_sub_unsafe128(__warp_usrid_198_amount0, 1);

                let __warp_se_215 = __warp_se_214;

                let __warp_usrid_198_amount0 = __warp_se_215;

                warp_add_unsafe128(__warp_se_215, 1);

                let (
                    __warp_usrid_198_amount0, __warp_usrid_199_amount1
                ) = __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part2(
                    __warp_usrid_198_amount0, __warp_usrid_195_recipient, __warp_usrid_199_amount1
                );

                return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
            } else {
                let (
                    __warp_usrid_198_amount0, __warp_usrid_199_amount1
                ) = __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part2(
                    __warp_usrid_198_amount0, __warp_usrid_195_recipient, __warp_usrid_199_amount1
                );

                return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
            }
        } else {
            let (
                __warp_usrid_198_amount0, __warp_usrid_199_amount1
            ) = __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part1(
                __warp_usrid_199_amount1, __warp_usrid_195_recipient, __warp_usrid_198_amount0
            );

            return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
        }
    }

    func __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_198_amount0: felt,
        __warp_usrid_195_recipient: felt,
        __warp_usrid_199_amount1: felt,
    ) -> (__warp_usrid_198_amount0: felt, __warp_usrid_199_amount1: felt) {
        alloc_locals;

        let (__warp_se_216) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(
            __warp_usrid_043_protocolFees
        );

        let (__warp_se_217) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(
            __warp_usrid_043_protocolFees
        );

        let (__warp_se_218) = WS1_READ_felt(__warp_se_217);

        let (__warp_se_219) = warp_sub_unsafe128(__warp_se_218, __warp_usrid_198_amount0);

        WS_WRITE0(__warp_se_216, __warp_se_219);

        let (__warp_se_220) = WS1_READ_felt(__warp_usrid_035_token0);

        let (__warp_se_221) = warp_uint256(__warp_usrid_198_amount0);

        safeTransfer_d1660f99(__warp_se_220, __warp_usrid_195_recipient, __warp_se_221);

        let (
            __warp_usrid_198_amount0, __warp_usrid_199_amount1
        ) = __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part1(
            __warp_usrid_199_amount1, __warp_usrid_195_recipient, __warp_usrid_198_amount0
        );

        return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
    }

    func __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_199_amount1: felt,
        __warp_usrid_195_recipient: felt,
        __warp_usrid_198_amount0: felt,
    ) -> (__warp_usrid_198_amount0: felt, __warp_usrid_199_amount1: felt) {
        alloc_locals;

        let (__warp_se_222) = warp_gt(__warp_usrid_199_amount1, 0);

        if (__warp_se_222 != 0) {
            let (__warp_se_223) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(
                __warp_usrid_043_protocolFees
            );

            let (__warp_se_224) = WS1_READ_felt(__warp_se_223);

            let (__warp_se_225) = warp_eq(__warp_usrid_199_amount1, __warp_se_224);

            if (__warp_se_225 != 0) {
                let (__warp_se_226) = warp_sub_unsafe128(__warp_usrid_199_amount1, 1);

                let __warp_se_227 = __warp_se_226;

                let __warp_usrid_199_amount1 = __warp_se_227;

                warp_add_unsafe128(__warp_se_227, 1);

                let (
                    __warp_usrid_198_amount0, __warp_usrid_199_amount1
                ) = __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_199_amount1, __warp_usrid_195_recipient, __warp_usrid_198_amount0
                );

                return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
            } else {
                let (
                    __warp_usrid_198_amount0, __warp_usrid_199_amount1
                ) = __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_199_amount1, __warp_usrid_195_recipient, __warp_usrid_198_amount0
                );

                return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
            }
        } else {
            let (
                __warp_usrid_198_amount0, __warp_usrid_199_amount1
            ) = __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_195_recipient, __warp_usrid_198_amount0, __warp_usrid_199_amount1
            );

            return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
        }
    }

    func __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part1_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_199_amount1: felt,
        __warp_usrid_195_recipient: felt,
        __warp_usrid_198_amount0: felt,
    ) -> (__warp_usrid_198_amount0: felt, __warp_usrid_199_amount1: felt) {
        alloc_locals;

        let (__warp_se_228) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(
            __warp_usrid_043_protocolFees
        );

        let (__warp_se_229) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(
            __warp_usrid_043_protocolFees
        );

        let (__warp_se_230) = WS1_READ_felt(__warp_se_229);

        let (__warp_se_231) = warp_sub_unsafe128(__warp_se_230, __warp_usrid_199_amount1);

        WS_WRITE0(__warp_se_228, __warp_se_231);

        let (__warp_se_232) = WS1_READ_felt(__warp_usrid_036_token1);

        let (__warp_se_233) = warp_uint256(__warp_usrid_199_amount1);

        safeTransfer_d1660f99(__warp_se_232, __warp_usrid_195_recipient, __warp_se_233);

        let (
            __warp_usrid_198_amount0, __warp_usrid_199_amount1
        ) = __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part1_if_part1(
            __warp_usrid_195_recipient, __warp_usrid_198_amount0, __warp_usrid_199_amount1
        );

        return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
    }

    func __warp_original_function_collectProtocol_85b66729_91_if_part1_if_part1_if_part1_if_part1{
        syscall_ptr: felt*, range_check_ptr: felt
    }(
        __warp_usrid_195_recipient: felt,
        __warp_usrid_198_amount0: felt,
        __warp_usrid_199_amount1: felt,
    ) -> (__warp_usrid_198_amount0: felt, __warp_usrid_199_amount1: felt) {
        alloc_locals;

        let (__warp_se_234) = get_caller_address();

        CollectProtocol_596b5739.emit(
            __warp_se_234,
            __warp_usrid_195_recipient,
            __warp_usrid_198_amount0,
            __warp_usrid_199_amount1,
        );

        let __warp_usrid_198_amount0 = __warp_usrid_198_amount0;

        let __warp_usrid_199_amount1 = __warp_usrid_199_amount1;

        return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
    }

    func __warp_modifier_lock_setFeeProtocol_8206a4d1_90{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_parameter___warp_parameter___warp_usrid_192_feeProtocol08588: felt,
        __warp_parameter___warp_parameter___warp_usrid_193_feeProtocol18689: felt,
    ) -> () {
        alloc_locals;

        let (__warp_se_235) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        let (__warp_se_236) = WS1_READ_felt(__warp_se_235);

        with_attr error_message("LOK") {
            assert __warp_se_236 = 1;
        }

        let (__warp_se_237) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_237, 0);

        __warp_modifier_onlyFactoryOwner_setFeeProtocol_8206a4d1_87(
            __warp_parameter___warp_parameter___warp_usrid_192_feeProtocol08588,
            __warp_parameter___warp_parameter___warp_usrid_193_feeProtocol18689,
        );

        let (__warp_se_238) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_238, 1);

        return ();
    }

    func __warp_modifier_onlyFactoryOwner_setFeeProtocol_8206a4d1_87{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_parameter___warp_usrid_192_feeProtocol085: felt,
        __warp_parameter___warp_usrid_193_feeProtocol186: felt,
    ) -> () {
        alloc_locals;

        let (__warp_se_239) = get_caller_address();

        let (__warp_se_240) = WS1_READ_felt(__warp_usrid_034_factory);

        let (__warp_se_241) = IUniswapV3Factory_warped_interface.owner_8da5cb5b(__warp_se_240);

        let (__warp_se_242) = warp_eq(__warp_se_239, __warp_se_241);

        assert __warp_se_242 = 1;

        __warp_original_function_setFeeProtocol_8206a4d1_84(
            __warp_parameter___warp_usrid_192_feeProtocol085,
            __warp_parameter___warp_usrid_193_feeProtocol186,
        );

        return ();
    }

    // @inheritdoc IUniswapV3PoolOwnerActions
    func __warp_original_function_setFeeProtocol_8206a4d1_84{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_192_feeProtocol0: felt, __warp_usrid_193_feeProtocol1: felt) -> () {
        alloc_locals;

        let (__warp_se_243) = warp_eq(__warp_usrid_192_feeProtocol0, 0);

        let (__warp_se_244) = warp_ge(__warp_usrid_192_feeProtocol0, 4);

        let (__warp_se_245) = warp_le(__warp_usrid_192_feeProtocol0, 10);

        let (__warp_se_246) = warp_and_(__warp_se_244, __warp_se_245);

        let (__warp_se_247) = warp_or(__warp_se_243, __warp_se_246);

        let (__warp_se_248) = warp_eq(__warp_usrid_193_feeProtocol1, 0);

        let (__warp_se_249) = warp_ge(__warp_usrid_193_feeProtocol1, 4);

        let (__warp_se_250) = warp_le(__warp_usrid_193_feeProtocol1, 10);

        let (__warp_se_251) = warp_and_(__warp_se_249, __warp_se_250);

        let (__warp_se_252) = warp_or(__warp_se_248, __warp_se_251);

        let (__warp_se_253) = warp_and_(__warp_se_247, __warp_se_252);

        assert __warp_se_253 = 1;

        let (__warp_se_254) = WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(
            __warp_usrid_040_slot0
        );

        let (__warp_usrid_194_feeProtocolOld) = WS1_READ_felt(__warp_se_254);

        let (__warp_se_255) = WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(
            __warp_usrid_040_slot0
        );

        let (__warp_se_256) = warp_shl8(__warp_usrid_193_feeProtocol1, 4);

        let (__warp_se_257) = warp_add_unsafe8(__warp_usrid_192_feeProtocol0, __warp_se_256);

        WS_WRITE0(__warp_se_255, __warp_se_257);

        let (__warp_se_258) = warp_mod(__warp_usrid_194_feeProtocolOld, 16);

        let (__warp_se_259) = warp_shr8(__warp_usrid_194_feeProtocolOld, 4);

        SetFeeProtocol_973d8d92.emit(
            __warp_se_258,
            __warp_se_259,
            __warp_usrid_192_feeProtocol0,
            __warp_usrid_193_feeProtocol1,
        );

        return ();
    }

    func __warp_modifier_lock_flash_490e6cbc_83{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_parameter___warp_parameter___warp_usrid_175_recipient7479: felt,
        __warp_parameter___warp_parameter___warp_usrid_176_amount07580: Uint256,
        __warp_parameter___warp_parameter___warp_usrid_177_amount17681: Uint256,
        __warp_parameter___warp_parameter___warp_usrid_178_data7782: cd_dynarray_felt,
    ) -> () {
        alloc_locals;

        let (__warp_se_260) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        let (__warp_se_261) = WS1_READ_felt(__warp_se_260);

        with_attr error_message("LOK") {
            assert __warp_se_261 = 1;
        }

        let (__warp_se_262) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_262, 0);

        __warp_modifier_noDelegateCall_flash_490e6cbc_78(
            __warp_parameter___warp_parameter___warp_usrid_175_recipient7479,
            __warp_parameter___warp_parameter___warp_usrid_176_amount07580,
            __warp_parameter___warp_parameter___warp_usrid_177_amount17681,
            __warp_parameter___warp_parameter___warp_usrid_178_data7782,
        );

        let (__warp_se_263) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_263, 1);

        return ();
    }

    func __warp_modifier_noDelegateCall_flash_490e6cbc_78{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_parameter___warp_usrid_175_recipient74: felt,
        __warp_parameter___warp_usrid_176_amount075: Uint256,
        __warp_parameter___warp_usrid_177_amount176: Uint256,
        __warp_parameter___warp_usrid_178_data77: cd_dynarray_felt,
    ) -> () {
        alloc_locals;

        checkNotDelegateCall_8233c275();

        __warp_original_function_flash_490e6cbc_73(
            __warp_parameter___warp_usrid_175_recipient74,
            __warp_parameter___warp_usrid_176_amount075,
            __warp_parameter___warp_usrid_177_amount176,
            __warp_parameter___warp_usrid_178_data77,
        );

        return ();
    }

    // @inheritdoc IUniswapV3PoolActions
    func __warp_original_function_flash_490e6cbc_73{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_175_recipient: felt,
        __warp_usrid_176_amount0: Uint256,
        __warp_usrid_177_amount1: Uint256,
        __warp_usrid_178_data: cd_dynarray_felt,
    ) -> () {
        alloc_locals;

        let (__warp_usrid_179__liquidity) = WS1_READ_felt(__warp_usrid_044_liquidity);

        let (__warp_se_264) = warp_gt(__warp_usrid_179__liquidity, 0);

        with_attr error_message("L") {
            assert __warp_se_264 = 1;
        }

        let (__warp_se_265) = WS1_READ_felt(__warp_usrid_037_fee);

        let (__warp_se_266) = warp_uint256(__warp_se_265);

        let (__warp_usrid_180_fee0) = mulDivRoundingUp_0af8b27f(
            __warp_usrid_176_amount0, __warp_se_266, Uint256(low=1000000, high=0)
        );

        let (__warp_se_267) = WS1_READ_felt(__warp_usrid_037_fee);

        let (__warp_se_268) = warp_uint256(__warp_se_267);

        let (__warp_usrid_181_fee1) = mulDivRoundingUp_0af8b27f(
            __warp_usrid_177_amount1, __warp_se_268, Uint256(low=1000000, high=0)
        );

        let (__warp_usrid_182_balance0Before) = balance0_1c69ad00();

        let (__warp_usrid_183_balance1Before) = balance1_c45c4f58();

        let (__warp_se_269) = warp_gt256(__warp_usrid_176_amount0, Uint256(low=0, high=0));

        if (__warp_se_269 != 0) {
            let (__warp_se_270) = WS1_READ_felt(__warp_usrid_035_token0);

            safeTransfer_d1660f99(
                __warp_se_270, __warp_usrid_175_recipient, __warp_usrid_176_amount0
            );

            __warp_original_function_flash_490e6cbc_73_if_part1(
                __warp_usrid_177_amount1,
                __warp_usrid_175_recipient,
                __warp_usrid_180_fee0,
                __warp_usrid_181_fee1,
                __warp_usrid_178_data,
                __warp_usrid_182_balance0Before,
                __warp_usrid_183_balance1Before,
                __warp_usrid_179__liquidity,
                __warp_usrid_176_amount0,
            );

            return ();
        } else {
            __warp_original_function_flash_490e6cbc_73_if_part1(
                __warp_usrid_177_amount1,
                __warp_usrid_175_recipient,
                __warp_usrid_180_fee0,
                __warp_usrid_181_fee1,
                __warp_usrid_178_data,
                __warp_usrid_182_balance0Before,
                __warp_usrid_183_balance1Before,
                __warp_usrid_179__liquidity,
                __warp_usrid_176_amount0,
            );

            return ();
        }
    }

    func __warp_original_function_flash_490e6cbc_73_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_177_amount1: Uint256,
        __warp_usrid_175_recipient: felt,
        __warp_usrid_180_fee0: Uint256,
        __warp_usrid_181_fee1: Uint256,
        __warp_usrid_178_data: cd_dynarray_felt,
        __warp_usrid_182_balance0Before: Uint256,
        __warp_usrid_183_balance1Before: Uint256,
        __warp_usrid_179__liquidity: felt,
        __warp_usrid_176_amount0: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_271) = warp_gt256(__warp_usrid_177_amount1, Uint256(low=0, high=0));

        if (__warp_se_271 != 0) {
            let (__warp_se_272) = WS1_READ_felt(__warp_usrid_036_token1);

            safeTransfer_d1660f99(
                __warp_se_272, __warp_usrid_175_recipient, __warp_usrid_177_amount1
            );

            __warp_original_function_flash_490e6cbc_73_if_part1_if_part1(
                __warp_usrid_180_fee0,
                __warp_usrid_181_fee1,
                __warp_usrid_178_data,
                __warp_usrid_182_balance0Before,
                __warp_usrid_183_balance1Before,
                __warp_usrid_179__liquidity,
                __warp_usrid_175_recipient,
                __warp_usrid_176_amount0,
                __warp_usrid_177_amount1,
            );

            return ();
        } else {
            __warp_original_function_flash_490e6cbc_73_if_part1_if_part1(
                __warp_usrid_180_fee0,
                __warp_usrid_181_fee1,
                __warp_usrid_178_data,
                __warp_usrid_182_balance0Before,
                __warp_usrid_183_balance1Before,
                __warp_usrid_179__liquidity,
                __warp_usrid_175_recipient,
                __warp_usrid_176_amount0,
                __warp_usrid_177_amount1,
            );

            return ();
        }
    }

    func __warp_original_function_flash_490e6cbc_73_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_180_fee0: Uint256,
        __warp_usrid_181_fee1: Uint256,
        __warp_usrid_178_data: cd_dynarray_felt,
        __warp_usrid_182_balance0Before: Uint256,
        __warp_usrid_183_balance1Before: Uint256,
        __warp_usrid_179__liquidity: felt,
        __warp_usrid_175_recipient: felt,
        __warp_usrid_176_amount0: Uint256,
        __warp_usrid_177_amount1: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_273) = get_caller_address();

        IUniswapV3FlashCallback_warped_interface.uniswapV3FlashCallback_e9cbafb0(
            __warp_se_273,
            __warp_usrid_180_fee0,
            __warp_usrid_181_fee1,
            __warp_usrid_178_data.len,
            __warp_usrid_178_data.ptr,
        );

        let (__warp_usrid_184_balance0After) = balance0_1c69ad00();

        let (__warp_usrid_185_balance1After) = balance1_c45c4f58();

        let (__warp_se_274) = add_771602f7(__warp_usrid_182_balance0Before, __warp_usrid_180_fee0);

        let (__warp_se_275) = warp_le256(__warp_se_274, __warp_usrid_184_balance0After);

        with_attr error_message("F0") {
            assert __warp_se_275 = 1;
        }

        let (__warp_se_276) = add_771602f7(__warp_usrid_183_balance1Before, __warp_usrid_181_fee1);

        let (__warp_se_277) = warp_le256(__warp_se_276, __warp_usrid_185_balance1After);

        with_attr error_message("F1") {
            assert __warp_se_277 = 1;
        }

        let (__warp_usrid_186_paid0) = warp_sub_unsafe256(
            __warp_usrid_184_balance0After, __warp_usrid_182_balance0Before
        );

        let (__warp_usrid_187_paid1) = warp_sub_unsafe256(
            __warp_usrid_185_balance1After, __warp_usrid_183_balance1Before
        );

        let (__warp_se_278) = warp_gt256(__warp_usrid_186_paid0, Uint256(low=0, high=0));

        if (__warp_se_278 != 0) {
            let (__warp_se_279) = WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(
                __warp_usrid_040_slot0
            );

            let (__warp_se_280) = WS1_READ_felt(__warp_se_279);

            let (__warp_usrid_188_feeProtocol0) = warp_mod(__warp_se_280, 16);

            let __warp_usrid_189_fees0 = Uint256(low=0, high=0);

            let (__warp_se_281) = warp_neq(__warp_usrid_188_feeProtocol0, 0);

            if (__warp_se_281 != 0) {
                let (__warp_se_282) = warp_uint256(__warp_usrid_188_feeProtocol0);

                let (__warp_se_283) = warp_div_unsafe256(__warp_usrid_186_paid0, __warp_se_282);

                let __warp_usrid_189_fees0 = __warp_se_283;

                __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part2(
                    __warp_usrid_189_fees0,
                    __warp_usrid_186_paid0,
                    __warp_usrid_179__liquidity,
                    __warp_usrid_187_paid1,
                    __warp_usrid_175_recipient,
                    __warp_usrid_176_amount0,
                    __warp_usrid_177_amount1,
                );

                return ();
            } else {
                __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part2(
                    __warp_usrid_189_fees0,
                    __warp_usrid_186_paid0,
                    __warp_usrid_179__liquidity,
                    __warp_usrid_187_paid1,
                    __warp_usrid_175_recipient,
                    __warp_usrid_176_amount0,
                    __warp_usrid_177_amount1,
                );

                return ();
            }
        } else {
            __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1(
                __warp_usrid_187_paid1,
                __warp_usrid_179__liquidity,
                __warp_usrid_175_recipient,
                __warp_usrid_176_amount0,
                __warp_usrid_177_amount1,
                __warp_usrid_186_paid0,
            );

            return ();
        }
    }

    func __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_189_fees0: Uint256,
        __warp_usrid_186_paid0: Uint256,
        __warp_usrid_179__liquidity: felt,
        __warp_usrid_187_paid1: Uint256,
        __warp_usrid_175_recipient: felt,
        __warp_usrid_176_amount0: Uint256,
        __warp_usrid_177_amount1: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_284) = warp_int256_to_int128(__warp_usrid_189_fees0);

        let (__warp_se_285) = warp_gt(__warp_se_284, 0);

        if (__warp_se_285 != 0) {
            let (__warp_se_286) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(
                __warp_usrid_043_protocolFees
            );

            let (__warp_se_287) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(
                __warp_usrid_043_protocolFees
            );

            let (__warp_se_288) = WS1_READ_felt(__warp_se_287);

            let (__warp_se_289) = warp_int256_to_int128(__warp_usrid_189_fees0);

            let (__warp_se_290) = warp_add_unsafe128(__warp_se_288, __warp_se_289);

            WS_WRITE0(__warp_se_286, __warp_se_290);

            __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part2_if_part1(
                __warp_usrid_186_paid0,
                __warp_usrid_189_fees0,
                __warp_usrid_179__liquidity,
                __warp_usrid_187_paid1,
                __warp_usrid_175_recipient,
                __warp_usrid_176_amount0,
                __warp_usrid_177_amount1,
            );

            return ();
        } else {
            __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part2_if_part1(
                __warp_usrid_186_paid0,
                __warp_usrid_189_fees0,
                __warp_usrid_179__liquidity,
                __warp_usrid_187_paid1,
                __warp_usrid_175_recipient,
                __warp_usrid_176_amount0,
                __warp_usrid_177_amount1,
            );

            return ();
        }
    }

    func __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part2_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_186_paid0: Uint256,
        __warp_usrid_189_fees0: Uint256,
        __warp_usrid_179__liquidity: felt,
        __warp_usrid_187_paid1: Uint256,
        __warp_usrid_175_recipient: felt,
        __warp_usrid_176_amount0: Uint256,
        __warp_usrid_177_amount1: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_291) = WS0_READ_Uint256(__warp_usrid_041_feeGrowthGlobal0X128);

        let (__warp_se_292) = warp_sub_unsafe256(__warp_usrid_186_paid0, __warp_usrid_189_fees0);

        let (__warp_se_293) = warp_uint256(__warp_usrid_179__liquidity);

        let (__warp_se_294) = mulDiv_aa9a0912(__warp_se_292, Uint256(low=0, high=1), __warp_se_293);

        let (__warp_se_295) = warp_add_unsafe256(__warp_se_291, __warp_se_294);

        WS_WRITE1(__warp_usrid_041_feeGrowthGlobal0X128, __warp_se_295);

        __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1(
            __warp_usrid_187_paid1,
            __warp_usrid_179__liquidity,
            __warp_usrid_175_recipient,
            __warp_usrid_176_amount0,
            __warp_usrid_177_amount1,
            __warp_usrid_186_paid0,
        );

        return ();
    }

    func __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_187_paid1: Uint256,
        __warp_usrid_179__liquidity: felt,
        __warp_usrid_175_recipient: felt,
        __warp_usrid_176_amount0: Uint256,
        __warp_usrid_177_amount1: Uint256,
        __warp_usrid_186_paid0: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_296) = warp_gt256(__warp_usrid_187_paid1, Uint256(low=0, high=0));

        if (__warp_se_296 != 0) {
            let (__warp_se_297) = WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(
                __warp_usrid_040_slot0
            );

            let (__warp_se_298) = WS1_READ_felt(__warp_se_297);

            let (__warp_usrid_190_feeProtocol1) = warp_shr8(__warp_se_298, 4);

            let __warp_usrid_191_fees1 = Uint256(low=0, high=0);

            let (__warp_se_299) = warp_neq(__warp_usrid_190_feeProtocol1, 0);

            if (__warp_se_299 != 0) {
                let (__warp_se_300) = warp_uint256(__warp_usrid_190_feeProtocol1);

                let (__warp_se_301) = warp_div_unsafe256(__warp_usrid_187_paid1, __warp_se_300);

                let __warp_usrid_191_fees1 = __warp_se_301;

                __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_191_fees1,
                    __warp_usrid_187_paid1,
                    __warp_usrid_179__liquidity,
                    __warp_usrid_175_recipient,
                    __warp_usrid_176_amount0,
                    __warp_usrid_177_amount1,
                    __warp_usrid_186_paid0,
                );

                return ();
            } else {
                __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_191_fees1,
                    __warp_usrid_187_paid1,
                    __warp_usrid_179__liquidity,
                    __warp_usrid_175_recipient,
                    __warp_usrid_176_amount0,
                    __warp_usrid_177_amount1,
                    __warp_usrid_186_paid0,
                );

                return ();
            }
        } else {
            __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_175_recipient,
                __warp_usrid_176_amount0,
                __warp_usrid_177_amount1,
                __warp_usrid_186_paid0,
                __warp_usrid_187_paid1,
            );

            return ();
        }
    }

    func __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_191_fees1: Uint256,
        __warp_usrid_187_paid1: Uint256,
        __warp_usrid_179__liquidity: felt,
        __warp_usrid_175_recipient: felt,
        __warp_usrid_176_amount0: Uint256,
        __warp_usrid_177_amount1: Uint256,
        __warp_usrid_186_paid0: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_302) = warp_int256_to_int128(__warp_usrid_191_fees1);

        let (__warp_se_303) = warp_gt(__warp_se_302, 0);

        if (__warp_se_303 != 0) {
            let (__warp_se_304) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(
                __warp_usrid_043_protocolFees
            );

            let (__warp_se_305) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(
                __warp_usrid_043_protocolFees
            );

            let (__warp_se_306) = WS1_READ_felt(__warp_se_305);

            let (__warp_se_307) = warp_int256_to_int128(__warp_usrid_191_fees1);

            let (__warp_se_308) = warp_add_unsafe128(__warp_se_306, __warp_se_307);

            WS_WRITE0(__warp_se_304, __warp_se_308);

            __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1_if_part2_if_part1(
                __warp_usrid_187_paid1,
                __warp_usrid_191_fees1,
                __warp_usrid_179__liquidity,
                __warp_usrid_175_recipient,
                __warp_usrid_176_amount0,
                __warp_usrid_177_amount1,
                __warp_usrid_186_paid0,
            );

            return ();
        } else {
            __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1_if_part2_if_part1(
                __warp_usrid_187_paid1,
                __warp_usrid_191_fees1,
                __warp_usrid_179__liquidity,
                __warp_usrid_175_recipient,
                __warp_usrid_176_amount0,
                __warp_usrid_177_amount1,
                __warp_usrid_186_paid0,
            );

            return ();
        }
    }

    func __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1_if_part2_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_187_paid1: Uint256,
        __warp_usrid_191_fees1: Uint256,
        __warp_usrid_179__liquidity: felt,
        __warp_usrid_175_recipient: felt,
        __warp_usrid_176_amount0: Uint256,
        __warp_usrid_177_amount1: Uint256,
        __warp_usrid_186_paid0: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_309) = WS0_READ_Uint256(__warp_usrid_042_feeGrowthGlobal1X128);

        let (__warp_se_310) = warp_sub_unsafe256(__warp_usrid_187_paid1, __warp_usrid_191_fees1);

        let (__warp_se_311) = warp_uint256(__warp_usrid_179__liquidity);

        let (__warp_se_312) = mulDiv_aa9a0912(__warp_se_310, Uint256(low=0, high=1), __warp_se_311);

        let (__warp_se_313) = warp_add_unsafe256(__warp_se_309, __warp_se_312);

        WS_WRITE1(__warp_usrid_042_feeGrowthGlobal1X128, __warp_se_313);

        __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1_if_part1(
            __warp_usrid_175_recipient,
            __warp_usrid_176_amount0,
            __warp_usrid_177_amount1,
            __warp_usrid_186_paid0,
            __warp_usrid_187_paid1,
        );

        return ();
    }

    func __warp_original_function_flash_490e6cbc_73_if_part1_if_part1_if_part1_if_part1{
        syscall_ptr: felt*, range_check_ptr: felt
    }(
        __warp_usrid_175_recipient: felt,
        __warp_usrid_176_amount0: Uint256,
        __warp_usrid_177_amount1: Uint256,
        __warp_usrid_186_paid0: Uint256,
        __warp_usrid_187_paid1: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_se_314) = get_caller_address();

        Flash_bdbdb71d.emit(
            __warp_se_314,
            __warp_usrid_175_recipient,
            __warp_usrid_176_amount0,
            __warp_usrid_177_amount1,
            __warp_usrid_186_paid0,
            __warp_usrid_187_paid1,
        );

        return ();
    }

    func __warp_modifier_noDelegateCall_swap_128acb08_72{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_parameter___warp_usrid_136_recipient63: felt,
        __warp_parameter___warp_usrid_137_zeroForOne64: felt,
        __warp_parameter___warp_usrid_138_amountSpecified65: Uint256,
        __warp_parameter___warp_usrid_139_sqrtPriceLimitX9666: felt,
        __warp_parameter___warp_usrid_140_data67: cd_dynarray_felt,
        __warp_parameter___warp_usrid_141_amount0_m_capture68: Uint256,
        __warp_parameter___warp_usrid_142_amount1_m_capture69: Uint256,
    ) -> (
        __warp_ret_parameter___warp_usrid_141_amount070: Uint256,
        __warp_ret_parameter___warp_usrid_142_amount171: Uint256,
    ) {
        alloc_locals;

        let __warp_ret_parameter___warp_usrid_142_amount171 = Uint256(low=0, high=0);

        let __warp_ret_parameter___warp_usrid_141_amount070 = Uint256(low=0, high=0);

        checkNotDelegateCall_8233c275();

        let (__warp_tv_14, __warp_tv_15) = __warp_original_function_swap_128acb08_62(
            __warp_parameter___warp_usrid_136_recipient63,
            __warp_parameter___warp_usrid_137_zeroForOne64,
            __warp_parameter___warp_usrid_138_amountSpecified65,
            __warp_parameter___warp_usrid_139_sqrtPriceLimitX9666,
            __warp_parameter___warp_usrid_140_data67,
            __warp_parameter___warp_usrid_141_amount0_m_capture68,
            __warp_parameter___warp_usrid_142_amount1_m_capture69,
        );

        let __warp_ret_parameter___warp_usrid_142_amount171 = __warp_tv_15;

        let __warp_ret_parameter___warp_usrid_141_amount070 = __warp_tv_14;

        let __warp_ret_parameter___warp_usrid_141_amount070 = __warp_ret_parameter___warp_usrid_141_amount070;

        let __warp_ret_parameter___warp_usrid_142_amount171 = __warp_ret_parameter___warp_usrid_142_amount171;

        return (
            __warp_ret_parameter___warp_usrid_141_amount070,
            __warp_ret_parameter___warp_usrid_142_amount171,
        );
    }

    // @inheritdoc IUniswapV3PoolActions
    func __warp_original_function_swap_128acb08_62{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_136_recipient: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_138_amountSpecified: Uint256,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_140_data: cd_dynarray_felt,
        __warp_usrid_141_amount0_m_capture: Uint256,
        __warp_usrid_142_amount1_m_capture: Uint256,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        let __warp_usrid_141_amount0 = Uint256(low=0, high=0);

        let __warp_usrid_142_amount1 = Uint256(low=0, high=0);

        let __warp_usrid_142_amount1 = __warp_usrid_142_amount1_m_capture;

        let __warp_usrid_141_amount0 = __warp_usrid_141_amount0_m_capture;

        let (__warp_se_315) = warp_neq256(__warp_usrid_138_amountSpecified, Uint256(low=0, high=0));

        with_attr error_message("AS") {
            assert __warp_se_315 = 1;
        }

        let (__warp_usrid_143_slot0Start) = ws_to_memory1(__warp_usrid_040_slot0);

        let (__warp_se_316) = WM25_Slot0_930d2817___warp_usrid_006_unlocked(
            __warp_usrid_143_slot0Start
        );

        let (__warp_se_317) = wm_read_felt(__warp_se_316);

        with_attr error_message("LOK") {
            assert __warp_se_317 = 1;
        }

        if (__warp_usrid_137_zeroForOne != 0) {
            let (__warp_se_318) = WM26_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(
                __warp_usrid_143_slot0Start
            );

            let (__warp_se_319) = wm_read_felt(__warp_se_318);

            let (__warp_se_320) = warp_lt(__warp_usrid_139_sqrtPriceLimitX96, __warp_se_319);

            let (__warp_se_321) = warp_gt(__warp_usrid_139_sqrtPriceLimitX96, 4295128739);

            let (__warp_se_322) = warp_and_(__warp_se_320, __warp_se_321);

            with_attr error_message("SPL") {
                assert __warp_se_322 = 1;
            }

            let (
                __warp_usrid_141_amount0, __warp_usrid_142_amount1
            ) = __warp_original_function_swap_128acb08_62_if_part1(
                __warp_usrid_137_zeroForOne,
                __warp_usrid_143_slot0Start,
                __warp_usrid_138_amountSpecified,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_141_amount0,
                __warp_usrid_142_amount1,
                __warp_usrid_136_recipient,
                __warp_usrid_140_data,
            );

            return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
        } else {
            let (__warp_se_323) = WM26_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(
                __warp_usrid_143_slot0Start
            );

            let (__warp_se_324) = wm_read_felt(__warp_se_323);

            let (__warp_se_325) = warp_gt(__warp_usrid_139_sqrtPriceLimitX96, __warp_se_324);

            let (__warp_se_326) = warp_lt(
                __warp_usrid_139_sqrtPriceLimitX96,
                1461446703485210103287273052203988822378723970342,
            );

            let (__warp_se_327) = warp_and_(__warp_se_325, __warp_se_326);

            with_attr error_message("SPL") {
                assert __warp_se_327 = 1;
            }

            let (
                __warp_usrid_141_amount0, __warp_usrid_142_amount1
            ) = __warp_original_function_swap_128acb08_62_if_part1(
                __warp_usrid_137_zeroForOne,
                __warp_usrid_143_slot0Start,
                __warp_usrid_138_amountSpecified,
                __warp_usrid_139_sqrtPriceLimitX96,
                __warp_usrid_141_amount0,
                __warp_usrid_142_amount1,
                __warp_usrid_136_recipient,
                __warp_usrid_140_data,
            );

            return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
        }
    }

    func __warp_original_function_swap_128acb08_62_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_143_slot0Start: felt,
        __warp_usrid_138_amountSpecified: Uint256,
        __warp_usrid_139_sqrtPriceLimitX96: felt,
        __warp_usrid_141_amount0: Uint256,
        __warp_usrid_142_amount1: Uint256,
        __warp_usrid_136_recipient: felt,
        __warp_usrid_140_data: cd_dynarray_felt,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_328) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_328, 0);

        let (__warp_se_329) = conditional0_148ce0b9(
            __warp_usrid_137_zeroForOne, __warp_usrid_143_slot0Start
        );

        let (__warp_se_330) = WS1_READ_felt(__warp_usrid_044_liquidity);

        let (__warp_se_331) = _blockTimestamp_c63aa3e7();

        let (__warp_usrid_144_cache) = WM1_struct_SwapCache_7600c2b6(
            __warp_se_329, __warp_se_330, __warp_se_331, 0, 0, 0
        );

        let (__warp_usrid_145_exactInput) = warp_gt_signed256(
            __warp_usrid_138_amountSpecified, Uint256(low=0, high=0)
        );

        let (__warp_se_332) = WM26_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(
            __warp_usrid_143_slot0Start
        );

        let (__warp_se_333) = wm_read_felt(__warp_se_332);

        let (__warp_se_334) = WM19_Slot0_930d2817___warp_usrid_001_tick(
            __warp_usrid_143_slot0Start
        );

        let (__warp_se_335) = wm_read_felt(__warp_se_334);

        let (__warp_se_336) = conditional1_0f286cba(__warp_usrid_137_zeroForOne);

        let (__warp_se_337) = WM21_SwapCache_7600c2b6___warp_usrid_014_liquidityStart(
            __warp_usrid_144_cache
        );

        let (__warp_se_338) = wm_read_felt(__warp_se_337);

        let (__warp_usrid_146_state) = WM2_struct_SwapState_eba3c779(
            __warp_usrid_138_amountSpecified,
            Uint256(low=0, high=0),
            __warp_se_333,
            __warp_se_335,
            __warp_se_336,
            0,
            __warp_se_338,
        );

        let (
            __warp_td_120, __warp_tv_17, __warp_tv_18, __warp_tv_19, __warp_td_121, __warp_td_122
        ) = __warp_while7(
            __warp_usrid_146_state,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_144_cache,
            __warp_usrid_143_slot0Start,
        );

        let __warp_tv_16 = __warp_td_120;

        let __warp_tv_20 = __warp_td_121;

        let __warp_tv_21 = __warp_td_122;

        let __warp_usrid_143_slot0Start = __warp_tv_21;

        let __warp_usrid_144_cache = __warp_tv_20;

        let __warp_usrid_145_exactInput = __warp_tv_19;

        let __warp_usrid_137_zeroForOne = __warp_tv_18;

        let __warp_usrid_139_sqrtPriceLimitX96 = __warp_tv_17;

        let __warp_usrid_146_state = __warp_tv_16;

        let (__warp_se_339) = WM5_SwapState_eba3c779___warp_usrid_022_tick(__warp_usrid_146_state);

        let (__warp_se_340) = wm_read_felt(__warp_se_339);

        let (__warp_se_341) = WM19_Slot0_930d2817___warp_usrid_001_tick(
            __warp_usrid_143_slot0Start
        );

        let (__warp_se_342) = wm_read_felt(__warp_se_341);

        let (__warp_se_343) = warp_neq(__warp_se_340, __warp_se_342);

        if (__warp_se_343 != 0) {
            let (__warp_se_344) = WM20_Slot0_930d2817___warp_usrid_002_observationIndex(
                __warp_usrid_143_slot0Start
            );

            let (__warp_se_345) = wm_read_felt(__warp_se_344);

            let (__warp_se_346) = WM18_SwapCache_7600c2b6___warp_usrid_015_blockTimestamp(
                __warp_usrid_144_cache
            );

            let (__warp_se_347) = wm_read_felt(__warp_se_346);

            let (__warp_se_348) = WM19_Slot0_930d2817___warp_usrid_001_tick(
                __warp_usrid_143_slot0Start
            );

            let (__warp_se_349) = wm_read_felt(__warp_se_348);

            let (__warp_se_350) = WM21_SwapCache_7600c2b6___warp_usrid_014_liquidityStart(
                __warp_usrid_144_cache
            );

            let (__warp_se_351) = wm_read_felt(__warp_se_350);

            let (__warp_se_352) = WM22_Slot0_930d2817___warp_usrid_003_observationCardinality(
                __warp_usrid_143_slot0Start
            );

            let (__warp_se_353) = wm_read_felt(__warp_se_352);

            let (__warp_se_354) = WM27_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(
                __warp_usrid_143_slot0Start
            );

            let (__warp_se_355) = wm_read_felt(__warp_se_354);

            let (
                __warp_usrid_152_observationIndex, __warp_usrid_153_observationCardinality
            ) = write_9b9fd24c(
                __warp_usrid_048_observations,
                __warp_se_345,
                __warp_se_347,
                __warp_se_349,
                __warp_se_351,
                __warp_se_353,
                __warp_se_355,
            );

            let (__warp_se_356) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(
                __warp_usrid_146_state
            );

            let (__warp_tv_22) = wm_read_felt(__warp_se_356);

            let (__warp_se_357) = WM5_SwapState_eba3c779___warp_usrid_022_tick(
                __warp_usrid_146_state
            );

            let (__warp_tv_23) = wm_read_felt(__warp_se_357);

            let __warp_tv_24 = __warp_usrid_152_observationIndex;

            let __warp_tv_25 = __warp_usrid_153_observationCardinality;

            let (__warp_se_358) = WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(
                __warp_usrid_040_slot0
            );

            WS_WRITE0(__warp_se_358, __warp_tv_25);

            let (__warp_se_359) = WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(
                __warp_usrid_040_slot0
            );

            WS_WRITE0(__warp_se_359, __warp_tv_24);

            let (__warp_se_360) = WSM7_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_040_slot0);

            WS_WRITE0(__warp_se_360, __warp_tv_23);

            let (__warp_se_361) = WSM8_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(
                __warp_usrid_040_slot0
            );

            WS_WRITE0(__warp_se_361, __warp_tv_22);

            let (
                __warp_usrid_141_amount0, __warp_usrid_142_amount1
            ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1(
                __warp_usrid_144_cache,
                __warp_usrid_146_state,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_141_amount0,
                __warp_usrid_142_amount1,
                __warp_usrid_138_amountSpecified,
                __warp_usrid_145_exactInput,
                __warp_usrid_136_recipient,
                __warp_usrid_140_data,
            );

            return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
        } else {
            let (__warp_se_362) = WSM8_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(
                __warp_usrid_040_slot0
            );

            let (__warp_se_363) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(
                __warp_usrid_146_state
            );

            let (__warp_se_364) = wm_read_felt(__warp_se_363);

            WS_WRITE0(__warp_se_362, __warp_se_364);

            let (
                __warp_usrid_141_amount0, __warp_usrid_142_amount1
            ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1(
                __warp_usrid_144_cache,
                __warp_usrid_146_state,
                __warp_usrid_137_zeroForOne,
                __warp_usrid_141_amount0,
                __warp_usrid_142_amount1,
                __warp_usrid_138_amountSpecified,
                __warp_usrid_145_exactInput,
                __warp_usrid_136_recipient,
                __warp_usrid_140_data,
            );

            return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
        }
    }

    func __warp_original_function_swap_128acb08_62_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_144_cache: felt,
        __warp_usrid_146_state: felt,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_141_amount0: Uint256,
        __warp_usrid_142_amount1: Uint256,
        __warp_usrid_138_amountSpecified: Uint256,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_136_recipient: felt,
        __warp_usrid_140_data: cd_dynarray_felt,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_365) = WM21_SwapCache_7600c2b6___warp_usrid_014_liquidityStart(
            __warp_usrid_144_cache
        );

        let (__warp_se_366) = wm_read_felt(__warp_se_365);

        let (__warp_se_367) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(
            __warp_usrid_146_state
        );

        let (__warp_se_368) = wm_read_felt(__warp_se_367);

        let (__warp_se_369) = warp_neq(__warp_se_366, __warp_se_368);

        if (__warp_se_369 != 0) {
            let (__warp_se_370) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(
                __warp_usrid_146_state
            );

            let (__warp_se_371) = wm_read_felt(__warp_se_370);

            WS_WRITE0(__warp_usrid_044_liquidity, __warp_se_371);

            let (
                __warp_usrid_141_amount0, __warp_usrid_142_amount1
            ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1(
                __warp_usrid_137_zeroForOne,
                __warp_usrid_146_state,
                __warp_usrid_141_amount0,
                __warp_usrid_142_amount1,
                __warp_usrid_138_amountSpecified,
                __warp_usrid_145_exactInput,
                __warp_usrid_136_recipient,
                __warp_usrid_140_data,
            );

            return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
        } else {
            let (
                __warp_usrid_141_amount0, __warp_usrid_142_amount1
            ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1(
                __warp_usrid_137_zeroForOne,
                __warp_usrid_146_state,
                __warp_usrid_141_amount0,
                __warp_usrid_142_amount1,
                __warp_usrid_138_amountSpecified,
                __warp_usrid_145_exactInput,
                __warp_usrid_136_recipient,
                __warp_usrid_140_data,
            );

            return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
        }
    }

    func __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_146_state: felt,
        __warp_usrid_141_amount0: Uint256,
        __warp_usrid_142_amount1: Uint256,
        __warp_usrid_138_amountSpecified: Uint256,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_136_recipient: felt,
        __warp_usrid_140_data: cd_dynarray_felt,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        if (__warp_usrid_137_zeroForOne != 0) {
            let (__warp_se_372) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(
                __warp_usrid_146_state
            );

            let (__warp_se_373) = wm_read_256(__warp_se_372);

            WS_WRITE1(__warp_usrid_041_feeGrowthGlobal0X128, __warp_se_373);

            let (__warp_se_374) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(
                __warp_usrid_146_state
            );

            let (__warp_se_375) = wm_read_felt(__warp_se_374);

            let (__warp_se_376) = warp_gt(__warp_se_375, 0);

            if (__warp_se_376 != 0) {
                let (__warp_se_377) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(
                    __warp_usrid_043_protocolFees
                );

                let (__warp_se_378) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(
                    __warp_usrid_043_protocolFees
                );

                let (__warp_se_379) = WS1_READ_felt(__warp_se_378);

                let (__warp_se_380) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(
                    __warp_usrid_146_state
                );

                let (__warp_se_381) = wm_read_felt(__warp_se_380);

                let (__warp_se_382) = warp_add_unsafe128(__warp_se_379, __warp_se_381);

                WS_WRITE0(__warp_se_377, __warp_se_382);

                let (
                    __warp_usrid_141_amount0, __warp_usrid_142_amount1
                ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_141_amount0,
                    __warp_usrid_142_amount1,
                    __warp_usrid_146_state,
                    __warp_usrid_138_amountSpecified,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_136_recipient,
                    __warp_usrid_140_data,
                );

                return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
            } else {
                let (
                    __warp_usrid_141_amount0, __warp_usrid_142_amount1
                ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_141_amount0,
                    __warp_usrid_142_amount1,
                    __warp_usrid_146_state,
                    __warp_usrid_138_amountSpecified,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_136_recipient,
                    __warp_usrid_140_data,
                );

                return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
            }
        } else {
            let (__warp_se_383) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(
                __warp_usrid_146_state
            );

            let (__warp_se_384) = wm_read_256(__warp_se_383);

            WS_WRITE1(__warp_usrid_042_feeGrowthGlobal1X128, __warp_se_384);

            let (__warp_se_385) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(
                __warp_usrid_146_state
            );

            let (__warp_se_386) = wm_read_felt(__warp_se_385);

            let (__warp_se_387) = warp_gt(__warp_se_386, 0);

            if (__warp_se_387 != 0) {
                let (__warp_se_388) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(
                    __warp_usrid_043_protocolFees
                );

                let (__warp_se_389) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(
                    __warp_usrid_043_protocolFees
                );

                let (__warp_se_390) = WS1_READ_felt(__warp_se_389);

                let (__warp_se_391) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(
                    __warp_usrid_146_state
                );

                let (__warp_se_392) = wm_read_felt(__warp_se_391);

                let (__warp_se_393) = warp_add_unsafe128(__warp_se_390, __warp_se_392);

                WS_WRITE0(__warp_se_388, __warp_se_393);

                let (
                    __warp_usrid_141_amount0, __warp_usrid_142_amount1
                ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part3(
                    __warp_usrid_141_amount0,
                    __warp_usrid_142_amount1,
                    __warp_usrid_146_state,
                    __warp_usrid_138_amountSpecified,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_136_recipient,
                    __warp_usrid_140_data,
                );

                return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
            } else {
                let (
                    __warp_usrid_141_amount0, __warp_usrid_142_amount1
                ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part3(
                    __warp_usrid_141_amount0,
                    __warp_usrid_142_amount1,
                    __warp_usrid_146_state,
                    __warp_usrid_138_amountSpecified,
                    __warp_usrid_137_zeroForOne,
                    __warp_usrid_145_exactInput,
                    __warp_usrid_136_recipient,
                    __warp_usrid_140_data,
                );

                return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
            }
        }
    }

    func __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part3{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_141_amount0: Uint256,
        __warp_usrid_142_amount1: Uint256,
        __warp_usrid_146_state: felt,
        __warp_usrid_138_amountSpecified: Uint256,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_136_recipient: felt,
        __warp_usrid_140_data: cd_dynarray_felt,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        let (
            __warp_usrid_141_amount0, __warp_usrid_142_amount1
        ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1(
            __warp_usrid_141_amount0,
            __warp_usrid_142_amount1,
            __warp_usrid_146_state,
            __warp_usrid_138_amountSpecified,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_136_recipient,
            __warp_usrid_140_data,
        );

        return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
    }

    func __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_141_amount0: Uint256,
        __warp_usrid_142_amount1: Uint256,
        __warp_usrid_146_state: felt,
        __warp_usrid_138_amountSpecified: Uint256,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_136_recipient: felt,
        __warp_usrid_140_data: cd_dynarray_felt,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        let (
            __warp_usrid_141_amount0, __warp_usrid_142_amount1
        ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1(
            __warp_usrid_141_amount0,
            __warp_usrid_142_amount1,
            __warp_usrid_146_state,
            __warp_usrid_138_amountSpecified,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_145_exactInput,
            __warp_usrid_136_recipient,
            __warp_usrid_140_data,
        );

        return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
    }

    func __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_141_amount0: Uint256,
        __warp_usrid_142_amount1: Uint256,
        __warp_usrid_146_state: felt,
        __warp_usrid_138_amountSpecified: Uint256,
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_145_exactInput: felt,
        __warp_usrid_136_recipient: felt,
        __warp_usrid_140_data: cd_dynarray_felt,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_394) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(
            __warp_usrid_146_state
        );

        let (__warp_tv_26) = wm_read_256(__warp_se_394);

        let (__warp_se_395) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(
            __warp_usrid_146_state
        );

        let (__warp_se_396) = wm_read_256(__warp_se_395);

        let (__warp_tv_27) = warp_sub_signed_unsafe256(
            __warp_usrid_138_amountSpecified, __warp_se_396
        );

        let __warp_usrid_142_amount1 = __warp_tv_27;

        let __warp_usrid_141_amount0 = __warp_tv_26;

        let (__warp_se_397) = warp_eq(__warp_usrid_137_zeroForOne, __warp_usrid_145_exactInput);

        if (__warp_se_397 != 0) {
            let (__warp_se_398) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(
                __warp_usrid_146_state
            );

            let (__warp_se_399) = wm_read_256(__warp_se_398);

            let (__warp_tv_28) = warp_sub_signed_unsafe256(
                __warp_usrid_138_amountSpecified, __warp_se_399
            );

            let (__warp_se_400) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(
                __warp_usrid_146_state
            );

            let (__warp_tv_29) = wm_read_256(__warp_se_400);

            let __warp_usrid_142_amount1 = __warp_tv_29;

            let __warp_usrid_141_amount0 = __warp_tv_28;

            let (
                __warp_usrid_141_amount0, __warp_usrid_142_amount1
            ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_137_zeroForOne,
                __warp_usrid_142_amount1,
                __warp_usrid_136_recipient,
                __warp_usrid_141_amount0,
                __warp_usrid_140_data,
                __warp_usrid_146_state,
            );

            return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
        } else {
            let (
                __warp_usrid_141_amount0, __warp_usrid_142_amount1
            ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_137_zeroForOne,
                __warp_usrid_142_amount1,
                __warp_usrid_136_recipient,
                __warp_usrid_141_amount0,
                __warp_usrid_140_data,
                __warp_usrid_146_state,
            );

            return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
        }
    }

    func __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_137_zeroForOne: felt,
        __warp_usrid_142_amount1: Uint256,
        __warp_usrid_136_recipient: felt,
        __warp_usrid_141_amount0: Uint256,
        __warp_usrid_140_data: cd_dynarray_felt,
        __warp_usrid_146_state: felt,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        if (__warp_usrid_137_zeroForOne != 0) {
            let (__warp_se_401) = warp_lt_signed256(
                __warp_usrid_142_amount1, Uint256(low=0, high=0)
            );

            if (__warp_se_401 != 0) {
                let (__warp_se_402) = WS1_READ_felt(__warp_usrid_036_token1);

                let (__warp_se_403) = warp_negate256(__warp_usrid_142_amount1);

                safeTransfer_d1660f99(__warp_se_402, __warp_usrid_136_recipient, __warp_se_403);

                let (
                    __warp_usrid_141_amount0, __warp_usrid_142_amount1
                ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_141_amount0,
                    __warp_usrid_142_amount1,
                    __warp_usrid_140_data,
                    __warp_usrid_136_recipient,
                    __warp_usrid_146_state,
                );

                return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
            } else {
                let (
                    __warp_usrid_141_amount0, __warp_usrid_142_amount1
                ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_141_amount0,
                    __warp_usrid_142_amount1,
                    __warp_usrid_140_data,
                    __warp_usrid_136_recipient,
                    __warp_usrid_146_state,
                );

                return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
            }
        } else {
            let (__warp_se_404) = warp_lt_signed256(
                __warp_usrid_141_amount0, Uint256(low=0, high=0)
            );

            if (__warp_se_404 != 0) {
                let (__warp_se_405) = WS1_READ_felt(__warp_usrid_035_token0);

                let (__warp_se_406) = warp_negate256(__warp_usrid_141_amount0);

                safeTransfer_d1660f99(__warp_se_405, __warp_usrid_136_recipient, __warp_se_406);

                let (
                    __warp_usrid_141_amount0, __warp_usrid_142_amount1
                ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1_if_part3(
                    __warp_usrid_141_amount0,
                    __warp_usrid_142_amount1,
                    __warp_usrid_140_data,
                    __warp_usrid_136_recipient,
                    __warp_usrid_146_state,
                );

                return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
            } else {
                let (
                    __warp_usrid_141_amount0, __warp_usrid_142_amount1
                ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1_if_part3(
                    __warp_usrid_141_amount0,
                    __warp_usrid_142_amount1,
                    __warp_usrid_140_data,
                    __warp_usrid_136_recipient,
                    __warp_usrid_146_state,
                );

                return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
            }
        }
    }

    func __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1_if_part3{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_141_amount0: Uint256,
        __warp_usrid_142_amount1: Uint256,
        __warp_usrid_140_data: cd_dynarray_felt,
        __warp_usrid_136_recipient: felt,
        __warp_usrid_146_state: felt,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        let (__warp_usrid_155_balance1Before) = balance1_c45c4f58();

        let (__warp_se_407) = get_caller_address();

        IUniswapV3SwapCallback_warped_interface.uniswapV3SwapCallback_fa461e33(
            __warp_se_407,
            __warp_usrid_141_amount0,
            __warp_usrid_142_amount1,
            __warp_usrid_140_data.len,
            __warp_usrid_140_data.ptr,
        );

        let (__warp_se_408) = add_771602f7(
            __warp_usrid_155_balance1Before, __warp_usrid_142_amount1
        );

        let (__warp_se_409) = balance1_c45c4f58();

        let (__warp_se_410) = warp_le256(__warp_se_408, __warp_se_409);

        with_attr error_message("IIA") {
            assert __warp_se_410 = 1;
        }

        let (
            __warp_usrid_141_amount0, __warp_usrid_142_amount1
        ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
            __warp_usrid_136_recipient,
            __warp_usrid_141_amount0,
            __warp_usrid_142_amount1,
            __warp_usrid_146_state,
        );

        return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
    }

    func __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_141_amount0: Uint256,
        __warp_usrid_142_amount1: Uint256,
        __warp_usrid_140_data: cd_dynarray_felt,
        __warp_usrid_136_recipient: felt,
        __warp_usrid_146_state: felt,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        let (__warp_usrid_154_balance0Before) = balance0_1c69ad00();

        let (__warp_se_411) = get_caller_address();

        IUniswapV3SwapCallback_warped_interface.uniswapV3SwapCallback_fa461e33(
            __warp_se_411,
            __warp_usrid_141_amount0,
            __warp_usrid_142_amount1,
            __warp_usrid_140_data.len,
            __warp_usrid_140_data.ptr,
        );

        let (__warp_se_412) = add_771602f7(
            __warp_usrid_154_balance0Before, __warp_usrid_141_amount0
        );

        let (__warp_se_413) = balance0_1c69ad00();

        let (__warp_se_414) = warp_le256(__warp_se_412, __warp_se_413);

        with_attr error_message("IIA") {
            assert __warp_se_414 = 1;
        }

        let (
            __warp_usrid_141_amount0, __warp_usrid_142_amount1
        ) = __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
            __warp_usrid_136_recipient,
            __warp_usrid_141_amount0,
            __warp_usrid_142_amount1,
            __warp_usrid_146_state,
        );

        return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
    }

    func __warp_original_function_swap_128acb08_62_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_136_recipient: felt,
        __warp_usrid_141_amount0: Uint256,
        __warp_usrid_142_amount1: Uint256,
        __warp_usrid_146_state: felt,
    ) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_415) = get_caller_address();

        let (__warp_se_416) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(
            __warp_usrid_146_state
        );

        let (__warp_se_417) = wm_read_felt(__warp_se_416);

        let (__warp_se_418) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(
            __warp_usrid_146_state
        );

        let (__warp_se_419) = wm_read_felt(__warp_se_418);

        let (__warp_se_420) = WM5_SwapState_eba3c779___warp_usrid_022_tick(__warp_usrid_146_state);

        let (__warp_se_421) = wm_read_felt(__warp_se_420);

        Swap_c42079f9.emit(
            __warp_se_415,
            __warp_usrid_136_recipient,
            __warp_usrid_141_amount0,
            __warp_usrid_142_amount1,
            __warp_se_417,
            __warp_se_419,
            __warp_se_421,
        );

        let (__warp_se_422) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_422, 1);

        let __warp_usrid_141_amount0 = __warp_usrid_141_amount0;

        let __warp_usrid_142_amount1 = __warp_usrid_142_amount1;

        return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
    }

    func __warp_modifier_lock_burn_a34123a7_61{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(
        __warp_parameter___warp_usrid_128_tickLower54: felt,
        __warp_parameter___warp_usrid_129_tickUpper55: felt,
        __warp_parameter___warp_usrid_130_amount56: felt,
        __warp_parameter___warp_usrid_131_amount0_m_capture57: Uint256,
        __warp_parameter___warp_usrid_132_amount1_m_capture58: Uint256,
    ) -> (
        __warp_ret_parameter___warp_usrid_131_amount059: Uint256,
        __warp_ret_parameter___warp_usrid_132_amount160: Uint256,
    ) {
        alloc_locals;

        let __warp_ret_parameter___warp_usrid_132_amount160 = Uint256(low=0, high=0);

        let __warp_ret_parameter___warp_usrid_131_amount059 = Uint256(low=0, high=0);

        let (__warp_se_423) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        let (__warp_se_424) = WS1_READ_felt(__warp_se_423);

        with_attr error_message("LOK") {
            assert __warp_se_424 = 1;
        }

        let (__warp_se_425) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_425, 0);

        let (__warp_tv_30, __warp_tv_31) = __warp_original_function_burn_a34123a7_53(
            __warp_parameter___warp_usrid_128_tickLower54,
            __warp_parameter___warp_usrid_129_tickUpper55,
            __warp_parameter___warp_usrid_130_amount56,
            __warp_parameter___warp_usrid_131_amount0_m_capture57,
            __warp_parameter___warp_usrid_132_amount1_m_capture58,
        );

        let __warp_ret_parameter___warp_usrid_132_amount160 = __warp_tv_31;

        let __warp_ret_parameter___warp_usrid_131_amount059 = __warp_tv_30;

        let (__warp_se_426) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_426, 1);

        let __warp_ret_parameter___warp_usrid_131_amount059 = __warp_ret_parameter___warp_usrid_131_amount059;

        let __warp_ret_parameter___warp_usrid_132_amount160 = __warp_ret_parameter___warp_usrid_132_amount160;

        return (
            __warp_ret_parameter___warp_usrid_131_amount059,
            __warp_ret_parameter___warp_usrid_132_amount160,
        );
    }

    // @inheritdoc IUniswapV3PoolActions
    // @dev noDelegateCall is applied indirectly via _modifyPosition
    func __warp_original_function_burn_a34123a7_53{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(
        __warp_usrid_128_tickLower: felt,
        __warp_usrid_129_tickUpper: felt,
        __warp_usrid_130_amount: felt,
        __warp_usrid_131_amount0_m_capture: Uint256,
        __warp_usrid_132_amount1_m_capture: Uint256,
    ) -> (__warp_usrid_131_amount0: Uint256, __warp_usrid_132_amount1: Uint256) {
        alloc_locals;

        let __warp_usrid_131_amount0 = Uint256(low=0, high=0);

        let __warp_usrid_132_amount1 = Uint256(low=0, high=0);

        let __warp_usrid_132_amount1 = __warp_usrid_132_amount1_m_capture;

        let __warp_usrid_131_amount0 = __warp_usrid_131_amount0_m_capture;

        let (__warp_se_427) = get_caller_address();

        let (__warp_se_428) = warp_uint256(__warp_usrid_130_amount);

        let (__warp_se_429) = toInt128_dd2a0316(__warp_se_428);

        let (__warp_se_430) = warp_negate128(__warp_se_429);

        let (__warp_se_431) = WM3_struct_ModifyPositionParams_82bf7b1b(
            __warp_se_427, __warp_usrid_128_tickLower, __warp_usrid_129_tickUpper, __warp_se_430
        );

        let (
            __warp_td_123, __warp_usrid_134_amount0Int, __warp_usrid_135_amount1Int
        ) = _modifyPosition_c6bd2490(__warp_se_431);

        let __warp_usrid_133_position = __warp_td_123;

        let (__warp_se_432) = warp_negate256(__warp_usrid_134_amount0Int);

        let __warp_usrid_131_amount0 = __warp_se_432;

        let (__warp_se_433) = warp_negate256(__warp_usrid_135_amount1Int);

        let __warp_usrid_132_amount1 = __warp_se_433;

        let (__warp_se_434) = warp_gt256(__warp_usrid_131_amount0, Uint256(low=0, high=0));

        let (__warp_se_435) = warp_gt256(__warp_usrid_132_amount1, Uint256(low=0, high=0));

        let (__warp_se_436) = warp_or(__warp_se_434, __warp_se_435);

        if (__warp_se_436 != 0) {
            let (__warp_se_437) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(
                __warp_usrid_133_position
            );

            let (__warp_se_438) = WS1_READ_felt(__warp_se_437);

            let (__warp_se_439) = warp_int256_to_int128(__warp_usrid_131_amount0);

            let (__warp_tv_32) = warp_add_unsafe128(__warp_se_438, __warp_se_439);

            let (__warp_se_440) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(
                __warp_usrid_133_position
            );

            let (__warp_se_441) = WS1_READ_felt(__warp_se_440);

            let (__warp_se_442) = warp_int256_to_int128(__warp_usrid_132_amount1);

            let (__warp_tv_33) = warp_add_unsafe128(__warp_se_441, __warp_se_442);

            let (__warp_se_443) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(
                __warp_usrid_133_position
            );

            WS_WRITE0(__warp_se_443, __warp_tv_33);

            let (__warp_se_444) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(
                __warp_usrid_133_position
            );

            WS_WRITE0(__warp_se_444, __warp_tv_32);

            let (
                __warp_usrid_131_amount0, __warp_usrid_132_amount1
            ) = __warp_original_function_burn_a34123a7_53_if_part1(
                __warp_usrid_128_tickLower,
                __warp_usrid_129_tickUpper,
                __warp_usrid_130_amount,
                __warp_usrid_131_amount0,
                __warp_usrid_132_amount1,
            );

            return (__warp_usrid_131_amount0, __warp_usrid_132_amount1);
        } else {
            let (
                __warp_usrid_131_amount0, __warp_usrid_132_amount1
            ) = __warp_original_function_burn_a34123a7_53_if_part1(
                __warp_usrid_128_tickLower,
                __warp_usrid_129_tickUpper,
                __warp_usrid_130_amount,
                __warp_usrid_131_amount0,
                __warp_usrid_132_amount1,
            );

            return (__warp_usrid_131_amount0, __warp_usrid_132_amount1);
        }
    }

    func __warp_original_function_burn_a34123a7_53_if_part1{
        syscall_ptr: felt*, range_check_ptr: felt
    }(
        __warp_usrid_128_tickLower: felt,
        __warp_usrid_129_tickUpper: felt,
        __warp_usrid_130_amount: felt,
        __warp_usrid_131_amount0: Uint256,
        __warp_usrid_132_amount1: Uint256,
    ) -> (__warp_usrid_131_amount0: Uint256, __warp_usrid_132_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_445) = get_caller_address();

        Burn_0c396cd9.emit(
            __warp_se_445,
            __warp_usrid_128_tickLower,
            __warp_usrid_129_tickUpper,
            __warp_usrid_130_amount,
            __warp_usrid_131_amount0,
            __warp_usrid_132_amount1,
        );

        let __warp_usrid_131_amount0 = __warp_usrid_131_amount0;

        let __warp_usrid_132_amount1 = __warp_usrid_132_amount1;

        return (__warp_usrid_131_amount0, __warp_usrid_132_amount1);
    }

    func __warp_modifier_lock_collect_4f1eb3d8_52{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(
        __warp_parameter___warp_usrid_120_recipient43: felt,
        __warp_parameter___warp_usrid_121_tickLower44: felt,
        __warp_parameter___warp_usrid_122_tickUpper45: felt,
        __warp_parameter___warp_usrid_123_amount0Requested46: felt,
        __warp_parameter___warp_usrid_124_amount1Requested47: felt,
        __warp_parameter___warp_usrid_125_amount0_m_capture48: felt,
        __warp_parameter___warp_usrid_126_amount1_m_capture49: felt,
    ) -> (
        __warp_ret_parameter___warp_usrid_125_amount050: felt,
        __warp_ret_parameter___warp_usrid_126_amount151: felt,
    ) {
        alloc_locals;

        let __warp_ret_parameter___warp_usrid_126_amount151 = 0;

        let __warp_ret_parameter___warp_usrid_125_amount050 = 0;

        let (__warp_se_446) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        let (__warp_se_447) = WS1_READ_felt(__warp_se_446);

        with_attr error_message("LOK") {
            assert __warp_se_447 = 1;
        }

        let (__warp_se_448) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_448, 0);

        let (__warp_tv_34, __warp_tv_35) = __warp_original_function_collect_4f1eb3d8_42(
            __warp_parameter___warp_usrid_120_recipient43,
            __warp_parameter___warp_usrid_121_tickLower44,
            __warp_parameter___warp_usrid_122_tickUpper45,
            __warp_parameter___warp_usrid_123_amount0Requested46,
            __warp_parameter___warp_usrid_124_amount1Requested47,
            __warp_parameter___warp_usrid_125_amount0_m_capture48,
            __warp_parameter___warp_usrid_126_amount1_m_capture49,
        );

        let __warp_ret_parameter___warp_usrid_126_amount151 = __warp_tv_35;

        let __warp_ret_parameter___warp_usrid_125_amount050 = __warp_tv_34;

        let (__warp_se_449) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_449, 1);

        let __warp_ret_parameter___warp_usrid_125_amount050 = __warp_ret_parameter___warp_usrid_125_amount050;

        let __warp_ret_parameter___warp_usrid_126_amount151 = __warp_ret_parameter___warp_usrid_126_amount151;

        return (
            __warp_ret_parameter___warp_usrid_125_amount050,
            __warp_ret_parameter___warp_usrid_126_amount151,
        );
    }

    // @inheritdoc IUniswapV3PoolActions
    func __warp_original_function_collect_4f1eb3d8_42{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(
        __warp_usrid_120_recipient: felt,
        __warp_usrid_121_tickLower: felt,
        __warp_usrid_122_tickUpper: felt,
        __warp_usrid_123_amount0Requested: felt,
        __warp_usrid_124_amount1Requested: felt,
        __warp_usrid_125_amount0_m_capture: felt,
        __warp_usrid_126_amount1_m_capture: felt,
    ) -> (__warp_usrid_125_amount0: felt, __warp_usrid_126_amount1: felt) {
        alloc_locals;

        let __warp_usrid_125_amount0 = 0;

        let __warp_usrid_126_amount1 = 0;

        let __warp_usrid_126_amount1 = __warp_usrid_126_amount1_m_capture;

        let __warp_usrid_125_amount0 = __warp_usrid_125_amount0_m_capture;

        let (__warp_se_450) = get_caller_address();

        let (__warp_usrid_127_position) = get_a4d6(
            __warp_usrid_047_positions,
            __warp_se_450,
            __warp_usrid_121_tickLower,
            __warp_usrid_122_tickUpper,
        );

        let (__warp_se_451) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(
            __warp_usrid_127_position
        );

        let (__warp_se_452) = WS1_READ_felt(__warp_se_451);

        let (__warp_se_453) = warp_gt(__warp_usrid_123_amount0Requested, __warp_se_452);

        if (__warp_se_453 != 0) {
            let (__warp_se_454) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(
                __warp_usrid_127_position
            );

            let (__warp_se_455) = WS1_READ_felt(__warp_se_454);

            let __warp_usrid_125_amount0 = __warp_se_455;

            let (
                __warp_usrid_125_amount0, __warp_usrid_126_amount1
            ) = __warp_original_function_collect_4f1eb3d8_42_if_part1(
                __warp_usrid_124_amount1Requested,
                __warp_usrid_127_position,
                __warp_usrid_126_amount1,
                __warp_usrid_125_amount0,
                __warp_usrid_120_recipient,
                __warp_usrid_121_tickLower,
                __warp_usrid_122_tickUpper,
            );

            return (__warp_usrid_125_amount0, __warp_usrid_126_amount1);
        } else {
            let __warp_usrid_125_amount0 = __warp_usrid_123_amount0Requested;

            let (
                __warp_usrid_125_amount0, __warp_usrid_126_amount1
            ) = __warp_original_function_collect_4f1eb3d8_42_if_part1(
                __warp_usrid_124_amount1Requested,
                __warp_usrid_127_position,
                __warp_usrid_126_amount1,
                __warp_usrid_125_amount0,
                __warp_usrid_120_recipient,
                __warp_usrid_121_tickLower,
                __warp_usrid_122_tickUpper,
            );

            return (__warp_usrid_125_amount0, __warp_usrid_126_amount1);
        }
    }

    func __warp_original_function_collect_4f1eb3d8_42_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_124_amount1Requested: felt,
        __warp_usrid_127_position: felt,
        __warp_usrid_126_amount1: felt,
        __warp_usrid_125_amount0: felt,
        __warp_usrid_120_recipient: felt,
        __warp_usrid_121_tickLower: felt,
        __warp_usrid_122_tickUpper: felt,
    ) -> (__warp_usrid_125_amount0: felt, __warp_usrid_126_amount1: felt) {
        alloc_locals;

        let (__warp_se_456) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(
            __warp_usrid_127_position
        );

        let (__warp_se_457) = WS1_READ_felt(__warp_se_456);

        let (__warp_se_458) = warp_gt(__warp_usrid_124_amount1Requested, __warp_se_457);

        if (__warp_se_458 != 0) {
            let (__warp_se_459) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(
                __warp_usrid_127_position
            );

            let (__warp_se_460) = WS1_READ_felt(__warp_se_459);

            let __warp_usrid_126_amount1 = __warp_se_460;

            let (
                __warp_usrid_125_amount0, __warp_usrid_126_amount1
            ) = __warp_original_function_collect_4f1eb3d8_42_if_part1_if_part1(
                __warp_usrid_125_amount0,
                __warp_usrid_127_position,
                __warp_usrid_120_recipient,
                __warp_usrid_126_amount1,
                __warp_usrid_121_tickLower,
                __warp_usrid_122_tickUpper,
            );

            return (__warp_usrid_125_amount0, __warp_usrid_126_amount1);
        } else {
            let __warp_usrid_126_amount1 = __warp_usrid_124_amount1Requested;

            let (
                __warp_usrid_125_amount0, __warp_usrid_126_amount1
            ) = __warp_original_function_collect_4f1eb3d8_42_if_part1_if_part1(
                __warp_usrid_125_amount0,
                __warp_usrid_127_position,
                __warp_usrid_120_recipient,
                __warp_usrid_126_amount1,
                __warp_usrid_121_tickLower,
                __warp_usrid_122_tickUpper,
            );

            return (__warp_usrid_125_amount0, __warp_usrid_126_amount1);
        }
    }

    func __warp_original_function_collect_4f1eb3d8_42_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_125_amount0: felt,
        __warp_usrid_127_position: felt,
        __warp_usrid_120_recipient: felt,
        __warp_usrid_126_amount1: felt,
        __warp_usrid_121_tickLower: felt,
        __warp_usrid_122_tickUpper: felt,
    ) -> (__warp_usrid_125_amount0: felt, __warp_usrid_126_amount1: felt) {
        alloc_locals;

        let (__warp_se_461) = warp_gt(__warp_usrid_125_amount0, 0);

        if (__warp_se_461 != 0) {
            let (__warp_se_462) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(
                __warp_usrid_127_position
            );

            let (__warp_se_463) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(
                __warp_usrid_127_position
            );

            let (__warp_se_464) = WS1_READ_felt(__warp_se_463);

            let (__warp_se_465) = warp_sub_unsafe128(__warp_se_464, __warp_usrid_125_amount0);

            WS_WRITE0(__warp_se_462, __warp_se_465);

            let (__warp_se_466) = WS1_READ_felt(__warp_usrid_035_token0);

            let (__warp_se_467) = warp_uint256(__warp_usrid_125_amount0);

            safeTransfer_d1660f99(__warp_se_466, __warp_usrid_120_recipient, __warp_se_467);

            let (
                __warp_usrid_125_amount0, __warp_usrid_126_amount1
            ) = __warp_original_function_collect_4f1eb3d8_42_if_part1_if_part1_if_part1(
                __warp_usrid_126_amount1,
                __warp_usrid_127_position,
                __warp_usrid_120_recipient,
                __warp_usrid_121_tickLower,
                __warp_usrid_122_tickUpper,
                __warp_usrid_125_amount0,
            );

            return (__warp_usrid_125_amount0, __warp_usrid_126_amount1);
        } else {
            let (
                __warp_usrid_125_amount0, __warp_usrid_126_amount1
            ) = __warp_original_function_collect_4f1eb3d8_42_if_part1_if_part1_if_part1(
                __warp_usrid_126_amount1,
                __warp_usrid_127_position,
                __warp_usrid_120_recipient,
                __warp_usrid_121_tickLower,
                __warp_usrid_122_tickUpper,
                __warp_usrid_125_amount0,
            );

            return (__warp_usrid_125_amount0, __warp_usrid_126_amount1);
        }
    }

    func __warp_original_function_collect_4f1eb3d8_42_if_part1_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_126_amount1: felt,
        __warp_usrid_127_position: felt,
        __warp_usrid_120_recipient: felt,
        __warp_usrid_121_tickLower: felt,
        __warp_usrid_122_tickUpper: felt,
        __warp_usrid_125_amount0: felt,
    ) -> (__warp_usrid_125_amount0: felt, __warp_usrid_126_amount1: felt) {
        alloc_locals;

        let (__warp_se_468) = warp_gt(__warp_usrid_126_amount1, 0);

        if (__warp_se_468 != 0) {
            let (__warp_se_469) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(
                __warp_usrid_127_position
            );

            let (__warp_se_470) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(
                __warp_usrid_127_position
            );

            let (__warp_se_471) = WS1_READ_felt(__warp_se_470);

            let (__warp_se_472) = warp_sub_unsafe128(__warp_se_471, __warp_usrid_126_amount1);

            WS_WRITE0(__warp_se_469, __warp_se_472);

            let (__warp_se_473) = WS1_READ_felt(__warp_usrid_036_token1);

            let (__warp_se_474) = warp_uint256(__warp_usrid_126_amount1);

            safeTransfer_d1660f99(__warp_se_473, __warp_usrid_120_recipient, __warp_se_474);

            let (
                __warp_usrid_125_amount0, __warp_usrid_126_amount1
            ) = __warp_original_function_collect_4f1eb3d8_42_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_120_recipient,
                __warp_usrid_121_tickLower,
                __warp_usrid_122_tickUpper,
                __warp_usrid_125_amount0,
                __warp_usrid_126_amount1,
            );

            return (__warp_usrid_125_amount0, __warp_usrid_126_amount1);
        } else {
            let (
                __warp_usrid_125_amount0, __warp_usrid_126_amount1
            ) = __warp_original_function_collect_4f1eb3d8_42_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_120_recipient,
                __warp_usrid_121_tickLower,
                __warp_usrid_122_tickUpper,
                __warp_usrid_125_amount0,
                __warp_usrid_126_amount1,
            );

            return (__warp_usrid_125_amount0, __warp_usrid_126_amount1);
        }
    }

    func __warp_original_function_collect_4f1eb3d8_42_if_part1_if_part1_if_part1_if_part1{
        syscall_ptr: felt*, range_check_ptr: felt
    }(
        __warp_usrid_120_recipient: felt,
        __warp_usrid_121_tickLower: felt,
        __warp_usrid_122_tickUpper: felt,
        __warp_usrid_125_amount0: felt,
        __warp_usrid_126_amount1: felt,
    ) -> (__warp_usrid_125_amount0: felt, __warp_usrid_126_amount1: felt) {
        alloc_locals;

        let (__warp_se_475) = get_caller_address();

        Collect_70935338.emit(
            __warp_se_475,
            __warp_usrid_120_recipient,
            __warp_usrid_121_tickLower,
            __warp_usrid_122_tickUpper,
            __warp_usrid_125_amount0,
            __warp_usrid_126_amount1,
        );

        let __warp_usrid_125_amount0 = __warp_usrid_125_amount0;

        let __warp_usrid_126_amount1 = __warp_usrid_126_amount1;

        return (__warp_usrid_125_amount0, __warp_usrid_126_amount1);
    }

    func __warp_modifier_lock_mint_3c8a7d8d_41{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(
        __warp_parameter___warp_usrid_109_recipient32: felt,
        __warp_parameter___warp_usrid_110_tickLower33: felt,
        __warp_parameter___warp_usrid_111_tickUpper34: felt,
        __warp_parameter___warp_usrid_112_amount35: felt,
        __warp_parameter___warp_usrid_113_data36: cd_dynarray_felt,
        __warp_parameter___warp_usrid_114_amount0_m_capture37: Uint256,
        __warp_parameter___warp_usrid_115_amount1_m_capture38: Uint256,
    ) -> (
        __warp_ret_parameter___warp_usrid_114_amount039: Uint256,
        __warp_ret_parameter___warp_usrid_115_amount140: Uint256,
    ) {
        alloc_locals;

        let __warp_ret_parameter___warp_usrid_115_amount140 = Uint256(low=0, high=0);

        let __warp_ret_parameter___warp_usrid_114_amount039 = Uint256(low=0, high=0);

        let (__warp_se_476) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        let (__warp_se_477) = WS1_READ_felt(__warp_se_476);

        with_attr error_message("LOK") {
            assert __warp_se_477 = 1;
        }

        let (__warp_se_478) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_478, 0);

        let (__warp_tv_36, __warp_tv_37) = __warp_original_function_mint_3c8a7d8d_31(
            __warp_parameter___warp_usrid_109_recipient32,
            __warp_parameter___warp_usrid_110_tickLower33,
            __warp_parameter___warp_usrid_111_tickUpper34,
            __warp_parameter___warp_usrid_112_amount35,
            __warp_parameter___warp_usrid_113_data36,
            __warp_parameter___warp_usrid_114_amount0_m_capture37,
            __warp_parameter___warp_usrid_115_amount1_m_capture38,
        );

        let __warp_ret_parameter___warp_usrid_115_amount140 = __warp_tv_37;

        let __warp_ret_parameter___warp_usrid_114_amount039 = __warp_tv_36;

        let (__warp_se_479) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_479, 1);

        let __warp_ret_parameter___warp_usrid_114_amount039 = __warp_ret_parameter___warp_usrid_114_amount039;

        let __warp_ret_parameter___warp_usrid_115_amount140 = __warp_ret_parameter___warp_usrid_115_amount140;

        return (
            __warp_ret_parameter___warp_usrid_114_amount039,
            __warp_ret_parameter___warp_usrid_115_amount140,
        );
    }

    // @inheritdoc IUniswapV3PoolActions
    // @dev noDelegateCall is applied indirectly via _modifyPosition
    func __warp_original_function_mint_3c8a7d8d_31{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(
        __warp_usrid_109_recipient: felt,
        __warp_usrid_110_tickLower: felt,
        __warp_usrid_111_tickUpper: felt,
        __warp_usrid_112_amount: felt,
        __warp_usrid_113_data: cd_dynarray_felt,
        __warp_usrid_114_amount0_m_capture: Uint256,
        __warp_usrid_115_amount1_m_capture: Uint256,
    ) -> (__warp_usrid_114_amount0: Uint256, __warp_usrid_115_amount1: Uint256) {
        alloc_locals;

        let __warp_usrid_114_amount0 = Uint256(low=0, high=0);

        let __warp_usrid_115_amount1 = Uint256(low=0, high=0);

        let __warp_usrid_115_amount1 = __warp_usrid_115_amount1_m_capture;

        let __warp_usrid_114_amount0 = __warp_usrid_114_amount0_m_capture;

        let (__warp_se_480) = warp_gt(__warp_usrid_112_amount, 0);

        assert __warp_se_480 = 1;

        let (__warp_se_481) = warp_uint256(__warp_usrid_112_amount);

        let (__warp_se_482) = toInt128_dd2a0316(__warp_se_481);

        let (__warp_se_483) = WM3_struct_ModifyPositionParams_82bf7b1b(
            __warp_usrid_109_recipient,
            __warp_usrid_110_tickLower,
            __warp_usrid_111_tickUpper,
            __warp_se_482,
        );

        let (
            __warp_gv1, __warp_usrid_116_amount0Int, __warp_usrid_117_amount1Int
        ) = _modifyPosition_c6bd2490(__warp_se_483);

        let __warp_usrid_114_amount0 = __warp_usrid_116_amount0Int;

        let __warp_usrid_115_amount1 = __warp_usrid_117_amount1Int;

        let __warp_usrid_118_balance0Before = Uint256(low=0, high=0);

        let __warp_usrid_119_balance1Before = Uint256(low=0, high=0);

        let (__warp_se_484) = warp_gt256(__warp_usrid_114_amount0, Uint256(low=0, high=0));

        if (__warp_se_484 != 0) {
            let (__warp_se_485) = balance0_1c69ad00();

            let __warp_usrid_118_balance0Before = __warp_se_485;

            let (
                __warp_usrid_114_amount0, __warp_usrid_115_amount1
            ) = __warp_original_function_mint_3c8a7d8d_31_if_part1(
                __warp_usrid_115_amount1,
                __warp_usrid_119_balance1Before,
                __warp_usrid_114_amount0,
                __warp_usrid_113_data,
                __warp_usrid_118_balance0Before,
                __warp_usrid_109_recipient,
                __warp_usrid_110_tickLower,
                __warp_usrid_111_tickUpper,
                __warp_usrid_112_amount,
            );

            return (__warp_usrid_114_amount0, __warp_usrid_115_amount1);
        } else {
            let (
                __warp_usrid_114_amount0, __warp_usrid_115_amount1
            ) = __warp_original_function_mint_3c8a7d8d_31_if_part1(
                __warp_usrid_115_amount1,
                __warp_usrid_119_balance1Before,
                __warp_usrid_114_amount0,
                __warp_usrid_113_data,
                __warp_usrid_118_balance0Before,
                __warp_usrid_109_recipient,
                __warp_usrid_110_tickLower,
                __warp_usrid_111_tickUpper,
                __warp_usrid_112_amount,
            );

            return (__warp_usrid_114_amount0, __warp_usrid_115_amount1);
        }
    }

    func __warp_original_function_mint_3c8a7d8d_31_if_part1{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }(
        __warp_usrid_115_amount1: Uint256,
        __warp_usrid_119_balance1Before: Uint256,
        __warp_usrid_114_amount0: Uint256,
        __warp_usrid_113_data: cd_dynarray_felt,
        __warp_usrid_118_balance0Before: Uint256,
        __warp_usrid_109_recipient: felt,
        __warp_usrid_110_tickLower: felt,
        __warp_usrid_111_tickUpper: felt,
        __warp_usrid_112_amount: felt,
    ) -> (__warp_usrid_114_amount0: Uint256, __warp_usrid_115_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_486) = warp_gt256(__warp_usrid_115_amount1, Uint256(low=0, high=0));

        if (__warp_se_486 != 0) {
            let (__warp_se_487) = balance1_c45c4f58();

            let __warp_usrid_119_balance1Before = __warp_se_487;

            let (
                __warp_usrid_114_amount0, __warp_usrid_115_amount1
            ) = __warp_original_function_mint_3c8a7d8d_31_if_part1_if_part1(
                __warp_usrid_114_amount0,
                __warp_usrid_115_amount1,
                __warp_usrid_113_data,
                __warp_usrid_118_balance0Before,
                __warp_usrid_119_balance1Before,
                __warp_usrid_109_recipient,
                __warp_usrid_110_tickLower,
                __warp_usrid_111_tickUpper,
                __warp_usrid_112_amount,
            );

            return (__warp_usrid_114_amount0, __warp_usrid_115_amount1);
        } else {
            let (
                __warp_usrid_114_amount0, __warp_usrid_115_amount1
            ) = __warp_original_function_mint_3c8a7d8d_31_if_part1_if_part1(
                __warp_usrid_114_amount0,
                __warp_usrid_115_amount1,
                __warp_usrid_113_data,
                __warp_usrid_118_balance0Before,
                __warp_usrid_119_balance1Before,
                __warp_usrid_109_recipient,
                __warp_usrid_110_tickLower,
                __warp_usrid_111_tickUpper,
                __warp_usrid_112_amount,
            );

            return (__warp_usrid_114_amount0, __warp_usrid_115_amount1);
        }
    }

    func __warp_original_function_mint_3c8a7d8d_31_if_part1_if_part1{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }(
        __warp_usrid_114_amount0: Uint256,
        __warp_usrid_115_amount1: Uint256,
        __warp_usrid_113_data: cd_dynarray_felt,
        __warp_usrid_118_balance0Before: Uint256,
        __warp_usrid_119_balance1Before: Uint256,
        __warp_usrid_109_recipient: felt,
        __warp_usrid_110_tickLower: felt,
        __warp_usrid_111_tickUpper: felt,
        __warp_usrid_112_amount: felt,
    ) -> (__warp_usrid_114_amount0: Uint256, __warp_usrid_115_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_488) = get_caller_address();

        IUniswapV3MintCallback_warped_interface.uniswapV3MintCallback_d3487997(
            __warp_se_488,
            __warp_usrid_114_amount0,
            __warp_usrid_115_amount1,
            __warp_usrid_113_data.len,
            __warp_usrid_113_data.ptr,
        );

        let (__warp_se_489) = warp_gt256(__warp_usrid_114_amount0, Uint256(low=0, high=0));

        if (__warp_se_489 != 0) {
            let (__warp_se_490) = add_771602f7(
                __warp_usrid_118_balance0Before, __warp_usrid_114_amount0
            );

            let (__warp_se_491) = balance0_1c69ad00();

            let (__warp_se_492) = warp_le256(__warp_se_490, __warp_se_491);

            with_attr error_message("M0") {
                assert __warp_se_492 = 1;
            }

            let (
                __warp_usrid_114_amount0, __warp_usrid_115_amount1
            ) = __warp_original_function_mint_3c8a7d8d_31_if_part1_if_part1_if_part1(
                __warp_usrid_115_amount1,
                __warp_usrid_119_balance1Before,
                __warp_usrid_109_recipient,
                __warp_usrid_110_tickLower,
                __warp_usrid_111_tickUpper,
                __warp_usrid_112_amount,
                __warp_usrid_114_amount0,
            );

            return (__warp_usrid_114_amount0, __warp_usrid_115_amount1);
        } else {
            let (
                __warp_usrid_114_amount0, __warp_usrid_115_amount1
            ) = __warp_original_function_mint_3c8a7d8d_31_if_part1_if_part1_if_part1(
                __warp_usrid_115_amount1,
                __warp_usrid_119_balance1Before,
                __warp_usrid_109_recipient,
                __warp_usrid_110_tickLower,
                __warp_usrid_111_tickUpper,
                __warp_usrid_112_amount,
                __warp_usrid_114_amount0,
            );

            return (__warp_usrid_114_amount0, __warp_usrid_115_amount1);
        }
    }

    func __warp_original_function_mint_3c8a7d8d_31_if_part1_if_part1_if_part1{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }(
        __warp_usrid_115_amount1: Uint256,
        __warp_usrid_119_balance1Before: Uint256,
        __warp_usrid_109_recipient: felt,
        __warp_usrid_110_tickLower: felt,
        __warp_usrid_111_tickUpper: felt,
        __warp_usrid_112_amount: felt,
        __warp_usrid_114_amount0: Uint256,
    ) -> (__warp_usrid_114_amount0: Uint256, __warp_usrid_115_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_493) = warp_gt256(__warp_usrid_115_amount1, Uint256(low=0, high=0));

        if (__warp_se_493 != 0) {
            let (__warp_se_494) = add_771602f7(
                __warp_usrid_119_balance1Before, __warp_usrid_115_amount1
            );

            let (__warp_se_495) = balance1_c45c4f58();

            let (__warp_se_496) = warp_le256(__warp_se_494, __warp_se_495);

            with_attr error_message("M1") {
                assert __warp_se_496 = 1;
            }

            let (
                __warp_usrid_114_amount0, __warp_usrid_115_amount1
            ) = __warp_original_function_mint_3c8a7d8d_31_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_109_recipient,
                __warp_usrid_110_tickLower,
                __warp_usrid_111_tickUpper,
                __warp_usrid_112_amount,
                __warp_usrid_114_amount0,
                __warp_usrid_115_amount1,
            );

            return (__warp_usrid_114_amount0, __warp_usrid_115_amount1);
        } else {
            let (
                __warp_usrid_114_amount0, __warp_usrid_115_amount1
            ) = __warp_original_function_mint_3c8a7d8d_31_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_109_recipient,
                __warp_usrid_110_tickLower,
                __warp_usrid_111_tickUpper,
                __warp_usrid_112_amount,
                __warp_usrid_114_amount0,
                __warp_usrid_115_amount1,
            );

            return (__warp_usrid_114_amount0, __warp_usrid_115_amount1);
        }
    }

    func __warp_original_function_mint_3c8a7d8d_31_if_part1_if_part1_if_part1_if_part1{
        syscall_ptr: felt*, range_check_ptr: felt
    }(
        __warp_usrid_109_recipient: felt,
        __warp_usrid_110_tickLower: felt,
        __warp_usrid_111_tickUpper: felt,
        __warp_usrid_112_amount: felt,
        __warp_usrid_114_amount0: Uint256,
        __warp_usrid_115_amount1: Uint256,
    ) -> (__warp_usrid_114_amount0: Uint256, __warp_usrid_115_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_497) = get_caller_address();

        Mint_7a53080b.emit(
            __warp_se_497,
            __warp_usrid_109_recipient,
            __warp_usrid_110_tickLower,
            __warp_usrid_111_tickUpper,
            __warp_usrid_112_amount,
            __warp_usrid_114_amount0,
            __warp_usrid_115_amount1,
        );

        let __warp_usrid_114_amount0 = __warp_usrid_114_amount0;

        let __warp_usrid_115_amount1 = __warp_usrid_115_amount1;

        return (__warp_usrid_114_amount0, __warp_usrid_115_amount1);
    }

    func __warp_modifier_noDelegateCall__modifyPosition_c6bd2490_30{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(
        __warp_parameter___warp_usrid_088_params23: felt,
        __warp_parameter___warp_usrid_089_position_m_capture24: felt,
        __warp_parameter___warp_usrid_090_amount0_m_capture25: Uint256,
        __warp_parameter___warp_usrid_091_amount1_m_capture26: Uint256,
    ) -> (
        __warp_ret_parameter___warp_usrid_089_position27: felt,
        __warp_ret_parameter___warp_usrid_090_amount028: Uint256,
        __warp_ret_parameter___warp_usrid_091_amount129: Uint256,
    ) {
        alloc_locals;

        let __warp_ret_parameter___warp_usrid_091_amount129 = Uint256(low=0, high=0);

        let __warp_ret_parameter___warp_usrid_090_amount028 = Uint256(low=0, high=0);

        let __warp_ret_parameter___warp_usrid_089_position27 = 0;

        checkNotDelegateCall_8233c275();

        let (
            __warp_td_124, __warp_tv_39, __warp_tv_40
        ) = __warp_original_function__modifyPosition_c6bd2490_22(
            __warp_parameter___warp_usrid_088_params23,
            __warp_parameter___warp_usrid_089_position_m_capture24,
            __warp_parameter___warp_usrid_090_amount0_m_capture25,
            __warp_parameter___warp_usrid_091_amount1_m_capture26,
        );

        let __warp_tv_38 = __warp_td_124;

        let __warp_ret_parameter___warp_usrid_091_amount129 = __warp_tv_40;

        let __warp_ret_parameter___warp_usrid_090_amount028 = __warp_tv_39;

        let __warp_ret_parameter___warp_usrid_089_position27 = __warp_tv_38;

        let __warp_ret_parameter___warp_usrid_089_position27 = __warp_ret_parameter___warp_usrid_089_position27;

        let __warp_ret_parameter___warp_usrid_090_amount028 = __warp_ret_parameter___warp_usrid_090_amount028;

        let __warp_ret_parameter___warp_usrid_091_amount129 = __warp_ret_parameter___warp_usrid_091_amount129;

        return (
            __warp_ret_parameter___warp_usrid_089_position27,
            __warp_ret_parameter___warp_usrid_090_amount028,
            __warp_ret_parameter___warp_usrid_091_amount129,
        );
    }

    // @dev Effect some changes to a position
    // @param params the position details and the change to the position's liquidity to effect
    // @return position a storage pointer referencing the position with the given owner and tick range
    // @return amount0 the amount of token0 owed to the pool, negative if the pool should pay the recipient
    // @return amount1 the amount of token1 owed to the pool, negative if the pool should pay the recipient
    func __warp_original_function__modifyPosition_c6bd2490_22{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(
        __warp_usrid_088_params: felt,
        __warp_usrid_089_position_m_capture: felt,
        __warp_usrid_090_amount0_m_capture: Uint256,
        __warp_usrid_091_amount1_m_capture: Uint256,
    ) -> (
        __warp_usrid_089_position: felt,
        __warp_usrid_090_amount0: Uint256,
        __warp_usrid_091_amount1: Uint256,
    ) {
        alloc_locals;

        let __warp_usrid_089_position = 0;

        let __warp_usrid_090_amount0 = Uint256(low=0, high=0);

        let __warp_usrid_091_amount1 = Uint256(low=0, high=0);

        let __warp_usrid_091_amount1 = __warp_usrid_091_amount1_m_capture;

        let __warp_usrid_090_amount0 = __warp_usrid_090_amount0_m_capture;

        let __warp_usrid_089_position = __warp_usrid_089_position_m_capture;

        let (__warp_se_498) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(
            __warp_usrid_088_params
        );

        let (__warp_se_499) = wm_read_felt(__warp_se_498);

        let (__warp_se_500) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(
            __warp_usrid_088_params
        );

        let (__warp_se_501) = wm_read_felt(__warp_se_500);

        checkTicks_d267849c(__warp_se_499, __warp_se_501);

        let (__warp_usrid_092__slot0) = ws_to_memory1(__warp_usrid_040_slot0);

        let (__warp_se_502) = WM30_ModifyPositionParams_82bf7b1b___warp_usrid_009_owner(
            __warp_usrid_088_params
        );

        let (__warp_se_503) = wm_read_felt(__warp_se_502);

        let (__warp_se_504) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(
            __warp_usrid_088_params
        );

        let (__warp_se_505) = wm_read_felt(__warp_se_504);

        let (__warp_se_506) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(
            __warp_usrid_088_params
        );

        let (__warp_se_507) = wm_read_felt(__warp_se_506);

        let (__warp_se_508) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(
            __warp_usrid_088_params
        );

        let (__warp_se_509) = wm_read_felt(__warp_se_508);

        let (__warp_se_510) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_092__slot0);

        let (__warp_se_511) = wm_read_felt(__warp_se_510);

        let (__warp_se_512) = _updatePosition_42b4bd05(
            __warp_se_503, __warp_se_505, __warp_se_507, __warp_se_509, __warp_se_511
        );

        let __warp_usrid_089_position = __warp_se_512;

        let (__warp_se_513) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(
            __warp_usrid_088_params
        );

        let (__warp_se_514) = wm_read_felt(__warp_se_513);

        let (__warp_se_515) = warp_neq(__warp_se_514, 0);

        if (__warp_se_515 != 0) {
            let (__warp_se_516) = WM19_Slot0_930d2817___warp_usrid_001_tick(
                __warp_usrid_092__slot0
            );

            let (__warp_se_517) = wm_read_felt(__warp_se_516);

            let (__warp_se_518) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(
                __warp_usrid_088_params
            );

            let (__warp_se_519) = wm_read_felt(__warp_se_518);

            let (__warp_se_520) = warp_lt_signed24(__warp_se_517, __warp_se_519);

            if (__warp_se_520 != 0) {
                let (__warp_se_521) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(
                    __warp_usrid_088_params
                );

                let (__warp_se_522) = wm_read_felt(__warp_se_521);

                let (__warp_se_523) = getSqrtRatioAtTick_986cfba3(__warp_se_522);

                let (__warp_se_524) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(
                    __warp_usrid_088_params
                );

                let (__warp_se_525) = wm_read_felt(__warp_se_524);

                let (__warp_se_526) = getSqrtRatioAtTick_986cfba3(__warp_se_525);

                let (
                    __warp_se_527
                ) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(
                    __warp_usrid_088_params
                );

                let (__warp_se_528) = wm_read_felt(__warp_se_527);

                let (__warp_se_529) = getAmount0Delta_c932699b(
                    __warp_se_523, __warp_se_526, __warp_se_528
                );

                let __warp_usrid_090_amount0 = __warp_se_529;

                let (
                    __warp_td_125, __warp_usrid_090_amount0, __warp_usrid_091_amount1
                ) = __warp_original_function__modifyPosition_c6bd2490_22_if_part2(
                    __warp_usrid_089_position, __warp_usrid_090_amount0, __warp_usrid_091_amount1
                );

                let __warp_usrid_089_position = __warp_td_125;

                return (
                    __warp_usrid_089_position, __warp_usrid_090_amount0, __warp_usrid_091_amount1
                );
            } else {
                let (__warp_se_530) = WM19_Slot0_930d2817___warp_usrid_001_tick(
                    __warp_usrid_092__slot0
                );

                let (__warp_se_531) = wm_read_felt(__warp_se_530);

                let (__warp_se_532) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(
                    __warp_usrid_088_params
                );

                let (__warp_se_533) = wm_read_felt(__warp_se_532);

                let (__warp_se_534) = warp_lt_signed24(__warp_se_531, __warp_se_533);

                if (__warp_se_534 != 0) {
                    let (__warp_usrid_093_liquidityBefore) = WS1_READ_felt(
                        __warp_usrid_044_liquidity
                    );

                    let (__warp_se_535) = WM20_Slot0_930d2817___warp_usrid_002_observationIndex(
                        __warp_usrid_092__slot0
                    );

                    let (__warp_se_536) = wm_read_felt(__warp_se_535);

                    let (__warp_se_537) = _blockTimestamp_c63aa3e7();

                    let (__warp_se_538) = WM19_Slot0_930d2817___warp_usrid_001_tick(
                        __warp_usrid_092__slot0
                    );

                    let (__warp_se_539) = wm_read_felt(__warp_se_538);

                    let (
                        __warp_se_540
                    ) = WM22_Slot0_930d2817___warp_usrid_003_observationCardinality(
                        __warp_usrid_092__slot0
                    );

                    let (__warp_se_541) = wm_read_felt(__warp_se_540);

                    let (
                        __warp_se_542
                    ) = WM27_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(
                        __warp_usrid_092__slot0
                    );

                    let (__warp_se_543) = wm_read_felt(__warp_se_542);

                    let (__warp_tv_41, __warp_tv_42) = write_9b9fd24c(
                        __warp_usrid_048_observations,
                        __warp_se_536,
                        __warp_se_537,
                        __warp_se_539,
                        __warp_usrid_093_liquidityBefore,
                        __warp_se_541,
                        __warp_se_543,
                    );

                    let (
                        __warp_se_544
                    ) = WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(
                        __warp_usrid_040_slot0
                    );

                    WS_WRITE0(__warp_se_544, __warp_tv_42);

                    let (__warp_se_545) = WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(
                        __warp_usrid_040_slot0
                    );

                    WS_WRITE0(__warp_se_545, __warp_tv_41);

                    let (__warp_se_546) = WM26_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(
                        __warp_usrid_092__slot0
                    );

                    let (__warp_se_547) = wm_read_felt(__warp_se_546);

                    let (
                        __warp_se_548
                    ) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(
                        __warp_usrid_088_params
                    );

                    let (__warp_se_549) = wm_read_felt(__warp_se_548);

                    let (__warp_se_550) = getSqrtRatioAtTick_986cfba3(__warp_se_549);

                    let (
                        __warp_se_551
                    ) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(
                        __warp_usrid_088_params
                    );

                    let (__warp_se_552) = wm_read_felt(__warp_se_551);

                    let (__warp_se_553) = getAmount0Delta_c932699b(
                        __warp_se_547, __warp_se_550, __warp_se_552
                    );

                    let __warp_usrid_090_amount0 = __warp_se_553;

                    let (
                        __warp_se_554
                    ) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(
                        __warp_usrid_088_params
                    );

                    let (__warp_se_555) = wm_read_felt(__warp_se_554);

                    let (__warp_se_556) = getSqrtRatioAtTick_986cfba3(__warp_se_555);

                    let (__warp_se_557) = WM26_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(
                        __warp_usrid_092__slot0
                    );

                    let (__warp_se_558) = wm_read_felt(__warp_se_557);

                    let (
                        __warp_se_559
                    ) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(
                        __warp_usrid_088_params
                    );

                    let (__warp_se_560) = wm_read_felt(__warp_se_559);

                    let (__warp_se_561) = getAmount1Delta_00c11862(
                        __warp_se_556, __warp_se_558, __warp_se_560
                    );

                    let __warp_usrid_091_amount1 = __warp_se_561;

                    let (
                        __warp_se_562
                    ) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(
                        __warp_usrid_088_params
                    );

                    let (__warp_se_563) = wm_read_felt(__warp_se_562);

                    let (__warp_se_564) = addDelta_402d44fb(
                        __warp_usrid_093_liquidityBefore, __warp_se_563
                    );

                    WS_WRITE0(__warp_usrid_044_liquidity, __warp_se_564);

                    let (
                        __warp_td_126, __warp_usrid_090_amount0, __warp_usrid_091_amount1
                    ) = __warp_original_function__modifyPosition_c6bd2490_22_if_part3(
                        __warp_usrid_089_position,
                        __warp_usrid_090_amount0,
                        __warp_usrid_091_amount1,
                    );

                    let __warp_usrid_089_position = __warp_td_126;

                    return (
                        __warp_usrid_089_position,
                        __warp_usrid_090_amount0,
                        __warp_usrid_091_amount1,
                    );
                } else {
                    let (
                        __warp_se_565
                    ) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(
                        __warp_usrid_088_params
                    );

                    let (__warp_se_566) = wm_read_felt(__warp_se_565);

                    let (__warp_se_567) = getSqrtRatioAtTick_986cfba3(__warp_se_566);

                    let (
                        __warp_se_568
                    ) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(
                        __warp_usrid_088_params
                    );

                    let (__warp_se_569) = wm_read_felt(__warp_se_568);

                    let (__warp_se_570) = getSqrtRatioAtTick_986cfba3(__warp_se_569);

                    let (
                        __warp_se_571
                    ) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(
                        __warp_usrid_088_params
                    );

                    let (__warp_se_572) = wm_read_felt(__warp_se_571);

                    let (__warp_se_573) = getAmount1Delta_00c11862(
                        __warp_se_567, __warp_se_570, __warp_se_572
                    );

                    let __warp_usrid_091_amount1 = __warp_se_573;

                    let (
                        __warp_td_127, __warp_usrid_090_amount0, __warp_usrid_091_amount1
                    ) = __warp_original_function__modifyPosition_c6bd2490_22_if_part3(
                        __warp_usrid_089_position,
                        __warp_usrid_090_amount0,
                        __warp_usrid_091_amount1,
                    );

                    let __warp_usrid_089_position = __warp_td_127;

                    return (
                        __warp_usrid_089_position,
                        __warp_usrid_090_amount0,
                        __warp_usrid_091_amount1,
                    );
                }
            }
        } else {
            let __warp_usrid_089_position = __warp_usrid_089_position;

            let __warp_usrid_090_amount0 = __warp_usrid_090_amount0;

            let __warp_usrid_091_amount1 = __warp_usrid_091_amount1;

            return (__warp_usrid_089_position, __warp_usrid_090_amount0, __warp_usrid_091_amount1);
        }
    }

    func __warp_original_function__modifyPosition_c6bd2490_22_if_part3(
        __warp_usrid_089_position: felt,
        __warp_usrid_090_amount0: Uint256,
        __warp_usrid_091_amount1: Uint256,
    ) -> (
        __warp_usrid_089_position: felt,
        __warp_usrid_090_amount0: Uint256,
        __warp_usrid_091_amount1: Uint256,
    ) {
        alloc_locals;

        let (
            __warp_td_128, __warp_usrid_090_amount0, __warp_usrid_091_amount1
        ) = __warp_original_function__modifyPosition_c6bd2490_22_if_part2(
            __warp_usrid_089_position, __warp_usrid_090_amount0, __warp_usrid_091_amount1
        );

        let __warp_usrid_089_position = __warp_td_128;

        return (__warp_usrid_089_position, __warp_usrid_090_amount0, __warp_usrid_091_amount1);
    }

    func __warp_original_function__modifyPosition_c6bd2490_22_if_part2(
        __warp_usrid_089_position: felt,
        __warp_usrid_090_amount0: Uint256,
        __warp_usrid_091_amount1: Uint256,
    ) -> (
        __warp_usrid_089_position: felt,
        __warp_usrid_090_amount0: Uint256,
        __warp_usrid_091_amount1: Uint256,
    ) {
        alloc_locals;

        let __warp_usrid_089_position = __warp_usrid_089_position;

        let __warp_usrid_090_amount0 = __warp_usrid_090_amount0;

        let __warp_usrid_091_amount1 = __warp_usrid_091_amount1;

        return (__warp_usrid_089_position, __warp_usrid_090_amount0, __warp_usrid_091_amount1);
    }

    func __warp_modifier_lock_increaseObservationCardinalityNext_32148f67_21{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_parameter___warp_parameter___warp_usrid_081_observationCardinalityNext1820: felt) -> (
        ) {
        alloc_locals;

        let (__warp_se_574) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        let (__warp_se_575) = WS1_READ_felt(__warp_se_574);

        with_attr error_message("LOK") {
            assert __warp_se_575 = 1;
        }

        let (__warp_se_576) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_576, 0);

        __warp_modifier_noDelegateCall_increaseObservationCardinalityNext_32148f67_19(
            __warp_parameter___warp_parameter___warp_usrid_081_observationCardinalityNext1820
        );

        let (__warp_se_577) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_040_slot0);

        WS_WRITE0(__warp_se_577, 1);

        return ();
    }

    func __warp_modifier_noDelegateCall_increaseObservationCardinalityNext_32148f67_19{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_parameter___warp_usrid_081_observationCardinalityNext18: felt) -> () {
        alloc_locals;

        checkNotDelegateCall_8233c275();

        __warp_original_function_increaseObservationCardinalityNext_32148f67_17(
            __warp_parameter___warp_usrid_081_observationCardinalityNext18
        );

        return ();
    }

    // @inheritdoc IUniswapV3PoolActions
    func __warp_original_function_increaseObservationCardinalityNext_32148f67_17{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(__warp_usrid_081_observationCardinalityNext: felt) -> () {
        alloc_locals;

        let (__warp_se_578) = WSM11_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(
            __warp_usrid_040_slot0
        );

        let (__warp_usrid_082_observationCardinalityNextOld) = WS1_READ_felt(__warp_se_578);

        let (__warp_usrid_083_observationCardinalityNextNew) = grow_48fc651e(
            __warp_usrid_048_observations,
            __warp_usrid_082_observationCardinalityNextOld,
            __warp_usrid_081_observationCardinalityNext,
        );

        let (__warp_se_579) = WSM11_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(
            __warp_usrid_040_slot0
        );

        WS_WRITE0(__warp_se_579, __warp_usrid_083_observationCardinalityNextNew);

        let (__warp_se_580) = warp_neq(
            __warp_usrid_082_observationCardinalityNextOld,
            __warp_usrid_083_observationCardinalityNextNew,
        );

        if (__warp_se_580 != 0) {
            IncreaseObservationCardinalityNext_ac49e518.emit(
                __warp_usrid_082_observationCardinalityNextOld,
                __warp_usrid_083_observationCardinalityNextNew,
            );

            __warp_original_function_increaseObservationCardinalityNext_32148f67_17_if_part1();

            return ();
        } else {
            __warp_original_function_increaseObservationCardinalityNext_32148f67_17_if_part1();

            return ();
        }
    }

    func __warp_original_function_increaseObservationCardinalityNext_32148f67_17_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func __warp_modifier_noDelegateCall_observe_883bdbfd_16{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_parameter___warp_usrid_078_secondsAgos11: cd_dynarray_felt,
        __warp_parameter___warp_usrid_079_tickCumulatives_m_capture12: felt,
        __warp_parameter___warp_usrid_080_secondsPerLiquidityCumulativeX128s_m_capture13: felt,
    ) -> (
        __warp_ret_parameter___warp_usrid_079_tickCumulatives14: felt,
        __warp_ret_parameter___warp_usrid_080_secondsPerLiquidityCumulativeX128s15: felt,
    ) {
        alloc_locals;

        let (__warp_ret_parameter___warp_usrid_080_secondsPerLiquidityCumulativeX128s15) = wm_new(
            Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        let (__warp_ret_parameter___warp_usrid_079_tickCumulatives14) = wm_new(
            Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        checkNotDelegateCall_8233c275();

        let (__warp_td_129, __warp_td_130) = __warp_original_function_observe_883bdbfd_10(
            __warp_parameter___warp_usrid_078_secondsAgos11,
            __warp_parameter___warp_usrid_079_tickCumulatives_m_capture12,
            __warp_parameter___warp_usrid_080_secondsPerLiquidityCumulativeX128s_m_capture13,
        );

        let __warp_tv_43 = __warp_td_129;

        let __warp_tv_44 = __warp_td_130;

        let __warp_ret_parameter___warp_usrid_080_secondsPerLiquidityCumulativeX128s15 = __warp_tv_44;

        let __warp_ret_parameter___warp_usrid_079_tickCumulatives14 = __warp_tv_43;

        let __warp_ret_parameter___warp_usrid_079_tickCumulatives14 = __warp_ret_parameter___warp_usrid_079_tickCumulatives14;

        let __warp_ret_parameter___warp_usrid_080_secondsPerLiquidityCumulativeX128s15 = __warp_ret_parameter___warp_usrid_080_secondsPerLiquidityCumulativeX128s15;

        return (
            __warp_ret_parameter___warp_usrid_079_tickCumulatives14,
            __warp_ret_parameter___warp_usrid_080_secondsPerLiquidityCumulativeX128s15,
        );
    }

    // @inheritdoc IUniswapV3PoolDerivedState
    func __warp_original_function_observe_883bdbfd_10{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_078_secondsAgos: cd_dynarray_felt,
        __warp_usrid_079_tickCumulatives_m_capture: felt,
        __warp_usrid_080_secondsPerLiquidityCumulativeX128s_m_capture: felt,
    ) -> (
        __warp_usrid_079_tickCumulatives: felt,
        __warp_usrid_080_secondsPerLiquidityCumulativeX128s: felt,
    ) {
        alloc_locals;

        let (__warp_usrid_079_tickCumulatives) = wm_new(
            Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        let (__warp_usrid_080_secondsPerLiquidityCumulativeX128s) = wm_new(
            Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        let __warp_usrid_080_secondsPerLiquidityCumulativeX128s = __warp_usrid_080_secondsPerLiquidityCumulativeX128s_m_capture;

        let __warp_usrid_079_tickCumulatives = __warp_usrid_079_tickCumulatives_m_capture;

        let (__warp_se_581) = _blockTimestamp_c63aa3e7();

        let (__warp_se_582) = cd_to_memory0(__warp_usrid_078_secondsAgos);

        let (__warp_se_583) = WSM7_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_040_slot0);

        let (__warp_se_584) = WS1_READ_felt(__warp_se_583);

        let (__warp_se_585) = WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(
            __warp_usrid_040_slot0
        );

        let (__warp_se_586) = WS1_READ_felt(__warp_se_585);

        let (__warp_se_587) = WS1_READ_felt(__warp_usrid_044_liquidity);

        let (__warp_se_588) = WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(
            __warp_usrid_040_slot0
        );

        let (__warp_se_589) = WS1_READ_felt(__warp_se_588);

        let (__warp_td_131, __warp_td_132) = observe_1ce1e7a5(
            __warp_usrid_048_observations,
            __warp_se_581,
            __warp_se_582,
            __warp_se_584,
            __warp_se_586,
            __warp_se_587,
            __warp_se_589,
        );

        let __warp_usrid_079_tickCumulatives = __warp_td_131;

        let __warp_usrid_080_secondsPerLiquidityCumulativeX128s = __warp_td_132;

        return (
            __warp_usrid_079_tickCumulatives, __warp_usrid_080_secondsPerLiquidityCumulativeX128s
        );
    }

    func __warp_modifier_noDelegateCall_snapshotCumulativesInside_a38807f2_9{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_parameter___warp_usrid_059_tickLower1: felt,
        __warp_parameter___warp_usrid_060_tickUpper2: felt,
        __warp_parameter___warp_usrid_061_tickCumulativeInside_m_capture3: felt,
        __warp_parameter___warp_usrid_062_secondsPerLiquidityInsideX128_m_capture4: felt,
        __warp_parameter___warp_usrid_063_secondsInside_m_capture5: felt,
    ) -> (
        __warp_ret_parameter___warp_usrid_061_tickCumulativeInside6: felt,
        __warp_ret_parameter___warp_usrid_062_secondsPerLiquidityInsideX1287: felt,
        __warp_ret_parameter___warp_usrid_063_secondsInside8: felt,
    ) {
        alloc_locals;

        let __warp_ret_parameter___warp_usrid_063_secondsInside8 = 0;

        let __warp_ret_parameter___warp_usrid_062_secondsPerLiquidityInsideX1287 = 0;

        let __warp_ret_parameter___warp_usrid_061_tickCumulativeInside6 = 0;

        checkNotDelegateCall_8233c275();

        let (
            __warp_tv_45, __warp_tv_46, __warp_tv_47
        ) = __warp_original_function_snapshotCumulativesInside_a38807f2_0(
            __warp_parameter___warp_usrid_059_tickLower1,
            __warp_parameter___warp_usrid_060_tickUpper2,
            __warp_parameter___warp_usrid_061_tickCumulativeInside_m_capture3,
            __warp_parameter___warp_usrid_062_secondsPerLiquidityInsideX128_m_capture4,
            __warp_parameter___warp_usrid_063_secondsInside_m_capture5,
        );

        let __warp_ret_parameter___warp_usrid_063_secondsInside8 = __warp_tv_47;

        let __warp_ret_parameter___warp_usrid_062_secondsPerLiquidityInsideX1287 = __warp_tv_46;

        let __warp_ret_parameter___warp_usrid_061_tickCumulativeInside6 = __warp_tv_45;

        let __warp_ret_parameter___warp_usrid_061_tickCumulativeInside6 = __warp_ret_parameter___warp_usrid_061_tickCumulativeInside6;

        let __warp_ret_parameter___warp_usrid_062_secondsPerLiquidityInsideX1287 = __warp_ret_parameter___warp_usrid_062_secondsPerLiquidityInsideX1287;

        let __warp_ret_parameter___warp_usrid_063_secondsInside8 = __warp_ret_parameter___warp_usrid_063_secondsInside8;

        return (
            __warp_ret_parameter___warp_usrid_061_tickCumulativeInside6,
            __warp_ret_parameter___warp_usrid_062_secondsPerLiquidityInsideX1287,
            __warp_ret_parameter___warp_usrid_063_secondsInside8,
        );
    }

    // @inheritdoc IUniswapV3PoolDerivedState
    func __warp_original_function_snapshotCumulativesInside_a38807f2_0{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_059_tickLower: felt,
        __warp_usrid_060_tickUpper: felt,
        __warp_usrid_061_tickCumulativeInside_m_capture: felt,
        __warp_usrid_062_secondsPerLiquidityInsideX128_m_capture: felt,
        __warp_usrid_063_secondsInside_m_capture: felt,
    ) -> (
        __warp_usrid_061_tickCumulativeInside: felt,
        __warp_usrid_062_secondsPerLiquidityInsideX128: felt,
        __warp_usrid_063_secondsInside: felt,
    ) {
        alloc_locals;

        let __warp_usrid_061_tickCumulativeInside = 0;

        let __warp_usrid_062_secondsPerLiquidityInsideX128 = 0;

        let __warp_usrid_063_secondsInside = 0;

        let __warp_usrid_063_secondsInside = __warp_usrid_063_secondsInside_m_capture;

        let __warp_usrid_062_secondsPerLiquidityInsideX128 = __warp_usrid_062_secondsPerLiquidityInsideX128_m_capture;

        let __warp_usrid_061_tickCumulativeInside = __warp_usrid_061_tickCumulativeInside_m_capture;

        checkTicks_d267849c(__warp_usrid_059_tickLower, __warp_usrid_060_tickUpper);

        let __warp_usrid_064_tickCumulativeLower = 0;

        let __warp_usrid_065_tickCumulativeUpper = 0;

        let __warp_usrid_066_secondsPerLiquidityOutsideLowerX128 = 0;

        let __warp_usrid_067_secondsPerLiquidityOutsideUpperX128 = 0;

        let __warp_usrid_068_secondsOutsideLower = 0;

        let __warp_usrid_069_secondsOutsideUpper = 0;

        let (__warp_usrid_070_lower) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_045_ticks, __warp_usrid_059_tickLower
        );

        let (__warp_usrid_071_upper) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_045_ticks, __warp_usrid_060_tickUpper
        );

        let __warp_usrid_072_initializedLower = 0;

        let (__warp_se_590) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
            __warp_usrid_070_lower
        );

        let (__warp_tv_48) = WS1_READ_felt(__warp_se_590);

        let (__warp_se_591) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
            __warp_usrid_070_lower
        );

        let (__warp_tv_49) = WS1_READ_felt(__warp_se_591);

        let (__warp_se_592) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(
            __warp_usrid_070_lower
        );

        let (__warp_tv_50) = WS1_READ_felt(__warp_se_592);

        let (__warp_se_593) = WSM15_Info_39bc053d___warp_usrid_07_initialized(
            __warp_usrid_070_lower
        );

        let (__warp_tv_51) = WS1_READ_felt(__warp_se_593);

        let __warp_usrid_072_initializedLower = __warp_tv_51;

        let __warp_usrid_068_secondsOutsideLower = __warp_tv_50;

        let __warp_usrid_066_secondsPerLiquidityOutsideLowerX128 = __warp_tv_49;

        let __warp_usrid_064_tickCumulativeLower = __warp_tv_48;

        assert __warp_usrid_072_initializedLower = 1;

        let __warp_usrid_073_initializedUpper = 0;

        let (__warp_se_594) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
            __warp_usrid_071_upper
        );

        let (__warp_tv_52) = WS1_READ_felt(__warp_se_594);

        let (__warp_se_595) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
            __warp_usrid_071_upper
        );

        let (__warp_tv_53) = WS1_READ_felt(__warp_se_595);

        let (__warp_se_596) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(
            __warp_usrid_071_upper
        );

        let (__warp_tv_54) = WS1_READ_felt(__warp_se_596);

        let (__warp_se_597) = WSM15_Info_39bc053d___warp_usrid_07_initialized(
            __warp_usrid_071_upper
        );

        let (__warp_tv_55) = WS1_READ_felt(__warp_se_597);

        let __warp_usrid_073_initializedUpper = __warp_tv_55;

        let __warp_usrid_069_secondsOutsideUpper = __warp_tv_54;

        let __warp_usrid_067_secondsPerLiquidityOutsideUpperX128 = __warp_tv_53;

        let __warp_usrid_065_tickCumulativeUpper = __warp_tv_52;

        assert __warp_usrid_073_initializedUpper = 1;

        let (__warp_usrid_074__slot0) = ws_to_memory1(__warp_usrid_040_slot0);

        let (__warp_se_598) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_074__slot0);

        let (__warp_se_599) = wm_read_felt(__warp_se_598);

        let (__warp_se_600) = warp_lt_signed24(__warp_se_599, __warp_usrid_059_tickLower);

        if (__warp_se_600 != 0) {
            let (__warp_usrid_061_tickCumulativeInside) = warp_sub_signed_unsafe56(
                __warp_usrid_064_tickCumulativeLower, __warp_usrid_065_tickCumulativeUpper
            );

            let (__warp_usrid_062_secondsPerLiquidityInsideX128) = warp_sub_unsafe160(
                __warp_usrid_066_secondsPerLiquidityOutsideLowerX128,
                __warp_usrid_067_secondsPerLiquidityOutsideUpperX128,
            );

            let (__warp_usrid_063_secondsInside) = warp_sub_unsafe32(
                __warp_usrid_068_secondsOutsideLower, __warp_usrid_069_secondsOutsideUpper
            );

            return (
                __warp_usrid_061_tickCumulativeInside,
                __warp_usrid_062_secondsPerLiquidityInsideX128,
                __warp_usrid_063_secondsInside,
            );
        } else {
            let (__warp_se_601) = WM19_Slot0_930d2817___warp_usrid_001_tick(
                __warp_usrid_074__slot0
            );

            let (__warp_se_602) = wm_read_felt(__warp_se_601);

            let (__warp_se_603) = warp_lt_signed24(__warp_se_602, __warp_usrid_060_tickUpper);

            if (__warp_se_603 != 0) {
                let (__warp_usrid_075_time) = _blockTimestamp_c63aa3e7();

                let (__warp_se_604) = WM19_Slot0_930d2817___warp_usrid_001_tick(
                    __warp_usrid_074__slot0
                );

                let (__warp_se_605) = wm_read_felt(__warp_se_604);

                let (__warp_se_606) = WM20_Slot0_930d2817___warp_usrid_002_observationIndex(
                    __warp_usrid_074__slot0
                );

                let (__warp_se_607) = wm_read_felt(__warp_se_606);

                let (__warp_se_608) = WS1_READ_felt(__warp_usrid_044_liquidity);

                let (__warp_se_609) = WM22_Slot0_930d2817___warp_usrid_003_observationCardinality(
                    __warp_usrid_074__slot0
                );

                let (__warp_se_610) = wm_read_felt(__warp_se_609);

                let (
                    __warp_usrid_076_tickCumulative,
                    __warp_usrid_077_secondsPerLiquidityCumulativeX128,
                ) = observeSingle_f7f8d6a0(
                    __warp_usrid_048_observations,
                    __warp_usrid_075_time,
                    0,
                    __warp_se_605,
                    __warp_se_607,
                    __warp_se_608,
                    __warp_se_610,
                );

                let (__warp_se_611) = warp_sub_signed_unsafe56(
                    __warp_usrid_076_tickCumulative, __warp_usrid_064_tickCumulativeLower
                );

                let (__warp_usrid_061_tickCumulativeInside) = warp_sub_signed_unsafe56(
                    __warp_se_611, __warp_usrid_065_tickCumulativeUpper
                );

                let (__warp_se_612) = warp_sub_unsafe160(
                    __warp_usrid_077_secondsPerLiquidityCumulativeX128,
                    __warp_usrid_066_secondsPerLiquidityOutsideLowerX128,
                );

                let (__warp_usrid_062_secondsPerLiquidityInsideX128) = warp_sub_unsafe160(
                    __warp_se_612, __warp_usrid_067_secondsPerLiquidityOutsideUpperX128
                );

                let (__warp_se_613) = warp_sub_unsafe32(
                    __warp_usrid_075_time, __warp_usrid_068_secondsOutsideLower
                );

                let (__warp_usrid_063_secondsInside) = warp_sub_unsafe32(
                    __warp_se_613, __warp_usrid_069_secondsOutsideUpper
                );

                return (
                    __warp_usrid_061_tickCumulativeInside,
                    __warp_usrid_062_secondsPerLiquidityInsideX128,
                    __warp_usrid_063_secondsInside,
                );
            } else {
                let (__warp_usrid_061_tickCumulativeInside) = warp_sub_signed_unsafe56(
                    __warp_usrid_065_tickCumulativeUpper, __warp_usrid_064_tickCumulativeLower
                );

                let (__warp_usrid_062_secondsPerLiquidityInsideX128) = warp_sub_unsafe160(
                    __warp_usrid_067_secondsPerLiquidityOutsideUpperX128,
                    __warp_usrid_066_secondsPerLiquidityOutsideLowerX128,
                );

                let (__warp_usrid_063_secondsInside) = warp_sub_unsafe32(
                    __warp_usrid_069_secondsOutsideUpper, __warp_usrid_068_secondsOutsideLower
                );

                return (
                    __warp_usrid_061_tickCumulativeInside,
                    __warp_usrid_062_secondsPerLiquidityInsideX128,
                    __warp_usrid_063_secondsInside,
                );
            }
        }
    }

    func _blockTimestamp_c63aa3e7{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }() -> (__warp_usrid_04_: felt) {
        alloc_locals;

        let (__warp_se_616) = WS0_READ_Uint256(__warp_usrid_00_time);

        let (__warp_se_617) = warp_int256_to_int32(__warp_se_616);

        return (__warp_se_617,);
    }

    func __warp_init_MockTimeUniswapV3Pool{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }() -> () {
        alloc_locals;

        WS_WRITE1(__warp_usrid_00_time, Uint256(low=1601906400, high=0));

        return ();
    }

    func __warp_constructor_0{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }() -> () {
        alloc_locals;

        let (__warp_se_619) = get_contract_address();

        WS_WRITE0(__warp_usrid_00_original, __warp_se_619);

        return ();
    }

    func __warp_constructor_1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }() -> () {
        alloc_locals;

        let __warp_usrid_049__tickSpacing = 0;

        let (__warp_se_620) = get_caller_address();

        let (
            __warp_tv_56, __warp_tv_57, __warp_tv_58, __warp_tv_59, __warp_tv_60
        ) = IUniswapV3PoolDeployer_warped_interface.parameters_89035730(__warp_se_620);

        let __warp_usrid_049__tickSpacing = __warp_tv_60;

        WS_WRITE0(__warp_usrid_037_fee, __warp_tv_59);

        WS_WRITE0(__warp_usrid_036_token1, __warp_tv_58);

        WS_WRITE0(__warp_usrid_035_token0, __warp_tv_57);

        WS_WRITE0(__warp_usrid_034_factory, __warp_tv_56);

        WS_WRITE0(__warp_usrid_038_tickSpacing, __warp_usrid_049__tickSpacing);

        let (__warp_se_621) = tickSpacingToMaxLiquidityPerTick_82c66f87(
            __warp_usrid_049__tickSpacing
        );

        WS_WRITE0(__warp_usrid_039_maxLiquidityPerTick, __warp_se_621);

        return ();
    }

    // @dev Common checks for valid tick inputs.
    func checkTicks_d267849c{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_054_tickLower: felt, __warp_usrid_055_tickUpper: felt
    ) -> () {
        alloc_locals;

        let (__warp_se_623) = warp_lt_signed24(
            __warp_usrid_054_tickLower, __warp_usrid_055_tickUpper
        );

        with_attr error_message("TLU") {
            assert __warp_se_623 = 1;
        }

        let (__warp_se_624) = warp_ge_signed24(__warp_usrid_054_tickLower, 15889944);

        with_attr error_message("TLM") {
            assert __warp_se_624 = 1;
        }

        let (__warp_se_625) = warp_le_signed24(__warp_usrid_055_tickUpper, 887272);

        with_attr error_message("TUM") {
            assert __warp_se_625 = 1;
        }

        return ();
    }

    // @dev Get the pool's balance of token0
    // @dev This function is gas optimized to avoid a redundant extcodesize check in addition to the returndatasize
    // check
    func balance0_1c69ad00{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
        ) -> (__warp_usrid_057_: Uint256) {
        alloc_locals;

        let (__warp_se_626) = WS1_READ_felt(__warp_usrid_035_token0);

        let (__warp_se_627) = get_contract_address();

        let (__warp_se_628) = IERC20Minimal_warped_interface.balanceOf_70a08231(
            __warp_se_626, __warp_se_627
        );

        return (__warp_se_628,);
    }

    // @dev Get the pool's balance of token1
    // @dev This function is gas optimized to avoid a redundant extcodesize check in addition to the returndatasize
    // check
    func balance1_c45c4f58{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
        ) -> (__warp_usrid_058_: Uint256) {
        alloc_locals;

        let (__warp_se_629) = WS1_READ_felt(__warp_usrid_036_token1);

        let (__warp_se_630) = get_contract_address();

        let (__warp_se_631) = IERC20Minimal_warped_interface.balanceOf_70a08231(
            __warp_se_629, __warp_se_630
        );

        return (__warp_se_631,);
    }

    // @dev Effect some changes to a position
    // @param params the position details and the change to the position's liquidity to effect
    // @return position a storage pointer referencing the position with the given owner and tick range
    // @return amount0 the amount of token0 owed to the pool, negative if the pool should pay the recipient
    // @return amount1 the amount of token1 owed to the pool, negative if the pool should pay the recipient
    func _modifyPosition_c6bd2490{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(__warp_usrid_088_params: felt) -> (
        __warp_usrid_089_position: felt,
        __warp_usrid_090_amount0: Uint256,
        __warp_usrid_091_amount1: Uint256,
    ) {
        alloc_locals;

        let __warp_usrid_091_amount1 = Uint256(low=0, high=0);

        let __warp_usrid_090_amount0 = Uint256(low=0, high=0);

        let __warp_usrid_089_position = 0;

        let (
            __warp_td_135, __warp_usrid_090_amount0, __warp_usrid_091_amount1
        ) = __warp_modifier_noDelegateCall__modifyPosition_c6bd2490_30(
            __warp_usrid_088_params,
            __warp_usrid_089_position,
            __warp_usrid_090_amount0,
            __warp_usrid_091_amount1,
        );

        let __warp_usrid_089_position = __warp_td_135;

        return (__warp_usrid_089_position, __warp_usrid_090_amount0, __warp_usrid_091_amount1);
    }

    // @dev Gets and updates a position with the given liquidity delta
    // @param owner the owner of the position
    // @param tickLower the lower tick of the position's tick range
    // @param tickUpper the upper tick of the position's tick range
    // @param tick the current tick, passed to avoid sloads
    func _updatePosition_42b4bd05{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(
        __warp_usrid_094_owner: felt,
        __warp_usrid_095_tickLower: felt,
        __warp_usrid_096_tickUpper: felt,
        __warp_usrid_097_liquidityDelta: felt,
        __warp_usrid_098_tick: felt,
    ) -> (__warp_usrid_099_position: felt) {
        alloc_locals;

        let __warp_usrid_099_position = 0;

        let (__warp_se_639) = get_a4d6(
            __warp_usrid_047_positions,
            __warp_usrid_094_owner,
            __warp_usrid_095_tickLower,
            __warp_usrid_096_tickUpper,
        );

        let __warp_usrid_099_position = __warp_se_639;

        let (__warp_usrid_100__feeGrowthGlobal0X128) = WS0_READ_Uint256(
            __warp_usrid_041_feeGrowthGlobal0X128
        );

        let (__warp_usrid_101__feeGrowthGlobal1X128) = WS0_READ_Uint256(
            __warp_usrid_042_feeGrowthGlobal1X128
        );

        let __warp_usrid_102_flippedLower = 0;

        let __warp_usrid_103_flippedUpper = 0;

        let (__warp_se_640) = warp_neq(__warp_usrid_097_liquidityDelta, 0);

        if (__warp_se_640 != 0) {
            let (__warp_usrid_104_time) = _blockTimestamp_c63aa3e7();

            let (__warp_se_641) = WSM7_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_040_slot0);

            let (__warp_se_642) = WS1_READ_felt(__warp_se_641);

            let (__warp_se_643) = WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(
                __warp_usrid_040_slot0
            );

            let (__warp_se_644) = WS1_READ_felt(__warp_se_643);

            let (__warp_se_645) = WS1_READ_felt(__warp_usrid_044_liquidity);

            let (__warp_se_646) = WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(
                __warp_usrid_040_slot0
            );

            let (__warp_se_647) = WS1_READ_felt(__warp_se_646);

            let (
                __warp_usrid_105_tickCumulative, __warp_usrid_106_secondsPerLiquidityCumulativeX128
            ) = observeSingle_f7f8d6a0(
                __warp_usrid_048_observations,
                __warp_usrid_104_time,
                0,
                __warp_se_642,
                __warp_se_644,
                __warp_se_645,
                __warp_se_647,
            );

            let (__warp_se_648) = WS1_READ_felt(__warp_usrid_039_maxLiquidityPerTick);

            let (__warp_se_649) = update_3bf3(
                __warp_usrid_045_ticks,
                __warp_usrid_095_tickLower,
                __warp_usrid_098_tick,
                __warp_usrid_097_liquidityDelta,
                __warp_usrid_100__feeGrowthGlobal0X128,
                __warp_usrid_101__feeGrowthGlobal1X128,
                __warp_usrid_106_secondsPerLiquidityCumulativeX128,
                __warp_usrid_105_tickCumulative,
                __warp_usrid_104_time,
                0,
                __warp_se_648,
            );

            let __warp_usrid_102_flippedLower = __warp_se_649;

            let (__warp_se_650) = WS1_READ_felt(__warp_usrid_039_maxLiquidityPerTick);

            let (__warp_se_651) = update_3bf3(
                __warp_usrid_045_ticks,
                __warp_usrid_096_tickUpper,
                __warp_usrid_098_tick,
                __warp_usrid_097_liquidityDelta,
                __warp_usrid_100__feeGrowthGlobal0X128,
                __warp_usrid_101__feeGrowthGlobal1X128,
                __warp_usrid_106_secondsPerLiquidityCumulativeX128,
                __warp_usrid_105_tickCumulative,
                __warp_usrid_104_time,
                1,
                __warp_se_650,
            );

            let __warp_usrid_103_flippedUpper = __warp_se_651;

            if (__warp_usrid_102_flippedLower != 0) {
                let (__warp_se_652) = WS1_READ_felt(__warp_usrid_038_tickSpacing);

                flipTick_5b3a(
                    __warp_usrid_046_tickBitmap, __warp_usrid_095_tickLower, __warp_se_652
                );

                let (__warp_se_653) = _updatePosition_42b4bd05_if_part2(
                    __warp_usrid_103_flippedUpper,
                    __warp_usrid_096_tickUpper,
                    __warp_usrid_095_tickLower,
                    __warp_usrid_098_tick,
                    __warp_usrid_100__feeGrowthGlobal0X128,
                    __warp_usrid_101__feeGrowthGlobal1X128,
                    __warp_usrid_099_position,
                    __warp_usrid_097_liquidityDelta,
                    __warp_usrid_102_flippedLower,
                );

                return (__warp_se_653,);
            } else {
                let (__warp_se_654) = _updatePosition_42b4bd05_if_part2(
                    __warp_usrid_103_flippedUpper,
                    __warp_usrid_096_tickUpper,
                    __warp_usrid_095_tickLower,
                    __warp_usrid_098_tick,
                    __warp_usrid_100__feeGrowthGlobal0X128,
                    __warp_usrid_101__feeGrowthGlobal1X128,
                    __warp_usrid_099_position,
                    __warp_usrid_097_liquidityDelta,
                    __warp_usrid_102_flippedLower,
                );

                return (__warp_se_654,);
            }
        } else {
            let (__warp_se_655) = _updatePosition_42b4bd05_if_part1(
                __warp_usrid_095_tickLower,
                __warp_usrid_096_tickUpper,
                __warp_usrid_098_tick,
                __warp_usrid_100__feeGrowthGlobal0X128,
                __warp_usrid_101__feeGrowthGlobal1X128,
                __warp_usrid_099_position,
                __warp_usrid_097_liquidityDelta,
                __warp_usrid_102_flippedLower,
                __warp_usrid_103_flippedUpper,
            );

            return (__warp_se_655,);
        }
    }

    func _updatePosition_42b4bd05_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_103_flippedUpper: felt,
        __warp_usrid_096_tickUpper: felt,
        __warp_usrid_095_tickLower: felt,
        __warp_usrid_098_tick: felt,
        __warp_usrid_100__feeGrowthGlobal0X128: Uint256,
        __warp_usrid_101__feeGrowthGlobal1X128: Uint256,
        __warp_usrid_099_position: felt,
        __warp_usrid_097_liquidityDelta: felt,
        __warp_usrid_102_flippedLower: felt,
    ) -> (__warp_usrid_099_position: felt) {
        alloc_locals;

        if (__warp_usrid_103_flippedUpper != 0) {
            let (__warp_se_656) = WS1_READ_felt(__warp_usrid_038_tickSpacing);

            flipTick_5b3a(__warp_usrid_046_tickBitmap, __warp_usrid_096_tickUpper, __warp_se_656);

            let (__warp_se_657) = _updatePosition_42b4bd05_if_part2_if_part1(
                __warp_usrid_095_tickLower,
                __warp_usrid_096_tickUpper,
                __warp_usrid_098_tick,
                __warp_usrid_100__feeGrowthGlobal0X128,
                __warp_usrid_101__feeGrowthGlobal1X128,
                __warp_usrid_099_position,
                __warp_usrid_097_liquidityDelta,
                __warp_usrid_102_flippedLower,
                __warp_usrid_103_flippedUpper,
            );

            return (__warp_se_657,);
        } else {
            let (__warp_se_658) = _updatePosition_42b4bd05_if_part2_if_part1(
                __warp_usrid_095_tickLower,
                __warp_usrid_096_tickUpper,
                __warp_usrid_098_tick,
                __warp_usrid_100__feeGrowthGlobal0X128,
                __warp_usrid_101__feeGrowthGlobal1X128,
                __warp_usrid_099_position,
                __warp_usrid_097_liquidityDelta,
                __warp_usrid_102_flippedLower,
                __warp_usrid_103_flippedUpper,
            );

            return (__warp_se_658,);
        }
    }

    func _updatePosition_42b4bd05_if_part2_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_095_tickLower: felt,
        __warp_usrid_096_tickUpper: felt,
        __warp_usrid_098_tick: felt,
        __warp_usrid_100__feeGrowthGlobal0X128: Uint256,
        __warp_usrid_101__feeGrowthGlobal1X128: Uint256,
        __warp_usrid_099_position: felt,
        __warp_usrid_097_liquidityDelta: felt,
        __warp_usrid_102_flippedLower: felt,
        __warp_usrid_103_flippedUpper: felt,
    ) -> (__warp_usrid_099_position: felt) {
        alloc_locals;

        let (__warp_se_659) = _updatePosition_42b4bd05_if_part1(
            __warp_usrid_095_tickLower,
            __warp_usrid_096_tickUpper,
            __warp_usrid_098_tick,
            __warp_usrid_100__feeGrowthGlobal0X128,
            __warp_usrid_101__feeGrowthGlobal1X128,
            __warp_usrid_099_position,
            __warp_usrid_097_liquidityDelta,
            __warp_usrid_102_flippedLower,
            __warp_usrid_103_flippedUpper,
        );

        return (__warp_se_659,);
    }

    func _updatePosition_42b4bd05_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_095_tickLower: felt,
        __warp_usrid_096_tickUpper: felt,
        __warp_usrid_098_tick: felt,
        __warp_usrid_100__feeGrowthGlobal0X128: Uint256,
        __warp_usrid_101__feeGrowthGlobal1X128: Uint256,
        __warp_usrid_099_position: felt,
        __warp_usrid_097_liquidityDelta: felt,
        __warp_usrid_102_flippedLower: felt,
        __warp_usrid_103_flippedUpper: felt,
    ) -> (__warp_usrid_099_position: felt) {
        alloc_locals;

        let (
            __warp_usrid_107_feeGrowthInside0X128, __warp_usrid_108_feeGrowthInside1X128
        ) = getFeeGrowthInside_5ae8(
            __warp_usrid_045_ticks,
            __warp_usrid_095_tickLower,
            __warp_usrid_096_tickUpper,
            __warp_usrid_098_tick,
            __warp_usrid_100__feeGrowthGlobal0X128,
            __warp_usrid_101__feeGrowthGlobal1X128,
        );

        update_d9a1a063(
            __warp_usrid_099_position,
            __warp_usrid_097_liquidityDelta,
            __warp_usrid_107_feeGrowthInside0X128,
            __warp_usrid_108_feeGrowthInside1X128,
        );

        let (__warp_se_660) = warp_lt_signed128(__warp_usrid_097_liquidityDelta, 0);

        if (__warp_se_660 != 0) {
            if (__warp_usrid_102_flippedLower != 0) {
                clear_db51(__warp_usrid_045_ticks, __warp_usrid_095_tickLower);

                let (__warp_se_661) = _updatePosition_42b4bd05_if_part1_if_part2(
                    __warp_usrid_103_flippedUpper,
                    __warp_usrid_096_tickUpper,
                    __warp_usrid_099_position,
                );

                return (__warp_se_661,);
            } else {
                let (__warp_se_662) = _updatePosition_42b4bd05_if_part1_if_part2(
                    __warp_usrid_103_flippedUpper,
                    __warp_usrid_096_tickUpper,
                    __warp_usrid_099_position,
                );

                return (__warp_se_662,);
            }
        } else {
            return (__warp_usrid_099_position,);
        }
    }

    func _updatePosition_42b4bd05_if_part1_if_part2{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }(
        __warp_usrid_103_flippedUpper: felt,
        __warp_usrid_096_tickUpper: felt,
        __warp_usrid_099_position: felt,
    ) -> (__warp_usrid_099_position: felt) {
        alloc_locals;

        if (__warp_usrid_103_flippedUpper != 0) {
            clear_db51(__warp_usrid_045_ticks, __warp_usrid_096_tickUpper);

            let (__warp_se_663) = _updatePosition_42b4bd05_if_part1_if_part2_if_part1(
                __warp_usrid_099_position
            );

            return (__warp_se_663,);
        } else {
            let (__warp_se_664) = _updatePosition_42b4bd05_if_part1_if_part2_if_part1(
                __warp_usrid_099_position
            );

            return (__warp_se_664,);
        }
    }

    func _updatePosition_42b4bd05_if_part1_if_part2_if_part1(__warp_usrid_099_position: felt) -> (
        __warp_usrid_099_position: felt
    ) {
        alloc_locals;

        return (__warp_usrid_099_position,);
    }

    func conditional0_148ce0b9{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(__warp_usrid_156_zeroForOne: felt, __warp_usrid_157_slot0Start: felt) -> (
        __warp_usrid_158_: felt
    ) {
        alloc_locals;

        if (__warp_usrid_156_zeroForOne != 0) {
            let (__warp_se_665) = WM32_Slot0_930d2817___warp_usrid_005_feeProtocol(
                __warp_usrid_157_slot0Start
            );

            let (__warp_se_666) = wm_read_felt(__warp_se_665);

            let (__warp_se_667) = warp_mod(__warp_se_666, 16);

            return (__warp_se_667,);
        } else {
            let (__warp_se_668) = WM32_Slot0_930d2817___warp_usrid_005_feeProtocol(
                __warp_usrid_157_slot0Start
            );

            let (__warp_se_669) = wm_read_felt(__warp_se_668);

            let (__warp_se_670) = warp_shr8(__warp_se_669, 4);

            return (__warp_se_670,);
        }
    }

    func conditional1_0f286cba{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }(__warp_usrid_159_zeroForOne: felt) -> (__warp_usrid_160_: Uint256) {
        alloc_locals;

        if (__warp_usrid_159_zeroForOne != 0) {
            let (__warp_se_671) = WS0_READ_Uint256(__warp_usrid_041_feeGrowthGlobal0X128);

            return (__warp_se_671,);
        } else {
            let (__warp_se_672) = WS0_READ_Uint256(__warp_usrid_042_feeGrowthGlobal1X128);

            return (__warp_se_672,);
        }
    }

    func conditional2_a88d8ea4{range_check_ptr: felt, warp_memory: DictAccess*}(
        __warp_usrid_161_flag: felt,
        __warp_usrid_162_sqrtPriceLimitX96: felt,
        __warp_usrid_163_step: felt,
    ) -> (__warp_usrid_164_: felt) {
        alloc_locals;

        if (__warp_usrid_161_flag != 0) {
            return (__warp_usrid_162_sqrtPriceLimitX96,);
        } else {
            let (__warp_se_673) = WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(
                __warp_usrid_163_step
            );

            let (__warp_se_674) = wm_read_felt(__warp_se_673);

            return (__warp_se_674,);
        }
    }

    func conditional3_e92662c8{range_check_ptr: felt, warp_memory: DictAccess*}(
        __warp_usrid_165_zeroForOne: felt,
        __warp_usrid_166_sqrtPriceLimitX96: felt,
        __warp_usrid_167_step: felt,
    ) -> (__warp_usrid_168_: felt) {
        alloc_locals;

        if (__warp_usrid_165_zeroForOne != 0) {
            let (__warp_se_675) = WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(
                __warp_usrid_167_step
            );

            let (__warp_se_676) = wm_read_felt(__warp_se_675);

            let (__warp_se_677) = warp_lt(__warp_se_676, __warp_usrid_166_sqrtPriceLimitX96);

            return (__warp_se_677,);
        } else {
            let (__warp_se_678) = WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(
                __warp_usrid_167_step
            );

            let (__warp_se_679) = wm_read_felt(__warp_se_678);

            let (__warp_se_680) = warp_gt(__warp_se_679, __warp_usrid_166_sqrtPriceLimitX96);

            return (__warp_se_680,);
        }
    }

    func conditional4_9427c021{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        warp_memory: DictAccess*,
    }(__warp_usrid_169_zeroForOne: felt, __warp_usrid_170_state: felt) -> (
        __warp_usrid_171_: Uint256
    ) {
        alloc_locals;

        if (__warp_usrid_169_zeroForOne != 0) {
            let (__warp_se_681) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(
                __warp_usrid_170_state
            );

            let (__warp_se_682) = wm_read_256(__warp_se_681);

            return (__warp_se_682,);
        } else {
            let (__warp_se_683) = WS0_READ_Uint256(__warp_usrid_041_feeGrowthGlobal0X128);

            return (__warp_se_683,);
        }
    }

    func conditional5_28dc1807{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        warp_memory: DictAccess*,
    }(__warp_usrid_172_zeroForOne: felt, __warp_usrid_173_state: felt) -> (
        __warp_usrid_174_: Uint256
    ) {
        alloc_locals;

        if (__warp_usrid_172_zeroForOne != 0) {
            let (__warp_se_684) = WS0_READ_Uint256(__warp_usrid_042_feeGrowthGlobal1X128);

            return (__warp_se_684,);
        } else {
            let (__warp_se_685) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(
                __warp_usrid_173_state
            );

            let (__warp_se_686) = wm_read_256(__warp_se_685);

            return (__warp_se_686,);
        }
    }

    func __warp_init_UniswapV3Pool{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }() -> () {
        alloc_locals;

        WS_WRITE1(__warp_usrid_033_loopRuns, Uint256(low=0, high=0));

        return ();
    }

    // @dev Private method is used instead of inlining into modifier because modifiers are copied into each method,
    //     and the use of immutable means the address bytes are copied in every place the modifier is used.
    func checkNotDelegateCall_8233c275{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }() -> () {
        alloc_locals;

        let (__warp_se_725) = get_contract_address();

        let (__warp_se_726) = WS1_READ_felt(__warp_usrid_00_original);

        let (__warp_se_727) = warp_eq(__warp_se_725, __warp_se_726);

        assert __warp_se_727 = 1;

        return ();
    }

    // @notice Derives max liquidity per tick from given tick spacing
    // @dev Executed within the pool constructor
    // @param tickSpacing The amount of required tick separation, realized in multiples of `tickSpacing`
    //     e.g., a tickSpacing of 3 requires ticks to be initialized every 3rd tick i.e., ..., -6, -3, 0, 3, 6, ...
    // @return The max liquidity per tick
    func tickSpacingToMaxLiquidityPerTick_82c66f87{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_08_tickSpacing: felt) -> (__warp_usrid_09_: felt) {
        alloc_locals;

        let (__warp_se_728) = warp_div_signed_unsafe24(15889944, __warp_usrid_08_tickSpacing);

        let (__warp_usrid_10_minTick) = warp_mul_signed_unsafe24(
            __warp_se_728, __warp_usrid_08_tickSpacing
        );

        let (__warp_se_729) = warp_div_signed_unsafe24(887272, __warp_usrid_08_tickSpacing);

        let (__warp_usrid_11_maxTick) = warp_mul_signed_unsafe24(
            __warp_se_729, __warp_usrid_08_tickSpacing
        );

        let (__warp_se_730) = warp_sub_signed_unsafe24(
            __warp_usrid_11_maxTick, __warp_usrid_10_minTick
        );

        let (__warp_se_731) = warp_div_unsafe(__warp_se_730, __warp_usrid_08_tickSpacing);

        let (__warp_usrid_12_numTicks) = warp_add_unsafe24(__warp_se_731, 1);

        let (__warp_se_732) = warp_div_unsafe(
            340282366920938463463374607431768211455, __warp_usrid_12_numTicks
        );

        return (__warp_se_732,);
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
    func getFeeGrowthInside_5ae8{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_13_self: felt,
        __warp_usrid_14_tickLower: felt,
        __warp_usrid_15_tickUpper: felt,
        __warp_usrid_16_tickCurrent: felt,
        __warp_usrid_17_feeGrowthGlobal0X128: Uint256,
        __warp_usrid_18_feeGrowthGlobal1X128: Uint256,
    ) -> (
        __warp_usrid_19_feeGrowthInside0X128: Uint256, __warp_usrid_20_feeGrowthInside1X128: Uint256
    ) {
        alloc_locals;

        let __warp_usrid_20_feeGrowthInside1X128 = Uint256(low=0, high=0);

        let __warp_usrid_19_feeGrowthInside0X128 = Uint256(low=0, high=0);

        let (__warp_usrid_21_lower) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_13_self, __warp_usrid_14_tickLower
        );

        let (__warp_usrid_22_upper) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_13_self, __warp_usrid_15_tickUpper
        );

        let __warp_usrid_23_feeGrowthBelow0X128 = Uint256(low=0, high=0);

        let __warp_usrid_24_feeGrowthBelow1X128 = Uint256(low=0, high=0);

        let (__warp_se_733) = warp_ge_signed24(
            __warp_usrid_16_tickCurrent, __warp_usrid_14_tickLower
        );

        if (__warp_se_733 != 0) {
            let (__warp_se_734) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                __warp_usrid_21_lower
            );

            let (__warp_se_735) = WS0_READ_Uint256(__warp_se_734);

            let __warp_usrid_23_feeGrowthBelow0X128 = __warp_se_735;

            let (__warp_se_736) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                __warp_usrid_21_lower
            );

            let (__warp_se_737) = WS0_READ_Uint256(__warp_se_736);

            let __warp_usrid_24_feeGrowthBelow1X128 = __warp_se_737;

            let (
                __warp_usrid_19_feeGrowthInside0X128, __warp_usrid_20_feeGrowthInside1X128
            ) = getFeeGrowthInside_5ae8_if_part1(
                __warp_usrid_16_tickCurrent,
                __warp_usrid_15_tickUpper,
                __warp_usrid_22_upper,
                __warp_usrid_17_feeGrowthGlobal0X128,
                __warp_usrid_18_feeGrowthGlobal1X128,
                __warp_usrid_19_feeGrowthInside0X128,
                __warp_usrid_23_feeGrowthBelow0X128,
                __warp_usrid_20_feeGrowthInside1X128,
                __warp_usrid_24_feeGrowthBelow1X128,
            );

            return (__warp_usrid_19_feeGrowthInside0X128, __warp_usrid_20_feeGrowthInside1X128);
        } else {
            let (__warp_se_738) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                __warp_usrid_21_lower
            );

            let (__warp_se_739) = WS0_READ_Uint256(__warp_se_738);

            let (__warp_se_740) = warp_sub_unsafe256(
                __warp_usrid_17_feeGrowthGlobal0X128, __warp_se_739
            );

            let __warp_usrid_23_feeGrowthBelow0X128 = __warp_se_740;

            let (__warp_se_741) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                __warp_usrid_21_lower
            );

            let (__warp_se_742) = WS0_READ_Uint256(__warp_se_741);

            let (__warp_se_743) = warp_sub_unsafe256(
                __warp_usrid_18_feeGrowthGlobal1X128, __warp_se_742
            );

            let __warp_usrid_24_feeGrowthBelow1X128 = __warp_se_743;

            let (
                __warp_usrid_19_feeGrowthInside0X128, __warp_usrid_20_feeGrowthInside1X128
            ) = getFeeGrowthInside_5ae8_if_part1(
                __warp_usrid_16_tickCurrent,
                __warp_usrid_15_tickUpper,
                __warp_usrid_22_upper,
                __warp_usrid_17_feeGrowthGlobal0X128,
                __warp_usrid_18_feeGrowthGlobal1X128,
                __warp_usrid_19_feeGrowthInside0X128,
                __warp_usrid_23_feeGrowthBelow0X128,
                __warp_usrid_20_feeGrowthInside1X128,
                __warp_usrid_24_feeGrowthBelow1X128,
            );

            return (__warp_usrid_19_feeGrowthInside0X128, __warp_usrid_20_feeGrowthInside1X128);
        }
    }

    func getFeeGrowthInside_5ae8_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_16_tickCurrent: felt,
        __warp_usrid_15_tickUpper: felt,
        __warp_usrid_22_upper: felt,
        __warp_usrid_17_feeGrowthGlobal0X128: Uint256,
        __warp_usrid_18_feeGrowthGlobal1X128: Uint256,
        __warp_usrid_19_feeGrowthInside0X128: Uint256,
        __warp_usrid_23_feeGrowthBelow0X128: Uint256,
        __warp_usrid_20_feeGrowthInside1X128: Uint256,
        __warp_usrid_24_feeGrowthBelow1X128: Uint256,
    ) -> (
        __warp_usrid_19_feeGrowthInside0X128: Uint256, __warp_usrid_20_feeGrowthInside1X128: Uint256
    ) {
        alloc_locals;

        let __warp_usrid_25_feeGrowthAbove0X128 = Uint256(low=0, high=0);

        let __warp_usrid_26_feeGrowthAbove1X128 = Uint256(low=0, high=0);

        let (__warp_se_744) = warp_lt_signed24(
            __warp_usrid_16_tickCurrent, __warp_usrid_15_tickUpper
        );

        if (__warp_se_744 != 0) {
            let (__warp_se_745) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                __warp_usrid_22_upper
            );

            let (__warp_se_746) = WS0_READ_Uint256(__warp_se_745);

            let __warp_usrid_25_feeGrowthAbove0X128 = __warp_se_746;

            let (__warp_se_747) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                __warp_usrid_22_upper
            );

            let (__warp_se_748) = WS0_READ_Uint256(__warp_se_747);

            let __warp_usrid_26_feeGrowthAbove1X128 = __warp_se_748;

            let (
                __warp_usrid_19_feeGrowthInside0X128, __warp_usrid_20_feeGrowthInside1X128
            ) = getFeeGrowthInside_5ae8_if_part1_if_part1(
                __warp_usrid_19_feeGrowthInside0X128,
                __warp_usrid_17_feeGrowthGlobal0X128,
                __warp_usrid_23_feeGrowthBelow0X128,
                __warp_usrid_25_feeGrowthAbove0X128,
                __warp_usrid_20_feeGrowthInside1X128,
                __warp_usrid_18_feeGrowthGlobal1X128,
                __warp_usrid_24_feeGrowthBelow1X128,
                __warp_usrid_26_feeGrowthAbove1X128,
            );

            return (__warp_usrid_19_feeGrowthInside0X128, __warp_usrid_20_feeGrowthInside1X128);
        } else {
            let (__warp_se_749) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                __warp_usrid_22_upper
            );

            let (__warp_se_750) = WS0_READ_Uint256(__warp_se_749);

            let (__warp_se_751) = warp_sub_unsafe256(
                __warp_usrid_17_feeGrowthGlobal0X128, __warp_se_750
            );

            let __warp_usrid_25_feeGrowthAbove0X128 = __warp_se_751;

            let (__warp_se_752) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                __warp_usrid_22_upper
            );

            let (__warp_se_753) = WS0_READ_Uint256(__warp_se_752);

            let (__warp_se_754) = warp_sub_unsafe256(
                __warp_usrid_18_feeGrowthGlobal1X128, __warp_se_753
            );

            let __warp_usrid_26_feeGrowthAbove1X128 = __warp_se_754;

            let (
                __warp_usrid_19_feeGrowthInside0X128, __warp_usrid_20_feeGrowthInside1X128
            ) = getFeeGrowthInside_5ae8_if_part1_if_part1(
                __warp_usrid_19_feeGrowthInside0X128,
                __warp_usrid_17_feeGrowthGlobal0X128,
                __warp_usrid_23_feeGrowthBelow0X128,
                __warp_usrid_25_feeGrowthAbove0X128,
                __warp_usrid_20_feeGrowthInside1X128,
                __warp_usrid_18_feeGrowthGlobal1X128,
                __warp_usrid_24_feeGrowthBelow1X128,
                __warp_usrid_26_feeGrowthAbove1X128,
            );

            return (__warp_usrid_19_feeGrowthInside0X128, __warp_usrid_20_feeGrowthInside1X128);
        }
    }

    func getFeeGrowthInside_5ae8_if_part1_if_part1{bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_19_feeGrowthInside0X128: Uint256,
        __warp_usrid_17_feeGrowthGlobal0X128: Uint256,
        __warp_usrid_23_feeGrowthBelow0X128: Uint256,
        __warp_usrid_25_feeGrowthAbove0X128: Uint256,
        __warp_usrid_20_feeGrowthInside1X128: Uint256,
        __warp_usrid_18_feeGrowthGlobal1X128: Uint256,
        __warp_usrid_24_feeGrowthBelow1X128: Uint256,
        __warp_usrid_26_feeGrowthAbove1X128: Uint256,
    ) -> (
        __warp_usrid_19_feeGrowthInside0X128: Uint256, __warp_usrid_20_feeGrowthInside1X128: Uint256
    ) {
        alloc_locals;

        let (__warp_se_755) = warp_sub_unsafe256(
            __warp_usrid_17_feeGrowthGlobal0X128, __warp_usrid_23_feeGrowthBelow0X128
        );

        let (__warp_se_756) = warp_sub_unsafe256(
            __warp_se_755, __warp_usrid_25_feeGrowthAbove0X128
        );

        let __warp_usrid_19_feeGrowthInside0X128 = __warp_se_756;

        let (__warp_se_757) = warp_sub_unsafe256(
            __warp_usrid_18_feeGrowthGlobal1X128, __warp_usrid_24_feeGrowthBelow1X128
        );

        let (__warp_se_758) = warp_sub_unsafe256(
            __warp_se_757, __warp_usrid_26_feeGrowthAbove1X128
        );

        let __warp_usrid_20_feeGrowthInside1X128 = __warp_se_758;

        let __warp_usrid_19_feeGrowthInside0X128 = __warp_usrid_19_feeGrowthInside0X128;

        let __warp_usrid_20_feeGrowthInside1X128 = __warp_usrid_20_feeGrowthInside1X128;

        return (__warp_usrid_19_feeGrowthInside0X128, __warp_usrid_20_feeGrowthInside1X128);
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
    func update_3bf3{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_27_self: felt,
        __warp_usrid_28_tick: felt,
        __warp_usrid_29_tickCurrent: felt,
        __warp_usrid_30_liquidityDelta: felt,
        __warp_usrid_31_feeGrowthGlobal0X128: Uint256,
        __warp_usrid_32_feeGrowthGlobal1X128: Uint256,
        __warp_usrid_33_secondsPerLiquidityCumulativeX128: felt,
        __warp_usrid_34_tickCumulative: felt,
        __warp_usrid_35_time: felt,
        __warp_usrid_36_upper: felt,
        __warp_usrid_37_maxLiquidity: felt,
    ) -> (__warp_usrid_38_flipped: felt) {
        alloc_locals;

        let __warp_usrid_38_flipped = 0;

        let (__warp_usrid_39_info) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_27_self, __warp_usrid_28_tick
        );

        let (__warp_se_759) = WSM16_Info_39bc053d___warp_usrid_00_liquidityGross(
            __warp_usrid_39_info
        );

        let (__warp_usrid_40_liquidityGrossBefore) = WS1_READ_felt(__warp_se_759);

        let (__warp_usrid_41_liquidityGrossAfter) = addDelta_402d44fb(
            __warp_usrid_40_liquidityGrossBefore, __warp_usrid_30_liquidityDelta
        );

        let (__warp_se_760) = warp_le(
            __warp_usrid_41_liquidityGrossAfter, __warp_usrid_37_maxLiquidity
        );

        with_attr error_message("LO") {
            assert __warp_se_760 = 1;
        }

        let (__warp_se_761) = warp_eq(__warp_usrid_41_liquidityGrossAfter, 0);

        let (__warp_se_762) = warp_eq(__warp_usrid_40_liquidityGrossBefore, 0);

        let (__warp_se_763) = warp_neq(__warp_se_761, __warp_se_762);

        let __warp_usrid_38_flipped = __warp_se_763;

        let (__warp_se_764) = warp_eq(__warp_usrid_40_liquidityGrossBefore, 0);

        if (__warp_se_764 != 0) {
            let (__warp_se_765) = warp_le_signed24(
                __warp_usrid_28_tick, __warp_usrid_29_tickCurrent
            );

            if (__warp_se_765 != 0) {
                let (__warp_se_766) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
                    __warp_usrid_39_info
                );

                WS_WRITE1(__warp_se_766, __warp_usrid_31_feeGrowthGlobal0X128);

                let (__warp_se_767) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
                    __warp_usrid_39_info
                );

                WS_WRITE1(__warp_se_767, __warp_usrid_32_feeGrowthGlobal1X128);

                let (
                    __warp_se_768
                ) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
                    __warp_usrid_39_info
                );

                WS_WRITE0(__warp_se_768, __warp_usrid_33_secondsPerLiquidityCumulativeX128);

                let (__warp_se_769) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
                    __warp_usrid_39_info
                );

                WS_WRITE0(__warp_se_769, __warp_usrid_34_tickCumulative);

                let (__warp_se_770) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(
                    __warp_usrid_39_info
                );

                WS_WRITE0(__warp_se_770, __warp_usrid_35_time);

                let (__warp_se_771) = update_3bf3_if_part2(
                    __warp_usrid_39_info,
                    __warp_usrid_41_liquidityGrossAfter,
                    __warp_usrid_36_upper,
                    __warp_usrid_30_liquidityDelta,
                    __warp_usrid_38_flipped,
                );

                return (__warp_se_771,);
            } else {
                let (__warp_se_772) = update_3bf3_if_part2(
                    __warp_usrid_39_info,
                    __warp_usrid_41_liquidityGrossAfter,
                    __warp_usrid_36_upper,
                    __warp_usrid_30_liquidityDelta,
                    __warp_usrid_38_flipped,
                );

                return (__warp_se_772,);
            }
        } else {
            let (__warp_se_773) = update_3bf3_if_part1(
                __warp_usrid_39_info,
                __warp_usrid_41_liquidityGrossAfter,
                __warp_usrid_36_upper,
                __warp_usrid_30_liquidityDelta,
                __warp_usrid_38_flipped,
            );

            return (__warp_se_773,);
        }
    }

    func update_3bf3_if_part2{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_39_info: felt,
        __warp_usrid_41_liquidityGrossAfter: felt,
        __warp_usrid_36_upper: felt,
        __warp_usrid_30_liquidityDelta: felt,
        __warp_usrid_38_flipped: felt,
    ) -> (__warp_usrid_38_flipped: felt) {
        alloc_locals;

        let (__warp_se_774) = WSM15_Info_39bc053d___warp_usrid_07_initialized(__warp_usrid_39_info);

        WS_WRITE0(__warp_se_774, 1);

        let (__warp_se_775) = update_3bf3_if_part1(
            __warp_usrid_39_info,
            __warp_usrid_41_liquidityGrossAfter,
            __warp_usrid_36_upper,
            __warp_usrid_30_liquidityDelta,
            __warp_usrid_38_flipped,
        );

        return (__warp_se_775,);
    }

    func update_3bf3_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_39_info: felt,
        __warp_usrid_41_liquidityGrossAfter: felt,
        __warp_usrid_36_upper: felt,
        __warp_usrid_30_liquidityDelta: felt,
        __warp_usrid_38_flipped: felt,
    ) -> (__warp_usrid_38_flipped: felt) {
        alloc_locals;

        let (__warp_se_776) = WSM16_Info_39bc053d___warp_usrid_00_liquidityGross(
            __warp_usrid_39_info
        );

        WS_WRITE0(__warp_se_776, __warp_usrid_41_liquidityGrossAfter);

        if (__warp_usrid_36_upper != 0) {
            let (__warp_se_777) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_39_info
            );

            let (__warp_se_778) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_39_info
            );

            let (__warp_se_779) = WS1_READ_felt(__warp_se_778);

            let (__warp_se_780) = warp_int128_to_int256(__warp_se_779);

            let (__warp_se_781) = warp_int128_to_int256(__warp_usrid_30_liquidityDelta);

            let (__warp_se_782) = sub_adefc37b(__warp_se_780, __warp_se_781);

            let (__warp_se_783) = toInt128_dd2a0316(__warp_se_782);

            WS_WRITE0(__warp_se_777, __warp_se_783);

            return (__warp_usrid_38_flipped,);
        } else {
            let (__warp_se_784) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_39_info
            );

            let (__warp_se_785) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(
                __warp_usrid_39_info
            );

            let (__warp_se_786) = WS1_READ_felt(__warp_se_785);

            let (__warp_se_787) = warp_int128_to_int256(__warp_se_786);

            let (__warp_se_788) = warp_int128_to_int256(__warp_usrid_30_liquidityDelta);

            let (__warp_se_789) = add_a5f3c23b(__warp_se_787, __warp_se_788);

            let (__warp_se_790) = toInt128_dd2a0316(__warp_se_789);

            WS_WRITE0(__warp_se_784, __warp_se_790);

            return (__warp_usrid_38_flipped,);
        }
    }

    // @notice Clears tick data
    // @param self The mapping containing all initialized tick information for initialized ticks
    // @param tick The tick that will be cleared
    func clear_db51{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
        __warp_usrid_42_self: felt, __warp_usrid_43_tick: felt
    ) -> () {
        alloc_locals;

        let (__warp_se_791) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_42_self, __warp_usrid_43_tick
        );

        WS_STRUCT_Info_DELETE(__warp_se_791);

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
    func cross_5d47{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_44_self: felt,
        __warp_usrid_45_tick: felt,
        __warp_usrid_46_feeGrowthGlobal0X128: Uint256,
        __warp_usrid_47_feeGrowthGlobal1X128: Uint256,
        __warp_usrid_48_secondsPerLiquidityCumulativeX128: felt,
        __warp_usrid_49_tickCumulative: felt,
        __warp_usrid_50_time: felt,
    ) -> (__warp_usrid_51_liquidityNet: felt) {
        alloc_locals;

        let __warp_usrid_51_liquidityNet = 0;

        let (__warp_usrid_52_info) = WS0_INDEX_felt_to_Info_39bc053d(
            __warp_usrid_44_self, __warp_usrid_45_tick
        );

        let (__warp_se_792) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
            __warp_usrid_52_info
        );

        let (__warp_se_793) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
            __warp_usrid_52_info
        );

        let (__warp_se_794) = WS0_READ_Uint256(__warp_se_793);

        let (__warp_se_795) = warp_sub_unsafe256(
            __warp_usrid_46_feeGrowthGlobal0X128, __warp_se_794
        );

        WS_WRITE1(__warp_se_792, __warp_se_795);

        let (__warp_se_796) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
            __warp_usrid_52_info
        );

        let (__warp_se_797) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
            __warp_usrid_52_info
        );

        let (__warp_se_798) = WS0_READ_Uint256(__warp_se_797);

        let (__warp_se_799) = warp_sub_unsafe256(
            __warp_usrid_47_feeGrowthGlobal1X128, __warp_se_798
        );

        WS_WRITE1(__warp_se_796, __warp_se_799);

        let (__warp_se_800) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
            __warp_usrid_52_info
        );

        let (__warp_se_801) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
            __warp_usrid_52_info
        );

        let (__warp_se_802) = WS1_READ_felt(__warp_se_801);

        let (__warp_se_803) = warp_sub_unsafe160(
            __warp_usrid_48_secondsPerLiquidityCumulativeX128, __warp_se_802
        );

        WS_WRITE0(__warp_se_800, __warp_se_803);

        let (__warp_se_804) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
            __warp_usrid_52_info
        );

        let (__warp_se_805) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
            __warp_usrid_52_info
        );

        let (__warp_se_806) = WS1_READ_felt(__warp_se_805);

        let (__warp_se_807) = warp_sub_signed_unsafe56(
            __warp_usrid_49_tickCumulative, __warp_se_806
        );

        WS_WRITE0(__warp_se_804, __warp_se_807);

        let (__warp_se_808) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(
            __warp_usrid_52_info
        );

        let (__warp_se_809) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(
            __warp_usrid_52_info
        );

        let (__warp_se_810) = WS1_READ_felt(__warp_se_809);

        let (__warp_se_811) = warp_sub_unsafe32(__warp_usrid_50_time, __warp_se_810);

        WS_WRITE0(__warp_se_808, __warp_se_811);

        let (__warp_se_812) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(
            __warp_usrid_52_info
        );

        let (__warp_se_813) = WS1_READ_felt(__warp_se_812);

        let __warp_usrid_51_liquidityNet = __warp_se_813;

        return (__warp_usrid_51_liquidityNet,);
    }

    // @notice Add a signed liquidity delta to liquidity and revert if it overflows or underflows
    // @param x The liquidity before change
    // @param y The delta by which liquidity should be changed
    // @return z The liquidity delta
    func addDelta_402d44fb{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_00_x: felt, __warp_usrid_01_y: felt
    ) -> (__warp_usrid_02_z: felt) {
        alloc_locals;

        let __warp_usrid_02_z = 0;

        let (__warp_se_814) = warp_lt_signed128(__warp_usrid_01_y, 0);

        if (__warp_se_814 != 0) {
            let (__warp_se_815) = warp_negate128(__warp_usrid_01_y);

            let (__warp_se_816) = warp_sub_unsafe128(__warp_usrid_00_x, __warp_se_815);

            let __warp_se_817 = __warp_se_816;

            let __warp_usrid_02_z = __warp_se_817;

            let (__warp_se_818) = warp_lt(__warp_se_817, __warp_usrid_00_x);

            with_attr error_message("LS") {
                assert __warp_se_818 = 1;
            }

            let (__warp_se_819) = addDelta_402d44fb_if_part1(__warp_usrid_02_z);

            return (__warp_se_819,);
        } else {
            let (__warp_se_820) = warp_add_unsafe128(__warp_usrid_00_x, __warp_usrid_01_y);

            let __warp_se_821 = __warp_se_820;

            let __warp_usrid_02_z = __warp_se_821;

            let (__warp_se_822) = warp_ge(__warp_se_821, __warp_usrid_00_x);

            with_attr error_message("LA") {
                assert __warp_se_822 = 1;
            }

            let (__warp_se_823) = addDelta_402d44fb_if_part1(__warp_usrid_02_z);

            return (__warp_se_823,);
        }
    }

    func addDelta_402d44fb_if_part1(__warp_usrid_02_z: felt) -> (__warp_usrid_02_z: felt) {
        alloc_locals;

        return (__warp_usrid_02_z,);
    }

    // @notice Cast a uint256 to a uint160, revert on overflow
    // @param y The uint256 to be downcasted
    // @return z The downcasted integer, now type uint160
    func toUint160_dfef6beb{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_00_y: Uint256
    ) -> (__warp_usrid_01_z: felt) {
        alloc_locals;

        let __warp_usrid_01_z = 0;

        let (__warp_se_824) = warp_int256_to_int160(__warp_usrid_00_y);

        let __warp_se_825 = __warp_se_824;

        let __warp_usrid_01_z = __warp_se_825;

        let (__warp_se_826) = warp_uint256(__warp_se_825);

        let (__warp_se_827) = warp_eq256(__warp_se_826, __warp_usrid_00_y);

        assert __warp_se_827 = 1;

        return (__warp_usrid_01_z,);
    }

    // @notice Cast a int256 to a int128, revert on overflow or underflow
    // @param y The int256 to be downcasted
    // @return z The downcasted integer, now type int128
    func toInt128_dd2a0316{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_02_y: Uint256
    ) -> (__warp_usrid_03_z: felt) {
        alloc_locals;

        let __warp_usrid_03_z = 0;

        let (__warp_se_828) = warp_int256_to_int128(__warp_usrid_02_y);

        let __warp_se_829 = __warp_se_828;

        let __warp_usrid_03_z = __warp_se_829;

        let (__warp_se_830) = warp_int128_to_int256(__warp_se_829);

        let (__warp_se_831) = warp_eq256(__warp_se_830, __warp_usrid_02_y);

        assert __warp_se_831 = 1;

        return (__warp_usrid_03_z,);
    }

    // @notice Cast a uint256 to a int256, revert on overflow
    // @param y The uint256 to be casted
    // @return z The casted integer, now type int256
    func toInt256_dfbe873b{range_check_ptr: felt}(__warp_usrid_04_y: Uint256) -> (
        __warp_usrid_05_z: Uint256
    ) {
        alloc_locals;

        let __warp_usrid_05_z = Uint256(low=0, high=0);

        let (__warp_se_832) = warp_lt256(
            __warp_usrid_04_y, Uint256(low=0, high=170141183460469231731687303715884105728)
        );

        assert __warp_se_832 = 1;

        let __warp_usrid_05_z = __warp_usrid_04_y;

        return (__warp_usrid_05_z,);
    }

    // @notice Returns x + y, reverts if sum overflows uint256
    // @param x The augend
    // @param y The addend
    // @return z The sum of x and y
    func add_771602f7{range_check_ptr: felt}(
        __warp_usrid_00_x: Uint256, __warp_usrid_01_y: Uint256
    ) -> (__warp_usrid_02_z: Uint256) {
        alloc_locals;

        let __warp_usrid_02_z = Uint256(low=0, high=0);

        let (__warp_se_833) = warp_add_unsafe256(__warp_usrid_00_x, __warp_usrid_01_y);

        let __warp_se_834 = __warp_se_833;

        let __warp_usrid_02_z = __warp_se_834;

        let (__warp_se_835) = warp_ge256(__warp_se_834, __warp_usrid_00_x);

        assert __warp_se_835 = 1;

        return (__warp_usrid_02_z,);
    }

    // @notice Returns x + y, reverts if overflows or underflows
    // @param x The augend
    // @param y The addend
    // @return z The sum of x and y
    func add_a5f3c23b{range_check_ptr: felt}(
        __warp_usrid_09_x: Uint256, __warp_usrid_10_y: Uint256
    ) -> (__warp_usrid_11_z: Uint256) {
        alloc_locals;

        let __warp_usrid_11_z = Uint256(low=0, high=0);

        let (__warp_se_836) = warp_add_signed_unsafe256(__warp_usrid_09_x, __warp_usrid_10_y);

        let __warp_se_837 = __warp_se_836;

        let __warp_usrid_11_z = __warp_se_837;

        let (__warp_se_838) = warp_ge_signed256(__warp_se_837, __warp_usrid_09_x);

        let (__warp_se_839) = warp_ge_signed256(__warp_usrid_10_y, Uint256(low=0, high=0));

        let (__warp_se_840) = warp_eq(__warp_se_838, __warp_se_839);

        assert __warp_se_840 = 1;

        return (__warp_usrid_11_z,);
    }

    // @notice Returns x - y, reverts if overflows or underflows
    // @param x The minuend
    // @param y The subtrahend
    // @return z The difference of x and y
    func sub_adefc37b{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_12_x: Uint256, __warp_usrid_13_y: Uint256
    ) -> (__warp_usrid_14_z: Uint256) {
        alloc_locals;

        let __warp_usrid_14_z = Uint256(low=0, high=0);

        let (__warp_se_841) = warp_sub_signed_unsafe256(__warp_usrid_12_x, __warp_usrid_13_y);

        let __warp_se_842 = __warp_se_841;

        let __warp_usrid_14_z = __warp_se_842;

        let (__warp_se_843) = warp_le_signed256(__warp_se_842, __warp_usrid_12_x);

        let (__warp_se_844) = warp_ge_signed256(__warp_usrid_13_y, Uint256(low=0, high=0));

        let (__warp_se_845) = warp_eq(__warp_se_843, __warp_se_844);

        assert __warp_se_845 = 1;

        return (__warp_usrid_14_z,);
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

        let (__warp_se_846) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_04_last
        );

        let (__warp_se_847) = wm_read_felt(__warp_se_846);

        let (__warp_usrid_09_delta) = warp_sub_unsafe32(
            __warp_usrid_05_blockTimestamp, __warp_se_847
        );

        let (__warp_se_848) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(
            __warp_usrid_04_last
        );

        let (__warp_se_849) = wm_read_felt(__warp_se_848);

        let (__warp_se_850) = warp_int24_to_int56(__warp_usrid_06_tick);

        let (__warp_se_851) = warp_mul_signed_unsafe56(__warp_se_850, __warp_usrid_09_delta);

        let (__warp_se_852) = warp_add_signed_unsafe56(__warp_se_849, __warp_se_851);

        let (
            __warp_se_853
        ) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
            __warp_usrid_04_last
        );

        let (__warp_se_854) = wm_read_felt(__warp_se_853);

        let (__warp_se_855) = warp_shl160(__warp_usrid_09_delta, 128);

        let (__warp_se_856) = conditional0_5bba3b34(__warp_usrid_07_liquidity);

        let (__warp_se_857) = warp_div_unsafe(__warp_se_855, __warp_se_856);

        let (__warp_se_858) = warp_add_unsafe160(__warp_se_854, __warp_se_857);

        let (__warp_se_859) = WM5_struct_Observation_2cc4d695(
            __warp_usrid_05_blockTimestamp, __warp_se_852, __warp_se_858, 1
        );

        return (__warp_se_859,);
    }

    func conditional0_5bba3b34{range_check_ptr: felt}(__warp_usrid_10_liquidity: felt) -> (
        __warp_usrid_11_: felt
    ) {
        alloc_locals;

        let (__warp_se_860) = warp_gt(__warp_usrid_10_liquidity, 0);

        if (__warp_se_860 != 0) {
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

        let (__warp_se_861) = WS0_IDX(
            __warp_usrid_12_self,
            Uint256(low=0, high=0),
            Uint256(low=4, high=0),
            Uint256(low=65535, high=0),
        );

        let (__warp_se_862) = WM5_struct_Observation_2cc4d695(__warp_usrid_13_time, 0, 0, 1);

        wm_to_storage1(__warp_se_861, __warp_se_862);

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

        let (__warp_se_863) = warp_uint256(__warp_usrid_17_index);

        let (__warp_se_864) = WS0_IDX(
            __warp_usrid_16_self, __warp_se_863, Uint256(low=4, high=0), Uint256(low=65535, high=0)
        );

        let (__warp_usrid_25_last) = ws_to_memory0(__warp_se_864);

        let (__warp_se_865) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_25_last
        );

        let (__warp_se_866) = wm_read_felt(__warp_se_865);

        let (__warp_se_867) = warp_eq(__warp_se_866, __warp_usrid_18_blockTimestamp);

        if (__warp_se_867 != 0) {
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

        let (__warp_se_868) = warp_gt(__warp_usrid_22_cardinalityNext, __warp_usrid_21_cardinality);

        let (__warp_se_869) = warp_sub_unsafe16(__warp_usrid_21_cardinality, 1);

        let (__warp_se_870) = warp_eq(__warp_usrid_17_index, __warp_se_869);

        let (__warp_se_871) = warp_and_(__warp_se_868, __warp_se_870);

        if (__warp_se_871 != 0) {
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

        let (__warp_se_872) = warp_add_unsafe16(__warp_usrid_17_index, 1);

        let (__warp_se_873) = warp_mod(__warp_se_872, __warp_usrid_24_cardinalityUpdated);

        let __warp_usrid_23_indexUpdated = __warp_se_873;

        let (__warp_se_874) = warp_uint256(__warp_usrid_23_indexUpdated);

        let (__warp_se_875) = WS0_IDX(
            __warp_usrid_16_self, __warp_se_874, Uint256(low=4, high=0), Uint256(low=65535, high=0)
        );

        let (__warp_se_876) = transform_44108314(
            __warp_usrid_25_last,
            __warp_usrid_18_blockTimestamp,
            __warp_usrid_19_tick,
            __warp_usrid_20_liquidity,
        );

        wm_to_storage1(__warp_se_875, __warp_se_876);

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

        let (__warp_se_877) = warp_gt(__warp_usrid_27_current, 0);

        with_attr error_message("I") {
            assert __warp_se_877 = 1;
        }

        let (__warp_se_878) = warp_le(__warp_usrid_28_next, __warp_usrid_27_current);

        if (__warp_se_878 != 0) {
            return (__warp_usrid_27_current,);
        } else {
            let (__warp_se_879) = grow_48fc651e_if_part1(
                __warp_usrid_27_current, __warp_usrid_28_next, __warp_usrid_26_self
            );

            return (__warp_se_879,);
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

        let (__warp_tv_61, __warp_tv_62, __warp_td_136) = __warp_while8(
            __warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self
        );

        let __warp_tv_63 = __warp_td_136;

        let __warp_usrid_26_self = __warp_tv_63;

        let __warp_usrid_28_next = __warp_tv_62;

        let __warp_usrid_30_i = __warp_tv_61;

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

        let (__warp_se_880) = warp_le(__warp_usrid_32_a, __warp_usrid_31_time);

        let (__warp_se_881) = warp_le(__warp_usrid_33_b, __warp_usrid_31_time);

        let (__warp_se_882) = warp_and_(__warp_se_880, __warp_se_881);

        if (__warp_se_882 != 0) {
            let (__warp_se_883) = warp_le(__warp_usrid_32_a, __warp_usrid_33_b);

            return (__warp_se_883,);
        } else {
            let (__warp_se_884) = lte_34209030_if_part1(
                __warp_usrid_32_a, __warp_usrid_31_time, __warp_usrid_33_b
            );

            return (__warp_se_884,);
        }
    }

    func lte_34209030_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_32_a: felt, __warp_usrid_31_time: felt, __warp_usrid_33_b: felt
    ) -> (__warp_usrid_34_: felt) {
        alloc_locals;

        let (__warp_se_885) = warp_add_unsafe40(__warp_usrid_32_a, 4294967296);

        let (__warp_usrid_35_aAdjusted) = warp_uint256(__warp_se_885);

        let (__warp_se_886) = warp_gt(__warp_usrid_32_a, __warp_usrid_31_time);

        if (__warp_se_886 != 0) {
            let (__warp_se_887) = warp_uint256(__warp_usrid_32_a);

            let __warp_usrid_35_aAdjusted = __warp_se_887;

            let (__warp_se_888) = lte_34209030_if_part1_if_part1(
                __warp_usrid_33_b, __warp_usrid_31_time, __warp_usrid_35_aAdjusted
            );

            return (__warp_se_888,);
        } else {
            let (__warp_se_889) = lte_34209030_if_part1_if_part1(
                __warp_usrid_33_b, __warp_usrid_31_time, __warp_usrid_35_aAdjusted
            );

            return (__warp_se_889,);
        }
    }

    func lte_34209030_if_part1_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_33_b: felt, __warp_usrid_31_time: felt, __warp_usrid_35_aAdjusted: Uint256
    ) -> (__warp_usrid_34_: felt) {
        alloc_locals;

        let (__warp_se_890) = warp_add_unsafe40(__warp_usrid_33_b, 4294967296);

        let (__warp_usrid_36_bAdjusted) = warp_uint256(__warp_se_890);

        let (__warp_se_891) = warp_gt(__warp_usrid_33_b, __warp_usrid_31_time);

        if (__warp_se_891 != 0) {
            let (__warp_se_892) = warp_uint256(__warp_usrid_33_b);

            let __warp_usrid_36_bAdjusted = __warp_se_892;

            let (__warp_se_893) = lte_34209030_if_part1_if_part1_if_part1(
                __warp_usrid_35_aAdjusted, __warp_usrid_36_bAdjusted
            );

            return (__warp_se_893,);
        } else {
            let (__warp_se_894) = lte_34209030_if_part1_if_part1_if_part1(
                __warp_usrid_35_aAdjusted, __warp_usrid_36_bAdjusted
            );

            return (__warp_se_894,);
        }
    }

    func lte_34209030_if_part1_if_part1_if_part1{range_check_ptr: felt}(
        __warp_usrid_35_aAdjusted: Uint256, __warp_usrid_36_bAdjusted: Uint256
    ) -> (__warp_usrid_34_: felt) {
        alloc_locals;

        let (__warp_se_895) = warp_le256(__warp_usrid_35_aAdjusted, __warp_usrid_36_bAdjusted);

        return (__warp_se_895,);
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

        let (__warp_usrid_43_atOrAfter) = WM5_struct_Observation_2cc4d695(0, 0, 0, 0);

        let (__warp_usrid_42_beforeOrAt) = WM5_struct_Observation_2cc4d695(0, 0, 0, 0);

        let (__warp_se_896) = warp_add_unsafe16(__warp_usrid_40_index, 1);

        let (__warp_se_897) = warp_mod(__warp_se_896, __warp_usrid_41_cardinality);

        let (__warp_usrid_44_l) = warp_uint256(__warp_se_897);

        let (__warp_se_898) = warp_uint256(__warp_usrid_41_cardinality);

        let (__warp_se_899) = warp_add_unsafe256(__warp_usrid_44_l, __warp_se_898);

        let (__warp_usrid_45_r) = warp_sub_unsafe256(__warp_se_899, Uint256(low=1, high=0));

        let __warp_usrid_46_i = Uint256(low=0, high=0);

        let (
            __warp_tv_64,
            __warp_tv_65,
            __warp_tv_66,
            __warp_td_137,
            __warp_td_138,
            __warp_tv_69,
            __warp_td_139,
            __warp_tv_71,
            __warp_tv_72,
        ) = __warp_while9(
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

        let __warp_tv_67 = __warp_td_137;

        let __warp_tv_68 = __warp_td_138;

        let __warp_tv_70 = __warp_td_139;

        let __warp_usrid_39_target = __warp_tv_72;

        let __warp_usrid_38_time = __warp_tv_71;

        let __warp_usrid_43_atOrAfter = __warp_tv_70;

        let __warp_usrid_41_cardinality = __warp_tv_69;

        let __warp_usrid_37_self = __warp_tv_68;

        let __warp_usrid_42_beforeOrAt = __warp_tv_67;

        let __warp_usrid_45_r = __warp_tv_66;

        let __warp_usrid_44_l = __warp_tv_65;

        let __warp_usrid_46_i = __warp_tv_64;

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

        let (__warp_usrid_56_atOrAfter) = WM5_struct_Observation_2cc4d695(0, 0, 0, 0);

        let (__warp_usrid_55_beforeOrAt) = WM5_struct_Observation_2cc4d695(0, 0, 0, 0);

        let (__warp_se_900) = warp_uint256(__warp_usrid_52_index);

        let (__warp_se_901) = WS0_IDX(
            __warp_usrid_48_self, __warp_se_900, Uint256(low=4, high=0), Uint256(low=65535, high=0)
        );

        let (__warp_se_902) = ws_to_memory0(__warp_se_901);

        let __warp_usrid_55_beforeOrAt = __warp_se_902;

        let (__warp_se_903) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_55_beforeOrAt
        );

        let (__warp_se_904) = wm_read_felt(__warp_se_903);

        let (__warp_se_905) = lte_34209030(
            __warp_usrid_49_time, __warp_se_904, __warp_usrid_50_target
        );

        if (__warp_se_905 != 0) {
            let (__warp_se_906) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                __warp_usrid_55_beforeOrAt
            );

            let (__warp_se_907) = wm_read_felt(__warp_se_906);

            let (__warp_se_908) = warp_eq(__warp_se_907, __warp_usrid_50_target);

            if (__warp_se_908 != 0) {
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
            let (__warp_td_144, __warp_td_145) = getSurroundingObservations_68850d1b_if_part1(
                __warp_usrid_55_beforeOrAt,
                __warp_usrid_48_self,
                __warp_usrid_52_index,
                __warp_usrid_54_cardinality,
                __warp_usrid_49_time,
                __warp_usrid_50_target,
            );

            let __warp_usrid_55_beforeOrAt = __warp_td_144;

            let __warp_usrid_56_atOrAfter = __warp_td_145;

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

        let (__warp_se_909) = warp_add_unsafe16(__warp_usrid_52_index, 1);

        let (__warp_se_910) = warp_mod(__warp_se_909, __warp_usrid_54_cardinality);

        let (__warp_se_911) = warp_uint256(__warp_se_910);

        let (__warp_se_912) = WS0_IDX(
            __warp_usrid_48_self, __warp_se_911, Uint256(low=4, high=0), Uint256(low=65535, high=0)
        );

        let (__warp_se_913) = ws_to_memory0(__warp_se_912);

        let __warp_usrid_55_beforeOrAt = __warp_se_913;

        let (__warp_se_914) = WM0_Observation_2cc4d695___warp_usrid_03_initialized(
            __warp_usrid_55_beforeOrAt
        );

        let (__warp_se_915) = wm_read_felt(__warp_se_914);

        if (1 - __warp_se_915 != 0) {
            let (__warp_se_916) = WS0_IDX(
                __warp_usrid_48_self,
                Uint256(low=0, high=0),
                Uint256(low=4, high=0),
                Uint256(low=65535, high=0),
            );

            let (__warp_se_917) = ws_to_memory0(__warp_se_916);

            let __warp_usrid_55_beforeOrAt = __warp_se_917;

            let (
                __warp_td_148, __warp_td_149
            ) = getSurroundingObservations_68850d1b_if_part1_if_part1(
                __warp_usrid_49_time,
                __warp_usrid_55_beforeOrAt,
                __warp_usrid_50_target,
                __warp_usrid_48_self,
                __warp_usrid_52_index,
                __warp_usrid_54_cardinality,
            );

            let __warp_usrid_55_beforeOrAt = __warp_td_148;

            let __warp_usrid_56_atOrAfter = __warp_td_149;

            return (__warp_usrid_55_beforeOrAt, __warp_usrid_56_atOrAfter);
        } else {
            let (
                __warp_td_150, __warp_td_151
            ) = getSurroundingObservations_68850d1b_if_part1_if_part1(
                __warp_usrid_49_time,
                __warp_usrid_55_beforeOrAt,
                __warp_usrid_50_target,
                __warp_usrid_48_self,
                __warp_usrid_52_index,
                __warp_usrid_54_cardinality,
            );

            let __warp_usrid_55_beforeOrAt = __warp_td_150;

            let __warp_usrid_56_atOrAfter = __warp_td_151;

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

        let (__warp_se_918) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_55_beforeOrAt
        );

        let (__warp_se_919) = wm_read_felt(__warp_se_918);

        let (__warp_se_920) = lte_34209030(
            __warp_usrid_49_time, __warp_se_919, __warp_usrid_50_target
        );

        with_attr error_message("OLD") {
            assert __warp_se_920 = 1;
        }

        let (__warp_td_152, __warp_td_153) = binarySearch_c698fcdd(
            __warp_usrid_48_self,
            __warp_usrid_49_time,
            __warp_usrid_50_target,
            __warp_usrid_52_index,
            __warp_usrid_54_cardinality,
        );

        let __warp_usrid_55_beforeOrAt = __warp_td_152;

        let __warp_usrid_56_atOrAfter = __warp_td_153;

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

        let (__warp_se_921) = warp_eq(__warp_usrid_59_secondsAgo, 0);

        if (__warp_se_921 != 0) {
            let (__warp_se_922) = warp_uint256(__warp_usrid_61_index);

            let (__warp_se_923) = WS0_IDX(
                __warp_usrid_57_self,
                __warp_se_922,
                Uint256(low=4, high=0),
                Uint256(low=65535, high=0),
            );

            let (__warp_usrid_66_last) = ws_to_memory0(__warp_se_923);

            let (__warp_se_924) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                __warp_usrid_66_last
            );

            let (__warp_se_925) = wm_read_felt(__warp_se_924);

            let (__warp_se_926) = warp_neq(__warp_se_925, __warp_usrid_58_time);

            if (__warp_se_926 != 0) {
                let (__warp_se_927) = transform_44108314(
                    __warp_usrid_66_last,
                    __warp_usrid_58_time,
                    __warp_usrid_60_tick,
                    __warp_usrid_62_liquidity,
                );

                let __warp_usrid_66_last = __warp_se_927;

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

        let (__warp_se_928) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(
            __warp_usrid_66_last
        );

        let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_928);

        let (
            __warp_se_929
        ) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
            __warp_usrid_66_last
        );

        let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(__warp_se_929);

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

        let (__warp_td_154, __warp_td_155) = getSurroundingObservations_68850d1b(
            __warp_usrid_57_self,
            __warp_usrid_58_time,
            __warp_usrid_67_target,
            __warp_usrid_60_tick,
            __warp_usrid_61_index,
            __warp_usrid_62_liquidity,
            __warp_usrid_63_cardinality,
        );

        let __warp_usrid_68_beforeOrAt = __warp_td_154;

        let __warp_usrid_69_atOrAfter = __warp_td_155;

        let (__warp_se_930) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
            __warp_usrid_68_beforeOrAt
        );

        let (__warp_se_931) = wm_read_felt(__warp_se_930);

        let (__warp_se_932) = warp_eq(__warp_usrid_67_target, __warp_se_931);

        if (__warp_se_932 != 0) {
            let (__warp_se_933) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(
                __warp_usrid_68_beforeOrAt
            );

            let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_933);

            let (
                __warp_se_934
            ) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
                __warp_usrid_68_beforeOrAt
            );

            let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(__warp_se_934);

            return (
                __warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128
            );
        } else {
            let (__warp_se_935) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                __warp_usrid_69_atOrAfter
            );

            let (__warp_se_936) = wm_read_felt(__warp_se_935);

            let (__warp_se_937) = warp_eq(__warp_usrid_67_target, __warp_se_936);

            if (__warp_se_937 != 0) {
                let (__warp_se_938) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(
                    __warp_usrid_69_atOrAfter
                );

                let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_938);

                let (
                    __warp_se_939
                ) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
                    __warp_usrid_69_atOrAfter
                );

                let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(
                    __warp_se_939
                );

                return (
                    __warp_usrid_64_tickCumulative,
                    __warp_usrid_65_secondsPerLiquidityCumulativeX128,
                );
            } else {
                let (__warp_se_940) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                    __warp_usrid_69_atOrAfter
                );

                let (__warp_se_941) = wm_read_felt(__warp_se_940);

                let (__warp_se_942) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_943) = wm_read_felt(__warp_se_942);

                let (__warp_usrid_70_observationTimeDelta) = warp_sub_unsafe32(
                    __warp_se_941, __warp_se_943
                );

                let (__warp_se_944) = WM1_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_945) = wm_read_felt(__warp_se_944);

                let (__warp_usrid_71_targetDelta) = warp_sub_unsafe32(
                    __warp_usrid_67_target, __warp_se_945
                );

                let (__warp_se_946) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_947) = wm_read_felt(__warp_se_946);

                let (__warp_se_948) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(
                    __warp_usrid_69_atOrAfter
                );

                let (__warp_se_949) = wm_read_felt(__warp_se_948);

                let (__warp_se_950) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_951) = wm_read_felt(__warp_se_950);

                let (__warp_se_952) = warp_sub_signed_unsafe56(__warp_se_949, __warp_se_951);

                let (__warp_se_953) = warp_int32_to_int56(__warp_usrid_70_observationTimeDelta);

                let (__warp_se_954) = warp_div_signed_unsafe56(__warp_se_952, __warp_se_953);

                let (__warp_se_955) = warp_int32_to_int56(__warp_usrid_71_targetDelta);

                let (__warp_se_956) = warp_mul_signed_unsafe56(__warp_se_954, __warp_se_955);

                let (__warp_usrid_64_tickCumulative) = warp_add_signed_unsafe56(
                    __warp_se_947, __warp_se_956
                );

                let (
                    __warp_se_957
                ) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_958) = wm_read_felt(__warp_se_957);

                let (
                    __warp_se_959
                ) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
                    __warp_usrid_69_atOrAfter
                );

                let (__warp_se_960) = wm_read_felt(__warp_se_959);

                let (
                    __warp_se_961
                ) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
                    __warp_usrid_68_beforeOrAt
                );

                let (__warp_se_962) = wm_read_felt(__warp_se_961);

                let (__warp_se_963) = warp_sub_unsafe160(__warp_se_960, __warp_se_962);

                let (__warp_se_964) = warp_uint256(__warp_se_963);

                let (__warp_se_965) = warp_uint256(__warp_usrid_71_targetDelta);

                let (__warp_se_966) = warp_mul_unsafe256(__warp_se_964, __warp_se_965);

                let (__warp_se_967) = warp_uint256(__warp_usrid_70_observationTimeDelta);

                let (__warp_se_968) = warp_div_unsafe256(__warp_se_966, __warp_se_967);

                let (__warp_se_969) = warp_int256_to_int160(__warp_se_968);

                let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = warp_add_unsafe160(
                    __warp_se_958, __warp_se_969
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

        let (__warp_se_970) = warp_gt(__warp_usrid_78_cardinality, 0);

        with_attr error_message("I") {
            assert __warp_se_970 = 1;
        }

        let (__warp_se_971) = wm_dyn_array_length(__warp_usrid_74_secondsAgos);

        let (__warp_se_972) = wm_new(__warp_se_971, Uint256(low=1, high=0));

        let __warp_usrid_79_tickCumulatives = __warp_se_972;

        let (__warp_se_973) = wm_dyn_array_length(__warp_usrid_74_secondsAgos);

        let (__warp_se_974) = wm_new(__warp_se_973, Uint256(low=1, high=0));

        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_se_974;

        let __warp_usrid_81_i = Uint256(low=0, high=0);

        let (
            __warp_tv_73,
            __warp_td_156,
            __warp_td_157,
            __warp_td_158,
            __warp_td_159,
            __warp_tv_78,
            __warp_tv_79,
            __warp_tv_80,
            __warp_tv_81,
            __warp_tv_82,
        ) = __warp_while10(
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

        let __warp_tv_74 = __warp_td_156;

        let __warp_tv_75 = __warp_td_157;

        let __warp_tv_76 = __warp_td_158;

        let __warp_tv_77 = __warp_td_159;

        let __warp_usrid_78_cardinality = __warp_tv_82;

        let __warp_usrid_77_liquidity = __warp_tv_81;

        let __warp_usrid_76_index = __warp_tv_80;

        let __warp_usrid_75_tick = __warp_tv_79;

        let __warp_usrid_73_time = __warp_tv_78;

        let __warp_usrid_72_self = __warp_tv_77;

        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_tv_76;

        let __warp_usrid_79_tickCumulatives = __warp_tv_75;

        let __warp_usrid_74_secondsAgos = __warp_tv_74;

        let __warp_usrid_81_i = __warp_tv_73;

        let __warp_usrid_79_tickCumulatives = __warp_usrid_79_tickCumulatives;

        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_usrid_80_secondsPerLiquidityCumulativeX128s;

        return (
            __warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s
        );
    }

    // @notice Calculates sqrt(1.0001^tick) * 2^96
    // @dev Throws if |tick| > max tick
    // @param tick The input tick for the above formula
    // @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
    // at the given tick
    func getSqrtRatioAtTick_986cfba3{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_04_tick: felt
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let __warp_usrid_05_sqrtPriceX96 = 0;

        let __warp_usrid_06_absTick = Uint256(low=0, high=0);

        let (__warp_se_975) = warp_lt_signed24(__warp_usrid_04_tick, 0);

        if (__warp_se_975 != 0) {
            let (__warp_se_976) = warp_int24_to_int256(__warp_usrid_04_tick);

            let (__warp_se_977) = warp_negate256(__warp_se_976);

            let __warp_usrid_06_absTick = __warp_se_977;

            let (__warp_se_978) = getSqrtRatioAtTick_986cfba3_if_part1(
                __warp_usrid_06_absTick, __warp_usrid_04_tick, __warp_usrid_05_sqrtPriceX96
            );

            return (__warp_se_978,);
        } else {
            let (__warp_se_979) = warp_int24_to_int256(__warp_usrid_04_tick);

            let __warp_usrid_06_absTick = __warp_se_979;

            let (__warp_se_980) = getSqrtRatioAtTick_986cfba3_if_part1(
                __warp_usrid_06_absTick, __warp_usrid_04_tick, __warp_usrid_05_sqrtPriceX96
            );

            return (__warp_se_980,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_981) = warp_uint256(887272);

        let (__warp_se_982) = warp_le256(__warp_usrid_06_absTick, __warp_se_981);

        with_attr error_message("T") {
            assert __warp_se_982 = 1;
        }

        let __warp_usrid_07_ratio = Uint256(low=0, high=1);

        let (__warp_se_983) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=1, high=0));

        let (__warp_se_984) = warp_neq256(__warp_se_983, Uint256(low=0, high=0));

        if (__warp_se_984 != 0) {
            let __warp_usrid_07_ratio = Uint256(
                low=340265354078544963557816517032075149313, high=0
            );

            let (__warp_se_985) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_985,);
        } else {
            let (__warp_se_986) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_986,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_987) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=2, high=0));

        let (__warp_se_988) = warp_neq256(__warp_se_987, Uint256(low=0, high=0));

        if (__warp_se_988 != 0) {
            let (__warp_se_989) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=340248342086729790484326174814286782778, high=0)
            );

            let (__warp_se_990) = warp_shr256(__warp_se_989, 128);

            let __warp_usrid_07_ratio = __warp_se_990;

            let (__warp_se_991) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_991,);
        } else {
            let (__warp_se_992) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_992,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_993) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=4, high=0));

        let (__warp_se_994) = warp_neq256(__warp_se_993, Uint256(low=0, high=0));

        if (__warp_se_994 != 0) {
            let (__warp_se_995) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=340214320654664324051920982716015181260, high=0)
            );

            let (__warp_se_996) = warp_shr256(__warp_se_995, 128);

            let __warp_usrid_07_ratio = __warp_se_996;

            let (__warp_se_997) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_997,);
        } else {
            let (__warp_se_998) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_998,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_999) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=8, high=0));

        let (__warp_se_1000) = warp_neq256(__warp_se_999, Uint256(low=0, high=0));

        if (__warp_se_1000 != 0) {
            let (__warp_se_1001) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=340146287995602323631171512101879684304, high=0)
            );

            let (__warp_se_1002) = warp_shr256(__warp_se_1001, 128);

            let __warp_usrid_07_ratio = __warp_se_1002;

            let (
                __warp_se_1003
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1003,);
        } else {
            let (
                __warp_se_1004
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1004,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1005) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=16, high=0)
        );

        let (__warp_se_1006) = warp_neq256(__warp_se_1005, Uint256(low=0, high=0));

        if (__warp_se_1006 != 0) {
            let (__warp_se_1007) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=340010263488231146823593991679159461444, high=0)
            );

            let (__warp_se_1008) = warp_shr256(__warp_se_1007, 128);

            let __warp_usrid_07_ratio = __warp_se_1008;

            let (
                __warp_se_1009
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1009,);
        } else {
            let (
                __warp_se_1010
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1010,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1011) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=32, high=0)
        );

        let (__warp_se_1012) = warp_neq256(__warp_se_1011, Uint256(low=0, high=0));

        if (__warp_se_1012 != 0) {
            let (__warp_se_1013) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=339738377640345403697157401104375502016, high=0)
            );

            let (__warp_se_1014) = warp_shr256(__warp_se_1013, 128);

            let __warp_usrid_07_ratio = __warp_se_1014;

            let (
                __warp_se_1015
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1015,);
        } else {
            let (
                __warp_se_1016
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1016,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1017) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=64, high=0)
        );

        let (__warp_se_1018) = warp_neq256(__warp_se_1017, Uint256(low=0, high=0));

        if (__warp_se_1018 != 0) {
            let (__warp_se_1019) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=339195258003219555707034227454543997025, high=0)
            );

            let (__warp_se_1020) = warp_shr256(__warp_se_1019, 128);

            let __warp_usrid_07_ratio = __warp_se_1020;

            let (
                __warp_se_1021
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1021,);
        } else {
            let (
                __warp_se_1022
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1022,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1023) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=128, high=0)
        );

        let (__warp_se_1024) = warp_neq256(__warp_se_1023, Uint256(low=0, high=0));

        if (__warp_se_1024 != 0) {
            let (__warp_se_1025) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=338111622100601834656805679988414885971, high=0)
            );

            let (__warp_se_1026) = warp_shr256(__warp_se_1025, 128);

            let __warp_usrid_07_ratio = __warp_se_1026;

            let (
                __warp_se_1027
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1027,);
        } else {
            let (
                __warp_se_1028
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1028,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1029) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=256, high=0)
        );

        let (__warp_se_1030) = warp_neq256(__warp_se_1029, Uint256(low=0, high=0));

        if (__warp_se_1030 != 0) {
            let (__warp_se_1031) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=335954724994790223023589805789778977700, high=0)
            );

            let (__warp_se_1032) = warp_shr256(__warp_se_1031, 128);

            let __warp_usrid_07_ratio = __warp_se_1032;

            let (
                __warp_se_1033
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1033,);
        } else {
            let (
                __warp_se_1034
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1034,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1035) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=512, high=0)
        );

        let (__warp_se_1036) = warp_neq256(__warp_se_1035, Uint256(low=0, high=0));

        if (__warp_se_1036 != 0) {
            let (__warp_se_1037) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=331682121138379247127172139078559817300, high=0)
            );

            let (__warp_se_1038) = warp_shr256(__warp_se_1037, 128);

            let __warp_usrid_07_ratio = __warp_se_1038;

            let (
                __warp_se_1039
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1039,);
        } else {
            let (
                __warp_se_1040
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1040,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1041) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=1024, high=0)
        );

        let (__warp_se_1042) = warp_neq256(__warp_se_1041, Uint256(low=0, high=0));

        if (__warp_se_1042 != 0) {
            let (__warp_se_1043) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=323299236684853023288211250268160618739, high=0)
            );

            let (__warp_se_1044) = warp_shr256(__warp_se_1043, 128);

            let __warp_usrid_07_ratio = __warp_se_1044;

            let (
                __warp_se_1045
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1045,);
        } else {
            let (
                __warp_se_1046
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1046,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1047) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=2048, high=0)
        );

        let (__warp_se_1048) = warp_neq256(__warp_se_1047, Uint256(low=0, high=0));

        if (__warp_se_1048 != 0) {
            let (__warp_se_1049) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=307163716377032989948697243942600083929, high=0)
            );

            let (__warp_se_1050) = warp_shr256(__warp_se_1049, 128);

            let __warp_usrid_07_ratio = __warp_se_1050;

            let (
                __warp_se_1051
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1051,);
        } else {
            let (
                __warp_se_1052
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1052,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1053) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=4096, high=0)
        );

        let (__warp_se_1054) = warp_neq256(__warp_se_1053, Uint256(low=0, high=0));

        if (__warp_se_1054 != 0) {
            let (__warp_se_1055) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=277268403626896220162999269216087595045, high=0)
            );

            let (__warp_se_1056) = warp_shr256(__warp_se_1055, 128);

            let __warp_usrid_07_ratio = __warp_se_1056;

            let (
                __warp_se_1057
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1057,);
        } else {
            let (
                __warp_se_1058
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1058,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1059) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=8192, high=0)
        );

        let (__warp_se_1060) = warp_neq256(__warp_se_1059, Uint256(low=0, high=0));

        if (__warp_se_1060 != 0) {
            let (__warp_se_1061) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=225923453940442621947126027127485391333, high=0)
            );

            let (__warp_se_1062) = warp_shr256(__warp_se_1061, 128);

            let __warp_usrid_07_ratio = __warp_se_1062;

            let (
                __warp_se_1063
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1063,);
        } else {
            let (
                __warp_se_1064
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1064,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1065) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=16384, high=0)
        );

        let (__warp_se_1066) = warp_neq256(__warp_se_1065, Uint256(low=0, high=0));

        if (__warp_se_1066 != 0) {
            let (__warp_se_1067) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=149997214084966997727330242082538205943, high=0)
            );

            let (__warp_se_1068) = warp_shr256(__warp_se_1067, 128);

            let __warp_usrid_07_ratio = __warp_se_1068;

            let (
                __warp_se_1069
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1069,);
        } else {
            let (
                __warp_se_1070
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1070,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1071) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=32768, high=0)
        );

        let (__warp_se_1072) = warp_neq256(__warp_se_1071, Uint256(low=0, high=0));

        if (__warp_se_1072 != 0) {
            let (__warp_se_1073) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=66119101136024775622716233608466517926, high=0)
            );

            let (__warp_se_1074) = warp_shr256(__warp_se_1073, 128);

            let __warp_usrid_07_ratio = __warp_se_1074;

            let (
                __warp_se_1075
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1075,);
        } else {
            let (
                __warp_se_1076
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1076,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1077) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=65536, high=0)
        );

        let (__warp_se_1078) = warp_neq256(__warp_se_1077, Uint256(low=0, high=0));

        if (__warp_se_1078 != 0) {
            let (__warp_se_1079) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=12847376061809297530290974190478138313, high=0)
            );

            let (__warp_se_1080) = warp_shr256(__warp_se_1079, 128);

            let __warp_usrid_07_ratio = __warp_se_1080;

            let (
                __warp_se_1081
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1081,);
        } else {
            let (
                __warp_se_1082
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1082,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1083) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=131072, high=0)
        );

        let (__warp_se_1084) = warp_neq256(__warp_se_1083, Uint256(low=0, high=0));

        if (__warp_se_1084 != 0) {
            let (__warp_se_1085) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=485053260817066172746253684029974020, high=0)
            );

            let (__warp_se_1086) = warp_shr256(__warp_se_1085, 128);

            let __warp_usrid_07_ratio = __warp_se_1086;

            let (
                __warp_se_1087
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1087,);
        } else {
            let (
                __warp_se_1088
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1088,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1089) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=262144, high=0)
        );

        let (__warp_se_1090) = warp_neq256(__warp_se_1089, Uint256(low=0, high=0));

        if (__warp_se_1090 != 0) {
            let (__warp_se_1091) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=691415978906521570653435304214168, high=0)
            );

            let (__warp_se_1092) = warp_shr256(__warp_se_1091, 128);

            let __warp_usrid_07_ratio = __warp_se_1092;

            let (
                __warp_se_1093
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1093,);
        } else {
            let (
                __warp_se_1094
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_06_absTick,
                __warp_usrid_07_ratio,
                __warp_usrid_04_tick,
                __warp_usrid_05_sqrtPriceX96,
            );

            return (__warp_se_1094,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_06_absTick: Uint256,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_04_tick: felt,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1095) = warp_bitwise_and256(
            __warp_usrid_06_absTick, Uint256(low=524288, high=0)
        );

        let (__warp_se_1096) = warp_neq256(__warp_se_1095, Uint256(low=0, high=0));

        if (__warp_se_1096 != 0) {
            let (__warp_se_1097) = warp_mul_unsafe256(
                __warp_usrid_07_ratio, Uint256(low=1404880482679654955896180642, high=0)
            );

            let (__warp_se_1098) = warp_shr256(__warp_se_1097, 128);

            let __warp_usrid_07_ratio = __warp_se_1098;

            let (
                __warp_se_1099
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_tick, __warp_usrid_07_ratio, __warp_usrid_05_sqrtPriceX96
            );

            return (__warp_se_1099,);
        } else {
            let (
                __warp_se_1100
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_04_tick, __warp_usrid_07_ratio, __warp_usrid_05_sqrtPriceX96
            );

            return (__warp_se_1100,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_04_tick: felt,
        __warp_usrid_07_ratio: Uint256,
        __warp_usrid_05_sqrtPriceX96: felt,
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        let (__warp_se_1101) = warp_gt_signed24(__warp_usrid_04_tick, 0);

        if (__warp_se_1101 != 0) {
            let (__warp_se_1102) = warp_div_unsafe256(
                Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
                __warp_usrid_07_ratio,
            );

            let __warp_usrid_07_ratio = __warp_se_1102;

            let (
                __warp_se_1103
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_07_ratio, __warp_usrid_05_sqrtPriceX96
            );

            return (__warp_se_1103,);
        } else {
            let (
                __warp_se_1104
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_07_ratio, __warp_usrid_05_sqrtPriceX96
            );

            return (__warp_se_1104,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_07_ratio: Uint256, __warp_usrid_05_sqrtPriceX96: felt) -> (
        __warp_usrid_05_sqrtPriceX96: felt
    ) {
        alloc_locals;

        let (__warp_se_1105) = warp_mod256(__warp_usrid_07_ratio, Uint256(low=4294967296, high=0));

        let (__warp_se_1106) = warp_eq256(__warp_se_1105, Uint256(low=0, high=0));

        if (__warp_se_1106 != 0) {
            let (__warp_se_1107) = warp_shr256(__warp_usrid_07_ratio, 32);

            let (__warp_se_1108) = warp_int256_to_int160(__warp_se_1107);

            let __warp_usrid_05_sqrtPriceX96 = __warp_se_1108;

            let (
                __warp_se_1109
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_05_sqrtPriceX96
            );

            return (__warp_se_1109,);
        } else {
            let (__warp_se_1110) = warp_shr256(__warp_usrid_07_ratio, 32);

            let (__warp_se_1111) = warp_add_unsafe256(__warp_se_1110, Uint256(low=1, high=0));

            let (__warp_se_1112) = warp_int256_to_int160(__warp_se_1111);

            let __warp_usrid_05_sqrtPriceX96 = __warp_se_1112;

            let (
                __warp_se_1113
            ) = getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_05_sqrtPriceX96
            );

            return (__warp_se_1113,);
        }
    }

    func getSqrtRatioAtTick_986cfba3_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
        __warp_usrid_05_sqrtPriceX96: felt
    ) -> (__warp_usrid_05_sqrtPriceX96: felt) {
        alloc_locals;

        return (__warp_usrid_05_sqrtPriceX96,);
    }

    // @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
    // @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
    // ever return.
    // @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
    // @return tick The greatest tick for which the ratio is less than or equal to the input ratio
    func getTickAtSqrtRatio_4f76c058{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_08_sqrtPriceX96: felt
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let __warp_usrid_09_tick = 0;

        let (__warp_se_1114) = warp_ge(__warp_usrid_08_sqrtPriceX96, 4295128739);

        let (__warp_se_1115) = warp_lt(
            __warp_usrid_08_sqrtPriceX96, 1461446703485210103287273052203988822378723970342
        );

        let (__warp_se_1116) = warp_and_(__warp_se_1114, __warp_se_1115);

        with_attr error_message("R") {
            assert __warp_se_1116 = 1;
        }

        let (__warp_se_1117) = warp_uint256(__warp_usrid_08_sqrtPriceX96);

        let (__warp_usrid_10_ratio) = warp_shl256(__warp_se_1117, 32);

        let __warp_usrid_11_r = __warp_usrid_10_ratio;

        let __warp_usrid_12_msb = Uint256(low=0, high=0);

        let __warp_usrid_13_f = Uint256(low=0, high=0);

        let __warp_usrid_13_f = Uint256(low=0, high=0);

        let (__warp_se_1118) = warp_gt256(
            __warp_usrid_11_r, Uint256(low=340282366920938463463374607431768211455, high=0)
        );

        if (__warp_se_1118 != 0) {
            let __warp_usrid_13_f = Uint256(low=128, high=0);

            let (__warp_se_1119) = getTickAtSqrtRatio_4f76c058_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1119,);
        } else {
            let (__warp_se_1120) = getTickAtSqrtRatio_4f76c058_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1120,);
        }
    }

    func getTickAtSqrtRatio_4f76c058_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_12_msb: Uint256,
        __warp_usrid_13_f: Uint256,
        __warp_usrid_11_r: Uint256,
        __warp_usrid_10_ratio: Uint256,
        __warp_usrid_09_tick: felt,
        __warp_usrid_08_sqrtPriceX96: felt,
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let (__warp_se_1121) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);

        let __warp_usrid_12_msb = __warp_se_1121;

        let (__warp_se_1122) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1122;

        let __warp_usrid_13_f = Uint256(low=0, high=0);

        let (__warp_se_1123) = warp_gt256(
            __warp_usrid_11_r, Uint256(low=18446744073709551615, high=0)
        );

        if (__warp_se_1123 != 0) {
            let __warp_usrid_13_f = Uint256(low=64, high=0);

            let (__warp_se_1124) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1124,);
        } else {
            let (__warp_se_1125) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1125,);
        }
    }

    func getTickAtSqrtRatio_4f76c058_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_msb: Uint256,
        __warp_usrid_13_f: Uint256,
        __warp_usrid_11_r: Uint256,
        __warp_usrid_10_ratio: Uint256,
        __warp_usrid_09_tick: felt,
        __warp_usrid_08_sqrtPriceX96: felt,
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let (__warp_se_1126) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);

        let __warp_usrid_12_msb = __warp_se_1126;

        let (__warp_se_1127) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1127;

        let __warp_usrid_13_f = Uint256(low=0, high=0);

        let (__warp_se_1128) = warp_gt256(__warp_usrid_11_r, Uint256(low=4294967295, high=0));

        if (__warp_se_1128 != 0) {
            let __warp_usrid_13_f = Uint256(low=32, high=0);

            let (__warp_se_1129) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1129,);
        } else {
            let (__warp_se_1130) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1130,);
        }
    }

    func getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_msb: Uint256,
        __warp_usrid_13_f: Uint256,
        __warp_usrid_11_r: Uint256,
        __warp_usrid_10_ratio: Uint256,
        __warp_usrid_09_tick: felt,
        __warp_usrid_08_sqrtPriceX96: felt,
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let (__warp_se_1131) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);

        let __warp_usrid_12_msb = __warp_se_1131;

        let (__warp_se_1132) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1132;

        let __warp_usrid_13_f = Uint256(low=0, high=0);

        let (__warp_se_1133) = warp_gt256(__warp_usrid_11_r, Uint256(low=65535, high=0));

        if (__warp_se_1133 != 0) {
            let __warp_usrid_13_f = Uint256(low=16, high=0);

            let (__warp_se_1134) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1134,);
        } else {
            let (__warp_se_1135) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1135,);
        }
    }

    func getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_msb: Uint256,
        __warp_usrid_13_f: Uint256,
        __warp_usrid_11_r: Uint256,
        __warp_usrid_10_ratio: Uint256,
        __warp_usrid_09_tick: felt,
        __warp_usrid_08_sqrtPriceX96: felt,
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let (__warp_se_1136) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);

        let __warp_usrid_12_msb = __warp_se_1136;

        let (__warp_se_1137) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1137;

        let __warp_usrid_13_f = Uint256(low=0, high=0);

        let (__warp_se_1138) = warp_gt256(__warp_usrid_11_r, Uint256(low=255, high=0));

        if (__warp_se_1138 != 0) {
            let __warp_usrid_13_f = Uint256(low=8, high=0);

            let (
                __warp_se_1139
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1139,);
        } else {
            let (
                __warp_se_1140
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1140,);
        }
    }

    func getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_msb: Uint256,
        __warp_usrid_13_f: Uint256,
        __warp_usrid_11_r: Uint256,
        __warp_usrid_10_ratio: Uint256,
        __warp_usrid_09_tick: felt,
        __warp_usrid_08_sqrtPriceX96: felt,
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let (__warp_se_1141) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);

        let __warp_usrid_12_msb = __warp_se_1141;

        let (__warp_se_1142) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1142;

        let __warp_usrid_13_f = Uint256(low=0, high=0);

        let (__warp_se_1143) = warp_gt256(__warp_usrid_11_r, Uint256(low=15, high=0));

        if (__warp_se_1143 != 0) {
            let __warp_usrid_13_f = Uint256(low=4, high=0);

            let (
                __warp_se_1144
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1144,);
        } else {
            let (
                __warp_se_1145
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1145,);
        }
    }

    func getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_msb: Uint256,
        __warp_usrid_13_f: Uint256,
        __warp_usrid_11_r: Uint256,
        __warp_usrid_10_ratio: Uint256,
        __warp_usrid_09_tick: felt,
        __warp_usrid_08_sqrtPriceX96: felt,
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let (__warp_se_1146) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);

        let __warp_usrid_12_msb = __warp_se_1146;

        let (__warp_se_1147) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1147;

        let __warp_usrid_13_f = Uint256(low=0, high=0);

        let (__warp_se_1148) = warp_gt256(__warp_usrid_11_r, Uint256(low=3, high=0));

        if (__warp_se_1148 != 0) {
            let __warp_usrid_13_f = Uint256(low=2, high=0);

            let (
                __warp_se_1149
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1149,);
        } else {
            let (
                __warp_se_1150
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1150,);
        }
    }

    func getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_msb: Uint256,
        __warp_usrid_13_f: Uint256,
        __warp_usrid_11_r: Uint256,
        __warp_usrid_10_ratio: Uint256,
        __warp_usrid_09_tick: felt,
        __warp_usrid_08_sqrtPriceX96: felt,
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let (__warp_se_1151) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);

        let __warp_usrid_12_msb = __warp_se_1151;

        let (__warp_se_1152) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1152;

        let __warp_usrid_13_f = Uint256(low=0, high=0);

        let (__warp_se_1153) = warp_gt256(__warp_usrid_11_r, Uint256(low=1, high=0));

        if (__warp_se_1153 != 0) {
            let __warp_usrid_13_f = Uint256(low=1, high=0);

            let (
                __warp_se_1154
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1154,);
        } else {
            let (
                __warp_se_1155
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_13_f,
                __warp_usrid_11_r,
                __warp_usrid_10_ratio,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1155,);
        }
    }

    func getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_msb: Uint256,
        __warp_usrid_13_f: Uint256,
        __warp_usrid_11_r: Uint256,
        __warp_usrid_10_ratio: Uint256,
        __warp_usrid_09_tick: felt,
        __warp_usrid_08_sqrtPriceX96: felt,
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let (__warp_se_1156) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);

        let __warp_usrid_12_msb = __warp_se_1156;

        let (__warp_se_1157) = warp_ge256(__warp_usrid_12_msb, Uint256(low=128, high=0));

        if (__warp_se_1157 != 0) {
            let (__warp_se_1158) = warp_sub_unsafe256(
                __warp_usrid_12_msb, Uint256(low=127, high=0)
            );

            let (__warp_se_1159) = warp_shr256_256(__warp_usrid_10_ratio, __warp_se_1158);

            let __warp_usrid_11_r = __warp_se_1159;

            let (
                __warp_se_1160
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_11_r,
                __warp_usrid_13_f,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1160,);
        } else {
            let (__warp_se_1161) = warp_sub_unsafe256(
                Uint256(low=127, high=0), __warp_usrid_12_msb
            );

            let (__warp_se_1162) = warp_shl256_256(__warp_usrid_10_ratio, __warp_se_1161);

            let __warp_usrid_11_r = __warp_se_1162;

            let (
                __warp_se_1163
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_12_msb,
                __warp_usrid_11_r,
                __warp_usrid_13_f,
                __warp_usrid_09_tick,
                __warp_usrid_08_sqrtPriceX96,
            );

            return (__warp_se_1163,);
        }
    }

    func getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_msb: Uint256,
        __warp_usrid_11_r: Uint256,
        __warp_usrid_13_f: Uint256,
        __warp_usrid_09_tick: felt,
        __warp_usrid_08_sqrtPriceX96: felt,
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let (__warp_se_1164) = warp_sub_signed_unsafe256(
            __warp_usrid_12_msb, Uint256(low=128, high=0)
        );

        let (__warp_usrid_14_log_2) = warp_shl256(__warp_se_1164, 64);

        let (__warp_se_1165) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1166) = warp_shr256(__warp_se_1165, 127);

        let __warp_usrid_11_r = __warp_se_1166;

        let (__warp_se_1167) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1167;

        let (__warp_se_1168) = warp_shl256(__warp_usrid_13_f, 63);

        let (__warp_se_1169) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1168);

        let __warp_usrid_14_log_2 = __warp_se_1169;

        let (__warp_se_1170) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1170;

        let (__warp_se_1171) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1172) = warp_shr256(__warp_se_1171, 127);

        let __warp_usrid_11_r = __warp_se_1172;

        let (__warp_se_1173) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1173;

        let (__warp_se_1174) = warp_shl256(__warp_usrid_13_f, 62);

        let (__warp_se_1175) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1174);

        let __warp_usrid_14_log_2 = __warp_se_1175;

        let (__warp_se_1176) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1176;

        let (__warp_se_1177) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1178) = warp_shr256(__warp_se_1177, 127);

        let __warp_usrid_11_r = __warp_se_1178;

        let (__warp_se_1179) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1179;

        let (__warp_se_1180) = warp_shl256(__warp_usrid_13_f, 61);

        let (__warp_se_1181) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1180);

        let __warp_usrid_14_log_2 = __warp_se_1181;

        let (__warp_se_1182) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1182;

        let (__warp_se_1183) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1184) = warp_shr256(__warp_se_1183, 127);

        let __warp_usrid_11_r = __warp_se_1184;

        let (__warp_se_1185) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1185;

        let (__warp_se_1186) = warp_shl256(__warp_usrid_13_f, 60);

        let (__warp_se_1187) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1186);

        let __warp_usrid_14_log_2 = __warp_se_1187;

        let (__warp_se_1188) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1188;

        let (__warp_se_1189) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1190) = warp_shr256(__warp_se_1189, 127);

        let __warp_usrid_11_r = __warp_se_1190;

        let (__warp_se_1191) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1191;

        let (__warp_se_1192) = warp_shl256(__warp_usrid_13_f, 59);

        let (__warp_se_1193) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1192);

        let __warp_usrid_14_log_2 = __warp_se_1193;

        let (__warp_se_1194) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1194;

        let (__warp_se_1195) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1196) = warp_shr256(__warp_se_1195, 127);

        let __warp_usrid_11_r = __warp_se_1196;

        let (__warp_se_1197) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1197;

        let (__warp_se_1198) = warp_shl256(__warp_usrid_13_f, 58);

        let (__warp_se_1199) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1198);

        let __warp_usrid_14_log_2 = __warp_se_1199;

        let (__warp_se_1200) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1200;

        let (__warp_se_1201) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1202) = warp_shr256(__warp_se_1201, 127);

        let __warp_usrid_11_r = __warp_se_1202;

        let (__warp_se_1203) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1203;

        let (__warp_se_1204) = warp_shl256(__warp_usrid_13_f, 57);

        let (__warp_se_1205) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1204);

        let __warp_usrid_14_log_2 = __warp_se_1205;

        let (__warp_se_1206) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1206;

        let (__warp_se_1207) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1208) = warp_shr256(__warp_se_1207, 127);

        let __warp_usrid_11_r = __warp_se_1208;

        let (__warp_se_1209) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1209;

        let (__warp_se_1210) = warp_shl256(__warp_usrid_13_f, 56);

        let (__warp_se_1211) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1210);

        let __warp_usrid_14_log_2 = __warp_se_1211;

        let (__warp_se_1212) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1212;

        let (__warp_se_1213) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1214) = warp_shr256(__warp_se_1213, 127);

        let __warp_usrid_11_r = __warp_se_1214;

        let (__warp_se_1215) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1215;

        let (__warp_se_1216) = warp_shl256(__warp_usrid_13_f, 55);

        let (__warp_se_1217) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1216);

        let __warp_usrid_14_log_2 = __warp_se_1217;

        let (__warp_se_1218) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1218;

        let (__warp_se_1219) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1220) = warp_shr256(__warp_se_1219, 127);

        let __warp_usrid_11_r = __warp_se_1220;

        let (__warp_se_1221) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1221;

        let (__warp_se_1222) = warp_shl256(__warp_usrid_13_f, 54);

        let (__warp_se_1223) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1222);

        let __warp_usrid_14_log_2 = __warp_se_1223;

        let (__warp_se_1224) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1224;

        let (__warp_se_1225) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1226) = warp_shr256(__warp_se_1225, 127);

        let __warp_usrid_11_r = __warp_se_1226;

        let (__warp_se_1227) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1227;

        let (__warp_se_1228) = warp_shl256(__warp_usrid_13_f, 53);

        let (__warp_se_1229) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1228);

        let __warp_usrid_14_log_2 = __warp_se_1229;

        let (__warp_se_1230) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1230;

        let (__warp_se_1231) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1232) = warp_shr256(__warp_se_1231, 127);

        let __warp_usrid_11_r = __warp_se_1232;

        let (__warp_se_1233) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1233;

        let (__warp_se_1234) = warp_shl256(__warp_usrid_13_f, 52);

        let (__warp_se_1235) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1234);

        let __warp_usrid_14_log_2 = __warp_se_1235;

        let (__warp_se_1236) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1236;

        let (__warp_se_1237) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1238) = warp_shr256(__warp_se_1237, 127);

        let __warp_usrid_11_r = __warp_se_1238;

        let (__warp_se_1239) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1239;

        let (__warp_se_1240) = warp_shl256(__warp_usrid_13_f, 51);

        let (__warp_se_1241) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1240);

        let __warp_usrid_14_log_2 = __warp_se_1241;

        let (__warp_se_1242) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1242;

        let (__warp_se_1243) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);

        let (__warp_se_1244) = warp_shr256(__warp_se_1243, 127);

        let __warp_usrid_11_r = __warp_se_1244;

        let (__warp_se_1245) = warp_shr256(__warp_usrid_11_r, 128);

        let __warp_usrid_13_f = __warp_se_1245;

        let (__warp_se_1246) = warp_shl256(__warp_usrid_13_f, 50);

        let (__warp_se_1247) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1246);

        let __warp_usrid_14_log_2 = __warp_se_1247;

        let (__warp_se_1248) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);

        let __warp_usrid_11_r = __warp_se_1248;

        let (__warp_usrid_15_log_sqrt10001) = warp_mul_signed_unsafe256(
            __warp_usrid_14_log_2, Uint256(low=255738958999603826347141, high=0)
        );

        let (__warp_se_1249) = warp_sub_signed_unsafe256(
            __warp_usrid_15_log_sqrt10001,
            Uint256(low=3402992956809132418596140100660247210, high=0),
        );

        let (__warp_se_1250) = warp_shr_signed256(__warp_se_1249, 128);

        let (__warp_usrid_16_tickLow) = warp_int256_to_int24(__warp_se_1250);

        let (__warp_se_1251) = warp_add_signed_unsafe256(
            __warp_usrid_15_log_sqrt10001,
            Uint256(low=291339464771989622907027621153398088495, high=0),
        );

        let (__warp_se_1252) = warp_shr_signed256(__warp_se_1251, 128);

        let (__warp_usrid_17_tickHi) = warp_int256_to_int24(__warp_se_1252);

        let (__warp_se_1253) = warp_eq(__warp_usrid_16_tickLow, __warp_usrid_17_tickHi);

        if (__warp_se_1253 != 0) {
            let __warp_usrid_09_tick = __warp_usrid_16_tickLow;

            let (
                __warp_se_1254
            ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_09_tick
            );

            return (__warp_se_1254,);
        } else {
            let (__warp_se_1255) = getSqrtRatioAtTick_986cfba3(__warp_usrid_17_tickHi);

            let (__warp_se_1256) = warp_le(__warp_se_1255, __warp_usrid_08_sqrtPriceX96);

            if (__warp_se_1256 != 0) {
                let __warp_usrid_09_tick = __warp_usrid_17_tickHi;

                let (
                    __warp_se_1257
                ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_09_tick
                );

                return (__warp_se_1257,);
            } else {
                let __warp_usrid_09_tick = __warp_usrid_16_tickLow;

                let (
                    __warp_se_1258
                ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2(
                    __warp_usrid_09_tick
                );

                return (__warp_se_1258,);
            }
        }
    }

    func getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part2(
        __warp_usrid_09_tick: felt
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        let (
            __warp_se_1259
        ) = getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
            __warp_usrid_09_tick
        );

        return (__warp_se_1259,);
    }

    func getTickAtSqrtRatio_4f76c058_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
        __warp_usrid_09_tick: felt
    ) -> (__warp_usrid_09_tick: felt) {
        alloc_locals;

        return (__warp_usrid_09_tick,);
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
    func getNextSqrtPriceFromAmount0RoundingUp_157f652f{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_00_sqrtPX96: felt,
        __warp_usrid_01_liquidity: felt,
        __warp_usrid_02_amount: Uint256,
        __warp_usrid_03_add: felt,
    ) -> (__warp_usrid_04_: felt) {
        alloc_locals;

        let (__warp_se_1260) = warp_eq256(__warp_usrid_02_amount, Uint256(low=0, high=0));

        if (__warp_se_1260 != 0) {
            return (__warp_usrid_00_sqrtPX96,);
        } else {
            let (__warp_se_1261) = getNextSqrtPriceFromAmount0RoundingUp_157f652f_if_part1(
                __warp_usrid_01_liquidity,
                __warp_usrid_03_add,
                __warp_usrid_02_amount,
                __warp_usrid_00_sqrtPX96,
            );

            return (__warp_se_1261,);
        }
    }

    func getNextSqrtPriceFromAmount0RoundingUp_157f652f_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_01_liquidity: felt,
        __warp_usrid_03_add: felt,
        __warp_usrid_02_amount: Uint256,
        __warp_usrid_00_sqrtPX96: felt,
    ) -> (__warp_usrid_04_: felt) {
        alloc_locals;

        let (__warp_se_1262) = warp_uint256(__warp_usrid_01_liquidity);

        let (__warp_usrid_05_numerator1) = warp_shl256(__warp_se_1262, 96);

        if (__warp_usrid_03_add != 0) {
            let __warp_usrid_06_product = Uint256(low=0, high=0);

            let (__warp_se_1263) = warp_uint256(__warp_usrid_00_sqrtPX96);

            let (__warp_se_1264) = warp_mul_unsafe256(__warp_usrid_02_amount, __warp_se_1263);

            let __warp_se_1265 = __warp_se_1264;

            let __warp_usrid_06_product = __warp_se_1265;

            let (__warp_se_1266) = warp_div_unsafe256(__warp_se_1265, __warp_usrid_02_amount);

            let (__warp_se_1267) = warp_uint256(__warp_usrid_00_sqrtPX96);

            let (__warp_se_1268) = warp_eq256(__warp_se_1266, __warp_se_1267);

            if (__warp_se_1268 != 0) {
                let (__warp_usrid_07_denominator) = warp_add_unsafe256(
                    __warp_usrid_05_numerator1, __warp_usrid_06_product
                );

                let (__warp_se_1269) = warp_ge256(
                    __warp_usrid_07_denominator, __warp_usrid_05_numerator1
                );

                if (__warp_se_1269 != 0) {
                    let (__warp_se_1270) = warp_uint256(__warp_usrid_00_sqrtPX96);

                    let (__warp_se_1271) = mulDivRoundingUp_0af8b27f(
                        __warp_usrid_05_numerator1, __warp_se_1270, __warp_usrid_07_denominator
                    );

                    let (__warp_se_1272) = warp_int256_to_int160(__warp_se_1271);

                    return (__warp_se_1272,);
                } else {
                    let (
                        __warp_se_1273
                    ) = getNextSqrtPriceFromAmount0RoundingUp_157f652f_if_part1_if_part3(
                        __warp_usrid_05_numerator1, __warp_usrid_00_sqrtPX96, __warp_usrid_02_amount
                    );

                    return (__warp_se_1273,);
                }
            } else {
                let (
                    __warp_se_1274
                ) = getNextSqrtPriceFromAmount0RoundingUp_157f652f_if_part1_if_part2(
                    __warp_usrid_05_numerator1, __warp_usrid_00_sqrtPX96, __warp_usrid_02_amount
                );

                return (__warp_se_1274,);
            }
        } else {
            let __warp_usrid_08_product = Uint256(low=0, high=0);

            let (__warp_se_1275) = warp_uint256(__warp_usrid_00_sqrtPX96);

            let (__warp_se_1276) = warp_mul_unsafe256(__warp_usrid_02_amount, __warp_se_1275);

            let __warp_se_1277 = __warp_se_1276;

            let __warp_usrid_08_product = __warp_se_1277;

            let (__warp_se_1278) = warp_div_unsafe256(__warp_se_1277, __warp_usrid_02_amount);

            let (__warp_se_1279) = warp_uint256(__warp_usrid_00_sqrtPX96);

            let (__warp_se_1280) = warp_eq256(__warp_se_1278, __warp_se_1279);

            let (__warp_se_1281) = warp_gt256(__warp_usrid_05_numerator1, __warp_usrid_08_product);

            let (__warp_se_1282) = warp_and_(__warp_se_1280, __warp_se_1281);

            assert __warp_se_1282 = 1;

            let (__warp_usrid_09_denominator) = warp_sub_unsafe256(
                __warp_usrid_05_numerator1, __warp_usrid_08_product
            );

            let (__warp_se_1283) = warp_uint256(__warp_usrid_00_sqrtPX96);

            let (__warp_se_1284) = mulDivRoundingUp_0af8b27f(
                __warp_usrid_05_numerator1, __warp_se_1283, __warp_usrid_09_denominator
            );

            let (__warp_se_1285) = toUint160_dfef6beb(__warp_se_1284);

            return (__warp_se_1285,);
        }
    }

    func getNextSqrtPriceFromAmount0RoundingUp_157f652f_if_part1_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_05_numerator1: Uint256,
        __warp_usrid_00_sqrtPX96: felt,
        __warp_usrid_02_amount: Uint256,
    ) -> (__warp_usrid_04_: felt) {
        alloc_locals;

        let (__warp_se_1286) = getNextSqrtPriceFromAmount0RoundingUp_157f652f_if_part1_if_part2(
            __warp_usrid_05_numerator1, __warp_usrid_00_sqrtPX96, __warp_usrid_02_amount
        );

        return (__warp_se_1286,);
    }

    func getNextSqrtPriceFromAmount0RoundingUp_157f652f_if_part1_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_05_numerator1: Uint256,
        __warp_usrid_00_sqrtPX96: felt,
        __warp_usrid_02_amount: Uint256,
    ) -> (__warp_usrid_04_: felt) {
        alloc_locals;

        let (__warp_se_1287) = warp_uint256(__warp_usrid_00_sqrtPX96);

        let (__warp_se_1288) = warp_div_unsafe256(__warp_usrid_05_numerator1, __warp_se_1287);

        let (__warp_se_1289) = add_771602f7(__warp_se_1288, __warp_usrid_02_amount);

        let (__warp_se_1290) = divRoundingUp_40226b32(__warp_usrid_05_numerator1, __warp_se_1289);

        let (__warp_se_1291) = warp_int256_to_int160(__warp_se_1290);

        return (__warp_se_1291,);
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
    func getNextSqrtPriceFromAmount1RoundingDown_fb4de288{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_10_sqrtPX96: felt,
        __warp_usrid_11_liquidity: felt,
        __warp_usrid_12_amount: Uint256,
        __warp_usrid_13_add: felt,
    ) -> (__warp_usrid_14_: felt) {
        alloc_locals;

        if (__warp_usrid_13_add != 0) {
            let __warp_usrid_15_quotient = Uint256(low=0, high=0);

            let (__warp_se_1292) = warp_uint256(1461501637330902918203684832716283019655932542975);

            let (__warp_se_1293) = warp_le256(__warp_usrid_12_amount, __warp_se_1292);

            if (__warp_se_1293 != 0) {
                let (__warp_se_1294) = warp_shl256(__warp_usrid_12_amount, 96);

                let (__warp_se_1295) = warp_uint256(__warp_usrid_11_liquidity);

                let (__warp_se_1296) = warp_div_unsafe256(__warp_se_1294, __warp_se_1295);

                let __warp_usrid_15_quotient = __warp_se_1296;

                let (__warp_se_1297) = getNextSqrtPriceFromAmount1RoundingDown_fb4de288_if_part2(
                    __warp_usrid_10_sqrtPX96, __warp_usrid_15_quotient
                );

                return (__warp_se_1297,);
            } else {
                let (__warp_se_1298) = warp_uint256(__warp_usrid_11_liquidity);

                let (__warp_se_1299) = mulDiv_aa9a0912(
                    __warp_usrid_12_amount,
                    Uint256(low=79228162514264337593543950336, high=0),
                    __warp_se_1298,
                );

                let __warp_usrid_15_quotient = __warp_se_1299;

                let (__warp_se_1300) = getNextSqrtPriceFromAmount1RoundingDown_fb4de288_if_part2(
                    __warp_usrid_10_sqrtPX96, __warp_usrid_15_quotient
                );

                return (__warp_se_1300,);
            }
        } else {
            let __warp_usrid_16_quotient = Uint256(low=0, high=0);

            let (__warp_se_1301) = warp_uint256(1461501637330902918203684832716283019655932542975);

            let (__warp_se_1302) = warp_le256(__warp_usrid_12_amount, __warp_se_1301);

            if (__warp_se_1302 != 0) {
                let (__warp_se_1303) = warp_shl256(__warp_usrid_12_amount, 96);

                let (__warp_se_1304) = warp_uint256(__warp_usrid_11_liquidity);

                let (__warp_se_1305) = divRoundingUp_40226b32(__warp_se_1303, __warp_se_1304);

                let __warp_usrid_16_quotient = __warp_se_1305;

                let (__warp_se_1306) = getNextSqrtPriceFromAmount1RoundingDown_fb4de288_if_part3(
                    __warp_usrid_10_sqrtPX96, __warp_usrid_16_quotient
                );

                return (__warp_se_1306,);
            } else {
                let (__warp_se_1307) = warp_uint256(__warp_usrid_11_liquidity);

                let (__warp_se_1308) = mulDivRoundingUp_0af8b27f(
                    __warp_usrid_12_amount,
                    Uint256(low=79228162514264337593543950336, high=0),
                    __warp_se_1307,
                );

                let __warp_usrid_16_quotient = __warp_se_1308;

                let (__warp_se_1309) = getNextSqrtPriceFromAmount1RoundingDown_fb4de288_if_part3(
                    __warp_usrid_10_sqrtPX96, __warp_usrid_16_quotient
                );

                return (__warp_se_1309,);
            }
        }
    }

    func getNextSqrtPriceFromAmount1RoundingDown_fb4de288_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_10_sqrtPX96: felt, __warp_usrid_16_quotient: Uint256) -> (
        __warp_usrid_14_: felt
    ) {
        alloc_locals;

        let (__warp_se_1310) = warp_uint256(__warp_usrid_10_sqrtPX96);

        let (__warp_se_1311) = warp_gt256(__warp_se_1310, __warp_usrid_16_quotient);

        assert __warp_se_1311 = 1;

        let (__warp_se_1312) = warp_uint256(__warp_usrid_10_sqrtPX96);

        let (__warp_se_1313) = warp_sub_unsafe256(__warp_se_1312, __warp_usrid_16_quotient);

        let (__warp_se_1314) = warp_int256_to_int160(__warp_se_1313);

        return (__warp_se_1314,);
    }

    func getNextSqrtPriceFromAmount1RoundingDown_fb4de288_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_10_sqrtPX96: felt, __warp_usrid_15_quotient: Uint256) -> (
        __warp_usrid_14_: felt
    ) {
        alloc_locals;

        let (__warp_se_1315) = warp_uint256(__warp_usrid_10_sqrtPX96);

        let (__warp_se_1316) = add_771602f7(__warp_se_1315, __warp_usrid_15_quotient);

        let (__warp_se_1317) = toUint160_dfef6beb(__warp_se_1316);

        return (__warp_se_1317,);
    }

    // @notice Gets the next sqrt price given an input amount of token0 or token1
    // @dev Throws if price or liquidity are 0, or if the next price is out of bounds
    // @param sqrtPX96 The starting price, i.e., before accounting for the input amount
    // @param liquidity The amount of usable liquidity
    // @param amountIn How much of token0, or token1, is being swapped in
    // @param zeroForOne Whether the amount in is token0 or token1
    // @return sqrtQX96 The price after adding the input amount to token0 or token1
    func getNextSqrtPriceFromInput_aa58276a{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_17_sqrtPX96: felt,
        __warp_usrid_18_liquidity: felt,
        __warp_usrid_19_amountIn: Uint256,
        __warp_usrid_20_zeroForOne: felt,
    ) -> (__warp_usrid_21_sqrtQX96: felt) {
        alloc_locals;

        let (__warp_se_1318) = warp_gt(__warp_usrid_17_sqrtPX96, 0);

        assert __warp_se_1318 = 1;

        let (__warp_se_1319) = warp_gt(__warp_usrid_18_liquidity, 0);

        assert __warp_se_1319 = 1;

        if (__warp_usrid_20_zeroForOne != 0) {
            let (__warp_se_1320) = getNextSqrtPriceFromAmount0RoundingUp_157f652f(
                __warp_usrid_17_sqrtPX96, __warp_usrid_18_liquidity, __warp_usrid_19_amountIn, 1
            );

            return (__warp_se_1320,);
        } else {
            let (__warp_se_1321) = getNextSqrtPriceFromAmount1RoundingDown_fb4de288(
                __warp_usrid_17_sqrtPX96, __warp_usrid_18_liquidity, __warp_usrid_19_amountIn, 1
            );

            return (__warp_se_1321,);
        }
    }

    // @notice Gets the next sqrt price given an output amount of token0 or token1
    // @dev Throws if price or liquidity are 0 or the next price is out of bounds
    // @param sqrtPX96 The starting price before accounting for the output amount
    // @param liquidity The amount of usable liquidity
    // @param amountOut How much of token0, or token1, is being swapped out
    // @param zeroForOne Whether the amount out is token0 or token1
    // @return sqrtQX96 The price after removing the output amount of token0 or token1
    func getNextSqrtPriceFromOutput_fedf2b5f{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_22_sqrtPX96: felt,
        __warp_usrid_23_liquidity: felt,
        __warp_usrid_24_amountOut: Uint256,
        __warp_usrid_25_zeroForOne: felt,
    ) -> (__warp_usrid_26_sqrtQX96: felt) {
        alloc_locals;

        let (__warp_se_1322) = warp_gt(__warp_usrid_22_sqrtPX96, 0);

        assert __warp_se_1322 = 1;

        let (__warp_se_1323) = warp_gt(__warp_usrid_23_liquidity, 0);

        assert __warp_se_1323 = 1;

        if (__warp_usrid_25_zeroForOne != 0) {
            let (__warp_se_1324) = getNextSqrtPriceFromAmount1RoundingDown_fb4de288(
                __warp_usrid_22_sqrtPX96, __warp_usrid_23_liquidity, __warp_usrid_24_amountOut, 0
            );

            return (__warp_se_1324,);
        } else {
            let (__warp_se_1325) = getNextSqrtPriceFromAmount0RoundingUp_157f652f(
                __warp_usrid_22_sqrtPX96, __warp_usrid_23_liquidity, __warp_usrid_24_amountOut, 0
            );

            return (__warp_se_1325,);
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
    func getAmount0Delta_2c32d4b6{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_27_sqrtRatioAX96: felt,
        __warp_usrid_28_sqrtRatioBX96: felt,
        __warp_usrid_29_liquidity: felt,
        __warp_usrid_30_roundUp: felt,
    ) -> (__warp_usrid_31_amount0: Uint256) {
        alloc_locals;

        let (__warp_se_1326) = warp_gt(
            __warp_usrid_27_sqrtRatioAX96, __warp_usrid_28_sqrtRatioBX96
        );

        if (__warp_se_1326 != 0) {
            let __warp_tv_83 = __warp_usrid_28_sqrtRatioBX96;

            let __warp_tv_84 = __warp_usrid_27_sqrtRatioAX96;

            let __warp_usrid_28_sqrtRatioBX96 = __warp_tv_84;

            let __warp_usrid_27_sqrtRatioAX96 = __warp_tv_83;

            let (__warp_se_1327) = getAmount0Delta_2c32d4b6_if_part1(
                __warp_usrid_29_liquidity,
                __warp_usrid_28_sqrtRatioBX96,
                __warp_usrid_27_sqrtRatioAX96,
                __warp_usrid_30_roundUp,
            );

            return (__warp_se_1327,);
        } else {
            let (__warp_se_1328) = getAmount0Delta_2c32d4b6_if_part1(
                __warp_usrid_29_liquidity,
                __warp_usrid_28_sqrtRatioBX96,
                __warp_usrid_27_sqrtRatioAX96,
                __warp_usrid_30_roundUp,
            );

            return (__warp_se_1328,);
        }
    }

    func getAmount0Delta_2c32d4b6_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_29_liquidity: felt,
        __warp_usrid_28_sqrtRatioBX96: felt,
        __warp_usrid_27_sqrtRatioAX96: felt,
        __warp_usrid_30_roundUp: felt,
    ) -> (__warp_usrid_31_amount0: Uint256) {
        alloc_locals;

        let (__warp_se_1329) = warp_uint256(__warp_usrid_29_liquidity);

        let (__warp_usrid_32_numerator1) = warp_shl256(__warp_se_1329, 96);

        let (__warp_se_1330) = warp_sub_unsafe160(
            __warp_usrid_28_sqrtRatioBX96, __warp_usrid_27_sqrtRatioAX96
        );

        let (__warp_usrid_33_numerator2) = warp_uint256(__warp_se_1330);

        let (__warp_se_1331) = warp_gt(__warp_usrid_27_sqrtRatioAX96, 0);

        assert __warp_se_1331 = 1;

        if (__warp_usrid_30_roundUp != 0) {
            let (__warp_se_1332) = warp_uint256(__warp_usrid_28_sqrtRatioBX96);

            let (__warp_se_1333) = mulDivRoundingUp_0af8b27f(
                __warp_usrid_32_numerator1, __warp_usrid_33_numerator2, __warp_se_1332
            );

            let (__warp_se_1334) = warp_uint256(__warp_usrid_27_sqrtRatioAX96);

            let (__warp_se_1335) = divRoundingUp_40226b32(__warp_se_1333, __warp_se_1334);

            return (__warp_se_1335,);
        } else {
            let (__warp_se_1336) = warp_uint256(__warp_usrid_28_sqrtRatioBX96);

            let (__warp_se_1337) = mulDiv_aa9a0912(
                __warp_usrid_32_numerator1, __warp_usrid_33_numerator2, __warp_se_1336
            );

            let (__warp_se_1338) = warp_uint256(__warp_usrid_27_sqrtRatioAX96);

            let (__warp_se_1339) = warp_div_unsafe256(__warp_se_1337, __warp_se_1338);

            return (__warp_se_1339,);
        }
    }

    // @notice Gets the amount1 delta between two prices
    // @dev Calculates liquidity * (sqrt(upper) - sqrt(lower))
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The amount of usable liquidity
    // @param roundUp Whether to round the amount up, or down
    // @return amount1 Amount of token1 required to cover a position of size liquidity between the two passed prices
    func getAmount1Delta_48a0c5bd{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_34_sqrtRatioAX96: felt,
        __warp_usrid_35_sqrtRatioBX96: felt,
        __warp_usrid_36_liquidity: felt,
        __warp_usrid_37_roundUp: felt,
    ) -> (__warp_usrid_38_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_1340) = warp_gt(
            __warp_usrid_34_sqrtRatioAX96, __warp_usrid_35_sqrtRatioBX96
        );

        if (__warp_se_1340 != 0) {
            let __warp_tv_85 = __warp_usrid_35_sqrtRatioBX96;

            let __warp_tv_86 = __warp_usrid_34_sqrtRatioAX96;

            let __warp_usrid_35_sqrtRatioBX96 = __warp_tv_86;

            let __warp_usrid_34_sqrtRatioAX96 = __warp_tv_85;

            let (__warp_se_1341) = getAmount1Delta_48a0c5bd_if_part1(
                __warp_usrid_37_roundUp,
                __warp_usrid_36_liquidity,
                __warp_usrid_35_sqrtRatioBX96,
                __warp_usrid_34_sqrtRatioAX96,
            );

            return (__warp_se_1341,);
        } else {
            let (__warp_se_1342) = getAmount1Delta_48a0c5bd_if_part1(
                __warp_usrid_37_roundUp,
                __warp_usrid_36_liquidity,
                __warp_usrid_35_sqrtRatioBX96,
                __warp_usrid_34_sqrtRatioAX96,
            );

            return (__warp_se_1342,);
        }
    }

    func getAmount1Delta_48a0c5bd_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_37_roundUp: felt,
        __warp_usrid_36_liquidity: felt,
        __warp_usrid_35_sqrtRatioBX96: felt,
        __warp_usrid_34_sqrtRatioAX96: felt,
    ) -> (__warp_usrid_38_amount1: Uint256) {
        alloc_locals;

        if (__warp_usrid_37_roundUp != 0) {
            let (__warp_se_1343) = warp_uint256(__warp_usrid_36_liquidity);

            let (__warp_se_1344) = warp_sub_unsafe160(
                __warp_usrid_35_sqrtRatioBX96, __warp_usrid_34_sqrtRatioAX96
            );

            let (__warp_se_1345) = warp_uint256(__warp_se_1344);

            let (__warp_se_1346) = mulDivRoundingUp_0af8b27f(
                __warp_se_1343, __warp_se_1345, Uint256(low=79228162514264337593543950336, high=0)
            );

            return (__warp_se_1346,);
        } else {
            let (__warp_se_1347) = warp_uint256(__warp_usrid_36_liquidity);

            let (__warp_se_1348) = warp_sub_unsafe160(
                __warp_usrid_35_sqrtRatioBX96, __warp_usrid_34_sqrtRatioAX96
            );

            let (__warp_se_1349) = warp_uint256(__warp_se_1348);

            let (__warp_se_1350) = mulDiv_aa9a0912(
                __warp_se_1347, __warp_se_1349, Uint256(low=79228162514264337593543950336, high=0)
            );

            return (__warp_se_1350,);
        }
    }

    // @notice Helper that gets signed token0 delta
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The change in liquidity for which to compute the amount0 delta
    // @return amount0 Amount of token0 corresponding to the passed liquidityDelta between the two prices
    func getAmount0Delta_c932699b{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_39_sqrtRatioAX96: felt,
        __warp_usrid_40_sqrtRatioBX96: felt,
        __warp_usrid_41_liquidity: felt,
    ) -> (__warp_usrid_42_amount0: Uint256) {
        alloc_locals;

        let (__warp_se_1351) = warp_lt_signed128(__warp_usrid_41_liquidity, 0);

        if (__warp_se_1351 != 0) {
            let (__warp_se_1352) = warp_negate128(__warp_usrid_41_liquidity);

            let (__warp_se_1353) = getAmount0Delta_2c32d4b6(
                __warp_usrid_39_sqrtRatioAX96, __warp_usrid_40_sqrtRatioBX96, __warp_se_1352, 0
            );

            let (__warp_se_1354) = toInt256_dfbe873b(__warp_se_1353);

            let (__warp_se_1355) = warp_negate256(__warp_se_1354);

            return (__warp_se_1355,);
        } else {
            let (__warp_se_1356) = getAmount0Delta_2c32d4b6(
                __warp_usrid_39_sqrtRatioAX96,
                __warp_usrid_40_sqrtRatioBX96,
                __warp_usrid_41_liquidity,
                1,
            );

            let (__warp_se_1357) = toInt256_dfbe873b(__warp_se_1356);

            return (__warp_se_1357,);
        }
    }

    // @notice Helper that gets signed token1 delta
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The change in liquidity for which to compute the amount1 delta
    // @return amount1 Amount of token1 corresponding to the passed liquidityDelta between the two prices
    func getAmount1Delta_00c11862{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_43_sqrtRatioAX96: felt,
        __warp_usrid_44_sqrtRatioBX96: felt,
        __warp_usrid_45_liquidity: felt,
    ) -> (__warp_usrid_46_amount1: Uint256) {
        alloc_locals;

        let (__warp_se_1358) = warp_lt_signed128(__warp_usrid_45_liquidity, 0);

        if (__warp_se_1358 != 0) {
            let (__warp_se_1359) = warp_negate128(__warp_usrid_45_liquidity);

            let (__warp_se_1360) = getAmount1Delta_48a0c5bd(
                __warp_usrid_43_sqrtRatioAX96, __warp_usrid_44_sqrtRatioBX96, __warp_se_1359, 0
            );

            let (__warp_se_1361) = toInt256_dfbe873b(__warp_se_1360);

            let (__warp_se_1362) = warp_negate256(__warp_se_1361);

            return (__warp_se_1362,);
        } else {
            let (__warp_se_1363) = getAmount1Delta_48a0c5bd(
                __warp_usrid_43_sqrtRatioAX96,
                __warp_usrid_44_sqrtRatioBX96,
                __warp_usrid_45_liquidity,
                1,
            );

            let (__warp_se_1364) = toInt256_dfbe873b(__warp_se_1363);

            return (__warp_se_1364,);
        }
    }

    // @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    // @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
    func mulDiv_aa9a0912{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_00_a: Uint256, __warp_usrid_01_b: Uint256, __warp_usrid_02_denominator: Uint256
    ) -> (__warp_usrid_03_result: Uint256) {
        alloc_locals;

        let __warp_usrid_03_result = Uint256(low=0, high=0);

        let __warp_usrid_04_prod0 = Uint256(low=0, high=0);

        let (__warp_se_1365) = warp_mul_unsafe256(__warp_usrid_00_a, __warp_usrid_01_b);

        let __warp_usrid_04_prod0 = __warp_se_1365;

        let (__warp_usrid_05_mm) = warp_mulmod(
            __warp_usrid_00_a,
            __warp_usrid_01_b,
            Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        );

        let __warp_usrid_06_prod1 = Uint256(low=0, high=0);

        let (__warp_se_1366) = warp_sub_unsafe256(__warp_usrid_05_mm, __warp_usrid_04_prod0);

        let __warp_usrid_06_prod1 = __warp_se_1366;

        let (__warp_se_1367) = warp_lt256(__warp_usrid_05_mm, __warp_usrid_04_prod0);

        if (__warp_se_1367 != 0) {
            let (__warp_se_1368) = warp_sub_unsafe256(
                __warp_usrid_06_prod1, Uint256(low=1, high=0)
            );

            let __warp_usrid_06_prod1 = __warp_se_1368;

            let (__warp_se_1369) = mulDiv_aa9a0912_if_part1(
                __warp_usrid_06_prod1,
                __warp_usrid_02_denominator,
                __warp_usrid_03_result,
                __warp_usrid_04_prod0,
                __warp_usrid_00_a,
                __warp_usrid_01_b,
            );

            return (__warp_se_1369,);
        } else {
            let (__warp_se_1370) = mulDiv_aa9a0912_if_part1(
                __warp_usrid_06_prod1,
                __warp_usrid_02_denominator,
                __warp_usrid_03_result,
                __warp_usrid_04_prod0,
                __warp_usrid_00_a,
                __warp_usrid_01_b,
            );

            return (__warp_se_1370,);
        }
    }

    func mulDiv_aa9a0912_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_06_prod1: Uint256,
        __warp_usrid_02_denominator: Uint256,
        __warp_usrid_03_result: Uint256,
        __warp_usrid_04_prod0: Uint256,
        __warp_usrid_00_a: Uint256,
        __warp_usrid_01_b: Uint256,
    ) -> (__warp_usrid_03_result: Uint256) {
        alloc_locals;

        let (__warp_se_1371) = warp_eq256(__warp_usrid_06_prod1, Uint256(low=0, high=0));

        if (__warp_se_1371 != 0) {
            let (__warp_se_1372) = warp_gt256(__warp_usrid_02_denominator, Uint256(low=0, high=0));

            assert __warp_se_1372 = 1;

            let (__warp_se_1373) = warp_div_unsafe256(
                __warp_usrid_04_prod0, __warp_usrid_02_denominator
            );

            let __warp_usrid_03_result = __warp_se_1373;

            return (__warp_usrid_03_result,);
        } else {
            let (__warp_se_1374) = mulDiv_aa9a0912_if_part1_if_part1(
                __warp_usrid_02_denominator,
                __warp_usrid_06_prod1,
                __warp_usrid_00_a,
                __warp_usrid_01_b,
                __warp_usrid_04_prod0,
                __warp_usrid_03_result,
            );

            return (__warp_se_1374,);
        }
    }

    func mulDiv_aa9a0912_if_part1_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_02_denominator: Uint256,
        __warp_usrid_06_prod1: Uint256,
        __warp_usrid_00_a: Uint256,
        __warp_usrid_01_b: Uint256,
        __warp_usrid_04_prod0: Uint256,
        __warp_usrid_03_result: Uint256,
    ) -> (__warp_usrid_03_result: Uint256) {
        alloc_locals;

        let (__warp_se_1375) = warp_gt256(__warp_usrid_02_denominator, __warp_usrid_06_prod1);

        assert __warp_se_1375 = 1;

        let __warp_usrid_07_remainder = Uint256(low=0, high=0);

        let (__warp_se_1376) = warp_mulmod(
            __warp_usrid_00_a, __warp_usrid_01_b, __warp_usrid_02_denominator
        );

        let __warp_usrid_07_remainder = __warp_se_1376;

        let (__warp_se_1377) = warp_gt256(__warp_usrid_07_remainder, __warp_usrid_04_prod0);

        if (__warp_se_1377 != 0) {
            let (__warp_se_1378) = warp_sub_unsafe256(
                __warp_usrid_06_prod1, Uint256(low=1, high=0)
            );

            let __warp_usrid_06_prod1 = __warp_se_1378;

            let (__warp_se_1379) = mulDiv_aa9a0912_if_part1_if_part1_if_part1(
                __warp_usrid_04_prod0,
                __warp_usrid_07_remainder,
                __warp_usrid_02_denominator,
                __warp_usrid_06_prod1,
                __warp_usrid_03_result,
            );

            return (__warp_se_1379,);
        } else {
            let (__warp_se_1380) = mulDiv_aa9a0912_if_part1_if_part1_if_part1(
                __warp_usrid_04_prod0,
                __warp_usrid_07_remainder,
                __warp_usrid_02_denominator,
                __warp_usrid_06_prod1,
                __warp_usrid_03_result,
            );

            return (__warp_se_1380,);
        }
    }

    func mulDiv_aa9a0912_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_04_prod0: Uint256,
        __warp_usrid_07_remainder: Uint256,
        __warp_usrid_02_denominator: Uint256,
        __warp_usrid_06_prod1: Uint256,
        __warp_usrid_03_result: Uint256,
    ) -> (__warp_usrid_03_result: Uint256) {
        alloc_locals;

        let (__warp_se_1381) = warp_sub_unsafe256(__warp_usrid_04_prod0, __warp_usrid_07_remainder);

        let __warp_usrid_04_prod0 = __warp_se_1381;

        let (__warp_se_1382) = warp_negate256(__warp_usrid_02_denominator);

        let (__warp_usrid_08_twos) = warp_bitwise_and256(
            __warp_se_1382, __warp_usrid_02_denominator
        );

        let (__warp_se_1383) = warp_div_unsafe256(
            __warp_usrid_02_denominator, __warp_usrid_08_twos
        );

        let __warp_usrid_02_denominator = __warp_se_1383;

        let (__warp_se_1384) = warp_div_unsafe256(__warp_usrid_04_prod0, __warp_usrid_08_twos);

        let __warp_usrid_04_prod0 = __warp_se_1384;

        let (__warp_se_1385) = warp_sub_unsafe256(Uint256(low=0, high=0), __warp_usrid_08_twos);

        let (__warp_se_1386) = warp_div_unsafe256(__warp_se_1385, __warp_usrid_08_twos);

        let (__warp_se_1387) = warp_add_unsafe256(__warp_se_1386, Uint256(low=1, high=0));

        let __warp_usrid_08_twos = __warp_se_1387;

        let (__warp_se_1388) = warp_mul_unsafe256(__warp_usrid_06_prod1, __warp_usrid_08_twos);

        let (__warp_se_1389) = warp_bitwise_or256(__warp_usrid_04_prod0, __warp_se_1388);

        let __warp_usrid_04_prod0 = __warp_se_1389;

        let (__warp_se_1390) = warp_mul_unsafe256(
            Uint256(low=3, high=0), __warp_usrid_02_denominator
        );

        let (__warp_usrid_09_inv) = warp_xor256(__warp_se_1390, Uint256(low=2, high=0));

        let (__warp_se_1391) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_1392) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_1391);

        let (__warp_se_1393) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_1392);

        let __warp_usrid_09_inv = __warp_se_1393;

        let (__warp_se_1394) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_1395) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_1394);

        let (__warp_se_1396) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_1395);

        let __warp_usrid_09_inv = __warp_se_1396;

        let (__warp_se_1397) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_1398) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_1397);

        let (__warp_se_1399) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_1398);

        let __warp_usrid_09_inv = __warp_se_1399;

        let (__warp_se_1400) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_1401) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_1400);

        let (__warp_se_1402) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_1401);

        let __warp_usrid_09_inv = __warp_se_1402;

        let (__warp_se_1403) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_1404) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_1403);

        let (__warp_se_1405) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_1404);

        let __warp_usrid_09_inv = __warp_se_1405;

        let (__warp_se_1406) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);

        let (__warp_se_1407) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_1406);

        let (__warp_se_1408) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_1407);

        let __warp_usrid_09_inv = __warp_se_1408;

        let (__warp_se_1409) = warp_mul_unsafe256(__warp_usrid_04_prod0, __warp_usrid_09_inv);

        let __warp_usrid_03_result = __warp_se_1409;

        return (__warp_usrid_03_result,);
    }

    // @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    func mulDivRoundingUp_0af8b27f{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_10_a: Uint256, __warp_usrid_11_b: Uint256, __warp_usrid_12_denominator: Uint256
    ) -> (__warp_usrid_13_result: Uint256) {
        alloc_locals;

        let __warp_usrid_13_result = Uint256(low=0, high=0);

        let (__warp_se_1410) = mulDiv_aa9a0912(
            __warp_usrid_10_a, __warp_usrid_11_b, __warp_usrid_12_denominator
        );

        let __warp_usrid_13_result = __warp_se_1410;

        let (__warp_se_1411) = warp_mulmod(
            __warp_usrid_10_a, __warp_usrid_11_b, __warp_usrid_12_denominator
        );

        let (__warp_se_1412) = warp_gt256(__warp_se_1411, Uint256(low=0, high=0));

        if (__warp_se_1412 != 0) {
            let (__warp_se_1413) = warp_lt256(
                __warp_usrid_13_result,
                Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
            );

            assert __warp_se_1413 = 1;

            let (__warp_se_1414) = warp_add_unsafe256(
                __warp_usrid_13_result, Uint256(low=1, high=0)
            );

            let __warp_se_1415 = __warp_se_1414;

            let __warp_usrid_13_result = __warp_se_1415;

            warp_sub_unsafe256(__warp_se_1415, Uint256(low=1, high=0));

            let (__warp_se_1416) = mulDivRoundingUp_0af8b27f_if_part1(__warp_usrid_13_result);

            return (__warp_se_1416,);
        } else {
            let (__warp_se_1417) = mulDivRoundingUp_0af8b27f_if_part1(__warp_usrid_13_result);

            return (__warp_se_1417,);
        }
    }

    func mulDivRoundingUp_0af8b27f_if_part1(__warp_usrid_13_result: Uint256) -> (
        __warp_usrid_13_result: Uint256
    ) {
        alloc_locals;

        return (__warp_usrid_13_result,);
    }

    // @notice Returns ceil(x / y)
    // @dev division by 0 has unspecified behavior, and must be checked externally
    // @param x The dividend
    // @param y The divisor
    // @return z The quotient, ceil(x / y)
    func divRoundingUp_40226b32{range_check_ptr: felt}(
        __warp_usrid_00_x: Uint256, __warp_usrid_01_y: Uint256
    ) -> (__warp_usrid_02_z: Uint256) {
        alloc_locals;

        let __warp_usrid_02_z = Uint256(low=0, high=0);

        let __warp_usrid_03_temp = Uint256(low=0, high=0);

        let (__warp_se_1418) = warp_mod256(__warp_usrid_00_x, __warp_usrid_01_y);

        let (__warp_se_1419) = warp_gt256(__warp_se_1418, Uint256(low=0, high=0));

        if (__warp_se_1419 != 0) {
            let __warp_usrid_03_temp = Uint256(low=1, high=0);

            let (__warp_se_1420) = divRoundingUp_40226b32_if_part1(
                __warp_usrid_02_z, __warp_usrid_00_x, __warp_usrid_01_y, __warp_usrid_03_temp
            );

            return (__warp_se_1420,);
        } else {
            let (__warp_se_1421) = divRoundingUp_40226b32_if_part1(
                __warp_usrid_02_z, __warp_usrid_00_x, __warp_usrid_01_y, __warp_usrid_03_temp
            );

            return (__warp_se_1421,);
        }
    }

    func divRoundingUp_40226b32_if_part1{range_check_ptr: felt}(
        __warp_usrid_02_z: Uint256,
        __warp_usrid_00_x: Uint256,
        __warp_usrid_01_y: Uint256,
        __warp_usrid_03_temp: Uint256,
    ) -> (__warp_usrid_02_z: Uint256) {
        alloc_locals;

        let (__warp_se_1422) = warp_div_unsafe256(__warp_usrid_00_x, __warp_usrid_01_y);

        let (__warp_se_1423) = warp_add_unsafe256(__warp_se_1422, __warp_usrid_03_temp);

        let __warp_usrid_02_z = __warp_se_1423;

        return (__warp_usrid_02_z,);
    }

    // @notice Returns the Info struct of a position, given an owner and position boundaries
    // @param self The mapping containing all user positions
    // @param owner The address of the position owner
    // @param tickLower The lower tick boundary of the position
    // @param tickUpper The upper tick boundary of the position
    // @return position The position info struct of the given owners' position
    func get_a4d6{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
        keccak_ptr: felt*,
    }(
        __warp_usrid_05_self: felt,
        __warp_usrid_06_owner: felt,
        __warp_usrid_07_tickLower: felt,
        __warp_usrid_08_tickUpper: felt,
    ) -> (__warp_usrid_09_position: felt) {
        alloc_locals;

        let __warp_usrid_09_position = 0;

        let (__warp_se_1424) = abi_encode_packed0(
            __warp_usrid_06_owner, __warp_usrid_07_tickLower, __warp_usrid_08_tickUpper
        );

        let (__warp_se_1425) = warp_keccak(__warp_se_1424);

        let (__warp_se_1426) = WS2_INDEX_Uint256_to_Info_d529aac3(
            __warp_usrid_05_self, __warp_se_1425
        );

        let __warp_usrid_09_position = __warp_se_1426;

        return (__warp_usrid_09_position,);
    }

    // @notice Credits accumulated fees to a user's position
    // @param self The individual position to update
    // @param liquidityDelta The change in pool liquidity as a result of the position update
    // @param feeGrowthInside0X128 The all-time fee growth in token0, per unit of liquidity, inside the position's tick boundaries
    // @param feeGrowthInside1X128 The all-time fee growth in token1, per unit of liquidity, inside the position's tick boundaries
    func update_d9a1a063{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_10_self: felt,
        __warp_usrid_11_liquidityDelta: felt,
        __warp_usrid_12_feeGrowthInside0X128: Uint256,
        __warp_usrid_13_feeGrowthInside1X128: Uint256,
    ) -> () {
        alloc_locals;

        let (__warp_usrid_14__self) = ws_to_memory2(__warp_usrid_10_self);

        let __warp_usrid_15_liquidityNext = 0;

        let (__warp_se_1427) = warp_eq(__warp_usrid_11_liquidityDelta, 0);

        if (__warp_se_1427 != 0) {
            let (__warp_se_1428) = WM35_Info_d529aac3___warp_usrid_00_liquidity(
                __warp_usrid_14__self
            );

            let (__warp_se_1429) = wm_read_felt(__warp_se_1428);

            let (__warp_se_1430) = warp_gt(__warp_se_1429, 0);

            with_attr error_message("NP") {
                assert __warp_se_1430 = 1;
            }

            let (__warp_se_1431) = WM35_Info_d529aac3___warp_usrid_00_liquidity(
                __warp_usrid_14__self
            );

            let (__warp_se_1432) = wm_read_felt(__warp_se_1431);

            let __warp_usrid_15_liquidityNext = __warp_se_1432;

            update_d9a1a063_if_part1(
                __warp_usrid_12_feeGrowthInside0X128,
                __warp_usrid_14__self,
                __warp_usrid_13_feeGrowthInside1X128,
                __warp_usrid_11_liquidityDelta,
                __warp_usrid_10_self,
                __warp_usrid_15_liquidityNext,
            );

            return ();
        } else {
            let (__warp_se_1433) = WM35_Info_d529aac3___warp_usrid_00_liquidity(
                __warp_usrid_14__self
            );

            let (__warp_se_1434) = wm_read_felt(__warp_se_1433);

            let (__warp_se_1435) = addDelta_402d44fb(
                __warp_se_1434, __warp_usrid_11_liquidityDelta
            );

            let __warp_usrid_15_liquidityNext = __warp_se_1435;

            update_d9a1a063_if_part1(
                __warp_usrid_12_feeGrowthInside0X128,
                __warp_usrid_14__self,
                __warp_usrid_13_feeGrowthInside1X128,
                __warp_usrid_11_liquidityDelta,
                __warp_usrid_10_self,
                __warp_usrid_15_liquidityNext,
            );

            return ();
        }
    }

    func update_d9a1a063_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
        warp_memory: DictAccess*,
    }(
        __warp_usrid_12_feeGrowthInside0X128: Uint256,
        __warp_usrid_14__self: felt,
        __warp_usrid_13_feeGrowthInside1X128: Uint256,
        __warp_usrid_11_liquidityDelta: felt,
        __warp_usrid_10_self: felt,
        __warp_usrid_15_liquidityNext: felt,
    ) -> () {
        alloc_locals;

        let (__warp_se_1436) = WM36_Info_d529aac3___warp_usrid_01_feeGrowthInside0LastX128(
            __warp_usrid_14__self
        );

        let (__warp_se_1437) = wm_read_256(__warp_se_1436);

        let (__warp_se_1438) = warp_sub_unsafe256(
            __warp_usrid_12_feeGrowthInside0X128, __warp_se_1437
        );

        let (__warp_se_1439) = WM35_Info_d529aac3___warp_usrid_00_liquidity(__warp_usrid_14__self);

        let (__warp_se_1440) = wm_read_felt(__warp_se_1439);

        let (__warp_se_1441) = warp_uint256(__warp_se_1440);

        let (__warp_se_1442) = mulDiv_aa9a0912(
            __warp_se_1438, __warp_se_1441, Uint256(low=0, high=1)
        );

        let (__warp_usrid_16_tokensOwed0) = warp_int256_to_int128(__warp_se_1442);

        let (__warp_se_1443) = WM37_Info_d529aac3___warp_usrid_02_feeGrowthInside1LastX128(
            __warp_usrid_14__self
        );

        let (__warp_se_1444) = wm_read_256(__warp_se_1443);

        let (__warp_se_1445) = warp_sub_unsafe256(
            __warp_usrid_13_feeGrowthInside1X128, __warp_se_1444
        );

        let (__warp_se_1446) = WM35_Info_d529aac3___warp_usrid_00_liquidity(__warp_usrid_14__self);

        let (__warp_se_1447) = wm_read_felt(__warp_se_1446);

        let (__warp_se_1448) = warp_uint256(__warp_se_1447);

        let (__warp_se_1449) = mulDiv_aa9a0912(
            __warp_se_1445, __warp_se_1448, Uint256(low=0, high=1)
        );

        let (__warp_usrid_17_tokensOwed1) = warp_int256_to_int128(__warp_se_1449);

        let (__warp_se_1450) = warp_neq(__warp_usrid_11_liquidityDelta, 0);

        if (__warp_se_1450 != 0) {
            let (__warp_se_1451) = WSM20_Info_d529aac3___warp_usrid_00_liquidity(
                __warp_usrid_10_self
            );

            WS_WRITE0(__warp_se_1451, __warp_usrid_15_liquidityNext);

            update_d9a1a063_if_part1_if_part1(
                __warp_usrid_10_self,
                __warp_usrid_12_feeGrowthInside0X128,
                __warp_usrid_13_feeGrowthInside1X128,
                __warp_usrid_16_tokensOwed0,
                __warp_usrid_17_tokensOwed1,
            );

            return ();
        } else {
            update_d9a1a063_if_part1_if_part1(
                __warp_usrid_10_self,
                __warp_usrid_12_feeGrowthInside0X128,
                __warp_usrid_13_feeGrowthInside1X128,
                __warp_usrid_16_tokensOwed0,
                __warp_usrid_17_tokensOwed1,
            );

            return ();
        }
    }

    func update_d9a1a063_if_part1_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_10_self: felt,
        __warp_usrid_12_feeGrowthInside0X128: Uint256,
        __warp_usrid_13_feeGrowthInside1X128: Uint256,
        __warp_usrid_16_tokensOwed0: felt,
        __warp_usrid_17_tokensOwed1: felt,
    ) -> () {
        alloc_locals;

        let (__warp_se_1452) = WSM21_Info_d529aac3___warp_usrid_01_feeGrowthInside0LastX128(
            __warp_usrid_10_self
        );

        WS_WRITE1(__warp_se_1452, __warp_usrid_12_feeGrowthInside0X128);

        let (__warp_se_1453) = WSM22_Info_d529aac3___warp_usrid_02_feeGrowthInside1LastX128(
            __warp_usrid_10_self
        );

        WS_WRITE1(__warp_se_1453, __warp_usrid_13_feeGrowthInside1X128);

        let (__warp_se_1454) = warp_gt(__warp_usrid_16_tokensOwed0, 0);

        let (__warp_se_1455) = warp_gt(__warp_usrid_17_tokensOwed1, 0);

        let (__warp_se_1456) = warp_or(__warp_se_1454, __warp_se_1455);

        if (__warp_se_1456 != 0) {
            let (__warp_se_1457) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(
                __warp_usrid_10_self
            );

            let (__warp_se_1458) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(
                __warp_usrid_10_self
            );

            let (__warp_se_1459) = WS1_READ_felt(__warp_se_1458);

            let (__warp_se_1460) = warp_add_unsafe128(__warp_se_1459, __warp_usrid_16_tokensOwed0);

            WS_WRITE0(__warp_se_1457, __warp_se_1460);

            let (__warp_se_1461) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(
                __warp_usrid_10_self
            );

            let (__warp_se_1462) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(
                __warp_usrid_10_self
            );

            let (__warp_se_1463) = WS1_READ_felt(__warp_se_1462);

            let (__warp_se_1464) = warp_add_unsafe128(__warp_se_1463, __warp_usrid_17_tokensOwed1);

            WS_WRITE0(__warp_se_1461, __warp_se_1464);

            update_d9a1a063_if_part1_if_part1_if_part1();

            return ();
        } else {
            update_d9a1a063_if_part1_if_part1_if_part1();

            return ();
        }
    }

    func update_d9a1a063_if_part1_if_part1_if_part1() -> () {
        alloc_locals;

        return ();
    }

    // @notice Computes the position in the mapping where the initialized bit for a tick lives
    // @param tick The tick for which to compute the position
    // @return wordPos The key in the mapping containing the word in which the bit is stored
    // @return bitPos The bit position in the word where the flag is stored
    func position_3e7b7779{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_00_tick: felt
    ) -> (__warp_usrid_01_wordPos: felt, __warp_usrid_02_bitPos: felt) {
        alloc_locals;

        let __warp_usrid_02_bitPos = 0;

        let __warp_usrid_01_wordPos = 0;

        let (__warp_se_1465) = warp_shr_signed24(__warp_usrid_00_tick, 8);

        let (__warp_se_1466) = warp_int24_to_int16(__warp_se_1465);

        let __warp_usrid_01_wordPos = __warp_se_1466;

        let (__warp_se_1467) = warp_mod(__warp_usrid_00_tick, 256);

        let (__warp_se_1468) = warp_int24_to_int8(__warp_se_1467);

        let __warp_usrid_02_bitPos = __warp_se_1468;

        let __warp_usrid_01_wordPos = __warp_usrid_01_wordPos;

        let __warp_usrid_02_bitPos = __warp_usrid_02_bitPos;

        return (__warp_usrid_01_wordPos, __warp_usrid_02_bitPos);
    }

    // @notice Flips the initialized state for a given tick from false to true, or vice versa
    // @param self The mapping in which to flip the tick
    // @param tick The tick to flip
    // @param tickSpacing The spacing between usable ticks
    func flipTick_5b3a{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_03_self: felt, __warp_usrid_04_tick: felt, __warp_usrid_05_tickSpacing: felt
    ) -> () {
        alloc_locals;

        let (__warp_se_1469) = warp_mod_signed24(__warp_usrid_04_tick, __warp_usrid_05_tickSpacing);

        let (__warp_se_1470) = warp_eq(__warp_se_1469, 0);

        assert __warp_se_1470 = 1;

        let (__warp_se_1471) = warp_div_signed_unsafe24(
            __warp_usrid_04_tick, __warp_usrid_05_tickSpacing
        );

        let (__warp_usrid_06_wordPos, __warp_usrid_07_bitPos) = position_3e7b7779(__warp_se_1471);

        let (__warp_usrid_08_mask) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_07_bitPos);

        let __warp_cs_0 = __warp_usrid_06_wordPos;

        let (__warp_se_1472) = WS1_INDEX_felt_to_Uint256(__warp_usrid_03_self, __warp_cs_0);

        let (__warp_se_1473) = WS1_INDEX_felt_to_Uint256(__warp_usrid_03_self, __warp_cs_0);

        let (__warp_se_1474) = WS0_READ_Uint256(__warp_se_1473);

        let (__warp_se_1475) = warp_xor256(__warp_se_1474, __warp_usrid_08_mask);

        WS_WRITE1(__warp_se_1472, __warp_se_1475);

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
    func nextInitializedTickWithinOneWord_a52a{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_09_self: felt,
        __warp_usrid_10_tick: felt,
        __warp_usrid_11_tickSpacing: felt,
        __warp_usrid_12_lte: felt,
    ) -> (__warp_usrid_13_next: felt, __warp_usrid_14_initialized: felt) {
        alloc_locals;

        let __warp_usrid_13_next = 0;

        let __warp_usrid_14_initialized = 0;

        let (__warp_usrid_15_compressed) = warp_div_signed_unsafe24(
            __warp_usrid_10_tick, __warp_usrid_11_tickSpacing
        );

        let (__warp_se_1476) = warp_lt_signed24(__warp_usrid_10_tick, 0);

        let (__warp_se_1477) = warp_mod_signed24(__warp_usrid_10_tick, __warp_usrid_11_tickSpacing);

        let (__warp_se_1478) = warp_neq(__warp_se_1477, 0);

        let (__warp_se_1479) = warp_and_(__warp_se_1476, __warp_se_1478);

        if (__warp_se_1479 != 0) {
            let (__warp_se_1480) = warp_sub_signed_unsafe24(__warp_usrid_15_compressed, 1);

            let __warp_se_1481 = __warp_se_1480;

            let __warp_usrid_15_compressed = __warp_se_1481;

            warp_add_signed_unsafe24(__warp_se_1481, 1);

            let (
                __warp_usrid_13_next, __warp_usrid_14_initialized
            ) = nextInitializedTickWithinOneWord_a52a_if_part1(
                __warp_usrid_12_lte,
                __warp_usrid_15_compressed,
                __warp_usrid_09_self,
                __warp_usrid_14_initialized,
                __warp_usrid_13_next,
                __warp_usrid_11_tickSpacing,
            );

            return (__warp_usrid_13_next, __warp_usrid_14_initialized);
        } else {
            let (
                __warp_usrid_13_next, __warp_usrid_14_initialized
            ) = nextInitializedTickWithinOneWord_a52a_if_part1(
                __warp_usrid_12_lte,
                __warp_usrid_15_compressed,
                __warp_usrid_09_self,
                __warp_usrid_14_initialized,
                __warp_usrid_13_next,
                __warp_usrid_11_tickSpacing,
            );

            return (__warp_usrid_13_next, __warp_usrid_14_initialized);
        }
    }

    func nextInitializedTickWithinOneWord_a52a_if_part1{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr: felt,
        bitwise_ptr: BitwiseBuiltin*,
    }(
        __warp_usrid_12_lte: felt,
        __warp_usrid_15_compressed: felt,
        __warp_usrid_09_self: felt,
        __warp_usrid_14_initialized: felt,
        __warp_usrid_13_next: felt,
        __warp_usrid_11_tickSpacing: felt,
    ) -> (__warp_usrid_13_next: felt, __warp_usrid_14_initialized: felt) {
        alloc_locals;

        if (__warp_usrid_12_lte != 0) {
            let (__warp_usrid_16_wordPos, __warp_usrid_17_bitPos) = position_3e7b7779(
                __warp_usrid_15_compressed
            );

            let (__warp_se_1482) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_17_bitPos);

            let (__warp_se_1483) = warp_sub_unsafe256(__warp_se_1482, Uint256(low=1, high=0));

            let (__warp_se_1484) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_17_bitPos);

            let (__warp_usrid_18_mask) = warp_add_unsafe256(__warp_se_1483, __warp_se_1484);

            let (__warp_se_1485) = WS1_INDEX_felt_to_Uint256(
                __warp_usrid_09_self, __warp_usrid_16_wordPos
            );

            let (__warp_se_1486) = WS0_READ_Uint256(__warp_se_1485);

            let (__warp_usrid_19_masked) = warp_bitwise_and256(
                __warp_se_1486, __warp_usrid_18_mask
            );

            let (__warp_se_1487) = warp_neq256(__warp_usrid_19_masked, Uint256(low=0, high=0));

            let __warp_usrid_14_initialized = __warp_se_1487;

            if (__warp_usrid_14_initialized != 0) {
                let (__warp_se_1488) = mostSignificantBit_e6bcbc65(__warp_usrid_19_masked);

                let (__warp_se_1489) = warp_sub_signed_unsafe24(
                    __warp_usrid_17_bitPos, __warp_se_1488
                );

                let (__warp_se_1490) = warp_sub_signed_unsafe24(
                    __warp_usrid_15_compressed, __warp_se_1489
                );

                let (__warp_se_1491) = warp_mul_signed_unsafe24(
                    __warp_se_1490, __warp_usrid_11_tickSpacing
                );

                let __warp_usrid_13_next = __warp_se_1491;

                let (
                    __warp_usrid_13_next, __warp_usrid_14_initialized
                ) = nextInitializedTickWithinOneWord_a52a_if_part1_if_part2(
                    __warp_usrid_13_next, __warp_usrid_14_initialized
                );

                return (__warp_usrid_13_next, __warp_usrid_14_initialized);
            } else {
                let (__warp_se_1492) = warp_sub_signed_unsafe24(
                    __warp_usrid_15_compressed, __warp_usrid_17_bitPos
                );

                let (__warp_se_1493) = warp_mul_signed_unsafe24(
                    __warp_se_1492, __warp_usrid_11_tickSpacing
                );

                let __warp_usrid_13_next = __warp_se_1493;

                let (
                    __warp_usrid_13_next, __warp_usrid_14_initialized
                ) = nextInitializedTickWithinOneWord_a52a_if_part1_if_part2(
                    __warp_usrid_13_next, __warp_usrid_14_initialized
                );

                return (__warp_usrid_13_next, __warp_usrid_14_initialized);
            }
        } else {
            let (__warp_se_1494) = warp_add_signed_unsafe24(__warp_usrid_15_compressed, 1);

            let (__warp_usrid_20_wordPos, __warp_usrid_21_bitPos) = position_3e7b7779(
                __warp_se_1494
            );

            let (__warp_se_1495) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_21_bitPos);

            let (__warp_se_1496) = warp_sub_unsafe256(__warp_se_1495, Uint256(low=1, high=0));

            let (__warp_usrid_22_mask) = warp_bitwise_not256(__warp_se_1496);

            let (__warp_se_1497) = WS1_INDEX_felt_to_Uint256(
                __warp_usrid_09_self, __warp_usrid_20_wordPos
            );

            let (__warp_se_1498) = WS0_READ_Uint256(__warp_se_1497);

            let (__warp_usrid_23_masked) = warp_bitwise_and256(
                __warp_se_1498, __warp_usrid_22_mask
            );

            let (__warp_se_1499) = warp_neq256(__warp_usrid_23_masked, Uint256(low=0, high=0));

            let __warp_usrid_14_initialized = __warp_se_1499;

            if (__warp_usrid_14_initialized != 0) {
                let (__warp_se_1500) = warp_add_signed_unsafe24(__warp_usrid_15_compressed, 1);

                let (__warp_se_1501) = leastSignificantBit_d230d23f(__warp_usrid_23_masked);

                let (__warp_se_1502) = warp_sub_signed_unsafe24(
                    __warp_se_1501, __warp_usrid_21_bitPos
                );

                let (__warp_se_1503) = warp_add_signed_unsafe24(__warp_se_1500, __warp_se_1502);

                let (__warp_se_1504) = warp_mul_signed_unsafe24(
                    __warp_se_1503, __warp_usrid_11_tickSpacing
                );

                let __warp_usrid_13_next = __warp_se_1504;

                let (
                    __warp_usrid_13_next, __warp_usrid_14_initialized
                ) = nextInitializedTickWithinOneWord_a52a_if_part1_if_part3(
                    __warp_usrid_13_next, __warp_usrid_14_initialized
                );

                return (__warp_usrid_13_next, __warp_usrid_14_initialized);
            } else {
                let (__warp_se_1505) = warp_add_signed_unsafe24(__warp_usrid_15_compressed, 1);

                let (__warp_se_1506) = warp_sub_signed_unsafe24(255, __warp_usrid_21_bitPos);

                let (__warp_se_1507) = warp_add_signed_unsafe24(__warp_se_1505, __warp_se_1506);

                let (__warp_se_1508) = warp_mul_signed_unsafe24(
                    __warp_se_1507, __warp_usrid_11_tickSpacing
                );

                let __warp_usrid_13_next = __warp_se_1508;

                let (
                    __warp_usrid_13_next, __warp_usrid_14_initialized
                ) = nextInitializedTickWithinOneWord_a52a_if_part1_if_part3(
                    __warp_usrid_13_next, __warp_usrid_14_initialized
                );

                return (__warp_usrid_13_next, __warp_usrid_14_initialized);
            }
        }
    }

    func nextInitializedTickWithinOneWord_a52a_if_part1_if_part3(
        __warp_usrid_13_next: felt, __warp_usrid_14_initialized: felt
    ) -> (__warp_usrid_13_next: felt, __warp_usrid_14_initialized: felt) {
        alloc_locals;

        let (
            __warp_usrid_13_next, __warp_usrid_14_initialized
        ) = nextInitializedTickWithinOneWord_a52a_if_part1_if_part1(
            __warp_usrid_13_next, __warp_usrid_14_initialized
        );

        return (__warp_usrid_13_next, __warp_usrid_14_initialized);
    }

    func nextInitializedTickWithinOneWord_a52a_if_part1_if_part2(
        __warp_usrid_13_next: felt, __warp_usrid_14_initialized: felt
    ) -> (__warp_usrid_13_next: felt, __warp_usrid_14_initialized: felt) {
        alloc_locals;

        let (
            __warp_usrid_13_next, __warp_usrid_14_initialized
        ) = nextInitializedTickWithinOneWord_a52a_if_part1_if_part1(
            __warp_usrid_13_next, __warp_usrid_14_initialized
        );

        return (__warp_usrid_13_next, __warp_usrid_14_initialized);
    }

    func nextInitializedTickWithinOneWord_a52a_if_part1_if_part1(
        __warp_usrid_13_next: felt, __warp_usrid_14_initialized: felt
    ) -> (__warp_usrid_13_next: felt, __warp_usrid_14_initialized: felt) {
        alloc_locals;

        let __warp_usrid_13_next = __warp_usrid_13_next;

        let __warp_usrid_14_initialized = __warp_usrid_14_initialized;

        return (__warp_usrid_13_next, __warp_usrid_14_initialized);
    }

    // @notice Returns the index of the most significant bit of the number,
    //     where the least significant bit is at index 0 and the most significant bit is at index 255
    // @dev The function satisfies the property:
    //     x >= 2**mostSignificantBit(x) and x < 2**(mostSignificantBit(x)+1)
    // @param x the value for which to compute the most significant bit, must be greater than 0
    // @return r the index of the most significant bit
    func mostSignificantBit_e6bcbc65{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_00_x: Uint256
    ) -> (__warp_usrid_01_r: felt) {
        alloc_locals;

        let __warp_usrid_01_r = 0;

        let (__warp_se_1509) = warp_gt256(__warp_usrid_00_x, Uint256(low=0, high=0));

        assert __warp_se_1509 = 1;

        let (__warp_se_1510) = warp_ge256(__warp_usrid_00_x, Uint256(low=0, high=1));

        if (__warp_se_1510 != 0) {
            let (__warp_se_1511) = warp_shr256(__warp_usrid_00_x, 128);

            let __warp_usrid_00_x = __warp_se_1511;

            let (__warp_se_1512) = warp_add_unsafe8(__warp_usrid_01_r, 128);

            let __warp_usrid_01_r = __warp_se_1512;

            let (__warp_se_1513) = mostSignificantBit_e6bcbc65_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1513,);
        } else {
            let (__warp_se_1514) = mostSignificantBit_e6bcbc65_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1514,);
        }
    }

    func mostSignificantBit_e6bcbc65_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_00_x: Uint256, __warp_usrid_01_r: felt
    ) -> (__warp_usrid_01_r: felt) {
        alloc_locals;

        let (__warp_se_1515) = warp_ge256(
            __warp_usrid_00_x, Uint256(low=18446744073709551616, high=0)
        );

        if (__warp_se_1515 != 0) {
            let (__warp_se_1516) = warp_shr256(__warp_usrid_00_x, 64);

            let __warp_usrid_00_x = __warp_se_1516;

            let (__warp_se_1517) = warp_add_unsafe8(__warp_usrid_01_r, 64);

            let __warp_usrid_01_r = __warp_se_1517;

            let (__warp_se_1518) = mostSignificantBit_e6bcbc65_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1518,);
        } else {
            let (__warp_se_1519) = mostSignificantBit_e6bcbc65_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1519,);
        }
    }

    func mostSignificantBit_e6bcbc65_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_00_x: Uint256, __warp_usrid_01_r: felt) -> (__warp_usrid_01_r: felt) {
        alloc_locals;

        let (__warp_se_1520) = warp_ge256(__warp_usrid_00_x, Uint256(low=4294967296, high=0));

        if (__warp_se_1520 != 0) {
            let (__warp_se_1521) = warp_shr256(__warp_usrid_00_x, 32);

            let __warp_usrid_00_x = __warp_se_1521;

            let (__warp_se_1522) = warp_add_unsafe8(__warp_usrid_01_r, 32);

            let __warp_usrid_01_r = __warp_se_1522;

            let (__warp_se_1523) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1523,);
        } else {
            let (__warp_se_1524) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1524,);
        }
    }

    func mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_00_x: Uint256, __warp_usrid_01_r: felt) -> (__warp_usrid_01_r: felt) {
        alloc_locals;

        let (__warp_se_1525) = warp_ge256(__warp_usrid_00_x, Uint256(low=65536, high=0));

        if (__warp_se_1525 != 0) {
            let (__warp_se_1526) = warp_shr256(__warp_usrid_00_x, 16);

            let __warp_usrid_00_x = __warp_se_1526;

            let (__warp_se_1527) = warp_add_unsafe8(__warp_usrid_01_r, 16);

            let __warp_usrid_01_r = __warp_se_1527;

            let (__warp_se_1528) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1528,);
        } else {
            let (__warp_se_1529) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1529,);
        }
    }

    func mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_00_x: Uint256, __warp_usrid_01_r: felt) -> (__warp_usrid_01_r: felt) {
        alloc_locals;

        let (__warp_se_1530) = warp_ge256(__warp_usrid_00_x, Uint256(low=256, high=0));

        if (__warp_se_1530 != 0) {
            let (__warp_se_1531) = warp_shr256(__warp_usrid_00_x, 8);

            let __warp_usrid_00_x = __warp_se_1531;

            let (__warp_se_1532) = warp_add_unsafe8(__warp_usrid_01_r, 8);

            let __warp_usrid_01_r = __warp_se_1532;

            let (
                __warp_se_1533
            ) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1533,);
        } else {
            let (
                __warp_se_1534
            ) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1534,);
        }
    }

    func mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_00_x: Uint256, __warp_usrid_01_r: felt) -> (__warp_usrid_01_r: felt) {
        alloc_locals;

        let (__warp_se_1535) = warp_ge256(__warp_usrid_00_x, Uint256(low=16, high=0));

        if (__warp_se_1535 != 0) {
            let (__warp_se_1536) = warp_shr256(__warp_usrid_00_x, 4);

            let __warp_usrid_00_x = __warp_se_1536;

            let (__warp_se_1537) = warp_add_unsafe8(__warp_usrid_01_r, 4);

            let __warp_usrid_01_r = __warp_se_1537;

            let (
                __warp_se_1538
            ) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1538,);
        } else {
            let (
                __warp_se_1539
            ) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1539,);
        }
    }

    func mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_00_x: Uint256, __warp_usrid_01_r: felt) -> (__warp_usrid_01_r: felt) {
        alloc_locals;

        let (__warp_se_1540) = warp_ge256(__warp_usrid_00_x, Uint256(low=4, high=0));

        if (__warp_se_1540 != 0) {
            let (__warp_se_1541) = warp_shr256(__warp_usrid_00_x, 2);

            let __warp_usrid_00_x = __warp_se_1541;

            let (__warp_se_1542) = warp_add_unsafe8(__warp_usrid_01_r, 2);

            let __warp_usrid_01_r = __warp_se_1542;

            let (
                __warp_se_1543
            ) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1543,);
        } else {
            let (
                __warp_se_1544
            ) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_00_x, __warp_usrid_01_r
            );

            return (__warp_se_1544,);
        }
    }

    func mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_00_x: Uint256, __warp_usrid_01_r: felt) -> (__warp_usrid_01_r: felt) {
        alloc_locals;

        let (__warp_se_1545) = warp_ge256(__warp_usrid_00_x, Uint256(low=2, high=0));

        if (__warp_se_1545 != 0) {
            let (__warp_se_1546) = warp_add_unsafe8(__warp_usrid_01_r, 1);

            let __warp_usrid_01_r = __warp_se_1546;

            let (
                __warp_se_1547
            ) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_01_r
            );

            return (__warp_se_1547,);
        } else {
            let (
                __warp_se_1548
            ) = mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_01_r
            );

            return (__warp_se_1548,);
        }
    }

    func mostSignificantBit_e6bcbc65_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
        __warp_usrid_01_r: felt
    ) -> (__warp_usrid_01_r: felt) {
        alloc_locals;

        return (__warp_usrid_01_r,);
    }

    // @notice Returns the index of the least significant bit of the number,
    //     where the least significant bit is at index 0 and the most significant bit is at index 255
    // @dev The function satisfies the property:
    //     (x & 2**leastSignificantBit(x)) != 0 and (x & (2**(leastSignificantBit(x)) - 1)) == 0)
    // @param x the value for which to compute the least significant bit, must be greater than 0
    // @return r the index of the least significant bit
    func leastSignificantBit_d230d23f{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_02_x: Uint256
    ) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let __warp_usrid_03_r = 0;

        let (__warp_se_1549) = warp_gt256(__warp_usrid_02_x, Uint256(low=0, high=0));

        assert __warp_se_1549 = 1;

        let __warp_usrid_03_r = 255;

        let (__warp_se_1550) = warp_uint256(340282366920938463463374607431768211455);

        let (__warp_se_1551) = warp_bitwise_and256(__warp_usrid_02_x, __warp_se_1550);

        let (__warp_se_1552) = warp_gt256(__warp_se_1551, Uint256(low=0, high=0));

        if (__warp_se_1552 != 0) {
            let (__warp_se_1553) = warp_sub_unsafe8(__warp_usrid_03_r, 128);

            let __warp_usrid_03_r = __warp_se_1553;

            let (__warp_se_1554) = leastSignificantBit_d230d23f_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1554,);
        } else {
            let (__warp_se_1555) = warp_shr256(__warp_usrid_02_x, 128);

            let __warp_usrid_02_x = __warp_se_1555;

            let (__warp_se_1556) = leastSignificantBit_d230d23f_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1556,);
        }
    }

    func leastSignificantBit_d230d23f_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt
    ) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_1557) = warp_uint256(18446744073709551615);

        let (__warp_se_1558) = warp_bitwise_and256(__warp_usrid_02_x, __warp_se_1557);

        let (__warp_se_1559) = warp_gt256(__warp_se_1558, Uint256(low=0, high=0));

        if (__warp_se_1559 != 0) {
            let (__warp_se_1560) = warp_sub_unsafe8(__warp_usrid_03_r, 64);

            let __warp_usrid_03_r = __warp_se_1560;

            let (__warp_se_1561) = leastSignificantBit_d230d23f_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1561,);
        } else {
            let (__warp_se_1562) = warp_shr256(__warp_usrid_02_x, 64);

            let __warp_usrid_02_x = __warp_se_1562;

            let (__warp_se_1563) = leastSignificantBit_d230d23f_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1563,);
        }
    }

    func leastSignificantBit_d230d23f_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_1564) = warp_uint256(4294967295);

        let (__warp_se_1565) = warp_bitwise_and256(__warp_usrid_02_x, __warp_se_1564);

        let (__warp_se_1566) = warp_gt256(__warp_se_1565, Uint256(low=0, high=0));

        if (__warp_se_1566 != 0) {
            let (__warp_se_1567) = warp_sub_unsafe8(__warp_usrid_03_r, 32);

            let __warp_usrid_03_r = __warp_se_1567;

            let (__warp_se_1568) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1568,);
        } else {
            let (__warp_se_1569) = warp_shr256(__warp_usrid_02_x, 32);

            let __warp_usrid_02_x = __warp_se_1569;

            let (__warp_se_1570) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1570,);
        }
    }

    func leastSignificantBit_d230d23f_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_1571) = warp_uint256(65535);

        let (__warp_se_1572) = warp_bitwise_and256(__warp_usrid_02_x, __warp_se_1571);

        let (__warp_se_1573) = warp_gt256(__warp_se_1572, Uint256(low=0, high=0));

        if (__warp_se_1573 != 0) {
            let (__warp_se_1574) = warp_sub_unsafe8(__warp_usrid_03_r, 16);

            let __warp_usrid_03_r = __warp_se_1574;

            let (__warp_se_1575) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1575,);
        } else {
            let (__warp_se_1576) = warp_shr256(__warp_usrid_02_x, 16);

            let __warp_usrid_02_x = __warp_se_1576;

            let (__warp_se_1577) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1577,);
        }
    }

    func leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_1578) = warp_uint256(255);

        let (__warp_se_1579) = warp_bitwise_and256(__warp_usrid_02_x, __warp_se_1578);

        let (__warp_se_1580) = warp_gt256(__warp_se_1579, Uint256(low=0, high=0));

        if (__warp_se_1580 != 0) {
            let (__warp_se_1581) = warp_sub_unsafe8(__warp_usrid_03_r, 8);

            let __warp_usrid_03_r = __warp_se_1581;

            let (
                __warp_se_1582
            ) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1582,);
        } else {
            let (__warp_se_1583) = warp_shr256(__warp_usrid_02_x, 8);

            let __warp_usrid_02_x = __warp_se_1583;

            let (
                __warp_se_1584
            ) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1584,);
        }
    }

    func leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_1585) = warp_bitwise_and256(__warp_usrid_02_x, Uint256(low=15, high=0));

        let (__warp_se_1586) = warp_gt256(__warp_se_1585, Uint256(low=0, high=0));

        if (__warp_se_1586 != 0) {
            let (__warp_se_1587) = warp_sub_unsafe8(__warp_usrid_03_r, 4);

            let __warp_usrid_03_r = __warp_se_1587;

            let (
                __warp_se_1588
            ) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1588,);
        } else {
            let (__warp_se_1589) = warp_shr256(__warp_usrid_02_x, 4);

            let __warp_usrid_02_x = __warp_se_1589;

            let (
                __warp_se_1590
            ) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1590,);
        }
    }

    func leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_1591) = warp_bitwise_and256(__warp_usrid_02_x, Uint256(low=3, high=0));

        let (__warp_se_1592) = warp_gt256(__warp_se_1591, Uint256(low=0, high=0));

        if (__warp_se_1592 != 0) {
            let (__warp_se_1593) = warp_sub_unsafe8(__warp_usrid_03_r, 2);

            let __warp_usrid_03_r = __warp_se_1593;

            let (
                __warp_se_1594
            ) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1594,);
        } else {
            let (__warp_se_1595) = warp_shr256(__warp_usrid_02_x, 2);

            let __warp_usrid_02_x = __warp_se_1595;

            let (
                __warp_se_1596
            ) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_02_x, __warp_usrid_03_r
            );

            return (__warp_se_1596,);
        }
    }

    func leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(__warp_usrid_02_x: Uint256, __warp_usrid_03_r: felt) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        let (__warp_se_1597) = warp_bitwise_and256(__warp_usrid_02_x, Uint256(low=1, high=0));

        let (__warp_se_1598) = warp_gt256(__warp_se_1597, Uint256(low=0, high=0));

        if (__warp_se_1598 != 0) {
            let (__warp_se_1599) = warp_sub_unsafe8(__warp_usrid_03_r, 1);

            let __warp_usrid_03_r = __warp_se_1599;

            let (
                __warp_se_1600
            ) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_03_r
            );

            return (__warp_se_1600,);
        } else {
            let (
                __warp_se_1601
            ) = leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_03_r
            );

            return (__warp_se_1601,);
        }
    }

    func leastSignificantBit_d230d23f_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1_if_part1(
        __warp_usrid_03_r: felt
    ) -> (__warp_usrid_03_r: felt) {
        alloc_locals;

        return (__warp_usrid_03_r,);
    }

    // @notice Transfers tokens from msg.sender to a recipient
    // @dev Calls transfer on token contract, errors with TF if transfer fails
    // @param token The contract address of the token which will be transferred
    // @param to The recipient of the transfer
    // @param value The value of the transfer
    func safeTransfer_d1660f99{syscall_ptr: felt*, range_check_ptr: felt}(
        __warp_usrid_00_token: felt, __warp_usrid_01_to: felt, __warp_usrid_02_value: Uint256
    ) -> () {
        alloc_locals;

        let (__warp_usrid_03_data) = IERC20Minimal_warped_interface.transfer_a9059cbb(
            __warp_usrid_00_token, __warp_usrid_01_to, __warp_usrid_02_value
        );

        with_attr error_message("TF") {
            assert __warp_usrid_03_data = 1;
        }

        return ();
    }

    // @notice Computes the result of swapping some amount in, or amount out, given the parameters of the swap
    // @dev The fee, plus the amount in, will never exceed the amount remaining if the swap's `amountSpecified` is positive
    // @param sqrtRatioCurrentX96 The current sqrt price of the pool
    // @param sqrtRatioTargetX96 The price that cannot be exceeded, from which the direction of the swap is inferred
    // @param liquidity The usable liquidity
    // @param amountRemaining How much input or output amount is remaining to be swapped in/out
    // @param feePips The fee taken from the input amount, expressed in hundredths of a bip
    // @return sqrtRatioNextX96 The price after swapping the amount in/out, not to exceed the price target
    // @return amountIn The amount to be swapped in, of either token0 or token1, based on the direction of the swap
    // @return amountOut The amount to be received, of either token0 or token1, based on the direction of the swap
    // @return feeAmount The amount of input that will be taken as a fee
    func computeSwapStep_100d3f74{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_00_sqrtRatioCurrentX96: felt,
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_02_liquidity: felt,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let __warp_usrid_08_feeAmount = Uint256(low=0, high=0);

        let __warp_usrid_07_amountOut = Uint256(low=0, high=0);

        let __warp_usrid_05_sqrtRatioNextX96 = 0;

        let __warp_usrid_06_amountIn = Uint256(low=0, high=0);

        let (__warp_usrid_09_zeroForOne) = warp_ge(
            __warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_01_sqrtRatioTargetX96
        );

        let (__warp_usrid_10_exactIn) = warp_ge_signed256(
            __warp_usrid_03_amountRemaining, Uint256(low=0, high=0)
        );

        if (__warp_usrid_10_exactIn != 0) {
            let (__warp_se_1602) = warp_sub_unsafe24(1000000, __warp_usrid_04_feePips);

            let (__warp_se_1603) = warp_uint256(__warp_se_1602);

            let (__warp_usrid_11_amountRemainingLessFee) = mulDiv_aa9a0912(
                __warp_usrid_03_amountRemaining, __warp_se_1603, Uint256(low=1000000, high=0)
            );

            if (__warp_usrid_09_zeroForOne != 0) {
                let (__warp_se_1604) = getAmount0Delta_2c32d4b6(
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_02_liquidity,
                    1,
                );

                let __warp_usrid_06_amountIn = __warp_se_1604;

                let (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                ) = computeSwapStep_100d3f74_if_part2(
                    __warp_usrid_11_amountRemainingLessFee,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_02_liquidity,
                    __warp_usrid_09_zeroForOne,
                    __warp_usrid_10_exactIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_03_amountRemaining,
                    __warp_usrid_08_feeAmount,
                    __warp_usrid_04_feePips,
                );

                return (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                );
            } else {
                let (__warp_se_1605) = getAmount1Delta_48a0c5bd(
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_02_liquidity,
                    1,
                );

                let __warp_usrid_06_amountIn = __warp_se_1605;

                let (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                ) = computeSwapStep_100d3f74_if_part2(
                    __warp_usrid_11_amountRemainingLessFee,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_02_liquidity,
                    __warp_usrid_09_zeroForOne,
                    __warp_usrid_10_exactIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_03_amountRemaining,
                    __warp_usrid_08_feeAmount,
                    __warp_usrid_04_feePips,
                );

                return (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                );
            }
        } else {
            if (__warp_usrid_09_zeroForOne != 0) {
                let (__warp_se_1606) = getAmount1Delta_48a0c5bd(
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_02_liquidity,
                    0,
                );

                let __warp_usrid_07_amountOut = __warp_se_1606;

                let (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                ) = computeSwapStep_100d3f74_if_part3(
                    __warp_usrid_03_amountRemaining,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_02_liquidity,
                    __warp_usrid_09_zeroForOne,
                    __warp_usrid_10_exactIn,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_08_feeAmount,
                    __warp_usrid_04_feePips,
                );

                return (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                );
            } else {
                let (__warp_se_1607) = getAmount0Delta_2c32d4b6(
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_02_liquidity,
                    0,
                );

                let __warp_usrid_07_amountOut = __warp_se_1607;

                let (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                ) = computeSwapStep_100d3f74_if_part3(
                    __warp_usrid_03_amountRemaining,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_02_liquidity,
                    __warp_usrid_09_zeroForOne,
                    __warp_usrid_10_exactIn,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_08_feeAmount,
                    __warp_usrid_04_feePips,
                );

                return (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                );
            }
        }
    }

    func computeSwapStep_100d3f74_if_part3{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_00_sqrtRatioCurrentX96: felt,
        __warp_usrid_02_liquidity: felt,
        __warp_usrid_09_zeroForOne: felt,
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_1608) = warp_negate256(__warp_usrid_03_amountRemaining);

        let (__warp_se_1609) = warp_ge256(__warp_se_1608, __warp_usrid_07_amountOut);

        if (__warp_se_1609 != 0) {
            let __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_01_sqrtRatioTargetX96;

            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part3_if_part1(
                __warp_usrid_01_sqrtRatioTargetX96,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_09_zeroForOne,
                __warp_usrid_10_exactIn,
                __warp_usrid_06_amountIn,
                __warp_usrid_00_sqrtRatioCurrentX96,
                __warp_usrid_02_liquidity,
                __warp_usrid_07_amountOut,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_08_feeAmount,
                __warp_usrid_04_feePips,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        } else {
            let (__warp_se_1610) = warp_negate256(__warp_usrid_03_amountRemaining);

            let (__warp_se_1611) = getNextSqrtPriceFromOutput_fedf2b5f(
                __warp_usrid_00_sqrtRatioCurrentX96,
                __warp_usrid_02_liquidity,
                __warp_se_1610,
                __warp_usrid_09_zeroForOne,
            );

            let __warp_usrid_05_sqrtRatioNextX96 = __warp_se_1611;

            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part3_if_part1(
                __warp_usrid_01_sqrtRatioTargetX96,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_09_zeroForOne,
                __warp_usrid_10_exactIn,
                __warp_usrid_06_amountIn,
                __warp_usrid_00_sqrtRatioCurrentX96,
                __warp_usrid_02_liquidity,
                __warp_usrid_07_amountOut,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_08_feeAmount,
                __warp_usrid_04_feePips,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        }
    }

    func computeSwapStep_100d3f74_if_part3_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_09_zeroForOne: felt,
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_00_sqrtRatioCurrentX96: felt,
        __warp_usrid_02_liquidity: felt,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
        ) = computeSwapStep_100d3f74_if_part1(
            __warp_usrid_01_sqrtRatioTargetX96,
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_09_zeroForOne,
            __warp_usrid_10_exactIn,
            __warp_usrid_06_amountIn,
            __warp_usrid_00_sqrtRatioCurrentX96,
            __warp_usrid_02_liquidity,
            __warp_usrid_07_amountOut,
            __warp_usrid_03_amountRemaining,
            __warp_usrid_08_feeAmount,
            __warp_usrid_04_feePips,
        );

        return (
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
        );
    }

    func computeSwapStep_100d3f74_if_part2{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_11_amountRemainingLessFee: Uint256,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_00_sqrtRatioCurrentX96: felt,
        __warp_usrid_02_liquidity: felt,
        __warp_usrid_09_zeroForOne: felt,
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_1612) = warp_ge256(
            __warp_usrid_11_amountRemainingLessFee, __warp_usrid_06_amountIn
        );

        if (__warp_se_1612 != 0) {
            let __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_01_sqrtRatioTargetX96;

            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part2_if_part1(
                __warp_usrid_01_sqrtRatioTargetX96,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_09_zeroForOne,
                __warp_usrid_10_exactIn,
                __warp_usrid_06_amountIn,
                __warp_usrid_00_sqrtRatioCurrentX96,
                __warp_usrid_02_liquidity,
                __warp_usrid_07_amountOut,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_08_feeAmount,
                __warp_usrid_04_feePips,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        } else {
            let (__warp_se_1613) = getNextSqrtPriceFromInput_aa58276a(
                __warp_usrid_00_sqrtRatioCurrentX96,
                __warp_usrid_02_liquidity,
                __warp_usrid_11_amountRemainingLessFee,
                __warp_usrid_09_zeroForOne,
            );

            let __warp_usrid_05_sqrtRatioNextX96 = __warp_se_1613;

            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part2_if_part1(
                __warp_usrid_01_sqrtRatioTargetX96,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_09_zeroForOne,
                __warp_usrid_10_exactIn,
                __warp_usrid_06_amountIn,
                __warp_usrid_00_sqrtRatioCurrentX96,
                __warp_usrid_02_liquidity,
                __warp_usrid_07_amountOut,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_08_feeAmount,
                __warp_usrid_04_feePips,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        }
    }

    func computeSwapStep_100d3f74_if_part2_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_09_zeroForOne: felt,
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_00_sqrtRatioCurrentX96: felt,
        __warp_usrid_02_liquidity: felt,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
        ) = computeSwapStep_100d3f74_if_part1(
            __warp_usrid_01_sqrtRatioTargetX96,
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_09_zeroForOne,
            __warp_usrid_10_exactIn,
            __warp_usrid_06_amountIn,
            __warp_usrid_00_sqrtRatioCurrentX96,
            __warp_usrid_02_liquidity,
            __warp_usrid_07_amountOut,
            __warp_usrid_03_amountRemaining,
            __warp_usrid_08_feeAmount,
            __warp_usrid_04_feePips,
        );

        return (
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
        );
    }

    func computeSwapStep_100d3f74_if_part1{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_09_zeroForOne: felt,
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_00_sqrtRatioCurrentX96: felt,
        __warp_usrid_02_liquidity: felt,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_usrid_12_max) = warp_eq(
            __warp_usrid_01_sqrtRatioTargetX96, __warp_usrid_05_sqrtRatioNextX96
        );

        if (__warp_usrid_09_zeroForOne != 0) {
            let (__warp_se_1614) = warp_and_(__warp_usrid_12_max, __warp_usrid_10_exactIn);

            if (1 - __warp_se_1614 != 0) {
                let (__warp_se_1615) = getAmount0Delta_2c32d4b6(
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_02_liquidity,
                    1,
                );

                let __warp_usrid_06_amountIn = __warp_se_1615;

                let (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                ) = computeSwapStep_100d3f74_if_part1_if_part2(
                    __warp_usrid_12_max,
                    __warp_usrid_10_exactIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_02_liquidity,
                    __warp_usrid_03_amountRemaining,
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_08_feeAmount,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_04_feePips,
                );

                return (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                );
            } else {
                let (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                ) = computeSwapStep_100d3f74_if_part1_if_part2(
                    __warp_usrid_12_max,
                    __warp_usrid_10_exactIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_02_liquidity,
                    __warp_usrid_03_amountRemaining,
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_08_feeAmount,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_04_feePips,
                );

                return (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                );
            }
        } else {
            let (__warp_se_1616) = warp_and_(__warp_usrid_12_max, __warp_usrid_10_exactIn);

            if (1 - __warp_se_1616 != 0) {
                let (__warp_se_1617) = getAmount1Delta_48a0c5bd(
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_02_liquidity,
                    1,
                );

                let __warp_usrid_06_amountIn = __warp_se_1617;

                let (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                ) = computeSwapStep_100d3f74_if_part1_if_part3(
                    __warp_usrid_12_max,
                    __warp_usrid_10_exactIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_02_liquidity,
                    __warp_usrid_03_amountRemaining,
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_08_feeAmount,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_04_feePips,
                );

                return (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                );
            } else {
                let (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                ) = computeSwapStep_100d3f74_if_part1_if_part3(
                    __warp_usrid_12_max,
                    __warp_usrid_10_exactIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_00_sqrtRatioCurrentX96,
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_02_liquidity,
                    __warp_usrid_03_amountRemaining,
                    __warp_usrid_01_sqrtRatioTargetX96,
                    __warp_usrid_08_feeAmount,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_04_feePips,
                );

                return (
                    __warp_usrid_05_sqrtRatioNextX96,
                    __warp_usrid_06_amountIn,
                    __warp_usrid_07_amountOut,
                    __warp_usrid_08_feeAmount,
                );
            }
        }
    }

    func computeSwapStep_100d3f74_if_part1_if_part3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_max: felt,
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_00_sqrtRatioCurrentX96: felt,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_02_liquidity: felt,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_1618) = warp_and_(__warp_usrid_12_max, 1 - __warp_usrid_10_exactIn);

        if (1 - __warp_se_1618 != 0) {
            let (__warp_se_1619) = getAmount0Delta_2c32d4b6(
                __warp_usrid_00_sqrtRatioCurrentX96,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_02_liquidity,
                0,
            );

            let __warp_usrid_07_amountOut = __warp_se_1619;

            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part1_if_part3_if_part1(
                __warp_usrid_10_exactIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_01_sqrtRatioTargetX96,
                __warp_usrid_08_feeAmount,
                __warp_usrid_06_amountIn,
                __warp_usrid_04_feePips,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        } else {
            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part1_if_part3_if_part1(
                __warp_usrid_10_exactIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_01_sqrtRatioTargetX96,
                __warp_usrid_08_feeAmount,
                __warp_usrid_06_amountIn,
                __warp_usrid_04_feePips,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        }
    }

    func computeSwapStep_100d3f74_if_part1_if_part3_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
        ) = computeSwapStep_100d3f74_if_part1_if_part1(
            __warp_usrid_10_exactIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_03_amountRemaining,
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_01_sqrtRatioTargetX96,
            __warp_usrid_08_feeAmount,
            __warp_usrid_06_amountIn,
            __warp_usrid_04_feePips,
        );

        return (
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
        );
    }

    func computeSwapStep_100d3f74_if_part1_if_part2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_12_max: felt,
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_00_sqrtRatioCurrentX96: felt,
        __warp_usrid_02_liquidity: felt,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_1620) = warp_and_(__warp_usrid_12_max, 1 - __warp_usrid_10_exactIn);

        if (1 - __warp_se_1620 != 0) {
            let (__warp_se_1621) = getAmount1Delta_48a0c5bd(
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_00_sqrtRatioCurrentX96,
                __warp_usrid_02_liquidity,
                0,
            );

            let __warp_usrid_07_amountOut = __warp_se_1621;

            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part1_if_part2_if_part1(
                __warp_usrid_10_exactIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_01_sqrtRatioTargetX96,
                __warp_usrid_08_feeAmount,
                __warp_usrid_06_amountIn,
                __warp_usrid_04_feePips,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        } else {
            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part1_if_part2_if_part1(
                __warp_usrid_10_exactIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_01_sqrtRatioTargetX96,
                __warp_usrid_08_feeAmount,
                __warp_usrid_06_amountIn,
                __warp_usrid_04_feePips,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        }
    }

    func computeSwapStep_100d3f74_if_part1_if_part2_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
        ) = computeSwapStep_100d3f74_if_part1_if_part1(
            __warp_usrid_10_exactIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_03_amountRemaining,
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_01_sqrtRatioTargetX96,
            __warp_usrid_08_feeAmount,
            __warp_usrid_06_amountIn,
            __warp_usrid_04_feePips,
        );

        return (
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
        );
    }

    func computeSwapStep_100d3f74_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_04_feePips: felt,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_1622) = warp_negate256(__warp_usrid_03_amountRemaining);

        let (__warp_se_1623) = warp_gt256(__warp_usrid_07_amountOut, __warp_se_1622);

        let (__warp_se_1624) = warp_and_(1 - __warp_usrid_10_exactIn, __warp_se_1623);

        if (__warp_se_1624 != 0) {
            let (__warp_se_1625) = warp_negate256(__warp_usrid_03_amountRemaining);

            let __warp_usrid_07_amountOut = __warp_se_1625;

            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part1_if_part1_if_part1(
                __warp_usrid_10_exactIn,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_01_sqrtRatioTargetX96,
                __warp_usrid_08_feeAmount,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_06_amountIn,
                __warp_usrid_04_feePips,
                __warp_usrid_07_amountOut,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        } else {
            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part1_if_part1_if_part1(
                __warp_usrid_10_exactIn,
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_01_sqrtRatioTargetX96,
                __warp_usrid_08_feeAmount,
                __warp_usrid_03_amountRemaining,
                __warp_usrid_06_amountIn,
                __warp_usrid_04_feePips,
                __warp_usrid_07_amountOut,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        }
    }

    func computeSwapStep_100d3f74_if_part1_if_part1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
    }(
        __warp_usrid_10_exactIn: felt,
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_01_sqrtRatioTargetX96: felt,
        __warp_usrid_08_feeAmount: Uint256,
        __warp_usrid_03_amountRemaining: Uint256,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_04_feePips: felt,
        __warp_usrid_07_amountOut: Uint256,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_1626) = warp_neq(
            __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_01_sqrtRatioTargetX96
        );

        let (__warp_se_1627) = warp_and_(__warp_usrid_10_exactIn, __warp_se_1626);

        if (__warp_se_1627 != 0) {
            let (__warp_se_1628) = warp_sub_unsafe256(
                __warp_usrid_03_amountRemaining, __warp_usrid_06_amountIn
            );

            let __warp_usrid_08_feeAmount = __warp_se_1628;

            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        } else {
            let (__warp_se_1629) = warp_uint256(__warp_usrid_04_feePips);

            let (__warp_se_1630) = warp_sub_unsafe24(1000000, __warp_usrid_04_feePips);

            let (__warp_se_1631) = warp_uint256(__warp_se_1630);

            let (__warp_se_1632) = mulDivRoundingUp_0af8b27f(
                __warp_usrid_06_amountIn, __warp_se_1629, __warp_se_1631
            );

            let __warp_usrid_08_feeAmount = __warp_se_1632;

            let (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            ) = computeSwapStep_100d3f74_if_part1_if_part1_if_part1_if_part1(
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );

            return (
                __warp_usrid_05_sqrtRatioNextX96,
                __warp_usrid_06_amountIn,
                __warp_usrid_07_amountOut,
                __warp_usrid_08_feeAmount,
            );
        }
    }

    func computeSwapStep_100d3f74_if_part1_if_part1_if_part1_if_part1(
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) -> (
        __warp_usrid_05_sqrtRatioNextX96: felt,
        __warp_usrid_06_amountIn: Uint256,
        __warp_usrid_07_amountOut: Uint256,
        __warp_usrid_08_feeAmount: Uint256,
    ) {
        alloc_locals;

        let __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;

        let __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;

        let __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;

        let __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;

        return (
            __warp_usrid_05_sqrtRatioNextX96,
            __warp_usrid_06_amountIn,
            __warp_usrid_07_amountOut,
            __warp_usrid_08_feeAmount,
        );
    }
}

@external
func setFeeGrowthGlobal0X128_d380c679{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}(__warp_usrid_01__feeGrowthGlobal0X128: Uint256) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_01__feeGrowthGlobal0X128);

    WS_WRITE1(
        MockTimeUniswapV3Pool.__warp_usrid_041_feeGrowthGlobal0X128,
        __warp_usrid_01__feeGrowthGlobal0X128,
    );

    return ();
}

@external
func setFeeGrowthGlobal1X128_f6eb760f{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}(__warp_usrid_02__feeGrowthGlobal1X128: Uint256) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_02__feeGrowthGlobal1X128);

    WS_WRITE1(
        MockTimeUniswapV3Pool.__warp_usrid_042_feeGrowthGlobal1X128,
        __warp_usrid_02__feeGrowthGlobal1X128,
    );

    return ();
}

@external
func advanceTime_07e32f0a{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_03_by: Uint256
) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_03_by);

    let (__warp_se_614) = WS0_READ_Uint256(MockTimeUniswapV3Pool.__warp_usrid_00_time);

    let (__warp_se_615) = warp_add_unsafe256(__warp_se_614, __warp_usrid_03_by);

    WS_WRITE1(MockTimeUniswapV3Pool.__warp_usrid_00_time, __warp_se_615);

    return ();
}

@view
func time_16ada547{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_05_: Uint256
) {
    alloc_locals;

    let (__warp_se_618) = WS0_READ_Uint256(MockTimeUniswapV3Pool.__warp_usrid_00_time);

    return (__warp_se_618,);
}

@constructor
func constructor{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}() {
    alloc_locals;
    WARP_USED_STORAGE.write(262168);
    WARP_NAMEGEN.write(3);

    MockTimeUniswapV3Pool.__warp_constructor_0();

    MockTimeUniswapV3Pool.__warp_init_UniswapV3Pool();

    MockTimeUniswapV3Pool.__warp_constructor_1();

    MockTimeUniswapV3Pool.__warp_init_MockTimeUniswapV3Pool();

    return ();
}

@external
func setValues_8ff8bcfb{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_050__token0: felt,
    __warp_usrid_051__token1: felt,
    __warp_usrid_052__fee: felt,
    __warp_usrid_053__tickSpacing: felt,
) -> () {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_053__tickSpacing);

    warp_external_input_check_int24(__warp_usrid_052__fee);

    warp_external_input_check_address(__warp_usrid_051__token1);

    warp_external_input_check_address(__warp_usrid_050__token0);

    WS_WRITE0(MockTimeUniswapV3Pool.__warp_usrid_034_factory, 0);

    WS_WRITE0(MockTimeUniswapV3Pool.__warp_usrid_035_token0, __warp_usrid_050__token0);

    WS_WRITE0(MockTimeUniswapV3Pool.__warp_usrid_036_token1, __warp_usrid_051__token1);

    WS_WRITE0(MockTimeUniswapV3Pool.__warp_usrid_037_fee, __warp_usrid_052__fee);

    WS_WRITE0(MockTimeUniswapV3Pool.__warp_usrid_038_tickSpacing, __warp_usrid_053__tickSpacing);

    let (__warp_se_622) = MockTimeUniswapV3Pool.tickSpacingToMaxLiquidityPerTick_82c66f87(
        __warp_usrid_053__tickSpacing
    );

    WS_WRITE0(MockTimeUniswapV3Pool.__warp_usrid_039_maxLiquidityPerTick, __warp_se_622);

    return ();
}

// @inheritdoc IUniswapV3PoolDerivedState
@view
func snapshotCumulativesInside_a38807f2{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_059_tickLower: felt, __warp_usrid_060_tickUpper: felt) -> (
    __warp_usrid_061_tickCumulativeInside: felt,
    __warp_usrid_062_secondsPerLiquidityInsideX128: felt,
    __warp_usrid_063_secondsInside: felt,
) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        warp_external_input_check_int24(__warp_usrid_060_tickUpper);

        warp_external_input_check_int24(__warp_usrid_059_tickLower);

        let __warp_usrid_063_secondsInside = 0;

        let __warp_usrid_062_secondsPerLiquidityInsideX128 = 0;

        let __warp_usrid_061_tickCumulativeInside = 0;

        let (
            __warp_usrid_061_tickCumulativeInside,
            __warp_usrid_062_secondsPerLiquidityInsideX128,
            __warp_usrid_063_secondsInside,
        ) = MockTimeUniswapV3Pool.__warp_modifier_noDelegateCall_snapshotCumulativesInside_a38807f2_9(
            __warp_usrid_059_tickLower,
            __warp_usrid_060_tickUpper,
            __warp_usrid_061_tickCumulativeInside,
            __warp_usrid_062_secondsPerLiquidityInsideX128,
            __warp_usrid_063_secondsInside,
        );

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (
            __warp_usrid_061_tickCumulativeInside,
            __warp_usrid_062_secondsPerLiquidityInsideX128,
            __warp_usrid_063_secondsInside,
        );
    }
}

// @inheritdoc IUniswapV3PoolDerivedState
@view
func observe_883bdbfd{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_078_secondsAgos_len: felt, __warp_usrid_078_secondsAgos: felt*) -> (
    __warp_usrid_079_tickCumulatives_len: felt,
    __warp_usrid_079_tickCumulatives: felt*,
    __warp_usrid_080_secondsPerLiquidityCumulativeX128s_len: felt,
    __warp_usrid_080_secondsPerLiquidityCumulativeX128s: felt*,
) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check0(__warp_usrid_078_secondsAgos_len, __warp_usrid_078_secondsAgos);

        let (__warp_usrid_080_secondsPerLiquidityCumulativeX128s) = wm_new(
            Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        let (__warp_usrid_079_tickCumulatives) = wm_new(
            Uint256(low=0, high=0), Uint256(low=1, high=0)
        );

        local __warp_usrid_078_secondsAgos_dstruct: cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_078_secondsAgos_len, __warp_usrid_078_secondsAgos);

        let (
            __warp_td_133, __warp_td_134
        ) = MockTimeUniswapV3Pool.__warp_modifier_noDelegateCall_observe_883bdbfd_16(
            __warp_usrid_078_secondsAgos_dstruct,
            __warp_usrid_079_tickCumulatives,
            __warp_usrid_080_secondsPerLiquidityCumulativeX128s,
        );

        let __warp_usrid_079_tickCumulatives = __warp_td_133;

        let __warp_usrid_080_secondsPerLiquidityCumulativeX128s = __warp_td_134;

        let (__warp_se_632) = wm_to_calldata0(__warp_usrid_079_tickCumulatives);

        let (__warp_se_633) = wm_to_calldata3(__warp_usrid_080_secondsPerLiquidityCumulativeX128s);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (__warp_se_632.len, __warp_se_632.ptr, __warp_se_633.len, __warp_se_633.ptr);
    }
}

// @inheritdoc IUniswapV3PoolActions
@external
func increaseObservationCardinalityNext_32148f67{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_081_observationCardinalityNext: felt) -> () {
    alloc_locals;

    warp_external_input_check_int16(__warp_usrid_081_observationCardinalityNext);

    MockTimeUniswapV3Pool.__warp_modifier_lock_increaseObservationCardinalityNext_32148f67_21(
        __warp_usrid_081_observationCardinalityNext
    );

    return ();
}

// @inheritdoc IUniswapV3PoolActions
// @dev not locked because it initializes unlocked
@external
func initialize_f637731d{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_084_sqrtPriceX96: felt) -> () {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        warp_external_input_check_int160(__warp_usrid_084_sqrtPriceX96);

        let (__warp_se_634) = WSM8_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(
            MockTimeUniswapV3Pool.__warp_usrid_040_slot0
        );

        let (__warp_se_635) = WS1_READ_felt(__warp_se_634);

        let (__warp_se_636) = warp_eq(__warp_se_635, 0);

        with_attr error_message("AI") {
            assert __warp_se_636 = 1;
        }

        let (__warp_usrid_085_tick) = MockTimeUniswapV3Pool.getTickAtSqrtRatio_4f76c058(
            __warp_usrid_084_sqrtPriceX96
        );

        let (__warp_se_637) = MockTimeUniswapV3Pool._blockTimestamp_c63aa3e7();

        let (
            __warp_usrid_086_cardinality, __warp_usrid_087_cardinalityNext
        ) = MockTimeUniswapV3Pool.initialize_286f3ae4(
            MockTimeUniswapV3Pool.__warp_usrid_048_observations, __warp_se_637
        );

        let (__warp_se_638) = WM4_struct_Slot0_930d2817(
            __warp_usrid_084_sqrtPriceX96,
            __warp_usrid_085_tick,
            0,
            __warp_usrid_086_cardinality,
            __warp_usrid_087_cardinalityNext,
            0,
            1,
        );

        wm_to_storage0(MockTimeUniswapV3Pool.__warp_usrid_040_slot0, __warp_se_638);

        Initialize_98636036.emit(__warp_usrid_084_sqrtPriceX96, __warp_usrid_085_tick);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return ();
    }
}

// @inheritdoc IUniswapV3PoolActions
// @dev noDelegateCall is applied indirectly via _modifyPosition
@external
func mint_3c8a7d8d{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_109_recipient: felt,
    __warp_usrid_110_tickLower: felt,
    __warp_usrid_111_tickUpper: felt,
    __warp_usrid_112_amount: felt,
    __warp_usrid_113_data_len: felt,
    __warp_usrid_113_data: felt*,
) -> (__warp_usrid_114_amount0: Uint256, __warp_usrid_115_amount1: Uint256) {
    alloc_locals;
    let (local keccak_ptr_start: felt*) = alloc();
    let keccak_ptr = keccak_ptr_start;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory, keccak_ptr {
        extern_input_check1(__warp_usrid_113_data_len, __warp_usrid_113_data);

        warp_external_input_check_int128(__warp_usrid_112_amount);

        warp_external_input_check_int24(__warp_usrid_111_tickUpper);

        warp_external_input_check_int24(__warp_usrid_110_tickLower);

        warp_external_input_check_address(__warp_usrid_109_recipient);

        let __warp_usrid_115_amount1 = Uint256(low=0, high=0);

        let __warp_usrid_114_amount0 = Uint256(low=0, high=0);

        local __warp_usrid_113_data_dstruct: cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_113_data_len, __warp_usrid_113_data);

        let (
            __warp_usrid_114_amount0, __warp_usrid_115_amount1
        ) = MockTimeUniswapV3Pool.__warp_modifier_lock_mint_3c8a7d8d_41(
            __warp_usrid_109_recipient,
            __warp_usrid_110_tickLower,
            __warp_usrid_111_tickUpper,
            __warp_usrid_112_amount,
            __warp_usrid_113_data_dstruct,
            __warp_usrid_114_amount0,
            __warp_usrid_115_amount1,
        );

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        finalize_keccak(keccak_ptr_start, keccak_ptr);

        return (__warp_usrid_114_amount0, __warp_usrid_115_amount1);
    }
}

// @inheritdoc IUniswapV3PoolActions
@external
func collect_4f1eb3d8{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_120_recipient: felt,
    __warp_usrid_121_tickLower: felt,
    __warp_usrid_122_tickUpper: felt,
    __warp_usrid_123_amount0Requested: felt,
    __warp_usrid_124_amount1Requested: felt,
) -> (__warp_usrid_125_amount0: felt, __warp_usrid_126_amount1: felt) {
    alloc_locals;
    let (local keccak_ptr_start: felt*) = alloc();
    let keccak_ptr = keccak_ptr_start;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory, keccak_ptr {
        warp_external_input_check_int128(__warp_usrid_124_amount1Requested);

        warp_external_input_check_int128(__warp_usrid_123_amount0Requested);

        warp_external_input_check_int24(__warp_usrid_122_tickUpper);

        warp_external_input_check_int24(__warp_usrid_121_tickLower);

        warp_external_input_check_address(__warp_usrid_120_recipient);

        let __warp_usrid_126_amount1 = 0;

        let __warp_usrid_125_amount0 = 0;

        let (
            __warp_usrid_125_amount0, __warp_usrid_126_amount1
        ) = MockTimeUniswapV3Pool.__warp_modifier_lock_collect_4f1eb3d8_52(
            __warp_usrid_120_recipient,
            __warp_usrid_121_tickLower,
            __warp_usrid_122_tickUpper,
            __warp_usrid_123_amount0Requested,
            __warp_usrid_124_amount1Requested,
            __warp_usrid_125_amount0,
            __warp_usrid_126_amount1,
        );

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        finalize_keccak(keccak_ptr_start, keccak_ptr);

        return (__warp_usrid_125_amount0, __warp_usrid_126_amount1);
    }
}

// @inheritdoc IUniswapV3PoolActions
// @dev noDelegateCall is applied indirectly via _modifyPosition
@external
func burn_a34123a7{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_128_tickLower: felt,
    __warp_usrid_129_tickUpper: felt,
    __warp_usrid_130_amount: felt,
) -> (__warp_usrid_131_amount0: Uint256, __warp_usrid_132_amount1: Uint256) {
    alloc_locals;
    let (local keccak_ptr_start: felt*) = alloc();
    let keccak_ptr = keccak_ptr_start;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory, keccak_ptr {
        warp_external_input_check_int128(__warp_usrid_130_amount);

        warp_external_input_check_int24(__warp_usrid_129_tickUpper);

        warp_external_input_check_int24(__warp_usrid_128_tickLower);

        let __warp_usrid_132_amount1 = Uint256(low=0, high=0);

        let __warp_usrid_131_amount0 = Uint256(low=0, high=0);

        let (
            __warp_usrid_131_amount0, __warp_usrid_132_amount1
        ) = MockTimeUniswapV3Pool.__warp_modifier_lock_burn_a34123a7_61(
            __warp_usrid_128_tickLower,
            __warp_usrid_129_tickUpper,
            __warp_usrid_130_amount,
            __warp_usrid_131_amount0,
            __warp_usrid_132_amount1,
        );

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        finalize_keccak(keccak_ptr_start, keccak_ptr);

        return (__warp_usrid_131_amount0, __warp_usrid_132_amount1);
    }
}

// @inheritdoc IUniswapV3PoolActions
@external
func swap_128acb08{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_136_recipient: felt,
    __warp_usrid_137_zeroForOne: felt,
    __warp_usrid_138_amountSpecified: Uint256,
    __warp_usrid_139_sqrtPriceLimitX96: felt,
    __warp_usrid_140_data_len: felt,
    __warp_usrid_140_data: felt*,
) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check1(__warp_usrid_140_data_len, __warp_usrid_140_data);

        warp_external_input_check_int160(__warp_usrid_139_sqrtPriceLimitX96);

        warp_external_input_check_int256(__warp_usrid_138_amountSpecified);

        warp_external_input_check_bool(__warp_usrid_137_zeroForOne);

        warp_external_input_check_address(__warp_usrid_136_recipient);

        let __warp_usrid_142_amount1 = Uint256(low=0, high=0);

        let __warp_usrid_141_amount0 = Uint256(low=0, high=0);

        local __warp_usrid_140_data_dstruct: cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_140_data_len, __warp_usrid_140_data);

        let (
            __warp_usrid_141_amount0, __warp_usrid_142_amount1
        ) = MockTimeUniswapV3Pool.__warp_modifier_noDelegateCall_swap_128acb08_72(
            __warp_usrid_136_recipient,
            __warp_usrid_137_zeroForOne,
            __warp_usrid_138_amountSpecified,
            __warp_usrid_139_sqrtPriceLimitX96,
            __warp_usrid_140_data_dstruct,
            __warp_usrid_141_amount0,
            __warp_usrid_142_amount1,
        );

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (__warp_usrid_141_amount0, __warp_usrid_142_amount1);
    }
}

// @inheritdoc IUniswapV3PoolActions
@external
func flash_490e6cbc{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_175_recipient: felt,
    __warp_usrid_176_amount0: Uint256,
    __warp_usrid_177_amount1: Uint256,
    __warp_usrid_178_data_len: felt,
    __warp_usrid_178_data: felt*,
) -> () {
    alloc_locals;

    extern_input_check1(__warp_usrid_178_data_len, __warp_usrid_178_data);

    warp_external_input_check_int256(__warp_usrid_177_amount1);

    warp_external_input_check_int256(__warp_usrid_176_amount0);

    warp_external_input_check_address(__warp_usrid_175_recipient);

    local __warp_usrid_178_data_dstruct: cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_178_data_len, __warp_usrid_178_data);

    MockTimeUniswapV3Pool.__warp_modifier_lock_flash_490e6cbc_83(
        __warp_usrid_175_recipient,
        __warp_usrid_176_amount0,
        __warp_usrid_177_amount1,
        __warp_usrid_178_data_dstruct,
    );

    return ();
}

// @inheritdoc IUniswapV3PoolOwnerActions
@external
func setFeeProtocol_8206a4d1{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_192_feeProtocol0: felt, __warp_usrid_193_feeProtocol1: felt) -> () {
    alloc_locals;

    warp_external_input_check_int8(__warp_usrid_193_feeProtocol1);

    warp_external_input_check_int8(__warp_usrid_192_feeProtocol0);

    MockTimeUniswapV3Pool.__warp_modifier_lock_setFeeProtocol_8206a4d1_90(
        __warp_usrid_192_feeProtocol0, __warp_usrid_193_feeProtocol1
    );

    return ();
}

// @inheritdoc IUniswapV3PoolOwnerActions
@external
func collectProtocol_85b66729{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_195_recipient: felt,
    __warp_usrid_196_amount0Requested: felt,
    __warp_usrid_197_amount1Requested: felt,
) -> (__warp_usrid_198_amount0: felt, __warp_usrid_199_amount1: felt) {
    alloc_locals;

    warp_external_input_check_int128(__warp_usrid_197_amount1Requested);

    warp_external_input_check_int128(__warp_usrid_196_amount0Requested);

    warp_external_input_check_address(__warp_usrid_195_recipient);

    let __warp_usrid_199_amount1 = 0;

    let __warp_usrid_198_amount0 = 0;

    let (
        __warp_usrid_198_amount0, __warp_usrid_199_amount1
    ) = MockTimeUniswapV3Pool.__warp_modifier_lock_collectProtocol_85b66729_107(
        __warp_usrid_195_recipient,
        __warp_usrid_196_amount0Requested,
        __warp_usrid_197_amount1Requested,
        __warp_usrid_198_amount0,
        __warp_usrid_199_amount1,
    );

    return (__warp_usrid_198_amount0, __warp_usrid_199_amount1);
}

@view
func loopRuns_67e0b647{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_200_: Uint256
) {
    alloc_locals;

    let (__warp_se_687) = WS0_READ_Uint256(MockTimeUniswapV3Pool.__warp_usrid_033_loopRuns);

    return (__warp_se_687,);
}

@view
func factory_c45a0155{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_201_: felt
) {
    alloc_locals;

    let (__warp_se_688) = WS1_READ_felt(MockTimeUniswapV3Pool.__warp_usrid_034_factory);

    return (__warp_se_688,);
}

@view
func token0_0dfe1681{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_202_: felt
) {
    alloc_locals;

    let (__warp_se_689) = WS1_READ_felt(MockTimeUniswapV3Pool.__warp_usrid_035_token0);

    return (__warp_se_689,);
}

@view
func token1_d21220a7{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_203_: felt
) {
    alloc_locals;

    let (__warp_se_690) = WS1_READ_felt(MockTimeUniswapV3Pool.__warp_usrid_036_token1);

    return (__warp_se_690,);
}

@view
func fee_ddca3f43{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_204_: felt
) {
    alloc_locals;

    let (__warp_se_691) = WS1_READ_felt(MockTimeUniswapV3Pool.__warp_usrid_037_fee);

    return (__warp_se_691,);
}

@view
func tickSpacing_d0c93a7c{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    ) -> (__warp_usrid_205_: felt) {
    alloc_locals;

    let (__warp_se_692) = WS1_READ_felt(MockTimeUniswapV3Pool.__warp_usrid_038_tickSpacing);

    return (__warp_se_692,);
}

@view
func maxLiquidityPerTick_70cf754a{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}() -> (__warp_usrid_206_: felt) {
    alloc_locals;

    let (__warp_se_693) = WS1_READ_felt(MockTimeUniswapV3Pool.__warp_usrid_039_maxLiquidityPerTick);

    return (__warp_se_693,);
}

@view
func slot0_3850c7bd{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_207_: felt,
    __warp_usrid_208_: felt,
    __warp_usrid_209_: felt,
    __warp_usrid_210_: felt,
    __warp_usrid_211_: felt,
    __warp_usrid_212_: felt,
    __warp_usrid_213_: felt,
) {
    alloc_locals;

    let __warp_usrid_214__temp0 = MockTimeUniswapV3Pool.__warp_usrid_040_slot0;

    let (__warp_se_694) = WSM8_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(
        __warp_usrid_214__temp0
    );

    let (__warp_usrid_207_) = WS1_READ_felt(__warp_se_694);

    let (__warp_se_695) = WSM7_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_214__temp0);

    let (__warp_usrid_208_) = WS1_READ_felt(__warp_se_695);

    let (__warp_se_696) = WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(
        __warp_usrid_214__temp0
    );

    let (__warp_usrid_209_) = WS1_READ_felt(__warp_se_696);

    let (__warp_se_697) = WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(
        __warp_usrid_214__temp0
    );

    let (__warp_usrid_210_) = WS1_READ_felt(__warp_se_697);

    let (__warp_se_698) = WSM11_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(
        __warp_usrid_214__temp0
    );

    let (__warp_usrid_211_) = WS1_READ_felt(__warp_se_698);

    let (__warp_se_699) = WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(__warp_usrid_214__temp0);

    let (__warp_usrid_212_) = WS1_READ_felt(__warp_se_699);

    let (__warp_se_700) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_214__temp0);

    let (__warp_usrid_213_) = WS1_READ_felt(__warp_se_700);

    return (
        __warp_usrid_207_,
        __warp_usrid_208_,
        __warp_usrid_209_,
        __warp_usrid_210_,
        __warp_usrid_211_,
        __warp_usrid_212_,
        __warp_usrid_213_,
    );
}

@view
func feeGrowthGlobal0X128_f3058399{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}() -> (__warp_usrid_215_: Uint256) {
    alloc_locals;

    let (__warp_se_701) = WS0_READ_Uint256(
        MockTimeUniswapV3Pool.__warp_usrid_041_feeGrowthGlobal0X128
    );

    return (__warp_se_701,);
}

@view
func feeGrowthGlobal1X128_46141319{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}() -> (__warp_usrid_216_: Uint256) {
    alloc_locals;

    let (__warp_se_702) = WS0_READ_Uint256(
        MockTimeUniswapV3Pool.__warp_usrid_042_feeGrowthGlobal1X128
    );

    return (__warp_se_702,);
}

@view
func protocolFees_1ad8b03b{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    ) -> (__warp_usrid_217_: felt, __warp_usrid_218_: felt) {
    alloc_locals;

    let __warp_usrid_219__temp0 = MockTimeUniswapV3Pool.__warp_usrid_043_protocolFees;

    let (__warp_se_703) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(
        __warp_usrid_219__temp0
    );

    let (__warp_usrid_217_) = WS1_READ_felt(__warp_se_703);

    let (__warp_se_704) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(
        __warp_usrid_219__temp0
    );

    let (__warp_usrid_218_) = WS1_READ_felt(__warp_se_704);

    return (__warp_usrid_217_, __warp_usrid_218_);
}

@view
func liquidity_1a686502{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    ) -> (__warp_usrid_220_: felt) {
    alloc_locals;

    let (__warp_se_705) = WS1_READ_felt(MockTimeUniswapV3Pool.__warp_usrid_044_liquidity);

    return (__warp_se_705,);
}

@view
func ticks_f30dba93{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_221__i0: felt
) -> (
    __warp_usrid_222_: felt,
    __warp_usrid_223_: felt,
    __warp_usrid_224_: Uint256,
    __warp_usrid_225_: Uint256,
    __warp_usrid_226_: felt,
    __warp_usrid_227_: felt,
    __warp_usrid_228_: felt,
    __warp_usrid_229_: felt,
) {
    alloc_locals;

    warp_external_input_check_int24(__warp_usrid_221__i0);

    let (__warp_usrid_230__temp0) = WS0_INDEX_felt_to_Info_39bc053d(
        MockTimeUniswapV3Pool.__warp_usrid_045_ticks, __warp_usrid_221__i0
    );

    let (__warp_se_706) = WSM16_Info_39bc053d___warp_usrid_00_liquidityGross(
        __warp_usrid_230__temp0
    );

    let (__warp_usrid_222_) = WS1_READ_felt(__warp_se_706);

    let (__warp_se_707) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(__warp_usrid_230__temp0);

    let (__warp_usrid_223_) = WS1_READ_felt(__warp_se_707);

    let (__warp_se_708) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(
        __warp_usrid_230__temp0
    );

    let (__warp_usrid_224_) = WS0_READ_Uint256(__warp_se_708);

    let (__warp_se_709) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(
        __warp_usrid_230__temp0
    );

    let (__warp_usrid_225_) = WS0_READ_Uint256(__warp_se_709);

    let (__warp_se_710) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(
        __warp_usrid_230__temp0
    );

    let (__warp_usrid_226_) = WS1_READ_felt(__warp_se_710);

    let (__warp_se_711) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(
        __warp_usrid_230__temp0
    );

    let (__warp_usrid_227_) = WS1_READ_felt(__warp_se_711);

    let (__warp_se_712) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(
        __warp_usrid_230__temp0
    );

    let (__warp_usrid_228_) = WS1_READ_felt(__warp_se_712);

    let (__warp_se_713) = WSM15_Info_39bc053d___warp_usrid_07_initialized(__warp_usrid_230__temp0);

    let (__warp_usrid_229_) = WS1_READ_felt(__warp_se_713);

    return (
        __warp_usrid_222_,
        __warp_usrid_223_,
        __warp_usrid_224_,
        __warp_usrid_225_,
        __warp_usrid_226_,
        __warp_usrid_227_,
        __warp_usrid_228_,
        __warp_usrid_229_,
    );
}

@view
func tickBitmap_5339c296{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_231__i0: felt
) -> (__warp_usrid_232_: Uint256) {
    alloc_locals;

    warp_external_input_check_int16(__warp_usrid_231__i0);

    let (__warp_se_714) = WS1_INDEX_felt_to_Uint256(
        MockTimeUniswapV3Pool.__warp_usrid_046_tickBitmap, __warp_usrid_231__i0
    );

    let (__warp_se_715) = WS0_READ_Uint256(__warp_se_714);

    return (__warp_se_715,);
}

@view
func positions_514ea4bf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_233__i0: Uint256
) -> (
    __warp_usrid_234_: felt,
    __warp_usrid_235_: Uint256,
    __warp_usrid_236_: Uint256,
    __warp_usrid_237_: felt,
    __warp_usrid_238_: felt,
) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_233__i0);

    let (__warp_usrid_239__temp0) = WS2_INDEX_Uint256_to_Info_d529aac3(
        MockTimeUniswapV3Pool.__warp_usrid_047_positions, __warp_usrid_233__i0
    );

    let (__warp_se_716) = WSM20_Info_d529aac3___warp_usrid_00_liquidity(__warp_usrid_239__temp0);

    let (__warp_usrid_234_) = WS1_READ_felt(__warp_se_716);

    let (__warp_se_717) = WSM21_Info_d529aac3___warp_usrid_01_feeGrowthInside0LastX128(
        __warp_usrid_239__temp0
    );

    let (__warp_usrid_235_) = WS0_READ_Uint256(__warp_se_717);

    let (__warp_se_718) = WSM22_Info_d529aac3___warp_usrid_02_feeGrowthInside1LastX128(
        __warp_usrid_239__temp0
    );

    let (__warp_usrid_236_) = WS0_READ_Uint256(__warp_se_718);

    let (__warp_se_719) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(__warp_usrid_239__temp0);

    let (__warp_usrid_237_) = WS1_READ_felt(__warp_se_719);

    let (__warp_se_720) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(__warp_usrid_239__temp0);

    let (__warp_usrid_238_) = WS1_READ_felt(__warp_se_720);

    return (
        __warp_usrid_234_,
        __warp_usrid_235_,
        __warp_usrid_236_,
        __warp_usrid_237_,
        __warp_usrid_238_,
    );
}

@view
func observations_252c09d7{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_240__i0: Uint256
) -> (
    __warp_usrid_241_: felt,
    __warp_usrid_242_: felt,
    __warp_usrid_243_: felt,
    __warp_usrid_244_: felt,
) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_240__i0);

    let (__warp_usrid_245__temp0) = WS0_IDX(
        MockTimeUniswapV3Pool.__warp_usrid_048_observations,
        __warp_usrid_240__i0,
        Uint256(low=4, high=0),
        Uint256(low=65535, high=0),
    );

    let (__warp_se_721) = WSM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(
        __warp_usrid_245__temp0
    );

    let (__warp_usrid_241_) = WS1_READ_felt(__warp_se_721);

    let (__warp_se_722) = WSM23_Observation_2cc4d695___warp_usrid_01_tickCumulative(
        __warp_usrid_245__temp0
    );

    let (__warp_usrid_242_) = WS1_READ_felt(__warp_se_722);

    let (
        __warp_se_723
    ) = WSM24_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(
        __warp_usrid_245__temp0
    );

    let (__warp_usrid_243_) = WS1_READ_felt(__warp_se_723);

    let (__warp_se_724) = WSM25_Observation_2cc4d695___warp_usrid_03_initialized(
        __warp_usrid_245__temp0
    );

    let (__warp_usrid_244_) = WS1_READ_felt(__warp_se_724);

    return (__warp_usrid_241_, __warp_usrid_242_, __warp_usrid_243_, __warp_usrid_244_);
}

// Contract Def IUniswapV3PoolDeployer@interface

@contract_interface
namespace IUniswapV3PoolDeployer_warped_interface {
    func parameters_89035730() -> (
        __warp_usrid_00_factory: felt,
        __warp_usrid_01_token0: felt,
        __warp_usrid_02_token1: felt,
        __warp_usrid_03_fee: felt,
        __warp_usrid_04_tickSpacing: felt,
    ) {
    }
}

// Contract Def IERC20Minimal@interface

@contract_interface
namespace IERC20Minimal_warped_interface {
    func balanceOf_70a08231(__warp_usrid_00_account: felt) -> (__warp_usrid_01_: Uint256) {
    }

    func transfer_a9059cbb(__warp_usrid_02_recipient: felt, __warp_usrid_03_amount: Uint256) -> (
        __warp_usrid_04_: felt
    ) {
    }

    func allowance_dd62ed3e(__warp_usrid_05_owner: felt, __warp_usrid_06_spender: felt) -> (
        __warp_usrid_07_: Uint256
    ) {
    }

    func approve_095ea7b3(__warp_usrid_08_spender: felt, __warp_usrid_09_amount: Uint256) -> (
        __warp_usrid_10_: felt
    ) {
    }

    func transferFrom_23b872dd(
        __warp_usrid_11_sender: felt,
        __warp_usrid_12_recipient: felt,
        __warp_usrid_13_amount: Uint256,
    ) -> (__warp_usrid_14_: felt) {
    }
}

// Contract Def IUniswapV3MintCallback@interface

@contract_interface
namespace IUniswapV3MintCallback_warped_interface {
    func uniswapV3MintCallback_d3487997(
        __warp_usrid_00_amount0Owed: Uint256,
        __warp_usrid_01_amount1Owed: Uint256,
        __warp_usrid_02_data_len: felt,
        __warp_usrid_02_data: felt*,
    ) -> () {
    }
}

// Contract Def IUniswapV3SwapCallback@interface

@contract_interface
namespace IUniswapV3SwapCallback_warped_interface {
    func uniswapV3SwapCallback_fa461e33(
        __warp_usrid_00_amount0Delta: Uint256,
        __warp_usrid_01_amount1Delta: Uint256,
        __warp_usrid_02_data_len: felt,
        __warp_usrid_02_data: felt*,
    ) -> () {
    }
}

// Contract Def IUniswapV3FlashCallback@interface

@contract_interface
namespace IUniswapV3FlashCallback_warped_interface {
    func uniswapV3FlashCallback_e9cbafb0(
        __warp_usrid_00_fee0: Uint256,
        __warp_usrid_01_fee1: Uint256,
        __warp_usrid_02_data_len: felt,
        __warp_usrid_02_data: felt*,
    ) -> () {
    }
}

// Contract Def IUniswapV3Factory@interface

@contract_interface
namespace IUniswapV3Factory_warped_interface {
    func owner_8da5cb5b() -> (__warp_usrid_09_: felt) {
    }

    func feeAmountTickSpacing_22afcccb(__warp_usrid_10_fee: felt) -> (__warp_usrid_11_: felt) {
    }

    func getPool_1698ee82(
        __warp_usrid_12_tokenA: felt, __warp_usrid_13_tokenB: felt, __warp_usrid_14_fee: felt
    ) -> (__warp_usrid_15_pool: felt) {
    }

    func createPool_a1671295(
        __warp_usrid_16_tokenA: felt, __warp_usrid_17_tokenB: felt, __warp_usrid_18_fee: felt
    ) -> (__warp_usrid_19_pool: felt) {
    }

    func setOwner_13af4035(__warp_usrid_20__owner: felt) -> () {
    }

    func enableFeeAmount_8a7c195f(__warp_usrid_21_fee: felt, __warp_usrid_22_tickSpacing: felt) -> (
        ) {
    }
}

// Original soldity abi: ["constructor()","setFeeGrowthGlobal0X128(uint256)","setFeeGrowthGlobal1X128(uint256)","advanceTime(uint256)","time()","","setValues(address,address,uint24,int24)","snapshotCumulativesInside(int24,int24)","observe(uint32[])","increaseObservationCardinalityNext(uint16)","initialize(uint160)","mint(address,int24,int24,uint128,bytes)","collect(address,int24,int24,uint128,uint128)","burn(int24,int24,uint128)","swap(address,bool,int256,uint160,bytes)","flash(address,uint256,uint256,bytes)","setFeeProtocol(uint8,uint8)","collectProtocol(address,uint128,uint128)","loopRuns()","factory()","token0()","token1()","fee()","tickSpacing()","maxLiquidityPerTick()","slot0()","feeGrowthGlobal0X128()","feeGrowthGlobal1X128()","protocolFees()","liquidity()","ticks(int24)","tickBitmap(int16)","positions(bytes32)","observations(uint256)"]
