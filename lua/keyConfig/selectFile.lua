local map = vim.keymap.set -- Cada vez que hagas un archivo de comandos atajo importa esto.

-- Ventanas (splits)
map("n", "<C-h>", "<C-w>h", { desc = "Mover a la ventana izquierda" }) -- "ctrl + h" Nos movemos a la ventana izquierda
map("n", "<C-l>", "<C-w>l", { desc = "Mover a la ventana derecha" }) -- "ctrl + l" Nos movemos a la ventana derecha
map("n", "<C-j>", "<C-w>j", { desc = "Mover a la ventana inferior" }) -- "ctrl + j" Nos movemos a la ventana inferior
map("n", "<C-k>", "<C-w>k", { desc = "Mover a la ventana superior" }) -- "ctrl + k" Nos movemos a la ventana superior

-- Cambiar entre buffers abiertos.
-- Los buffer son espacios de memoria en donde se guarda un archivo para indicar que esta abierto o se esta modificando.
-- Cuando decimos movernos entre buffers es basicamente movernos entre los archivos que abrimos anteriormente.

map("n", "<leader>1", "1gt", { desc = "Ir a pestaña 1" }) -- Viajar a buffer 1
map("n", "<leader>2", "2gt", { desc = "Ir a pestaña 2" }) -- Viajar a buffer 2
map("n", "<leader>3", "3gt", { desc = "Ir a pestaña 3" }) -- Viajar a buffer 3
map("n", "<leader>4", "4gt", { desc = "Ir a pestaña 4" }) -- Viajar a buffer 4
map("n", "<leader>5", "5gt", { desc = "Ir a pestaña 5" }) -- Viajar a buffer 5
map("n", "<leader>6", "6gt", { desc = "Ir a pestaña 6" }) -- Viajar a buffer 6
map("n", "<leader>7", "7gt", { desc = "Ir a pestaña 7" }) -- Viajar a buffer 7
map("n", "<leader>8", "8gt", { desc = "Ir a pestaña 8" }) -- Viajar a buffer 8
map("n", "<leader>9", "9gt", { desc = "Ir a pestaña 9" }) -- Viajar a buffer 9
map("n", "<leader>0", "10gt", { desc = "Ir a pestaña 10" }) -- Viajar a buffer 10

-- Explorador de archivos:
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Explorador de archivos"} ,{ noremap = true, silent = true}) -- Abre el explorador de archivos
