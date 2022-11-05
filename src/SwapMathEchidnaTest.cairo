%lang starknet


from warplib.maths.external_input_check_ints import warp_external_input_check_int160, warp_external_input_check_int128, warp_external_input_check_int256, warp_external_input_check_int24
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.gt import warp_gt, warp_gt256
from warplib.maths.lt import warp_lt, warp_lt256
from warplib.maths.sub import warp_sub256
from warplib.maths.le import warp_le256, warp_le
from warplib.maths.lt_signed import warp_lt_signed256
from warplib.maths.negate import warp_negate256
from warplib.maths.add import warp_add256
from warplib.maths.eq import warp_eq, warp_eq256
from warplib.maths.neq import warp_neq
from warplib.maths.ge import warp_ge, warp_ge256
from warplib.maths.ge_signed import warp_ge_signed256
from warplib.maths.sub_unsafe import warp_sub_unsafe24, warp_sub_unsafe256, warp_sub_unsafe160
from warplib.maths.int_conversions import warp_uint256, warp_int256_to_int160
from warplib.maths.mul_unsafe import warp_mul_unsafe256
from warplib.maths.mulmod import warp_mulmod
from warplib.maths.div_unsafe import warp_div_unsafe256
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.add_unsafe import warp_add_unsafe256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.xor import warp_xor256
from warplib.maths.mul import warp_mul256
from warplib.maths.div import warp_div256
from warplib.maths.shl import warp_shl256
from warplib.maths.mod import warp_mod256


// Contract Def SwapMathEchidnaTest


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

namespace SwapMathEchidnaTest{

    // Dynamic variables - Arrays and Maps

    // Static variables


    func __warp_conditional_computeSwapStep_100d3f74_1(__warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt)-> (__warp_rc_0 : felt, __warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt){
    alloc_locals;


        
        if (__warp_usrid_12_max != 0){
        
            
            let __warp_rc_0 = __warp_usrid_10_exactIn;
            
            let __warp_rc_0 = __warp_rc_0;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_0, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }else{
        
            
            let __warp_rc_0 = 0;
            
            let __warp_rc_0 = __warp_rc_0;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_0, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }

    }


    func __warp_conditional_computeSwapStep_100d3f74_3(__warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt)-> (__warp_rc_2 : felt, __warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt){
    alloc_locals;


        
        if (__warp_usrid_12_max != 0){
        
            
            let __warp_rc_2 = 1 - __warp_usrid_10_exactIn;
            
            let __warp_rc_2 = __warp_rc_2;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_2, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }else{
        
            
            let __warp_rc_2 = 0;
            
            let __warp_rc_2 = __warp_rc_2;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_2, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }

    }


    func __warp_conditional_computeSwapStep_100d3f74_5(__warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt)-> (__warp_rc_4 : felt, __warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt){
    alloc_locals;


        
        if (__warp_usrid_12_max != 0){
        
            
            let __warp_rc_4 = __warp_usrid_10_exactIn;
            
            let __warp_rc_4 = __warp_rc_4;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_4, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }else{
        
            
            let __warp_rc_4 = 0;
            
            let __warp_rc_4 = __warp_rc_4;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_4, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }

    }


    func __warp_conditional_computeSwapStep_100d3f74_7(__warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt)-> (__warp_rc_6 : felt, __warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt){
    alloc_locals;


        
        if (__warp_usrid_12_max != 0){
        
            
            let __warp_rc_6 = 1 - __warp_usrid_10_exactIn;
            
            let __warp_rc_6 = __warp_rc_6;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_6, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }else{
        
            
            let __warp_rc_6 = 0;
            
            let __warp_rc_6 = __warp_rc_6;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_6, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }

    }


    func __warp_conditional_computeSwapStep_100d3f74_9{range_check_ptr : felt}(__warp_usrid_10_exactIn : felt, __warp_usrid_07_amountOut : Uint256, __warp_usrid_03_amountRemaining : Uint256)-> (__warp_rc_8 : felt, __warp_usrid_10_exactIn : felt, __warp_usrid_07_amountOut : Uint256, __warp_usrid_03_amountRemaining : Uint256){
    alloc_locals;


        
        if (1 - __warp_usrid_10_exactIn != 0){
        
            
            let (__warp_se_27) = warp_negate256(__warp_usrid_03_amountRemaining);
            
            let (__warp_se_28) = warp_gt256(__warp_usrid_07_amountOut, __warp_se_27);
            
            let __warp_rc_8 = __warp_se_28;
            
            let __warp_rc_8 = __warp_rc_8;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            let __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
            
            let __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
            
            
            
            return (__warp_rc_8, __warp_usrid_10_exactIn, __warp_usrid_07_amountOut, __warp_usrid_03_amountRemaining);
        }else{
        
            
            let __warp_rc_8 = 0;
            
            let __warp_rc_8 = __warp_rc_8;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            let __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
            
            let __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
            
            
            
            return (__warp_rc_8, __warp_usrid_10_exactIn, __warp_usrid_07_amountOut, __warp_usrid_03_amountRemaining);
        }

    }


