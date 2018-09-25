module View.Loading exposing (error, icon, slowThreshold)

{-| A loading spinner icon.
-}

import Data.Asset
import Html exposing (Attribute, Html)
import Html.Attributes exposing (alt, height, src, width)
import Process
import Task exposing (Task)


icon : Html msg
icon =
    Html.img
        [ Data.Asset.src Data.Asset.loading
        , width 64
        , height 64
        , alt "View.Loading..."
        ]
        []


error : String -> Html msg
error str =
    Html.text ("Error loading " ++ str ++ ".")


slowThreshold : Task x ()
slowThreshold =
    Process.sleep 500
