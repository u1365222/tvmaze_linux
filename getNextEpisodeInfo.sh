#!/bin/bash
mode="name" # Valid inputs are 'name' & 'id'
IFS=',' read -r -a array <<< "$*"
for input in "${array[@]}"
do
  input=$(echo $input) # Trim the input
  input_lower=$(echo $input | tr '[A-Z]' '[a-z]') # Make input lowercase
  case "$input_lower" in
    '-mode id'*)
      input=$(echo $input | cut -c10-)
      mode="id";;
    '-mode name'*)
      input=$(echo $input | cut -c12-)
      mode="name";;
    *) ;;
  esac
  if [ "$input" != '' ]; then
    echo ""
    if [[ "$mode" == "id" && $input =~ ^-?[0-9]+$ ]]; then # Integer check
      showInfo=$(curl -s "http://api.tvmaze.com/shows/$input?embed=nextepisode" )
    else
      showInfo=$(curl -s "http://api.tvmaze.com/singlesearch/shows?q=$input&embed=nextepisode" )
    fi
    name=$(echo $showInfo | sed 's/.*"name":"\([^"]*\)","type".*/\1/')
    if [ ${#name} = 0 ]; then
      if [ "$mode" == "id" ]; then echo "No match found for ID $input"; else echo "No match found for '$input'"; fi
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
  fi
done