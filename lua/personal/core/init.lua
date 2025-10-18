-- ======================================
--   Núcleo Central - SONRIENTE NV v5
--   Con Sistema de Caché Inteligente
-- ======================================

-- ========================================
-- PRE-INICIALIZACIÓN: CACHÉ DE IMPATIENT
-- ========================================

-- Cargar impatient.nvim si está disponible (carga más rápida de módulos Lua)
local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
  impatient.enable_profile()
end

-- ========================================
-- VERIFICACIÓN DE VERSIÓN
-- ========================================

local function check_neovim_version()
  local required = "0.9.0"
  if vim.fn.has("nvim-" .. required) == 0 then
    vim.notify(
      string.format(
        "⚠️ Sonriente-Nv v5 requiere Neovim >= %s\n" ..
        "Versión actual: %s\n" ..
        "Actualiza Neovim para continuar.",
        required,
        vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
      ),
      vim.log.levels.ERROR
    )
    return false
  end
  return true
end

if not check_neovim_version() then
  return
end

-- ========================================
-- INICIALIZACIÓN DE CACHÉ
-- ========================================

-- Cargar sistema de caché PRIMERO
local cache_ok, cache = pcall(require, "personal.core.cacheX")
if cache_ok then
  -- Restaurar highlights desde caché (ahorra tiempo)
  if not cache.restore_highlights() then
    -- Si no hay caché, se cargarán normalmente
  end
end

-- ========================================
-- FUNCIÓN DE CARGA SEGURA
-- ========================================

local load_times = {}

local function safe_require(module)
  local start = vim.loop.hrtime()
  local ok, err = pcall(require, module)
  local elapsed = (vim.loop.hrtime() - start) / 1e6 -- ms

  if ok then
    load_times[module] = elapsed

    -- Trackear en caché
    if cache_ok then
      cache.track_module(module)
    end

    return true
  else
    vim.notify(
      string.format("❌ Error cargando '%s':\n%s", module, err),
      vim.log.levels.ERROR
    )
    return false
  end
end

-- ========================================
-- ORDEN DE CARGA OPTIMIZADO
-- ========================================

-- Fase 1: CRÍTICOS (cargan inmediatamente)
local critical_modules = {
  "personal.core.utilX",   -- Utilidades base
  "personal.core.optionX", -- Opciones de Neovim

}

-- Fase 2: ALTA PRIORIDAD (cargan con pequeño delay)
local high_priority_modules = {
  "personal.core.keymapX",  -- Keymaps globales
  "personal.core.autocmdX", -- Autocomandos
}

-- Fase 3: NORMAL (cargan después)
local normal_modules = {
  "personal.core.loaderX", -- Sistema de lazy loading
}

-- ========================================
-- CARGA SECUENCIAL
-- ========================================

-- Cargar módulos críticos inmediatamente
for _, module in ipairs(critical_modules) do
  safe_require(module)
end

-- Cargar módulos de alta prioridad con pequeño delay
vim.defer_fn(function()
  for _, module in ipairs(high_priority_modules) do
    safe_require(module)
  end
end, 1)

-- Cargar módulos normales después
vim.defer_fn(function()
  for _, module in ipairs(normal_modules) do
    safe_require(module)
  end
end, 5)

-- ========================================
-- POST-CARGA: OPTIMIZACIONES
-- ========================================

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    -- Esperar a que todo cargue
    vim.schedule(function()
      -- Obtener estadísticas de Lazy
      local lazy_ok, lazy = pcall(require, "lazy")
      if lazy_ok then
        local stats = lazy.stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100

        vim.notify(
          string.format(
            "😼 Sonriente Nv v5 | %d plugins | %.2fms | 🚀 Caché: %s",
            stats.count,
            ms,
            cache_ok and "✅" or "❌"
          ),
          vim.log.levels.INFO
        )
      end

      -- Guardar highlights al caché después de cargar todo
      if cache_ok then
        vim.defer_fn(function()
          cache.cache_highlights()
        end, 1000)
      end

      -- Limpieza de memoria inicial
      vim.defer_fn(function()
        collectgarbage("collect")
      end, 2000)
    end)
  end,
})

-- ========================================
-- COMANDO: RECARGAR CONFIGURACIÓN
-- ========================================

vim.api.nvim_create_user_command("ReloadConfig", function()
  -- Limpiar módulos cargados
  for name, _ in pairs(package.loaded) do
    if name:match("^core") or name:match("^plugins") or name:match("^configs") then
      package.loaded[name] = nil
    end
  end

  -- Recargar init.lua
  dofile(vim.env.MYVIMRC)

  -- Limpiar y recargar caché
  if cache_ok then
    cache.save_state()
  end

  vim.notify("🔄 Configuración recargada", vim.log.levels.INFO)
end, { desc = "Recargar configuración de Neovim" })

-- ========================================
-- COMANDO: MOSTRAR TIEMPOS DE CARGA
-- ========================================

