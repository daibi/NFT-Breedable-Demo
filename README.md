# NFT-Breedable-Demo

## DEMO

https://user-images.githubusercontent.com/110514575/208557332-122b1346-3edc-4021-bbe3-1462e0bc2de4.mp4


## 0 Get Started

Prerequisites: 
* npm
* Ganache, truffle
* pinata 

### 0.1 Set up a local blockchain environment

After you have set up your local blockchain environment, `cd` into the `truffle-project` repository and run the following instructions:

```bash
npm install
truffle compile
truffle migrate
```

Then, you will see a smart contract called `EightTrigramCore` deployed in your local blockchain environment.

### 0.2 Prepare front-end `.env.local` file

This project is based on nextJS and has some config variable from the `.env.local` file(not exist in this repository). Therefore, to run this demo locally, you need the following variables config in your local-created `.env.local` file(sits in `./web3-next-demo/.env.local`): 

```
// Contract address
CONTRACT_ADDRESS 
// api key used for pinata(ipfs server) picture saving
PINATA_API_KEY
// api secret used for pinata picture saving
PINATA_API_SECRET
// net address for your local blockchain environment
BLOCKCHAIN_NET_ADDRESS

// Contract address used for front-end
NEXT_PUBLIC_CONTRACT_ADDRESS
```


## 1 Overview

This is a repository for an NFT collection with basic breeding ability. It will allow two different and no-related NFT elements combine with each other to generate a new descendant NFT, and this new NFT can inherit parents' gene while can have a relatively small chance to mutate some parts of it.

To fulfill some randomness in the inheritance, we need to figure out a way two freely choose parents' gene series(NFT's Metadata), combining with each other and sometimes with some mutation; but still make sure that the gene result on their child still makes sense in the NFT metadata set. To make this happen in a fairly low cost, we choose the following features as metadata:

* Hex code color in a limited palette(To make sure that color selections are suitable)

* the Eight Trigrams(which can combine with each other to make different "signs")

* the Eight Trigrams, each NFT has the following features:

    * Each NFT has eight positions waiting for 'lighting up'

    * Gene-0 NFT is inited with one position lighted up with a randomly-generated Chinese-zodiac sitting in the central of picture

    * To light up a new position, it is highly recommended to find another NFT with the desired position lighted, but a mutation is possible during the breeding process.

Below is an example of how those NFTs looks like:

