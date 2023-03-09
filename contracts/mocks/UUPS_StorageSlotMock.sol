//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {UUPS_StorageSlot} from "../UUPS_StorageSlot.sol";

/**
 * @title Mock contract for testing <UUPS_StorageSlot>
 * @author Vladimir Kumalagov
 */
contract UUPS_StorageSlotMock is UUPS_StorageSlot {
    // Return address of the implementation
    function getImplementation() external view returns (address) {
        return _getImplementation();
    }

    function emitUpgraded() external {
        emit Upgraded(address(this));
    }

    function writeToImplementationSlot(address newImpl) external {
        assembly {
            sstore(IMPL_SLOT, newImpl)
        }
    }
}
