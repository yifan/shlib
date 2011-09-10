#!/bin/bash -ex

# generic command-line option parser for bash shell script
#
# Author: Yifan Zhang (freqyifan at gmail dot com)
#
# Permission is granted for free distribution and usage provided the copyright
# notice are not altered.
#
#
# how to use it:
# ; example.sh
# VERBOSE=false
#
# cmdopts_version "1.0"
# cmdopts_usage "$0: [option] input output"
# cmdopts_add_option "-v" "--verbose" "display progress information" "VERBOSE=true"
# cmdopts_add_option "-l" "" "list option" "assign LIST"
# cmdopts_parse "$@"
#
# ; bash cmdopts.sh -v -l "a b c d"
# echo "VERBOSE=$VERBOSE"
# echo "LIST=$LIST"
#
# ; ./example.sh -h
# version: 1.0
# usage:
#   example.sh: [option] input output
# options:
#   -h,--help         display help information
#   -v,--verbose      display progress information
#   -l,               list option
#
# ; ./example.sh -v -l "Blha balh"
# VERBOSE=true
# LIST=Blha balh
#
# 08-Sep-2011


CMDOPTS_N=0
CMDOPTS_VERSION="0.0"
CMDOPTS_USAGE="please use -h,--help to see help information"

function cmdopts_version {
  local version=$1; shift
  CMDOPTS_VERSION=$version
}

function cmdopts_usage {
  local usage=$1
  CMDOPTS_USAGE=$usage
}

function cmdopts_add_option {
  local shtopt=$1; shift
  local lngopt=$1; shift
  local hlpmsg=$1; shift
  local action=$1; shift
  CMDOPTS_SHTOPT_ARRAY[$CMDOPTS_N]=$shtopt
  CMDOPTS_LNGOPT_ARRAY[$CMDOPTS_N]=$lngopt
  CMDOPTS_HLPMSG_ARRAY[$CMDOPTS_N]=$hlpmsg
  CMDOPTS_ACTION_ARRAY[$CMDOPTS_N]=$action
  CMDOPTS_N=$[$CMDOPTS_N+1]
}

function cmdopts_parse {
  while [[ $# -gt 0 ]];
  do
    local NOTVALID=true
    for ((i=0;i<$CMDOPTS_N;i++)); 
    do
      if [[ "$1" == "${CMDOPTS_SHTOPT_ARRAY[$i]}" || "$1" == "${CMDOPTS_LNGOPT_ARRAY[$i]}" ]];
      then
        if [[ "${CMDOPTS_ACTION_ARRAY[$i]}" =~ "assign " ]];
        then
          shift
          local varnam=${CMDOPTS_ACTION_ARRAY[$i]#assign }
          eval "$varnam=\"$1\""
        else
          eval "${CMDOPTS_ACTION_ARRAY[$i]}"
        fi
        NOTVALID=false
        break
      fi
    done
    if $NOTVALID;
    then
      break
    fi
    shift
  done
}

function cmdopts_display_help {
  echo "version:" $CMDOPTS_VERSION
  echo "usage:"
  echo "  " $CMDOPTS_USAGE
  echo "options:"
  for ((i=0;i<$CMDOPTS_N;i++));
  do
    printf "  %s,%-14s %s\n" "${CMDOPTS_SHTOPT_ARRAY[$i]}" "${CMDOPTS_LNGOPT_ARRAY[$i]}" "${CMDOPTS_HLPMSG_ARRAY[$i]}"
  done
}

cmdopts_add_option "-h" "--help" "display help information" "cmdopts_display_help; exit"
