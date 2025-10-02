-- Aca agrege un estilo mas visual y amigable a la vista, mejora estilo de notificaciones y otras cositas bonitas.
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim", -- UI base
      "rcarriga/nvim-notify", -- Motor de notificaciones
    },
    config = function()
      require("noice").setup({
        lsp = {
          progress = {
            enabled = true, -- Muestra progreso de LSP (útil con Mason)
          },
          signature = {
            enabled = true,
          },
        },
        presets = {
          bottom_search = true,        -- El ":" y "/" aparecen abajo
          command_palette = true,      -- Comandos tipo paleta
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,       -- Borde para docs del LSP
        },
      })

      vim.notify = require("notify") -- Reemplaza notify por defecto
    end,
  },
}

