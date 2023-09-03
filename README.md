# MooY'AA'Ho Contracts

## Prerequisites

- Node.js
- Yarn
- Foundry rs

## Build

```bash
$ forge build
```

## Deploy

```bash
$ forge script ./script/deploy.s.sol:Deployer --rpc-url ${RPC_URL} --broadcast
```

## Deployments

### [Goerli Testnet](./output/deployments-5.json)

```json
{
  "entrypoint": "0x493dA402fA45002E1E48C5b30e78A74eAe06209F",
  "factory": "0x05DAe891A3b5a249D260E033F371Cceedcd51e06",
  "stdAcc": "0xdc8a7af1A48214cD5074d21C0125a1aB0a1FaE2A",
  "thresholdStore": "0x200754bf8a56D786A2Ce1bA6F1a013aaDdC9bCd3",
  "verifier": "0x8A71A16CFB6030dB0124376ecE83bC241D020c43",
  "yaho": "0x145f142764389A842230aac87F27b1875EF13BB2"
}
```

### [Optimism Goerli Testnet](./output/deployments-420.json)

```json
{
  "entrypoint": "0x232c219e8e5d66cB205Ec8830490C58eCd61af4D",
  "factory": "0xce8F4b55ac2abC4fC99031528310458Dc0448D6D",
  "stdAcc": "0x2B1152A346D1b933E1F79fbf0Be2fe96EF7668f4",
  "thresholdStore": "0x55026FcCEfc306BE8873fC6D8AC2456a9619F4ED",
  "verifier": "0x7facCe44e6Be620af218A8d8fAc68785aCC72d46",
  "yaho": "0x1c7A1492d937d09C86211B403dD9A4204F1700eA"
}
```

### [Polygon L2 (zkEVM) Testnet](./output//deployments-1442.json)

```json
{
  "entrypoint": "0x232c219e8e5d66cB205Ec8830490C58eCd61af4D",
  "factory": "0xce8F4b55ac2abC4fC99031528310458Dc0448D6D",
  "stdAcc": "0x2B1152A346D1b933E1F79fbf0Be2fe96EF7668f4",
  "thresholdStore": "0x55026FcCEfc306BE8873fC6D8AC2456a9619F4ED",
  "verifier": "0x7facCe44e6Be620af218A8d8fAc68785aCC72d46",
  "yaho": "0x1c7A1492d937d09C86211B403dD9A4204F1700eA"
}
```

### [Taiko L2 (zkEVM) Testnet](./output/deployments-167005.json)

```json
{
  "entrypoint": "0x55026FcCEfc306BE8873fC6D8AC2456a9619F4ED",
  "factory": "0xc9498F5CE12B0Bf11F31374Ce8e6044C42A6705b",
  "stdAcc": "0xF6dDaF9f40F354EC90D8B8C735efE9A50DdceDC1",
  "thresholdStore": "0x7facCe44e6Be620af218A8d8fAc68785aCC72d46",
  "verifier": "0xce8F4b55ac2abC4fC99031528310458Dc0448D6D",
  "yaho": "0x232c219e8e5d66cB205Ec8830490C58eCd61af4D"
}
```

### [Linea L2 (zkEVM) Testnet](./output/deployments-59140.json)

```json
{
  "entrypoint": "0x232c219e8e5d66cB205Ec8830490C58eCd61af4D",
  "factory": "0xce8F4b55ac2abC4fC99031528310458Dc0448D6D",
  "stdAcc": "0x2B1152A346D1b933E1F79fbf0Be2fe96EF7668f4",
  "thresholdStore": "0x55026FcCEfc306BE8873fC6D8AC2456a9619F4ED",
  "verifier": "0x7facCe44e6Be620af218A8d8fAc68785aCC72d46",
  "yaho": "0x1c7A1492d937d09C86211B403dD9A4204F1700eA"
}
```
