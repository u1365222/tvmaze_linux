# tvmaze_linux
Linux/Bash scripts for TVMaze

##== getNextEpisodeInfo ==

Description: Outputs the date & time of the next episode for the input show(s)

Input type: CSV (Comma Seperated Values)

###Standard Usage:
  getNextEpisodeInfo.sh showName [, anotherShowName...]

You can switch between using the TVMaze ID & the show name by using

###-mode ID/Name (case insensitive)
  Default is name

  Setting the mode is done inline and thus continues to search with that mode until the other mode is selected

####getNextEpisodeInfo.sh -mode id 1, 2
  Returns the next episode information for TVMaze IDs 1 & 2 respectively

####getNextEpisodeInfo.sh -mode name 1, 2
####getNextEpisodeInfo.sh 1, 2
  Returns the next episode information for the singlesearch match for "1" & "2" repsectively

####getNextEpisodeInfo.sh -mode id 1, -mode name 2
  Returns the next episode information for TVMaze ID 1 and the singlesearch match for "2" respectively

####getNextEpisodeInfo.sh -mode name 1, -mode id 2
####getNextEpisodeInfo.sh 1, -mode id 2
  Returns the next episode information for the singlesearch match for "1" and TVMaze ID 2 respectively

####Error Checking:
  When in ID mode, if the current query is not an integer it will it as a name (but not change the mode)

  Make sure you are in the correct mode; an integer in name mode is valid as it searching for the number in show names

========================
