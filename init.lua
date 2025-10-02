-- Configurando Lazy que no sirve para cargar plugins solo cuando sea necesario --
require("configx.lazySetup")

-- Configurando tecla lider, en este caso sera el "Espacio"
vim.g.mapleader = " " -- La tecla lider se conoce como <leader> - saber esto nos sirve para crear los atajos despues.
vim.g.maplocalleader = "\\"

require "keymapx" -- Cargamos los atajos que tenemos dentro de "lua/keymapx". -- Miralos y modificalos a tu gusto.

-- Los plugins tendran nombres bastante intuitivos, en la carpeta de "pluginx", dentro de "lua/pluginx" asi sabran reconocerlos y modificarlos.
require("lazy").setup({
  {  import = "pluginx" },}, lazy_config)
