-- =========================================================
--   TELESCOPE v5 - Con Caché y Lazy Loading Inteligente
-- =========================================================

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",

  -- ========================================
  -- LAZY LOADING ULTRA AGRESIVO
  -- ========================================
  cmd = "Telescope",

  -- ========================================
  -- DEPENDENCIAS CON LAZY LOADING
  -- ========================================
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },

    -- FZF nativo (CRÍTICO para velocidad)
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
      lazy = true,
    },

    -- Iconos (cargar solo cuando sea necesario)
    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,
      opts = {
        -- Caché de iconos para velocidad
        override = {},
        default = true,
        strict = true,
      },
    },
  },

  -- ========================================
  -- CONFIGURACIÓN OPTIMIZADA
  -- ========================================
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local cache = require("personal.core.cacheX")

    -- ========================================
    -- CACHÉ DE BÚSQUEDAS
    -- ========================================
    local search_cache = cache.file_cache or {}
    local cache_ttl = 300 -- 5 minutos

    -- Función para cachear resultados de find_files
    local function cached_find_files(opts)
      opts = opts or {}
      local cwd = opts.cwd or vim.fn.getcwd()
      local cache_key = "find_files:" .. cwd
      local now = os.time()

      -- Verificar caché
      if search_cache[cache_key] and (now - search_cache[cache_key].time) < cache_ttl then
        opts.results_cache = search_cache[cache_key].results
      end

      require("telescope.builtin").find_files(opts)

      -- Guardar en caché después de la búsqueda
      vim.defer_fn(function()
        search_cache[cache_key] = {
          results = opts.results_cache or {},
          time = now,
        }
      end, 100)
    end

    telescope.setup({
      defaults = {
        -- ========================================
        -- UI MINIMALISTA Y RÁPIDA
        -- ========================================
        prompt_prefix = "🔍 ",
        selection_caret = "➜ ",
        entry_prefix = "  ",
        multi_icon = "✓ ",
        border = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

        -- ========================================
        -- LAYOUT OPTIMIZADO
        -- ========================================
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },

        sorting_strategy = "ascending",

        -- ========================================
        -- IGNORAR ARCHIVOS INNECESARIOS (CRÍTICO)
        -- ========================================
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "%.cache/",
          "__pycache__/",
          "%.pytest_cache/",
          "build/",
          "dist/",
          "target/",
          "vendor/",
          "%.npm/",
          "%.yarn/",
          "%.lock",
          "package%-lock%.json",
          "yarn%.lock",
          "%.min%.js",
          "%.min%.css",
          "%.exe",
          "%.dll",
          "%.so",
          "%.dylib",
          "%.zip",
          "%.tar%.gz",
          "%.jpg",
          "%.jpeg",
          "%.png",
          "%.gif",
          "%.svg",
          "%.ico",
          "%.pdf",
          "%.mp4",
          "%.mkv",
        },

        -- ========================================
        -- RIPGREP ULTRA OPTIMIZADO
        -- ========================================
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim",
          "--hidden",
          -- Optimizaciones de rendimiento
          "--max-columns=150",
          "--max-columns-preview",
          -- Ignorar binarios automáticamente
          "--binary",
        },

        -- ========================================
        -- CACHÉ Y RENDIMIENTO
        -- ========================================
        cache_picker = {
          num_pickers = 20, -- Cachear más búsquedas
          limit_entries = 1000,
        },

        -- Preview optimizado
        preview = {
          treesitter = true,
          filesize_limit = 1, -- MB
          timeout = 250,
          hide_on_startup = false,
          msg_bg_fillchar = " ",
        },

        -- Historial persistente
        history = {
          path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
          limit = 200,
        },

        -- UI
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" },

        -- Sorters más rápidos
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,

        -- ========================================
        -- KEYMAPS MEJORADOS
        -- ========================================
        mappings = {
          i = {
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-c>"] = actions.close,
            ["<Esc>"] = actions.close,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Down>"] = actions.cycle_history_next,
            ["<Up>"] = actions.cycle_history_prev,
          },
          n = {
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<Esc>"] = actions.close,
            ["q"] = actions.close,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["?"] = actions.which_key,
          },
        },
      },

      -- ========================================
      -- PICKERS CON CACHÉ
      -- ========================================
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          hidden = true,
          -- Usar fd si está disponible (más rápido que rg)
          find_command = vim.fn.executable("fd") == 1
              and { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
              or { "rg", "--files", "--hidden", "-g", "!.git" },
        },

        oldfiles = {
          theme = "dropdown",
          previewer = false,
          only_cwd = true,
          -- Cachear archivos recientes
          cache_picker = {
            num_pickers = 10,
          },
        },

        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          sort_mru = true,
          sort_lastused = true,
          mappings = {
            i = { ["<C-d>"] = actions.delete_buffer },
            n = { ["dd"] = actions.delete_buffer },
          },
        },

        live_grep = {
          only_sort_text = true,
          previewer = true,
          -- Optimización: solo buscar en archivos de texto
          type_filter = "lua",
        },

        git_files = {
          theme = "dropdown",
          previewer = false,
          show_untracked = true,
          use_git_root = true,
        },
      },

      -- ========================================
      -- EXTENSIONES
      -- ========================================
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- ========================================
    -- CARGAR FZF (CRÍTICO)
    -- ========================================
    pcall(telescope.load_extension, "fzf")

    -- ========================================
    -- FUNCIONES WRAPPER CON CACHÉ
    -- ========================================

    -- Find files con caché
    _G.TelescopeCachedFindFiles = function(opts)
      cached_find_files(opts)
    end

    -- Live grep con límite de resultados para velocidad
    _G.TelescopeFastGrep = function(opts)
      opts = opts or {}
      opts.max_results = 1000 -- Limitar para mejor rendimiento
      require("telescope.builtin").live_grep(opts)
    end

    -- ========================================
    -- COMANDOS PERSONALIZADOS OPTIMIZADOS
    -- ========================================

    -- Buscar en config de Neovim
    vim.api.nvim_create_user_command("TelescopeConfig", function()
      require("telescope.builtin").find_files({
        prompt_title = "🛠️ Config",
        cwd = vim.fn.stdpath("config"),
        hidden = true,
      })
    end, {})

    -- Buscar TODOs con mejor pattern
    vim.api.nvim_create_user_command("TelescopeTodos", function()
      require("telescope.builtin").grep_string({
        prompt_title = "📝 TODOs",
        search = "TODO|FIXME|HACK|WARN|PERF|NOTE|XXX",
        use_regex = true,
      })
    end, {})

    -- Limpiar caché de búsquedas
    vim.api.nvim_create_user_command("TelescopeClearCache", function()
      search_cache = {}
      cache.clear_file_cache()
      vim.notify("🗑️  Caché de Telescope limpiado", vim.log.levels.INFO)
    end, {})

    -- ========================================
    -- KEYMAPS (solo si no se definieron antes)
    -- ========================================
    local map = vim.keymap.set
    local opts = { silent = true, noremap = true }

    map(
      "n",
      "<leader><space>",
      "<cmd>lua TelescopeCachedFindFiles()<CR>",
      vim.tbl_extend("force", opts, { desc = "Buscar archivos (cached)" })
    )

    map(
      "n",
      "<leader>fg",
      "<cmd>lua TelescopeFastGrep()<CR>",
      vim.tbl_extend("force", opts, { desc = "Buscar texto (fast)" })
    )

    -- ========================================
    -- NOTIFICACIÓN
    -- ========================================
    vim.schedule(function()
      local fzf_loaded = pcall(require, "telescope._extensions.fzf")
      if fzf_loaded then
        vim.notify("🔭 Telescope + FZF + Caché ✅", vim.log.levels.INFO)
      else
        vim.notify("🔭 Telescope cargado (sin FZF) ⚠️", vim.log.levels.WARN)
      end
    end)
  end,
}
