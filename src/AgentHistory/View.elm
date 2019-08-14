module AgentHistory.View exposing (root)

import AgentHistory.Types exposing (..)
import Array exposing (Array)
import CommonTypes exposing (..)
import Contracts.Types as CTypes
import Element exposing (Attribute, Element)
import Element.Background
import Element.Border
import Element.Events
import Element.Font
import Element.Input
import Eth.Types exposing (Address)
import FiatValue exposing (FiatValue)
import Filters.Types as Filters
import Filters.View as Filters
import Helpers.Element as EH
import Helpers.Time as TimeHelpers
import Html.Events.Extra
import Images exposing (Image)
import Margin
import Maybe.Extra
import PaymentMethods exposing (PaymentMethod)
import Time
import TokenValue exposing (TokenValue)
import TradeCache.State as TradeCache
import TradeCache.Types as TradeCache exposing (TradeCache)
import TradeTable.Types as TradeTable
import TradeTable.View as TradeTable
import Wallet


root : Time.Posix -> List TradeCache -> Model -> Element Msg
root time tradeCaches model =
    Element.column
        [ Element.Border.rounded 5
        , Element.Background.color EH.white
        , Element.width Element.fill
        , Element.height Element.fill
        , Element.paddingXY 30 20
        ]
        [ pageTitleElement model
        , statusAndFiltersElement tradeCaches model
        , maybeResultsElement time tradeCaches model
        ]


pageTitleElement : Model -> Element Msg
pageTitleElement model =
    let
        viewingOwnHistory =
            case Wallet.userInfo model.wallet of
                Nothing ->
                    False

                Just userInfo ->
                    userInfo.address == model.agentAddress
    in
    if viewingOwnHistory then
        Element.none

    else
        Element.row
            [ Element.spacing 10
            , Element.paddingEach
                { top = 10
                , left = 20
                , right = 20
                , bottom = 20
                }
            ]
            [ Element.el
                [ Element.Font.size 24
                , Element.Font.semiBold
                ]
                (Element.text "Trade History for User")
            , EH.ethAddress 18 model.agentAddress
            ]


statusAndFiltersElement : List TradeCache -> Model -> Element Msg
statusAndFiltersElement tradeCaches model =
    let
        statusMsgElement s =
            Element.el
                [ Element.Font.size 20
                , Element.Font.semiBold
                , Element.Font.color EH.darkGray
                , Element.centerX
                ]
                (Element.text s)

        statusMessages : List (Element Msg)
        statusMessages =
            if List.all ((==) TradeCache.NoneFound) (List.map TradeCache.loadingStatus tradeCaches) then
                [ statusMsgElement "No trades found." ]

            else
                tradeCaches
                    |> List.map
                        (\tc ->
                            case TradeCache.loadingStatus tc of
                                TradeCache.QueryingNumTrades ->
                                    Just <| "Querying " ++ factoryName tc.factory ++ " Factory..."

                                TradeCache.NoneFound ->
                                    Nothing

                                TradeCache.FetchingTrades ->
                                    Just <| "Fetching " ++ factoryName tc.factory ++ " Trades..."

                                TradeCache.AllFetched ->
                                    Nothing
                        )
                    |> Maybe.Extra.values
                    |> List.map statusMsgElement
    in
    Element.el
        [ Element.width Element.fill
        , Element.inFront <|
            Element.column
                [ Element.spacing 5
                , Element.alignLeft
                ]
                statusMessages
        ]
        (Element.el
            [ Element.centerX ]
            (Element.map FiltersMsg <| Filters.view model.filters)
        )


maybeResultsElement : Time.Posix -> List TradeCache -> Model -> Element Msg
maybeResultsElement time tradeCaches model =
    let
        visibleTrades =
            tradeCaches
                |> List.map
                    (\tradeCache ->
                        TradeCache.loadedValidTrades tradeCache
                            |> filterTrades
                                (basicFilterFunc model)
                    )
                |> List.concat
                |> Filters.filterTrades model.filters
    in
    if visibleTrades == [] then
        Element.none

    else
        TradeTable.view
            time
            model.tradeTable
            [ TradeTable.Phase
            , TradeTable.Offer
            , TradeTable.FiatPrice
            , TradeTable.Margin
            , TradeTable.PaymentWindow
            , TradeTable.BurnWindow
            ]
            visibleTrades
            |> Element.map TradeTableMsg


getLoadedTrades : List CTypes.Trade -> List CTypes.FullTradeInfo
getLoadedTrades =
    List.filterMap
        (\trade ->
            case trade of
                CTypes.LoadedTrade tradeInfo ->
                    Just tradeInfo

                _ ->
                    Nothing
        )


filterTrades :
    (CTypes.FullTradeInfo -> Bool)
    -> List CTypes.FullTradeInfo
    -> List CTypes.FullTradeInfo
filterTrades filterFunc =
    List.filter filterFunc


basicFilterFunc : Model -> (CTypes.FullTradeInfo -> Bool)
basicFilterFunc model =
    \trade ->
        (trade.parameters.initiatorAddress == model.agentAddress)
            || (trade.state.responder == Just model.agentAddress)
