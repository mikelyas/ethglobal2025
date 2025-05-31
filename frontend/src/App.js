import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';

// Contract configuration
const CONTRACT_ADDRESS = "<PASTE_SYNTH_MINTER_ADDRESS>";
const CONTRACT_ABI = [
  "function depositAndMint() external payable returns (uint256)",
  "function burnAndRedeem(uint256 amount) external returns (uint256)"
];

function App() {
  const [userAddress, setUserAddress] = useState(null);
  const [amountInEther, setAmountInEther] = useState('0.1');
  const [amountToBurn, setAmountToBurn] = useState('0');
  const [txStatus, setTxStatus] = useState('');

  useEffect(() => {
    if (!window.ethereum) {
      alert("Please install MetaMask");
    }
  }, []);

  const connectWallet = async () => {
    try {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      await provider.send("eth_requestAccounts", []);
      const signer = provider.getSigner();
      const address = await signer.getAddress();
      setUserAddress(address);
    } catch (error) {
      alert(error.message);
    }
  };

  return (
    <div style={{ padding: '20px' }}>
      {!userAddress ? (
        <button onClick={connectWallet}>Connect Wallet</button>
      ) : (
        <p>Connected: {userAddress}</p>
      )}
      
      <div style={{ marginTop: '20px' }}>
        <input
          type="text"
          value={amountInEther}
          onChange={(e) => setAmountInEther(e.target.value)}
          placeholder="Amount in ETH"
        />
        <button>Deposit & Mint</button>
      </div>

      <div style={{ marginTop: '20px' }}>
        <input
          type="text"
          value={amountToBurn}
          onChange={(e) => setAmountToBurn(e.target.value)}
          placeholder="Amount to burn"
        />
        <button>Burn & Redeem</button>
      </div>

      <div style={{ marginTop: '20px' }}>
        <button disabled title="Coming soon">Cross-Chain to RSK</button>
        <button disabled title="Coming soon">Mint on Flow</button>
        <button disabled title="Coming soon">Swap via 1inch</button>
        <button disabled title="Coming soon">Check Price (Pyth)</button>
        <button disabled title="Coming soon">Recover via Email</button>
        <button disabled title="Coming soon">Award Merits</button>
        <button disabled title="Coming soon">Placeholder #7</button>
      </div>

      {txStatus && (
        <div style={{ marginTop: '20px' }}>
          <p>Transaction Status: {txStatus}</p>
        </div>
      )}
    </div>
  );
}

export default App; 