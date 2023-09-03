import {
  SimpleSmartContractAccount,
  SmartAccountProvider,
  type SimpleSmartAccountOwner,
  LocalAccountSigner,
} from "@alchemy/aa-core";
import { foundry } from "viem/chains";
import { Hex } from "viem";

import deployments from "../output/deployments.json";

const KEY_USER = process.env.KEY_USER;
if (!KEY_USER) {
  throw new Error("KEY_USER env var is required");
}

// 1. define the EOA owner of the Smart Account
// this uses a utility method for creating an account signer using mnemonic
// we also have a utility for creating an account signer from a private key
const owner: SimpleSmartAccountOwner =
  LocalAccountSigner.privateKeyToAccountSigner(KEY_USER as Hex);

// 2. initialize the provider and connect it to the account
const provider = new SmartAccountProvider(
  "http://0.0.0.0:14337/1337", // rpcUrl
  deployments.entrypoint as Hex, // entryPointAddress
  foundry // chain
).connect(
  (rpcClient) =>
    new SimpleSmartContractAccount({
      entryPointAddress: deployments.entrypoint as Hex,
      chain: foundry,
      factoryAddress: deployments.factory as Hex,
      rpcClient,
      owner,
      // optionally if you already know the account's address
      accountAddress: deployments.stdAcc as Hex,
    })
);

async function main() {
  console.log(JSON.stringify(deployments, null, 2));

  // 3. send a UserOperation
  const { hash } = await provider.sendUserOperation({
    target: deployments.yaho as Hex,
    data: `0x`,
  });

  console.log("hash", hash);
}

main().catch(console.error);
