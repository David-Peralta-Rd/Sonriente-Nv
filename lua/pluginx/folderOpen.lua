-- Aca agregamos el plugins para gestionar carpetas, tambien podras crear archivos y carpetas con esto.
-- Para ver los comandos primero abre con "ctrl + e" y presiona "g"

-- plugins/filetree.lua

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Desactivar netrw predefinido, para evitar conflictos
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      -- Vista
      view = {
        width = 17, -- Configura el tamaño que gustes, ami me gusta pequeño asi que lo dejare bastante bajo.
        side = "left",
        number = false,
        relativenumber = false,
        signcolumn = "no",   -- opcional, para no mostrar columna de signos
      },

      -- Renderizado y estética
      renderer = {
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,  -- desactivo íconos de git para simplificar
          },
        },
        indent_markers = {
          enable = false,  -- sin líneas de indentación extra
        },
        highlight_opened_files = "name",  -- resaltar nombre del archivo abierto
      },

      -- Comportamientos básicos
      filters = {
        dotfiles = false,     -- puedes cambiar a true si no quieres ver archivos ocultos
        git_ignored = true,    -- ocultar archivos ignorados por git
      },
      update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
      },

      -- Git
      git = {
        enable = true,
        ignore = true,
      },

      -- Otras pequeñas opciones
      actions = {
        open_file = {
          quit_on_open = true,  -- Si quieres que no se cierre al abrir el archivo ponlo en "false".
        },
      },

      -- Mapeo de teclas para abrir / cerrar
      -- Esto lo puedes poner en tu configuración general de keymaps
    })

    -- Keymap para abrir/cerrar con Ctrl+e
  end,
}

