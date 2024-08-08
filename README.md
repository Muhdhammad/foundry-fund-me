# Getting Started

## About 

__Fund Me__ is a smart contract built on Foundry and Solidity. This contract allows anyone to contribute funds directly to it. It provides a straightforward and secure way to collect donations or support for various purposes by interacting with the Ethereum blockchain.

## Requirements
[git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git): 
You should have git installed on your PC, you can check the git version by running `git --version` and if is showing some version like `git version x.x.x`, then you have installed it correctly.

[foundry](https://getfoundry.sh/):
You should have foundry installed, you can check by running the `forge --version`, if you see something like this `forge 0.2.0 (f2518c9 2024-08-06T00:18:13.943817879Z)` then you have done it correctly.

## Usage
### Deployment

```
forge script script/DeployFundMe.s.sol
```
### Testing

This project consists of (03) tests to ensure its functionality.
1. Unit
2. Integration
3. Forked

```
forge test
```
You can also,
```
// Only run test functions matching the specified regex pattern.

forge test --match-test testFunctionName
```

or
```
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage
```
forge coverage
```

## Deployment to testnet or mainnet
1. Setup environment variables

You'll have to set up your `$SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables in a `.env file` 

* `$PRIVATE_KEY`: The private key of you account (example from [Metamask](https://metamask.io/)) __SERIOUS NOTE:__ For Development purpose, always use a key that does'nt have any real funds in it.
* `$SEPOLIA_RPC_URL`: This is url of the sepolia testnet node you're working with, you can choose any free node as a service provider like [Alchemy](https://www.alchemy.com/).
* Optionally, add you `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).


2. Get testnet ETH 
 
Go to [faucets.chain.link](https://faucets.chain.link/) or any other faucet to get testnet ETH, you should see ETH appear in you wallet.

3. Deploy

```
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```
You can also make its key in a `makefile` to access it easily instead of writing down all of this in the terminal.


## Scripts

After deploying to a testnet or local net, you can run the scripts.

Deploying locally using cast
```
cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>
```
or
```
forge script script/Interactions.s.sol:Fund_FundMe --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
forge script script/Interactions.s.sol:Withdraw_FundMe --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
```

## Withdraw
```
cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()" --private-key <PRIVATE_KEY>
```

## Gas Estimation
You can estimate how much gas different things cost by running
```
forge snapshot
```
You'll see any output file called `.gas-snapshot`

## Additional Note

Best practice to use your `$PRIVATE_KEY` is to encode it and then use it, you should never hard copy paste your private key with the real funds in the `.env` file.

# Thanks!
Thank you for staying engaged with this project, if you appreciated this, feel free to follow!


