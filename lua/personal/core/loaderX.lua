-- =========================================================
--   Lazy Loader Inteligente con Prioridades
-- =========================================================
-- Ubicación: lua/custom/core/loaderX.lua

local M = {}
local cache = require("core.cacheX")

-- ========================================
-- PRIORIDADES DE CARGA
-- ========================================

M.priorities = {
  -- Críticos - Cargan primero
  critical = {
    "nvim-treesitter",
    "nvim-lspconfig",
    "mason.nvim",
  },

  -- Alta prioridad - UI básica
  high = {
    "which-key.nvim",
    "telescope.nvim",
    "nvim-cmp",
  },

  -- Media - Features comunes
  medium = {
    "gitsigns.nvim",
    "Comment.nvim",
    "indent-blankline.nvim",
  },

  -- Baja - Features ocasionales
  low = {
    "trouble.nvim",
    "todo-comments.nvim",
  },

  -- Muy baja - Solo cuando se necesiten
  defer = {
    "neogit",
    "diffview.nvim",
  }
}

-- ========================================
-- DETECCIÓN DE CONTEXTO
-- ========================================

-- Detectar si estamos en un proyecto Git
function M.is_git_repo()
  local git_dir = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
  return git_dir ~= ""
end

-- Detectar tipo de proyecto
function M.detect_project_type()
  local cwd = vim.fn.getcwd()

  -- Node.js
  if vim.fn.filereadable(cwd .. "/package.json") == 1 then
    return "node"
  end

  -- Python
  if vim.fn.filereadable(cwd .. "/requirements.txt") == 1
      or vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
    return "python"
  end

  -- Rust
  if vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
    return "rust"
  end

  -- Go
  if vim.fn.filereadable(cwd .. "/go.mod") == 1 then
    return "go"
  end

  return "generic"
end

-- ========================================
-- CARGA CONDICIONAL INTELIGENTE
-- ========================================

-- Cargar plugins solo si son necesarios para el proyecto actual
function M.should_load_plugin(plugin_name)
  local project_type = M.detect_project_type()

  -- Plugins específicos por lenguaje
  local language_plugins = {
    node = { "typescript-tools", "package-info" },
    python = { "nvim-dap-python" },
    rust = { "rust-tools", "crates.nvim" },
  }

  -- Si el plugin es específico del lenguaje
  for lang, plugins in pairs(language_plugins) do
    if vim.tbl_contains(plugins, plugin_name) then
      return project_type == lang
    end
  end

  return true
end

-- ========================================
-- PATRONES DE LAZY LOADING
-- ========================================

-- Pattern para UI plugins (cargar en VeryLazy)
function M.ui_plugin_spec(plugin)
  return vim.tbl_extend("force", plugin, {
    event = "VeryLazy",
    priority = 50,
  })
end

-- Pattern para LSP plugins (cargar al abrir archivo)
function M.lsp_plugin_spec(plugin)
  return vim.tbl_extend("force", plugin, {
    event = { "BufReadPre", "BufNewFile" },
    priority = 100,
  })
end

-- Pattern para Git plugins (solo en repos)
function M.git_plugin_spec(plugin)
  return vim.tbl_extend("force", plugin, {
    event = M.is_git_repo() and { "BufReadPre", "BufNewFile" } or nil,
    cond = M.is_git_repo(),
  })
end

-- Pattern para plugins de escritura (Markdown, etc)
function M.writing_plugin_spec(plugin)
  return vim.tbl_extend("force", plugin, {
    ft = { "markdown", "text", "org" },
  })
end

-- ========================================
-- CARGA SECUENCIAL
-- ========================================

-- Cargar plugins en orden de prioridad
function M.sequential_load()
  local loaded = {}

  -- 1. Críticos primero
  for _, plugin in ipairs(M.priorities.critical) do
    if M.should_load_plugin(plugin) then
      pcall(require, plugin)
      table.insert(loaded, plugin)
    end
  end

  -- 2. Alta prioridad después de un delay
  vim.defer_fn(function()
    for _, plugin in ipairs(M.priorities.high) do
      if M.should_load_plugin(plugin) then
        pcall(require, plugin)
        table.insert(loaded, plugin)
      end
    end
  end, 50)

  -- 3. Media prioridad con más delay
  vim.defer_fn(function()
    for _, plugin in ipairs(M.priorities.medium) do
      if M.should_load_plugin(plugin) then
        pcall(require, plugin)
        table.insert(loaded, plugin)
      end
    end
  end, 150)

  return loaded
