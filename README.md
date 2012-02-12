#Overview

A command line utility for OS X to convert a video file to be playable by 1st gen. AppleTVs. Uses Handbrake, adds the file to iTunes, and tries to guess the show name, season, and episode number from the file name.

#Using as a Folder Action

1. Open Automator and create a new Folder Action Workflow.
2. Pick your folder, and drag over the "Run Shell Script" action
3. Paste in some code to loop over and convert the added files:

	`for f in "$@"
	do
		~/bin/VideoConvert "$f"
	done`
	
4. Save. Your finished workflow should look like [this](http://dl.getdropbox.com/u/3578765/imageHost/github/ConvertToiTunes_workflow.png)

#Misc Details

* Uses the [Handbrake CLI](http://handbrake.fr/downloads2.php)
* Assumes handbrake CLI is kept in `~/bin`
* Assumes whatever you add to it is a TV Show
* Assumes show name and season info is encoded in the file name as Some.Show.Name.S01E01.[whatever].avi
	* I haven't spent much time on this part, so if you have better ideas, let me know
* Uses the `AppleTV` preset, because that's what I have, but is really easy to change
* Assumes that iTunes will copy whatever files are added to it

#Credit

* Steven Frank: [Using Handbrake from the command line](http://stevenf.com/notes/index.php/?Using+HandBrake+from+the+command+line)
* Kind folks who posted on [CocoaDev](http://cocoadev.com/) and [Stack Overflow](http://stackoverflow.com/) about the iTunes Bridge. I've lost links to the specific posts

#License

The MIT License (MIT)
Copyright (c) 2012 Jim Dusseau

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

