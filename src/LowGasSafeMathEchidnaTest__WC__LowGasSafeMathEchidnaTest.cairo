%lang starknet

from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from starkware.cairo.common.uint256 import Uint256
from warplib.maths.add import warp_add256
from warplib.maths.eq import warp_eq256, warp_eq
from warplib.maths.ge import warp_ge256
from warplib.maths.and_ import warp_and_
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.sub import warp_sub256
from warplib.maths.le import warp_le256
from warplib.maths.mul import warp_mul256
from warplib.maths.or import warp_or
from warplib.maths.add_signed import warp_add_signed256
from warplib.maths.lt_signed import warp_lt_signed256
from warplib.maths.ge_signed import warp_ge_signed256
from warplib.maths.sub_signed import warp_sub_signed256
from warplib.maths.gt_signed import warp_gt_signed256
from warplib.maths.le_signed import warp_le_signed256
from warplib.maths.div import warp_div256

// Contract Def LowGasSafeMathEchidnaTest

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

namespace LowGasSafeMathEchidnaTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    func checkAddi_9239e777_if_part1() -> () {
        alloc_locals;

        return ();
    }

    func checkSubi_bd78b20d_if_part1() -> () {
        alloc_locals;

        return ();
    }

    // @notice Returns x + y, reverts if sum overflows uint256
    // @param x The augend
    // @param y The addend
    // @return z The sum of x and y
    func s1___warp_usrfn_00_add{range_check_ptr: felt}(
        __warp_usrid_05_x: Uint256, __warp_usrid_06_y: Uint256
    ) -> (__warp_usrid_07_z: Uint256) {
        alloc_locals;

        let __warp_usrid_07_z = Uint256(low=0, high=0);

        let (__warp_se_27) = warp_add256(__warp_usrid_05_x, __warp_usrid_06_y);

        let __warp_se_28 = __warp_se_27;

        let __warp_usrid_07_z = __warp_se_28;

        let (__warp_se_29) = warp_ge256(__warp_se_28, __warp_usrid_05_x);

        assert __warp_se_29 = 1;

        return (__warp_usrid_07_z,);
    }

    // @notice Returns x - y, reverts if underflows
    // @param x The minuend
    // @param y The subtrahend
    // @return z The difference of x and y
    func s1___warp_usrfn_01_sub{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_08_x: Uint256, __warp_usrid_09_y: Uint256
    ) -> (__warp_usrid_10_z: Uint256) {
        alloc_locals;

        let __warp_usrid_10_z = Uint256(low=0, high=0);

        let (__warp_se_30) = warp_sub256(__warp_usrid_08_x, __warp_usrid_09_y);

        let __warp_se_31 = __warp_se_30;

        let __warp_usrid_10_z = __warp_se_31;

        let (__warp_se_32) = warp_le256(__warp_se_31, __warp_usrid_08_x);

        assert __warp_se_32 = 1;

        return (__warp_usrid_10_z,);
    }

    func _conditional0{range_check_ptr: felt}(
        __warp_usrid_11_x: Uint256, __warp_usrid_13_z: Uint256, __warp_usrid_12_y: Uint256
    ) -> (
        ret_conditional0: felt,
        __warp_usrid_11_x: Uint256,
        __warp_usrid_13_z: Uint256,
        __warp_usrid_12_y: Uint256,
    ) {
        alloc_locals;

        let (__warp_se_33) = warp_eq256(__warp_usrid_11_x, Uint256(low=0, high=0));

        if (__warp_se_33 != 0) {
            let ret_conditional0 = 1;

            return (ret_conditional0, __warp_usrid_11_x, __warp_usrid_13_z, __warp_usrid_12_y);
        } else {
            let (__warp_se_34) = warp_mul256(__warp_usrid_11_x, __warp_usrid_12_y);

            let __warp_se_35 = __warp_se_34;

            let __warp_usrid_13_z = __warp_se_35;

            let (__warp_se_36) = warp_div256(__warp_se_35, __warp_usrid_11_x);

            let (__warp_se_37) = warp_eq256(__warp_se_36, __warp_usrid_12_y);

            let ret_conditional0 = __warp_se_37;

            return (ret_conditional0, __warp_usrid_11_x, __warp_usrid_13_z, __warp_usrid_12_y);
        }
    }

    // @notice Returns x * y, reverts if overflows
    // @param x The multiplicand
    // @param y The multiplier
    // @return z The product of x and y
    func s1___warp_usrfn_02_mul{range_check_ptr: felt}(
        __warp_usrid_11_x: Uint256, __warp_usrid_12_y: Uint256
    ) -> (__warp_usrid_13_z: Uint256) {
        alloc_locals;

        let __warp_usrid_13_z = Uint256(low=0, high=0);

        let ret_conditional1 = 0;

        let (
            ret_conditional1, __warp_usrid_11_x, __warp_usrid_13_z, __warp_usrid_12_y
        ) = _conditional0(__warp_usrid_11_x, __warp_usrid_13_z, __warp_usrid_12_y);

        assert ret_conditional1 = 1;

        return (__warp_usrid_13_z,);
    }

    // @notice Returns x + y, reverts if overflows or underflows
    // @param x The augend
    // @param y The addend
    // @return z The sum of x and y
    func s1___warp_usrfn_03_add{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_14_x: Uint256, __warp_usrid_15_y: Uint256
    ) -> (__warp_usrid_16_z: Uint256) {
        alloc_locals;

        let __warp_usrid_16_z = Uint256(low=0, high=0);

        let (__warp_se_38) = warp_add_signed256(__warp_usrid_14_x, __warp_usrid_15_y);

        let __warp_se_39 = __warp_se_38;

        let __warp_usrid_16_z = __warp_se_39;

        let (__warp_se_40) = warp_ge_signed256(__warp_se_39, __warp_usrid_14_x);

        let (__warp_se_41) = warp_ge_signed256(__warp_usrid_15_y, Uint256(low=0, high=0));

        let (__warp_se_42) = warp_eq(__warp_se_40, __warp_se_41);

        assert __warp_se_42 = 1;

        return (__warp_usrid_16_z,);
    }

    // @notice Returns x - y, reverts if overflows or underflows
    // @param x The minuend
    // @param y The subtrahend
    // @return z The difference of x and y
    func s1___warp_usrfn_04_sub{range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
        __warp_usrid_17_x: Uint256, __warp_usrid_18_y: Uint256
    ) -> (__warp_usrid_19_z: Uint256) {
        alloc_locals;

        let __warp_usrid_19_z = Uint256(low=0, high=0);

        let (__warp_se_43) = warp_sub_signed256(__warp_usrid_17_x, __warp_usrid_18_y);

        let __warp_se_44 = __warp_se_43;

        let __warp_usrid_19_z = __warp_se_44;

        let (__warp_se_45) = warp_le_signed256(__warp_se_44, __warp_usrid_17_x);

        let (__warp_se_46) = warp_ge_signed256(__warp_usrid_18_y, Uint256(low=0, high=0));

        let (__warp_se_47) = warp_eq(__warp_se_45, __warp_se_46);

        assert __warp_se_47 = 1;

        return (__warp_usrid_19_z,);
    }
}

