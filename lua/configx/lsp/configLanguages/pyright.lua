-- Estas configuraciones se encargan que el lsp de python solo carge cuando se abra un archivo python
-- Esto esta asi para que rinda mas y aprovechar las ventajas de Lazy.

local utils = require("configx.lsp.utils")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.lsp.start(vim.lsp.config.pyright(utils.make_opts({
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "strict",
            autoSearchPaths = true,
          }
        }
      }
    })))
  end
})

