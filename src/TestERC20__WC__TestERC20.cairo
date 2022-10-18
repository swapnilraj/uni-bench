%lang starknet

from warplib.maths.external_input_check_address import warp_external_input_check_address
from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from warplib.maths.add import warp_add256
from warplib.maths.ge import warp_ge256
from warplib.maths.sub import warp_sub256

func WS0_READ_warp_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) -> (val: felt) {
    alloc_locals;
    let (read0) = readId(loc);
    return (read0,);
}

func WS1_READ_Uint256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) -> (val: Uint256) {
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0, high=read1),);
}

func WS_WRITE0{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt, value: Uint256
) -> (res: Uint256) {
    WARP_STORAGE.write(loc, value.low);
    WARP_STORAGE.write(loc + 1, value.high);
    return (value,);
}

@storage_var
func WARP_MAPPING0(name: felt, index: felt) -> (resLoc: felt) {
}
func WS0_INDEX_felt_to_Uint256{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}(name: felt, index: felt) -> (res: felt) {
    alloc_locals;
    let (existing) = WARP_MAPPING0.read(name, index);
    if (existing == 0) {
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING0.write(name, index, used);
        return (used,);
    } else {
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING1(name: felt, index: felt) -> (resLoc: felt) {
}
func WS1_INDEX_felt_to_warp_id{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
}(name: felt, index: felt) -> (res: felt) {
    alloc_locals;
    let (existing) = WARP_MAPPING1.read(name, index);
    if (existing == 0) {
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING1.write(name, index, used);
        return (used,);
    } else {
        return (existing,);
    }
}

// Contract Def TestERC20

// @notice Event emitted when the approval amount for the spender of a given owner's tokens changes.
// @param owner The account that approved spending of its tokens
// @param spender The account for which the spending allowance was modified
// @param value The new allowance from the owner to the spender
@event
func Approval_8c5be1e5(
    __warp_usrid_18_owner: felt, __warp_usrid_19_spender: felt, __warp_usrid_20_value: Uint256
) {
}

// @notice Event emitted when tokens are transferred from one address to another, either via `#transfer` or `#transferFrom`.
// @param from The account from which the tokens were sent, i.e. the balance decreased
// @param to The account to which the tokens were sent, i.e. the balance increased
// @param value The amount of tokens that were transferred
@event
func Transfer_ddf252ad(
    __warp_usrid_15_from: felt, __warp_usrid_16_to: felt, __warp_usrid_17_value: Uint256
) {
}

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

namespace TestERC20 {
    // Dynamic variables - Arrays and Maps

    const __warp_usrid_00_balanceOf = 1;

    const __warp_usrid_01_allowance = 2;

    // Static variables

    func __warp_constructor_0{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }(__warp_usrid_02_amount: Uint256) -> () {
        alloc_locals;

        let (__warp_se_0) = get_caller_address();

        mint_40c10f19_internal(__warp_se_0, __warp_usrid_02_amount);

        return ();
    }

    func mint_40c10f19_internal{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt
    }(__warp_usrid_03_to: felt, __warp_usrid_04_amount: Uint256) -> () {
        alloc_locals;

        let (__warp_se_1) = WS0_INDEX_felt_to_Uint256(
            __warp_usrid_00_balanceOf, __warp_usrid_03_to
        );

        let (__warp_se_2) = WS1_READ_Uint256(__warp_se_1);

        let (__warp_usrid_05_balanceNext) = warp_add256(__warp_se_2, __warp_usrid_04_amount);

        let (__warp_se_3) = warp_ge256(__warp_usrid_05_balanceNext, __warp_usrid_04_amount);

        with_attr error_message("overflow balance") {
            assert __warp_se_3 = 1;
        }

        let (__warp_se_4) = WS0_INDEX_felt_to_Uint256(
            __warp_usrid_00_balanceOf, __warp_usrid_03_to
        );

        WS_WRITE0(__warp_se_4, __warp_usrid_05_balanceNext);

        return ();
    }
}

@external
func transfer_a9059cbb{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(__warp_usrid_06_recipient: felt, __warp_usrid_07_amount: Uint256) -> (__warp_usrid_08_: felt) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_07_amount);

    warp_external_input_check_address(__warp_usrid_06_recipient);

    let (__warp_se_5) = get_caller_address();

    let (__warp_se_6) = WS0_INDEX_felt_to_Uint256(TestERC20.__warp_usrid_00_balanceOf, __warp_se_5);

    let (__warp_usrid_09_balanceBefore) = WS1_READ_Uint256(__warp_se_6);

    let (__warp_se_7) = warp_ge256(__warp_usrid_09_balanceBefore, __warp_usrid_07_amount);

    with_attr error_message("insufficient balance") {
        assert __warp_se_7 = 1;
    }

    let (__warp_se_8) = get_caller_address();

    let (__warp_se_9) = WS0_INDEX_felt_to_Uint256(TestERC20.__warp_usrid_00_balanceOf, __warp_se_8);

    let (__warp_se_10) = warp_sub256(__warp_usrid_09_balanceBefore, __warp_usrid_07_amount);

    WS_WRITE0(__warp_se_9, __warp_se_10);

    let (__warp_se_11) = WS0_INDEX_felt_to_Uint256(
        TestERC20.__warp_usrid_00_balanceOf, __warp_usrid_06_recipient
    );

    let (__warp_usrid_10_balanceRecipient) = WS1_READ_Uint256(__warp_se_11);

    let (__warp_se_12) = warp_add256(__warp_usrid_10_balanceRecipient, __warp_usrid_07_amount);

    let (__warp_se_13) = warp_ge256(__warp_se_12, __warp_usrid_10_balanceRecipient);

    with_attr error_message("recipient balance overflow") {
        assert __warp_se_13 = 1;
    }

    let (__warp_se_14) = WS0_INDEX_felt_to_Uint256(
        TestERC20.__warp_usrid_00_balanceOf, __warp_usrid_06_recipient
    );

    let (__warp_se_15) = warp_add256(__warp_usrid_10_balanceRecipient, __warp_usrid_07_amount);

    WS_WRITE0(__warp_se_14, __warp_se_15);

    let (__warp_se_16) = get_caller_address();

    Transfer_ddf252ad.emit(__warp_se_16, __warp_usrid_06_recipient, __warp_usrid_07_amount);

    return (1,);
}

@external
func approve_095ea7b3{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_11_spender: felt, __warp_usrid_12_amount: Uint256
) -> (__warp_usrid_13_: felt) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_12_amount);

    warp_external_input_check_address(__warp_usrid_11_spender);

    let (__warp_se_17) = get_caller_address();

    let (__warp_se_18) = WS1_INDEX_felt_to_warp_id(
        TestERC20.__warp_usrid_01_allowance, __warp_se_17
    );

    let (__warp_se_19) = WS0_READ_warp_id(__warp_se_18);

    let (__warp_se_20) = WS0_INDEX_felt_to_Uint256(__warp_se_19, __warp_usrid_11_spender);

    WS_WRITE0(__warp_se_20, __warp_usrid_12_amount);

    let (__warp_se_21) = get_caller_address();

    Approval_8c5be1e5.emit(__warp_se_21, __warp_usrid_11_spender, __warp_usrid_12_amount);

    return (1,);
}

