import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployCrowdFund: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  await deploy("ExampleExternalContract", {
    from: deployer,
    args: [
      /* constructor args here */
    ],
    log: true,
    autoMine: true,
  });
};

export default deployCrowdFund;
deployCrowdFund.tags = ["ExampleExternalContract"];
