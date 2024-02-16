mod Swaplace;

mod interfaces {
    mod ISwaplace;
    mod ITransfer;
}

mod mocks {
    mod MockERC20;
    mod MockERC721;
}

#[cfg(test)]
mod tests {
    mod test_swaplace;

    mod utils {
        mod swaplace_helper;
        mod constants;
    }
}
