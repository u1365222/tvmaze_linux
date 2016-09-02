#!/bin/bash
IFS=',' read -r -a array <<< "$*"
for show in "${array[@]}"
do
  echo ""
  showInfo=$(curl -s "http://api.tvmaze.com/singlesearch/shows?q=$show&embed=nextepisode" )
  name=$(echo $showInfo | sed 's/.*"name":"\([^"]*\)","type".*/\1/')
  if [ ${#name} = 0 ]; then echo "No match found for '$show'"
  else
    echo "Show: $name"
    status=$(echo $showInfo | sed 's/.*"status":"\([^"]*\)".*/\1/')
    if [ "$status" == "Ended" ]; then echo "$name has ended; there are no more episodes"
    else
      nextepisode=$(echo $showInfo | sed 's/.*"nextepisode"://')
      if [ "$nextepisode" != "$showInfo" ]; then
        airdate=$(echo $showInfo | sed 's/.*"airdate":"\([^"]*\)".*/\1/')
        airtime=$(echo $showInfo | sed 's/.*"airtime":"\([^"]*\)".*/\1/')
        if [ ${#airdate} = 0 ]; then
          if [ ${#airtime} != 0 ]; then echo "No broadcast information is known"; else echo "Next episode airs at $airtime (date not known)"; fi
        else
          echo -ne "Next episode: $airdate"
          if [ ${#airtime} != 0 ]; then echo " @ $airtime"; else echo ""; fi
        fi
      else
        echo "Next episode has not been added for this show"
      fi
    fi
  fi
done