return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Recuerda hacer tu configuracion de lenguaje en la carpeta "lua/pluginx/lsp/languageConfig/"
      require("configx.lsp") -- Carga todas las configuraciones definidas en el "init.lua" de "lua/configx/lsp/init.lua"
    end
  }
}

