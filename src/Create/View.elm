module Create.View exposing (root)

import BigInt exposing (BigInt)
import CmdUp exposing (CmdUp)
import CommonTypes exposing (..)
import Config
import Contracts.Types as CTypes
import Create.PMWizard.View as PMWizard
import Create.Types exposing (..)
import Element exposing (Attribute, Element)
import Element.Background
import Element.Border
import Element.Events
import Element.Font
import Element.Input
import Helpers.Element as EH
import Helpers.Eth as EthHelpers
import Helpers.Time as TimeHelpers
import Html.Attributes
import Images exposing (Image)
import List.Extra
import Maybe.Extra
import PaymentMethods exposing (PaymentMethod)
import Prices
import Time
import TokenValue exposing (TokenValue)
import Wallet


root : Model -> ( Element Msg, List (Element Msg) )
root model =
    ( EH.submodelContainer
        1000
        (Just "Trade Dai/xDai for any asset! No bank account or KYC required.")
        "CUSTOM TRADE"
        (Element.column
            [ Element.width Element.fill
            , Element.spacing 20
            , Element.padding 20
            ]
            [ mainInputElement model
            , phasesElement model
            , openButtonElement model.inputs.dhToken model.wallet
            ]
        )
    , viewModals model
    )


mainInputElement : Model -> Element Msg
mainInputElement model =
    let
        factory =
            Wallet.factoryWithDefault model.wallet
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing 20
        , Element.Border.rounded 5
        , Element.paddingXY 20 0
        ]
        [ Element.row
            [ Element.width Element.fill
            , Element.spaceEvenly
            ]
            [ tradeTypeElement factory model
            , daiElement factory model
            , fiatElement model
            ]
        , feeNotifyElement model
        ]


tradeTypeElement : FactoryType -> Model -> Element Msg
tradeTypeElement factory model =
    EH.withInputHeader
        [ Element.alignTop ]
        "Trade Type"
        (roleToggleElement
            (tokenUnitName factory)
            model.inputs.userRole
        )


roleToggleElement : String -> BuyerOrSeller -> Element Msg
roleToggleElement tokenName userRole =
    let
        baseStyles =
            [ Element.Font.size 24
            , Element.Font.medium
            , Element.pointer
            ]

        ( buyDaiEl, sellDaiEl ) =
            ( EH.withSelectedUnderline [] (userRole == Buyer) <|
                Element.el
                    ([ Element.Events.onClick <| ChangeRole Buyer ] ++ baseStyles)
                    (Element.text <| "Buy " ++ tokenName)
            , EH.withSelectedUnderline [] (userRole == Seller) <|
                Element.el
                    ([ Element.Events.onClick <| ChangeRole Seller ] ++ baseStyles)
                    (Element.text <| "Sell " ++ tokenName)
            )
    in
    Element.row
        [ Element.spacing 20
        , Element.paddingEach
            { top = 10
            , bottom = 0
            , right = 0
            , left = 0
            }
        ]
        [ sellDaiEl
        , buyDaiEl
        ]


daiElement : FactoryType -> Model -> Element Msg
daiElement factory model =
    EH.withInputHeader
        [ Element.alignTop ]
        (case model.inputs.userRole of
            Buyer ->
                "You're buying"

            Seller ->
                "You're selling"
        )
        (EH.roundedComplexInputBox
            [ Element.width <| Element.px 200
            , Element.below <|
                EH.maybeErrorElement
                    [ inputErrorTag
                    , Element.moveDown 5
                    ]
                    model.errors.daiAmount
            ]
            [ EH.dhTokenTypeSelector model.inputs.dhToken model.showDhTypeDropdown DhDropdownClicked DhTypeChanged ]
            { onChange = TradeAmountChanged
            , text = model.inputs.daiAmount
            , placeholder = Nothing
            , label = Element.Input.labelHidden "dai input"
            }
            []
        )


