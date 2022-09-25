module ExtractCssTest exposing (all)

import ExtractCss exposing (rule)
import Review.Test
import Test exposing (Test, describe, test)


extractorModule : String
extractorModule =
    """module StubCssGenerator exposing (..)

import Css exposing (Style)

generatedCssListHere____THIS_IS_MY_SPECIAL_CODE : String
generatedCssListHere____THIS_IS_MY_SPECIAL_CODE =
   ""
"""


all : Test
all =
    describe "ExtractCss"
        [ test "should report an error when REPLACEME" <|
            \() ->
                [ """module A exposing (..)

import Css
import Html as H exposing (Html)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)


view =
    div
        [ Html.Styled.Attributes.css
            [ Css.backgroundColor (Css.hex "#ff375a")
            , Css.color (Css.hex "#ffffff")
            ]
        ]
        []
"""
                , extractorModule
                ]
                    |> Review.Test.runOnModules rule
                    |> Review.Test.expectErrorsForModules
                        [ ( "StubCssGenerator"
                          , [ Review.Test.error
                                { message = "TODO"
                                , details = [ "" ]
                                , under = "\"\""
                                }
                                |> Review.Test.whenFixed
                                    """module StubCssGenerator exposing (..)

import Css exposing (Style)

generatedCssListHere____THIS_IS_MY_SPECIAL_CODE : String
generatedCssListHere____THIS_IS_MY_SPECIAL_CODE =
   "import Css\\n\\nclasses = [ [ Css.backgroundColor (Css.hex \\"#ff375a\\"), Css.color (Css.hex \\"#ffffff\\") ] ]"

"""
                            ]
                          )
                        , ( "A"
                          , [ Review.Test.error
                                { message = "Temp"
                                , details = [ "" ]
                                , under =
                                    --"""Css.backgroundColor (Css.hex "#ff375a")"""
                                    """Html.Styled.Attributes.css
            [ Css.backgroundColor (Css.hex "#ff375a")
            , Css.color (Css.hex "#ffffff")
            ]"""
                                }
                                |> Review.Test.whenFixed
                                    """module A exposing (..)

import Css
import Html as H exposing (Html)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)


view =
    div
        [ Html.Styled.Attributes.css
            [ (Css.batch [])
            , (Css.batch [])
            ]
        ]
        []
"""
                            , Review.Test.error
                                { message = "Temp"
                                , details = [ "" ]
                                , under =
                                    """Html.Styled.Attributes.css
            [ Css.backgroundColor (Css.hex "#ff375a")
            , Css.color (Css.hex "#ffffff")
            ]"""
                                }
                                |> Review.Test.whenFixed
                                    """module A exposing (..)

import Css
import Html as H exposing (Html)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)


view =
    div
        [ Html.Styled.Attributes.css
            [ (Css.batch [])
            , (Css.batch [])
            ]
        ]
        []
"""
                            ]
                          )
                        ]
        ]
