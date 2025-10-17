-- ===========================
--   Autocommands Inteligentes v4
-- ===========================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ========================================
-- GRUPO: Rendimiento Ultra
-- ========================================
local perf_group = augroup("SonrientePerf", { clear = true })

-- Desactivar cursorline cuando no estás en la ventana activa
autocmd({ "WinEnter", "BufEnter" }, {
  group = perf_group,
  callback = function()
    if vim.bo.buftype == "" then -- Solo en buffers normales
      vim.opt_local.cursorline = true
    end
  end,
  desc = "Activar cursorline en ventana activa",
})

autocmd({ "WinLeave", "BufLeave" }, {
  group = perf_group,
  callback = function()
    vim.opt_local.cursorline = false
  end,
  desc = "Desactivar cursorline al salir de ventana",
})

-- Cambiar entre número relativo y absoluto automáticamente
autocmd("InsertEnter", {
  group = perf_group,
  callback = function()
    vim.opt_local.relativenumber = false
  end,
  desc = "Números absolutos en modo Insert",
})

autocmd("InsertLeave", {
  group = perf_group,
  callback = function()
    if vim.opt.number:get() then
      vim.opt_local.relativenumber = true
    end
  end,
  desc = "Números relativos al salir de Insert",
})

-- Limpieza de memoria cuando Neovim está inactivo
autocmd("CursorHold", {
  group = perf_group,
  callback = function()
    collectgarbage("collect")
  end,
  desc = "Limpiar memoria en inactividad",
})

-- Redibujado acelerado durante comandos
autocmd("CmdlineEnter", {
  group = perf_group,
  callback = function()
    vim.opt.lazyredraw = true
  end,
  desc = "Lazy redraw al entrar a cmdline",
})

autocmd("CmdlineLeave", {
  group = perf_group,
  callback = function()
    vim.opt.lazyredraw = false
  end,
  desc = "Restaurar redraw normal",
})

-- Igualar splits al redimensionar ventana
autocmd("VimResized", {
  group = perf_group,
  callback = function()
    vim.cmd("wincmd =")
  end,
  desc = "Igualar splits al redimensionar",
})

-- ========================================
-- GRUPO: Auto-guardado Inteligente
-- ========================================
local save_group = augroup("SonrienteAutoSave", { clear = true })

-- Auto guardar al perder foco o cambiar de buffer
autocmd({ "FocusLost", "BufLeave" }, {
  group = save_group,
  callback = function()
    if vim.bo.modifiable and vim.bo.modified and vim.bo.buftype == "" then
      vim.cmd("silent! write")
    end
  end,
  desc = "Auto-guardar al cambiar de buffer",
})

-- ========================================
-- GRUPO: Resaltar al copiar
-- ========================================
local yank_group = augroup("SonrienteYankHighlight", { clear = true })

autocmd("TextYankPost", {
  group = yank_group,
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200,
    })
  end,
  desc = "Resaltar texto copiado",
})

-- ========================================
-- GRUPO: Limpieza de Espacios en Blanco
-- ========================================
local whitespace_group = augroup("SonrienteWhitespace", { clear = true })