fiatElement : Model -> Element Msg
fiatElement model =
    let
        fiatCharElement =
            case Prices.char model.inputs.fiatType of
                Just char ->
                    Element.el
                        [ Element.Events.onClick <|
                            CmdUp <|
                                CmdUp.gTag "click" "misclick" "currency symbol" 0
                        ]
                        (Element.text <| char)

                Nothing ->
                    Element.none
    in
    EH.withInputHeader
        [ Element.alignTop ]
        "For:"
        (EH.roundedComplexInputBox
            [ Element.width <| Element.px 250
            , Element.padding 8
            , Element.below <|
                EH.maybeErrorElement
                    [ inputErrorTag
                    , Element.moveDown 5
                    ]
                    (Maybe.Extra.or
                        model.errors.fiatAmount
                        model.errors.fiatType
                    )
            ]
            [ EH.currencySelector
                model.showFiatTypeDropdown
                model.inputs.fiatType
                (ShowCurrencyDropdown True)
                FiatTypeChanged
                (CmdUp <| CmdUp.gTag "click" "misclick" "currency flag" 0)
            , fiatCharElement
            ]
            { onChange = FiatAmountChanged
            , text = model.inputs.fiatAmount
            , placeholder =
                Just <|
                    Element.Input.placeholder
                        [ Element.Font.color EH.placeholderTextColor
                        ]
                        (Element.text "0")
            , label = Element.Input.labelHidden "price input"
            }
            []
        )


fiatInputElement : Prices.Symbol -> String -> Bool -> Maybe String -> Maybe String -> Element Msg
fiatInputElement symbol amountString showFiatTypeDropdown maybeAmountError maybeTypeError =
    let
        fiatCharElement =
            case Prices.char symbol of
                Just char ->
                    Element.el
                        [ Element.Events.onClick <|
                            CmdUp <|
                                CmdUp.gTag "click" "misclick" "currency symbol" 0
                        ]
                        (Element.text <| char)

                Nothing ->
                    Element.none

        flagClickedMsg =
            CmdUp <| CmdUp.gTag "click" "misclick" "currency flag" 0

        currencySelector =
            Element.el
                [ Element.below <|
                    EH.maybeErrorElement
                        [ inputErrorTag
                        , Element.moveDown 5
                        ]
                        maybeTypeError
                ]
                (EH.currencySelector showFiatTypeDropdown symbol (ShowCurrencyDropdown True) FiatTypeChanged flagClickedMsg)
    in
    EH.fancyInput
        [ Element.width <| Element.px 250
        , Element.Font.medium
        , Element.Font.size 24
        , Element.Background.color EH.submodelBackgroundColor
        , Element.below <|
            EH.maybeErrorElement
                [ inputErrorTag
                , Element.moveDown 5
                ]
                maybeAmountError
        ]
        ( Just fiatCharElement, Just currencySelector )
        "price input"
        Nothing
        amountString
        FiatAmountChanged


openButtonElement : FactoryType -> Wallet.State -> Element Msg
openButtonElement dhTypeInput wallet =
    Element.el [ Element.centerX ] <|
        case ( Wallet.userInfo wallet, Wallet.factory wallet ) of
            ( Just userInfo, Just factory ) ->
                if factory == dhTypeInput then
                    EH.redButton "Open Trade" (CreateClicked factory userInfo)

                else
                    EH.disabledButton "Open Trade"
                        (Just <|
                            "You must switch your wallet to the "
                                ++ networkNameForFactory dhTypeInput
                                ++ " network to create a trade with "
                                ++ tokenUnitName dhTypeInput
                        )

            ( Nothing, _ ) ->
                EH.redButton "Connect to Wallet" Web3Connect

            ( _, Nothing ) ->
                EH.disabledButton "Unsupported Network" Nothing


feeNotifyElement : Model -> Element Msg
feeNotifyElement model =
    let
        blueText =
            case TokenValue.fromString model.inputs.daiAmount of
                Just daiAmount ->
                    "There is a 1% fee of "
                        ++ TokenValue.toConciseString
                            (TokenValue.div daiAmount 100)
                        ++ " "
                        ++ tokenUnitName (Wallet.factoryWithDefault model.wallet)
                        ++ "."

                Nothing ->
                    "There is a 1% fee."

        regularText =
            "We only collect this fee when trades resolve successfully."
    in
    Element.row
        [ Element.centerX
        , Element.paddingXY 20 10
        , Element.Background.color <| Element.rgb255 10 33 108
        , Element.Border.rounded 8
        , Element.spacing 5
        , Element.Events.onClick <|
            CmdUp <|
                CmdUp.gTag "click" "misclick" "fee notify element" 0
        ]
        [ Element.el
            [ Element.Font.size 18
            , Element.Font.color <| Element.rgb255 0 226 255
            , Element.Font.semiBold
            ]
            (Element.text blueText)
        , Element.el
            [ Element.Font.size 17
            , Element.Font.color EH.white
            , Element.Font.medium
            ]
            (Element.text regularText)
        ]


