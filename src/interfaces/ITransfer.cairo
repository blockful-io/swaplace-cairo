use starknet::ContractAddress;

#[starknet::interface]
trait ITransfer<TContractState> {
    fn transfer_from(
        ref self: TContractState, from: ContractAddress, to: ContractAddress, amount_or_id: u256
    );
}
