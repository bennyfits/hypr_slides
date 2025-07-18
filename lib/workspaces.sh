#!/bin/bash
function workspace_attr () {
  echo $(jq --raw-output .$1 <<< $(hyprctl activeworkspace -j))
}