{-} Copyright 2018 Allison Wong
 -  This program is licensed under the MIT license.  Full terms can be found at:
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
--import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
import System.IO (appendFile)

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Book-Mapper"
    $(widgetFile "home")

getBookMarkerR :: String -> Handler Value
getBookMarkerR bookName = do
    --db <- liftIO $ createDatabase "Files/database.txt"
    --cdb <- liftIO $ createCoordinatesDB db
    cdb <- liftIO $ readCoordinatesDB "Files/saved-database.json"
    returnJson $ CoordinateObject (retrieveCoordinates bookName cdb)

getInputR :: String -> String -> Handler String
getInputR name setting = do
    liftIO $ appendFile "Files/database.txt" (name ++ "%" ++ setting ++ "\n")
    return $ "'" ++ name ++ "' with a location of '" ++ setting ++ 
             "' has been added to the database.  Thanks!"


