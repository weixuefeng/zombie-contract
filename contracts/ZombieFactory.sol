//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;
import "hardhat/console.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

contract ZombieFactory is Ownable{

    using SafeMath for uint256;
    // 1. 为 uint32 声明 使用 SafeMath32
    using SafeMath32 for uint32;
    // 2. 为 uint16 声明 使用 SafeMath16
    using SafeMath16 for uint16;

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint index = 1;
    uint coolDownTime = 1 days;

    struct Zombie {
        string name;
        uint dna;
        // 节省 gas
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    // zombie mapper
    mapping(uint => address) public zombieToOwner;
    // zombie account
    mapping(address => uint) ownerZombieCount;

    event NewZombie(uint zombieId, string name, uint dna);

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) internal {
        // arrays.push()
        zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + coolDownTime), 0, 0));
        emit NewZombie(index, _name, _dna);
        zombieToOwner[index] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        index++;
    }

    // view, 只读取合约里面的变量，不修改
    // pure, 纯函数，不读取合约里面的变量，返回值只与输入参数有关
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encode(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "Every address can only create one zombie!");
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
