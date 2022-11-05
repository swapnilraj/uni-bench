%lang starknet


from warplib.maths.external_input_check_ints import warp_external_input_check_int24, warp_external_input_check_int160
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.lt_signed import warp_lt_signed24
from warplib.maths.int_conversions import warp_int24_to_int256, warp_uint256, warp_int256_to_int160, warp_int256_to_int24
from warplib.maths.negate import warp_negate256
from warplib.maths.le import warp_le256, warp_le
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.neq import warp_neq256
from warplib.maths.mul_unsafe import warp_mul_unsafe256
from warplib.maths.shr import warp_shr256, warp_shr256_256
from warplib.maths.gt_signed import warp_gt_signed24
from warplib.maths.div_unsafe import warp_div_unsafe256
from warplib.maths.mod import warp_mod256
from warplib.maths.eq import warp_eq256, warp_eq
from warplib.maths.add_unsafe import warp_add_unsafe256
from warplib.maths.ge import warp_ge, warp_ge256
from warplib.maths.lt import warp_lt
from warplib.maths.shl import warp_shl256, warp_shl256_256
from warplib.maths.gt import warp_gt256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.sub_unsafe import warp_sub_unsafe256
from warplib.maths.sub_signed_unsafe import warp_sub_signed_unsafe256
from warplib.maths.mul_signed_unsafe import warp_mul_signed_unsafe256
from warplib.maths.shr_signed import warp_shr_signed256
from warplib.maths.add_signed_unsafe import warp_add_signed_unsafe256


// Contract Def TickMathTest


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

namespace TickMathTest{

    // Dynamic variables - Arrays and Maps

    // Static variables

