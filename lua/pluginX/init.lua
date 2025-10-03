-- Aqui cargaremos nuestros plugins, Intentare hacerlo lo mas facil para que puedan disfrutarlo C:

return {
  -- Themes
  { "EdenEast/nightfox.nvim", name = "nightfox", lazy = false, priority = 1000,
    config = function() vim.cmd("colorscheme duskfox") end },

  -- LSP y autocompletado
  { "neovim/nvim-lspconfig", event = "BufReadPre" },
  { "williamboman/mason.nvim", build = ":MasonUpdate", cmd = "Mason" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp", event = "InsertEnter" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip", event = "InsertEnter" },

  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope" },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", event = { "BufReadPost", "BufNewFile" } },

  -- Git
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", config = true },
}
