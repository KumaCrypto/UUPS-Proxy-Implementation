import {
	ProxyFixtureFactory,
	expect,
	loadFixture,
	ethers,
	SignerWithAddress,
} from "./helper";

import {
	UUPSUpgradeableTest__factory,
	UUPSUpgradeableTest,
} from "../typechain-types";

import { ContractFactory, Contract } from "ethers";

describe("Check upgradeability", function () {
	let owner: SignerWithAddress,
		anotherUser: SignerWithAddress,
		signers: SignerWithAddress[];

	let implFactory: ContractFactory;
	let proxyFixture: () => Promise<Contract>;

	before(async function () {
		[owner, anotherUser, ...signers] = await ethers.getSigners();
		implFactory = new UUPSUpgradeableTest__factory(owner);

		const proxyFixtureFactory = new ProxyFixtureFactory(owner, implFactory);
		proxyFixture =
			proxyFixtureFactory.deployWithProxy.bind(proxyFixtureFactory);
	});

	it("Delegatecall returns value", async function () {
		const contract = (await loadFixture(
			proxyFixture
		)) as UUPSUpgradeableTest;

		const version = await contract.getVersion();
		expect(version).eq(1);
	});

	it("Proxy | Re-initialize must be reverted", async function () {
		const contract = (await loadFixture(
			proxyFixture
		)) as UUPSUpgradeableTest;

		await expect(contract.initialize()).revertedWith(
			"Initializable: contract is already initialized"
		);
	});

	it("Implementation | Re-initialize must be reverted", async function () {
		const contract = (await loadFixture(
			proxyFixture
		)) as UUPSUpgradeableTest;

		const implAddress = await contract.getImplementation();
		const implementation = implFactory.attach(implAddress);

		await expect(implementation.initialize()).revertedWith(
			"Initializable: contract is already initialized"
		);
	});
});
