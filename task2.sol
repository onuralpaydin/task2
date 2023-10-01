 //SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Varlik {
    address public sahibi;
    string public adres;
    
    constructor(string memory _adres) {
        sahibi = msg.sender;
        adres = _adres;
    }
}
contract KiraYonetimi {
    struct Kiraci {
        address kiraciAdres;
        string kiraciBilgisi;
        bool kiraciDurumu;
    }
    
    struct KiraSozlesmesi {
        address sahibi;
        address kiraci;
        uint256 kiraBaslangicTarihi;
        uint256 kiraBitisTarihi;
    }
    
    mapping(address => Kiraci) public kiracilar;
    mapping(address => KiraSozlesmesi) public kiraSozlesmeleri;
    
    event KirayaVerildi(address indexed sahibi, address indexed kiraci, uint256 kiraBaslangicTarihi, uint256 kiraBitisTarihi);
    event KiradanCikarildi(address indexed sahibi, address indexed kiraci);

    function kiraYap(address _kiraci, address _varlikAdresi, uint256 _kiraBaslangicTarihi, uint256 _kiraBitisTarihi) external {
        Varlik varlik = Varlik(_varlikAdresi);
        require(msg.sender == varlik.sahibi(), "Yalnizca varlik sahibi kiraya verebilir.");
        require(!kiracilar[_kiraci].kiraciDurumu, "Kiraci zaten kirada.");
        
        kiracilar[_kiraci] = Kiraci(_kiraci, varlik.adres(), true);
        kiraSozlesmeleri[_kiraci] = KiraSozlesmesi(msg.sender, _kiraci, _kiraBaslangicTarihi, _kiraBitisTarihi);
        
        emit KirayaVerildi(msg.sender, _kiraci, _kiraBaslangicTarihi, _kiraBitisTarihi);
    }

    function kiraSonlandir(address _kiraci, address _varlikAdresi) external {
        Varlik varlik = Varlik(_varlikAdresi);
        require(msg.sender == varlik.sahibi(), "Yalnizca varlik sahibi kira sonlandirabilir.");
        require(kiraSozlesmeleri[_kiraci].sahibi == msg.sender, "Yalnizca kira sahibi kira sonlandirabilir.");
        
        delete kiracilar[_kiraci];
        delete kiraSozlesmeleri[_kiraci];
        
        emit KiradanCikarildi(msg.sender, _kiraci);
    }
}