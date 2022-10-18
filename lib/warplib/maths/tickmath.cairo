%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math_cmp import is_le, is_le_felt
from starkware.cairo.common.math import assert_le, assert_lt
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.uint256 import (
    Uint256,
    SHIFT,
    ALL_ONES,
    uint256_add,
    uint256_sub,
    uint256_le,
    uint256_shl,
    uint256_shr,
    uint256_or,
    uint256_mul,
    uint256_unsigned_div_rem,
    uint256_signed_nn,
    uint256_cond_neg,
    uint256_neg,
    uint256_lt,
)

from warplib.maths.utils import felt_to_uint256

namespace TickMathLib {
    const MIN_TICK = 0xf27618;

    const MAX_TICK = 0xd89e8;

    const MIN_SQRT_RATIO = 4295128739;

    const MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;

    func le_signed24{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(lhs: felt, rhs: felt) -> (
        res: felt
    ) {
        alloc_locals;
        let (lhs_msb: felt) = bitwise_and(lhs, 0x800000);
        let (rhs_msb: felt) = bitwise_and(rhs, 0x800000);
        local bitwise_ptr: BitwiseBuiltin* = bitwise_ptr;
        if (lhs_msb == 0) {
            // lhs >= 0
            if (rhs_msb == 0) {
                // rhs >= 0
                let result = is_le_felt(lhs, rhs);
                return (result,);
            } else {
                // rhs < 0
                return (0,);
            }
        } else {
            // lhs < 0
            if (rhs_msb == 0) {
                // rhs >= 0
                return (1,);
            } else {
                // rhs < 0
                // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
                let result = is_le_felt(lhs, rhs);
                return (result,);
            }
        }
    }

    func abs_felt{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(num: felt) -> (num: felt) {
        alloc_locals;
        let (is_negative) = le_signed24(num, 16777215);

        if (is_negative == 1) {
            let (num) = bitwise_xor(2 ** 24 - 1, num);
            let num = num + 1;
            let (num) = bitwise_and(num, 2 ** 24 - 1);
            return (num,);
        } else {
            return (num,);
        }
    }

    func init_ratio{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
        condition: felt, left: Uint256, right: Uint256
    ) -> (init: Uint256) {
        alloc_locals;
        if (condition != 0) {
            return (left,);
        } else {
            return (right,);
        }
    }

    func step_pow{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
        condition: felt, ratio: Uint256, step_constant: felt
    ) -> (init: Uint256) {
        alloc_locals;
        let (step_constant_uint256) = felt_to_uint256(step_constant);

        if (condition != 0) {
            let (ratio, _) = uint256_mul(ratio, step_constant_uint256);
            let (ratio) = uint256_shr(ratio, Uint256(128, 0));
            return (ratio,);
        } else {
            return (ratio,);
        }
    }

    func get_ratio_at_tick{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(tick: felt) -> (
        price_x192: Uint256
    ) {
        let (sqrt_price_x96: Uint256) = get_sqrt_ratio_at_tick(tick);
        let (result: Uint256, carry: Uint256) = uint256_mul(sqrt_price_x96, sqrt_price_x96);
        assert carry = Uint256(0, 0);
        return (result,);
    }

    func get_sqrt_ratio_at_tick_external{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(tick: felt)
    -> (price: felt) {
      alloc_locals;
      let (res: Uint256) = get_sqrt_ratio_at_tick(tick);
      let final_res = res.low + res.high * 2**128;
      return (final_res,);
    }

    func get_sqrt_ratio_at_tick{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(tick: felt) -> (
        sqrt_price_x96: Uint256
    ) {
        alloc_locals;

        let (abs_tick) = abs_felt(tick);

        with_attr error_message("T {abs_tick}") {
            let less_than_max_tick = is_le(abs_tick, MAX_TICK);
            assert less_than_max_tick = 1;
        }

        let (first_bit_on) = bitwise_and(abs_tick, 0x1);
        let (left_uint256) = felt_to_uint256(0xfffcb933bd6fad37aa2d162d1a594001);
        let (ratio) = init_ratio(first_bit_on, left_uint256, Uint256(0, 1));

        let (second_bit_on) = bitwise_and(abs_tick, 0x2);
        let (ratio) = step_pow(second_bit_on, ratio, 0xfff97272373d413259a46990580e213a);

        let (third_bit_on) = bitwise_and(abs_tick, 0x4);
        let (ratio) = step_pow(third_bit_on, ratio, 0xfff2e50f5f656932ef12357cf3c7fdcc);

        let (fourth_bit_on) = bitwise_and(abs_tick, 0x8);
        let (ratio) = step_pow(fourth_bit_on, ratio, 0xffe5caca7e10e4e61c3624eaa0941cd0);

        let (fifth_bit_on) = bitwise_and(abs_tick, 0x10);
        let (ratio) = step_pow(fifth_bit_on, ratio, 0xffcb9843d60f6159c9db58835c926644);

        let (sixth_bit_on) = bitwise_and(abs_tick, 0x20);
        let (ratio) = step_pow(sixth_bit_on, ratio, 0xff973b41fa98c081472e6896dfb254c0);

        let (seventh_bit_on) = bitwise_and(abs_tick, 0x40);
        let (ratio) = step_pow(seventh_bit_on, ratio, 0xff2ea16466c96a3843ec78b326b52861);

        let (eightth_bit_on) = bitwise_and(abs_tick, 0x80);
        let (ratio) = step_pow(eightth_bit_on, ratio, 0xfe5dee046a99a2a811c461f1969c3053);

        let (ninth_bit_on) = bitwise_and(abs_tick, 0x100);
        let (ratio) = step_pow(ninth_bit_on, ratio, 0xfcbe86c7900a88aedcffc83b479aa3a4);

        let (tenth_bit_on) = bitwise_and(abs_tick, 0x200);
        let (ratio) = step_pow(tenth_bit_on, ratio, 0xf987a7253ac413176f2b074cf7815e54);

        let (eleventh_bit_on) = bitwise_and(abs_tick, 0x400);
        let (ratio) = step_pow(eleventh_bit_on, ratio, 0xf3392b0822b70005940c7a398e4b70f3);

        let (twelfth_bit_on) = bitwise_and(abs_tick, 0x800);
        let (ratio) = step_pow(twelfth_bit_on, ratio, 0xe7159475a2c29b7443b29c7fa6e889d9);

        let (thirteenth_bit_on) = bitwise_and(abs_tick, 0x1000);
        let (ratio) = step_pow(thirteenth_bit_on, ratio, 0xd097f3bdfd2022b8845ad8f792aa5825);

        let (fourteenth_bit_on) = bitwise_and(abs_tick, 0x2000);
        let (ratio) = step_pow(fourteenth_bit_on, ratio, 0xa9f746462d870fdf8a65dc1f90e061e5);

        let (fifteenth_bit_on) = bitwise_and(abs_tick, 0x4000);
        let (ratio) = step_pow(fifteenth_bit_on, ratio, 0x70d869a156d2a1b890bb3df62baf32f7);

        let (sixteenth_bit_on) = bitwise_and(abs_tick, 0x8000);
        let (ratio) = step_pow(sixteenth_bit_on, ratio, 0x31be135f97d08fd981231505542fcfa6);

        let (seventeenth_bit_on) = bitwise_and(abs_tick, 0x10000);
        let (ratio) = step_pow(seventeenth_bit_on, ratio, 0x9aa508b5b7a84e1c677de54f3e99bc9);

        let (eighteenth_bit_on) = bitwise_and(abs_tick, 0x20000);
        let (ratio) = step_pow(eighteenth_bit_on, ratio, 0x5d6af8dedb81196699c329225ee604);

        let (ninteenth_bit_on) = bitwise_and(abs_tick, 0x40000);
        let (ratio) = step_pow(ninteenth_bit_on, ratio, 0x2216e584f5fa1ea926041bedfe98);

        let (twentieth_bit_on) = bitwise_and(abs_tick, 0x80000);
        let (ratio) = step_pow(twentieth_bit_on, ratio, 0x48a170391f7dc42444e8fa2);

        let (positive_tick) = le_signed24(0, tick);

        if (positive_tick == 1) {
            let uint256_max = Uint256(ALL_ONES, ALL_ONES);
            let (ratio, _) = uint256_unsigned_div_rem(uint256_max, ratio);
            tempvar ratio = ratio;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            tempvar ratio = ratio;
            tempvar range_check_ptr = range_check_ptr;
        }

        // Compiler being stupid
        local ratio: Uint256 = ratio;
        let (int) = uint256_shr(ratio, Uint256(32, 0));
        let (_, rem) = uint256_unsigned_div_rem(ratio, Uint256(2 ** 32, 0));

        if (rem.low == 0) {
            if (rem.high == 0) {
                let (sqrt_price_X96, _) = uint256_add(int, rem);
                return (sqrt_price_X96,);
            }
        }

        let (sqrt_price_X96, _) = uint256_add(int, Uint256(1, 0));
        return (sqrt_price_X96,);
    }

    func one_round{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
        shift_offset: felt, ratio: Uint256, msb: Uint256, flag_: felt
    ) -> (ratio: Uint256, msb: Uint256) {
        alloc_locals;
        let (flag_uint256) = felt_to_uint256(flag_);

        let (turn_bit_on) = uint256_le(ratio, flag_uint256);
        let turn_bit_on = 1 - turn_bit_on;

        let (f: Uint256) = uint256_shl(Uint256(turn_bit_on, 0), Uint256(shift_offset, 0));
        let (msb: Uint256) = uint256_or(msb, f);
        let (ratio: Uint256) = uint256_shr(ratio, f);

        return (ratio, msb);
    }

    func second_round{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
        r: Uint256, log_2: Uint256, shift_offset: felt
    ) -> (r: Uint256, log_2: Uint256) {
        alloc_locals;
        let (r_square, _) = uint256_mul(r, r);
        let (r) = uint256_shr(r_square, Uint256(127, 0));

        let (f) = uint256_shr(r, Uint256(128, 0));
        let (flag) = uint256_shl(f, Uint256(shift_offset, 0));

        let (log_2) = uint256_or(log_2, flag);
        let (r) = uint256_shr(r, f);

        return (r, log_2);
    }

    func get_tick_at_sqrt_ratio_external{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(sqrt_price_X96: felt
    ) -> (tick: felt){
      alloc_locals;
      let (in_uint256) = felt_to_uint256(sqrt_price_X96);
      let (res) = get_tick_at_sqrt_ratio(in_uint256);
      return (res,);
    }

    func get_tick_at_sqrt_ratio{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
        sqrt_price_X96: Uint256
    ) -> (tick: felt) {
        alloc_locals;
        with_attr error_message("R {sqrt_price_X96}") {
            let (max_sqrt_ratio_256) = felt_to_uint256(MAX_SQRT_RATIO);
            let (min_sqrt_ratio_256) = felt_to_uint256(MIN_SQRT_RATIO);
            let (lt) = uint256_lt(sqrt_price_X96, max_sqrt_ratio_256);
            let (le) = uint256_le(min_sqrt_ratio_256, sqrt_price_X96);
            assert le = 1;
            assert lt = 1;
        }

        let (ratio) = uint256_shl(sqrt_price_X96, Uint256(32, 0));

        let r = ratio;
        let msb = Uint256(0, 0);

        let (r, msb) = one_round(7, r, msb, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);

        let (r, msb) = one_round(6, r, msb, 0xFFFFFFFFFFFFFFFF);

        let (r, msb) = one_round(5, r, msb, 0xFFFFFFFF);

        let (r, msb) = one_round(4, r, msb, 0xFFFF);

        let (r, msb) = one_round(3, r, msb, 0xFF);

        let (r, msb) = one_round(2, r, msb, 0xF);

        let (r, msb) = one_round(1, r, msb, 0x3);

        let (_, msb) = one_round(0, r, msb, 0x1);

        let (gt_128) = uint256_le(Uint256(128, 0), msb);
        if (gt_128 == 1) {
            let (shift) = uint256_sub(msb, Uint256(127, 0));
            let (r) = uint256_shr(ratio, shift);
        } else {
            let (shift) = uint256_sub(Uint256(127, 0), msb);
            let (r) = uint256_shl(ratio, shift);
        }
        local r: Uint256 = r;
        // Needs to be signed
        let (log_2) = uint256_sub(msb, Uint256(128, 0));
        let (log_2) = uint256_shl(log_2, Uint256(64, 0));

        let (r, log_2) = second_round(r, log_2, 63);

        let (r, log_2) = second_round(r, log_2, 62);

        let (r, log_2) = second_round(r, log_2, 61);

        let (r, log_2) = second_round(r, log_2, 60);

        let (r, log_2) = second_round(r, log_2, 59);

        let (r, log_2) = second_round(r, log_2, 58);

        let (r, log_2) = second_round(r, log_2, 57);

        let (r, log_2) = second_round(r, log_2, 56);

        let (r, log_2) = second_round(r, log_2, 55);

        let (r, log_2) = second_round(r, log_2, 54);

        let (r, log_2) = second_round(r, log_2, 53);

        let (r, log_2) = second_round(r, log_2, 52);

        let (r, log_2) = second_round(r, log_2, 51);

        let (r, log_2) = second_round(r, log_2, 50);

        let (log_sqrt10001) = mul_signed256(log_2, Uint256(255738958999603826347141, 0));

        let (tick_low) = uint256_sub(
            log_sqrt10001, Uint256(3402992956809132418596140100660247210, 0)
        );
        let (tick_low) = uint256_shr(tick_low, Uint256(128, 0));

        let (tick_high, _) = uint256_add(
            log_sqrt10001, Uint256(291339464771989622907027621153398088495, 0)
        );
        let (tick_high) = uint256_shr(tick_high, Uint256(128, 0));

        if (tick_low.low == tick_high.low) {
            if (tick_low.high == tick_high.high) {
                let res = tick_low.low + 2 ** 128 * tick_low.high;
                let (res) = bitwise_and(res, 2 ** 24 - 1);
                return (res,);
            }
        }
        let res = tick_high.low + 2 ** 128 * tick_low.high;
        let (res) = bitwise_and(res, 2 ** 24 - 1);
        let (ratio_at_tick_high) = get_sqrt_ratio_at_tick(res);
        let (less_than_price) = uint256_le(ratio_at_tick_high, sqrt_price_X96);
        if (less_than_price == 1) {
            return (res,);
        } else {
            let res = tick_low.low + 2 ** 128 * tick_low.high;
            let (res) = bitwise_and(res, 2 ** 24 - 1);
            return (res,);
        }
    }

    func mul_signed256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
        lhs: Uint256, rhs: Uint256
    ) -> (result: Uint256) {
        alloc_locals;
        // 1 => lhs >= 0, 0 => lhs < 0
        let (lhs_nn) = uint256_signed_nn(lhs);
        // 1 => rhs >= 0, 0 => rhs < 0
        let (local rhs_nn) = uint256_signed_nn(rhs);
        // negates if arg is 1, which is if lhs_nn is 0, which is if lhs < 0
        let (lhs_abs) = uint256_cond_neg(lhs, 1 - lhs_nn);
        // negates if arg is 1
        let (rhs_abs) = uint256_cond_neg(rhs, 1 - rhs_nn);
        let (res_abs, overflow) = uint256_mul(lhs_abs, rhs_abs);
        assert overflow.low = 0;
        assert overflow.high = 0;
        let res_should_be_neg = lhs_nn + rhs_nn;
        if (res_should_be_neg == 1) {
            let (in_range) = uint256_le(res_abs, Uint256(0, 0x80000000000000000000000000000000));
            assert in_range = 1;
            let (negated) = uint256_neg(res_abs);
            return (negated,);
        } else {
            let (msb) = bitwise_and(res_abs.high, 0x80000000000000000000000000000000);
            assert msb = 0;
            return (res_abs,);
        }
    }
}