phasesElement : Model -> Element Msg
phasesElement model =
    Element.column
        [ Element.width Element.fill
        , Element.spacing 15
        ]
        [ phaseHorizontalSpacer
        , openPhaseElement
            model.inputs.autorecallInterval
            model.errors.autorecallInterval
            model.inputs.userRole
        , phaseHorizontalSpacer
        , committedPhaseElement
            model.inputs.paymentMethod
            model.errors.paymentMethod
            model.inputs.autoabortInterval
            model.errors.autoabortInterval
            model.inputs.userRole
        , phaseHorizontalSpacer
        , judgmentPhaseElement
            model.inputs.autoreleaseInterval
            model.errors.autoreleaseInterval
            model.inputs.userRole
        , phaseHorizontalSpacer
        ]


phaseHorizontalSpacer : Element Msg
phaseHorizontalSpacer =
    Element.el
        [ Element.width Element.fill
        , Element.height <| Element.px 2
        , Element.Background.color EH.black
        ]
        Element.none


openPhaseElement : Time.Posix -> Maybe String -> BuyerOrSeller -> Element Msg
openPhaseElement interval maybeError userRole =
    phaseElement
        Images.openWindowIcon
        "Open Window"
        (openWindowSummary userRole)
        interval
        maybeError
        AutorecallIntervalChanged


committedPhaseElement : String -> Maybe String -> Time.Posix -> Maybe String -> BuyerOrSeller -> Element Msg
committedPhaseElement paymentMethodText maybeTextError interval maybeIntervalError userRole =
    Element.column
        [ Element.spacing 15 ]
        [ phaseElement
            Images.fiatBag
            "Payment Window"
            (paymentWindowSummary userRole)
            interval
            maybeIntervalError
            AutoabortIntervalChanged
        , paymentMethodsElement maybeTextError userRole paymentMethodText
        ]


judgmentPhaseElement : Time.Posix -> Maybe String -> BuyerOrSeller -> Element Msg
judgmentPhaseElement interval maybeError userRole =
    phaseElement
        Images.releaseWindowIcon
        "Burn/Release Window"
        (releaseWindowSummary userRole)
        interval
        maybeError
        AutoreleaseIntervalChanged


openWindowSummary : BuyerOrSeller -> String
openWindowSummary userRole =
    let
        committingParty =
            case userRole of
                Buyer ->
                    "Seller"

                Seller ->
                    "Buyer"
    in
    "The offer will expire by this time window if a "
        ++ committingParty
        ++ " does not commit to the trade, returning the balance and the 1% fee to your wallet. This can also be manually triggered anytime before a "
        ++ committingParty
        ++ " commits."


paymentWindowSummary : BuyerOrSeller -> String
paymentWindowSummary userRole =
    case userRole of
        Buyer ->
            "After committing, you and the Seller have this long to complete the external payment, using one of your payment methods indicated below. If you fail to confirm payment within this window, 1/4 of your deposit is burned from both parties and the rest is refunded."

        Seller ->
            "After committing, you and the Buyer have this long to complete the external payment, using one of your payment methods indicated below. If the Buyer aborts or fails to confirm within this window, 1/12 of the trade amount is burned from both parties and the rest is refunded."


releaseWindowSummary : BuyerOrSeller -> String
releaseWindowSummary userRole =
    case userRole of
        Buyer ->
            "Once you confirm payment, the Seller has this time window to decide whether to release the funds to you or burn everything. If he doesn't decide before the time is up, funds are released to you by default."

        Seller ->
            "Once the Buyer confirms payment, you have this long to decide whether to release the funds to the Buyer or, in the case of an attempted scam, burn everything. If you don't decide before the time is up, funds are released to the Buyer by default."


paymentMethodsElement : Maybe String -> BuyerOrSeller -> String -> Element Msg
paymentMethodsElement maybeError initiatorRole inputText =
    let
        titleElement =
            Element.el
                [ Element.Font.size 22
                , Element.Font.semiBold
                ]
                (Element.text "Payment Method")

        inputElement =
            Element.Input.multiline
                [ Element.width Element.fill
                , Element.height <| Element.px 150
                , Element.Background.color <| Element.rgba255 155 203 255 0.2
                , Element.Border.width 0
                ]
                { onChange = ChangePaymentMethodText
                , text = inputText
                , placeholder =
                    if inputText == "" then
                        Just <| inputPlaceholder initiatorRole

                    else
                        Nothing
                , label = Element.Input.labelHidden "payment method"
                , spellcheck = True
                }
    in
    Element.column
        [ Element.spacing 20
        , Element.paddingEach
            { left = 45
            , right = 45
            , top = 0
            , bottom = 15
            }
        , Element.width Element.fill
        , Element.above <|
            EH.maybeErrorElement
                [ inputErrorTag
                , Element.moveDown 30
                , Element.padding 10
                , Element.Font.size 20
                , Element.width <| Element.px 400
                ]
                maybeError
        ]
        [ titleElement
        , inputElement
        ]


