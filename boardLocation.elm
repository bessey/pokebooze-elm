module BoardLocation exposing (translatePosition, Point)

import Array exposing (..)


type alias Point =
    { x : Int
    , y : Int
    }


translatePosition : Int -> Maybe Point
translatePosition position =
    let
        points =
            fromList
                [ -- UP
                  Point 266 1950
                , Point 266 1764
                , Point 266 1578
                , Point 266 1392
                , Point 266 1206
                , Point 266 1020
                , Point 266 834
                , Point 266 648
                , Point 266 462
                  -- ACCROSS
                , Point 266 285
                , Point 452 285
                , Point 638 285
                , Point 824 285
                , Point 1010 285
                , Point 1196 285
                , Point 1382 285
                , Point 1568 285
                , Point 1754 285
                ]
    in
        Array.get position points
