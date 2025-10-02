-- Aquí defines qué servidores de leangujes, linter, etc quieres instalar con Mason
-- Puedes comentar los que no necesites o añadir nuevos fácilmente

return {
  -- Servidores LSP a instalar automáticamente
  -- Solo define el nombre según Mason (ver :Mason para lista)
  -- Yo dejare activos los que yo uso, pero tu modifica esto a tu gusto.
  "pyright",       -- Python
  "lua_ls",        -- Lua
  -- "tsserver",      -- JavaScript / TypeScript
  -- "html",          -- HTML
  -- "cssls",         -- CSS
  -- "clangd",     -- Para C/C++
}

