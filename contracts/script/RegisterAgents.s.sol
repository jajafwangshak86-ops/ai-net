// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {AgentRegistry} from "../src/AgentRegistry.sol";

/// @notice Registers 5 agents from the deployer wallet using unique derived addresses as the wallet field.
contract RegisterAgents is Script {
    AgentRegistry constant REGISTRY = AgentRegistry(0x052f70C756B079F7eADB8b72C7Ea1579215090C8);

    function run() external {
        vm.startBroadcast();
        REGISTRY.register("https://api.venice.ai/api/v1", "research", 0.01 ether);
        REGISTRY.register("https://api.venice.ai/api/v1", "risk",     0.01 ether);
        REGISTRY.register("https://api.venice.ai/api/v1", "report",   0.01 ether);
        REGISTRY.register("https://api.venice.ai/api/v1", "coding",   0.02 ether);
        REGISTRY.register("https://api.venice.ai/api/v1", "design",   0.01 ether);
        console.log("Total agents:", REGISTRY.totalAgents());
        vm.stopBroadcast();
    }
}
