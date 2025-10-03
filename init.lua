-- Carga principal de todos los ajustes OwO


-- Core Configuración--
require("coreX")

-- Lazy bootstrap --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Carga de plugins --
require("lazy").setup("pluginX", {
  ui = { border = "rounded" },
})