phaseElement : Image -> String -> String -> Time.Posix -> Maybe String -> (Time.Posix -> Msg) -> Element Msg
phaseElement icon title summary interval maybeError newIntervalMsg =
    let
        iconAndTitleElement =
            Element.row
                [ Element.spacing 30 ]
                [ Images.toElement
                    [ Element.height <| Element.px 40
                    , Element.Events.onClick <|
                        CmdUp <|
                            CmdUp.gTag "click" "misclick" ("symbol for " ++ title) 0
                    ]
                    icon
                , Element.el
                    [ Element.Font.size 22
                    , Element.Font.semiBold
                    ]
                    (Element.text title)
                ]

        descriptionElement =
            Element.paragraph
                [ Element.Font.size 17
                , Element.Font.medium
                , Element.Font.color EH.permanentTextColor
                ]
                [ Element.text summary ]

        intervalElement =
            Element.el
                [ Element.Background.color <| Element.rgba255 155 203 255 0.2
                , Element.Border.rounded 5
                , Element.padding 15
                , Element.above <|
                    EH.maybeErrorElement
                        [ inputErrorTag ]
                        maybeError
                ]
                (EH.intervalInput EH.black interval newIntervalMsg)
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing 2
        ]
        (List.map
            (Element.el
                [ Element.paddingXY 45 18
                , Element.width Element.fill
                ]
            )
            [ iconAndTitleElement
            , Element.row
                [ Element.width Element.fill
                , Element.spacing 25
                ]
                [ intervalElement
                , descriptionElement
                ]
            ]
        )


viewModals : Model -> List (Element Msg)
viewModals model =
    model.txChainStatus
        |> Maybe.map
            (\txChainStatus ->
                txChainStatusModal txChainStatus model
            )
        |> List.singleton
        |> Maybe.Extra.values


txChainStatusModal : TxChainStatus -> Model -> Element Msg
txChainStatusModal txChainStatus model =
    case txChainStatus of
        Confirm factoryType createParameters ->
            let
                ( depositAmountEl, confirmButton ) =
                    case model.depositAmount of
                        Just depositAmount ->
                            ( TokenValue.tokenValue depositAmount
                                |> TokenValue.toConciseString
                                |> Element.text
                            , EH.redButton "Yes, I definitely want to open this trade." (ConfirmCreate factoryType createParameters depositAmount)
                            )

                        Nothing ->
                            ( Element.text "??"
                            , EH.disabledButton "(loading exact fees...)" Nothing
                            )
            in
            EH.closeableModal
                []
                (Element.column
                    [ Element.spacing 20
                    , Element.padding 20
                    , Element.centerX
                    , Element.height Element.fill
                    , Element.Font.center
                    ]
                    [ Element.el
                        [ Element.Font.size 26
                        , Element.Font.semiBold
                        , Element.centerX
                        , Element.centerY
                        ]
                        (Element.text "Just to Confirm...")
                    , Element.column
                        [ Element.spacing 20
                        , Element.centerX
                        , Element.centerY
                        ]
                        (List.map
                            (Element.paragraph
                                [ Element.centerX
                                , Element.Font.size 18
                                , Element.Font.medium
                                , Element.Font.color EH.permanentTextColor
                                ]
                            )
                            (getWarningParagraphs createParameters
                                ++ [ [ Element.text <| "You will deposit "
                                     , depositAmountEl
                                     , Element.text <| " " ++ tokenUnitName factoryType ++ " (this includes the 1% dev fee) to open this trade."
                                     ]
                                   ]
                                ++ (case factoryType of
                                        Token _ ->
                                            [ [ Element.text <| "This ususally requires two Metamask signatures. Your " ++ tokenUnitName factoryType ++ " will not be deposited until the final transaction has been mined." ] ]

                                        Native _ ->
                                            []
                                   )
                            )
                        )
                    , Element.el
                        [ Element.alignBottom
                        , Element.centerX
                        ]
                        confirmButton
                    ]
                )
                NoOp
                AbortCreate

        ApproveNeedsSig tokenType ->
            Element.el
                [ Element.centerX
                , Element.centerY
                , Element.Events.onClick <|
                    CmdUp <|
                        CmdUp.gTag "txChainModal clicked" "misclick" "ApproveNeedsSig" 0
                ]
            <|
                EH.txProcessModal
                    [ Element.text "Waiting for user signature for the approve call."
                    , Element.text "(check Metamask!)"
                    , Element.text "Note that there will be a second transaction to sign after this."
                    ]
                    NoOp
                    NoOp

        ApproveMining tokenType createParameters txHash ->
            Element.el
                [ Element.centerX
                , Element.centerY
                , Element.Events.onClick <|
                    CmdUp <|
                        CmdUp.gTag "txChainModal clicked" "misclick" "ApproveMining" 0
                ]
            <|
                EH.txProcessModal
                    [ Element.text "Mining the initial approve transaction..."
                    , Element.newTabLink [ Element.Font.underline, Element.Font.color EH.blue ]
                        { url = EthHelpers.makeViewTxUrl (Token tokenType) txHash
                        , label = Element.text "See the transaction on Etherscan"
                        }
                    , Element.text "Funds will not leave your wallet until you sign the next transaction."
                    ]
                    NoOp
                    NoOp

        CreateNeedsSig _ ->
            Element.el
                [ Element.centerX
                , Element.centerY
                , Element.Events.onClick <|
                    CmdUp <|
                        CmdUp.gTag "txChainModal clicked" "misclick" "CreateNeedsSig" 0
                ]
            <|
                EH.txProcessModal
                    [ Element.text "Waiting for user signature for the create call."
                    , Element.text "(check Metamask!)"
                    ]
                    NoOp
                    NoOp

        CreateMining factoryType txHash ->
            Element.el
                [ Element.centerX
                , Element.centerY
                , Element.Events.onClick <|
                    CmdUp <|
                        CmdUp.gTag "txChainModal clicked" "misclick" "CreateMining" 0
                ]
            <|
                EH.txProcessModal
                    [ Element.text "Mining the final create call..."
                    , Element.newTabLink [ Element.Font.underline, Element.Font.color EH.blue ]
                        { url = EthHelpers.makeViewTxUrl factoryType txHash
                        , label = Element.text "See the transaction on Etherscan"
                        }
                    , Element.text "You will be redirected when it's mined."
                    ]
                    NoOp
                    NoOp


