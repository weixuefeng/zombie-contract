pragma solidity ^0.7.0;

import "./ZombieHelper.sol";

contract ZombieBattle is ZombieHelper {
    using SafeMath for uint256;
    using SafeMath for uint16;
    using SafeMath for uint32;

    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns (uint) {
        randNonce = randNonce.add(1);
        return uint(keccak256(abi.encode(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId){
        // 2. 在这里开始定义函数
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);
        if(rand <= attackVictoryProbability) {
            myZombie.winCount = myZombie.winCount.add(uint16(1));
            myZombie.level = myZombie.level.add(uint32(1));
            enemyZombie.lossCount = enemyZombie.lossCount.add(uint16(1));
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
            _triggerCooldown(myZombie);
        }
    }
}
