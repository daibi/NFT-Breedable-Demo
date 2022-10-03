# NFT-Breedable-Demo

## 1 Overview

This is a repository for an NFT collection with basic breeding ability. It will allow two different and no-related NFT elements combine with each other to generate a new descendant NFT, and this new NFT can inherit parents' gene while can have a relatively small chance to mutate some parts of it.

To fulfill some randomness in the inheritance, we need to figure out a way that two freely chosen parents' gene series(NFT's Metadata), combine with each other and sometimes with mutation, but still make sure that the gene result in their child still make sense in the NFT metadata set. To make this happen in a fairly low cost, we choose the following features as metadata:

* Hex code color
* the Eight Trigrams(which can combine with each other to make different "signs")

## 2 Overall System Design
### 2.1 Module Structure

![NFT Breedable Module Structure](https://github.com/daibi/NFT-Breedable-Demo/blob/main/pics/module_structure.png?raw=true)

### 2.2 Sequence Diagrams
Absolutely, we cannot have all calculations on chain because of the cost for on-chain activities. Therefore, we need to seperate some of functionalities to front-end. Below are sequence diagrams, which will provide a walk through the follwing functionalities:

* NFT front-end page render
* Gene 0 NFT minting
* NFT breeding

💡 **Red words** are steps that need further illustration, and we will have a further discussion in the following chapters

#### 2.2.1 NFT front-end page render

![Frontend page render](https://raw.githubusercontent.com/daibi/NFT-Breedable-Demo/fddbc9dcc23aa92b715b12a7f79aa58174e014c2/pics/NFT_front_end_page_render.svg)

#### 2.2.2 Gene 0 NFT Minting

![Gene 0 Minting](https://raw.githubusercontent.com/daibi/NFT-Breedable-Demo/d5623ff04eb25b6480dd07d18c82caf42cf8831d/pics/gene0_Minting.svg)

#### 2.2.3 NFT Breeding

![NFT breeding](https://raw.githubusercontent.com/daibi/NFT-Breedable-Demo/8974dab6868f3f63e1c4580f596b03db34c7fd50/pics/NFT_breeding.svg)

## 3 Detailed Process Demostration
### 3.1 Elements for Picture

For this project, I had a hard time to figure out a representation of gene that can freely combine with each other while still make sense in its metadata set. Fortunately, I found the following elements that may fit with the situation. They are: 

* A png formatted legendary creature: Baihu
* Hex code color for this png file: Hex code color is a six-hex-code representation of color, which can combine on the byte level to generate new color representation
* Eight Trigrams：Of course there are eight basic signs. Our ancestors have expanded the system to 64 high-level signs to represent different situations for mankind's life. Following  picture demostrates a possible combination of basic signs, and we will use the expanded signs as part of gene series.

![bagua combination](https://github.com/daibi/NFT-Breedable-Demo/blob/main/pics/bagua_combination.png?raw=true)

Here, we will use its basic element -- "bar" to make combination and mutation happen. When parents' are breeding, we will need to choose child's bar from parents' bar on the same position. Below illustrates a possible gene selection for child's sign (red bar means it being chosin in child's gene series, green means mutation happens at this position during the breeding process):

![bagua combination2](https://github.com/daibi/NFT-Breedable-Demo/blob/main/pics/bagua_combination2.png?raw=true)

💡 We have a bonus feature here. Those signs also represents a basic element in China's ancient mindset, called Wuxing, which includes "Metal", "Wood", "Water", "Fire", "Earth". They have a cycle for reinforcement and counteraction, a potential metadata for Gamefi applications.

### 3.2 Gene 0 NFT Minting Prerequisites

Gene 0 NFT Minting process need to check the following prerequisities: 
* Minting switch status is open or not
* (Potentail): check if minting address is in whitelist

### 3.3 Gene 0 NFT metadata generation

Gene 0 NFT metadata is a randomly generated gene series, which depends on the random generated from chainlink. The "real" minting process happens in the callback function listening to successful random number generation in chainlink.

For Gene 0 NFT, two parts of metadata need to be genearted from the random number result (Denoted as R):

* Hex code color: Hex code color code has six hex digits, each digit is generated via the following process:
  * First:  R mod 16
  * Second: (R  + 2 * First)  mod 16
  * Third: First - 0x2
  * Fourth: (R  - 2 * Third)  mod 16
  * Fifth: (R  + Fourth)  mod 16
  * Sixth:  (R  + 3 * Fifth)  mod 16
* Eight Trigrams sign generation: a "sign" is composed with 6 "bars", and a "bar" has two variations, which can be viewed as a binary representation. Therefore, we will use the binary representation of the random number and pick last 6 bit as the result of "sign" generation.

### 3.4 NFT  breeding: combine parents' gene series

As for the breeding process, we need to consider two parts of gene combination, the color and the "Eight Trigrams sign"; and the beautiful part: mutation.

During NFT breeding, we will use each hex digit of generated random number to act as a flag that if mutation happen in this part. Below is the digit position that decides if certain mutation happens:

Say if we have received a random number from Chainlink, we employ the following digit to determine the mutation phenomena:

![mutation control](https://github.com/daibi/NFT-Breedable-Demo/blob/main/pics/mutation_control.png?raw=true)
