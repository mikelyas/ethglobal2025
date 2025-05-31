# ethglobal2025

graph TD
    subgraph Frontend
        WebUI[React.js Web Application]
        BlockscoutSDK[Blockscout SDK for Transaction Status]
    end

    subgraph Backend Off-chain Services
        PriceService[Pyth Hermes Service - Fetch Price Data]
        vlayerService[vlayer Off-chain Prover - Generate ZK Proofs]
    end

    subgraph Blockchain Infrastructure
        subgraph Rootstock_RSK
            DepositContract[RBTC Collateral Deposit Contract]
        end

        subgraph Ethereum
            SynthMintContract[Synthetic Asset Mint Contract]
            PriceOracleContract[Pyth Oracle Contract]
            SwapAggregatorContract[1inch Swap Aggregator Contract]
        end

        subgraph Flow_EVM
            SynthFlowContract[Synthetic Asset Contract on Flow]
            YieldStrategyContract[Yield Strategy Contracts]
        end

        LayerZero[LayerZero - Cross-chain Messaging Protocol]
        vlayerVerifier[vlayer On-chain Verifier Contract]
    end

    %% Frontend Interactions
    User[User] --> WebUI
    WebUI --> BlockscoutSDK
    WebUI --> DepositContract
    WebUI --> SynthMintContract
    WebUI --> SynthFlowContract
    WebUI --> SwapAggregatorContract

    %% Backend to Blockchain
    PriceService --> PriceOracleContract
    vlayerService --> vlayerVerifier

    %% Cross-chain interactions via LayerZero
    DepositContract --> LayerZero
    LayerZero --> SynthMintContract
    SynthMintContract <--> LayerZero
    LayerZero <--> SynthFlowContract

    %% Smart contract interactions
    SynthMintContract --> PriceOracleContract
    SynthMintContract --> SwapAggregatorContract
    SynthFlowContract --> YieldStrategyContract

    %% vlayer interactions
    SynthMintContract --> vlayerVerifier
    vlayerVerifier --> SynthMintContract
