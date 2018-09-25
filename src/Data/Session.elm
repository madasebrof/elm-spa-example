module Data.Session exposing (Session, changes, cred, fromViewer, navKey, viewer)

import Browser.Navigation as Nav
import Data.Api exposing (Cred)
import Data.Avatar exposing (Avatar)
import Data.Profile exposing (Profile)
import Data.Viewer exposing (Viewer)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, required)
import Json.Encode as Encode exposing (Value)
import Time



-- TYPES


type Session
    = LoggedIn Nav.Key Viewer
    | Guest Nav.Key



-- INFO


viewer : Session -> Maybe Viewer
viewer session =
    case session of
        LoggedIn _ val ->
            Just val

        Guest _ ->
            Nothing


cred : Session -> Maybe Cred
cred session =
    case session of
        LoggedIn _ val ->
            Just (Data.Viewer.cred val)

        Guest _ ->
            Nothing


navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn key _ ->
            key

        Guest key ->
            key



-- CHANGES


changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    Data.Api.viewerChanges (\maybeViewer -> toMsg (fromViewer key maybeViewer)) Data.Viewer.decoder


fromViewer : Nav.Key -> Maybe Viewer -> Session
fromViewer key maybeViewer =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    case maybeViewer of
        Just viewerVal ->
            LoggedIn key viewerVal

        Nothing ->
            Guest key
