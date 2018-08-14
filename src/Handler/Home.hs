{-} Copyright 2018 Allison Wong
 -  This project is licensed under the MIT license.  Full terms can be found at:
 -  https://github.com/wonal/Book-Mapper/blob/master/LICENSE.
 -  The code in this file was modified from the Yesod-Simple template, and was
 -  written with the help from the Yesod online book found at https://www.yesodweb.com/book, 
 -  specifically the "Basics", "Routing and Handlers", "Forms", and "Scaffolding and the Site" 
 -  chapters.  The Yesod book is licensed under the Creative Commons License, found at:
 -  https://creativecommons.org/licenses/by/4.0/, and the Yesod framework code is licensed under 
 -  the MIT license, which can be found at:
 -  https://github.com/yesodweb/yesod/blob/master/LICENSE.
 -}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import System.IO (appendFile)
import qualified Data.Char as C

{-}
- The handler for a GET request to the root URL: sets the title of the page 
- and calls the function 'widgetFile' which looks for 'home.hamlet', 'home.julius',
- and 'home.lucius' files and ultimately returns HTML
-}
getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Book-Mapper"
    $(widgetFile "home")

{-}
 - The handler for a GET request to the URL /bookmarker with query string of a book title.
 - Retrieves an associated coordinate pair if it exists in the database and returns it 
 - serialized
 -}
getBookMarkerR :: String -> Handler Value
getBookMarkerR bookName = do
    cdb <- liftIO $ readCoordinatesDB "Files/saved-database.json"
    returnJson $ CoordinateObject (retrieveCoordinates bookName cdb)


{-}
 - The handler for a GET request to the URL /input with query string of a book title and 
 - book location.  Checks to see if that pair already exists in the database, and if not
 - adds it to the textfile and coordinate database before returning a string message
 - for confirmation. 
-}
getInputR :: String -> String -> Handler String
getInputR name setting = do
    coordinate <- liftIO $ getLatLng setting
    cdb <- liftIO $ readCoordinatesDB "Files/saved-database.json"
    let lowername = map C.toLower name
    let latlngresults = retrieveCoordinates lowername cdb 
    let message = "'" ++ name ++ "' with a location of '" ++ setting ++ 
             "' has been added to the database.  Thanks!"
    if (coordinate `elem` latlngresults) then return message
                                   else do
                                        liftIO $ appendFile "Files/database.txt" (name ++ "%" ++ setting ++ "\n")
                                        let updated = insertWith (++) lowername [coordinate] cdb 
                                        liftIO $ saveCoordinatesDB updated "Files/saved-database.json"
                                        return message