    func __warp_conditional_computeSwapStep_100d3f74_11(__warp_usrid_10_exactIn : felt, __warp_usrid_05_sqrtRatioNextX96 : felt, __warp_usrid_01_sqrtRatioTargetX96 : felt)-> (__warp_rc_10 : felt, __warp_usrid_10_exactIn : felt, __warp_usrid_05_sqrtRatioNextX96 : felt, __warp_usrid_01_sqrtRatioTargetX96 : felt){
    alloc_locals;


        
        if (__warp_usrid_10_exactIn != 0){
        
            
            let (__warp_se_29) = warp_neq(__warp_usrid_05_sqrtRatioNextX96, __warp_usrid_01_sqrtRatioTargetX96);
            
            let __warp_rc_10 = __warp_se_29;
            
            let __warp_rc_10 = __warp_rc_10;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            let __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
            
            let __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
            
            
            
            return (__warp_rc_10, __warp_usrid_10_exactIn, __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_01_sqrtRatioTargetX96);
        }else{
        
            
            let __warp_rc_10 = 0;
            
            let __warp_rc_10 = __warp_rc_10;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            let __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
            
            let __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
            
            
            
            return (__warp_rc_10, __warp_usrid_10_exactIn, __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_01_sqrtRatioTargetX96);
        }

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
    func computeSwapStep_100d3f74{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_sqrtRatioCurrentX96 : felt, __warp_usrid_01_sqrtRatioTargetX96 : felt, __warp_usrid_02_liquidity : felt, __warp_usrid_03_amountRemaining : Uint256, __warp_usrid_04_feePips : felt)-> (__warp_usrid_05_sqrtRatioNextX96 : felt, __warp_usrid_06_amountIn : Uint256, __warp_usrid_07_amountOut : Uint256, __warp_usrid_08_feeAmount : Uint256){
    alloc_locals;


        
        let __warp_usrid_08_feeAmount = Uint256(low=0, high=0);
        
        let __warp_usrid_07_amountOut = Uint256(low=0, high=0);
        
        let __warp_usrid_05_sqrtRatioNextX96 = 0;
        
        let __warp_usrid_06_amountIn = Uint256(low=0, high=0);
        
            
            let (__warp_usrid_09_zeroForOne) = warp_ge(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_01_sqrtRatioTargetX96);
            
            let (__warp_usrid_10_exactIn) = warp_ge_signed256(__warp_usrid_03_amountRemaining, Uint256(low=0, high=0));
            
                
                if (__warp_usrid_10_exactIn != 0){
                
                    
                    let (__warp_se_30) = warp_sub_unsafe24(1000000, __warp_usrid_04_feePips);
                    
                    let (__warp_se_31) = warp_uint256(__warp_se_30);
                    
                    let (__warp_usrid_11_amountRemainingLessFee) = mulDiv_aa9a0912(__warp_usrid_03_amountRemaining, __warp_se_31, Uint256(low=1000000, high=0));
                    
                        
                        if (__warp_usrid_09_zeroForOne != 0){
                        
                            
                            let (__warp_pse_0) = getAmount0Delta_2c32d4b6(__warp_usrid_01_sqrtRatioTargetX96, __warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, 1);
                            
                            let __warp_usrid_06_amountIn = __warp_pse_0;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                            tempvar __warp_usrid_11_amountRemainingLessFee = __warp_usrid_11_amountRemainingLessFee;
                        }else{
                        
                            
                            let (__warp_pse_1) = getAmount1Delta_48a0c5bd(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_01_sqrtRatioTargetX96, __warp_usrid_02_liquidity, 1);
                            
                            let __warp_usrid_06_amountIn = __warp_pse_1;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                            tempvar __warp_usrid_11_amountRemainingLessFee = __warp_usrid_11_amountRemainingLessFee;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                        tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                        tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                        tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                        tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                        tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                        tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                        tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                        tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                        tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                        tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                        tempvar __warp_usrid_11_amountRemainingLessFee = __warp_usrid_11_amountRemainingLessFee;
                    
                    let (__warp_se_32) = warp_ge256(__warp_usrid_11_amountRemainingLessFee, __warp_usrid_06_amountIn);
                    
                        
                        if (__warp_se_32 != 0){
                        
                            
                            let __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                        }else{
                        
                            
                            let (__warp_pse_2) = getNextSqrtPriceFromInput_aa58276a(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, __warp_usrid_11_amountRemainingLessFee, __warp_usrid_09_zeroForOne);
                            
                            let __warp_usrid_05_sqrtRatioNextX96 = __warp_pse_2;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                        tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                        tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                        tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                        tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                        tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                        tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                        tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                        tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                        tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                        tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                    tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                    tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                    tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                    tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                    tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                    tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                    tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                    tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                    tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                    tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                }else{
                
                    
                        
                        if (__warp_usrid_09_zeroForOne != 0){
                        
                            
                            let (__warp_pse_3) = getAmount1Delta_48a0c5bd(__warp_usrid_01_sqrtRatioTargetX96, __warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, 0);
                            
                            let __warp_usrid_07_amountOut = __warp_pse_3;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                        }else{
                        
                            
                            let (__warp_pse_4) = getAmount0Delta_2c32d4b6(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_01_sqrtRatioTargetX96, __warp_usrid_02_liquidity, 0);
                            
                            let __warp_usrid_07_amountOut = __warp_pse_4;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                        tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                        tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                        tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                        tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                        tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                        tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                        tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                        tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                        tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                        tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                    
                    let (__warp_se_33) = warp_negate256(__warp_usrid_03_amountRemaining);
                    
                    let (__warp_se_34) = warp_ge256(__warp_se_33, __warp_usrid_07_amountOut);
                    
                        
                        if (__warp_se_34 != 0){
                        
                            
                            let __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                        }else{
                        
                            
                            let (__warp_se_35) = warp_negate256(__warp_usrid_03_amountRemaining);
                            
                            let (__warp_pse_5) = getNextSqrtPriceFromOutput_fedf2b5f(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, __warp_se_35, __warp_usrid_09_zeroForOne);
                            
                            let __warp_usrid_05_sqrtRatioNextX96 = __warp_pse_5;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                        tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                        tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                        tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                        tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                        tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                        tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                        tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                        tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                        tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                        tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                    tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                    tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                    tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                    tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                    tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                    tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                    tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                    tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                    tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                    tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                tempvar __warp_usrid_09_zeroForOne = __warp_usrid_09_zeroForOne;
                tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
            
            let (__warp_usrid_12_max) = warp_eq(__warp_usrid_01_sqrtRatioTargetX96, __warp_usrid_05_sqrtRatioNextX96);
            
                
                if (__warp_usrid_09_zeroForOne != 0){
                
                    
                    let __warp_rc_0 = 0;
                    
                        
                        let (__warp_tv_0, __warp_tv_1, __warp_tv_2) = __warp_conditional_computeSwapStep_100d3f74_1(__warp_usrid_12_max, __warp_usrid_10_exactIn);
                        
                        let __warp_usrid_10_exactIn = __warp_tv_2;
                        
                        let __warp_usrid_12_max = __warp_tv_1;
                        
                        let __warp_rc_0 = __warp_tv_0;
                    
                        
                        if (1 - __warp_rc_0 != 0){
                        
                            
                            let (__warp_pse_6) = getAmount0Delta_2c32d4b6(__warp_usrid_05_sqrtRatioNextX96, __warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, 1);
                            
                            let __warp_usrid_06_amountIn = __warp_pse_6;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                            tempvar __warp_usrid_12_max = __warp_usrid_12_max;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                            tempvar __warp_usrid_12_max = __warp_usrid_12_max;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                        tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                        tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                        tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                        tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                        tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                        tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                        tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                        tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                        tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                        tempvar __warp_usrid_12_max = __warp_usrid_12_max;
                    
                    let __warp_rc_2 = 0;
                    
                        
                        let (__warp_tv_3, __warp_tv_4, __warp_tv_5) = __warp_conditional_computeSwapStep_100d3f74_3(__warp_usrid_12_max, __warp_usrid_10_exactIn);
                        
                        let __warp_usrid_10_exactIn = __warp_tv_5;
                        
                        let __warp_usrid_12_max = __warp_tv_4;
                        
                        let __warp_rc_2 = __warp_tv_3;
                    
                        
                        if (1 - __warp_rc_2 != 0){
                        
                            
                            let (__warp_pse_7) = getAmount1Delta_48a0c5bd(__warp_usrid_05_sqrtRatioNextX96, __warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, 0);
                            
                            let __warp_usrid_07_amountOut = __warp_pse_7;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                        tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                        tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                        tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                        tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                        tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                        tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                        tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                    tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                    tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                    tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                    tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                    tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                    tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                    tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                }else{
                
                    
                    let __warp_rc_4 = 0;
                    
                        
                        let (__warp_tv_6, __warp_tv_7, __warp_tv_8) = __warp_conditional_computeSwapStep_100d3f74_5(__warp_usrid_12_max, __warp_usrid_10_exactIn);
                        
                        let __warp_usrid_10_exactIn = __warp_tv_8;
                        
                        let __warp_usrid_12_max = __warp_tv_7;
                        
                        let __warp_rc_4 = __warp_tv_6;
                    
                        
                        if (1 - __warp_rc_4 != 0){
                        
                            
                            let (__warp_pse_8) = getAmount1Delta_48a0c5bd(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_02_liquidity, 1);
                            
                            let __warp_usrid_06_amountIn = __warp_pse_8;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                            tempvar __warp_usrid_12_max = __warp_usrid_12_max;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                            tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                            tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                            tempvar __warp_usrid_12_max = __warp_usrid_12_max;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                        tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                        tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                        tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                        tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                        tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                        tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                        tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                        tempvar __warp_usrid_00_sqrtRatioCurrentX96 = __warp_usrid_00_sqrtRatioCurrentX96;
                        tempvar __warp_usrid_02_liquidity = __warp_usrid_02_liquidity;
                        tempvar __warp_usrid_12_max = __warp_usrid_12_max;
                    
                    let __warp_rc_6 = 0;
                    
                        
                        let (__warp_tv_9, __warp_tv_10, __warp_tv_11) = __warp_conditional_computeSwapStep_100d3f74_7(__warp_usrid_12_max, __warp_usrid_10_exactIn);
                        
                        let __warp_usrid_10_exactIn = __warp_tv_11;
                        
                        let __warp_usrid_12_max = __warp_tv_10;
                        
                        let __warp_rc_6 = __warp_tv_9;
                    
                        
                        if (1 - __warp_rc_6 != 0){
                        
                            
                            let (__warp_pse_9) = getAmount0Delta_2c32d4b6(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_02_liquidity, 0);
                            
                            let __warp_usrid_07_amountOut = __warp_pse_9;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                            tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                            tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                            tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                            tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                        tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                        tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                        tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                        tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                        tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                        tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                        tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                    tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                    tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                    tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                    tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                    tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                    tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                    tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
            
            let __warp_rc_8 = 0;
            
                
                let (__warp_tv_12, __warp_tv_13, __warp_tv_14, __warp_tv_15) = __warp_conditional_computeSwapStep_100d3f74_9(__warp_usrid_10_exactIn, __warp_usrid_07_amountOut, __warp_usrid_03_amountRemaining);
                
                let __warp_usrid_03_amountRemaining = __warp_tv_15;
                
                let __warp_usrid_07_amountOut = __warp_tv_14;
                
                let __warp_usrid_10_exactIn = __warp_tv_13;
                
                let __warp_rc_8 = __warp_tv_12;
            
                
                if (__warp_rc_8 != 0){
                
                    
                    let (__warp_se_36) = warp_negate256(__warp_usrid_03_amountRemaining);
                    
                    let __warp_usrid_07_amountOut = __warp_se_36;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                    tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                    tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                    tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                    tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                    tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                    tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                    tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                    tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                    tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                    tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                    tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                    tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                    tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                    tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                tempvar __warp_usrid_04_feePips = __warp_usrid_04_feePips;
                tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                tempvar __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
                tempvar __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
            
            let __warp_rc_10 = 0;
            
                
                let (__warp_tv_16, __warp_tv_17, __warp_tv_18, __warp_tv_19) = __warp_conditional_computeSwapStep_100d3f74_11(__warp_usrid_10_exactIn, __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_01_sqrtRatioTargetX96);
                
                let __warp_usrid_01_sqrtRatioTargetX96 = __warp_tv_19;
                
                let __warp_usrid_05_sqrtRatioNextX96 = __warp_tv_18;
                
                let __warp_usrid_10_exactIn = __warp_tv_17;
                
                let __warp_rc_10 = __warp_tv_16;
            
                
                if (__warp_rc_10 != 0){
                
                    
                    let (__warp_se_37) = warp_sub_unsafe256(__warp_usrid_03_amountRemaining, __warp_usrid_06_amountIn);
                    
                    let __warp_usrid_08_feeAmount = __warp_se_37;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                    tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                    tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                    tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                }else{
                
                    
                    let (__warp_se_38) = warp_uint256(__warp_usrid_04_feePips);
                    
                    let (__warp_se_39) = warp_sub_unsafe24(1000000, __warp_usrid_04_feePips);
                    
                    let (__warp_se_40) = warp_uint256(__warp_se_39);
                    
                    let (__warp_pse_10) = mulDivRoundingUp_0af8b27f(__warp_usrid_06_amountIn, __warp_se_38, __warp_se_40);
                    
                    let __warp_usrid_08_feeAmount = __warp_pse_10;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                    tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                    tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                    tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
        
        let __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
        
        let __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
        
        let __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
        
        let __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
        
        
        
        return (__warp_usrid_05_sqrtRatioNextX96, __warp_usrid_06_amountIn, __warp_usrid_07_amountOut, __warp_usrid_08_feeAmount);

    }

    // @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    // @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
    func mulDiv_aa9a0912{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_a : Uint256, __warp_usrid_01_b : Uint256, __warp_usrid_02_denominator : Uint256)-> (__warp_usrid_03_result : Uint256){
    alloc_locals;


        
        let __warp_usrid_03_result = Uint256(low=0, high=0);
        
        let __warp_usrid_04_prod0 = Uint256(low=0, high=0);
        
            
            let (__warp_se_41) = warp_mul_unsafe256(__warp_usrid_00_a, __warp_usrid_01_b);
            
            let __warp_usrid_04_prod0 = __warp_se_41;
            
            let (__warp_usrid_05_mm) = warp_mulmod(__warp_usrid_00_a, __warp_usrid_01_b, Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455));
            
            let __warp_usrid_06_prod1 = Uint256(low=0, high=0);
            
            let (__warp_se_42) = warp_sub_unsafe256(__warp_usrid_05_mm, __warp_usrid_04_prod0);
            
            let __warp_usrid_06_prod1 = __warp_se_42;
            
            let (__warp_se_43) = warp_lt256(__warp_usrid_05_mm, __warp_usrid_04_prod0);
            
                
                if (__warp_se_43 != 0){
                
                    
                    let (__warp_se_44) = warp_sub_unsafe256(__warp_usrid_06_prod1, Uint256(low=1, high=0));
                    
                    let __warp_usrid_06_prod1 = __warp_se_44;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_result = __warp_usrid_03_result;
                    tempvar __warp_usrid_04_prod0 = __warp_usrid_04_prod0;
                    tempvar __warp_usrid_02_denominator = __warp_usrid_02_denominator;
                    tempvar __warp_usrid_06_prod1 = __warp_usrid_06_prod1;
                    tempvar __warp_usrid_00_a = __warp_usrid_00_a;
                    tempvar __warp_usrid_01_b = __warp_usrid_01_b;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_result = __warp_usrid_03_result;
                    tempvar __warp_usrid_04_prod0 = __warp_usrid_04_prod0;
                    tempvar __warp_usrid_02_denominator = __warp_usrid_02_denominator;
                    tempvar __warp_usrid_06_prod1 = __warp_usrid_06_prod1;
                    tempvar __warp_usrid_00_a = __warp_usrid_00_a;
                    tempvar __warp_usrid_01_b = __warp_usrid_01_b;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_result = __warp_usrid_03_result;
                tempvar __warp_usrid_04_prod0 = __warp_usrid_04_prod0;
                tempvar __warp_usrid_02_denominator = __warp_usrid_02_denominator;
                tempvar __warp_usrid_06_prod1 = __warp_usrid_06_prod1;
                tempvar __warp_usrid_00_a = __warp_usrid_00_a;
                tempvar __warp_usrid_01_b = __warp_usrid_01_b;
            
            let (__warp_se_45) = warp_eq256(__warp_usrid_06_prod1, Uint256(low=0, high=0));
            
                
                if (__warp_se_45 != 0){
                
                    
                    let (__warp_se_46) = warp_gt256(__warp_usrid_02_denominator, Uint256(low=0, high=0));
                    
                    assert __warp_se_46 = 1;
                    
                    let (__warp_se_47) = warp_div_unsafe256(__warp_usrid_04_prod0, __warp_usrid_02_denominator);
                    
                    let __warp_usrid_03_result = __warp_se_47;
                    
                    
                    
                    return (__warp_usrid_03_result,);
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_result = __warp_usrid_03_result;
                    tempvar __warp_usrid_04_prod0 = __warp_usrid_04_prod0;
                    tempvar __warp_usrid_02_denominator = __warp_usrid_02_denominator;
                    tempvar __warp_usrid_06_prod1 = __warp_usrid_06_prod1;
                    tempvar __warp_usrid_00_a = __warp_usrid_00_a;
                    tempvar __warp_usrid_01_b = __warp_usrid_01_b;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_result = __warp_usrid_03_result;
                tempvar __warp_usrid_04_prod0 = __warp_usrid_04_prod0;
                tempvar __warp_usrid_02_denominator = __warp_usrid_02_denominator;
                tempvar __warp_usrid_06_prod1 = __warp_usrid_06_prod1;
                tempvar __warp_usrid_00_a = __warp_usrid_00_a;
                tempvar __warp_usrid_01_b = __warp_usrid_01_b;
            
            let (__warp_se_48) = warp_gt256(__warp_usrid_02_denominator, __warp_usrid_06_prod1);
            
            assert __warp_se_48 = 1;
            
            let __warp_usrid_07_remainder = Uint256(low=0, high=0);
            
            let (__warp_se_49) = warp_mulmod(__warp_usrid_00_a, __warp_usrid_01_b, __warp_usrid_02_denominator);
            
            let __warp_usrid_07_remainder = __warp_se_49;
            
            let (__warp_se_50) = warp_gt256(__warp_usrid_07_remainder, __warp_usrid_04_prod0);
            
                
                if (__warp_se_50 != 0){
                
                    
                    let (__warp_se_51) = warp_sub_unsafe256(__warp_usrid_06_prod1, Uint256(low=1, high=0));
                    
                    let __warp_usrid_06_prod1 = __warp_se_51;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_result = __warp_usrid_03_result;
                    tempvar __warp_usrid_04_prod0 = __warp_usrid_04_prod0;
                    tempvar __warp_usrid_02_denominator = __warp_usrid_02_denominator;
                    tempvar __warp_usrid_06_prod1 = __warp_usrid_06_prod1;
                    tempvar __warp_usrid_07_remainder = __warp_usrid_07_remainder;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_result = __warp_usrid_03_result;
                    tempvar __warp_usrid_04_prod0 = __warp_usrid_04_prod0;
                    tempvar __warp_usrid_02_denominator = __warp_usrid_02_denominator;
                    tempvar __warp_usrid_06_prod1 = __warp_usrid_06_prod1;
                    tempvar __warp_usrid_07_remainder = __warp_usrid_07_remainder;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_result = __warp_usrid_03_result;
                tempvar __warp_usrid_04_prod0 = __warp_usrid_04_prod0;
                tempvar __warp_usrid_02_denominator = __warp_usrid_02_denominator;
                tempvar __warp_usrid_06_prod1 = __warp_usrid_06_prod1;
                tempvar __warp_usrid_07_remainder = __warp_usrid_07_remainder;
            
            let (__warp_se_52) = warp_sub_unsafe256(__warp_usrid_04_prod0, __warp_usrid_07_remainder);
            
            let __warp_usrid_04_prod0 = __warp_se_52;
            
            let (__warp_se_53) = warp_negate256(__warp_usrid_02_denominator);
            
            let (__warp_usrid_08_twos) = warp_bitwise_and256(__warp_se_53, __warp_usrid_02_denominator);
            
            let (__warp_se_54) = warp_div_unsafe256(__warp_usrid_02_denominator, __warp_usrid_08_twos);
            
            let __warp_usrid_02_denominator = __warp_se_54;
            
            let (__warp_se_55) = warp_div_unsafe256(__warp_usrid_04_prod0, __warp_usrid_08_twos);
            
            let __warp_usrid_04_prod0 = __warp_se_55;
            
            let (__warp_se_56) = warp_sub_unsafe256(Uint256(low=0, high=0), __warp_usrid_08_twos);
            
            let (__warp_se_57) = warp_div_unsafe256(__warp_se_56, __warp_usrid_08_twos);
            
            let (__warp_se_58) = warp_add_unsafe256(__warp_se_57, Uint256(low=1, high=0));
            
            let __warp_usrid_08_twos = __warp_se_58;
            
            let (__warp_se_59) = warp_mul_unsafe256(__warp_usrid_06_prod1, __warp_usrid_08_twos);
            
            let (__warp_se_60) = warp_bitwise_or256(__warp_usrid_04_prod0, __warp_se_59);
            
            let __warp_usrid_04_prod0 = __warp_se_60;
            
            let (__warp_se_61) = warp_mul_unsafe256(Uint256(low=3, high=0), __warp_usrid_02_denominator);
            
            let (__warp_usrid_09_inv) = warp_xor256(__warp_se_61, Uint256(low=2, high=0));
            
            let (__warp_se_62) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);
            
            let (__warp_se_63) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_62);
            
            let (__warp_se_64) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_63);
            
            let __warp_usrid_09_inv = __warp_se_64;
            
            let (__warp_se_65) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);
            
            let (__warp_se_66) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_65);
            
            let (__warp_se_67) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_66);
            
            let __warp_usrid_09_inv = __warp_se_67;
            
            let (__warp_se_68) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);
            
            let (__warp_se_69) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_68);
            
            let (__warp_se_70) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_69);
            
            let __warp_usrid_09_inv = __warp_se_70;
            
            let (__warp_se_71) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);
            
            let (__warp_se_72) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_71);
            
            let (__warp_se_73) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_72);
            
            let __warp_usrid_09_inv = __warp_se_73;
            
            let (__warp_se_74) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);
            
            let (__warp_se_75) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_74);
            
            let (__warp_se_76) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_75);
            
            let __warp_usrid_09_inv = __warp_se_76;
            
            let (__warp_se_77) = warp_mul_unsafe256(__warp_usrid_02_denominator, __warp_usrid_09_inv);
            
            let (__warp_se_78) = warp_sub_unsafe256(Uint256(low=2, high=0), __warp_se_77);
            
            let (__warp_se_79) = warp_mul_unsafe256(__warp_usrid_09_inv, __warp_se_78);
            
            let __warp_usrid_09_inv = __warp_se_79;
            
            let (__warp_se_80) = warp_mul_unsafe256(__warp_usrid_04_prod0, __warp_usrid_09_inv);
            
            let __warp_usrid_03_result = __warp_se_80;
        
        
        
        return (__warp_usrid_03_result,);

    }

