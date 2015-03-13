docker-jslint
=============

Docker container which lints javascript files in the directories
passed to it as argument(s).

Applies the Google Closure Compiler, as well as gjslint, to all
Javascript files.

Any lint errors will trigger a non-zero container exit status.

