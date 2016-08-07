module Main exposing (main)

import Player
import Roller
import Html exposing (Html, button, div, text)
import Html.App as App
import Html.Attributes exposing (style, class)
import Html.Events exposing (onClick)
import AnimationFrame
import Style
import Style.Properties exposing (..)


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
    | Animate Float


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
                -- Roll the dice
                ( roller, rollerMsg ) =
                    Roller.update dieMsg model.roller

                model =
                    { model | roller = roller }
            in
                case dieMsg of
                    Roller.NewFace face ->
                        let
                            -- Move the player accordingly
                            ( player, playerMsg ) =
                                Player.update (Player.Move roller.dieFace) model.player
                        in
                            ( { model | player = player }
                            , Cmd.batch
                                [ Cmd.map Die rollerMsg
                                , Cmd.map FirstPlayer playerMsg
                                ]
                            )

                    _ ->
                        ( model, Cmd.map Die rollerMsg )

        Animate time ->
            let
                firstPlayer =
                    model.player
            in
                ( { model
                    | player =
                        { firstPlayer | style = Style.tick time firstPlayer.style }
                  }
                , Cmd.none
                )



-- VIEW


view : Model -> Html Msg
view model =
    div [ containerStyle ]
        [ div
            [ mapStyle ]
            [ text (toString model.roller.dieFace)
            , App.map Die (Roller.view model.roller)
            , App.map FirstPlayer (Player.view model.player)
            ]
        ]



-- SUBS


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.times Animate



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
