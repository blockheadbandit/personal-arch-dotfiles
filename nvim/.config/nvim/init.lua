--setting up lazynvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{"nvim-tree/nvim-tree.lua",dependencies = {"nvim-tree/nvim-web-devicons"}},
	{"nvim-lualine/lualine.nvim",dependencies = {"nvim-tree/nvim-web-devicons"}},
	{"akinsho/toggleterm.nvim", version="*", config = true },
	{"neovim/nvim-lspconfig"},
	{"hrsh7th/nvim-cmp"},
	{"hrsh7th/cmp-nvim-lsp"},
	{"L3MON4D3/LuaSnip"},
	{"lewis6991/gitsigns.nvim"},
	{"nvim-telescope/telescope.nvim", tag = '0.1.8', dependencies = {'nvim-lua/plenary.nvim'}},
	{"folke/trouble.nvim",opts = {}, cmd="Trouble", Keys = {
		{"<leader>dt","<cmd>Trouble diagnostics toggle<cr>",desc = "Diagnostics (Trouble)",},
		{"<leader>dT","<cmd>Trouble diagnostics toggle filter.buf=0<cr>",desc = "Buffer Diagnostics (Trouble)",},
		{"<leader>cs","<cmd>Trouble symbols toggle focus=false<cr>",desc = "Symbols (Trouble)",},
		{"<leader>cl","<cmd>Trouble lsp toggle focus=false win.position=right<cr>",desc = "LSP Definitions / references / ... (Trouble)",},
    		{"<leader>dL","<cmd>Trouble loclist toggle<cr>",desc = "Location List (Trouble)",},
    		{"<leader>dQ","<cmd>Trouble qflist toggle<cr>",desc = "Quickfix List (Trouble)",},
	}},
	require("colorscheme")
})
-- plugin setups
-- UI features
require("lualine").setup({})
require("nvim-tree").setup({view={width=30,},})
vim.opt.number = true
require("nvim-tree.api").tree.open()
require("toggleterm").setup({
	size = 15,
	open_mapping = [[<C-\>]],
	direction="horizontal",
	start_in_insert=true,
})
-- language servers
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = { version = "LuaJIT",path = vim.split(package.path,";"),},
			diagnostics = { globals = {"vim"},},
			workspace = {library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false},
			telemetry = {enable = false},
		},
	},
})
lspconfig.pyright.setup({})
lspconfig.clangd.setup({})
-- completion
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
  },
  sources = {
    { name = "nvim_lsp" }
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
})
-- telescope fuzzy find
local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open
local add_to_trouble = require("trouble.sources.telescope").add
require('telescope').setup{
	defaults = {mappings = { i = { ["<c-t>"] = open_with_trouble },n = { ["<c-t>"] = open_with_trouble },}}
}
vim.keymap.set("n", "<leader>ff", function()
  require('telescope.builtin').find_files({
    hidden = true,     -- show hidden files (like .gitignore, .config)
  })
end, { desc = "Find all files recursively, including hidden" })
-- misc 
-- todo, line numbers, keymappings
