#!/bin/bash

# Determine if verbose mode is enabled
VERBOSE=false
if [[ "$1" == "-verbose" ]]; then
  VERBOSE=true
fi

# Function to run commands with optional verbosity
run_cmd() {
  if $VERBOSE; then
    "$@"
  else
    "$@" > /dev/null 2>&1
  fi
}

# Example setup of a simple progress bar
show_progress() {
  local duration=${1:-5}
  local interval=0.1
  local progress=0
  local bar_size=50

  printf "Progress: ["
  while [[ $progress -lt $bar_size ]]; do
    printf "#"
    sleep $interval
    progress=$((progress + 1))
  done
  printf "] Done!\n"
}

show_progress &
progress_pid=$!
run_cmd pacman -Syu git base-devel

run_cmd git clone https://github.com/RohanBhattacharyya/archdots.git && cd archdots && mv -f .config ~/.local/ && cd ..

run_cmd sudo pacman -S flatpak
run_cmd flatpak install flathub io.github.zen_browser.zen
run_cmd git clone https://github.com/chris-marsh/galendae.git && cd galendae && make release && mv galendae ~/.local/bin/ && cd .. && rm -rf galendae
run_cmd rm -rf archdots
run_cmd wget https://github.com/RohanBhattacharyya/TPet-Fetch/releases/download/release1.1/tpet && chmod +x tpet && mv tpet ~/.local/bin/

run_cmd echo "export PATH=$PATH:~/.local/bin" >> ~/.bashrc
run_cmd echo "export PATH=$PATH:~/.local/bin" >> ~/.zshrc
kill $progress_pid
echo "Done! Please restart your system to apply changes."
