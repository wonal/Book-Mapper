--{-# OPTIONS_GHC -F -pgmF hspec-discover -optF --module-name=Spec #-}
import Test.Hspec
import Control.Exception(evaluate)
import DatabaseUtils

main :: IO ()
main = hspec $ do
   describe "DatabaseUtils" $ do
     it "returns an empty db from an empty file" $ do
       writeFile "database.txt" ""
       createDatabase `shouldBe` ([]::IO Database)
