#!/bin/bash
declare json
declare address
local_path=$(dirname "$(realpath $0)")
config_path="$local_path/config"
active_workspace=$(hyprctl activeworkspace -j | jq '.id')
windows=$(hyprctl clients -j)

source "$local_path/lib/windows.sh"
source "$local_path/lib/workspaces.sh"
source "$local_path/lib/monitors.sh"
source "$local_path/lib/slides.sh"

for slide in $config_path/*; do
  json=$(jq --raw-output <<< $(cat $slide))
  if [[ $windows = *"$(config_val name)"* ]]; then

    address=$(get_window_address "$(config_val selector)")
    
    if [ $address != "\"\"" ]; then
      bash -c "hyprctl dispatch setfloating address:$address"
      bash -c "hyprctl dispatch movewindowpixel 'exact $(animate_from)', address:$address"
      bash -c "hyprctl dispatch movetoworkspacesilent 'special:slides', address:$address"
    fi
  fi
done