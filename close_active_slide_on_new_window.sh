 #!/bin/bash
script_path=$(dirname "$(realpath $0)")
function handle {
  if [[ ${1:0:10} == "openwindow" ]]; then
    bash -c "$script_path/close_all_slides.sh"
  fi
}

socat -t7889400 - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done