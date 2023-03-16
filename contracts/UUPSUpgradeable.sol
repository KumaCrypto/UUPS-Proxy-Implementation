//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Interfaces
import {IERC1822Proxiable} from "./interfaces/IERC1822Proxiable.sol";
import {IUUPSUpgradeableErrors} from "./errors/IUUPSUpgradeableErrors.sol";

// Contracts
import {ERC1967UpgradeUUPS} from "./ERC1967UpgradeUUPS.sol";

abstract contract UUPSUpgradeable is
	IERC1822Proxiable,
	IUUPSUpgradeableErrors,
	ERC1967UpgradeUUPS
{
	// During the deployment of the implementation, address(this) will be the implementation address.
	address private immutable __self = address(this);

	modifier onlyProxy() {
		// Onle delegatecall accepted
		if (address(this) == __self) revert UUPSUpgradeable__notDelegateCall();

		// Delegatecall not from active implementation
		if (_getImplementation() != __self)
			revert UUPSUpgradeable__notAnActiveProxy();
		_;
	}

	// Returns implementation slot.
	// Required by ERC1822 (checking compatibility).
	function proxiableUUID() external view returns (bytes32) {
		if (address(this) != __self) revert UUPSUpgradeable__onlySimpleCall();
		return IMPL_SLOT;
	}

	// Initializes the smart-contract update, without an additional call.
	function upgradeTo(address newImplementation) public onlyProxy {
		_authorizeUpgrade(newImplementation);
		_upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
	}

	// Initializes the smart-contract update, with an additional call to <newImplementation> with <data>.
	function upgradeToAndCall(
		address newImplementation,
		bytes memory data
	) public onlyProxy {
		_authorizeUpgrade(newImplementation);
		_upgradeToAndCallUUPS(newImplementation, data, true);
	}

	// Function that should revert when `msg.sender` is not authorized to upgrade the contract.
	function _authorizeUpgrade(address newImplementation) internal virtual;
}
