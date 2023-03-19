import { ERC1967Proxy__factory } from "../../typechain-types";

import { ContractFactory, Contract } from "ethers";
import { SignerWithAddress } from "./libs";

import { Interface } from "@ethersproject/abi/src.ts/interface";
import { FunctionFragment } from "@ethersproject/abi/src.ts/fragments";

export class ProxyManager {
	private deployer: SignerWithAddress;

	private impl: Contract | null;
	private proxy: Contract | null;
	private implFactory: ContractFactory;

	private initializerArgs: Array<any>;
	private nonStandartInitializer: string | null;

	constructor(
		_deployer: SignerWithAddress,
		_implFactory: ContractFactory,
		_initializerArgs?: any[],
		_nonStandartInitializer?: string
	) {
		this.proxy = null;
		this.impl = null;

		this.deployer = _deployer;
		this.implFactory = _implFactory;

		this.initializerArgs = _initializerArgs ?? [];
		this.nonStandartInitializer = _nonStandartInitializer ?? null;
	}

	async deployWithProxy() {
		if (!this?.implFactory) {
			throw new Error("Factory of the implementation isn't specified");
		}

		const impl = await this.implFactory.deploy();
		const proxyFactory = new ERC1967Proxy__factory(this.deployer);

		const initializerCalldata = this.getInitializerData(
			this.implFactory.interface,
			this.initializerArgs,
			this.nonStandartInitializer
		);

		let proxy = await proxyFactory.deploy(
			impl.address,
			initializerCalldata
		);

		this.proxy = this.implFactory.attach(proxy.address);

		return this.proxy;
	}

	async upgradeContract(newImplFactory: ContractFactory) {
		if (!this.proxy)
			throw new Error("Unable to upgrade contract - proxy does't exist");

		this.implFactory = newImplFactory;
		this.impl = await this.implFactory.deploy();

		await this.proxy.upgradeTo(this.impl.address);

		return this.proxy;
	}

	getInitializerData(
		_interface: Interface,
		_args?: any[],
		_nonStandartInitializer?: string | null
	): string {
		if (!_args) _args = [];
		const initializerName = _nonStandartInitializer ?? "initialize";

		let initializerFragment: FunctionFragment;

		try {
			initializerFragment = _interface.getFunction(initializerName);
		} catch (e: any) {
			console.warn(`Contract does't has initializer OR Error: ${e}`);
			return "";
		}

		const argsAmount = initializerFragment.inputs.length;

		if (argsAmount !== _args.length) {
			throw new Error(
				`Given amount of args does not match with initializer args amount.\nGiven: ${_args.length}, required: ${argsAmount}`
			);
		}

		return _interface.encodeFunctionData(initializerFragment, _args);
	}
}
