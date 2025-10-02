-- Configurando Lazy que no sirve para cargar plugins solo cuando sea necesario --
require("configx.lazySetup")

-- Configurando tecla lider, en este caso sera el "Espacio"
-- La tecla lider se conoce como "<leader>", saber esto nos sirve para ejecutar muchas opciones y atajos que tengamos.
-- Configura tu tecla lider y presionala para saber que pasa.
vim.g.mapleader = " " -- Yo aca undi un "Espacio", entonces ahora la tecla lider que defini va ser el "Espacio", puedes cambiarlo por el que gustes.
vim.g.maplocalleader = "\\"

-- Activamos los numeros relativos, esto nos sirve para movernos de manera agil, si no sabes como hacerlo investiga un video, es muy util.
-- Si no te gusta ponlos ambos en false.

vim.opt.number = true
vim.opt.relativenumber = true 

require "keymapx" -- Cargamos los atajos que tenemos dentro de "lua/keymapx". -- Miralos y modificalos a tu gusto.

-- Los plugins tendran nombres bastante intuitivos, en la carpeta de "pluginx", dentro de "lua/pluginx" asi sabran reconocerlos y modificarlos.
require("lazy").setup({
  {  import = "pluginx" },}, lazy_config)


