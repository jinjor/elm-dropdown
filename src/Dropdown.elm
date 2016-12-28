module Dropdown exposing
  ( Dropdown
  , Msg
  , Fit(..)
  , init
  , update
  , view
  , subscriptions
  )


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Mouse
import Json.Decode as Decode


type Msg
  = Open
  | Close
  | Enter
  | Leave


type Dropdown =
  Dropdown
    { open : Bool
    , entering : Bool
    }


init : Dropdown
init =
  Dropdown { open = False, entering = False }


update : Msg -> Dropdown -> Dropdown
update msg (Dropdown model) =
  case msg of
    Open ->
      Dropdown { model | open = True }

    Close ->
      Dropdown { model | open = False }

    Enter ->
      Dropdown { model | entering = True }

    Leave ->
      Dropdown { model | entering = False }


subscriptions : Dropdown -> Sub Msg
subscriptions (Dropdown model) =
  if model.open && not model.entering then
    Mouse.clicks (always Close)
  else
    Sub.none


type alias Config msg =
  { transform : Msg -> msg
  , fitTo : Fit
  }


type Fit = Left | Right | Both


view : Config msg -> List (Attribute msg) -> (Bool -> Html msg) -> Html msg -> Dropdown -> Html msg
view config attributes button menu (Dropdown model) =
  let
    button_ =
      div [ onClick (config.transform Open) ] [ button model.open ]

    (left, right) =
      case config.fitTo of
        Left -> (True, False)
        Right -> (False, True)
        Both -> (True, True)

    menu_ =
      if model.open then
        div
          [ style (menuStyle 3 left right)
          , onClick (config.transform Close)
          ]
          [ menu ]
      else
        text ""
  in
    div
      ( attributes ++
        [ style containerStyle
        , onMouseEnter Enter |> Html.Attributes.map config.transform
        , onMouseLeave Leave |> Html.Attributes.map config.transform
        ]
      )
      [ button_
      , menu_
      ]


containerStyle : List (String, String)
containerStyle =
  [ ("position", "relative")
  ]


menuStyle : Int -> Bool -> Bool -> List (String, String)
menuStyle margin left right =
  [ ("position", "absolute")
  , ("left", if left then "0" else "")
  , ("right", if right then "0" else "")
  , ("margin-top", px margin)
  ]


px : number -> String
px n =
  toString n ++ "px"
