# Early Ethereum contract sources

Source code for early Ethereum mainnet contracts, many of them claimed as early or first NFTs, each
checked against the code deployed on the chain. Where a project published verified source, it is copied
here unchanged. Where no source was ever published, the source was rebuilt from the deployed bytecode
until it compiled back to that bytecode.

[`manifest.json`](manifest.json) lists every contract with its file, compiler and settings, and
[`check.cjs`](check.cjs) compiles them all and compares the result with the chain (see
[How to check](#how-to-check)).

## What "match" means here

The compiled code is compared twice: with the code at the address (`eth_getCode`) and with the input of
the transaction that deployed it, which also contains the constructor.

- **IDENTICAL**: every byte is the same.
- **IDENTICAL except metadata hash**: from Solidity 0.4.7 on, the compiler appends a hash of a
  description of the compile, which includes the exact source text and file name. Everything else is
  byte for byte the same. For contracts whose original file text is unknown, this is the closest
  possible match; Sourcify calls it a partial match.

## Contents

| Project | Contract | Address | Deployed (UTC) | File | Source | Match |
|---|---|---|---|---|---|---|
| Terra Nullius | Terra Nullius | `0x6e38A457C722C6011B2dfa06d49240e797844d66` | 2015-08-07 20:48 | [`terra_nullius/TerraNullius_0x6e38a457.sol`](terra_nullius/TerraNullius_0x6e38a457.sol) | verified | identical |
| 69ers | ICAPRegistrar (first) | `0xc076CF70C54c698D4442Cde1561452564FA339A5` | 2015-08-07 23:31 | [`icap_registrar/ICAPRegistrar_0xc076cf70.sol`](icap_registrar/ICAPRegistrar_0xc076cf70.sol) | dapp-bin file, reordered | identical |
| 69ers | ICAPRegistrar (second) | `0xa1A111bc074c9cfa781F0C38e63bD51c91b8af00` | 2015-08-08 08:08 | [`icap_registrar/ICAPRegistrar_0xa1a111bc.sol`](icap_registrar/ICAPRegistrar_0xa1a111bc.sol) | dapp-bin file, reordered | identical |
| GlobalRegistrar | v0 (Linagee), v1, v6, v9, v13, v18 | see [below](#globalregistrar-including-the-linagee-copy) | 2015-08-08 to 2016-02-06 | [`global_registrar/`](global_registrar/) | geth 1.0's compiled registrar | identical |
| Documents | Documents | `0x5548e21695f8F5E4eDBcd8aBc2de0924c718dAcA` | 2015-08-12 15:20 | [`documents/Documents_0x5548e216.sol`](documents/Documents_0x5548e216.sol) | rebuilt | identical |
| Oracles | Oracles | `0xd5f5120d1fdfda5ef60fca1f81d709f0432738af` | 2015-08-24 17:35 | [`oracles/Oracles_0xd5f5120d.sol`](oracles/Oracles_0xd5f5120d.sol) | rebuilt | identical |
| Etherization | Etherization | `0xb40d0312BaC389AE0a05053020Aac80c9237358B` | 2016-09-16 11:33 | [`etherization/Etherization_0xb40d0312.sol`](etherization/Etherization_0xb40d0312.sol) | verified | identical |
| PixelMap | three tests | see [below](#pixelmap) | 2016-11-15, 2016-11-16 | [`pixelmap/PixelMap_tests.sol`](pixelmap/PixelMap_tests.sol) | rebuilt | identical |
| PixelMap | PixelMap | `0x015A06a433353f8db634dF4eDdF0C109882A15AB` | 2016-11-17 04:29 | [`pixelmap/PixelMap_0x015a06a4.sol`](pixelmap/PixelMap_0x015a06a4.sol) | verified | identical |
| PixelMap | wrapper (2021) | `0x050dc61dFB867E0fE3Cf2948362b6c0F3fAF790b` | 2021-08-26 20:07 | [`pixelmap/PixelMapWrapper_0x050dc61d/`](pixelmap/PixelMapWrapper_0x050dc61d/) | verified | identical |
| Peperium | test factory | `0xc1a542530b304060aeebc7d8808e927e5e673db7` | 2017-04-14 23:16 | [`peperium/CardTokenFactory_test_0xc1a54253.sol`](peperium/CardTokenFactory_test_0xc1a54253.sol) | rebuilt | except metadata hash |
| Peperium | Series 1 factory | `0xD875c876435A79b5EB2099D06Aa97FFd4fB6FC9d` | 2017-04-14 23:30 | [`peperium/CardTokenFactory_0xd875c876.sol`](peperium/CardTokenFactory_0xd875c876.sol) | verified (a decompilation) | except metadata hash |
| Peperium | card KFPEPE | `0x648445e48093d999966375b30186D433fEF9c364` | 2017-04-14 23:34 | [`peperium/CardToken_0x648445e4.sol`](peperium/CardToken_0x648445e4.sol) | verified | except metadata hash |
| Peperium | Series 2 factory | `0xB4e34890034a13325363b3226DCE8EeEc292D626` | 2017-08-27 14:32 | [`peperium/CardTokenFactory2_0xb4e34890.sol`](peperium/CardTokenFactory2_0xb4e34890.sol) | verified (a decompilation) | except metadata hash |
| Curio Cards | test factory | `0x7605faFE3261438F60defb98F110602E8Cfa45ed` | 2017-05-09 01:24 | [`curio_cards/CardFactory_test_0x7605fafe.sol`](curio_cards/CardFactory_test_0x7605fafe.sol) | rebuilt | except metadata hash |
| Curio Cards | card factory | `0x37AAb22019448859fc255e6E353A1baF2c05E6Bb` | 2017-05-09 17:18 | [`curio_cards/CardToken_0x6aa2044c.sol`](curio_cards/CardToken_0x6aa2044c.sol) | verified | except metadata hash |
| Curio Cards | card 1 | `0x6Aa2044C7A0f9e2758EdAE97247B03a0D7e73d6c` | 2017-05-09 17:22 | [`curio_cards/CardToken_0x6aa2044c.sol`](curio_cards/CardToken_0x6aa2044c.sol) | verified | except metadata hash |
| CryptoPunks | v1 | `0x6Ba6f2207e343923BA692e5Cae646Fb0F566DB8D` | 2017-06-09 00:22 | [`cryptopunks/CryptoPunks_0x6ba6f220.sol`](cryptopunks/CryptoPunks_0x6ba6f220.sol) | verified | except metadata hash |
| CryptoPunks | v2 | `0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB` | 2017-06-22 19:40 | [`cryptopunks/CryptoPunksMarket_0xb47e3cd8.sol`](cryptopunks/CryptoPunksMarket_0xb47e3cd8.sol) | verified | except metadata hash |
| MoonCatRescue | MoonCatRescue | `0x60cd862c9C687A9dE49aecdC3A99b74A4fc54aB6` | 2017-08-09 04:36 | [`mooncatrescue/MoonCatRescue_0x60cd862c.sol`](mooncatrescue/MoonCatRescue_0x60cd862c.sol) | verified, one character restored | except metadata hash |
| CryptoCats | two tests | see [below](#cryptocats) | 2017-11-11 | [`cryptocats/CryptoCatsMarket_tests.sol`](cryptocats/CryptoCatsMarket_tests.sol) | rebuilt | except metadata hash |
| CryptoCats | v0 | `0xC4AA7a486c054E6F277712C7D82DB1A3A1DBE758` | 2017-11-12 08:12 | [`cryptocats/CryptoCatsMarket_0xc4aa7a48.sol`](cryptocats/CryptoCatsMarket_0xc4aa7a48.sol) | verified | except metadata hash |
| CryptoCats | v1 | `0xa185B9E63FB83A5a1A13A4460B8E8605672b6020` | 2017-11-25 11:01 | [`cryptocats/CryptoCatsMarket_0xa185b9e6.sol`](cryptocats/CryptoCatsMarket_0xa185b9e6.sol) | rebuilt | except metadata hash |
| CryptoCats | v2, first deployment | `0x62bFCB95D90ba722C8714F5774c623Bee20BF4fF` | 2017-12-19 14:13 | [`cryptocats/CryptoCatsMarket_0x62bfcb95.sol`](cryptocats/CryptoCatsMarket_0x62bfcb95.sol) | rebuilt | except metadata hash |
| CryptoCats | v2 | `0x9508008227b6b3391959334604677d60169EF540` | 2017-12-19 15:48 | [`cryptocats/CryptoCatsMarket_0x95080082.sol`](cryptocats/CryptoCatsMarket_0x95080082.sol) | rebuilt | except metadata hash |
| CryptoCats | v3, replaced | `0x19c320b43744254ebdBcb1F1BD0e2a3dc08E01dc` | 2017-12-24 14:10 | [`cryptocats/CryptoCatsMarket_0x19c320b4.sol`](cryptocats/CryptoCatsMarket_0x19c320b4.sol) | verified | except metadata hash |
| CryptoCats | v3 | `0x088C6Ad962812b5Aa905BA6F3c5c145f9D4C079f` | 2017-12-24 14:10 | [`cryptocats/CryptoCatsMarket_0x088c6ad9.sol`](cryptocats/CryptoCatsMarket_0x088c6ad9.sol) | verified | except metadata hash |
| CryptoCats | wrapper (2021) | `0xd0e7Bc3F1EFc5f098534Bce73589835b8273b9a0` | 2021-03-14 17:38 | [`cryptocats/WrappedCryptoCat_0xd0e7bc3f.sol`](cryptocats/WrappedCryptoCat_0xd0e7bc3f.sol) | verified | except metadata hash |
| CryptoKitties | KittyCore | `0x06012c8cf97BEaD5deAe237070F9587f8E7A266d` | 2017-11-23 05:41 | [`cryptokitties/KittyCore_0x06012c8c.sol`](cryptokitties/KittyCore_0x06012c8c.sol) | verified | except metadata hash |

"Verified" means the source is published for that address by Etherscan, and in most cases Sourcify
too. It is copied here byte for byte, from Sourcify or, for Terra Nullius and the Peperium Series 1
factory, from Etherscan, except for one character in MoonCatRescue (see below). "Rebuilt" means no
source was ever published, and the file was written from the bytecode. Every file that is not a
verified copy starts with a comment saying how it was made.

**Do not edit, reformat or re-save the `.sol` files.** Compilers this old can give different output for
a different file text, even if only a comment changed. The repository's `.gitattributes` stops git from
converting their line endings.

## Notes by project

### Terra Nullius

The file is Etherscan's verified copy, Windows line endings included. Compiled with Solidity 0.1.1 and
the optimizer off, it reproduces the deployed code and the deployment input byte for byte.

### The 69er contracts: ICAPRegistrar

Both come from `registrar/ICAPRegistrar.sol` in ethereum/dapp-bin, added by Marek Kotewicz on 6 Aug 2015
(commit e9f5df99d49ccfb334e3bf121c02d6201649fe83), a cut-down copy of Gavin Wood's FixedFeeRegistrar with
`bytes32` names and a 69-ether fee. It was the registry for ICAP, a proposed IBAN-style address format
for Ethereum. The second contract was hard-coded into web3.js as its ICAP registry 72 minutes after it
was deployed (commit 3373b8f, 8 Aug 2015) and stayed there through web3.js 0.20.7.

- The second contract is the dapp-bin file with `transfer()` placed before `disown()`.
- The first is the same file without `addr()` and `owner()`, with `setAddr()` placed second.

Solidity 0.1.x compiled function bodies in the order of their syntax-tree nodes' memory addresses,
which decides which of two identical blocks of code the optimizer keeps. Compiled unchanged, the
dapp-bin file gives code of the same length that differs only in some jump targets; the function
orders used here reproduce the deployed code. These two files are dapp-bin code, used under its MIT
License ([`icap_registrar/LICENSE-dapp-bin.txt`](icap_registrar/LICENSE-dapp-bin.txt)).

### GlobalRegistrar (including the Linagee copy)

The six copies below have exactly the same code, which is the runtime part of `GlobalRegistrarCode`, the
precompiled registrar that geth 1.0.0 to 1.1.x carried in `common/registrar/contracts.go`. In those
releases `admin.setGlobalRegistrar("", sender)` deployed that binary whenever no registrar address was
set, which is why identical copies came from different senders.

| Copy | Address | Deployed (UTC) |
|---|---|---|
| v0, now called the Linagee Name Registrar | `0x5564886ca2C518d1964E5FCea4f423b41Db9F561` | 2015-08-08 05:20 |
| v1 | `0x2272D8d4dEc7DF90a36f03EFF778DECc6918F1A9` | 2015-08-10 10:31 |
| v6 | `0x822964bF8402477833837c86Ccff926c169bA550` | 2015-08-30 09:09 |
| v9, hard-coded into geth as its Frontier registrar | `0x33990122638b9132cA29c723BDF037F1a891a70C` | 2015-09-24 11:06 |
| v13 | `0xb829C107E7BeEdF9D97694860E99eFa66fD2eD3a` | 2015-09-24 22:56 |
| v18 | `0x07408Af8Ca23Cdd4Fc7C09d47AA91bbe5A308525` | 2016-02-06 19:29 |

[`global_registrar/`](global_registrar/) holds the binary as geth 1.0.1 shipped it and the source geth
shipped next to it, `GlobalRegistrarSrc`, both copied unchanged from
https://github.com/ethereum/go-ethereum/blob/v1.0.1/common/registrar/contracts.go under geth's LGPL-3.0
license. The binary has no `6060604052` memory setup, which every archived Solidity build emits (the
oldest is 0.1.1, August 2015), so it came from an older compiler and cannot be recompiled from the source
with any archived build. The check compares the binary itself with the chain.

### Documents and Oracles

No source for either has been found in public repositories, code searches or on Etherscan. Function,
public variable and event names are stored in the bytecode as hashes, so those names are the original
ones; `hardSet(uint16)` and `setWinningOutcome(uint32)` in Oracles are in no signature database and
were found by testing candidate names against their selectors. Parameter and local variable names, and
Documents' internal function, are guesses that do not affect the bytecode.

- **Documents** registers 32-byte document hashes. `newDocument` gives an unused hash to the caller and
  `transferDocument` lets only its current holder pass it on. The only privileged function, `empty`,
  sends the contract's ether to its deployer.
- **Oracles** has three seats, each transferable only by its holder. Each seat reports one value once,
  and `getWinningOutcome` maps the value two seats agree on to an outcome from 1 to 10,001; without
  agreement it returns a fallback that anyone could set with `hardSet` after 1 Nov 2015.

### PixelMap

The three tests have the same code:
`0x1C733BE4D204c628546257Cb090639463FA54881` (2016-11-15 20:58),
`0x406D4d30dE0C7c11499aDA85a3DC50c735B6dd60` (2016-11-15 21:03) and
`0xf22670f012e4D71Dc01f3ae24b2e88f4A4f90a70` (2016-11-16 23:15). Their source is the verified PixelMap
source with two changes: `buyTile` pays the price to the buyer instead of to the seller or creator, and
has no `else` branch. They were compiled with Solidity 0.4.4 and the optimizer off; PixelMap itself with
0.4.2 and the optimizer on.

### Peperium

The verified sources Etherscan and Sourcify publish for the Series 1 and Series 2 factories are both
decompilations made by luna, not the original files, and no original source for either is known. Both
factories' constructors set `RareCount` to 1, so it reads one more than the number of cards created.
The test factory was rebuilt for this repository from the verified KFPEPE card source and a factory in
the pattern of Curio Cards' published `CardFactory`; it is the Series 1 factory without the line that
increments `RareCount`. All 22 cards the Series 1 factory created have the same code as KFPEPE.

### Curio Cards

Etherscan's verified source for the card factory and Sourcify's for card 1 are the same file, which
contains both contracts. The test factory, deployed 16 hours earlier from a different address, is
the same file except that its constructor sets `CardCount` to 1 instead of 0. All 58 cards the card
factory has created so far have the same code as card 1.

### MoonCatRescue

Sourcify's copy of the source has `"?"` where the deployed contract stores the cat emoji 🐱 as its
`symbol`; the character was lost in an encoding conversion. The copy here has the emoji back, which
makes the deployment input match as well.

### CryptoCats

Only v0, the two v3 deployments and the wrapper have published source. The others were rebuilt from it:

- **The two tests** (`0xD23AdE68C693264Aa9e8f8303F912A3E54718456`, 2017-11-11 04:58, optimizer on;
  `0x78eEa094E1D30141CCAde64F8D29a7BFcC921F9E`, 2017-11-11 11:15, optimizer off) are v0 with the image
  hash "INSERT ACTUAL HASH HERE" and the names "CryptoCTest", "CRYPTOCTEST" and "CRT".
- **v1** started with 12 cats copied from v0 by an internal function its constructor called, and added
  a market with offers and CryptoPunks-style bids. Five of its function names were found by testing
  candidate names against their selectors. Its `buyCat` requires an offer's `sellOnlyTo` to be the buyer,
  so only offers made to a specific address could be bought.
- **v2** is v3 without v3's bug fix: `getCat` takes payment but never credits it to `pendingWithdrawals`,
  so ETH paid for claims cannot be withdrawn. The first v2 deployment registers its releases inside
  `migrateCatOwnersFromPreviousContract` rather than in the constructor.

## How to check

You need [Node.js](https://nodejs.org) 18 or later, a copy of this repository and the URL of an Ethereum
JSON-RPC endpoint. From this folder:

```
node check.cjs https://eth.blockscout.com/api/eth-rpc --download
```

`--download` fetches the compilers the manifest names from https://binaries.soliditylang.org/bin/ into
`compilers/`, and keeps each only if its SHA-256 matches the one published in that site's `list.json`.
The script compiles every file in a fresh process and prints, for each address, how the compiled code
compares with the deployed code and with the deployment transaction. Add addresses after the URL to
check only those. Node may print an `Invalid asm.js` warning, which is harmless.

Many nodes no longer serve transactions from 2015 to 2017; when a node doesn't, the script says so and
still checks the deployed code. Blockscout's public endpoint, used above, serves them but limits how fast
it answers, so a full run takes several minutes.

## Licenses

The rebuilt sources, `check.cjs`, `manifest.json` and this README are under the MIT License
([`LICENSE`](LICENSE)). The verified sources belong to their authors and are copied from their public
verification records. The ICAPRegistrar files are dapp-bin code under its MIT License, the
GlobalRegistrar files are geth code under the LGPL-3.0, and the CryptoCats sources carry their authors'
MIT notice.

## Elsewhere: Etheria

Etheria v0.9, v1.0, v1.1 and v1.2, and the four test versions that survive from before v0.9, have source
verified on Etherscan. Their sources and compile recipes are in
https://github.com/cyrusadkisson/etheria_source.
