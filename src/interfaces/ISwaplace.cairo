use swaplace::Swaplace::{Asset, Swap};

// Interface of the {Swaplace} implementation.
#[starknet::interface]
trait ISwaplace<TContractState> {
    // Accepts a Swap. Once the Swap is accepted, the expiry is set
    // to zero to avoid reutilization.
    //
    // Requirements:
    //
    // - `allowed` must be the zero address or match the caller address.
    // - `expiry` must be bigger than timestamp.
    // - `biding` assets must be allowed to transfer.
    // - `asking` assets must be allowed to transfer.
    //
    // Emits a {SwapAccepted} event.
    //
    // NOTE: The expiry is set to 0, because if the Swap is expired it
    // will revert, preventing reentrancy attacks.
    fn create_swap(
        ref self: TContractState, swap: Swap, biding: Span<Asset>, asking: Span<Asset>
    ) -> u256;

    // Accepts a Swap. Once the Swap is accepted, the expiry is set
    // to zero to avoid reutilization.
    //
    // Requirements:
    //
    // - `allowed` must be the zero address or match the caller address.
    // - `expiry` must be bigger than timestamp.
    // - `biding` assets must be allowed to transfer.
    // - `asking` assets must be allowed to transfer.
    //
    // Emits a {SwapAccepted} event.
    //
    // NOTE: The expiry is set to 0, because if the Swap is expired it
    // will revert, preventing reentrancy attacks.
    fn accept_swap(ref self: TContractState, swap_id: u256) -> bool;

    // Expiry with 0 seconds means that the Swap doesn't exist
    // or is already canceled.
    //
    // Requirements:
    //
    // - `owner` must be the caller adress.
    // - `expiry` must be bigger than timestamp.
    //
    // Emits a {SwapCanceled} event.
    fn cancel_swap(ref self: TContractState, swap_id: u256);

    // Retrieves the details of a Swap based on the `swapId` provided.
    //
    // NOTE: If the Swaps doesn't exist, the values will be defaulted to 0.
    // You can check if a Swap exists by checking if the `owner` is the zero address.
    // If the `owner` is the zero address, then the Swap doesn't exist.
    fn get_swap(self: @TContractState, swap_id: u256) -> Swap;

    // Retrieves the total number of swaps that have been created in the contract.
    //
    // Returns:
    // - `u256`: The total number of swaps.
    //
    // NOTE: This function provides the count of all swaps, including those that have been accepted,
    // canceled, or expired. It does not filter based on the current state of the swaps.
    fn get_total_swaps(self: @TContractState) -> u256;
}
