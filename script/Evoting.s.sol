// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/Evoting.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        new Evoting();
        vm.stopBroadcast();
    }
}