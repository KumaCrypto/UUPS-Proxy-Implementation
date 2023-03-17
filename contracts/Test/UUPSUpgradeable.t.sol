//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "../UUPSUpgradeable.sol";

contract UUPSUpgradeableTest is UUPSUpgradeable, OwnableUpgradeable {
	function getVersion() external pure returns (uint256) {
		return 1;
	}

	function initialize() external {
		__Ownable_init();
	}

	function _authorizeUpgrade(
		address newImplementation
	) internal virtual override onlyOwner {}
}
