// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {TaskCoordinator} from "../src/TaskCoordinator.sol";

/// @notice Creates a task, hires 3 agents, completes it — generates onchain activity.
contract DemoTask is Script {
    TaskCoordinator constant COORDINATOR = TaskCoordinator(payable(0x2097796487bea53b00D1e6e2D3327D30bEf08E3E));

    // The single agent registered (deployer wallet)
    address constant AGENT = 0xA5EFE8954B68B95333f3aCE9e65039DC8235fD47;

    function run() external {
        vm.startBroadcast();

        // Create task with 0.03 CELO budget (agent price is 0.01 ether × 3 capabilities registered)
        uint256 taskId = COORDINATOR.createTask{value: 0.05 ether}("AI-Net demo: market analysis", 1 days);
        console.log("Task created:", taskId);

        // Hire agent (pays 0.01 CELO via ERC-7710)
        COORDINATOR.hireAgent(taskId, AGENT);
        console.log("Agent hired");

        // Complete task — refunds unspent budget
        COORDINATOR.completeTask(taskId);
        console.log("Task completed");

        vm.stopBroadcast();
    }
}
