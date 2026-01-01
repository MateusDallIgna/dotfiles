--- Chafa preview plugin for Yazi
-- Falls back to Chafa when other image previews fail

local M = {}

function M:peek(job)
	local cha = require "ya.sync"
	local file = job.file

	if not file:is_regular() then
		return
	end

	-- Use Chafa for ASCII art preview
	local output, err = ya.preview_command({
		"chafa",
		"-f", "symbols",
		"-s", tostring(job.area.w - 4),
		"--symbols", "braille",
		"--color-space", "rgb",
		file.url
	})

	if output and #output > 0 then
		ya.preview_widgets(job, {
			ui.Paragraph.parse(job.area, output),
		})
	end
end

function M:seek(job)
	-- Chafa doesn't support seeking
end

return M