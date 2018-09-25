module B_Message exposing (Msg(..))

import Browser
import Page.Article as Article
import Page.Article.Editor as Editor
import Page.Home as Home
import Page.Login as Login
import Page.Profile as Profile
import Page.Register as Register
import Page.Settings as Settings
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)


type Msg
    = Ignored
    | ChangedRoute (Maybe Route)
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | GotHomeMsg Home.Msg
    | GotSettingsMsg Settings.Msg
    | GotLoginMsg Login.Msg
    | GotRegisterMsg Register.Msg
    | GotProfileMsg Profile.Msg
    | GotArticleMsg Article.Msg
    | GotEditorMsg Editor.Msg
    | GotSession Session
