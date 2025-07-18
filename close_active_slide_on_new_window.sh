 #!/bin/bash
declare address
declare windows
declare json
local_path=$(dirname "$(realpath $0)")
config_path="$local_path/config"
declare monitors=$(hyprctl monitors -j)
declare address


source "$local_path/lib/windows.sh"
source "$local_path/lib/workspaces.sh"
source "$local_path/lib/monitors.sh"
source "$local_path/lib/slides.sh"

function handle {
  
  if [[ ${1:0:10} == "openwindow" ]]; then
    address="\"0x${1:12:12}\""
    windows=$(hyprctl clients -j)

    if [ $(window_attr floating) = false  ] || [ $(window_attr fullscreen) -ne 0 ]; then
      
      for slide in $config_path/*; do
        json=$(jq --raw-output <<< $(cat $slide))
        address="$(get_window_address "$(config_val selector)")"

        if [ $(window_attr floating) = true  ] || [ $(window_attr fullscreen) = 1 ]; then
          bash -c "hyprctl dispatch setfloating address:$address"
          bash -c "hyprctl dispatch movewindowpixel 'exact $(animate_from)', address:$address"
          bash -c "hyprctl dispatch movetoworkspacesilent 'special:slides', address:$address"
        fi

      done

      bash -c "hyprctl dispatch cyclenext prev"
    fi
  fi
}
socat -t7889400 - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done