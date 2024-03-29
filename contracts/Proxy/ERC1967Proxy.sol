//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Сontracts
import {ERC1967Base} from "../ERC1967Base.sol";
import {Proxy} from "./Proxy.sol";

contract ERC1967Proxy is ERC1967Base, Proxy {
	// While the proxy is being deployed, initialize it immediately in the constructor.
	constructor(address _logic, bytes memory _data) {
		if (
			IMPL_SLOT !=
			bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
		) revert ERC1967UpgradeUUPS__incorrectSlot();

		_upgradeToAndCallUUPS(_logic, _data, false);
	}

	function _getImplementation()
		internal
		view
		override(ERC1967Base, Proxy)
		returns (address)
	{
		return ERC1967Base._getImplementation();
	}
}
