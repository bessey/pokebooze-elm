module Player exposing (Model, Msg(..), init, update, view)

import Html exposing (Html, button, div, text, span)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, class)
import Style
import Style.Properties exposing (..)
import Time exposing (second)
import BoardLocation


-- MODEL


type alias Model =
    { id : Int
    , position : Int
    , style : Style.Animation
    }


init : Int -> Int -> Model
init id position =
    Model
        id
        position
        (Style.init (positionStyle position))



-- UPDATE


type Msg
    = Move Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Move positions ->
            let
                newPosition =
                    model.position + positions
            in
                { model
                    | position = newPosition
                    , style =
                        Style.animate
                            |> animateToNewPosition model.position newPosition
                            |> Style.on model.style
                }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ style (Style.render model.style)
        , class ("player" ++ " player-" ++ toString (model.id + 1))
        ]
        [ span [] [ text (toString model.position) ]
        ]



-- THE REST


animateToNewPosition position newPosition style =
    let
        initialStyle =
            Style.to (positionStyle position) style
                |> Style.andThen
    in
        List.foldl
            (\position styles ->
                styles
                    |> Style.to (positionStyle position)
                    |> Style.duration (0.25 * second)
                    |> Style.andThen
            )
            initialStyle
            [(position + 1)..newPosition]


positionStyle position =
    let
        point =
            BoardLocation.translatePosition position
    in
        [ Left (point.x + 50.0) Px
        , Top (point.y - 50.0) Px
        ]
