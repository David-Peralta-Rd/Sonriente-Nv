-- ╔═══════════════════════════════════════════════════════════╗
-- ║           SONRIENTE NV v4 - ULTRA PERFORMANCE             ║
-- ║     Sistema de Caché Inteligente + Lazy Loading Ninja    ║
-- ╚═══════════════════════════════════════════════════════════╝

-- ========================================
-- FASE 0: PRE-INICIALIZACIÓN CRÍTICA
-- ========================================

-- Deshabilitar providers ANTES de cargar cualquier cosa
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Deshabilitar plugins integrados que NO usamos
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- ========================================
-- FASE 1: VERIFICACIÓN DE ENTORNO
-- ========================================

local function check_neovim_version()
    local required = "0.9.0"
    local current = vim.version()

    if vim.fn.has("nvim-" .. required) == 0 then
        vim.api.nvim_err_writeln(
            string.format(
                "\n" ..
                "╔═══════════════════════════════════════════════╗\n" ..
                "║         ⚠️  VERSIÓN DE NEOVIM OBSOLETA        ║\n" ..
                "╠═══════════════════════════════════════════════╣\n" ..
                "║  Requerida: >= %s                          ║\n" ..
                "║  Actual:    %s.%s.%s                         ║\n" ..
                "║                                               ║\n" ..
                "║  Por favor actualiza Neovim para continuar.  ║\n" ..
                "╚═══════════════════════════════════════════════╝\n",
                required,
                current.major, current.minor, current.patch
            )
        )
        return false
    end
    return true
end

if not check_neovim_version() then
    return
end

-- ========================================
-- FASE 2: INICIALIZACIÓN DE CACHÉ
-- ========================================

local cache_ok, cache = pcall(require, "personal.core.cacheX")
local cache_start = vim.loop.hrtime()

if cache_ok then
    -- Cargar estado previo
    cache.load_state()

    -- Restaurar highlights si existen (ULTRA RÁPIDO)
    local highlights_restored = cache.restore_highlights()

    if highlights_restored then
        vim.schedule(function()
            local elapsed = (vim.loop.hrtime() - cache_start) / 1e6
            -- Solo notificar si tardó más de 5ms (silencioso si es rápido)
            if elapsed > 5 then
                vim.notify(
                    string.format("💾 Highlights desde caché (%.2fms)", elapsed),
                    vim.log.levels.INFO
                )
            end
        end)
    end
else
    vim.schedule(function()
        vim.notify(
            "⚠️  Sistema de caché no disponible\n" ..
            "   Algunas optimizaciones estarán desactivadas",
            vim.log.levels.WARN
        )
    end)
end

-- ========================================
-- FASE 3: SISTEMA DE CARGA CON MÉTRICAS
-- ========================================

local load_times = {}
local total_start = vim.loop.hrtime()

local function safe_require(module_name)
    local start = vim.loop.hrtime()
    local ok, result = pcall(require, module_name)
    local elapsed = (vim.loop.hrtime() - start) / 1e6 -- Convertir a ms

    if ok then
        load_times[module_name] = elapsed

        -- Trackear en caché si está disponible
        if cache_ok then
            cache.track_module(module_name)
        end

        return true, result
    else
        -- Error crítico: mostrar inmediatamente
        vim.schedule(function()
            vim.notify(
                string.format("❌ Error cargando '%s':\n%s", module_name, result),
                vim.log.levels.ERROR
            )
        end)
        return false, nil
    end
end

-- ========================================
-- FASE 4: CARGA SECUENCIAL OPTIMIZADA
-- ========================================

-- Definir fases de carga con prioridades
local load_phases = {
    -- FASE CRÍTICA: 0ms delay (inmediato)
    critical = {
        modules = {
            "personal.core.optiona", -- Opciones base (SIEMPRE PRIMERO)
            "personal.core.utilX",   -- Utilidades globales
        },
        delay = 0,
    },

    -- FASE ALTA: 1ms delay
    high = {
        modules = {
            "personal.core.keymapX",  -- Keymaps globales
            "personal.core.autocmdX", -- Autocomandos
        },
        delay = 1,
    },

    -- FASE NORMAL: 5ms delay
    normal = {
        modules = {
            "personal.core.loaderX", -- Sistema de loader
        },
        delay = 5,
    },
}

-- Función para cargar una fase completa
local function load_phase(phase_name, phase_config)
    local phase_start = vim.loop.hrtime()
    local loaded = {}
    local failed = {}

    for _, module in ipairs(phase_config.modules) do
        local ok, _ = safe_require(module)
        if ok then
            table.insert(loaded, module)
        else
            table.insert(failed, module)
        end
    end

    local phase_elapsed = (vim.loop.hrtime() - phase_start) / 1e6

    -- Retornar estadísticas de la fase
    return {
        name = phase_name,
        loaded = loaded,
        failed = failed,
        elapsed = phase_elapsed,
    }
