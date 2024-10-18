// create a variable to hold your NFTs
let nfts = [];

// this function will take in some values as parameters, create an
// NFT object using the parameters passed to it for its metadata, 
// and store it in the variable above.
function mintNFT(name, description, owner) {
    const nft = {
        name: name,
        description: description,
        owner: owner
    };
    nfts.push(nft);
}

// create a "loop" that will go through an "array" of NFTs
// and print their metadata with console.log()
function listNFTs() {
    nfts.forEach(nft => {
        console.log(`Name: ${nft.name}, Description: ${nft.description}, Owner: ${nft.owner}`);
    });
}

// print the total number of NFTs we have minted to the console
function getTotalSupply() {
    return nfts.length;
}

// call your functions below this line
mintNFT("NFT1", "First NFT", "Alice");
mintNFT("NFT2", "Second NFT", "Bob");

listNFTs();
console.log("Total Supply: " + getTotalSupply());