//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @title Error list for the <IUUPSUpgradeableErrors>
interface IUUPSUpgradeableErrors {
	error UUPSUpgradeable__notDelegateCall();
	error UUPSUpgradeable__notAnActiveProxy();
	error UUPSUpgradeable__onlySimpleCall();
}
