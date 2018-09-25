module E_Init exposing (init)

import A_Model exposing (..)
import B_Message exposing (..)
import Browser.Navigation as Nav
import D_Command exposing (changeRouteTo)
import Data.Route exposing (Route)
import Data.Session exposing (Session)
import Data.Viewer exposing (Viewer)
import Url exposing (Url)


init : Maybe Viewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeViewer url navKey =
    changeRouteTo (Data.Route.fromUrl url)
        (Redirect (Data.Session.fromViewer navKey maybeViewer))
