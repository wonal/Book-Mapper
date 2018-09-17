# Book-Mapper

Copyright (c) 2018 Allison Wong

This is a web application that allows avid readers to create a map of places they have traveled to via the books they have read.  A reader starts with an empty world map and by looking up books he/she has read, a reader can add markers to the map, each representing where a book takes place.  

## Status [![Build Status](https://travis-ci.com/wonal/Book-Mapper.svg?branch=master)](https://travis-ci.com/wonal/Book-Mapper)

## Current Features
Book-Mapper features include:
- Adding a marker: readers can look up a book they have read by title, and if present in the database, a marker will be added to their book map according to where the book is set.  
- Adding a book to the database: I built the book database from scratch!  So chances are, a particular book won't be there, in which case, a reader can add a location for a particular book to the database to be stored for their use and other readers.
- A personal book map with markers, with each marker corresponding to where a book that the user has read takes place.

This initial version of Book-Mapper is limited to books that have taken place on Earth, although hopefully this will be extended in the future for us science-fiction lovers.  

## Future Plans
There is still a lot I would like to do with this project: optimizations, improvements in design and usability, etc.  Below is a list of ideas I have for the next stages of this project:
- Allow users to save maps 
- Convert to using SQLite as a database
- Investigate a more efficient means of creating a book/location database
- Transition to using OpenStreetMaps or another alternative

## Build Instructions

### Ubuntu 18.04 

If you don't already have Haskell Stack, install via the command: `curl -sSL https://get.haskellstack.org/ | sh`.
If you get a warning about adding a path to the beginning of PATH in your profile, add 
`export PATH="/home/user_name/.local/bin:$PATH"` to the end of your `.bashrc` file found at `~/.bashrc`.  Close and re-open your terminal.  
Clone the repository: https://github.com/wonal/Book-Mapper.git .  Install the yesod command line tool inside the project directory: `stack install yesod-bin --install-ghc` (grab a cup of coffee, tea, beer, take a walk, etc.). 

Obtain a Google Maps API key enabled for the Google Maps (Google Maps Javascript API) and Google Places (Google Geocoding API) services.  You can follow the steps [here](https://developers.google.com/maps/documentation/javascript/get-api-key).  Place the key in a text file
titled "APIkey.txt" in the root directory (make sure to add it to your .gitignore file).  Paste your API key where instructed (`APIKEYHERE`) within the `templates/home.julius` file.    

Run the command `stack build` (grab another cup of coffee, tea, beer, go on another walk, etc.).
To run in development mode, run the command `stack exec -- yesod devel`.
Access localhost:3000 in your browser.

### A Note About Development Mode
I have been exclusively developing using development mode `stack exec -- yesod devel`.  To run in "production", the `stack build` command displays the path where the executable was placed.  Place that executable in a directory along with the `config` directory, the `files` directory, and the `APIkey.txt` file.  Start the server with the command `.\BookMapper`.  

## Credits
This project was built by me, Allison Wong, with a lot of help from the Yesod web framework, which is licensed under the [MIT license](https://github.com/yesodweb/yesod/blob/master/LICENSE).  The template I used for my web application was the 'yesod-simple' Stack template.  I used [Yesod's website](https://www.yesodweb.com) and [online book](https://www.yesodweb.com/book), many of their chapters which I read through numerous times to help create this web application.

Other credits are mentioned throughout the source code as appropriate.  

## License

This work is licensed under the MIT license.  See the corresponding file [`LICENSE`](https://github.com/wonal/Book-Mapper/blob/master/LICENSE) in this distribution for license terms.
