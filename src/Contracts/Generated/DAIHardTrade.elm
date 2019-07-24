module Contracts.Generated.DAIHardTrade exposing
    ( Committed
    , GetParameters
    , GetPhaseStartInfo
    , GetState
    , Initiated
    , InitiatorStatementLog
    , ResponderStatementLog
    , abort
    , abortPunishment
    , abortedEvent
    , autoabortAvailable
    , autoabortInterval
    , autorecallAvailable
    , autorecallInterval
    , autoreleaseAvailable
    , autoreleaseInterval
    , beneficiary
    , beneficiaryDeposit
    , burn
    , burnedEvent
    , claim
    , claimedEvent
    , closedReason
    , commit
    , committedDecoder
    , committedEvent
    , custodian
    , daiContract
    , devFee
    , devFeeAddress
    , founderFee
    , founderFeeAddress
    , getBalance
    , getParameters
    , getParametersDecoder
    , getPhaseStartInfo
    , getPhaseStartInfoDecoder
    , getResponderDeposit
    , getState
    , getStateDecoder
    , initiatedDecoder
    , initiatedEvent
    , initiator
    , initiatorStatement
    , initiatorStatementLogDecoder
    , initiatorStatementLogEvent
    , phase
    , phaseStartBlocknums
    , phaseStartTimestamps
    , poke
    , pokeEvent
    , pokeNeeded
    , pokeReward
    , pokeRewardGranted
    , recall
    , recalledEvent
    , release
    , releasedEvent
    , responder
    , responderStatement
    , responderStatementLogDecoder
    , responderStatementLogEvent
    , tradeAmount
    )

import Abi.Decode as AbiDecode exposing (abiDecode, andMap, data, toElmDecoder, topic)
import Abi.Encode as AbiEncode exposing (Encoding(..), abiEncode)
import BigInt exposing (BigInt)
import Eth.Types exposing (..)
import Eth.Utils as U
import Json.Decode as Decode exposing (Decoder, succeed)
import Json.Decode.Pipeline exposing (custom)



{-

   This file was generated by https://github.com/cmditch/elm-ethereum-generator

-}


{-| "abort()" function
-}
abort : Address -> Call ()
abort contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "abort()" []
    , nonce = Nothing
    , decoder = Decode.succeed ()
    }


{-| "abortPunishment()" function
-}
abortPunishment : Address -> Call BigInt
abortPunishment contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "abortPunishment()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "autoabortAvailable()" function
-}
autoabortAvailable : Address -> Call Bool
autoabortAvailable contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "autoabortAvailable()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.bool
    }


{-| "autoabortInterval()" function
-}
autoabortInterval : Address -> Call BigInt
autoabortInterval contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "autoabortInterval()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "autorecallAvailable()" function
-}
autorecallAvailable : Address -> Call Bool
autorecallAvailable contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "autorecallAvailable()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.bool
    }


{-| "autorecallInterval()" function
-}
autorecallInterval : Address -> Call BigInt
autorecallInterval contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "autorecallInterval()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "autoreleaseAvailable()" function
-}
autoreleaseAvailable : Address -> Call Bool
autoreleaseAvailable contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "autoreleaseAvailable()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.bool
    }


{-| "autoreleaseInterval()" function
-}
autoreleaseInterval : Address -> Call BigInt
autoreleaseInterval contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "autoreleaseInterval()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "beneficiary()" function
-}
beneficiary : Address -> Call Address
beneficiary contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "beneficiary()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.address
    }


{-| "beneficiaryDeposit()" function
-}
beneficiaryDeposit : Address -> Call BigInt
beneficiaryDeposit contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "beneficiaryDeposit()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "burn()" function
-}
burn : Address -> Call ()
burn contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "burn()" []
    , nonce = Nothing
    , decoder = Decode.succeed ()
    }


{-| "claim()" function
-}
claim : Address -> Call ()
claim contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "claim()" []
    , nonce = Nothing
    , decoder = Decode.succeed ()
    }


{-| "closedReason()" function
-}
closedReason : Address -> Call BigInt
closedReason contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "closedReason()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "commit(address,string)" function
-}
commit : Address -> Address -> String -> Call ()
commit contractAddress responder_ commPubkey =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "commit(address,string)" [ AbiEncode.address responder_, AbiEncode.string commPubkey ]
    , nonce = Nothing
    , decoder = Decode.succeed ()
    }


{-| "custodian()" function
-}
custodian : Address -> Call Address
custodian contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "custodian()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.address
    }


{-| "daiContract()" function
-}
daiContract : Address -> Call Address
daiContract contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "daiContract()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.address
    }


{-| "devFee()" function
-}
devFee : Address -> Call BigInt
devFee contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "devFee()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "devFeeAddress()" function
-}
devFeeAddress : Address -> Call Address
devFeeAddress contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "devFeeAddress()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.address
    }


