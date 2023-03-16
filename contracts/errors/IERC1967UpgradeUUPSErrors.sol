//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @title Error list for the <ERC1967UpgradeUUPS>
interface IERC1967UpgradeUUPSErrors {
	error ERC1967UpgradeUUPS__incorrectSlot();
	error ERC1967UpgradeUUPS__newImplementationIsNotUUPS();
	error ERC1967UpgradeUUPS__unsupportedProxiableUUID(bytes32 slotNumber);
}
