// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./AVALabToken.sol";


contract AVALabBridge is ReentrancyGuard {
	IERC20 public avalabV1;
	AVALabToken public avalabV2;
	address public burnAddress = 0xdEad000000000000000000000000000000000000;

	constructor(IERC20 _avalabV1, AVALabToken _avalabV2) public {
		avalabV1 = _avalabV1;
		avalabV2 = _avalabV2;
	}

	event Bridge(address indexed user, uint amount);

	function convert(uint256 _amount) public nonReentrant {
		require(msg.sender == tx.origin, "Must be called directly");

		bool success = false;

		success = avalabV1.transferFrom(msg.sender, burnAddress, _amount);

		require(success == true, 'transfer failed');

		avalabV2.bridgeMint(msg.sender, _amount);
		emit Bridge(msg.sender, _amount);
		
	}
}