![NFT breedable demo](https://github.com/daibi/NFT-Breedable-Demo/blob/demo-init/pics/NFTbreeding.png?raw=true)

## 2 Overall System Design
### 2.1 Module Structure

### 2.1.1 original Version
![NFT Breedable Module Structure](https://github.com/daibi/NFT-Breedable-Demo/blob/main/pics/module_structure.png?raw=true)

### 2.1.2 New Version

![NFT Breedable Module Sturcture New Version](https://github.com/daibi/NFT-Breedable-Demo/blob/demo-init/pics/NFT_breedable_new_module_structure.png?raw=true)

### 2.1.3 Differences

In the new version, we introduce a NodeJs back-end server to solve computational and translating tasks and reassign some "READ" methods to backend to relieve front-end's computational overhead. 

Therefore, back-end server is now in charge of the following features:

* Read smart-contracts state via certain parametes. (i.e: address, NFT tokenId)

* Generate image via the random number input, and save the generated image to pinata ipfs server

And for the front-end, it only focuses on the "WRITE" method on smart contract, while interact with back-end to retrieve data for presentation.


### 2.2 Sequence Diagrams
Absolutely, we cannot have all calculations on chain because of the cost for on-chain activities. Therefore, we need to seperate some of functionalities to front-end. Below are sequence diagrams, which will provide a walk through the follwing functionalities:

* NFT front-end page render

* Gene 0 NFT minting

* NFT breeding


#### 2.2.1 NFT front-end page render

![Frontend page render](https://github.com/daibi/NFT-Breedable-Demo/blob/demo-init/pics/NFT_front_end_page_render.png?raw=true)

**Edit note:** In the former version, we chose to generate the image via Canvas in the front-end page. For the concern of front-end performance, we have moved this part to backend and generate picture based on the metada provided and save it to ipfs server with a url representation of this image instead. 

#### 2.2.2 Gene 0 NFT Minting

![Gene 0 Minting](https://github.com/daibi/NFT-Breedable-Demo/blob/demo-init/pics/gene0_NFT_minting.png?raw=true)

#### 2.2.3 NFT Breeding

![NFT breeding](https://github.com/daibi/NFT-Breedable-Demo/blob/demo-init/pics/NFT_breeding.png?raw=true)

## 3 Detailed Process Demostration
### 3.1 Elements for Picture

For this project, I had a hard time to figure out a representation of gene that can freely combine with each other while still make sense in its metadata set. Fortunately, I found the following elements that may fit with the situation. They are: 

* A png - formatted Chinese Zodiac with an eight-trigram surrounded:
* A hex code color palette for lighting up each "trigram sign": 
  * Hex code color is a six-hex-code representation of color, which can combine on the byte level to generate new color representation
* Eight Trigrams：Of course there are eight basic signs. Our ancestors have expanded the system to 64 high-level signs to represent different situations for mankind's life. 

Below is an example of a gene-0 NFT, with seven signs not lighted and one sign being lighted up with gradually changing color: 

![gene0 NFT](https://github.com/daibi/NFT-Breedable-Demo/blob/demo-init/pics/gene0NFT.png?raw=true)

### 3.2 Gene 0 NFT Minting Prerequisites

Gene 0 NFT Minting process need to check the following prerequisities: 
* Minting switch status is open or not
* check if minting address is in whitelist

### 3.3 Gene 0 NFT metadata generation

Gene 0 NFT metadata is a randomly generated gene series, which depends on the random number generated from chainlink. 

NOTE: For easier implementation, we use random number generated at front-end and use the random number from chainlink in further iterations.

For Gene 0 NFT, two parts of metadata need to be genearted from the random number result (Denoted as R):

* Based on the given eight-trigram picture, each trigram has fixed position. Therefore, the trigram sign generated by the input random number has a fixed place to "light up". And we need to light up the position with gradually changing colors.

* Eight Trigrams sign generation: a "sign" is composed with 6 "bars", and a "bar" has two variations, which can be viewed as a binary representation. Therefore, we will use the binary representation of the random number and pick last 6 bit as the result of "sign" generation.

* Hex code "from" color: Hex code color code has six hex digits, we use a size-6 color palette to select a color for lighting up :

* Hex code "to" color: same as the from color based on the random number rightly shifted by 3 digit

```javascript
const colorPalette = [
  'FEAFDC',
  'C5C6FE',
  'FED0B6',
  'FAE97A',
  '83FFC0',
  '80B1FE',
]
const colorGeneGeneratedFrom = colorPalette[randomNumber % 6]
let colorGeneGeneratedTo = colorPalette[Math.abs(randomNumber >> 3) % 6]
// if from-color and to-color are the same, change the to-color
if (colorGeneGeneratedFrom === colorGeneGeneratedTo) {
 	colorGeneGeneratedTo = colorPalette[((randomNumber % 6) + 3) % 6]
}
```

### 3.4 NFT breeding: combine parents' gene series

As for the breeding process, we need to consider two parts of gene combination, the color and the "Eight Trigrams sign"; and the beautiful part: mutation.

During NFT breeding, we choose the two NFT that the current address has operational priviledge. And use mother's NFT metadata as a "base", and check if father's lighted position has not been lighted on mothers' metadata, which has a decreasing chance (starting from 50%) of being inherited on their child's metadata. 

We have mentioned how two NFTs are combined, and we will post it here again to have a favor of how this breeding happens.


![mutation control](https://github.com/daibi/NFT-Breedable-Demo/blob/demo-init/pics/NFTbreeding.png?raw=true)
