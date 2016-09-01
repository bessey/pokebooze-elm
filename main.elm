module Main exposing (main)

import Player
import Roller
import Html exposing (Html, button, div, text)
import Html.App as App
import Html.Attributes exposing (style, class)
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
    { players : List Player.Model
    , roller : Roller.Model
    , activePlayer : Int
    }


init : Int -> ( Model, Cmd Msg )
init position =
    let
        p1 =
            Player.init 0 position

        p2 =
            Player.init 1 position

        ( roller, rollerMsg ) =
            Roller.init
    in
        ( Model [ p1, p2 ] roller 1
        , Cmd.map Die rollerMsg
        )



-- UPDATE


type Msg
    = Players Int Player.Msg
    | Die Roller.Msg
    | Animate Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Players index playerMsg ->
            ( { model | players = List.map (updatePlayer model.activePlayer playerMsg) model.players }
            , Cmd.none
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
                        ( { model
                            | players = List.map (updatePlayer model.activePlayer (Player.Move face)) model.players
                            , activePlayer = (model.activePlayer + 1) % List.length model.players
                          }
                        , Cmd.map Die rollerMsg
                        )

                    _ ->
                        ( model, Cmd.map Die rollerMsg )

        Animate time ->
            ( { model
                | players = List.map (\player -> { player | style = Style.tick time player.style }) model.players
              }
            , Cmd.none
            )


updatePlayer : Int -> Player.Msg -> Player.Model -> Player.Model
updatePlayer targetId msg model =
    if targetId == model.id then
        Player.update msg model
    else
        model


updatePlayerModel : Player.Model -> Player.Model
updatePlayerModel model =
    model



-- VIEW


view : Model -> Html Msg
view model =
    div [ containerStyle ]
        [ div
            [ mapStyle ]
            ([ text (toString model.roller.dieFace)
             , text "  "
             , text (toString (model.activePlayer + 1))
             , App.map Die (Roller.view model.roller)
             ]
                ++ List.map viewIndexedPlayer model.players
            )
        ]


viewIndexedPlayer : Player.Model -> Html Msg
viewIndexedPlayer model =
    App.map (Players model.id) (Player.view model)



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
