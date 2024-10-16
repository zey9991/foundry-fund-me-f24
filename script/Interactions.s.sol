//SPDX-L
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE};
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundFundMe(mostRecentDeployed);
    }
}

// 定义一个脚本合约 WithdrawFundMe，用于提取 FundMe 合约的资金
contract WithdrawFundMe is Script {
    // 定义一个公有函数 withdrawFundMe，接收一个合约地址（mostRecentlyDeployed），用于从 FundMe 提取资金
    function withdrawFundMe(address mostRecentlyDeployed) public {
        // 开始广播交易，将后续操作真正发送到链上
        vm.startBroadcast();

        // 调用传入地址的 FundMe 合约中的 withdraw 函数，提取合约中的资金
        FundMe(payable(mostRecentlyDeployed)).withdraw();

        // 停止广播，结束链上操作
        vm.stopBroadcast();

        // 打印提取成功的消息到控制台
        console.log("Withdraw FundMe balance!");
    }

    // 定义一个外部函数 run，用于获取最近部署的 FundMe 合约地址并执行 withdrawFundMe 函数
    function run() external {
        // 使用 DevOpsTools 工具，获取最近部署的 FundMe 合约地址（通过链 ID）
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe", // 要获取的合约名称
            block.chainid // 当前链的链 ID，确保找到正确链上部署的合约
        );

        // 调用 withdrawFundMe 函数，传入获取到的合约地址，执行资金提取操作
        withdrawFundMe(mostRecentDeployed); // 这里进行修改以自动获取最新的部署地址
    }
}
