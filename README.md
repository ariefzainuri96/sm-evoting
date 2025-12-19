## Evoting Smart Contract

== Deploy to Local machine ==

## Public Account

0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000.000000000000000000 ETH)  
0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (10000.000000000000000000 ETH)  
0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC (10000.000000000000000000 ETH)  
0x90F79bf6EB2c4f870365E785982E1f101E93b906 (10000.000000000000000000 ETH)  
0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65 (10000.000000000000000000 ETH)  
0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc (10000.000000000000000000 ETH)  
0x976EA74026E726554dB657fA54763abd0C3a0aa9 (10000.000000000000000000 ETH)  
0x14dC79964da2C08b23698B3D3cc7Ca32193d9955 (10000.000000000000000000 ETH)  
0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f (10000.000000000000000000 ETH)  
0xa0Ee7A142d267C1f36714E4a8F75612F20a79720 (10000.000000000000000000 ETH)  

## Private Keys

0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff800x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a60x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba0x92db14e403b83dfe3df233f83dfa3a0d7096f21ca9b0d6d6b8d88b2b4ec1564e0x4bbbf85ce3377467afe5d46f804f221813b2bb87f24d81f60f1fcdbf7cbf43560xdbda1821b80551c9d65939329250298aa3472ba22feea921c0cf5d620ea67b970x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6

FYI:

- to run `forge`, `anvil`, or `foundry` related command, use git-bash based terminal
- generate abi.json file `forge build --extra-output-files abi`
- look in folder `/out/Evoting.sol/Evoting.abi.json`
- copy generated `.abi.json` file to `evoting-subgraph/abis`
- remove this folder first `cd E:Backend/Graph/graph-node/docker/data` -> otherwise it will conflict the logs of event
- if anvil is not become one in `E:Backend/Graph/graph-node/docker/docker-compose.yaml`, then run step 1 first, otherwise skip to step 2

STEP:

1. start anvil use this command `anvil`
- verify anvil produce block `cast block-number --rpc-url http://127.0.0.1:8545`
2. start graph node docker
- cd E:Backend/Graph/graph-node/docker
- run this command `docker compose up`
3. deploy the contract
- --private-key will be the deployer (owner) -> get this from anvil
- `forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast`
4. update the evoting-subgraph/subgraph.yaml contract address after successfuly deploy the contract
- `address: "0xNEW_CONTRACT_ADDRESS"`
5. run below command to generate new build in subgraph:
- `graph codegen`
- `graph build`
- `graph create --node http://localhost:8020 default/evoting`
- `graph deploy --node http://localhost:8020 --ipfs http://localhost:5001 default/evoting`

Query for GraphQL:

{
  votes {
    id
    voter
    voteId
    timestamp
  }
}

6. Test the contract function
- `cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "vote()" --rpc-url http://127.0.0.1:8545 --private-key 0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba`
- `cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "updateVoteStatus(bool)" true --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`

======================== DEPLOY to Sepolia Testnet ==========================

FYI: topup development wallet account by use faucet web, eg: google web3 faucet

1. register to Alchemy `https://dashboard.alchemy.com/`
- save the Ethereum Sepolia URL to .env file -> SEPOLIA_RPC_URL
2. register to etherscan `https://etherscan.io/apidashboard`
- generate and save the API Key to .env file -> ETHERSCAN_API_KEY
3. Secure Key Management (Avoid Plaintext Keys)
- run this command `cast wallet import --interactive testnet_wallet` -> testnet_wallet is what you will call in forge script command
- you'll need to insert your wallet private_key address -> open metamask and get from your selected account don't forget to put `0x` before the key
4. Production Deployment Command (perform dry run test first)
- before run forge script command, run `source .env` first to export the env file to terminal session
- command for dry run test `forge script script/Evoting.s.sol --fork-url $SEPOLIA_RPC_URL --account testnet_wallet --sender $ETH_PUBLIC_ADDRESS -vvvv`
- command for Sepolia Testnet Broadcast `forge script script/Evoting.s.sol --rpc-url $SEPOLIA_RPC_URL --account testnet_wallet --sender $ETH_PUBLIC_ADDRESS --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvvv`
5. Update the Subgraph for Production
- cd subgraph/subgraph.yaml -> update the generated address from step 4
- update the network: sepolia
- update the startBlock: 9870270 -> this is blockNumber value from step 4
- run this command `graph codegen` & `graph build`
- if in local development we run `graph create` & `graph deploy` we don't use it in Production
- instead we use Subgraph Studio `https://thegraph.com/studio/subgraph/evoting-sepolia/endpoints`
- Create the Subgraph Online
  - Go to Subgraph Studio.
  - Connect your MetaMask.
  - Click "Create a Subgraph".
  - Name it (e.g., evoting-sepolia) and select Sepolia as the network.
  - Follow the instruction to auth and push deploy to Subgraph Studio
6. Test contract function
- don't forget to run `source .env` to load env file
- to create/update data `cast send $CONTRACT_ADDRESS "updateVoteStatus(bool)" true --account testnet_wallet --rpc-url $SEPOLIA_RPC_URL`
- to read data `cast call $CONTRACT_ADDRESS "functionName(type1,type2)" arg1 arg2 --rpc-url $SEPOLIA_RPC_URL`