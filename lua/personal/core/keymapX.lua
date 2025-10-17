-- ===========================
--   Keymaps Globales v4
-- ===========================

local map = vim.keymap.set

-- ========================================
-- NOTA: Leader keys definidos en optionX.lua
-- <leader> = Space
-- <localleader> = _
-- ========================================

-- ========================================
-- GUARDADO Y SALIDA
-- ========================================
map("n", "<C-s>", "<cmd>w!<CR>", { desc = "Guardar archivo" })
map("i", "<C-s>", "<Esc><cmd>w!<CR>", { desc = "Guardar archivo (insert)" })
map("n", "<C-q>", "<cmd>q!<CR>", { desc = "Salir sin guardar" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Salir todo sin guardar" })
map("n", "<leader>x", "<cmd>x<CR>", { desc = "Guardar y salir" })

-- ========================================
-- GESTIÓN DE PLUGINS
-- ========================================
map("n", "<F2>", "<cmd>Lazy<CR>", { desc = "Abrir Lazy" })
map("n", "<F3>", "<cmd>Mason<CR>", { desc = "Abrir Mason" })
map("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Lazy" })
map("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Mason" })

-- ========================================
-- NAVEGACIÓN ENTRE BUFFERS/PESTAÑAS
-- ========================================
map("n", "<leader>1", "1gt", { desc = "Ir a pestaña 1" })
map("n", "<leader>2", "2gt", { desc = "Ir a pestaña 2" })
map("n", "<leader>3", "3gt", { desc = "Ir a pestaña 3" })
map("n", "<leader>4", "4gt", { desc = "Ir a pestaña 4" })
map("n", "<leader>5", "5gt", { desc = "Ir a pestaña 5" })

-- Navegación de buffers
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Buffer siguiente" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Cerrar buffer" })
map("n", "<leader>bD", "<cmd>%bd|e#<CR>", { desc = "Cerrar todos menos actual" })

-- ========================================
-- NAVEGACIÓN ENTRE VENTANAS (SPLITS)
-- ========================================
map("n", "<C-h>", "<C-w>h", { desc = "Ventana izquierda" })
map("n", "<C-l>", "<C-w>l", { desc = "Ventana derecha" })
map("n", "<C-j>", "<C-w>j", { desc = "Ventana inferior" })
map("n", "<C-k>", "<C-w>k", { desc = "Ventana superior" })

-- Redimensionar ventanas
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Aumentar altura" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Reducir altura" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Reducir ancho" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Aumentar ancho" })

-- Crear splits
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Igualar splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Cerrar split actual" })

-- ========================================
-- MOVIMIENTO MEJORADO
-- ========================================
map("n", "<leader>j", "<C-d>zz", { desc = "Bajar media pantalla" })
map("n", "<leader>k", "<C-u>zz", { desc = "Subir media pantalla" })
map("n", "n", "nzzzv", { desc = "Siguiente búsqueda (centrado)" })
map("n", "N", "Nzzzv", { desc = "Búsqueda anterior (centrado)" })
map("n", "*", "*zzzv", { desc = "Buscar palabra bajo cursor" })
map("n", "#", "#zzzv", { desc = "Buscar palabra bajo cursor (reversa)" })

-- Mover líneas arriba/abajo
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Mover línea abajo" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Mover línea arriba" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Mover selección abajo" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Mover selección arriba" })

-- Mantener selección al indentar
map("v", "<", "<gv", { desc = "Indentar izquierda" })
map("v", ">", ">gv", { desc = "Indentar derecha" })

-- ========================================
-- COPIAR/PEGAR MEJORADO
-- ========================================
-- Borrar sin copiar al registro
map("n", "<leader>d", '"_d', { desc = "Borrar sin copiar" })
map("v", "<leader>d", '"_d', { desc = "Borrar sin copiar" })
map("n", "x", '"_x', { desc = "Borrar char sin copiar" })

-- Pegar sin perder el registro
map("v", "p", '"_dP', { desc = "Pegar sin perder registro" })

-- Copiar al clipboard del sistema
map("n", "<leader>y", '"+y', { desc = "Copiar al clipboard" })
map("v", "<leader>y", '"+y', { desc = "Copiar al clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Copiar línea al clipboard" })

-- ========================================
-- TELESCOPE (si está instalado)
-- ========================================
map("n", "<leader><space>", "<cmd>Telescope find_files<CR>", { desc = "Buscar archivos" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Buscar archivos" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Buscar texto" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buscar buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Ayuda" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Archivos recientes" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Comandos" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })

-- Git con Telescope
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
map("n", "<leader>gf", "<cmd>Telescope git_files<CR>", { desc = "Git files" })
map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })

-- ========================================
-- LSP (se activarán cuando LSP esté adjunto)
-- ========================================
-- Estos se definen en lspX/handlers.lua cuando LSP se adjunta
-- Aquí solo documentamos:
-- gd = Ir a definición
-- gD = Ir a declaración
-- gi = Ir a implementación
-- gr = Ver referencias
-- K = Hover documentation
-- <leader>ca = Code actions
-- <leader>rn = Renombrar
-- <leader>f = Formatear

