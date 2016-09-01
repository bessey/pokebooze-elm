module Player exposing (Model, Msg(..), init, update, view)

import Html exposing (Html, button, div, text, span)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, class)
import Style
import Style.Properties exposing (..)
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
                    | position = (Debug.log (toString newPosition) newPosition)
                    , style =
                        Style.animate
                            |> Style.to (positionStyle newPosition)
                            |> Style.on model.style
                }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ playerStyle model
        , class "player"
        ]
        [ span [] [ text (toString model.position) ]
        ]



-- STYLES


playerStyle model =
    let
        color =
            if model.id == 0 then
                "red"
            else
                "blue"
    in
        style
            ([ ( "background-color", color )
             , ( "color", "white" )
             , ( "width", "50px" )
             , ( "height", "50px" )
             , ( "position", "absolute" )
             ]
                ++ (Style.render model.style)
            )



-- THE REST


positionStyle position =
    case BoardLocation.translatePosition position of
        Just point ->
            [ Left (point.x + 50.0) Px
            , Top (point.y - 50.0) Px
            ]

        _ ->
            Debug.crash "Incorrect position, shouldn't happen" Left 0.0 Px
