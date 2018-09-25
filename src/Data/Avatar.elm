module Data.Avatar exposing (Avatar, decoder, encode, src, toMaybeString)

import Data.Asset
import Html exposing (Attribute)
import Html.Attributes
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)



-- TYPES


type Avatar
    = Avatar (Maybe String)



-- CREATE


decoder : Decoder Avatar
decoder =
    Decode.map Avatar (Decode.nullable Decode.string)



-- TRANSFORM


encode : Avatar -> Value
encode (Avatar maybeUrl) =
    case maybeUrl of
        Just url ->
            Encode.string url

        Nothing ->
            Encode.null


src : Avatar -> Attribute msg
src (Avatar maybeUrl) =
    case maybeUrl of
        Nothing ->
            Data.Asset.src Data.Asset.defaultAvatar

        Just "" ->
            Data.Asset.src Data.Asset.defaultAvatar

        Just url ->
            Html.Attributes.src url


toMaybeString : Avatar -> Maybe String
toMaybeString (Avatar maybeUrl) =
    maybeUrl
