-- =========================================================
--   LAZY.LUA OPTIMIZADO - LazyVim + Sistema de Caché v5
-- =========================================================

-- ========================================
-- BOOTSTRAP: Instalar lazy.nvim
-- ========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.notify("📦 Instalando lazy.nvim...", vim.log.levels.INFO)

  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "❌ Error al clonar lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPresiona cualquier tecla para salir..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end

  vim.notify("✅ lazy.nvim instalado correctamente", vim.log.levels.INFO)
end

vim.opt.rtp:prepend(lazypath)

-- ========================================
-- INICIALIZAR SISTEMA DE CACHÉ (TU v5)
-- ========================================
local cache_ok, cache = pcall(require, "util.cacheX")

if cache_ok then
  -- Cargar estado previo
  cache.load_state()

  -- Restaurar highlights (si existen)
  vim.schedule(function()
    if cache.restore_highlights() then
      -- Solo notificar si hay datos
      local stats = cache.get_stats()
      if stats.highlights_cached > 0 then
        vim.notify(
          string.format("💾 Caché: %d highlights restaurados", stats.highlights_cached),
          vim.log.levels.INFO
        )
      end
    end
  end)
end

-- ========================================
-- CONFIGURACIÓN DE LAZY
-- ========================================
require("lazy").setup({
  spec = {
    -- LazyVim base
    { "LazyVim/LazyVim",          import = "lazyvim.plugins" },

    -- Tus plugins personalizados
    { import = "plugins" },
    { import = "personal.plugins" }
  },

  -- ========================================
  -- DEFAULTS OPTIMIZADOS
  -- ========================================
  defaults = {
    -- 🔥 CAMBIO CRÍTICO: Lazy loading por defecto
    lazy = true, -- ✅ Cambié a true para optimizar

    -- Sin versiones fijas (siempre latest)
    version = false,

    -- Cargar SOLO cuando se necesite
    -- (LazyVim maneja sus propios plugins internamente)
  },

  -- ========================================
  -- INSTALACIÓN
  -- ========================================
  install = {
    colorscheme = { "tokyonight", "catppuccin", "habamax" },
    missing = true, -- Instalar plugins faltantes automáticamente
  },

  -- ========================================
  -- CHECKER DE ACTUALIZACIONES
  -- ========================================
  checker = {
    enabled = true,
    notify = false,       -- Sin notificaciones molestas
    frequency = 3600,     -- Revisar cada hora
    check_pinned = false, -- No revisar plugins pinned
  },

  -- ========================================
  -- CHANGE DETECTION
  -- ========================================
  change_detection = {
    enabled = true,
    notify = false, -- Sin notificaciones al detectar cambios
  },

  -- ========================================
  -- PERFORMANCE ULTRA-OPTIMIZADO
  -- ========================================
  performance = {
    cache = {
      enabled = true,
    },

    reset_packpath = true, -- Mejor rendimiento

    rtp = {
      reset = true, -- Limpiar runtimepath

      -- ========================================
      -- PLUGINS INTEGRADOS DESHABILITADOS
      -- ========================================
      disabled_plugins = {
        -- Compresión (no los usamos)
        "gzip",
        "tarPlugin",
        "zipPlugin",

        -- Scripting viejo
        "2html_plugin",
        "tohtml",

        -- Tutoriales (ya sabes usar Vim)
        "tutor",
        "tutor_mode_plugin",

        -- Netrw (file explorer viejo)
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",

        -- Matchparen (LazyVim trae mejor alternativa)
        "matchit",
        "matchparen",

        -- Plugins viejos que no usamos
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        "logipat",
        "rrhelper",

        -- Spell (si no usas corrector ortográfico)
        -- "spellfile_plugin",  -- Descomenta si no usas spell
      },
    },
  },

  -- ========================================
  -- UI PERSONALIZADA
  -- ========================================
  ui = {
    size = { width = 0.85, height = 0.85 },
    border = "rounded",
    title = "😼 Lazy - Gestor de Plugins",
    title_pos = "center",

    -- Iconos personalizados
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤",
      loaded = "●",
      not_loaded = "○",
    },
  },

  -- ========================================
  -- LOCKFILE
  -- ========================================
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",

  -- ========================================
  -- GIT CONFIG
  -- ========================================
  git = {
    log = { "--since=3 days ago" }, -- Solo commits recientes
    timeout = 120,
    url_format = "https://github.com/%s.git",
    filter = true, -- Clone parcial (más rápido)
  },

  -- ========================================
  -- README
  -- ========================================
  readme = {
    enabled = true,
    root = vim.fn.stdpath("state") .. "/lazy/readme",
    files = { "README.md", "lua/**/README.md" },
    skip_if_doc_exists = true,
  },

  -- ========================================
  -- DEV (Desarrollo de plugins)
  -- ========================================
  dev = {
    path = "~/projects",
    patterns = {}, -- Agregar tus repos si desarrollas plugins
    fallback = false,
  },

  -- ========================================
  -- PROFILING
  -- ========================================
  profiling = {
    loader = false,
    require = false,
  },
})