@view
func checkAdd_0f935000{syscall_ptr: felt*, range_check_ptr: felt}(
    __warp_usrid_00_x: Uint256, __warp_usrid_01_y: Uint256
) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_01_y);

    warp_external_input_check_int256(__warp_usrid_00_x);

    let (__warp_usrid_02_z) = LowGasSafeMathEchidnaTest.s1___warp_usrfn_00_add(
        __warp_usrid_00_x, __warp_usrid_01_y
    );

    let (__warp_se_0) = warp_add256(__warp_usrid_00_x, __warp_usrid_01_y);

    let (__warp_se_1) = warp_eq256(__warp_usrid_02_z, __warp_se_0);

    assert __warp_se_1 = 1;

    let (__warp_se_2) = warp_ge256(__warp_usrid_02_z, __warp_usrid_00_x);

    let (__warp_se_3) = warp_ge256(__warp_usrid_02_z, __warp_usrid_01_y);

    let (__warp_se_4) = warp_and_(__warp_se_2, __warp_se_3);

    assert __warp_se_4 = 1;

    return ();
}

@view
func checkSub_6d886fae{syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
    __warp_usrid_03_x: Uint256, __warp_usrid_04_y: Uint256
) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_04_y);

    warp_external_input_check_int256(__warp_usrid_03_x);

    let (__warp_usrid_05_z) = LowGasSafeMathEchidnaTest.s1___warp_usrfn_01_sub(
        __warp_usrid_03_x, __warp_usrid_04_y
    );

    let (__warp_se_5) = warp_sub256(__warp_usrid_03_x, __warp_usrid_04_y);

    let (__warp_se_6) = warp_eq256(__warp_usrid_05_z, __warp_se_5);

    assert __warp_se_6 = 1;

    let (__warp_se_7) = warp_le256(__warp_usrid_05_z, __warp_usrid_03_x);

    assert __warp_se_7 = 1;

    return ();
}

