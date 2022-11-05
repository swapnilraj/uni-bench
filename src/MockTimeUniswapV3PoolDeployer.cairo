%lang starknet


from warplib.memory import wm_alloc, wm_new
from starkware.cairo.common.dict import dict_write, dict_read
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.uint256 import Uint256
from warplib.maths.external_input_check_address import warp_external_input_check_address
from warplib.maths.external_input_check_ints import warp_external_input_check_int24
from warplib.maths.utils import felt_to_uint256
from warplib.dynamic_arrays_util import fixed_bytes256_to_felt_dynamic_array, fixed_bytes_to_felt_dynamic_array, felt_array_to_warp_memory_array
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.cairo_keccak.keccak import finalize_keccak
from warplib.keccak import warp_keccak
from warplib.maths.bytes_conversions import warp_bytes_narrow_256
from starkware.starknet.common.syscalls import deploy


// @declare contracts/test/MockTimeUniswapV3Pool.sol/MockTimeUniswapV3Pool.cairo
const MockTimeUniswapV3Pool_class_hash_0ffb5ed4 = 0x1e774e896c36f028b9f1ada224f9af064c9f55a8ce6697454e77b78b58346ea ;


struct Parameters_66d1f174{
    __warp_usrid_00_factory : felt,
    __warp_usrid_01_token0 : felt,
    __warp_usrid_02_token1 : felt,
    __warp_usrid_03_fee : felt,
    __warp_usrid_04_tickSpacing : felt,
}


struct cd_dynarray_felt{
     len : felt ,
     ptr : felt*,
}

func WM0_struct_Parameters_66d1f174{range_check_ptr, warp_memory: DictAccess*}(__warp_usrid_00_factory: felt, __warp_usrid_01_token0: felt, __warp_usrid_02_token1: felt, __warp_usrid_03_fee: felt, __warp_usrid_04_tickSpacing: felt) -> (res:felt){
    alloc_locals;
    let (start) = wm_alloc(Uint256(0x5, 0x0));
dict_write{dict_ptr=warp_memory}(start, __warp_usrid_00_factory);
dict_write{dict_ptr=warp_memory}(start + 1, __warp_usrid_01_token0);
dict_write{dict_ptr=warp_memory}(start + 2, __warp_usrid_02_token1);
dict_write{dict_ptr=warp_memory}(start + 3, __warp_usrid_03_fee);
dict_write{dict_ptr=warp_memory}(start + 4, __warp_usrid_04_tickSpacing);
    return (start,);
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
let (elem_mem_loc_4) = dict_read{dict_ptr=warp_memory}(mem_loc + 4);
WARP_STORAGE.write(loc + 4, elem_mem_loc_4);
    return (loc,);
}

func WS_STRUCT_Parameters_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt){
   alloc_locals;
    WS1_DELETE(loc);
    WS1_DELETE(loc + 1);
    WS1_DELETE(loc + 2);
    WS2_DELETE(loc + 3);
    WS3_DELETE(loc + 4);
   return ();
}

