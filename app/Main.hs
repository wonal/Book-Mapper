module Main where

import Bookmap
import LatLngUtils
import Yesod

main :: IO ()
main = warp 3000 BookMapper

{-
main = do
       result <- getLatLng "Portland,OR" 
       putStrLn $ show result
-}
