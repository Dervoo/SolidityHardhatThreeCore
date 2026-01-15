import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("StakeModule", (m) => {

  const stake = m.contract("Stake");

  return { stake };
});