{-| "founderFee()" function
-}
founderFee : Address -> Call BigInt
founderFee contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "founderFee()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "founderFeeAddress()" function
-}
founderFeeAddress : Address -> Call Address
founderFeeAddress contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "founderFeeAddress()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.address
    }


{-| "getBalance()" function
-}
getBalance : Address -> Call BigInt
getBalance contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "getBalance()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "getParameters()" function
-}
type alias GetParameters =
    { initiator : Address
    , initiatedByCustodian : Bool
    , tradeAmount : BigInt
    , beneficiaryDeposit : BigInt
    , abortPunishment : BigInt
    , autorecallInterval : BigInt
    , autoabortInterval : BigInt
    , autoreleaseInterval : BigInt
    , pokeReward : BigInt
    }


getParameters : Address -> Call GetParameters
getParameters contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "getParameters()" []
    , nonce = Nothing
    , decoder = getParametersDecoder
    }


getParametersDecoder : Decoder GetParameters
getParametersDecoder =
    abiDecode GetParameters
        |> andMap AbiDecode.address
        |> andMap AbiDecode.bool
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> toElmDecoder


{-| "getPhaseStartInfo()" function
-}
type alias GetPhaseStartInfo =
    { v0 : BigInt
    , v1 : BigInt
    , v2 : BigInt
    , v3 : BigInt
    , v4 : BigInt
    , v5 : BigInt
    , v6 : BigInt
    , v7 : BigInt
    , v8 : BigInt
    , v9 : BigInt
    }


getPhaseStartInfo : Address -> Call GetPhaseStartInfo
getPhaseStartInfo contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "getPhaseStartInfo()" []
    , nonce = Nothing
    , decoder = getPhaseStartInfoDecoder
    }


getPhaseStartInfoDecoder : Decoder GetPhaseStartInfo
getPhaseStartInfoDecoder =
    abiDecode GetPhaseStartInfo
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> toElmDecoder


{-| "getResponderDeposit()" function
-}
getResponderDeposit : Address -> Call BigInt
getResponderDeposit contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "getResponderDeposit()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "getState()" function
-}
type alias GetState =
    { balance : BigInt
    , phase : BigInt
    , phaseStartTimestamp : BigInt
    , responder : Address
    , closedReason : BigInt
    }


getState : Address -> Call GetState
getState contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "getState()" []
    , nonce = Nothing
    , decoder = getStateDecoder
    }


getStateDecoder : Decoder GetState
getStateDecoder =
    abiDecode GetState
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.uint
        |> andMap AbiDecode.address
        |> andMap AbiDecode.uint
        |> toElmDecoder


{-| "initiatedByCustodian()" function
-}
initiatedByCustodian : Address -> Call Bool
initiatedByCustodian contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "initiatedByCustodian()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.bool
    }


{-| "initiator()" function
-}
initiator : Address -> Call Address
initiator contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "initiator()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.address
    }


{-| "initiatorStatement(string)" function
-}
initiatorStatement : Address -> String -> Call ()
initiatorStatement contractAddress statement =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "initiatorStatement(string)" [ AbiEncode.string statement ]
    , nonce = Nothing
    , decoder = Decode.succeed ()
    }


{-| "phase()" function
-}
phase : Address -> Call BigInt
phase contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "phase()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "phaseStartBlocknums(uint256)" function
-}
phaseStartBlocknums : Address -> BigInt -> Call BigInt
phaseStartBlocknums contractAddress a =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "phaseStartBlocknums(uint256)" [ AbiEncode.uint a ]
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "phaseStartTimestamps(uint256)" function
-}
phaseStartTimestamps : Address -> BigInt -> Call BigInt
phaseStartTimestamps contractAddress a =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "phaseStartTimestamps(uint256)" [ AbiEncode.uint a ]
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "poke()" function
-}
poke : Address -> Call Bool
poke contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "poke()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.bool
    }


{-| "pokeNeeded()" function
-}
pokeNeeded : Address -> Call Bool
pokeNeeded contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "pokeNeeded()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.bool
    }


{-| "pokeReward()" function
-}
pokeReward : Address -> Call BigInt
pokeReward contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "pokeReward()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "pokeRewardGranted()" function
-}
pokeRewardGranted : Address -> Call Bool
pokeRewardGranted contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "pokeRewardGranted()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.bool
    }


{-| "recall()" function
-}
recall : Address -> Call ()
recall contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "recall()" []
    , nonce = Nothing
    , decoder = Decode.succeed ()
    }


{-| "release()" function
-}
release : Address -> Call ()
release contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "release()" []
    , nonce = Nothing
    , decoder = Decode.succeed ()
    }


