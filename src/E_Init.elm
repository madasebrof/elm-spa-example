module E_Init exposing (init)

import A_Model exposing (..)
import B_Message exposing (..)
import Browser.Navigation as Nav
import D_Command exposing (changeRouteTo)
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)
import Viewer exposing (Viewer)


init : Maybe Viewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeViewer url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromViewer navKey maybeViewer))
