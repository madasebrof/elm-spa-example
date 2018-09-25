module G_View exposing (view)

import A_Model exposing (..)
import B_Message exposing (..)
import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Page exposing (Page)
import Page.Article as Article
import Page.Article.Editor as Editor
import Page.Blank as Blank
import Page.Home as Home
import Page.Login as Login
import Page.NotFound as NotFound
import Page.Profile as Profile
import Page.Register as Register
import Page.Settings as Settings
import Session exposing (Session)


view : Model -> Document Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view (Session.viewer (toSession model)) page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            viewPage Page.Other (\_ -> Ignored) Blank.view

        NotFound _ ->
            viewPage Page.Other (\_ -> Ignored) NotFound.view

        Settings settings ->
            viewPage Page.Other GotSettingsMsg (Settings.view settings)

        Home home ->
            viewPage Page.Home GotHomeMsg (Home.view home)

        Login login ->
            viewPage Page.Other GotLoginMsg (Login.view login)

        Register register ->
            viewPage Page.Other GotRegisterMsg (Register.view register)

        Profile username profile ->
            viewPage (Page.Profile username) GotProfileMsg (Profile.view profile)

        Article article ->
            viewPage Page.Other GotArticleMsg (Article.view article)

        Editor Nothing editor ->
            viewPage Page.NewArticle GotEditorMsg (Editor.view editor)

        Editor (Just _) editor ->
            viewPage Page.Other GotEditorMsg (Editor.view editor)
