import {
	ProxyManager,
	expect,
	loadFixture,
	ethers,
	SignerWithAddress,
} from "./helper";

import {
	UUPSUpgradeableTestV1__factory,
	UUPSUpgradeableTestV1,
	UUPSUpgradeableTestV2__factory,
	UUPSUpgradeableTestV3__factory,
} from "../typechain-types";

import { ContractFactory, Contract } from "ethers";

describe("Check upgradeability", function () {
	let owner: SignerWithAddress,
		anotherUser: SignerWithAddress,
		signers: SignerWithAddress[];

	let implFactory: ContractFactory;
	let proxyFixture: () => Promise<Contract>, proxyManager: ProxyManager;

	before(async function () {
		[owner, anotherUser, ...signers] = await ethers.getSigners();
		implFactory = new UUPSUpgradeableTestV1__factory(owner);

		proxyManager = new ProxyManager(owner, implFactory);
		proxyFixture = proxyManager.deployWithProxy.bind(proxyManager);
	});

	it("Delegatecall returns value", async function () {
		const contract = (await loadFixture(
			proxyFixture
		)) as UUPSUpgradeableTestV1;

		const version = await contract.getVersion();
		expect(version).eq(1);
	});

	it("Proxy | Re-initialize must be reverted", async function () {
		const contract = (await loadFixture(
			proxyFixture
		)) as UUPSUpgradeableTestV1;

		await expect(contract.initialize()).revertedWith(
			"Initializable: contract is already initialized"
		);
	});

	it("Implementation | Re-initialize must be reverted", async function () {
		const contract = (await loadFixture(
			proxyFixture
		)) as UUPSUpgradeableTestV1;

		const implAddress = await contract.getImplementation();
		const implementation = implFactory.attach(implAddress);

		await expect(implementation.initialize()).revertedWith(
			"Initializable: contract is already initialized"
		);
	});

	it("Contract can be upgraded", async function () {
		const contract = (await loadFixture(
			proxyFixture
		)) as UUPSUpgradeableTestV1;

		await proxyManager.upgradeContract(
			new UUPSUpgradeableTestV2__factory(owner)
		);

		const version = await contract.getVersion();
		expect(version).eq(2);
	});

	it("Contract can be upgraded from the new version", async function () {
		const contract = (await loadFixture(
			proxyFixture
		)) as UUPSUpgradeableTestV1;

		await proxyManager.upgradeContract(
			new UUPSUpgradeableTestV2__factory(owner)
		);

		await proxyManager.upgradeContract(
			new UUPSUpgradeableTestV3__factory(owner)
		);

		const version = await contract.getVersion();
		expect(version).eq(3);
	});
});
