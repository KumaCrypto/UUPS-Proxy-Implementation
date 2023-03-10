import {
	expect,
	createFixture,
	loadFixture,
	ContractType,
	ethers,
	BigNumber,
} from "./helper";

describe("UUPS_StorageSlot", function () {
	const fixture = createFixture(ContractType.UUPS_StorageSlotMock);

	it("ImplSlot number is correct", async function () {
		const { UUPS_StorageSlot } = await loadFixture(fixture);

		const contractSlotNumber =
			await UUPS_StorageSlot.getImplementationSlot();

		const digest = ethers.utils.solidityKeccak256(
			["string"],
			["eip1967.proxy.implementation"]
		);

		const slotNumber = BigNumber.from(digest).sub(1);
		expect(contractSlotNumber).eq(slotNumber);
	});

	it("Impl default value is zero", async function () {
		const { UUPS_StorageSlot } = await loadFixture(fixture);

		const implAddress = await UUPS_StorageSlot.getImplementation();
		expect(implAddress).eq(ethers.constants.AddressZero);
	});

	it("Wtite to impl slot set the value", async function () {
		const { UUPS_StorageSlot, owner: newImpl } = await loadFixture(fixture);

		await UUPS_StorageSlot.writeToImplementationSlot(newImpl.address);
		const implAddress = await UUPS_StorageSlot.getImplementation();

		expect(implAddress).eq(newImpl.address);
	});
});
