module View.Page exposing (Page(..), view, viewErrors)

import Browser exposing (Document)
import Data.Api exposing (Cred)
import Data.Avatar
import Data.Viewer exposing (Viewer)
import Html exposing (Html, a, button, div, footer, i, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (class, classList, href, style)
import Html.Events exposing (onClick)
import Data.Profile
import Data.Route exposing (Route)
import Data.Session exposing (Session)
import Data.Username exposing (Username)


{-| Determines which navbar link (if any) will be rendered as active.

Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.

-}
type Page
    = Other
    | Home
    | Login
    | Register
    | Settings
    | Profile Username
    | NewArticle


{-| Take a page's Html and frames it with a header and footer.

The caller provides the current user, so we can display in either
"signed in" (rendering username) or "signed out" mode.

isLoading is for determining whether we should show a loading spinner
in the header. (This comes up during slow page transitions.)

-}
view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg
view maybeViewer page { title, content } =
    { title = title ++ " - Conduit"
    , body = viewHeader page maybeViewer :: content :: [ viewFooter ]
    }


viewHeader : Page -> Maybe Viewer -> Html msg
viewHeader page maybeViewer =
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Data.Route.href Data.Route.Home ]
                [ text "conduit" ]
            , ul [ class "nav navbar-nav pull-xs-right" ] <|
                navbarLink page Data.Route.Home [ text "Home" ]
                    :: viewMenu page maybeViewer
            ]
        ]


viewMenu : Page -> Maybe Viewer -> List (Html msg)
viewMenu page maybeViewer =
    let
        linkTo =
            navbarLink page
    in
    case maybeViewer of
        Just viewer ->
            let
                username =
                    Data.Viewer.username viewer

                avatar =
                    Data.Viewer.avatar viewer
            in
            [ linkTo Data.Route.NewArticle [ i [ class "ion-compose" ] [], text "\u{00A0}New Post" ]
            , linkTo Data.Route.Settings [ i [ class "ion-gear-a" ] [], text "\u{00A0}Settings" ]
            , linkTo
                (Data.Route.Profile username)
                [ img [ class "user-pic", Data.Avatar.src avatar ] []
                , Data.Username.toHtml username
                ]
            , linkTo Data.Route.Logout [ text "Sign out" ]
            ]

        Nothing ->
            [ linkTo Data.Route.Login [ text "Sign in" ]
            , linkTo Data.Route.Register [ text "Sign up" ]
            ]


viewFooter : Html msg
viewFooter =
    footer []
        [ div [ class "container" ]
            [ a [ class "logo-font", href "/" ] [ text "conduit" ]
            , span [ class "attribution" ]
                [ text "An interactive learning project from "
                , a [ href "https://thinkster.io" ] [ text "Thinkster" ]
                , text ". Code & design licensed under MIT."
                ]
            ]
        ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink page route linkContent =
    li [ classList [ ( "nav-item", True ), ( "active", isActive page route ) ] ]
        [ a [ class "nav-link", Data.Route.href route ] linkContent ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Data.Route.Home ) ->
            True

        ( Login, Data.Route.Login ) ->
            True

        ( Register, Data.Route.Register ) ->
            True

        ( Settings, Data.Route.Settings ) ->
            True

        ( Profile pageUsername, Data.Route.Profile routeUsername ) ->
            pageUsername == routeUsername

        ( NewArticle, Data.Route.NewArticle ) ->
            True

        _ ->
            False


{-| Render dismissable errors. We use this all over the place!
-}
viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    if List.isEmpty errors then
        Html.text ""

    else
        div
            [ class "error-messages"
            , style "position" "fixed"
            , style "top" "0"
            , style "background" "rgb(250, 250, 250)"
            , style "padding" "20px"
            , style "border" "1px solid"
            ]
        <|
            List.map (\error -> p [] [ text error ]) errors
                ++ [ button [ onClick dismissErrors ] [ text "Ok" ] ]