vim.api.nvim_create_user_command("LoadTimes", function()
  -- Ordenar por tiempo
  local sorted = {}
  for module, time in pairs(load_times) do
    table.insert(sorted, { module = module, time = time })
  end

  table.sort(sorted, function(a, b)
    return a.time > b.time
  end)

  print("\n⏱️  Tiempos de carga de módulos core:")
  print(string.rep("─", 50))

  for i, item in ipairs(sorted) do
    local color = item.time > 10 and "WarningMsg" or "Normal"
    vim.api.nvim_echo({
      { string.format("%d. ", i),             "Number" },
      { string.format("%-30s ", item.module), "String" },
      { string.format("%.2fms", item.time),   color },
    }, false, {})
  end

  print(string.rep("─", 50))

  local total = 0
  for _, item in ipairs(sorted) do
    total = total + item.time
  end
  print(string.format("Total: %.2fms\n", total))
end, { desc = "Mostrar tiempos de carga" })

-- ========================================
-- COMANDO: OPTIMIZAR SISTEMA
-- ========================================

vim.api.nvim_create_user_command("OptimizeNvim", function()
  -- 1. Limpiar caché viejo
  if cache_ok then
    cache.clean_cache()
  end

  -- 2. Compilar lazy cache
  local lazy_ok, lazy = pcall(require, "lazy")
  if lazy_ok then
    lazy.sync()
  end

  -- 3. Limpiar packpath
  vim.opt.packpath = vim.fn.stdpath("data") .. "/site"

  -- 4. Garbage collection agresivo
  collectgarbage("collect")
  collectgarbage("collect")

  vim.notify("⚡ Sistema optimizado", vim.log.levels.INFO)
end, { desc = "Optimizar Neovim completamente" })

-- ========================================
-- COMANDO: DIAGNOSTICAR PROBLEMAS
-- ========================================

vim.api.nvim_create_user_command("DiagnoseNvim", function()
  print("\n🔍 Diagnóstico de Sonriente Nv:")
  print(string.rep("═", 60))

  -- Versión de Neovim
  local version = vim.version()
  print(string.format("📌 Neovim: v%d.%d.%d", version.major, version.minor, version.patch))

  -- Sistema de caché
  if cache_ok then
    local stats = cache.get_stats()
    print(string.format("💾 Caché: ✅ Activo"))
    print(string.format("   - Plugins rastreados: %d", stats.plugins_tracked))
    print(string.format("   - Tamaño: %.2f KB", stats.cache_size / 1024))
  else
    print("💾 Caché: ❌ No disponible")
  end

  -- Lazy.nvim
  local lazy_ok, lazy = pcall(require, "lazy")
  if lazy_ok then
    local stats = lazy.stats()
    print(string.format("🔌 Lazy.nvim: ✅ %d plugins", stats.count))
    print(string.format("   - Tiempo de inicio: %.2fms", stats.startuptime))
  else
    print("🔌 Lazy.nvim: ❌ No cargado")
  end

  -- Memoria
  local mem = collectgarbage("count")
  print(string.format("🧠 Memoria Lua: %.2f MB", mem / 1024))

  -- Comandos importantes
  local commands = { "git", "rg", "fd", "make" }
  print("\n🔧 Comandos del sistema:")
  for _, cmd in ipairs(commands) do
    local status = vim.fn.executable(cmd) == 1 and "✅" or "❌"
    print(string.format("   %s %s", status, cmd))
  end

  -- Providers
  print("\n🐍 Providers:")
  local providers = {
    python3 = vim.g.loaded_python3_provider,
    ruby = vim.g.loaded_ruby_provider,
    node = vim.g.loaded_node_provider,
  }
  for name, status in pairs(providers) do
    local icon = status == 0 and "🔴 Deshabilitado" or "✅ Activo"
    print(string.format("   %s: %s", name, icon))
  end

  print(string.rep("═", 60) .. "\n")
end, { desc = "Diagnosticar estado del sistema" })

-- ========================================
-- AUTO-GUARDADO DE CACHÉ AL SALIR
-- ========================================

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if cache_ok then
      cache.save_state()
    end
  end,
})

-- ========================================
-- LIMPIEZA PERIÓDICA DE MEMORIA
-- ========================================

-- Limpiar memoria cada 5 minutos
local cleanup_timer = vim.loop.new_timer()
cleanup_timer:start(300000, 300000, vim.schedule_wrap(function()
  collectgarbage("collect")
end))

-- ========================================
-- MENSAJE DE BIENVENIDA (OPCIONAL)
-- ========================================

if vim.fn.argc() == 0 then -- Solo si no se abrió con archivo
  vim.defer_fn(function()
    local hour = tonumber(os.date("%H"))
    local greeting

    if hour < 12 then
      greeting = "Buenos días"
    elseif hour < 18 then
      greeting = "Buenas tardes"
    else
      greeting = "Buenas noches"
    end

    -- ASCII art minimalista (opcional)
    local logo = {
      "",
      "   ╭─────────────────────────────╮",
      "   │  😼 Sonriente Nv v5       │",
      "   │  " .. greeting .. "! 🚀           │",
      "   ╰─────────────────────────────╯",
      "",
    }

    -- Solo mostrar si el buffer está vacío
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_line_count(bufnr) == 1
        and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == "" then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, logo)
      vim.bo[bufnr].modifiable = false
      vim.bo[bufnr].modified = false
    end
  end, 50)
end
