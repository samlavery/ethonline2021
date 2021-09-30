#!/usr/bin/python3

from brownie import Token, accounts


def main():
    return Token.deploy("PI Token", "PIT", "meta", {'from': accounts[0]})
