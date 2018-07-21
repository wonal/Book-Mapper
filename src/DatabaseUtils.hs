-- Copyright (c) 2018 Allison Wong
module DatabaseUtils where
import qualified Data.Char as C
import qualified Data.List as D 
import qualified Data.Map as M 
import qualified Data.List.Split as L
import qualified Data.Set as S
import qualified Data.String.Utils as U  --cabal/stack install MissingH
import System.IO 

{- Assumes data stored in 'database.txt' is in format of "booktitle"%"booklocation";"booklocation"\n"
Database is in the form of [([char],[char])].
-}


createDatabase = do
            contents <- readFile "database.txt"
            if (not $ null contents) then do database contents
                                     else return [([],[])] 

database contents = do
                    let strings = (U.join "" $ U.split "\"" contents)
                    let parsed = map (L.splitOn "%") (lines $ map C.toLower strings)  
                    let dict = M.toList $ foldr (\x s -> M.insertWith (\a b -> a ++ ";" ++ b) (x !! 0) (x !! 1) s) M.empty parsed
                    return (map join dict)
                           where join (a,b) = (a, D.intercalate ";" $ S.toList $ S.fromList $ map (U.join ",") (map (map U.strip) ((map (L.splitOn ",") (L.splitOn ";" b)))))
