//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "./ZombieFactory.sol";

// Create KittyInterface here
interface KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {

    // Initialize kittyContract here using `ckAddress` from above
    KittyInterface kittyContract;

    modifier onlyOwnerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    function setKittyContractAddress(address _address) external onlyOwner{
        kittyContract = KittyInterface(_address);
    }

    //除 public 和 private 属性之外，Solidity 还使用了另外两个描述函数可见性的修饰词：internal（内部） 和 external（外部）。
    //internal 和 private 类似，不过， 如果某个合约继承自其父合约，这个合约即可以访问父合约中定义的“内部”函数。（嘿，这听起来正是我们想要的那样！）。
    //external 与public 类似，只不过这些函数只能在合约之外调用 - 它们不能被合约内的其他函数调用。稍后我们将讨论什么时候使用 external 和 public。
    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal onlyOwnerOf(_zombieId){
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie), "zombie must ready!");
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        if(uint(keccak256(abi.encode(_species))) == uint(keccak256(abi.encode("kitty")))) {
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + coolDownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return _zombie.readyTime <= block.timestamp;
    }
}
