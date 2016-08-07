module Player exposing (Model, Msg, init, update, view, subscriptions)

import Html exposing (Html, button, div, text, span)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, class)
import AnimationFrame
import Style
import Style.Properties exposing (..)


-- MODEL


type alias Model =
    { position : Int
    , style : Style.Animation
    }



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Animate Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            let
                newPosition =
                    model.position + 1
            in
                ( { model
                    | position = newPosition
                    , style =
                        Style.animate
                            |> Style.to [ positionStyle newPosition ]
                            |> Style.on model.style
                  }
                , Cmd.none
                )

        Decrement ->
            let
                newPosition =
                    model.position - 1
            in
                ( { model
                    | position = newPosition
                    , style =
                        Style.animate
                            |> Style.to [ positionStyle newPosition ]
                            |> Style.on model.style
                  }
                , Cmd.none
                )

        Animate time ->
            ( { model
                | style = Style.tick time model.style
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ playerStyle model
        , class "player"
        ]
        [ span [] [ text (toString model.position) ]
        , button [ onClick Increment ] [ text "+" ]
        ]



-- STYLES


playerStyle model =
    style
        ([ ( "background-color", "red" )
         , ( "width", "50px" )
         , ( "height", "50px" )
         , ( "position", "absolute" )
         ]
            ++ (Style.render model.style)
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.times Animate



-- THE REST


init : Int -> ( Model, Cmd Msg )
init position =
    ( { position = position
      , style =
            Style.init [ positionStyle position ]
      }
    , Cmd.none
    )


positionStyle position =
    let
        positionFloat =
            toFloat position
    in
        Left (positionFloat * 30) Px
