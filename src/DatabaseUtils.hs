--  Copyright (c) 2018 Allison Wong
--  This program is licensed under the MIT license.  Full terms can be found at:
--  https://github.com/wonal/Book-Mapper/blob/master/LICENSE.
  

module DatabaseUtils where
import qualified Data.Char as C
--import qualified Data.List as D 
import qualified Data.HashMap.Strict as M 
import qualified Data.List.Split as L
import qualified Data.Set as S
import qualified Data.String.Utils as U  
import qualified LatLngUtils as LL
--import Data.Aeson (encode)
--import qualified Data.ByteString.Lazy.Char8 as D

type Title = String
type Place = String
type Database = [(Title, Place)]
type CoordinatesDB = [(Title, [LL.Coordinate])]


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


createCoordinatesDB :: Database -> IO (M.HashMap String [LL.Coordinate])
createCoordinatesDB db = do
                         latlng <- mapM LL.getLatLng [snd entry | entry <- db] 
                         let formattedlatlng = map (:[]) latlng
                         let titlecoords = zip [fst entry | entry <- db] formattedlatlng
                         let cdb = M.fromListWith (++) titlecoords
                         return cdb

retrieveCoordinates :: String -> M.HashMap String [LL.Coordinate] -> [LL.Coordinate]
retrieveCoordinates key cdb = case M.lookup (map C.toLower key) cdb of
                                   Nothing -> []
                                   Just c  -> c

--main :: IO ()
--main = do
--    db <- createDatabase "database.txt" 
--    cdb <- createCoordinatesDB []
--    putStrLn (show cdb)
    -- let ccs = retrieveCoordinates "astoria" cdb 
    -- D.putStrLn $ encode $ LL.CoordinateObject ccs