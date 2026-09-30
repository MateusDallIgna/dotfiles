--- @since 25.12.29

local function span(text, color)
	local s = ui.Span(text)
	if color then
		s = s:fg(color)
	end
	return s
end

local function resolve_color(primary, fallback)
	local color = primary and primary:fg() or nil
	if not color and fallback then
		color = fallback:bg()
	end
	return color
end

local function setup(_, opts)
	opts = opts or {}
	local always_show = opts.always_show_icons or false
	local position = opts.icons_position == "bottom" and "bottom" or "top"

	local symbols = {
		selected = opts.select_symbol or "󰻭",
		yanked = opts.yank_symbol or "",
		cut = opts.cut_symbol or "󰆐",
	}

	local function append(parts, count, symbol, color)
		if always_show or count > 0 then
			parts[#parts + 1] = span(string.format(" %d %s", count, symbol), color)
			parts[#parts + 1] = " "
		end
	end

	local function render_counts(self)
		local selected = #cx.active.selected
		local yanked = #cx.yanked
		local is_cut = cx.yanked.is_cut

		if not always_show and selected == 0 and yanked == 0 then
			return ""
		end

		local copied = is_cut and 0 or yanked
		local cut = is_cut and yanked or 0

		local parts = {}
		if position == "bottom" then
			append(parts, copied, symbols.yanked, resolve_color(th.mgr.marker_copied, th.mgr.count_copied))
			append(parts, cut, symbols.cut, resolve_color(th.mgr.marker_cut, th.mgr.count_cut))
			append(parts, selected, symbols.selected, resolve_color(th.mgr.marker_selected, th.mgr.count_selected))
		else
			append(parts, selected, symbols.selected, resolve_color(th.mgr.marker_selected, th.mgr.count_selected))
			append(parts, copied, symbols.yanked, resolve_color(th.mgr.marker_copied, th.mgr.count_copied))
			append(parts, cut, symbols.cut, resolve_color(th.mgr.marker_cut, th.mgr.count_cut))
		end

		return ui.Line(parts)
	end

	if position == "bottom" then
		function Header.count()
			return ""
		end

		Status:children_add(render_counts, 3500, Status.LEFT)
	else
		function Header:count()
			return render_counts(self)
		end
	end
end

return { setup = setup }
