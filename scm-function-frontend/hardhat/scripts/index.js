// pages/index.js
import { useState, useEffect } from "react";
import { ethers } from "ethers";
import saiTokABI from "../artifacts/contracts/SaiTok.sol/SaiTok.json";

export default function HomePage() {
    const [ethWallet, setEthWallet] = useState(undefined);
    const [account, setAccount] = useState(undefined);
    const [saiTok, setSaiTok] = useState(undefined);
    const [balance, setBalance] = useState(0);
    const contractAddress = "0x38cB7800C3Fddb8dda074C1c650A155154924C73";

    const getWallet = async () => {
        if (window.ethereum) {
            setEthWallet(window.ethereum);
        }
    };

    const connectAccount = async () => {
        if (!ethWallet) {
            alert('MetaMask wallet is required to connect');
            return;
        }
        const accounts = await ethWallet.request({ method: 'eth_requestAccounts' });
        setAccount(accounts[0]);
        getSaiTokContract();
    };

    const getSaiTokContract = () => {
        const provider = new ethers.providers.Web3Provider(ethWallet);
        const signer = provider.getSigner();
        const saiTokContract = new ethers.Contract(contractAddress, saiTokABI.abi, signer);
        setSaiTok(saiTokContract);
    };

    const getBalance = async () => {
        if (saiTok && account) {
            const balance = await saiTok.accountBalance(account); // Use accountBalance mapping
            setBalance(balance.toString());
        }
    };

    const mintTokens = async (amount) => {
        if (saiTok) {
            const tx = await saiTok.createTokens(account, amount); // Call createTokens
            await tx.wait();
            getBalance();
        }
    };

    const burnTokens = async (amount) => {
        if (saiTok) {
            const tx = await saiTok.destroyTokens(account, amount); // Call destroyTokens
            await tx.wait();
            getBalance();
        }
    };

    useEffect(() => {
        getWallet();
    }, []);

    useEffect(() => {
        if (account) {
            getBalance();
        }
    }, [account, saiTok]);

    return (
        <main>
            <h1>SaiTok Token Dashboard</h1>
            {account ? (
                <div>
                    <p>Account: {account}</p>
                    <p>Balance: {balance}</p>
                    <button onClick={() => mintTokens(100)}>Mint 100 SAI</button>
                    <button onClick={() => burnTokens(50)}>Burn 50 SAI</button>
                </div>
            ) : (
                <button onClick={connectAccount}>Connect MetaMask</button>
            )}
        </main>
    );
}