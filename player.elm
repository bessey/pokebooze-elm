module Player exposing (Model, Msg, init, update, view)

import Html exposing (Html, button, div, text, span)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, class)


-- MODEL


type alias Model =
    Int


init : Int -> Model
init position =
    position



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1



-- VIEW


view : Model -> Html Msg
view model =
    div [ playerStyle, class "player" ]
        [ span [] [ text (toString model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]



-- STYLES


playerStyle =
    style
        [ ( "background-color", "red" )
        , ( "width", "50px" )
        , ( "height", "50px" )
        ]