func WS1_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS2_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS3_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WSM0_Parameters_66d1f174___warp_usrid_00_factory(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM1_Parameters_66d1f174___warp_usrid_01_token0(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WSM2_Parameters_66d1f174___warp_usrid_02_token1(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WSM3_Parameters_66d1f174___warp_usrid_03_fee(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WSM4_Parameters_66d1f174___warp_usrid_04_tickSpacing(loc: felt) -> (memberLoc: felt){
    return (loc + 4,);
}

func WS0_READ_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func abi_encode_packed0{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(param0 : felt, param1 : felt, param2 : felt, param3 : felt) -> (result_ptr : felt){
  alloc_locals;
  let bytes_index : felt = 0;
  let (bytes_array : felt*) = alloc();
let (param0256) = felt_to_uint256(param0);
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param0256);
let bytes_index = bytes_index +  32;
let (param1256) = felt_to_uint256(param1);
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param1256);
let bytes_index = bytes_index +  32;
fixed_bytes_to_felt_dynamic_array(bytes_index,bytes_array,0,param2,3);
let bytes_index = bytes_index +  3;
fixed_bytes_to_felt_dynamic_array(bytes_index,bytes_array,0,param3,3);
let bytes_index = bytes_index +  3;
  let (max_length256) = felt_to_uint256(bytes_index);
  let (mem_ptr) = wm_new(max_length256, Uint256(0x1, 0x0));
  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_index);
  return (mem_ptr,);
}

func encode_as_felt0() -> (calldata_array : cd_dynarray_felt){
   alloc_locals;
   let total_size : felt = 0;
   let (decode_array : felt*) = alloc();
   let result = cd_dynarray_felt(total_size, decode_array);
   return (result,);
}


// Contract Def MockTimeUniswapV3PoolDeployer


@event
func PoolDeployed_f0d1eeab(__warp_usrid_06_pool : felt){
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

namespace MockTimeUniswapV3PoolDeployer{

    // Dynamic variables - Arrays and Maps

    // Static variables

    const __warp_usrid_05_parameters = 0;

}


    @external
    func deploy_fad5359f{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_07_factory : felt, __warp_usrid_08_token0 : felt, __warp_usrid_09_token1 : felt, __warp_usrid_10_fee : felt, __warp_usrid_11_tickSpacing : felt)-> (__warp_usrid_12_pool : felt){
    alloc_locals;
    let (local keccak_ptr_start : felt*) = alloc();
    let keccak_ptr = keccak_ptr_start;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory, keccak_ptr{

        
        warp_external_input_check_int24(__warp_usrid_11_tickSpacing);
        
        warp_external_input_check_int24(__warp_usrid_10_fee);
        
        warp_external_input_check_address(__warp_usrid_09_token1);
        
        warp_external_input_check_address(__warp_usrid_08_token0);
        
        warp_external_input_check_address(__warp_usrid_07_factory);
        
        let __warp_usrid_12_pool = 0;
        
        let (__warp_se_0) = WM0_struct_Parameters_66d1f174(__warp_usrid_07_factory, __warp_usrid_08_token0, __warp_usrid_09_token1, __warp_usrid_10_fee, __warp_usrid_11_tickSpacing);
        
        wm_to_storage0(MockTimeUniswapV3PoolDeployer.__warp_usrid_05_parameters, __warp_se_0);
        
        let (__warp_se_1) = abi_encode_packed0(__warp_usrid_08_token0, __warp_usrid_09_token1, __warp_usrid_10_fee, __warp_usrid_11_tickSpacing);
        
        let (__warp_se_2) = warp_keccak(__warp_se_1);
        
        let (__warp_se_3) = warp_bytes_narrow_256(__warp_se_2, 8);
        
        let (__warp_se_4) = encode_as_felt0();
        
        let (__warp_se_5) = deploy(MockTimeUniswapV3Pool_class_hash_0ffb5ed4,__warp_se_3,__warp_se_4.len, __warp_se_4.ptr,0);
        
        let __warp_usrid_12_pool = __warp_se_5;
        
        PoolDeployed_f0d1eeab.emit(__warp_usrid_12_pool);
        
        WS_STRUCT_Parameters_DELETE(MockTimeUniswapV3PoolDeployer.__warp_usrid_05_parameters);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        finalize_keccak(keccak_ptr_start, keccak_ptr);
        
        return (__warp_usrid_12_pool,);
    }
    }


    @view
    func parameters_89035730{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_13_ : felt, __warp_usrid_14_ : felt, __warp_usrid_15_ : felt, __warp_usrid_16_ : felt, __warp_usrid_17_ : felt){
    alloc_locals;


        
        let __warp_usrid_18__temp0 = MockTimeUniswapV3PoolDeployer.__warp_usrid_05_parameters;
        
        let (__warp_se_6) = WSM0_Parameters_66d1f174___warp_usrid_00_factory(__warp_usrid_18__temp0);
        
        let (__warp_usrid_13_) = WS0_READ_felt(__warp_se_6);
        
        let (__warp_se_7) = WSM1_Parameters_66d1f174___warp_usrid_01_token0(__warp_usrid_18__temp0);
        
        let (__warp_usrid_14_) = WS0_READ_felt(__warp_se_7);
        
        let (__warp_se_8) = WSM2_Parameters_66d1f174___warp_usrid_02_token1(__warp_usrid_18__temp0);
        
        let (__warp_usrid_15_) = WS0_READ_felt(__warp_se_8);
        
        let (__warp_se_9) = WSM3_Parameters_66d1f174___warp_usrid_03_fee(__warp_usrid_18__temp0);
        
        let (__warp_usrid_16_) = WS0_READ_felt(__warp_se_9);
        
        let (__warp_se_10) = WSM4_Parameters_66d1f174___warp_usrid_04_tickSpacing(__warp_usrid_18__temp0);
        
        let (__warp_usrid_17_) = WS0_READ_felt(__warp_se_10);
        
        
        
        return (__warp_usrid_13_, __warp_usrid_14_, __warp_usrid_15_, __warp_usrid_16_, __warp_usrid_17_);

    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(){
    alloc_locals;
    WARP_USED_STORAGE.write(5);


        
        
        
        return ();

    }

// Original soldity abi: ["constructor()","deploy(address,address,address,uint24,int24)","parameters()"]