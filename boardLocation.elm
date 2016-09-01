module BoardLocation exposing (translatePosition, Point)

import Array exposing (..)


type alias Point =
    { x : Float
    , y : Float
    }


boardXOrigin =
    266.0


boardYOrigin =
    1950.0


cellHeight =
    187.75


cellWidth =
    cellHeight


translatePosition : Int -> Maybe Point
translatePosition position =
    if List.member position [0..8] then
        Just (Point boardXOrigin (boardYOrigin - (position * cellHeight)))
    else if List.member position [9..16] then
        Just (Point (boardXOrigin + ((position - 8) * cellWidth)) (boardYOrigin - (8 * cellHeight)))
    else
        Nothing
