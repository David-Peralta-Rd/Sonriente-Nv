-- Aqui un status de linea bonito y elegante, lo que nos merecemos.
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto", -- se adapta al color del tema.
        section_separators = "",
        component_separators = "",
      },
    })
  end,
}

