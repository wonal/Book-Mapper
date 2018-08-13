-- Copyright (c) 2018 Allison Wong
-- This program is licensed under the MIT license.  Full terms can be found at:
-- https://github.com/wonal/Book-Mapper/blob/master/LICENSE.
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module LatLngUtils where

import Data.Aeson 
import GHC.Generics
import qualified Data.Text as T
import Data.Aeson (decode) 
import qualified Network.HTTP.Conduit as H

data CoordinateObject = CoordinateObject 
    {  coordinates :: [Coordinate]
    } deriving (Eq, Show, Generic)

data Coordinate = Coordinate 
    {  lat :: Double
    ,  lng :: Double 
    } deriving (Eq, Show, Generic)

data CDB = CDB 
    {  entries :: [BookInfo]
    } deriving (Eq, Show, Generic)

data BookInfo = BookInfo
    {  title      :: T.Text
    ,  locations  :: [Coordinate]
    } deriving (Eq, Show, Generic)

data QueryResult = QueryResult
    {  results :: [Results]
    ,  status  :: T.Text
    } deriving (Eq, Show, Generic)

data Results = Results
    {   address_components :: [AddressComponents]
    ,   formatted_address  :: T.Text
    ,   geometry           :: Geometry
    ,   partial_match      :: Maybe Bool
    ,   place_id           :: T.Text
    ,   types              :: [T.Text]
    } deriving (Eq, Show)

data AddressComponents = AddressComponents
    {   long_name  :: T.Text
    ,   short_name :: T.Text
    ,   atypes     :: [T.Text]
    } deriving (Eq, Show)

data Geometry = Geometry
    {   bounds        :: Maybe Bounds
    ,   location      :: Location
    ,   location_type :: T.Text
    ,   viewport      :: Bounds
    } deriving (Eq, Show)

data Bounds = Bounds
    {   northeast :: Location 
    ,   southwest :: Location
    } deriving (Eq, Show, Generic)

data Location = Location
    {   latitude :: Double
    ,   longitude :: Double
    } deriving (Show, Eq)

instance FromJSON Bounds
instance FromJSON QueryResult

instance FromJSON Coordinate 
instance ToJSON Coordinate where 
    toEncoding = genericToEncoding defaultOptions
instance FromJSON CDB 
instance ToJSON CDB where 
    toEncoding = genericToEncoding defaultOptions
instance FromJSON BookInfo 
instance ToJSON BookInfo where 
    toEncoding = genericToEncoding defaultOptions
instance FromJSON CoordinateObject 
instance ToJSON CoordinateObject where
    toEncoding = genericToEncoding defaultOptions

{-} The FromJSON instance methods below were implemented with the help of a School of Haskell tutorial 
written by Alfredo DiNapoli, titled "Episode 1 - JSON", found here: 
https://www.schoolofhaskell.com/school/to-infinity-and-beyond/pick-of-the-week/episode-1-json" -}
instance FromJSON AddressComponents where
    parseJSON (Object v) = AddressComponents 
                          <$> v .:  "long_name" 
                          <*> v .:  "short_name" 
                          <*> v .:  "types"
    parseJSON _    = fail "AddressComponents is an invalid type"

instance FromJSON Results where
    parseJSON (Object v) = Results
                          <$> v .:  "address_components"
                          <*> v .:  "formatted_address"
                          <*> v .:  "geometry"
                          <*> v .:? "partial_match"
                          <*> v .:  "place_id"
                          <*> v .:  "types"
    parseJSON _    = fail "Results is an invalid type"

instance FromJSON Geometry where
    parseJSON (Object v) = Geometry
                          <$> v .:? "bounds"
                          <*> v .:  "location"
                          <*> v .:  "location_type"
                          <*> v .:  "viewport"
    parseJSON _    = fail "Geometry is an invalid type"

instance FromJSON Location where
    parseJSON (Object v) = Location 
                          <$> v .: "lat"
                          <*> v .: "lng"
    parseJSON _    = fail "Location is an invalid type"


getLatLng :: String -> IO Coordinate
getLatLng string = do
    json_obj <- (getJSON string)
    return $ case json_obj of 
                  Nothing -> Coordinate {lat = 0.0, lng = 0.0}
                  Just x  -> if (null $ results x) then Coordinate {lat = 0.0, lng = 0.0}
                                                   else Coordinate {lat = latitude $ location $ geometry $ head $ results x, lng = longitude $ location $ geometry $ head $ results x}


{-} getJSON implemented with the help of a tutorial from the School of Haskell website on Parsing JSON with Aeson, found
here: https://www.schoolofhaskell.com/school/starting-with-haskell/libraries-and-frameworks/text-manipulation/json
under the Application: Rate exchange JSON API example." -}
getJSON :: String -> IO (Maybe QueryResult)
getJSON place = do
    apiKey <- readApiKey
    fmap decode $ H.simpleHttp $ "https://maps.googleapis.com/maps/api/geocode/json?address=" ++ place ++ "&key=" ++ apiKey


readApiKey :: IO String
readApiKey = do
    contents <- readFile "Files/APIkey.txt"
    return contents