@external
func transferFrom_23b872dd{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    __warp_usrid_14_sender: felt, __warp_usrid_15_recipient: felt, __warp_usrid_16_amount: Uint256
) -> (__warp_usrid_17_: felt) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_16_amount);

    warp_external_input_check_address(__warp_usrid_15_recipient);

    warp_external_input_check_address(__warp_usrid_14_sender);

    let (__warp_se_22) = WS1_INDEX_felt_to_warp_id(
        TestERC20.__warp_usrid_01_allowance, __warp_usrid_14_sender
    );

    let (__warp_se_23) = WS0_READ_warp_id(__warp_se_22);

    let (__warp_se_24) = get_caller_address();

    let (__warp_se_25) = WS0_INDEX_felt_to_Uint256(__warp_se_23, __warp_se_24);

    let (__warp_usrid_18_allowanceBefore) = WS1_READ_Uint256(__warp_se_25);

    let (__warp_se_26) = warp_ge256(__warp_usrid_18_allowanceBefore, __warp_usrid_16_amount);

    with_attr error_message("allowance insufficient") {
        assert __warp_se_26 = 1;
    }

    let (__warp_se_27) = WS1_INDEX_felt_to_warp_id(
        TestERC20.__warp_usrid_01_allowance, __warp_usrid_14_sender
    );

    let (__warp_se_28) = WS0_READ_warp_id(__warp_se_27);

    let (__warp_se_29) = get_caller_address();

    let (__warp_se_30) = WS0_INDEX_felt_to_Uint256(__warp_se_28, __warp_se_29);

    let (__warp_se_31) = warp_sub256(__warp_usrid_18_allowanceBefore, __warp_usrid_16_amount);

    WS_WRITE0(__warp_se_30, __warp_se_31);

    let (__warp_se_32) = WS0_INDEX_felt_to_Uint256(
        TestERC20.__warp_usrid_00_balanceOf, __warp_usrid_15_recipient
    );

    let (__warp_usrid_19_balanceRecipient) = WS1_READ_Uint256(__warp_se_32);

    let (__warp_se_33) = warp_add256(__warp_usrid_19_balanceRecipient, __warp_usrid_16_amount);

    let (__warp_se_34) = warp_ge256(__warp_se_33, __warp_usrid_19_balanceRecipient);

    with_attr error_message("overflow balance recipient") {
        assert __warp_se_34 = 1;
    }

    let (__warp_se_35) = WS0_INDEX_felt_to_Uint256(
        TestERC20.__warp_usrid_00_balanceOf, __warp_usrid_15_recipient
    );

    let (__warp_se_36) = warp_add256(__warp_usrid_19_balanceRecipient, __warp_usrid_16_amount);

    WS_WRITE0(__warp_se_35, __warp_se_36);

    let (__warp_se_37) = WS0_INDEX_felt_to_Uint256(
        TestERC20.__warp_usrid_00_balanceOf, __warp_usrid_14_sender
    );

    let (__warp_usrid_20_balanceSender) = WS1_READ_Uint256(__warp_se_37);

    let (__warp_se_38) = warp_ge256(__warp_usrid_20_balanceSender, __warp_usrid_16_amount);

    with_attr error_message("underflow balance sender") {
        assert __warp_se_38 = 1;
    }

    let (__warp_se_39) = WS0_INDEX_felt_to_Uint256(
        TestERC20.__warp_usrid_00_balanceOf, __warp_usrid_14_sender
    );

    let (__warp_se_40) = warp_sub256(__warp_usrid_20_balanceSender, __warp_usrid_16_amount);

    WS_WRITE0(__warp_se_39, __warp_se_40);

    Transfer_ddf252ad.emit(
        __warp_usrid_14_sender, __warp_usrid_15_recipient, __warp_usrid_16_amount
    );

    return (1,);
}

