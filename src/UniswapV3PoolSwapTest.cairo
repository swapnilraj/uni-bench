%lang starknet


from warplib.memory import wm_read_felt, wm_read_256, wm_new
from starkware.cairo.common.uint256 import uint256_sub, uint256_add, Uint256
from starkware.cairo.common.alloc import alloc
from warplib.maths.utils import narrow_safe, felt_to_uint256
from warplib.maths.external_input_check_address import warp_external_input_check_address
from warplib.maths.external_input_check_bool import warp_external_input_check_bool
from warplib.maths.external_input_check_ints import warp_external_input_check_int256, warp_external_input_check_int160, warp_external_input_check_int8
from starkware.cairo.common.dict import dict_write
from warplib.dynamic_arrays_util import byte_array_to_felt_value, fixed_bytes256_to_felt_dynamic_array, felt_array_to_warp_memory_array
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.starknet.common.syscalls import get_caller_address
from warplib.maths.gt_signed import warp_gt_signed256


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


// Contract Def UniswapV3PoolSwapTest


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

namespace UniswapV3PoolSwapTest{

    // Dynamic variables - Arrays and Maps

    // Static variables

    const __warp_usrid_00__amount0Delta = 0;

    const __warp_usrid_01__amount1Delta = 2;

}


    @external
    func getSwapResult_7f2ba7bc{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_02_pool : felt, __warp_usrid_03_zeroForOne : felt, __warp_usrid_04_amountSpecified : Uint256, __warp_usrid_05_sqrtPriceLimitX96 : felt)-> (__warp_usrid_06_amount0Delta : Uint256, __warp_usrid_07_amount1Delta : Uint256, __warp_usrid_08_nextSqrtRatio : felt){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int160(__warp_usrid_05_sqrtPriceLimitX96);
        
        warp_external_input_check_int256(__warp_usrid_04_amountSpecified);
        
        warp_external_input_check_bool(__warp_usrid_03_zeroForOne);
        
        warp_external_input_check_address(__warp_usrid_02_pool);
        
        let __warp_usrid_08_nextSqrtRatio = 0;
        
        let __warp_usrid_07_amount1Delta = Uint256(low=0, high=0);
        
        let __warp_usrid_06_amount0Delta = Uint256(low=0, high=0);
        
            
            let (__warp_se_0) = get_caller_address();
            
            let (__warp_se_1) = abi_encode0(__warp_se_0);
            
            let (__warp_se_2) = wm_to_calldata0(__warp_se_1);
            
            let (__warp_tv_0, __warp_tv_1) = IUniswapV3Pool_warped_interface.swap_128acb08(__warp_usrid_02_pool, 0, __warp_usrid_03_zeroForOne, __warp_usrid_04_amountSpecified, __warp_usrid_05_sqrtPriceLimitX96, __warp_se_2.len, __warp_se_2.ptr);
            
            let __warp_usrid_07_amount1Delta = __warp_tv_1;
            
            let __warp_usrid_06_amount0Delta = __warp_tv_0;
        
        let __warp_usrid_09___warp_tf0 = 0;
        
        let __warp_usrid_10___warp_tf1 = 0;
        
        let __warp_usrid_11___warp_tf2 = 0;
        
        let __warp_usrid_12___warp_tf3 = 0;
        
        let __warp_usrid_13___warp_tf4 = 0;
        
        let __warp_usrid_14___warp_tf5 = 0;
        
            
            let (__warp_tv_2, __warp_tv_3, __warp_tv_4, __warp_tv_5, __warp_tv_6, __warp_tv_7, __warp_tv_8) = IUniswapV3Pool_warped_interface.slot0_3850c7bd(__warp_usrid_02_pool);
            
            let __warp_usrid_14___warp_tf5 = __warp_tv_8;
            
            let __warp_usrid_13___warp_tf4 = __warp_tv_7;
            
            let __warp_usrid_12___warp_tf3 = __warp_tv_6;
            
            let __warp_usrid_11___warp_tf2 = __warp_tv_5;
            
            let __warp_usrid_10___warp_tf1 = __warp_tv_4;
            
            let __warp_usrid_09___warp_tf0 = __warp_tv_3;
            
            let __warp_usrid_08_nextSqrtRatio = __warp_tv_2;
        
        let __warp_usrid_06_amount0Delta = __warp_usrid_06_amount0Delta;
        
        let __warp_usrid_07_amount1Delta = __warp_usrid_07_amount1Delta;
        
        let __warp_usrid_08_nextSqrtRatio = __warp_usrid_08_nextSqrtRatio;
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return (__warp_usrid_06_amount0Delta, __warp_usrid_07_amount1Delta, __warp_usrid_08_nextSqrtRatio);
    }
    }


    @external
    func uniswapV3SwapCallback_fa461e33{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_15_amount0Delta : Uint256, __warp_usrid_16_amount1Delta : Uint256, __warp_usrid_17_data_len : felt, __warp_usrid_17_data : felt*)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check0(__warp_usrid_17_data_len, __warp_usrid_17_data);
        
        warp_external_input_check_int256(__warp_usrid_16_amount1Delta);
        
        warp_external_input_check_int256(__warp_usrid_15_amount0Delta);
        
        local __warp_usrid_17_data_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_17_data_len, __warp_usrid_17_data);
        
        let (__warp_se_3) = cd_to_memory0(__warp_usrid_17_data_dstruct);
        
        let (__warp_usrid_18_sender) = abi_decode0(__warp_se_3);
        
        let (__warp_se_4) = warp_gt_signed256(__warp_usrid_15_amount0Delta, Uint256(low=0, high=0));
        
            
            if (__warp_se_4 != 0){
            
                
                let (__warp_se_5) = get_caller_address();
                
                let (__warp_pse_0) = IUniswapV3Pool_warped_interface.token0_0dfe1681(__warp_se_5);
                
                let (__warp_se_6) = get_caller_address();
                
                IERC20Minimal_warped_interface.transferFrom_23b872dd(__warp_pse_0, __warp_usrid_18_sender, __warp_se_6, __warp_usrid_15_amount0Delta);
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
            }else{
            
                
                let (__warp_se_7) = warp_gt_signed256(__warp_usrid_16_amount1Delta, Uint256(low=0, high=0));
                
                    
                    if (__warp_se_7 != 0){
                    
                        
                        let (__warp_se_8) = get_caller_address();
                        
                        let (__warp_pse_1) = IUniswapV3Pool_warped_interface.token1_d21220a7(__warp_se_8);
                        
                        let (__warp_se_9) = get_caller_address();
                        
                        IERC20Minimal_warped_interface.transferFrom_23b872dd(__warp_pse_1, __warp_usrid_18_sender, __warp_se_9, __warp_usrid_16_amount1Delta);
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
    WARP_USED_STORAGE.write(4);


        
        
        
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

// Original soldity abi: ["constructor()","getSwapResult(address,bool,int256,uint160)","uniswapV3SwapCallback(int256,int256,bytes)"]