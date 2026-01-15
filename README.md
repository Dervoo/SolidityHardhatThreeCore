# Sample Hardhat 3 Beta Project (`node:test` and `viem`)

This project showcases a Hardhat 3 Beta project using the native Node.js test runner (`node:test`) and the `viem` library for Ethereum interactions.

To learn more about the Hardhat 3 Beta, please visit the [Getting Started guide](https://hardhat.org/docs/getting-started#getting-started-with-hardhat-3). To share your feedback, join our [Hardhat 3 Beta](https://hardhat.org/hardhat3-beta-telegram-group) Telegram group or [open an issue](https://github.com/NomicFoundation/hardhat/issues/new) in our GitHub issue tracker.

## Project Overview

This example project includes:

- A simple Hardhat configuration file.
- Foundry-compatible Solidity unit tests.
- TypeScript integration tests using [`node:test`](nodejs.org/api/test.html), the new Node.js native test runner, and [`viem`](https://viem.sh/).
- Examples demonstrating how to connect to different types of networks, including locally simulating OP mainnet.

## Usage

### Running Tests

To run all the tests in the project, execute the following command:

```shell
npx hardhat test
```

You can also selectively run the Solidity or `node:test` tests:

```shell
npx hardhat test solidity
npx hardhat test nodejs
```

### Make a deployment to Sepolia

This project includes an example Ignition module to deploy the contract. You can deploy this module to a locally simulated chain or to Sepolia.

To run the deployment to a local chain:

```shell
npx hardhat ignition deploy ignition/modules/Counter.ts
```

To run the deployment to Sepolia, you need an account with funds to send the transaction. The provided Hardhat configuration includes a Configuration Variable called `SEPOLIA_PRIVATE_KEY`, which you can use to set the private key of the account you want to use.

You can set the `SEPOLIA_PRIVATE_KEY` variable using the `hardhat-keystore` plugin or by setting it as an environment variable.

To set the `SEPOLIA_PRIVATE_KEY` config variable using `hardhat-keystore`:

```shell
npx hardhat keystore set SEPOLIA_PRIVATE_KEY
```

After setting the variable, you can run the deployment with the Sepolia network:

```shell
npx hardhat ignition deploy --network sepolia ignition/modules/Counter.ts
```


vm list: (do testowania w t.sol)

vm.expectRevert() – oczekuje, że następna operacja się cofnie (revert).

vm.expectRevert(bytes("reason")) – oczekuje konkretnego komunikatu revertu.

vm.expectEmit(bool checkTopic1, bool checkTopic2, bool checkTopic3, bool checkData) – przygotowuje test do sprawdzenia emitowanego eventu.

vm.recordLogs() / vm.getRecordedLogs() – nagrywa eventy i pozwala je analizować później

vm.warp(uint256 timestamp) – ustawia czas bloku (symulacja przyszłości).

vm.roll(uint256 blockNumber) – zmienia numer aktualnego bloku.

vm.fee(uint256 baseFee) – ustawia bazową opłatę gas dla bloku.

vm.prank(address) – sprawia, że następna transakcja wygląda jakby była od danego adresu.

vm.startPrank(address) / vm.stopPrank() – dłuższa wersja pranku, dla wielu wywołań.

vm.deal(address, uint256 amount) – ustawia saldo ETH dla adresu.

vm.label(address, "Name") – nadaje etykietę adresowi (dla czytelności w logach).

vm.mockCall(address, bytes calldata, bytes calldata returnData) – symuluje odpowiedź wywołania do innego kontraktu.

vm.etch(address, bytes code) – nadpisuje kod kontraktu w danym adresie.

vm.store(address, bytes32 slot, bytes32 value) – ustawia wartość w storage kontraktu (slot pamięci).

vm.load(address, bytes32 slot) – odczytuje wartość ze storage kontraktu.

vm.chainId() – ustawia ID sieci.

vm.broadcast() – wysyła transakcję z klucza prywatnego (np. do deploy/testnet).

vm.assume(bool condition) – do fuzzingu, aby ograniczyć zakres testów.

vm.recordLogs() i vm.getRecordedLogs() – nagrywanie i odczyt logów/eventów.

vm.expectCall(address, bytes calldata) – sprawdza, czy dany kontrakt zostanie wywołany z określonymi danymi.