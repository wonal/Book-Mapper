# Book-Mapper

Copyright (c) 2018 Allison Wong

This is a web application designed to allow avid readers to create a map of places they have traveled to via the books they have read.

## Status: [![Build Status](https://travis-ci.com/wonal/Book-Mapper.svg?branch=master)](https://travis-ci.com/wonal/Book-Mapper)

## Current Features:
Book-Mapper features include:
- Adding a marker: readers can look up a book they have read by title, and if present in the database, a marker will be added to their book map according to where the book is set.  
- Adding a book to the database: I built the book database from scratch!  So chances are, a particular book won't not be there, in which case, a reader can add a location for a particular book to the database to be stored for their use and others.
- A personal book map with markers, with each marker indicating the location of a book the user has read.

This initial version of Book-Mapper is limited to books that have taken place on Earth, although hopefully this will be extended in the future for us science-fiction lovers.  

## Future Plans
There is still a lot I would like to do with this project: optimizations, improvements in design and usability, etc.  Below is a list of ideas I have for the next stages of this project:
- Allow users to save maps 
- Convert to using SQLite as a database
- Investigate a more efficient means of creating a book/location database
- Transition to using OpenStreetMaps or another alternative

## Build Instructions

### Windows

### Ubuntu

## Credits
This project was built using the Yesod web framework, which is licensed under the [MIT license](https://github.com/yesodweb/yesod/blob/master/LICENSE).  The template I used for my web application was the 'yesod-simple' Stack template.  I used [Yesod's website](https://www.yesodweb.com) and [online book](https://www.yesodweb.com/book), which I read through over and over again to help create this web application.

Other credits are mentioned throughout the source code as appropriate.  

## License

This work is licensed under the MIT license.  See the corresponding file `LICENSE` in this distribution for license terms.
