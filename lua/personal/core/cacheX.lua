-- =========================================================
--   Sistema de Caché Inteligente - Inspirado en NvChad
-- =========================================================
-- Ubicación: lua/core/cacheX.lua

local M = {}
local uv = vim.loop
local cache_dir = vim.fn.stdpath("cache") .. "/sonriente"
local state_file = cache_dir .. "/state.json"

-- ========================================
-- INICIALIZACIÓN
-- ========================================

-- Crear directorio de caché si no existe
if vim.fn.isdirectory(cache_dir) == 0 then
  vim.fn.mkdir(cache_dir, "p")
end

-- Estado global del caché
M.state = {
  plugins = {},
  keymaps = {},
  commands = {},
  autocmds = {},
  highlights = {},
  options = {},
  last_updated = 0,
}

-- ========================================
-- CARGAR ESTADO DESDE DISCO
-- ========================================

function M.load_state()
  local ok, content = pcall(vim.fn.readfile, state_file)
  if ok and #content > 0 then
    local decoded = vim.json.decode(table.concat(content, ""))
    if decoded then
      M.state = vim.tbl_deep_extend("force", M.state, decoded)
      return true
    end
  end
  return false
end

-- ========================================
-- GUARDAR ESTADO A DISCO
-- ========================================

function M.save_state()
  local encoded = vim.json.encode(M.state)
  vim.fn.writefile({ encoded }, state_file)
  M.state.last_updated = os.time()
end

-- ========================================
-- CACHÉ DE MÓDULOS LUA
-- ========================================

-- Guardar qué módulos se cargaron para pre-cargarlos después
function M.track_module(module_name)
  if not M.state.plugins[module_name] then
    M.state.plugins[module_name] = {
      loaded_at = os.time(),
      load_count = 1,
    }
  else
    M.state.plugins[module_name].load_count =
      M.state.plugins[module_name].load_count + 1
  end
end

-- Pre-cargar módulos frecuentes
function M.preload_frequent_modules()
  local threshold = 5 -- Cargar si se usó más de 5 veces

  for module, data in pairs(M.state.plugins) do
    if data.load_count >= threshold then
      vim.schedule(function()
        pcall(require, module)
      end)
    end
  end
end

-- ========================================
-- CACHÉ DE CONFIGURACIONES
-- ========================================

-- Guardar configuración de highlights para cargarlos rápido
function M.cache_highlights()
  local hls = {}

  -- Capturar todos los highlights actuales
  local all_hls = vim.api.nvim_get_hl(0, {})

  for name, hl in pairs(all_hls) do
    if type(hl) == "table" and next(hl) then
      hls[name] = hl
    end
  end

  M.state.highlights = hls
  M.save_state()
end

-- Restaurar highlights desde caché
function M.restore_highlights()
  if not M.state.highlights or not next(M.state.highlights) then
    return false
  end

  for name, hl in pairs(M.state.highlights) do
    pcall(vim.api.nvim_set_hl, 0, name, hl)
  end

  return true
end

-- ========================================
-- CACHÉ DE KEYMAPS
-- ========================================

function M.cache_keymap(mode, lhs, rhs, opts)
  local key = mode .. lhs
  M.state.keymaps[key] = {
    mode = mode,
    lhs = lhs,
    rhs = type(rhs) == "string" and rhs or "<function>",
    opts = opts,
  }
end

-- ========================================
-- CACHÉ DE COMANDOS
-- ========================================

function M.cache_command(name, definition)
  M.state.commands[name] = {
    name = name,
    created_at = os.time(),
    definition = type(definition) == "string" and definition or "<function>",
  }
end

-- ========================================
-- LIMPIEZA DE CACHÉ
-- ========================================

function M.clean_cache()
  -- Eliminar módulos no usados en 30 días
  local threshold = os.time() - (30 * 24 * 60 * 60)

  for module, data in pairs(M.state.plugins) do
    if data.loaded_at < threshold and data.load_count < 3 then
      M.state.plugins[module] = nil
    end
  end

  M.save_state()
  vim.notify("🧹 Caché limpiado", vim.log.levels.INFO)
end

-- ========================================
-- AUTO-GUARDADO PERIÓDICO
-- ========================================

local save_timer = uv.new_timer()
save_timer:start(60000, 60000, vim.schedule_wrap(function()
  M.save_state()
end))

