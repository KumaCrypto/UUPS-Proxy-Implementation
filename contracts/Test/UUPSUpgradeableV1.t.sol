//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "../UUPSUpgradeable.sol";

contract UUPSUpgradeableTestV1 is UUPSUpgradeable, OwnableUpgradeable {
	function initialize() external initializer {
		__Ownable_init();
	}

	function getVersion() external pure virtual returns (uint256) {
		return 1;
	}

	function getImplementation() external view returns (address) {
		return _getImplementation();
	}

	function _authorizeUpgrade(
		address newImplementation
	) internal virtual override onlyOwner {}
}
