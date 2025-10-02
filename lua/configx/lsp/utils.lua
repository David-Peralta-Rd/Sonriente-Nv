-- Aqui configuramos herramientas utiles para usar con el lenguaje.
local M = {}

-- Capabilities para autocompletado (si usas nvim-cmp)
-- M.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Función que se ejecuta cuando se conecta un LSP al buffer
M.on_attach = function(client, bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr, silent = true }

  map("n", "K", vim.lsp.buf.hover, opts)
  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)
  -- Puedes añadir más funciones comunes aquí
end

-- Función para combinar configuración común + específica
function M.make_opts(extra)
  return vim.tbl_deep_extend("force", {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
  }, extra or {})
end

return M

