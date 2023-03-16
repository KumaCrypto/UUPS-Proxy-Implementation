//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @title Proxiable ERC-1822 interface
interface IERC1822Proxiable {
	/// @dev Returns slot, in which is stored an implementation slot
	function proxiableUUID() external view returns (bytes32);
}
