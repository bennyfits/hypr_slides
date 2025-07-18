#!/bin/bash
function config_val () {
  echo $(jq --raw-output .$1 <<< $json)
}

function get_window_address () {
  echo "\"$(jq --raw-output ".[] | ${1} | .address" <<< $windows)\""
}

function window_attr () {
  echo $(jq --raw-output ".[] | select(.address==$(echo "$address")) | .$1" <<< $windows)
}
