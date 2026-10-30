#!/bin/sh
# Clears the agent state marker of a window once the user looks at it.
# Called from the after-select-window hook; running agents keep their marker.
window_id="$1"

[ -n "$window_id" ] || exit 0

state=$(tmux show-option -wqv -t "$window_id" @agent_state 2>/dev/null)

case "$state" in
    done|needs-input)
        tmux set-option -wu -t "$window_id" @agent_state 2>/dev/null
        ;;
esac
