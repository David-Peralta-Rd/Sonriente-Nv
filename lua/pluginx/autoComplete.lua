-- Plugin de auto completado, este nos ayuda a trabajar eficientemente.

return {
  {
    "hrsh7th/nvim-cmp",         -- El motor principal de autocompletado
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- Fuente para LSP
      "hrsh7th/cmp-buffer",     -- Fuente para buffer actual
      "hrsh7th/cmp-path",       -- Autocompletado de rutas
      "saadparwaiz1/cmp_luasnip", -- Fuente para snippets
      "L3MON4D3/LuaSnip",       -- Motor de snippets
      "rafamadriz/friendly-snippets", -- Snippets ya hechos
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Cargar snippets ya hechos (opcional pero útil)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}

