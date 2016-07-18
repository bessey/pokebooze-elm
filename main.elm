module Main exposing (main)

import Player
import Html exposing (Html, button, div, text)
import Html.App as App
import Html.Attributes exposing (style, class)
import Html.Events exposing (onClick)


main =
    App.beginnerProgram
        { model = init 0
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { player : Player.Model
    }


init : Int -> Model
init position =
    { player = Player.init position
    }



-- UPDATE


type Msg
    = FirstPlayer Player.Msg


update : Msg -> Model -> Model
update message model =
    case message of
        FirstPlayer msg ->
            { model | player = Player.update msg model.player }



-- VIEW


view : Model -> Html Msg
view model =
    div [ containerStyle ]
        [ div
            [ mapStyle ]
            [ App.map FirstPlayer (Player.view model.player) ]
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
        ]
