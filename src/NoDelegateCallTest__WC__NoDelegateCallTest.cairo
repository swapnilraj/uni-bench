%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin
from warplib.block_methods import warp_block_timestamp
from warplib.maths.div import warp_div256
from starkware.starknet.common.syscalls import get_contract_address
from warplib.maths.eq import warp_eq

func WS0_READ_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) -> (val: felt) {
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func WS_WRITE0{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt, value: felt
) -> (res: felt) {
    WARP_STORAGE.write(loc, value);
    return (value,);
}

// Contract Def NoDelegateCallTest

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

namespace NoDelegateCallTest {
    // Dynamic variables - Arrays and Maps

    // Static variables

    const __warp_usrid_01_original = 0;

    func __warp_modifier_noDelegateCall___warp_usrfn_00_noDelegateCallPrivate_5{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }() -> () {
        alloc_locals;

        s1___warp_usrfn_00_checkNotDelegateCall();

        __warp_original_function___warp_usrfn_00_noDelegateCallPrivate_4();

        return ();
    }

    func __warp_original_function___warp_usrfn_00_noDelegateCallPrivate_4() -> () {
        alloc_locals;

        return ();
    }

    func __warp_modifier_noDelegateCall_cannotBeDelegateCalled_423ecb05_3{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }(__warp_parameter___warp_usrid_02__m_capture1: Uint256) -> (
        __warp_ret_parameter___warp_usrid_02_2: Uint256
    ) {
        alloc_locals;

        let __warp_ret_parameter___warp_usrid_02_2 = Uint256(low=0, high=0);

        s1___warp_usrfn_00_checkNotDelegateCall();

        let (__warp_se_0) = __warp_original_function_cannotBeDelegateCalled_423ecb05_0(
            __warp_parameter___warp_usrid_02__m_capture1
        );

        let __warp_ret_parameter___warp_usrid_02_2 = __warp_se_0;

        return (__warp_ret_parameter___warp_usrid_02_2,);
    }

    func __warp_original_function_cannotBeDelegateCalled_423ecb05_0{
        syscall_ptr: felt*, range_check_ptr: felt
    }(__warp_usrid_02__m_capture: Uint256) -> (__warp_usrid_02_: Uint256) {
        alloc_locals;

        let __warp_usrid_02_ = Uint256(low=0, high=0);

        let __warp_usrid_02_ = __warp_usrid_02__m_capture;

        let (__warp_se_1) = warp_block_timestamp();

        let (__warp_se_2) = warp_div256(__warp_se_1, Uint256(low=5, high=0));

        return (__warp_se_2,);
    }

    func __warp_usrfn_00_noDelegateCallPrivate{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }() -> () {
        alloc_locals;

        __warp_modifier_noDelegateCall___warp_usrfn_00_noDelegateCallPrivate_5();

        return ();
    }

    func __warp_constructor_0{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }() -> () {
        alloc_locals;

        let (__warp_se_6) = get_contract_address();

        WS_WRITE0(__warp_usrid_01_original, __warp_se_6);

        return ();
    }

    // @dev Private method is used instead of inlining into modifier because modifiers are copied into each method,
    //     and the use of immutable means the address bytes are copied in every place the modifier is used.
    func s1___warp_usrfn_00_checkNotDelegateCall{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }() -> () {
        alloc_locals;

        let (__warp_se_7) = get_contract_address();

        let (__warp_se_8) = WS0_READ_felt(__warp_usrid_01_original);

        let (__warp_se_9) = warp_eq(__warp_se_7, __warp_se_8);

        assert __warp_se_9 = 1;

        return ();
    }
}

@view
func canBeDelegateCalled_f45f416e{syscall_ptr: felt*, range_check_ptr: felt}() -> (
    __warp_usrid_01_: Uint256
) {
    alloc_locals;

    let (__warp_se_3) = warp_block_timestamp();

    let (__warp_se_4) = warp_div256(__warp_se_3, Uint256(low=5, high=0));

    return (__warp_se_4,);
}

@view
func cannotBeDelegateCalled_423ecb05{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}() -> (__warp_usrid_02_: Uint256) {
    alloc_locals;

    let __warp_usrid_02_ = Uint256(low=0, high=0);

    let (
        __warp_se_5
    ) = NoDelegateCallTest.__warp_modifier_noDelegateCall_cannotBeDelegateCalled_423ecb05_3(
        __warp_usrid_02_
    );

    return (__warp_se_5,);
}

@view
func callsIntoNoDelegateCallFunction_64270164{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}() -> () {
    alloc_locals;

    NoDelegateCallTest.__warp_usrfn_00_noDelegateCallPrivate();

    return ();
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;
    WARP_USED_STORAGE.write(1);

    NoDelegateCallTest.__warp_constructor_0();

    return ();
}

// Original soldity abi: ["constructor()","canBeDelegateCalled()","cannotBeDelegateCalled()","callsIntoNoDelegateCallFunction()"]
