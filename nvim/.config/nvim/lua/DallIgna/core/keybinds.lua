-- ===========================================================================================
--  GENERAL KEYMAPS
-- ===========================================================================================

local keymap = vim.keymap.set

local function opts(desc)
	return { desc = desc, silent = true }
end

vim.g.mapleader = " "

-- -------------------------------------------------------------------------------------------
--  Better Movement
-- ------------------------------------------------------------------------------------------

keymap("n", "j", "gj", opts("Move Down"))
keymap("n", "k", "gk", opts("Move Up"))

-- -------------------------------------------------------------------------------------------
--  Close Buffer
-- ------------------------------------------------------------------------------------------

keymap("n", "<leader>cb", "<cmd>bdelete<cr>", opts("Close Buffer"))

-- -------------------------------------------------------------------------------------------
-- File Operations
-- -------------------------------------------------------------------------------------------

keymap("n", "<leader>w", "<cmd>w<cr>", opts("Save file"))
keymap("n", "<leader>q", "<cmd>q<cr>", opts("Quit Neovim"))

-- -------------------------------------------------------------------------------------------
-- Window Navigation
-- -------------------------------------------------------------------------------------------

keymap("n", "<C-k>", "<C-w>k", opts("Navigate window Up"))
keymap("n", "<C-j>", "<C-w>j", opts("Navigate window Down"))
keymap("n", "<C-h>", "<C-w>h", opts("Navigate window Left"))
keymap("n", "<C-l>", "<C-w>l", opts("Navigate window Right"))

-- -------------------------------------------------------------------------------------------
--  Pane Resizing
-- -------------------------------------------------------------------------------------------

keymap("n", "<C-Up>", ":resize -2<CR>", opts("Decrease window height"))
keymap("n", "<C-Down>", ":resize +2<CR>", opts("Increase window height"))
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts("Decrease window width"))
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts("Increase window width"))

-- -------------------------------------------------------------------------------------------
--  Buffers Navigate
-- -------------------------------------------------------------------------------------------

keymap("n", "<S-l>", ":bnext<CR>", opts("Navigate Buffer Next"))
keymap("n", "<S-h>", ":bprevious<CR>", opts("Navigate Buffer Previous"))

-- -------------------------------------------------------------------------------------------
--  Exit Insert Mode
-- -------------------------------------------------------------------------------------------

keymap("i", "jk", "<ESC>", opts("Quit Insert Mode"))
keymap("i", "kj", "<ESC>", opts("Quit Insert Mode"))

-- -------------------------------------------------------------------------------------------
--  Keep Indent Mode
-- -------------------------------------------------------------------------------------------

keymap("v", "<", "<gv^", opts("Indent Left"))
keymap("v", ">", ">gv^", opts("Indent Right"))

-- -------------------------------------------------------------------------------------------
--  Shift Lines
-- -------------------------------------------------------------------------------------------

keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts("Shift Up"))
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts("Shift Down"))
keymap("v", "p", '"_dP', opts("Paste (keep buffer)"))

-- -------------------------------------------------------------------------------------------
--  Clear Serch Highlight
-- -------------------------------------------------------------------------------------------

keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", opts("Clear search highlight"))

-- -------------------------------------------------------------------------------------------
--  Open Mason
-- -------------------------------------------------------------------------------------------

keymap("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason" })

-- ------------------------------------------------------------------------------------------
--  Open Lazy
-- ------------------------------------------------------------------------------------------

keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- ------------------------------------------------------------------------------------------
--  LSP
-- ------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local function lsp_opts(desc)
			return { desc = desc, buffer = ev.buf, silent = true }
		end
		keymap("n", "gd", vim.lsp.buf.definition, lsp_opts("LSP: Go Definition"))
		keymap("n", "gD", vim.lsp.buf.declaration, lsp_opts("LSP: Go Declaration"))
		keymap("n", "gr", vim.lsp.buf.references, lsp_opts("LSP: Go References"))
		keymap("n", "gi", vim.lsp.buf.implementation, lsp_opts("LSP: Go Implementation"))
		keymap("n", "K", vim.lsp.buf.hover, lsp_opts("LSP: Show Documentation"))
		keymap("n", "<leader>rn", vim.lsp.buf.rename, lsp_opts("LSP: Rename Variable"))
		keymap("n", "<leader>rf", vim.diagnostic.open_float, lsp_opts("LSP: Open float error"))
		keymap("n", "<leader>ca", vim.lsp.buf.code_action, lsp_opts("LSP: Code Action"))
	end,
})

-- ------------------------------------------------------------------------------------------
--  Copilot
-- ------------------------------------------------------------------------------------------

keymap("n", "<leader>cc", "<cmd>Copilot toggle<cr>", { desc = "Toggle Copilot" })

-- ------------------------------------------------------------------------------------------
--  Telescope
-- ------------------------------------------------------------------------------------------

keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts("Telescope: Find Files"))
keymap("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", opts("Telescope: Find Colorschemes"))
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", opts("Telescope: Find Keymaps"))
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts("Telescope: Live Grep"))
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts("Telescope: Find Buffers"))
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", opts("Telescope: Find Older Files"))
keymap("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts("Telescope: Find in Current Buffer"))
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts("Telescope: Help Tags"))
keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", opts("Telescope: Diagnostics"))
keymap("n", "<leader>fr", "<cmd>Telescope resume<cr>", opts("Telescope: Resume"))

-- ------------------------------------------------------------------------------------------
--  Neo-Tree
-- ------------------------------------------------------------------------------------------
keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", opts("Neo-Tree: Toggle Explorer"))
keymap("n", "<leader>be", "<cmd>Neotree buffers<cr>", opts("Explorer: Buffers"))
