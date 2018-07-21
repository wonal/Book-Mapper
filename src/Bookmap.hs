{- Copyright (c) 2018 Allison Wong 
   Code based on the Input Forms example taken from the 
   Forms chapter of the online book "Haskell and Yesod",
   available at www.yesodweb.com/book, licensed under the
   Creative Commons Attribution 4.0 International License.
   The license can be found at:
   https://creativecommons.org/licenses/by/4.0/legalcode
-}

{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module Bookmap where
import Control.Applicative
import Data.Text (Text)
import System.IO
import Yesod
import DatabaseUtils

data BookMapper = BookMapper

mkYesod "BookMapper" [parseRoutes|
/ HomeR GET
/input InputR GET
/test DatabaseR GET
|]

instance Yesod BookMapper

instance RenderMessage BookMapper FormMessage where
    renderMessage _ _ = defaultFormMessage

data Book = Book 
    { bookTitle :: Text
    , bookLocation :: Text
    }
    deriving Show

getHomeR :: Handler Html
getHomeR = defaultLayout
    [whamlet|
        <form action=@{InputR}>
            <p>
                Enter the title
                <input type=text name=title> 
                and the location of the book
                <input type=text name=location>
                to add to your map.
                <input type=submit value="Add book">
                <br>
                <a href=@{DatabaseR}>Print Database
    |]

getInputR :: Handler Html
getInputR = do
    book <- runInputGet $ Book
               <$> ireq textField "title"
               <*> ireq textField "location"
    res <- liftIO $ appendFile "database.txt" (show (bookTitle book) ++ "%" ++ show (bookLocation book) ++ "\n")
    defaultLayout [whamlet|
                      <p>#{show $ bookTitle book} set in #{show $ bookLocation book}
                         <br>
                         <br>
                         <a href=@{HomeR}>Return
                  |]
getDatabaseR :: Handler Html
getDatabaseR = do
    db <- liftIO $ createDatabase
    defaultLayout [whamlet|
                      <p>#{show db}
                      <br>
                      <a href=@{HomeR}>Return
                  |]


