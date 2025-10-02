-- Instalare un tema con colores pasteles y coloreado suave de variables, es como un abrazo al Alma :D
--
return {
  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("duskfox") -- De este tema puedes elegir el:  
    end,
  },
}

