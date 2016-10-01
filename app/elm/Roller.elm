module Roller exposing (Model, Msg(..), update, view, init)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, class)
import Random


diceSize =
    6



-- MODEL


type alias Model =
    { dieFace : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 1, Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.int 1 diceSize) )

        NewFace newFace ->
            ( Model newFace, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ style [ ( "position", "fixed" ) ] ]
        [ button [ onClick Roll ] [ text "Roll" ]
        ]