-- ========================================
-- OPTIMIZACIÓN DE CARGA INICIAL
-- ========================================

-- Compilar y cachear configuración de Lazy
function M.compile_lazy_config()
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then return end

  -- Forzar compilación del caché de Lazy
  vim.schedule(function()
    vim.cmd("Lazy! restore")
  end)
end

-- ========================================
-- HELPERS DE BÚSQUEDA RÁPIDA
-- ========================================

-- Caché para búsquedas de archivos
M.file_cache = {}
M.file_cache_ttl = 300 -- 5 minutos

function M.get_project_files(cwd)
  cwd = cwd or vim.fn.getcwd()
  local cache_key = cwd
  local cache = M.file_cache[cache_key]

  -- Verificar si caché es válido
  if cache and (os.time() - cache.timestamp) < M.file_cache_ttl then
    return cache.files
  end

  -- Buscar archivos
  local files = vim.fn.systemlist({
    "fd",
    "--type", "f",
    "--hidden",
    "--exclude", ".git",
    "--exclude", "node_modules",
  })

  -- Guardar en caché
  M.file_cache[cache_key] = {
    files = files,
    timestamp = os.time(),
  }

  return files
end

-- Limpiar caché de archivos cuando cambies de proyecto
function M.clear_file_cache()
  M.file_cache = {}
end

-- ========================================
-- ESTADÍSTICAS
-- ========================================

function M.get_stats()
  return {
    plugins_tracked = vim.tbl_count(M.state.plugins),
    keymaps_cached = vim.tbl_count(M.state.keymaps),
    commands_cached = vim.tbl_count(M.state.commands),
    highlights_cached = vim.tbl_count(M.state.highlights),
    cache_size = vim.fn.getfsize(state_file),
    last_updated = os.date("%Y-%m-%d %H:%M:%S", M.state.last_updated),
  }
end

function M.print_stats()
  local stats = M.get_stats()
  print("📊 Estadísticas de Caché:")
  print(string.format("  Plugins rastreados: %d", stats.plugins_tracked))
  print(string.format("  Keymaps: %d", stats.keymaps_cached))
  print(string.format("  Comandos: %d", stats.commands_cached))
  print(string.format("  Highlights: %d", stats.highlights_cached))
  print(string.format("  Tamaño: %.2f KB", stats.cache_size / 1024))
  print(string.format("  Última actualización: %s", stats.last_updated))
end

-- ========================================
-- COMANDOS DE USUARIO
-- ========================================

vim.api.nvim_create_user_command("CacheClean", M.clean_cache, {
  desc = "Limpiar caché antiguo"
})

vim.api.nvim_create_user_command("CacheStats", M.print_stats, {
  desc = "Mostrar estadísticas de caché"
})

vim.api.nvim_create_user_command("CacheClear", function()
  M.state = {
    plugins = {},
    keymaps = {},
    commands = {},
    autocmds = {},
    highlights = {},
    options = {},
    last_updated = 0,
  }
  M.save_state()
  M.clear_file_cache()
  vim.notify("🗑️  Caché completamente limpiado", vim.log.levels.WARN)
end, {
  desc = "Limpiar todo el caché"
})

-- ========================================
-- INICIALIZACIÓN AL CARGAR
-- ========================================

-- Cargar estado al inicio
M.load_state()

-- Pre-cargar módulos frecuentes en el fondo
vim.defer_fn(function()
  M.preload_frequent_modules()
end, 100)

-- Guardar estado al salir
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    M.save_state()
  end,
})

-- ========================================
-- INTEGRACIÓN CON LAZY.NVIM
-- ========================================

-- Hook para trackear carga de plugins SIN romper el require original
local original_require = require

-- Tabla para evitar loops infinitos
local tracking_in_progress = {}

_G.require = function(module)
  -- Llamar al require original PRIMERO
  local result = original_require(module)

  -- Evitar loop infinito
  if tracking_in_progress[module] then
    return result
  end

  -- Marcar como en progreso
  tracking_in_progress[module] = true

  -- Solo trackear módulos de plugins y configs (no core para evitar loops)
  if module:match("^plugins%.") or module:match("^configs%.") then
    -- Usar pcall para no romper nada si falla
    pcall(function()
      M.track_module(module)
    end)
  end

  -- Desmarcar
  tracking_in_progress[module] = nil

  return result
end

return M
