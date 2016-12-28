import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dropdown


main =
  program
    { init = model ! []
    , view = view
    , update = \msg model -> update msg model ! []
    , subscriptions = subscriptions
    }


model =
  { dropdown = Dropdown.init
  }


type Msg
  = DropdownMsg Dropdown.Msg
  | Select


update msg model =
  case msg of
    DropdownMsg msg ->
      { model | dropdown = Dropdown.update msg model.dropdown }

    Select ->
      Debug.log "select" model


subscriptions model =
  Dropdown.subscriptions model.dropdown |> Sub.map DropdownMsg


view model =
  div []
    [ Dropdown.view
      { transform = DropdownMsg
      , fitTo = Dropdown.Right
      }
      [ style containerStyle ]
      button
      menu
      model.dropdown
    , div []
        [ text "next next next next next next next next next next next"
        , br [] []
        , text "next next next next next next next next next next next"
        , br [] []
        , text "next next next next next next next next next next next"
        , br [] []
        , text "next next next next next next next next next next next"
        , br [] []
        , text "next next next next next next next next next next next"
        , br [] []
        ]
    ]


button opened =
  div [ style buttonStyle ] [ text (toString opened) ]


menu =
  div [ style menuStyle, onClick Select ] [ text "Menu" ]


containerStyle =
  [ ("margin-left", "auto")
  , ("margin-right", "auto")
  , ("width", "120px")
  ]


buttonStyle =
  [ ("width", "120px")
  , ("height", "30px")
  , ("line-height", "30px")
  , ("text-align", "center")
  , ("background", "skyblue")
  ]


menuStyle =
  [ ("width", "200px")
  , ("height", "120px")
  , ("border", "solid 1px #aaa")
  , ("background-color", "white")
  ]