end

-- Cargar todas las fases secuencialmente
local phase_stats = {}

-- Cargar fase crítica INMEDIATAMENTE
table.insert(phase_stats, load_phase("critical", load_phases.critical))

-- Cargar fase alta con pequeño delay
if #load_phases.high.modules > 0 then
    vim.defer_fn(function()
        table.insert(phase_stats, load_phase("high", load_phases.high))
    end, load_phases.high.delay)
end

-- Cargar fase normal con más delay
if #load_phases.normal.modules > 0 then
    vim.defer_fn(function()
        table.insert(phase_stats, load_phase("normal", load_phases.normal))
    end, load_phases.normal.delay)
end

-- ========================================
-- FASE 5: POST-INICIALIZACIÓN
-- ========================================

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.schedule(function()
            local total_elapsed = (vim.loop.hrtime() - total_start) / 1e6

            -- Obtener estadísticas de Lazy si está disponible
            local lazy_ok, lazy = pcall(require, "lazy")
            local lazy_info = ""

            if lazy_ok then
                local stats = lazy.stats()
                lazy_info = string.format(" | %d plugins", stats.count)
            end

            -- Mensaje de bienvenida con estadísticas
            vim.notify(
                string.format(
                    "😼 Sonriente Nv v4 | %.2fms%s | Caché: %s",
                    total_elapsed,
                    lazy_info,
                    cache_ok and "✅" or "❌"
                ),
                vim.log.levels.INFO
            )

            -- Cachear highlights después de que todo cargó
            if cache_ok then
                vim.defer_fn(function()
                    cache.cache_highlights()
                end, 1000)
            end

            -- Limpieza inicial de memoria
            vim.defer_fn(function()
                collectgarbage("collect")
            end, 2000)
        end)
    end,
})

-- ========================================
-- FASE 6: COMANDOS DE DIAGNÓSTICO
-- ========================================

-- Comando: Recargar configuración completa
vim.api.nvim_create_user_command("ReloadConfig", function()
    -- Limpiar módulos cargados
    for name, _ in pairs(package.loaded) do
        if name:match("^core") or name:match("^plugins") or name:match("^configs") then
            package.loaded[name] = nil
        end
    end

    -- Recargar init.lua
    dofile(vim.env.MYVIMRC)

    -- Guardar estado de caché
    if cache_ok then
        cache.save_state()
    end

    vim.notify("🔄 Configuración recargada", vim.log.levels.INFO)
end, { desc = "Recargar configuración completa" })

-- Comando: Ver tiempos de carga
vim.api.nvim_create_user_command("LoadTimes", function()
    -- Ordenar por tiempo (más lentos primero)
    local sorted = {}
    for module, time in pairs(load_times) do
        table.insert(sorted, { module = module, time = time })
    end

    table.sort(sorted, function(a, b)
        return a.time > b.time
    end)

    -- Imprimir tabla bonita
    print("\n⏱️  Tiempos de Carga de Módulos Core:")
    print(string.rep("─", 60))

    local total = 0
    for i, item in ipairs(sorted) do
        local color = item.time > 10 and "WarningMsg" or (item.time > 5 and "Number" or "Comment")
        vim.api.nvim_echo({
            { string.format("%2d. ", i),            "Number" },
            { string.format("%-35s ", item.module), "String" },
            { string.format("%6.2fms", item.time),  color },
        }, false, {})
        total = total + item.time
    end

    print(string.rep("─", 60))
    print(string.format("Total: %.2fms\n", total))
end, { desc = "Mostrar tiempos de carga de módulos" })

