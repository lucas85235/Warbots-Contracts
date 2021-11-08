// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
// import "./Part.sol";

// contract Part {
    
//     enum PartsType {
//         HEAD,
//         BODY,
//         ARMSLEFT,
//         ARMSRIGHT,
//         LEGS
//     }

//     struct Attributes {
//         uint256 serial;
//         PartsType partType;
//     }

//     function totalSupply() external view returns (uint256) {}
//     function partsList(address from) public view returns (uint256[] memory) {}
//     function getPart(uint256 tokenID) public view returns (Attributes memory) {}
// }

contract Robot is ERC721, Ownable {

    using SafeMath for uint256;
    using Strings for string;

    struct Attributes {
        uint256 head;
        uint256 body;
        uint256 armsLeft;
        uint256 armsRight;
        uint256 legs;
    }

    Attributes[] private robots;
    mapping (address => uint256[]) private robotsInWallet;

    constructor() ERC721("Robot", "BOT") {
        mint(0, 0, 0, 0, 0);
    }

    function totalSupply() external view returns (uint256) {
        return robots.length;
    }

    function transferFrom(address from, address to, uint256 tokenId)
        public override {

        super.transferFrom(from, to, tokenId);

        uint256 element;

        for (uint256 i = 0; i < robotsInWallet[from].length; i++) {
            if (robotsInWallet[from][i] == tokenId) {
                element = i;
            }
        }

        removeInOrder(from, element);
        robotsInWallet[to].push(tokenId);
    }

    function mint(uint256 headID, uint256 bodyID, uint256 armsLeftID, uint256 armsRightID, uint256 legsID)
        public returns (bool) {

        uint256 newItemID = robots.length;

        robots.push(
            Attributes(headID, bodyID, armsLeftID, armsRightID, legsID)
        );

        _safeMint(msg.sender, newItemID);
        robotsInWallet[msg.sender].push(newItemID);

        return true;
    }

    function robotsList(address from) public view returns (uint256[] memory) {
        return robotsInWallet[from];
    }

    function getRobotParts(uint256 tokenID) public view returns (Attributes memory) {
        return robots[tokenID];
    }

    function removeInOrder(address sender, uint256 index) internal {

        for (uint256 i = index; i < robotsInWallet[sender].length - 1; i++) {
            robotsInWallet[sender][i] = robotsInWallet[sender][i + 1];
        }

        robotsInWallet[sender].pop();
    }

    function updateHead(uint256 tokenID, uint256 newHead) public {

        // receber uma part do mesmo tipo como parametro
        // vericar se essa parte e do mesmo propietario do sender
        // enviar a part de parametro para o endereço de queima

        require(ownerOf(tokenID) == msg.sender, "Not is owner of this nft!");
        robots[tokenID].head = newHead;
    }

    // separar peças do robor e mintar/devolver partes do mesmo

    // criar de mintar o nft que
    // receber partes como parametro
    // vericar se essas partes são do mesmo propietario do sender
    // enviar as partes para o endereço de queima

}