@view
func balanceOf_70a08231{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_21__i0: felt
) -> (__warp_usrid_22_: Uint256) {
    alloc_locals;

    warp_external_input_check_address(__warp_usrid_21__i0);

    let (__warp_se_41) = WS0_INDEX_felt_to_Uint256(
        TestERC20.__warp_usrid_00_balanceOf, __warp_usrid_21__i0
    );

    let (__warp_se_42) = WS1_READ_Uint256(__warp_se_41);

    return (__warp_se_42,);
}

@view
func allowance_dd62ed3e{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_23__i0: felt, __warp_usrid_24__i1: felt
) -> (__warp_usrid_25_: Uint256) {
    alloc_locals;

    warp_external_input_check_address(__warp_usrid_24__i1);

    warp_external_input_check_address(__warp_usrid_23__i0);

    let (__warp_se_43) = WS1_INDEX_felt_to_warp_id(
        TestERC20.__warp_usrid_01_allowance, __warp_usrid_23__i0
    );

    let (__warp_se_44) = WS0_READ_warp_id(__warp_se_43);

    let (__warp_se_45) = WS0_INDEX_felt_to_Uint256(__warp_se_44, __warp_usrid_24__i1);

    let (__warp_se_46) = WS1_READ_Uint256(__warp_se_45);

    return (__warp_se_46,);
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_02_amount: Uint256
) {
    alloc_locals;
    WARP_USED_STORAGE.write(2);
    WARP_NAMEGEN.write(2);

    warp_external_input_check_int256(__warp_usrid_02_amount);

    TestERC20.__warp_constructor_0(__warp_usrid_02_amount);

    return ();
}

@external
func mint_40c10f19{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_03_to: felt, __warp_usrid_04_amount: Uint256
) -> () {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_04_amount);

    warp_external_input_check_address(__warp_usrid_03_to);

    TestERC20.mint_40c10f19_internal(__warp_usrid_03_to, __warp_usrid_04_amount);

    return ();
}

// Original soldity abi: ["constructor(uint256)","","mint(address,uint256)","transfer(address,uint256)","approve(address,uint256)","transferFrom(address,address,uint256)","balanceOf(address)","allowance(address,address)","constructor()"]
