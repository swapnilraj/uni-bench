%lang starknet


from warplib.memory import wm_read_felt, wm_read_256, wm_alloc, wm_write_felt, wm_write_256, wm_new, wm_dyn_array_length, wm_index_dyn
from starkware.cairo.common.dict import dict_write, dict_read
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_le, uint256_lt, SHIFT, HALF_SHIFT, split_64, uint256_check
from starkware.cairo.common.alloc import alloc
from warplib.maths.utils import narrow_safe, felt_to_uint256
from starkware.cairo.common.math import split_felt
from warplib.maths.external_input_check_ints import warp_external_input_check_int24, warp_external_input_check_int32, warp_external_input_check_int16, warp_external_input_check_int160, warp_external_input_check_int128, warp_external_input_check_int8, warp_external_input_check_int256
from warplib.maths.external_input_check_address import warp_external_input_check_address
from warplib.maths.external_input_check_bool import warp_external_input_check_bool
from warplib.dynamic_arrays_util import fixed_bytes256_to_felt_dynamic_array, fixed_bytes_to_felt_dynamic_array, felt_array_to_warp_memory_array
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.lt import warp_lt256, warp_lt
from warplib.maths.add_unsafe import warp_add_unsafe256, warp_add_unsafe16, warp_add_unsafe128, warp_add_unsafe8, warp_add_unsafe24, warp_add_unsafe160, warp_add_unsafe40
from warplib.maths.sub_unsafe import warp_sub_unsafe256, warp_sub_unsafe16, warp_sub_unsafe128, warp_sub_unsafe160, warp_sub_unsafe32, warp_sub_unsafe8, warp_sub_unsafe24
from warplib.maths.div_unsafe import warp_div_unsafe256, warp_div_unsafe
from warplib.maths.int_conversions import warp_uint256, warp_int256_to_int128, warp_int256_to_int32, warp_int128_to_int256, warp_int256_to_int160, warp_int24_to_int56, warp_int32_to_int56, warp_int24_to_int256, warp_int256_to_int24, warp_int24_to_int16, warp_int24_to_int8
from warplib.maths.mod import warp_mod256, warp_mod
from warplib.maths.neq import warp_neq256, warp_neq
from warplib.maths.lt_signed import warp_lt_signed24, warp_lt_signed256, warp_lt_signed128
from warplib.maths.gt_signed import warp_gt_signed24, warp_gt_signed256
from warplib.maths.sub_signed_unsafe import warp_sub_signed_unsafe256, warp_sub_signed_unsafe24, warp_sub_signed_unsafe56
from warplib.maths.add_signed_unsafe import warp_add_signed_unsafe256, warp_add_signed_unsafe56, warp_add_signed_unsafe24
from warplib.maths.gt import warp_gt, warp_gt256
from warplib.maths.eq import warp_eq, warp_eq256
from warplib.maths.negate import warp_negate128, warp_negate256
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address
from warplib.maths.ge import warp_ge, warp_ge256
from warplib.maths.le import warp_le, warp_le256
from warplib.maths.shl import warp_shl8, warp_shl160, warp_shl256, warp_shl256_256
from warplib.maths.shr import warp_shr8, warp_shr256, warp_shr256_256
from warplib.maths.ge_signed import warp_ge_signed24, warp_ge_signed256
from warplib.maths.le_signed import warp_le_signed24, warp_le_signed256
from warplib.block_methods import warp_block_timestamp
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.cairo_keccak.keccak import finalize_keccak
from warplib.maths.div_signed_unsafe import warp_div_signed_unsafe24, warp_div_signed_unsafe56
from warplib.maths.mul_signed_unsafe import warp_mul_signed_unsafe24, warp_mul_signed_unsafe56, warp_mul_signed_unsafe256
from warplib.maths.sub import warp_sub
from warplib.maths.mul_unsafe import warp_mul_unsafe256
from warplib.maths.bitwise_and import warp_bitwise_and256
from warplib.maths.bitwise_or import warp_bitwise_or256
from warplib.maths.shr_signed import warp_shr_signed256, warp_shr_signed24
from warplib.maths.mul import warp_mul256
from warplib.maths.div import warp_div256
from warplib.maths.mulmod import warp_mulmod
from warplib.maths.xor import warp_xor256
from warplib.keccak import warp_keccak
from warplib.maths.mod_signed import warp_mod_signed24
from warplib.maths.bitwise_not import warp_bitwise_not256

// Splits a field element in the range [0, 2^224) to its low 128-bit and high 96-bit parts.
func split_128{range_check_ptr}(a: felt) -> (low: felt, high: felt) {
    alloc_locals;
    const UPPER_BOUND = 2 ** 224;
    const HIGH_BOUND = UPPER_BOUND / SHIFT;
    local low: felt;
    local high: felt;

    %{
        ids.low = ids.a & ((1<<128) - 1)
        ids.high = ids.a >> 128
    %}
    assert a = low + high * SHIFT;
    assert [range_check_ptr + 0] = high;
    assert [range_check_ptr + 1] = HIGH_BOUND - 1 - high;
    assert [range_check_ptr + 2] = low;
    let range_check_ptr = range_check_ptr + 3;
    return (low, high);
}

// Adds two integers. Returns the result as a 256-bit integer and the (1-bit) carry.
// Doesn't verify that the result is a valid Uint256
// For use when that check would be performed elsewhere
func _uint256_add_no_uint256_check{range_check_ptr}(a: Uint256, b: Uint256) -> (res: Uint256, carry: felt) {
    alloc_locals;
    local res: Uint256;
    local carry_low: felt;
    local carry_high: felt;
    %{
        sum_low = ids.a.low + ids.b.low
        ids.carry_low = 1 if sum_low >= ids.SHIFT else 0
        sum_high = ids.a.high + ids.b.high + ids.carry_low
        ids.carry_high = 1 if sum_high >= ids.SHIFT else 0
    %}

    assert carry_low * carry_low = carry_low;
    assert carry_high * carry_high = carry_high;

    assert res.low = a.low + b.low - carry_low * SHIFT;
    assert res.high = a.high + b.high + carry_low - carry_high * SHIFT;

    return (res, carry_high);
}



func uint256_mul{range_check_ptr}(a: Uint256, b: Uint256) -> (low: Uint256, high: Uint256) {
    alloc_locals;
    let (a0, a1) = split_64(a.low);
    let (a2, a3) = split_64(a.high);
    let (b0, b1) = split_64(b.low);
    let (b2, b3) = split_64(b.high);
    
    local B0 = b0*HALF_SHIFT;
    local b12 = b1 + b2*HALF_SHIFT;
    
    let (res0, carry) = split_128(a1 * B0 + a0 * b.low);
    let (res2, carry) = split_128(
	a3 * B0 + a2 * b.low + a1 * b12 + a0 * b.high + carry,
    );
    let (res4, carry) = split_128(
        a3 * b12 + a2 * b.high + a1 * b3 + carry
    );
    // let (res6, carry) = split_64(a3 * b3 + carry);

    return (low=Uint256(low=res0, high=res2), high=Uint256(low=res4, high=a3 * b3 + carry),);
}


func uint256_square{range_check_ptr}(a: Uint256) -> (low: Uint256, high: Uint256) {
    alloc_locals;
    let (a0, a1) = split_64(a.low);
    let (a2, a3) = split_64(a.high);

    const HALF_SHIFT2 = 2*HALF_SHIFT;

    local a12=a1 + a2*HALF_SHIFT2;

    let (res0, carry) = split_128(a0*(a0 + a1*HALF_SHIFT2));
    let (res2, carry) = split_128(a0*a.high*2 + a1*a12 + carry);
    let (res4, carry) = split_128(a3*(a1 + a12) + a2*a2 + carry);
    // let (res6, carry) = split_64(a3*a3 + carry);

    return (low=Uint256(low=res0, high=res2), high=Uint256(low=res4, high=a3*a3 + carry),);
}

// Returns the floor value of the square root of a uint256 integer.
func uint256_sqrt{range_check_ptr}(n: Uint256) -> (res: Uint256) {
    alloc_locals;
    local root: felt;

    %{
        from starkware.python.math_utils import isqrt
        n = (ids.n.high << 128) + ids.n.low
        root = isqrt(n)
        assert 0 <= root < 2 ** 128
        ids.root = root
    %}

    // Verify that 0 <= root < 2**128.
    [range_check_ptr] = root;
    let range_check_ptr = range_check_ptr + 1;

    // Verify that n >= root**2.
    let (root_squared) = uint128_square(root);
    let (check_lower_bound) = uint256_le(root_squared, n);
    assert check_lower_bound = 1;

    // Verify that n <= (root+1)**2 - 1.
    // Note that (root+1)**2 - 1 = root**2 + 2*root.
    // In the case where root = 2**128 - 1,
    // Since (root+1)**2 = 2**256, next_root_squared_minus_one = 2**256 - 1, as desired.
    let (twice_root) = uint128_add(root, root);
    let (next_root_squared_minus_one,_) = uint256_add(root_squared,twice_root);
    let (check_upper_bound) = uint256_le(n, next_root_squared_minus_one);
    assert check_upper_bound = 1;

    return (res=Uint256(low=root,high=0));
}

//Uses new uint256_mul, also uses no_uint256_check version of add
func uint256_unsigned_div_rem{range_check_ptr}(a: Uint256, div: Uint256) -> (
    quotient: Uint256, remainder: Uint256
) {
    alloc_locals;

    // If div == 0, return (0, 0).
    if (div.low + div.high == 0) {
        return (quotient=Uint256(0, 0), remainder=Uint256(0, 0));
    }

    // Guess the quotient and the remainder.
    local quotient: Uint256;
    local remainder: Uint256;
    %{
        a = (ids.a.high << 128) + ids.a.low
        div = (ids.div.high << 128) + ids.div.low
        quotient, remainder = divmod(a, div)

        ids.quotient.low = quotient & ((1 << 128) - 1)
        ids.quotient.high = quotient >> 128
        ids.remainder.low = remainder & ((1 << 128) - 1)
        ids.remainder.high = remainder >> 128
    %}
    uint256_check(quotient);
    uint256_check(remainder);
    let (res_mul, carry) = uint256_mul(quotient, div);
    assert carry = Uint256(0, 0);

    let (check_val, add_carry) = _uint256_add_no_uint256_check(res_mul, remainder);
    assert check_val = a;
    assert add_carry = 0;

    let (is_valid) = uint256_lt(remainder, div);
    assert is_valid = 1;
    return (quotient=quotient, remainder=remainder);
}




// Subtracts two integers. Returns the result as a 256-bit integer
// and a sign felt that is 1 if the result is non-negative, convention based on signed_nn
// although I think the opposite convetion makes more sense
func uint256_sub{range_check_ptr}(a: Uint256, b: Uint256) -> (res: Uint256, sign: felt) {
    alloc_locals;
    local res : Uint256;
    %{
        def split(num: int, num_bits_shift: int = 128, length: int = 2):
            a = []
            for _ in range(length):
                a.append( num & ((1 << num_bits_shift) - 1) )
                num = num >> num_bits_shift
            return tuple(a)

        def pack(z, num_bits_shift: int = 128) -> int:
            limbs = (z.low, z.high)
            return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

        a = pack(ids.a)
        b = pack(ids.b)
        res = (a - b)%2**256
        res_split = split(res)
        ids.res.low = res_split[0]
        ids.res.high = res_split[1]
     %}
     uint256_check(res);
     let (aa, inv_sign) = _uint256_add_no_uint256_check(res,b);
     assert aa = a;
     return (res, 1-inv_sign);
}

//assumes inputs are <2**128
func uint128_add{range_check_ptr}(a: felt, b: felt) -> (result: Uint256) {
    alloc_locals;
    local carry: felt;
    %{
        res = ids.a + ids.b
        ids.carry = 1 if res >= ids.SHIFT else 0
    %}
    // Either 0 or 1
    assert carry * carry = carry;
    local res = a + b - carry * SHIFT;
    [range_check_ptr] = res;
    let range_check_ptr = range_check_ptr + 1;

    return (result=Uint256(low=res, high=carry));
}

//assumes inputs are <2**128
func uint128_mul{range_check_ptr}(a: felt, b: felt) -> (result: Uint256) {
    let (a0, a1) = split_64(a);
    let (b0, b1) = split_64(b);

    let (res0, carry) = split_128(a1 * b0*HALF_SHIFT + a0 * b);
    // let (res2, carry) = split_64(a1 * b1 + carry);

    return (result=Uint256(low=res0, high=a1 * b1 + carry));
}

//assumes input is <2**128
func uint128_square{range_check_ptr}(a: felt) -> (result: Uint256) {
    let (a0, a1) = split_64(a);

    let (res0, carry) = split_128(a0*(a + a1*HALF_SHIFT));
    // let (res2, carry) = split_64(a1 * a1 + carry);

    return (result=Uint256(low=res0, high=a1 * a1 + carry));
}

//a series of overlapping 128-bit sections of a Uint256.
//for use in uint128_mul_expanded and uint128_unsigned_div_rem_expanded
struct Uint256_expand {
    B0: felt,
    b01: felt,
    b12: felt,
    b23: felt,
    b3: felt,
}

//expands a Uint256 into a Uint256_expand
func uint256_expand{range_check_ptr}(a: Uint256) -> (exp: Uint256_expand) {
    let (a0, a1) = split_64(a.low);
    let (a2, a3) = split_64(a.high);
      
    return(exp=Uint256_expand(a0*HALF_SHIFT,a.low,a1 + a2*HALF_SHIFT,a.high,a3));
}

func uint256_mul_expanded{range_check_ptr}(a: Uint256, b: Uint256_expand) -> (low: Uint256, high: Uint256) {
    let (a0, a1) = split_64(a.low);
    let (a2, a3) = split_64(a.high);

    let (res0, carry) = split_128(a1 * b.B0 + a0 * b.b01);
    let (res2, carry) = split_128(
	a3 * b.B0 + a2 * b.b01 + a1 * b.b12 + a0 * b.b23 + carry,
    );
    let (res4, carry) = split_128(
        a3 * b.b12 + a2 * b.b23 + a1 * b.b3 + carry
    );
    // let (res6, carry) = split_64(a3 * b.b3 + carry);

    return (low=Uint256(low=res0, high=res2), high=Uint256(low=res4, high=a3 * b.b3 + carry),);
}

func uint256_unsigned_div_rem_expanded{range_check_ptr}(a: Uint256, div: Uint256_expand) -> (
    quotient: Uint256, remainder: Uint256
) {
    alloc_locals;

    // Guess the quotient and the remainder.
    local quotient: Uint256;
    local remainder: Uint256;
    %{
        a = (ids.a.high << 128) + ids.a.low
        div = (ids.div.b23 << 128) + ids.div.b01
        quotient, remainder = divmod(a, div)

        ids.quotient.low = quotient & ((1 << 128) - 1)
        ids.quotient.high = quotient >> 128
        ids.remainder.low = remainder & ((1 << 128) - 1)
        ids.remainder.high = remainder >> 128
    %}
    uint256_check(quotient);
    uint256_check(remainder);
    let (res_mul, carry) = uint256_mul_expanded(quotient, div);
    assert carry = Uint256(0, 0);

    let (check_val, add_carry) = _uint256_add_no_uint256_check(res_mul, remainder);
    assert check_val = a;
    assert add_carry = 0;

    let (is_valid) = uint256_lt(remainder, Uint256(div.b01,div.b23));
    assert is_valid = 1;
    return (quotient=quotient, remainder=remainder);
}


// Computes:
// 1. The integer division `(a * b) // div` (as a 512-bit number).
// 2. The remainder `(a * b) modulo div`.
// Assumption: div != 0.
func uint256_mul_div_mod{range_check_ptr}(a: Uint256, b: Uint256, div: Uint256) -> (
    quotient_low: Uint256, quotient_high: Uint256, remainder: Uint256
) {
    alloc_locals;

    // Compute a * b (512 bits).
    let (ab_low, ab_high) = uint256_mul(a, b);

    // Guess the quotient and remainder of (a * b) / d.
    local quotient_low: Uint256;
    local quotient_high: Uint256;
    local remainder: Uint256;

    %{
        a = (ids.a.high << 128) + ids.a.low
        b = (ids.b.high << 128) + ids.b.low
        div = (ids.div.high << 128) + ids.div.low
        quotient, remainder = divmod(a * b, div)

        ids.quotient_low.low = quotient & ((1 << 128) - 1)
        ids.quotient_low.high = (quotient >> 128) & ((1 << 128) - 1)
        ids.quotient_high.low = (quotient >> 256) & ((1 << 128) - 1)
        ids.quotient_high.high = quotient >> 384
        ids.remainder.low = remainder & ((1 << 128) - 1)
        ids.remainder.high = remainder >> 128
    %}

    // Compute x = quotient * div + remainder.
    uint256_check(quotient_high);
    let (quotient_mod10, quotient_mod11) = uint256_mul(quotient_high, div);
    uint256_check(quotient_low);
    let (quotient_mod00, quotient_mod01) = uint256_mul(quotient_low, div);
    // Since x should equal a * b, the high 256 bits must be zero.
    assert quotient_mod11 = Uint256(0, 0);

    // The low 256 bits of x must be ab_low.
    uint256_check(remainder);
    let (x0, carry0) = uint256_add(quotient_mod00, remainder);
    assert x0 = ab_low;

    let (x1, carry1) = uint256_add(quotient_mod01, quotient_mod10);
    assert carry1 = 0;
    let (x1, carry2) = uint256_add(x1, Uint256(low=carry0, high=0));
    assert carry2 = 0;

    assert x1 = ab_high;

    // Verify that 0 <= remainder < div.
    let (is_valid) = uint256_lt(remainder, div);
    assert is_valid = 1;

    return (quotient_low=quotient_low, quotient_high=quotient_high, remainder=remainder);
}



struct Info_d529aac3{
    __warp_usrid_00_liquidity : felt,
    __warp_usrid_01_feeGrowthInside0LastX128 : Uint256,
    __warp_usrid_02_feeGrowthInside1LastX128 : Uint256,
    __warp_usrid_03_tokensOwed0 : felt,
    __warp_usrid_04_tokensOwed1 : felt,
}


struct Observation_2cc4d695{
    __warp_usrid_00_blockTimestamp : felt,
    __warp_usrid_01_tickCumulative : felt,
    __warp_usrid_02_secondsPerLiquidityCumulativeX128 : felt,
    __warp_usrid_03_initialized : felt,
}


struct Info_39bc053d{
    __warp_usrid_00_liquidityGross : felt,
    __warp_usrid_01_liquidityNet : felt,
    __warp_usrid_02_feeGrowthOutside0X128 : Uint256,
    __warp_usrid_03_feeGrowthOutside1X128 : Uint256,
    __warp_usrid_04_tickCumulativeOutside : felt,
    __warp_usrid_05_secondsPerLiquidityOutsideX128 : felt,
    __warp_usrid_06_secondsOutside : felt,
    __warp_usrid_07_initialized : felt,
}


struct Slot0_930d2817{
    __warp_usrid_000_sqrtPriceX96 : felt,
    __warp_usrid_001_tick : felt,
    __warp_usrid_002_observationIndex : felt,
    __warp_usrid_003_observationCardinality : felt,
    __warp_usrid_004_observationCardinalityNext : felt,
    __warp_usrid_005_feeProtocol : felt,
    __warp_usrid_006_unlocked : felt,
}


struct ProtocolFees_bf8b310b{
    __warp_usrid_007_token0 : felt,
    __warp_usrid_008_token1 : felt,
}


struct ModifyPositionParams_82bf7b1b{
    __warp_usrid_009_owner : felt,
    __warp_usrid_010_tickLower : felt,
    __warp_usrid_011_tickUpper : felt,
    __warp_usrid_012_liquidityDelta : felt,
}


struct SwapCache_7600c2b6{
    __warp_usrid_013_feeProtocol : felt,
    __warp_usrid_014_liquidityStart : felt,
    __warp_usrid_015_blockTimestamp : felt,
    __warp_usrid_016_tickCumulative : felt,
    __warp_usrid_017_secondsPerLiquidityCumulativeX128 : felt,
    __warp_usrid_018_computedLatestObservation : felt,
}


struct SwapState_eba3c779{
    __warp_usrid_019_amountSpecifiedRemaining : Uint256,
    __warp_usrid_020_amountCalculated : Uint256,
    __warp_usrid_021_sqrtPriceX96 : felt,
    __warp_usrid_022_tick : felt,
    __warp_usrid_023_feeGrowthGlobalX128 : Uint256,
    __warp_usrid_024_protocolFee : felt,
    __warp_usrid_025_liquidity : felt,
}


struct StepComputations_cf1844f5{
    __warp_usrid_026_sqrtPriceStartX96 : felt,
    __warp_usrid_027_tickNext : felt,
    __warp_usrid_028_initialized : felt,
    __warp_usrid_029_sqrtPriceNextX96 : felt,
    __warp_usrid_030_amountIn : Uint256,
    __warp_usrid_031_amountOut : Uint256,
    __warp_usrid_032_feeAmount : Uint256,
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

func WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(loc: felt) -> (memberLoc: felt){
    return (loc + 4,);
}

func WM5_SwapState_eba3c779___warp_usrid_022_tick(loc: felt) -> (memberLoc: felt){
    return (loc + 5,);
}

func WM9_SwapState_eba3c779___warp_usrid_025_liquidity(loc: felt) -> (memberLoc: felt){
    return (loc + 9,);
}

func WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(loc: felt) -> (memberLoc: felt){
    return (loc + 8,);
}

func WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(loc: felt) -> (memberLoc: felt){
    return (loc + 6,);
}

func WM4_StepComputations_cf1844f5___warp_usrid_026_sqrtPriceStartX96(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WM6_StepComputations_cf1844f5___warp_usrid_028_initialized(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(loc: felt) -> (memberLoc: felt){
    return (loc + 8,);
}

func WM11_StepComputations_cf1844f5___warp_usrid_031_amountOut(loc: felt) -> (memberLoc: felt){
    return (loc + 6,);
}

func WM12_StepComputations_cf1844f5___warp_usrid_030_amountIn(loc: felt) -> (memberLoc: felt){
    return (loc + 4,);
}

func WM14_SwapCache_7600c2b6___warp_usrid_013_feeProtocol(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WM17_SwapCache_7600c2b6___warp_usrid_018_computedLatestObservation(loc: felt) -> (memberLoc: felt){
    return (loc + 5,);
}

func WM18_SwapCache_7600c2b6___warp_usrid_015_blockTimestamp(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WM21_SwapCache_7600c2b6___warp_usrid_014_liquidityStart(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WM23_SwapCache_7600c2b6___warp_usrid_017_secondsPerLiquidityCumulativeX128(loc: felt) -> (memberLoc: felt){
    return (loc + 4,);
}

func WM24_SwapCache_7600c2b6___warp_usrid_016_tickCumulative(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WM19_Slot0_930d2817___warp_usrid_001_tick(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WM20_Slot0_930d2817___warp_usrid_002_observationIndex(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WM22_Slot0_930d2817___warp_usrid_003_observationCardinality(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WM25_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WM26_Slot0_930d2817___warp_usrid_006_unlocked(loc: felt) -> (memberLoc: felt){
    return (loc + 6,);
}

func WM27_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(loc: felt) -> (memberLoc: felt){
    return (loc + 4,);
}

func WM32_Slot0_930d2817___warp_usrid_005_feeProtocol(loc: felt) -> (memberLoc: felt){
    return (loc + 5,);
}

func WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WM30_ModifyPositionParams_82bf7b1b___warp_usrid_009_owner(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WM35_Info_d529aac3___warp_usrid_00_liquidity(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WM36_Info_d529aac3___warp_usrid_01_feeGrowthInside0LastX128(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WM37_Info_d529aac3___warp_usrid_02_feeGrowthInside1LastX128(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WM0_struct_StepComputations_cf1844f5{range_check_ptr, warp_memory: DictAccess*}(__warp_usrid_026_sqrtPriceStartX96: felt, __warp_usrid_027_tickNext: felt, __warp_usrid_028_initialized: felt, __warp_usrid_029_sqrtPriceNextX96: felt, __warp_usrid_030_amountIn: Uint256, __warp_usrid_031_amountOut: Uint256, __warp_usrid_032_feeAmount: Uint256) -> (res:felt){
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

func WM1_struct_SwapCache_7600c2b6{range_check_ptr, warp_memory: DictAccess*}(__warp_usrid_013_feeProtocol: felt, __warp_usrid_014_liquidityStart: felt, __warp_usrid_015_blockTimestamp: felt, __warp_usrid_016_tickCumulative: felt, __warp_usrid_017_secondsPerLiquidityCumulativeX128: felt, __warp_usrid_018_computedLatestObservation: felt) -> (res:felt){
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

func WM2_struct_SwapState_eba3c779{range_check_ptr, warp_memory: DictAccess*}(__warp_usrid_019_amountSpecifiedRemaining: Uint256, __warp_usrid_020_amountCalculated: Uint256, __warp_usrid_021_sqrtPriceX96: felt, __warp_usrid_022_tick: felt, __warp_usrid_023_feeGrowthGlobalX128: Uint256, __warp_usrid_024_protocolFee: felt, __warp_usrid_025_liquidity: felt) -> (res:felt){
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

func WM3_struct_ModifyPositionParams_82bf7b1b{range_check_ptr, warp_memory: DictAccess*}(__warp_usrid_009_owner: felt, __warp_usrid_010_tickLower: felt, __warp_usrid_011_tickUpper: felt, __warp_usrid_012_liquidityDelta: felt) -> (res:felt){
    alloc_locals;
    let (start) = wm_alloc(Uint256(0x4, 0x0));
dict_write{dict_ptr=warp_memory}(start, __warp_usrid_009_owner);
dict_write{dict_ptr=warp_memory}(start + 1, __warp_usrid_010_tickLower);
dict_write{dict_ptr=warp_memory}(start + 2, __warp_usrid_011_tickUpper);
dict_write{dict_ptr=warp_memory}(start + 3, __warp_usrid_012_liquidityDelta);
    return (start,);
}

func WM4_struct_Slot0_930d2817{range_check_ptr, warp_memory: DictAccess*}(__warp_usrid_000_sqrtPriceX96: felt, __warp_usrid_001_tick: felt, __warp_usrid_002_observationIndex: felt, __warp_usrid_003_observationCardinality: felt, __warp_usrid_004_observationCardinalityNext: felt, __warp_usrid_005_feeProtocol: felt, __warp_usrid_006_unlocked: felt) -> (res:felt){
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

func WM5_struct_Observation_2cc4d695{range_check_ptr, warp_memory: DictAccess*}(__warp_usrid_00_blockTimestamp: felt, __warp_usrid_01_tickCumulative: felt, __warp_usrid_02_secondsPerLiquidityCumulativeX128: felt, __warp_usrid_03_initialized: felt) -> (res:felt){
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
let (elem_mem_loc_4) = dict_read{dict_ptr=warp_memory}(mem_loc + 4);
WARP_STORAGE.write(loc + 4, elem_mem_loc_4);
let (elem_mem_loc_5) = dict_read{dict_ptr=warp_memory}(mem_loc + 5);
WARP_STORAGE.write(loc + 5, elem_mem_loc_5);
let (elem_mem_loc_6) = dict_read{dict_ptr=warp_memory}(mem_loc + 6);
WARP_STORAGE.write(loc + 6, elem_mem_loc_6);
    return (loc,);
}

func wm_to_storage1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt, mem_loc: felt) -> (loc: felt){
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

func WS_STRUCT_Info_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt){
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
    WARP_STORAGE.write(loc + 1, 0);
    return ();
}

func WS4_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS5_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS6_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS7_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WSM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM23_Observation_2cc4d695___warp_usrid_01_tickCumulative(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WSM24_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WSM25_Observation_2cc4d695___warp_usrid_03_initialized(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WSM1_Slot0_930d2817___warp_usrid_006_unlocked(loc: felt) -> (memberLoc: felt){
    return (loc + 6,);
}

func WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(loc: felt) -> (memberLoc: felt){
    return (loc + 5,);
}

func WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WSM7_Slot0_930d2817___warp_usrid_001_tick(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WSM8_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM11_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(loc: felt) -> (memberLoc: felt){
    return (loc + 4,);
}

func WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(loc: felt) -> (memberLoc: felt){
    return (loc + 5,);
}

func WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(loc: felt) -> (memberLoc: felt){
    return (loc + 6,);
}

func WSM20_Info_d529aac3___warp_usrid_00_liquidity(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM21_Info_d529aac3___warp_usrid_01_feeGrowthInside0LastX128(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WSM22_Info_d529aac3___warp_usrid_02_feeGrowthInside1LastX128(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(loc: felt) -> (memberLoc: felt){
    return (loc + 6,);
}

func WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(loc: felt) -> (memberLoc: felt){
    return (loc + 7,);
}

func WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(loc: felt) -> (memberLoc: felt){
    return (loc + 8,);
}

func WSM15_Info_39bc053d___warp_usrid_07_initialized(loc: felt) -> (memberLoc: felt){
    return (loc + 9,);
}

func WSM16_Info_39bc053d___warp_usrid_00_liquidityGross(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(loc: felt) -> (memberLoc: felt){
    return (loc + 4,);
}

func WS0_READ_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func WS1_READ_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: Uint256){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0,high=read1),);
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

func ws_to_memory1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt) -> (mem_loc: felt){
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

func ws_to_memory2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt) -> (mem_loc: felt){
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

func WS_WRITE0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: felt) -> (res: felt){
    WARP_STORAGE.write(loc, value);
    return (value,);
}

func WS_WRITE1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: Uint256) -> (res: Uint256){
    WARP_STORAGE.write(loc, value.low);
    WARP_STORAGE.write(loc + 1, value.high);
    return (value,);
}

func extern_input_check0{range_check_ptr : felt}(len: felt, ptr : felt*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
warp_external_input_check_int32(ptr[0]);
   extern_input_check0(len = len - 1, ptr = ptr + 1);
    return ();
}

func extern_input_check1{range_check_ptr : felt}(len: felt, ptr : felt*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
warp_external_input_check_int8(ptr[0]);
   extern_input_check1(len = len - 1, ptr = ptr + 1);
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

func abi_encode_packed0{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(param0 : felt, param1 : felt, param2 : felt) -> (result_ptr : felt){
  alloc_locals;
  let bytes_index : felt = 0;
  let (bytes_array : felt*) = alloc();
let (param0256) = felt_to_uint256(param0);
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param0256);
let bytes_index = bytes_index +  32;
fixed_bytes_to_felt_dynamic_array(bytes_index,bytes_array,0,param1,3);
let bytes_index = bytes_index +  3;
fixed_bytes_to_felt_dynamic_array(bytes_index,bytes_array,0,param2,3);
let bytes_index = bytes_index +  3;
  let (max_length256) = felt_to_uint256(bytes_index);
  let (mem_ptr) = wm_new(max_length256, Uint256(0x1, 0x0));
  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_index);
  return (mem_ptr,);
}

@storage_var
func WARP_MAPPING0(name: felt, index: felt) -> (resLoc : felt){
}
func WS0_INDEX_felt_to_Info_39bc053d{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING0.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 10);
        WARP_MAPPING0.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING1(name: felt, index: felt) -> (resLoc : felt){
}
func WS1_INDEX_felt_to_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING1.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING1.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING2(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS2_INDEX_Uint256_to_Info_d529aac3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING2.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 7);
        WARP_MAPPING2.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}


// Contract Def UniswapV3Pool


// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
// @param sender The address that collects the protocol fees
// @param recipient The address that receives the collected protocol fees
// @param amount0 The amount of token0 protocol fees that is withdrawn
// @param amount0 The amount of token1 protocol fees that is withdrawn
@event
func CollectProtocol_596b5739(__warp_usrid_40_sender : felt, __warp_usrid_41_recipient : felt, __warp_usrid_42_amount0 : felt, __warp_usrid_43_amount1 : felt){
}

// @notice Emitted when the protocol fee is changed by the pool
// @param feeProtocol0Old The previous value of the token0 protocol fee
// @param feeProtocol1Old The previous value of the token1 protocol fee
// @param feeProtocol0New The updated value of the token0 protocol fee
// @param feeProtocol1New The updated value of the token1 protocol fee
@event
func SetFeeProtocol_973d8d92(__warp_usrid_36_feeProtocol0Old : felt, __warp_usrid_37_feeProtocol1Old : felt, __warp_usrid_38_feeProtocol0New : felt, __warp_usrid_39_feeProtocol1New : felt){
}

// @notice Emitted by the pool for increases to the number of observations that can be stored
// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
// just before a mint/swap/burn.
// @param observationCardinalityNextOld The previous value of the next observation cardinality
// @param observationCardinalityNextNew The updated value of the next observation cardinality
@event
func IncreaseObservationCardinalityNext_ac49e518(__warp_usrid_34_observationCardinalityNextOld : felt, __warp_usrid_35_observationCardinalityNextNew : felt){
}

// @notice Emitted by the pool for any flashes of token0/token1
// @param sender The address that initiated the swap call, and that received the callback
// @param recipient The address that received the tokens from flash
// @param amount0 The amount of token0 that was flashed
// @param amount1 The amount of token1 that was flashed
// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
@event
func Flash_bdbdb71d(__warp_usrid_28_sender : felt, __warp_usrid_29_recipient : felt, __warp_usrid_30_amount0 : Uint256, __warp_usrid_31_amount1 : Uint256, __warp_usrid_32_paid0 : Uint256, __warp_usrid_33_paid1 : Uint256){
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
func Swap_c42079f9(__warp_usrid_21_sender : felt, __warp_usrid_22_recipient : felt, __warp_usrid_23_amount0 : Uint256, __warp_usrid_24_amount1 : Uint256, __warp_usrid_25_sqrtPriceX96 : felt, __warp_usrid_26_liquidity : felt, __warp_usrid_27_tick : felt){
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
func Burn_0c396cd9(__warp_usrid_15_owner : felt, __warp_usrid_16_tickLower : felt, __warp_usrid_17_tickUpper : felt, __warp_usrid_18_amount : felt, __warp_usrid_19_amount0 : Uint256, __warp_usrid_20_amount1 : Uint256){
}

// @notice Emitted when fees are collected by the owner of a position
// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
// @param owner The owner of the position for which fees are collected
// @param tickLower The lower tick of the position
// @param tickUpper The upper tick of the position
// @param amount0 The amount of token0 fees collected
// @param amount1 The amount of token1 fees collected
@event
func Collect_70935338(__warp_usrid_09_owner : felt, __warp_usrid_10_recipient : felt, __warp_usrid_11_tickLower : felt, __warp_usrid_12_tickUpper : felt, __warp_usrid_13_amount0 : felt, __warp_usrid_14_amount1 : felt){
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
func Mint_7a53080b(__warp_usrid_02_sender : felt, __warp_usrid_03_owner : felt, __warp_usrid_04_tickLower : felt, __warp_usrid_05_tickUpper : felt, __warp_usrid_06_amount : felt, __warp_usrid_07_amount0 : Uint256, __warp_usrid_08_amount1 : Uint256){
}

// @notice Emitted exactly once by a pool when #initialize is first called on the pool
// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
@event
func Initialize_98636036(__warp_usrid_00_sqrtPriceX96 : felt, __warp_usrid_01_tick : felt){
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

namespace UniswapV3Pool{

    // Dynamic variables - Arrays and Maps

    const __warp_usrid_044_ticks = 1;

    const __warp_usrid_045_tickBitmap = 2;

    const __warp_usrid_046_positions = 3;

    // Static variables

    const __warp_usrid_033_factory = 0;

    const __warp_usrid_034_token0 = 1;

    const __warp_usrid_035_token1 = 2;

    const __warp_usrid_036_fee = 3;

    const __warp_usrid_037_tickSpacing = 4;

    const __warp_usrid_038_maxLiquidityPerTick = 5;

    const __warp_usrid_039_slot0 = 6;

    const __warp_usrid_040_feeGrowthGlobal0X128 = 13;

    const __warp_usrid_041_feeGrowthGlobal1X128 = 15;

    const __warp_usrid_042_protocolFees = 17;

    const __warp_usrid_043_liquidity = 19;

    const __warp_usrid_047_observations = 23;

    const __warp_usrid_00_original = 262163;


    func __warp_while3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_81_i : Uint256, __warp_usrid_74_secondsAgos : felt, __warp_usrid_79_tickCumulatives : felt, __warp_usrid_80_secondsPerLiquidityCumulativeX128s : felt, __warp_usrid_72_self : felt, __warp_usrid_73_time : felt, __warp_usrid_75_tick : felt, __warp_usrid_76_index : felt, __warp_usrid_77_liquidity : felt, __warp_usrid_78_cardinality : felt)-> (__warp_usrid_81_i : Uint256, __warp_usrid_74_secondsAgos : felt, __warp_usrid_79_tickCumulatives : felt, __warp_usrid_80_secondsPerLiquidityCumulativeX128s : felt, __warp_usrid_72_self : felt, __warp_usrid_73_time : felt, __warp_usrid_75_tick : felt, __warp_usrid_76_index : felt, __warp_usrid_77_liquidity : felt, __warp_usrid_78_cardinality : felt){
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
        
        let (__warp_usrid_81_i, __warp_td_0, __warp_td_1, __warp_td_2, __warp_td_3, __warp_usrid_73_time, __warp_usrid_75_tick, __warp_usrid_76_index, __warp_usrid_77_liquidity, __warp_usrid_78_cardinality) = __warp_while3(__warp_usrid_81_i, __warp_usrid_74_secondsAgos, __warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s, __warp_usrid_72_self, __warp_usrid_73_time, __warp_usrid_75_tick, __warp_usrid_76_index, __warp_usrid_77_liquidity, __warp_usrid_78_cardinality);
        
        let __warp_usrid_74_secondsAgos = __warp_td_0;
        
        let __warp_usrid_79_tickCumulatives = __warp_td_1;
        
        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_td_2;
        
        let __warp_usrid_72_self = __warp_td_3;
        
        
        
        return (__warp_usrid_81_i, __warp_usrid_74_secondsAgos, __warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s, __warp_usrid_72_self, __warp_usrid_73_time, __warp_usrid_75_tick, __warp_usrid_76_index, __warp_usrid_77_liquidity, __warp_usrid_78_cardinality);

    }


    func __warp_conditional___warp_while2_1{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_47_targetAtOrAfter : felt, __warp_usrid_38_time : felt, __warp_usrid_39_target : felt, __warp_usrid_43_atOrAfter : felt)-> (__warp_rc_0 : felt, __warp_usrid_47_targetAtOrAfter : felt, __warp_usrid_38_time : felt, __warp_usrid_39_target : felt, __warp_usrid_43_atOrAfter : felt){
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


    func __warp_while2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_46_i : Uint256, __warp_usrid_44_l : Uint256, __warp_usrid_45_r : Uint256, __warp_usrid_42_beforeOrAt : felt, __warp_usrid_37_self : felt, __warp_usrid_41_cardinality : felt, __warp_usrid_43_atOrAfter : felt, __warp_usrid_38_time : felt, __warp_usrid_39_target : felt)-> (__warp_usrid_46_i : Uint256, __warp_usrid_44_l : Uint256, __warp_usrid_45_r : Uint256, __warp_usrid_42_beforeOrAt : felt, __warp_usrid_37_self : felt, __warp_usrid_41_cardinality : felt, __warp_usrid_43_atOrAfter : felt, __warp_usrid_38_time : felt, __warp_usrid_39_target : felt){
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
                            
                            let (__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_td_4, __warp_td_5, __warp_usrid_41_cardinality, __warp_td_6, __warp_usrid_38_time, __warp_usrid_39_target) = __warp_while2(__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);
                            
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
                    
                        
                        let (__warp_tv_2, __warp_tv_3, __warp_tv_4, __warp_tv_5, __warp_td_7) = __warp_conditional___warp_while2_1(__warp_usrid_47_targetAtOrAfter, __warp_usrid_38_time, __warp_usrid_39_target, __warp_usrid_43_atOrAfter);
                        
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
        
        let (__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_td_8, __warp_td_9, __warp_usrid_41_cardinality, __warp_td_10, __warp_usrid_38_time, __warp_usrid_39_target) = __warp_while2(__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);
        
        let __warp_usrid_42_beforeOrAt = __warp_td_8;
        
        let __warp_usrid_37_self = __warp_td_9;
        
        let __warp_usrid_43_atOrAfter = __warp_td_10;
        
        
        
        return (__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);

    }


    func __warp_while1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_30_i : felt, __warp_usrid_28_next : felt, __warp_usrid_26_self : felt)-> (__warp_usrid_30_i : felt, __warp_usrid_28_next : felt, __warp_usrid_26_self : felt){
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
        
        let (__warp_usrid_30_i, __warp_usrid_28_next, __warp_td_11) = __warp_while1(__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);
        
        let __warp_usrid_26_self = __warp_td_11;
        
        
        
        return (__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);

    }


    func __warp_conditional___warp_while0_3{range_check_ptr : felt, warp_memory : DictAccess*}(__warp_usrid_141_state : felt, __warp_usrid_134_sqrtPriceLimitX96 : felt)-> (__warp_rc_2 : felt, __warp_usrid_141_state : felt, __warp_usrid_134_sqrtPriceLimitX96 : felt){
    alloc_locals;


        
        let (__warp_se_30) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(__warp_usrid_141_state);
        
        let (__warp_se_31) = wm_read_256(__warp_se_30);
        
        let (__warp_se_32) = warp_neq256(__warp_se_31, Uint256(low=0, high=0));
        
        if (__warp_se_32 != 0){
        
            
            let (__warp_se_33) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(__warp_usrid_141_state);
            
            let (__warp_se_34) = wm_read_felt(__warp_se_33);
            
            let (__warp_se_35) = warp_neq(__warp_se_34, __warp_usrid_134_sqrtPriceLimitX96);
            
            let __warp_rc_2 = __warp_se_35;
            
            let __warp_rc_2 = __warp_rc_2;
            
            let __warp_usrid_141_state = __warp_usrid_141_state;
            
            let __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
            
            
            
            return (__warp_rc_2, __warp_usrid_141_state, __warp_usrid_134_sqrtPriceLimitX96);
        }else{
        
            
            let __warp_rc_2 = 0;
            
            let __warp_rc_2 = __warp_rc_2;
            
            let __warp_usrid_141_state = __warp_usrid_141_state;
            
            let __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
            
            
            
            return (__warp_rc_2, __warp_usrid_141_state, __warp_usrid_134_sqrtPriceLimitX96);
        }

    }


    func __warp_while0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_141_state : felt, __warp_usrid_134_sqrtPriceLimitX96 : felt, __warp_usrid_132_zeroForOne : felt, __warp_usrid_140_exactInput : felt, __warp_usrid_139_cache : felt, __warp_usrid_138_slot0Start : felt)-> (__warp_usrid_141_state : felt, __warp_usrid_134_sqrtPriceLimitX96 : felt, __warp_usrid_132_zeroForOne : felt, __warp_usrid_140_exactInput : felt, __warp_usrid_139_cache : felt, __warp_usrid_138_slot0Start : felt){
    alloc_locals;


        
            
            let __warp_rc_2 = 0;
            
                
                let (__warp_tv_7, __warp_td_12, __warp_tv_9) = __warp_conditional___warp_while0_3(__warp_usrid_141_state, __warp_usrid_134_sqrtPriceLimitX96);
                
                let __warp_tv_8 = __warp_td_12;
                
                let __warp_usrid_134_sqrtPriceLimitX96 = __warp_tv_9;
                
                let __warp_usrid_141_state = __warp_tv_8;
                
                let __warp_rc_2 = __warp_tv_7;
            
                
                if (__warp_rc_2 != 0){
                
                    
                    let (__warp_usrid_142_step) = WM0_struct_StepComputations_cf1844f5(0, 0, 0, 0, Uint256(low=0, high=0), Uint256(low=0, high=0), Uint256(low=0, high=0));
                    
                    let (__warp_se_36) = WM4_StepComputations_cf1844f5___warp_usrid_026_sqrtPriceStartX96(__warp_usrid_142_step);
                    
                    let (__warp_se_37) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(__warp_usrid_141_state);
                    
                    let (__warp_se_38) = wm_read_felt(__warp_se_37);
                    
                    wm_write_felt(__warp_se_36, __warp_se_38);
                    
                        
                        let (__warp_se_39) = WM5_SwapState_eba3c779___warp_usrid_022_tick(__warp_usrid_141_state);
                        
                        let (__warp_se_40) = wm_read_felt(__warp_se_39);
                        
                        let (__warp_se_41) = WS0_READ_felt(__warp_usrid_037_tickSpacing);
                        
                        let (__warp_tv_10, __warp_tv_11) = nextInitializedTickWithinOneWord_a52a(__warp_usrid_045_tickBitmap, __warp_se_40, __warp_se_41, __warp_usrid_132_zeroForOne);
                        
                        let (__warp_se_42) = WM6_StepComputations_cf1844f5___warp_usrid_028_initialized(__warp_usrid_142_step);
                        
                        wm_write_felt(__warp_se_42, __warp_tv_11);
                        
                        let (__warp_se_43) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(__warp_usrid_142_step);
                        
                        wm_write_felt(__warp_se_43, __warp_tv_10);
                    
                    let (__warp_se_44) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(__warp_usrid_142_step);
                    
                    let (__warp_se_45) = wm_read_felt(__warp_se_44);
                    
                    let (__warp_se_46) = warp_lt_signed24(__warp_se_45, 15889944);
                    
                        
                        if (__warp_se_46 != 0){
                        
                            
                            let (__warp_se_47) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(__warp_usrid_142_step);
                            
                            wm_write_felt(__warp_se_47, 15889944);
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                        }else{
                        
                            
                            let (__warp_se_48) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(__warp_usrid_142_step);
                            
                            let (__warp_se_49) = wm_read_felt(__warp_se_48);
                            
                            let (__warp_se_50) = warp_gt_signed24(__warp_se_49, 887272);
                            
                                
                                if (__warp_se_50 != 0){
                                
                                    
                                    let (__warp_se_51) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(__warp_usrid_142_step);
                                    
                                    wm_write_felt(__warp_se_51, 887272);
                                    tempvar range_check_ptr = range_check_ptr;
                                    tempvar warp_memory = warp_memory;
                                    tempvar syscall_ptr = syscall_ptr;
                                    tempvar pedersen_ptr = pedersen_ptr;
                                    tempvar bitwise_ptr = bitwise_ptr;
                                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                    tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                                }else{
                                
                                    tempvar range_check_ptr = range_check_ptr;
                                    tempvar warp_memory = warp_memory;
                                    tempvar syscall_ptr = syscall_ptr;
                                    tempvar pedersen_ptr = pedersen_ptr;
                                    tempvar bitwise_ptr = bitwise_ptr;
                                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                    tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                                }
                                tempvar range_check_ptr = range_check_ptr;
                                tempvar warp_memory = warp_memory;
                                tempvar syscall_ptr = syscall_ptr;
                                tempvar pedersen_ptr = pedersen_ptr;
                                tempvar bitwise_ptr = bitwise_ptr;
                                tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                        tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                        tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                        tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                        tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                        tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                        tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                    
                    let (__warp_se_52) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(__warp_usrid_142_step);
                    
                    let (__warp_se_53) = wm_read_felt(__warp_se_52);
                    
                    let (__warp_pse_3) = getSqrtRatioAtTick_986cfba3(__warp_se_53);
                    
                    let (__warp_se_54) = WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(__warp_usrid_142_step);
                    
                    wm_write_felt(__warp_se_54, __warp_pse_3);
                    
                        
                        let (__warp_pse_4) = conditional3_e92662c8(__warp_usrid_132_zeroForOne, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_142_step);
                        
                        let (__warp_pse_5) = conditional2_a88d8ea4(__warp_pse_4, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_142_step);
                        
                        let (__warp_se_55) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(__warp_usrid_141_state);
                        
                        let (__warp_se_56) = wm_read_felt(__warp_se_55);
                        
                        let (__warp_se_57) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(__warp_usrid_141_state);
                        
                        let (__warp_se_58) = wm_read_felt(__warp_se_57);
                        
                        let (__warp_se_59) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(__warp_usrid_141_state);
                        
                        let (__warp_se_60) = wm_read_256(__warp_se_59);
                        
                        let (__warp_se_61) = WS0_READ_felt(__warp_usrid_036_fee);
                        
                        let (__warp_tv_12, __warp_tv_13, __warp_tv_14, __warp_tv_15) = computeSwapStep_100d3f74(__warp_se_56, __warp_pse_5, __warp_se_58, __warp_se_60, __warp_se_61);
                        
                        let (__warp_se_62) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(__warp_usrid_142_step);
                        
                        wm_write_256(__warp_se_62, __warp_tv_15);
                        
                        let (__warp_se_63) = WM11_StepComputations_cf1844f5___warp_usrid_031_amountOut(__warp_usrid_142_step);
                        
                        wm_write_256(__warp_se_63, __warp_tv_14);
                        
                        let (__warp_se_64) = WM12_StepComputations_cf1844f5___warp_usrid_030_amountIn(__warp_usrid_142_step);
                        
                        wm_write_256(__warp_se_64, __warp_tv_13);
                        
                        let (__warp_se_65) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(__warp_usrid_141_state);
                        
                        wm_write_felt(__warp_se_65, __warp_tv_12);
                    
                        
                        if (__warp_usrid_140_exactInput != 0){
                        
                            
                            let (__warp_se_66) = WM12_StepComputations_cf1844f5___warp_usrid_030_amountIn(__warp_usrid_142_step);
                            
                            let (__warp_se_67) = wm_read_256(__warp_se_66);
                            
                            let (__warp_se_68) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(__warp_usrid_142_step);
                            
                            let (__warp_se_69) = wm_read_256(__warp_se_68);
                            
                            let (__warp_se_70) = warp_add_unsafe256(__warp_se_67, __warp_se_69);
                            
                            let (__warp_pse_6) = toInt256_dfbe873b(__warp_se_70);
                            
                            let (__warp_se_71) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(__warp_usrid_141_state);
                            
                            let (__warp_se_72) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(__warp_usrid_141_state);
                            
                            let (__warp_se_73) = wm_read_256(__warp_se_72);
                            
                            let (__warp_se_74) = warp_sub_signed_unsafe256(__warp_se_73, __warp_pse_6);
                            
                            wm_write_256(__warp_se_71, __warp_se_74);
                            
                            let (__warp_se_75) = WM11_StepComputations_cf1844f5___warp_usrid_031_amountOut(__warp_usrid_142_step);
                            
                            let (__warp_se_76) = wm_read_256(__warp_se_75);
                            
                            let (__warp_pse_7) = toInt256_dfbe873b(__warp_se_76);
                            
                            let (__warp_se_77) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(__warp_usrid_141_state);
                            
                            let (__warp_se_78) = wm_read_256(__warp_se_77);
                            
                            let (__warp_pse_8) = sub_adefc37b(__warp_se_78, __warp_pse_7);
                            
                            let (__warp_se_79) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(__warp_usrid_141_state);
                            
                            wm_write_256(__warp_se_79, __warp_pse_8);
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                        }else{
                        
                            
                            let (__warp_se_80) = WM11_StepComputations_cf1844f5___warp_usrid_031_amountOut(__warp_usrid_142_step);
                            
                            let (__warp_se_81) = wm_read_256(__warp_se_80);
                            
                            let (__warp_pse_9) = toInt256_dfbe873b(__warp_se_81);
                            
                            let (__warp_se_82) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(__warp_usrid_141_state);
                            
                            let (__warp_se_83) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(__warp_usrid_141_state);
                            
                            let (__warp_se_84) = wm_read_256(__warp_se_83);
                            
                            let (__warp_se_85) = warp_add_signed_unsafe256(__warp_se_84, __warp_pse_9);
                            
                            wm_write_256(__warp_se_82, __warp_se_85);
                            
                            let (__warp_se_86) = WM12_StepComputations_cf1844f5___warp_usrid_030_amountIn(__warp_usrid_142_step);
                            
                            let (__warp_se_87) = wm_read_256(__warp_se_86);
                            
                            let (__warp_se_88) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(__warp_usrid_142_step);
                            
                            let (__warp_se_89) = wm_read_256(__warp_se_88);
                            
                            let (__warp_se_90) = warp_add_unsafe256(__warp_se_87, __warp_se_89);
                            
                            let (__warp_pse_10) = toInt256_dfbe873b(__warp_se_90);
                            
                            let (__warp_se_91) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(__warp_usrid_141_state);
                            
                            let (__warp_se_92) = wm_read_256(__warp_se_91);
                            
                            let (__warp_pse_11) = add_a5f3c23b(__warp_se_92, __warp_pse_10);
                            
                            let (__warp_se_93) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(__warp_usrid_141_state);
                            
                            wm_write_256(__warp_se_93, __warp_pse_11);
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                        tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                        tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                        tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                        tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                        tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                        tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                    
                    let (__warp_se_94) = WM14_SwapCache_7600c2b6___warp_usrid_013_feeProtocol(__warp_usrid_139_cache);
                    
                    let (__warp_se_95) = wm_read_felt(__warp_se_94);
                    
                    let (__warp_se_96) = warp_gt(__warp_se_95, 0);
                    
                        
                        if (__warp_se_96 != 0){
                        
                            
                            let (__warp_se_97) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(__warp_usrid_142_step);
                            
                            let (__warp_se_98) = wm_read_256(__warp_se_97);
                            
                            let (__warp_se_99) = WM14_SwapCache_7600c2b6___warp_usrid_013_feeProtocol(__warp_usrid_139_cache);
                            
                            let (__warp_se_100) = wm_read_felt(__warp_se_99);
                            
                            let (__warp_se_101) = warp_uint256(__warp_se_100);
                            
                            let (__warp_usrid_143_delta) = warp_div_unsafe256(__warp_se_98, __warp_se_101);
                            
                            let (__warp_se_102) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(__warp_usrid_142_step);
                            
                            let (__warp_se_103) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(__warp_usrid_142_step);
                            
                            let (__warp_se_104) = wm_read_256(__warp_se_103);
                            
                            let (__warp_se_105) = warp_sub_unsafe256(__warp_se_104, __warp_usrid_143_delta);
                            
                            wm_write_256(__warp_se_102, __warp_se_105);
                            
                            let (__warp_se_106) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(__warp_usrid_141_state);
                            
                            let (__warp_se_107) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(__warp_usrid_141_state);
                            
                            let (__warp_se_108) = wm_read_felt(__warp_se_107);
                            
                            let (__warp_se_109) = warp_int256_to_int128(__warp_usrid_143_delta);
                            
                            let (__warp_se_110) = warp_add_unsafe128(__warp_se_108, __warp_se_109);
                            
                            wm_write_felt(__warp_se_106, __warp_se_110);
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                        tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                        tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                        tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                        tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                        tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                        tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                    
                    let (__warp_se_111) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(__warp_usrid_141_state);
                    
                    let (__warp_se_112) = wm_read_felt(__warp_se_111);
                    
                    let (__warp_se_113) = warp_gt(__warp_se_112, 0);
                    
                        
                        if (__warp_se_113 != 0){
                        
                            
                            let (__warp_se_114) = WM10_StepComputations_cf1844f5___warp_usrid_032_feeAmount(__warp_usrid_142_step);
                            
                            let (__warp_se_115) = wm_read_256(__warp_se_114);
                            
                            let (__warp_se_116) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(__warp_usrid_141_state);
                            
                            let (__warp_se_117) = wm_read_felt(__warp_se_116);
                            
                            let (__warp_se_118) = warp_uint256(__warp_se_117);
                            
                            let (__warp_pse_12) = mulDiv_aa9a0912(__warp_se_115, Uint256(low=0, high=1), __warp_se_118);
                            
                            let (__warp_se_119) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(__warp_usrid_141_state);
                            
                            let (__warp_se_120) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(__warp_usrid_141_state);
                            
                            let (__warp_se_121) = wm_read_256(__warp_se_120);
                            
                            let (__warp_se_122) = warp_add_unsafe256(__warp_se_121, __warp_pse_12);
                            
                            wm_write_256(__warp_se_119, __warp_se_122);
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                        tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                        tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                        tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                        tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                        tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                        tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                    
                    let (__warp_se_123) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(__warp_usrid_141_state);
                    
                    let (__warp_se_124) = wm_read_felt(__warp_se_123);
                    
                    let (__warp_se_125) = WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(__warp_usrid_142_step);
                    
                    let (__warp_se_126) = wm_read_felt(__warp_se_125);
                    
                    let (__warp_se_127) = warp_eq(__warp_se_124, __warp_se_126);
                    
                        
                        if (__warp_se_127 != 0){
                        
                            
                            let (__warp_se_128) = WM6_StepComputations_cf1844f5___warp_usrid_028_initialized(__warp_usrid_142_step);
                            
                            let (__warp_se_129) = wm_read_felt(__warp_se_128);
                            
                                
                                if (__warp_se_129 != 0){
                                
                                    
                                    let (__warp_se_130) = WM17_SwapCache_7600c2b6___warp_usrid_018_computedLatestObservation(__warp_usrid_139_cache);
                                    
                                    let (__warp_se_131) = wm_read_felt(__warp_se_130);
                                    
                                        
                                        if (1 - __warp_se_131 != 0){
                                        
                                            
                                                
                                                let (__warp_se_132) = WM18_SwapCache_7600c2b6___warp_usrid_015_blockTimestamp(__warp_usrid_139_cache);
                                                
                                                let (__warp_se_133) = wm_read_felt(__warp_se_132);
                                                
                                                let (__warp_se_134) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_138_slot0Start);
                                                
                                                let (__warp_se_135) = wm_read_felt(__warp_se_134);
                                                
                                                let (__warp_se_136) = WM20_Slot0_930d2817___warp_usrid_002_observationIndex(__warp_usrid_138_slot0Start);
                                                
                                                let (__warp_se_137) = wm_read_felt(__warp_se_136);
                                                
                                                let (__warp_se_138) = WM21_SwapCache_7600c2b6___warp_usrid_014_liquidityStart(__warp_usrid_139_cache);
                                                
                                                let (__warp_se_139) = wm_read_felt(__warp_se_138);
                                                
                                                let (__warp_se_140) = WM22_Slot0_930d2817___warp_usrid_003_observationCardinality(__warp_usrid_138_slot0Start);
                                                
                                                let (__warp_se_141) = wm_read_felt(__warp_se_140);
                                                
                                                let (__warp_tv_16, __warp_tv_17) = observeSingle_f7f8d6a0(__warp_usrid_047_observations, __warp_se_133, 0, __warp_se_135, __warp_se_137, __warp_se_139, __warp_se_141);
                                                
                                                let (__warp_se_142) = WM23_SwapCache_7600c2b6___warp_usrid_017_secondsPerLiquidityCumulativeX128(__warp_usrid_139_cache);
                                                
                                                wm_write_felt(__warp_se_142, __warp_tv_17);
                                                
                                                let (__warp_se_143) = WM24_SwapCache_7600c2b6___warp_usrid_016_tickCumulative(__warp_usrid_139_cache);
                                                
                                                wm_write_felt(__warp_se_143, __warp_tv_16);
                                            
                                            let (__warp_se_144) = WM17_SwapCache_7600c2b6___warp_usrid_018_computedLatestObservation(__warp_usrid_139_cache);
                                            
                                            wm_write_felt(__warp_se_144, 1);
                                            tempvar range_check_ptr = range_check_ptr;
                                            tempvar warp_memory = warp_memory;
                                            tempvar syscall_ptr = syscall_ptr;
                                            tempvar pedersen_ptr = pedersen_ptr;
                                            tempvar bitwise_ptr = bitwise_ptr;
                                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                                        }else{
                                        
                                            tempvar range_check_ptr = range_check_ptr;
                                            tempvar warp_memory = warp_memory;
                                            tempvar syscall_ptr = syscall_ptr;
                                            tempvar pedersen_ptr = pedersen_ptr;
                                            tempvar bitwise_ptr = bitwise_ptr;
                                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                                        }
                                        tempvar range_check_ptr = range_check_ptr;
                                        tempvar warp_memory = warp_memory;
                                        tempvar syscall_ptr = syscall_ptr;
                                        tempvar pedersen_ptr = pedersen_ptr;
                                        tempvar bitwise_ptr = bitwise_ptr;
                                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                        tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                        tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                        tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                        tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                        tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                        tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                                    
                                    let (__warp_usrid_144_aux0) = conditional4_9427c021(__warp_usrid_132_zeroForOne, __warp_usrid_141_state);
                                    
                                    let (__warp_usrid_145_aux1) = conditional5_28dc1807(__warp_usrid_132_zeroForOne, __warp_usrid_141_state);
                                    
                                    let (__warp_se_145) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(__warp_usrid_142_step);
                                    
                                    let (__warp_se_146) = wm_read_felt(__warp_se_145);
                                    
                                    let (__warp_se_147) = WM23_SwapCache_7600c2b6___warp_usrid_017_secondsPerLiquidityCumulativeX128(__warp_usrid_139_cache);
                                    
                                    let (__warp_se_148) = wm_read_felt(__warp_se_147);
                                    
                                    let (__warp_se_149) = WM24_SwapCache_7600c2b6___warp_usrid_016_tickCumulative(__warp_usrid_139_cache);
                                    
                                    let (__warp_se_150) = wm_read_felt(__warp_se_149);
                                    
                                    let (__warp_se_151) = WM18_SwapCache_7600c2b6___warp_usrid_015_blockTimestamp(__warp_usrid_139_cache);
                                    
                                    let (__warp_se_152) = wm_read_felt(__warp_se_151);
                                    
                                    let (__warp_usrid_146_liquidityNet) = cross_5d47(__warp_usrid_044_ticks, __warp_se_146, __warp_usrid_144_aux0, __warp_usrid_145_aux1, __warp_se_148, __warp_se_150, __warp_se_152);
                                    
                                        
                                        if (__warp_usrid_132_zeroForOne != 0){
                                        
                                            
                                            let (__warp_se_153) = warp_negate128(__warp_usrid_146_liquidityNet);
                                            
                                            let __warp_usrid_146_liquidityNet = __warp_se_153;
                                            tempvar range_check_ptr = range_check_ptr;
                                            tempvar warp_memory = warp_memory;
                                            tempvar syscall_ptr = syscall_ptr;
                                            tempvar pedersen_ptr = pedersen_ptr;
                                            tempvar bitwise_ptr = bitwise_ptr;
                                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                                            tempvar __warp_usrid_146_liquidityNet = __warp_usrid_146_liquidityNet;
                                        }else{
                                        
                                            tempvar range_check_ptr = range_check_ptr;
                                            tempvar warp_memory = warp_memory;
                                            tempvar syscall_ptr = syscall_ptr;
                                            tempvar pedersen_ptr = pedersen_ptr;
                                            tempvar bitwise_ptr = bitwise_ptr;
                                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                            tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                                            tempvar __warp_usrid_146_liquidityNet = __warp_usrid_146_liquidityNet;
                                        }
                                        tempvar range_check_ptr = range_check_ptr;
                                        tempvar warp_memory = warp_memory;
                                        tempvar syscall_ptr = syscall_ptr;
                                        tempvar pedersen_ptr = pedersen_ptr;
                                        tempvar bitwise_ptr = bitwise_ptr;
                                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                        tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                        tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                        tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                        tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                        tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                        tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                                        tempvar __warp_usrid_146_liquidityNet = __warp_usrid_146_liquidityNet;
                                    
                                    let (__warp_se_154) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(__warp_usrid_141_state);
                                    
                                    let (__warp_se_155) = wm_read_felt(__warp_se_154);
                                    
                                    let (__warp_pse_13) = addDelta_402d44fb(__warp_se_155, __warp_usrid_146_liquidityNet);
                                    
                                    let (__warp_se_156) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(__warp_usrid_141_state);
                                    
                                    wm_write_felt(__warp_se_156, __warp_pse_13);
                                    tempvar range_check_ptr = range_check_ptr;
                                    tempvar warp_memory = warp_memory;
                                    tempvar syscall_ptr = syscall_ptr;
                                    tempvar pedersen_ptr = pedersen_ptr;
                                    tempvar bitwise_ptr = bitwise_ptr;
                                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                    tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                                }else{
                                
                                    tempvar range_check_ptr = range_check_ptr;
                                    tempvar warp_memory = warp_memory;
                                    tempvar syscall_ptr = syscall_ptr;
                                    tempvar pedersen_ptr = pedersen_ptr;
                                    tempvar bitwise_ptr = bitwise_ptr;
                                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                    tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                                }
                                tempvar range_check_ptr = range_check_ptr;
                                tempvar warp_memory = warp_memory;
                                tempvar syscall_ptr = syscall_ptr;
                                tempvar pedersen_ptr = pedersen_ptr;
                                tempvar bitwise_ptr = bitwise_ptr;
                                tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                tempvar __warp_usrid_142_step = __warp_usrid_142_step;
                            
                                
                                if (__warp_usrid_132_zeroForOne != 0){
                                
                                    
                                    let (__warp_se_157) = WM5_SwapState_eba3c779___warp_usrid_022_tick(__warp_usrid_141_state);
                                    
                                    let (__warp_se_158) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(__warp_usrid_142_step);
                                    
                                    let (__warp_se_159) = wm_read_felt(__warp_se_158);
                                    
                                    let (__warp_se_160) = warp_sub_signed_unsafe24(__warp_se_159, 1);
                                    
                                    wm_write_felt(__warp_se_157, __warp_se_160);
                                    tempvar range_check_ptr = range_check_ptr;
                                    tempvar warp_memory = warp_memory;
                                    tempvar syscall_ptr = syscall_ptr;
                                    tempvar pedersen_ptr = pedersen_ptr;
                                    tempvar bitwise_ptr = bitwise_ptr;
                                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                }else{
                                
                                    
                                    let (__warp_se_161) = WM5_SwapState_eba3c779___warp_usrid_022_tick(__warp_usrid_141_state);
                                    
                                    let (__warp_se_162) = WM7_StepComputations_cf1844f5___warp_usrid_027_tickNext(__warp_usrid_142_step);
                                    
                                    let (__warp_se_163) = wm_read_felt(__warp_se_162);
                                    
                                    wm_write_felt(__warp_se_161, __warp_se_163);
                                    tempvar range_check_ptr = range_check_ptr;
                                    tempvar warp_memory = warp_memory;
                                    tempvar syscall_ptr = syscall_ptr;
                                    tempvar pedersen_ptr = pedersen_ptr;
                                    tempvar bitwise_ptr = bitwise_ptr;
                                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                }
                                tempvar range_check_ptr = range_check_ptr;
                                tempvar warp_memory = warp_memory;
                                tempvar syscall_ptr = syscall_ptr;
                                tempvar pedersen_ptr = pedersen_ptr;
                                tempvar bitwise_ptr = bitwise_ptr;
                                tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                        }else{
                        
                            
                            let (__warp_se_164) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(__warp_usrid_141_state);
                            
                            let (__warp_se_165) = wm_read_felt(__warp_se_164);
                            
                            let (__warp_se_166) = WM4_StepComputations_cf1844f5___warp_usrid_026_sqrtPriceStartX96(__warp_usrid_142_step);
                            
                            let (__warp_se_167) = wm_read_felt(__warp_se_166);
                            
                            let (__warp_se_168) = warp_neq(__warp_se_165, __warp_se_167);
                            
                                
                                if (__warp_se_168 != 0){
                                
                                    
                                    let (__warp_se_169) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(__warp_usrid_141_state);
                                    
                                    let (__warp_se_170) = wm_read_felt(__warp_se_169);
                                    
                                    let (__warp_pse_14) = getTickAtSqrtRatio_4f76c058(__warp_se_170);
                                    
                                    let (__warp_se_171) = WM5_SwapState_eba3c779___warp_usrid_022_tick(__warp_usrid_141_state);
                                    
                                    wm_write_felt(__warp_se_171, __warp_pse_14);
                                    tempvar range_check_ptr = range_check_ptr;
                                    tempvar warp_memory = warp_memory;
                                    tempvar syscall_ptr = syscall_ptr;
                                    tempvar pedersen_ptr = pedersen_ptr;
                                    tempvar bitwise_ptr = bitwise_ptr;
                                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                }else{
                                
                                    tempvar range_check_ptr = range_check_ptr;
                                    tempvar warp_memory = warp_memory;
                                    tempvar syscall_ptr = syscall_ptr;
                                    tempvar pedersen_ptr = pedersen_ptr;
                                    tempvar bitwise_ptr = bitwise_ptr;
                                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                                }
                                tempvar range_check_ptr = range_check_ptr;
                                tempvar warp_memory = warp_memory;
                                tempvar syscall_ptr = syscall_ptr;
                                tempvar pedersen_ptr = pedersen_ptr;
                                tempvar bitwise_ptr = bitwise_ptr;
                                tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                                tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                                tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                                tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                                tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                                tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                            tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                            tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                        tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                        tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                        tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                        tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                        tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                }else{
                
                    
                    let __warp_usrid_141_state = __warp_usrid_141_state;
                    
                    let __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                    
                    let __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    
                    let __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                    
                    let __warp_usrid_139_cache = __warp_usrid_139_cache;
                    
                    let __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                    
                    
                    
                    return (__warp_usrid_141_state, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_132_zeroForOne, __warp_usrid_140_exactInput, __warp_usrid_139_cache, __warp_usrid_138_slot0Start);
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
        
        let (__warp_td_13, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_132_zeroForOne, __warp_usrid_140_exactInput, __warp_td_14, __warp_td_15) = __warp_while0(__warp_usrid_141_state, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_132_zeroForOne, __warp_usrid_140_exactInput, __warp_usrid_139_cache, __warp_usrid_138_slot0Start);
        
        let __warp_usrid_141_state = __warp_td_13;
        
        let __warp_usrid_139_cache = __warp_td_14;
        
        let __warp_usrid_138_slot0Start = __warp_td_15;
        
        
        
        return (__warp_usrid_141_state, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_132_zeroForOne, __warp_usrid_140_exactInput, __warp_usrid_139_cache, __warp_usrid_138_slot0Start);

    }


    func __warp_modifier_lock_collectProtocol_85b66729_107{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_parameter___warp_parameter___warp_usrid_190_recipient92100 : felt, __warp_parameter___warp_parameter___warp_usrid_191_amount0Requested93101 : felt, __warp_parameter___warp_parameter___warp_usrid_192_amount1Requested94102 : felt, __warp_parameter___warp_parameter___warp_usrid_193_amount0_m_capture95103 : felt, __warp_parameter___warp_parameter___warp_usrid_194_amount1_m_capture96104 : felt)-> (__warp_ret_parameter___warp_usrid_193_amount0105 : felt, __warp_ret_parameter___warp_usrid_194_amount1106 : felt){
    alloc_locals;


        
        let __warp_ret_parameter___warp_usrid_194_amount1106 = 0;
        
        let __warp_ret_parameter___warp_usrid_193_amount0105 = 0;
        
        let (__warp_se_172) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        let (__warp_se_173) = WS0_READ_felt(__warp_se_172);
        
        with_attr error_message("LOK"){
            assert __warp_se_173 = 1;
        }
        
        let (__warp_se_174) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_174, 0);
        
            
            let (__warp_tv_18, __warp_tv_19) = __warp_modifier_onlyFactoryOwner_collectProtocol_85b66729_99(__warp_parameter___warp_parameter___warp_usrid_190_recipient92100, __warp_parameter___warp_parameter___warp_usrid_191_amount0Requested93101, __warp_parameter___warp_parameter___warp_usrid_192_amount1Requested94102, __warp_parameter___warp_parameter___warp_usrid_193_amount0_m_capture95103, __warp_parameter___warp_parameter___warp_usrid_194_amount1_m_capture96104);
            
            let __warp_ret_parameter___warp_usrid_194_amount1106 = __warp_tv_19;
            
            let __warp_ret_parameter___warp_usrid_193_amount0105 = __warp_tv_18;
        
        let (__warp_se_175) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_175, 1);
        
        let __warp_ret_parameter___warp_usrid_193_amount0105 = __warp_ret_parameter___warp_usrid_193_amount0105;
        
        let __warp_ret_parameter___warp_usrid_194_amount1106 = __warp_ret_parameter___warp_usrid_194_amount1106;
        
        
        
        return (__warp_ret_parameter___warp_usrid_193_amount0105, __warp_ret_parameter___warp_usrid_194_amount1106);

    }


    func __warp_modifier_onlyFactoryOwner_collectProtocol_85b66729_99{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_parameter___warp_usrid_190_recipient92 : felt, __warp_parameter___warp_usrid_191_amount0Requested93 : felt, __warp_parameter___warp_usrid_192_amount1Requested94 : felt, __warp_parameter___warp_usrid_193_amount0_m_capture95 : felt, __warp_parameter___warp_usrid_194_amount1_m_capture96 : felt)-> (__warp_ret_parameter___warp_usrid_193_amount097 : felt, __warp_ret_parameter___warp_usrid_194_amount198 : felt){
    alloc_locals;


        
        let __warp_ret_parameter___warp_usrid_194_amount198 = 0;
        
        let __warp_ret_parameter___warp_usrid_193_amount097 = 0;
        
        let (__warp_se_176) = WS0_READ_felt(__warp_usrid_033_factory);
        
        let (__warp_pse_15) = IUniswapV3Factory_warped_interface.owner_8da5cb5b(__warp_se_176);
        
        let (__warp_se_177) = get_caller_address();
        
        let (__warp_se_178) = warp_eq(__warp_se_177, __warp_pse_15);
        
        assert __warp_se_178 = 1;
        
            
            let (__warp_tv_20, __warp_tv_21) = __warp_original_function_collectProtocol_85b66729_91(__warp_parameter___warp_usrid_190_recipient92, __warp_parameter___warp_usrid_191_amount0Requested93, __warp_parameter___warp_usrid_192_amount1Requested94, __warp_parameter___warp_usrid_193_amount0_m_capture95, __warp_parameter___warp_usrid_194_amount1_m_capture96);
            
            let __warp_ret_parameter___warp_usrid_194_amount198 = __warp_tv_21;
            
            let __warp_ret_parameter___warp_usrid_193_amount097 = __warp_tv_20;
        
        let __warp_ret_parameter___warp_usrid_193_amount097 = __warp_ret_parameter___warp_usrid_193_amount097;
        
        let __warp_ret_parameter___warp_usrid_194_amount198 = __warp_ret_parameter___warp_usrid_194_amount198;
        
        
        
        return (__warp_ret_parameter___warp_usrid_193_amount097, __warp_ret_parameter___warp_usrid_194_amount198);

    }

    // @inheritdoc IUniswapV3PoolOwnerActions
    func __warp_original_function_collectProtocol_85b66729_91{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_190_recipient : felt, __warp_usrid_191_amount0Requested : felt, __warp_usrid_192_amount1Requested : felt, __warp_usrid_193_amount0_m_capture : felt, __warp_usrid_194_amount1_m_capture : felt)-> (__warp_usrid_193_amount0 : felt, __warp_usrid_194_amount1 : felt){
    alloc_locals;


        
        let __warp_usrid_193_amount0 = 0;
        
        let __warp_usrid_194_amount1 = 0;
        
        let __warp_usrid_194_amount1 = __warp_usrid_194_amount1_m_capture;
        
        let __warp_usrid_193_amount0 = __warp_usrid_193_amount0_m_capture;
        
            
            let (__warp_se_179) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(__warp_usrid_042_protocolFees);
            
            let (__warp_se_180) = WS0_READ_felt(__warp_se_179);
            
            let (__warp_se_181) = warp_gt(__warp_usrid_191_amount0Requested, __warp_se_180);
            
                
                if (__warp_se_181 != 0){
                
                    
                    let (__warp_se_182) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(__warp_usrid_042_protocolFees);
                    
                    let (__warp_se_183) = WS0_READ_felt(__warp_se_182);
                    
                    let __warp_usrid_193_amount0 = __warp_se_183;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                    tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                    tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                    tempvar __warp_usrid_192_amount1Requested = __warp_usrid_192_amount1Requested;
                }else{
                
                    
                    let __warp_usrid_193_amount0 = __warp_usrid_191_amount0Requested;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                    tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                    tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                    tempvar __warp_usrid_192_amount1Requested = __warp_usrid_192_amount1Requested;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                tempvar __warp_usrid_192_amount1Requested = __warp_usrid_192_amount1Requested;
            
            let (__warp_se_184) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(__warp_usrid_042_protocolFees);
            
            let (__warp_se_185) = WS0_READ_felt(__warp_se_184);
            
            let (__warp_se_186) = warp_gt(__warp_usrid_192_amount1Requested, __warp_se_185);
            
                
                if (__warp_se_186 != 0){
                
                    
                    let (__warp_se_187) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(__warp_usrid_042_protocolFees);
                    
                    let (__warp_se_188) = WS0_READ_felt(__warp_se_187);
                    
                    let __warp_usrid_194_amount1 = __warp_se_188;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                    tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                    tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                }else{
                
                    
                    let __warp_usrid_194_amount1 = __warp_usrid_192_amount1Requested;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                    tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                    tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
            
            let (__warp_se_189) = warp_gt(__warp_usrid_193_amount0, 0);
            
                
                if (__warp_se_189 != 0){
                
                    
                    let (__warp_se_190) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(__warp_usrid_042_protocolFees);
                    
                    let (__warp_se_191) = WS0_READ_felt(__warp_se_190);
                    
                    let (__warp_se_192) = warp_eq(__warp_usrid_193_amount0, __warp_se_191);
                    
                        
                        if (__warp_se_192 != 0){
                        
                            
                            let (__warp_pse_16) = warp_sub_unsafe128(__warp_usrid_193_amount0, 1);
                            
                            let __warp_usrid_193_amount0 = __warp_pse_16;
                            
                            warp_add_unsafe128(__warp_pse_16, 1);
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                            tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                            tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                        }else{
                        
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                            tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                            tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                        }
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                        tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                        tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                    
                    let (__warp_se_193) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(__warp_usrid_042_protocolFees);
                    
                    let (__warp_se_194) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(__warp_usrid_042_protocolFees);
                    
                    let (__warp_se_195) = WS0_READ_felt(__warp_se_194);
                    
                    let (__warp_se_196) = warp_sub_unsafe128(__warp_se_195, __warp_usrid_193_amount0);
                    
                    WS_WRITE0(__warp_se_193, __warp_se_196);
                    
                    let (__warp_se_197) = WS0_READ_felt(__warp_usrid_034_token0);
                    
                    let (__warp_se_198) = warp_uint256(__warp_usrid_193_amount0);
                    
                    safeTransfer_d1660f99(__warp_se_197, __warp_usrid_190_recipient, __warp_se_198);
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                    tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                    tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                }else{
                
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                    tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                    tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
            
            let (__warp_se_199) = warp_gt(__warp_usrid_194_amount1, 0);
            
                
                if (__warp_se_199 != 0){
                
                    
                    let (__warp_se_200) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(__warp_usrid_042_protocolFees);
                    
                    let (__warp_se_201) = WS0_READ_felt(__warp_se_200);
                    
                    let (__warp_se_202) = warp_eq(__warp_usrid_194_amount1, __warp_se_201);
                    
                        
                        if (__warp_se_202 != 0){
                        
                            
                            let (__warp_pse_17) = warp_sub_unsafe128(__warp_usrid_194_amount1, 1);
                            
                            let __warp_usrid_194_amount1 = __warp_pse_17;
                            
                            warp_add_unsafe128(__warp_pse_17, 1);
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                            tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                            tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                        }else{
                        
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                            tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                            tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                        }
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                        tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                        tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                    
                    let (__warp_se_203) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(__warp_usrid_042_protocolFees);
                    
                    let (__warp_se_204) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(__warp_usrid_042_protocolFees);
                    
                    let (__warp_se_205) = WS0_READ_felt(__warp_se_204);
                    
                    let (__warp_se_206) = warp_sub_unsafe128(__warp_se_205, __warp_usrid_194_amount1);
                    
                    WS_WRITE0(__warp_se_203, __warp_se_206);
                    
                    let (__warp_se_207) = WS0_READ_felt(__warp_usrid_035_token1);
                    
                    let (__warp_se_208) = warp_uint256(__warp_usrid_194_amount1);
                    
                    safeTransfer_d1660f99(__warp_se_207, __warp_usrid_190_recipient, __warp_se_208);
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                    tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                    tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                }else{
                
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                    tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                    tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
                tempvar __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
                tempvar __warp_usrid_190_recipient = __warp_usrid_190_recipient;
            
            let (__warp_se_209) = get_caller_address();
            
            CollectProtocol_596b5739.emit(__warp_se_209, __warp_usrid_190_recipient, __warp_usrid_193_amount0, __warp_usrid_194_amount1);
        
        let __warp_usrid_193_amount0 = __warp_usrid_193_amount0;
        
        let __warp_usrid_194_amount1 = __warp_usrid_194_amount1;
        
        
        
        return (__warp_usrid_193_amount0, __warp_usrid_194_amount1);

    }


    func __warp_modifier_lock_setFeeProtocol_8206a4d1_90{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_parameter___warp_parameter___warp_usrid_187_feeProtocol08588 : felt, __warp_parameter___warp_parameter___warp_usrid_188_feeProtocol18689 : felt)-> (){
    alloc_locals;


        
        let (__warp_se_210) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        let (__warp_se_211) = WS0_READ_felt(__warp_se_210);
        
        with_attr error_message("LOK"){
            assert __warp_se_211 = 1;
        }
        
        let (__warp_se_212) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_212, 0);
        
        __warp_modifier_onlyFactoryOwner_setFeeProtocol_8206a4d1_87(__warp_parameter___warp_parameter___warp_usrid_187_feeProtocol08588, __warp_parameter___warp_parameter___warp_usrid_188_feeProtocol18689);
        
        let (__warp_se_213) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_213, 1);
        
        
        
        return ();

    }


    func __warp_modifier_onlyFactoryOwner_setFeeProtocol_8206a4d1_87{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_parameter___warp_usrid_187_feeProtocol085 : felt, __warp_parameter___warp_usrid_188_feeProtocol186 : felt)-> (){
    alloc_locals;


        
        let (__warp_se_214) = WS0_READ_felt(__warp_usrid_033_factory);
        
        let (__warp_pse_18) = IUniswapV3Factory_warped_interface.owner_8da5cb5b(__warp_se_214);
        
        let (__warp_se_215) = get_caller_address();
        
        let (__warp_se_216) = warp_eq(__warp_se_215, __warp_pse_18);
        
        assert __warp_se_216 = 1;
        
        __warp_original_function_setFeeProtocol_8206a4d1_84(__warp_parameter___warp_usrid_187_feeProtocol085, __warp_parameter___warp_usrid_188_feeProtocol186);
        
        
        
        return ();

    }


    func __warp_conditional___warp_conditional___warp_conditional___warp_original_function_setFeeProtocol_8206a4d1_84_5_7_9{range_check_ptr : felt}(__warp_usrid_187_feeProtocol0 : felt)-> (__warp_rc_8 : felt, __warp_usrid_187_feeProtocol0 : felt){
    alloc_locals;


        
        let (__warp_se_217) = warp_ge(__warp_usrid_187_feeProtocol0, 4);
        
        if (__warp_se_217 != 0){
        
            
            let (__warp_se_218) = warp_le(__warp_usrid_187_feeProtocol0, 10);
            
            let __warp_rc_8 = __warp_se_218;
            
            let __warp_rc_8 = __warp_rc_8;
            
            let __warp_usrid_187_feeProtocol0 = __warp_usrid_187_feeProtocol0;
            
            
            
            return (__warp_rc_8, __warp_usrid_187_feeProtocol0);
        }else{
        
            
            let __warp_rc_8 = 0;
            
            let __warp_rc_8 = __warp_rc_8;
            
            let __warp_usrid_187_feeProtocol0 = __warp_usrid_187_feeProtocol0;
            
            
            
            return (__warp_rc_8, __warp_usrid_187_feeProtocol0);
        }

    }


    func __warp_conditional___warp_conditional___warp_original_function_setFeeProtocol_8206a4d1_84_5_7{range_check_ptr : felt}(__warp_usrid_187_feeProtocol0 : felt)-> (__warp_rc_6 : felt, __warp_usrid_187_feeProtocol0 : felt){
    alloc_locals;


        
        let (__warp_se_219) = warp_eq(__warp_usrid_187_feeProtocol0, 0);
        
        if (__warp_se_219 != 0){
        
            
            let __warp_rc_6 = 1;
            
            let __warp_rc_6 = __warp_rc_6;
            
            let __warp_usrid_187_feeProtocol0 = __warp_usrid_187_feeProtocol0;
            
            
            
            return (__warp_rc_6, __warp_usrid_187_feeProtocol0);
        }else{
        
            
            let __warp_rc_8 = 0;
            
                
                let (__warp_tv_22, __warp_tv_23) = __warp_conditional___warp_conditional___warp_conditional___warp_original_function_setFeeProtocol_8206a4d1_84_5_7_9(__warp_usrid_187_feeProtocol0);
                
                let __warp_usrid_187_feeProtocol0 = __warp_tv_23;
                
                let __warp_rc_8 = __warp_tv_22;
            
            let __warp_rc_6 = __warp_rc_8;
            
            let __warp_rc_6 = __warp_rc_6;
            
            let __warp_usrid_187_feeProtocol0 = __warp_usrid_187_feeProtocol0;
            
            
            
            return (__warp_rc_6, __warp_usrid_187_feeProtocol0);
        }

    }


    func __warp_conditional___warp_conditional___warp_conditional___warp_original_function_setFeeProtocol_8206a4d1_84_5_11_13{range_check_ptr : felt}(__warp_usrid_188_feeProtocol1 : felt)-> (__warp_rc_12 : felt, __warp_usrid_188_feeProtocol1 : felt){
    alloc_locals;


        
        let (__warp_se_220) = warp_ge(__warp_usrid_188_feeProtocol1, 4);
        
        if (__warp_se_220 != 0){
        
            
            let (__warp_se_221) = warp_le(__warp_usrid_188_feeProtocol1, 10);
            
            let __warp_rc_12 = __warp_se_221;
            
            let __warp_rc_12 = __warp_rc_12;
            
            let __warp_usrid_188_feeProtocol1 = __warp_usrid_188_feeProtocol1;
            
            
            
            return (__warp_rc_12, __warp_usrid_188_feeProtocol1);
        }else{
        
            
            let __warp_rc_12 = 0;
            
            let __warp_rc_12 = __warp_rc_12;
            
            let __warp_usrid_188_feeProtocol1 = __warp_usrid_188_feeProtocol1;
            
            
            
            return (__warp_rc_12, __warp_usrid_188_feeProtocol1);
        }

    }


    func __warp_conditional___warp_conditional___warp_original_function_setFeeProtocol_8206a4d1_84_5_11{range_check_ptr : felt}(__warp_usrid_188_feeProtocol1 : felt)-> (__warp_rc_10 : felt, __warp_usrid_188_feeProtocol1 : felt){
    alloc_locals;


        
        let (__warp_se_222) = warp_eq(__warp_usrid_188_feeProtocol1, 0);
        
        if (__warp_se_222 != 0){
        
            
            let __warp_rc_10 = 1;
            
            let __warp_rc_10 = __warp_rc_10;
            
            let __warp_usrid_188_feeProtocol1 = __warp_usrid_188_feeProtocol1;
            
            
            
            return (__warp_rc_10, __warp_usrid_188_feeProtocol1);
        }else{
        
            
            let __warp_rc_12 = 0;
            
                
                let (__warp_tv_26, __warp_tv_27) = __warp_conditional___warp_conditional___warp_conditional___warp_original_function_setFeeProtocol_8206a4d1_84_5_11_13(__warp_usrid_188_feeProtocol1);
                
                let __warp_usrid_188_feeProtocol1 = __warp_tv_27;
                
                let __warp_rc_12 = __warp_tv_26;
            
            let __warp_rc_10 = __warp_rc_12;
            
            let __warp_rc_10 = __warp_rc_10;
            
            let __warp_usrid_188_feeProtocol1 = __warp_usrid_188_feeProtocol1;
            
            
            
            return (__warp_rc_10, __warp_usrid_188_feeProtocol1);
        }

    }


    func __warp_conditional___warp_original_function_setFeeProtocol_8206a4d1_84_5{range_check_ptr : felt}(__warp_usrid_187_feeProtocol0 : felt, __warp_usrid_188_feeProtocol1 : felt)-> (__warp_rc_4 : felt, __warp_usrid_187_feeProtocol0 : felt, __warp_usrid_188_feeProtocol1 : felt){
    alloc_locals;


        
        let __warp_rc_6 = 0;
        
            
            let (__warp_tv_24, __warp_tv_25) = __warp_conditional___warp_conditional___warp_original_function_setFeeProtocol_8206a4d1_84_5_7(__warp_usrid_187_feeProtocol0);
            
            let __warp_usrid_187_feeProtocol0 = __warp_tv_25;
            
            let __warp_rc_6 = __warp_tv_24;
        
        if (__warp_rc_6 != 0){
        
            
            let __warp_rc_10 = 0;
            
                
                let (__warp_tv_28, __warp_tv_29) = __warp_conditional___warp_conditional___warp_original_function_setFeeProtocol_8206a4d1_84_5_11(__warp_usrid_188_feeProtocol1);
                
                let __warp_usrid_188_feeProtocol1 = __warp_tv_29;
                
                let __warp_rc_10 = __warp_tv_28;
            
            let __warp_rc_4 = __warp_rc_10;
            
            let __warp_rc_4 = __warp_rc_4;
            
            let __warp_usrid_187_feeProtocol0 = __warp_usrid_187_feeProtocol0;
            
            let __warp_usrid_188_feeProtocol1 = __warp_usrid_188_feeProtocol1;
            
            
            
            return (__warp_rc_4, __warp_usrid_187_feeProtocol0, __warp_usrid_188_feeProtocol1);
        }else{
        
            
            let __warp_rc_4 = 0;
            
            let __warp_rc_4 = __warp_rc_4;
            
            let __warp_usrid_187_feeProtocol0 = __warp_usrid_187_feeProtocol0;
            
            let __warp_usrid_188_feeProtocol1 = __warp_usrid_188_feeProtocol1;
            
            
            
            return (__warp_rc_4, __warp_usrid_187_feeProtocol0, __warp_usrid_188_feeProtocol1);
        }

    }

    // @inheritdoc IUniswapV3PoolOwnerActions
    func __warp_original_function_setFeeProtocol_8206a4d1_84{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_187_feeProtocol0 : felt, __warp_usrid_188_feeProtocol1 : felt)-> (){
    alloc_locals;


        
            
            let __warp_rc_4 = 0;
            
                
                let (__warp_tv_30, __warp_tv_31, __warp_tv_32) = __warp_conditional___warp_original_function_setFeeProtocol_8206a4d1_84_5(__warp_usrid_187_feeProtocol0, __warp_usrid_188_feeProtocol1);
                
                let __warp_usrid_188_feeProtocol1 = __warp_tv_32;
                
                let __warp_usrid_187_feeProtocol0 = __warp_tv_31;
                
                let __warp_rc_4 = __warp_tv_30;
            
            assert __warp_rc_4 = 1;
            
            let (__warp_se_223) = WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(__warp_usrid_039_slot0);
            
            let (__warp_usrid_189_feeProtocolOld) = WS0_READ_felt(__warp_se_223);
            
            let (__warp_se_224) = WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(__warp_usrid_039_slot0);
            
            let (__warp_se_225) = warp_shl8(__warp_usrid_188_feeProtocol1, 4);
            
            let (__warp_se_226) = warp_add_unsafe8(__warp_usrid_187_feeProtocol0, __warp_se_225);
            
            WS_WRITE0(__warp_se_224, __warp_se_226);
            
            let (__warp_se_227) = warp_mod(__warp_usrid_189_feeProtocolOld, 16);
            
            let (__warp_se_228) = warp_shr8(__warp_usrid_189_feeProtocolOld, 4);
            
            SetFeeProtocol_973d8d92.emit(__warp_se_227, __warp_se_228, __warp_usrid_187_feeProtocol0, __warp_usrid_188_feeProtocol1);
        
        
        
        return ();

    }


    func __warp_modifier_lock_flash_490e6cbc_83{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_parameter___warp_parameter___warp_usrid_170_recipient7479 : felt, __warp_parameter___warp_parameter___warp_usrid_171_amount07580 : Uint256, __warp_parameter___warp_parameter___warp_usrid_172_amount17681 : Uint256, __warp_parameter___warp_parameter___warp_usrid_173_data7782 : cd_dynarray_felt)-> (){
    alloc_locals;


        
        let (__warp_se_229) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        let (__warp_se_230) = WS0_READ_felt(__warp_se_229);
        
        with_attr error_message("LOK"){
            assert __warp_se_230 = 1;
        }
        
        let (__warp_se_231) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_231, 0);
        
        __warp_modifier_noDelegateCall_flash_490e6cbc_78(__warp_parameter___warp_parameter___warp_usrid_170_recipient7479, __warp_parameter___warp_parameter___warp_usrid_171_amount07580, __warp_parameter___warp_parameter___warp_usrid_172_amount17681, __warp_parameter___warp_parameter___warp_usrid_173_data7782);
        
        let (__warp_se_232) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_232, 1);
        
        
        
        return ();

    }


    func __warp_modifier_noDelegateCall_flash_490e6cbc_78{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_parameter___warp_usrid_170_recipient74 : felt, __warp_parameter___warp_usrid_171_amount075 : Uint256, __warp_parameter___warp_usrid_172_amount176 : Uint256, __warp_parameter___warp_usrid_173_data77 : cd_dynarray_felt)-> (){
    alloc_locals;


        
        checkNotDelegateCall_8233c275();
        
        __warp_original_function_flash_490e6cbc_73(__warp_parameter___warp_usrid_170_recipient74, __warp_parameter___warp_usrid_171_amount075, __warp_parameter___warp_usrid_172_amount176, __warp_parameter___warp_usrid_173_data77);
        
        
        
        return ();

    }

    // @inheritdoc IUniswapV3PoolActions
    func __warp_original_function_flash_490e6cbc_73{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_170_recipient : felt, __warp_usrid_171_amount0 : Uint256, __warp_usrid_172_amount1 : Uint256, __warp_usrid_173_data : cd_dynarray_felt)-> (){
    alloc_locals;


        
            
            let (__warp_usrid_174__liquidity) = WS0_READ_felt(__warp_usrid_043_liquidity);
            
            let (__warp_se_233) = warp_gt(__warp_usrid_174__liquidity, 0);
            
            with_attr error_message("L"){
                assert __warp_se_233 = 1;
            }
            
            let (__warp_se_234) = WS0_READ_felt(__warp_usrid_036_fee);
            
            let (__warp_se_235) = warp_uint256(__warp_se_234);
            
            let (__warp_usrid_175_fee0) = mulDivRoundingUp_0af8b27f(__warp_usrid_171_amount0, __warp_se_235, Uint256(low=1000000, high=0));
            
            let (__warp_se_236) = WS0_READ_felt(__warp_usrid_036_fee);
            
            let (__warp_se_237) = warp_uint256(__warp_se_236);
            
            let (__warp_usrid_176_fee1) = mulDivRoundingUp_0af8b27f(__warp_usrid_172_amount1, __warp_se_237, Uint256(low=1000000, high=0));
            
            let (__warp_usrid_177_balance0Before) = balance0_1c69ad00();
            
            let (__warp_usrid_178_balance1Before) = balance1_c45c4f58();
            
            let (__warp_se_238) = warp_gt256(__warp_usrid_171_amount0, Uint256(low=0, high=0));
            
                
                if (__warp_se_238 != 0){
                
                    
                    let (__warp_se_239) = WS0_READ_felt(__warp_usrid_034_token0);
                    
                    safeTransfer_d1660f99(__warp_se_239, __warp_usrid_170_recipient, __warp_usrid_171_amount0);
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                    tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                    tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                    tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                    tempvar __warp_usrid_178_balance1Before = __warp_usrid_178_balance1Before;
                    tempvar __warp_usrid_177_balance0Before = __warp_usrid_177_balance0Before;
                    tempvar __warp_usrid_176_fee1 = __warp_usrid_176_fee1;
                    tempvar __warp_usrid_175_fee0 = __warp_usrid_175_fee0;
                    tempvar __warp_usrid_173_data = __warp_usrid_173_data;
                }else{
                
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                    tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                    tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                    tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                    tempvar __warp_usrid_178_balance1Before = __warp_usrid_178_balance1Before;
                    tempvar __warp_usrid_177_balance0Before = __warp_usrid_177_balance0Before;
                    tempvar __warp_usrid_176_fee1 = __warp_usrid_176_fee1;
                    tempvar __warp_usrid_175_fee0 = __warp_usrid_175_fee0;
                    tempvar __warp_usrid_173_data = __warp_usrid_173_data;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                tempvar __warp_usrid_178_balance1Before = __warp_usrid_178_balance1Before;
                tempvar __warp_usrid_177_balance0Before = __warp_usrid_177_balance0Before;
                tempvar __warp_usrid_176_fee1 = __warp_usrid_176_fee1;
                tempvar __warp_usrid_175_fee0 = __warp_usrid_175_fee0;
                tempvar __warp_usrid_173_data = __warp_usrid_173_data;
            
            let (__warp_se_240) = warp_gt256(__warp_usrid_172_amount1, Uint256(low=0, high=0));
            
                
                if (__warp_se_240 != 0){
                
                    
                    let (__warp_se_241) = WS0_READ_felt(__warp_usrid_035_token1);
                    
                    safeTransfer_d1660f99(__warp_se_241, __warp_usrid_170_recipient, __warp_usrid_172_amount1);
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                    tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                    tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                    tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                    tempvar __warp_usrid_178_balance1Before = __warp_usrid_178_balance1Before;
                    tempvar __warp_usrid_177_balance0Before = __warp_usrid_177_balance0Before;
                    tempvar __warp_usrid_176_fee1 = __warp_usrid_176_fee1;
                    tempvar __warp_usrid_175_fee0 = __warp_usrid_175_fee0;
                    tempvar __warp_usrid_173_data = __warp_usrid_173_data;
                }else{
                
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                    tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                    tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                    tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                    tempvar __warp_usrid_178_balance1Before = __warp_usrid_178_balance1Before;
                    tempvar __warp_usrid_177_balance0Before = __warp_usrid_177_balance0Before;
                    tempvar __warp_usrid_176_fee1 = __warp_usrid_176_fee1;
                    tempvar __warp_usrid_175_fee0 = __warp_usrid_175_fee0;
                    tempvar __warp_usrid_173_data = __warp_usrid_173_data;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                tempvar __warp_usrid_178_balance1Before = __warp_usrid_178_balance1Before;
                tempvar __warp_usrid_177_balance0Before = __warp_usrid_177_balance0Before;
                tempvar __warp_usrid_176_fee1 = __warp_usrid_176_fee1;
                tempvar __warp_usrid_175_fee0 = __warp_usrid_175_fee0;
                tempvar __warp_usrid_173_data = __warp_usrid_173_data;
            
            let (__warp_se_242) = get_caller_address();
            
            IUniswapV3FlashCallback_warped_interface.uniswapV3FlashCallback_e9cbafb0(__warp_se_242, __warp_usrid_175_fee0, __warp_usrid_176_fee1, __warp_usrid_173_data.len, __warp_usrid_173_data.ptr);
            
            let (__warp_usrid_179_balance0After) = balance0_1c69ad00();
            
            let (__warp_usrid_180_balance1After) = balance1_c45c4f58();
            
            let (__warp_pse_19) = add_771602f7(__warp_usrid_177_balance0Before, __warp_usrid_175_fee0);
            
            let (__warp_se_243) = warp_le256(__warp_pse_19, __warp_usrid_179_balance0After);
            
            with_attr error_message("F0"){
                assert __warp_se_243 = 1;
            }
            
            let (__warp_pse_20) = add_771602f7(__warp_usrid_178_balance1Before, __warp_usrid_176_fee1);
            
            let (__warp_se_244) = warp_le256(__warp_pse_20, __warp_usrid_180_balance1After);
            
            with_attr error_message("F1"){
                assert __warp_se_244 = 1;
            }
            
            let (__warp_usrid_181_paid0) = warp_sub_unsafe256(__warp_usrid_179_balance0After, __warp_usrid_177_balance0Before);
            
            let (__warp_usrid_182_paid1) = warp_sub_unsafe256(__warp_usrid_180_balance1After, __warp_usrid_178_balance1Before);
            
            let (__warp_se_245) = warp_gt256(__warp_usrid_181_paid0, Uint256(low=0, high=0));
            
                
                if (__warp_se_245 != 0){
                
                    
                    let (__warp_se_246) = WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(__warp_usrid_039_slot0);
                    
                    let (__warp_se_247) = WS0_READ_felt(__warp_se_246);
                    
                    let (__warp_usrid_183_feeProtocol0) = warp_mod(__warp_se_247, 16);
                    
                    let __warp_usrid_184_fees0 = Uint256(low=0, high=0);
                    
                    let (__warp_se_248) = warp_neq(__warp_usrid_183_feeProtocol0, 0);
                    
                        
                        if (__warp_se_248 != 0){
                        
                            
                            let (__warp_se_249) = warp_uint256(__warp_usrid_183_feeProtocol0);
                            
                            let (__warp_se_250) = warp_div_unsafe256(__warp_usrid_181_paid0, __warp_se_249);
                            
                            let __warp_usrid_184_fees0 = __warp_se_250;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                            tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                            tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                            tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                            tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                            tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                            tempvar __warp_usrid_184_fees0 = __warp_usrid_184_fees0;
                        }else{
                        
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                            tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                            tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                            tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                            tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                            tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                            tempvar __warp_usrid_184_fees0 = __warp_usrid_184_fees0;
                        }
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                        tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                        tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                        tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                        tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                        tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                        tempvar __warp_usrid_184_fees0 = __warp_usrid_184_fees0;
                    
                    let (__warp_se_251) = warp_int256_to_int128(__warp_usrid_184_fees0);
                    
                    let (__warp_se_252) = warp_gt(__warp_se_251, 0);
                    
                        
                        if (__warp_se_252 != 0){
                        
                            
                            let (__warp_se_253) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(__warp_usrid_042_protocolFees);
                            
                            let (__warp_se_254) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(__warp_usrid_042_protocolFees);
                            
                            let (__warp_se_255) = WS0_READ_felt(__warp_se_254);
                            
                            let (__warp_se_256) = warp_int256_to_int128(__warp_usrid_184_fees0);
                            
                            let (__warp_se_257) = warp_add_unsafe128(__warp_se_255, __warp_se_256);
                            
                            WS_WRITE0(__warp_se_253, __warp_se_257);
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                            tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                            tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                            tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                            tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                            tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                            tempvar __warp_usrid_184_fees0 = __warp_usrid_184_fees0;
                        }else{
                        
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                            tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                            tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                            tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                            tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                            tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                            tempvar __warp_usrid_184_fees0 = __warp_usrid_184_fees0;
                        }
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                        tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                        tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                        tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                        tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                        tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                        tempvar __warp_usrid_184_fees0 = __warp_usrid_184_fees0;
                    
                    let (__warp_se_258) = warp_sub_unsafe256(__warp_usrid_181_paid0, __warp_usrid_184_fees0);
                    
                    let (__warp_se_259) = warp_uint256(__warp_usrid_174__liquidity);
                    
                    let (__warp_pse_21) = mulDiv_aa9a0912(__warp_se_258, Uint256(low=0, high=1), __warp_se_259);
                    
                    let (__warp_se_260) = WS1_READ_Uint256(__warp_usrid_040_feeGrowthGlobal0X128);
                    
                    let (__warp_se_261) = warp_add_unsafe256(__warp_se_260, __warp_pse_21);
                    
                    WS_WRITE1(__warp_usrid_040_feeGrowthGlobal0X128, __warp_se_261);
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                    tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                    tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                    tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                    tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                    tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                }else{
                
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                    tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                    tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                    tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                    tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                    tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
            
            let (__warp_se_262) = warp_gt256(__warp_usrid_182_paid1, Uint256(low=0, high=0));
            
                
                if (__warp_se_262 != 0){
                
                    
                    let (__warp_se_263) = WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(__warp_usrid_039_slot0);
                    
                    let (__warp_se_264) = WS0_READ_felt(__warp_se_263);
                    
                    let (__warp_usrid_185_feeProtocol1) = warp_shr8(__warp_se_264, 4);
                    
                    let __warp_usrid_186_fees1 = Uint256(low=0, high=0);
                    
                    let (__warp_se_265) = warp_neq(__warp_usrid_185_feeProtocol1, 0);
                    
                        
                        if (__warp_se_265 != 0){
                        
                            
                            let (__warp_se_266) = warp_uint256(__warp_usrid_185_feeProtocol1);
                            
                            let (__warp_se_267) = warp_div_unsafe256(__warp_usrid_182_paid1, __warp_se_266);
                            
                            let __warp_usrid_186_fees1 = __warp_se_267;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                            tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                            tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                            tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                            tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                            tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                            tempvar __warp_usrid_186_fees1 = __warp_usrid_186_fees1;
                        }else{
                        
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                            tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                            tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                            tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                            tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                            tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                            tempvar __warp_usrid_186_fees1 = __warp_usrid_186_fees1;
                        }
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                        tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                        tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                        tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                        tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                        tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                        tempvar __warp_usrid_186_fees1 = __warp_usrid_186_fees1;
                    
                    let (__warp_se_268) = warp_int256_to_int128(__warp_usrid_186_fees1);
                    
                    let (__warp_se_269) = warp_gt(__warp_se_268, 0);
                    
                        
                        if (__warp_se_269 != 0){
                        
                            
                            let (__warp_se_270) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(__warp_usrid_042_protocolFees);
                            
                            let (__warp_se_271) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(__warp_usrid_042_protocolFees);
                            
                            let (__warp_se_272) = WS0_READ_felt(__warp_se_271);
                            
                            let (__warp_se_273) = warp_int256_to_int128(__warp_usrid_186_fees1);
                            
                            let (__warp_se_274) = warp_add_unsafe128(__warp_se_272, __warp_se_273);
                            
                            WS_WRITE0(__warp_se_270, __warp_se_274);
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                            tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                            tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                            tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                            tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                            tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                            tempvar __warp_usrid_186_fees1 = __warp_usrid_186_fees1;
                        }else{
                        
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                            tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                            tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                            tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                            tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                            tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                            tempvar __warp_usrid_186_fees1 = __warp_usrid_186_fees1;
                        }
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                        tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                        tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                        tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                        tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                        tempvar __warp_usrid_174__liquidity = __warp_usrid_174__liquidity;
                        tempvar __warp_usrid_186_fees1 = __warp_usrid_186_fees1;
                    
                    let (__warp_se_275) = warp_sub_unsafe256(__warp_usrid_182_paid1, __warp_usrid_186_fees1);
                    
                    let (__warp_se_276) = warp_uint256(__warp_usrid_174__liquidity);
                    
                    let (__warp_pse_22) = mulDiv_aa9a0912(__warp_se_275, Uint256(low=0, high=1), __warp_se_276);
                    
                    let (__warp_se_277) = WS1_READ_Uint256(__warp_usrid_041_feeGrowthGlobal1X128);
                    
                    let (__warp_se_278) = warp_add_unsafe256(__warp_se_277, __warp_pse_22);
                    
                    WS_WRITE1(__warp_usrid_041_feeGrowthGlobal1X128, __warp_se_278);
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                    tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                    tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                    tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                    tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                }else{
                
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                    tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                    tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                    tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                    tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_170_recipient = __warp_usrid_170_recipient;
                tempvar __warp_usrid_171_amount0 = __warp_usrid_171_amount0;
                tempvar __warp_usrid_172_amount1 = __warp_usrid_172_amount1;
                tempvar __warp_usrid_181_paid0 = __warp_usrid_181_paid0;
                tempvar __warp_usrid_182_paid1 = __warp_usrid_182_paid1;
            
            let (__warp_se_279) = get_caller_address();
            
            Flash_bdbdb71d.emit(__warp_se_279, __warp_usrid_170_recipient, __warp_usrid_171_amount0, __warp_usrid_172_amount1, __warp_usrid_181_paid0, __warp_usrid_182_paid1);
        
        
        
        return ();

    }


    func __warp_modifier_noDelegateCall_swap_128acb08_72{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_parameter___warp_usrid_131_recipient63 : felt, __warp_parameter___warp_usrid_132_zeroForOne64 : felt, __warp_parameter___warp_usrid_133_amountSpecified65 : Uint256, __warp_parameter___warp_usrid_134_sqrtPriceLimitX9666 : felt, __warp_parameter___warp_usrid_135_data67 : cd_dynarray_felt, __warp_parameter___warp_usrid_136_amount0_m_capture68 : Uint256, __warp_parameter___warp_usrid_137_amount1_m_capture69 : Uint256)-> (__warp_ret_parameter___warp_usrid_136_amount070 : Uint256, __warp_ret_parameter___warp_usrid_137_amount171 : Uint256){
    alloc_locals;


        
        let __warp_ret_parameter___warp_usrid_137_amount171 = Uint256(low=0, high=0);
        
        let __warp_ret_parameter___warp_usrid_136_amount070 = Uint256(low=0, high=0);
        
        checkNotDelegateCall_8233c275();
        
            
            let (__warp_tv_33, __warp_tv_34) = __warp_original_function_swap_128acb08_62(__warp_parameter___warp_usrid_131_recipient63, __warp_parameter___warp_usrid_132_zeroForOne64, __warp_parameter___warp_usrid_133_amountSpecified65, __warp_parameter___warp_usrid_134_sqrtPriceLimitX9666, __warp_parameter___warp_usrid_135_data67, __warp_parameter___warp_usrid_136_amount0_m_capture68, __warp_parameter___warp_usrid_137_amount1_m_capture69);
            
            let __warp_ret_parameter___warp_usrid_137_amount171 = __warp_tv_34;
            
            let __warp_ret_parameter___warp_usrid_136_amount070 = __warp_tv_33;
        
        let __warp_ret_parameter___warp_usrid_136_amount070 = __warp_ret_parameter___warp_usrid_136_amount070;
        
        let __warp_ret_parameter___warp_usrid_137_amount171 = __warp_ret_parameter___warp_usrid_137_amount171;
        
        
        
        return (__warp_ret_parameter___warp_usrid_136_amount070, __warp_ret_parameter___warp_usrid_137_amount171);

    }


    func __warp_conditional___warp_original_function_swap_128acb08_62_15{range_check_ptr : felt, warp_memory : DictAccess*}(__warp_usrid_134_sqrtPriceLimitX96 : felt, __warp_usrid_138_slot0Start : felt)-> (__warp_rc_14 : felt, __warp_usrid_134_sqrtPriceLimitX96 : felt, __warp_usrid_138_slot0Start : felt){
    alloc_locals;


        
        let (__warp_se_280) = WM25_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(__warp_usrid_138_slot0Start);
        
        let (__warp_se_281) = wm_read_felt(__warp_se_280);
        
        let (__warp_se_282) = warp_lt(__warp_usrid_134_sqrtPriceLimitX96, __warp_se_281);
        
        if (__warp_se_282 != 0){
        
            
            let (__warp_se_283) = warp_gt(__warp_usrid_134_sqrtPriceLimitX96, 4295128739);
            
            let __warp_rc_14 = __warp_se_283;
            
            let __warp_rc_14 = __warp_rc_14;
            
            let __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
            
            let __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
            
            
            
            return (__warp_rc_14, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_138_slot0Start);
        }else{
        
            
            let __warp_rc_14 = 0;
            
            let __warp_rc_14 = __warp_rc_14;
            
            let __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
            
            let __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
            
            
            
            return (__warp_rc_14, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_138_slot0Start);
        }

    }


    func __warp_conditional___warp_original_function_swap_128acb08_62_17{range_check_ptr : felt, warp_memory : DictAccess*}(__warp_usrid_134_sqrtPriceLimitX96 : felt, __warp_usrid_138_slot0Start : felt)-> (__warp_rc_16 : felt, __warp_usrid_134_sqrtPriceLimitX96 : felt, __warp_usrid_138_slot0Start : felt){
    alloc_locals;


        
        let (__warp_se_284) = WM25_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(__warp_usrid_138_slot0Start);
        
        let (__warp_se_285) = wm_read_felt(__warp_se_284);
        
        let (__warp_se_286) = warp_gt(__warp_usrid_134_sqrtPriceLimitX96, __warp_se_285);
        
        if (__warp_se_286 != 0){
        
            
            let (__warp_se_287) = warp_lt(__warp_usrid_134_sqrtPriceLimitX96, 1461446703485210103287273052203988822378723970342);
            
            let __warp_rc_16 = __warp_se_287;
            
            let __warp_rc_16 = __warp_rc_16;
            
            let __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
            
            let __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
            
            
            
            return (__warp_rc_16, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_138_slot0Start);
        }else{
        
            
            let __warp_rc_16 = 0;
            
            let __warp_rc_16 = __warp_rc_16;
            
            let __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
            
            let __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
            
            
            
            return (__warp_rc_16, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_138_slot0Start);
        }

    }

    // @inheritdoc IUniswapV3PoolActions
    func __warp_original_function_swap_128acb08_62{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_131_recipient : felt, __warp_usrid_132_zeroForOne : felt, __warp_usrid_133_amountSpecified : Uint256, __warp_usrid_134_sqrtPriceLimitX96 : felt, __warp_usrid_135_data : cd_dynarray_felt, __warp_usrid_136_amount0_m_capture : Uint256, __warp_usrid_137_amount1_m_capture : Uint256)-> (__warp_usrid_136_amount0 : Uint256, __warp_usrid_137_amount1 : Uint256){
    alloc_locals;


        
        let __warp_usrid_136_amount0 = Uint256(low=0, high=0);
        
        let __warp_usrid_137_amount1 = Uint256(low=0, high=0);
        
        let __warp_usrid_137_amount1 = __warp_usrid_137_amount1_m_capture;
        
        let __warp_usrid_136_amount0 = __warp_usrid_136_amount0_m_capture;
        
            
            let (__warp_se_288) = warp_neq256(__warp_usrid_133_amountSpecified, Uint256(low=0, high=0));
            
            with_attr error_message("AS"){
                assert __warp_se_288 = 1;
            }
            
            let (__warp_usrid_138_slot0Start) = ws_to_memory1(__warp_usrid_039_slot0);
            
            let (__warp_se_289) = WM26_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_138_slot0Start);
            
            let (__warp_se_290) = wm_read_felt(__warp_se_289);
            
            with_attr error_message("LOK"){
                assert __warp_se_290 = 1;
            }
            
                
                if (__warp_usrid_132_zeroForOne != 0){
                
                    
                    let __warp_rc_14 = 0;
                    
                        
                        let (__warp_tv_35, __warp_tv_36, __warp_td_16) = __warp_conditional___warp_original_function_swap_128acb08_62_15(__warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_138_slot0Start);
                        
                        let __warp_tv_37 = __warp_td_16;
                        
                        let __warp_usrid_138_slot0Start = __warp_tv_37;
                        
                        let __warp_usrid_134_sqrtPriceLimitX96 = __warp_tv_36;
                        
                        let __warp_rc_14 = __warp_tv_35;
                    
                    with_attr error_message("SPL"){
                        assert __warp_rc_14 = 1;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                    tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                }else{
                
                    
                    let __warp_rc_16 = 0;
                    
                        
                        let (__warp_tv_38, __warp_tv_39, __warp_td_17) = __warp_conditional___warp_original_function_swap_128acb08_62_17(__warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_138_slot0Start);
                        
                        let __warp_tv_40 = __warp_td_17;
                        
                        let __warp_usrid_138_slot0Start = __warp_tv_40;
                        
                        let __warp_usrid_134_sqrtPriceLimitX96 = __warp_tv_39;
                        
                        let __warp_rc_16 = __warp_tv_38;
                    
                    with_attr error_message("SPL"){
                        assert __warp_rc_16 = 1;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                    tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                    tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                    tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                tempvar __warp_usrid_138_slot0Start = __warp_usrid_138_slot0Start;
                tempvar __warp_usrid_134_sqrtPriceLimitX96 = __warp_usrid_134_sqrtPriceLimitX96;
            
            let (__warp_se_291) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
            
            WS_WRITE0(__warp_se_291, 0);
            
            let (__warp_pse_23) = conditional0_148ce0b9(__warp_usrid_132_zeroForOne, __warp_usrid_138_slot0Start);
            
            let (__warp_pse_24) = _blockTimestamp_c63aa3e7();
            
            let (__warp_se_292) = WS0_READ_felt(__warp_usrid_043_liquidity);
            
            let (__warp_usrid_139_cache) = WM1_struct_SwapCache_7600c2b6(__warp_pse_23, __warp_se_292, __warp_pse_24, 0, 0, 0);
            
            let (__warp_usrid_140_exactInput) = warp_gt_signed256(__warp_usrid_133_amountSpecified, Uint256(low=0, high=0));
            
            let (__warp_pse_25) = conditional1_0f286cba(__warp_usrid_132_zeroForOne);
            
            let (__warp_se_293) = WM25_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(__warp_usrid_138_slot0Start);
            
            let (__warp_se_294) = wm_read_felt(__warp_se_293);
            
            let (__warp_se_295) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_138_slot0Start);
            
            let (__warp_se_296) = wm_read_felt(__warp_se_295);
            
            let (__warp_se_297) = WM21_SwapCache_7600c2b6___warp_usrid_014_liquidityStart(__warp_usrid_139_cache);
            
            let (__warp_se_298) = wm_read_felt(__warp_se_297);
            
            let (__warp_usrid_141_state) = WM2_struct_SwapState_eba3c779(__warp_usrid_133_amountSpecified, Uint256(low=0, high=0), __warp_se_294, __warp_se_296, __warp_pse_25, 0, __warp_se_298);
            
                
                let (__warp_td_18, __warp_tv_42, __warp_tv_43, __warp_tv_44, __warp_td_19, __warp_td_20) = __warp_while0(__warp_usrid_141_state, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_132_zeroForOne, __warp_usrid_140_exactInput, __warp_usrid_139_cache, __warp_usrid_138_slot0Start);
                
                let __warp_tv_41 = __warp_td_18;
                
                let __warp_tv_45 = __warp_td_19;
                
                let __warp_tv_46 = __warp_td_20;
                
                let __warp_usrid_138_slot0Start = __warp_tv_46;
                
                let __warp_usrid_139_cache = __warp_tv_45;
                
                let __warp_usrid_140_exactInput = __warp_tv_44;
                
                let __warp_usrid_132_zeroForOne = __warp_tv_43;
                
                let __warp_usrid_134_sqrtPriceLimitX96 = __warp_tv_42;
                
                let __warp_usrid_141_state = __warp_tv_41;
            
            let (__warp_se_299) = WM5_SwapState_eba3c779___warp_usrid_022_tick(__warp_usrid_141_state);
            
            let (__warp_se_300) = wm_read_felt(__warp_se_299);
            
            let (__warp_se_301) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_138_slot0Start);
            
            let (__warp_se_302) = wm_read_felt(__warp_se_301);
            
            let (__warp_se_303) = warp_neq(__warp_se_300, __warp_se_302);
            
                
                if (__warp_se_303 != 0){
                
                    
                    let (__warp_se_304) = WM20_Slot0_930d2817___warp_usrid_002_observationIndex(__warp_usrid_138_slot0Start);
                    
                    let (__warp_se_305) = wm_read_felt(__warp_se_304);
                    
                    let (__warp_se_306) = WM18_SwapCache_7600c2b6___warp_usrid_015_blockTimestamp(__warp_usrid_139_cache);
                    
                    let (__warp_se_307) = wm_read_felt(__warp_se_306);
                    
                    let (__warp_se_308) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_138_slot0Start);
                    
                    let (__warp_se_309) = wm_read_felt(__warp_se_308);
                    
                    let (__warp_se_310) = WM21_SwapCache_7600c2b6___warp_usrid_014_liquidityStart(__warp_usrid_139_cache);
                    
                    let (__warp_se_311) = wm_read_felt(__warp_se_310);
                    
                    let (__warp_se_312) = WM22_Slot0_930d2817___warp_usrid_003_observationCardinality(__warp_usrid_138_slot0Start);
                    
                    let (__warp_se_313) = wm_read_felt(__warp_se_312);
                    
                    let (__warp_se_314) = WM27_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(__warp_usrid_138_slot0Start);
                    
                    let (__warp_se_315) = wm_read_felt(__warp_se_314);
                    
                    let (__warp_usrid_147_observationIndex, __warp_usrid_148_observationCardinality) = write_9b9fd24c(__warp_usrid_047_observations, __warp_se_305, __warp_se_307, __warp_se_309, __warp_se_311, __warp_se_313, __warp_se_315);
                    
                        
                        let (__warp_se_316) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(__warp_usrid_141_state);
                        
                        let (__warp_tv_47) = wm_read_felt(__warp_se_316);
                        
                        let (__warp_se_317) = WM5_SwapState_eba3c779___warp_usrid_022_tick(__warp_usrid_141_state);
                        
                        let (__warp_tv_48) = wm_read_felt(__warp_se_317);
                        
                        let __warp_tv_49 = __warp_usrid_147_observationIndex;
                        
                        let __warp_tv_50 = __warp_usrid_148_observationCardinality;
                        
                        let (__warp_se_318) = WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(__warp_usrid_039_slot0);
                        
                        WS_WRITE0(__warp_se_318, __warp_tv_50);
                        
                        let (__warp_se_319) = WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(__warp_usrid_039_slot0);
                        
                        WS_WRITE0(__warp_se_319, __warp_tv_49);
                        
                        let (__warp_se_320) = WSM7_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_039_slot0);
                        
                        WS_WRITE0(__warp_se_320, __warp_tv_48);
                        
                        let (__warp_se_321) = WSM8_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(__warp_usrid_039_slot0);
                        
                        WS_WRITE0(__warp_se_321, __warp_tv_47);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                    tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                }else{
                
                    
                    let (__warp_se_322) = WSM8_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(__warp_usrid_039_slot0);
                    
                    let (__warp_se_323) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(__warp_usrid_141_state);
                    
                    let (__warp_se_324) = wm_read_felt(__warp_se_323);
                    
                    WS_WRITE0(__warp_se_322, __warp_se_324);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                    tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                    tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                tempvar __warp_usrid_139_cache = __warp_usrid_139_cache;
            
            let (__warp_se_325) = WM21_SwapCache_7600c2b6___warp_usrid_014_liquidityStart(__warp_usrid_139_cache);
            
            let (__warp_se_326) = wm_read_felt(__warp_se_325);
            
            let (__warp_se_327) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(__warp_usrid_141_state);
            
            let (__warp_se_328) = wm_read_felt(__warp_se_327);
            
            let (__warp_se_329) = warp_neq(__warp_se_326, __warp_se_328);
            
                
                if (__warp_se_329 != 0){
                
                    
                    let (__warp_se_330) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(__warp_usrid_141_state);
                    
                    let (__warp_se_331) = wm_read_felt(__warp_se_330);
                    
                    WS_WRITE0(__warp_usrid_043_liquidity, __warp_se_331);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                    tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                    tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
            
                
                if (__warp_usrid_132_zeroForOne != 0){
                
                    
                    let (__warp_se_332) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(__warp_usrid_141_state);
                    
                    let (__warp_se_333) = wm_read_256(__warp_se_332);
                    
                    WS_WRITE1(__warp_usrid_040_feeGrowthGlobal0X128, __warp_se_333);
                    
                    let (__warp_se_334) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(__warp_usrid_141_state);
                    
                    let (__warp_se_335) = wm_read_felt(__warp_se_334);
                    
                    let (__warp_se_336) = warp_gt(__warp_se_335, 0);
                    
                        
                        if (__warp_se_336 != 0){
                        
                            
                            let (__warp_se_337) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(__warp_usrid_042_protocolFees);
                            
                            let (__warp_se_338) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(__warp_usrid_042_protocolFees);
                            
                            let (__warp_se_339) = WS0_READ_felt(__warp_se_338);
                            
                            let (__warp_se_340) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(__warp_usrid_141_state);
                            
                            let (__warp_se_341) = wm_read_felt(__warp_se_340);
                            
                            let (__warp_se_342) = warp_add_unsafe128(__warp_se_339, __warp_se_341);
                            
                            WS_WRITE0(__warp_se_337, __warp_se_342);
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                            tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                            tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                            tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                            tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                            tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                            tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                        tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                        tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                        tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                        tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                        tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                        tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                    tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                }else{
                
                    
                    let (__warp_se_343) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(__warp_usrid_141_state);
                    
                    let (__warp_se_344) = wm_read_256(__warp_se_343);
                    
                    WS_WRITE1(__warp_usrid_041_feeGrowthGlobal1X128, __warp_se_344);
                    
                    let (__warp_se_345) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(__warp_usrid_141_state);
                    
                    let (__warp_se_346) = wm_read_felt(__warp_se_345);
                    
                    let (__warp_se_347) = warp_gt(__warp_se_346, 0);
                    
                        
                        if (__warp_se_347 != 0){
                        
                            
                            let (__warp_se_348) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(__warp_usrid_042_protocolFees);
                            
                            let (__warp_se_349) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(__warp_usrid_042_protocolFees);
                            
                            let (__warp_se_350) = WS0_READ_felt(__warp_se_349);
                            
                            let (__warp_se_351) = WM15_SwapState_eba3c779___warp_usrid_024_protocolFee(__warp_usrid_141_state);
                            
                            let (__warp_se_352) = wm_read_felt(__warp_se_351);
                            
                            let (__warp_se_353) = warp_add_unsafe128(__warp_se_350, __warp_se_352);
                            
                            WS_WRITE0(__warp_se_348, __warp_se_353);
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                            tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                            tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                            tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                            tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                            tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                            tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                            tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                            tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                        tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                        tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                        tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                        tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                        tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                        tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                    tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                    tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                tempvar __warp_usrid_133_amountSpecified = __warp_usrid_133_amountSpecified;
                tempvar __warp_usrid_140_exactInput = __warp_usrid_140_exactInput;
            
                
                let (__warp_se_354) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(__warp_usrid_141_state);
                
                let (__warp_tv_51) = wm_read_256(__warp_se_354);
                
                let (__warp_se_355) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(__warp_usrid_141_state);
                
                let (__warp_se_356) = wm_read_256(__warp_se_355);
                
                let (__warp_tv_52) = warp_sub_signed_unsafe256(__warp_usrid_133_amountSpecified, __warp_se_356);
                
                let __warp_usrid_137_amount1 = __warp_tv_52;
                
                let __warp_usrid_136_amount0 = __warp_tv_51;
            
            let (__warp_se_357) = warp_eq(__warp_usrid_132_zeroForOne, __warp_usrid_140_exactInput);
            
                
                if (__warp_se_357 != 0){
                
                    
                        
                        let (__warp_se_358) = WM2_SwapState_eba3c779___warp_usrid_019_amountSpecifiedRemaining(__warp_usrid_141_state);
                        
                        let (__warp_se_359) = wm_read_256(__warp_se_358);
                        
                        let (__warp_tv_53) = warp_sub_signed_unsafe256(__warp_usrid_133_amountSpecified, __warp_se_359);
                        
                        let (__warp_se_360) = WM13_SwapState_eba3c779___warp_usrid_020_amountCalculated(__warp_usrid_141_state);
                        
                        let (__warp_tv_54) = wm_read_256(__warp_se_360);
                        
                        let __warp_usrid_137_amount1 = __warp_tv_54;
                        
                        let __warp_usrid_136_amount0 = __warp_tv_53;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                    tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                    tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                tempvar __warp_usrid_132_zeroForOne = __warp_usrid_132_zeroForOne;
                tempvar __warp_usrid_135_data = __warp_usrid_135_data;
            
                
                if (__warp_usrid_132_zeroForOne != 0){
                
                    
                    let (__warp_se_361) = warp_lt_signed256(__warp_usrid_137_amount1, Uint256(low=0, high=0));
                    
                        
                        if (__warp_se_361 != 0){
                        
                            
                            let (__warp_se_362) = WS0_READ_felt(__warp_usrid_035_token1);
                            
                            let (__warp_se_363) = warp_negate256(__warp_usrid_137_amount1);
                            
                            safeTransfer_d1660f99(__warp_se_362, __warp_usrid_131_recipient, __warp_se_363);
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                            tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                            tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                            tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                            tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                        tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                        tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                        tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                    
                    let (__warp_usrid_149_balance0Before) = balance0_1c69ad00();
                    
                    let (__warp_se_364) = get_caller_address();
                    
                    IUniswapV3SwapCallback_warped_interface.uniswapV3SwapCallback_fa461e33(__warp_se_364, __warp_usrid_136_amount0, __warp_usrid_137_amount1, __warp_usrid_135_data.len, __warp_usrid_135_data.ptr);
                    
                    let (__warp_pse_26) = add_771602f7(__warp_usrid_149_balance0Before, __warp_usrid_136_amount0);
                    
                    let (__warp_pse_27) = balance0_1c69ad00();
                    
                    let (__warp_se_365) = warp_le256(__warp_pse_26, __warp_pse_27);
                    
                    with_attr error_message("IIA"){
                        assert __warp_se_365 = 1;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                }else{
                
                    
                    let (__warp_se_366) = warp_lt_signed256(__warp_usrid_136_amount0, Uint256(low=0, high=0));
                    
                        
                        if (__warp_se_366 != 0){
                        
                            
                            let (__warp_se_367) = WS0_READ_felt(__warp_usrid_034_token0);
                            
                            let (__warp_se_368) = warp_negate256(__warp_usrid_136_amount0);
                            
                            safeTransfer_d1660f99(__warp_se_367, __warp_usrid_131_recipient, __warp_se_368);
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                            tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                            tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                        }else{
                        
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                            tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                            tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                            tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                            tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                        tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                        tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                        tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                        tempvar __warp_usrid_135_data = __warp_usrid_135_data;
                    
                    let (__warp_usrid_150_balance1Before) = balance1_c45c4f58();
                    
                    let (__warp_se_369) = get_caller_address();
                    
                    IUniswapV3SwapCallback_warped_interface.uniswapV3SwapCallback_fa461e33(__warp_se_369, __warp_usrid_136_amount0, __warp_usrid_137_amount1, __warp_usrid_135_data.len, __warp_usrid_135_data.ptr);
                    
                    let (__warp_pse_28) = add_771602f7(__warp_usrid_150_balance1Before, __warp_usrid_137_amount1);
                    
                    let (__warp_pse_29) = balance1_c45c4f58();
                    
                    let (__warp_se_370) = warp_le256(__warp_pse_28, __warp_pse_29);
                    
                    with_attr error_message("IIA"){
                        assert __warp_se_370 = 1;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                    tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                    tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                    tempvar __warp_usrid_141_state = __warp_usrid_141_state;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
                tempvar __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
                tempvar __warp_usrid_131_recipient = __warp_usrid_131_recipient;
                tempvar __warp_usrid_141_state = __warp_usrid_141_state;
            
            let (__warp_se_371) = get_caller_address();
            
            let (__warp_se_372) = WM3_SwapState_eba3c779___warp_usrid_021_sqrtPriceX96(__warp_usrid_141_state);
            
            let (__warp_se_373) = wm_read_felt(__warp_se_372);
            
            let (__warp_se_374) = WM9_SwapState_eba3c779___warp_usrid_025_liquidity(__warp_usrid_141_state);
            
            let (__warp_se_375) = wm_read_felt(__warp_se_374);
            
            let (__warp_se_376) = WM5_SwapState_eba3c779___warp_usrid_022_tick(__warp_usrid_141_state);
            
            let (__warp_se_377) = wm_read_felt(__warp_se_376);
            
            Swap_c42079f9.emit(__warp_se_371, __warp_usrid_131_recipient, __warp_usrid_136_amount0, __warp_usrid_137_amount1, __warp_se_373, __warp_se_375, __warp_se_377);
            
            let (__warp_se_378) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
            
            WS_WRITE0(__warp_se_378, 1);
        
        let __warp_usrid_136_amount0 = __warp_usrid_136_amount0;
        
        let __warp_usrid_137_amount1 = __warp_usrid_137_amount1;
        
        
        
        return (__warp_usrid_136_amount0, __warp_usrid_137_amount1);

    }


    func __warp_modifier_lock_burn_a34123a7_61{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_parameter___warp_usrid_123_tickLower54 : felt, __warp_parameter___warp_usrid_124_tickUpper55 : felt, __warp_parameter___warp_usrid_125_amount56 : felt, __warp_parameter___warp_usrid_126_amount0_m_capture57 : Uint256, __warp_parameter___warp_usrid_127_amount1_m_capture58 : Uint256)-> (__warp_ret_parameter___warp_usrid_126_amount059 : Uint256, __warp_ret_parameter___warp_usrid_127_amount160 : Uint256){
    alloc_locals;


        
        let __warp_ret_parameter___warp_usrid_127_amount160 = Uint256(low=0, high=0);
        
        let __warp_ret_parameter___warp_usrid_126_amount059 = Uint256(low=0, high=0);
        
        let (__warp_se_379) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        let (__warp_se_380) = WS0_READ_felt(__warp_se_379);
        
        with_attr error_message("LOK"){
            assert __warp_se_380 = 1;
        }
        
        let (__warp_se_381) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_381, 0);
        
            
            let (__warp_tv_55, __warp_tv_56) = __warp_original_function_burn_a34123a7_53(__warp_parameter___warp_usrid_123_tickLower54, __warp_parameter___warp_usrid_124_tickUpper55, __warp_parameter___warp_usrid_125_amount56, __warp_parameter___warp_usrid_126_amount0_m_capture57, __warp_parameter___warp_usrid_127_amount1_m_capture58);
            
            let __warp_ret_parameter___warp_usrid_127_amount160 = __warp_tv_56;
            
            let __warp_ret_parameter___warp_usrid_126_amount059 = __warp_tv_55;
        
        let (__warp_se_382) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_382, 1);
        
        let __warp_ret_parameter___warp_usrid_126_amount059 = __warp_ret_parameter___warp_usrid_126_amount059;
        
        let __warp_ret_parameter___warp_usrid_127_amount160 = __warp_ret_parameter___warp_usrid_127_amount160;
        
        
        
        return (__warp_ret_parameter___warp_usrid_126_amount059, __warp_ret_parameter___warp_usrid_127_amount160);

    }


    func __warp_conditional___warp_original_function_burn_a34123a7_53_19{range_check_ptr : felt}(__warp_usrid_126_amount0 : Uint256, __warp_usrid_127_amount1 : Uint256)-> (__warp_rc_18 : felt, __warp_usrid_126_amount0 : Uint256, __warp_usrid_127_amount1 : Uint256){
    alloc_locals;


        
        let (__warp_se_383) = warp_gt256(__warp_usrid_126_amount0, Uint256(low=0, high=0));
        
        if (__warp_se_383 != 0){
        
            
            let __warp_rc_18 = 1;
            
            let __warp_rc_18 = __warp_rc_18;
            
            let __warp_usrid_126_amount0 = __warp_usrid_126_amount0;
            
            let __warp_usrid_127_amount1 = __warp_usrid_127_amount1;
            
            
            
            return (__warp_rc_18, __warp_usrid_126_amount0, __warp_usrid_127_amount1);
        }else{
        
            
            let (__warp_se_384) = warp_gt256(__warp_usrid_127_amount1, Uint256(low=0, high=0));
            
            let __warp_rc_18 = __warp_se_384;
            
            let __warp_rc_18 = __warp_rc_18;
            
            let __warp_usrid_126_amount0 = __warp_usrid_126_amount0;
            
            let __warp_usrid_127_amount1 = __warp_usrid_127_amount1;
            
            
            
            return (__warp_rc_18, __warp_usrid_126_amount0, __warp_usrid_127_amount1);
        }

    }

    // @inheritdoc IUniswapV3PoolActions
    // @dev noDelegateCall is applied indirectly via _modifyPosition
    func __warp_original_function_burn_a34123a7_53{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_usrid_123_tickLower : felt, __warp_usrid_124_tickUpper : felt, __warp_usrid_125_amount : felt, __warp_usrid_126_amount0_m_capture : Uint256, __warp_usrid_127_amount1_m_capture : Uint256)-> (__warp_usrid_126_amount0 : Uint256, __warp_usrid_127_amount1 : Uint256){
    alloc_locals;


        
        let __warp_usrid_126_amount0 = Uint256(low=0, high=0);
        
        let __warp_usrid_127_amount1 = Uint256(low=0, high=0);
        
        let __warp_usrid_127_amount1 = __warp_usrid_127_amount1_m_capture;
        
        let __warp_usrid_126_amount0 = __warp_usrid_126_amount0_m_capture;
        
            
            let (__warp_se_385) = warp_uint256(__warp_usrid_125_amount);
            
            let (__warp_pse_30) = toInt128_dd2a0316(__warp_se_385);
            
            let (__warp_se_386) = get_caller_address();
            
            let (__warp_se_387) = warp_negate128(__warp_pse_30);
            
            let (__warp_se_388) = WM3_struct_ModifyPositionParams_82bf7b1b(__warp_se_386, __warp_usrid_123_tickLower, __warp_usrid_124_tickUpper, __warp_se_387);
            
            let (__warp_td_21, __warp_usrid_129_amount0Int, __warp_usrid_130_amount1Int) = _modifyPosition_c6bd2490(__warp_se_388);
            
            let __warp_usrid_128_position = __warp_td_21;
            
            let (__warp_se_389) = warp_negate256(__warp_usrid_129_amount0Int);
            
            let __warp_usrid_126_amount0 = __warp_se_389;
            
            let (__warp_se_390) = warp_negate256(__warp_usrid_130_amount1Int);
            
            let __warp_usrid_127_amount1 = __warp_se_390;
            
            let __warp_rc_18 = 0;
            
                
                let (__warp_tv_57, __warp_tv_58, __warp_tv_59) = __warp_conditional___warp_original_function_burn_a34123a7_53_19(__warp_usrid_126_amount0, __warp_usrid_127_amount1);
                
                let __warp_usrid_127_amount1 = __warp_tv_59;
                
                let __warp_usrid_126_amount0 = __warp_tv_58;
                
                let __warp_rc_18 = __warp_tv_57;
            
                
                if (__warp_rc_18 != 0){
                
                    
                        
                        let (__warp_se_391) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(__warp_usrid_128_position);
                        
                        let (__warp_se_392) = WS0_READ_felt(__warp_se_391);
                        
                        let (__warp_se_393) = warp_int256_to_int128(__warp_usrid_126_amount0);
                        
                        let (__warp_tv_60) = warp_add_unsafe128(__warp_se_392, __warp_se_393);
                        
                        let (__warp_se_394) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(__warp_usrid_128_position);
                        
                        let (__warp_se_395) = WS0_READ_felt(__warp_se_394);
                        
                        let (__warp_se_396) = warp_int256_to_int128(__warp_usrid_127_amount1);
                        
                        let (__warp_tv_61) = warp_add_unsafe128(__warp_se_395, __warp_se_396);
                        
                        let (__warp_se_397) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(__warp_usrid_128_position);
                        
                        WS_WRITE0(__warp_se_397, __warp_tv_61);
                        
                        let (__warp_se_398) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(__warp_usrid_128_position);
                        
                        WS_WRITE0(__warp_se_398, __warp_tv_60);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar __warp_usrid_127_amount1 = __warp_usrid_127_amount1;
                    tempvar __warp_usrid_126_amount0 = __warp_usrid_126_amount0;
                    tempvar __warp_usrid_123_tickLower = __warp_usrid_123_tickLower;
                    tempvar __warp_usrid_124_tickUpper = __warp_usrid_124_tickUpper;
                    tempvar __warp_usrid_125_amount = __warp_usrid_125_amount;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar __warp_usrid_127_amount1 = __warp_usrid_127_amount1;
                    tempvar __warp_usrid_126_amount0 = __warp_usrid_126_amount0;
                    tempvar __warp_usrid_123_tickLower = __warp_usrid_123_tickLower;
                    tempvar __warp_usrid_124_tickUpper = __warp_usrid_124_tickUpper;
                    tempvar __warp_usrid_125_amount = __warp_usrid_125_amount;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar warp_memory = warp_memory;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_127_amount1 = __warp_usrid_127_amount1;
                tempvar __warp_usrid_126_amount0 = __warp_usrid_126_amount0;
                tempvar __warp_usrid_123_tickLower = __warp_usrid_123_tickLower;
                tempvar __warp_usrid_124_tickUpper = __warp_usrid_124_tickUpper;
                tempvar __warp_usrid_125_amount = __warp_usrid_125_amount;
            
            let (__warp_se_399) = get_caller_address();
            
            Burn_0c396cd9.emit(__warp_se_399, __warp_usrid_123_tickLower, __warp_usrid_124_tickUpper, __warp_usrid_125_amount, __warp_usrid_126_amount0, __warp_usrid_127_amount1);
        
        let __warp_usrid_126_amount0 = __warp_usrid_126_amount0;
        
        let __warp_usrid_127_amount1 = __warp_usrid_127_amount1;
        
        
        
        return (__warp_usrid_126_amount0, __warp_usrid_127_amount1);

    }


    func __warp_modifier_lock_collect_4f1eb3d8_52{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_parameter___warp_usrid_115_recipient43 : felt, __warp_parameter___warp_usrid_116_tickLower44 : felt, __warp_parameter___warp_usrid_117_tickUpper45 : felt, __warp_parameter___warp_usrid_118_amount0Requested46 : felt, __warp_parameter___warp_usrid_119_amount1Requested47 : felt, __warp_parameter___warp_usrid_120_amount0_m_capture48 : felt, __warp_parameter___warp_usrid_121_amount1_m_capture49 : felt)-> (__warp_ret_parameter___warp_usrid_120_amount050 : felt, __warp_ret_parameter___warp_usrid_121_amount151 : felt){
    alloc_locals;


        
        let __warp_ret_parameter___warp_usrid_121_amount151 = 0;
        
        let __warp_ret_parameter___warp_usrid_120_amount050 = 0;
        
        let (__warp_se_400) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        let (__warp_se_401) = WS0_READ_felt(__warp_se_400);
        
        with_attr error_message("LOK"){
            assert __warp_se_401 = 1;
        }
        
        let (__warp_se_402) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_402, 0);
        
            
            let (__warp_tv_62, __warp_tv_63) = __warp_original_function_collect_4f1eb3d8_42(__warp_parameter___warp_usrid_115_recipient43, __warp_parameter___warp_usrid_116_tickLower44, __warp_parameter___warp_usrid_117_tickUpper45, __warp_parameter___warp_usrid_118_amount0Requested46, __warp_parameter___warp_usrid_119_amount1Requested47, __warp_parameter___warp_usrid_120_amount0_m_capture48, __warp_parameter___warp_usrid_121_amount1_m_capture49);
            
            let __warp_ret_parameter___warp_usrid_121_amount151 = __warp_tv_63;
            
            let __warp_ret_parameter___warp_usrid_120_amount050 = __warp_tv_62;
        
        let (__warp_se_403) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_403, 1);
        
        let __warp_ret_parameter___warp_usrid_120_amount050 = __warp_ret_parameter___warp_usrid_120_amount050;
        
        let __warp_ret_parameter___warp_usrid_121_amount151 = __warp_ret_parameter___warp_usrid_121_amount151;
        
        
        
        return (__warp_ret_parameter___warp_usrid_120_amount050, __warp_ret_parameter___warp_usrid_121_amount151);

    }

    // @inheritdoc IUniswapV3PoolActions
    func __warp_original_function_collect_4f1eb3d8_42{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_usrid_115_recipient : felt, __warp_usrid_116_tickLower : felt, __warp_usrid_117_tickUpper : felt, __warp_usrid_118_amount0Requested : felt, __warp_usrid_119_amount1Requested : felt, __warp_usrid_120_amount0_m_capture : felt, __warp_usrid_121_amount1_m_capture : felt)-> (__warp_usrid_120_amount0 : felt, __warp_usrid_121_amount1 : felt){
    alloc_locals;


        
        let __warp_usrid_120_amount0 = 0;
        
        let __warp_usrid_121_amount1 = 0;
        
        let __warp_usrid_121_amount1 = __warp_usrid_121_amount1_m_capture;
        
        let __warp_usrid_120_amount0 = __warp_usrid_120_amount0_m_capture;
        
            
            let (__warp_se_404) = get_caller_address();
            
            let (__warp_usrid_122_position) = get_a4d6(__warp_usrid_046_positions, __warp_se_404, __warp_usrid_116_tickLower, __warp_usrid_117_tickUpper);
            
            let (__warp_se_405) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(__warp_usrid_122_position);
            
            let (__warp_se_406) = WS0_READ_felt(__warp_se_405);
            
            let (__warp_se_407) = warp_gt(__warp_usrid_118_amount0Requested, __warp_se_406);
            
                
                if (__warp_se_407 != 0){
                
                    
                    let (__warp_se_408) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(__warp_usrid_122_position);
                    
                    let (__warp_se_409) = WS0_READ_felt(__warp_se_408);
                    
                    let __warp_usrid_120_amount0 = __warp_se_409;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                    tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                    tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                    tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                    tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                    tempvar __warp_usrid_122_position = __warp_usrid_122_position;
                    tempvar __warp_usrid_119_amount1Requested = __warp_usrid_119_amount1Requested;
                }else{
                
                    
                    let __warp_usrid_120_amount0 = __warp_usrid_118_amount0Requested;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                    tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                    tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                    tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                    tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                    tempvar __warp_usrid_122_position = __warp_usrid_122_position;
                    tempvar __warp_usrid_119_amount1Requested = __warp_usrid_119_amount1Requested;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar keccak_ptr = keccak_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                tempvar __warp_usrid_122_position = __warp_usrid_122_position;
                tempvar __warp_usrid_119_amount1Requested = __warp_usrid_119_amount1Requested;
            
            let (__warp_se_410) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(__warp_usrid_122_position);
            
            let (__warp_se_411) = WS0_READ_felt(__warp_se_410);
            
            let (__warp_se_412) = warp_gt(__warp_usrid_119_amount1Requested, __warp_se_411);
            
                
                if (__warp_se_412 != 0){
                
                    
                    let (__warp_se_413) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(__warp_usrid_122_position);
                    
                    let (__warp_se_414) = WS0_READ_felt(__warp_se_413);
                    
                    let __warp_usrid_121_amount1 = __warp_se_414;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                    tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                    tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                    tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                    tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                    tempvar __warp_usrid_122_position = __warp_usrid_122_position;
                }else{
                
                    
                    let __warp_usrid_121_amount1 = __warp_usrid_119_amount1Requested;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                    tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                    tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                    tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                    tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                    tempvar __warp_usrid_122_position = __warp_usrid_122_position;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar keccak_ptr = keccak_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                tempvar __warp_usrid_122_position = __warp_usrid_122_position;
            
            let (__warp_se_415) = warp_gt(__warp_usrid_120_amount0, 0);
            
                
                if (__warp_se_415 != 0){
                
                    
                    let (__warp_se_416) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(__warp_usrid_122_position);
                    
                    let (__warp_se_417) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(__warp_usrid_122_position);
                    
                    let (__warp_se_418) = WS0_READ_felt(__warp_se_417);
                    
                    let (__warp_se_419) = warp_sub_unsafe128(__warp_se_418, __warp_usrid_120_amount0);
                    
                    WS_WRITE0(__warp_se_416, __warp_se_419);
                    
                    let (__warp_se_420) = WS0_READ_felt(__warp_usrid_034_token0);
                    
                    let (__warp_se_421) = warp_uint256(__warp_usrid_120_amount0);
                    
                    safeTransfer_d1660f99(__warp_se_420, __warp_usrid_115_recipient, __warp_se_421);
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                    tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                    tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                    tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                    tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                    tempvar __warp_usrid_122_position = __warp_usrid_122_position;
                }else{
                
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                    tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                    tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                    tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                    tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                    tempvar __warp_usrid_122_position = __warp_usrid_122_position;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar keccak_ptr = keccak_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                tempvar __warp_usrid_122_position = __warp_usrid_122_position;
            
            let (__warp_se_422) = warp_gt(__warp_usrid_121_amount1, 0);
            
                
                if (__warp_se_422 != 0){
                
                    
                    let (__warp_se_423) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(__warp_usrid_122_position);
                    
                    let (__warp_se_424) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(__warp_usrid_122_position);
                    
                    let (__warp_se_425) = WS0_READ_felt(__warp_se_424);
                    
                    let (__warp_se_426) = warp_sub_unsafe128(__warp_se_425, __warp_usrid_121_amount1);
                    
                    WS_WRITE0(__warp_se_423, __warp_se_426);
                    
                    let (__warp_se_427) = WS0_READ_felt(__warp_usrid_035_token1);
                    
                    let (__warp_se_428) = warp_uint256(__warp_usrid_121_amount1);
                    
                    safeTransfer_d1660f99(__warp_se_427, __warp_usrid_115_recipient, __warp_se_428);
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                    tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                    tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                    tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                    tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                }else{
                
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                    tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                    tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                    tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                    tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar keccak_ptr = keccak_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
                tempvar __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
                tempvar __warp_usrid_115_recipient = __warp_usrid_115_recipient;
                tempvar __warp_usrid_116_tickLower = __warp_usrid_116_tickLower;
                tempvar __warp_usrid_117_tickUpper = __warp_usrid_117_tickUpper;
            
            let (__warp_se_429) = get_caller_address();
            
            Collect_70935338.emit(__warp_se_429, __warp_usrid_115_recipient, __warp_usrid_116_tickLower, __warp_usrid_117_tickUpper, __warp_usrid_120_amount0, __warp_usrid_121_amount1);
        
        let __warp_usrid_120_amount0 = __warp_usrid_120_amount0;
        
        let __warp_usrid_121_amount1 = __warp_usrid_121_amount1;
        
        
        
        return (__warp_usrid_120_amount0, __warp_usrid_121_amount1);

    }


    func __warp_modifier_lock_mint_3c8a7d8d_41{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_parameter___warp_usrid_104_recipient32 : felt, __warp_parameter___warp_usrid_105_tickLower33 : felt, __warp_parameter___warp_usrid_106_tickUpper34 : felt, __warp_parameter___warp_usrid_107_amount35 : felt, __warp_parameter___warp_usrid_108_data36 : cd_dynarray_felt, __warp_parameter___warp_usrid_109_amount0_m_capture37 : Uint256, __warp_parameter___warp_usrid_110_amount1_m_capture38 : Uint256)-> (__warp_ret_parameter___warp_usrid_109_amount039 : Uint256, __warp_ret_parameter___warp_usrid_110_amount140 : Uint256){
    alloc_locals;


        
        let __warp_ret_parameter___warp_usrid_110_amount140 = Uint256(low=0, high=0);
        
        let __warp_ret_parameter___warp_usrid_109_amount039 = Uint256(low=0, high=0);
        
        let (__warp_se_430) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        let (__warp_se_431) = WS0_READ_felt(__warp_se_430);
        
        with_attr error_message("LOK"){
            assert __warp_se_431 = 1;
        }
        
        let (__warp_se_432) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_432, 0);
        
            
            let (__warp_tv_64, __warp_tv_65) = __warp_original_function_mint_3c8a7d8d_31(__warp_parameter___warp_usrid_104_recipient32, __warp_parameter___warp_usrid_105_tickLower33, __warp_parameter___warp_usrid_106_tickUpper34, __warp_parameter___warp_usrid_107_amount35, __warp_parameter___warp_usrid_108_data36, __warp_parameter___warp_usrid_109_amount0_m_capture37, __warp_parameter___warp_usrid_110_amount1_m_capture38);
            
            let __warp_ret_parameter___warp_usrid_110_amount140 = __warp_tv_65;
            
            let __warp_ret_parameter___warp_usrid_109_amount039 = __warp_tv_64;
        
        let (__warp_se_433) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_433, 1);
        
        let __warp_ret_parameter___warp_usrid_109_amount039 = __warp_ret_parameter___warp_usrid_109_amount039;
        
        let __warp_ret_parameter___warp_usrid_110_amount140 = __warp_ret_parameter___warp_usrid_110_amount140;
        
        
        
        return (__warp_ret_parameter___warp_usrid_109_amount039, __warp_ret_parameter___warp_usrid_110_amount140);

    }

    // @inheritdoc IUniswapV3PoolActions
    // @dev noDelegateCall is applied indirectly via _modifyPosition
    func __warp_original_function_mint_3c8a7d8d_31{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_usrid_104_recipient : felt, __warp_usrid_105_tickLower : felt, __warp_usrid_106_tickUpper : felt, __warp_usrid_107_amount : felt, __warp_usrid_108_data : cd_dynarray_felt, __warp_usrid_109_amount0_m_capture : Uint256, __warp_usrid_110_amount1_m_capture : Uint256)-> (__warp_usrid_109_amount0 : Uint256, __warp_usrid_110_amount1 : Uint256){
    alloc_locals;


        
        let __warp_usrid_109_amount0 = Uint256(low=0, high=0);
        
        let __warp_usrid_110_amount1 = Uint256(low=0, high=0);
        
        let __warp_usrid_110_amount1 = __warp_usrid_110_amount1_m_capture;
        
        let __warp_usrid_109_amount0 = __warp_usrid_109_amount0_m_capture;
        
        let (__warp_se_434) = warp_gt(__warp_usrid_107_amount, 0);
        
        assert __warp_se_434 = 1;
        
        let (__warp_se_435) = warp_uint256(__warp_usrid_107_amount);
        
        let (__warp_pse_31) = toInt128_dd2a0316(__warp_se_435);
        
        let (__warp_se_436) = WM3_struct_ModifyPositionParams_82bf7b1b(__warp_usrid_104_recipient, __warp_usrid_105_tickLower, __warp_usrid_106_tickUpper, __warp_pse_31);
        
        let (__warp_gv0, __warp_usrid_111_amount0Int, __warp_usrid_112_amount1Int) = _modifyPosition_c6bd2490(__warp_se_436);
        
        let __warp_usrid_109_amount0 = __warp_usrid_111_amount0Int;
        
        let __warp_usrid_110_amount1 = __warp_usrid_112_amount1Int;
        
        let __warp_usrid_113_balance0Before = Uint256(low=0, high=0);
        
        let __warp_usrid_114_balance1Before = Uint256(low=0, high=0);
        
        let (__warp_se_437) = warp_gt256(__warp_usrid_109_amount0, Uint256(low=0, high=0));
        
            
            if (__warp_se_437 != 0){
            
                
                let (__warp_pse_32) = balance0_1c69ad00();
                
                let __warp_usrid_113_balance0Before = __warp_pse_32;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
                tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
                tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
                tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
                tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
                tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
                tempvar __warp_usrid_114_balance1Before = __warp_usrid_114_balance1Before;
                tempvar __warp_usrid_113_balance0Before = __warp_usrid_113_balance0Before;
                tempvar __warp_usrid_108_data = __warp_usrid_108_data;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
                tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
                tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
                tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
                tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
                tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
                tempvar __warp_usrid_114_balance1Before = __warp_usrid_114_balance1Before;
                tempvar __warp_usrid_113_balance0Before = __warp_usrid_113_balance0Before;
                tempvar __warp_usrid_108_data = __warp_usrid_108_data;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar warp_memory = warp_memory;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar keccak_ptr = keccak_ptr;
            tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
            tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
            tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
            tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
            tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
            tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
            tempvar __warp_usrid_114_balance1Before = __warp_usrid_114_balance1Before;
            tempvar __warp_usrid_113_balance0Before = __warp_usrid_113_balance0Before;
            tempvar __warp_usrid_108_data = __warp_usrid_108_data;
        
        let (__warp_se_438) = warp_gt256(__warp_usrid_110_amount1, Uint256(low=0, high=0));
        
            
            if (__warp_se_438 != 0){
            
                
                let (__warp_pse_33) = balance1_c45c4f58();
                
                let __warp_usrid_114_balance1Before = __warp_pse_33;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
                tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
                tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
                tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
                tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
                tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
                tempvar __warp_usrid_114_balance1Before = __warp_usrid_114_balance1Before;
                tempvar __warp_usrid_113_balance0Before = __warp_usrid_113_balance0Before;
                tempvar __warp_usrid_108_data = __warp_usrid_108_data;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
                tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
                tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
                tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
                tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
                tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
                tempvar __warp_usrid_114_balance1Before = __warp_usrid_114_balance1Before;
                tempvar __warp_usrid_113_balance0Before = __warp_usrid_113_balance0Before;
                tempvar __warp_usrid_108_data = __warp_usrid_108_data;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar warp_memory = warp_memory;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar keccak_ptr = keccak_ptr;
            tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
            tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
            tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
            tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
            tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
            tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
            tempvar __warp_usrid_114_balance1Before = __warp_usrid_114_balance1Before;
            tempvar __warp_usrid_113_balance0Before = __warp_usrid_113_balance0Before;
            tempvar __warp_usrid_108_data = __warp_usrid_108_data;
        
        let (__warp_se_439) = get_caller_address();
        
        IUniswapV3MintCallback_warped_interface.uniswapV3MintCallback_d3487997(__warp_se_439, __warp_usrid_109_amount0, __warp_usrid_110_amount1, __warp_usrid_108_data.len, __warp_usrid_108_data.ptr);
        
        let (__warp_se_440) = warp_gt256(__warp_usrid_109_amount0, Uint256(low=0, high=0));
        
            
            if (__warp_se_440 != 0){
            
                
                let (__warp_pse_34) = add_771602f7(__warp_usrid_113_balance0Before, __warp_usrid_109_amount0);
                
                let (__warp_pse_35) = balance0_1c69ad00();
                
                let (__warp_se_441) = warp_le256(__warp_pse_34, __warp_pse_35);
                
                with_attr error_message("M0"){
                    assert __warp_se_441 = 1;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
                tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
                tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
                tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
                tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
                tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
                tempvar __warp_usrid_114_balance1Before = __warp_usrid_114_balance1Before;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
                tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
                tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
                tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
                tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
                tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
                tempvar __warp_usrid_114_balance1Before = __warp_usrid_114_balance1Before;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar warp_memory = warp_memory;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar keccak_ptr = keccak_ptr;
            tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
            tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
            tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
            tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
            tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
            tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
            tempvar __warp_usrid_114_balance1Before = __warp_usrid_114_balance1Before;
        
        let (__warp_se_442) = warp_gt256(__warp_usrid_110_amount1, Uint256(low=0, high=0));
        
            
            if (__warp_se_442 != 0){
            
                
                let (__warp_pse_36) = add_771602f7(__warp_usrid_114_balance1Before, __warp_usrid_110_amount1);
                
                let (__warp_pse_37) = balance1_c45c4f58();
                
                let (__warp_se_443) = warp_le256(__warp_pse_36, __warp_pse_37);
                
                with_attr error_message("M1"){
                    assert __warp_se_443 = 1;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
                tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
                tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
                tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
                tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
                tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar warp_memory = warp_memory;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
                tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
                tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
                tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
                tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
                tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar warp_memory = warp_memory;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar keccak_ptr = keccak_ptr;
            tempvar __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
            tempvar __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
            tempvar __warp_usrid_104_recipient = __warp_usrid_104_recipient;
            tempvar __warp_usrid_105_tickLower = __warp_usrid_105_tickLower;
            tempvar __warp_usrid_106_tickUpper = __warp_usrid_106_tickUpper;
            tempvar __warp_usrid_107_amount = __warp_usrid_107_amount;
        
        let (__warp_se_444) = get_caller_address();
        
        Mint_7a53080b.emit(__warp_se_444, __warp_usrid_104_recipient, __warp_usrid_105_tickLower, __warp_usrid_106_tickUpper, __warp_usrid_107_amount, __warp_usrid_109_amount0, __warp_usrid_110_amount1);
        
        let __warp_usrid_109_amount0 = __warp_usrid_109_amount0;
        
        let __warp_usrid_110_amount1 = __warp_usrid_110_amount1;
        
        
        
        return (__warp_usrid_109_amount0, __warp_usrid_110_amount1);

    }


    func __warp_modifier_noDelegateCall__modifyPosition_c6bd2490_30{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_parameter___warp_usrid_083_params23 : felt, __warp_parameter___warp_usrid_084_position_m_capture24 : felt, __warp_parameter___warp_usrid_085_amount0_m_capture25 : Uint256, __warp_parameter___warp_usrid_086_amount1_m_capture26 : Uint256)-> (__warp_ret_parameter___warp_usrid_084_position27 : felt, __warp_ret_parameter___warp_usrid_085_amount028 : Uint256, __warp_ret_parameter___warp_usrid_086_amount129 : Uint256){
    alloc_locals;


        
        let __warp_ret_parameter___warp_usrid_086_amount129 = Uint256(low=0, high=0);
        
        let __warp_ret_parameter___warp_usrid_085_amount028 = Uint256(low=0, high=0);
        
        let __warp_ret_parameter___warp_usrid_084_position27 = 0;
        
        checkNotDelegateCall_8233c275();
        
            
            let (__warp_td_22, __warp_tv_67, __warp_tv_68) = __warp_original_function__modifyPosition_c6bd2490_22(__warp_parameter___warp_usrid_083_params23, __warp_parameter___warp_usrid_084_position_m_capture24, __warp_parameter___warp_usrid_085_amount0_m_capture25, __warp_parameter___warp_usrid_086_amount1_m_capture26);
            
            let __warp_tv_66 = __warp_td_22;
            
            let __warp_ret_parameter___warp_usrid_086_amount129 = __warp_tv_68;
            
            let __warp_ret_parameter___warp_usrid_085_amount028 = __warp_tv_67;
            
            let __warp_ret_parameter___warp_usrid_084_position27 = __warp_tv_66;
        
        let __warp_ret_parameter___warp_usrid_084_position27 = __warp_ret_parameter___warp_usrid_084_position27;
        
        let __warp_ret_parameter___warp_usrid_085_amount028 = __warp_ret_parameter___warp_usrid_085_amount028;
        
        let __warp_ret_parameter___warp_usrid_086_amount129 = __warp_ret_parameter___warp_usrid_086_amount129;
        
        
        
        return (__warp_ret_parameter___warp_usrid_084_position27, __warp_ret_parameter___warp_usrid_085_amount028, __warp_ret_parameter___warp_usrid_086_amount129);

    }

    // @dev Effect some changes to a position
    // @param params the position details and the change to the position's liquidity to effect
    // @return position a storage pointer referencing the position with the given owner and tick range
    // @return amount0 the amount of token0 owed to the pool, negative if the pool should pay the recipient
    // @return amount1 the amount of token1 owed to the pool, negative if the pool should pay the recipient
    func __warp_original_function__modifyPosition_c6bd2490_22{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_usrid_083_params : felt, __warp_usrid_084_position_m_capture : felt, __warp_usrid_085_amount0_m_capture : Uint256, __warp_usrid_086_amount1_m_capture : Uint256)-> (__warp_usrid_084_position : felt, __warp_usrid_085_amount0 : Uint256, __warp_usrid_086_amount1 : Uint256){
    alloc_locals;


        
        let __warp_usrid_084_position = 0;
        
        let __warp_usrid_085_amount0 = Uint256(low=0, high=0);
        
        let __warp_usrid_086_amount1 = Uint256(low=0, high=0);
        
        let __warp_usrid_086_amount1 = __warp_usrid_086_amount1_m_capture;
        
        let __warp_usrid_085_amount0 = __warp_usrid_085_amount0_m_capture;
        
        let __warp_usrid_084_position = __warp_usrid_084_position_m_capture;
        
        let (__warp_se_445) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(__warp_usrid_083_params);
        
        let (__warp_se_446) = wm_read_felt(__warp_se_445);
        
        let (__warp_se_447) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(__warp_usrid_083_params);
        
        let (__warp_se_448) = wm_read_felt(__warp_se_447);
        
        checkTicks_d267849c(__warp_se_446, __warp_se_448);
        
        let (__warp_usrid_087__slot0) = ws_to_memory1(__warp_usrid_039_slot0);
        
        let (__warp_se_449) = WM30_ModifyPositionParams_82bf7b1b___warp_usrid_009_owner(__warp_usrid_083_params);
        
        let (__warp_se_450) = wm_read_felt(__warp_se_449);
        
        let (__warp_se_451) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(__warp_usrid_083_params);
        
        let (__warp_se_452) = wm_read_felt(__warp_se_451);
        
        let (__warp_se_453) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(__warp_usrid_083_params);
        
        let (__warp_se_454) = wm_read_felt(__warp_se_453);
        
        let (__warp_se_455) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(__warp_usrid_083_params);
        
        let (__warp_se_456) = wm_read_felt(__warp_se_455);
        
        let (__warp_se_457) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_087__slot0);
        
        let (__warp_se_458) = wm_read_felt(__warp_se_457);
        
        let (__warp_pse_38) = _updatePosition_42b4bd05(__warp_se_450, __warp_se_452, __warp_se_454, __warp_se_456, __warp_se_458);
        
        let __warp_usrid_084_position = __warp_pse_38;
        
        let (__warp_se_459) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(__warp_usrid_083_params);
        
        let (__warp_se_460) = wm_read_felt(__warp_se_459);
        
        let (__warp_se_461) = warp_neq(__warp_se_460, 0);
        
            
            if (__warp_se_461 != 0){
            
                
                let (__warp_se_462) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_087__slot0);
                
                let (__warp_se_463) = wm_read_felt(__warp_se_462);
                
                let (__warp_se_464) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(__warp_usrid_083_params);
                
                let (__warp_se_465) = wm_read_felt(__warp_se_464);
                
                let (__warp_se_466) = warp_lt_signed24(__warp_se_463, __warp_se_465);
                
                    
                    if (__warp_se_466 != 0){
                    
                        
                        let (__warp_se_467) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(__warp_usrid_083_params);
                        
                        let (__warp_se_468) = wm_read_felt(__warp_se_467);
                        
                        let (__warp_pse_39) = getSqrtRatioAtTick_986cfba3(__warp_se_468);
                        
                        let (__warp_se_469) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(__warp_usrid_083_params);
                        
                        let (__warp_se_470) = wm_read_felt(__warp_se_469);
                        
                        let (__warp_pse_40) = getSqrtRatioAtTick_986cfba3(__warp_se_470);
                        
                        let (__warp_se_471) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(__warp_usrid_083_params);
                        
                        let (__warp_se_472) = wm_read_felt(__warp_se_471);
                        
                        let (__warp_pse_41) = getAmount0Delta_c932699b(__warp_pse_39, __warp_pse_40, __warp_se_472);
                        
                        let __warp_usrid_085_amount0 = __warp_pse_41;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar keccak_ptr = keccak_ptr;
                        tempvar __warp_usrid_086_amount1 = __warp_usrid_086_amount1;
                        tempvar __warp_usrid_085_amount0 = __warp_usrid_085_amount0;
                        tempvar __warp_usrid_084_position = __warp_usrid_084_position;
                    }else{
                    
                        
                        let (__warp_se_473) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_087__slot0);
                        
                        let (__warp_se_474) = wm_read_felt(__warp_se_473);
                        
                        let (__warp_se_475) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(__warp_usrid_083_params);
                        
                        let (__warp_se_476) = wm_read_felt(__warp_se_475);
                        
                        let (__warp_se_477) = warp_lt_signed24(__warp_se_474, __warp_se_476);
                        
                            
                            if (__warp_se_477 != 0){
                            
                                
                                let (__warp_usrid_088_liquidityBefore) = WS0_READ_felt(__warp_usrid_043_liquidity);
                                
                                    
                                    let (__warp_pse_42) = _blockTimestamp_c63aa3e7();
                                    
                                    let (__warp_se_478) = WM20_Slot0_930d2817___warp_usrid_002_observationIndex(__warp_usrid_087__slot0);
                                    
                                    let (__warp_se_479) = wm_read_felt(__warp_se_478);
                                    
                                    let (__warp_se_480) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_087__slot0);
                                    
                                    let (__warp_se_481) = wm_read_felt(__warp_se_480);
                                    
                                    let (__warp_se_482) = WM22_Slot0_930d2817___warp_usrid_003_observationCardinality(__warp_usrid_087__slot0);
                                    
                                    let (__warp_se_483) = wm_read_felt(__warp_se_482);
                                    
                                    let (__warp_se_484) = WM27_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(__warp_usrid_087__slot0);
                                    
                                    let (__warp_se_485) = wm_read_felt(__warp_se_484);
                                    
                                    let (__warp_tv_69, __warp_tv_70) = write_9b9fd24c(__warp_usrid_047_observations, __warp_se_479, __warp_pse_42, __warp_se_481, __warp_usrid_088_liquidityBefore, __warp_se_483, __warp_se_485);
                                    
                                    let (__warp_se_486) = WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(__warp_usrid_039_slot0);
                                    
                                    WS_WRITE0(__warp_se_486, __warp_tv_70);
                                    
                                    let (__warp_se_487) = WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(__warp_usrid_039_slot0);
                                    
                                    WS_WRITE0(__warp_se_487, __warp_tv_69);
                                
                                let (__warp_se_488) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(__warp_usrid_083_params);
                                
                                let (__warp_se_489) = wm_read_felt(__warp_se_488);
                                
                                let (__warp_pse_43) = getSqrtRatioAtTick_986cfba3(__warp_se_489);
                                
                                let (__warp_se_490) = WM25_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(__warp_usrid_087__slot0);
                                
                                let (__warp_se_491) = wm_read_felt(__warp_se_490);
                                
                                let (__warp_se_492) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(__warp_usrid_083_params);
                                
                                let (__warp_se_493) = wm_read_felt(__warp_se_492);
                                
                                let (__warp_pse_44) = getAmount0Delta_c932699b(__warp_se_491, __warp_pse_43, __warp_se_493);
                                
                                let __warp_usrid_085_amount0 = __warp_pse_44;
                                
                                let (__warp_se_494) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(__warp_usrid_083_params);
                                
                                let (__warp_se_495) = wm_read_felt(__warp_se_494);
                                
                                let (__warp_pse_45) = getSqrtRatioAtTick_986cfba3(__warp_se_495);
                                
                                let (__warp_se_496) = WM25_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(__warp_usrid_087__slot0);
                                
                                let (__warp_se_497) = wm_read_felt(__warp_se_496);
                                
                                let (__warp_se_498) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(__warp_usrid_083_params);
                                
                                let (__warp_se_499) = wm_read_felt(__warp_se_498);
                                
                                let (__warp_pse_46) = getAmount1Delta_00c11862(__warp_pse_45, __warp_se_497, __warp_se_499);
                                
                                let __warp_usrid_086_amount1 = __warp_pse_46;
                                
                                let (__warp_se_500) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(__warp_usrid_083_params);
                                
                                let (__warp_se_501) = wm_read_felt(__warp_se_500);
                                
                                let (__warp_pse_47) = addDelta_402d44fb(__warp_usrid_088_liquidityBefore, __warp_se_501);
                                
                                WS_WRITE0(__warp_usrid_043_liquidity, __warp_pse_47);
                                tempvar range_check_ptr = range_check_ptr;
                                tempvar warp_memory = warp_memory;
                                tempvar bitwise_ptr = bitwise_ptr;
                                tempvar syscall_ptr = syscall_ptr;
                                tempvar pedersen_ptr = pedersen_ptr;
                                tempvar keccak_ptr = keccak_ptr;
                                tempvar __warp_usrid_086_amount1 = __warp_usrid_086_amount1;
                                tempvar __warp_usrid_085_amount0 = __warp_usrid_085_amount0;
                                tempvar __warp_usrid_084_position = __warp_usrid_084_position;
                            }else{
                            
                                
                                let (__warp_se_502) = WM28_ModifyPositionParams_82bf7b1b___warp_usrid_010_tickLower(__warp_usrid_083_params);
                                
                                let (__warp_se_503) = wm_read_felt(__warp_se_502);
                                
                                let (__warp_pse_48) = getSqrtRatioAtTick_986cfba3(__warp_se_503);
                                
                                let (__warp_se_504) = WM29_ModifyPositionParams_82bf7b1b___warp_usrid_011_tickUpper(__warp_usrid_083_params);
                                
                                let (__warp_se_505) = wm_read_felt(__warp_se_504);
                                
                                let (__warp_pse_49) = getSqrtRatioAtTick_986cfba3(__warp_se_505);
                                
                                let (__warp_se_506) = WM31_ModifyPositionParams_82bf7b1b___warp_usrid_012_liquidityDelta(__warp_usrid_083_params);
                                
                                let (__warp_se_507) = wm_read_felt(__warp_se_506);
                                
                                let (__warp_pse_50) = getAmount1Delta_00c11862(__warp_pse_48, __warp_pse_49, __warp_se_507);
                                
                                let __warp_usrid_086_amount1 = __warp_pse_50;
                                tempvar range_check_ptr = range_check_ptr;
                                tempvar warp_memory = warp_memory;
                                tempvar bitwise_ptr = bitwise_ptr;
                                tempvar syscall_ptr = syscall_ptr;
                                tempvar pedersen_ptr = pedersen_ptr;
                                tempvar keccak_ptr = keccak_ptr;
                                tempvar __warp_usrid_086_amount1 = __warp_usrid_086_amount1;
                                tempvar __warp_usrid_085_amount0 = __warp_usrid_085_amount0;
                                tempvar __warp_usrid_084_position = __warp_usrid_084_position;
                            }
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar warp_memory = warp_memory;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar keccak_ptr = keccak_ptr;
                            tempvar __warp_usrid_086_amount1 = __warp_usrid_086_amount1;
                            tempvar __warp_usrid_085_amount0 = __warp_usrid_085_amount0;
                            tempvar __warp_usrid_084_position = __warp_usrid_084_position;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar keccak_ptr = keccak_ptr;
                        tempvar __warp_usrid_086_amount1 = __warp_usrid_086_amount1;
                        tempvar __warp_usrid_085_amount0 = __warp_usrid_085_amount0;
                        tempvar __warp_usrid_084_position = __warp_usrid_084_position;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar __warp_usrid_086_amount1 = __warp_usrid_086_amount1;
                    tempvar __warp_usrid_085_amount0 = __warp_usrid_085_amount0;
                    tempvar __warp_usrid_084_position = __warp_usrid_084_position;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_086_amount1 = __warp_usrid_086_amount1;
                tempvar __warp_usrid_085_amount0 = __warp_usrid_085_amount0;
                tempvar __warp_usrid_084_position = __warp_usrid_084_position;
            }else{
            
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar keccak_ptr = keccak_ptr;
                tempvar __warp_usrid_086_amount1 = __warp_usrid_086_amount1;
                tempvar __warp_usrid_085_amount0 = __warp_usrid_085_amount0;
                tempvar __warp_usrid_084_position = __warp_usrid_084_position;
            }
            tempvar range_check_ptr = range_check_ptr;
            tempvar warp_memory = warp_memory;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar keccak_ptr = keccak_ptr;
            tempvar __warp_usrid_086_amount1 = __warp_usrid_086_amount1;
            tempvar __warp_usrid_085_amount0 = __warp_usrid_085_amount0;
            tempvar __warp_usrid_084_position = __warp_usrid_084_position;
        
        let __warp_usrid_084_position = __warp_usrid_084_position;
        
        let __warp_usrid_085_amount0 = __warp_usrid_085_amount0;
        
        let __warp_usrid_086_amount1 = __warp_usrid_086_amount1;
        
        
        
        return (__warp_usrid_084_position, __warp_usrid_085_amount0, __warp_usrid_086_amount1);

    }


    func __warp_modifier_lock_increaseObservationCardinalityNext_32148f67_21{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_parameter___warp_parameter___warp_usrid_076_observationCardinalityNext1820 : felt)-> (){
    alloc_locals;


        
        let (__warp_se_508) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        let (__warp_se_509) = WS0_READ_felt(__warp_se_508);
        
        with_attr error_message("LOK"){
            assert __warp_se_509 = 1;
        }
        
        let (__warp_se_510) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_510, 0);
        
        __warp_modifier_noDelegateCall_increaseObservationCardinalityNext_32148f67_19(__warp_parameter___warp_parameter___warp_usrid_076_observationCardinalityNext1820);
        
        let (__warp_se_511) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_511, 1);
        
        
        
        return ();

    }


    func __warp_modifier_noDelegateCall_increaseObservationCardinalityNext_32148f67_19{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_parameter___warp_usrid_076_observationCardinalityNext18 : felt)-> (){
    alloc_locals;


        
        checkNotDelegateCall_8233c275();
        
        __warp_original_function_increaseObservationCardinalityNext_32148f67_17(__warp_parameter___warp_usrid_076_observationCardinalityNext18);
        
        
        
        return ();

    }

    // @inheritdoc IUniswapV3PoolActions
    func __warp_original_function_increaseObservationCardinalityNext_32148f67_17{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_076_observationCardinalityNext : felt)-> (){
    alloc_locals;


        
        let (__warp_se_512) = WSM11_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(__warp_usrid_039_slot0);
        
        let (__warp_usrid_077_observationCardinalityNextOld) = WS0_READ_felt(__warp_se_512);
        
        let (__warp_usrid_078_observationCardinalityNextNew) = grow_48fc651e(__warp_usrid_047_observations, __warp_usrid_077_observationCardinalityNextOld, __warp_usrid_076_observationCardinalityNext);
        
        let (__warp_se_513) = WSM11_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(__warp_usrid_039_slot0);
        
        WS_WRITE0(__warp_se_513, __warp_usrid_078_observationCardinalityNextNew);
        
        let (__warp_se_514) = warp_neq(__warp_usrid_077_observationCardinalityNextOld, __warp_usrid_078_observationCardinalityNextNew);
        
            
            if (__warp_se_514 != 0){
            
                
                IncreaseObservationCardinalityNext_ac49e518.emit(__warp_usrid_077_observationCardinalityNextOld, __warp_usrid_078_observationCardinalityNextNew);
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
            }else{
            
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
            }
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
        
        
        
        return ();

    }


    func __warp_modifier_noDelegateCall_observe_883bdbfd_16{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_parameter___warp_usrid_073_secondsAgos11 : cd_dynarray_felt, __warp_parameter___warp_usrid_074_tickCumulatives_m_capture12 : felt, __warp_parameter___warp_usrid_075_secondsPerLiquidityCumulativeX128s_m_capture13 : felt)-> (__warp_ret_parameter___warp_usrid_074_tickCumulatives14 : felt, __warp_ret_parameter___warp_usrid_075_secondsPerLiquidityCumulativeX128s15 : felt){
    alloc_locals;


        
        let (__warp_ret_parameter___warp_usrid_075_secondsPerLiquidityCumulativeX128s15) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));
        
        let (__warp_ret_parameter___warp_usrid_074_tickCumulatives14) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));
        
        checkNotDelegateCall_8233c275();
        
            
            let (__warp_td_23, __warp_td_24) = __warp_original_function_observe_883bdbfd_10(__warp_parameter___warp_usrid_073_secondsAgos11, __warp_parameter___warp_usrid_074_tickCumulatives_m_capture12, __warp_parameter___warp_usrid_075_secondsPerLiquidityCumulativeX128s_m_capture13);
            
            let __warp_tv_71 = __warp_td_23;
            
            let __warp_tv_72 = __warp_td_24;
            
            let __warp_ret_parameter___warp_usrid_075_secondsPerLiquidityCumulativeX128s15 = __warp_tv_72;
            
            let __warp_ret_parameter___warp_usrid_074_tickCumulatives14 = __warp_tv_71;
        
        let __warp_ret_parameter___warp_usrid_074_tickCumulatives14 = __warp_ret_parameter___warp_usrid_074_tickCumulatives14;
        
        let __warp_ret_parameter___warp_usrid_075_secondsPerLiquidityCumulativeX128s15 = __warp_ret_parameter___warp_usrid_075_secondsPerLiquidityCumulativeX128s15;
        
        
        
        return (__warp_ret_parameter___warp_usrid_074_tickCumulatives14, __warp_ret_parameter___warp_usrid_075_secondsPerLiquidityCumulativeX128s15);

    }

    // @inheritdoc IUniswapV3PoolDerivedState
    func __warp_original_function_observe_883bdbfd_10{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_073_secondsAgos : cd_dynarray_felt, __warp_usrid_074_tickCumulatives_m_capture : felt, __warp_usrid_075_secondsPerLiquidityCumulativeX128s_m_capture : felt)-> (__warp_usrid_074_tickCumulatives : felt, __warp_usrid_075_secondsPerLiquidityCumulativeX128s : felt){
    alloc_locals;


        
        let (__warp_usrid_074_tickCumulatives) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));
        
        let (__warp_usrid_075_secondsPerLiquidityCumulativeX128s) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));
        
        let __warp_usrid_075_secondsPerLiquidityCumulativeX128s = __warp_usrid_075_secondsPerLiquidityCumulativeX128s_m_capture;
        
        let __warp_usrid_074_tickCumulatives = __warp_usrid_074_tickCumulatives_m_capture;
        
        let (__warp_pse_51) = _blockTimestamp_c63aa3e7();
        
        let (__warp_se_515) = cd_to_memory0(__warp_usrid_073_secondsAgos);
        
        let (__warp_se_516) = WSM7_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_039_slot0);
        
        let (__warp_se_517) = WS0_READ_felt(__warp_se_516);
        
        let (__warp_se_518) = WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(__warp_usrid_039_slot0);
        
        let (__warp_se_519) = WS0_READ_felt(__warp_se_518);
        
        let (__warp_se_520) = WS0_READ_felt(__warp_usrid_043_liquidity);
        
        let (__warp_se_521) = WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(__warp_usrid_039_slot0);
        
        let (__warp_se_522) = WS0_READ_felt(__warp_se_521);
        
        let (__warp_td_25, __warp_td_26) = observe_1ce1e7a5(__warp_usrid_047_observations, __warp_pse_51, __warp_se_515, __warp_se_517, __warp_se_519, __warp_se_520, __warp_se_522);
        
        let __warp_usrid_074_tickCumulatives = __warp_td_25;
        
        let __warp_usrid_075_secondsPerLiquidityCumulativeX128s = __warp_td_26;
        
        
        
        return (__warp_usrid_074_tickCumulatives, __warp_usrid_075_secondsPerLiquidityCumulativeX128s);

    }


    func __warp_modifier_noDelegateCall_snapshotCumulativesInside_a38807f2_9{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_parameter___warp_usrid_054_tickLower1 : felt, __warp_parameter___warp_usrid_055_tickUpper2 : felt, __warp_parameter___warp_usrid_056_tickCumulativeInside_m_capture3 : felt, __warp_parameter___warp_usrid_057_secondsPerLiquidityInsideX128_m_capture4 : felt, __warp_parameter___warp_usrid_058_secondsInside_m_capture5 : felt)-> (__warp_ret_parameter___warp_usrid_056_tickCumulativeInside6 : felt, __warp_ret_parameter___warp_usrid_057_secondsPerLiquidityInsideX1287 : felt, __warp_ret_parameter___warp_usrid_058_secondsInside8 : felt){
    alloc_locals;


        
        let __warp_ret_parameter___warp_usrid_058_secondsInside8 = 0;
        
        let __warp_ret_parameter___warp_usrid_057_secondsPerLiquidityInsideX1287 = 0;
        
        let __warp_ret_parameter___warp_usrid_056_tickCumulativeInside6 = 0;
        
        checkNotDelegateCall_8233c275();
        
            
            let (__warp_tv_73, __warp_tv_74, __warp_tv_75) = __warp_original_function_snapshotCumulativesInside_a38807f2_0(__warp_parameter___warp_usrid_054_tickLower1, __warp_parameter___warp_usrid_055_tickUpper2, __warp_parameter___warp_usrid_056_tickCumulativeInside_m_capture3, __warp_parameter___warp_usrid_057_secondsPerLiquidityInsideX128_m_capture4, __warp_parameter___warp_usrid_058_secondsInside_m_capture5);
            
            let __warp_ret_parameter___warp_usrid_058_secondsInside8 = __warp_tv_75;
            
            let __warp_ret_parameter___warp_usrid_057_secondsPerLiquidityInsideX1287 = __warp_tv_74;
            
            let __warp_ret_parameter___warp_usrid_056_tickCumulativeInside6 = __warp_tv_73;
        
        let __warp_ret_parameter___warp_usrid_056_tickCumulativeInside6 = __warp_ret_parameter___warp_usrid_056_tickCumulativeInside6;
        
        let __warp_ret_parameter___warp_usrid_057_secondsPerLiquidityInsideX1287 = __warp_ret_parameter___warp_usrid_057_secondsPerLiquidityInsideX1287;
        
        let __warp_ret_parameter___warp_usrid_058_secondsInside8 = __warp_ret_parameter___warp_usrid_058_secondsInside8;
        
        
        
        return (__warp_ret_parameter___warp_usrid_056_tickCumulativeInside6, __warp_ret_parameter___warp_usrid_057_secondsPerLiquidityInsideX1287, __warp_ret_parameter___warp_usrid_058_secondsInside8);

    }

    // @inheritdoc IUniswapV3PoolDerivedState
    func __warp_original_function_snapshotCumulativesInside_a38807f2_0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_054_tickLower : felt, __warp_usrid_055_tickUpper : felt, __warp_usrid_056_tickCumulativeInside_m_capture : felt, __warp_usrid_057_secondsPerLiquidityInsideX128_m_capture : felt, __warp_usrid_058_secondsInside_m_capture : felt)-> (__warp_usrid_056_tickCumulativeInside : felt, __warp_usrid_057_secondsPerLiquidityInsideX128 : felt, __warp_usrid_058_secondsInside : felt){
    alloc_locals;


        
        let __warp_usrid_056_tickCumulativeInside = 0;
        
        let __warp_usrid_057_secondsPerLiquidityInsideX128 = 0;
        
        let __warp_usrid_058_secondsInside = 0;
        
        let __warp_usrid_058_secondsInside = __warp_usrid_058_secondsInside_m_capture;
        
        let __warp_usrid_057_secondsPerLiquidityInsideX128 = __warp_usrid_057_secondsPerLiquidityInsideX128_m_capture;
        
        let __warp_usrid_056_tickCumulativeInside = __warp_usrid_056_tickCumulativeInside_m_capture;
        
            
            checkTicks_d267849c(__warp_usrid_054_tickLower, __warp_usrid_055_tickUpper);
            
            let __warp_usrid_059_tickCumulativeLower = 0;
            
            let __warp_usrid_060_tickCumulativeUpper = 0;
            
            let __warp_usrid_061_secondsPerLiquidityOutsideLowerX128 = 0;
            
            let __warp_usrid_062_secondsPerLiquidityOutsideUpperX128 = 0;
            
            let __warp_usrid_063_secondsOutsideLower = 0;
            
            let __warp_usrid_064_secondsOutsideUpper = 0;
            
                
                let (__warp_usrid_065_lower) = WS0_INDEX_felt_to_Info_39bc053d(__warp_usrid_044_ticks, __warp_usrid_054_tickLower);
                
                let (__warp_usrid_066_upper) = WS0_INDEX_felt_to_Info_39bc053d(__warp_usrid_044_ticks, __warp_usrid_055_tickUpper);
                
                let __warp_usrid_067_initializedLower = 0;
                
                    
                    let (__warp_se_523) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(__warp_usrid_065_lower);
                    
                    let (__warp_tv_76) = WS0_READ_felt(__warp_se_523);
                    
                    let (__warp_se_524) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(__warp_usrid_065_lower);
                    
                    let (__warp_tv_77) = WS0_READ_felt(__warp_se_524);
                    
                    let (__warp_se_525) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(__warp_usrid_065_lower);
                    
                    let (__warp_tv_78) = WS0_READ_felt(__warp_se_525);
                    
                    let (__warp_se_526) = WSM15_Info_39bc053d___warp_usrid_07_initialized(__warp_usrid_065_lower);
                    
                    let (__warp_tv_79) = WS0_READ_felt(__warp_se_526);
                    
                    let __warp_usrid_067_initializedLower = __warp_tv_79;
                    
                    let __warp_usrid_063_secondsOutsideLower = __warp_tv_78;
                    
                    let __warp_usrid_061_secondsPerLiquidityOutsideLowerX128 = __warp_tv_77;
                    
                    let __warp_usrid_059_tickCumulativeLower = __warp_tv_76;
                
                assert __warp_usrid_067_initializedLower = 1;
                
                let __warp_usrid_068_initializedUpper = 0;
                
                    
                    let (__warp_se_527) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(__warp_usrid_066_upper);
                    
                    let (__warp_tv_80) = WS0_READ_felt(__warp_se_527);
                    
                    let (__warp_se_528) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(__warp_usrid_066_upper);
                    
                    let (__warp_tv_81) = WS0_READ_felt(__warp_se_528);
                    
                    let (__warp_se_529) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(__warp_usrid_066_upper);
                    
                    let (__warp_tv_82) = WS0_READ_felt(__warp_se_529);
                    
                    let (__warp_se_530) = WSM15_Info_39bc053d___warp_usrid_07_initialized(__warp_usrid_066_upper);
                    
                    let (__warp_tv_83) = WS0_READ_felt(__warp_se_530);
                    
                    let __warp_usrid_068_initializedUpper = __warp_tv_83;
                    
                    let __warp_usrid_064_secondsOutsideUpper = __warp_tv_82;
                    
                    let __warp_usrid_062_secondsPerLiquidityOutsideUpperX128 = __warp_tv_81;
                    
                    let __warp_usrid_060_tickCumulativeUpper = __warp_tv_80;
                
                assert __warp_usrid_068_initializedUpper = 1;
            
            let (__warp_usrid_069__slot0) = ws_to_memory1(__warp_usrid_039_slot0);
            
            let (__warp_se_531) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_069__slot0);
            
            let (__warp_se_532) = wm_read_felt(__warp_se_531);
            
            let (__warp_se_533) = warp_lt_signed24(__warp_se_532, __warp_usrid_054_tickLower);
            
            if (__warp_se_533 != 0){
            
                
                let (__warp_usrid_056_tickCumulativeInside) = warp_sub_signed_unsafe56(__warp_usrid_059_tickCumulativeLower, __warp_usrid_060_tickCumulativeUpper);
                
                let (__warp_usrid_057_secondsPerLiquidityInsideX128) = warp_sub_unsafe160(__warp_usrid_061_secondsPerLiquidityOutsideLowerX128, __warp_usrid_062_secondsPerLiquidityOutsideUpperX128);
                
                let (__warp_usrid_058_secondsInside) = warp_sub_unsafe32(__warp_usrid_063_secondsOutsideLower, __warp_usrid_064_secondsOutsideUpper);
                
                
                
                return (__warp_usrid_056_tickCumulativeInside, __warp_usrid_057_secondsPerLiquidityInsideX128, __warp_usrid_058_secondsInside);
            }else{
            
                
                let (__warp_se_534) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_069__slot0);
                
                let (__warp_se_535) = wm_read_felt(__warp_se_534);
                
                let (__warp_se_536) = warp_lt_signed24(__warp_se_535, __warp_usrid_055_tickUpper);
                
                if (__warp_se_536 != 0){
                
                    
                    let (__warp_usrid_070_time) = _blockTimestamp_c63aa3e7();
                    
                    let (__warp_se_537) = WM19_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_069__slot0);
                    
                    let (__warp_se_538) = wm_read_felt(__warp_se_537);
                    
                    let (__warp_se_539) = WM20_Slot0_930d2817___warp_usrid_002_observationIndex(__warp_usrid_069__slot0);
                    
                    let (__warp_se_540) = wm_read_felt(__warp_se_539);
                    
                    let (__warp_se_541) = WS0_READ_felt(__warp_usrid_043_liquidity);
                    
                    let (__warp_se_542) = WM22_Slot0_930d2817___warp_usrid_003_observationCardinality(__warp_usrid_069__slot0);
                    
                    let (__warp_se_543) = wm_read_felt(__warp_se_542);
                    
                    let (__warp_usrid_071_tickCumulative, __warp_usrid_072_secondsPerLiquidityCumulativeX128) = observeSingle_f7f8d6a0(__warp_usrid_047_observations, __warp_usrid_070_time, 0, __warp_se_538, __warp_se_540, __warp_se_541, __warp_se_543);
                    
                    let (__warp_se_544) = warp_sub_signed_unsafe56(__warp_usrid_071_tickCumulative, __warp_usrid_059_tickCumulativeLower);
                    
                    let (__warp_usrid_056_tickCumulativeInside) = warp_sub_signed_unsafe56(__warp_se_544, __warp_usrid_060_tickCumulativeUpper);
                    
                    let (__warp_se_545) = warp_sub_unsafe160(__warp_usrid_072_secondsPerLiquidityCumulativeX128, __warp_usrid_061_secondsPerLiquidityOutsideLowerX128);
                    
                    let (__warp_usrid_057_secondsPerLiquidityInsideX128) = warp_sub_unsafe160(__warp_se_545, __warp_usrid_062_secondsPerLiquidityOutsideUpperX128);
                    
                    let (__warp_se_546) = warp_sub_unsafe32(__warp_usrid_070_time, __warp_usrid_063_secondsOutsideLower);
                    
                    let (__warp_usrid_058_secondsInside) = warp_sub_unsafe32(__warp_se_546, __warp_usrid_064_secondsOutsideUpper);
                    
                    
                    
                    return (__warp_usrid_056_tickCumulativeInside, __warp_usrid_057_secondsPerLiquidityInsideX128, __warp_usrid_058_secondsInside);
                }else{
                
                    
                    let (__warp_usrid_056_tickCumulativeInside) = warp_sub_signed_unsafe56(__warp_usrid_060_tickCumulativeUpper, __warp_usrid_059_tickCumulativeLower);
                    
                    let (__warp_usrid_057_secondsPerLiquidityInsideX128) = warp_sub_unsafe160(__warp_usrid_062_secondsPerLiquidityOutsideUpperX128, __warp_usrid_061_secondsPerLiquidityOutsideLowerX128);
                    
                    let (__warp_usrid_058_secondsInside) = warp_sub_unsafe32(__warp_usrid_064_secondsOutsideUpper, __warp_usrid_063_secondsOutsideLower);
                    
                    
                    
                    return (__warp_usrid_056_tickCumulativeInside, __warp_usrid_057_secondsPerLiquidityInsideX128, __warp_usrid_058_secondsInside);
                }
            }

    }


    func __warp_constructor_1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}()-> (){
    alloc_locals;


        
        let __warp_usrid_048__tickSpacing = 0;
        
            
            let (__warp_se_547) = get_caller_address();
            
            let (__warp_tv_84, __warp_tv_85, __warp_tv_86, __warp_tv_87, __warp_tv_88) = IUniswapV3PoolDeployer_warped_interface.parameters_89035730(__warp_se_547);
            
            let __warp_usrid_048__tickSpacing = __warp_tv_88;
            
            WS_WRITE0(__warp_usrid_036_fee, __warp_tv_87);
            
            WS_WRITE0(__warp_usrid_035_token1, __warp_tv_86);
            
            WS_WRITE0(__warp_usrid_034_token0, __warp_tv_85);
            
            WS_WRITE0(__warp_usrid_033_factory, __warp_tv_84);
        
        WS_WRITE0(__warp_usrid_037_tickSpacing, __warp_usrid_048__tickSpacing);
        
        let (__warp_pse_52) = tickSpacingToMaxLiquidityPerTick_82c66f87(__warp_usrid_048__tickSpacing);
        
        WS_WRITE0(__warp_usrid_038_maxLiquidityPerTick, __warp_pse_52);
        
        
        
        return ();

    }

    // @dev Common checks for valid tick inputs.
    func checkTicks_d267849c{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_049_tickLower : felt, __warp_usrid_050_tickUpper : felt)-> (){
    alloc_locals;


        
        let (__warp_se_548) = warp_lt_signed24(__warp_usrid_049_tickLower, __warp_usrid_050_tickUpper);
        
        with_attr error_message("TLU"){
            assert __warp_se_548 = 1;
        }
        
        let (__warp_se_549) = warp_ge_signed24(__warp_usrid_049_tickLower, 15889944);
        
        with_attr error_message("TLM"){
            assert __warp_se_549 = 1;
        }
        
        let (__warp_se_550) = warp_le_signed24(__warp_usrid_050_tickUpper, 887272);
        
        with_attr error_message("TUM"){
            assert __warp_se_550 = 1;
        }
        
        
        
        return ();

    }

    // @dev Returns the block timestamp truncated to 32 bits, i.e. mod 2**32. This method is overridden in tests.
    func _blockTimestamp_c63aa3e7{syscall_ptr : felt*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}()-> (__warp_usrid_051_ : felt){
    alloc_locals;


        
        let (__warp_se_551) = warp_block_timestamp();
        
        let (__warp_se_552) = warp_int256_to_int32(__warp_se_551);
        
        
        
        return (__warp_se_552,);

    }

    // @dev Get the pool's balance of token0
    // @dev This function is gas optimized to avoid a redundant extcodesize check in addition to the returndatasize
    // check
    func balance0_1c69ad00{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_052_ : Uint256){
    alloc_locals;


        
        let (__warp_se_553) = WS0_READ_felt(__warp_usrid_034_token0);
        
        let (__warp_se_554) = get_contract_address();
        
        let (__warp_pse_53) = IERC20Minimal_warped_interface.balanceOf_70a08231(__warp_se_553, __warp_se_554);
        
        
        
        return (__warp_pse_53,);

    }

    // @dev Get the pool's balance of token1
    // @dev This function is gas optimized to avoid a redundant extcodesize check in addition to the returndatasize
    // check
    func balance1_c45c4f58{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_053_ : Uint256){
    alloc_locals;


        
        let (__warp_se_555) = WS0_READ_felt(__warp_usrid_035_token1);
        
        let (__warp_se_556) = get_contract_address();
        
        let (__warp_pse_54) = IERC20Minimal_warped_interface.balanceOf_70a08231(__warp_se_555, __warp_se_556);
        
        
        
        return (__warp_pse_54,);

    }

    // @dev Effect some changes to a position
    // @param params the position details and the change to the position's liquidity to effect
    // @return position a storage pointer referencing the position with the given owner and tick range
    // @return amount0 the amount of token0 owed to the pool, negative if the pool should pay the recipient
    // @return amount1 the amount of token1 owed to the pool, negative if the pool should pay the recipient
    func _modifyPosition_c6bd2490{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_usrid_083_params : felt)-> (__warp_usrid_084_position : felt, __warp_usrid_085_amount0 : Uint256, __warp_usrid_086_amount1 : Uint256){
    alloc_locals;


        
        let __warp_usrid_086_amount1 = Uint256(low=0, high=0);
        
        let __warp_usrid_085_amount0 = Uint256(low=0, high=0);
        
        let __warp_usrid_084_position = 0;
        
        let (__warp_td_29, __warp_usrid_085_amount0, __warp_usrid_086_amount1) = __warp_modifier_noDelegateCall__modifyPosition_c6bd2490_30(__warp_usrid_083_params, __warp_usrid_084_position, __warp_usrid_085_amount0, __warp_usrid_086_amount1);
        
        let __warp_usrid_084_position = __warp_td_29;
        
        
        
        return (__warp_usrid_084_position, __warp_usrid_085_amount0, __warp_usrid_086_amount1);

    }

    // @dev Gets and updates a position with the given liquidity delta
    // @param owner the owner of the position
    // @param tickLower the lower tick of the position's tick range
    // @param tickUpper the upper tick of the position's tick range
    // @param tick the current tick, passed to avoid sloads
    func _updatePosition_42b4bd05{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_usrid_089_owner : felt, __warp_usrid_090_tickLower : felt, __warp_usrid_091_tickUpper : felt, __warp_usrid_092_liquidityDelta : felt, __warp_usrid_093_tick : felt)-> (__warp_usrid_094_position : felt){
    alloc_locals;


        
        let __warp_usrid_094_position = 0;
        
        let (__warp_pse_56) = get_a4d6(__warp_usrid_046_positions, __warp_usrid_089_owner, __warp_usrid_090_tickLower, __warp_usrid_091_tickUpper);
        
        let __warp_usrid_094_position = __warp_pse_56;
        
        let (__warp_usrid_095__feeGrowthGlobal0X128) = WS1_READ_Uint256(__warp_usrid_040_feeGrowthGlobal0X128);
        
        let (__warp_usrid_096__feeGrowthGlobal1X128) = WS1_READ_Uint256(__warp_usrid_041_feeGrowthGlobal1X128);
        
        let __warp_usrid_097_flippedLower = 0;
        
        let __warp_usrid_098_flippedUpper = 0;
        
        let (__warp_se_563) = warp_neq(__warp_usrid_092_liquidityDelta, 0);
        
            
            if (__warp_se_563 != 0){
            
                
                let (__warp_usrid_099_time) = _blockTimestamp_c63aa3e7();
                
                let (__warp_se_564) = WSM7_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_039_slot0);
                
                let (__warp_se_565) = WS0_READ_felt(__warp_se_564);
                
                let (__warp_se_566) = WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(__warp_usrid_039_slot0);
                
                let (__warp_se_567) = WS0_READ_felt(__warp_se_566);
                
                let (__warp_se_568) = WS0_READ_felt(__warp_usrid_043_liquidity);
                
                let (__warp_se_569) = WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(__warp_usrid_039_slot0);
                
                let (__warp_se_570) = WS0_READ_felt(__warp_se_569);
                
                let (__warp_usrid_100_tickCumulative, __warp_usrid_101_secondsPerLiquidityCumulativeX128) = observeSingle_f7f8d6a0(__warp_usrid_047_observations, __warp_usrid_099_time, 0, __warp_se_565, __warp_se_567, __warp_se_568, __warp_se_570);
                
                let (__warp_se_571) = WS0_READ_felt(__warp_usrid_038_maxLiquidityPerTick);
                
                let (__warp_pse_57) = update_3bf3(__warp_usrid_044_ticks, __warp_usrid_090_tickLower, __warp_usrid_093_tick, __warp_usrid_092_liquidityDelta, __warp_usrid_095__feeGrowthGlobal0X128, __warp_usrid_096__feeGrowthGlobal1X128, __warp_usrid_101_secondsPerLiquidityCumulativeX128, __warp_usrid_100_tickCumulative, __warp_usrid_099_time, 0, __warp_se_571);
                
                let __warp_usrid_097_flippedLower = __warp_pse_57;
                
                let (__warp_se_572) = WS0_READ_felt(__warp_usrid_038_maxLiquidityPerTick);
                
                let (__warp_pse_58) = update_3bf3(__warp_usrid_044_ticks, __warp_usrid_091_tickUpper, __warp_usrid_093_tick, __warp_usrid_092_liquidityDelta, __warp_usrid_095__feeGrowthGlobal0X128, __warp_usrid_096__feeGrowthGlobal1X128, __warp_usrid_101_secondsPerLiquidityCumulativeX128, __warp_usrid_100_tickCumulative, __warp_usrid_099_time, 1, __warp_se_572);
                
                let __warp_usrid_098_flippedUpper = __warp_pse_58;
                
                    
                    if (__warp_usrid_097_flippedLower != 0){
                    
                        
                        let (__warp_se_573) = WS0_READ_felt(__warp_usrid_037_tickSpacing);
                        
                        flipTick_5b3a(__warp_usrid_045_tickBitmap, __warp_usrid_090_tickLower, __warp_se_573);
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar keccak_ptr = keccak_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                        tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                        tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                        tempvar __warp_usrid_097_flippedLower = __warp_usrid_097_flippedLower;
                        tempvar __warp_usrid_090_tickLower = __warp_usrid_090_tickLower;
                        tempvar __warp_usrid_092_liquidityDelta = __warp_usrid_092_liquidityDelta;
                        tempvar __warp_usrid_093_tick = __warp_usrid_093_tick;
                        tempvar __warp_usrid_095__feeGrowthGlobal0X128 = __warp_usrid_095__feeGrowthGlobal0X128;
                        tempvar __warp_usrid_096__feeGrowthGlobal1X128 = __warp_usrid_096__feeGrowthGlobal1X128;
                    }else{
                    
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar keccak_ptr = keccak_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                        tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                        tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                        tempvar __warp_usrid_097_flippedLower = __warp_usrid_097_flippedLower;
                        tempvar __warp_usrid_090_tickLower = __warp_usrid_090_tickLower;
                        tempvar __warp_usrid_092_liquidityDelta = __warp_usrid_092_liquidityDelta;
                        tempvar __warp_usrid_093_tick = __warp_usrid_093_tick;
                        tempvar __warp_usrid_095__feeGrowthGlobal0X128 = __warp_usrid_095__feeGrowthGlobal0X128;
                        tempvar __warp_usrid_096__feeGrowthGlobal1X128 = __warp_usrid_096__feeGrowthGlobal1X128;
                    }
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                    tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                    tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                    tempvar __warp_usrid_097_flippedLower = __warp_usrid_097_flippedLower;
                    tempvar __warp_usrid_090_tickLower = __warp_usrid_090_tickLower;
                    tempvar __warp_usrid_092_liquidityDelta = __warp_usrid_092_liquidityDelta;
                    tempvar __warp_usrid_093_tick = __warp_usrid_093_tick;
                    tempvar __warp_usrid_095__feeGrowthGlobal0X128 = __warp_usrid_095__feeGrowthGlobal0X128;
                    tempvar __warp_usrid_096__feeGrowthGlobal1X128 = __warp_usrid_096__feeGrowthGlobal1X128;
                
                    
                    if (__warp_usrid_098_flippedUpper != 0){
                    
                        
                        let (__warp_se_574) = WS0_READ_felt(__warp_usrid_037_tickSpacing);
                        
                        flipTick_5b3a(__warp_usrid_045_tickBitmap, __warp_usrid_091_tickUpper, __warp_se_574);
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar keccak_ptr = keccak_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                        tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                        tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                        tempvar __warp_usrid_097_flippedLower = __warp_usrid_097_flippedLower;
                        tempvar __warp_usrid_090_tickLower = __warp_usrid_090_tickLower;
                        tempvar __warp_usrid_092_liquidityDelta = __warp_usrid_092_liquidityDelta;
                        tempvar __warp_usrid_093_tick = __warp_usrid_093_tick;
                        tempvar __warp_usrid_095__feeGrowthGlobal0X128 = __warp_usrid_095__feeGrowthGlobal0X128;
                        tempvar __warp_usrid_096__feeGrowthGlobal1X128 = __warp_usrid_096__feeGrowthGlobal1X128;
                    }else{
                    
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar keccak_ptr = keccak_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                        tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                        tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                        tempvar __warp_usrid_097_flippedLower = __warp_usrid_097_flippedLower;
                        tempvar __warp_usrid_090_tickLower = __warp_usrid_090_tickLower;
                        tempvar __warp_usrid_092_liquidityDelta = __warp_usrid_092_liquidityDelta;
                        tempvar __warp_usrid_093_tick = __warp_usrid_093_tick;
                        tempvar __warp_usrid_095__feeGrowthGlobal0X128 = __warp_usrid_095__feeGrowthGlobal0X128;
                        tempvar __warp_usrid_096__feeGrowthGlobal1X128 = __warp_usrid_096__feeGrowthGlobal1X128;
                    }
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                    tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                    tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                    tempvar __warp_usrid_097_flippedLower = __warp_usrid_097_flippedLower;
                    tempvar __warp_usrid_090_tickLower = __warp_usrid_090_tickLower;
                    tempvar __warp_usrid_092_liquidityDelta = __warp_usrid_092_liquidityDelta;
                    tempvar __warp_usrid_093_tick = __warp_usrid_093_tick;
                    tempvar __warp_usrid_095__feeGrowthGlobal0X128 = __warp_usrid_095__feeGrowthGlobal0X128;
                    tempvar __warp_usrid_096__feeGrowthGlobal1X128 = __warp_usrid_096__feeGrowthGlobal1X128;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar keccak_ptr = keccak_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                tempvar __warp_usrid_097_flippedLower = __warp_usrid_097_flippedLower;
                tempvar __warp_usrid_090_tickLower = __warp_usrid_090_tickLower;
                tempvar __warp_usrid_092_liquidityDelta = __warp_usrid_092_liquidityDelta;
                tempvar __warp_usrid_093_tick = __warp_usrid_093_tick;
                tempvar __warp_usrid_095__feeGrowthGlobal0X128 = __warp_usrid_095__feeGrowthGlobal0X128;
                tempvar __warp_usrid_096__feeGrowthGlobal1X128 = __warp_usrid_096__feeGrowthGlobal1X128;
            }else{
            
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar keccak_ptr = keccak_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                tempvar __warp_usrid_097_flippedLower = __warp_usrid_097_flippedLower;
                tempvar __warp_usrid_090_tickLower = __warp_usrid_090_tickLower;
                tempvar __warp_usrid_092_liquidityDelta = __warp_usrid_092_liquidityDelta;
                tempvar __warp_usrid_093_tick = __warp_usrid_093_tick;
                tempvar __warp_usrid_095__feeGrowthGlobal0X128 = __warp_usrid_095__feeGrowthGlobal0X128;
                tempvar __warp_usrid_096__feeGrowthGlobal1X128 = __warp_usrid_096__feeGrowthGlobal1X128;
            }
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar range_check_ptr = range_check_ptr;
            tempvar warp_memory = warp_memory;
            tempvar keccak_ptr = keccak_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar __warp_usrid_094_position = __warp_usrid_094_position;
            tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
            tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
            tempvar __warp_usrid_097_flippedLower = __warp_usrid_097_flippedLower;
            tempvar __warp_usrid_090_tickLower = __warp_usrid_090_tickLower;
            tempvar __warp_usrid_092_liquidityDelta = __warp_usrid_092_liquidityDelta;
            tempvar __warp_usrid_093_tick = __warp_usrid_093_tick;
            tempvar __warp_usrid_095__feeGrowthGlobal0X128 = __warp_usrid_095__feeGrowthGlobal0X128;
            tempvar __warp_usrid_096__feeGrowthGlobal1X128 = __warp_usrid_096__feeGrowthGlobal1X128;
        
        let (__warp_usrid_102_feeGrowthInside0X128, __warp_usrid_103_feeGrowthInside1X128) = getFeeGrowthInside_5ae8(__warp_usrid_044_ticks, __warp_usrid_090_tickLower, __warp_usrid_091_tickUpper, __warp_usrid_093_tick, __warp_usrid_095__feeGrowthGlobal0X128, __warp_usrid_096__feeGrowthGlobal1X128);
        
        update_d9a1a063(__warp_usrid_094_position, __warp_usrid_092_liquidityDelta, __warp_usrid_102_feeGrowthInside0X128, __warp_usrid_103_feeGrowthInside1X128);
        
        let (__warp_se_575) = warp_lt_signed128(__warp_usrid_092_liquidityDelta, 0);
        
            
            if (__warp_se_575 != 0){
            
                
                    
                    if (__warp_usrid_097_flippedLower != 0){
                    
                        
                        clear_db51(__warp_usrid_044_ticks, __warp_usrid_090_tickLower);
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar keccak_ptr = keccak_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                        tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                        tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                    }else{
                    
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar keccak_ptr = keccak_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                        tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                        tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                    }
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                    tempvar __warp_usrid_098_flippedUpper = __warp_usrid_098_flippedUpper;
                    tempvar __warp_usrid_091_tickUpper = __warp_usrid_091_tickUpper;
                
                    
                    if (__warp_usrid_098_flippedUpper != 0){
                    
                        
                        clear_db51(__warp_usrid_044_ticks, __warp_usrid_091_tickUpper);
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar keccak_ptr = keccak_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                    }else{
                    
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar warp_memory = warp_memory;
                        tempvar keccak_ptr = keccak_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                    }
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar keccak_ptr = keccak_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_094_position = __warp_usrid_094_position;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar keccak_ptr = keccak_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar __warp_usrid_094_position = __warp_usrid_094_position;
            }else{
            
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar keccak_ptr = keccak_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar __warp_usrid_094_position = __warp_usrid_094_position;
            }
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar range_check_ptr = range_check_ptr;
            tempvar warp_memory = warp_memory;
            tempvar keccak_ptr = keccak_ptr;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar __warp_usrid_094_position = __warp_usrid_094_position;
        
        
        
        return (__warp_usrid_094_position,);

    }


    func conditional0_148ce0b9{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_151_zeroForOne : felt, __warp_usrid_152_slot0Start : felt)-> (__warp_usrid_153_ : felt){
    alloc_locals;


        
        if (__warp_usrid_151_zeroForOne != 0){
        
            
            let (__warp_se_576) = WM32_Slot0_930d2817___warp_usrid_005_feeProtocol(__warp_usrid_152_slot0Start);
            
            let (__warp_se_577) = wm_read_felt(__warp_se_576);
            
            let (__warp_se_578) = warp_mod(__warp_se_577, 16);
            
            
            
            return (__warp_se_578,);
        }else{
        
            
            let (__warp_se_579) = WM32_Slot0_930d2817___warp_usrid_005_feeProtocol(__warp_usrid_152_slot0Start);
            
            let (__warp_se_580) = wm_read_felt(__warp_se_579);
            
            let (__warp_se_581) = warp_shr8(__warp_se_580, 4);
            
            
            
            return (__warp_se_581,);
        }

    }


    func conditional1_0f286cba{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_usrid_154_zeroForOne : felt)-> (__warp_usrid_155_ : Uint256){
    alloc_locals;


        
        if (__warp_usrid_154_zeroForOne != 0){
        
            
            let (__warp_se_582) = WS1_READ_Uint256(__warp_usrid_040_feeGrowthGlobal0X128);
            
            
            
            return (__warp_se_582,);
        }else{
        
            
            let (__warp_se_583) = WS1_READ_Uint256(__warp_usrid_041_feeGrowthGlobal1X128);
            
            
            
            return (__warp_se_583,);
        }

    }


    func conditional2_a88d8ea4{range_check_ptr : felt, warp_memory : DictAccess*}(__warp_usrid_156_flag : felt, __warp_usrid_157_sqrtPriceLimitX96 : felt, __warp_usrid_158_step : felt)-> (__warp_usrid_159_ : felt){
    alloc_locals;


        
        if (__warp_usrid_156_flag != 0){
        
            
            
            
            return (__warp_usrid_157_sqrtPriceLimitX96,);
        }else{
        
            
            let (__warp_se_584) = WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(__warp_usrid_158_step);
            
            let (__warp_se_585) = wm_read_felt(__warp_se_584);
            
            
            
            return (__warp_se_585,);
        }

    }


    func conditional3_e92662c8{range_check_ptr : felt, warp_memory : DictAccess*}(__warp_usrid_160_zeroForOne : felt, __warp_usrid_161_sqrtPriceLimitX96 : felt, __warp_usrid_162_step : felt)-> (__warp_usrid_163_ : felt){
    alloc_locals;


        
        if (__warp_usrid_160_zeroForOne != 0){
        
            
            let (__warp_se_586) = WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(__warp_usrid_162_step);
            
            let (__warp_se_587) = wm_read_felt(__warp_se_586);
            
            let (__warp_se_588) = warp_lt(__warp_se_587, __warp_usrid_161_sqrtPriceLimitX96);
            
            
            
            return (__warp_se_588,);
        }else{
        
            
            let (__warp_se_589) = WM8_StepComputations_cf1844f5___warp_usrid_029_sqrtPriceNextX96(__warp_usrid_162_step);
            
            let (__warp_se_590) = wm_read_felt(__warp_se_589);
            
            let (__warp_se_591) = warp_gt(__warp_se_590, __warp_usrid_161_sqrtPriceLimitX96);
            
            
            
            return (__warp_se_591,);
        }

    }


    func conditional4_9427c021{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(__warp_usrid_164_zeroForOne : felt, __warp_usrid_165_state : felt)-> (__warp_usrid_166_ : Uint256){
    alloc_locals;


        
        if (__warp_usrid_164_zeroForOne != 0){
        
            
            let (__warp_se_592) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(__warp_usrid_165_state);
            
            let (__warp_se_593) = wm_read_256(__warp_se_592);
            
            
            
            return (__warp_se_593,);
        }else{
        
            
            let (__warp_se_594) = WS1_READ_Uint256(__warp_usrid_040_feeGrowthGlobal0X128);
            
            
            
            return (__warp_se_594,);
        }

    }


    func conditional5_28dc1807{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(__warp_usrid_167_zeroForOne : felt, __warp_usrid_168_state : felt)-> (__warp_usrid_169_ : Uint256){
    alloc_locals;


        
        if (__warp_usrid_167_zeroForOne != 0){
        
            
            let (__warp_se_595) = WS1_READ_Uint256(__warp_usrid_041_feeGrowthGlobal1X128);
            
            
            
            return (__warp_se_595,);
        }else{
        
            
            let (__warp_se_596) = WM16_SwapState_eba3c779___warp_usrid_023_feeGrowthGlobalX128(__warp_usrid_168_state);
            
            let (__warp_se_597) = wm_read_256(__warp_se_596);
            
            
            
            return (__warp_se_597,);
        }

    }


    func __warp_constructor_0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (){
    alloc_locals;


        
        let (__warp_se_635) = get_contract_address();
        
        WS_WRITE0(__warp_usrid_00_original, __warp_se_635);
        
        
        
        return ();

    }

    // @dev Private method is used instead of inlining into modifier because modifiers are copied into each method,
    //     and the use of immutable means the address bytes are copied in every place the modifier is used.
    func checkNotDelegateCall_8233c275{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (){
    alloc_locals;


        
        let (__warp_se_636) = get_contract_address();
        
        let (__warp_se_637) = WS0_READ_felt(__warp_usrid_00_original);
        
        let (__warp_se_638) = warp_eq(__warp_se_636, __warp_se_637);
        
        assert __warp_se_638 = 1;
        
        
        
        return ();

    }

    // @notice Derives max liquidity per tick from given tick spacing
    // @dev Executed within the pool constructor
    // @param tickSpacing The amount of required tick separation, realized in multiples of `tickSpacing`
    //     e.g., a tickSpacing of 3 requires ticks to be initialized every 3rd tick i.e., ..., -6, -3, 0, 3, 6, ...
    // @return The max liquidity per tick
    func tickSpacingToMaxLiquidityPerTick_82c66f87{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_08_tickSpacing : felt)-> (__warp_usrid_09_ : felt){
    alloc_locals;


        
            
            let (__warp_se_639) = warp_div_signed_unsafe24(15889944, __warp_usrid_08_tickSpacing);
            
            let (__warp_usrid_10_minTick) = warp_mul_signed_unsafe24(__warp_se_639, __warp_usrid_08_tickSpacing);
            
            let (__warp_se_640) = warp_div_signed_unsafe24(887272, __warp_usrid_08_tickSpacing);
            
            let (__warp_usrid_11_maxTick) = warp_mul_signed_unsafe24(__warp_se_640, __warp_usrid_08_tickSpacing);
            
            let (__warp_se_641) = warp_sub_signed_unsafe24(__warp_usrid_11_maxTick, __warp_usrid_10_minTick);
            
            let (__warp_se_642) = warp_div_unsafe(__warp_se_641, __warp_usrid_08_tickSpacing);
            
            let (__warp_usrid_12_numTicks) = warp_add_unsafe24(__warp_se_642, 1);
            
            let (__warp_se_643) = warp_div_unsafe(340282366920938463463374607431768211455, __warp_usrid_12_numTicks);
            
            
            
            return (__warp_se_643,);

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
    func getFeeGrowthInside_5ae8{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_13_self : felt, __warp_usrid_14_tickLower : felt, __warp_usrid_15_tickUpper : felt, __warp_usrid_16_tickCurrent : felt, __warp_usrid_17_feeGrowthGlobal0X128 : Uint256, __warp_usrid_18_feeGrowthGlobal1X128 : Uint256)-> (__warp_usrid_19_feeGrowthInside0X128 : Uint256, __warp_usrid_20_feeGrowthInside1X128 : Uint256){
    alloc_locals;


        
        let __warp_usrid_20_feeGrowthInside1X128 = Uint256(low=0, high=0);
        
        let __warp_usrid_19_feeGrowthInside0X128 = Uint256(low=0, high=0);
        
            
            let (__warp_usrid_21_lower) = WS0_INDEX_felt_to_Info_39bc053d(__warp_usrid_13_self, __warp_usrid_14_tickLower);
            
            let (__warp_usrid_22_upper) = WS0_INDEX_felt_to_Info_39bc053d(__warp_usrid_13_self, __warp_usrid_15_tickUpper);
            
            let __warp_usrid_23_feeGrowthBelow0X128 = Uint256(low=0, high=0);
            
            let __warp_usrid_24_feeGrowthBelow1X128 = Uint256(low=0, high=0);
            
            let (__warp_se_644) = warp_ge_signed24(__warp_usrid_16_tickCurrent, __warp_usrid_14_tickLower);
            
                
                if (__warp_se_644 != 0){
                
                    
                    let (__warp_se_645) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(__warp_usrid_21_lower);
                    
                    let (__warp_se_646) = WS1_READ_Uint256(__warp_se_645);
                    
                    let __warp_usrid_23_feeGrowthBelow0X128 = __warp_se_646;
                    
                    let (__warp_se_647) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(__warp_usrid_21_lower);
                    
                    let (__warp_se_648) = WS1_READ_Uint256(__warp_se_647);
                    
                    let __warp_usrid_24_feeGrowthBelow1X128 = __warp_se_648;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_20_feeGrowthInside1X128 = __warp_usrid_20_feeGrowthInside1X128;
                    tempvar __warp_usrid_19_feeGrowthInside0X128 = __warp_usrid_19_feeGrowthInside0X128;
                    tempvar __warp_usrid_18_feeGrowthGlobal1X128 = __warp_usrid_18_feeGrowthGlobal1X128;
                    tempvar __warp_usrid_24_feeGrowthBelow1X128 = __warp_usrid_24_feeGrowthBelow1X128;
                    tempvar __warp_usrid_17_feeGrowthGlobal0X128 = __warp_usrid_17_feeGrowthGlobal0X128;
                    tempvar __warp_usrid_23_feeGrowthBelow0X128 = __warp_usrid_23_feeGrowthBelow0X128;
                    tempvar __warp_usrid_22_upper = __warp_usrid_22_upper;
                    tempvar __warp_usrid_16_tickCurrent = __warp_usrid_16_tickCurrent;
                    tempvar __warp_usrid_15_tickUpper = __warp_usrid_15_tickUpper;
                }else{
                
                    
                    let (__warp_se_649) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(__warp_usrid_21_lower);
                    
                    let (__warp_se_650) = WS1_READ_Uint256(__warp_se_649);
                    
                    let (__warp_se_651) = warp_sub_unsafe256(__warp_usrid_17_feeGrowthGlobal0X128, __warp_se_650);
                    
                    let __warp_usrid_23_feeGrowthBelow0X128 = __warp_se_651;
                    
                    let (__warp_se_652) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(__warp_usrid_21_lower);
                    
                    let (__warp_se_653) = WS1_READ_Uint256(__warp_se_652);
                    
                    let (__warp_se_654) = warp_sub_unsafe256(__warp_usrid_18_feeGrowthGlobal1X128, __warp_se_653);
                    
                    let __warp_usrid_24_feeGrowthBelow1X128 = __warp_se_654;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_20_feeGrowthInside1X128 = __warp_usrid_20_feeGrowthInside1X128;
                    tempvar __warp_usrid_19_feeGrowthInside0X128 = __warp_usrid_19_feeGrowthInside0X128;
                    tempvar __warp_usrid_18_feeGrowthGlobal1X128 = __warp_usrid_18_feeGrowthGlobal1X128;
                    tempvar __warp_usrid_24_feeGrowthBelow1X128 = __warp_usrid_24_feeGrowthBelow1X128;
                    tempvar __warp_usrid_17_feeGrowthGlobal0X128 = __warp_usrid_17_feeGrowthGlobal0X128;
                    tempvar __warp_usrid_23_feeGrowthBelow0X128 = __warp_usrid_23_feeGrowthBelow0X128;
                    tempvar __warp_usrid_22_upper = __warp_usrid_22_upper;
                    tempvar __warp_usrid_16_tickCurrent = __warp_usrid_16_tickCurrent;
                    tempvar __warp_usrid_15_tickUpper = __warp_usrid_15_tickUpper;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_20_feeGrowthInside1X128 = __warp_usrid_20_feeGrowthInside1X128;
                tempvar __warp_usrid_19_feeGrowthInside0X128 = __warp_usrid_19_feeGrowthInside0X128;
                tempvar __warp_usrid_18_feeGrowthGlobal1X128 = __warp_usrid_18_feeGrowthGlobal1X128;
                tempvar __warp_usrid_24_feeGrowthBelow1X128 = __warp_usrid_24_feeGrowthBelow1X128;
                tempvar __warp_usrid_17_feeGrowthGlobal0X128 = __warp_usrid_17_feeGrowthGlobal0X128;
                tempvar __warp_usrid_23_feeGrowthBelow0X128 = __warp_usrid_23_feeGrowthBelow0X128;
                tempvar __warp_usrid_22_upper = __warp_usrid_22_upper;
                tempvar __warp_usrid_16_tickCurrent = __warp_usrid_16_tickCurrent;
                tempvar __warp_usrid_15_tickUpper = __warp_usrid_15_tickUpper;
            
            let __warp_usrid_25_feeGrowthAbove0X128 = Uint256(low=0, high=0);
            
            let __warp_usrid_26_feeGrowthAbove1X128 = Uint256(low=0, high=0);
            
            let (__warp_se_655) = warp_lt_signed24(__warp_usrid_16_tickCurrent, __warp_usrid_15_tickUpper);
            
                
                if (__warp_se_655 != 0){
                
                    
                    let (__warp_se_656) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(__warp_usrid_22_upper);
                    
                    let (__warp_se_657) = WS1_READ_Uint256(__warp_se_656);
                    
                    let __warp_usrid_25_feeGrowthAbove0X128 = __warp_se_657;
                    
                    let (__warp_se_658) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(__warp_usrid_22_upper);
                    
                    let (__warp_se_659) = WS1_READ_Uint256(__warp_se_658);
                    
                    let __warp_usrid_26_feeGrowthAbove1X128 = __warp_se_659;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_20_feeGrowthInside1X128 = __warp_usrid_20_feeGrowthInside1X128;
                    tempvar __warp_usrid_19_feeGrowthInside0X128 = __warp_usrid_19_feeGrowthInside0X128;
                    tempvar __warp_usrid_26_feeGrowthAbove1X128 = __warp_usrid_26_feeGrowthAbove1X128;
                    tempvar __warp_usrid_18_feeGrowthGlobal1X128 = __warp_usrid_18_feeGrowthGlobal1X128;
                    tempvar __warp_usrid_24_feeGrowthBelow1X128 = __warp_usrid_24_feeGrowthBelow1X128;
                    tempvar __warp_usrid_25_feeGrowthAbove0X128 = __warp_usrid_25_feeGrowthAbove0X128;
                    tempvar __warp_usrid_17_feeGrowthGlobal0X128 = __warp_usrid_17_feeGrowthGlobal0X128;
                    tempvar __warp_usrid_23_feeGrowthBelow0X128 = __warp_usrid_23_feeGrowthBelow0X128;
                }else{
                
                    
                    let (__warp_se_660) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(__warp_usrid_22_upper);
                    
                    let (__warp_se_661) = WS1_READ_Uint256(__warp_se_660);
                    
                    let (__warp_se_662) = warp_sub_unsafe256(__warp_usrid_17_feeGrowthGlobal0X128, __warp_se_661);
                    
                    let __warp_usrid_25_feeGrowthAbove0X128 = __warp_se_662;
                    
                    let (__warp_se_663) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(__warp_usrid_22_upper);
                    
                    let (__warp_se_664) = WS1_READ_Uint256(__warp_se_663);
                    
                    let (__warp_se_665) = warp_sub_unsafe256(__warp_usrid_18_feeGrowthGlobal1X128, __warp_se_664);
                    
                    let __warp_usrid_26_feeGrowthAbove1X128 = __warp_se_665;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_20_feeGrowthInside1X128 = __warp_usrid_20_feeGrowthInside1X128;
                    tempvar __warp_usrid_19_feeGrowthInside0X128 = __warp_usrid_19_feeGrowthInside0X128;
                    tempvar __warp_usrid_26_feeGrowthAbove1X128 = __warp_usrid_26_feeGrowthAbove1X128;
                    tempvar __warp_usrid_18_feeGrowthGlobal1X128 = __warp_usrid_18_feeGrowthGlobal1X128;
                    tempvar __warp_usrid_24_feeGrowthBelow1X128 = __warp_usrid_24_feeGrowthBelow1X128;
                    tempvar __warp_usrid_25_feeGrowthAbove0X128 = __warp_usrid_25_feeGrowthAbove0X128;
                    tempvar __warp_usrid_17_feeGrowthGlobal0X128 = __warp_usrid_17_feeGrowthGlobal0X128;
                    tempvar __warp_usrid_23_feeGrowthBelow0X128 = __warp_usrid_23_feeGrowthBelow0X128;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_20_feeGrowthInside1X128 = __warp_usrid_20_feeGrowthInside1X128;
                tempvar __warp_usrid_19_feeGrowthInside0X128 = __warp_usrid_19_feeGrowthInside0X128;
                tempvar __warp_usrid_26_feeGrowthAbove1X128 = __warp_usrid_26_feeGrowthAbove1X128;
                tempvar __warp_usrid_18_feeGrowthGlobal1X128 = __warp_usrid_18_feeGrowthGlobal1X128;
                tempvar __warp_usrid_24_feeGrowthBelow1X128 = __warp_usrid_24_feeGrowthBelow1X128;
                tempvar __warp_usrid_25_feeGrowthAbove0X128 = __warp_usrid_25_feeGrowthAbove0X128;
                tempvar __warp_usrid_17_feeGrowthGlobal0X128 = __warp_usrid_17_feeGrowthGlobal0X128;
                tempvar __warp_usrid_23_feeGrowthBelow0X128 = __warp_usrid_23_feeGrowthBelow0X128;
            
            let (__warp_se_666) = warp_sub_unsafe256(__warp_usrid_17_feeGrowthGlobal0X128, __warp_usrid_23_feeGrowthBelow0X128);
            
            let (__warp_se_667) = warp_sub_unsafe256(__warp_se_666, __warp_usrid_25_feeGrowthAbove0X128);
            
            let __warp_usrid_19_feeGrowthInside0X128 = __warp_se_667;
            
            let (__warp_se_668) = warp_sub_unsafe256(__warp_usrid_18_feeGrowthGlobal1X128, __warp_usrid_24_feeGrowthBelow1X128);
            
            let (__warp_se_669) = warp_sub_unsafe256(__warp_se_668, __warp_usrid_26_feeGrowthAbove1X128);
            
            let __warp_usrid_20_feeGrowthInside1X128 = __warp_se_669;
        
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
    func update_3bf3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_27_self : felt, __warp_usrid_28_tick : felt, __warp_usrid_29_tickCurrent : felt, __warp_usrid_30_liquidityDelta : felt, __warp_usrid_31_feeGrowthGlobal0X128 : Uint256, __warp_usrid_32_feeGrowthGlobal1X128 : Uint256, __warp_usrid_33_secondsPerLiquidityCumulativeX128 : felt, __warp_usrid_34_tickCumulative : felt, __warp_usrid_35_time : felt, __warp_usrid_36_upper : felt, __warp_usrid_37_maxLiquidity : felt)-> (__warp_usrid_38_flipped : felt){
    alloc_locals;


        
        let __warp_usrid_38_flipped = 0;
        
        let (__warp_usrid_39_info) = WS0_INDEX_felt_to_Info_39bc053d(__warp_usrid_27_self, __warp_usrid_28_tick);
        
        let (__warp_se_670) = WSM16_Info_39bc053d___warp_usrid_00_liquidityGross(__warp_usrid_39_info);
        
        let (__warp_usrid_40_liquidityGrossBefore) = WS0_READ_felt(__warp_se_670);
        
        let (__warp_usrid_41_liquidityGrossAfter) = addDelta_402d44fb(__warp_usrid_40_liquidityGrossBefore, __warp_usrid_30_liquidityDelta);
        
        let (__warp_se_671) = warp_le(__warp_usrid_41_liquidityGrossAfter, __warp_usrid_37_maxLiquidity);
        
        with_attr error_message("LO"){
            assert __warp_se_671 = 1;
        }
        
        let (__warp_se_672) = warp_eq(__warp_usrid_41_liquidityGrossAfter, 0);
        
        let (__warp_se_673) = warp_eq(__warp_usrid_40_liquidityGrossBefore, 0);
        
        let (__warp_se_674) = warp_neq(__warp_se_672, __warp_se_673);
        
        let __warp_usrid_38_flipped = __warp_se_674;
        
        let (__warp_se_675) = warp_eq(__warp_usrid_40_liquidityGrossBefore, 0);
        
            
            if (__warp_se_675 != 0){
            
                
                let (__warp_se_676) = warp_le_signed24(__warp_usrid_28_tick, __warp_usrid_29_tickCurrent);
                
                    
                    if (__warp_se_676 != 0){
                    
                        
                        let (__warp_se_677) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(__warp_usrid_39_info);
                        
                        WS_WRITE1(__warp_se_677, __warp_usrid_31_feeGrowthGlobal0X128);
                        
                        let (__warp_se_678) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(__warp_usrid_39_info);
                        
                        WS_WRITE1(__warp_se_678, __warp_usrid_32_feeGrowthGlobal1X128);
                        
                        let (__warp_se_679) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(__warp_usrid_39_info);
                        
                        WS_WRITE0(__warp_se_679, __warp_usrid_33_secondsPerLiquidityCumulativeX128);
                        
                        let (__warp_se_680) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(__warp_usrid_39_info);
                        
                        WS_WRITE0(__warp_se_680, __warp_usrid_34_tickCumulative);
                        
                        let (__warp_se_681) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(__warp_usrid_39_info);
                        
                        WS_WRITE0(__warp_se_681, __warp_usrid_35_time);
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_38_flipped = __warp_usrid_38_flipped;
                        tempvar __warp_usrid_36_upper = __warp_usrid_36_upper;
                        tempvar __warp_usrid_39_info = __warp_usrid_39_info;
                        tempvar __warp_usrid_30_liquidityDelta = __warp_usrid_30_liquidityDelta;
                        tempvar __warp_usrid_41_liquidityGrossAfter = __warp_usrid_41_liquidityGrossAfter;
                    }else{
                    
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_38_flipped = __warp_usrid_38_flipped;
                        tempvar __warp_usrid_36_upper = __warp_usrid_36_upper;
                        tempvar __warp_usrid_39_info = __warp_usrid_39_info;
                        tempvar __warp_usrid_30_liquidityDelta = __warp_usrid_30_liquidityDelta;
                        tempvar __warp_usrid_41_liquidityGrossAfter = __warp_usrid_41_liquidityGrossAfter;
                    }
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_38_flipped = __warp_usrid_38_flipped;
                    tempvar __warp_usrid_36_upper = __warp_usrid_36_upper;
                    tempvar __warp_usrid_39_info = __warp_usrid_39_info;
                    tempvar __warp_usrid_30_liquidityDelta = __warp_usrid_30_liquidityDelta;
                    tempvar __warp_usrid_41_liquidityGrossAfter = __warp_usrid_41_liquidityGrossAfter;
                
                let (__warp_se_682) = WSM15_Info_39bc053d___warp_usrid_07_initialized(__warp_usrid_39_info);
                
                WS_WRITE0(__warp_se_682, 1);
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_38_flipped = __warp_usrid_38_flipped;
                tempvar __warp_usrid_36_upper = __warp_usrid_36_upper;
                tempvar __warp_usrid_39_info = __warp_usrid_39_info;
                tempvar __warp_usrid_30_liquidityDelta = __warp_usrid_30_liquidityDelta;
                tempvar __warp_usrid_41_liquidityGrossAfter = __warp_usrid_41_liquidityGrossAfter;
            }else{
            
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_38_flipped = __warp_usrid_38_flipped;
                tempvar __warp_usrid_36_upper = __warp_usrid_36_upper;
                tempvar __warp_usrid_39_info = __warp_usrid_39_info;
                tempvar __warp_usrid_30_liquidityDelta = __warp_usrid_30_liquidityDelta;
                tempvar __warp_usrid_41_liquidityGrossAfter = __warp_usrid_41_liquidityGrossAfter;
            }
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar __warp_usrid_38_flipped = __warp_usrid_38_flipped;
            tempvar __warp_usrid_36_upper = __warp_usrid_36_upper;
            tempvar __warp_usrid_39_info = __warp_usrid_39_info;
            tempvar __warp_usrid_30_liquidityDelta = __warp_usrid_30_liquidityDelta;
            tempvar __warp_usrid_41_liquidityGrossAfter = __warp_usrid_41_liquidityGrossAfter;
        
        let (__warp_se_683) = WSM16_Info_39bc053d___warp_usrid_00_liquidityGross(__warp_usrid_39_info);
        
        WS_WRITE0(__warp_se_683, __warp_usrid_41_liquidityGrossAfter);
        
            
            if (__warp_usrid_36_upper != 0){
            
                
                let (__warp_se_684) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(__warp_usrid_39_info);
                
                let (__warp_se_685) = WS0_READ_felt(__warp_se_684);
                
                let (__warp_se_686) = warp_int128_to_int256(__warp_se_685);
                
                let (__warp_se_687) = warp_int128_to_int256(__warp_usrid_30_liquidityDelta);
                
                let (__warp_pse_59) = sub_adefc37b(__warp_se_686, __warp_se_687);
                
                let (__warp_pse_60) = toInt128_dd2a0316(__warp_pse_59);
                
                let (__warp_se_688) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(__warp_usrid_39_info);
                
                WS_WRITE0(__warp_se_688, __warp_pse_60);
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_38_flipped = __warp_usrid_38_flipped;
            }else{
            
                
                let (__warp_se_689) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(__warp_usrid_39_info);
                
                let (__warp_se_690) = WS0_READ_felt(__warp_se_689);
                
                let (__warp_se_691) = warp_int128_to_int256(__warp_se_690);
                
                let (__warp_se_692) = warp_int128_to_int256(__warp_usrid_30_liquidityDelta);
                
                let (__warp_pse_61) = add_a5f3c23b(__warp_se_691, __warp_se_692);
                
                let (__warp_pse_62) = toInt128_dd2a0316(__warp_pse_61);
                
                let (__warp_se_693) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(__warp_usrid_39_info);
                
                WS_WRITE0(__warp_se_693, __warp_pse_62);
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_38_flipped = __warp_usrid_38_flipped;
            }
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar __warp_usrid_38_flipped = __warp_usrid_38_flipped;
        
        
        
        return (__warp_usrid_38_flipped,);

    }

    // @notice Clears tick data
    // @param self The mapping containing all initialized tick information for initialized ticks
    // @param tick The tick that will be cleared
    func clear_db51{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_usrid_42_self : felt, __warp_usrid_43_tick : felt)-> (){
    alloc_locals;


        
        let (__warp_se_694) = WS0_INDEX_felt_to_Info_39bc053d(__warp_usrid_42_self, __warp_usrid_43_tick);
        
        WS_STRUCT_Info_DELETE(__warp_se_694);
        
        
        
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
    func cross_5d47{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_44_self : felt, __warp_usrid_45_tick : felt, __warp_usrid_46_feeGrowthGlobal0X128 : Uint256, __warp_usrid_47_feeGrowthGlobal1X128 : Uint256, __warp_usrid_48_secondsPerLiquidityCumulativeX128 : felt, __warp_usrid_49_tickCumulative : felt, __warp_usrid_50_time : felt)-> (__warp_usrid_51_liquidityNet : felt){
    alloc_locals;


        
        let __warp_usrid_51_liquidityNet = 0;
        
            
            let (__warp_usrid_52_info) = WS0_INDEX_felt_to_Info_39bc053d(__warp_usrid_44_self, __warp_usrid_45_tick);
            
            let (__warp_se_695) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(__warp_usrid_52_info);
            
            let (__warp_se_696) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(__warp_usrid_52_info);
            
            let (__warp_se_697) = WS1_READ_Uint256(__warp_se_696);
            
            let (__warp_se_698) = warp_sub_unsafe256(__warp_usrid_46_feeGrowthGlobal0X128, __warp_se_697);
            
            WS_WRITE1(__warp_se_695, __warp_se_698);
            
            let (__warp_se_699) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(__warp_usrid_52_info);
            
            let (__warp_se_700) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(__warp_usrid_52_info);
            
            let (__warp_se_701) = WS1_READ_Uint256(__warp_se_700);
            
            let (__warp_se_702) = warp_sub_unsafe256(__warp_usrid_47_feeGrowthGlobal1X128, __warp_se_701);
            
            WS_WRITE1(__warp_se_699, __warp_se_702);
            
            let (__warp_se_703) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(__warp_usrid_52_info);
            
            let (__warp_se_704) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(__warp_usrid_52_info);
            
            let (__warp_se_705) = WS0_READ_felt(__warp_se_704);
            
            let (__warp_se_706) = warp_sub_unsafe160(__warp_usrid_48_secondsPerLiquidityCumulativeX128, __warp_se_705);
            
            WS_WRITE0(__warp_se_703, __warp_se_706);
            
            let (__warp_se_707) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(__warp_usrid_52_info);
            
            let (__warp_se_708) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(__warp_usrid_52_info);
            
            let (__warp_se_709) = WS0_READ_felt(__warp_se_708);
            
            let (__warp_se_710) = warp_sub_signed_unsafe56(__warp_usrid_49_tickCumulative, __warp_se_709);
            
            WS_WRITE0(__warp_se_707, __warp_se_710);
            
            let (__warp_se_711) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(__warp_usrid_52_info);
            
            let (__warp_se_712) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(__warp_usrid_52_info);
            
            let (__warp_se_713) = WS0_READ_felt(__warp_se_712);
            
            let (__warp_se_714) = warp_sub_unsafe32(__warp_usrid_50_time, __warp_se_713);
            
            WS_WRITE0(__warp_se_711, __warp_se_714);
            
            let (__warp_se_715) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(__warp_usrid_52_info);
            
            let (__warp_se_716) = WS0_READ_felt(__warp_se_715);
            
            let __warp_usrid_51_liquidityNet = __warp_se_716;
        
        
        
        return (__warp_usrid_51_liquidityNet,);

    }

    // @notice Add a signed liquidity delta to liquidity and revert if it overflows or underflows
    // @param x The liquidity before change
    // @param y The delta by which liquidity should be changed
    // @return z The liquidity delta
    func addDelta_402d44fb{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_x : felt, __warp_usrid_01_y : felt)-> (__warp_usrid_02_z : felt){
    alloc_locals;


        
        let __warp_usrid_02_z = 0;
        
            
            let (__warp_se_717) = warp_lt_signed128(__warp_usrid_01_y, 0);
            
                
                if (__warp_se_717 != 0){
                
                    
                    let (__warp_se_718) = warp_negate128(__warp_usrid_01_y);
                    
                    let (__warp_pse_63) = warp_sub_unsafe128(__warp_usrid_00_x, __warp_se_718);
                    
                    let __warp_usrid_02_z = __warp_pse_63;
                    
                    let (__warp_se_719) = warp_lt(__warp_pse_63, __warp_usrid_00_x);
                    
                    with_attr error_message("LS"){
                        assert __warp_se_719 = 1;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_02_z = __warp_usrid_02_z;
                }else{
                
                    
                    let (__warp_pse_64) = warp_add_unsafe128(__warp_usrid_00_x, __warp_usrid_01_y);
                    
                    let __warp_usrid_02_z = __warp_pse_64;
                    
                    let (__warp_se_720) = warp_ge(__warp_pse_64, __warp_usrid_00_x);
                    
                    with_attr error_message("LA"){
                        assert __warp_se_720 = 1;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_02_z = __warp_usrid_02_z;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_02_z = __warp_usrid_02_z;
        
        
        
        return (__warp_usrid_02_z,);

    }

    // @notice Cast a uint256 to a uint160, revert on overflow
    // @param y The uint256 to be downcasted
    // @return z The downcasted integer, now type uint160
    func toUint160_dfef6beb{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_y : Uint256)-> (__warp_usrid_01_z : felt){
    alloc_locals;


        
        let __warp_usrid_01_z = 0;
        
        let (__warp_pse_65) = warp_int256_to_int160(__warp_usrid_00_y);
        
        let __warp_usrid_01_z = __warp_pse_65;
        
        let (__warp_se_721) = warp_uint256(__warp_pse_65);
        
        let (__warp_se_722) = warp_eq256(__warp_se_721, __warp_usrid_00_y);
        
        assert __warp_se_722 = 1;
        
        
        
        return (__warp_usrid_01_z,);

    }

    // @notice Cast a int256 to a int128, revert on overflow or underflow
    // @param y The int256 to be downcasted
    // @return z The downcasted integer, now type int128
    func toInt128_dd2a0316{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_02_y : Uint256)-> (__warp_usrid_03_z : felt){
    alloc_locals;


        
        let __warp_usrid_03_z = 0;
        
        let (__warp_pse_66) = warp_int256_to_int128(__warp_usrid_02_y);
        
        let __warp_usrid_03_z = __warp_pse_66;
        
        let (__warp_se_723) = warp_int128_to_int256(__warp_pse_66);
        
        let (__warp_se_724) = warp_eq256(__warp_se_723, __warp_usrid_02_y);
        
        assert __warp_se_724 = 1;
        
        
        
        return (__warp_usrid_03_z,);

    }

    // @notice Cast a uint256 to a int256, revert on overflow
    // @param y The uint256 to be casted
    // @return z The casted integer, now type int256
    func toInt256_dfbe873b{range_check_ptr : felt}(__warp_usrid_04_y : Uint256)-> (__warp_usrid_05_z : Uint256){
    alloc_locals;


        
        let __warp_usrid_05_z = Uint256(low=0, high=0);
        
        let (__warp_se_725) = warp_lt256(__warp_usrid_04_y, Uint256(low=0, high=170141183460469231731687303715884105728));
        
        assert __warp_se_725 = 1;
        
        let __warp_usrid_05_z = __warp_usrid_04_y;
        
        
        
        return (__warp_usrid_05_z,);

    }

    // @notice Returns x + y, reverts if sum overflows uint256
    // @param x The augend
    // @param y The addend
    // @return z The sum of x and y
    func add_771602f7{range_check_ptr : felt}(__warp_usrid_00_x : Uint256, __warp_usrid_01_y : Uint256)-> (__warp_usrid_02_z : Uint256){
    alloc_locals;


        
        let __warp_usrid_02_z = Uint256(low=0, high=0);
        
            
            let (__warp_pse_67) = warp_add_unsafe256(__warp_usrid_00_x, __warp_usrid_01_y);
            
            let __warp_usrid_02_z = __warp_pse_67;
            
            let (__warp_se_726) = warp_ge256(__warp_pse_67, __warp_usrid_00_x);
            
            assert __warp_se_726 = 1;
        
        
        
        return (__warp_usrid_02_z,);

    }

    // @notice Returns x + y, reverts if overflows or underflows
    // @param x The augend
    // @param y The addend
    // @return z The sum of x and y
    func add_a5f3c23b{range_check_ptr : felt}(__warp_usrid_09_x : Uint256, __warp_usrid_10_y : Uint256)-> (__warp_usrid_11_z : Uint256){
    alloc_locals;


        
        let __warp_usrid_11_z = Uint256(low=0, high=0);
        
            
            let (__warp_pse_70) = warp_add_signed_unsafe256(__warp_usrid_09_x, __warp_usrid_10_y);
            
            let __warp_usrid_11_z = __warp_pse_70;
            
            let (__warp_se_727) = warp_ge_signed256(__warp_pse_70, __warp_usrid_09_x);
            
            let (__warp_se_728) = warp_ge_signed256(__warp_usrid_10_y, Uint256(low=0, high=0));
            
            let (__warp_se_729) = warp_eq(__warp_se_727, __warp_se_728);
            
            assert __warp_se_729 = 1;
        
        
        
        return (__warp_usrid_11_z,);

    }

    // @notice Returns x - y, reverts if overflows or underflows
    // @param x The minuend
    // @param y The subtrahend
    // @return z The difference of x and y
    func sub_adefc37b{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_12_x : Uint256, __warp_usrid_13_y : Uint256)-> (__warp_usrid_14_z : Uint256){
    alloc_locals;


        
        let __warp_usrid_14_z = Uint256(low=0, high=0);
        
            
            let (__warp_pse_71) = warp_sub_signed_unsafe256(__warp_usrid_12_x, __warp_usrid_13_y);
            
            let __warp_usrid_14_z = __warp_pse_71;
            
            let (__warp_se_730) = warp_le_signed256(__warp_pse_71, __warp_usrid_12_x);
            
            let (__warp_se_731) = warp_ge_signed256(__warp_usrid_13_y, Uint256(low=0, high=0));
            
            let (__warp_se_732) = warp_eq(__warp_se_730, __warp_se_731);
            
            assert __warp_se_732 = 1;
        
        
        
        return (__warp_usrid_14_z,);

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


        
            
            let (__warp_se_733) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_04_last);
            
            let (__warp_se_734) = wm_read_felt(__warp_se_733);
            
            let (__warp_usrid_09_delta) = warp_sub_unsafe32(__warp_usrid_05_blockTimestamp, __warp_se_734);
            
            let (__warp_pse_72) = conditional0_5bba3b34(__warp_usrid_07_liquidity);
            
            let (__warp_se_735) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_04_last);
            
            let (__warp_se_736) = wm_read_felt(__warp_se_735);
            
            let (__warp_se_737) = warp_int24_to_int56(__warp_usrid_06_tick);
            
            let (__warp_se_738) = warp_mul_signed_unsafe56(__warp_se_737, __warp_usrid_09_delta);
            
            let (__warp_se_739) = warp_add_signed_unsafe56(__warp_se_736, __warp_se_738);
            
            let (__warp_se_740) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_04_last);
            
            let (__warp_se_741) = wm_read_felt(__warp_se_740);
            
            let (__warp_se_742) = warp_shl160(__warp_usrid_09_delta, 128);
            
            let (__warp_se_743) = warp_div_unsafe(__warp_se_742, __warp_pse_72);
            
            let (__warp_se_744) = warp_add_unsafe160(__warp_se_741, __warp_se_743);
            
            let (__warp_se_745) = WM5_struct_Observation_2cc4d695(__warp_usrid_05_blockTimestamp, __warp_se_739, __warp_se_744, 1);
            
            
            
            return (__warp_se_745,);

    }


    func conditional0_5bba3b34{range_check_ptr : felt}(__warp_usrid_10_liquidity : felt)-> (__warp_usrid_11_ : felt){
    alloc_locals;


        
            
            let (__warp_se_746) = warp_gt(__warp_usrid_10_liquidity, 0);
            
            if (__warp_se_746 != 0){
            
                
                
                
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


        
            
            let (__warp_se_747) = WS0_IDX(__warp_usrid_12_self, Uint256(low=0, high=0), Uint256(low=4, high=0), Uint256(low=65535, high=0));
            
            let (__warp_se_748) = WM5_struct_Observation_2cc4d695(__warp_usrid_13_time, 0, 0, 1);
            
            wm_to_storage1(__warp_se_747, __warp_se_748);
            
            let __warp_usrid_14_cardinality = 1;
            
            let __warp_usrid_15_cardinalityNext = 1;
            
            
            
            return (__warp_usrid_14_cardinality, __warp_usrid_15_cardinalityNext);

    }


    func __warp_conditional_write_9b9fd24c_23{range_check_ptr : felt}(__warp_usrid_22_cardinalityNext : felt, __warp_usrid_21_cardinality : felt, __warp_usrid_17_index : felt)-> (__warp_rc_22 : felt, __warp_usrid_22_cardinalityNext : felt, __warp_usrid_21_cardinality : felt, __warp_usrid_17_index : felt){
    alloc_locals;


        
        let (__warp_se_749) = warp_gt(__warp_usrid_22_cardinalityNext, __warp_usrid_21_cardinality);
        
        if (__warp_se_749 != 0){
        
            
            let (__warp_se_750) = warp_sub(__warp_usrid_21_cardinality, 1);
            
            let (__warp_se_751) = warp_eq(__warp_usrid_17_index, __warp_se_750);
            
            let __warp_rc_22 = __warp_se_751;
            
            let __warp_rc_22 = __warp_rc_22;
            
            let __warp_usrid_22_cardinalityNext = __warp_usrid_22_cardinalityNext;
            
            let __warp_usrid_21_cardinality = __warp_usrid_21_cardinality;
            
            let __warp_usrid_17_index = __warp_usrid_17_index;
            
            
            
            return (__warp_rc_22, __warp_usrid_22_cardinalityNext, __warp_usrid_21_cardinality, __warp_usrid_17_index);
        }else{
        
            
            let __warp_rc_22 = 0;
            
            let __warp_rc_22 = __warp_rc_22;
            
            let __warp_usrid_22_cardinalityNext = __warp_usrid_22_cardinalityNext;
            
            let __warp_usrid_21_cardinality = __warp_usrid_21_cardinality;
            
            let __warp_usrid_17_index = __warp_usrid_17_index;
            
            
            
            return (__warp_rc_22, __warp_usrid_22_cardinalityNext, __warp_usrid_21_cardinality, __warp_usrid_17_index);
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
        
            
            let (__warp_se_752) = warp_uint256(__warp_usrid_17_index);
            
            let (__warp_se_753) = WS0_IDX(__warp_usrid_16_self, __warp_se_752, Uint256(low=4, high=0), Uint256(low=65535, high=0));
            
            let (__warp_usrid_25_last) = ws_to_memory0(__warp_se_753);
            
            let (__warp_se_754) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_25_last);
            
            let (__warp_se_755) = wm_read_felt(__warp_se_754);
            
            let (__warp_se_756) = warp_eq(__warp_se_755, __warp_usrid_18_blockTimestamp);
            
                
                if (__warp_se_756 != 0){
                
                    
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
            
            let __warp_rc_22 = 0;
            
                
                let (__warp_tv_93, __warp_tv_94, __warp_tv_95, __warp_tv_96) = __warp_conditional_write_9b9fd24c_23(__warp_usrid_22_cardinalityNext, __warp_usrid_21_cardinality, __warp_usrid_17_index);
                
                let __warp_usrid_17_index = __warp_tv_96;
                
                let __warp_usrid_21_cardinality = __warp_tv_95;
                
                let __warp_usrid_22_cardinalityNext = __warp_tv_94;
                
                let __warp_rc_22 = __warp_tv_93;
            
                
                if (__warp_rc_22 != 0){
                
                    
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
            
            let (__warp_se_757) = warp_add_unsafe16(__warp_usrid_17_index, 1);
            
            let (__warp_se_758) = warp_mod(__warp_se_757, __warp_usrid_24_cardinalityUpdated);
            
            let __warp_usrid_23_indexUpdated = __warp_se_758;
            
            let (__warp_pse_73) = transform_44108314(__warp_usrid_25_last, __warp_usrid_18_blockTimestamp, __warp_usrid_19_tick, __warp_usrid_20_liquidity);
            
            let (__warp_se_759) = warp_uint256(__warp_usrid_23_indexUpdated);
            
            let (__warp_se_760) = WS0_IDX(__warp_usrid_16_self, __warp_se_759, Uint256(low=4, high=0), Uint256(low=65535, high=0));
            
            wm_to_storage1(__warp_se_760, __warp_pse_73);
        
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


        
            
            let (__warp_se_761) = warp_gt(__warp_usrid_27_current, 0);
            
            with_attr error_message("I"){
                assert __warp_se_761 = 1;
            }
            
            let (__warp_se_762) = warp_le(__warp_usrid_28_next, __warp_usrid_27_current);
            
                
                if (__warp_se_762 != 0){
                
                    
                    
                    
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
                
                    
                    let (__warp_tv_97, __warp_tv_98, __warp_td_30) = __warp_while1(__warp_usrid_30_i, __warp_usrid_28_next, __warp_usrid_26_self);
                    
                    let __warp_tv_99 = __warp_td_30;
                    
                    let __warp_usrid_26_self = __warp_tv_99;
                    
                    let __warp_usrid_28_next = __warp_tv_98;
                    
                    let __warp_usrid_30_i = __warp_tv_97;
            
            
            
            return (__warp_usrid_28_next,);

    }


    func __warp_conditional_lte_34209030_25{range_check_ptr : felt}(__warp_usrid_32_a : felt, __warp_usrid_31_time : felt, __warp_usrid_33_b : felt)-> (__warp_rc_24 : felt, __warp_usrid_32_a : felt, __warp_usrid_31_time : felt, __warp_usrid_33_b : felt){
    alloc_locals;


        
        let (__warp_se_763) = warp_le(__warp_usrid_32_a, __warp_usrid_31_time);
        
        if (__warp_se_763 != 0){
        
            
            let (__warp_se_764) = warp_le(__warp_usrid_33_b, __warp_usrid_31_time);
            
            let __warp_rc_24 = __warp_se_764;
            
            let __warp_rc_24 = __warp_rc_24;
            
            let __warp_usrid_32_a = __warp_usrid_32_a;
            
            let __warp_usrid_31_time = __warp_usrid_31_time;
            
            let __warp_usrid_33_b = __warp_usrid_33_b;
            
            
            
            return (__warp_rc_24, __warp_usrid_32_a, __warp_usrid_31_time, __warp_usrid_33_b);
        }else{
        
            
            let __warp_rc_24 = 0;
            
            let __warp_rc_24 = __warp_rc_24;
            
            let __warp_usrid_32_a = __warp_usrid_32_a;
            
            let __warp_usrid_31_time = __warp_usrid_31_time;
            
            let __warp_usrid_33_b = __warp_usrid_33_b;
            
            
            
            return (__warp_rc_24, __warp_usrid_32_a, __warp_usrid_31_time, __warp_usrid_33_b);
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


        
            
            let __warp_rc_24 = 0;
            
                
                let (__warp_tv_100, __warp_tv_101, __warp_tv_102, __warp_tv_103) = __warp_conditional_lte_34209030_25(__warp_usrid_32_a, __warp_usrid_31_time, __warp_usrid_33_b);
                
                let __warp_usrid_33_b = __warp_tv_103;
                
                let __warp_usrid_31_time = __warp_tv_102;
                
                let __warp_usrid_32_a = __warp_tv_101;
                
                let __warp_rc_24 = __warp_tv_100;
            
                
                if (__warp_rc_24 != 0){
                
                    
                    let (__warp_se_765) = warp_le(__warp_usrid_32_a, __warp_usrid_33_b);
                    
                    
                    
                    return (__warp_se_765,);
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
            
            let (__warp_se_766) = warp_add_unsafe40(__warp_usrid_32_a, 4294967296);
            
            let (__warp_usrid_35_aAdjusted) = warp_uint256(__warp_se_766);
            
            let (__warp_se_767) = warp_gt(__warp_usrid_32_a, __warp_usrid_31_time);
            
                
                if (__warp_se_767 != 0){
                
                    
                    let (__warp_se_768) = warp_uint256(__warp_usrid_32_a);
                    
                    let __warp_usrid_35_aAdjusted = __warp_se_768;
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
            
            let (__warp_se_769) = warp_add_unsafe40(__warp_usrid_33_b, 4294967296);
            
            let (__warp_usrid_36_bAdjusted) = warp_uint256(__warp_se_769);
            
            let (__warp_se_770) = warp_gt(__warp_usrid_33_b, __warp_usrid_31_time);
            
                
                if (__warp_se_770 != 0){
                
                    
                    let (__warp_se_771) = warp_uint256(__warp_usrid_33_b);
                    
                    let __warp_usrid_36_bAdjusted = __warp_se_771;
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
            
            let (__warp_se_772) = warp_le256(__warp_usrid_35_aAdjusted, __warp_usrid_36_bAdjusted);
            
            
            
            return (__warp_se_772,);

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


        
        let (__warp_usrid_43_atOrAfter) = WM5_struct_Observation_2cc4d695(0, 0, 0, 0);
        
        let (__warp_usrid_42_beforeOrAt) = WM5_struct_Observation_2cc4d695(0, 0, 0, 0);
        
            
            let (__warp_se_773) = warp_add_unsafe16(__warp_usrid_40_index, 1);
            
            let (__warp_se_774) = warp_mod(__warp_se_773, __warp_usrid_41_cardinality);
            
            let (__warp_usrid_44_l) = warp_uint256(__warp_se_774);
            
            let (__warp_se_775) = warp_uint256(__warp_usrid_41_cardinality);
            
            let (__warp_se_776) = warp_add_unsafe256(__warp_usrid_44_l, __warp_se_775);
            
            let (__warp_usrid_45_r) = warp_sub_unsafe256(__warp_se_776, Uint256(low=1, high=0));
            
            let __warp_usrid_46_i = Uint256(low=0, high=0);
            
                
                let (__warp_tv_104, __warp_tv_105, __warp_tv_106, __warp_td_31, __warp_td_32, __warp_tv_109, __warp_td_33, __warp_tv_111, __warp_tv_112) = __warp_while2(__warp_usrid_46_i, __warp_usrid_44_l, __warp_usrid_45_r, __warp_usrid_42_beforeOrAt, __warp_usrid_37_self, __warp_usrid_41_cardinality, __warp_usrid_43_atOrAfter, __warp_usrid_38_time, __warp_usrid_39_target);
                
                let __warp_tv_107 = __warp_td_31;
                
                let __warp_tv_108 = __warp_td_32;
                
                let __warp_tv_110 = __warp_td_33;
                
                let __warp_usrid_39_target = __warp_tv_112;
                
                let __warp_usrid_38_time = __warp_tv_111;
                
                let __warp_usrid_43_atOrAfter = __warp_tv_110;
                
                let __warp_usrid_41_cardinality = __warp_tv_109;
                
                let __warp_usrid_37_self = __warp_tv_108;
                
                let __warp_usrid_42_beforeOrAt = __warp_tv_107;
                
                let __warp_usrid_45_r = __warp_tv_106;
                
                let __warp_usrid_44_l = __warp_tv_105;
                
                let __warp_usrid_46_i = __warp_tv_104;
        
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


        
        let (__warp_usrid_56_atOrAfter) = WM5_struct_Observation_2cc4d695(0, 0, 0, 0);
        
        let (__warp_usrid_55_beforeOrAt) = WM5_struct_Observation_2cc4d695(0, 0, 0, 0);
        
            
            let (__warp_se_777) = warp_uint256(__warp_usrid_52_index);
            
            let (__warp_se_778) = WS0_IDX(__warp_usrid_48_self, __warp_se_777, Uint256(low=4, high=0), Uint256(low=65535, high=0));
            
            let (__warp_se_779) = ws_to_memory0(__warp_se_778);
            
            let __warp_usrid_55_beforeOrAt = __warp_se_779;
            
            let (__warp_se_780) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_55_beforeOrAt);
            
            let (__warp_se_781) = wm_read_felt(__warp_se_780);
            
            let (__warp_pse_74) = lte_34209030(__warp_usrid_49_time, __warp_se_781, __warp_usrid_50_target);
            
                
                if (__warp_pse_74 != 0){
                
                    
                    let (__warp_se_782) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_55_beforeOrAt);
                    
                    let (__warp_se_783) = wm_read_felt(__warp_se_782);
                    
                    let (__warp_se_784) = warp_eq(__warp_se_783, __warp_usrid_50_target);
                    
                    if (__warp_se_784 != 0){
                    
                        
                        let __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;
                        
                        let __warp_usrid_56_atOrAfter = __warp_usrid_56_atOrAfter;
                        
                        
                        
                        return (__warp_usrid_55_beforeOrAt, __warp_usrid_56_atOrAfter);
                    }else{
                    
                        
                        let (__warp_pse_75) = transform_44108314(__warp_usrid_55_beforeOrAt, __warp_usrid_50_target, __warp_usrid_51_tick, __warp_usrid_53_liquidity);
                        
                        let __warp_usrid_55_beforeOrAt = __warp_usrid_55_beforeOrAt;
                        
                        let __warp_usrid_56_atOrAfter = __warp_pse_75;
                        
                        
                        
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
            
            let (__warp_se_785) = warp_add_unsafe16(__warp_usrid_52_index, 1);
            
            let (__warp_se_786) = warp_mod(__warp_se_785, __warp_usrid_54_cardinality);
            
            let (__warp_se_787) = warp_uint256(__warp_se_786);
            
            let (__warp_se_788) = WS0_IDX(__warp_usrid_48_self, __warp_se_787, Uint256(low=4, high=0), Uint256(low=65535, high=0));
            
            let (__warp_se_789) = ws_to_memory0(__warp_se_788);
            
            let __warp_usrid_55_beforeOrAt = __warp_se_789;
            
            let (__warp_se_790) = WM1_Observation_2cc4d695___warp_usrid_03_initialized(__warp_usrid_55_beforeOrAt);
            
            let (__warp_se_791) = wm_read_felt(__warp_se_790);
            
                
                if (1 - __warp_se_791 != 0){
                
                    
                    let (__warp_se_792) = WS0_IDX(__warp_usrid_48_self, Uint256(low=0, high=0), Uint256(low=4, high=0), Uint256(low=65535, high=0));
                    
                    let (__warp_se_793) = ws_to_memory0(__warp_se_792);
                    
                    let __warp_usrid_55_beforeOrAt = __warp_se_793;
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
            
            let (__warp_se_794) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_55_beforeOrAt);
            
            let (__warp_se_795) = wm_read_felt(__warp_se_794);
            
            let (__warp_pse_76) = lte_34209030(__warp_usrid_49_time, __warp_se_795, __warp_usrid_50_target);
            
            with_attr error_message("OLD"){
                assert __warp_pse_76 = 1;
            }
            
            let (__warp_td_34, __warp_td_35) = binarySearch_c698fcdd(__warp_usrid_48_self, __warp_usrid_49_time, __warp_usrid_50_target, __warp_usrid_52_index, __warp_usrid_54_cardinality);
            
            let __warp_usrid_55_beforeOrAt = __warp_td_34;
            
            let __warp_usrid_56_atOrAfter = __warp_td_35;
            
            
            
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


        
            
            let (__warp_se_796) = warp_eq(__warp_usrid_59_secondsAgo, 0);
            
                
                if (__warp_se_796 != 0){
                
                    
                    let (__warp_se_797) = warp_uint256(__warp_usrid_61_index);
                    
                    let (__warp_se_798) = WS0_IDX(__warp_usrid_57_self, __warp_se_797, Uint256(low=4, high=0), Uint256(low=65535, high=0));
                    
                    let (__warp_usrid_66_last) = ws_to_memory0(__warp_se_798);
                    
                    let (__warp_se_799) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_66_last);
                    
                    let (__warp_se_800) = wm_read_felt(__warp_se_799);
                    
                    let (__warp_se_801) = warp_neq(__warp_se_800, __warp_usrid_58_time);
                    
                        
                        if (__warp_se_801 != 0){
                        
                            
                            let (__warp_pse_77) = transform_44108314(__warp_usrid_66_last, __warp_usrid_58_time, __warp_usrid_60_tick, __warp_usrid_62_liquidity);
                            
                            let __warp_usrid_66_last = __warp_pse_77;
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
                    
                    let (__warp_se_802) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_66_last);
                    
                    let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_802);
                    
                    let (__warp_se_803) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_66_last);
                    
                    let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(__warp_se_803);
                    
                    
                    
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
            
            let (__warp_td_36, __warp_td_37) = getSurroundingObservations_68850d1b(__warp_usrid_57_self, __warp_usrid_58_time, __warp_usrid_67_target, __warp_usrid_60_tick, __warp_usrid_61_index, __warp_usrid_62_liquidity, __warp_usrid_63_cardinality);
            
            let __warp_usrid_68_beforeOrAt = __warp_td_36;
            
            let __warp_usrid_69_atOrAfter = __warp_td_37;
            
            let (__warp_se_804) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_68_beforeOrAt);
            
            let (__warp_se_805) = wm_read_felt(__warp_se_804);
            
            let (__warp_se_806) = warp_eq(__warp_usrid_67_target, __warp_se_805);
            
            if (__warp_se_806 != 0){
            
                
                let (__warp_se_807) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_68_beforeOrAt);
                
                let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_807);
                
                let (__warp_se_808) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_68_beforeOrAt);
                
                let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(__warp_se_808);
                
                
                
                return (__warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128);
            }else{
            
                
                let (__warp_se_809) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_69_atOrAfter);
                
                let (__warp_se_810) = wm_read_felt(__warp_se_809);
                
                let (__warp_se_811) = warp_eq(__warp_usrid_67_target, __warp_se_810);
                
                if (__warp_se_811 != 0){
                
                    
                    let (__warp_se_812) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_69_atOrAfter);
                    
                    let (__warp_usrid_64_tickCumulative) = wm_read_felt(__warp_se_812);
                    
                    let (__warp_se_813) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_69_atOrAfter);
                    
                    let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = wm_read_felt(__warp_se_813);
                    
                    
                    
                    return (__warp_usrid_64_tickCumulative, __warp_usrid_65_secondsPerLiquidityCumulativeX128);
                }else{
                
                    
                    let (__warp_se_814) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_69_atOrAfter);
                    
                    let (__warp_se_815) = wm_read_felt(__warp_se_814);
                    
                    let (__warp_se_816) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_817) = wm_read_felt(__warp_se_816);
                    
                    let (__warp_usrid_70_observationTimeDelta) = warp_sub_unsafe32(__warp_se_815, __warp_se_817);
                    
                    let (__warp_se_818) = WM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_819) = wm_read_felt(__warp_se_818);
                    
                    let (__warp_usrid_71_targetDelta) = warp_sub_unsafe32(__warp_usrid_67_target, __warp_se_819);
                    
                    let (__warp_se_820) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_821) = wm_read_felt(__warp_se_820);
                    
                    let (__warp_se_822) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_69_atOrAfter);
                    
                    let (__warp_se_823) = wm_read_felt(__warp_se_822);
                    
                    let (__warp_se_824) = WM33_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_825) = wm_read_felt(__warp_se_824);
                    
                    let (__warp_se_826) = warp_sub_signed_unsafe56(__warp_se_823, __warp_se_825);
                    
                    let (__warp_se_827) = warp_int32_to_int56(__warp_usrid_70_observationTimeDelta);
                    
                    let (__warp_se_828) = warp_div_signed_unsafe56(__warp_se_826, __warp_se_827);
                    
                    let (__warp_se_829) = warp_int32_to_int56(__warp_usrid_71_targetDelta);
                    
                    let (__warp_se_830) = warp_mul_signed_unsafe56(__warp_se_828, __warp_se_829);
                    
                    let (__warp_usrid_64_tickCumulative) = warp_add_signed_unsafe56(__warp_se_821, __warp_se_830);
                    
                    let (__warp_se_831) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_832) = wm_read_felt(__warp_se_831);
                    
                    let (__warp_se_833) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_69_atOrAfter);
                    
                    let (__warp_se_834) = wm_read_felt(__warp_se_833);
                    
                    let (__warp_se_835) = WM34_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_68_beforeOrAt);
                    
                    let (__warp_se_836) = wm_read_felt(__warp_se_835);
                    
                    let (__warp_se_837) = warp_sub_unsafe160(__warp_se_834, __warp_se_836);
                    
                    let (__warp_se_838) = warp_uint256(__warp_se_837);
                    
                    let (__warp_se_839) = warp_uint256(__warp_usrid_71_targetDelta);
                    
                    let (__warp_se_840) = warp_mul_unsafe256(__warp_se_838, __warp_se_839);
                    
                    let (__warp_se_841) = warp_uint256(__warp_usrid_70_observationTimeDelta);
                    
                    let (__warp_se_842) = warp_div_unsafe256(__warp_se_840, __warp_se_841);
                    
                    let (__warp_se_843) = warp_int256_to_int160(__warp_se_842);
                    
                    let (__warp_usrid_65_secondsPerLiquidityCumulativeX128) = warp_add_unsafe160(__warp_se_832, __warp_se_843);
                    
                    
                    
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
        
            
            let (__warp_se_844) = warp_gt(__warp_usrid_78_cardinality, 0);
            
            with_attr error_message("I"){
                assert __warp_se_844 = 1;
            }
            
            let (__warp_se_845) = wm_dyn_array_length(__warp_usrid_74_secondsAgos);
            
            let (__warp_se_846) = wm_new(__warp_se_845, Uint256(low=1, high=0));
            
            let __warp_usrid_79_tickCumulatives = __warp_se_846;
            
            let (__warp_se_847) = wm_dyn_array_length(__warp_usrid_74_secondsAgos);
            
            let (__warp_se_848) = wm_new(__warp_se_847, Uint256(low=1, high=0));
            
            let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_se_848;
            
                
                let __warp_usrid_81_i = Uint256(low=0, high=0);
                
                    
                    let (__warp_tv_113, __warp_td_38, __warp_td_39, __warp_td_40, __warp_td_41, __warp_tv_118, __warp_tv_119, __warp_tv_120, __warp_tv_121, __warp_tv_122) = __warp_while3(__warp_usrid_81_i, __warp_usrid_74_secondsAgos, __warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s, __warp_usrid_72_self, __warp_usrid_73_time, __warp_usrid_75_tick, __warp_usrid_76_index, __warp_usrid_77_liquidity, __warp_usrid_78_cardinality);
                    
                    let __warp_tv_114 = __warp_td_38;
                    
                    let __warp_tv_115 = __warp_td_39;
                    
                    let __warp_tv_116 = __warp_td_40;
                    
                    let __warp_tv_117 = __warp_td_41;
                    
                    let __warp_usrid_78_cardinality = __warp_tv_122;
                    
                    let __warp_usrid_77_liquidity = __warp_tv_121;
                    
                    let __warp_usrid_76_index = __warp_tv_120;
                    
                    let __warp_usrid_75_tick = __warp_tv_119;
                    
                    let __warp_usrid_73_time = __warp_tv_118;
                    
                    let __warp_usrid_72_self = __warp_tv_117;
                    
                    let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_tv_116;
                    
                    let __warp_usrid_79_tickCumulatives = __warp_tv_115;
                    
                    let __warp_usrid_74_secondsAgos = __warp_tv_114;
                    
                    let __warp_usrid_81_i = __warp_tv_113;
        
        let __warp_usrid_79_tickCumulatives = __warp_usrid_79_tickCumulatives;
        
        let __warp_usrid_80_secondsPerLiquidityCumulativeX128s = __warp_usrid_80_secondsPerLiquidityCumulativeX128s;
        
        
        
        return (__warp_usrid_79_tickCumulatives, __warp_usrid_80_secondsPerLiquidityCumulativeX128s);

    }

    // @notice Calculates sqrt(1.0001^tick) * 2^96
    // @dev Throws if |tick| > max tick
    // @param tick The input tick for the above formula
    // @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
    // at the given tick
    func getSqrtRatioAtTick_986cfba3{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_04_tick : felt)-> (__warp_usrid_05_sqrtPriceX96 : felt){
    alloc_locals;


        
        let __warp_usrid_05_sqrtPriceX96 = 0;
        
            
            let __warp_usrid_06_absTick = Uint256(low=0, high=0);
            
            let (__warp_se_849) = warp_lt_signed24(__warp_usrid_04_tick, 0);
            
                
                if (__warp_se_849 != 0){
                
                    
                    let (__warp_se_850) = warp_int24_to_int256(__warp_usrid_04_tick);
                    
                    let (__warp_se_851) = warp_negate256(__warp_se_850);
                    
                    let __warp_usrid_06_absTick = __warp_se_851;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                    tempvar __warp_usrid_04_tick = __warp_usrid_04_tick;
                    tempvar __warp_usrid_06_absTick = __warp_usrid_06_absTick;
                }else{
                
                    
                    let (__warp_se_852) = warp_int24_to_int256(__warp_usrid_04_tick);
                    
                    let __warp_usrid_06_absTick = __warp_se_852;
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
            
            let (__warp_se_853) = warp_uint256(887272);
            
            let (__warp_se_854) = warp_le256(__warp_usrid_06_absTick, __warp_se_853);
            
            with_attr error_message("T"){
                assert __warp_se_854 = 1;
            }
            
            let __warp_usrid_07_ratio = Uint256(low=0, high=1);
            
            let (__warp_se_855) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=1, high=0));
            
            let (__warp_se_856) = warp_neq256(__warp_se_855, Uint256(low=0, high=0));
            
                
                if (__warp_se_856 != 0){
                
                    
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
            
            let (__warp_se_857) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=2, high=0));
            
            let (__warp_se_858) = warp_neq256(__warp_se_857, Uint256(low=0, high=0));
            
                
                if (__warp_se_858 != 0){
                
                    
                    let (__warp_se_859) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=340248342086729790484326174814286782778, high=0));
                    
                    let (__warp_se_860) = warp_shr256(__warp_se_859, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_860;
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
            
            let (__warp_se_861) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=4, high=0));
            
            let (__warp_se_862) = warp_neq256(__warp_se_861, Uint256(low=0, high=0));
            
                
                if (__warp_se_862 != 0){
                
                    
                    let (__warp_se_863) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=340214320654664324051920982716015181260, high=0));
                    
                    let (__warp_se_864) = warp_shr256(__warp_se_863, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_864;
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
            
            let (__warp_se_865) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=8, high=0));
            
            let (__warp_se_866) = warp_neq256(__warp_se_865, Uint256(low=0, high=0));
            
                
                if (__warp_se_866 != 0){
                
                    
                    let (__warp_se_867) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=340146287995602323631171512101879684304, high=0));
                    
                    let (__warp_se_868) = warp_shr256(__warp_se_867, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_868;
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
            
            let (__warp_se_869) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=16, high=0));
            
            let (__warp_se_870) = warp_neq256(__warp_se_869, Uint256(low=0, high=0));
            
                
                if (__warp_se_870 != 0){
                
                    
                    let (__warp_se_871) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=340010263488231146823593991679159461444, high=0));
                    
                    let (__warp_se_872) = warp_shr256(__warp_se_871, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_872;
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
            
            let (__warp_se_873) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=32, high=0));
            
            let (__warp_se_874) = warp_neq256(__warp_se_873, Uint256(low=0, high=0));
            
                
                if (__warp_se_874 != 0){
                
                    
                    let (__warp_se_875) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=339738377640345403697157401104375502016, high=0));
                    
                    let (__warp_se_876) = warp_shr256(__warp_se_875, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_876;
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
            
            let (__warp_se_877) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=64, high=0));
            
            let (__warp_se_878) = warp_neq256(__warp_se_877, Uint256(low=0, high=0));
            
                
                if (__warp_se_878 != 0){
                
                    
                    let (__warp_se_879) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=339195258003219555707034227454543997025, high=0));
                    
                    let (__warp_se_880) = warp_shr256(__warp_se_879, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_880;
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
            
            let (__warp_se_881) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=128, high=0));
            
            let (__warp_se_882) = warp_neq256(__warp_se_881, Uint256(low=0, high=0));
            
                
                if (__warp_se_882 != 0){
                
                    
                    let (__warp_se_883) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=338111622100601834656805679988414885971, high=0));
                    
                    let (__warp_se_884) = warp_shr256(__warp_se_883, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_884;
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
            
            let (__warp_se_885) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=256, high=0));
            
            let (__warp_se_886) = warp_neq256(__warp_se_885, Uint256(low=0, high=0));
            
                
                if (__warp_se_886 != 0){
                
                    
                    let (__warp_se_887) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=335954724994790223023589805789778977700, high=0));
                    
                    let (__warp_se_888) = warp_shr256(__warp_se_887, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_888;
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
            
            let (__warp_se_889) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=512, high=0));
            
            let (__warp_se_890) = warp_neq256(__warp_se_889, Uint256(low=0, high=0));
            
                
                if (__warp_se_890 != 0){
                
                    
                    let (__warp_se_891) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=331682121138379247127172139078559817300, high=0));
                    
                    let (__warp_se_892) = warp_shr256(__warp_se_891, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_892;
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
            
            let (__warp_se_893) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=1024, high=0));
            
            let (__warp_se_894) = warp_neq256(__warp_se_893, Uint256(low=0, high=0));
            
                
                if (__warp_se_894 != 0){
                
                    
                    let (__warp_se_895) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=323299236684853023288211250268160618739, high=0));
                    
                    let (__warp_se_896) = warp_shr256(__warp_se_895, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_896;
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
            
            let (__warp_se_897) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=2048, high=0));
            
            let (__warp_se_898) = warp_neq256(__warp_se_897, Uint256(low=0, high=0));
            
                
                if (__warp_se_898 != 0){
                
                    
                    let (__warp_se_899) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=307163716377032989948697243942600083929, high=0));
                    
                    let (__warp_se_900) = warp_shr256(__warp_se_899, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_900;
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
            
            let (__warp_se_901) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=4096, high=0));
            
            let (__warp_se_902) = warp_neq256(__warp_se_901, Uint256(low=0, high=0));
            
                
                if (__warp_se_902 != 0){
                
                    
                    let (__warp_se_903) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=277268403626896220162999269216087595045, high=0));
                    
                    let (__warp_se_904) = warp_shr256(__warp_se_903, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_904;
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
            
            let (__warp_se_905) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=8192, high=0));
            
            let (__warp_se_906) = warp_neq256(__warp_se_905, Uint256(low=0, high=0));
            
                
                if (__warp_se_906 != 0){
                
                    
                    let (__warp_se_907) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=225923453940442621947126027127485391333, high=0));
                    
                    let (__warp_se_908) = warp_shr256(__warp_se_907, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_908;
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
            
            let (__warp_se_909) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=16384, high=0));
            
            let (__warp_se_910) = warp_neq256(__warp_se_909, Uint256(low=0, high=0));
            
                
                if (__warp_se_910 != 0){
                
                    
                    let (__warp_se_911) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=149997214084966997727330242082538205943, high=0));
                    
                    let (__warp_se_912) = warp_shr256(__warp_se_911, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_912;
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
            
            let (__warp_se_913) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=32768, high=0));
            
            let (__warp_se_914) = warp_neq256(__warp_se_913, Uint256(low=0, high=0));
            
                
                if (__warp_se_914 != 0){
                
                    
                    let (__warp_se_915) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=66119101136024775622716233608466517926, high=0));
                    
                    let (__warp_se_916) = warp_shr256(__warp_se_915, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_916;
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
            
            let (__warp_se_917) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=65536, high=0));
            
            let (__warp_se_918) = warp_neq256(__warp_se_917, Uint256(low=0, high=0));
            
                
                if (__warp_se_918 != 0){
                
                    
                    let (__warp_se_919) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=12847376061809297530290974190478138313, high=0));
                    
                    let (__warp_se_920) = warp_shr256(__warp_se_919, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_920;
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
            
            let (__warp_se_921) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=131072, high=0));
            
            let (__warp_se_922) = warp_neq256(__warp_se_921, Uint256(low=0, high=0));
            
                
                if (__warp_se_922 != 0){
                
                    
                    let (__warp_se_923) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=485053260817066172746253684029974020, high=0));
                    
                    let (__warp_se_924) = warp_shr256(__warp_se_923, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_924;
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
            
            let (__warp_se_925) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=262144, high=0));
            
            let (__warp_se_926) = warp_neq256(__warp_se_925, Uint256(low=0, high=0));
            
                
                if (__warp_se_926 != 0){
                
                    
                    let (__warp_se_927) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=691415978906521570653435304214168, high=0));
                    
                    let (__warp_se_928) = warp_shr256(__warp_se_927, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_928;
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
            
            let (__warp_se_929) = warp_bitwise_and256(__warp_usrid_06_absTick, Uint256(low=524288, high=0));
            
            let (__warp_se_930) = warp_neq256(__warp_se_929, Uint256(low=0, high=0));
            
                
                if (__warp_se_930 != 0){
                
                    
                    let (__warp_se_931) = warp_mul_unsafe256(__warp_usrid_07_ratio, Uint256(low=1404880482679654955896180642, high=0));
                    
                    let (__warp_se_932) = warp_shr256(__warp_se_931, 128);
                    
                    let __warp_usrid_07_ratio = __warp_se_932;
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
            
            let (__warp_se_933) = warp_gt_signed24(__warp_usrid_04_tick, 0);
            
                
                if (__warp_se_933 != 0){
                
                    
                    let (__warp_se_934) = warp_div_unsafe256(Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455), __warp_usrid_07_ratio);
                    
                    let __warp_usrid_07_ratio = __warp_se_934;
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
            
            let (__warp_se_935) = warp_mod256(__warp_usrid_07_ratio, Uint256(low=4294967296, high=0));
            
            let (__warp_se_936) = warp_eq256(__warp_se_935, Uint256(low=0, high=0));
            
                
                if (__warp_se_936 != 0){
                
                    
                    let (__warp_se_937) = warp_shr256(__warp_usrid_07_ratio, 32);
                    
                    let (__warp_se_938) = warp_int256_to_int160(__warp_se_937);
                    
                    let __warp_usrid_05_sqrtPriceX96 = __warp_se_938;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                }else{
                
                    
                    let (__warp_se_939) = warp_shr256(__warp_usrid_07_ratio, 32);
                    
                    let (__warp_se_940) = warp_add_unsafe256(__warp_se_939, Uint256(low=1, high=0));
                    
                    let (__warp_se_941) = warp_int256_to_int160(__warp_se_940);
                    
                    let __warp_usrid_05_sqrtPriceX96 = __warp_se_941;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_05_sqrtPriceX96 = __warp_usrid_05_sqrtPriceX96;
        
        
        
        return (__warp_usrid_05_sqrtPriceX96,);

    }


    func __warp_conditional_getTickAtSqrtRatio_4f76c058_27{range_check_ptr : felt}(__warp_usrid_08_sqrtPriceX96 : felt)-> (__warp_rc_26 : felt, __warp_usrid_08_sqrtPriceX96 : felt){
    alloc_locals;


        
        let (__warp_se_942) = warp_ge(__warp_usrid_08_sqrtPriceX96, 4295128739);
        
        if (__warp_se_942 != 0){
        
            
            let (__warp_se_943) = warp_lt(__warp_usrid_08_sqrtPriceX96, 1461446703485210103287273052203988822378723970342);
            
            let __warp_rc_26 = __warp_se_943;
            
            let __warp_rc_26 = __warp_rc_26;
            
            let __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
            
            
            
            return (__warp_rc_26, __warp_usrid_08_sqrtPriceX96);
        }else{
        
            
            let __warp_rc_26 = 0;
            
            let __warp_rc_26 = __warp_rc_26;
            
            let __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
            
            
            
            return (__warp_rc_26, __warp_usrid_08_sqrtPriceX96);
        }

    }

    // @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
    // @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
    // ever return.
    // @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
    // @return tick The greatest tick for which the ratio is less than or equal to the input ratio
    func getTickAtSqrtRatio_4f76c058{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_08_sqrtPriceX96 : felt)-> (__warp_usrid_09_tick : felt){
    alloc_locals;


        
        let __warp_usrid_09_tick = 0;
        
            
            let __warp_rc_26 = 0;
            
                
                let (__warp_tv_123, __warp_tv_124) = __warp_conditional_getTickAtSqrtRatio_4f76c058_27(__warp_usrid_08_sqrtPriceX96);
                
                let __warp_usrid_08_sqrtPriceX96 = __warp_tv_124;
                
                let __warp_rc_26 = __warp_tv_123;
            
            with_attr error_message("R"){
                assert __warp_rc_26 = 1;
            }
            
            let (__warp_se_944) = warp_uint256(__warp_usrid_08_sqrtPriceX96);
            
            let (__warp_usrid_10_ratio) = warp_shl256(__warp_se_944, 32);
            
            let __warp_usrid_11_r = __warp_usrid_10_ratio;
            
            let __warp_usrid_12_msb = Uint256(low=0, high=0);
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_945) = warp_gt256(__warp_usrid_11_r, Uint256(low=340282366920938463463374607431768211455, high=0));
            
                
                if (__warp_se_945 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=128, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_946) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_946;
            
            let (__warp_se_947) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_947;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_948) = warp_gt256(__warp_usrid_11_r, Uint256(low=18446744073709551615, high=0));
            
                
                if (__warp_se_948 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=64, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_949) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_949;
            
            let (__warp_se_950) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_950;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_951) = warp_gt256(__warp_usrid_11_r, Uint256(low=4294967295, high=0));
            
                
                if (__warp_se_951 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=32, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_952) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_952;
            
            let (__warp_se_953) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_953;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_954) = warp_gt256(__warp_usrid_11_r, Uint256(low=65535, high=0));
            
                
                if (__warp_se_954 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=16, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_955) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_955;
            
            let (__warp_se_956) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_956;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_957) = warp_gt256(__warp_usrid_11_r, Uint256(low=255, high=0));
            
                
                if (__warp_se_957 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=8, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_958) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_958;
            
            let (__warp_se_959) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_959;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_960) = warp_gt256(__warp_usrid_11_r, Uint256(low=15, high=0));
            
                
                if (__warp_se_960 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=4, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_961) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_961;
            
            let (__warp_se_962) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_962;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_963) = warp_gt256(__warp_usrid_11_r, Uint256(low=3, high=0));
            
                
                if (__warp_se_963 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=2, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_964) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_964;
            
            let (__warp_se_965) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_965;
            
            let __warp_usrid_13_f = Uint256(low=0, high=0);
            
            let (__warp_se_966) = warp_gt256(__warp_usrid_11_r, Uint256(low=1, high=0));
            
                
                if (__warp_se_966 != 0){
                
                    
                    let __warp_usrid_13_f = Uint256(low=1, high=0);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                    tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                tempvar __warp_usrid_10_ratio = __warp_usrid_10_ratio;
            
            let (__warp_se_967) = warp_bitwise_or256(__warp_usrid_12_msb, __warp_usrid_13_f);
            
            let __warp_usrid_12_msb = __warp_se_967;
            
            let (__warp_se_968) = warp_ge256(__warp_usrid_12_msb, Uint256(low=128, high=0));
            
                
                if (__warp_se_968 != 0){
                
                    
                    let (__warp_se_969) = warp_sub_unsafe256(__warp_usrid_12_msb, Uint256(low=127, high=0));
                    
                    let (__warp_se_970) = warp_shr256_256(__warp_usrid_10_ratio, __warp_se_969);
                    
                    let __warp_usrid_11_r = __warp_se_970;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                }else{
                
                    
                    let (__warp_se_971) = warp_sub_unsafe256(Uint256(low=127, high=0), __warp_usrid_12_msb);
                    
                    let (__warp_se_972) = warp_shl256_256(__warp_usrid_10_ratio, __warp_se_971);
                    
                    let __warp_usrid_11_r = __warp_se_972;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                    tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                    tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                    tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                tempvar __warp_usrid_08_sqrtPriceX96 = __warp_usrid_08_sqrtPriceX96;
                tempvar __warp_usrid_11_r = __warp_usrid_11_r;
                tempvar __warp_usrid_13_f = __warp_usrid_13_f;
                tempvar __warp_usrid_12_msb = __warp_usrid_12_msb;
            
            let (__warp_se_973) = warp_sub_signed_unsafe256(__warp_usrid_12_msb, Uint256(low=128, high=0));
            
            let (__warp_usrid_14_log_2) = warp_shl256(__warp_se_973, 64);
            
            let (__warp_se_974) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_975) = warp_shr256(__warp_se_974, 127);
            
            let __warp_usrid_11_r = __warp_se_975;
            
            let (__warp_se_976) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_976;
            
            let (__warp_se_977) = warp_shl256(__warp_usrid_13_f, 63);
            
            let (__warp_se_978) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_977);
            
            let __warp_usrid_14_log_2 = __warp_se_978;
            
            let (__warp_se_979) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_979;
            
            let (__warp_se_980) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_981) = warp_shr256(__warp_se_980, 127);
            
            let __warp_usrid_11_r = __warp_se_981;
            
            let (__warp_se_982) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_982;
            
            let (__warp_se_983) = warp_shl256(__warp_usrid_13_f, 62);
            
            let (__warp_se_984) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_983);
            
            let __warp_usrid_14_log_2 = __warp_se_984;
            
            let (__warp_se_985) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_985;
            
            let (__warp_se_986) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_987) = warp_shr256(__warp_se_986, 127);
            
            let __warp_usrid_11_r = __warp_se_987;
            
            let (__warp_se_988) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_988;
            
            let (__warp_se_989) = warp_shl256(__warp_usrid_13_f, 61);
            
            let (__warp_se_990) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_989);
            
            let __warp_usrid_14_log_2 = __warp_se_990;
            
            let (__warp_se_991) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_991;
            
            let (__warp_se_992) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_993) = warp_shr256(__warp_se_992, 127);
            
            let __warp_usrid_11_r = __warp_se_993;
            
            let (__warp_se_994) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_994;
            
            let (__warp_se_995) = warp_shl256(__warp_usrid_13_f, 60);
            
            let (__warp_se_996) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_995);
            
            let __warp_usrid_14_log_2 = __warp_se_996;
            
            let (__warp_se_997) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_997;
            
            let (__warp_se_998) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_999) = warp_shr256(__warp_se_998, 127);
            
            let __warp_usrid_11_r = __warp_se_999;
            
            let (__warp_se_1000) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_1000;
            
            let (__warp_se_1001) = warp_shl256(__warp_usrid_13_f, 59);
            
            let (__warp_se_1002) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1001);
            
            let __warp_usrid_14_log_2 = __warp_se_1002;
            
            let (__warp_se_1003) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_1003;
            
            let (__warp_se_1004) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_1005) = warp_shr256(__warp_se_1004, 127);
            
            let __warp_usrid_11_r = __warp_se_1005;
            
            let (__warp_se_1006) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_1006;
            
            let (__warp_se_1007) = warp_shl256(__warp_usrid_13_f, 58);
            
            let (__warp_se_1008) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1007);
            
            let __warp_usrid_14_log_2 = __warp_se_1008;
            
            let (__warp_se_1009) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_1009;
            
            let (__warp_se_1010) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_1011) = warp_shr256(__warp_se_1010, 127);
            
            let __warp_usrid_11_r = __warp_se_1011;
            
            let (__warp_se_1012) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_1012;
            
            let (__warp_se_1013) = warp_shl256(__warp_usrid_13_f, 57);
            
            let (__warp_se_1014) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1013);
            
            let __warp_usrid_14_log_2 = __warp_se_1014;
            
            let (__warp_se_1015) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_1015;
            
            let (__warp_se_1016) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_1017) = warp_shr256(__warp_se_1016, 127);
            
            let __warp_usrid_11_r = __warp_se_1017;
            
            let (__warp_se_1018) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_1018;
            
            let (__warp_se_1019) = warp_shl256(__warp_usrid_13_f, 56);
            
            let (__warp_se_1020) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1019);
            
            let __warp_usrid_14_log_2 = __warp_se_1020;
            
            let (__warp_se_1021) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_1021;
            
            let (__warp_se_1022) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_1023) = warp_shr256(__warp_se_1022, 127);
            
            let __warp_usrid_11_r = __warp_se_1023;
            
            let (__warp_se_1024) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_1024;
            
            let (__warp_se_1025) = warp_shl256(__warp_usrid_13_f, 55);
            
            let (__warp_se_1026) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1025);
            
            let __warp_usrid_14_log_2 = __warp_se_1026;
            
            let (__warp_se_1027) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_1027;
            
            let (__warp_se_1028) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_1029) = warp_shr256(__warp_se_1028, 127);
            
            let __warp_usrid_11_r = __warp_se_1029;
            
            let (__warp_se_1030) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_1030;
            
            let (__warp_se_1031) = warp_shl256(__warp_usrid_13_f, 54);
            
            let (__warp_se_1032) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1031);
            
            let __warp_usrid_14_log_2 = __warp_se_1032;
            
            let (__warp_se_1033) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_1033;
            
            let (__warp_se_1034) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_1035) = warp_shr256(__warp_se_1034, 127);
            
            let __warp_usrid_11_r = __warp_se_1035;
            
            let (__warp_se_1036) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_1036;
            
            let (__warp_se_1037) = warp_shl256(__warp_usrid_13_f, 53);
            
            let (__warp_se_1038) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1037);
            
            let __warp_usrid_14_log_2 = __warp_se_1038;
            
            let (__warp_se_1039) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_1039;
            
            let (__warp_se_1040) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_1041) = warp_shr256(__warp_se_1040, 127);
            
            let __warp_usrid_11_r = __warp_se_1041;
            
            let (__warp_se_1042) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_1042;
            
            let (__warp_se_1043) = warp_shl256(__warp_usrid_13_f, 52);
            
            let (__warp_se_1044) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1043);
            
            let __warp_usrid_14_log_2 = __warp_se_1044;
            
            let (__warp_se_1045) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_1045;
            
            let (__warp_se_1046) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_1047) = warp_shr256(__warp_se_1046, 127);
            
            let __warp_usrid_11_r = __warp_se_1047;
            
            let (__warp_se_1048) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_1048;
            
            let (__warp_se_1049) = warp_shl256(__warp_usrid_13_f, 51);
            
            let (__warp_se_1050) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1049);
            
            let __warp_usrid_14_log_2 = __warp_se_1050;
            
            let (__warp_se_1051) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_1051;
            
            let (__warp_se_1052) = warp_mul_unsafe256(__warp_usrid_11_r, __warp_usrid_11_r);
            
            let (__warp_se_1053) = warp_shr256(__warp_se_1052, 127);
            
            let __warp_usrid_11_r = __warp_se_1053;
            
            let (__warp_se_1054) = warp_shr256(__warp_usrid_11_r, 128);
            
            let __warp_usrid_13_f = __warp_se_1054;
            
            let (__warp_se_1055) = warp_shl256(__warp_usrid_13_f, 50);
            
            let (__warp_se_1056) = warp_bitwise_or256(__warp_usrid_14_log_2, __warp_se_1055);
            
            let __warp_usrid_14_log_2 = __warp_se_1056;
            
            let (__warp_se_1057) = warp_shr256_256(__warp_usrid_11_r, __warp_usrid_13_f);
            
            let __warp_usrid_11_r = __warp_se_1057;
            
            let (__warp_usrid_15_log_sqrt10001) = warp_mul_signed_unsafe256(__warp_usrid_14_log_2, Uint256(low=255738958999603826347141, high=0));
            
            let (__warp_se_1058) = warp_sub_signed_unsafe256(__warp_usrid_15_log_sqrt10001, Uint256(low=3402992956809132418596140100660247210, high=0));
            
            let (__warp_se_1059) = warp_shr_signed256(__warp_se_1058, 128);
            
            let (__warp_usrid_16_tickLow) = warp_int256_to_int24(__warp_se_1059);
            
            let (__warp_se_1060) = warp_add_signed_unsafe256(__warp_usrid_15_log_sqrt10001, Uint256(low=291339464771989622907027621153398088495, high=0));
            
            let (__warp_se_1061) = warp_shr_signed256(__warp_se_1060, 128);
            
            let (__warp_usrid_17_tickHi) = warp_int256_to_int24(__warp_se_1061);
            
            let (__warp_se_1062) = warp_eq(__warp_usrid_16_tickLow, __warp_usrid_17_tickHi);
            
                
                if (__warp_se_1062 != 0){
                
                    
                    let __warp_usrid_09_tick = __warp_usrid_16_tickLow;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                }else{
                
                    
                    let (__warp_pse_78) = getSqrtRatioAtTick_986cfba3(__warp_usrid_17_tickHi);
                    
                    let (__warp_se_1063) = warp_le(__warp_pse_78, __warp_usrid_08_sqrtPriceX96);
                    
                        
                        if (__warp_se_1063 != 0){
                        
                            
                            let __warp_usrid_09_tick = __warp_usrid_17_tickHi;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                        }else{
                        
                            
                            let __warp_usrid_09_tick = __warp_usrid_16_tickLow;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_09_tick = __warp_usrid_09_tick;
        
        
        
        return (__warp_usrid_09_tick,);

    }


    func __warp_conditional_getNextSqrtPriceFromAmount0RoundingUp_157f652f_29{range_check_ptr : felt}(__warp_usrid_08_product : Uint256, __warp_usrid_02_amount : Uint256, __warp_usrid_00_sqrtPX96 : felt, __warp_usrid_05_numerator1 : Uint256)-> (__warp_rc_28 : felt, __warp_usrid_08_product : Uint256, __warp_usrid_02_amount : Uint256, __warp_usrid_00_sqrtPX96 : felt, __warp_usrid_05_numerator1 : Uint256){
    alloc_locals;


        
        let (__warp_se_1064) = warp_uint256(__warp_usrid_00_sqrtPX96);
        
        let (__warp_pse_83) = warp_mul256(__warp_usrid_02_amount, __warp_se_1064);
        
        let __warp_usrid_08_product = __warp_pse_83;
        
        let (__warp_se_1065) = warp_div256(__warp_pse_83, __warp_usrid_02_amount);
        
        let (__warp_se_1066) = warp_uint256(__warp_usrid_00_sqrtPX96);
        
        let (__warp_se_1067) = warp_eq256(__warp_se_1065, __warp_se_1066);
        
        if (__warp_se_1067 != 0){
        
            
            let (__warp_se_1068) = warp_gt256(__warp_usrid_05_numerator1, __warp_usrid_08_product);
            
            let __warp_rc_28 = __warp_se_1068;
            
            let __warp_rc_28 = __warp_rc_28;
            
            let __warp_usrid_08_product = __warp_usrid_08_product;
            
            let __warp_usrid_02_amount = __warp_usrid_02_amount;
            
            let __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
            
            let __warp_usrid_05_numerator1 = __warp_usrid_05_numerator1;
            
            
            
            return (__warp_rc_28, __warp_usrid_08_product, __warp_usrid_02_amount, __warp_usrid_00_sqrtPX96, __warp_usrid_05_numerator1);
        }else{
        
            
            let __warp_rc_28 = 0;
            
            let __warp_rc_28 = __warp_rc_28;
            
            let __warp_usrid_08_product = __warp_usrid_08_product;
            
            let __warp_usrid_02_amount = __warp_usrid_02_amount;
            
            let __warp_usrid_00_sqrtPX96 = __warp_usrid_00_sqrtPX96;
            
            let __warp_usrid_05_numerator1 = __warp_usrid_05_numerator1;
            
            
            
            return (__warp_rc_28, __warp_usrid_08_product, __warp_usrid_02_amount, __warp_usrid_00_sqrtPX96, __warp_usrid_05_numerator1);
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


        
            
            let (__warp_se_1069) = warp_eq256(__warp_usrid_02_amount, Uint256(low=0, high=0));
            
                
                if (__warp_se_1069 != 0){
                
                    
                    
                    
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
            
            let (__warp_se_1070) = warp_uint256(__warp_usrid_01_liquidity);
            
            let (__warp_usrid_05_numerator1) = warp_shl256(__warp_se_1070, 96);
            
            if (__warp_usrid_03_add != 0){
            
                
                let __warp_usrid_06_product = Uint256(low=0, high=0);
                
                let (__warp_se_1071) = warp_uint256(__warp_usrid_00_sqrtPX96);
                
                let (__warp_pse_79) = warp_mul_unsafe256(__warp_usrid_02_amount, __warp_se_1071);
                
                let __warp_usrid_06_product = __warp_pse_79;
                
                let (__warp_se_1072) = warp_div_unsafe256(__warp_pse_79, __warp_usrid_02_amount);
                
                let (__warp_se_1073) = warp_uint256(__warp_usrid_00_sqrtPX96);
                
                let (__warp_se_1074) = warp_eq256(__warp_se_1072, __warp_se_1073);
                
                    
                    if (__warp_se_1074 != 0){
                    
                        
                        let (__warp_usrid_07_denominator) = warp_add_unsafe256(__warp_usrid_05_numerator1, __warp_usrid_06_product);
                        
                        let (__warp_se_1075) = warp_ge256(__warp_usrid_07_denominator, __warp_usrid_05_numerator1);
                        
                            
                            if (__warp_se_1075 != 0){
                            
                                
                                let (__warp_se_1076) = warp_uint256(__warp_usrid_00_sqrtPX96);
                                
                                let (__warp_pse_80) = mulDivRoundingUp_0af8b27f(__warp_usrid_05_numerator1, __warp_se_1076, __warp_usrid_07_denominator);
                                
                                let (__warp_se_1077) = warp_int256_to_int160(__warp_pse_80);
                                
                                
                                
                                return (__warp_se_1077,);
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
                
                let (__warp_se_1078) = warp_uint256(__warp_usrid_00_sqrtPX96);
                
                let (__warp_se_1079) = warp_div_unsafe256(__warp_usrid_05_numerator1, __warp_se_1078);
                
                let (__warp_pse_81) = add_771602f7(__warp_se_1079, __warp_usrid_02_amount);
                
                let (__warp_pse_82) = divRoundingUp_40226b32(__warp_usrid_05_numerator1, __warp_pse_81);
                
                let (__warp_se_1080) = warp_int256_to_int160(__warp_pse_82);
                
                
                
                return (__warp_se_1080,);
            }else{
            
                
                let __warp_usrid_08_product = Uint256(low=0, high=0);
                
                let __warp_rc_28 = 0;
                
                    
                    let (__warp_tv_125, __warp_tv_126, __warp_tv_127, __warp_tv_128, __warp_tv_129) = __warp_conditional_getNextSqrtPriceFromAmount0RoundingUp_157f652f_29(__warp_usrid_08_product, __warp_usrid_02_amount, __warp_usrid_00_sqrtPX96, __warp_usrid_05_numerator1);
                    
                    let __warp_usrid_05_numerator1 = __warp_tv_129;
                    
                    let __warp_usrid_00_sqrtPX96 = __warp_tv_128;
                    
                    let __warp_usrid_02_amount = __warp_tv_127;
                    
                    let __warp_usrid_08_product = __warp_tv_126;
                    
                    let __warp_rc_28 = __warp_tv_125;
                
                assert __warp_rc_28 = 1;
                
                let (__warp_usrid_09_denominator) = warp_sub_unsafe256(__warp_usrid_05_numerator1, __warp_usrid_08_product);
                
                let (__warp_se_1081) = warp_uint256(__warp_usrid_00_sqrtPX96);
                
                let (__warp_pse_84) = mulDivRoundingUp_0af8b27f(__warp_usrid_05_numerator1, __warp_se_1081, __warp_usrid_09_denominator);
                
                let (__warp_pse_85) = toUint160_dfef6beb(__warp_pse_84);
                
                
                
                return (__warp_pse_85,);
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
                
                let (__warp_se_1082) = warp_uint256(1461501637330902918203684832716283019655932542975);
                
                let (__warp_se_1083) = warp_le256(__warp_usrid_12_amount, __warp_se_1082);
                
                    
                    if (__warp_se_1083 != 0){
                    
                        
                        let (__warp_se_1084) = warp_shl256(__warp_usrid_12_amount, 96);
                        
                        let (__warp_se_1085) = warp_uint256(__warp_usrid_11_liquidity);
                        
                        let (__warp_se_1086) = warp_div_unsafe256(__warp_se_1084, __warp_se_1085);
                        
                        let __warp_usrid_15_quotient = __warp_se_1086;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_15_quotient = __warp_usrid_15_quotient;
                        tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                    }else{
                    
                        
                        let (__warp_se_1087) = warp_uint256(__warp_usrid_11_liquidity);
                        
                        let (__warp_pse_86) = mulDiv_aa9a0912(__warp_usrid_12_amount, Uint256(low=79228162514264337593543950336, high=0), __warp_se_1087);
                        
                        let __warp_usrid_15_quotient = __warp_pse_86;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_15_quotient = __warp_usrid_15_quotient;
                        tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_15_quotient = __warp_usrid_15_quotient;
                    tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                
                let (__warp_se_1088) = warp_uint256(__warp_usrid_10_sqrtPX96);
                
                let (__warp_pse_87) = add_771602f7(__warp_se_1088, __warp_usrid_15_quotient);
                
                let (__warp_pse_88) = toUint160_dfef6beb(__warp_pse_87);
                
                
                
                return (__warp_pse_88,);
            }else{
            
                
                let __warp_usrid_16_quotient = Uint256(low=0, high=0);
                
                let (__warp_se_1089) = warp_uint256(1461501637330902918203684832716283019655932542975);
                
                let (__warp_se_1090) = warp_le256(__warp_usrid_12_amount, __warp_se_1089);
                
                    
                    if (__warp_se_1090 != 0){
                    
                        
                        let (__warp_se_1091) = warp_shl256(__warp_usrid_12_amount, 96);
                        
                        let (__warp_se_1092) = warp_uint256(__warp_usrid_11_liquidity);
                        
                        let (__warp_pse_89) = divRoundingUp_40226b32(__warp_se_1091, __warp_se_1092);
                        
                        let __warp_usrid_16_quotient = __warp_pse_89;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_16_quotient = __warp_usrid_16_quotient;
                        tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                    }else{
                    
                        
                        let (__warp_se_1093) = warp_uint256(__warp_usrid_11_liquidity);
                        
                        let (__warp_pse_90) = mulDivRoundingUp_0af8b27f(__warp_usrid_12_amount, Uint256(low=79228162514264337593543950336, high=0), __warp_se_1093);
                        
                        let __warp_usrid_16_quotient = __warp_pse_90;
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar __warp_usrid_16_quotient = __warp_usrid_16_quotient;
                        tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                    }
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_16_quotient = __warp_usrid_16_quotient;
                    tempvar __warp_usrid_10_sqrtPX96 = __warp_usrid_10_sqrtPX96;
                
                let (__warp_se_1094) = warp_uint256(__warp_usrid_10_sqrtPX96);
                
                let (__warp_se_1095) = warp_gt256(__warp_se_1094, __warp_usrid_16_quotient);
                
                assert __warp_se_1095 = 1;
                
                let (__warp_se_1096) = warp_uint256(__warp_usrid_10_sqrtPX96);
                
                let (__warp_se_1097) = warp_sub_unsafe256(__warp_se_1096, __warp_usrid_16_quotient);
                
                let (__warp_se_1098) = warp_int256_to_int160(__warp_se_1097);
                
                
                
                return (__warp_se_1098,);
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


        
        let (__warp_se_1099) = warp_gt(__warp_usrid_17_sqrtPX96, 0);
        
        assert __warp_se_1099 = 1;
        
        let (__warp_se_1100) = warp_gt(__warp_usrid_18_liquidity, 0);
        
        assert __warp_se_1100 = 1;
        
        if (__warp_usrid_20_zeroForOne != 0){
        
            
            let (__warp_pse_91) = getNextSqrtPriceFromAmount0RoundingUp_157f652f(__warp_usrid_17_sqrtPX96, __warp_usrid_18_liquidity, __warp_usrid_19_amountIn, 1);
            
            
            
            return (__warp_pse_91,);
        }else{
        
            
            let (__warp_pse_92) = getNextSqrtPriceFromAmount1RoundingDown_fb4de288(__warp_usrid_17_sqrtPX96, __warp_usrid_18_liquidity, __warp_usrid_19_amountIn, 1);
            
            
            
            return (__warp_pse_92,);
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


        
        let (__warp_se_1101) = warp_gt(__warp_usrid_22_sqrtPX96, 0);
        
        assert __warp_se_1101 = 1;
        
        let (__warp_se_1102) = warp_gt(__warp_usrid_23_liquidity, 0);
        
        assert __warp_se_1102 = 1;
        
        if (__warp_usrid_25_zeroForOne != 0){
        
            
            let (__warp_pse_93) = getNextSqrtPriceFromAmount1RoundingDown_fb4de288(__warp_usrid_22_sqrtPX96, __warp_usrid_23_liquidity, __warp_usrid_24_amountOut, 0);
            
            
            
            return (__warp_pse_93,);
        }else{
        
            
            let (__warp_pse_94) = getNextSqrtPriceFromAmount0RoundingUp_157f652f(__warp_usrid_22_sqrtPX96, __warp_usrid_23_liquidity, __warp_usrid_24_amountOut, 0);
            
            
            
            return (__warp_pse_94,);
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


        
            
            let (__warp_se_1103) = warp_gt(__warp_usrid_27_sqrtRatioAX96, __warp_usrid_28_sqrtRatioBX96);
            
                
                if (__warp_se_1103 != 0){
                
                    
                    let __warp_tv_130 = __warp_usrid_28_sqrtRatioBX96;
                    
                    let __warp_tv_131 = __warp_usrid_27_sqrtRatioAX96;
                    
                    let __warp_usrid_28_sqrtRatioBX96 = __warp_tv_131;
                    
                    let __warp_usrid_27_sqrtRatioAX96 = __warp_tv_130;
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
            
            let (__warp_se_1104) = warp_uint256(__warp_usrid_29_liquidity);
            
            let (__warp_usrid_32_numerator1) = warp_shl256(__warp_se_1104, 96);
            
            let (__warp_se_1105) = warp_sub_unsafe160(__warp_usrid_28_sqrtRatioBX96, __warp_usrid_27_sqrtRatioAX96);
            
            let (__warp_usrid_33_numerator2) = warp_uint256(__warp_se_1105);
            
            let (__warp_se_1106) = warp_gt(__warp_usrid_27_sqrtRatioAX96, 0);
            
            assert __warp_se_1106 = 1;
            
            if (__warp_usrid_30_roundUp != 0){
            
                
                let (__warp_se_1107) = warp_uint256(__warp_usrid_28_sqrtRatioBX96);
                
                let (__warp_pse_95) = mulDivRoundingUp_0af8b27f(__warp_usrid_32_numerator1, __warp_usrid_33_numerator2, __warp_se_1107);
                
                let (__warp_se_1108) = warp_uint256(__warp_usrid_27_sqrtRatioAX96);
                
                let (__warp_pse_96) = divRoundingUp_40226b32(__warp_pse_95, __warp_se_1108);
                
                
                
                return (__warp_pse_96,);
            }else{
            
                
                let (__warp_se_1109) = warp_uint256(__warp_usrid_28_sqrtRatioBX96);
                
                let (__warp_pse_97) = mulDiv_aa9a0912(__warp_usrid_32_numerator1, __warp_usrid_33_numerator2, __warp_se_1109);
                
                let (__warp_se_1110) = warp_uint256(__warp_usrid_27_sqrtRatioAX96);
                
                let (__warp_se_1111) = warp_div_unsafe256(__warp_pse_97, __warp_se_1110);
                
                
                
                return (__warp_se_1111,);
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


        
            
            let (__warp_se_1112) = warp_gt(__warp_usrid_34_sqrtRatioAX96, __warp_usrid_35_sqrtRatioBX96);
            
                
                if (__warp_se_1112 != 0){
                
                    
                    let __warp_tv_132 = __warp_usrid_35_sqrtRatioBX96;
                    
                    let __warp_tv_133 = __warp_usrid_34_sqrtRatioAX96;
                    
                    let __warp_usrid_35_sqrtRatioBX96 = __warp_tv_133;
                    
                    let __warp_usrid_34_sqrtRatioAX96 = __warp_tv_132;
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
            
                
                let (__warp_se_1113) = warp_uint256(__warp_usrid_36_liquidity);
                
                let (__warp_se_1114) = warp_sub_unsafe160(__warp_usrid_35_sqrtRatioBX96, __warp_usrid_34_sqrtRatioAX96);
                
                let (__warp_se_1115) = warp_uint256(__warp_se_1114);
                
                let (__warp_pse_98) = mulDivRoundingUp_0af8b27f(__warp_se_1113, __warp_se_1115, Uint256(low=79228162514264337593543950336, high=0));
                
                
                
                return (__warp_pse_98,);
            }else{
            
                
                let (__warp_se_1116) = warp_uint256(__warp_usrid_36_liquidity);
                
                let (__warp_se_1117) = warp_sub_unsafe160(__warp_usrid_35_sqrtRatioBX96, __warp_usrid_34_sqrtRatioAX96);
                
                let (__warp_se_1118) = warp_uint256(__warp_se_1117);
                
                let (__warp_pse_99) = mulDiv_aa9a0912(__warp_se_1116, __warp_se_1118, Uint256(low=79228162514264337593543950336, high=0));
                
                
                
                return (__warp_pse_99,);
            }

    }

    // @notice Helper that gets signed token0 delta
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The change in liquidity for which to compute the amount0 delta
    // @return amount0 Amount of token0 corresponding to the passed liquidityDelta between the two prices
    func getAmount0Delta_c932699b{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_39_sqrtRatioAX96 : felt, __warp_usrid_40_sqrtRatioBX96 : felt, __warp_usrid_41_liquidity : felt)-> (__warp_usrid_42_amount0 : Uint256){
    alloc_locals;


        
        let (__warp_se_1119) = warp_lt_signed128(__warp_usrid_41_liquidity, 0);
        
        if (__warp_se_1119 != 0){
        
            
            let (__warp_se_1120) = warp_negate128(__warp_usrid_41_liquidity);
            
            let (__warp_pse_100) = getAmount0Delta_2c32d4b6(__warp_usrid_39_sqrtRatioAX96, __warp_usrid_40_sqrtRatioBX96, __warp_se_1120, 0);
            
            let (__warp_pse_101) = toInt256_dfbe873b(__warp_pse_100);
            
            let (__warp_se_1121) = warp_negate256(__warp_pse_101);
            
            
            
            return (__warp_se_1121,);
        }else{
        
            
            let (__warp_pse_102) = getAmount0Delta_2c32d4b6(__warp_usrid_39_sqrtRatioAX96, __warp_usrid_40_sqrtRatioBX96, __warp_usrid_41_liquidity, 1);
            
            let (__warp_pse_103) = toInt256_dfbe873b(__warp_pse_102);
            
            
            
            return (__warp_pse_103,);
        }

    }

    // @notice Helper that gets signed token1 delta
    // @param sqrtRatioAX96 A sqrt price
    // @param sqrtRatioBX96 Another sqrt price
    // @param liquidity The change in liquidity for which to compute the amount1 delta
    // @return amount1 Amount of token1 corresponding to the passed liquidityDelta between the two prices
    func getAmount1Delta_00c11862{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_43_sqrtRatioAX96 : felt, __warp_usrid_44_sqrtRatioBX96 : felt, __warp_usrid_45_liquidity : felt)-> (__warp_usrid_46_amount1 : Uint256){
    alloc_locals;


        
        let (__warp_se_1122) = warp_lt_signed128(__warp_usrid_45_liquidity, 0);
        
        if (__warp_se_1122 != 0){
        
            
            let (__warp_se_1123) = warp_negate128(__warp_usrid_45_liquidity);
            
            let (__warp_pse_104) = getAmount1Delta_48a0c5bd(__warp_usrid_43_sqrtRatioAX96, __warp_usrid_44_sqrtRatioBX96, __warp_se_1123, 0);
            
            let (__warp_pse_105) = toInt256_dfbe873b(__warp_pse_104);
            
            let (__warp_se_1124) = warp_negate256(__warp_pse_105);
            
            
            
            return (__warp_se_1124,);
        }else{
        
            
            let (__warp_pse_106) = getAmount1Delta_48a0c5bd(__warp_usrid_43_sqrtRatioAX96, __warp_usrid_44_sqrtRatioBX96, __warp_usrid_45_liquidity, 1);
            
            let (__warp_pse_107) = toInt256_dfbe873b(__warp_pse_106);
            
            
            
            return (__warp_pse_107,);
        }

    }

    // @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    // @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
    func mulDiv_aa9a0912{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_a : Uint256, __warp_usrid_01_b : Uint256, __warp_usrid_02_denominator : Uint256)-> (__warp_usrid_03_result : Uint256){
       let (low, high, remainder) = uint256_mul_div_mod(__warp_usrid_00_a,__warp_usrid_01_b, __warp_usrid_02_denominator);
       assert high.high = 0;
       assert high.low = 0;
       return (__warp_usrid_03_result=low);
    }

    // @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    // @param a The multiplicand
    // @param b The multiplier
    // @param denominator The divisor
    // @return result The 256-bit result
    func mulDivRoundingUp_0af8b27f{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_10_a : Uint256, __warp_usrid_11_b : Uint256, __warp_usrid_12_denominator : Uint256)-> (__warp_usrid_13_result : Uint256){
      let (low, high, remainder) = uint256_mul_div_mod(__warp_usrid_10_a,__warp_usrid_11_b, __warp_usrid_12_denominator);
      assert high.high = 0;
      assert high.low = 0;
      if (remainder.low + remainder.high != 0) {
        let (low, carry) = uint256_add(low, Uint256(1, 0));
        assert carry = 0;
        return (__warp_usrid_13_result=low);
      }
      return (__warp_usrid_13_result=low);
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
            
            let (__warp_se_1168) = warp_mod256(__warp_usrid_00_x, __warp_usrid_01_y);
            
            let (__warp_se_1169) = warp_gt256(__warp_se_1168, Uint256(low=0, high=0));
            
                
                if (__warp_se_1169 != 0){
                
                    
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
            
            let (__warp_se_1170) = warp_div_unsafe256(__warp_usrid_00_x, __warp_usrid_01_y);
            
            let (__warp_se_1171) = warp_add_unsafe256(__warp_se_1170, __warp_usrid_03_temp);
            
            let __warp_usrid_02_z = __warp_se_1171;
        
        
        
        return (__warp_usrid_02_z,);

    }

    // @notice Returns the Info struct of a position, given an owner and position boundaries
    // @param self The mapping containing all user positions
    // @param owner The address of the position owner
    // @param tickLower The lower tick boundary of the position
    // @param tickUpper The upper tick boundary of the position
    // @return position The position info struct of the given owners' position
    func get_a4d6{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_usrid_05_self : felt, __warp_usrid_06_owner : felt, __warp_usrid_07_tickLower : felt, __warp_usrid_08_tickUpper : felt)-> (__warp_usrid_09_position : felt){
    alloc_locals;


        
        let __warp_usrid_09_position = 0;
        
        let (__warp_se_1172) = abi_encode_packed0(__warp_usrid_06_owner, __warp_usrid_07_tickLower, __warp_usrid_08_tickUpper);
        
        let (__warp_se_1173) = warp_keccak(__warp_se_1172);
        
        let (__warp_se_1174) = WS2_INDEX_Uint256_to_Info_d529aac3(__warp_usrid_05_self, __warp_se_1173);
        
        let __warp_usrid_09_position = __warp_se_1174;
        
        
        
        return (__warp_usrid_09_position,);

    }


    func __warp_conditional_update_d9a1a063_31{range_check_ptr : felt}(__warp_usrid_16_tokensOwed0 : felt, __warp_usrid_17_tokensOwed1 : felt)-> (__warp_rc_30 : felt, __warp_usrid_16_tokensOwed0 : felt, __warp_usrid_17_tokensOwed1 : felt){
    alloc_locals;


        
        let (__warp_se_1175) = warp_gt(__warp_usrid_16_tokensOwed0, 0);
        
        if (__warp_se_1175 != 0){
        
            
            let __warp_rc_30 = 1;
            
            let __warp_rc_30 = __warp_rc_30;
            
            let __warp_usrid_16_tokensOwed0 = __warp_usrid_16_tokensOwed0;
            
            let __warp_usrid_17_tokensOwed1 = __warp_usrid_17_tokensOwed1;
            
            
            
            return (__warp_rc_30, __warp_usrid_16_tokensOwed0, __warp_usrid_17_tokensOwed1);
        }else{
        
            
            let (__warp_se_1176) = warp_gt(__warp_usrid_17_tokensOwed1, 0);
            
            let __warp_rc_30 = __warp_se_1176;
            
            let __warp_rc_30 = __warp_rc_30;
            
            let __warp_usrid_16_tokensOwed0 = __warp_usrid_16_tokensOwed0;
            
            let __warp_usrid_17_tokensOwed1 = __warp_usrid_17_tokensOwed1;
            
            
            
            return (__warp_rc_30, __warp_usrid_16_tokensOwed0, __warp_usrid_17_tokensOwed1);
        }

    }

    // @notice Credits accumulated fees to a user's position
    // @param self The individual position to update
    // @param liquidityDelta The change in pool liquidity as a result of the position update
    // @param feeGrowthInside0X128 The all-time fee growth in token0, per unit of liquidity, inside the position's tick boundaries
    // @param feeGrowthInside1X128 The all-time fee growth in token1, per unit of liquidity, inside the position's tick boundaries
    func update_d9a1a063{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_usrid_10_self : felt, __warp_usrid_11_liquidityDelta : felt, __warp_usrid_12_feeGrowthInside0X128 : Uint256, __warp_usrid_13_feeGrowthInside1X128 : Uint256)-> (){
    alloc_locals;


        
            
            let (__warp_usrid_14__self) = ws_to_memory2(__warp_usrid_10_self);
            
            let __warp_usrid_15_liquidityNext = 0;
            
            let (__warp_se_1177) = warp_eq(__warp_usrid_11_liquidityDelta, 0);
            
                
                if (__warp_se_1177 != 0){
                
                    
                    let (__warp_se_1178) = WM35_Info_d529aac3___warp_usrid_00_liquidity(__warp_usrid_14__self);
                    
                    let (__warp_se_1179) = wm_read_felt(__warp_se_1178);
                    
                    let (__warp_se_1180) = warp_gt(__warp_se_1179, 0);
                    
                    with_attr error_message("NP"){
                        assert __warp_se_1180 = 1;
                    }
                    
                    let (__warp_se_1181) = WM35_Info_d529aac3___warp_usrid_00_liquidity(__warp_usrid_14__self);
                    
                    let (__warp_se_1182) = wm_read_felt(__warp_se_1181);
                    
                    let __warp_usrid_15_liquidityNext = __warp_se_1182;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_10_self = __warp_usrid_10_self;
                    tempvar __warp_usrid_13_feeGrowthInside1X128 = __warp_usrid_13_feeGrowthInside1X128;
                    tempvar __warp_usrid_12_feeGrowthInside0X128 = __warp_usrid_12_feeGrowthInside0X128;
                    tempvar __warp_usrid_15_liquidityNext = __warp_usrid_15_liquidityNext;
                    tempvar __warp_usrid_11_liquidityDelta = __warp_usrid_11_liquidityDelta;
                    tempvar __warp_usrid_14__self = __warp_usrid_14__self;
                }else{
                
                    
                    let (__warp_se_1183) = WM35_Info_d529aac3___warp_usrid_00_liquidity(__warp_usrid_14__self);
                    
                    let (__warp_se_1184) = wm_read_felt(__warp_se_1183);
                    
                    let (__warp_pse_110) = addDelta_402d44fb(__warp_se_1184, __warp_usrid_11_liquidityDelta);
                    
                    let __warp_usrid_15_liquidityNext = __warp_pse_110;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_10_self = __warp_usrid_10_self;
                    tempvar __warp_usrid_13_feeGrowthInside1X128 = __warp_usrid_13_feeGrowthInside1X128;
                    tempvar __warp_usrid_12_feeGrowthInside0X128 = __warp_usrid_12_feeGrowthInside0X128;
                    tempvar __warp_usrid_15_liquidityNext = __warp_usrid_15_liquidityNext;
                    tempvar __warp_usrid_11_liquidityDelta = __warp_usrid_11_liquidityDelta;
                    tempvar __warp_usrid_14__self = __warp_usrid_14__self;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_10_self = __warp_usrid_10_self;
                tempvar __warp_usrid_13_feeGrowthInside1X128 = __warp_usrid_13_feeGrowthInside1X128;
                tempvar __warp_usrid_12_feeGrowthInside0X128 = __warp_usrid_12_feeGrowthInside0X128;
                tempvar __warp_usrid_15_liquidityNext = __warp_usrid_15_liquidityNext;
                tempvar __warp_usrid_11_liquidityDelta = __warp_usrid_11_liquidityDelta;
                tempvar __warp_usrid_14__self = __warp_usrid_14__self;
            
            let (__warp_se_1185) = WM36_Info_d529aac3___warp_usrid_01_feeGrowthInside0LastX128(__warp_usrid_14__self);
            
            let (__warp_se_1186) = wm_read_256(__warp_se_1185);
            
            let (__warp_se_1187) = warp_sub_unsafe256(__warp_usrid_12_feeGrowthInside0X128, __warp_se_1186);
            
            let (__warp_se_1188) = WM35_Info_d529aac3___warp_usrid_00_liquidity(__warp_usrid_14__self);
            
            let (__warp_se_1189) = wm_read_felt(__warp_se_1188);
            
            let (__warp_se_1190) = warp_uint256(__warp_se_1189);
            
            let (__warp_pse_111) = mulDiv_aa9a0912(__warp_se_1187, __warp_se_1190, Uint256(low=0, high=1));
            
            let (__warp_usrid_16_tokensOwed0) = warp_int256_to_int128(__warp_pse_111);
            
            let (__warp_se_1191) = WM37_Info_d529aac3___warp_usrid_02_feeGrowthInside1LastX128(__warp_usrid_14__self);
            
            let (__warp_se_1192) = wm_read_256(__warp_se_1191);
            
            let (__warp_se_1193) = warp_sub_unsafe256(__warp_usrid_13_feeGrowthInside1X128, __warp_se_1192);
            
            let (__warp_se_1194) = WM35_Info_d529aac3___warp_usrid_00_liquidity(__warp_usrid_14__self);
            
            let (__warp_se_1195) = wm_read_felt(__warp_se_1194);
            
            let (__warp_se_1196) = warp_uint256(__warp_se_1195);
            
            let (__warp_pse_112) = mulDiv_aa9a0912(__warp_se_1193, __warp_se_1196, Uint256(low=0, high=1));
            
            let (__warp_usrid_17_tokensOwed1) = warp_int256_to_int128(__warp_pse_112);
            
            let (__warp_se_1197) = warp_neq(__warp_usrid_11_liquidityDelta, 0);
            
                
                if (__warp_se_1197 != 0){
                
                    
                    let (__warp_se_1198) = WSM20_Info_d529aac3___warp_usrid_00_liquidity(__warp_usrid_10_self);
                    
                    WS_WRITE0(__warp_se_1198, __warp_usrid_15_liquidityNext);
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_17_tokensOwed1 = __warp_usrid_17_tokensOwed1;
                    tempvar __warp_usrid_10_self = __warp_usrid_10_self;
                    tempvar __warp_usrid_16_tokensOwed0 = __warp_usrid_16_tokensOwed0;
                    tempvar __warp_usrid_13_feeGrowthInside1X128 = __warp_usrid_13_feeGrowthInside1X128;
                    tempvar __warp_usrid_12_feeGrowthInside0X128 = __warp_usrid_12_feeGrowthInside0X128;
                }else{
                
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_17_tokensOwed1 = __warp_usrid_17_tokensOwed1;
                    tempvar __warp_usrid_10_self = __warp_usrid_10_self;
                    tempvar __warp_usrid_16_tokensOwed0 = __warp_usrid_16_tokensOwed0;
                    tempvar __warp_usrid_13_feeGrowthInside1X128 = __warp_usrid_13_feeGrowthInside1X128;
                    tempvar __warp_usrid_12_feeGrowthInside0X128 = __warp_usrid_12_feeGrowthInside0X128;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_17_tokensOwed1 = __warp_usrid_17_tokensOwed1;
                tempvar __warp_usrid_10_self = __warp_usrid_10_self;
                tempvar __warp_usrid_16_tokensOwed0 = __warp_usrid_16_tokensOwed0;
                tempvar __warp_usrid_13_feeGrowthInside1X128 = __warp_usrid_13_feeGrowthInside1X128;
                tempvar __warp_usrid_12_feeGrowthInside0X128 = __warp_usrid_12_feeGrowthInside0X128;
            
            let (__warp_se_1199) = WSM21_Info_d529aac3___warp_usrid_01_feeGrowthInside0LastX128(__warp_usrid_10_self);
            
            WS_WRITE1(__warp_se_1199, __warp_usrid_12_feeGrowthInside0X128);
            
            let (__warp_se_1200) = WSM22_Info_d529aac3___warp_usrid_02_feeGrowthInside1LastX128(__warp_usrid_10_self);
            
            WS_WRITE1(__warp_se_1200, __warp_usrid_13_feeGrowthInside1X128);
            
            let __warp_rc_30 = 0;
            
                
                let (__warp_tv_134, __warp_tv_135, __warp_tv_136) = __warp_conditional_update_d9a1a063_31(__warp_usrid_16_tokensOwed0, __warp_usrid_17_tokensOwed1);
                
                let __warp_usrid_17_tokensOwed1 = __warp_tv_136;
                
                let __warp_usrid_16_tokensOwed0 = __warp_tv_135;
                
                let __warp_rc_30 = __warp_tv_134;
            
                
                if (__warp_rc_30 != 0){
                
                    
                    let (__warp_se_1201) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(__warp_usrid_10_self);
                    
                    let (__warp_se_1202) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(__warp_usrid_10_self);
                    
                    let (__warp_se_1203) = WS0_READ_felt(__warp_se_1202);
                    
                    let (__warp_se_1204) = warp_add_unsafe128(__warp_se_1203, __warp_usrid_16_tokensOwed0);
                    
                    WS_WRITE0(__warp_se_1201, __warp_se_1204);
                    
                    let (__warp_se_1205) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(__warp_usrid_10_self);
                    
                    let (__warp_se_1206) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(__warp_usrid_10_self);
                    
                    let (__warp_se_1207) = WS0_READ_felt(__warp_se_1206);
                    
                    let (__warp_se_1208) = warp_add_unsafe128(__warp_se_1207, __warp_usrid_17_tokensOwed1);
                    
                    WS_WRITE0(__warp_se_1205, __warp_se_1208);
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                }else{
                
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar warp_memory = warp_memory;
                    tempvar bitwise_ptr = bitwise_ptr;
                }
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar range_check_ptr = range_check_ptr;
                tempvar warp_memory = warp_memory;
                tempvar bitwise_ptr = bitwise_ptr;
        
        
        
        return ();

    }

    // @notice Computes the position in the mapping where the initialized bit for a tick lives
    // @param tick The tick for which to compute the position
    // @return wordPos The key in the mapping containing the word in which the bit is stored
    // @return bitPos The bit position in the word where the flag is stored
    func position_3e7b7779{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_tick : felt)-> (__warp_usrid_01_wordPos : felt, __warp_usrid_02_bitPos : felt){
    alloc_locals;


        
        let __warp_usrid_02_bitPos = 0;
        
        let __warp_usrid_01_wordPos = 0;
        
            
            let (__warp_se_1209) = warp_shr_signed24(__warp_usrid_00_tick, 8);
            
            let (__warp_se_1210) = warp_int24_to_int16(__warp_se_1209);
            
            let __warp_usrid_01_wordPos = __warp_se_1210;
            
            let (__warp_se_1211) = warp_mod(__warp_usrid_00_tick, 256);
            
            let (__warp_se_1212) = warp_int24_to_int8(__warp_se_1211);
            
            let __warp_usrid_02_bitPos = __warp_se_1212;
        
        let __warp_usrid_01_wordPos = __warp_usrid_01_wordPos;
        
        let __warp_usrid_02_bitPos = __warp_usrid_02_bitPos;
        
        
        
        return (__warp_usrid_01_wordPos, __warp_usrid_02_bitPos);

    }

    // @notice Flips the initialized state for a given tick from false to true, or vice versa
    // @param self The mapping in which to flip the tick
    // @param tick The tick to flip
    // @param tickSpacing The spacing between usable ticks
    func flipTick_5b3a{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_03_self : felt, __warp_usrid_04_tick : felt, __warp_usrid_05_tickSpacing : felt)-> (){
    alloc_locals;


        
            
            let (__warp_se_1213) = warp_mod_signed24(__warp_usrid_04_tick, __warp_usrid_05_tickSpacing);
            
            let (__warp_se_1214) = warp_eq(__warp_se_1213, 0);
            
            assert __warp_se_1214 = 1;
            
            let (__warp_se_1215) = warp_div_signed_unsafe24(__warp_usrid_04_tick, __warp_usrid_05_tickSpacing);
            
            let (__warp_usrid_06_wordPos, __warp_usrid_07_bitPos) = position_3e7b7779(__warp_se_1215);
            
            let (__warp_usrid_08_mask) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_07_bitPos);
            
            let __warp_cs_0 = __warp_usrid_06_wordPos;
            
            let (__warp_se_1216) = WS1_INDEX_felt_to_Uint256(__warp_usrid_03_self, __warp_cs_0);
            
            let (__warp_se_1217) = WS1_INDEX_felt_to_Uint256(__warp_usrid_03_self, __warp_cs_0);
            
            let (__warp_se_1218) = WS1_READ_Uint256(__warp_se_1217);
            
            let (__warp_se_1219) = warp_xor256(__warp_se_1218, __warp_usrid_08_mask);
            
            WS_WRITE1(__warp_se_1216, __warp_se_1219);
        
        
        
        return ();

    }


    func __warp_conditional_nextInitializedTickWithinOneWord_a52a_33{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_10_tick : felt, __warp_usrid_11_tickSpacing : felt)-> (__warp_rc_32 : felt, __warp_usrid_10_tick : felt, __warp_usrid_11_tickSpacing : felt){
    alloc_locals;


        
        let (__warp_se_1220) = warp_lt_signed24(__warp_usrid_10_tick, 0);
        
        if (__warp_se_1220 != 0){
        
            
            let (__warp_se_1221) = warp_mod_signed24(__warp_usrid_10_tick, __warp_usrid_11_tickSpacing);
            
            let (__warp_se_1222) = warp_neq(__warp_se_1221, 0);
            
            let __warp_rc_32 = __warp_se_1222;
            
            let __warp_rc_32 = __warp_rc_32;
            
            let __warp_usrid_10_tick = __warp_usrid_10_tick;
            
            let __warp_usrid_11_tickSpacing = __warp_usrid_11_tickSpacing;
            
            
            
            return (__warp_rc_32, __warp_usrid_10_tick, __warp_usrid_11_tickSpacing);
        }else{
        
            
            let __warp_rc_32 = 0;
            
            let __warp_rc_32 = __warp_rc_32;
            
            let __warp_usrid_10_tick = __warp_usrid_10_tick;
            
            let __warp_usrid_11_tickSpacing = __warp_usrid_11_tickSpacing;
            
            
            
            return (__warp_rc_32, __warp_usrid_10_tick, __warp_usrid_11_tickSpacing);
        }

    }

    // @notice Returns the next initialized tick contained in the same word (or adjacent word) as the tick that is either
    // to the left (less than or equal to) or right (greater than) of the given tick
    // @param self The mapping in which to compute the next initialized tick
    // @param tick The starting tick
    // @param tickSpacing The spacing between usable ticks
    // @param lte Whether to search for the next initialized tick to the left (less than or equal to the starting tick)
    // @return next The next initialized or uninitialized tick up to 256 ticks away from the current tick
    // @return initialized Whether the next tick is initialized, as the function only searches within up to 256 ticks
    func nextInitializedTickWithinOneWord_a52a{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_09_self : felt, __warp_usrid_10_tick : felt, __warp_usrid_11_tickSpacing : felt, __warp_usrid_12_lte : felt)-> (__warp_usrid_13_next : felt, __warp_usrid_14_initialized : felt){
    alloc_locals;


        
        let __warp_usrid_13_next = 0;
        
        let __warp_usrid_14_initialized = 0;
        
            
            let (__warp_usrid_15_compressed) = warp_div_signed_unsafe24(__warp_usrid_10_tick, __warp_usrid_11_tickSpacing);
            
            let __warp_rc_32 = 0;
            
                
                let (__warp_tv_137, __warp_tv_138, __warp_tv_139) = __warp_conditional_nextInitializedTickWithinOneWord_a52a_33(__warp_usrid_10_tick, __warp_usrid_11_tickSpacing);
                
                let __warp_usrid_11_tickSpacing = __warp_tv_139;
                
                let __warp_usrid_10_tick = __warp_tv_138;
                
                let __warp_rc_32 = __warp_tv_137;
            
                
                if (__warp_rc_32 != 0){
                
                    
                    let (__warp_pse_113) = warp_sub_signed_unsafe24(__warp_usrid_15_compressed, 1);
                    
                    let __warp_usrid_15_compressed = __warp_pse_113;
                    
                    warp_add_signed_unsafe24(__warp_pse_113, 1);
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                    tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                    tempvar __warp_usrid_12_lte = __warp_usrid_12_lte;
                    tempvar __warp_usrid_11_tickSpacing = __warp_usrid_11_tickSpacing;
                    tempvar __warp_usrid_15_compressed = __warp_usrid_15_compressed;
                    tempvar __warp_usrid_09_self = __warp_usrid_09_self;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                    tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                    tempvar __warp_usrid_12_lte = __warp_usrid_12_lte;
                    tempvar __warp_usrid_11_tickSpacing = __warp_usrid_11_tickSpacing;
                    tempvar __warp_usrid_15_compressed = __warp_usrid_15_compressed;
                    tempvar __warp_usrid_09_self = __warp_usrid_09_self;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                tempvar __warp_usrid_12_lte = __warp_usrid_12_lte;
                tempvar __warp_usrid_11_tickSpacing = __warp_usrid_11_tickSpacing;
                tempvar __warp_usrid_15_compressed = __warp_usrid_15_compressed;
                tempvar __warp_usrid_09_self = __warp_usrid_09_self;
            
                
                if (__warp_usrid_12_lte != 0){
                
                    
                    let (__warp_usrid_16_wordPos, __warp_usrid_17_bitPos) = position_3e7b7779(__warp_usrid_15_compressed);
                    
                    let (__warp_se_1223) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_17_bitPos);
                    
                    let (__warp_se_1224) = warp_sub_unsafe256(__warp_se_1223, Uint256(low=1, high=0));
                    
                    let (__warp_se_1225) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_17_bitPos);
                    
                    let (__warp_usrid_18_mask) = warp_add_unsafe256(__warp_se_1224, __warp_se_1225);
                    
                    let (__warp_se_1226) = WS1_INDEX_felt_to_Uint256(__warp_usrid_09_self, __warp_usrid_16_wordPos);
                    
                    let (__warp_se_1227) = WS1_READ_Uint256(__warp_se_1226);
                    
                    let (__warp_usrid_19_masked) = warp_bitwise_and256(__warp_se_1227, __warp_usrid_18_mask);
                    
                    let (__warp_se_1228) = warp_neq256(__warp_usrid_19_masked, Uint256(low=0, high=0));
                    
                    let __warp_usrid_14_initialized = __warp_se_1228;
                    
                        
                        if (__warp_usrid_14_initialized != 0){
                        
                            
                            let (__warp_pse_114) = mostSignificantBit_e6bcbc65(__warp_usrid_19_masked);
                            
                            let (__warp_se_1229) = warp_sub_signed_unsafe24(__warp_usrid_17_bitPos, __warp_pse_114);
                            
                            let (__warp_se_1230) = warp_sub_signed_unsafe24(__warp_usrid_15_compressed, __warp_se_1229);
                            
                            let (__warp_se_1231) = warp_mul_signed_unsafe24(__warp_se_1230, __warp_usrid_11_tickSpacing);
                            
                            let __warp_usrid_13_next = __warp_se_1231;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                            tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                        }else{
                        
                            
                            let (__warp_se_1232) = warp_sub_signed_unsafe24(__warp_usrid_15_compressed, __warp_usrid_17_bitPos);
                            
                            let (__warp_se_1233) = warp_mul_signed_unsafe24(__warp_se_1232, __warp_usrid_11_tickSpacing);
                            
                            let __warp_usrid_13_next = __warp_se_1233;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                            tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                        tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                    tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                }else{
                
                    
                    let (__warp_se_1234) = warp_add_signed_unsafe24(__warp_usrid_15_compressed, 1);
                    
                    let (__warp_usrid_20_wordPos, __warp_usrid_21_bitPos) = position_3e7b7779(__warp_se_1234);
                    
                    let (__warp_se_1235) = warp_shl256(Uint256(low=1, high=0), __warp_usrid_21_bitPos);
                    
                    let (__warp_se_1236) = warp_sub_unsafe256(__warp_se_1235, Uint256(low=1, high=0));
                    
                    let (__warp_usrid_22_mask) = warp_bitwise_not256(__warp_se_1236);
                    
                    let (__warp_se_1237) = WS1_INDEX_felt_to_Uint256(__warp_usrid_09_self, __warp_usrid_20_wordPos);
                    
                    let (__warp_se_1238) = WS1_READ_Uint256(__warp_se_1237);
                    
                    let (__warp_usrid_23_masked) = warp_bitwise_and256(__warp_se_1238, __warp_usrid_22_mask);
                    
                    let (__warp_se_1239) = warp_neq256(__warp_usrid_23_masked, Uint256(low=0, high=0));
                    
                    let __warp_usrid_14_initialized = __warp_se_1239;
                    
                        
                        if (__warp_usrid_14_initialized != 0){
                        
                            
                            let (__warp_pse_115) = leastSignificantBit_d230d23f(__warp_usrid_23_masked);
                            
                            let (__warp_se_1240) = warp_add_signed_unsafe24(__warp_usrid_15_compressed, 1);
                            
                            let (__warp_se_1241) = warp_sub_signed_unsafe24(__warp_pse_115, __warp_usrid_21_bitPos);
                            
                            let (__warp_se_1242) = warp_add_signed_unsafe24(__warp_se_1240, __warp_se_1241);
                            
                            let (__warp_se_1243) = warp_mul_signed_unsafe24(__warp_se_1242, __warp_usrid_11_tickSpacing);
                            
                            let __warp_usrid_13_next = __warp_se_1243;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                            tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                        }else{
                        
                            
                            let (__warp_se_1244) = warp_add_signed_unsafe24(__warp_usrid_15_compressed, 1);
                            
                            let (__warp_se_1245) = warp_sub_signed_unsafe24(255, __warp_usrid_21_bitPos);
                            
                            let (__warp_se_1246) = warp_add_signed_unsafe24(__warp_se_1244, __warp_se_1245);
                            
                            let (__warp_se_1247) = warp_mul_signed_unsafe24(__warp_se_1246, __warp_usrid_11_tickSpacing);
                            
                            let __warp_usrid_13_next = __warp_se_1247;
                            tempvar range_check_ptr = range_check_ptr;
                            tempvar bitwise_ptr = bitwise_ptr;
                            tempvar syscall_ptr = syscall_ptr;
                            tempvar pedersen_ptr = pedersen_ptr;
                            tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                            tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                        }
                        tempvar range_check_ptr = range_check_ptr;
                        tempvar bitwise_ptr = bitwise_ptr;
                        tempvar syscall_ptr = syscall_ptr;
                        tempvar pedersen_ptr = pedersen_ptr;
                        tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                        tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar syscall_ptr = syscall_ptr;
                    tempvar pedersen_ptr = pedersen_ptr;
                    tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                    tempvar __warp_usrid_13_next = __warp_usrid_13_next;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar syscall_ptr = syscall_ptr;
                tempvar pedersen_ptr = pedersen_ptr;
                tempvar __warp_usrid_14_initialized = __warp_usrid_14_initialized;
                tempvar __warp_usrid_13_next = __warp_usrid_13_next;
        
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
    func mostSignificantBit_e6bcbc65{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_00_x : Uint256)-> (__warp_usrid_01_r : felt){
    alloc_locals;


        
        let __warp_usrid_01_r = 0;
        
            
            let (__warp_se_1248) = warp_gt256(__warp_usrid_00_x, Uint256(low=0, high=0));
            
            assert __warp_se_1248 = 1;
            
            let (__warp_se_1249) = warp_ge256(__warp_usrid_00_x, Uint256(low=0, high=1));
            
                
                if (__warp_se_1249 != 0){
                
                    
                    let (__warp_se_1250) = warp_shr256(__warp_usrid_00_x, 128);
                    
                    let __warp_usrid_00_x = __warp_se_1250;
                    
                    let (__warp_se_1251) = warp_add_unsafe8(__warp_usrid_01_r, 128);
                    
                    let __warp_usrid_01_r = __warp_se_1251;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                tempvar __warp_usrid_00_x = __warp_usrid_00_x;
            
            let (__warp_se_1252) = warp_ge256(__warp_usrid_00_x, Uint256(low=18446744073709551616, high=0));
            
                
                if (__warp_se_1252 != 0){
                
                    
                    let (__warp_se_1253) = warp_shr256(__warp_usrid_00_x, 64);
                    
                    let __warp_usrid_00_x = __warp_se_1253;
                    
                    let (__warp_se_1254) = warp_add_unsafe8(__warp_usrid_01_r, 64);
                    
                    let __warp_usrid_01_r = __warp_se_1254;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                tempvar __warp_usrid_00_x = __warp_usrid_00_x;
            
            let (__warp_se_1255) = warp_ge256(__warp_usrid_00_x, Uint256(low=4294967296, high=0));
            
                
                if (__warp_se_1255 != 0){
                
                    
                    let (__warp_se_1256) = warp_shr256(__warp_usrid_00_x, 32);
                    
                    let __warp_usrid_00_x = __warp_se_1256;
                    
                    let (__warp_se_1257) = warp_add_unsafe8(__warp_usrid_01_r, 32);
                    
                    let __warp_usrid_01_r = __warp_se_1257;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                tempvar __warp_usrid_00_x = __warp_usrid_00_x;
            
            let (__warp_se_1258) = warp_ge256(__warp_usrid_00_x, Uint256(low=65536, high=0));
            
                
                if (__warp_se_1258 != 0){
                
                    
                    let (__warp_se_1259) = warp_shr256(__warp_usrid_00_x, 16);
                    
                    let __warp_usrid_00_x = __warp_se_1259;
                    
                    let (__warp_se_1260) = warp_add_unsafe8(__warp_usrid_01_r, 16);
                    
                    let __warp_usrid_01_r = __warp_se_1260;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                tempvar __warp_usrid_00_x = __warp_usrid_00_x;
            
            let (__warp_se_1261) = warp_ge256(__warp_usrid_00_x, Uint256(low=256, high=0));
            
                
                if (__warp_se_1261 != 0){
                
                    
                    let (__warp_se_1262) = warp_shr256(__warp_usrid_00_x, 8);
                    
                    let __warp_usrid_00_x = __warp_se_1262;
                    
                    let (__warp_se_1263) = warp_add_unsafe8(__warp_usrid_01_r, 8);
                    
                    let __warp_usrid_01_r = __warp_se_1263;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                tempvar __warp_usrid_00_x = __warp_usrid_00_x;
            
            let (__warp_se_1264) = warp_ge256(__warp_usrid_00_x, Uint256(low=16, high=0));
            
                
                if (__warp_se_1264 != 0){
                
                    
                    let (__warp_se_1265) = warp_shr256(__warp_usrid_00_x, 4);
                    
                    let __warp_usrid_00_x = __warp_se_1265;
                    
                    let (__warp_se_1266) = warp_add_unsafe8(__warp_usrid_01_r, 4);
                    
                    let __warp_usrid_01_r = __warp_se_1266;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                tempvar __warp_usrid_00_x = __warp_usrid_00_x;
            
            let (__warp_se_1267) = warp_ge256(__warp_usrid_00_x, Uint256(low=4, high=0));
            
                
                if (__warp_se_1267 != 0){
                
                    
                    let (__warp_se_1268) = warp_shr256(__warp_usrid_00_x, 2);
                    
                    let __warp_usrid_00_x = __warp_se_1268;
                    
                    let (__warp_se_1269) = warp_add_unsafe8(__warp_usrid_01_r, 2);
                    
                    let __warp_usrid_01_r = __warp_se_1269;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                    tempvar __warp_usrid_00_x = __warp_usrid_00_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                tempvar __warp_usrid_00_x = __warp_usrid_00_x;
            
            let (__warp_se_1270) = warp_ge256(__warp_usrid_00_x, Uint256(low=2, high=0));
            
                
                if (__warp_se_1270 != 0){
                
                    
                    let (__warp_se_1271) = warp_add_unsafe8(__warp_usrid_01_r, 1);
                    
                    let __warp_usrid_01_r = __warp_se_1271;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_01_r = __warp_usrid_01_r;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_01_r = __warp_usrid_01_r;
        
        
        
        return (__warp_usrid_01_r,);

    }

    // @notice Returns the index of the least significant bit of the number,
    //     where the least significant bit is at index 0 and the most significant bit is at index 255
    // @dev The function satisfies the property:
    //     (x & 2**leastSignificantBit(x)) != 0 and (x & (2**(leastSignificantBit(x)) - 1)) == 0)
    // @param x the value for which to compute the least significant bit, must be greater than 0
    // @return r the index of the least significant bit
    func leastSignificantBit_d230d23f{range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_02_x : Uint256)-> (__warp_usrid_03_r : felt){
    alloc_locals;


        
        let __warp_usrid_03_r = 0;
        
            
            let (__warp_se_1272) = warp_gt256(__warp_usrid_02_x, Uint256(low=0, high=0));
            
            assert __warp_se_1272 = 1;
            
            let __warp_usrid_03_r = 255;
            
            let (__warp_se_1273) = warp_uint256(340282366920938463463374607431768211455);
            
            let (__warp_se_1274) = warp_bitwise_and256(__warp_usrid_02_x, __warp_se_1273);
            
            let (__warp_se_1275) = warp_gt256(__warp_se_1274, Uint256(low=0, high=0));
            
                
                if (__warp_se_1275 != 0){
                
                    
                    let (__warp_se_1276) = warp_sub_unsafe8(__warp_usrid_03_r, 128);
                    
                    let __warp_usrid_03_r = __warp_se_1276;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }else{
                
                    
                    let (__warp_se_1277) = warp_shr256(__warp_usrid_02_x, 128);
                    
                    let __warp_usrid_02_x = __warp_se_1277;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                tempvar __warp_usrid_02_x = __warp_usrid_02_x;
            
            let (__warp_se_1278) = warp_uint256(18446744073709551615);
            
            let (__warp_se_1279) = warp_bitwise_and256(__warp_usrid_02_x, __warp_se_1278);
            
            let (__warp_se_1280) = warp_gt256(__warp_se_1279, Uint256(low=0, high=0));
            
                
                if (__warp_se_1280 != 0){
                
                    
                    let (__warp_se_1281) = warp_sub_unsafe8(__warp_usrid_03_r, 64);
                    
                    let __warp_usrid_03_r = __warp_se_1281;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }else{
                
                    
                    let (__warp_se_1282) = warp_shr256(__warp_usrid_02_x, 64);
                    
                    let __warp_usrid_02_x = __warp_se_1282;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                tempvar __warp_usrid_02_x = __warp_usrid_02_x;
            
            let (__warp_se_1283) = warp_uint256(4294967295);
            
            let (__warp_se_1284) = warp_bitwise_and256(__warp_usrid_02_x, __warp_se_1283);
            
            let (__warp_se_1285) = warp_gt256(__warp_se_1284, Uint256(low=0, high=0));
            
                
                if (__warp_se_1285 != 0){
                
                    
                    let (__warp_se_1286) = warp_sub_unsafe8(__warp_usrid_03_r, 32);
                    
                    let __warp_usrid_03_r = __warp_se_1286;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }else{
                
                    
                    let (__warp_se_1287) = warp_shr256(__warp_usrid_02_x, 32);
                    
                    let __warp_usrid_02_x = __warp_se_1287;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                tempvar __warp_usrid_02_x = __warp_usrid_02_x;
            
            let (__warp_se_1288) = warp_uint256(65535);
            
            let (__warp_se_1289) = warp_bitwise_and256(__warp_usrid_02_x, __warp_se_1288);
            
            let (__warp_se_1290) = warp_gt256(__warp_se_1289, Uint256(low=0, high=0));
            
                
                if (__warp_se_1290 != 0){
                
                    
                    let (__warp_se_1291) = warp_sub_unsafe8(__warp_usrid_03_r, 16);
                    
                    let __warp_usrid_03_r = __warp_se_1291;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }else{
                
                    
                    let (__warp_se_1292) = warp_shr256(__warp_usrid_02_x, 16);
                    
                    let __warp_usrid_02_x = __warp_se_1292;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                tempvar __warp_usrid_02_x = __warp_usrid_02_x;
            
            let (__warp_se_1293) = warp_uint256(255);
            
            let (__warp_se_1294) = warp_bitwise_and256(__warp_usrid_02_x, __warp_se_1293);
            
            let (__warp_se_1295) = warp_gt256(__warp_se_1294, Uint256(low=0, high=0));
            
                
                if (__warp_se_1295 != 0){
                
                    
                    let (__warp_se_1296) = warp_sub_unsafe8(__warp_usrid_03_r, 8);
                    
                    let __warp_usrid_03_r = __warp_se_1296;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }else{
                
                    
                    let (__warp_se_1297) = warp_shr256(__warp_usrid_02_x, 8);
                    
                    let __warp_usrid_02_x = __warp_se_1297;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                tempvar __warp_usrid_02_x = __warp_usrid_02_x;
            
            let (__warp_se_1298) = warp_bitwise_and256(__warp_usrid_02_x, Uint256(low=15, high=0));
            
            let (__warp_se_1299) = warp_gt256(__warp_se_1298, Uint256(low=0, high=0));
            
                
                if (__warp_se_1299 != 0){
                
                    
                    let (__warp_se_1300) = warp_sub_unsafe8(__warp_usrid_03_r, 4);
                    
                    let __warp_usrid_03_r = __warp_se_1300;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }else{
                
                    
                    let (__warp_se_1301) = warp_shr256(__warp_usrid_02_x, 4);
                    
                    let __warp_usrid_02_x = __warp_se_1301;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                tempvar __warp_usrid_02_x = __warp_usrid_02_x;
            
            let (__warp_se_1302) = warp_bitwise_and256(__warp_usrid_02_x, Uint256(low=3, high=0));
            
            let (__warp_se_1303) = warp_gt256(__warp_se_1302, Uint256(low=0, high=0));
            
                
                if (__warp_se_1303 != 0){
                
                    
                    let (__warp_se_1304) = warp_sub_unsafe8(__warp_usrid_03_r, 2);
                    
                    let __warp_usrid_03_r = __warp_se_1304;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }else{
                
                    
                    let (__warp_se_1305) = warp_shr256(__warp_usrid_02_x, 2);
                    
                    let __warp_usrid_02_x = __warp_se_1305;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                    tempvar __warp_usrid_02_x = __warp_usrid_02_x;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                tempvar __warp_usrid_02_x = __warp_usrid_02_x;
            
            let (__warp_se_1306) = warp_bitwise_and256(__warp_usrid_02_x, Uint256(low=1, high=0));
            
            let (__warp_se_1307) = warp_gt256(__warp_se_1306, Uint256(low=0, high=0));
            
                
                if (__warp_se_1307 != 0){
                
                    
                    let (__warp_se_1308) = warp_sub_unsafe8(__warp_usrid_03_r, 1);
                    
                    let __warp_usrid_03_r = __warp_se_1308;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                }else{
                
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_03_r = __warp_usrid_03_r;
                }
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar __warp_usrid_03_r = __warp_usrid_03_r;
        
        
        
        return (__warp_usrid_03_r,);

    }

    // @notice Transfers tokens from msg.sender to a recipient
    // @dev Calls transfer on token contract, errors with TF if transfer fails
    // @param token The contract address of the token which will be transferred
    // @param to The recipient of the transfer
    // @param value The value of the transfer
    func safeTransfer_d1660f99{syscall_ptr : felt*, range_check_ptr : felt}(__warp_usrid_00_token : felt, __warp_usrid_01_to : felt, __warp_usrid_02_value : Uint256)-> (){
    alloc_locals;


        
        let (__warp_usrid_03_data) = IERC20Minimal_warped_interface.transfer_a9059cbb(__warp_usrid_00_token, __warp_usrid_01_to, __warp_usrid_02_value);
        
        with_attr error_message("TF"){
            assert __warp_usrid_03_data = 1;
        }
        
        
        
        return ();

    }


    func __warp_conditional_computeSwapStep_100d3f74_35(__warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt)-> (__warp_rc_34 : felt, __warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt){
    alloc_locals;


        
        if (__warp_usrid_12_max != 0){
        
            
            let __warp_rc_34 = __warp_usrid_10_exactIn;
            
            let __warp_rc_34 = __warp_rc_34;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_34, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }else{
        
            
            let __warp_rc_34 = 0;
            
            let __warp_rc_34 = __warp_rc_34;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_34, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }

    }


    func __warp_conditional_computeSwapStep_100d3f74_37(__warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt)-> (__warp_rc_36 : felt, __warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt){
    alloc_locals;


        
        if (__warp_usrid_12_max != 0){
        
            
            let __warp_rc_36 = 1 - __warp_usrid_10_exactIn;
            
            let __warp_rc_36 = __warp_rc_36;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_36, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }else{
        
            
            let __warp_rc_36 = 0;
            
            let __warp_rc_36 = __warp_rc_36;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_36, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }

    }


    func __warp_conditional_computeSwapStep_100d3f74_39(__warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt)-> (__warp_rc_38 : felt, __warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt){
    alloc_locals;


        
        if (__warp_usrid_12_max != 0){
        
            
            let __warp_rc_38 = __warp_usrid_10_exactIn;
            
            let __warp_rc_38 = __warp_rc_38;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_38, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }else{
        
            
            let __warp_rc_38 = 0;
            
            let __warp_rc_38 = __warp_rc_38;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_38, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }

    }


    func __warp_conditional_computeSwapStep_100d3f74_41(__warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt)-> (__warp_rc_40 : felt, __warp_usrid_12_max : felt, __warp_usrid_10_exactIn : felt){
    alloc_locals;


        
        if (__warp_usrid_12_max != 0){
        
            
            let __warp_rc_40 = 1 - __warp_usrid_10_exactIn;
            
            let __warp_rc_40 = __warp_rc_40;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_40, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }else{
        
            
            let __warp_rc_40 = 0;
            
            let __warp_rc_40 = __warp_rc_40;
            
            let __warp_usrid_12_max = __warp_usrid_12_max;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            
            
            return (__warp_rc_40, __warp_usrid_12_max, __warp_usrid_10_exactIn);
        }

    }


    func __warp_conditional_computeSwapStep_100d3f74_43{range_check_ptr : felt}(__warp_usrid_10_exactIn : felt, __warp_usrid_07_amountOut : Uint256, __warp_usrid_03_amountRemaining : Uint256)-> (__warp_rc_42 : felt, __warp_usrid_10_exactIn : felt, __warp_usrid_07_amountOut : Uint256, __warp_usrid_03_amountRemaining : Uint256){
    alloc_locals;


        
        if (1 - __warp_usrid_10_exactIn != 0){
        
            
            let (__warp_se_1309) = warp_negate256(__warp_usrid_03_amountRemaining);
            
            let (__warp_se_1310) = warp_gt256(__warp_usrid_07_amountOut, __warp_se_1309);
            
            let __warp_rc_42 = __warp_se_1310;
            
            let __warp_rc_42 = __warp_rc_42;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            let __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
            
            let __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
            
            
            
            return (__warp_rc_42, __warp_usrid_10_exactIn, __warp_usrid_07_amountOut, __warp_usrid_03_amountRemaining);
        }else{
        
            
            let __warp_rc_42 = 0;
            
            let __warp_rc_42 = __warp_rc_42;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            let __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
            
            let __warp_usrid_03_amountRemaining = __warp_usrid_03_amountRemaining;
            
            
            
            return (__warp_rc_42, __warp_usrid_10_exactIn, __warp_usrid_07_amountOut, __warp_usrid_03_amountRemaining);
        }

    }


    func __warp_conditional_computeSwapStep_100d3f74_45(__warp_usrid_10_exactIn : felt, __warp_usrid_05_sqrtRatioNextX96 : felt, __warp_usrid_01_sqrtRatioTargetX96 : felt)-> (__warp_rc_44 : felt, __warp_usrid_10_exactIn : felt, __warp_usrid_05_sqrtRatioNextX96 : felt, __warp_usrid_01_sqrtRatioTargetX96 : felt){
    alloc_locals;


        
        if (__warp_usrid_10_exactIn != 0){
        
            
            let (__warp_se_1311) = warp_neq(__warp_usrid_05_sqrtRatioNextX96, __warp_usrid_01_sqrtRatioTargetX96);
            
            let __warp_rc_44 = __warp_se_1311;
            
            let __warp_rc_44 = __warp_rc_44;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            let __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
            
            let __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
            
            
            
            return (__warp_rc_44, __warp_usrid_10_exactIn, __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_01_sqrtRatioTargetX96);
        }else{
        
            
            let __warp_rc_44 = 0;
            
            let __warp_rc_44 = __warp_rc_44;
            
            let __warp_usrid_10_exactIn = __warp_usrid_10_exactIn;
            
            let __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
            
            let __warp_usrid_01_sqrtRatioTargetX96 = __warp_usrid_01_sqrtRatioTargetX96;
            
            
            
            return (__warp_rc_44, __warp_usrid_10_exactIn, __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_01_sqrtRatioTargetX96);
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
                
                    
                    let (__warp_se_1312) = warp_sub_unsafe24(1000000, __warp_usrid_04_feePips);
                    
                    let (__warp_se_1313) = warp_uint256(__warp_se_1312);
                    
                    let (__warp_usrid_11_amountRemainingLessFee) = mulDiv_aa9a0912(__warp_usrid_03_amountRemaining, __warp_se_1313, Uint256(low=1000000, high=0));
                    
                        
                        if (__warp_usrid_09_zeroForOne != 0){
                        
                            
                            let (__warp_pse_116) = getAmount0Delta_2c32d4b6(__warp_usrid_01_sqrtRatioTargetX96, __warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, 1);
                            
                            let __warp_usrid_06_amountIn = __warp_pse_116;
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
                        
                            
                            let (__warp_pse_117) = getAmount1Delta_48a0c5bd(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_01_sqrtRatioTargetX96, __warp_usrid_02_liquidity, 1);
                            
                            let __warp_usrid_06_amountIn = __warp_pse_117;
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
                    
                    let (__warp_se_1314) = warp_ge256(__warp_usrid_11_amountRemainingLessFee, __warp_usrid_06_amountIn);
                    
                        
                        if (__warp_se_1314 != 0){
                        
                            
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
                        
                            
                            let (__warp_pse_118) = getNextSqrtPriceFromInput_aa58276a(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, __warp_usrid_11_amountRemainingLessFee, __warp_usrid_09_zeroForOne);
                            
                            let __warp_usrid_05_sqrtRatioNextX96 = __warp_pse_118;
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
                        
                            
                            let (__warp_pse_119) = getAmount1Delta_48a0c5bd(__warp_usrid_01_sqrtRatioTargetX96, __warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, 0);
                            
                            let __warp_usrid_07_amountOut = __warp_pse_119;
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
                        
                            
                            let (__warp_pse_120) = getAmount0Delta_2c32d4b6(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_01_sqrtRatioTargetX96, __warp_usrid_02_liquidity, 0);
                            
                            let __warp_usrid_07_amountOut = __warp_pse_120;
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
                    
                    let (__warp_se_1315) = warp_negate256(__warp_usrid_03_amountRemaining);
                    
                    let (__warp_se_1316) = warp_ge256(__warp_se_1315, __warp_usrid_07_amountOut);
                    
                        
                        if (__warp_se_1316 != 0){
                        
                            
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
                        
                            
                            let (__warp_se_1317) = warp_negate256(__warp_usrid_03_amountRemaining);
                            
                            let (__warp_pse_121) = getNextSqrtPriceFromOutput_fedf2b5f(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, __warp_se_1317, __warp_usrid_09_zeroForOne);
                            
                            let __warp_usrid_05_sqrtRatioNextX96 = __warp_pse_121;
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
                
                    
                    let __warp_rc_34 = 0;
                    
                        
                        let (__warp_tv_140, __warp_tv_141, __warp_tv_142) = __warp_conditional_computeSwapStep_100d3f74_35(__warp_usrid_12_max, __warp_usrid_10_exactIn);
                        
                        let __warp_usrid_10_exactIn = __warp_tv_142;
                        
                        let __warp_usrid_12_max = __warp_tv_141;
                        
                        let __warp_rc_34 = __warp_tv_140;
                    
                        
                        if (1 - __warp_rc_34 != 0){
                        
                            
                            let (__warp_pse_122) = getAmount0Delta_2c32d4b6(__warp_usrid_05_sqrtRatioNextX96, __warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, 1);
                            
                            let __warp_usrid_06_amountIn = __warp_pse_122;
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
                    
                    let __warp_rc_36 = 0;
                    
                        
                        let (__warp_tv_143, __warp_tv_144, __warp_tv_145) = __warp_conditional_computeSwapStep_100d3f74_37(__warp_usrid_12_max, __warp_usrid_10_exactIn);
                        
                        let __warp_usrid_10_exactIn = __warp_tv_145;
                        
                        let __warp_usrid_12_max = __warp_tv_144;
                        
                        let __warp_rc_36 = __warp_tv_143;
                    
                        
                        if (1 - __warp_rc_36 != 0){
                        
                            
                            let (__warp_pse_123) = getAmount1Delta_48a0c5bd(__warp_usrid_05_sqrtRatioNextX96, __warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_02_liquidity, 0);
                            
                            let __warp_usrid_07_amountOut = __warp_pse_123;
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
                
                    
                    let __warp_rc_38 = 0;
                    
                        
                        let (__warp_tv_146, __warp_tv_147, __warp_tv_148) = __warp_conditional_computeSwapStep_100d3f74_39(__warp_usrid_12_max, __warp_usrid_10_exactIn);
                        
                        let __warp_usrid_10_exactIn = __warp_tv_148;
                        
                        let __warp_usrid_12_max = __warp_tv_147;
                        
                        let __warp_rc_38 = __warp_tv_146;
                    
                        
                        if (1 - __warp_rc_38 != 0){
                        
                            
                            let (__warp_pse_124) = getAmount1Delta_48a0c5bd(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_02_liquidity, 1);
                            
                            let __warp_usrid_06_amountIn = __warp_pse_124;
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
                    
                    let __warp_rc_40 = 0;
                    
                        
                        let (__warp_tv_149, __warp_tv_150, __warp_tv_151) = __warp_conditional_computeSwapStep_100d3f74_41(__warp_usrid_12_max, __warp_usrid_10_exactIn);
                        
                        let __warp_usrid_10_exactIn = __warp_tv_151;
                        
                        let __warp_usrid_12_max = __warp_tv_150;
                        
                        let __warp_rc_40 = __warp_tv_149;
                    
                        
                        if (1 - __warp_rc_40 != 0){
                        
                            
                            let (__warp_pse_125) = getAmount0Delta_2c32d4b6(__warp_usrid_00_sqrtRatioCurrentX96, __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_02_liquidity, 0);
                            
                            let __warp_usrid_07_amountOut = __warp_pse_125;
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
            
            let __warp_rc_42 = 0;
            
                
                let (__warp_tv_152, __warp_tv_153, __warp_tv_154, __warp_tv_155) = __warp_conditional_computeSwapStep_100d3f74_43(__warp_usrid_10_exactIn, __warp_usrid_07_amountOut, __warp_usrid_03_amountRemaining);
                
                let __warp_usrid_03_amountRemaining = __warp_tv_155;
                
                let __warp_usrid_07_amountOut = __warp_tv_154;
                
                let __warp_usrid_10_exactIn = __warp_tv_153;
                
                let __warp_rc_42 = __warp_tv_152;
            
                
                if (__warp_rc_42 != 0){
                
                    
                    let (__warp_se_1318) = warp_negate256(__warp_usrid_03_amountRemaining);
                    
                    let __warp_usrid_07_amountOut = __warp_se_1318;
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
            
            let __warp_rc_44 = 0;
            
                
                let (__warp_tv_156, __warp_tv_157, __warp_tv_158, __warp_tv_159) = __warp_conditional_computeSwapStep_100d3f74_45(__warp_usrid_10_exactIn, __warp_usrid_05_sqrtRatioNextX96, __warp_usrid_01_sqrtRatioTargetX96);
                
                let __warp_usrid_01_sqrtRatioTargetX96 = __warp_tv_159;
                
                let __warp_usrid_05_sqrtRatioNextX96 = __warp_tv_158;
                
                let __warp_usrid_10_exactIn = __warp_tv_157;
                
                let __warp_rc_44 = __warp_tv_156;
            
                
                if (__warp_rc_44 != 0){
                
                    
                    let (__warp_se_1319) = warp_sub_unsafe256(__warp_usrid_03_amountRemaining, __warp_usrid_06_amountIn);
                    
                    let __warp_usrid_08_feeAmount = __warp_se_1319;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar __warp_usrid_08_feeAmount = __warp_usrid_08_feeAmount;
                    tempvar __warp_usrid_07_amountOut = __warp_usrid_07_amountOut;
                    tempvar __warp_usrid_06_amountIn = __warp_usrid_06_amountIn;
                    tempvar __warp_usrid_05_sqrtRatioNextX96 = __warp_usrid_05_sqrtRatioNextX96;
                }else{
                
                    
                    let (__warp_se_1320) = warp_uint256(__warp_usrid_04_feePips);
                    
                    let (__warp_se_1321) = warp_sub_unsafe24(1000000, __warp_usrid_04_feePips);
                    
                    let (__warp_se_1322) = warp_uint256(__warp_se_1321);
                    
                    let (__warp_pse_126) = mulDivRoundingUp_0af8b27f(__warp_usrid_06_amountIn, __warp_se_1320, __warp_se_1322);
                    
                    let __warp_usrid_08_feeAmount = __warp_pse_126;
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

}

    // @inheritdoc IUniswapV3PoolDerivedState
    @view
    func snapshotCumulativesInside_a38807f2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_054_tickLower : felt, __warp_usrid_055_tickUpper : felt)-> (__warp_usrid_056_tickCumulativeInside : felt, __warp_usrid_057_secondsPerLiquidityInsideX128 : felt, __warp_usrid_058_secondsInside : felt){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int24(__warp_usrid_055_tickUpper);
        
        warp_external_input_check_int24(__warp_usrid_054_tickLower);
        
        let __warp_usrid_058_secondsInside = 0;
        
        let __warp_usrid_057_secondsPerLiquidityInsideX128 = 0;
        
        let __warp_usrid_056_tickCumulativeInside = 0;
        
        let (__warp_usrid_056_tickCumulativeInside, __warp_usrid_057_secondsPerLiquidityInsideX128, __warp_usrid_058_secondsInside) = UniswapV3Pool.__warp_modifier_noDelegateCall_snapshotCumulativesInside_a38807f2_9(__warp_usrid_054_tickLower, __warp_usrid_055_tickUpper, __warp_usrid_056_tickCumulativeInside, __warp_usrid_057_secondsPerLiquidityInsideX128, __warp_usrid_058_secondsInside);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return (__warp_usrid_056_tickCumulativeInside, __warp_usrid_057_secondsPerLiquidityInsideX128, __warp_usrid_058_secondsInside);
    }
    }

    // @inheritdoc IUniswapV3PoolDerivedState
    @view
    func observe_883bdbfd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_073_secondsAgos_len : felt, __warp_usrid_073_secondsAgos : felt*)-> (__warp_usrid_074_tickCumulatives_len : felt, __warp_usrid_074_tickCumulatives : felt*, __warp_usrid_075_secondsPerLiquidityCumulativeX128s_len : felt, __warp_usrid_075_secondsPerLiquidityCumulativeX128s : felt*){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check0(__warp_usrid_073_secondsAgos_len, __warp_usrid_073_secondsAgos);
        
        let (__warp_usrid_075_secondsPerLiquidityCumulativeX128s) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));
        
        let (__warp_usrid_074_tickCumulatives) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));
        
        local __warp_usrid_073_secondsAgos_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_073_secondsAgos_len, __warp_usrid_073_secondsAgos);
        
        let (__warp_td_27, __warp_td_28) = UniswapV3Pool.__warp_modifier_noDelegateCall_observe_883bdbfd_16(__warp_usrid_073_secondsAgos_dstruct, __warp_usrid_074_tickCumulatives, __warp_usrid_075_secondsPerLiquidityCumulativeX128s);
        
        let __warp_usrid_074_tickCumulatives = __warp_td_27;
        
        let __warp_usrid_075_secondsPerLiquidityCumulativeX128s = __warp_td_28;
        
        let (__warp_se_557) = wm_to_calldata0(__warp_usrid_074_tickCumulatives);
        
        let (__warp_se_558) = wm_to_calldata3(__warp_usrid_075_secondsPerLiquidityCumulativeX128s);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return (__warp_se_557.len, __warp_se_557.ptr, __warp_se_558.len, __warp_se_558.ptr);
    }
    }

    // @inheritdoc IUniswapV3PoolActions
    @external
    func increaseObservationCardinalityNext_32148f67{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_076_observationCardinalityNext : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_int16(__warp_usrid_076_observationCardinalityNext);
        
        UniswapV3Pool.__warp_modifier_lock_increaseObservationCardinalityNext_32148f67_21(__warp_usrid_076_observationCardinalityNext);
        
        let __warp_uv0 = ();
        
        
        
        return ();

    }

    // @inheritdoc IUniswapV3PoolActions
    // @dev not locked because it initializes unlocked
    @external
    func initialize_f637731d{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_079_sqrtPriceX96 : felt)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int160(__warp_usrid_079_sqrtPriceX96);
        
        let (__warp_se_559) = WSM8_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(UniswapV3Pool.__warp_usrid_039_slot0);
        
        let (__warp_se_560) = WS0_READ_felt(__warp_se_559);
        
        let (__warp_se_561) = warp_eq(__warp_se_560, 0);
        
        with_attr error_message("AI"){
            assert __warp_se_561 = 1;
        }
        
        let (__warp_usrid_080_tick) = UniswapV3Pool.getTickAtSqrtRatio_4f76c058(__warp_usrid_079_sqrtPriceX96);
        
        let (__warp_pse_55) = UniswapV3Pool._blockTimestamp_c63aa3e7();
        
        let (__warp_usrid_081_cardinality, __warp_usrid_082_cardinalityNext) = UniswapV3Pool.initialize_286f3ae4(UniswapV3Pool.__warp_usrid_047_observations, __warp_pse_55);
        
        let (__warp_se_562) = WM4_struct_Slot0_930d2817(__warp_usrid_079_sqrtPriceX96, __warp_usrid_080_tick, 0, __warp_usrid_081_cardinality, __warp_usrid_082_cardinalityNext, 0, 1);
        
        wm_to_storage0(UniswapV3Pool.__warp_usrid_039_slot0, __warp_se_562);
        
        Initialize_98636036.emit(__warp_usrid_079_sqrtPriceX96, __warp_usrid_080_tick);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }

    // @inheritdoc IUniswapV3PoolActions
    // @dev noDelegateCall is applied indirectly via _modifyPosition
    @external
    func mint_3c8a7d8d{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_104_recipient : felt, __warp_usrid_105_tickLower : felt, __warp_usrid_106_tickUpper : felt, __warp_usrid_107_amount : felt, __warp_usrid_108_data_len : felt, __warp_usrid_108_data : felt*)-> (__warp_usrid_109_amount0 : Uint256, __warp_usrid_110_amount1 : Uint256){
    alloc_locals;
    let (local keccak_ptr_start : felt*) = alloc();
    let keccak_ptr = keccak_ptr_start;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory, keccak_ptr{

        
        extern_input_check1(__warp_usrid_108_data_len, __warp_usrid_108_data);
        
        warp_external_input_check_int128(__warp_usrid_107_amount);
        
        warp_external_input_check_int24(__warp_usrid_106_tickUpper);
        
        warp_external_input_check_int24(__warp_usrid_105_tickLower);
        
        warp_external_input_check_address(__warp_usrid_104_recipient);
        
        let __warp_usrid_110_amount1 = Uint256(low=0, high=0);
        
        let __warp_usrid_109_amount0 = Uint256(low=0, high=0);
        
        local __warp_usrid_108_data_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_108_data_len, __warp_usrid_108_data);
        
        let (__warp_usrid_109_amount0, __warp_usrid_110_amount1) = UniswapV3Pool.__warp_modifier_lock_mint_3c8a7d8d_41(__warp_usrid_104_recipient, __warp_usrid_105_tickLower, __warp_usrid_106_tickUpper, __warp_usrid_107_amount, __warp_usrid_108_data_dstruct, __warp_usrid_109_amount0, __warp_usrid_110_amount1);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        finalize_keccak(keccak_ptr_start, keccak_ptr);
        
        return (__warp_usrid_109_amount0, __warp_usrid_110_amount1);
    }
    }

    // @inheritdoc IUniswapV3PoolActions
    @external
    func collect_4f1eb3d8{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_115_recipient : felt, __warp_usrid_116_tickLower : felt, __warp_usrid_117_tickUpper : felt, __warp_usrid_118_amount0Requested : felt, __warp_usrid_119_amount1Requested : felt)-> (__warp_usrid_120_amount0 : felt, __warp_usrid_121_amount1 : felt){
    alloc_locals;
    let (local keccak_ptr_start : felt*) = alloc();
    let keccak_ptr = keccak_ptr_start;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory, keccak_ptr{

        
        warp_external_input_check_int128(__warp_usrid_119_amount1Requested);
        
        warp_external_input_check_int128(__warp_usrid_118_amount0Requested);
        
        warp_external_input_check_int24(__warp_usrid_117_tickUpper);
        
        warp_external_input_check_int24(__warp_usrid_116_tickLower);
        
        warp_external_input_check_address(__warp_usrid_115_recipient);
        
        let __warp_usrid_121_amount1 = 0;
        
        let __warp_usrid_120_amount0 = 0;
        
        let (__warp_usrid_120_amount0, __warp_usrid_121_amount1) = UniswapV3Pool.__warp_modifier_lock_collect_4f1eb3d8_52(__warp_usrid_115_recipient, __warp_usrid_116_tickLower, __warp_usrid_117_tickUpper, __warp_usrid_118_amount0Requested, __warp_usrid_119_amount1Requested, __warp_usrid_120_amount0, __warp_usrid_121_amount1);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        finalize_keccak(keccak_ptr_start, keccak_ptr);
        
        return (__warp_usrid_120_amount0, __warp_usrid_121_amount1);
    }
    }

    // @inheritdoc IUniswapV3PoolActions
    // @dev noDelegateCall is applied indirectly via _modifyPosition
    @external
    func burn_a34123a7{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_123_tickLower : felt, __warp_usrid_124_tickUpper : felt, __warp_usrid_125_amount : felt)-> (__warp_usrid_126_amount0 : Uint256, __warp_usrid_127_amount1 : Uint256){
    alloc_locals;
    let (local keccak_ptr_start : felt*) = alloc();
    let keccak_ptr = keccak_ptr_start;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory, keccak_ptr{

        
        warp_external_input_check_int128(__warp_usrid_125_amount);
        
        warp_external_input_check_int24(__warp_usrid_124_tickUpper);
        
        warp_external_input_check_int24(__warp_usrid_123_tickLower);
        
        let __warp_usrid_127_amount1 = Uint256(low=0, high=0);
        
        let __warp_usrid_126_amount0 = Uint256(low=0, high=0);
        
        let (__warp_usrid_126_amount0, __warp_usrid_127_amount1) = UniswapV3Pool.__warp_modifier_lock_burn_a34123a7_61(__warp_usrid_123_tickLower, __warp_usrid_124_tickUpper, __warp_usrid_125_amount, __warp_usrid_126_amount0, __warp_usrid_127_amount1);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        finalize_keccak(keccak_ptr_start, keccak_ptr);
        
        return (__warp_usrid_126_amount0, __warp_usrid_127_amount1);
    }
    }

    // @inheritdoc IUniswapV3PoolActions
    @external
    func swap_128acb08{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_131_recipient : felt, __warp_usrid_132_zeroForOne : felt, __warp_usrid_133_amountSpecified : Uint256, __warp_usrid_134_sqrtPriceLimitX96 : felt, __warp_usrid_135_data_len : felt, __warp_usrid_135_data : felt*)-> (__warp_usrid_136_amount0 : Uint256, __warp_usrid_137_amount1 : Uint256){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check1(__warp_usrid_135_data_len, __warp_usrid_135_data);
        
        warp_external_input_check_int160(__warp_usrid_134_sqrtPriceLimitX96);
        
        warp_external_input_check_int256(__warp_usrid_133_amountSpecified);
        
        warp_external_input_check_bool(__warp_usrid_132_zeroForOne);
        
        warp_external_input_check_address(__warp_usrid_131_recipient);
        
        let __warp_usrid_137_amount1 = Uint256(low=0, high=0);
        
        let __warp_usrid_136_amount0 = Uint256(low=0, high=0);
        
        local __warp_usrid_135_data_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_135_data_len, __warp_usrid_135_data);
        
        let (__warp_usrid_136_amount0, __warp_usrid_137_amount1) = UniswapV3Pool.__warp_modifier_noDelegateCall_swap_128acb08_72(__warp_usrid_131_recipient, __warp_usrid_132_zeroForOne, __warp_usrid_133_amountSpecified, __warp_usrid_134_sqrtPriceLimitX96, __warp_usrid_135_data_dstruct, __warp_usrid_136_amount0, __warp_usrid_137_amount1);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return (__warp_usrid_136_amount0, __warp_usrid_137_amount1);
    }
    }

    // @inheritdoc IUniswapV3PoolActions
    @external
    func flash_490e6cbc{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_170_recipient : felt, __warp_usrid_171_amount0 : Uint256, __warp_usrid_172_amount1 : Uint256, __warp_usrid_173_data_len : felt, __warp_usrid_173_data : felt*)-> (){
    alloc_locals;


        
        extern_input_check1(__warp_usrid_173_data_len, __warp_usrid_173_data);
        
        warp_external_input_check_int256(__warp_usrid_172_amount1);
        
        warp_external_input_check_int256(__warp_usrid_171_amount0);
        
        warp_external_input_check_address(__warp_usrid_170_recipient);
        
        local __warp_usrid_173_data_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_usrid_173_data_len, __warp_usrid_173_data);
        
        UniswapV3Pool.__warp_modifier_lock_flash_490e6cbc_83(__warp_usrid_170_recipient, __warp_usrid_171_amount0, __warp_usrid_172_amount1, __warp_usrid_173_data_dstruct);
        
        let __warp_uv1 = ();
        
        
        
        return ();

    }

    // @inheritdoc IUniswapV3PoolOwnerActions
    @external
    func setFeeProtocol_8206a4d1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_187_feeProtocol0 : felt, __warp_usrid_188_feeProtocol1 : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_int8(__warp_usrid_188_feeProtocol1);
        
        warp_external_input_check_int8(__warp_usrid_187_feeProtocol0);
        
        UniswapV3Pool.__warp_modifier_lock_setFeeProtocol_8206a4d1_90(__warp_usrid_187_feeProtocol0, __warp_usrid_188_feeProtocol1);
        
        let __warp_uv2 = ();
        
        
        
        return ();

    }

    // @inheritdoc IUniswapV3PoolOwnerActions
    @external
    func collectProtocol_85b66729{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_usrid_190_recipient : felt, __warp_usrid_191_amount0Requested : felt, __warp_usrid_192_amount1Requested : felt)-> (__warp_usrid_193_amount0 : felt, __warp_usrid_194_amount1 : felt){
    alloc_locals;


        
        warp_external_input_check_int128(__warp_usrid_192_amount1Requested);
        
        warp_external_input_check_int128(__warp_usrid_191_amount0Requested);
        
        warp_external_input_check_address(__warp_usrid_190_recipient);
        
        let __warp_usrid_194_amount1 = 0;
        
        let __warp_usrid_193_amount0 = 0;
        
        let (__warp_usrid_193_amount0, __warp_usrid_194_amount1) = UniswapV3Pool.__warp_modifier_lock_collectProtocol_85b66729_107(__warp_usrid_190_recipient, __warp_usrid_191_amount0Requested, __warp_usrid_192_amount1Requested, __warp_usrid_193_amount0, __warp_usrid_194_amount1);
        
        
        
        return (__warp_usrid_193_amount0, __warp_usrid_194_amount1);

    }


    @view
    func factory_c45a0155{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_195_ : felt){
    alloc_locals;


        
        let (__warp_se_598) = WS0_READ_felt(UniswapV3Pool.__warp_usrid_033_factory);
        
        
        
        return (__warp_se_598,);

    }


    @view
    func token0_0dfe1681{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_196_ : felt){
    alloc_locals;


        
        let (__warp_se_599) = WS0_READ_felt(UniswapV3Pool.__warp_usrid_034_token0);
        
        
        
        return (__warp_se_599,);

    }


    @view
    func token1_d21220a7{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_197_ : felt){
    alloc_locals;


        
        let (__warp_se_600) = WS0_READ_felt(UniswapV3Pool.__warp_usrid_035_token1);
        
        
        
        return (__warp_se_600,);

    }


    @view
    func fee_ddca3f43{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_198_ : felt){
    alloc_locals;


        
        let (__warp_se_601) = WS0_READ_felt(UniswapV3Pool.__warp_usrid_036_fee);
        
        
        
        return (__warp_se_601,);

    }


    @view
    func tickSpacing_d0c93a7c{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_199_ : felt){
    alloc_locals;


        
        let (__warp_se_602) = WS0_READ_felt(UniswapV3Pool.__warp_usrid_037_tickSpacing);
        
        
        
        return (__warp_se_602,);

    }


    @view
    func maxLiquidityPerTick_70cf754a{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_200_ : felt){
    alloc_locals;


        
        let (__warp_se_603) = WS0_READ_felt(UniswapV3Pool.__warp_usrid_038_maxLiquidityPerTick);
        
        
        
        return (__warp_se_603,);

    }


    @view
    func slot0_3850c7bd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_201_ : felt, __warp_usrid_202_ : felt, __warp_usrid_203_ : felt, __warp_usrid_204_ : felt, __warp_usrid_205_ : felt, __warp_usrid_206_ : felt, __warp_usrid_207_ : felt){
    alloc_locals;


        
        let __warp_usrid_208__temp0 = UniswapV3Pool.__warp_usrid_039_slot0;
        
        let (__warp_se_604) = WSM8_Slot0_930d2817___warp_usrid_000_sqrtPriceX96(__warp_usrid_208__temp0);
        
        let (__warp_usrid_201_) = WS0_READ_felt(__warp_se_604);
        
        let (__warp_se_605) = WSM7_Slot0_930d2817___warp_usrid_001_tick(__warp_usrid_208__temp0);
        
        let (__warp_usrid_202_) = WS0_READ_felt(__warp_se_605);
        
        let (__warp_se_606) = WSM6_Slot0_930d2817___warp_usrid_002_observationIndex(__warp_usrid_208__temp0);
        
        let (__warp_usrid_203_) = WS0_READ_felt(__warp_se_606);
        
        let (__warp_se_607) = WSM5_Slot0_930d2817___warp_usrid_003_observationCardinality(__warp_usrid_208__temp0);
        
        let (__warp_usrid_204_) = WS0_READ_felt(__warp_se_607);
        
        let (__warp_se_608) = WSM11_Slot0_930d2817___warp_usrid_004_observationCardinalityNext(__warp_usrid_208__temp0);
        
        let (__warp_usrid_205_) = WS0_READ_felt(__warp_se_608);
        
        let (__warp_se_609) = WSM4_Slot0_930d2817___warp_usrid_005_feeProtocol(__warp_usrid_208__temp0);
        
        let (__warp_usrid_206_) = WS0_READ_felt(__warp_se_609);
        
        let (__warp_se_610) = WSM1_Slot0_930d2817___warp_usrid_006_unlocked(__warp_usrid_208__temp0);
        
        let (__warp_usrid_207_) = WS0_READ_felt(__warp_se_610);
        
        
        
        return (__warp_usrid_201_, __warp_usrid_202_, __warp_usrid_203_, __warp_usrid_204_, __warp_usrid_205_, __warp_usrid_206_, __warp_usrid_207_);

    }


    @view
    func feeGrowthGlobal0X128_f3058399{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_209_ : Uint256){
    alloc_locals;


        
        let (__warp_se_611) = WS1_READ_Uint256(UniswapV3Pool.__warp_usrid_040_feeGrowthGlobal0X128);
        
        
        
        return (__warp_se_611,);

    }


    @view
    func feeGrowthGlobal1X128_46141319{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_210_ : Uint256){
    alloc_locals;


        
        let (__warp_se_612) = WS1_READ_Uint256(UniswapV3Pool.__warp_usrid_041_feeGrowthGlobal1X128);
        
        
        
        return (__warp_se_612,);

    }


    @view
    func protocolFees_1ad8b03b{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_211_ : felt, __warp_usrid_212_ : felt){
    alloc_locals;


        
        let __warp_usrid_213__temp0 = UniswapV3Pool.__warp_usrid_042_protocolFees;
        
        let (__warp_se_613) = WSM2_ProtocolFees_bf8b310b___warp_usrid_007_token0(__warp_usrid_213__temp0);
        
        let (__warp_usrid_211_) = WS0_READ_felt(__warp_se_613);
        
        let (__warp_se_614) = WSM3_ProtocolFees_bf8b310b___warp_usrid_008_token1(__warp_usrid_213__temp0);
        
        let (__warp_usrid_212_) = WS0_READ_felt(__warp_se_614);
        
        
        
        return (__warp_usrid_211_, __warp_usrid_212_);

    }


    @view
    func liquidity_1a686502{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_usrid_214_ : felt){
    alloc_locals;


        
        let (__warp_se_615) = WS0_READ_felt(UniswapV3Pool.__warp_usrid_043_liquidity);
        
        
        
        return (__warp_se_615,);

    }


    @view
    func ticks_f30dba93{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_usrid_215__i0 : felt)-> (__warp_usrid_216_ : felt, __warp_usrid_217_ : felt, __warp_usrid_218_ : Uint256, __warp_usrid_219_ : Uint256, __warp_usrid_220_ : felt, __warp_usrid_221_ : felt, __warp_usrid_222_ : felt, __warp_usrid_223_ : felt){
    alloc_locals;


        
        warp_external_input_check_int24(__warp_usrid_215__i0);
        
        let (__warp_usrid_224__temp0) = WS0_INDEX_felt_to_Info_39bc053d(UniswapV3Pool.__warp_usrid_044_ticks, __warp_usrid_215__i0);
        
        let (__warp_se_616) = WSM16_Info_39bc053d___warp_usrid_00_liquidityGross(__warp_usrid_224__temp0);
        
        let (__warp_usrid_216_) = WS0_READ_felt(__warp_se_616);
        
        let (__warp_se_617) = WSM17_Info_39bc053d___warp_usrid_01_liquidityNet(__warp_usrid_224__temp0);
        
        let (__warp_usrid_217_) = WS0_READ_felt(__warp_se_617);
        
        let (__warp_se_618) = WSM18_Info_39bc053d___warp_usrid_02_feeGrowthOutside0X128(__warp_usrid_224__temp0);
        
        let (__warp_usrid_218_) = WS1_READ_Uint256(__warp_se_618);
        
        let (__warp_se_619) = WSM19_Info_39bc053d___warp_usrid_03_feeGrowthOutside1X128(__warp_usrid_224__temp0);
        
        let (__warp_usrid_219_) = WS1_READ_Uint256(__warp_se_619);
        
        let (__warp_se_620) = WSM12_Info_39bc053d___warp_usrid_04_tickCumulativeOutside(__warp_usrid_224__temp0);
        
        let (__warp_usrid_220_) = WS0_READ_felt(__warp_se_620);
        
        let (__warp_se_621) = WSM13_Info_39bc053d___warp_usrid_05_secondsPerLiquidityOutsideX128(__warp_usrid_224__temp0);
        
        let (__warp_usrid_221_) = WS0_READ_felt(__warp_se_621);
        
        let (__warp_se_622) = WSM14_Info_39bc053d___warp_usrid_06_secondsOutside(__warp_usrid_224__temp0);
        
        let (__warp_usrid_222_) = WS0_READ_felt(__warp_se_622);
        
        let (__warp_se_623) = WSM15_Info_39bc053d___warp_usrid_07_initialized(__warp_usrid_224__temp0);
        
        let (__warp_usrid_223_) = WS0_READ_felt(__warp_se_623);
        
        
        
        return (__warp_usrid_216_, __warp_usrid_217_, __warp_usrid_218_, __warp_usrid_219_, __warp_usrid_220_, __warp_usrid_221_, __warp_usrid_222_, __warp_usrid_223_);

    }


    @view
    func tickBitmap_5339c296{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_usrid_225__i0 : felt)-> (__warp_usrid_226_ : Uint256){
    alloc_locals;


        
        warp_external_input_check_int16(__warp_usrid_225__i0);
        
        let (__warp_se_624) = WS1_INDEX_felt_to_Uint256(UniswapV3Pool.__warp_usrid_045_tickBitmap, __warp_usrid_225__i0);
        
        let (__warp_se_625) = WS1_READ_Uint256(__warp_se_624);
        
        
        
        return (__warp_se_625,);

    }


    @view
    func positions_514ea4bf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_usrid_227__i0 : Uint256)-> (__warp_usrid_228_ : felt, __warp_usrid_229_ : Uint256, __warp_usrid_230_ : Uint256, __warp_usrid_231_ : felt, __warp_usrid_232_ : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_usrid_227__i0);
        
        let (__warp_usrid_233__temp0) = WS2_INDEX_Uint256_to_Info_d529aac3(UniswapV3Pool.__warp_usrid_046_positions, __warp_usrid_227__i0);
        
        let (__warp_se_626) = WSM20_Info_d529aac3___warp_usrid_00_liquidity(__warp_usrid_233__temp0);
        
        let (__warp_usrid_228_) = WS0_READ_felt(__warp_se_626);
        
        let (__warp_se_627) = WSM21_Info_d529aac3___warp_usrid_01_feeGrowthInside0LastX128(__warp_usrid_233__temp0);
        
        let (__warp_usrid_229_) = WS1_READ_Uint256(__warp_se_627);
        
        let (__warp_se_628) = WSM22_Info_d529aac3___warp_usrid_02_feeGrowthInside1LastX128(__warp_usrid_233__temp0);
        
        let (__warp_usrid_230_) = WS1_READ_Uint256(__warp_se_628);
        
        let (__warp_se_629) = WSM9_Info_d529aac3___warp_usrid_03_tokensOwed0(__warp_usrid_233__temp0);
        
        let (__warp_usrid_231_) = WS0_READ_felt(__warp_se_629);
        
        let (__warp_se_630) = WSM10_Info_d529aac3___warp_usrid_04_tokensOwed1(__warp_usrid_233__temp0);
        
        let (__warp_usrid_232_) = WS0_READ_felt(__warp_se_630);
        
        
        
        return (__warp_usrid_228_, __warp_usrid_229_, __warp_usrid_230_, __warp_usrid_231_, __warp_usrid_232_);

    }


    @view
    func observations_252c09d7{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_usrid_234__i0 : Uint256)-> (__warp_usrid_235_ : felt, __warp_usrid_236_ : felt, __warp_usrid_237_ : felt, __warp_usrid_238_ : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_usrid_234__i0);
        
        let (__warp_usrid_239__temp0) = WS0_IDX(UniswapV3Pool.__warp_usrid_047_observations, __warp_usrid_234__i0, Uint256(low=4, high=0), Uint256(low=65535, high=0));
        
        let (__warp_se_631) = WSM0_Observation_2cc4d695___warp_usrid_00_blockTimestamp(__warp_usrid_239__temp0);
        
        let (__warp_usrid_235_) = WS0_READ_felt(__warp_se_631);
        
        let (__warp_se_632) = WSM23_Observation_2cc4d695___warp_usrid_01_tickCumulative(__warp_usrid_239__temp0);
        
        let (__warp_usrid_236_) = WS0_READ_felt(__warp_se_632);
        
        let (__warp_se_633) = WSM24_Observation_2cc4d695___warp_usrid_02_secondsPerLiquidityCumulativeX128(__warp_usrid_239__temp0);
        
        let (__warp_usrid_237_) = WS0_READ_felt(__warp_se_633);
        
        let (__warp_se_634) = WSM25_Observation_2cc4d695___warp_usrid_03_initialized(__warp_usrid_239__temp0);
        
        let (__warp_usrid_238_) = WS0_READ_felt(__warp_se_634);
        
        
        
        return (__warp_usrid_235_, __warp_usrid_236_, __warp_usrid_237_, __warp_usrid_238_);

    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(){
    alloc_locals;
    WARP_USED_STORAGE.write(262164);
    WARP_NAMEGEN.write(3);


        
        UniswapV3Pool.__warp_constructor_0();
        
        // UniswapV3Pool.__warp_constructor_1();
        
        
        
        return ();

    }


// Contract Def IUniswapV3Factory@interface


@contract_interface
namespace IUniswapV3Factory_warped_interface{
    func owner_8da5cb5b()-> (__warp_usrid_09_ : felt){
    }
    
    func feeAmountTickSpacing_22afcccb(__warp_usrid_10_fee : felt)-> (__warp_usrid_11_ : felt){
    }
    
    func getPool_1698ee82(__warp_usrid_12_tokenA : felt, __warp_usrid_13_tokenB : felt, __warp_usrid_14_fee : felt)-> (__warp_usrid_15_pool : felt){
    }
    
    func createPool_a1671295(__warp_usrid_16_tokenA : felt, __warp_usrid_17_tokenB : felt, __warp_usrid_18_fee : felt)-> (__warp_usrid_19_pool : felt){
    }
    
    func setOwner_13af4035(__warp_usrid_20__owner : felt)-> (){
    }
    
    func enableFeeAmount_8a7c195f(__warp_usrid_21_fee : felt, __warp_usrid_22_tickSpacing : felt)-> (){
    }
    
}


// Contract Def IUniswapV3PoolDeployer@interface


@contract_interface
namespace IUniswapV3PoolDeployer_warped_interface{
    func parameters_89035730()-> (__warp_usrid_00_factory : felt, __warp_usrid_01_token0 : felt, __warp_usrid_02_token1 : felt, __warp_usrid_03_fee : felt, __warp_usrid_04_tickSpacing : felt){
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


// Contract Def IUniswapV3MintCallback@interface


@contract_interface
namespace IUniswapV3MintCallback_warped_interface{
    func uniswapV3MintCallback_d3487997(__warp_usrid_00_amount0Owed : Uint256, __warp_usrid_01_amount1Owed : Uint256, __warp_usrid_02_data_len : felt, __warp_usrid_02_data : felt*)-> (){
    }
    
}


// Contract Def IUniswapV3SwapCallback@interface


@contract_interface
namespace IUniswapV3SwapCallback_warped_interface{
    func uniswapV3SwapCallback_fa461e33(__warp_usrid_00_amount0Delta : Uint256, __warp_usrid_01_amount1Delta : Uint256, __warp_usrid_02_data_len : felt, __warp_usrid_02_data : felt*)-> (){
    }
    
}


// Contract Def IUniswapV3FlashCallback@interface


@contract_interface
namespace IUniswapV3FlashCallback_warped_interface{
    func uniswapV3FlashCallback_e9cbafb0(__warp_usrid_00_fee0 : Uint256, __warp_usrid_01_fee1 : Uint256, __warp_usrid_02_data_len : felt, __warp_usrid_02_data : felt*)-> (){
    }
    
}

// Original soldity abi: ["constructor()","","snapshotCumulativesInside(int24,int24)","observe(uint32[])","increaseObservationCardinalityNext(uint16)","initialize(uint160)","mint(address,int24,int24,uint128,bytes)","collect(address,int24,int24,uint128,uint128)","burn(int24,int24,uint128)","swap(address,bool,int256,uint160,bytes)","flash(address,uint256,uint256,bytes)","setFeeProtocol(uint8,uint8)","collectProtocol(address,uint128,uint128)","factory()","token0()","token1()","fee()","tickSpacing()","maxLiquidityPerTick()","slot0()","feeGrowthGlobal0X128()","feeGrowthGlobal1X128()","protocolFees()","liquidity()","ticks(int24)","tickBitmap(int16)","positions(bytes32)","observations(uint256)"]
