module Marketplace.Types exposing (FiatTypeAndRange, Model, Msg(..), Query, ResultColumnType(..), SearchInputs, TokenRange, updateFiatTypeInput, updateMaxDaiInput, updateMaxFiatInput, updateMinDaiInput, updateMinFiatInput, updateOpenMode, updatePaymentMethodInput, updatePaymentMethodTerms)

import Array exposing (Array)
import BigInt exposing (BigInt)
import CommonTypes exposing (..)
import Contracts.Generated.DAIHardFactory as DHF
import Contracts.Generated.DAIHardTrade as DHT
import Contracts.Types as CTypes
import Dict exposing (Dict)
import Eth.Sentry.Event as EventSentry exposing (EventSentry)
import Eth.Types exposing (Address)
import EthHelpers exposing (EthNode)
import FiatValue exposing (FiatValue)
import Http
import Json.Decode
import PaymentMethods exposing (PaymentMethod)
import String.Extra
import Time
import TokenValue exposing (TokenValue)
import TradeCache.Types as TradeCache exposing (TradeCache)


type alias Model =
    { ethNode : EthNode
    , userInfo : Maybe UserInfo
    , inputs : SearchInputs
    , showCurrencyDropdown : Bool
    , filterFunc : Time.Posix -> CTypes.FullTradeInfo -> Bool
    , sortFunc : CTypes.FullTradeInfo -> CTypes.FullTradeInfo -> Order
    , tradeCache : TradeCache
    }


type Msg
    = ChangeOfferType CTypes.OpenMode
    | MinDaiChanged String
    | MaxDaiChanged String
    | FiatTypeInputChanged String
    | MinFiatChanged String
    | MaxFiatChanged String
    | PaymentMethodInputChanged String
    | ShowCurrencyDropdown Bool
    | FiatTypeLostFocus
    | AddSearchTerm
    | RemoveTerm String
    | ApplyInputs
    | ResetSearch
    | TradeClicked Int
    | SortBy ResultColumnType Bool
    | TradeCacheMsg TradeCache.Msg
    | NoOp



--| StateFetched Int (Result Http.Error (Maybe CTypes.State))
--| Refresh Time.Posix


type alias SearchInputs =
    { minDai : String
    , maxDai : String
    , fiatType : String
    , minFiat : String
    , maxFiat : String
    , paymentMethod : String
    , paymentMethodTerms : List String
    , openMode : CTypes.OpenMode
    }


type alias Query =
    { openMode : CTypes.OpenMode
    , dai : TokenRange
    , fiat : Maybe FiatTypeAndRange
    , paymentMethodTerms : List String
    }


type alias TokenRange =
    { min : Maybe TokenValue
    , max : Maybe TokenValue
    }


type alias FiatTypeAndRange =
    { type_ : String
    , min : Maybe BigInt
    , max : Maybe BigInt
    }


updateOpenMode : CTypes.OpenMode -> SearchInputs -> SearchInputs
updateOpenMode openMode inputs =
    { inputs | openMode = openMode }


updatePaymentMethodInput : String -> SearchInputs -> SearchInputs
updatePaymentMethodInput input inputs =
    { inputs | paymentMethod = input }


updateFiatTypeInput : String -> SearchInputs -> SearchInputs
updateFiatTypeInput input inputs =
    { inputs | fiatType = input }


updateMinDaiInput : String -> SearchInputs -> SearchInputs
updateMinDaiInput input inputs =
    { inputs | minDai = input }


updateMaxDaiInput : String -> SearchInputs -> SearchInputs
updateMaxDaiInput input inputs =
    { inputs | maxDai = input }


updateMinFiatInput : String -> SearchInputs -> SearchInputs
updateMinFiatInput input inputs =
    { inputs | minFiat = input }


updateMaxFiatInput : String -> SearchInputs -> SearchInputs
updateMaxFiatInput input inputs =
    { inputs | maxFiat = input }


updatePaymentMethodTerms : List String -> SearchInputs -> SearchInputs
updatePaymentMethodTerms terms inputs =
    { inputs | paymentMethodTerms = terms }


type ResultColumnType
    = Expiring
    | TradeAmount
    | Fiat
    | Margin
    | PaymentMethods
    | AutoabortWindow
    | AutoreleaseWindow