-- ========================================
-- POST-SETUP: INTEGRACIÓN DE CACHÉ
-- ========================================

if cache_ok then
  -- Auto-guardado al salir
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      cache.save_state()
    end,
  })

  -- Cachear highlights al cambiar colorscheme
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      vim.defer_fn(function()
        cache.cache_highlights()
      end, 100)
    end,
  })

  -- Auto-guardado periódico (cada minuto)
  local timer = vim.loop.new_timer()
  timer:start(60000, 60000, vim.schedule_wrap(function()
    cache.save_state()
  end))
end

-- ========================================
-- ESTADÍSTICAS AL FINALIZAR CARGA
-- ========================================
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.schedule(function()
      local stats = require("lazy").stats()
      local ms = math.floor(stats.startuptime * 100 + 0.5) / 100

      local cache_status = cache_ok and "✅" or "❌"
      local cache_info = ""

      if cache_ok then
        local cache_stats = cache.get_stats()
        cache_info = string.format(" | 💾 %d módulos", cache_stats.plugins_tracked)
      end

      vim.notify(
        string.format(
          "😼 LazyVim | %d plugins | %.2fms | Caché: %s%s",
          stats.count,
          ms,
          cache_status,
          cache_info
        ),
        vim.log.levels.INFO
      )
    end)
  end,
})

-- ========================================
-- COMANDOS PERSONALIZADOS
-- ========================================

-- Ver estadísticas completas
vim.api.nvim_create_user_command("LazyStats", function()
  local stats = require("lazy").stats()

  print("\n╔═══════════════════════════════════════════════╗")
  print("║         📊 ESTADÍSTICAS DE LAZY              ║")
  print("╚═══════════════════════════════════════════════╝")
  print(string.format("  Plugins totales:    %d", stats.count))
  print(string.format("  Cargados:           %d", stats.loaded))
  print(string.format("  Tiempo de inicio:   %.2fms", stats.startuptime or 0))
  print(string.format("  Lazy-loaded:        %d (%.0f%%)",
    stats.count - stats.loaded,
    ((stats.count - stats.loaded) / stats.count) * 100))

  if cache_ok then
    print("\n  💾 Sistema de Caché:")
    local cache_stats = cache.get_stats()
    print(string.format("     Módulos:         %d", cache_stats.plugins_tracked))
    print(string.format("     Highlights:      %d", cache_stats.highlights_cached))
    print(string.format("     Tamaño:          %.2f KB", cache_stats.cache_size / 1024))
  end

  print("═══════════════════════════════════════════════\n")
end, { desc = "Mostrar estadísticas completas" })

-- Optimizar sistema completo
vim.api.nvim_create_user_command("LazyOptimize", function()
  print("⚡ Optimizando sistema...")

  -- 1. Limpiar caché de lazy
  require("lazy").clean()
  print("  ✓ Plugins limpiados")

  -- 2. Compilar caché
  require("lazy").sync()
  print("  ✓ Caché compilado")

  -- 3. Limpiar caché personalizado
  if cache_ok then
    cache.clean_cache()
    print("  ✓ Caché v5 limpiado")
  end

  -- 4. Garbage collection
  collectgarbage("collect")
  collectgarbage("collect")
  print("  ✓ Memoria liberada")

  print("\n✅ Sistema optimizado completamente\n")
end, { desc = "Optimizar sistema completo" })
