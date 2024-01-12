use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, starknet::Store)]
struct Asset {
    addr: ContractAddress,
    amount_or_id: u256,
}

#[derive(Copy, Drop, Serde, starknet::Store)]
struct Swap {
    owner: ContractAddress,
    allowed: ContractAddress,
    expiry: u64,
    biding_count: u64,
    asking_count: u64,
}

#[starknet::interface]
trait ISwaplace<TContractState> {
    // getters
    fn get_swap(self: @TContractState, swap_id: u256) -> Swap;
    fn total_swaps(self: @TContractState) -> u256;
    // external
    fn create_swap(
        ref self: TContractState, swap: Swap, biding: Span<Asset>, asking: Span<Asset>
    ) -> u256;
    fn accept_swap(ref self: TContractState, swap_id: u256) -> bool;
    fn cancel_swap(ref self: TContractState, swap_id: u256);
}

#[starknet::interface]
trait ITransfer<TContractState> {
    // external
    fn transferFrom(
        ref self: TContractState, from: ContractAddress, to: ContractAddress, amount_or_id: u256
    );
}

#[starknet::contract]
mod Swaplace {
    use super::{ISwaplace, Swap, Asset};
    use super::{ITransfer, ITransferDispatcher, ITransferDispatcherTrait};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};

    #[storage]
    struct Storage {
        total_swaps: u256,
        swaps: LegacyMap<u256, Swap>,
        swaps_biding: LegacyMap<(u256, u64), Asset>,
        swaps_asking: LegacyMap<(u256, u64), Asset>,
    }

    #[event]
    #[derive(Copy, Drop, starknet::Event, PartialEq)]
    enum Event {
        SwapCreated: SwapCreated,
        SwapAccepted: SwapAccepted,
        SwapCanceled: SwapCanceled,
    }

    #[derive(Copy, Drop, starknet::Event, PartialEq)]
    struct SwapCreated {
        #[key]
        user: ContractAddress,
        #[key]
        swap_id: u256,
        allowed: ContractAddress,
        expiry: u64,
    }

    #[derive(Copy, Drop, starknet::Event, PartialEq)]
    struct SwapAccepted {
        #[key]
        user: ContractAddress,
        #[key]
        swap_id: u256,
    }

    #[derive(Copy, Drop, starknet::Event, PartialEq)]
    struct SwapCanceled {
        #[key]
        user: ContractAddress,
        #[key]
        swap_id: u256,
    }

    #[abi(embed_v0)]
    impl ISwaplaceImpl of ISwaplace<ContractState> {
        fn get_swap(self: @ContractState, swap_id: u256) -> Swap {
            self.swaps.read(swap_id)
        }

        fn total_swaps(self: @ContractState) -> u256 {
            self.total_swaps.read()
        }

        fn create_swap(
            ref self: ContractState, swap: Swap, biding: Span<Asset>, asking: Span<Asset>
        ) -> u256 {
            assert(swap.owner == get_caller_address(), 'InvalidAddress');
            assert(swap.expiry >= get_block_timestamp(), 'InvalidExpiry');
            assert(biding.len() > 0 && asking.len() > 0, 'InvalidAssetsLength');
            // TODO: len

            let mut swap_id = self.total_swaps.read();
            swap_id += 1;
            self.total_swaps.write(swap_id);

            self.swaps.write(swap_id, swap);

            let mut i: u64 = 0;
            loop {
                if i == swap.biding_count {
                    break;
                }
                // TODO: 
                self.swaps_biding.write((swap_id, i), *biding.at(0));
                i += 1;
            };

            let mut i: u64 = 0;
            loop {
                if i == swap.asking_count {
                    break;
                }
                // TODO: 
                self.swaps_asking.write((swap_id, i), *asking.at(0));
                i += 1;
            };

            self
                .emit(
                    SwapCreated {
                        user: get_caller_address(),
                        swap_id,
                        allowed: swap.allowed,
                        expiry: swap.expiry
                    }
                );

            swap_id
        }

        fn accept_swap(ref self: ContractState, swap_id: u256) -> bool {
            let mut swap = self.swaps.read(swap_id);

            // if (swap.allowed != address(0) && swap.allowed != msg.sender)
            // revert InvalidAddress(msg.sender);

            assert(swap.allowed == get_caller_address(), 'InvalidAddress');
            assert(swap.expiry >= get_block_timestamp(), 'InvalidExpiry');

            swap.expiry = 0;
            self.swaps.write(swap_id, swap);

            let mut i: u64 = 0;
            loop {
                if i == swap.biding_count {
                    break;
                }
                let asset = self.swaps_biding.read((swap_id, i));
                // ERC20ABIDispatcher { contract_address: asset.address }
                //     .transfer_from(get_caller_address(), swap.owner, asset.amount_or_id);
                ITransferDispatcher { contract_address: asset.addr }
                    .transferFrom(get_caller_address(), swap.owner, asset.amount_or_id);
                i += 1;
            };

            let mut i: u64 = 0;
            loop {
                if i == swap.asking_count {
                    break;
                }
                let asset = self.swaps_asking.read((swap_id, i));
                // ERC20ABIDispatcher { contract_address: asset.address }
                //     .transfer_from(get_caller_address(), swap.owner, asset.amount_or_id);
                ITransferDispatcher { contract_address: asset.addr }
                    .transferFrom(get_caller_address(), swap.owner, asset.amount_or_id);
                i += 1;
            };

            self.emit(SwapAccepted { user: get_caller_address(), swap_id });
            true
        }

        fn cancel_swap(ref self: ContractState, swap_id: u256) {
            let mut swap = self.swaps.read(swap_id);

            assert(swap.owner == get_caller_address(), 'InvalidAddress');
            assert(swap.expiry >= get_block_timestamp(), 'InvalidExpiry');

            swap.expiry = 0;
            self.swaps.write(swap_id, swap);
            self.emit(SwapCanceled { user: get_caller_address(), swap_id });
        }
    }
}
