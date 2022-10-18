%lang starknet

from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.gt import warp_gt256
from warplib.maths.div import warp_div256
from warplib.maths.sub import warp_sub256
from warplib.maths.mod import warp_mod256
from warplib.maths.eq import warp_eq256
from warplib.maths.div_unsafe import warp_div_unsafe256
from warplib.maths.add_unsafe import warp_add_unsafe256

// Contract Def UnsafeMathEchidnaTest

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

namespace UnsafeMathEchidnaTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    func checkDivRoundingUp_2724da4e_if_part1() -> () {
        alloc_locals;

        return ();
    }

    // @notice Returns ceil(x / y)
    // @dev division by 0 has unspecified behavior, and must be checked externally
    // @param x The dividend
    // @param y The divisor
    // @return z The quotient, ceil(x / y)
    func s1___warp_usrfn_00_divRoundingUp{range_check_ptr: felt}(
        __warp_usrid_01_x: Uint256, __warp_usrid_02_y: Uint256
    ) -> (__warp_usrid_03_z: Uint256) {
        alloc_locals;

        let __warp_usrid_03_z = Uint256(low=0, high=0);

        let __warp_usrid_04_temp = Uint256(low=0, high=0);

        let (__warp_se_6) = warp_mod256(__warp_usrid_01_x, __warp_usrid_02_y);

        let (__warp_se_7) = warp_gt256(__warp_se_6, Uint256(low=0, high=0));

        if (__warp_se_7 != 0) {
            let __warp_usrid_04_temp = Uint256(low=1, high=0);

            let (__warp_se_8) = s1___warp_usrfn_00_divRoundingUp_if_part1(
                __warp_usrid_03_z, __warp_usrid_01_x, __warp_usrid_02_y, __warp_usrid_04_temp
            );

            return (__warp_se_8,);
        } else {
            let (__warp_se_9) = s1___warp_usrfn_00_divRoundingUp_if_part1(
                __warp_usrid_03_z, __warp_usrid_01_x, __warp_usrid_02_y, __warp_usrid_04_temp
            );

            return (__warp_se_9,);
        }
    }

    func s1___warp_usrfn_00_divRoundingUp_if_part1{range_check_ptr: felt}(
        __warp_usrid_03_z: Uint256,
        __warp_usrid_01_x: Uint256,
        __warp_usrid_02_y: Uint256,
        __warp_usrid_04_temp: Uint256,
    ) -> (__warp_usrid_03_z: Uint256) {
        alloc_locals;

        let (__warp_se_10) = warp_div_unsafe256(__warp_usrid_01_x, __warp_usrid_02_y);

        let (__warp_se_11) = warp_add_unsafe256(__warp_se_10, __warp_usrid_04_temp);

        let __warp_usrid_03_z = __warp_se_11;

        return (__warp_usrid_03_z,);
    }
}

@view
func checkDivRoundingUp_2724da4e{
    syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*
}(__warp_usrid_00_x: Uint256, __warp_usrid_01_d: Uint256) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_01_d);

    warp_external_input_check_int256(__warp_usrid_00_x);

    let (__warp_se_0) = warp_gt256(__warp_usrid_01_d, Uint256(low=0, high=0));

    assert __warp_se_0 = 1;

    let (__warp_usrid_02_z) = UnsafeMathEchidnaTest.s1___warp_usrfn_00_divRoundingUp(
        __warp_usrid_00_x, __warp_usrid_01_d
    );

    let (__warp_se_1) = warp_div256(__warp_usrid_00_x, __warp_usrid_01_d);

    let (__warp_usrid_03_diff) = warp_sub256(__warp_usrid_02_z, __warp_se_1);

    let (__warp_se_2) = warp_mod256(__warp_usrid_00_x, __warp_usrid_01_d);

    let (__warp_se_3) = warp_eq256(__warp_se_2, Uint256(low=0, high=0));

    if (__warp_se_3 != 0) {
        let (__warp_se_4) = warp_eq256(__warp_usrid_03_diff, Uint256(low=0, high=0));

        assert __warp_se_4 = 1;

        UnsafeMathEchidnaTest.checkDivRoundingUp_2724da4e_if_part1();

        return ();
    } else {
        let (__warp_se_5) = warp_eq256(__warp_usrid_03_diff, Uint256(low=1, high=0));

        assert __warp_se_5 = 1;

        UnsafeMathEchidnaTest.checkDivRoundingUp_2724da4e_if_part1();

        return ();
    }
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","checkDivRoundingUp(uint256,uint256)"]
