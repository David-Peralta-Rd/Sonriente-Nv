-- Configuracion y instalacion de Mason.

return {
  -- Mason: administrador de binarios LSP, DAP, etc.
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = true,
  },

  -- Mason-LSPConfig: instala servidores automáticamente
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "mason.nvim" },
    config = function()
      -- Importamos la lista de servidores desde configs
      local servers = require("configx.selectLanguage")

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })
    end,
  },
}

