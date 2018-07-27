module Main where

import Bookmap
import LatLngUtils
import DatabaseUtils
import Yesod

main :: IO ()
main = warp 3000 BookMapper

{-
main = do
       result <- getLatLng "Portland,OR" 
       putStrLn $ show result
main = do
       db <- createDatabase
       cdb <- createCoordinatesDB db
       putStrLn $ show cdb
-}