    // @notice Calculates sqrt(1.0001^tick) * 2^96
    // @dev Throws if |tick| > max tick
    // @param tick The input tick for the above formula
    // @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
    // at the given tick
    func s1_getSqrtRatioAtTick_986cfba3{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_04_tick : felt)-> (__warp_usrid_05_sqrtPriceX96 : felt){
    alloc_locals;


        
        let __warp_usrid_05_sqrtPriceX96 = 0;
        
            
            let __warp_usrid_06_absTick = Uint256(low=0, high=0);
            
            let (__warp_se_0) = warp_lt_signed24(__warp_usrid_04_tick, 0);
            
                
                if (__warp_se_0 != 0){
                
                    
                    let (__warp_se_1) = warp_int24_to_int256(__warp_usrid_04_tick);
                    
                    let (__warp_se_2) = warp_negate256(__warp_se_1);
                    
                    let __warp_usrid_06_absTick = __warp_se_2;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    
                    let (__warp_se_3) = warp_int24_to_int256(__warp_usrid_04_tick);
                    
                    let __warp_usrid_06_absTick = __warp_se_3;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_4) = warp_uint256(887272);
            
            let (__warp_se_5) = warp_le256(__warp_usrid_06_absTick, __warp_se_4);
            
            with_attr error_message("T"){
                assert __warp_se_5 = 1;
            }
            
            let __warp_usrid_07_ratio = Uint256(low=0, high=1);
            
            let (__warp_se_6) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=1, high=0));
            
            let (__warp_se_7) = warp_neq256(__warp_se_6, Uint256(low=0, high=0));
            
                
                if (__warp_se_7 != 0){
                
                    
                    let __warp_usrid_07_ratio = Uint256(low=340265354078544963557816517032075149313, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_8) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=2, high=0));
            
            let (__warp_se_9) = warp_neq256(__warp_se_8, Uint256(low=0, high=0));
            
                
                if (__warp_se_9 != 0){
                
                    
                    let (__warp_se_10) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=340248342086729790484326174814286782778, high=0));
                    
                    let (__warp_se_11) = warp_shr256(__warp_se_10, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_11;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_12) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=4, high=0));
            
            let (__warp_se_13) = warp_neq256(__warp_se_12, Uint256(low=0, high=0));
            
                
                if (__warp_se_13 != 0){
                
                    
                    let (__warp_se_14) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=340214320654664324051920982716015181260, high=0));
                    
                    let (__warp_se_15) = warp_shr256(__warp_se_14, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_15;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_16) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=8, high=0));
            
            let (__warp_se_17) = warp_neq256(__warp_se_16, Uint256(low=0, high=0));
            
                
                if (__warp_se_17 != 0){
                
                    
                    let (__warp_se_18) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=340146287995602323631171512101879684304, high=0));
                    
                    let (__warp_se_19) = warp_shr256(__warp_se_18, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_19;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_20) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=16, high=0));
            
            let (__warp_se_21) = warp_neq256(__warp_se_20, Uint256(low=0, high=0));
            
                
                if (__warp_se_21 != 0){
                
                    
                    let (__warp_se_22) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=340010263488231146823593991679159461444, high=0));
                    
                    let (__warp_se_23) = warp_shr256(__warp_se_22, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_23;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_24) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=32, high=0));
            
            let (__warp_se_25) = warp_neq256(__warp_se_24, Uint256(low=0, high=0));
            
                
                if (__warp_se_25 != 0){
                
                    
                    let (__warp_se_26) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=339738377640345403697157401104375502016, high=0));
                    
                    let (__warp_se_27) = warp_shr256(__warp_se_26, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_27;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_28) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=64, high=0));
            
            let (__warp_se_29) = warp_neq256(__warp_se_28, Uint256(low=0, high=0));
            
                
                if (__warp_se_29 != 0){
                
                    
                    let (__warp_se_30) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=339195258003219555707034227454543997025, high=0));
                    
                    let (__warp_se_31) = warp_shr256(__warp_se_30, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_31;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_32) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=128, high=0));
            
            let (__warp_se_33) = warp_neq256(__warp_se_32, Uint256(low=0, high=0));
            
                
                if (__warp_se_33 != 0){
                
                    
                    let (__warp_se_34) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=338111622100601834656805679988414885971, high=0));
                    
                    let (__warp_se_35) = warp_shr256(__warp_se_34, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_35;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_36) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=256, high=0));
            
            let (__warp_se_37) = warp_neq256(__warp_se_36, Uint256(low=0, high=0));
            
                
                if (__warp_se_37 != 0){
                
                    
                    let (__warp_se_38) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=335954724994790223023589805789778977700, high=0));
                    
                    let (__warp_se_39) = warp_shr256(__warp_se_38, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_39;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_40) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=512, high=0));
            
            let (__warp_se_41) = warp_neq256(__warp_se_40, Uint256(low=0, high=0));
            
                
                if (__warp_se_41 != 0){
                
                    
                    let (__warp_se_42) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=331682121138379247127172139078559817300, high=0));
                    
                    let (__warp_se_43) = warp_shr256(__warp_se_42, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_43;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_44) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=1024, high=0));
            
            let (__warp_se_45) = warp_neq256(__warp_se_44, Uint256(low=0, high=0));
            
                
                if (__warp_se_45 != 0){
                
                    
                    let (__warp_se_46) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=323299236684853023288211250268160618739, high=0));
                    
                    let (__warp_se_47) = warp_shr256(__warp_se_46, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_47;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_48) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=2048, high=0));
            
            let (__warp_se_49) = warp_neq256(__warp_se_48, Uint256(low=0, high=0));
            
                
                if (__warp_se_49 != 0){
                
                    
                    let (__warp_se_50) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=307163716377032989948697243942600083929, high=0));
                    
                    let (__warp_se_51) = warp_shr256(__warp_se_50, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_51;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_52) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=4096, high=0));
            
            let (__warp_se_53) = warp_neq256(__warp_se_52, Uint256(low=0, high=0));
            
                
                if (__warp_se_53 != 0){
                
                    
                    let (__warp_se_54) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=277268403626896220162999269216087595045, high=0));
                    
                    let (__warp_se_55) = warp_shr256(__warp_se_54, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_55;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_56) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=8192, high=0));
            
            let (__warp_se_57) = warp_neq256(__warp_se_56, Uint256(low=0, high=0));
            
                
                if (__warp_se_57 != 0){
                
                    
                    let (__warp_se_58) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=225923453940442621947126027127485391333, high=0));
                    
                    let (__warp_se_59) = warp_shr256(__warp_se_58, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_59;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_60) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=16384, high=0));
            
            let (__warp_se_61) = warp_neq256(__warp_se_60, Uint256(low=0, high=0));
            
                
                if (__warp_se_61 != 0){
                
                    
                    let (__warp_se_62) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=149997214084966997727330242082538205943, high=0));
                    
                    let (__warp_se_63) = warp_shr256(__warp_se_62, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_63;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_64) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=32768, high=0));
            
            let (__warp_se_65) = warp_neq256(__warp_se_64, Uint256(low=0, high=0));
            
                
                if (__warp_se_65 != 0){
                
                    
                    let (__warp_se_66) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=66119101136024775622716233608466517926, high=0));
                    
                    let (__warp_se_67) = warp_shr256(__warp_se_66, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_67;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_68) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=65536, high=0));
            
            let (__warp_se_69) = warp_neq256(__warp_se_68, Uint256(low=0, high=0));
            
                
                if (__warp_se_69 != 0){
                
                    
                    let (__warp_se_70) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=12847376061809297530290974190478138313, high=0));
                    
                    let (__warp_se_71) = warp_shr256(__warp_se_70, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_71;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_72) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=131072, high=0));
            
            let (__warp_se_73) = warp_neq256(__warp_se_72, Uint256(low=0, high=0));
            
                
                if (__warp_se_73 != 0){
                
                    
                    let (__warp_se_74) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=485053260817066172746253684029974020, high=0));
                    
                    let (__warp_se_75) = warp_shr256(__warp_se_74, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_75;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_76) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=262144, high=0));
            
            let (__warp_se_77) = warp_neq256(__warp_se_76, Uint256(low=0, high=0));
            
                
                if (__warp_se_77 != 0){
                
                    
                    let (__warp_se_78) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=691415978906521570653435304214168, high=0));
                    
                    let (__warp_se_79) = warp_shr256(__warp_se_78, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_79;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
            
            let (__warp_se_80) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=524288, high=0));
            
            let (__warp_se_81) = warp_neq256(__warp_se_80, Uint256(low=0, high=0));
            
                
                if (__warp_se_81 != 0){
                
                    
                    let (__warp_se_82) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=1404880482679654955896180642, high=0));
                    
                    let (__warp_se_83) = warp_shr256(__warp_se_82, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_83;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
            
            let (__warp_se_84) = warp_gt_signed24(__warp_usrid_04_tick, 0);
            
                
                if (__warp_se_84 != 0){
                
                    
                    let (__warp_se_85) = warp_div_unsafe256(Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455), __warp_usrid_07_ratio);
                    
                    let __warp_usrid_07_ratio = __warp_se_85;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                tempvar __warp_usrid_07_ratio = __warp_usrid_07_ratio;
            
            let (__warp_se_86) = warp_mod256(__warp_usrid_07_ratio, Uint256(low=4294967296, high=0));
            
            let (__warp_se_87) = warp_eq256(__warp_se_86, Uint256(low=0, high=0));
            
                
                if (__warp_se_87 != 0){
                
                    
                    let (__warp_se_88) = warp_shr256(__warp_usrid_07_ratio, 32);
                    
                    let (__warp_se_89) = warp_int256_to_int160(__warp_se_88);
                    
                    let __warp_usrid_05_sqrtPriceX96 = __warp_se_89;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                }else{
                
                    
                    let (__warp_se_90) = warp_shr256(__warp_usrid_07_ratio, 32);
                    
                    let (__warp_se_91) = warp_add_unsafe256(__warp_se_90, Uint256(low=1, high=0));
                    
                    let (__warp_se_92) = warp_int256_to_int160(__warp_se_91);
                    
                    let __warp_usrid_05_sqrtPriceX96 = __warp_se_92;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
        
        
        
        return (__warp_usrid_05_sqrtPriceX96,);

    }


    func __warp_conditional_s1_getTickAtSqrtRatio_4f76c058_1{range_check_ptr : felt}(__warp_usrid_08_sqrtPriceX96 : felt)-> (__warp_rc_0 : felt, __warp_usrid_08_sqrtPriceX96 : felt){
    alloc_locals;


        
        let (__warp_se_93) = warp_ge(__warp_usrid_08_sqrtPriceX96, 4295128739);
        
        if (__warp_se_93 != 0){
        
            
            let (__warp_se_94) = warp_lt(__warp_usrid_08_sqrtPriceX96, 1461446703485210103287273052203988822378723970342);
            
            let __warp_rc_0 = __warp_se_94;
            
            let __warp_rc_0 = __warp_rc_0;
            
            let __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
            
            
            
            return (__warp_rc_0, __warp_usrid_08_sqrtPriceX96);
        }else{
        
            
            let __warp_rc_0 = 0;
            
            let __warp_rc_0 = __warp_rc_0;
            
            let __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
            
            
            
            return (__warp_rc_0, __warp_usrid_08_sqrtPriceX96);
        }

    }

    // @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
    // @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
    // ever return.
    // @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
    // @return tick The greatest tick for which the ratio is less than or equal to the input ratio
    func s1_getTickAtSqrtRatio_4f76c058{syscall_ptr : felt*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_08_sqrtPriceX96 : felt)-> (__warp_usrid_09_tick : felt){
    alloc_locals;


        
        let __warp_usrid_09_tick = 0;
        
            
            let __warp_rc_0 = 0;
            
                
                let (__warp_tv_0, __warp_tv_1) = __warp_conditional_s1_getTickAtSqrtRatio_4f76c058_1(__warp_usrid_08_sqrtPriceX96);
                
                let __warp_usrid_08_sqrtPriceX96 = __warp_tv_1;
                
                let __warp_rc_0 = __warp_tv_0;
            
            with_attr error_message("R"){
                assert __warp_rc_0 = 1;
            }
            
            let (__warp_se_95) = warp_uint256(__warp_usrid_08_sqrtPriceX96);
            
            let (__warp_usrid_10_ratio) = warp_shl256(__warp_se_95, 32);
            
            let __warp_usrid_11_r = __warp_usrid_10_ratio;
            
            let __warp_usrid_12_msb = Uint256(low=0, high=0);
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_96) = warp_gt256(__warp_usrid_11_r, Uint256(low=340282366920938463463374607431768211455, high=0));
            
                
                if (__warp_se_96 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=128, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_97) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_97;
            
            let (__warp_se_98) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_98;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_99) = warp_gt256(__warp_usrid_11_r, Uint256(low=18446744073709551615, high=0));
            
                
                if (__warp_se_99 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=64, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_100) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_100;
            
            let (__warp_se_101) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_101;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_102) = warp_gt256(__warp_usrid_11_r, Uint256(low=4294967295, high=0));
            
                
                if (__warp_se_102 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=32, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_103) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_103;
            
            let (__warp_se_104) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_104;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_105) = warp_gt256(__warp_usrid_11_r, Uint256(low=65535, high=0));
            
                
                if (__warp_se_105 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=16, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_106) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_106;
            
            let (__warp_se_107) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_107;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_108) = warp_gt256(__warp_usrid_11_r, Uint256(low=255, high=0));
            
                
                if (__warp_se_108 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=8, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_109) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_109;
            
            let (__warp_se_110) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_110;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_111) = warp_gt256(__warp_usrid_11_r, Uint256(low=15, high=0));
            
                
                if (__warp_se_111 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=4, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_112) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_112;
            
            let (__warp_se_113) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_113;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_114) = warp_gt256(__warp_usrid_11_r, Uint256(low=3, high=0));
            
                
                if (__warp_se_114 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=2, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_115) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_115;
            
            let (__warp_se_116) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_116;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_117) = warp_gt256(__warp_usrid_11_r, Uint256(low=1, high=0));
            
                
                if (__warp_se_117 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=1, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_118) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_118;
            
            let (__warp_se_119) = warp_ge256(__warp_usrid_12_msb, Uint256(low=128, high=0));
            
                
                if (__warp_se_119 != 0){
                
                    
                    let (__warp_se_120) = warp_sub_unsafe256(__warp_usrid_12_msb, Uint256(low=127, high=0));
                    
                    let (__warp_se_121) = warp_shr256_256(__warp_usrid_10_ratio, __warp_se_120);
                    
                    let __warp_usrid_11_r = __warp_se_121;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                }else{
                
                    
                    let (__warp_se_122) = warp_sub_unsafe256(Uint256(low=127, high=0), __warp_usrid_12_msb);
                    
                    let (__warp_se_123) = warp_shl256_256(__warp_usrid_10_ratio, __warp_se_122);
                    
                    let __warp_usrid_11_r = __warp_se_123;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
            
            let (__warp_se_124) = warp_sub_signed_unsafe256(__warp_usrid_12_msb, Uint256(low=128, high=0));
            
            let (__warp_usrid_14_log_2) = warp_shl256(__warp_se_124, 64);
            
            let (__warp_se_125) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_126) = warp_shr256(__warp_se_125, 127);
            
            let __warp_usrid_11_r = __warp_se_126;
            
            let (__warp_se_127) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_127;
            
            let (__warp_se_128) = warp_shl256(__warp_usrid_13_f, 63);
            
            let (__warp_se_129) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_128);
            
            let __warp_usrid_14_log_2 = __warp_se_129;
            
            let (__warp_se_130) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_130;
            
            let (__warp_se_131) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_132) = warp_shr256(__warp_se_131, 127);
            
            let __warp_usrid_11_r = __warp_se_132;
            
            let (__warp_se_133) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_133;
            
            let (__warp_se_134) = warp_shl256(__warp_usrid_13_f, 62);
            
            let (__warp_se_135) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_134);
            
            let __warp_usrid_14_log_2 = __warp_se_135;
            
            let (__warp_se_136) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_136;
            
            let (__warp_se_137) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_138) = warp_shr256(__warp_se_137, 127);
            
            let __warp_usrid_11_r = __warp_se_138;
            
            let (__warp_se_139) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_139;
            
            let (__warp_se_140) = warp_shl256(__warp_usrid_13_f, 61);
            
            let (__warp_se_141) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_140);
            
            let __warp_usrid_14_log_2 = __warp_se_141;
            
            let (__warp_se_142) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_142;
            
            let (__warp_se_143) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_144) = warp_shr256(__warp_se_143, 127);
            
            let __warp_usrid_11_r = __warp_se_144;
            
            let (__warp_se_145) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_145;
            
            let (__warp_se_146) = warp_shl256(__warp_usrid_13_f, 60);
            
            let (__warp_se_147) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_146);
            
            let __warp_usrid_14_log_2 = __warp_se_147;
            
            let (__warp_se_148) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_148;
            
            let (__warp_se_149) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_150) = warp_shr256(__warp_se_149, 127);
            
            let __warp_usrid_11_r = __warp_se_150;
            
            let (__warp_se_151) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_151;
            
            let (__warp_se_152) = warp_shl256(__warp_usrid_13_f, 59);
            
            let (__warp_se_153) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_152);
            
            let __warp_usrid_14_log_2 = __warp_se_153;
            
            let (__warp_se_154) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_154;
            
            let (__warp_se_155) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_156) = warp_shr256(__warp_se_155, 127);
            
            let __warp_usrid_11_r = __warp_se_156;
            
            let (__warp_se_157) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_157;
            
            let (__warp_se_158) = warp_shl256(__warp_usrid_13_f, 58);
            
            let (__warp_se_159) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_158);
            
            let __warp_usrid_14_log_2 = __warp_se_159;
            
            let (__warp_se_160) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_160;
            
            let (__warp_se_161) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_162) = warp_shr256(__warp_se_161, 127);
            
            let __warp_usrid_11_r = __warp_se_162;
            
            let (__warp_se_163) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_163;
            
            let (__warp_se_164) = warp_shl256(__warp_usrid_13_f, 57);
            
            let (__warp_se_165) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_164);
            
            let __warp_usrid_14_log_2 = __warp_se_165;
            
            let (__warp_se_166) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_166;
            
            let (__warp_se_167) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_168) = warp_shr256(__warp_se_167, 127);
            
            let __warp_usrid_11_r = __warp_se_168;
            
            let (__warp_se_169) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_169;
            
            let (__warp_se_170) = warp_shl256(__warp_usrid_13_f, 56);
            
            let (__warp_se_171) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_170);
            
            let __warp_usrid_14_log_2 = __warp_se_171;
            
            let (__warp_se_172) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_172;
            
            let (__warp_se_173) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_174) = warp_shr256(__warp_se_173, 127);
            
            let __warp_usrid_11_r = __warp_se_174;
            
            let (__warp_se_175) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_175;
            
            let (__warp_se_176) = warp_shl256(__warp_usrid_13_f, 55);
            
            let (__warp_se_177) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_176);
            
            let __warp_usrid_14_log_2 = __warp_se_177;
            
            let (__warp_se_178) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_178;
            
            let (__warp_se_179) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_180) = warp_shr256(__warp_se_179, 127);
            
            let __warp_usrid_11_r = __warp_se_180;
            
            let (__warp_se_181) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_181;
            
            let (__warp_se_182) = warp_shl256(__warp_usrid_13_f, 54);
            
            let (__warp_se_183) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_182);
            
            let __warp_usrid_14_log_2 = __warp_se_183;
            
            let (__warp_se_184) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_184;
            
            let (__warp_se_185) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_186) = warp_shr256(__warp_se_185, 127);
            
            let __warp_usrid_11_r = __warp_se_186;
            
            let (__warp_se_187) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_187;
            
            let (__warp_se_188) = warp_shl256(__warp_usrid_13_f, 53);
            
            let (__warp_se_189) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_188);
            
            let __warp_usrid_14_log_2 = __warp_se_189;
            
            let (__warp_se_190) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_190;
            
            let (__warp_se_191) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_192) = warp_shr256(__warp_se_191, 127);
            
            let __warp_usrid_11_r = __warp_se_192;
            
            let (__warp_se_193) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_193;
            
            let (__warp_se_194) = warp_shl256(__warp_usrid_13_f, 52);
            
            let (__warp_se_195) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_194);
            
            let __warp_usrid_14_log_2 = __warp_se_195;
            
            let (__warp_se_196) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_196;
            
            let (__warp_se_197) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_198) = warp_shr256(__warp_se_197, 127);
            
            let __warp_usrid_11_r = __warp_se_198;
            
            let (__warp_se_199) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_199;
            
            let (__warp_se_200) = warp_shl256(__warp_usrid_13_f, 51);
            
            let (__warp_se_201) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_200);
            
            let __warp_usrid_14_log_2 = __warp_se_201;
            
            let (__warp_se_202) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_202;
            
            let (__warp_se_203) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_204) = warp_shr256(__warp_se_203, 127);
            
            let __warp_usrid_11_r = __warp_se_204;
            
            let (__warp_se_205) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_205;
            
            let (__warp_se_206) = warp_shl256(__warp_usrid_13_f, 50);
            
            let (__warp_se_207) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_206);
            
            let __warp_usrid_14_log_2 = __warp_se_207;
            
            let (__warp_se_208) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_208;
            
            let (__warp_usrid_15_log_sqrt10001) = warp_mul_signed_unsafe256(__warp_usrid_14_log_2, Uint256(low=255738958999603826347141, high=0));
            
            let (__warp_se_209) = warp_sub_signed_unsafe256(__warp_usrid_15_log_sqrt10001, Uint256(low=3402992956809132418596140100660247210, high=0));
            
            let (__warp_se_210) = warp_shr_signed256(__warp_se_209, 128);
            
            let (__warp_usrid_16_tickLow) = warp_int256_to_int24(__warp_se_210);
            
            let (__warp_se_211) = warp_add_signed_unsafe256(__warp_usrid_15_log_sqrt10001, Uint256(low=291339464771989622907027621153398088495, high=0));
            
            let (__warp_se_212) = warp_shr_signed256(__warp_se_211, 128);
            
            let (__warp_usrid_17_tickHi) = warp_int256_to_int24(__warp_se_212);
            
            let (__warp_se_213) = warp_eq(__warp_usrid_16_tickLow, __warp_usrid_17_tickHi);
            
                
                if (__warp_se_213 != 0){
                
                    
                    let __warp_usrid_09_tick = __warp_usrid_16_tickLow;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                }else{
                
                    
                    let (__warp_pse_2) = getSqrtRatioAtTick_986cfba3(__warp_usrid_17_tickHi);
                    
                    let (__warp_se_214) = warp_le(__warp_pse_2, __warp_usrid_08_sqrtPriceX96);
                    
                        
                        if (__warp_se_214 != 0){
                        
                            
                            let __warp_usrid_09_tick = __warp_usrid_17_tickHi;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                        }else{
                        
                            
                            let __warp_usrid_09_tick = __warp_usrid_16_tickLow;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
        
        
        
        return (__warp_usrid_09_tick,);

    }

}


    @view
    func getSqrtRatioAtTick_986cfba3{syscall_ptr : felt*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_tick : felt)-> (__warp_usrid_01_ : felt){
    alloc_locals;


        
        warp_external_input_check_int24(__warp_usrid_00_tick);
        
        let (__warp_pse_0) = TickMathTest.s1_getSqrtRatioAtTick_986cfba3(__warp_usrid_00_tick);
        
        
        
        return (__warp_pse_0,);

    }


    @view
    func getTickAtSqrtRatio_4f76c058{syscall_ptr : felt*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_02_sqrtPriceX96 : felt)-> (__warp_usrid_03_ : felt){
    alloc_locals;


        
        warp_external_input_check_int160(__warp_usrid_02_sqrtPriceX96);
        
        let (__warp_pse_1) = TickMathTest.s1_getTickAtSqrtRatio_4f76c058(__warp_usrid_02_sqrtPriceX96);
        
        
        
        return (__warp_pse_1,);

    }


    @view
    func MIN_SQRT_RATIO_ee8847ff{syscall_ptr : felt*, range_check_ptr : felt}()-> (__warp_usrid_04_ : felt){
    alloc_locals;


        
        
        
        return (4295128739,);

    }


    @view
    func MAX_SQRT_RATIO_6d2cc304{syscall_ptr : felt*, range_check_ptr : felt}()-> (__warp_usrid_05_ : felt){
    alloc_locals;


        
        
        
        return (1461446703485210103287273052203988822378723970342,);

    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(){
    alloc_locals;


        
        
        
        return ();

    }

// Original soldity abi: ["constructor()","getSqrtRatioAtTick(int24)","getTickAtSqrtRatio(uint160)","MIN_SQRT_RATIO()","MAX_SQRT_RATIO()"]