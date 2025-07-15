#!/bin/bash
config_path=$(dirname "$(realpath $0)")/config
for drawer in $config_path/*; do
  address=$(hyprctl clients -j | jq ".[] | $(jq --raw-output .selector $drawer) | .address" | tr -d '"')
  x=$(jq --raw-output .position.home.x $drawer)
  y=$(jq --raw-output .position.home.y $drawer)
  bash -c "hyprctl dispatch setfloating address:$address"
  bash -c "hyprctl dispatch movewindowpixel 'exact $x $y', address:$address"
done