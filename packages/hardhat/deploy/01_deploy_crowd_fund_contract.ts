import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployCrowdFundContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy, get } = hre.deployments;

  const exampleExternalContract = await get("ExampleExternalContract");

  const thresholdETH = "1000000000000000000"; // 1 ETH in wei
  const deadline = Math.floor(Date.now() / 1000) + 3600; // 1 hour from now

  await deploy("CrowdFundContract", {
    from: deployer,
    args: [thresholdETH, deadline, exampleExternalContract.address],
    log: true,
    autoMine: true,
  });
};

export default deployCrowdFundContract;
deployCrowdFundContract.tags = ["CrowdFundContract"];
