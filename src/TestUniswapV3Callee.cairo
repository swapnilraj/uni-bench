%lang starknet


from warplib.memory import wm_read_felt, wm_read_256, wm_new
from starkware.cairo.common.uint256 import uint256_sub, uint256_add, Uint256
from starkware.cairo.common.alloc import alloc
from warplib.maths.utils import narrow_safe, felt_to_uint256
from warplib.maths.external_input_check_address import warp_external_input_check_address
from warplib.maths.external_input_check_ints import warp_external_input_check_int256, warp_external_input_check_int160, warp_external_input_check_int8, warp_external_input_check_int24, warp_external_input_check_int128
from starkware.cairo.common.dict import dict_write
from warplib.dynamic_arrays_util import byte_array_to_felt_value, byte_array_to_uint256_value, fixed_bytes256_to_felt_dynamic_array, felt_array_to_warp_memory_array
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.starknet.common.syscalls import get_caller_address
from warplib.maths.negate import warp_negate256
from warplib.maths.eq import warp_eq256
from warplib.maths.gt_signed import warp_gt_signed256
from warplib.maths.gt import warp_gt256
from warplib.maths.lt import warp_lt256


struct cd_dynarray_felt{
     len : felt ,
     ptr : felt*,
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

func extern_input_check0{range_check_ptr : felt}(len: felt, ptr : felt*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
warp_external_input_check_int8(ptr[0]);
   extern_input_check0(len = len - 1, ptr = ptr + 1);
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

func abi_decode0{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(mem_ptr : felt) -> (result0 : felt){
  alloc_locals;
  let max_index_length: felt = 32;
  let mem_index: felt = 0;
// Param 0 decoding:
let (result0 : felt) = byte_array_to_felt_value(mem_index, mem_index + 32, mem_ptr, 0);
let mem_index = mem_index + 32;
  assert max_index_length - mem_index = 0;
 return (result0 = result0);
}

func abi_decode1{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(mem_ptr : felt) -> (result0 : felt,result1 : Uint256,result2 : Uint256){
  alloc_locals;
  let max_index_length: felt = 96;
  let mem_index: felt = 0;
// Param 0 decoding:
let (result0 : felt) = byte_array_to_felt_value(mem_index, mem_index + 32, mem_ptr, 0);
let mem_index = mem_index + 32;
// Param 1 decoding:
let (result1 : Uint256) = byte_array_to_uint256_value(mem_index,mem_index + 32,mem_ptr,0,0);
let mem_index = mem_index + 32;
// Param 2 decoding:
let (result2 : Uint256) = byte_array_to_uint256_value(mem_index,mem_index + 32,mem_ptr,0,0);
let mem_index = mem_index + 32;
  assert max_index_length - mem_index = 0;
 return (result0 = result0,result1 = result1,result2 = result2);
}

func abi_encode0{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(param0 : felt) -> (result_ptr : felt){
  alloc_locals;
  let bytes_index : felt = 0;
  let bytes_offset : felt = 32;
  let (bytes_array : felt*) = alloc();
let (param0256) = felt_to_uint256(param0);
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param0256);
let bytes_index = bytes_index + 32;
  let (max_length256) = felt_to_uint256(bytes_offset);
  let (mem_ptr) = wm_new(max_length256, Uint256(0x1, 0x0));
  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_offset);
  return (mem_ptr,);
}

func abi_encode1{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(param0 : felt, param1 : Uint256, param2 : Uint256) -> (result_ptr : felt){
  alloc_locals;
  let bytes_index : felt = 0;
  let bytes_offset : felt = 96;
  let (bytes_array : felt*) = alloc();
let (param0256) = felt_to_uint256(param0);
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param0256);
let bytes_index = bytes_index + 32;
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param1);
let bytes_index = bytes_index + 32;
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param2);
let bytes_index = bytes_index + 32;
  let (max_length256) = felt_to_uint256(bytes_offset);
  let (mem_ptr) = wm_new(max_length256, Uint256(0x1, 0x0));
  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_offset);
  return (mem_ptr,);
}


// Contract Def TestUniswapV3Callee


