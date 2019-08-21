module CryptoSwap.Types exposing (Errors, ForeignCrypto(..), Model, Msg(..), TxChainStatus(..), UpdateResult, exampleAddressForForeignCrypto, foreignCryptoName, foreignCryptoToFiatValue, justModelUpdate, maybeUserParameters, noErrors)

import AppCmd exposing (AppCmd)
import BigInt exposing (BigInt)
import ChainCmd exposing (ChainCmd)
import CommonTypes exposing (..)
import Contracts.Types as CTypes
import Eth.Types exposing (Address, TxHash, TxReceipt)
import FiatValue exposing (FiatValue)
import Http
import PaymentMethods exposing (PaymentMethod)
import Time
import TokenValue exposing (TokenValue)
import Wallet


type alias Model =
    { wallet : Wallet.State
    , initiatorRole : BuyerOrSeller
    , amountInInput : String
    , amountIn : Maybe TokenValue
    , dhToken : FactoryType
    , foreignCrypto : ForeignCrypto
    , marginInput : String
    , margin : Maybe Float
    , amountOut : Maybe TokenValue
    , receiveAddressInput : String
    , receiveAddress : Maybe String
    , showDhTokenDropdown : Bool
    , showForeignCryptoDropdown : Bool
    , showAdditionalSettings : Bool
    , errors : Errors
    , txChainStatus : Maybe TxChainStatus
    , depositAmount : Maybe BigInt
    , allowance : Maybe BigInt
    }


type TxChainStatus
    = Confirm FactoryType CTypes.CreateParameters
    | ApproveNeedsSig TokenFactoryType
    | ApproveMining TokenFactoryType CTypes.CreateParameters TxHash
    | CreateNeedsSig FactoryType
    | CreateMining FactoryType TxHash


type Msg
    = Refresh Time.Posix
    | AmountInChanged String
    | MarginChanged String
    | TokenTypeClicked
    | ForeignCryptoTypeClicked
    | ReceiveAddressChanged String
    | PlaceOrderClicked FactoryType UserInfo CTypes.UserParameters
    | AbortCreate
    | ConfirmCreate FactoryType CTypes.CreateParameters BigInt
    | AllowanceFetched TokenFactoryType (Result Http.Error BigInt)
    | ApproveSigned TokenFactoryType CTypes.CreateParameters (Result String TxHash)
    | CreateSigned FactoryType (Result String TxHash)
    | CreateMined FactoryType (Result String TxReceipt)
    | ToggleAdditionalSettings
    | AppCmd (AppCmd Msg)


type alias UpdateResult =
    { model : Model
    , cmd : Cmd Msg
    , chainCmd : ChainCmd Msg
    , appCmds : List (AppCmd Msg)
    }


justModelUpdate : Model -> UpdateResult
justModelUpdate model =
    UpdateResult
        model
        Cmd.none
        ChainCmd.none
        []


type ForeignCrypto
    = ZEC
    | XMR
    | BTC


foreignCryptoName : ForeignCrypto -> String
foreignCryptoName crypto =
    case crypto of
        ZEC ->
            "ZEC"

        XMR ->
            "XMR"

        BTC ->
            "BTC"


foreignCryptoToFiatValue : ForeignCrypto -> TokenValue -> FiatValue
foreignCryptoToFiatValue cryptoType amount =
    FiatValue
        (foreignCryptoName cryptoType)
        (TokenValue.getEvmValue amount)


type alias Errors =
    { amountIn : Maybe String
    , margin : Maybe String
    , receiveAddress : Maybe String
    }


noErrors : Errors
noErrors =
    Errors Nothing Nothing Nothing


exampleAddressForForeignCrypto : ForeignCrypto -> String
exampleAddressForForeignCrypto crypto =
    case crypto of
        ZEC ->
            "zs... / zc... / t..."

        XMR ->
            "4..."

        BTC ->
            "1... / 3... / bc1..."


maybeUserParameters : Model -> Maybe CTypes.UserParameters
maybeUserParameters model =
    case model.initiatorRole of
        Buyer ->
            Maybe.map3
                (\amountIn margin amountOut ->
                    { initiatorRole = model.initiatorRole
                    , tradeAmount = amountOut
                    , price = foreignCryptoToFiatValue model.foreignCrypto amountIn
                    , paymentMethods =
                        [ PaymentMethod
                            PaymentMethods.Custom
                            ("Provide your "
                                ++ foreignCryptoName model.foreignCrypto
                                ++ " address immediately upon commitment, via chat."
                            )
                        ]
                    , autorecallInterval = Time.millisToPosix (1000 * 60 * 60 * 48)
                    , autoabortInterval = Time.millisToPosix (1000 * 60 * 60 * 24)
                    , autoreleaseInterval = Time.millisToPosix (1000 * 60 * 60 * 24)
                    }
                )
                model.amountIn
                model.margin
                model.amountOut

        Seller ->
            Maybe.map4
                (\amountIn margin receiveAddress amountOut ->
                    { initiatorRole = model.initiatorRole
                    , tradeAmount = amountIn
                    , price = foreignCryptoToFiatValue model.foreignCrypto amountOut
                    , paymentMethods =
                        [ PaymentMethod
                            PaymentMethods.Custom
                            ("Pay to " ++ receiveAddress ++ " immediately upon commitment.")
                        ]
                    , autorecallInterval = Time.millisToPosix (1000 * 60 * 60 * 48)
                    , autoabortInterval = Time.millisToPosix (1000 * 60 * 60 * 24)
                    , autoreleaseInterval = Time.millisToPosix (1000 * 60 * 60 * 24)
                    }
                )
                model.amountIn
                model.margin
                model.receiveAddress
                model.amountOut
