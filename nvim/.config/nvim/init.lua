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
	{"lewis6991/gitsigns.nvim"}
	
})

require("lualine").setup()
require("nvim-tree").setup({
	view={width=30,},
})

vim.opt.number = true
require("nvim-tree.api").tree.open()
require("toggleterm").setup({ 
	size = 15,
	open_mapping = [[<C-\>]],
	direction="horizontal",
	start_in_insert=true,
})
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})
lspconfig.pyright.setup({})
lspconfig.clangd.setup({})

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
