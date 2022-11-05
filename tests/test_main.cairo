%lang starknet
from src.main import balance, increase_balance
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.alloc import alloc


from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_sub,
    uint256_add,
    uint256_le,
    uint256_lt,
    uint256_mul,
)

@contract_interface
namespace Pool {

func initialize_f637731d(__warp_usrid_084_sqrtPriceX96: felt) -> () {
}

func setValues_8ff8bcfb(
    __warp_usrid_050__token0: felt,
    __warp_usrid_051__token1: felt,
    __warp_usrid_052__fee: felt,
    __warp_usrid_053__tickSpacing: felt,
) -> () {
}


func swap_128acb08(
    __warp_usrid_136_recipient: felt,
    __warp_usrid_137_zeroForOne: felt,
    __warp_usrid_138_amountSpecified: Uint256,
    __warp_usrid_139_sqrtPriceLimitX96: felt,
    __warp_usrid_140_data_len: felt,
    __warp_usrid_140_data: felt*,
) -> (__warp_usrid_141_amount0: Uint256, __warp_usrid_142_amount1: Uint256) {
}

}

@external
func __setup__{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}() {
    tempvar pool_address;
    tempvar token0_address;
    tempvar token1_address;
    %{ context.token0 = deploy_contract("./src/TestERC20.cairo", [100000000, 10000000000000]).contract_address %}
    %{ context.token1 = deploy_contract("./src/TestERC20.cairo", [100000000, 10000000000000]).contract_address %}
    %{ context.pool = deploy_contract("./src/UniswapV3Pool.cairo").contract_address %}
    //%{ context.factory = deploy_contract("./src/UniswapV3Factory__WC__UniswapV3Factory.cairo").contract_address %}
    %{ ids.pool_address = context.pool %}
    %{ ids.token0_address = context.token0 %}
    %{ ids.token1_address = context.token1 %}

     Pool.setValues_8ff8bcfb(pool_address, token0_address, token1_address, 500, 10);
     Pool.initialize_f637731d(pool_address, 0x01000000000000000000000000);

    return ();
}

const TO = 0x1;

@external
func test_swap{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}() {
    tempvar pool_address;
    %{ ids.pool_address = context.pool %}

    let (d : felt*) = alloc();
    let amount = Uint256(low= 0x0de0b6b3a7640000, high=0);

    Pool.swap_128acb08(pool_address, TO, 0, amount, 0xfffd8963efd1fc6a506488495d951d5263988d25, 0 , d);

    return ();
}
