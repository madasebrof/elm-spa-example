module A_Model exposing (Model(..), toSession)

import Article.Slug exposing (Slug)
import Page.Article as Article
import Page.Article.Editor as Editor
import Page.Home as Home
import Page.Login as Login
import Page.NotFound as NotFound
import Page.Profile as Profile
import Page.Register as Register
import Page.Settings as Settings
import Session exposing (Session)
import Username exposing (Username)


type Model
    = Redirect Session
    | NotFound Session
    | Home Home.Model
    | Settings Settings.Model
    | Login Login.Model
    | Register Register.Model
    | Profile Username Profile.Model
    | Article Article.Model
    | Editor (Maybe Slug) Editor.Model


toSession : Model -> Session
toSession page =
    case page of
        Redirect session ->
            session

        NotFound session ->
            session

        Home home ->
            Home.toSession home

        Settings settings ->
            Settings.toSession settings

        Login login ->
            Login.toSession login

        Register register ->
            Register.toSession register

        Profile _ profile ->
            Profile.toSession profile

        Article article ->
            Article.toSession article

        Editor _ editor ->
            Editor.toSession editor
