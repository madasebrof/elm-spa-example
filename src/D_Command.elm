module D_Command exposing (changeRouteTo, subscriptions, updateWith)

import A_Model exposing (..)
import B_Message exposing (..)
import Data.Api
import Data.Route exposing (Route)
import Data.Session exposing (Session)
import Page.Article as Article
import Page.Article.Editor as Editor
import Page.Home as Home
import Page.Login as Login
import Page.NotFound as NotFound
import Page.Profile as Profile
import Page.Register as Register
import Page.Settings as Settings


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        NotFound _ ->
            Sub.none

        Redirect _ ->
            Data.Session.changes GotSession (Data.Session.navKey (toSession model))

        Settings settings ->
            Sub.map GotSettingsMsg (Settings.subscriptions settings)

        Home home ->
            Sub.map GotHomeMsg (Home.subscriptions home)

        Login login ->
            Sub.map GotLoginMsg (Login.subscriptions login)

        Register register ->
            Sub.map GotRegisterMsg (Register.subscriptions register)

        Profile _ profile ->
            Sub.map GotProfileMsg (Profile.subscriptions profile)

        Article article ->
            Sub.map GotArticleMsg (Article.subscriptions article)

        Editor _ editor ->
            Sub.map GotEditorMsg (Editor.subscriptions editor)


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Data.Route.Root ->
            ( model, Data.Route.replaceUrl (Data.Session.navKey session) Data.Route.Home )

        Just Data.Route.Logout ->
            ( model, Data.Api.logout )

        Just Data.Route.NewArticle ->
            Editor.initNew session
                |> updateWith (Editor Nothing) GotEditorMsg model

        Just (Data.Route.EditArticle slug) ->
            Editor.initEdit session slug
                |> updateWith (Editor (Just slug)) GotEditorMsg model

        Just Data.Route.Settings ->
            Settings.init session
                |> updateWith Settings GotSettingsMsg model

        Just Data.Route.Home ->
            Home.init session
                |> updateWith Home GotHomeMsg model

        Just Data.Route.Login ->
            Login.init session
                |> updateWith Login GotLoginMsg model

        Just Data.Route.Register ->
            Register.init session
                |> updateWith Register GotRegisterMsg model

        Just (Data.Route.Profile username) ->
            Profile.init session username
                |> updateWith (Profile username) GotProfileMsg model

        Just (Data.Route.Article slug) ->
            Article.init session slug
                |> updateWith Article GotArticleMsg model


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )
