-- ===========================
--   Opciones Base Optimizadas v4
-- ===========================
local opt = vim.opt
local g = vim.g

-- ========================================
-- LÍDER KEYS (lo más importante primero)
-- ========================================
-- g.mapleader = " "
-- g.maplocalleader = "_"
-- Para evitar problemas, se cargara en "lua/config/options.lua"
-- Esto hara que se carge despues del lazy y no ocurran errores

-- ========================================
-- INTERFAZ Y NAVEGACIÓN
-- ========================================
opt.number = true         -- Números absolutos
opt.relativenumber = true -- Números relativos para movimiento ninja
opt.cursorline = true     -- Resalta línea actual
opt.cursorcolumn = false  -- No resaltar columna (ahorra rendimiento)
opt.signcolumn = "yes"    -- Columna de signos siempre visible
opt.colorcolumn = "88"    -- Guía visual a los 80 caracteres
opt.scrolloff = 8         -- Margen vertical al mover cursor
opt.sidescrolloff = 8     -- Margen horizontal
opt.wrap = false          -- Sin wrap de líneas largas
opt.linebreak = true      -- Si activas wrap, corta en palabras
opt.showmode = false      -- No mostrar -- INSERT -- (lo hace statusline)
opt.cmdheight = 1         -- Altura mínima de línea de comandos
opt.laststatus = 3        -- Statusline global único (mejor rendimiento)
opt.splitbelow = true     -- Splits horizontales abajo
opt.splitright = true     -- Splits verticales a la derecha
opt.termguicolors = true  -- Colores RGB verdaderos
opt.winblend = 0          -- Sin transparencia en ventanas flotantes
opt.pumblend = 0          -- Sin transparencia en menú popup
opt.pumheight = 10        -- Altura máxima del menú de completado

-- ========================================
-- TABS E INDENTACIÓN
-- ========================================
opt.expandtab = true   -- Espacios en vez de tabs
opt.tabstop = 4        -- Ancho de tab
opt.softtabstop = 4    -- Ancho al presionar Tab
opt.shiftwidth = 4     -- Ancho de indentación
opt.smartindent = true -- Indentación inteligente
opt.autoindent = true  -- Mantener indentación
opt.shiftround = true  -- Redondear indentación a múltiplos de shiftwidth
opt.breakindent = true -- Mantener indentación en líneas wrapeadas

-- ========================================
-- BÚSQUEDA
-- ========================================
opt.ignorecase = true -- Ignorar mayúsculas en búsqueda
opt.smartcase = true  -- Ser sensible si hay mayúsculas
opt.incsearch = true  -- Búsqueda incremental
opt.hlsearch = false  -- No resaltar búsquedas antiguas
opt.wrapscan = true   -- Búsqueda circular

-- ========================================
-- SISTEMA Y RENDIMIENTO
-- ========================================
opt.clipboard = "unnamedplus" -- Integración con clipboard del sistema
opt.hidden = true             -- Mantener buffers en memoria
opt.updatetime = 250          -- Tiempo para CursorHold y swap (ms)
opt.timeoutlen = 500          -- Tiempo para detectar combinaciones de teclas
opt.ttimeoutlen = 10          -- Tiempo para secuencias de escape
opt.redrawtime = 1500         -- Tiempo máximo para redibujado de sintaxis
opt.lazyredraw = false        -- Redibujado inmediato (mejor UX en Neovim moderno)
opt.ttyfast = true            -- Terminal rápida
opt.synmaxcol = 240           -- No colorear sintaxis después de columna 240
opt.re = 0                    -- Motor regex automático (más inteligente)

-- ========================================
-- ARCHIVOS Y BACKUPS
-- ========================================
opt.swapfile = false                            -- Sin archivos swap
opt.backup = false                              -- Sin backups
opt.writebackup = false                         -- Sin backup temporal al guardar
opt.undofile = true                             -- Historial persistente de cambios
opt.undolevels = 10000                          -- Muchos niveles de undo
opt.undodir = vim.fn.stdpath("data") .. "/undo" -- Carpeta para archivos undo
opt.autoread = true                             -- Recargar archivo si cambió externamente
opt.autowrite = true                            -- Auto-guardar al cambiar de buffer

-- ========================================
-- HISTORIA Y COMANDOS
-- ========================================
opt.history = 1000  -- Historial grande de comandos
opt.showcmd = false -- No mostrar comandos parciales
opt.ruler = false   -- Sin ruler (lo hace statusline)

-- ========================================
-- LIMPIEZA VISUAL
-- ========================================
opt.fillchars = {
  eob = " ", -- Eliminar ~ al final de buffers
  fold = " ",
  foldopen = " ",
  foldclose = " ",
  foldsep = " ",
  diff = "╱",
  msgsep = "‾",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}
opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "⟩",
  precedes = "⟨",
}
opt.list = false          -- No mostrar caracteres invisibles por defecto
opt.shortmess:append("c") -- Mensajes más concisos
opt.shortmess:append("I") -- Sin intro al iniciar
opt.shortmess:append("W") -- No mostrar "written" al guardar
opt.shortmess:append("a") -- Abreviar mensajes

-- ========================================
-- COMPLETADO
-- ========================================
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.wildmode = { "longest:full", "full" }
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class" })
opt.wildignore:append({ ".git", "node_modules", "__pycache__" })

-- ========================================
-- MOUSE Y SONIDOS
-- ========================================
opt.mouse = "a"           -- Mouse habilitado en todos los modos
opt.mousemoveevent = true -- Detectar movimiento de mouse
opt.errorbells = false    -- Sin campanas de error
opt.visualbell = true     -- Parpadeo visual en vez de beep

-- ========================================
-- FOLDING (plegado de código)
-- ========================================
opt.foldmethod = "manual" -- Plegado manual (mejor rendimiento)
opt.foldlevel = 99        -- Mostrar todo desplegado por defecto
opt.foldlevelstart = 99   -- Empezar con todo desplegado
opt.foldenable = true     -- Habilitar folding

-- ========================================
-- SEGURIDAD
-- ========================================
opt.modeline = false -- Deshabilitar modelines (seguridad)
opt.secure = true    -- Modo seguro para .nvimrc en proyectos

-- ========================================
-- MISCELÁNEOS
-- ========================================
opt.virtualedit = "block"                   -- Mover cursor libremente en visual block
opt.inccommand = "split"                    -- Preview de sustituciones en tiempo real
opt.jumpoptions = "stack"                   -- Mejor navegación de jumplist
opt.spelloptions = "camel"                  -- Spell check reconoce camelCase
opt.spelllang = { "en", "es" }              -- Idiomas para spell check
opt.spell = false                           -- Spell check desactivado por defecto
opt.confirm = true                          -- Confirmar acciones destructivas
opt.formatoptions:remove({ "c", "r", "o" }) -- No auto-comentar líneas nuevas

-- ========================================
-- OPTIMIZACIONES ESPECÍFICAS DE NEOVIM
-- ========================================
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true -- Scroll suave (Neovim 0.10+)
end

-- Deshabilitar providers innecesarios
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- ========================================
-- CREAR DIRECTORIO UNDO SI NO EXISTE
-- ========================================
local undo_dir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end
