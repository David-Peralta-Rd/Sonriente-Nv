-- ======================================
--   Utilidades Globales - Sonriente v4
-- ======================================

local M = {}

-- ========================================
-- Funciones de mapeo simplificadas
-- ========================================

-- Mapeo básico mejorado
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false -- silent por defecto
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Mapeo con descripción (para which-key y ayuda)
function M.nmap(lhs, rhs, desc)
  M.map("n", lhs, rhs, { desc = desc })
end

function M.vmap(lhs, rhs, desc)
  M.map("v", lhs, rhs, { desc = desc })
end

function M.imap(lhs, rhs, desc)
  M.map("i", lhs, rhs, { desc = desc })
end

function M.tmap(lhs, rhs, desc)
  M.map("t", lhs, rhs, { desc = desc })
end

-- ========================================
-- Autocomandos simplificados
-- ========================================

function M.augroup(name)
  return vim.api.nvim_create_augroup("Sonriente_" .. name, { clear = true })
end

function M.autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, opts)
end

-- ========================================
-- Verificación de archivos/directorios
-- ========================================

function M.file_exists(path)
  return vim.fn.filereadable(path) == 1
end

function M.dir_exists(path)
  return vim.fn.isdirectory(path) == 1
end

function M.path_exists(path)
  return M.file_exists(path) or M.dir_exists(path)
end

-- ========================================
-- Ejecutar comandos del sistema
-- ========================================

function M.execute_command(cmd)
  local handle = io.popen(cmd)
  if not handle then return nil end
  local result = handle:read("*a")
  handle:close()
  return result and vim.trim(result) or nil
end

-- ========================================
-- Notificaciones mejoradas
-- ========================================

function M.notify(msg, level)
  level = level or vim.log.levels.INFO
  vim.notify(msg, level)
end

function M.error(msg)
  M.notify("❌ " .. msg, vim.log.levels.ERROR)
end

function M.warn(msg)
  M.notify("⚠️  " .. msg, vim.log.levels.WARN)
end

function M.info(msg)
  M.notify("ℹ️  " .. msg, vim.log.levels.INFO)
end

function M.success(msg)
  M.notify("✅ " .. msg, vim.log.levels.INFO)
end

-- ========================================
-- Helpers para buffers y ventanas
-- ========================================

function M.buf_is_valid(bufnr)
  return bufnr and vim.api.nvim_buf_is_valid(bufnr)
end

function M.buf_is_empty(bufnr)
  bufnr = bufnr or 0
  return vim.api.nvim_buf_line_count(bufnr) == 1
      and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == ""
end

function M.close_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].modified then
    M.warn("Buffer tiene cambios sin guardar")
    return
  end
  vim.cmd("bdelete")
end

-- ========================================
-- Gestión de plugins (lazy.nvim)
-- ========================================

function M.has_plugin(plugin_name)
  return require("lazy.core.config").plugins[plugin_name] ~= nil
end

function M.plugin_loaded(plugin_name)
  return require("lazy.core.config").plugins[plugin_name] and
      require("lazy.core.config").plugins[plugin_name]._.loaded
end

-- ========================================
-- Limpieza de memoria
-- ========================================

function M.cleanup_memory()
  collectgarbage("collect")
end

-- Auto limpieza cada 5 minutos
local cleanup_timer = vim.loop.new_timer()
cleanup_timer:start(300000, 300000, vim.schedule_wrap(M.cleanup_memory))

-- ========================================
-- Toggle opciones comunes
-- ========================================

function M.toggle_option(option)
  vim.opt[option] = not vim.opt[option]:get()
  M.info(string.format("%s: %s", option, vim.opt[option]:get()))
end

function M.toggle_wrap()
  M.toggle_option("wrap")
end

function M.toggle_spell()
  M.toggle_option("spell")
end

function M.toggle_relative_number()
  M.toggle_option("relativenumber")
end

-- ========================================
-- Debugging helpers
-- ========================================

function M.inspect(value)
  print(vim.inspect(value))
end

function M.profile_start()
  require("lazy").profile.start()
  M.info("Profiling iniciado")
end

function M.profile_stop()
  require("lazy").profile.stop()
  M.info("Profiling detenido")
end

-- ========================================
-- Exportar utilidades globalmente (opcional)
-- ========================================

_G.Utils = M

return M
