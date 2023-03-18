//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Interfaces
import {IUUPSUpgradeable} from "./interfaces/IUUPSUpgradeable.sol";

// Contracts
import {ERC1967Base} from "./ERC1967Base.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract UUPSUpgradeable is
	IUUPSUpgradeable,
	Initializable,
	ERC1967Base
{
	// During the deployment of the implementation, address(this) will be the implementation address.
	address private immutable __self = address(this);

	constructor() {
		_disableInitializers();
	}

	modifier onlyProxy() {
		// Only delegatecall accepted
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
	function upgradeTo(address newImplementation) external onlyProxy {
		_authorizeUpgrade(newImplementation);
		_upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
	}

	// Initializes the smart-contract update, with an additional call to <newImplementation> with <data>.
	function upgradeToAndCall(
		address newImplementation,
		bytes memory data
	) external onlyProxy {
		_authorizeUpgrade(newImplementation);
		_upgradeToAndCallUUPS(newImplementation, data, true);
	}

	// Function that should revert when `msg.sender` is not authorized to upgrade the contract.
	function _authorizeUpgrade(address newImplementation) internal virtual;
}
