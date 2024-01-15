mod SwaplaceTests {
    mod creating_swaps {
        mod creating_different_types_of_swaps {
            use core::array::ArrayTrait;
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, make_swap, compose_swap
            };
            use swaplace::tests::utils::constants::{ACCEPTEE, OWNER, DEPLOYER, ZERO};

            use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
            use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
            use swaplace::Swaplace::{Swap, Asset};
            use snforge_std::{CheatTarget, start_prank, stop_prank};

            #[test]
            fn test_should_be_able_to_create_a_1_1_swap_with_ERC20() {
                let (swaplace, mock_erc20, mock_erc721) = setup();

                let biding_addr = array![mock_erc20.contract_address];
                let biding_amount_or_id = array![50];
                let asking_addr = array![mock_erc20.contract_address];
                let asking_amount_or_id = array![50];

                let block_timestamp = 1000; // TODO: get_block_timestamp() * 2
                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    block_timestamp,
                    biding_addr.span(),
                    biding_amount_or_id.span(),
                    asking_addr.span(),
                    asking_amount_or_id.span(),
                );

                let total_swaps_bf = swaplace.get_total_swaps();

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                assert(swaplace.get_total_swaps() == total_swaps_bf + 1, 'err total_swaps');

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.owner == OWNER(), 'err owner');
                assert(swap_result.allowed == ZERO(), 'err allowed');
                assert(swap_result.expiry == block_timestamp, 'err expiry');
            }

            #[test]
            fn test_should_be_able_to_create_a_1_N_swap_with_ERC20() {
                let (swaplace, mock_erc20, mock_erc721) = setup();

                let biding_addr = array![mock_erc20.contract_address];
                let biding_amount_or_id = array![50];
                let asking_addr = array![
                    mock_erc20.contract_address,
                    mock_erc20.contract_address,
                    mock_erc20.contract_address,
                ];
                let asking_amount_or_id = array![50, 100, 150];

                let block_timestamp = 1000; // TODO: get_block_timestamp() * 2
                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    block_timestamp,
                    biding_addr.span(),
                    biding_amount_or_id.span(),
                    asking_addr.span(),
                    asking_amount_or_id.span(),
                );

                let total_swaps_bf = swaplace.get_total_swaps();
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                assert(swaplace.get_total_swaps() == total_swaps_bf + 1, 'err total_swaps');

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.owner == OWNER(), 'err owner');
                assert(swap_result.allowed == ZERO(), 'err allowed');
                assert(swap_result.expiry == block_timestamp, 'err expiry');
            }

            #[test]
            fn test_should_be_able_to_create_a_N_N_swap_with_ERC20() {
                let (swaplace, mock_erc20, mock_erc721) = setup();

                let biding_addr = array![
                    mock_erc20.contract_address,
                    mock_erc20.contract_address,
                    mock_erc20.contract_address,
                ];
                let biding_amount_or_id = array![50, 100, 150];
                let asking_addr = array![
                    mock_erc20.contract_address,
                    mock_erc20.contract_address,
                    mock_erc20.contract_address,
                ];
                let asking_amount_or_id = array![50, 100, 150];

                let block_timestamp = 1000; // TODO: get_block_timestamp() * 2
                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    block_timestamp,
                    biding_addr.span(),
                    biding_amount_or_id.span(),
                    asking_addr.span(),
                    asking_amount_or_id.span(),
                );

                let total_swaps_bf = swaplace.get_total_swaps();
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                assert(swaplace.get_total_swaps() == total_swaps_bf + 1, 'err total_swaps');

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.owner == OWNER(), 'err owner');
                assert(swap_result.allowed == ZERO(), 'err allowed');
                assert(swap_result.expiry == block_timestamp, 'err expiry');
            }

            #[test]
            fn test_should_be_able_to_create_a_1_1_swap_with_ERC721() {
                let (swaplace, mock_erc20, mock_erc721) = setup();

                let biding_addr = array![mock_erc721.contract_address];
                let biding_amount_or_id = array![1];
                let asking_addr = array![mock_erc721.contract_address];
                let asking_amount_or_id = array![4];

                let block_timestamp = 1000; // TODO: get_block_timestamp() * 2
                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    block_timestamp,
                    biding_addr.span(),
                    biding_amount_or_id.span(),
                    asking_addr.span(),
                    asking_amount_or_id.span(),
                );

                let total_swaps_bf = swaplace.get_total_swaps();
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                assert(swaplace.get_total_swaps() == total_swaps_bf + 1, 'err total_swaps');

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.owner == OWNER(), 'err owner');
                assert(swap_result.allowed == ZERO(), 'err allowed');
                assert(swap_result.expiry == block_timestamp, 'err expiry');
            }

            #[test]
            fn test_should_be_able_to_create_a_1_N_swap_with_ERC721() {
                let (swaplace, mock_erc20, mock_erc721) = setup();

                let biding_addr = array![mock_erc721.contract_address];
                let biding_amount_or_id = array![1];
                let asking_addr = array![
                    mock_erc721.contract_address,
                    mock_erc721.contract_address,
                    mock_erc721.contract_address,
                ];
                let asking_amount_or_id = array![4, 5, 6];

                let block_timestamp = 1000; // TODO: get_block_timestamp() * 2
                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    block_timestamp,
                    biding_addr.span(),
                    biding_amount_or_id.span(),
                    asking_addr.span(),
                    asking_amount_or_id.span(),
                );

                let total_swaps_bf = swaplace.get_total_swaps();
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                assert(swaplace.get_total_swaps() == total_swaps_bf + 1, 'err total_swaps');

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.owner == OWNER(), 'err owner');
                assert(swap_result.allowed == ZERO(), 'err allowed');
                assert(swap_result.expiry == block_timestamp, 'err expiry');
            }

            #[test]
            fn test_should_be_able_to_create_a_N_N_swap_with_ERC721() {
                let (swaplace, mock_erc20, mock_erc721) = setup();

                let biding_addr = array![
                    mock_erc721.contract_address,
                    mock_erc721.contract_address,
                    mock_erc721.contract_address,
                ];
                let biding_amount_or_id = array![1, 2, 3];
                let asking_addr = array![
                    mock_erc721.contract_address,
                    mock_erc721.contract_address,
                    mock_erc721.contract_address,
                ];
                let asking_amount_or_id = array![4, 5, 6];

                let block_timestamp = 1000; // TODO: get_block_timestamp() * 2
                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    block_timestamp,
                    biding_addr.span(),
                    biding_amount_or_id.span(),
                    asking_addr.span(),
                    asking_amount_or_id.span(),
                );

                let total_swaps_bf = swaplace.get_total_swaps();
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                assert(swaplace.get_total_swaps() == total_swaps_bf + 1, 'err total_swaps');

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.owner == OWNER(), 'err owner');
                assert(swap_result.allowed == ZERO(), 'err allowed');
                assert(swap_result.expiry == block_timestamp, 'err expiry');
            }
        }

        mod reverts_when_creating_swaps {
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, make_swap, compose_swap
            };
            use swaplace::tests::utils::constants::{ACCEPTEE, OWNER, DEPLOYER, ZERO};
            use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
            use swaplace::Swaplace::{Swap, Asset};
            use snforge_std::{declare, ContractClassTrait};
            use snforge_std::{CheatTarget, start_prank, stop_prank, start_warp, stop_warp};

            #[test]
            #[should_panic(expected: ('Swaplace: Invalid address',))]
            fn test_should_revert_when_owner_is_not_caller_address() {
                let (swaplace, mock_erc20, mock_erc721) = setup();
                let (swap, biding, asking) = mock_swap(
                    mock_erc20.contract_address, mock_erc721.contract_address
                );

                start_warp(CheatTarget::One(swaplace.contract_address), swap.expiry * 2);
                start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
                swaplace.create_swap(swap, biding, asking);
            }

            #[test]
            #[should_panic(expected: ('Swaplace: Invalid expiry time',))]
            fn test_should_revert_when_expiry_is_smaller_than_block_timestamp() {
                let (swaplace, mock_erc20, mock_erc721) = setup();
                let (mut swap, biding, asking) = mock_swap(
                    mock_erc20.contract_address, mock_erc721.contract_address
                );

                start_warp(CheatTarget::One(swaplace.contract_address), swap.expiry * 2);
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));
                stop_warp(CheatTarget::One(swaplace.contract_address));
            }

            #[test]
            #[should_panic(expected: ('Swaplace: Invalid assets length',))]
            fn test_should_revert_when_biding_and_asking_lengths_are_equal_0() {
                let (swaplace, mock_erc20, mock_erc721) = setup();
                let (swap, _, _) = mock_swap(
                    mock_erc20.contract_address, mock_erc721.contract_address
                );
                let biding = array![];
                let asking = array![];

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                swaplace.create_swap(swap, biding.span(), asking.span());
                stop_prank(CheatTarget::One(swaplace.contract_address));
            }
        }
    }

    mod accepting_swaps {
        use core::array::ArrayTrait;
        use swaplace::tests::utils::swaplace_helper::{
            setup, mock_swap, make_asset, make_swap, compose_swap
        };
        use swaplace::tests::utils::constants::{ACCEPTEE, OWNER, DEPLOYER, ZERO};
        use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
        use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
        use swaplace::Swaplace::{Swap, Asset};
        use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
        use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
        use snforge_std::{CheatTarget, start_prank, stop_prank};

        fn before_each() -> (
            Swap,
            Span<Asset>,
            Span<Asset>,
            ISwaplaceDispatcher,
            IMockERC20Dispatcher,
            IMockERC721Dispatcher
        ) {
            let (swaplace, mock_erc20, mock_erc721) = setup();

            mock_erc721.mint_to(OWNER(), 1);
            mock_erc20.mint_to(ACCEPTEE(), 1000);

            start_prank(CheatTarget::One(mock_erc721.contract_address), OWNER());
            mock_erc721.approve(swaplace.contract_address, 1);
            stop_prank(CheatTarget::One(mock_erc721.contract_address));

            start_prank(CheatTarget::One(mock_erc20.contract_address), ACCEPTEE());
            mock_erc20.approve(swaplace.contract_address, 1000);
            stop_prank(CheatTarget::One(mock_erc20.contract_address));

            let biding_addr = array![mock_erc721.contract_address];
            let biding_amount_or_id = array![1];
            let asking_addr = array![mock_erc20.contract_address];
            let asking_amount_or_id = array![1000];

            let block_timestamp = 1000; // TODO: get_block_timestamp() * 2
            let (swap, biding, asking) = compose_swap(
                OWNER(),
                ZERO(),
                block_timestamp,
                biding_addr.span(),
                biding_amount_or_id.span(),
                asking_addr.span(),
                asking_amount_or_id.span(),
            );
            (swap, biding, asking, swaplace, mock_erc20, mock_erc721)
        }

        mod accepting_different_types_of_swaps {
            use super::before_each;
            use core::array::ArrayTrait;
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, make_swap, compose_swap
            };
            use swaplace::tests::utils::constants::{ACCEPTEE, OWNER, DEPLOYER, ZERO};
            use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
            use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
            use swaplace::Swaplace::{Swap, Asset};
            use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
            use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
            use snforge_std::{CheatTarget, start_prank, stop_prank};
            use openzeppelin::token::erc20::interface::{IERC20Metadata, IERC20, IERC20Camel};

            #[test]
            fn test_should_be_able_to_accept_swap_as_1_1_swap() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
                swaplace.accept_swap(swap_id);
                stop_prank(CheatTarget::One(swaplace.contract_address));
                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.expiry == 0, 'err expiry');
            }

            #[test]
            fn test_should_be_able_to_accept_swap_as_N_N_swap() {
                let (mut swap, _, _, swaplace, mock_erc20, mock_erc721) = before_each();

                mock_erc20.mint_to(OWNER(), 500);
                mock_erc721.mint_to(ACCEPTEE(), 5);

                start_prank(CheatTarget::One(mock_erc20.contract_address), OWNER());
                mock_erc20.approve(swaplace.contract_address, 500);
                stop_prank(CheatTarget::One(mock_erc20.contract_address));

                start_prank(CheatTarget::One(mock_erc721.contract_address), ACCEPTEE());
                mock_erc721.approve(swaplace.contract_address, 5);
                stop_prank(CheatTarget::One(mock_erc721.contract_address));

                let biding = array![
                    make_asset(mock_erc721.contract_address, 1),
                    make_asset(mock_erc20.contract_address, 500)
                ];
                let asking = array![
                    make_asset(mock_erc20.contract_address, 1000),
                    make_asset(mock_erc721.contract_address, 5)
                ];

                swap.biding_count = 2;
                swap.asking_count = 2;

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding.span(), asking.span());
                stop_prank(CheatTarget::One(swaplace.contract_address));

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.owner == OWNER(), 'err owner');
                assert(swap_result.allowed == ZERO(), 'err allowed');
                assert(swap_result.expiry == swap.expiry, 'err expiry');

                start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
                swaplace.accept_swap(swap_id);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.expiry == 0, 'err expiry');
            }

            #[test]
            fn test_should_be_able_to_accept_swap_as_P2P_swap() {
                let (_, _, _, swaplace, mock_erc20, mock_erc721) = before_each();

                mock_erc20.mint_to(OWNER(), 1000);
                mock_erc721.mint_to(ACCEPTEE(), 10);

                start_prank(CheatTarget::One(mock_erc20.contract_address), OWNER());
                mock_erc20.approve(swaplace.contract_address, 1000);
                stop_prank(CheatTarget::One(mock_erc20.contract_address));

                start_prank(CheatTarget::One(mock_erc721.contract_address), ACCEPTEE());
                mock_erc721.approve(swaplace.contract_address, 10);
                stop_prank(CheatTarget::One(mock_erc721.contract_address));

                let (mut swap, biding, asking) = mock_swap(
                    mock_erc20.contract_address, mock_erc721.contract_address
                );
                swap.allowed = ACCEPTEE();

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.owner == OWNER(), 'err owner');
                assert(swap_result.allowed == ACCEPTEE(), 'err allowed');
                assert(swap_result.expiry == swap.expiry, 'err expiry');

                start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
                swaplace.accept_swap(swap_id);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.expiry == 0, 'err expiry');
            }
        }

        mod reverts_when_accepting_swaps {
            use super::before_each;
            use core::array::ArrayTrait;
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, make_swap, compose_swap
            };
            use swaplace::tests::utils::constants::{ACCEPTEE, OWNER, DEPLOYER, ZERO};
            use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
            use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
            use swaplace::Swaplace::{Swap, Asset};
            use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
            use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
            use snforge_std::{CheatTarget, start_prank, stop_prank, start_warp, stop_warp};

            #[test]
            #[should_panic(expected: ('Swaplace: Invalid expiry time',))]
            fn test_should_revert_when_calling_accept_swap_twice() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();

                start_warp(CheatTarget::One(swaplace.contract_address), swap.expiry * 2);

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
                swaplace.accept_swap(swap_id);

                let swap_result = swaplace.get_swap(swap_id);
                assert(swap_result.expiry == 0, 'err expiry');

                swaplace.accept_swap(swap_id);

                stop_prank(CheatTarget::One(swaplace.contract_address));

                stop_warp(CheatTarget::One(swaplace.contract_address));
            }

            #[test]
            #[should_panic(expected: ('Swaplace: Invalid expiry time',))]
            fn test_should_revert_when_expiry_is_smaller_than_block_timestamp() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                start_warp(CheatTarget::One(swaplace.contract_address), swap.expiry * 2);

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                swaplace.accept_swap(swap_id);
            }

            #[test]
            #[should_panic(expected: ('ERC721: unauthorized caller',))]
            fn test_should_revert_when_allowance_is_not_provided() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();

                start_prank(CheatTarget::One(mock_erc721.contract_address), OWNER());
                mock_erc721.approve(ZERO(), 1);
                stop_prank(CheatTarget::One(mock_erc721.contract_address));

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
                swaplace.accept_swap(swap_id);
            }

            #[test]
            #[should_panic(expected: ('Swaplace: Invalid address',))]
            fn test_should_revert_when_accept_swap_as_not_allowed_to_P2P_swap() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();

                mock_erc20.mint_to(OWNER(), 1000);
                mock_erc721.mint_to(ACCEPTEE(), 10);

                start_prank(CheatTarget::One(mock_erc20.contract_address), OWNER());
                mock_erc20.approve(swaplace.contract_address, 1000);
                stop_prank(CheatTarget::One(mock_erc20.contract_address));

                start_prank(CheatTarget::One(mock_erc721.contract_address), ACCEPTEE());
                mock_erc721.approve(swaplace.contract_address, 10);
                stop_prank(CheatTarget::One(mock_erc721.contract_address));

                let (mut swap, biding, asking) = mock_swap(
                    mock_erc20.contract_address, mock_erc721.contract_address
                );
                swap.allowed = DEPLOYER();

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
                swaplace.accept_swap(swap_id);
            }
        }
    }

    mod canceling_swaps {
        use core::array::ArrayTrait;
        use swaplace::tests::utils::swaplace_helper::{
            setup, mock_swap, make_asset, make_swap, compose_swap
        };
        use swaplace::tests::utils::constants::{ACCEPTEE, OWNER, DEPLOYER, ZERO};
        use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
        use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
        use swaplace::Swaplace::{Swap, Asset};
        use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
        use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
        use snforge_std::{CheatTarget, start_prank, stop_prank};

        fn before_each() -> (
            Swap,
            Span<Asset>,
            Span<Asset>,
            ISwaplaceDispatcher,
            IMockERC20Dispatcher,
            IMockERC721Dispatcher
        ) {
            let (swaplace, mock_erc20, mock_erc721) = setup();
            let (swap, biding, asking) = mock_swap(
                mock_erc20.contract_address, mock_erc721.contract_address
            );

            start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
            swaplace.create_swap(swap, biding, asking);
            stop_prank(CheatTarget::One(swaplace.contract_address));

            (swap, biding, asking, swaplace, mock_erc20, mock_erc721)
        }

        mod canceling_swaps {
            use super::before_each;
            use core::array::ArrayTrait;
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, make_swap, compose_swap
            };
            use swaplace::tests::utils::constants::{ACCEPTEE, OWNER, DEPLOYER, ZERO};
            use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
            use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
            use swaplace::Swaplace::{Swap, Asset};
            use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
            use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
            use snforge_std::{CheatTarget, start_prank, stop_prank, start_warp, stop_warp};
            use openzeppelin::token::erc20::interface::{IERC20Metadata, IERC20, IERC20Camel};

            #[test]
            fn test_should_be_able_to_cancel_swap_a_swap() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();

                let last_swap = swaplace.get_total_swaps();
                // before each create a swap, thats bc 1 its the last_swap
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                swaplace.cancel_swap(last_swap);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                let swap_result = swaplace.get_swap(last_swap);
                assert(swap_result.expiry == 0, 'err expiry');
            }

            #[test]
            #[should_panic(expected: ('Swaplace: Invalid expiry time',))]
            fn test_should_not_be_able_to_accept_swap_a_canceled_a_swap() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();
                start_warp(CheatTarget::One(swaplace.contract_address), swap.expiry * 2);

                let last_swap = swaplace.get_total_swaps();
                // before each create a swap, thats bc 1 its the last_swap
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                swaplace.accept_swap(last_swap);
            }
        }

        mod reverts_when_canceling_swaps {
            use super::before_each;
            use core::array::ArrayTrait;
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, make_swap, compose_swap
            };
            use swaplace::tests::utils::constants::{ACCEPTEE, OWNER, DEPLOYER, ZERO};
            use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
            use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
            use swaplace::Swaplace::{Swap, Asset};
            use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
            use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
            use snforge_std::{CheatTarget, start_prank, stop_prank, start_warp, stop_warp};
            use openzeppelin::token::erc20::interface::{IERC20Metadata, IERC20, IERC20Camel};

            // TODO: check this
            #[test]
            #[should_panic(expected: ('Swaplace: Invalid address',))]
            fn test_should_revert_when_owner_is_not_caller() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();

                let last_swap = swaplace.get_total_swaps();
                // before each create a swap, thats bc 1 its the last_swap
                start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
                swaplace.accept_swap(last_swap);
            }

            #[test]
            #[should_panic(expected: ('Swaplace: Invalid expiry time',))]
            fn test_should_revert_when_expiry_is_smaller_than_block_timestamp() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();

                let last_swap = swaplace.get_total_swaps();
                // before each create a swap, thats bc 1 its the last_swap
                start_warp(CheatTarget::One(swaplace.contract_address), swap.expiry * 2);
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                swaplace.cancel_swap(last_swap);
            }
        }
    }
    mod fetching_swaps {
        use core::array::ArrayTrait;
        use swaplace::tests::utils::swaplace_helper::{
            setup, mock_swap, make_asset, make_swap, compose_swap
        };
        use swaplace::tests::utils::constants::{ACCEPTEE, OWNER, DEPLOYER, ZERO};
        use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
        use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
        use swaplace::Swaplace::{Swap, Asset};
        use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
        use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
        use snforge_std::{CheatTarget, start_prank, stop_prank, start_warp, stop_warp};
        use openzeppelin::token::erc20::interface::{IERC20Metadata, IERC20, IERC20Camel};

        fn before_each() -> ISwaplaceDispatcher {
            let (swaplace, mock_erc20, mock_erc721) = setup();

            mock_erc721.mint_to(OWNER(), 1);
            mock_erc20.mint_to(ACCEPTEE(), 1000);

            let biding_addr = array![mock_erc721.contract_address];
            let biding_amount_or_id = array![1];

            let asking_addr = array![mock_erc20.contract_address];
            let asking_amount_or_id = array![1000];

            let (swap, biding, asking) = compose_swap(
                OWNER(),
                ZERO(),
                1000, // TODO: get_block_timestamp() * 2
                biding_addr.span(),
                biding_amount_or_id.span(),
                asking_addr.span(),
                asking_amount_or_id.span(),
            );

            start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
            swaplace.create_swap(swap, biding, asking);
            stop_prank(CheatTarget::One(swaplace.contract_address));

            swaplace
        }

        #[test]
        fn test_should_be_able_to_get_swap() {
            let swaplace = before_each();

            let last_swap = swaplace.get_total_swaps();
            let fetched_swap = swaplace.get_swap(last_swap);

            assert(fetched_swap.owner != ZERO(), 'err owner');
            // swap.allowed can be the zero address and shoul not be trusted for validation
            assert(fetched_swap.expiry != 0, 'err expiry');
            assert(fetched_swap.biding_count > 0, 'err biding_count');
            assert(fetched_swap.asking_count > 0, 'err asking_count');
        }

        #[test]
        fn test_should_return_empty_with_get_swap_when_swap_is_non_existant() {
            let swaplace = before_each();

            let imaginary_swap_id = 777;
            let fetched_swap = swaplace.get_swap(imaginary_swap_id);

            assert(fetched_swap.owner == ZERO(), 'err owner');
            // swap.allowed can be the zero address and shoul not be trusted for validation
            assert(fetched_swap.allowed == ZERO(), 'err allowed');
            assert(fetched_swap.expiry == 0, 'err expiry');
        }
    }
}
