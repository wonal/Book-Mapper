{-} Copyright 2018 Allison Wong
 -  This program is licensed under the MIT license.  Full terms can be found at:
 -  https://github.com/wonal/Book-Mapper/blob/master/LICENSE.
 -  The code in this file was generated from the Yesod-Simple Stack template and has not been modified.
 -  More information can be found by the command: stack templates
 -  or consulting the Yesod book online.  The Yesod framework is licensed under
 -  the MIT license, and further information can be found at:
 -  https://github.com/yesodweb/yesod/blob/master/LICENSE.  
 -}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
-- | Common handler functions.
module Handler.Common where

import Data.FileEmbed (embedFile)
import Import

-- These handlers embed files in the executable at compile time to avoid a
-- runtime dependency, and for efficiency.

getFaviconR :: Handler TypedContent
getFaviconR = do cacheSeconds $ 60 * 60 * 24 * 30 -- cache for a month
                 return $ TypedContent "image/x-icon"
                        $ toContent $(embedFile "config/favicon.ico")

getRobotsR :: Handler TypedContent
getRobotsR = return $ TypedContent typePlain
                    $ toContent $(embedFile "config/robots.txt")
