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
import DatabaseUtils
import qualified LatLngUtils as LL

testfile :: String
testfile = "test-database.txt"

main :: IO ()
main = hspec $ do
   describe "DatabaseUtils" $ do
     it "returns an empty db from an empty file" $ do
       writeFile testfile ""
       db <- createDatabase testfile
       db `shouldBe` ([]::Database)

     it "returns a 'database' with a single entry from a file with a single entry" $ do
       appendFile testfile ("BookTitle%Portland, OR\n")
       db <- createDatabase testfile
       db !! 0 `shouldBe` (("booktitle","portland, or")::(Title,Place))

     it "returns a single entry from a file of duplicates" $ do
       appendFile testfile ("BookTitle%Portland, OR\n")
       appendFile testfile ("BookTitle%Portland, OR\n")
       db <- createDatabase testfile
       length db `shouldBe` (1::Int)

     it "returns an empty list of coordinates when looking up a book not in the database" $ do
       db <- createDatabase testfile
       cdb <- createCoordinatesDB db 
       let coordinates = retrieveCoordinates "ADifferentBook" cdb 
       coordinates `shouldBe` ([]::[LL.Coordinate])

     it "returns the coordinates of the Portland, OR when looking up a single mapping" $ do
       db <- createDatabase testfile
       cdb <- createCoordinatesDB db 
       let coordinates = retrieveCoordinates "BookTitle" cdb 
       coordinates `shouldBe` ([LL.Coordinate {LL.lat = 45.5122308, LL.lng = -122.6587185}]::[LL.Coordinate])

     it "returns the coordinates of the Portland and Vancouver after adding an additional mapping for the same book" $ do
       appendFile testfile ("BookTitle%Tokyo, Japan\n")
       db <- createDatabase testfile
       cdb <- createCoordinatesDB db 
       let coordinates = retrieveCoordinates "BookTitle" cdb 
       coordinates `shouldBe` ([LL.Coordinate {LL.lat = 35.6894875, LL.lng = 139.6917064}, LL.Coordinate {LL.lat = 45.5122308, LL.lng = -122.6587185}]::[LL.Coordinate])

     it "returns an invalid coordinate for an invalid location" $ do
       writeFile testfile ""
       appendFile testfile ("BookTitle%asdofijowieasdjfaio\n")
       db <- createDatabase testfile
       cdb <- createCoordinatesDB db 
       let coordinates = retrieveCoordinates "BookTitle" cdb 
       coordinates `shouldBe` ([LL.Coordinate {LL.lat = 0.0, LL.lng = 0.0}]::[LL.Coordinate])

     it "returns a valid coordinate despite the title having one invalid mapping" $ do
       appendFile testfile ("BookTitle%Portland, OR\n")
       db <- createDatabase testfile
       cdb <- createCoordinatesDB db 
       let coordinates = retrieveCoordinates "BookTitle" cdb 
       coordinates `shouldBe` ([LL.Coordinate {LL.lat = 45.5122308, LL.lng = -122.6587185}, LL.Coordinate {LL.lat = 0.0, LL.lng = 0.0}]::[LL.Coordinate])