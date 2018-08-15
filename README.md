# Book-Mapper

Copyright (c) 2018 Allison Wong

This is a web application designed to allow avid readers to create a map of places they have traveled to via the books they have read.  The website allows a reader to start with an empty world map and by looking up books he/she has read, a reader can add markers to the map, each representing where a book takes place.  

## Status: [![Build Status](https://travis-ci.com/wonal/Book-Mapper.svg?branch=master)](https://travis-ci.com/wonal/Book-Mapper)

## Current Features:
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
If you get a warning about adding a path to the beginning of PATH in your profile:
add `export PATH="/home/user_name/.local/bin:$PATH" to the end of your `.bashrc` file found at `~/.bashrc`.  Restart your terminal.  
Clone the repository: https://github.com/wonal/Book-Mapper.git
Install the yesod command line tool inside the project directory: `stack install yesod-bin --install-ghc`. 

Obtain a Google maps API key enabled for Google Maps Javascript and Google Maps Geocoder services.  Place the key in a text file
titled "APIkey.txt" in the root directory (make sure to add it to your .gitignore file).  Paste your API key where instructed (`APIKEYHERE`) within the `templates/home.julius` file.    

Run the command `stack build`.
To run in development mode, run the command `stack exec -- yesod devel`.
Access localhost:3000 in your browser.

### A Note About Development Mode
I have been exclusively developing using development mode `stack exec -- yesod devel`.  `stack build` does install an executable which is supposed to be run via the command `stack exec BookMapper.exe`, however many times stack has been unable to find the executable.

## Credits
This project was built using the Yesod web framework, which is licensed under the [MIT license](https://github.com/yesodweb/yesod/blob/master/LICENSE).  The template I used for my web application was the 'yesod-simple' Stack template.  I used [Yesod's website](https://www.yesodweb.com) and [online book](https://www.yesodweb.com/book), which I read through over and over again to help create this web application.

Other credits are mentioned throughout the source code as appropriate.  

## License

This work is licensed under the MIT license.  See the corresponding file [`LICENSE`](https://github.com/wonal/Book-Mapper/blob/master/LICENSE) in this distribution for license terms.
