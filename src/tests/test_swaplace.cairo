mod SwaplaceTests {
    mod creating_swaps {
        mod creating_different_types_of_swaps {
            use core::array::ArrayTrait;
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, compose_swap
            };
            use swaplace::tests::utils::constants::{
                ACCEPTEE, OWNER, DEPLOYER, ZERO, MOCK_BLOCK_TIMESTAMP
            };

            use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
            use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
            use swaplace::Swaplace::{Swaplace, Swap, Asset};
            use snforge_std::{
                CheatTarget, start_prank, stop_prank, spy_events, SpyOn, EventSpy, EventAssertions
            };

            #[test]
            fn test_should_be_emit_event_when_swap_is_created() {
                let (swaplace, mock_erc20, mock_erc721) = setup();

                let biding_addr = array![mock_erc20.contract_address];
                let biding_amount_or_id = array![50];
                let asking_addr = array![mock_erc20.contract_address];
                let asking_amount_or_id = array![50];

                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    MOCK_BLOCK_TIMESTAMP,
                    biding_addr.span(),
                    biding_amount_or_id.span(),
                    asking_addr.span(),
                    asking_amount_or_id.span(),
                );

                let mut spy_events = spy_events(SpyOn::One(swaplace.contract_address));
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                spy_events
                    .assert_emitted(
                        @array![
                            (
                                swaplace.contract_address,
                                Swaplace::Event::SwapCreated(
                                    Swaplace::SwapCreated {
                                        user: OWNER(),
                                        swap_id: swap_id,
                                        allowed: ZERO(),
                                        expiry: MOCK_BLOCK_TIMESTAMP
                                    }
                                )
                            )
                        ]
                    );
            }

            #[test]
            fn test_should_be_able_to_create_a_1_1_swap_with_ERC20() {
                let (swaplace, mock_erc20, mock_erc721) = setup();

                let biding_addr = array![mock_erc20.contract_address];
                let biding_amount_or_id = array![50];
                let asking_addr = array![mock_erc20.contract_address];
                let asking_amount_or_id = array![50];

                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    MOCK_BLOCK_TIMESTAMP,
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
                assert(swap_result.expiry == MOCK_BLOCK_TIMESTAMP, 'err expiry');
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

                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    MOCK_BLOCK_TIMESTAMP,
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
                assert(swap_result.expiry == MOCK_BLOCK_TIMESTAMP, 'err expiry');
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

                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    MOCK_BLOCK_TIMESTAMP,
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
                assert(swap_result.expiry == MOCK_BLOCK_TIMESTAMP, 'err expiry');
            }

            #[test]
            fn test_should_be_able_to_create_a_1_1_swap_with_ERC721() {
                let (swaplace, mock_erc20, mock_erc721) = setup();

                let biding_addr = array![mock_erc721.contract_address];
                let biding_amount_or_id = array![1];
                let asking_addr = array![mock_erc721.contract_address];
                let asking_amount_or_id = array![4];

                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    MOCK_BLOCK_TIMESTAMP,
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
                assert(swap_result.expiry == MOCK_BLOCK_TIMESTAMP, 'err expiry');
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

                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    MOCK_BLOCK_TIMESTAMP,
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
                assert(swap_result.expiry == MOCK_BLOCK_TIMESTAMP, 'err expiry');
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

                let (swap, biding, asking) = compose_swap(
                    OWNER(),
                    ZERO(),
                    MOCK_BLOCK_TIMESTAMP,
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
                assert(swap_result.expiry == MOCK_BLOCK_TIMESTAMP, 'err expiry');
            }
        }

        mod reverts_when_creating_swaps {
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, compose_swap
            };
            use swaplace::tests::utils::constants::{
                ACCEPTEE, OWNER, DEPLOYER, ZERO, MOCK_BLOCK_TIMESTAMP
            };
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
        use swaplace::tests::utils::swaplace_helper::{setup, mock_swap, make_asset, compose_swap};
        use swaplace::tests::utils::constants::{
            ACCEPTEE, OWNER, DEPLOYER, ZERO, MOCK_BLOCK_TIMESTAMP
        };
        use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
        use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
        use swaplace::Swaplace::{Swaplace, Swap, Asset};
        use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
        use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
        use snforge_std::{
            CheatTarget, start_prank, stop_prank, start_warp, stop_warp, spy_events, SpyOn,
            EventSpy, EventAssertions
        };

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

            let (swap, biding, asking) = compose_swap(
                OWNER(),
                ZERO(),
                MOCK_BLOCK_TIMESTAMP,
                biding_addr.span(),
                biding_amount_or_id.span(),
                asking_addr.span(),
                asking_amount_or_id.span(),
            );
            (swap, biding, asking, swaplace, mock_erc20, mock_erc721)
        }

        #[test]
        fn test_should_be_emit_event_when_swap_is_accepted() {
            let (swaplace, mock_erc20, mock_erc721) = setup();
            mock_erc20.mint_to(OWNER(), 100);
            mock_erc20.mint_to(ACCEPTEE(), 100);

            let biding_addr = array![mock_erc20.contract_address];
            let biding_amount_or_id = array![50];
            let asking_addr = array![mock_erc20.contract_address];
            let asking_amount_or_id = array![50];

            start_prank(CheatTarget::One(mock_erc20.contract_address), OWNER());
            mock_erc20.approve(swaplace.contract_address, 50);
            stop_prank(CheatTarget::One(mock_erc20.contract_address));

            start_prank(CheatTarget::One(mock_erc20.contract_address), ACCEPTEE());
            mock_erc20.approve(swaplace.contract_address, 50);
            stop_prank(CheatTarget::One(mock_erc20.contract_address));

            let (swap, biding, asking) = compose_swap(
                OWNER(),
                ACCEPTEE(),
                MOCK_BLOCK_TIMESTAMP,
                biding_addr.span(),
                biding_amount_or_id.span(),
                asking_addr.span(),
                asking_amount_or_id.span(),
            );
            start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
            let swap_id = swaplace.create_swap(swap, biding, asking);
            stop_prank(CheatTarget::One(swaplace.contract_address));

            let mut spy_events = spy_events(SpyOn::One(swaplace.contract_address));

            // set block timestamp bf expiry time
            start_warp(CheatTarget::One(swaplace.contract_address), swap.expiry - 1);
            start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
            swaplace.accept_swap(swap_id);
            stop_prank(CheatTarget::One(swaplace.contract_address));
            stop_warp(CheatTarget::One(swaplace.contract_address));

            spy_events
                .assert_emitted(
                    @array![
                        (
                            swaplace.contract_address,
                            Swaplace::Event::SwapAccepted(
                                Swaplace::SwapAccepted { user: ACCEPTEE(), swap_id: swap_id, }
                            )
                        )
                    ]
                );
        }

        mod accepting_different_types_of_swaps {
            use super::before_each;
            use core::array::ArrayTrait;
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, make_swap, compose_swap
            };
            use swaplace::tests::utils::constants::{
                ACCEPTEE, OWNER, DEPLOYER, ZERO, MOCK_BLOCK_TIMESTAMP
            };
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

                let mut erc20_balance = mock_erc20.balance_of(ACCEPTEE());
                let mut token_1_owner = mock_erc721.owner_of(1);

                assert(erc20_balance == 1000, 'err wrong accepte balance');
                assert(token_1_owner == OWNER(), 'err wrong owner');

                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
                swaplace.accept_swap(swap_id);
                stop_prank(CheatTarget::One(swaplace.contract_address));

                erc20_balance = mock_erc20.balance_of(OWNER());
                token_1_owner = mock_erc721.owner_of(1);

                assert(erc20_balance == 1000, 'err wrong owner balance');
                assert(token_1_owner == ACCEPTEE(), 'err wrong owner');
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

                let mut erc20_balance_owner = mock_erc20.balance_of(OWNER());
                let mut erc20_balance_acceptee = mock_erc20.balance_of(ACCEPTEE());
                let mut owner_of_nft_1 = mock_erc721.owner_of(1);
                let mut owner_of_nft_5_ = mock_erc721.owner_of(5);

                assert(erc20_balance_owner == 500, 'err wrong owner balance');
                assert(erc20_balance_acceptee == 1000, 'err wrong accepte balance');
                assert(owner_of_nft_1 == OWNER(), 'err wrong nft 1 owner');
                assert(owner_of_nft_5_ == ACCEPTEE(), 'err wrong nft 5 owner');

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

                erc20_balance_owner = mock_erc20.balance_of(OWNER());
                erc20_balance_acceptee = mock_erc20.balance_of(ACCEPTEE());
                owner_of_nft_1 = mock_erc721.owner_of(1);
                owner_of_nft_5_ = mock_erc721.owner_of(5);

                assert(erc20_balance_owner == 1000, 'err wrong owner balance');
                assert(erc20_balance_acceptee == 500, 'err wrong accepte balance');
                assert(owner_of_nft_1 == ACCEPTEE(), 'err wrong nft 1 owner');
                assert(owner_of_nft_5_ == OWNER(), 'err wrong nft 5 owner');
            }

            #[test]
            fn test_should_be_able_to_accept_swap_as_P2P_swap() {
                let (_, _, _, swaplace, mock_erc20, mock_erc721) = before_each();

                let (mut swap, biding, asking) = mock_swap(
                    mock_erc20.contract_address, mock_erc721.contract_address
                );
                swap.allowed = ACCEPTEE();

                let erc20_balance = mock_erc20.balance_of(ACCEPTEE());
                let mut token_1_owner = mock_erc721.owner_of(1);

                assert(erc20_balance == 1000, 'err wrong accepte balance');
                assert(token_1_owner == OWNER(), 'err wrong owner');

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

                let erc20_balance_owner = mock_erc20.balance_of(OWNER());
                let erc20_balance_acceptee = mock_erc20.balance_of(ACCEPTEE());
                token_1_owner = mock_erc721.owner_of(1);

                assert(erc20_balance_owner == 50, 'err wrong owner balance');
                assert(erc20_balance_acceptee == 950, 'err wrong acceptee balance');
                assert(token_1_owner == ACCEPTEE(), 'err wrong owner');
            }
        }

        mod reverts_when_accepting_swaps {
            use super::before_each;
            use core::array::ArrayTrait;
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, compose_swap
            };
            use swaplace::tests::utils::constants::{
                ACCEPTEE, OWNER, DEPLOYER, ZERO, MOCK_BLOCK_TIMESTAMP
            };
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
                let (mut swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();
                swap.expiry = 500;

                start_warp(CheatTarget::One(swaplace.contract_address), 400);
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let swap_id = swaplace.create_swap(swap, biding, asking);
                stop_prank(CheatTarget::One(swaplace.contract_address));
                stop_warp(CheatTarget::One(swaplace.contract_address));

                let swap = swaplace.get_swap(swap_id);

                start_warp(CheatTarget::One(swaplace.contract_address), 600);
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                swaplace.accept_swap(swap_id);
                stop_prank(CheatTarget::One(swaplace.contract_address));
                stop_warp(CheatTarget::One(swaplace.contract_address));
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
        use swaplace::tests::utils::swaplace_helper::{setup, mock_swap, make_asset, compose_swap};
        use swaplace::tests::utils::constants::{
            ACCEPTEE, OWNER, DEPLOYER, ZERO, MOCK_BLOCK_TIMESTAMP
        };
        use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
        use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
        use swaplace::Swaplace::{Swaplace, Swap, Asset};
        use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
        use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
        use snforge_std::{
            CheatTarget, start_prank, stop_prank, start_warp, stop_warp, spy_events, SpyOn,
            EventSpy, EventAssertions
        };

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
            let swap_id = swaplace.create_swap(swap, biding, asking);
            stop_prank(CheatTarget::One(swaplace.contract_address));

            (swap, biding, asking, swaplace, mock_erc20, mock_erc721)
        }

        #[test]
        fn test_should_be_emit_event_when_swap_is_canceled() {
            let (swaplace, mock_erc20, mock_erc721) = setup();
            mock_erc20.mint_to(OWNER(), 100);
            mock_erc20.mint_to(ACCEPTEE(), 100);

            let biding_addr = array![mock_erc20.contract_address];
            let biding_amount_or_id = array![50];
            let asking_addr = array![mock_erc20.contract_address];
            let asking_amount_or_id = array![50];

            start_prank(CheatTarget::One(mock_erc20.contract_address), OWNER());
            mock_erc20.approve(swaplace.contract_address, 50);
            stop_prank(CheatTarget::One(mock_erc20.contract_address));

            start_prank(CheatTarget::One(mock_erc20.contract_address), ACCEPTEE());
            mock_erc20.approve(swaplace.contract_address, 50);
            stop_prank(CheatTarget::One(mock_erc20.contract_address));

            let (swap, biding, asking) = compose_swap(
                OWNER(),
                ACCEPTEE(),
                MOCK_BLOCK_TIMESTAMP,
                biding_addr.span(),
                biding_amount_or_id.span(),
                asking_addr.span(),
                asking_amount_or_id.span(),
            );
            start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
            let swap_id = swaplace.create_swap(swap, biding, asking);
            stop_prank(CheatTarget::One(swaplace.contract_address));

            let mut spy_events = spy_events(SpyOn::One(swaplace.contract_address));

            // set block timestamp bf expiry time
            start_warp(CheatTarget::One(swaplace.contract_address), swap.expiry - 1);
            start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
            swaplace.cancel_swap(swap_id);
            stop_prank(CheatTarget::One(swaplace.contract_address));
            stop_warp(CheatTarget::One(swaplace.contract_address));

            spy_events
                .assert_emitted(
                    @array![
                        (
                            swaplace.contract_address,
                            Swaplace::Event::SwapCanceled(
                                Swaplace::SwapCanceled { user: OWNER(), swap_id: swap_id, }
                            )
                        )
                    ]
                );
        }

        mod canceling_swaps {
            use super::before_each;
            use core::array::ArrayTrait;
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, compose_swap
            };
            use swaplace::tests::utils::constants::{
                ACCEPTEE, OWNER, DEPLOYER, ZERO, MOCK_BLOCK_TIMESTAMP
            };
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
                // set time 1 sec after the expiration time
                let block_timestamp = swap.expiry + 1;
                start_warp(CheatTarget::One(swaplace.contract_address), block_timestamp);

                let last_swap = swaplace.get_total_swaps();
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                swaplace.accept_swap(last_swap);
            }
        }

        mod reverts_when_canceling_swaps {
            use super::before_each;
            use core::array::ArrayTrait;
            use swaplace::tests::utils::swaplace_helper::{
                setup, mock_swap, make_asset, compose_swap
            };
            use swaplace::tests::utils::constants::{
                ACCEPTEE, OWNER, DEPLOYER, ZERO, MOCK_BLOCK_TIMESTAMP
            };
            use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
            use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
            use swaplace::Swaplace::{Swap, Asset};
            use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
            use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
            use snforge_std::{CheatTarget, start_prank, stop_prank, start_warp, stop_warp};
            use openzeppelin::token::erc20::interface::{IERC20Metadata, IERC20, IERC20Camel};

            #[test]
            #[should_panic(expected: ('Swaplace: Invalid address',))]
            fn test_should_revert_when_owner_is_not_caller() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();
                // set time 1 sec bf the expiration time
                let block_timestamp = swap.expiry - 1;

                start_warp(CheatTarget::One(swaplace.contract_address), block_timestamp);
                start_prank(CheatTarget::One(swaplace.contract_address), ACCEPTEE());
                let last_swap = swaplace.get_total_swaps();
                swaplace.cancel_swap(last_swap);
            }

            #[test]
            #[should_panic(expected: ('Swaplace: Invalid expiry time',))]
            fn test_should_revert_when_expiry_is_smaller_than_block_timestamp() {
                let (swap, biding, asking, swaplace, mock_erc20, mock_erc721) = before_each();
                // set time 1 sec after the expiration time
                let block_timestamp = swap.expiry + 1;

                start_warp(CheatTarget::One(swaplace.contract_address), block_timestamp);
                start_prank(CheatTarget::One(swaplace.contract_address), OWNER());
                let last_swap = swaplace.get_total_swaps();

                swaplace.cancel_swap(last_swap);
                stop_warp(CheatTarget::One(swaplace.contract_address));
                stop_prank(CheatTarget::One(swaplace.contract_address));
            }
        }
    }
    mod fetching_swaps {
        use core::array::ArrayTrait;
        use swaplace::tests::utils::swaplace_helper::{setup, mock_swap, make_asset, compose_swap};
        use swaplace::tests::utils::constants::{
            ACCEPTEE, OWNER, DEPLOYER, ZERO, MOCK_BLOCK_TIMESTAMP
        };
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
                MOCK_BLOCK_TIMESTAMP,
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
