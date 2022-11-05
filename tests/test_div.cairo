%lang starknet
from starkware.cairo.common.uint256 import uint256_mul, uint256_lt, uint256_add, uint256_check, Uint256
from starkware.cairo.common.math import split_felt

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

@external
func test_mul_mod{range_check_ptr}(a: felt, b: felt, div: felt) {
    if (div == 0) {
        let (high, low) = split_felt(a);
        let au = Uint256(low, high);
        let (high, low) = split_felt(b);
        let bu = Uint256(low, high);
        let (high, low) = split_felt(div);
        let divu = Uint256(low, high);
        return ();
    } else {
        let (high, low) = split_felt(a);
        let au = Uint256(low, high);
        let (high, low) = split_felt(b);
        let bu = Uint256(low, high);
        let (high, low) = split_felt(div);
        let divu = Uint256(low, high);
        uint256_mul_div_mod(au, bu, divu);
    }
    return ();
}
