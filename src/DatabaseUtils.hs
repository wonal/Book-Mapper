-- Copyright (c) 2018 Allison Wong
module DatabaseUtils where
import qualified Data.Char as C
--import qualified Data.List as D 
import qualified Data.HashMap.Strict as M 
import qualified Data.List.Split as L
import qualified Data.Set as S
import qualified Data.String.Utils as U  
--import System.IO 
import qualified LatLngUtils as LL

{- Assumes data stored in 'database.txt' is in format of "booktitle"%"booklocation"\n 
 - or booktitle%booklocation\n
-}

type Title = String
type Place = String
type Database = [(Title, Place)]
type CoordinatesDB = [(Title, [LL.CoordinateObj])]


createDatabase :: IO Database
createDatabase = do
                 contents <- readFile "database.txt"
                 if (not $ null contents) then do parseFile contents
                                          else return []

parseFile :: String -> IO Database
parseFile contents = do
                     let strings = (U.join "" $ U.split "\"" contents)
                     let entries = map (\x -> (x !! 0, x !! 1)) (map (L.splitOn "%") (lines $ map C.toLower strings))  
                     let unique_pairs = S.toList $ S.fromList entries 
                     return unique_pairs


createCoordinatesDB :: Database -> IO (M.HashMap String [LL.CoordinateObj])
createCoordinatesDB db = do
                         latlng <- mapM LL.getLatLng [snd entry | entry <- db] 
                         let formattedlatlng = map (:[]) latlng
                         let titlecoords = zip [fst entry | entry <- db] formattedlatlng
                         let cdb = M.fromListWith (++) titlecoords
                         return cdb



