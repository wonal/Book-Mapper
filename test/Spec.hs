{-} Copyright 2018 Allison Wong
 -  This program is licensed under the MIT license.  Full terms can be found at:
 -  https://github.com/wonal/Book-Mapper/blob/master/LICENSE.
 -  The code in this file was modified from the Yesod-Simple Stack template.
 -  More information can be found by the command: stack templates
 -  or consulting the Yesod book online.  The Yesod framework is licensed under
 -  the MIT license, and further information can be found at:
 -  https://github.com/yesodweb/yesod/blob/master/LICENSE.  
 -}
--{-# OPTIONS_GHC -F -pgmF hspec-discover -optF --module-name=Spec #-}
import Test.Hspec
import Control.Exception(evaluate)
import DatabaseUtils

main :: IO ()
main = hspec $ do
   describe "DatabaseUtils" $ do
     it "returns an empty db from an empty file" $ do
       writeFile "database.txt" ""
       db <- createDatabase
       db `shouldBe` ([]::Database)
