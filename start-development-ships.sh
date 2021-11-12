#!/bin/bash

urbit_binary_path=$(realpath ~/urbit/urbit-v1.7-x86_64-linux/urbit)
session_name='dev-ships'
verbose=false

# Example usage:
#
# Start fake ships ~zod, ~wes, ~nec, ~bus that exist in ~/urbit:
# ./start-development-ships.sh
#
# Create fake ships ~zod, ~wes, ~nec, ~bus  in ~/urbit:
# ./start-development-ships.sh '-F'
#
# Create fake ships ~zod, ~wes, ~nec, ~bus from pill in ~/urbit:
# ./start-development-ships.sh '-B ~/git/urbit/urbit/bin/multi.pill -F'

flags=${1:-''}
if $verbose; then
    echo "Starting development ships. Got flags: $flags..."
fi

#
# functions
#

start_development_ships_session() {
    # ---------------
    # |      |      |
    # | ~zod | ~wes |
    # |      |      |
    # |-------------|
    # |      |      |
    # | ~nec | ~bus |
    # |      |      |
    # ---------------
    session_name=$1
    flags=$2
    tmux new-session -d -s $session_name
    start_ship 'zod' "$flags"

    tmux split-window -h
    start_ship 'wes' "$flags"

    tmux select-pane -t 0
    tmux split-window -v
    start_ship 'nec' "$flags"

    tmux select-pane -t 2
    tmux split-window -v
    start_ship 'bus' "$flags"
}

start_ship() {
    ship_name=$1
    flags=$2
    if $verbose; then
        echo "Running: cd ~/urbit; $urbit_binary_path $flags $ship_name"
    fi
    tmux send-keys "cd ~/urbit; $urbit_binary_path $flags $ship_name" Enter
    sleep 0.1
}

#
# main
#

session_exists=$(tmux list-sessions | grep $session_name)
if [ "$session_exists" = "" ]; then
    start_development_ships_session $session_name "$flags"
    echo "Started development ships in session $session_name"
else
    echo "Session $session_name already running"
fi
