-- Configuracion de lsp, intentare hacerlo lo mas compatible para que no tengas problemas :D.


local lspconfig = require("lspconfig")
local mason_lsp = require("mason-lspconfig")

mason_lsp.setup({
  ensure_installed = { "lua_ls" }, -- lo que quieras
})


languageSelect = {
    "lua_ls",
},


local capabilities = require("cmp_nvim_lsp").default_capabilities()

mason_lsp.setup_handlers({
  function(server)
    lspconfig[server].setup({
      capabilities = capabilities,
    })
  end,
})