@event
func SwapCallback_d48241df(__warp_usrid_22_amount0Delta : Uint256, __warp_usrid_23_amount1Delta : Uint256){
}


@event
func MintCallback_a0968be0(__warp_usrid_33_amount0Owed : Uint256, __warp_usrid_34_amount1Owed : Uint256){
}


@event
func FlashCallback_2b0391b4(__warp_usrid_39_fee0 : Uint256, __warp_usrid_40_fee1 : Uint256){
}

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

namespace TestUniswapV3Callee{

    // Dynamic variables - Arrays and Maps

    // Static variables


    func __warp_conditional_uniswapV3SwapCallback_fa461e33_1{range_check_ptr : felt}(__warp_usrid_24_amount0Delta : Uint256, __warp_usrid_25_amount1Delta : Uint256)-> (__warp_rc_0 : felt, __warp_usrid_24_amount0Delta : Uint256, __warp_usrid_25_amount1Delta : Uint256){
    alloc_locals;


        
        let (__warp_se_20) = warp_eq256(__warp_usrid_24_amount0Delta, Uint256(low=0, high=0));
        
        if (__warp_se_20 != 0){
        
            
            let (__warp_se_21) = warp_eq256(__warp_usrid_25_amount1Delta, Uint256(low=0, high=0));
            
            let __warp_rc_0 = __warp_se_21;
            
            let __warp_rc_0 = __warp_rc_0;
            
            let __warp_usrid_24_amount0Delta = __warp_usrid_24_amount0Delta;
            
            let __warp_usrid_25_amount1Delta = __warp_usrid_25_amount1Delta;
            
            
            
            return (__warp_rc_0, __warp_usrid_24_amount0Delta, __warp_usrid_25_amount1Delta);
        }else{
        
            
            let __warp_rc_0 = 0;
            
            let __warp_rc_0 = __warp_rc_0;
            
            let __warp_usrid_24_amount0Delta = __warp_usrid_24_amount0Delta;
            
            let __warp_usrid_25_amount1Delta = __warp_usrid_25_amount1Delta;
            
            
            
            return (__warp_rc_0, __warp_usrid_24_amount0Delta, __warp_usrid_25_amount1Delta);
        }

    }

