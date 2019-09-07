module Helpers.Math exposing (ceiling)

ceiling : Int -> Int -> Int
ceiling value maxValue = 
    if value < maxValue then
        value

    else 
        maxValue