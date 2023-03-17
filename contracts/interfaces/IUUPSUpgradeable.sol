//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IERC1822Proxiable} from "./IERC1822Proxiable.sol";
import {IUUPSUpgradeableErrors} from "./errors/IUUPSUpgradeableErrors.sol";

/// @title Interface for the UUPSUpgradeable proxy
interface IUUPSUpgradeable is IERC1822Proxiable, IUUPSUpgradeableErrors {
	function upgradeTo(address newImplementation) external;

	function upgradeToAndCall(
		address newImplementation,
		bytes memory data
	) external;
}