@view
func checkMul_0fe48c5c{syscall_ptr: felt*, range_check_ptr: felt}(
    __warp_usrid_06_x: Uint256, __warp_usrid_07_y: Uint256
) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_07_y);

    warp_external_input_check_int256(__warp_usrid_06_x);

    let (__warp_usrid_08_z) = LowGasSafeMathEchidnaTest.s1___warp_usrfn_02_mul(
        __warp_usrid_06_x, __warp_usrid_07_y
    );

    let (__warp_se_8) = warp_mul256(__warp_usrid_06_x, __warp_usrid_07_y);

    let (__warp_se_9) = warp_eq256(__warp_usrid_08_z, __warp_se_8);

    assert __warp_se_9 = 1;

    let (__warp_se_10) = warp_eq256(__warp_usrid_06_x, Uint256(low=0, high=0));

    let (__warp_se_11) = warp_eq256(__warp_usrid_07_y, Uint256(low=0, high=0));

    let (__warp_se_12) = warp_or(__warp_se_10, __warp_se_11);

    let (__warp_se_13) = warp_ge256(__warp_usrid_08_z, __warp_usrid_06_x);

    let (__warp_se_14) = warp_ge256(__warp_usrid_08_z, __warp_usrid_07_y);

    let (__warp_se_15) = warp_and_(__warp_se_13, __warp_se_14);

    let (__warp_se_16) = warp_or(__warp_se_12, __warp_se_15);

    assert __warp_se_16 = 1;

    return ();
}

@view
func checkAddi_9239e777{syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
    __warp_usrid_09_x: Uint256, __warp_usrid_10_y: Uint256
) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_10_y);

    warp_external_input_check_int256(__warp_usrid_09_x);

    let (__warp_usrid_11_z) = LowGasSafeMathEchidnaTest.s1___warp_usrfn_03_add(
        __warp_usrid_09_x, __warp_usrid_10_y
    );

    let (__warp_se_17) = warp_add_signed256(__warp_usrid_09_x, __warp_usrid_10_y);

    let (__warp_se_18) = warp_eq256(__warp_usrid_11_z, __warp_se_17);

    assert __warp_se_18 = 1;

    let (__warp_se_19) = warp_lt_signed256(__warp_usrid_10_y, Uint256(low=0, high=0));

    if (__warp_se_19 != 0) {
        let (__warp_se_20) = warp_lt_signed256(__warp_usrid_11_z, __warp_usrid_09_x);

        assert __warp_se_20 = 1;

        LowGasSafeMathEchidnaTest.checkAddi_9239e777_if_part1();

        return ();
    } else {
        let (__warp_se_21) = warp_ge_signed256(__warp_usrid_11_z, __warp_usrid_09_x);

        assert __warp_se_21 = 1;

        LowGasSafeMathEchidnaTest.checkAddi_9239e777_if_part1();

        return ();
    }
}

@view
func checkSubi_bd78b20d{syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
    __warp_usrid_12_x: Uint256, __warp_usrid_13_y: Uint256
) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_13_y);

    warp_external_input_check_int256(__warp_usrid_12_x);

    let (__warp_usrid_14_z) = LowGasSafeMathEchidnaTest.s1___warp_usrfn_04_sub(
        __warp_usrid_12_x, __warp_usrid_13_y
    );

    let (__warp_se_22) = warp_sub_signed256(__warp_usrid_12_x, __warp_usrid_13_y);

    let (__warp_se_23) = warp_eq256(__warp_usrid_14_z, __warp_se_22);

    assert __warp_se_23 = 1;

    let (__warp_se_24) = warp_lt_signed256(__warp_usrid_13_y, Uint256(low=0, high=0));

    if (__warp_se_24 != 0) {
        let (__warp_se_25) = warp_gt_signed256(__warp_usrid_14_z, __warp_usrid_12_x);

        assert __warp_se_25 = 1;

        LowGasSafeMathEchidnaTest.checkSubi_bd78b20d_if_part1();

        return ();
    } else {
        let (__warp_se_26) = warp_le_signed256(__warp_usrid_14_z, __warp_usrid_12_x);

        assert __warp_se_26 = 1;

        LowGasSafeMathEchidnaTest.checkSubi_bd78b20d_if_part1();

        return ();
    }
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","checkAdd(uint256,uint256)","checkSub(uint256,uint256)","checkMul(uint256,uint256)","checkAddi(int256,int256)","checkSubi(int256,int256)"]
