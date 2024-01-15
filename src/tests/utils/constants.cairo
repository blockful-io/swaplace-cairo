use starknet::{ContractAddress, contract_address_const};

const MOCK_BLOCK_TIMESTAMP: u64 = 1000;

fn ACCEPTEE() -> ContractAddress {
    contract_address_const::<'ACCEPTEE'>()
}

fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

fn DEPLOYER() -> ContractAddress {
    contract_address_const::<'DEPLOYER'>()
}

fn ZERO() -> ContractAddress {
    Zeroable::zero()
}
