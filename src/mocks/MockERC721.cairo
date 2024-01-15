use starknet::ContractAddress;

#[starknet::interface]
trait IMockERC721<TContractState> {
    fn mint_to(ref self: TContractState, recipient: ContractAddress, token_id: u256);
    fn approve(ref self: TContractState, to: ContractAddress, token_id: u256);
    fn transfer_from(
        ref self: TContractState, from: ContractAddress, to: ContractAddress, token_id: u256
    );
    fn owner_of(self: @TContractState, token_id: u256) -> ContractAddress;
}

#[starknet::contract]
mod MockERC721 {
    use openzeppelin::introspection::src5::SRC5Component;
    use openzeppelin::token::erc721::ERC721Component;
    use starknet::{ContractAddress, get_caller_address};
    use super::IMockERC721;

    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    // ERC721
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    impl ERC721MetadataImpl = ERC721Component::ERC721MetadataImpl<ContractState>;
    impl ERC721CamelOnly = ERC721Component::ERC721CamelOnlyImpl<ContractState>;
    impl ERC721MetadataCamelOnly = ERC721Component::ERC721MetadataCamelOnlyImpl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

    // SRC5
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc721: ERC721Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let name = 'MockERC721';
        let symbol = 'ERC721';

        self.erc721.initializer(name, symbol);
    }

    #[external(v0)]
    impl IMockERC721Impl of IMockERC721<ContractState> {
        fn mint_to(ref self: ContractState, recipient: ContractAddress, token_id: u256) {
            self.erc721._mint(recipient, token_id);
        }

        fn approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let owner = self.erc721._owner_of(token_id);

            let caller = get_caller_address();
            // assert(owner == caller || self.is_approved_for_all(owner, caller), 'UNAUTHORIZED');
            self.erc721._approve(to, token_id);
        }

        fn transfer_from(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            assert(
                self.erc721._is_approved_or_owner(get_caller_address(), token_id),
                'ERC721: unauthorized caller'
            );
            self.erc721._transfer(from, to, token_id);
        }

        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            self.erc721.owner_of(token_id)
        }
    }
}
