module BoardLocation exposing (translatePosition, Point)

import List exposing (foldl, take, repeat)


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


cellDirections =
    repeat 8 "↑"
        ++ repeat 8 "→"
        ++ repeat 8 "↓"
        ++ repeat 7 "←"
        ++ repeat 7 "↑"
        ++ repeat 6 "→"
        ++ repeat 6 "↓"
        ++ repeat 5 "←"
        ++ repeat 5 "↑"
        ++ repeat 4 "→"
        ++ repeat 4 "↓"
        ++ repeat 3 "←"


translatePosition : Int -> Point
translatePosition position =
    take position cellDirections
        |> foldl addDirection (Point boardXOrigin boardYOrigin)


addDirection : String -> Point -> Point
addDirection nextDirection currentPosition =
    case nextDirection of
        "↑" ->
            { currentPosition | y = currentPosition.y - cellHeight }

        "→" ->
            { currentPosition | x = currentPosition.x + cellWidth }

        "↓" ->
            { currentPosition | y = currentPosition.y + cellHeight }

        "←" ->
            { currentPosition | x = currentPosition.x - cellWidth }

        _ ->
            Debug.crash "what the fuck did you do" currentPosition
