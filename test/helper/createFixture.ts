import { UUPS_StorageSlotMock__factory } from "../../typechain-types";

import { ethers } from "./libs";

enum ContractType {
	UUPS_StorageSlotMock,
}

function createFixture(type: ContractType) {
	let fixture;

	if (type === ContractType.UUPS_StorageSlotMock) {
		fixture = async function () {
			const [owner, user, ...signers] = await ethers.getSigners();

			const factory = new UUPS_StorageSlotMock__factory(owner);
			const UUPS_StorageSlot = await factory.deploy();

			return { UUPS_StorageSlot, owner, user, signers };
		};
	} else throw new Error("Contract type is not correct!");

	return fixture!;
}

export { ContractType, createFixture };
