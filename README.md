#Overview

A command line utility for OS X to convert a video file to be playable by 1st gen. AppleTVs. Uses Handbrake, adds the file to iTunes, and tries to guess the show name, season, and episode number from the file name.

#Using as a Folder Action

1. Open Automator and create a new Folder Action Workflow.
2. Pick your folder, and drag over the "Run Shell Script" action
3. Paste in some code to loop over and convert the added files:

	for f in "$@"
	do
		~/bin/VideoConvert "$f"
	done
	
4. Save. Your finished workflow should look like this: (http://dl.getdropbox.com/u/3578765/imageHost/github/ConvertToiTunes_workflow.png)

#Misc Details

* Uses the handbrake CLI: http://handbrake.fr/downloads2.php
* Assumes handbrake CLI is kept in ~/bin
* Assumes whatever you add to it is a TV Show
* Assumes show name and season info is encoded in the file name as Some.Show.Name.S01E01.[whatever].avi
	* I haven't spent much time on this part, so if you have better ideas, let me know
* Uses the AppleTV preset, because that's what I have
* Assumes that iTunes will copy whatever files are added to it

#Credit

* Steven Frank: [Using Handbrake from the command line](http://stevenf.com/notes/index.php/?Using+HandBrake+from+the+command+line)
* Kind folks who posted on [CocoaDev](http://cocoadev.com/) and [Stack Overflow](http://stackoverflow.com/) about the iTunes Bridge

