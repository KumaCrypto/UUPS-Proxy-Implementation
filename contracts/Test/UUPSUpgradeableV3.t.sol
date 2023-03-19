//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {UUPSUpgradeableTestV1} from "./UUPSUpgradeableV1.t.sol";

contract UUPSUpgradeableTestV3 is UUPSUpgradeableTestV1 {
	function getVersion() external pure override returns (uint256) {
		return 3;
	}
}
