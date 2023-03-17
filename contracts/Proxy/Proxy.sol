//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @title Default proxy with explanation
/// @author Vladimir Kumalagov
abstract contract Proxy {
	fallback() external payable {
		_delegate(_getImplementation());
	}

	receive() external payable {
		_delegate(_getImplementation());
	}

	function _delegate(address implementation) private {
		assembly {
			/**
			 * Calldatacopy: Copy input data in current environment to memory.
			 * ---
			 * Args:
			 * 1. destOffset: Place, where will be stored result.
			 * 2. offset: byte offset in the calldata to copy.
			 * 3. size: byte size to copy.
			 *
			 * ---
			 *
			 * calldatasize: Get size of input data in current environment.
			 */
			calldatacopy(0, 0, calldatasize())

			/**
			 * Delegatecall:
			 * Message-call into this account with an alternative account’s code,
			 * but persisting the current values for sender and value
			 * ---
			 * Args:
			 * 1. gas: amount of gas to send to the sub context to execute.
			 *    The gas that is not used by the sub context is returned to this one.
			 * 2. address: the account which code to execute.
			 * 3. argsOffset: byte offset in the memory in bytes, the calldata of the sub context.
			 * 4. argsSize: byte size to copy (size of the calldata).
			 * 5. retOffset: byte offset in the memory in bytes, where to store the return data of the sub context.
			 * 6. retSize: byte size to copy (size of the return data).
			 *
			 */
			let result := delegatecall(
				gas(),
				implementation,
				0,
				calldatasize(),
				0,
				0
			)

			/**
			 * returndatacopy: Copy output data from the previous call to memory
			 * ---
			 * Args:
			 * 1. destOffset: Place, where will be stored result.
			 * 2. offset: byte offset in the calldata to copy.
			 * 3. size: byte size to copy.
			 *
			 * ---
			 * returndatasize:
			 * Get size of output data from the previous call from the current environment
			 */
			returndatacopy(0, 0, returndatasize())

			// Check status of the delegatecall
			switch result
			// Delegatecall failed -> revert
			case 0 {
				revert(0, returndatasize())
			}
			// Delegatecall successful -> return call result
			default {
				return(0, returndatasize())
			}
		}
	}

	// Returns an address of the implementation
	// Implemented in <ERC1967UUPS>
	function _getImplementation() internal view virtual returns (address impl);
}
