module Main exposing (main)

import Player
import Roller
import Html exposing (Html, button, div, text)
import Html.App as App
import Html.Attributes exposing (style, class)
import Html.Events exposing (onClick)


main =
    App.program
        { init = init 0
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { player : Player.Model
    , roller : Roller.Model
    }


init : Int -> ( Model, Cmd Msg )
init position =
    let
        ( p1, p1Msg ) =
            Player.init position

        ( roller, rollerMsg ) =
            Roller.init
    in
        ( Model p1 roller
        , Cmd.batch
            [ Cmd.map FirstPlayer p1Msg
            , Cmd.map Die rollerMsg
            ]
        )



-- UPDATE


type Msg
    = FirstPlayer Player.Msg
    | Die Roller.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FirstPlayer firstPlayerMsg ->
            let
                ( p1, p1Msg ) =
                    Player.update firstPlayerMsg model.player
            in
                ( { model | player = p1 }
                , Cmd.map FirstPlayer p1Msg
                )

        Die dieMsg ->
            let
                ( roller, rollerMsg ) =
                    Roller.update dieMsg model.roller
            in
                ( { model | roller = roller }
                , Cmd.map Die rollerMsg
                )



-- VIEW


view : Model -> Html Msg
view model =
    div [ containerStyle ]
        [ div
            [ mapStyle ]
            [ App.map Die (Roller.view model.roller)
            , App.map FirstPlayer (Player.view model.player)
            ]
        ]



-- SUBS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map FirstPlayer (Player.subscriptions model.player)
        ]



-- STYLES


containerStyle =
    style
        [ ( "width", "100%" )
        , ( "height", "100%" )
        ]


mapStyle =
    style
        [ ( "background-image", "url(/board.png)" )
        , ( "width", "2216px" )
        , ( "height", "2216px" )
        , ( "position", "relative" )
        ]
