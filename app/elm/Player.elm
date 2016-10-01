module Player exposing (Model, Msg(..), init, update, view)

import Html exposing (Html, button, div, text, span)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, class)
import Animation exposing (px, top, left)
import Time exposing (second)
import BoardLocation


-- MODEL


type alias Model =
    { id : Int
    , position : Int
    , style : Animation.State
    }


init : Int -> Int -> Model
init id position =
    Model
        id
        position
        (Animation.style (positionStyle position))



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
                    , style = animateToNewPosition model.position newPosition model.style
                }



-- VIEW


view : Model -> Html Msg
view model =
    div
        (Animation.render
            model.style
            ++ [ class ("player" ++ " player-" ++ toString (model.id + 1))
               ]
        )
        [ span [] [ text (toString (model.id + 1)) ]
        ]



-- THE REST


animateToNewPosition position newPosition style =
    Animation.queue
        (List.concatMap
            (\position ->
                [ Animation.to (positionStyle position)
                , Animation.wait (0.25 * second)
                ]
            )
            [(position + 1)..newPosition]
        )
        style


positionStyle position =
    let
        point =
            BoardLocation.translatePosition position
    in
        [ left (px point.x)
        , top (px (point.y - 50.0))
        ]
