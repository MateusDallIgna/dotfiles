show_agent() {
  local index=$1
  local icon="$(get_tmux_option "@catppuccin_agent_icon" "")"
  local color="$(get_tmux_option "@catppuccin_agent_color" "$thm_blue")"
  local text="$(get_tmux_option "@catppuccin_agent_text" "#{agent_indicator}")"

  local module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
