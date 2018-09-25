module Main exposing (main)

import A_Model exposing (Model)
import B_Message exposing (Msg(..))
import C_Data exposing (..)
import D_Command exposing (subscriptions)
import Data.Api
import E_Init exposing (init)
import F_Update exposing (update)
import G_View exposing (view)
import Json.Decode as Decode exposing (Value)
import Viewer exposing (Viewer)



-- NOTE: Based on discussions around how asset management features
-- like code splitting and lazy loading have been shaping up, it's possible
-- that most of this file may become unnecessary in a future release of Elm.
-- Avoid putting things in this module unless there is no alternative!
-- See https://discourse.elm-lang.org/t/elm-spa-in-0-19/1800/2 for more.
-- MAIN


main : Program Value Model Msg
main =
    Data.Api.application Viewer.decoder
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
