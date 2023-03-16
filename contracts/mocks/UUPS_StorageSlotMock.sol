//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {ERC1967UpgradeUUPS} from "../ERC1967UpgradeUUPS.sol";

/**
 * @title Mock contract for testing <UUPS_StorageSlot>
 * @author Vladimir Kumalagov
 */
contract ERC1967UpgradeUUPSMock is ERC1967UpgradeUUPS {
	// Return address of the implementation
	function getImplementation() external view returns (address) {
		return _getImplementation();
	}

	function writeToImplementationSlot(address newImpl) external {
		assembly {
			sstore(IMPL_SLOT, newImpl)
		}
	}

	function getImplementationSlot() external pure returns (bytes32) {
		return IMPL_SLOT;
	}
}
