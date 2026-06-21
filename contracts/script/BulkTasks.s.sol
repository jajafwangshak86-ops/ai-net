// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {TaskCoordinator} from "../src/TaskCoordinator.sol";
import {GuildPermissions} from "../src/GuildPermissions.sol";

/// @notice Requester wallet runs full cycles; coordinator signs hireAgent inline.
contract BulkTasks is Script {
    TaskCoordinator  constant TC    = TaskCoordinator(payable(0x2097796487bea53b00D1e6e2D3327D30bEf08E3E));
    address          constant AGENT = 0xA5EFE8954B68B95333f3aCE9e65039DC8235fD47;
    uint256          constant N     = 112;   // cycles per run → 336 tx per wallet

    function run() external {
        uint256 requesterKey   = vm.envUint("REQUESTER_KEY");
        uint256 coordinatorKey = vm.envUint("COORDINATOR_KEY");
        address requester      = vm.addr(requesterKey);

        for (uint256 i = 0; i < N; i++) {
            vm.broadcast(requesterKey);
            uint256 tid = TC.createTask{value: 0.01 ether}("AI-Net task", 1 days);

            vm.broadcast(coordinatorKey);
            TC.hireAgent(tid, AGENT);

            vm.broadcast(requesterKey);
            TC.completeTask(tid);
        }
        console.log("Completed cycles from wallet");
    }
}
