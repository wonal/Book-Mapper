{-} Copyright 2018 Allison Wong
 -  The format of the code in this file was written with the help from the Yesod online book, 
 -  found at https://www.yesodweb.com/book, specifically the "Basics", "Routing and Handlers", 
 -  "Forms", and "Scaffolding and the Site" chapters, as well as the Yesod-Simple template
 -  The Yesod book is licensed under the Creative Commons License, found at:
 -  https://creativecommons.org/licenses/by/4.0/ and the the Yesod framework is licensed under 
 -  the MIT license, where further information can be found at:
 -  https://opensource.org/licenses/MIT.  
 -}
{-# QuasiQuotes #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
--import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
--import Text.Julius (RawJS (..))
import System.IO (appendFile)
import qualified Data.HashMap.Strict as M

data Book = Book 
    { bookTitle :: Text
    , bookLocation :: Text
    }
    deriving Show

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Book-Mapper"
    $(widgetFile "home")

getInputR :: Handler Html
getInputR = do
    book <- runInputGet $ Book
               <$> ireq textField "title"
               <*> ireq textField "location"
    res <- liftIO $ appendFile "database.txt" (show (bookTitle book) ++ "%" ++ show (bookLocation book) ++ "\n")
    defaultLayout $ do
        $(widgetFile "inputresult") 

--createCoordinatesDB :: Database -> IO (M.HashMap String [LL.Coordinates])
getDatabaseR :: Handler Html
getDatabaseR = do
    db <- liftIO $ createDatabase
    cdb <- liftIO $ createCoordinatesDB db
    defaultLayout $ do
       $(widgetFile "database")

{-
getBookMapR :: Handler Html
getBookMapR = defaultLayout $ do
    $(widgetFile "bookmap")
-}

getBookMapR :: Handler Html
getBookMapR = defaultLayout $ do
    setTitle "Book-Mapper"
    $(widgetFile "bookmap")
--

{-}
    [whamlet|
           <div id=#{map}>
       |]
    toWidgetBody
       [julius|function initMap() {
         var lisbon = {lat: 38.7437, lng: -9.23024}
         var map = new google.maps.Map(
            document.getElementById('map'), {zoom: 1, center: lisbon});
            var marker = new google.maps.Marker({position: lisbon, map: map});};
       |]
    toWidgetBody
       [julius|google.maps.event.addDomListener(window, 'load', initMap);
       |]
-- Define our data that will be used for creating the form.
data FileForm = FileForm
    { fileInfo :: FileInfo
    , fileDescription :: Text
    }

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
    (formWidget, formEnctype) <- generateFormPost sampleForm
    let submission = Nothing :: Maybe FileForm
        handlerName = "getHomeR" :: Text
    defaultLayout $ do
        let (commentFormId, commentTextareaId, commentListId) = commentIds
        aDomId <- newIdent
        setTitle "Welcome To Yesod!"
        $(widgetFile "homepage")

postHomeR :: Handler Html
postHomeR = do
    ((result, formWidget), formEnctype) <- runFormPost sampleForm
    let handlerName = "postHomeR" :: Text
        submission = case result of
            FormSuccess res -> Just res
            _ -> Nothing

    defaultLayout $ do
        let (commentFormId, commentTextareaId, commentListId) = commentIds
        aDomId <- newIdent
        setTitle "Welcome To Yesod!"
        $(widgetFile "homepage")

sampleForm :: Form FileForm
sampleForm = renderBootstrap3 BootstrapBasicForm $ FileForm
    <$> fileAFormReq "Choose a file"
    <*> areq textField textSettings Nothing
    -- Add attributes like the placeholder and CSS classes.
    where textSettings = FieldSettings
            { fsLabel = "What's on the file?"
            , fsTooltip = Nothing
            , fsId = Nothing
            , fsName = Nothing
            , fsAttrs =
                [ ("class", "form-control")
                , ("placeholder", "File description")
                ]
            }

commentIds :: (Text, Text, Text)
commentIds = ("js-commentForm", "js-createCommentTextarea", "js-commentList")
-}
