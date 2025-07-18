#!/bin/bash
declare local_path=$(dirname "$(realpath $0)")
declare json="$(cat $local_path/config/$1.json)"
declare windows=$(hyprctl clients -j)
declare monitors=$(hyprctl monitors -j)
declare address

source "$local_path/lib/windows.sh"
source "$local_path/lib/workspaces.sh"
source "$local_path/lib/monitors.sh"
source "$local_path/lib/slides.sh"

address="$(get_window_address "$(config_val selector)")"
bash -c "$local_path/close_all_slides.sh"

function open_slide {
  bash -c "hyprctl dispatch focusmonitor 0"
  echo "Monitor focused..."
  bash -c "hyprctl dispatch setfloating address:$address"
  echo "Window set to floating..."
  bash -c "hyprctl dispatch resizewindowpixel 'exact $(config_val width) $(config_val height)', address:$address"
  bash -c "hyprctl dispatch movetoworkspacesilent '$(workspace_attr id)', address:$address"
  bash -c "hyprctl dispatch movewindowpixel 'exact $(animate_from)', address:$address"
  sleep 0.1 # A minor stop to ensure that the vertical completes before the horizontal
  bash -c "hyprctl dispatch movewindowpixel 'exact $(animate_to)', address:$address"
  bash -c "hyprctl dispatch focuswindow address:$address"
}

if [ $address != "\"\"" ]; then
  if [ $(window_attr workspace.id) -lt 0 ] || [ $(workspace_attr id) -gt 1 ] && [ $(window_attr workspace.id) != $(workspace_attr id) ]; then
    open_slide
  else
    bash -f "hyprctl focusmonitor 0"
    #bash -c "hyprctl dispatch cyclenext prev"
  fi
else 
  bash -c "$(config_val command)"
fi
