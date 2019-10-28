#!/usr/bin/env bash

_LOG_STEPS=0
_LOG_STEP=1
_LOG_CURR=0

_LOG_STATS_TOTAL=0
_LOG_STATS_CURR=0

log_init() {
  _LOG_STEPS=$1

  if [[ -n $2 ]]; then
    _LOG_STEP=$2
  fi

  _LOG_STATS_TOTAL=$((_LOG_STEPS/_LOG_STEP))
}

log() {
  _LOG_CURR=$((_LOG_CURR+_LOG_STEP))
  _LOG_STATS_CURR=$((_LOG_STATS_CURR+1))

  local incomplete=$((_LOG_STEPS-_LOG_CURR))

  printf "\33[2K"

  echo "$1"

  printf "%0.s•" $(seq 1 $_LOG_CURR)

  if [[ $incomplete -gt 0 ]]; then
    printf "%0.s◦" $(seq 1 $incomplete)
  fi

  printf " [%s/%s]\r" "$_LOG_STATS_CURR" "$_LOG_STATS_TOTAL"

  if [[ "$_LOG_STEPS" == "$_LOG_CURR" ]]; then
    echo ""
  fi
}
