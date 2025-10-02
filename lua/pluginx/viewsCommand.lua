-- Mirar comandos disponibles
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    window = {
      border = "rounded", -- Puedes cambiar a "single", "shadow", etc.
      position = "bottom", -- "top" también es válido
      margin = { 1, 0, 1, 0 },
      padding = { 2, 2, 2, 2 },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 4,
      align = "left", -- o "center"
    },
    triggers = "auto", -- muestra menú cuando presionas <leader>, g, z, etc.
  },
}

