pragma solidity ^0.7.0;

import "./ZombieBattle.sol";
import "./ERC721.sol";

contract ZombieOwnership is ZombieBattle, ERC721{
    using SafeMath for uint16;

    mapping (uint => address) zombieApprovals;

    function balanceOf(address _owner) override public view returns (uint256 _balance) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) override public view returns (address _owner) {
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        // 2. 替换成 SafeMath 的 `sub`
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) override public onlyOwnerOf(_tokenId){
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) override public onlyOwnerOf(_tokenId){
        zombieApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) override public {
        require(zombieApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }

}
