module Main exposing (main)

import Player
import Roller
import Html exposing (Html, button, div, text)
import Html.App as App
import Html.Attributes exposing (style, class)
import AnimationFrame
import Animation


numberOfPlayers =
    4


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
        players =
            List.map (\x -> Player.init x position) [0..(numberOfPlayers - 1)]

        ( roller, rollerMsg ) =
            Roller.init
    in
        ( Model players roller 0
        , Cmd.map Die rollerMsg
        )



-- UPDATE


type Msg
    = Players Int Player.Msg
    | Die Roller.Msg
    | Animate Animation.Msg


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

        Animate animMsg ->
            let
                players =
                    List.map (\player -> { player | style = Animation.update animMsg player.style }) model.players
            in
                ( { model
                    | players = players
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


subscriptions model =
    Animation.subscription Animate (List.map (\player -> player.style) model.players)



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
