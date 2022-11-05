%lang starknet


from warplib.memory import wm_read_felt, wm_alloc, wm_read_256, wm_write_felt, wm_new, wm_dyn_array_length, wm_index_dyn
from starkware.cairo.common.dict import dict_write, dict_read
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.uint256 import Uint256, uint256_sub, uint256_add, uint256_le, uint256_lt, uint256_mul
from starkware.cairo.common.alloc import alloc
from warplib.maths.utils import narrow_safe, felt_to_uint256
from starkware.cairo.common.math import split_felt
from warplib.maths.external_input_check_ints import warp_external_input_check_int32, warp_external_input_check_int24, warp_external_input_check_int128, warp_external_input_check_int16, warp_external_input_check_int256
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from warplib.maths.lt import warp_lt256, warp_lt
from warplib.maths.add_unsafe import warp_add_unsafe256, warp_add_unsafe16, warp_add_unsafe32, warp_add_unsafe160, warp_add_unsafe40
from warplib.maths.sub_unsafe import warp_sub_unsafe256, warp_sub_unsafe16, warp_sub_unsafe32, warp_sub_unsafe160
from warplib.maths.div_unsafe import warp_div_unsafe256, warp_div_unsafe
from warplib.maths.int_conversions import warp_uint256, warp_int256_to_int248, warp_int24_to_int56, warp_int32_to_int56, warp_int256_to_int160
from warplib.maths.mod import warp_mod256, warp_mod
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from warplib.maths.eq import warp_eq
from warplib.maths.mul_signed_unsafe import warp_mul_signed_unsafe56
from warplib.maths.add_signed_unsafe import warp_add_signed_unsafe56
from warplib.maths.shl import warp_shl160
from warplib.maths.gt import warp_gt
from warplib.maths.sub import warp_sub
from warplib.maths.le import warp_le, warp_le256
from warplib.maths.neq import warp_neq
from warplib.maths.sub_signed_unsafe import warp_sub_signed_unsafe56
from warplib.maths.div_signed_unsafe import warp_div_signed_unsafe56
from warplib.maths.mul_unsafe import warp_mul_unsafe256


struct Observation_2cc4d695{
    __warp_usrid_00_blockTimestamp : felt,
    __warp_usrid_01_tickCumulative : felt,
    __warp_usrid_02_secondsPerLiquidityCumulativeX128 : felt,
    __warp_usrid_03_initialized : felt,
}


struct InitializeParams_62e4fbcc{
    __warp_usrid_00_time : felt,
    __warp_usrid_01_tick : felt,
    __warp_usrid_02_liquidity : felt,
}


struct UpdateParams_a5eebe58{
    __warp_usrid_03_advanceTimeBy : felt,
    __warp_usrid_04_tick : felt,
    __warp_usrid_05_liquidity : felt,
}


struct cd_dynarray_UpdateParams_a5eebe58{
     len : felt ,
     ptr : UpdateParams_a5eebe58*,
}

struct cd_dynarray_felt{
     len : felt ,
     ptr : felt*,
}

func WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WM1_Observation_2cc4d695___warp_usrid_03_initialized(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WM0_struct_Observation_2cc4d695{range_check_ptr, warp_memory: DictAccess*}(__warp_usrid_00_blockTimestamp: felt, __warp_usrid_01_tickCumulative: felt, __warp_usrid_02_secondsPerLiquidityCumulativeX128: felt, __warp_usrid_03_initialized: felt) -> (res:felt){
    alloc_locals;
    let (start) = wm_alloc(Uint256(0x4, 0x0));
dict_write{dict_ptr=warp_memory}(start, __warp_usrid_00_blockTimestamp);
dict_write{dict_ptr=warp_memory}(start + 1, __warp_usrid_01_tickCumulative);
dict_write{dict_ptr=warp_memory}(start + 2, __warp_usrid_02_secondsPerLiquidityCumulativeX128);
dict_write{dict_ptr=warp_memory}(start + 3, __warp_usrid_03_initialized);
    return (start,);
}

func wm_to_calldata0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(mem_loc: felt) -> (retData: cd_dynarray_felt){
    alloc_locals;
    let (len_256) = wm_read_256(mem_loc);
    let (ptr : felt*) = alloc();
    let (len_felt) = narrow_safe(len_256);
    wm_to_calldata1(len_felt, ptr, mem_loc + 2);
    return (cd_dynarray_felt(len=len_felt, ptr=ptr),);
}


func wm_to_calldata1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(len: felt, ptr: felt*, mem_loc: felt) -> (){
    alloc_locals;
    if (len == 0){
         return ();
    }
let (mem_read0) = wm_read_felt(mem_loc);
assert ptr[0] = mem_read0;
    wm_to_calldata1(len=len - 1, ptr=ptr + 1, mem_loc=mem_loc + 1);
    return ();
}

func wm_to_calldata3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(mem_loc: felt) -> (retData: cd_dynarray_felt){
    alloc_locals;
    let (len_256) = wm_read_256(mem_loc);
    let (ptr : felt*) = alloc();
    let (len_felt) = narrow_safe(len_256);
    wm_to_calldata4(len_felt, ptr, mem_loc + 2);
    return (cd_dynarray_felt(len=len_felt, ptr=ptr),);
}


func wm_to_calldata4{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(len: felt, ptr: felt*, mem_loc: felt) -> (){
    alloc_locals;
    if (len == 0){
         return ();
    }
let (mem_read0) = wm_read_felt(mem_loc);
assert ptr[0] = mem_read0;
    wm_to_calldata4(len=len - 1, ptr=ptr + 1, mem_loc=mem_loc + 1);
    return ();
}

func wm_to_storage0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt, mem_loc: felt) -> (loc: felt){
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

func WSM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM1_Observation_2cc4d695___warp_usrid_01_tickCumulative(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WSM2_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WSM3_Observation_2cc4d695___warp_usrid_03_initialized(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WS0_READ_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func WS0_IDX{range_check_ptr}(loc: felt, index: Uint256, size: Uint256, limit: Uint256) -> (resLoc: felt){
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
    return (res256.low + 2**128 * res256.high,);
}

func ws_to_memory0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt) -> (mem_loc: felt){
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

func WS_WRITE0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: felt) -> (res: felt){
    WARP_STORAGE.write(loc, value);
    return (value,);
}

func extern_input_check0{range_check_ptr : felt}(arg : InitializeParams_62e4fbcc) -> (){
alloc_locals;
warp_external_input_check_int32(arg.__warp_usrid_00_time);
warp_external_input_check_int24(arg.__warp_usrid_01_tick);
warp_external_input_check_int128(arg.__warp_usrid_02_liquidity);
return ();
}

func extern_input_check1{range_check_ptr : felt}(arg : UpdateParams_a5eebe58) -> (){
alloc_locals;
warp_external_input_check_int32(arg.__warp_usrid_03_advanceTimeBy);
warp_external_input_check_int24(arg.__warp_usrid_04_tick);
warp_external_input_check_int128(arg.__warp_usrid_05_liquidity);
return ();
}

func extern_input_check2{range_check_ptr : felt}(len: felt, ptr : UpdateParams_a5eebe58*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
extern_input_check1(ptr[0]);
   extern_input_check2(len = len - 1, ptr = ptr + 3);
    return ();
}

func extern_input_check3{range_check_ptr : felt}(len: felt, ptr : felt*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
warp_external_input_check_int32(ptr[0]);
   extern_input_check3(len = len - 1, ptr = ptr + 1);
    return ();
}

func cd_to_memory0_elem{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(calldata: felt*, mem_start: felt, length: felt){
    alloc_locals;
    if (length == 0){
        return ();
    }
dict_write{dict_ptr=warp_memory}(mem_start, calldata[0]);
    return cd_to_memory0_elem(calldata + 1, mem_start + 1, length - 1);
}
func cd_to_memory0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(calldata : cd_dynarray_felt) -> (mem_loc: felt){
    alloc_locals;
    let (len256) = felt_to_uint256(calldata.len);
    let (mem_start) = wm_new(len256, Uint256(0x1, 0x0));
    cd_to_memory0_elem(calldata.ptr, mem_start + 2, calldata.len);
    return (mem_start,);
}


// Contract Def OracleTest


@storage_var
func WARP_STORAGE(index: felt) -> (val: felt){
}
@storage_var
func WARP_USED_STORAGE() -> (val: felt){
}
@storage_var
func WARP_NAMEGEN() -> (name: felt){
}
func readId{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (val: felt){
    alloc_locals;
    let (id) = WARP_STORAGE.read(loc);
    if (id == 0){
        let (id) = WARP_NAMEGEN.read();
        WARP_NAMEGEN.write(id + 1);
        WARP_STORAGE.write(loc, id + 1);
        return (id + 1,);
    }else{
        return (id,);
    }
}

namespace OracleTest{

    // Dynamic variables - Arrays and Maps

    // Static variables

    const __warp_usrid_06_observations = 0;

    const __warp_usrid_07_time = 262140;

    const __warp_usrid_08_tick = 262141;

    const __warp_usrid_09_liquidity = 262142;

    const __warp_usrid_10_index = 262143;

    const __warp_usrid_11_cardinality = 262144;

    const __warp_usrid_12_cardinalityNext = 262145;


    func __warp_while14{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_81_i : Uint256, __warp_usrid_74_secondsAgos : felt, __warp_usrid_79_tickCumulatives : felt, __warp_usrid_80_secondsPerLiquidityCumulativeX128s : felt, __warp_usrid_72_self : felt, __warp_usrid_73_time : felt, __warp_usrid_75_tick : felt, __warp_usrid_76_index : felt, __warp_usrid_77_liquidity : felt, __warp_usrid_78_cardinality : felt)-> (__warp_usrid_81_i : Uint256, __warp_usrid_74_secondsAgos : felt, __warp_usrid_79_tickCumulatives : felt, __warp_usrid_80_secondsPerLiquidityCumulativeX128s : felt, __warp_usrid_72_self : felt, __warp_usrid_73_time : felt, __warp_usrid_75_tick : felt, __warp_usrid_76_index : felt, __warp_usrid_77_liquidity : felt, __warp_usrid_78_cardinality : felt){
    alloc_locals;


        
            
            let (__warp_se_0) = wm_dyn_array_length(__warp_usrid_74_secondsAgos);
            
            let (__warp_se_1) = warp_lt256(__warp_usrid_81_i, __warp_se_0);
            
                
                if (__warp_se_1 != 0){
                
                    
                        
                            
                            let (__warp_se_2) = wm_index_dyn(__warp_usrid_74_secondsAgos, __warp_usrid_81_i, Uint256(low=1, high=0));
                            
                            let (__warp_se_3) = wm_read_felt(__warp_se_2);
                            
                            let (__warp_tv_0, __warp_tv_1) = observeSingle_f7f8d6a0(__warp_usrid_72_self, __warp_usrid_73_time, __warp_se_3, __warp_usrid_75_tick, __warp_usrid_76_index, __warp_usrid_77_liquidity, __warp_usrid_78_cardinality);
                            
                            let (__warp_se_4) = wm_index_dyn(__warp_usrid_80_secondsPerLiquidityCumulativeX128s, __warp_usrid_81_i, Uint256(low=1, high=0));
                            
                            wm_write_felt(__warp_se_4, __warp_tv_1);
                            
                            let (__warp_se_5) = wm_index_dyn(__warp_usrid_79_tickCumulatives, __warp_usrid_81_i, Uint256(low=1, high=0));
                            
                            wm_write_felt(__warp_se_5, __warp_tv_0);
                    
                    let (__warp_pse_0) = warp_add_unsafe256(__warp_usrid_81_i, Uint256(low=1, high=0));
                    
                    let __warp_usrid_81_i = __warp_pse_0;
                    
                    warp_sub_unsafe256(__warp_pse_0, Uint256(low=1, high=0));
                    tempvar warp_memory = warp_memory;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_81_i = __warp_usrid_81_i;
                    tempvar __warp_usrid_74_secondsAgos = __warp_usrid_74_secondsAgos;
                    tempvar __warp_usrid_79_tickCumulatives = __warp_usrid_79_tickCumulatives;
                    tempvar __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_usrid_80_secondsPerLiquidityCumulativeX128s;
                    tempvar __warp_usrid_72_self = __warp_usrid_72_self;
                    tempvar __warp_usrid_73_time = __warp_usrid_73_time;
                    tempvar __warp_usrid_75_tick = __warp_usrid_75_tick;
                    tempvar __warp_usrid_76_index = __warp_usrid_76_index;
                    tempvar __warp_usrid_77_liquidity = __warp_usrid_77_liquidity;
                    tempvar __warp_usrid_78_cardinality = __warp_usrid_78_cardinality;
                }else{
                
                    
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
                    
                    
                    
                    return (__warp_usrid_81_i, __warp_usrid_74_secondsAgos, __warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s, __warp_usrid_72_self, __warp_usrid_73_time, __warp_usrid_75_tick, __warp_usrid_76_index, __warp_usrid_77_liquidity, __warp_usrid_78_cardinality);
                }
                tempvar warp_memory = warp_memory;
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_81_i = __warp_usrid_81_i;
                tempvar __warp_usrid_74_secondsAgos = __warp_usrid_74_secondsAgos;
                tempvar __warp_usrid_79_tickCumulatives = __warp_usrid_79_tickCumulatives;
                tempvar __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_usrid_80_secondsPerLiquidityCumulativeX128s;
                tempvar __warp_usrid_72_self = __warp_usrid_72_self;
                tempvar __warp_usrid_73_time = __warp_usrid_73_time;
                tempvar __warp_usrid_75_tick = __warp_usrid_75_tick;
                tempvar __warp_usrid_76_index = __warp_usrid_76_index;
                tempvar __warp_usrid_77_liquidity = __warp_usrid_77_liquidity;
                tempvar __warp_usrid_78_cardinality = __warp_usrid_78_cardinality;
        
        let (__warp_usrid_81_i, __warp_td_0, __warp_td_1, __warp_td_2, __warp_td_3, __warp_usrid_73_time, __warp_usrid_75_tick, __warp_usrid_76_index, __warp_usrid_77_liquidity, __warp_usrid_78_cardinality) = __warp_while14(__warp_usrid_81_i, __warp_usrid_74_secondsAgos, __warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s, __warp_usrid_72_self, __warp_usrid_73_time, __warp_usrid_75_tick, __warp_usrid_76_index, __warp_usrid_77_liquidity, __warp_usrid_78_cardinality);
        
        let __warp_usrid_74_secondsAgos = __warp_td_0;
        
        let __warp_usrid_79_tickCumulatives = __warp_td_1;
        
        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_td_2;
        
        let __warp_usrid_72_self = __warp_td_3;
        
        
        
        return (__warp_usrid_81_i, __warp_usrid_74_secondsAgos, __warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s, __warp_usrid_72_self, __warp_usrid_73_time, __warp_usrid_75_tick, __warp_usrid_76_index, __warp_usrid_77_liquidity, __warp_usrid_78_cardinality);

    }


    func __warp_conditional___warp_while13_1{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_47_targetAtOrAfter : felt, __warp_usrid_38_time : felt, __warp_usrid_39_target : felt, __warp_usrid_43_atOrAfter : felt)-> (__warp_rc_0 : felt, __warp_usrid_47_targetAtOrAfter : felt, __warp_usrid_38_time : felt, __warp_usrid_39_target : felt, __warp_usrid_43_atOrAfter : felt){
    alloc_locals;


        
        if (__warp_usrid_47_targetAtOrAfter != 0){
        
            
            let (__warp_se_6) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_43_atOrAfter);
            
            let (__warp_se_7) = wm_read_felt(__warp_se_6);
            
            let (__warp_pse_1) = lte_34209030(__warp_usrid_38_time, __warp_usrid_39_target, __warp_se_7);
            
            let __warp_rc_0 = __warp_pse_1;
            
            let __warp_rc_0 = __warp_rc_0;
            
            let __warp_usrid_47_targetAtOrAfter = __warp_usrid_47_targetAtOrAfter;
            
            let __warp_usrid_38_time = __warp_usrid_38_time;
            
            let __warp_usrid_39_target = __warp_usrid_39_target;
            
            let __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
            
            
            
            return (__warp_rc_0, __warp_usrid_47_targetAtOrAfter, __warp_usrid_38_time, __warp_usrid_39_target, __warp_usrid_43_atOrAfter);
        }else{
        
            
            let __warp_rc_0 = 0;
            
            let __warp_rc_0 = __warp_rc_0;
            
            let __warp_usrid_47_targetAtOrAfter = __warp_usrid_47_targetAtOrAfter;
            
            let __warp_usrid_38_time = __warp_usrid_38_time;
            
            let __warp_usrid_39_target = __warp_usrid_39_target;
            
            let __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
            
            
            
            return (__warp_rc_0, __warp_usrid_47_targetAtOrAfter, __warp_usrid_38_time, __warp_usrid_39_target, __warp_usrid_43_atOrAfter);
        }

    }


    func __warp_while13{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_46_i : Uint256, __warp_usrid_44_l : Uint256, __warp_usrid_45_r : Uint256, __warp_usrid_42_beforeOrAt : felt, __warp_usrid_37_self : felt, __warp_usrid_41_cardinality : felt, __warp_usrid_43_atOrAfter : felt, __warp_usrid_38_time : felt, __warp_usrid_39_target : felt)-> (__warp_usrid_46_i : Uint256, __warp_usrid_44_l : Uint256, __warp_usrid_45_r : Uint256, __warp_usrid_42_beforeOrAt : felt, __warp_usrid_37_self : felt, __warp_usrid_41_cardinality : felt, __warp_usrid_43_atOrAfter : felt, __warp_usrid_38_time : felt, __warp_usrid_39_target : felt){
    alloc_locals;


        
            
                
                if (1 != 0){
                
                    
                    let (__warp_se_8) = warp_add_unsafe256(__warp_usrid_44_l, __warp_usrid_45_r);
                    
                    let (__warp_se_9) = warp_div_unsafe256(__warp_se_8, Uint256(low=2, high=0));
                    
                    let __warp_usrid_46_i = __warp_se_9;
                    
                    let (__warp_se_10) = warp_uint256(__warp_usrid_41_cardinality);
                    
                    let (__warp_se_11) = warp_mod256(__warp_usrid_46_i, __warp_se_10);
                    
                    let (__warp_se_12) = WS0_IDX(__warp_usrid_37_self, __warp_se_11, Uint256(low=4, high=0), Uint256(low=65535, high=0));
                    
                    let (__warp_se_13) = ws_to_memory0(__warp_se_12);
                    
                    let __warp_usrid_42_beforeOrAt = __warp_se_13;
                    
                    let (__warp_se_14) = WM1_Observation_2cc4d695___warp_usrid_03_initialized(__warp_usrid_42_beforeOrAt);
                    
                    let (__warp_se_15) = wm_read_felt(__warp_se_14);
                    
                        
                        if (1 - __warp_se_15 != 0){
                        
                            
                            let (__warp_se_16) = warp_add_unsafe256(__warp_usrid_46_i, Uint256(low=1, high=0));
                            
                            let __warp_usrid_44_l = __warp_se_16;
                            
                            let (__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_td_4, __warp_td_5, __warp_usrid_41_cardinality, __warp_td_6, __warp_usrid_38_time, __warp_usrid_39_target) = __warp_while13(__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);
                            
                            let __warp_usrid_42_beforeOrAt = __warp_td_4;
                            
                            let __warp_usrid_37_self = __warp_td_5;
                            
                            let __warp_usrid_43_atOrAfter = __warp_td_6;
                            
                            
                            
                            return (__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_46_i = __warp_usrid_46_i;
                            tempvar __warp_usrid_44_l = __warp_usrid_44_l;
                            tempvar __warp_usrid_45_r = __warp_usrid_45_r;
                            tempvar __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                            tempvar __warp_usrid_37_self = __warp_usrid_37_self;
                            tempvar __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                            tempvar __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                            tempvar __warp_usrid_38_time = __warp_usrid_38_time;
                            tempvar __warp_usrid_39_target = __warp_usrid_39_target;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_46_i = __warp_usrid_46_i;
                        tempvar __warp_usrid_44_l = __warp_usrid_44_l;
                        tempvar __warp_usrid_45_r = __warp_usrid_45_r;
                        tempvar __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                        tempvar __warp_usrid_37_self = __warp_usrid_37_self;
                        tempvar __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                        tempvar __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                        tempvar __warp_usrid_38_time = __warp_usrid_38_time;
                        tempvar __warp_usrid_39_target = __warp_usrid_39_target;
                    
                    let (__warp_se_17) = warp_add_unsafe256(__warp_usrid_46_i, Uint256(low=1, high=0));
                    
                    let (__warp_se_18) = warp_uint256(__warp_usrid_41_cardinality);
                    
                    let (__warp_se_19) = warp_mod256(__warp_se_17, __warp_se_18);
                    
                    let (__warp_se_20) = WS0_IDX(__warp_usrid_37_self, __warp_se_19, Uint256(low=4, high=0), Uint256(low=65535, high=0));
                    
                    let (__warp_se_21) = ws_to_memory0(__warp_se_20);
                    
                    let __warp_usrid_43_atOrAfter = __warp_se_21;
                    
                    let (__warp_se_22) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_42_beforeOrAt);
                    
                    let (__warp_se_23) = wm_read_felt(__warp_se_22);
                    
                    let (__warp_usrid_47_targetAtOrAfter) = lte_34209030(__warp_usrid_38_time, __warp_se_23, __warp_usrid_39_target);
                    
                    let __warp_rc_0 = 0;
                    
                        
                        let (__warp_tv_2, __warp_tv_3, __warp_tv_4, __warp_tv_5, __warp_td_7) = __warp_conditional___warp_while13_1(__warp_usrid_47_targetAtOrAfter, __warp_usrid_38_time, __warp_usrid_39_target, __warp_usrid_43_atOrAfter);
                        
                        let __warp_tv_6 = __warp_td_7;
                        
                        let __warp_usrid_43_atOrAfter = __warp_tv_6;
                        
                        let __warp_usrid_39_target = __warp_tv_5;
                        
                        let __warp_usrid_38_time = __warp_tv_4;
                        
                        let __warp_usrid_47_targetAtOrAfter = __warp_tv_3;
                        
                        let __warp_rc_0 = __warp_tv_2;
                    
                        
                        if (__warp_rc_0 != 0){
                        
                            
                            let __warp_usrid_46_i = __warp_usrid_46_i;
                            
                            let __warp_usrid_44_l = __warp_usrid_44_l;
                            
                            let __warp_usrid_45_r = __warp_usrid_45_r;
                            
                            let __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                            
                            let __warp_usrid_37_self = __warp_usrid_37_self;
                            
                            let __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                            
                            let __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                            
                            let __warp_usrid_38_time = __warp_usrid_38_time;
                            
                            let __warp_usrid_39_target = __warp_usrid_39_target;
                            
                            
                            
                            return (__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_46_i = __warp_usrid_46_i;
                            tempvar __warp_usrid_44_l = __warp_usrid_44_l;
                            tempvar __warp_usrid_45_r = __warp_usrid_45_r;
                            tempvar __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                            tempvar __warp_usrid_37_self = __warp_usrid_37_self;
                            tempvar __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                            tempvar __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                            tempvar __warp_usrid_38_time = __warp_usrid_38_time;
                            tempvar __warp_usrid_39_target = __warp_usrid_39_target;
                            tempvar __warp_usrid_47_targetAtOrAfter = __warp_usrid_47_targetAtOrAfter;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_46_i = __warp_usrid_46_i;
                        tempvar __warp_usrid_44_l = __warp_usrid_44_l;
                        tempvar __warp_usrid_45_r = __warp_usrid_45_r;
                        tempvar __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                        tempvar __warp_usrid_37_self = __warp_usrid_37_self;
                        tempvar __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                        tempvar __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                        tempvar __warp_usrid_38_time = __warp_usrid_38_time;
                        tempvar __warp_usrid_39_target = __warp_usrid_39_target;
                        tempvar __warp_usrid_47_targetAtOrAfter = __warp_usrid_47_targetAtOrAfter;
                    
                        
                        if (1 - __warp_usrid_47_targetAtOrAfter != 0){
                        
                            
                            let (__warp_se_24) = warp_sub_unsafe256(__warp_usrid_46_i, Uint256(low=1, high=0));
                            
                            let __warp_usrid_45_r = __warp_se_24;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_46_i = __warp_usrid_46_i;
                            tempvar __warp_usrid_44_l = __warp_usrid_44_l;
                            tempvar __warp_usrid_45_r = __warp_usrid_45_r;
                            tempvar __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                            tempvar __warp_usrid_37_self = __warp_usrid_37_self;
                            tempvar __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                            tempvar __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                            tempvar __warp_usrid_38_time = __warp_usrid_38_time;
                            tempvar __warp_usrid_39_target = __warp_usrid_39_target;
                        }else{
                        
                            
                            let (__warp_se_25) = warp_add_unsafe256(__warp_usrid_46_i, Uint256(low=1, high=0));
                            
                            let __warp_usrid_44_l = __warp_se_25;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_46_i = __warp_usrid_46_i;
                            tempvar __warp_usrid_44_l = __warp_usrid_44_l;
                            tempvar __warp_usrid_45_r = __warp_usrid_45_r;
                            tempvar __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                            tempvar __warp_usrid_37_self = __warp_usrid_37_self;
                            tempvar __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                            tempvar __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                            tempvar __warp_usrid_38_time = __warp_usrid_38_time;
                            tempvar __warp_usrid_39_target = __warp_usrid_39_target;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_46_i = __warp_usrid_46_i;
                        tempvar __warp_usrid_44_l = __warp_usrid_44_l;
                        tempvar __warp_usrid_45_r = __warp_usrid_45_r;
                        tempvar __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                        tempvar __warp_usrid_37_self = __warp_usrid_37_self;
                        tempvar __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                        tempvar __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                        tempvar __warp_usrid_38_time = __warp_usrid_38_time;
                        tempvar __warp_usrid_39_target = __warp_usrid_39_target;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_46_i = __warp_usrid_46_i;
                    tempvar __warp_usrid_44_l = __warp_usrid_44_l;
                    tempvar __warp_usrid_45_r = __warp_usrid_45_r;
                    tempvar __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                    tempvar __warp_usrid_37_self = __warp_usrid_37_self;
                    tempvar __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                    tempvar __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                    tempvar __warp_usrid_38_time = __warp_usrid_38_time;
                    tempvar __warp_usrid_39_target = __warp_usrid_39_target;
                }else{
                
                    
                    let __warp_usrid_46_i = __warp_usrid_46_i;
                    
                    let __warp_usrid_44_l = __warp_usrid_44_l;
                    
                    let __warp_usrid_45_r = __warp_usrid_45_r;
                    
                    let __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                    
                    let __warp_usrid_37_self = __warp_usrid_37_self;
                    
                    let __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                    
                    let __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                    
                    let __warp_usrid_38_time = __warp_usrid_38_time;
                    
                    let __warp_usrid_39_target = __warp_usrid_39_target;
                    
                    
                    
                    return (__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_46_i = __warp_usrid_46_i;
                tempvar __warp_usrid_44_l = __warp_usrid_44_l;
                tempvar __warp_usrid_45_r = __warp_usrid_45_r;
                tempvar __warp_usrid_42_beforeOrAt = __warp_usrid_42_beforeOrAt;
                tempvar __warp_usrid_37_self = __warp_usrid_37_self;
                tempvar __warp_usrid_41_cardinality = __warp_usrid_41_cardinality;
                tempvar __warp_usrid_43_atOrAfter = __warp_usrid_43_atOrAfter;
                tempvar __warp_usrid_38_time = __warp_usrid_38_time;
                tempvar __warp_usrid_39_target = __warp_usrid_39_target;
        
        let (__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_td_8, __warp_td_9, __warp_usrid_41_cardinality, __warp_td_10, __warp_usrid_38_time, __warp_usrid_39_target) = __warp_while13(__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);
        
        let __warp_usrid_42_beforeOrAt = __warp_td_8;
        
        let __warp_usrid_37_self = __warp_td_9;
        
        let __warp_usrid_43_atOrAfter = __warp_td_10;
        
        
        
        return (__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);

    }


    func __warp_while12{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_30_i : felt, __warp_usrid_28_next : felt, __warp_usrid_26_self : felt)-> (__warp_usrid_30_i : felt, __warp_usrid_28_next : felt, __warp_usrid_26_self : felt){
    alloc_locals;


        
            
            let (__warp_se_26) = warp_lt(__warp_usrid_30_i, __warp_usrid_28_next);
            
                
                if (__warp_se_26 != 0){
                
                    
                    let (__warp_se_27) = warp_uint256(__warp_usrid_30_i);
                    
                    let (__warp_se_28) = WS0_IDX(__warp_usrid_26_self, __warp_se_27, Uint256(low=4, high=0), Uint256(low=65535, high=0));
                    
                    let (__warp_se_29) = WSM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_se_28);
                    
                    WS_WRITE0(__warp_se_29, 1);
                    
                    let (__warp_pse_2) = warp_add_unsafe16(__warp_usrid_30_i, 1);
                    
                    let __warp_usrid_30_i = __warp_pse_2;
                    
                    warp_sub_unsafe16(__warp_pse_2, 1);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_30_i = __warp_usrid_30_i;
                    tempvar __warp_usrid_28_next = __warp_usrid_28_next;
                    tempvar __warp_usrid_26_self = __warp_usrid_26_self;
                }else{
                
                    
                    let __warp_usrid_30_i = __warp_usrid_30_i;
                    
                    let __warp_usrid_28_next = __warp_usrid_28_next;
                    
                    let __warp_usrid_26_self = __warp_usrid_26_self;
                    
                    
                    
                    return (__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_30_i = __warp_usrid_30_i;
                tempvar __warp_usrid_28_next = __warp_usrid_28_next;
                tempvar __warp_usrid_26_self = __warp_usrid_26_self;
        
        let (__warp_usrid_30_i, __warp_usrid_28_next, __warp_td_11) = __warp_while12(__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);
        
        let __warp_usrid_26_self = __warp_td_11;
        
        
        
        return (__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);

    }


    func __warp_while11{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_23_i : Uint256, __warp_usrid_16_params_dstruct : cd_dynarray_UpdateParams_a5eebe58, __warp_usrid_22__time : felt, __warp_usrid_19__index : felt, __warp_usrid_20__cardinality : felt, __warp_usrid_17__tick : felt, __warp_usrid_18__liquidity : felt, __warp_usrid_21__cardinalityNext : felt)-> (__warp_usrid_23_i : Uint256, __warp_usrid_16_params_dstruct : cd_dynarray_UpdateParams_a5eebe58, __warp_usrid_22__time : felt, __warp_usrid_19__index : felt, __warp_usrid_20__cardinality : felt, __warp_usrid_17__tick : felt, __warp_usrid_18__liquidity : felt, __warp_usrid_21__cardinalityNext : felt){
    alloc_locals;


        
            
            let (__warp_se_30) = felt_to_uint256(__warp_usrid_16_params_dstruct.len);
            
            let (__warp_se_31) = warp_lt256(__warp_usrid_23_i, __warp_se_30);
            
                
                if (__warp_se_31 != 0){
                
                    
                        
                        let (__warp_se_32) = warp_int256_to_int248(__warp_usrid_23_i);
                        
                        let (__warp_se_33) = warp_add_unsafe32(__warp_usrid_22__time, __warp_usrid_16_params_dstruct.ptr[__warp_se_32].__warp_usrid_03_advanceTimeBy);
                        
                        let __warp_usrid_22__time = __warp_se_33;
                        
                            
                            let (__warp_tv_7, __warp_tv_8) = write_9b9fd24c(__warp_usrid_06_observations, __warp_usrid_19__index, __warp_usrid_22__time, __warp_usrid_17__tick, __warp_usrid_18__liquidity, __warp_usrid_20__cardinality, __warp_usrid_21__cardinalityNext);
                            
                            let __warp_usrid_20__cardinality = __warp_tv_8;
                            
                            let __warp_usrid_19__index = __warp_tv_7;
                        
                        let (__warp_se_34) = warp_int256_to_int248(__warp_usrid_23_i);
                        
                        let __warp_usrid_17__tick = __warp_usrid_16_params_dstruct.ptr[__warp_se_34].__warp_usrid_04_tick;
                        
                        let (__warp_se_35) = warp_int256_to_int248(__warp_usrid_23_i);
                        
                        let __warp_usrid_18__liquidity = __warp_usrid_16_params_dstruct.ptr[__warp_se_35].__warp_usrid_05_liquidity;
                    
                    let (__warp_pse_3) = warp_add_unsafe256(__warp_usrid_23_i, Uint256(low=1, high=0));
                    
                    let __warp_usrid_23_i = __warp_pse_3;
                    
                    warp_sub_unsafe256(__warp_pse_3, Uint256(low=1, high=0));
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar __warp_usrid_23_i = __warp_usrid_23_i;
                    tempvar __warp_usrid_16_params_dstruct = __warp_usrid_16_params_dstruct;
                    tempvar __warp_usrid_22__time = __warp_usrid_22__time;
                    tempvar __warp_usrid_19__index = __warp_usrid_19__index;
                    tempvar __warp_usrid_20__cardinality = __warp_usrid_20__cardinality;
                    tempvar __warp_usrid_17__tick = __warp_usrid_17__tick;
                    tempvar __warp_usrid_18__liquidity = __warp_usrid_18__liquidity;
                    tempvar __warp_usrid_21__cardinalityNext = __warp_usrid_21__cardinalityNext;
                }else{
                
                    
                    let __warp_usrid_23_i = __warp_usrid_23_i;
                    
                    let __warp_usrid_16_params_dstruct = __warp_usrid_16_params_dstruct;
                    
                    let __warp_usrid_22__time = __warp_usrid_22__time;
                    
                    let __warp_usrid_19__index = __warp_usrid_19__index;
                    
                    let __warp_usrid_20__cardinality = __warp_usrid_20__cardinality;
                    
                    let __warp_usrid_17__tick = __warp_usrid_17__tick;
                    
                    let __warp_usrid_18__liquidity = __warp_usrid_18__liquidity;
                    
                    let __warp_usrid_21__cardinalityNext = __warp_usrid_21__cardinalityNext;
                    
                    
                    
                    return (__warp_usrid_23_i, __warp_usrid_16_params_dstruct, __warp_usrid_22__time, __warp_usrid_19__index, __warp_usrid_20__cardinality, __warp_usrid_17__tick, __warp_usrid_18__liquidity, __warp_usrid_21__cardinalityNext);
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar __warp_usrid_23_i = __warp_usrid_23_i;
                tempvar __warp_usrid_16_params_dstruct = __warp_usrid_16_params_dstruct;
                tempvar __warp_usrid_22__time = __warp_usrid_22__time;
                tempvar __warp_usrid_19__index = __warp_usrid_19__index;
                tempvar __warp_usrid_20__cardinality = __warp_usrid_20__cardinality;
                tempvar __warp_usrid_17__tick = __warp_usrid_17__tick;
                tempvar __warp_usrid_18__liquidity = __warp_usrid_18__liquidity;
                tempvar __warp_usrid_21__cardinalityNext = __warp_usrid_21__cardinalityNext;
        
        let (__warp_usrid_23_i, __warp_td_12, __warp_usrid_22__time, __warp_usrid_19__index, __warp_usrid_20__cardinality, __warp_usrid_17__tick, __warp_usrid_18__liquidity, __warp_usrid_21__cardinalityNext) = __warp_while11(__warp_usrid_23_i, __warp_usrid_16_params_dstruct, __warp_usrid_22__time, __warp_usrid_19__index, __warp_usrid_20__cardinality, __warp_usrid_17__tick, __warp_usrid_18__liquidity, __warp_usrid_21__cardinalityNext);
        
        let __warp_usrid_16_params_dstruct = __warp_td_12;
        
        
        
        return (__warp_usrid_23_i, __warp_usrid_16_params_dstruct, __warp_usrid_22__time, __warp_usrid_19__index, __warp_usrid_20__cardinality, __warp_usrid_17__tick, __warp_usrid_18__liquidity, __warp_usrid_21__cardinalityNext);

    }


    func advanceTime_f7fd2cfa_internal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_14_by : felt)-> (){
    alloc_locals;


        
            
            let (__warp_se_38) = WS0_READ_felt(__warp_usrid_07_time);
            
            let (__warp_se_39) = warp_add_unsafe32(__warp_se_38, __warp_usrid_14_by);
            
            WS_WRITE0(__warp_usrid_07_time, __warp_se_39);
        
        
        
        return ();

    }

    // @notice Transforms a previous observation into a new observation, given the passage of time and the current tick and liquidity values
    // @dev blockTimestamp _must_ be chronologically equal to or greater than last.blockTimestamp, safe for 0 or 1 overflows
    // @param last The specified observation to be transformed
    // @param blockTimestamp The timestamp of the new observation
    // @param tick The active tick at the time of the new observation
    // @param liquidity The total in-range liquidity at the time of the new observation
    // @return Observation The newly populated observation
    func transform_44108314{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_04_last : felt, __warp_usrid_05_blockTimestamp : felt, __warp_usrid_06_tick : felt, __warp_usrid_07_liquidity : felt)-> (__warp_usrid_08_ : felt){
    alloc_locals;


        
            
            let (__warp_se_65) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_04_last);
            
            let (__warp_se_66) = wm_read_felt(__warp_se_65);
            
            let (__warp_usrid_09_delta) = warp_sub_unsafe32(__warp_usrid_05_blockTimestamp, __warp_se_66);
            
            let (__warp_pse_5) = conditional0_5bba3b34(__warp_usrid_07_liquidity);
            
            let (__warp_se_67) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_04_last);
            
            let (__warp_se_68) = wm_read_felt(__warp_se_67);
            
            let (__warp_se_69) = warp_int24_to_int56(__warp_usrid_06_tick);
            
            let (__warp_se_70) = warp_mul_signed_unsafe56(__warp_se_69, __warp_usrid_09_delta);
            
            let (__warp_se_71) = warp_add_signed_unsafe56(__warp_se_68, __warp_se_70);
            
            let (__warp_se_72) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_04_last);
            
            let (__warp_se_73) = wm_read_felt(__warp_se_72);
            
            let (__warp_se_74) = warp_shl160(__warp_usrid_09_delta, 128);
            
            let (__warp_se_75) = warp_div_unsafe(__warp_se_74, __warp_pse_5);
            
            let (__warp_se_76) = warp_add_unsafe160(__warp_se_73, __warp_se_75);
            
            let (__warp_se_77) = WM0_struct_Observation_2cc4d695(__warp_usrid_05_blockTimestamp, __warp_se_71, __warp_se_76, 1);
            
            
            
            return (__warp_se_77,);

    }


    func conditional0_5bba3b34{range_check_ptr : felt}(__warp_usrid_10_liquidity : felt)-> (__warp_usrid_11_ : felt){
    alloc_locals;


        
            
            let (__warp_se_78) = warp_gt(__warp_usrid_10_liquidity, 0);
            
            if (__warp_se_78 != 0){
            
                
                
                
                return (__warp_usrid_10_liquidity,);
            }else{
            
                
                
                
                return (1,);
            }

    }

    // @notice Initialize the oracle array by writing the first slot. Called once for the lifecycle of the observations array
    // @param self The stored oracle array
    // @param time The time of the oracle initialization, via block.timestamp truncated to uint32
    // @return cardinality The number of populated elements in the oracle array
    // @return cardinalityNext The new length of the oracle array, independent of population
    func initialize_286f3ae4{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(__warp_usrid_12_self : felt, __warp_usrid_13_time : felt)-> (__warp_usrid_14_cardinality : felt, __warp_usrid_15_cardinalityNext : felt){
    alloc_locals;


        
            
            let (__warp_se_79) = WS0_IDX(__warp_usrid_12_self, Uint256(low=0, high=0), Uint256(low=4, high=0), Uint256(low=65535, high=0));
            
            let (__warp_se_80) = WM0_struct_Observation_2cc4d695(__warp_usrid_13_time, 0, 0, 1);
            
            wm_to_storage0(__warp_se_79, __warp_se_80);
            
            let __warp_usrid_14_cardinality = 1;
            
            let __warp_usrid_15_cardinalityNext = 1;
            
            
            
            return (__warp_usrid_14_cardinality, __warp_usrid_15_cardinalityNext);

    }


    func __warp_conditional_write_9b9fd24c_3{range_check_ptr : felt}(__warp_usrid_22_cardinalityNext : felt, __warp_usrid_21_cardinality : felt, __warp_usrid_17_index : felt)-> (__warp_rc_2 : felt, __warp_usrid_22_cardinalityNext : felt, __warp_usrid_21_cardinality : felt, __warp_usrid_17_index : felt){
    alloc_locals;


        
        let (__warp_se_81) = warp_gt(__warp_usrid_22_cardinalityNext, __warp_usrid_21_cardinality);
        
        if (__warp_se_81 != 0){
        
            
            let (__warp_se_82) = warp_sub(__warp_usrid_21_cardinality, 1);
            
            let (__warp_se_83) = warp_eq(__warp_usrid_17_index, __warp_se_82);
            
            let __warp_rc_2 = __warp_se_83;
            
            let __warp_rc_2 = __warp_rc_2;
            
            let __warp_usrid_22_cardinalityNext = __warp_usrid_22_cardinalityNext;
            
            let __warp_usrid_21_cardinality = __warp_usrid_21_cardinality;
            
            let __warp_usrid_17_index = __warp_usrid_17_index;
            
            
            
            return (__warp_rc_2, __warp_usrid_22_cardinalityNext, __warp_usrid_21_cardinality, __warp_usrid_17_index);
        }else{
        
            
            let __warp_rc_2 = 0;
            
            let __warp_rc_2 = __warp_rc_2;
            
            let __warp_usrid_22_cardinalityNext = __warp_usrid_22_cardinalityNext;
            
            let __warp_usrid_21_cardinality = __warp_usrid_21_cardinality;
            
            let __warp_usrid_17_index = __warp_usrid_17_index;
            
            
            
            return (__warp_rc_2, __warp_usrid_22_cardinalityNext, __warp_usrid_21_cardinality, __warp_usrid_17_index);
        }

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
    func write_9b9fd24c{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_16_self : felt, __warp_usrid_17_index : felt, __warp_usrid_18_blockTimestamp : felt, __warp_usrid_19_tick : felt, __warp_usrid_20_liquidity : felt, __warp_usrid_21_cardinality : felt, __warp_usrid_22_cardinalityNext : felt)-> (__warp_usrid_23_indexUpdated : felt, __warp_usrid_24_cardinalityUpdated : felt){
    alloc_locals;


        
        let __warp_usrid_23_indexUpdated = 0;
        
        let __warp_usrid_24_cardinalityUpdated = 0;
        
            
            let (__warp_se_84) = warp_uint256(__warp_usrid_17_index);
            
            let (__warp_se_85) = WS0_IDX(__warp_usrid_16_self, __warp_se_84, Uint256(low=4, high=0), Uint256(low=65535, high=0));
            
            let (__warp_usrid_25_last) = ws_to_memory0(__warp_se_85);
            
            let (__warp_se_86) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_25_last);
            
            let (__warp_se_87) = wm_read_felt(__warp_se_86);
            
            let (__warp_se_88) = warp_eq(__warp_se_87, __warp_usrid_18_blockTimestamp);
            
                
                if (__warp_se_88 != 0){
                
                    
                    let __warp_usrid_23_indexUpdated = __warp_usrid_17_index;
                    
                    let __warp_usrid_24_cardinalityUpdated = __warp_usrid_21_cardinality;
                    
                    
                    
                    return (__warp_usrid_23_indexUpdated, __warp_usrid_24_cardinalityUpdated);
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_24_cardinalityUpdated = __warp_usrid_24_cardinalityUpdated;
                    tempvar __warp_usrid_23_indexUpdated = __warp_usrid_23_indexUpdated;
                    tempvar __warp_usrid_16_self = __warp_usrid_16_self;
                    tempvar __warp_usrid_25_last = __warp_usrid_25_last;
                    tempvar __warp_usrid_18_blockTimestamp = __warp_usrid_18_blockTimestamp;
                    tempvar __warp_usrid_19_tick = __warp_usrid_19_tick;
                    tempvar __warp_usrid_20_liquidity = __warp_usrid_20_liquidity;
                    tempvar __warp_usrid_17_index = __warp_usrid_17_index;
                    tempvar __warp_usrid_21_cardinality = __warp_usrid_21_cardinality;
                    tempvar __warp_usrid_22_cardinalityNext = __warp_usrid_22_cardinalityNext;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_24_cardinalityUpdated = __warp_usrid_24_cardinalityUpdated;
                tempvar __warp_usrid_23_indexUpdated = __warp_usrid_23_indexUpdated;
                tempvar __warp_usrid_16_self = __warp_usrid_16_self;
                tempvar __warp_usrid_25_last = __warp_usrid_25_last;
                tempvar __warp_usrid_18_blockTimestamp = __warp_usrid_18_blockTimestamp;
                tempvar __warp_usrid_19_tick = __warp_usrid_19_tick;
                tempvar __warp_usrid_20_liquidity = __warp_usrid_20_liquidity;
                tempvar __warp_usrid_17_index = __warp_usrid_17_index;
                tempvar __warp_usrid_21_cardinality = __warp_usrid_21_cardinality;
                tempvar __warp_usrid_22_cardinalityNext = __warp_usrid_22_cardinalityNext;
            
            let __warp_rc_2 = 0;
            
                
                let (__warp_tv_21, __warp_tv_22, __warp_tv_23, __warp_tv_24) = __warp_conditional_write_9b9fd24c_3(__warp_usrid_22_cardinalityNext, __warp_usrid_21_cardinality, __warp_usrid_17_index);
                
                let __warp_usrid_17_index = __warp_tv_24;
                
                let __warp_usrid_21_cardinality = __warp_tv_23;
                
                let __warp_usrid_22_cardinalityNext = __warp_tv_22;
                
                let __warp_rc_2 = __warp_tv_21;
            
                
                if (__warp_rc_2 != 0){
                
                    
                    let __warp_usrid_24_cardinalityUpdated = __warp_usrid_22_cardinalityNext;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_24_cardinalityUpdated = __warp_usrid_24_cardinalityUpdated;
                    tempvar __warp_usrid_23_indexUpdated = __warp_usrid_23_indexUpdated;
                    tempvar __warp_usrid_16_self = __warp_usrid_16_self;
                    tempvar __warp_usrid_25_last = __warp_usrid_25_last;
                    tempvar __warp_usrid_18_blockTimestamp = __warp_usrid_18_blockTimestamp;
                    tempvar __warp_usrid_19_tick = __warp_usrid_19_tick;
                    tempvar __warp_usrid_20_liquidity = __warp_usrid_20_liquidity;
                    tempvar __warp_usrid_17_index = __warp_usrid_17_index;
                }else{
                
                    
                    let __warp_usrid_24_cardinalityUpdated = __warp_usrid_21_cardinality;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_24_cardinalityUpdated = __warp_usrid_24_cardinalityUpdated;
                    tempvar __warp_usrid_23_indexUpdated = __warp_usrid_23_indexUpdated;
                    tempvar __warp_usrid_16_self = __warp_usrid_16_self;
                    tempvar __warp_usrid_25_last = __warp_usrid_25_last;
                    tempvar __warp_usrid_18_blockTimestamp = __warp_usrid_18_blockTimestamp;
                    tempvar __warp_usrid_19_tick = __warp_usrid_19_tick;
                    tempvar __warp_usrid_20_liquidity = __warp_usrid_20_liquidity;
                    tempvar __warp_usrid_17_index = __warp_usrid_17_index;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_24_cardinalityUpdated = __warp_usrid_24_cardinalityUpdated;
                tempvar __warp_usrid_23_indexUpdated = __warp_usrid_23_indexUpdated;
                tempvar __warp_usrid_16_self = __warp_usrid_16_self;
                tempvar __warp_usrid_25_last = __warp_usrid_25_last;
                tempvar __warp_usrid_18_blockTimestamp = __warp_usrid_18_blockTimestamp;
                tempvar __warp_usrid_19_tick = __warp_usrid_19_tick;
                tempvar __warp_usrid_20_liquidity = __warp_usrid_20_liquidity;
                tempvar __warp_usrid_17_index = __warp_usrid_17_index;
            
            let (__warp_se_89) = warp_add_unsafe16(__warp_usrid_17_index, 1);
            
            let (__warp_se_90) = warp_mod(__warp_se_89, __warp_usrid_24_cardinalityUpdated);
            
            let __warp_usrid_23_indexUpdated = __warp_se_90;
            
            let (__warp_pse_6) = transform_44108314(__warp_usrid_25_last, __warp_usrid_18_blockTimestamp, __warp_usrid_19_tick, __warp_usrid_20_liquidity);
            
            let (__warp_se_91) = warp_uint256(__warp_usrid_23_indexUpdated);
            
            let (__warp_se_92) = WS0_IDX(__warp_usrid_16_self, __warp_se_91, Uint256(low=4, high=0), Uint256(low=65535, high=0));
            
            wm_to_storage0(__warp_se_92, __warp_pse_6);
        
        let __warp_usrid_23_indexUpdated = __warp_usrid_23_indexUpdated;
        
        let __warp_usrid_24_cardinalityUpdated = __warp_usrid_24_cardinalityUpdated;
        
        
        
        return (__warp_usrid_23_indexUpdated, __warp_usrid_24_cardinalityUpdated);

    }

    // @notice Prepares the oracle array to store up to `next` observations
    // @param self The stored oracle array
    // @param current The current next cardinality of the oracle array
    // @param next The proposed next cardinality which will be populated in the oracle array
    // @return next The next cardinality which will be populated in the oracle array
    func grow_48fc651e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_26_self : felt, __warp_usrid_27_current : felt, __warp_usrid_28_next : felt)-> (__warp_usrid_29_ : felt){
    alloc_locals;


        
            
            let (__warp_se_93) = warp_gt(__warp_usrid_27_current, 0);
            
            with_attr error_message("I"){
                assert __warp_se_93 = 1;
            }
            
            let (__warp_se_94) = warp_le(__warp_usrid_28_next, __warp_usrid_27_current);
            
                
                if (__warp_se_94 != 0){
                
                    
                    
                    
                    return (__warp_usrid_27_current,);
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_28_next = __warp_usrid_28_next;
                    tempvar __warp_usrid_26_self = __warp_usrid_26_self;
                    tempvar __warp_usrid_27_current = __warp_usrid_27_current;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_28_next = __warp_usrid_28_next;
                tempvar __warp_usrid_26_self = __warp_usrid_26_self;
                tempvar __warp_usrid_27_current = __warp_usrid_27_current;
            
                
                let __warp_usrid_30_i = __warp_usrid_27_current;
                
                    
                    let (__warp_tv_25, __warp_tv_26, __warp_td_16) = __warp_while12(__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);
                    
                    let __warp_tv_27 = __warp_td_16;
                    
                    let __warp_usrid_26_self = __warp_tv_27;
                    
                    let __warp_usrid_28_next = __warp_tv_26;
                    
                    let __warp_usrid_30_i = __warp_tv_25;
            
            
            
            return (__warp_usrid_28_next,);

    }


    func __warp_conditional_lte_34209030_5{range_check_ptr : felt}(__warp_usrid_32_a : felt, __warp_usrid_31_time : felt, __warp_usrid_33_b : felt)-> (__warp_rc_4 : felt, __warp_usrid_32_a : felt, __warp_usrid_31_time : felt, __warp_usrid_33_b : felt){
    alloc_locals;


        
        let (__warp_se_95) = warp_le(__warp_usrid_32_a, __warp_usrid_31_time);
        
        if (__warp_se_95 != 0){
        
            
            let (__warp_se_96) = warp_le(__warp_usrid_33_b, __warp_usrid_31_time);
            
            let __warp_rc_4 = __warp_se_96;
            
            let __warp_rc_4 = __warp_rc_4;
            
            let __warp_usrid_32_a = __warp_usrid_32_a;
            
            let __warp_usrid_31_time = __warp_usrid_31_time;
            
            let __warp_usrid_33_b = __warp_usrid_33_b;
            
            
            
            return (__warp_rc_4, __warp_usrid_32_a, __warp_usrid_31_time, __warp_usrid_33_b);
        }else{
        
            
            let __warp_rc_4 = 0;
            
            let __warp_rc_4 = __warp_rc_4;
            
            let __warp_usrid_32_a = __warp_usrid_32_a;
            
            let __warp_usrid_31_time = __warp_usrid_31_time;
            
            let __warp_usrid_33_b = __warp_usrid_33_b;
            
            
            
            return (__warp_rc_4, __warp_usrid_32_a, __warp_usrid_31_time, __warp_usrid_33_b);
        }

    }

    // @notice comparator for 32-bit timestamps
    // @dev safe for 0 or 1 overflows, a and b _must_ be chronologically before or equal to time
    // @param time A timestamp truncated to 32 bits
    // @param a A comparison timestamp from which to determine the relative position of `time`
    // @param b From which to determine the relative position of `time`
    // @return bool Whether `a` is chronologically <= `b`
    func lte_34209030{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_31_time : felt, __warp_usrid_32_a : felt, __warp_usrid_33_b : felt)-> (__warp_usrid_34_ : felt){
    alloc_locals;


        
            
            let __warp_rc_4 = 0;
            
                
                let (__warp_tv_28, __warp_tv_29, __warp_tv_30, __warp_tv_31) = __warp_conditional_lte_34209030_5(__warp_usrid_32_a, __warp_usrid_31_time, __warp_usrid_33_b);
                
                let __warp_usrid_33_b = __warp_tv_31;
                
                let __warp_usrid_31_time = __warp_tv_30;
                
                let __warp_usrid_32_a = __warp_tv_29;
                
                let __warp_rc_4 = __warp_tv_28;
            
                
                if (__warp_rc_4 != 0){
                
                    
                    let (__warp_se_97) = warp_le(__warp_usrid_32_a, __warp_usrid_33_b);
                    
                    
                    
                    return (__warp_se_97,);
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_33_b = __warp_usrid_33_b;
                    tempvar __warp_usrid_31_time = __warp_usrid_31_time;
                    tempvar __warp_usrid_32_a = __warp_usrid_32_a;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_33_b = __warp_usrid_33_b;
                tempvar __warp_usrid_31_time = __warp_usrid_31_time;
                tempvar __warp_usrid_32_a = __warp_usrid_32_a;
            
            let (__warp_se_98) = warp_add_unsafe40(__warp_usrid_32_a, 4294967296);
            
            let (__warp_usrid_35_aAdjusted) = warp_uint256(__warp_se_98);
            
            let (__warp_se_99) = warp_gt(__warp_usrid_32_a, __warp_usrid_31_time);
            
                
                if (__warp_se_99 != 0){
                
                    
                    let (__warp_se_100) = warp_uint256(__warp_usrid_32_a);
                    
                    let __warp_usrid_35_aAdjusted = __warp_se_100;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_35_aAdjusted = __warp_usrid_35_aAdjusted;
                    tempvar __warp_usrid_33_b = __warp_usrid_33_b;
                    tempvar __warp_usrid_31_time = __warp_usrid_31_time;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_35_aAdjusted = __warp_usrid_35_aAdjusted;
                    tempvar __warp_usrid_33_b = __warp_usrid_33_b;
                    tempvar __warp_usrid_31_time = __warp_usrid_31_time;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_35_aAdjusted = __warp_usrid_35_aAdjusted;
                tempvar __warp_usrid_33_b = __warp_usrid_33_b;
                tempvar __warp_usrid_31_time = __warp_usrid_31_time;
            
            let (__warp_se_101) = warp_add_unsafe40(__warp_usrid_33_b, 4294967296);
            
            let (__warp_usrid_36_bAdjusted) = warp_uint256(__warp_se_101);
            
            let (__warp_se_102) = warp_gt(__warp_usrid_33_b, __warp_usrid_31_time);
            
                
                if (__warp_se_102 != 0){
                
                    
                    let (__warp_se_103) = warp_uint256(__warp_usrid_33_b);
                    
                    let __warp_usrid_36_bAdjusted = __warp_se_103;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_35_aAdjusted = __warp_usrid_35_aAdjusted;
                    tempvar __warp_usrid_36_bAdjusted = __warp_usrid_36_bAdjusted;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_35_aAdjusted = __warp_usrid_35_aAdjusted;
                    tempvar __warp_usrid_36_bAdjusted = __warp_usrid_36_bAdjusted;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_35_aAdjusted = __warp_usrid_35_aAdjusted;
                tempvar __warp_usrid_36_bAdjusted = __warp_usrid_36_bAdjusted;
            
            let (__warp_se_104) = warp_le256(__warp_usrid_35_aAdjusted, __warp_usrid_36_bAdjusted);
            
            
            
            return (__warp_se_104,);

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
    func binarySearch_c698fcdd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_37_self : felt, __warp_usrid_38_time : felt, __warp_usrid_39_target : felt, __warp_usrid_40_index : felt, __warp_usrid_41_cardinality : felt)-> (__warp_usrid_42_beforeOrAt : felt, __warp_usrid_43_atOrAfter : felt){
    alloc_locals;


        
        let (__warp_usrid_43_atOrAfter) = WM0_struct_Observation_2cc4d695(0, 0, 0, 0);
        
        let (__warp_usrid_42_beforeOrAt) = WM0_struct_Observation_2cc4d695(0, 0, 0, 0);
        
            
            let (__warp_se_105) = warp_add_unsafe16(__warp_usrid_40_index, 1);
            
            let (__warp_se_106) = warp_mod(__warp_se_105, __warp_usrid_41_cardinality);
            
            let (__warp_usrid_44_l) = warp_uint256(__warp_se_106);
            
            let (__warp_se_107) = warp_uint256(__warp_usrid_41_cardinality);
            
            let (__warp_se_108) = warp_add_unsafe256(__warp_usrid_44_l, __warp_se_107);
            
            let (__warp_usrid_45_r) = warp_sub_unsafe256(__warp_se_108, Uint256(low=1, high=0));
            
            let __warp_usrid_46_i = Uint256(low=0, high=0);
            
                
                let (__warp_tv_32, __warp_tv_33, __warp_tv_34, __warp_td_17, __warp_td_18, __warp_tv_37, __warp_td_19, __warp_tv_39, __warp_tv_40) = __warp_while13(__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);
                
                let __warp_tv_35 = __warp_td_17;
                
                let __warp_tv_36 = __warp_td_18;
                
                let __warp_tv_38 = __warp_td_19;
                
                let __warp_usrid_39_target = __warp_tv_40;
                
                let __warp_usrid_38_time = __warp_tv_39;
                
                let __warp_usrid_43_atOrAfter = __warp_tv_38;
                
                let __warp_usrid_41_cardinality = __warp_tv_37;
                
                let __warp_usrid_37_self = __warp_tv_36;
                
                let __warp_usrid_42_beforeOrAt = __warp_tv_35;
                
                let __warp_usrid_45_r = __warp_tv_34;
                
                let __warp_usrid_44_l = __warp_tv_33;
                
                let __warp_usrid_46_i = __warp_tv_32;
        
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
    func getSurroundingObservations_68850d1b{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_48_self : felt, __warp_usrid_49_time : felt, __warp_usrid_50_target : felt, __warp_usrid_51_tick : felt, __warp_usrid_52_index : felt, __warp_usrid_53_liquidity : felt, __warp_usrid_54_cardinality : felt)-> (__warp_usrid_55_beforeOrAt : felt, __warp_usrid_56_atOrAfter : felt){
    alloc_locals;


        
        let (__warp_usrid_56_atOrAfter) = WM0_struct_Observation_2cc4d695(0, 0, 0, 0);
        
        let (__warp_usrid_55_beforeOrAt) = WM0_struct_Observation_2cc4d695(0, 0, 0, 0);
        
            
            let (__warp_se_109) = warp_uint256(__warp_usrid_52_index);
            
            let (__warp_se_110) = WS0_IDX(__warp_usrid_48_self, __warp_se_109, Uint256(low=4, high=0), Uint256(low=65535, high=0));
            
            let (__warp_se_111) = ws_to_memory0(__warp_se_110);
            
            let __warp_usrid_55_beforeOrAt = __warp_se_111;
            
            let (__warp_se_112) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_55_beforeOrAt);
            
            let (__warp_se_113) = wm_read_felt(__warp_se_112);
            
            let (__warp_pse_7) = lte_34209030(__warp_usrid_49_time, __warp_se_113, __warp_usrid_50_target);
            
                
                if (__warp_pse_7 != 0){
                
                    
                    let (__warp_se_114) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_55_beforeOrAt);
                    
                    let (__warp_se_115) = wm_read_felt(__warp_se_114);
                    
                    let (__warp_se_116) = warp_eq(__warp_se_115, __warp_usrid_50_target);
                    
                    if (__warp_se_116 != 0){
                    
                        
                        let __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;
                        
                        let __warp_usrid_56_atOrAfter = __warp_usrid_56_atOrAfter;
                        
                        
                        
                        return (__warp_usrid_55_beforeOrAt, __warp_usrid_56_atOrAfter);
                    }else{
                    
                        
                        let (__warp_pse_8) = transform_44108314(__warp_usrid_55_beforeOrAt, __warp_usrid_50_target, __warp_usrid_51_tick, __warp_usrid_53_liquidity);
                        
                        let __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;
                        
                        let __warp_usrid_56_atOrAfter = __warp_pse_8;
                        
                        
                        
                        return (__warp_usrid_55_beforeOrAt, __warp_usrid_56_atOrAfter);
                    }
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_48_self = __warp_usrid_48_self;
                    tempvar __warp_usrid_49_time = __warp_usrid_49_time;
                    tempvar __warp_usrid_50_target = __warp_usrid_50_target;
                    tempvar __warp_usrid_52_index = __warp_usrid_52_index;
                    tempvar __warp_usrid_54_cardinality = __warp_usrid_54_cardinality;
                    tempvar __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_48_self = __warp_usrid_48_self;
                tempvar __warp_usrid_49_time = __warp_usrid_49_time;
                tempvar __warp_usrid_50_target = __warp_usrid_50_target;
                tempvar __warp_usrid_52_index = __warp_usrid_52_index;
                tempvar __warp_usrid_54_cardinality = __warp_usrid_54_cardinality;
                tempvar __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;
            
            let (__warp_se_117) = warp_add_unsafe16(__warp_usrid_52_index, 1);
            
            let (__warp_se_118) = warp_mod(__warp_se_117, __warp_usrid_54_cardinality);
            
            let (__warp_se_119) = warp_uint256(__warp_se_118);
            
            let (__warp_se_120) = WS0_IDX(__warp_usrid_48_self, __warp_se_119, Uint256(low=4, high=0), Uint256(low=65535, high=0));
            
            let (__warp_se_121) = ws_to_memory0(__warp_se_120);
            
            let __warp_usrid_55_beforeOrAt = __warp_se_121;
            
            let (__warp_se_122) = WM1_Observation_2cc4d695___warp_usrid_03_initialized(__warp_usrid_55_beforeOrAt);
            
            let (__warp_se_123) = wm_read_felt(__warp_se_122);
            
                
                if (1 - __warp_se_123 != 0){
                
                    
                    let (__warp_se_124) = WS0_IDX(__warp_usrid_48_self, Uint256(low=0, high=0), Uint256(low=4, high=0), Uint256(low=65535, high=0));
                    
                    let (__warp_se_125) = ws_to_memory0(__warp_se_124);
                    
                    let __warp_usrid_55_beforeOrAt = __warp_se_125;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_48_self = __warp_usrid_48_self;
                    tempvar __warp_usrid_49_time = __warp_usrid_49_time;
                    tempvar __warp_usrid_50_target = __warp_usrid_50_target;
                    tempvar __warp_usrid_52_index = __warp_usrid_52_index;
                    tempvar __warp_usrid_54_cardinality = __warp_usrid_54_cardinality;
                    tempvar __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_48_self = __warp_usrid_48_self;
                    tempvar __warp_usrid_49_time = __warp_usrid_49_time;
                    tempvar __warp_usrid_50_target = __warp_usrid_50_target;
                    tempvar __warp_usrid_52_index = __warp_usrid_52_index;
                    tempvar __warp_usrid_54_cardinality = __warp_usrid_54_cardinality;
                    tempvar __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_48_self = __warp_usrid_48_self;
                tempvar __warp_usrid_49_time = __warp_usrid_49_time;
                tempvar __warp_usrid_50_target = __warp_usrid_50_target;
                tempvar __warp_usrid_52_index = __warp_usrid_52_index;
                tempvar __warp_usrid_54_cardinality = __warp_usrid_54_cardinality;
                tempvar __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;
            
            let (__warp_se_126) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_55_beforeOrAt);
            
            let (__warp_se_127) = wm_read_felt(__warp_se_126);
            
            let (__warp_pse_9) = lte_34209030(__warp_usrid_49_time, __warp_se_127, __warp_usrid_50_target);
            
            with_attr error_message("OLD"){
                assert __warp_pse_9 = 1;
            }
            
            let (__warp_td_20, __warp_td_21) = binarySearch_c698fcdd(__warp_usrid_48_self, __warp_usrid_49_time, __warp_usrid_50_target, __warp_usrid_52_index, __warp_usrid_54_cardinality);
            
            let __warp_usrid_55_beforeOrAt = __warp_td_20;
            
            let __warp_usrid_56_atOrAfter = __warp_td_21;
            
            
            
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
    func observeSingle_f7f8d6a0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_57_self : felt, __warp_usrid_58_time : felt, __warp_usrid_59_secondsAgo : felt, __warp_usrid_60_tick : felt, __warp_usrid_61_index : felt, __warp_usrid_62_liquidity : felt, __warp_usrid_63_cardinality : felt)-> (__warp_usrid_64_tickCumulative : felt, __warp_usrid_65_secondsPerLiquidityCumulativeX128 : felt){
    alloc_locals;


        
            
            let (__warp_se_128) = warp_eq(__warp_usrid_59_secondsAgo, 0);
            
                
                if (__warp_se_128 != 0){
                
                    
                    let (__warp_se_129) = warp_uint256(__warp_usrid_61_index);
                    
                    let (__warp_se_130) = WS0_IDX(__warp_usrid_57_self, __warp_se_129, Uint256(low=4, high=0), Uint256(low=65535, high=0));
                    
                    let (__warp_usrid_66_last) = ws_to_memory0(__warp_se_130);
                    
                    let (__warp_se_131) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_66_last);
                    
                    let (__warp_se_132) = wm_read_felt(__warp_se_131);
                    
                    let (__warp_se_133) = warp_neq(__warp_se_132, __warp_usrid_58_time);
                    
                        
                        if (__warp_se_133 != 0){
                        
                            
                            let (__warp_pse_10) = transform_44108314(__warp_usrid_66_last, __warp_usrid_58_time, __warp_usrid_60_tick, __warp_usrid_62_liquidity);
                            
                            let __warp_usrid_66_last = __warp_pse_10;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_57_self = __warp_usrid_57_self;
                            tempvar __warp_usrid_58_time = __warp_usrid_58_time;
                            tempvar __warp_usrid_60_tick = __warp_usrid_60_tick;
                            tempvar __warp_usrid_61_index = __warp_usrid_61_index;
                            tempvar __warp_usrid_62_liquidity = __warp_usrid_62_liquidity;
                            tempvar __warp_usrid_63_cardinality = __warp_usrid_63_cardinality;
                            tempvar __warp_usrid_59_secondsAgo = __warp_usrid_59_secondsAgo;
                            tempvar __warp_usrid_66_last = __warp_usrid_66_last;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_57_self = __warp_usrid_57_self;
                            tempvar __warp_usrid_58_time = __warp_usrid_58_time;
                            tempvar __warp_usrid_60_tick = __warp_usrid_60_tick;
                            tempvar __warp_usrid_61_index = __warp_usrid_61_index;
                            tempvar __warp_usrid_62_liquidity = __warp_usrid_62_liquidity;
                            tempvar __warp_usrid_63_cardinality = __warp_usrid_63_cardinality;
                            tempvar __warp_usrid_59_secondsAgo = __warp_usrid_59_secondsAgo;
                            tempvar __warp_usrid_66_last = __warp_usrid_66_last;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_57_self = __warp_usrid_57_self;
                        tempvar __warp_usrid_58_time = __warp_usrid_58_time;
                        tempvar __warp_usrid_60_tick = __warp_usrid_60_tick;
                        tempvar __warp_usrid_61_index = __warp_usrid_61_index;
                        tempvar __warp_usrid_62_liquidity = __warp_usrid_62_liquidity;
                        tempvar __warp_usrid_63_cardinality = __warp_usrid_63_cardinality;
                        tempvar __warp_usrid_59_secondsAgo = __warp_usrid_59_secondsAgo;
                        tempvar __warp_usrid_66_last = __warp_usrid_66_last;
                    
                    let (__warp_se_134) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_66_last);
                    
                    let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_134);
                    
                    let (__warp_se_135) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_66_last);
                    
                    let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(__warp_se_135);
                    
                    
                    
                    return (__warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128);
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_57_self = __warp_usrid_57_self;
                    tempvar __warp_usrid_58_time = __warp_usrid_58_time;
                    tempvar __warp_usrid_60_tick = __warp_usrid_60_tick;
                    tempvar __warp_usrid_61_index = __warp_usrid_61_index;
                    tempvar __warp_usrid_62_liquidity = __warp_usrid_62_liquidity;
                    tempvar __warp_usrid_63_cardinality = __warp_usrid_63_cardinality;
                    tempvar __warp_usrid_59_secondsAgo = __warp_usrid_59_secondsAgo;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_57_self = __warp_usrid_57_self;
                tempvar __warp_usrid_58_time = __warp_usrid_58_time;
                tempvar __warp_usrid_60_tick = __warp_usrid_60_tick;
                tempvar __warp_usrid_61_index = __warp_usrid_61_index;
                tempvar __warp_usrid_62_liquidity = __warp_usrid_62_liquidity;
                tempvar __warp_usrid_63_cardinality = __warp_usrid_63_cardinality;
                tempvar __warp_usrid_59_secondsAgo = __warp_usrid_59_secondsAgo;
            
            let (__warp_usrid_67_target) = warp_sub_unsafe32(__warp_usrid_58_time, __warp_usrid_59_secondsAgo);
            
            let (__warp_td_22, __warp_td_23) = getSurroundingObservations_68850d1b(__warp_usrid_57_self, __warp_usrid_58_time, __warp_usrid_67_target, __warp_usrid_60_tick, __warp_usrid_61_index, __warp_usrid_62_liquidity, __warp_usrid_63_cardinality);
            
            let __warp_usrid_68_beforeOrAt = __warp_td_22;
            
            let __warp_usrid_69_atOrAfter = __warp_td_23;
            
            let (__warp_se_136) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_68_beforeOrAt);
            
            let (__warp_se_137) = wm_read_felt(__warp_se_136);
            
            let (__warp_se_138) = warp_eq(__warp_usrid_67_target, __warp_se_137);
            
            if (__warp_se_138 != 0){
            
                
                let (__warp_se_139) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_68_beforeOrAt);
                
                let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_139);
                
                let (__warp_se_140) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_68_beforeOrAt);
                
                let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(__warp_se_140);
                
                
                
                return (__warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128);
            }else{
            
                
                let (__warp_se_141) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_69_atOrAfter);
                
                let (__warp_se_142) = wm_read_felt(__warp_se_141);
                
                let (__warp_se_143) = warp_eq(__warp_usrid_67_target, __warp_se_142);
                
                if (__warp_se_143 != 0){
                
                    
                    let (__warp_se_144) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_69_atOrAfter);
                    
                    let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_144);
                    
                    let (__warp_se_145) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_69_atOrAfter);
                    
                    let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(__warp_se_145);
                    
                    
                    
                    return (__warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128);
                }else{
                
                    
                    let (__warp_se_146) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_69_atOrAfter);
                    
                    let (__warp_se_147) = wm_read_felt(__warp_se_146);
                    
                    let (__warp_se_148) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_149) = wm_read_felt(__warp_se_148);
                    
                    let (__warp_usrid_70_observationTimeDelta) = warp_sub_unsafe32(__warp_se_147, __warp_se_149);
                    
                    let (__warp_se_150) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_151) = wm_read_felt(__warp_se_150);
                    
                    let (__warp_usrid_71_targetDelta) = warp_sub_unsafe32(__warp_usrid_67_target, __warp_se_151);
                    
                    let (__warp_se_152) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_153) = wm_read_felt(__warp_se_152);
                    
                    let (__warp_se_154) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_69_atOrAfter);
                    
                    let (__warp_se_155) = wm_read_felt(__warp_se_154);
                    
                    let (__warp_se_156) = WM2_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_157) = wm_read_felt(__warp_se_156);
                    
                    let (__warp_se_158) = warp_sub_signed_unsafe56(__warp_se_155, __warp_se_157);
                    
                    let (__warp_se_159) = warp_int32_to_int56(__warp_usrid_70_observationTimeDelta);
                    
                    let (__warp_se_160) = warp_div_signed_unsafe56(__warp_se_158, __warp_se_159);
                    
                    let (__warp_se_161) = warp_int32_to_int56(__warp_usrid_71_targetDelta);
                    
                    let (__warp_se_162) = warp_mul_signed_unsafe56(__warp_se_160, __warp_se_161);
                    
                    let (__warp_usrid_64_tickCumulative) = warp_add_signed_unsafe56(__warp_se_153, __warp_se_162);
                    
                    let (__warp_se_163) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_164) = wm_read_felt(__warp_se_163);
                    
                    let (__warp_se_165) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_69_atOrAfter);
                    
                    let (__warp_se_166) = wm_read_felt(__warp_se_165);
                    
                    let (__warp_se_167) = WM3_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_168) = wm_read_felt(__warp_se_167);
                    
                    let (__warp_se_169) = warp_sub_unsafe160(__warp_se_166, __warp_se_168);
                    
                    let (__warp_se_170) = warp_uint256(__warp_se_169);
                    
                    let (__warp_se_171) = warp_uint256(__warp_usrid_71_targetDelta);
                    
                    let (__warp_se_172) = warp_mul_unsafe256(__warp_se_170, __warp_se_171);
                    
                    let (__warp_se_173) = warp_uint256(__warp_usrid_70_observationTimeDelta);
                    
                    let (__warp_se_174) = warp_div_unsafe256(__warp_se_172, __warp_se_173);
                    
                    let (__warp_se_175) = warp_int256_to_int160(__warp_se_174);
                    
                    let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = warp_add_unsafe160(__warp_se_164, __warp_se_175);
                    
                    
                    
                    return (__warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128);
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
    func observe_1ce1e7a5{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_72_self : felt, __warp_usrid_73_time : felt, __warp_usrid_74_secondsAgos : felt, __warp_usrid_75_tick : felt, __warp_usrid_76_index : felt, __warp_usrid_77_liquidity : felt, __warp_usrid_78_cardinality : felt)-> (__warp_usrid_79_tickCumulatives : felt, __warp_usrid_80_secondsPerLiquidityCumulativeX128s : felt){
    alloc_locals;


        
        let (__warp_usrid_80_secondsPerLiquidityCumulativeX128s) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));
        
        let (__warp_usrid_79_tickCumulatives) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));
        
            
            let (__warp_se_176) = warp_gt(__warp_usrid_78_cardinality, 0);
            
            with_attr error_message("I"){
                assert __warp_se_176 = 1;
            }
            
            let (__warp_se_177) = wm_dyn_array_length(__warp_usrid_74_secondsAgos);
            
            let (__warp_se_178) = wm_new(__warp_se_177, Uint256(low=1, high=0));
            
            let __warp_usrid_79_tickCumulatives = __warp_se_178;
            
            let (__warp_se_179) = wm_dyn_array_length(__warp_usrid_74_secondsAgos);
            
            let (__warp_se_180) = wm_new(__warp_se_179, Uint256(low=1, high=0));
            
            let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_se_180;
            
                
                let __warp_usrid_81_i = Uint256(low=0, high=0);
                
                    
                    let (__warp_tv_41, __warp_td_24, __warp_td_25, __warp_td_26, __warp_td_27, __warp_tv_46, __warp_tv_47, __warp_tv_48, __warp_tv_49, __warp_tv_50) = __warp_while14(__warp_usrid_81_i, __warp_usrid_74_secondsAgos, __warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s, __warp_usrid_72_self, __warp_usrid_73_time, __warp_usrid_75_tick, __warp_usrid_76_index, __warp_usrid_77_liquidity, __warp_usrid_78_cardinality);
                    
                    let __warp_tv_42 = __warp_td_24;
                    
                    let __warp_tv_43 = __warp_td_25;
                    
                    let __warp_tv_44 = __warp_td_26;
                    
                    let __warp_tv_45 = __warp_td_27;
                    
                    let __warp_usrid_78_cardinality = __warp_tv_50;
                    
                    let __warp_usrid_77_liquidity = __warp_tv_49;
                    
                    let __warp_usrid_76_index = __warp_tv_48;
                    
                    let __warp_usrid_75_tick = __warp_tv_47;
                    
                    let __warp_usrid_73_time = __warp_tv_46;
                    
                    let __warp_usrid_72_self = __warp_tv_45;
                    
                    let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_tv_44;
                    
                    let __warp_usrid_79_tickCumulatives = __warp_tv_43;
                    
                    let __warp_usrid_74_secondsAgos = __warp_tv_42;
                    
                    let __warp_usrid_81_i = __warp_tv_41;
        
        let __warp_usrid_79_tickCumulatives = __warp_usrid_79_tickCumulatives;
        
        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_usrid_80_secondsPerLiquidityCumulativeX128s;
        
        
        
        return (__warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s);

    }

}


    @external
    func initialize_daf50f6b{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_usrid_13_params : InitializeParams_62e4fbcc)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check0(__warp_usrid_13_params);
        
        let (__warp_se_36) = WS0_READ_felt(OracleTest.__warp_usrid_11_cardinality);
        
        let (__warp_se_37) = warp_eq(__warp_se_36, 0);
        
        with_attr error_message("already initialized"){
            assert __warp_se_37 = 1;
        }
        
        WS_WRITE0(OracleTest.__warp_usrid_07_time, __warp_usrid_13_params.__warp_usrid_00_time);
        
        WS_WRITE0(OracleTest.__warp_usrid_08_tick, __warp_usrid_13_params.__warp_usrid_01_tick);
        
        WS_WRITE0(OracleTest.__warp_usrid_09_liquidity, __warp_usrid_13_params.__warp_usrid_02_liquidity);
        
            
            let (__warp_tv_9, __warp_tv_10) = OracleTest.initialize_286f3ae4(OracleTest.__warp_usrid_06_observations, __warp_usrid_13_params.__warp_usrid_00_time);
            
            WS_WRITE0(OracleTest.__warp_usrid_12_cardinalityNext, __warp_tv_10);
            
            WS_WRITE0(OracleTest.__warp_usrid_11_cardinality, __warp_tv_9);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func update_65829dc5{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_15_params : UpdateParams_a5eebe58)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check1(__warp_usrid_15_params);
        
        OracleTest.advanceTime_f7fd2cfa_internal(__warp_usrid_15_params.__warp_usrid_03_advanceTimeBy);
        
            
            let (__warp_se_40) = WS0_READ_felt(OracleTest.__warp_usrid_10_index);
            
            let (__warp_se_41) = WS0_READ_felt(OracleTest.__warp_usrid_07_time);
            
            let (__warp_se_42) = WS0_READ_felt(OracleTest.__warp_usrid_08_tick);
            
            let (__warp_se_43) = WS0_READ_felt(OracleTest.__warp_usrid_09_liquidity);
            
            let (__warp_se_44) = WS0_READ_felt(OracleTest.__warp_usrid_11_cardinality);
            
            let (__warp_se_45) = WS0_READ_felt(OracleTest.__warp_usrid_12_cardinalityNext);
            
            let (__warp_tv_11, __warp_tv_12) = OracleTest.write_9b9fd24c(OracleTest.__warp_usrid_06_observations, __warp_se_40, __warp_se_41, __warp_se_42, __warp_se_43, __warp_se_44, __warp_se_45);
            
            WS_WRITE0(OracleTest.__warp_usrid_11_cardinality, __warp_tv_12);
            
            WS_WRITE0(OracleTest.__warp_usrid_10_index, __warp_tv_11);
        
        WS_WRITE0(OracleTest.__warp_usrid_08_tick, __warp_usrid_15_params.__warp_usrid_04_tick);
        
        WS_WRITE0(OracleTest.__warp_usrid_09_liquidity, __warp_usrid_15_params.__warp_usrid_05_liquidity);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func batchUpdate_d81740db{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_16_params_len : felt, __warp_usrid_16_params : UpdateParams_a5eebe58*)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check2(__warp_usrid_16_params_len, __warp_usrid_16_params);
        
        local __warp_usrid_16_params_dstruct : cd_dynarray_UpdateParams_a5eebe58 = cd_dynarray_UpdateParams_a5eebe58(__warp_usrid_16_params_len, __warp_usrid_16_params);
        
            
            let (__warp_usrid_17__tick) = WS0_READ_felt(OracleTest.__warp_usrid_08_tick);
            
            let (__warp_usrid_18__liquidity) = WS0_READ_felt(OracleTest.__warp_usrid_09_liquidity);
            
            let (__warp_usrid_19__index) = WS0_READ_felt(OracleTest.__warp_usrid_10_index);
            
            let (__warp_usrid_20__cardinality) = WS0_READ_felt(OracleTest.__warp_usrid_11_cardinality);
            
            let (__warp_usrid_21__cardinalityNext) = WS0_READ_felt(OracleTest.__warp_usrid_12_cardinalityNext);
            
            let (__warp_usrid_22__time) = WS0_READ_felt(OracleTest.__warp_usrid_07_time);
            
                
                let __warp_usrid_23_i = Uint256(low=0, high=0);
                
                    
                    let (__warp_tv_13, __warp_td_13, __warp_tv_15, __warp_tv_16, __warp_tv_17, __warp_tv_18, __warp_tv_19, __warp_tv_20) = OracleTest.__warp_while11(__warp_usrid_23_i, __warp_usrid_16_params_dstruct, __warp_usrid_22__time, __warp_usrid_19__index, __warp_usrid_20__cardinality, __warp_usrid_17__tick, __warp_usrid_18__liquidity, __warp_usrid_21__cardinalityNext);
                    
                    let __warp_tv_14 = __warp_td_13;
                    
                    let __warp_usrid_21__cardinalityNext = __warp_tv_20;
                    
                    let __warp_usrid_18__liquidity = __warp_tv_19;
                    
                    let __warp_usrid_17__tick = __warp_tv_18;
                    
                    let __warp_usrid_20__cardinality = __warp_tv_17;
                    
                    let __warp_usrid_19__index = __warp_tv_16;
                    
                    let __warp_usrid_22__time = __warp_tv_15;
                    
                    let __warp_usrid_23_i = __warp_tv_13;
            
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
    func grow_761eb23e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_24__cardinalityNext : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_int16(__warp_usrid_24__cardinalityNext);
        
        let (__warp_se_46) = WS0_READ_felt(OracleTest.__warp_usrid_12_cardinalityNext);
        
        let (__warp_pse_4) = OracleTest.grow_48fc651e(OracleTest.__warp_usrid_06_observations, __warp_se_46, __warp_usrid_24__cardinalityNext);
        
        WS_WRITE0(OracleTest.__warp_usrid_12_cardinalityNext, __warp_pse_4);
        
        
        
        return ();

    }


    @view
    func observe_883bdbfd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_25_secondsAgos_len : felt, __warp_usrid_25_secondsAgos : felt*)-> (__warp_usrid_26_tickCumulatives_len : felt, __warp_usrid_26_tickCumulatives : felt*, __warp_usrid_27_secondsPerLiquidityCumulativeX128s_len : felt, __warp_usrid_27_secondsPerLiquidityCumulativeX128s : felt*){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check3(__warp_usrid_25_secondsAgos_len, __warp_usrid_25_secondsAgos);
        
        local __warp_usrid_25_secondsAgos_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_25_secondsAgos_len, __warp_usrid_25_secondsAgos);
        
        let (__warp_se_47) = WS0_READ_felt(OracleTest.__warp_usrid_07_time);
        
        let (__warp_se_48) = cd_to_memory0(__warp_usrid_25_secondsAgos_dstruct);
        
        let (__warp_se_49) = WS0_READ_felt(OracleTest.__warp_usrid_08_tick);
        
        let (__warp_se_50) = WS0_READ_felt(OracleTest.__warp_usrid_10_index);
        
        let (__warp_se_51) = WS0_READ_felt(OracleTest.__warp_usrid_09_liquidity);
        
        let (__warp_se_52) = WS0_READ_felt(OracleTest.__warp_usrid_11_cardinality);
        
        let (__warp_td_14, __warp_td_15) = OracleTest.observe_1ce1e7a5(OracleTest.__warp_usrid_06_observations, __warp_se_47, __warp_se_48, __warp_se_49, __warp_se_50, __warp_se_51, __warp_se_52);
        
        let __warp_usrid_26_tickCumulatives = __warp_td_14;
        
        let __warp_usrid_27_secondsPerLiquidityCumulativeX128s = __warp_td_15;
        
        let (__warp_se_53) = wm_to_calldata0(__warp_usrid_26_tickCumulatives);
        
        let (__warp_se_54) = wm_to_calldata3(__warp_usrid_27_secondsPerLiquidityCumulativeX128s);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return (__warp_se_53.len, __warp_se_53.ptr, __warp_se_54.len, __warp_se_54.ptr);
    }
    }


    @view
    func observations_252c09d7{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_usrid_28__i0 : Uint256)-> (__warp_usrid_29_ : felt, __warp_usrid_30_ : felt, __warp_usrid_31_ : felt, __warp_usrid_32_ : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_usrid_28__i0);
        
        let (__warp_usrid_33__temp0) = WS0_IDX(OracleTest.__warp_usrid_06_observations, __warp_usrid_28__i0, Uint256(low=4, high=0), Uint256(low=65535, high=0));
        
        let (__warp_se_55) = WSM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_33__temp0);
        
        let (__warp_usrid_29_) = WS0_READ_felt(__warp_se_55);
        
        let (__warp_se_56) = WSM1_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_33__temp0);
        
        let (__warp_usrid_30_) = WS0_READ_felt(__warp_se_56);
        
        let (__warp_se_57) = WSM2_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_33__temp0);
        
        let (__warp_usrid_31_) = WS0_READ_felt(__warp_se_57);
        
        let (__warp_se_58) = WSM3_Observation_2cc4d695___warp_usrid_03_initialized(__warp_usrid_33__temp0);
        
        let (__warp_usrid_32_) = WS0_READ_felt(__warp_se_58);
        
        
        
        return (__warp_usrid_29_, __warp_usrid_30_, __warp_usrid_31_, __warp_usrid_32_);

    }


    @view
    func time_16ada547{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_34_ : felt){
    alloc_locals;


        
        let (__warp_se_59) = WS0_READ_felt(OracleTest.__warp_usrid_07_time);
        
        
        
        return (__warp_se_59,);

    }


    @view
    func tick_3eaf5d9f{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_35_ : felt){
    alloc_locals;


        
        let (__warp_se_60) = WS0_READ_felt(OracleTest.__warp_usrid_08_tick);
        
        
        
        return (__warp_se_60,);

    }


    @view
    func liquidity_1a686502{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_36_ : felt){
    alloc_locals;


        
        let (__warp_se_61) = WS0_READ_felt(OracleTest.__warp_usrid_09_liquidity);
        
        
        
        return (__warp_se_61,);

    }


    @view
    func index_2986c0e5{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_37_ : felt){
    alloc_locals;


        
        let (__warp_se_62) = WS0_READ_felt(OracleTest.__warp_usrid_10_index);
        
        
        
        return (__warp_se_62,);

    }


    @view
    func cardinality_dbffe9ad{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_38_ : felt){
    alloc_locals;


        
        let (__warp_se_63) = WS0_READ_felt(OracleTest.__warp_usrid_11_cardinality);
        
        
        
        return (__warp_se_63,);

    }


    @view
    func cardinalityNext_dd158c18{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_39_ : felt){
    alloc_locals;


        
        let (__warp_se_64) = WS0_READ_felt(OracleTest.__warp_usrid_12_cardinalityNext);
        
        
        
        return (__warp_se_64,);

    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(){
    alloc_locals;
    WARP_USED_STORAGE.write(262146);


        
        
        
        return ();

    }


    @external
    func advanceTime_f7fd2cfa{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_14_by : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_int32(__warp_usrid_14_by);
        
        OracleTest.advanceTime_f7fd2cfa_internal(__warp_usrid_14_by);
        
        let __warp_uv7 = ();
        
        
        
        return ();

    }

// Original soldity abi: ["constructor()","initialize((uint32,int24,uint128))","advanceTime(uint32)","update((uint32,int24,uint128))","batchUpdate((uint32,int24,uint128)[])","grow(uint16)","observe(uint32[])","observations(uint256)","time()","tick()","liquidity()","index()","cardinality()","cardinalityNext()"]