-- Eliminar espacios al final de líneas al guardar
autocmd("BufWritePre", {
  group = whitespace_group,
  callback = function()
    -- Guardar posición del cursor
    local save = vim.fn.winsaveview()
    -- Eliminar espacios en blanco al final
    vim.cmd([[%s/\s\+$//e]])
    -- Restaurar posición
    vim.fn.winrestview(save)
  end,
  desc = "Eliminar espacios al final al guardar",
})

-- ========================================
-- GRUPO: Restaurar Posición del Cursor
-- ========================================
local cursor_group = augroup("SonrienteCursorRestore", { clear = true })

-- Volver a la última posición al abrir archivo
autocmd("BufReadPost", {
  group = cursor_group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
  desc = "Restaurar posición del cursor",
})

-- ========================================
-- GRUPO: Configuraciones por Tipo de Archivo
-- ========================================
local filetype_group = augroup("SonrienteFiletype", { clear = true })

-- Configuración para archivos de texto
autocmd("FileType", {
  group = filetype_group,
  pattern = { "text", "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.linebreak = true
  end,
  desc = "Config para archivos de texto",
})

-- Configuración para JSON/YAML
autocmd("FileType", {
  group = filetype_group,
  pattern = { "json", "jsonc", "yaml" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
  desc = "Indentación de 2 para JSON/YAML",
})

-- Configuración para Python
autocmd("FileType", {
  group = filetype_group,
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.colorcolumn = "88" -- Black's line length
  end,
  desc = "Config para Python",
})

-- Configuración para Lua
autocmd("FileType", {
  group = filetype_group,
  pattern = "lua",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
  desc = "Config para Lua",
})

-- ========================================
-- GRUPO: Checkhealth Automático
-- ========================================
local health_group = augroup("SonrienteHealth", { clear = true })

-- Checkhealth al iniciar (solo primera vez)
autocmd("VimEnter", {
  group = health_group,
  once = true,
  callback = function()
    -- Solo si no se abrió con un archivo
    if vim.fn.argc() == 0 then
      vim.defer_fn(function()
        -- Verificar que comandos importantes existen
        local commands = { "git", "rg", "fd" }
        local missing = {}
        for _, cmd in ipairs(commands) do
          if vim.fn.executable(cmd) == 0 then
            table.insert(missing, cmd)
          end
        end
        if #missing > 0 then
          vim.notify(
            "⚠️  Comandos faltantes: " .. table.concat(missing, ", "),
            vim.log.levels.WARN
          )
        end
      end, 1000)
    end
  end,
  desc = "Verificar dependencias al iniciar",
})

-- ========================================
-- GRUPO: Terminal
-- ========================================
local term_group = augroup("SonrienteTerminal", { clear = true })

-- Entrar automáticamente en modo insert en terminal
autocmd("TermOpen", {
  group = term_group,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
  desc = "Config para terminal",
})

-- ========================================
-- GRUPO: Ayuda
-- ========================================
local help_group = augroup("SonrienteHelp", { clear = true })

-- Abrir ayuda en ventana vertical
autocmd("FileType", {
  group = help_group,
  pattern = "help",
  callback = function()
    vim.cmd("wincmd L")
    vim.opt_local.number = true
  end,
  desc = "Ayuda en split vertical",
})

-- ========================================
-- GRUPO: Quickfix
-- ========================================
local qf_group = augroup("SonrienteQuickfix", { clear = true })

-- Cerrar quickfix con 'q'
autocmd("FileType", {
  group = qf_group,
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, desc = "Cerrar quickfix" })
  end,
  desc = "Keymaps para quickfix",
})

-- ========================================
-- GRUPO: Buffers Especiales
-- ========================================
local special_group = augroup("SonrienteSpecial", { clear = true })

-- Auto-cerrar ciertos buffers con 'q'
autocmd("FileType", {
  group = special_group,
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "startuptime",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
  desc = "Cerrar buffers especiales con 'q'",
})

-- ========================================
-- GRUPO: Detección de Archivos Grandes
-- ========================================
local bigfile_group = augroup("SonrienteBigFile", { clear = true })

-- Desactivar features pesadas en archivos grandes
autocmd("BufReadPre", {
  group = bigfile_group,
  callback = function()
    local max_filesize = 1024 * 1024 -- 1MB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      vim.opt_local.syntax = "off"
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.loadplugins = false
      vim.notify("📦 Archivo grande detectado, features desactivadas", vim.log.levels.WARN)
    end
  end,
  desc = "Optimizar para archivos grandes",
})

-- ========================================
-- GRUPO: Crear Directorios Automáticamente
-- ========================================
local mkdir_group = augroup("SonrienteMkdir", { clear = true })

-- Crear directorio si no existe al guardar
autocmd("BufWritePre", {
  group = mkdir_group,
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Crear directorio al guardar",
})
