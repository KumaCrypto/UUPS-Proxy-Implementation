//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "../UUPSUpgradeable.sol";

contract UUPSUpgradeableTest is
	Initializable,
	UUPSUpgradeable,
	OwnableUpgradeable
{
	function initialize() external initializer {
		__Ownable_init();
	}

	function getVersion() external pure returns (uint256) {
		return 1;
	}

	function _authorizeUpgrade(
		address newImplementation
	) internal virtual override onlyOwner {}
}