    // @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    func mulDivRoundingUp_0af8b27f{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_10_a : Uint256, __warp_usrid_11_b : Uint256, __warp_usrid_12_denominator : Uint256)-> (__warp_usrid_13_result : Uint256){
    alloc_locals;


        
        let __warp_usrid_13_result = Uint256(low=0, high=0);
        
        let (__warp_pse_11) = mulDiv_aa9a0912(__warp_usrid_10_a, __warp_usrid_11_b, __warp_usrid_12_denominator);
        
        let __warp_usrid_13_result = __warp_pse_11;
        
            
            let (__warp_se_81) = warp_mulmod(__warp_usrid_10_a, __warp_usrid_11_b, __warp_usrid_12_denominator);
            
            let (__warp_se_82) = warp_gt256(__warp_se_81, Uint256(low=0, high=0));
            
                
                if (__warp_se_82 != 0){
                
                    
                    let (__warp_se_83) = warp_lt256(__warp_usrid_13_result, Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455));
                    
                    assert __warp_se_83 = 1;
                    
                    let (__warp_pse_12) = warp_add_unsafe256(__warp_usrid_13_result, Uint256(low=1, high=0));
                    
                    let __warp_usrid_13_result = __warp_pse_12;
                    
                    warp_sub_unsafe256(__warp_pse_12, Uint256(low=1, high=0));
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_13_result = __warp_usrid_13_result;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_13_result = __warp_usrid_13_result;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_13_result = __warp_usrid_13_result;
        
        
        