getWarningParagraphs : CTypes.CreateParameters -> List (List (Element Msg))
getWarningParagraphs createParameters =
    [ if TimeHelpers.compare createParameters.autoreleaseInterval (Time.millisToPosix (1000 * 60 * 20)) == LT then
        Just <|
            case createParameters.initiatorRole of
                Buyer ->
                    "That Burn/Release Window time is quite small! It might take a while to find a committed Seller."

                Seller ->
                    "That Burn/Release Window time is quite small! This may attract scammers. Only create this trade if you know what you're doing."

      else
        Nothing
    , if TimeHelpers.compare createParameters.autoabortInterval (Time.millisToPosix (1000 * 60 * 60)) == LT then
        Just <|
            case createParameters.initiatorRole of
                Buyer ->
                    "That Payment Window time is quite small! If you fail to to 1. make the payment and 2. click \"confirm\" before this time is up, the trade will automatically abort, incurring the abort punishments on both parties."

                Seller ->
                    "That Payment Window time is quite small! If the Buyer fails to to 1. make the payment and 2. click \"confirm\" before this time is up, the trade will automatically abort, incurring the abort punishments on both parties."

      else
        Nothing
    ]
        |> Maybe.Extra.values
        |> List.map
            (\message ->
                [ Element.el [ Element.Font.color EH.red ] <| Element.text "Caution! "
                , Element.text message
                ]
            )


inputPlaceholder : BuyerOrSeller -> Element.Input.Placeholder Msg
inputPlaceholder initiatorRole =
    Element.Input.placeholder
        [ Element.Font.color <| Element.rgba 0 0 0 0.2 ]
        (case initiatorRole of
            Seller ->
                Element.text """Some examples:

I can accept transfers to a Schwab bank account (routing 121202211)
I can meet in person to accept cash in London, weekdays after 6, with a day of notice.
Hide the cash in Hume Park, Bulawayo, and tell me the location over chat."""

            Buyer ->
                Element.text """Some examples:

I can deliver cash anywhere within an hour drive of Phoneix, AZ, with 2 days of notice.
TransferWise
Interac e-Transfer
"""
        )


inputErrorTag : Attribute Msg
inputErrorTag =
    Element.htmlAttribute <| Html.Attributes.id "inputError"
