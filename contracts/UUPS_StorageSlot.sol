//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

error UUPS_StorageSlot__incorrectSlot();

/**
 * @title Implementation of ERC1967 only for UUPS contracts.
 * @author Vladimir Kumalagov
 */
abstract contract UUPS_StorageSlot {
    // Pointer to storage slot where is implementation address is stored.
    // Computed from uint256(keccak256("eip1967.proxy.implementation")) - 1)
    uint256 internal constant IMPL_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @notice Emited when data in <IMPL_SLOT> is changed.
     * @param implementation - new implementation address
     */
    event Upgraded(address indexed implementation);

    // Validate computed <IMPL_SLOT> slot
    constructor() {
        if (IMPL_SLOT != uint256(keccak256("eip1967.proxy.implementation")) - 1)
            revert UUPS_StorageSlot__incorrectSlot();
    }

    // Returns the address of current implementation
    function _getImplementation() internal view returns (address impl) {
        assembly {
            impl := sload(IMPL_SLOT)
        }
    }
}
