//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Interfaces
import {IERC1822Proxiable} from "./interfaces/IERC1822Proxiable.sol";
import {IERC1967UUPSErrors} from "./interfaces/errors/IERC1967UUPSErrors.sol";

// Libs
import {AddressUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

/**
 * @title Implementation of ERC1967 only for UUPS contracts.
 * @author Vladimir Kumalagov
 */
abstract contract ERC1967Base is IERC1967UUPSErrors {
	// Pointer to storage slot where address of implementation is stored.
	// Computed from uint256(keccak256("eip1967.proxy.implementation")) - 1)
	bytes32 internal constant IMPL_SLOT =
		0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

	/**
	 * @notice Emited when data in <IMPL_SLOT> is changed.
	 * @param implementation - new implementation address
	 */
	event Upgraded(address indexed implementation);

	// Updating the implementation address and
	// if <data> or <forceCall> was provided -> calling <newImpl> with <data>
	function _upgradeToAndCallUUPS(
		address newImplementation,
		bytes memory data,
		bool forceCall
	) internal {
		// There is no compatibility check with the old version of UUPS (rollback slot).
		try IERC1822Proxiable(newImplementation).proxiableUUID() returns (
			bytes32 slot
		) {
			if (slot != IMPL_SLOT) {
				revert ERC1967UpgradeUUPS__unsupportedProxiableUUID(slot);
			}
		} catch {
			revert ERC1967UpgradeUUPS__newImplementationIsNotUUPS();
		}

		_upgradeTo(newImplementation);

		if (data.length > 0 || forceCall) {
			_functionDelegateCall(newImplementation, data);
		}
	}

	// Update the <IMPL_SLOT> with <newImplementation> address
	function _upgradeTo(address newImplementation) private {
		assembly {
			sstore(IMPL_SLOT, newImplementation)
		}

		emit Upgraded(newImplementation);
	}

	// Returns the address of current implementation
	function _getImplementation() internal view virtual returns (address impl) {
		assembly {
			impl := sload(IMPL_SLOT)
		}
	}

	function _functionDelegateCall(
		address target,
		bytes memory data
	) private returns (bytes memory) {
		if (!AddressUpgradeable.isContract(target))
			revert ERC1967UpgradeUUPS__delegatecallToNonContract();

		(bool success, bytes memory returndata) = target.delegatecall(data);

		return
			AddressUpgradeable.verifyCallResult(
				success,
				returndata,
				"Address: low-level delegate call failed"
			);
	}
}