{-| "responder()" function
-}
responder : Address -> Call Address
responder contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "responder()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.address
    }


{-| "responderStatement(string)" function
-}
responderStatement : Address -> String -> Call ()
responderStatement contractAddress statement =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "responderStatement(string)" [ AbiEncode.string statement ]
    , nonce = Nothing
    , decoder = Decode.succeed ()
    }


{-| "tradeAmount()" function
-}
tradeAmount : Address -> Call BigInt
tradeAmount contractAddress =
    { to = Just contractAddress
    , from = Nothing
    , gas = Nothing
    , gasPrice = Nothing
    , value = Nothing
    , data = Just <| AbiEncode.functionCall "tradeAmount()" []
    , nonce = Nothing
    , decoder = toElmDecoder AbiDecode.uint
    }


{-| "Aborted()" event
-}
abortedEvent : Address -> LogFilter
abortedEvent contractAddress =
    { fromBlock = LatestBlock
    , toBlock = LatestBlock
    , address = contractAddress
    , topics = [ Just <| U.keccak256 "Aborted()" ]
    }


{-| "Burned()" event
-}
burnedEvent : Address -> LogFilter
burnedEvent contractAddress =
    { fromBlock = LatestBlock
    , toBlock = LatestBlock
    , address = contractAddress
    , topics = [ Just <| U.keccak256 "Burned()" ]
    }


{-| "Claimed()" event
-}
claimedEvent : Address -> LogFilter
claimedEvent contractAddress =
    { fromBlock = LatestBlock
    , toBlock = LatestBlock
    , address = contractAddress
    , topics = [ Just <| U.keccak256 "Claimed()" ]
    }


{-| "Committed(address,string)" event
-}
type alias Committed =
    { responder : Address
    , commPubkey : String
    }


committedEvent : Address -> LogFilter
committedEvent contractAddress =
    { fromBlock = LatestBlock
    , toBlock = LatestBlock
    , address = contractAddress
    , topics = [ Just <| U.keccak256 "Committed(address,string)" ]
    }


committedDecoder : Decoder Committed
committedDecoder =
    succeed Committed
        |> custom (data 0 AbiDecode.address)
        |> custom (data 1 AbiDecode.string)


{-| "Initiated(string,string)" event
-}
type alias Initiated =
    { terms : String
    , commPubkey : String
    }


initiatedEvent : Address -> LogFilter
initiatedEvent contractAddress =
    { fromBlock = LatestBlock
    , toBlock = LatestBlock
    , address = contractAddress
    , topics = [ Just <| U.keccak256 "Initiated(string,string)" ]
    }


initiatedDecoder : Decoder Initiated
initiatedDecoder =
    succeed Initiated
        |> custom (data 0 AbiDecode.string)
        |> custom (data 1 AbiDecode.string)


{-| "InitiatorStatementLog(string)" event
-}
type alias InitiatorStatementLog =
    { statement : String }


initiatorStatementLogEvent : Address -> LogFilter
initiatorStatementLogEvent contractAddress =
    { fromBlock = LatestBlock
    , toBlock = LatestBlock
    , address = contractAddress
    , topics = [ Just <| U.keccak256 "InitiatorStatementLog(string)" ]
    }


initiatorStatementLogDecoder : Decoder InitiatorStatementLog
initiatorStatementLogDecoder =
    succeed InitiatorStatementLog
        |> custom (data 0 AbiDecode.string)


{-| "Poke()" event
-}
pokeEvent : Address -> LogFilter
pokeEvent contractAddress =
    { fromBlock = LatestBlock
    , toBlock = LatestBlock
    , address = contractAddress
    , topics = [ Just <| U.keccak256 "Poke()" ]
    }


{-| "Recalled()" event
-}
recalledEvent : Address -> LogFilter
recalledEvent contractAddress =
    { fromBlock = LatestBlock
    , toBlock = LatestBlock
    , address = contractAddress
    , topics = [ Just <| U.keccak256 "Recalled()" ]
    }


{-| "Released()" event
-}
releasedEvent : Address -> LogFilter
releasedEvent contractAddress =
    { fromBlock = LatestBlock
    , toBlock = LatestBlock
    , address = contractAddress
    , topics = [ Just <| U.keccak256 "Released()" ]
    }


{-| "ResponderStatementLog(string)" event
-}
type alias ResponderStatementLog =
    { statement : String }


responderStatementLogEvent : Address -> LogFilter
responderStatementLogEvent contractAddress =
    { fromBlock = LatestBlock
    , toBlock = LatestBlock
    , address = contractAddress
    , topics = [ Just <| U.keccak256 "ResponderStatementLog(string)" ]
    }


responderStatementLogDecoder : Decoder ResponderStatementLog
responderStatementLogDecoder =
    succeed ResponderStatementLog
        |> custom (data 0 AbiDecode.string)
