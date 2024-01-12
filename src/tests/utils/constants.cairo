use starknet::{ContractAddress, contract_address_const};

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
    contract_address_const::<'ZERO'>()
}
