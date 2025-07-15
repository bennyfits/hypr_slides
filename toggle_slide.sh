#!/bin/bash
script_path=$(dirname "$(realpath $0)")
file=($script_path/config/$1.json)
cat $file
# Configuration values.
selector=$(cat $file | jq --raw-output .selector)
name=$(cat $file | jq --raw-output .name)
command=$(cat $file | jq --raw-output .command)
x=$(cat $file | jq --raw-output .position.active.x)
y=$(cat $file | jq --raw-output .position.active.y)
home_x=$(cat $file | jq --raw-output .position.home.x)
home_y=$(cat $file | jq --raw-output .position.home.y)
height=$(cat $file | jq --raw-output .size.height)
width=$(cat $file | jq --raw-output .size.width)

# Hyprland state
address=$(hyprctl clients -j | jq ".[] | $selector | .address" | tr -d '"')
at_x=$(hyprctl clients -j | jq ".[] | $selector | .at[0]")
at_y=$(hyprctl clients -j | jq ".[] | $selector | .at[1]")
workspace=$(hyprctl clients -j | jq ".[] | $selector | .workspace.id")
active_workspace=$(hyprctl activeworkspace -j | jq '.id')

function open_slide {
    bash -c "hyprctl dispatch setfloating address:$address"
    bash -c "hyprctl dispatch resizewindowpixel 'exact $width $height', address:$address"
    bash -c "hyprctl dispatch movetoworkspacesilent '$active_workspace, address:$address'"
    bash -c "hyprctl dispatch movewindowpixel 'exact $x $at_y', address:$address"
    sleep 0.01 # A minor stop to ensure that the vertical completes before the horizontal
    bash -c "hyprctl dispatch movewindowpixel 'exact $x $y', address:$address"
    bash -c "hyprctl dispatch focuswindow address:$address"
}

if [ ! -z "${address}" ]; then
  
  if [ $at_y -lt -500 ]; then
  
    bash -c "$script_path/close_all_slides.sh"
    open_slide

  else
    
    bash -c "$script_path/close_all_slides.sh"
    bash -c "hyprctl dispatch cyclenext prev"

    # Move the window to the active workspace if the drawer is on another one.
    # The user may not know the window is open on another workspace.
    if [ $workspace -ne $active_workspace ]; then
      open_slide
    fi
  
  fi

else 
  bash -c $command
fi
