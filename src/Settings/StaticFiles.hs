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
{-# LANGUAGE TemplateHaskell   #-}
module Settings.StaticFiles where

import Settings     (appStaticDir, compileTimeAppSettings)
import Yesod.Static (staticFiles)

-- This generates easy references to files in the static directory at compile time,
-- giving you compile-time verification that referenced files exist.
-- Warning: any files added to your static directory during run-time can't be
-- accessed this way. You'll have to use their FilePath or URL to access them.
--
-- For example, to refer to @static/js/script.js@ via an identifier, you'd use:
--
--     js_script_js
--
-- If the identifier is not available, you may use:
--
--     StaticFile ["js", "script.js"] []
staticFiles (appStaticDir compileTimeAppSettings)