    // @notice Cast a uint256 to a int256, revert on overflow
    // @param y The uint256 to be casted
    // @return z The casted integer, now type int256
    func toInt256_dfbe873b{range_check_ptr : felt}(__warp_usrid_04_y : Uint256)-> (__warp_usrid_05_z : Uint256){
    alloc_locals;


        
        let __warp_usrid_05_z = Uint256(low=0, high=0);
        
        let (__warp_se_49) = warp_lt256(__warp_usrid_04_y, Uint256(low=0, high=170141183460469231731687303715884105728));
        
        assert __warp_se_49 = 1;
        
        let __warp_usrid_05_z = __warp_usrid_04_y;
        
        
        
        return (__warp_usrid_05_z,);

    }

}


    @external
    func swapExact0For1_6dfc0ddb{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_pool : felt, __warp_usrid_01_amount0In : Uint256, __warp_usrid_02_recipient : felt, __warp_usrid_03_sqrtPriceLimitX96 : felt)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int160(__warp_usrid_03_sqrtPriceLimitX96);
        
        warp_external_input_check_address(__warp_usrid_02_recipient);
        
        warp_external_input_check_int256(__warp_usrid_01_amount0In);
        
        warp_external_input_check_address(__warp_usrid_00_pool);
        
        let (__warp_pse_0) = TestUniswapV3Callee.toInt256_dfbe873b(__warp_usrid_01_amount0In);
        
        let (__warp_se_0) = get_caller_address();
        
        let (__warp_se_1) = abi_encode0(__warp_se_0);
        
        let (__warp_se_2) = wm_to_calldata0(__warp_se_1);
        
        IUniswapV3Pool_warped_interface.swap_128acb08(__warp_usrid_00_pool, __warp_usrid_02_recipient, 1, __warp_pse_0, __warp_usrid_03_sqrtPriceLimitX96, __warp_se_2.len, __warp_se_2.ptr);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func swap0ForExact1_bac7bf78{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_04_pool : felt, __warp_usrid_05_amount1Out : Uint256, __warp_usrid_06_recipient : felt, __warp_usrid_07_sqrtPriceLimitX96 : felt)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int160(__warp_usrid_07_sqrtPriceLimitX96);
        
        warp_external_input_check_address(__warp_usrid_06_recipient);
        
        warp_external_input_check_int256(__warp_usrid_05_amount1Out);
        
        warp_external_input_check_address(__warp_usrid_04_pool);
        
        let (__warp_pse_1) = TestUniswapV3Callee.toInt256_dfbe873b(__warp_usrid_05_amount1Out);
        
        let (__warp_se_3) = warp_negate256(__warp_pse_1);
        
        let (__warp_se_4) = get_caller_address();
        
        let (__warp_se_5) = abi_encode0(__warp_se_4);
        
        let (__warp_se_6) = wm_to_calldata0(__warp_se_5);
        
        IUniswapV3Pool_warped_interface.swap_128acb08(__warp_usrid_04_pool, __warp_usrid_06_recipient, 1, __warp_se_3, __warp_usrid_07_sqrtPriceLimitX96, __warp_se_6.len, __warp_se_6.ptr);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func swapExact1For0_e2be9109{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_08_pool : felt, __warp_usrid_09_amount1In : Uint256, __warp_usrid_10_recipient : felt, __warp_usrid_11_sqrtPriceLimitX96 : felt)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int160(__warp_usrid_11_sqrtPriceLimitX96);
        
        warp_external_input_check_address(__warp_usrid_10_recipient);
        
        warp_external_input_check_int256(__warp_usrid_09_amount1In);
        
        warp_external_input_check_address(__warp_usrid_08_pool);
        
        let (__warp_pse_2) = TestUniswapV3Callee.toInt256_dfbe873b(__warp_usrid_09_amount1In);
        
        let (__warp_se_7) = get_caller_address();
        
        let (__warp_se_8) = abi_encode0(__warp_se_7);
        
        let (__warp_se_9) = wm_to_calldata0(__warp_se_8);
        
        IUniswapV3Pool_warped_interface.swap_128acb08(__warp_usrid_08_pool, __warp_usrid_10_recipient, 0, __warp_pse_2, __warp_usrid_11_sqrtPriceLimitX96, __warp_se_9.len, __warp_se_9.ptr);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func swap1ForExact0_f603482c{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_12_pool : felt, __warp_usrid_13_amount0Out : Uint256, __warp_usrid_14_recipient : felt, __warp_usrid_15_sqrtPriceLimitX96 : felt)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int160(__warp_usrid_15_sqrtPriceLimitX96);
        
        warp_external_input_check_address(__warp_usrid_14_recipient);
        
        warp_external_input_check_int256(__warp_usrid_13_amount0Out);
        
        warp_external_input_check_address(__warp_usrid_12_pool);
        
        let (__warp_pse_3) = TestUniswapV3Callee.toInt256_dfbe873b(__warp_usrid_13_amount0Out);
        
        let (__warp_se_10) = warp_negate256(__warp_pse_3);
        
        let (__warp_se_11) = get_caller_address();
        
        let (__warp_se_12) = abi_encode0(__warp_se_11);
        
        let (__warp_se_13) = wm_to_calldata0(__warp_se_12);
        
        IUniswapV3Pool_warped_interface.swap_128acb08(__warp_usrid_12_pool, __warp_usrid_14_recipient, 0, __warp_se_10, __warp_usrid_15_sqrtPriceLimitX96, __warp_se_13.len, __warp_se_13.ptr);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func swapToLowerSqrtPrice_2ec20bf9{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_16_pool : felt, __warp_usrid_17_sqrtPriceX96 : felt, __warp_usrid_18_recipient : felt)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_address(__warp_usrid_18_recipient);
        
        warp_external_input_check_int160(__warp_usrid_17_sqrtPriceX96);
        
        warp_external_input_check_address(__warp_usrid_16_pool);
        
        let (__warp_se_14) = get_caller_address();
        
        let (__warp_se_15) = abi_encode0(__warp_se_14);
        
        let (__warp_se_16) = wm_to_calldata0(__warp_se_15);
        
        IUniswapV3Pool_warped_interface.swap_128acb08(__warp_usrid_16_pool, __warp_usrid_18_recipient, 1, Uint256(low=340282366920938463463374607431768211455, high=170141183460469231731687303715884105727), __warp_usrid_17_sqrtPriceX96, __warp_se_16.len, __warp_se_16.ptr);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func swapToHigherSqrtPrice_9e77b805{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_19_pool : felt, __warp_usrid_20_sqrtPriceX96 : felt, __warp_usrid_21_recipient : felt)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_address(__warp_usrid_21_recipient);
        
        warp_external_input_check_int160(__warp_usrid_20_sqrtPriceX96);
        
        warp_external_input_check_address(__warp_usrid_19_pool);
        
        let (__warp_se_17) = get_caller_address();
        
        let (__warp_se_18) = abi_encode0(__warp_se_17);
        
        let (__warp_se_19) = wm_to_calldata0(__warp_se_18);
        
        IUniswapV3Pool_warped_interface.swap_128acb08(__warp_usrid_19_pool, __warp_usrid_21_recipient, 0, Uint256(low=340282366920938463463374607431768211455, high=170141183460469231731687303715884105727), __warp_usrid_20_sqrtPriceX96, __warp_se_19.len, __warp_se_19.ptr);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func uniswapV3SwapCallback_fa461e33{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_24_amount0Delta : Uint256, __warp_usrid_25_amount1Delta : Uint256, __warp_usrid_26_data_len : felt, __warp_usrid_26_data : felt*)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check0(__warp_usrid_26_data_len, __warp_usrid_26_data);
        
        warp_external_input_check_int256(__warp_usrid_25_amount1Delta);
        
        warp_external_input_check_int256(__warp_usrid_24_amount0Delta);
        
        local __warp_usrid_26_data_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_26_data_len, __warp_usrid_26_data);
        
        let (__warp_se_22) = cd_to_memory0(__warp_usrid_26_data_dstruct);
        
        let (__warp_usrid_27_sender) = abi_decode0(__warp_se_22);
        
        SwapCallback_d48241df.emit(__warp_usrid_24_amount0Delta, __warp_usrid_25_amount1Delta);
        
        let (__warp_se_23) = warp_gt_signed256(__warp_usrid_24_amount0Delta, Uint256(low=0, high=0));
        
            
            if (__warp_se_23 != 0){
            
                
                let (__warp_se_24) = get_caller_address();
                
                let (__warp_pse_4) = IUniswapV3Pool_warped_interface.token0_0dfe1681(__warp_se_24);
                
                let (__warp_se_25) = get_caller_address();
                
                IERC20Minimal_warped_interface.transferFrom_23b872dd(__warp_pse_4, __warp_usrid_27_sender, __warp_se_25, __warp_usrid_24_amount0Delta);
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
            }else{
            
                
                let (__warp_se_26) = warp_gt_signed256(__warp_usrid_25_amount1Delta, Uint256(low=0, high=0));
                
                    
                    if (__warp_se_26 != 0){
                    
                        
                        let (__warp_se_27) = get_caller_address();
                        
                        let (__warp_pse_5) = IUniswapV3Pool_warped_interface.token1_d21220a7(__warp_se_27);
                        
                        let (__warp_se_28) = get_caller_address();
                        
                        IERC20Minimal_warped_interface.transferFrom_23b872dd(__warp_pse_5, __warp_usrid_27_sender, __warp_se_28, __warp_usrid_25_amount1Delta);
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                    }else{
                    
                        
                        let __warp_rc_0 = 0;
                        
                            
                            let (__warp_tv_0, __warp_tv_1, __warp_tv_2) = TestUniswapV3Callee.__warp_conditional_uniswapV3SwapCallback_fa461e33_1(__warp_usrid_24_amount0Delta, __warp_usrid_25_amount1Delta);
                            
                            let __warp_usrid_25_amount1Delta = __warp_tv_2;
                            
                            let __warp_usrid_24_amount0Delta = __warp_tv_1;
                            
                            let __warp_rc_0 = __warp_tv_0;
                        
                        assert __warp_rc_0 = 1;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar warp_memory = warp_memory;
            tempvar bitwise_ptr = bitwise_ptr;
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func mint_7b4f5327{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_28_pool : felt, __warp_usrid_29_recipient : felt, __warp_usrid_30_tickLower : felt, __warp_usrid_31_tickUpper : felt, __warp_usrid_32_amount : felt)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int128(__warp_usrid_32_amount);
        
        warp_external_input_check_int24(__warp_usrid_31_tickUpper);
        
        warp_external_input_check_int24(__warp_usrid_30_tickLower);
        
        warp_external_input_check_address(__warp_usrid_29_recipient);
        
        warp_external_input_check_address(__warp_usrid_28_pool);
        
        let (__warp_se_29) = get_caller_address();
        
        let (__warp_se_30) = abi_encode0(__warp_se_29);
        
        let (__warp_se_31) = wm_to_calldata0(__warp_se_30);
        
        IUniswapV3Pool_warped_interface.mint_3c8a7d8d(__warp_usrid_28_pool, __warp_usrid_29_recipient, __warp_usrid_30_tickLower, __warp_usrid_31_tickUpper, __warp_usrid_32_amount, __warp_se_31.len, __warp_se_31.ptr);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func uniswapV3MintCallback_d3487997{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_35_amount0Owed : Uint256, __warp_usrid_36_amount1Owed : Uint256, __warp_usrid_37_data_len : felt, __warp_usrid_37_data : felt*)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check0(__warp_usrid_37_data_len, __warp_usrid_37_data);
        
        warp_external_input_check_int256(__warp_usrid_36_amount1Owed);
        
        warp_external_input_check_int256(__warp_usrid_35_amount0Owed);
        
        local __warp_usrid_37_data_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_37_data_len, __warp_usrid_37_data);
        
        let (__warp_se_32) = cd_to_memory0(__warp_usrid_37_data_dstruct);
        
        let (__warp_usrid_38_sender) = abi_decode0(__warp_se_32);
        
        MintCallback_a0968be0.emit(__warp_usrid_35_amount0Owed, __warp_usrid_36_amount1Owed);
        
        let (__warp_se_33) = warp_gt256(__warp_usrid_35_amount0Owed, Uint256(low=0, high=0));
        
            
            if (__warp_se_33 != 0){
            
                
                let (__warp_se_34) = get_caller_address();
                
                let (__warp_pse_6) = IUniswapV3Pool_warped_interface.token0_0dfe1681(__warp_se_34);
                
                let (__warp_se_35) = get_caller_address();
                
                IERC20Minimal_warped_interface.transferFrom_23b872dd(__warp_pse_6, __warp_usrid_38_sender, __warp_se_35, __warp_usrid_35_amount0Owed);
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_38_sender = __warp_usrid_38_sender;
                tempvar __warp_usrid_36_amount1Owed = __warp_usrid_36_amount1Owed;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_38_sender = __warp_usrid_38_sender;
                tempvar __warp_usrid_36_amount1Owed = __warp_usrid_36_amount1Owed;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar warp_memory = warp_memory;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar __warp_usrid_38_sender = __warp_usrid_38_sender;
            tempvar __warp_usrid_36_amount1Owed = __warp_usrid_36_amount1Owed;
        
        let (__warp_se_36) = warp_gt256(__warp_usrid_36_amount1Owed, Uint256(low=0, high=0));
        
            
            if (__warp_se_36 != 0){
            
                
                let (__warp_se_37) = get_caller_address();
                
                let (__warp_pse_7) = IUniswapV3Pool_warped_interface.token1_d21220a7(__warp_se_37);
                
                let (__warp_se_38) = get_caller_address();
                
                IERC20Minimal_warped_interface.transferFrom_23b872dd(__warp_pse_7, __warp_usrid_38_sender, __warp_se_38, __warp_usrid_36_amount1Owed);
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar warp_memory = warp_memory;
            tempvar bitwise_ptr = bitwise_ptr;
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func flash_034b0f8f{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_41_pool : felt, __warp_usrid_42_recipient : felt, __warp_usrid_43_amount0 : Uint256, __warp_usrid_44_amount1 : Uint256, __warp_usrid_45_pay0 : Uint256, __warp_usrid_46_pay1 : Uint256)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int256(__warp_usrid_46_pay1);
        
        warp_external_input_check_int256(__warp_usrid_45_pay0);
        
        warp_external_input_check_int256(__warp_usrid_44_amount1);
        
        warp_external_input_check_int256(__warp_usrid_43_amount0);
        
        warp_external_input_check_address(__warp_usrid_42_recipient);
        
        warp_external_input_check_address(__warp_usrid_41_pool);
        
        let (__warp_se_39) = get_caller_address();
        
        let (__warp_se_40) = abi_encode1(__warp_se_39, __warp_usrid_45_pay0, __warp_usrid_46_pay1);
        
        let (__warp_se_41) = wm_to_calldata0(__warp_se_40);
        
        IUniswapV3Pool_warped_interface.flash_490e6cbc(__warp_usrid_41_pool, __warp_usrid_42_recipient, __warp_usrid_43_amount0, __warp_usrid_44_amount1, __warp_se_41.len, __warp_se_41.ptr);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func uniswapV3FlashCallback_e9cbafb0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_47_fee0 : Uint256, __warp_usrid_48_fee1 : Uint256, __warp_usrid_49_data_len : felt, __warp_usrid_49_data : felt*)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check0(__warp_usrid_49_data_len, __warp_usrid_49_data);
        
        warp_external_input_check_int256(__warp_usrid_48_fee1);
        
        warp_external_input_check_int256(__warp_usrid_47_fee0);
        
        local __warp_usrid_49_data_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_49_data_len, __warp_usrid_49_data);
        
        FlashCallback_2b0391b4.emit(__warp_usrid_47_fee0, __warp_usrid_48_fee1);
        
        let (__warp_se_42) = cd_to_memory0(__warp_usrid_49_data_dstruct);
        
        let (__warp_td_0, __warp_usrid_51_pay0, __warp_usrid_52_pay1) = abi_decode1(__warp_se_42);
        
        let __warp_usrid_50_sender = __warp_td_0;
        
        let (__warp_se_43) = warp_gt256(__warp_usrid_51_pay0, Uint256(low=0, high=0));
        
            
            if (__warp_se_43 != 0){
            
                
                let (__warp_se_44) = get_caller_address();
                
                let (__warp_pse_8) = IUniswapV3Pool_warped_interface.token0_0dfe1681(__warp_se_44);
                
                let (__warp_se_45) = get_caller_address();
                
                IERC20Minimal_warped_interface.transferFrom_23b872dd(__warp_pse_8, __warp_usrid_50_sender, __warp_se_45, __warp_usrid_51_pay0);
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_50_sender = __warp_usrid_50_sender;
                tempvar __warp_usrid_52_pay1 = __warp_usrid_52_pay1;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_50_sender = __warp_usrid_50_sender;
                tempvar __warp_usrid_52_pay1 = __warp_usrid_52_pay1;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar warp_memory = warp_memory;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar __warp_usrid_50_sender = __warp_usrid_50_sender;
            tempvar __warp_usrid_52_pay1 = __warp_usrid_52_pay1;
        
        let (__warp_se_46) = warp_gt256(__warp_usrid_52_pay1, Uint256(low=0, high=0));
        
            
            if (__warp_se_46 != 0){
            
                
                let (__warp_se_47) = get_caller_address();
                
                let (__warp_pse_9) = IUniswapV3Pool_warped_interface.token1_d21220a7(__warp_se_47);
                
                let (__warp_se_48) = get_caller_address();
                
                IERC20Minimal_warped_interface.transferFrom_23b872dd(__warp_pse_9, __warp_usrid_50_sender, __warp_se_48, __warp_usrid_52_pay1);
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar warp_memory = warp_memory;
            tempvar bitwise_ptr = bitwise_ptr;
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(){
    alloc_locals;


        
        
        
        return ();

    }


// Contract Def IUniswapV3Pool@interface


@contract_interface
namespace IUniswapV3Pool_warped_interface{
    func setFeeProtocol_8206a4d1(__warp_usrid_00_feeProtocol0 : felt, __warp_usrid_01_feeProtocol1 : felt)-> (){
    }
    
    func collectProtocol_85b66729(__warp_usrid_02_recipient : felt, __warp_usrid_03_amount0Requested : felt, __warp_usrid_04_amount1Requested : felt)-> (__warp_usrid_05_amount0 : felt, __warp_usrid_06_amount1 : felt){
    }
    
    func initialize_f637731d(__warp_usrid_00_sqrtPriceX96 : felt)-> (){
    }
    
    func mint_3c8a7d8d(__warp_usrid_01_recipient : felt, __warp_usrid_02_tickLower : felt, __warp_usrid_03_tickUpper : felt, __warp_usrid_04_amount : felt, __warp_usrid_05_data_len : felt, __warp_usrid_05_data : felt*)-> (__warp_usrid_06_amount0 : Uint256, __warp_usrid_07_amount1 : Uint256){
    }
    
    func collect_4f1eb3d8(__warp_usrid_08_recipient : felt, __warp_usrid_09_tickLower : felt, __warp_usrid_10_tickUpper : felt, __warp_usrid_11_amount0Requested : felt, __warp_usrid_12_amount1Requested : felt)-> (__warp_usrid_13_amount0 : felt, __warp_usrid_14_amount1 : felt){
    }
    
    func burn_a34123a7(__warp_usrid_15_tickLower : felt, __warp_usrid_16_tickUpper : felt, __warp_usrid_17_amount : felt)-> (__warp_usrid_18_amount0 : Uint256, __warp_usrid_19_amount1 : Uint256){
    }
    
    func swap_128acb08(__warp_usrid_20_recipient : felt, __warp_usrid_21_zeroForOne : felt, __warp_usrid_22_amountSpecified : Uint256, __warp_usrid_23_sqrtPriceLimitX96 : felt, __warp_usrid_24_data_len : felt, __warp_usrid_24_data : felt*)-> (__warp_usrid_25_amount0 : Uint256, __warp_usrid_26_amount1 : Uint256){
    }
    
    func flash_490e6cbc(__warp_usrid_27_recipient : felt, __warp_usrid_28_amount0 : Uint256, __warp_usrid_29_amount1 : Uint256, __warp_usrid_30_data_len : felt, __warp_usrid_30_data : felt*)-> (){
    }
    
    func increaseObservationCardinalityNext_32148f67(__warp_usrid_31_observationCardinalityNext : felt)-> (){
    }
    
    func observe_883bdbfd(__warp_usrid_00_secondsAgos_len : felt, __warp_usrid_00_secondsAgos : felt*)-> (__warp_usrid_01_tickCumulatives_len : felt, __warp_usrid_01_tickCumulatives : felt*, __warp_usrid_02_secondsPerLiquidityCumulativeX128s_len : felt, __warp_usrid_02_secondsPerLiquidityCumulativeX128s : felt*){
    }
    
    func snapshotCumulativesInside_a38807f2(__warp_usrid_03_tickLower : felt, __warp_usrid_04_tickUpper : felt)-> (__warp_usrid_05_tickCumulativeInside : felt, __warp_usrid_06_secondsPerLiquidityInsideX128 : felt, __warp_usrid_07_secondsInside : felt){
    }
    
    func slot0_3850c7bd()-> (__warp_usrid_00_sqrtPriceX96 : felt, __warp_usrid_01_tick : felt, __warp_usrid_02_observationIndex : felt, __warp_usrid_03_observationCardinality : felt, __warp_usrid_04_observationCardinalityNext : felt, __warp_usrid_05_feeProtocol : felt, __warp_usrid_06_unlocked : felt){
    }
    
    func feeGrowthGlobal0X128_f3058399()-> (__warp_usrid_07_ : Uint256){
    }
    
    func feeGrowthGlobal1X128_46141319()-> (__warp_usrid_08_ : Uint256){
    }
    
    func protocolFees_1ad8b03b()-> (__warp_usrid_09_token0 : felt, __warp_usrid_10_token1 : felt){
    }
    
    func liquidity_1a686502()-> (__warp_usrid_11_ : felt){
    }
    
    func ticks_f30dba93(__warp_usrid_12_tick : felt)-> (__warp_usrid_13_liquidityGross : felt, __warp_usrid_14_liquidityNet : felt, __warp_usrid_15_feeGrowthOutside0X128 : Uint256, __warp_usrid_16_feeGrowthOutside1X128 : Uint256, __warp_usrid_17_tickCumulativeOutside : felt, __warp_usrid_18_secondsPerLiquidityOutsideX128 : felt, __warp_usrid_19_secondsOutside : felt, __warp_usrid_20_initialized : felt){
    }
    
    func tickBitmap_5339c296(__warp_usrid_21_wordPosition : felt)-> (__warp_usrid_22_ : Uint256){
    }
    
    func positions_514ea4bf(__warp_usrid_23_key : Uint256)-> (__warp_usrid_24__liquidity : felt, __warp_usrid_25_feeGrowthInside0LastX128 : Uint256, __warp_usrid_26_feeGrowthInside1LastX128 : Uint256, __warp_usrid_27_tokensOwed0 : felt, __warp_usrid_28_tokensOwed1 : felt){
    }
    
    func observations_252c09d7(__warp_usrid_29_index : Uint256)-> (__warp_usrid_30_blockTimestamp : felt, __warp_usrid_31_tickCumulative : felt, __warp_usrid_32_secondsPerLiquidityCumulativeX128 : felt, __warp_usrid_33_initialized : felt){
    }
    
    func factory_c45a0155()-> (__warp_usrid_00_ : felt){
    }
    
    func token0_0dfe1681()-> (__warp_usrid_01_ : felt){
    }
    
    func token1_d21220a7()-> (__warp_usrid_02_ : felt){
    }
    
    func fee_ddca3f43()-> (__warp_usrid_03_ : felt){
    }
    
    func tickSpacing_d0c93a7c()-> (__warp_usrid_04_ : felt){
    }
    
    func maxLiquidityPerTick_70cf754a()-> (__warp_usrid_05_ : felt){
    }
    
}


// Contract Def IERC20Minimal@interface


@contract_interface
namespace IERC20Minimal_warped_interface{
    func balanceOf_70a08231(__warp_usrid_00_account : felt)-> (__warp_usrid_01_ : Uint256){
    }
    
    func transfer_a9059cbb(__warp_usrid_02_recipient : felt, __warp_usrid_03_amount : Uint256)-> (__warp_usrid_04_ : felt){
    }
    
    func allowance_dd62ed3e(__warp_usrid_05_owner : felt, __warp_usrid_06_spender : felt)-> (__warp_usrid_07_ : Uint256){
    }
    
    func approve_095ea7b3(__warp_usrid_08_spender : felt, __warp_usrid_09_amount : Uint256)-> (__warp_usrid_10_ : felt){
    }
    
    func transferFrom_23b872dd(__warp_usrid_11_sender : felt, __warp_usrid_12_recipient : felt, __warp_usrid_13_amount : Uint256)-> (__warp_usrid_14_ : felt){
    }
    
}

// Original soldity abi: ["constructor()","swapExact0For1(address,uint256,address,uint160)","swap0ForExact1(address,uint256,address,uint160)","swapExact1For0(address,uint256,address,uint160)","swap1ForExact0(address,uint256,address,uint160)","swapToLowerSqrtPrice(address,uint160,address)","swapToHigherSqrtPrice(address,uint160,address)","uniswapV3SwapCallback(int256,int256,bytes)","mint(address,address,int24,int24,uint128)","uniswapV3MintCallback(uint256,uint256,bytes)","flash(address,address,uint256,uint256,uint256,uint256)","uniswapV3FlashCallback(uint256,uint256,bytes)"]