        return (__warp_usrid_13_result,);

    }


    func __warp_conditional_getNextSqrtPriceFromAmount0RoundingUp_157f652f_13{range_check_ptr : felt}(__warp_usrid_08_product : Uint256, __warp_usrid_02_amount : Uint256, __warp_usrid_00_sqrtPX96 : felt, __warp_usrid_05_numerator1 : Uint256)-> (__warp_rc_12 : felt, __warp_usrid_08_product : Uint256, __warp_usrid_02_amount : Uint256, __warp_usrid_00_sqrtPX96 : felt, __warp_usrid_05_numerator1 : Uint256){
    alloc_locals;


        
        let (__warp_se_84) = warp_uint256(__warp_usrid_00_sqrtPX96);
        
        let (__warp_pse_17) = warp_mul256(__warp_usrid_02_amount, __warp_se_84);
        
        let __warp_usrid_08_product = __warp_pse_17;
        
        let (__warp_se_85) = warp_div256(__warp_pse_17, __warp_usrid_02_amount);
        
        let (__warp_se_86) = warp_uint256(__warp_usrid_00_sqrtPX96);
        
        let (__warp_se_87) = warp_eq256(__warp_se_85, __warp_se_86);
        
        if (__warp_se_87 != 0){
        
            
            let (__warp_se_88) = warp_gt256(__warp_usrid_05_numerator1, __warp_usrid_08_product);
            
            let __warp_rc_12 = __warp_se_88;
            
            let __warp_rc_12 = __warp_rc_12;
            
            let __warp_usrid_08_product = __warp_usrid_08_product;
            
            let __warp_usrid_02_amount = __warp_usrid_02_amount;
            
            let __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
            
            let __warp_usrid_05_numerator1 = __warp_usrid_05_numerator1;
            
            
            
            return (__warp_rc_12, __warp_usrid_08_product, __warp_usrid_02_amount, __warp_usrid_00_sqrtPX96, __warp_usrid_05_numerator1);
        }else{
        
            
            let __warp_rc_12 = 0;
            
            let __warp_rc_12 = __warp_rc_12;
            
            let __warp_usrid_08_product = __warp_usrid_08_product;
            
            let __warp_usrid_02_amount = __warp_usrid_02_amount;
            
            let __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
            
            let __warp_usrid_05_numerator1 = __warp_usrid_05_numerator1;
            
            
            
            return (__warp_rc_12, __warp_usrid_08_product, __warp_usrid_02_amount, __warp_usrid_00_sqrtPX96, __warp_usrid_05_numerator1);
        }

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
    func getNextSqrtPriceFromAmount0RoundingUp_157f652f{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_sqrtPX96 : felt, __warp_usrid_01_liquidity : felt, __warp_usrid_02_amount : Uint256, __warp_usrid_03_add : felt)-> (__warp_usrid_04_ : felt){
    alloc_locals;


        
            
            let (__warp_se_89) = warp_eq256(__warp_usrid_02_amount, Uint256(low=0, high=0));
            
                
                if (__warp_se_89 != 0){
                
                    
                    
                    
                    return (__warp_usrid_00_sqrtPX96,);
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_add = __warp_usrid_03_add;
                    tempvar __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
                    tempvar __warp_usrid_02_amount = __warp_usrid_02_amount;
                    tempvar __warp_usrid_01_liquidity = __warp_usrid_01_liquidity;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_add = __warp_usrid_03_add;
                tempvar __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
                tempvar __warp_usrid_02_amount = __warp_usrid_02_amount;
                tempvar __warp_usrid_01_liquidity = __warp_usrid_01_liquidity;
            
            let (__warp_se_90) = warp_uint256(__warp_usrid_01_liquidity);
            
            let (__warp_usrid_05_numerator1) = warp_shl256(__warp_se_90, 96);
            
            if (__warp_usrid_03_add != 0){
            
                
                let __warp_usrid_06_product = Uint256(low=0, high=0);
                
                let (__warp_se_91) = warp_uint256(__warp_usrid_00_sqrtPX96);
                
                let (__warp_pse_13) = warp_mul_unsafe256(__warp_usrid_02_amount, __warp_se_91);
                
                let __warp_usrid_06_product = __warp_pse_13;
                
                let (__warp_se_92) = warp_div_unsafe256(__warp_pse_13, __warp_usrid_02_amount);
                
                let (__warp_se_93) = warp_uint256(__warp_usrid_00_sqrtPX96);
                
                let (__warp_se_94) = warp_eq256(__warp_se_92, __warp_se_93);
                
                    
                    if (__warp_se_94 != 0){
                    
                        
                        let (__warp_usrid_07_denominator) = warp_add_unsafe256(__warp_usrid_05_numerator1, __warp_usrid_06_product);
                        
                        let (__warp_se_95) = warp_ge256(__warp_usrid_07_denominator, __warp_usrid_05_numerator1);
                        
                            
                            if (__warp_se_95 != 0){
                            
                                
                                let (__warp_se_96) = warp_uint256(__warp_usrid_00_sqrtPX96);
                                
                                let (__warp_pse_14) = mulDivRoundingUp_0af8b27f(__warp_usrid_05_numerator1, __warp_se_96, __warp_usrid_07_denominator);
                                
                                let (__warp_se_97) = warp_int256_to_int160(__warp_pse_14);
                                
                                
                                
                                return (__warp_se_97,);
                            }else{
                            
                                tempvar range_check_ptr = range_check_ptr;
                                tempvar bitwise_ptr = bitwise_ptr;
                                tempvar __warp_usrid_05_numerator1 = __warp_usrid_05_numerator1;
                                tempvar __warp_usrid_02_amount = __warp_usrid_02_amount;
                                tempvar __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
                            }
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_05_numerator1 = __warp_usrid_05_numerator1;
                            tempvar __warp_usrid_02_amount = __warp_usrid_02_amount;
                            tempvar __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_05_numerator1 = __warp_usrid_05_numerator1;
                        tempvar __warp_usrid_02_amount = __warp_usrid_02_amount;
                        tempvar __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
                    }else{
                    
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_05_numerator1 = __warp_usrid_05_numerator1;
                        tempvar __warp_usrid_02_amount = __warp_usrid_02_amount;
                        tempvar __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_numerator1 = __warp_usrid_05_numerator1;
                    tempvar __warp_usrid_02_amount = __warp_usrid_02_amount;
                    tempvar __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
                
                let (__warp_se_98) = warp_uint256(__warp_usrid_00_sqrtPX96);
                
                let (__warp_se_99) = warp_div_unsafe256(__warp_usrid_05_numerator1, __warp_se_98);
                
                let (__warp_pse_15) = add_771602f7(__warp_se_99, __warp_usrid_02_amount);
                
                let (__warp_pse_16) = divRoundingUp_40226b32(__warp_usrid_05_numerator1, __warp_pse_15);
                
                let (__warp_se_100) = warp_int256_to_int160(__warp_pse_16);
                
                
                
                return (__warp_se_100,);
            }else{
            
                
                let __warp_usrid_08_product = Uint256(low=0, high=0);
                
                let __warp_rc_12 = 0;
                
                    
                    let (__warp_tv_20, __warp_tv_21, __warp_tv_22, __warp_tv_23, __warp_tv_24) = __warp_conditional_getNextSqrtPriceFromAmount0RoundingUp_157f652f_13(__warp_usrid_08_product, __warp_usrid_02_amount, __warp_usrid_00_sqrtPX96, __warp_usrid_05_numerator1);
                    
                    let __warp_usrid_05_numerator1 = __warp_tv_24;
                    
                    let __warp_usrid_00_sqrtPX96 = __warp_tv_23;
                    
                    let __warp_usrid_02_amount = __warp_tv_22;
                    
                    let __warp_usrid_08_product = __warp_tv_21;
                    
                    let __warp_rc_12 = __warp_tv_20;
                
                assert __warp_rc_12 = 1;
                
                let (__warp_usrid_09_denominator) = warp_sub_unsafe256(__warp_usrid_05_numerator1, __warp_usrid_08_product);
                
                let (__warp_se_101) = warp_uint256(__warp_usrid_00_sqrtPX96);
                
                let (__warp_pse_18) = mulDivRoundingUp_0af8b27f(__warp_usrid_05_numerator1, __warp_se_101, __warp_usrid_09_denominator);
                
                let (__warp_pse_19) = toUint160_dfef6beb(__warp_pse_18);
                
                
                
                return (__warp_pse_19,);
            }

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
    func getNextSqrtPriceFromAmount1RoundingDown_fb4de288{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_10_sqrtPX96 : felt, __warp_usrid_11_liquidity : felt, __warp_usrid_12_amount : Uint256, __warp_usrid_13_add : felt)-> (__warp_usrid_14_ : felt){
    alloc_locals;


        
            
            if (__warp_usrid_13_add != 0){
            
                
                let __warp_usrid_15_quotient = Uint256(low=0, high=0);
                
                let (__warp_se_102) = warp_uint256(1461501637330902918203684832716283019655932542975);
                
                let (__warp_se_103) = warp_le256(__warp_usrid_12_amount, __warp_se_102);
                
                    
                    if (__warp_se_103 != 0){
                    
                        
                        let (__warp_se_104) = warp_shl256(__warp_usrid_12_amount, 96);
                        
                        let (__warp_se_105) = warp_uint256(__warp_usrid_11_liquidity);
                        
                        let (__warp_se_106) = warp_div_unsafe256(__warp_se_104, __warp_se_105);
                        
                        let __warp_usrid_15_quotient = __warp_se_106;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_15_quotient = __warp_usrid_15_quotient;
                        tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                    }else{
                    
                        
                        let (__warp_se_107) = warp_uint256(__warp_usrid_11_liquidity);
                        
                        let (__warp_pse_20) = mulDiv_aa9a0912(__warp_usrid_12_amount, Uint256(low=79228162514264337593543950336, high=0), __warp_se_107);
                        
                        let __warp_usrid_15_quotient = __warp_pse_20;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_15_quotient = __warp_usrid_15_quotient;
                        tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_15_quotient = __warp_usrid_15_quotient;
                    tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                
                let (__warp_se_108) = warp_uint256(__warp_usrid_10_sqrtPX96);
                
                let (__warp_pse_21) = add_771602f7(__warp_se_108, __warp_usrid_15_quotient);
                
                let (__warp_pse_22) = toUint160_dfef6beb(__warp_pse_21);
                
                
                
                return (__warp_pse_22,);
            }else{
            
                
                let __warp_usrid_16_quotient = Uint256(low=0, high=0);
                
                let (__warp_se_109) = warp_uint256(1461501637330902918203684832716283019655932542975);
                
                let (__warp_se_110) = warp_le256(__warp_usrid_12_amount, __warp_se_109);
                
                    
                    if (__warp_se_110 != 0){
                    
                        
                        let (__warp_se_111) = warp_shl256(__warp_usrid_12_amount, 96);
                        
                        let (__warp_se_112) = warp_uint256(__warp_usrid_11_liquidity);
                        
                        let (__warp_pse_23) = divRoundingUp_40226b32(__warp_se_111, __warp_se_112);
                        
                        let __warp_usrid_16_quotient = __warp_pse_23;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_16_quotient = __warp_usrid_16_quotient;
                        tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                    }else{
                    
                        
                        let (__warp_se_113) = warp_uint256(__warp_usrid_11_liquidity);
                        
                        let (__warp_pse_24) = mulDivRoundingUp_0af8b27f(__warp_usrid_12_amount, Uint256(low=79228162514264337593543950336, high=0), __warp_se_113);
                        
                        let __warp_usrid_16_quotient = __warp_pse_24;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_16_quotient = __warp_usrid_16_quotient;
                        tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_16_quotient = __warp_usrid_16_quotient;
                    tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                
                let (__warp_se_114) = warp_uint256(__warp_usrid_10_sqrtPX96);
                
                let (__warp_se_115) = warp_gt256(__warp_se_114, __warp_usrid_16_quotient);
                
                assert __warp_se_115 = 1;
                
                let (__warp_se_116) = warp_uint256(__warp_usrid_10_sqrtPX96);
                
                let (__warp_se_117) = warp_sub_unsafe256(__warp_se_116, __warp_usrid_16_quotient);
                
                let (__warp_se_118) = warp_int256_to_int160(__warp_se_117);
                
                
                
                return (__warp_se_118,);
            }

    }

    // @notice Gets the next sqrt price given an input amount of token0 or token1
    // @dev Throws if price or liquidity are 0, or if the next price is out of bounds
    // @param sqrtPX96 The starting price, i.e., before accounting for the input amount
    // @param liquidity The amount of usable liquidity
    // @param amountIn How much of token0, or token1, is being swapped in
    // @param zeroForOne Whether the amount in is token0 or token1
    // @return sqrtQX96 The price after adding the input amount to token0 or token1
    func getNextSqrtPriceFromInput_aa58276a{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_17_sqrtPX96 : felt, __warp_usrid_18_liquidity : felt, __warp_usrid_19_amountIn : Uint256, __warp_usrid_20_zeroForOne : felt)-> (__warp_usrid_21_sqrtQX96 : felt){
    alloc_locals;


        
        let (__warp_se_119) = warp_gt(__warp_usrid_17_sqrtPX96, 0);
        
        assert __warp_se_119 = 1;
        
        let (__warp_se_120) = warp_gt(__warp_usrid_18_liquidity, 0);
        
        assert __warp_se_120 = 1;
        
        if (__warp_usrid_20_zeroForOne != 0){
        
            
            let (__warp_pse_25) = getNextSqrtPriceFromAmount0RoundingUp_157f652f(__warp_usrid_17_sqrtPX96, __warp_usrid_18_liquidity, __warp_usrid_19_amountIn, 1);
            
            
            
            return (__warp_pse_25,);
        }else{
        
            
            let (__warp_pse_26) = getNextSqrtPriceFromAmount1RoundingDown_fb4de288(__warp_usrid_17_sqrtPX96, __warp_usrid_18_liquidity, __warp_usrid_19_amountIn, 1);
            
            
            
            return (__warp_pse_26,);
        }

    }

    // @notice Gets the next sqrt price given an output amount of token0 or token1
    // @dev Throws if price or liquidity are 0 or the next price is out of bounds
    // @param sqrtPX96 The starting price before accounting for the output amount
    // @param liquidity The amount of usable liquidity
    // @param amountOut How much of token0, or token1, is being swapped out
    // @param zeroForOne Whether the amount out is token0 or token1
    // @return sqrtQX96 The price after removing the output amount of token0 or token1
    func getNextSqrtPriceFromOutput_fedf2b5f{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_22_sqrtPX96 : felt, __warp_usrid_23_liquidity : felt, __warp_usrid_24_amountOut : Uint256, __warp_usrid_25_zeroForOne : felt)-> (__warp_usrid_26_sqrtQX96 : felt){
    alloc_locals;


        
        let (__warp_se_121) = warp_gt(__warp_usrid_22_sqrtPX96, 0);
        
        assert __warp_se_121 = 1;
        
        let (__warp_se_122) = warp_gt(__warp_usrid_23_liquidity, 0);
        
        assert __warp_se_122 = 1;
        
        if (__warp_usrid_25_zeroForOne != 0){
        
            
            let (__warp_pse_27) = getNextSqrtPriceFromAmount1RoundingDown_fb4de288(__warp_usrid_22_sqrtPX96, __warp_usrid_23_liquidity, __warp_usrid_24_amountOut, 0);
            
            
            
            return (__warp_pse_27,);
        }else{
        
            
            let (__warp_pse_28) = getNextSqrtPriceFromAmount0RoundingUp_157f652f(__warp_usrid_22_sqrtPX96, __warp_usrid_23_liquidity, __warp_usrid_24_amountOut, 0);
            
            
            
            return (__warp_pse_28,);
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
    func getAmount0Delta_2c32d4b6{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_27_sqrtRatioAX96 : felt, __warp_usrid_28_sqrtRatioBX96 : felt, __warp_usrid_29_liquidity : felt, __warp_usrid_30_roundUp : felt)-> (__warp_usrid_31_amount0 : Uint256){
    alloc_locals;


        
            
            let (__warp_se_123) = warp_gt(__warp_usrid_27_sqrtRatioAX96, __warp_usrid_28_sqrtRatioBX96);
            
                
                if (__warp_se_123 != 0){
                
                    
                    let __warp_tv_25 = __warp_usrid_28_sqrtRatioBX96;
                    
                    let __warp_tv_26 = __warp_usrid_27_sqrtRatioAX96;
                    
                    let __warp_usrid_28_sqrtRatioBX96 = __warp_tv_26;
                    
                    let __warp_usrid_27_sqrtRatioAX96 = __warp_tv_25;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_30_roundUp = __warp_usrid_30_roundUp;
                    tempvar __warp_usrid_27_sqrtRatioAX96 = __warp_usrid_27_sqrtRatioAX96;
                    tempvar __warp_usrid_28_sqrtRatioBX96 = __warp_usrid_28_sqrtRatioBX96;
                    tempvar __warp_usrid_29_liquidity = __warp_usrid_29_liquidity;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_30_roundUp = __warp_usrid_30_roundUp;
                    tempvar __warp_usrid_27_sqrtRatioAX96 = __warp_usrid_27_sqrtRatioAX96;
                    tempvar __warp_usrid_28_sqrtRatioBX96 = __warp_usrid_28_sqrtRatioBX96;
                    tempvar __warp_usrid_29_liquidity = __warp_usrid_29_liquidity;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_30_roundUp = __warp_usrid_30_roundUp;
                tempvar __warp_usrid_27_sqrtRatioAX96 = __warp_usrid_27_sqrtRatioAX96;
                tempvar __warp_usrid_28_sqrtRatioBX96 = __warp_usrid_28_sqrtRatioBX96;
                tempvar __warp_usrid_29_liquidity = __warp_usrid_29_liquidity;
            
            let (__warp_se_124) = warp_uint256(__warp_usrid_29_liquidity);
            
            let (__warp_usrid_32_numerator1) = warp_shl256(__warp_se_124, 96);
            
            let (__warp_se_125) = warp_sub_unsafe160(__warp_usrid_28_sqrtRatioBX96, __warp_usrid_27_sqrtRatioAX96);
            
            let (__warp_usrid_33_numerator2) = warp_uint256(__warp_se_125);
            
            let (__warp_se_126) = warp_gt(__warp_usrid_27_sqrtRatioAX96, 0);
            
            assert __warp_se_126 = 1;
            
            if (__warp_usrid_30_roundUp != 0){
            
                
                let (__warp_se_127) = warp_uint256(__warp_usrid_28_sqrtRatioBX96);
                
                let (__warp_pse_29) = mulDivRoundingUp_0af8b27f(__warp_usrid_32_numerator1, __warp_usrid_33_numerator2, __warp_se_127);
                
                let (__warp_se_128) = warp_uint256(__warp_usrid_27_sqrtRatioAX96);
                
                let (__warp_pse_30) = divRoundingUp_40226b32(__warp_pse_29, __warp_se_128);
                
                
                
                return (__warp_pse_30,);
            }else{
            
                
                let (__warp_se_129) = warp_uint256(__warp_usrid_28_sqrtRatioBX96);
                
                let (__warp_pse_31) = mulDiv_aa9a0912(__warp_usrid_32_numerator1, __warp_usrid_33_numerator2, __warp_se_129);
                
                let (__warp_se_130) = warp_uint256(__warp_usrid_27_sqrtRatioAX96);
                
                let (__warp_se_131) = warp_div_unsafe256(__warp_pse_31, __warp_se_130);
                
                
                
                return (__warp_se_131,);
            }

    }

    // @notice Gets the amount1 delta between two prices
    // @dev Calculates liquidity * (sqrt(upper) - sqrt(lower))
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The amount of usable liquidity
    // @param roundUp Whether to round the amount up, or down
    // @return amount1 Amount of token1 required to cover a position of size liquidity between the two passed prices
    func getAmount1Delta_48a0c5bd{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_34_sqrtRatioAX96 : felt, __warp_usrid_35_sqrtRatioBX96 : felt, __warp_usrid_36_liquidity : felt, __warp_usrid_37_roundUp : felt)-> (__warp_usrid_38_amount1 : Uint256){
    alloc_locals;


        
            
            let (__warp_se_132) = warp_gt(__warp_usrid_34_sqrtRatioAX96, __warp_usrid_35_sqrtRatioBX96);
            
                
                if (__warp_se_132 != 0){
                
                    
                    let __warp_tv_27 = __warp_usrid_35_sqrtRatioBX96;
                    
                    let __warp_tv_28 = __warp_usrid_34_sqrtRatioAX96;
                    
                    let __warp_usrid_35_sqrtRatioBX96 = __warp_tv_28;
                    
                    let __warp_usrid_34_sqrtRatioAX96 = __warp_tv_27;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_37_roundUp = __warp_usrid_37_roundUp;
                    tempvar __warp_usrid_35_sqrtRatioBX96 = __warp_usrid_35_sqrtRatioBX96;
                    tempvar __warp_usrid_34_sqrtRatioAX96 = __warp_usrid_34_sqrtRatioAX96;
                    tempvar __warp_usrid_36_liquidity = __warp_usrid_36_liquidity;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_37_roundUp = __warp_usrid_37_roundUp;
                    tempvar __warp_usrid_35_sqrtRatioBX96 = __warp_usrid_35_sqrtRatioBX96;
                    tempvar __warp_usrid_34_sqrtRatioAX96 = __warp_usrid_34_sqrtRatioAX96;
                    tempvar __warp_usrid_36_liquidity = __warp_usrid_36_liquidity;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_37_roundUp = __warp_usrid_37_roundUp;
                tempvar __warp_usrid_35_sqrtRatioBX96 = __warp_usrid_35_sqrtRatioBX96;
                tempvar __warp_usrid_34_sqrtRatioAX96 = __warp_usrid_34_sqrtRatioAX96;
                tempvar __warp_usrid_36_liquidity = __warp_usrid_36_liquidity;
            
            if (__warp_usrid_37_roundUp != 0){
            
                
                let (__warp_se_133) = warp_uint256(__warp_usrid_36_liquidity);
                
                let (__warp_se_134) = warp_sub_unsafe160(__warp_usrid_35_sqrtRatioBX96, __warp_usrid_34_sqrtRatioAX96);
                
                let (__warp_se_135) = warp_uint256(__warp_se_134);
                
                let (__warp_pse_32) = mulDivRoundingUp_0af8b27f(__warp_se_133, __warp_se_135, Uint256(low=79228162514264337593543950336, high=0));
                
                
                
                return (__warp_pse_32,);
            }else{
            
                
                let (__warp_se_136) = warp_uint256(__warp_usrid_36_liquidity);
                
                let (__warp_se_137) = warp_sub_unsafe160(__warp_usrid_35_sqrtRatioBX96, __warp_usrid_34_sqrtRatioAX96);
                
                let (__warp_se_138) = warp_uint256(__warp_se_137);
                
                let (__warp_pse_33) = mulDiv_aa9a0912(__warp_se_136, __warp_se_138, Uint256(low=79228162514264337593543950336, high=0));
                
                
                
                return (__warp_pse_33,);
            }

    }

    // @notice Returns ceil(x / y)
    // @dev division by 0 has unspecified behavior, and must be checked externally
    // @param x The dividend
    // @param y The divisor
    // @return z The quotient, ceil(x / y)
    func divRoundingUp_40226b32{range_check_ptr : felt}(__warp_usrid_00_x : Uint256, __warp_usrid_01_y : Uint256)-> (__warp_usrid_02_z : Uint256){
    alloc_locals;


        
        let __warp_usrid_02_z = Uint256(low=0, high=0);
        
            
            let __warp_usrid_03_temp = Uint256(low=0, high=0);
            
            let (__warp_se_139) = warp_mod256(__warp_usrid_00_x, __warp_usrid_01_y);
            
            let (__warp_se_140) = warp_gt256(__warp_se_139, Uint256(low=0, high=0));
            
                
                if (__warp_se_140 != 0){
                
                    
                    let __warp_usrid_03_temp = Uint256(low=1, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar __warp_usrid_02_z = __warp_usrid_02_z;
                    tempvar __warp_usrid_03_temp = __warp_usrid_03_temp;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                    tempvar __warp_usrid_01_y = __warp_usrid_01_y;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar __warp_usrid_02_z = __warp_usrid_02_z;
                    tempvar __warp_usrid_03_temp = __warp_usrid_03_temp;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                    tempvar __warp_usrid_01_y = __warp_usrid_01_y;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar __warp_usrid_02_z = __warp_usrid_02_z;
                tempvar __warp_usrid_03_temp = __warp_usrid_03_temp;
                tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                tempvar __warp_usrid_01_y = __warp_usrid_01_y;
            
            let (__warp_se_141) = warp_div_unsafe256(__warp_usrid_00_x, __warp_usrid_01_y);
            
            let (__warp_se_142) = warp_add_unsafe256(__warp_se_141, __warp_usrid_03_temp);
            
            let __warp_usrid_02_z = __warp_se_142;
        
        
        
        return (__warp_usrid_02_z,);

    }

    // @notice Returns x + y, reverts if sum overflows uint256
    // @param x The augend
    // @param y The addend
    // @return z The sum of x and y
    func add_771602f7{range_check_ptr : felt}(__warp_usrid_00_x : Uint256, __warp_usrid_01_y : Uint256)-> (__warp_usrid_02_z : Uint256){
    alloc_locals;


        
        let __warp_usrid_02_z = Uint256(low=0, high=0);
        
            
            let (__warp_pse_42) = warp_add_unsafe256(__warp_usrid_00_x, __warp_usrid_01_y);
            
            let __warp_usrid_02_z = __warp_pse_42;
            
            let (__warp_se_143) = warp_ge256(__warp_pse_42, __warp_usrid_00_x);
            
            assert __warp_se_143 = 1;
        
        
        
        return (__warp_usrid_02_z,);

    }

    // @notice Cast a uint256 to a uint160, revert on overflow
    // @param y The uint256 to be downcasted
    // @return z The downcasted integer, now type uint160
    func toUint160_dfef6beb{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_y : Uint256)-> (__warp_usrid_01_z : felt){
    alloc_locals;


        
        let __warp_usrid_01_z = 0;
        
        let (__warp_pse_47) = warp_int256_to_int160(__warp_usrid_00_y);
        
        let __warp_usrid_01_z = __warp_pse_47;
        
        let (__warp_se_144) = warp_uint256(__warp_pse_47);
        
        let (__warp_se_145) = warp_eq256(__warp_se_144, __warp_usrid_00_y);
        
        assert __warp_se_145 = 1;
        
        
        
        return (__warp_usrid_01_z,);

    }

}


    @view
    func checkComputeSwapStepInvariants_d7e3056f{syscall_ptr : felt*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_sqrtPriceRaw : felt, __warp_usrid_01_sqrtPriceTargetRaw : felt, __warp_usrid_02_liquidity : felt, __warp_usrid_03_amountRemaining : Uint256, __warp_usrid_04_feePips : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_int24(__warp_usrid_04_feePips);
        
        warp_external_input_check_int256(__warp_usrid_03_amountRemaining);
        
        warp_external_input_check_int128(__warp_usrid_02_liquidity);
        
        warp_external_input_check_int160(__warp_usrid_01_sqrtPriceTargetRaw);
        
        warp_external_input_check_int160(__warp_usrid_00_sqrtPriceRaw);
        
        let (__warp_se_0) = warp_gt(__warp_usrid_00_sqrtPriceRaw, 0);
        
        assert __warp_se_0 = 1;
        
        let (__warp_se_1) = warp_gt(__warp_usrid_01_sqrtPriceTargetRaw, 0);
        
        assert __warp_se_1 = 1;
        
        let (__warp_se_2) = warp_gt(__warp_usrid_04_feePips, 0);
        
        assert __warp_se_2 = 1;
        
        let (__warp_se_3) = warp_lt(__warp_usrid_04_feePips, 1000000);
        
        assert __warp_se_3 = 1;
        
        let (__warp_usrid_05_sqrtQ, __warp_usrid_06_amountIn, __warp_usrid_07_amountOut, __warp_usrid_08_feeAmount) = SwapMathEchidnaTest.computeSwapStep_100d3f74(__warp_usrid_00_sqrtPriceRaw, __warp_usrid_01_sqrtPriceTargetRaw, __warp_usrid_02_liquidity, __warp_usrid_03_amountRemaining, __warp_usrid_04_feePips);
        
        let (__warp_se_4) = warp_sub256(Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455), __warp_usrid_08_feeAmount);
        
        let (__warp_se_5) = warp_le256(__warp_usrid_06_amountIn, __warp_se_4);
        
        assert __warp_se_5 = 1;
        
        let (__warp_se_6) = warp_lt_signed256(__warp_usrid_03_amountRemaining, Uint256(low=0, high=0));
        
            
            if (__warp_se_6 != 0){
            
                
                let (__warp_se_7) = warp_negate256(__warp_usrid_03_amountRemaining);
                
                let (__warp_se_8) = warp_le256(__warp_usrid_07_amountOut, __warp_se_7);
                
                assert __warp_se_8 = 1;
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
                tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
                tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
                tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
            }else{
            
                
                let (__warp_se_9) = warp_add256(__warp_usrid_06_amountIn, __warp_usrid_08_feeAmount);
                
                let (__warp_se_10) = warp_le256(__warp_se_9, __warp_usrid_03_amountRemaining);
                
                assert __warp_se_10 = 1;
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
                tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
                tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
                tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
            tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
            tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
        
        let (__warp_se_11) = warp_eq(__warp_usrid_00_sqrtPriceRaw, __warp_usrid_01_sqrtPriceTargetRaw);
        
            
            if (__warp_se_11 != 0){
            
                
                let (__warp_se_12) = warp_eq256(__warp_usrid_06_amountIn, Uint256(low=0, high=0));
                
                assert __warp_se_12 = 1;
                
                let (__warp_se_13) = warp_eq256(__warp_usrid_07_amountOut, Uint256(low=0, high=0));
                
                assert __warp_se_13 = 1;
                
                let (__warp_se_14) = warp_eq256(__warp_usrid_08_feeAmount, Uint256(low=0, high=0));
                
                assert __warp_se_14 = 1;
                
                let (__warp_se_15) = warp_eq(__warp_usrid_05_sqrtQ, __warp_usrid_01_sqrtPriceTargetRaw);
                
                assert __warp_se_15 = 1;
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
                tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
                tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
                tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
                tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
                tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
                tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
                tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
            tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
            tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
            tempvar __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
            tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
            tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
            tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
        
        let (__warp_se_16) = warp_neq(__warp_usrid_05_sqrtQ, __warp_usrid_01_sqrtPriceTargetRaw);
        
            
            if (__warp_se_16 != 0){
            
                
                let (__warp_se_17) = warp_lt_signed256(__warp_usrid_03_amountRemaining, Uint256(low=0, high=0));
                
                    
                    if (__warp_se_17 != 0){
                    
                        
                        let (__warp_se_18) = warp_negate256(__warp_usrid_03_amountRemaining);
                        
                        let (__warp_se_19) = warp_eq256(__warp_usrid_07_amountOut, __warp_se_18);
                        
                        assert __warp_se_19 = 1;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
                        tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
                        tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
                    }else{
                    
                        
                        let (__warp_se_20) = warp_add256(__warp_usrid_06_amountIn, __warp_usrid_08_feeAmount);
                        
                        let (__warp_se_21) = warp_eq256(__warp_se_20, __warp_usrid_03_amountRemaining);
                        
                        assert __warp_se_21 = 1;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
                        tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
                        tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
                    tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
                    tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
                tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
                tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
                tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
                tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar __warp_usrid_05_sqrtQ = __warp_usrid_05_sqrtQ;
            tempvar __warp_usrid_01_sqrtPriceTargetRaw = __warp_usrid_01_sqrtPriceTargetRaw;
            tempvar __warp_usrid_00_sqrtPriceRaw = __warp_usrid_00_sqrtPriceRaw;
        
        let (__warp_se_22) = warp_le(__warp_usrid_01_sqrtPriceTargetRaw, __warp_usrid_00_sqrtPriceRaw);
        
            
            if (__warp_se_22 != 0){
            
                
                let (__warp_se_23) = warp_le(__warp_usrid_05_sqrtQ, __warp_usrid_00_sqrtPriceRaw);
                
                assert __warp_se_23 = 1;
                
                let (__warp_se_24) = warp_ge(__warp_usrid_05_sqrtQ, __warp_usrid_01_sqrtPriceTargetRaw);
                
                assert __warp_se_24 = 1;
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
            }else{
            
                
                let (__warp_se_25) = warp_ge(__warp_usrid_05_sqrtQ, __warp_usrid_00_sqrtPriceRaw);
                
                assert __warp_se_25 = 1;
                
                let (__warp_se_26) = warp_le(__warp_usrid_05_sqrtQ, __warp_usrid_01_sqrtPriceTargetRaw);
                
                assert __warp_se_26 = 1;
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
        
        
        
        return ();

    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(){
    alloc_locals;


        
        
        
        return ();

    }

// Original soldity abi: ["constructor()","checkComputeSwapStepInvariants(uint160,uint160,uint128,int256,uint24)"]