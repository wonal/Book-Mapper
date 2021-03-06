--  Copyright (c) 2018 Allison Wong
--  This program is licensed under the MIT license.  Full terms can be found at:
--  https://github.com/wonal/Book-Mapper/blob/master/LICENSE.
  

module DatabaseUtils where
import qualified Data.Char as C
import qualified Data.HashMap.Strict as M 
import qualified Data.List.Split as L
import qualified Data.Set as S
import qualified Data.String.Utils as U  
import qualified LatLngUtils as LL
import Data.Aeson (encode, decode)
import qualified Data.ByteString.Lazy as D
import Data.Text(pack, unpack)

type Title = String
type Place = String
type Database = [(Title, Place)]
type CoordinatesDB = [(String, [LL.Coordinate])]


{-}
 - Creates a 'database' of book titles and their corresponding locations from 
 - the textfile 'database.txt'.
 -}
createDatabase :: String -> IO Database 
createDatabase filename = do
                 contents <- readFile filename 
                 if (not $ null contents) then do parseFile contents
                                          else return []


parseFile :: String -> IO Database
parseFile contents = do
                     let strings = (U.join "" $ U.split "\"" contents)
                     let entries = map (\x -> (x !! 0, x !! 1)) (map (L.splitOn "%") (lines $ map C.toLower strings))  
                     let unique_pairs = S.toList $ S.fromList entries 
                     return unique_pairs


-- Creates a coordinates database of book titles and the coordinate pairs of the book location(s).  
createCoordinatesDB :: Database -> IO (M.HashMap String [LL.Coordinate])
createCoordinatesDB db = do
                         latlng <- mapM LL.getLatLng [snd entry | entry <- db] 
                         let formattedlatlng = map (:[]) latlng
                         let titlecoords = zip [fst entry | entry <- db] formattedlatlng
                         let cdb = M.fromListWith (++) titlecoords
                         return cdb


-- Returns a list of coordinate pairs for a book title key
retrieveCoordinates :: String -> M.HashMap String [LL.Coordinate] -> [LL.Coordinate]
retrieveCoordinates key cdb = case M.lookup (map C.toLower key) cdb of
                                   Nothing -> []
                                   Just c  -> c


-- Saves a coordinate database to a file in json format
saveCoordinatesDB :: M.HashMap String [LL.Coordinate] -> String -> IO ()
saveCoordinatesDB coordinatesdb filename = do
                                           let list = M.toList coordinatesdb
                                           let jsonobj = LL.CDB [LL.BookInfo (pack $ fst x) (snd x) | x <- list]
                                           D.writeFile filename (encode jsonobj)


-- Reads in a coordinate database from json format into a hashmap 
readCoordinatesDB :: String -> IO (M.HashMap String [LL.Coordinate])
readCoordinatesDB filename = do
                             bytes <- D.readFile filename 
                             return (decodeBytes bytes)


decodeBytes :: D.ByteString -> M.HashMap String [LL.Coordinate]
decodeBytes bs = case decode bs of
                      Nothing -> M.empty
                      Just x  -> M.fromListWith (++) [(unpack $ LL.title y, LL.locations y) | y <- LL.entries x]


