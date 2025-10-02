-- Configuracion de lua para que use su lsp cuando se abra un archivo lua.
local utils = require("configx.lsp.utils")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.lsp.start(vim.lsp.config.lua_ls(utils.make_opts({
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false,
          },
        },
      },
    })))
  end,
})

