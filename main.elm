module Main exposing (main)

import Player
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
    }


init : Int -> ( Model, Cmd Msg )
init position =
    let
        ( p1, p1Msg ) =
            Player.init position
    in
        ( Model p1
        , Cmd.batch
            [ Cmd.map FirstPlayer p1Msg ]
        )



-- UPDATE


type Msg
    = FirstPlayer Player.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FirstPlayer firstPlayerMsg ->
            let
                ( p1, p1Msg ) =
                    Player.update firstPlayerMsg model.player
            in
                ( Model p1
                , Cmd.map FirstPlayer p1Msg
                )



-- VIEW


view : Model -> Html Msg
view model =
    div [ containerStyle ]
        [ div
            [ mapStyle ]
            [ App.map FirstPlayer (Player.view model.player) ]
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