end

-- ========================================
-- CARGA BASADA EN EVENTOS
-- ========================================

-- Registrar plugins para carga automática
function M.register_autoload()
  -- Git plugins solo en repos
  if M.is_git_repo() then
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      once = true,
      callback = function()
        vim.defer_fn(function()
          pcall(require, "gitsigns")
        end, 100)
      end,
    })
  end

  -- LSP en primer archivo
  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    callback = function()
      -- Cargar LSP después de un pequeño delay
      vim.defer_fn(function()
        pcall(require, "lspconfig")
        pcall(require, "mason")
      end, 10)
    end,
  })

  -- Telescope cuando se busca algo
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    once = true,
    pattern = { "/", "?" },
    callback = function()
      pcall(require, "telescope")
    end,
  })
end

-- ========================================
-- PRE-CARGA DE MÓDULOS FRECUENTES
-- ========================================

function M.preload_common_modules()
  -- Módulos que siempre se usan
  local common = {
    "plenary",
    "nvim-web-devicons",
  }

  for _, module in ipairs(common) do
    vim.defer_fn(function()
      pcall(require, module)
    end, 200)
  end
end

-- ========================================
-- LAZY LOADING DE FUNCIONES
-- ========================================

-- Wrapper para cargar plugins solo cuando se llama una función
function M.lazy_function(plugin_name, func_name)
  return function(...)
    local plugin = require(plugin_name)
    if plugin[func_name] then
      return plugin[func_name](...)
    end
  end
end

-- ========================================
-- OPTIMIZACIÓN DE RUNTIMEPATH
-- ========================================

function M.optimize_rtp()
  -- Remover paths duplicados
  local seen = {}
  local new_rtp = {}

  for _, path in ipairs(vim.opt.rtp:get()) do
    if not seen[path] then
      seen[path] = true
      table.insert(new_rtp, path)
    end
  end

  vim.opt.rtp = new_rtp
end

-- ========================================
-- LIMPIEZA DE MEMORIA AGRESIVA
-- ========================================

function M.aggressive_cleanup()
  -- Limpiar packer_compiled si existe
  local compiled = vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua"
  if vim.fn.filereadable(compiled) == 1 then
    vim.fn.delete(compiled)
  end

  -- Collectgarbage agresivo
  collectgarbage("collect")
  collectgarbage("collect") -- Dos veces para forzar
end

-- ========================================
-- MONITOREO DE CARGA
-- ========================================

M.load_times = {}

function M.track_load_time(plugin_name, start_time)
  local elapsed = vim.loop.hrtime() - start_time
  M.load_times[plugin_name] = elapsed / 1e6 -- Convertir a ms
end

function M.print_load_times()
  local sorted = {}
  for plugin, time in pairs(M.load_times) do
    table.insert(sorted, { plugin = plugin, time = time })
  end

  table.sort(sorted, function(a, b)
    return a.time > b.time
  end)

  print("⏱️  Tiempos de carga (ms):")
  for i, item in ipairs(sorted) do
    if i <= 10 then -- Top 10
      print(string.format("  %d. %s: %.2fms", i, item.plugin, item.time))
    end
  end
end

-- ========================================
-- COMANDOS DE UTILIDAD
-- ========================================

vim.api.nvim_create_user_command("LoaderStats", M.print_load_times, {
  desc = "Mostrar tiempos de carga"
})

vim.api.nvim_create_user_command("LoaderCleanup", M.aggressive_cleanup, {
  desc = "Limpieza agresiva de memoria"
})

vim.api.nvim_create_user_command("LoaderOptimize", function()
  M.optimize_rtp()
  M.aggressive_cleanup()
  vim.notify("✅ Loader optimizado", vim.log.levels.INFO)
end, {
  desc = "Optimizar loader"
})

-- ========================================
-- INICIALIZACIÓN
-- ========================================

-- Auto-registrar carga de plugins
vim.defer_fn(function()
  M.register_autoload()
  M.preload_common_modules()
end, 100)

return M