-- ========================================
-- UTILIDADES RÁPIDAS
-- ========================================
-- Toggle options
map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })
map("n", "<leader>us", "<cmd>set spell!<CR>", { desc = "Toggle spell" })
map("n", "<leader>un", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative number" })
map("n", "<leader>ul", "<cmd>set list!<CR>", { desc = "Toggle list chars" })

-- Limpiar highlights de búsqueda
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Limpiar highlights" })

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Salir modo terminal" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: ventana izq" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: ventana abajo" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: ventana arriba" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: ventana der" })

-- Abrir terminal
map("n", "<leader>th", "<cmd>split | terminal<CR>", { desc = "Terminal horizontal" })
map("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Terminal vertical" })
map("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Terminal" })

-- ========================================
-- QUICKFIX Y LOCATION LIST
-- ========================================
map("n", "<leader>co", "<cmd>copen<CR>", { desc = "Abrir quickfix" })
map("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Cerrar quickfix" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Quickfix anterior" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Quickfix siguiente" })
map("n", "[l", "<cmd>lprev<CR>", { desc = "Location anterior" })
map("n", "]l", "<cmd>lnext<CR>", { desc = "Location siguiente" })

-- ========================================
-- COMANDOS PERSONALIZADOS
-- ========================================
-- Recargar configuración
map("n", "<leader>R", "<cmd>ReloadConfig<CR>", { desc = "Recargar config" })

-- ========================================
-- FUNCIÓN: RENOMBRAR PALABRA (tu función original mejorada)
-- ========================================
map("n", "<localleader>r", function()
  local word = vim.fn.expand("<cword>")

  -- Verificar que hay una palabra bajo el cursor
  if word == "" then
    vim.notify("⚠️  No hay palabra bajo el cursor", vim.log.levels.WARN)
    return
  end

  -- Pedir nueva palabra
  local new = vim.fn.input({
    prompt = "Reemplazar '" .. word .. "' por: ",
    default = word,
  })

  -- Cancelar si no se ingresó nada o es igual
  if new == "" or new == word then
    vim.notify("ℹ️  Operación cancelada", vim.log.levels.INFO)
    return
  end

  -- Ejecutar reemplazo global respetando palabras completas
  local cmd = string.format("%%s/\\<%s\\>/%s/g", word, new)
  local ok, err = pcall(vim.cmd, cmd)

  if ok then
    vim.notify(
      string.format("✅ '%s' → '%s'", word, new),
      vim.log.levels.INFO
    )
  else
    vim.notify(
      string.format("❌ Error: %s", err),
      vim.log.levels.ERROR
    )
  end
end, { desc = "Renombrar palabra en todo el archivo" })

-- ========================================
-- FUNCIÓN: TOGGLE TRANSPARENCIA
-- ========================================
map("n", "<leader>ut", function()
  local colors = vim.api.nvim_get_hl(0, { name = "Normal" })
  if colors.bg then
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.notify("🪟 Transparencia activada", vim.log.levels.INFO)
  else
    vim.cmd("colorscheme " .. vim.g.colors_name)
    vim.notify("🎨 Transparencia desactivada", vim.log.levels.INFO)
  end
end, { desc = "Toggle transparencia" })

-- ========================================
-- FUNCIÓN: COPIAR RUTA DEL ARCHIVO
-- ========================================
map("n", "<leader>fp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("📋 Ruta copiada: " .. path, vim.log.levels.INFO)
end, { desc = "Copiar ruta completa" })

map("n", "<leader>fn", function()
  local path = vim.fn.expand("%:t")
  vim.fn.setreg("+", path)
  vim.notify("📋 Nombre copiado: " .. path, vim.log.levels.INFO)
end, { desc = "Copiar nombre de archivo" })

-- ========================================
-- FUNCIÓN: CENTRAR BUFFER VERTICALMENTE
-- ========================================
map("n", "<leader>zz", function()
  local line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local win_height = vim.fn.winheight(0)
  local offset = math.floor((win_height - 1) / 2)

  vim.cmd("normal! zt")
  if line > offset then
    vim.cmd("normal! " .. offset .. "j")
  end
end, { desc = "Centrar buffer verticalmente" })

-- ========================================
-- DESHABILITAR TECLAS MOLESTAS
-- ========================================
-- Deshabilitar Q (modo Ex)
map("n", "Q", "<nop>", { desc = "Deshabilitado" })

-- Deshabilitar flechas en modo normal (opcional, descomenta si quieres)
map("n", "<Up>", "<nop>", { desc = "Usa k" })
map("n", "<Down>", "<nop>", { desc = "Usa j" })
map("n", "<Left>", "<nop>", { desc = "Usa h" })
map("n", "<Right>", "<nop>", { desc = "Usa l" })