-- Comando: Diagnóstico completo del sistema
vim.api.nvim_create_user_command("DiagnoseNvim", function()
    print("\n╔═══════════════════════════════════════════════════════════╗")
    print("║           DIAGNÓSTICO DEL SISTEMA - SONRIENTE NV         ║")
    print("╚═══════════════════════════════════════════════════════════╝\n")

    -- 1. Versión de Neovim
    local version = vim.version()
    print(string.format("📌 Neovim v%d.%d.%d", version.major, version.minor, version.patch))

    -- 2. Sistema de caché
    if cache_ok then
        local stats = cache.get_stats()
        print("\n💾 Sistema de Caché: ✅ ACTIVO")
        print(string.format("   ├─ Plugins rastreados: %d", stats.plugins_tracked))
        print(string.format("   ├─ Keymaps cacheados: %d", stats.keymaps_cached))
        print(string.format("   ├─ Comandos cacheados: %d", stats.commands_cached))
        print(string.format("   ├─ Highlights: %d", stats.highlights_cached))
        print(string.format("   ├─ Tamaño: %.2f KB", stats.cache_size / 1024))
        print(string.format("   └─ Última actualización: %s", stats.last_updated))
    else
        print("\n💾 Sistema de Caché: ❌ NO DISPONIBLE")
    end

    -- 3. Lazy.nvim
    local lazy_ok, lazy = pcall(require, "lazy")
    if lazy_ok then
        local stats = lazy.stats()
        print("\n🔌 Lazy.nvim: ✅ ACTIVO")
        print(string.format("   ├─ Plugins totales: %d", stats.count))
        print(string.format("   ├─ Cargados: %d", stats.loaded))
        print(string.format("   └─ Tiempo de inicio: %.2fms", stats.startuptime or 0))
    else
        print("\n🔌 Lazy.nvim: ❌ NO CARGADO")
    end

    -- 4. Memoria
    local mem = collectgarbage("count")
    print(string.format("\n🧠 Memoria Lua: %.2f MB", mem / 1024))

    -- 5. Comandos del sistema
    print("\n🔧 Comandos del Sistema:")
    local commands = { "git", "rg", "fd", "make", "node", "python3" }
    for _, cmd in ipairs(commands) do
        local status = vim.fn.executable(cmd) == 1 and "✅" or "❌"
        print(string.format("   %s %s", status, cmd))
    end

    -- 6. Providers
    print("\n🐍 Providers:")
    local providers = {
        { name = "Python3", var = vim.g.loaded_python3_provider },
        { name = "Ruby",    var = vim.g.loaded_ruby_provider },
        { name = "Node",    var = vim.g.loaded_node_provider },
        { name = "Perl",    var = vim.g.loaded_perl_provider },
    }
    for _, prov in ipairs(providers) do
        local status = prov.var == 0 and "🔴 Deshabilitado" or "✅ Activo"
        print(string.format("   %-10s: %s", prov.name, status))
    end

    -- 7. Módulos cargados
    local core_modules = 0
    local plugin_modules = 0
    for name, _ in pairs(package.loaded) do
        if name:match("^core") then
            core_modules = core_modules + 1
        elseif name:match("^plugins") then
            plugin_modules = plugin_modules + 1
        end
    end
    print(string.format("\n📦 Módulos Cargados:"))
    print(string.format("   ├─ Core: %d", core_modules))
    print(string.format("   └─ Plugins: %d", plugin_modules))

    print("\n" .. string.rep("─", 60) .. "\n")
end, { desc = "Diagnóstico completo del sistema" })

-- Comando: Optimizar sistema completo
vim.api.nvim_create_user_command("OptimizeNvim", function()
    print("⚡ Optimizando sistema...\n")

    -- 1. Limpiar caché viejo
    if cache_ok then
        cache.clean_cache()
        print("✓ Caché limpiado")
    end

    -- 2. Optimizar Lazy
    local lazy_ok, lazy = pcall(require, "lazy")
    if lazy_ok then
        vim.cmd("Lazy sync")
        print("✓ Lazy sincronizado")
    end

    -- 3. Limpiar packpath
    vim.opt.packpath = vim.fn.stdpath("data") .. "/site"
    print("✓ Packpath limpiado")

    -- 4. Garbage collection agresivo
    collectgarbage("collect")
    collectgarbage("collect") -- Dos veces para forzar
    print("✓ Memoria liberada")

    -- 5. Optimizar runtimepath
    local loader_ok, loader = pcall(require, "personal.core.loaderX")
    if loader_ok then
        loader.optimize_rtp()
        print("✓ Runtimepath optimizado")
    end

    vim.notify("\n✅ Sistema completamente optimizado", vim.log.levels.INFO)
end, { desc = "Optimizar Neovim completamente" })

-- Comando: Benchmark de inicio
vim.api.nvim_create_user_command("BenchmarkStartup", function()
    vim.cmd("Lazy profile")
end, { desc = "Ver benchmark de tiempo de inicio" })

-- ========================================
-- FASE 7: LIMPIEZA AUTOMÁTICA
-- ========================================

-- Auto-guardar caché al salir
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if cache_ok then
            cache.save_state()
        end
    end,
})

-- Limpieza periódica de memoria (cada 5 minutos)
local cleanup_timer = vim.loop.new_timer()
cleanup_timer:start(300000, 300000, vim.schedule_wrap(function()
    collectgarbage("collect")
end))

-- ========================================
-- MODO DEBUG (opcional, descomenta para activar)
-- ========================================

-- vim.defer_fn(function()
--   vim.cmd("LoadTimes")
-- end, 100)
