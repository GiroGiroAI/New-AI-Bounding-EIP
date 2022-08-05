import pytest
import brownie
from eth_utils import to_wei, to_checksum_address
import json

zero = "0x0000000000000000000000000000000000000000"
nGiveaway = 300


@pytest.fixture(scope="module")
def character(Character, accounts):
    return accounts[0].deploy(Character)


@pytest.fixture(scope="module")
def weapon(Weapon, accounts):
    return accounts[0].deploy(Weapon)


@pytest.fixture(scope="module")
def soul(Soul, accounts):
    return accounts[0].deploy(Soul)


def test_character_mint(character, accounts):
    character.safeMint(accounts[1])


def test_weapon_mint(weapon, accounts):
    weapon.safeMint(accounts[1])


def test_soul_mint(soul, accounts):
    soul.safeMint(accounts[1])


def test_weapon_attach(weapon, character, accounts):
    weapon.attach(0, (character, 0), {"from": accounts[1]})


def test_weapon_transferFrom(weapon, character, accounts):
    with brownie.reverts("This token is attached to a master."):
        weapon.transferFrom(accounts[1], accounts[2], 0, {"from": accounts[1]})
    weapon.dettach(0, {"from": accounts[1]})
    weapon.transferFrom(accounts[1], accounts[2], 0, {"from": accounts[1]})


def test_soul_transferFrom(weapon, character, accounts):
    with brownie.reverts("This token is attached to a master."):
        weapon.transferFrom(accounts[1], accounts[2], 0, {"from": accounts[1]})
    weapon.dettach(0, {"from": accounts[1]})
    weapon.transferFrom(accounts[1], accounts[2], 0, {"from": accounts[1]})


def test_soul_attach(weapon, character, accounts):
    weapon.attach(0, (character, 0), {"from": accounts[1]})


def test_weapon_transferFrom(weapon, character, accounts):
    with brownie.reverts("This token is attached to a master."):
        weapon.transferFrom(accounts[1], accounts[2], 0, {"from": accounts[1]})
    weapon.dettach(0, {"from": accounts[1]})
    weapon.transferFrom(accounts[1], accounts[2], 0, {"from": accounts[1]})
