use snforge_std::{declare, ContractClassTrait};
use snforge_std::{CheatTarget, start_prank, stop_prank};

use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
use swaplace::interfaces::ISwaplace::{ISwaplaceDispatcher, ISwaplaceDispatcherTrait};
use swaplace::Swaplace::{Swap, Asset};
use swaplace::mocks::MockERC20::{IMockERC20Dispatcher, IMockERC20DispatcherTrait};
use swaplace::mocks::MockERC721::{IMockERC721Dispatcher, IMockERC721DispatcherTrait};
use swaplace::tests::utils::constants::{ACCEPTEE, OWNER, DEPLOYER, ZERO, MOCK_BLOCK_TIMESTAMP};

fn setup() -> (ISwaplaceDispatcher, IMockERC20Dispatcher, IMockERC721Dispatcher) {
    let swaplace = deploy_swaplace();
    let mock_erc20 = deploy_mock_erc20();
    let mock_erc721 = deploy_mock_erc721();
    (swaplace, mock_erc20, mock_erc721)
}

fn mock_swap(
    mock_erc20: ContractAddress, mock_erc721: ContractAddress
) -> (Swap, Span<Asset>, Span<Asset>) {
    let biding_addr = array![mock_erc721];
    let biding_amount_or_id = array![1];

    let asking_addr = array![mock_erc20];
    let asking_amount_or_id = array![50];

    compose_swap(
        OWNER(),
        ZERO(),
        MOCK_BLOCK_TIMESTAMP,
        biding_addr.span(),
        biding_amount_or_id.span(),
        asking_addr.span(),
        asking_amount_or_id.span(),
    )
}

fn make_asset(addr: ContractAddress, amount_or_id: u256,) -> Asset {
    Asset { addr, amount_or_id }
}

fn make_swap(
    owner: ContractAddress,
    allowed: ContractAddress,
    expiry: u64,
    biding: Span<Asset>,
    asking: Span<Asset>,
) -> Swap {
    // check for the current `block.timestamp` because `expiry` cannot be in the past
    // let timestamp = (await ethers.provider.getBlock("latest")).timestamp;
    // if expiry < timestamp {
    //     throw new Error("InvalidExpiry");
    // }

    // if biding.len() == 0 || asking.len() == 0 {
    //     throw new Error("InvalidAssetsLength");
    // }

    Swap {
        owner,
        allowed,
        expiry,
        biding_count: biding.len().into(),
        asking_count: asking.len().into(),
    }
}

fn compose_swap(
    owner: ContractAddress,
    allowed: ContractAddress,
    expiry: u64,
    biding_addr: Span<ContractAddress>,
    biding_amount_or_id: Span<u256>,
    asking_addr: Span<ContractAddress>,
    asking_amount_or_id: Span<u256>,
) -> (Swap, Span<Asset>, Span<Asset>) {
    // lenght of addresses and their respective amounts must be equal
    // if (
    //     bidingAddr.length != bidingAmountOrId.length ||
    //     askingAddr.length != askingAmountOrId.length
    // ) {
    //     throw new Error("InvalidAssetsLength");
    // }

    // push new assets to the array of bids and asks
    let mut biding = array![];
    let mut idx = 0;
    loop {
        if idx == biding_addr.len() {
            break;
        }
        biding.append(make_asset(*biding_addr.at(idx), *biding_amount_or_id.at(idx)));
        idx += 1;
    };

    let mut asking = array![];
    let mut idx = 0;
    loop {
        if idx == asking_addr.len() {
            break;
        }
        asking.append(make_asset(*asking_addr.at(idx), *asking_amount_or_id.at(idx)));
        idx += 1;
    };

    let swap = make_swap(owner, allowed, expiry, biding.span(), asking.span());
    (swap, biding.span(), asking.span())
}

fn deploy_swaplace() -> ISwaplaceDispatcher {
    let swaplace = declare('Swaplace');
    let calldata = array![];
    let address = swaplace.deploy(@calldata).unwrap();
    return ISwaplaceDispatcher { contract_address: address };
}

fn deploy_mock_erc20() -> IMockERC20Dispatcher {
    let erc20 = declare('MockERC20');
    let mut calldata = array![];
    let address = erc20.deploy(@calldata).unwrap();
    IMockERC20Dispatcher { contract_address: address }
}

fn deploy_mock_erc721() -> IMockERC721Dispatcher {
    let erc721 = declare('MockERC721');
    let mut calldata = array![];
    let address = erc721.deploy(@calldata).unwrap();
    IMockERC721Dispatcher { contract_address: address }
}
