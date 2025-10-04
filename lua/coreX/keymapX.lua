-- Configuración que define comportamiento de atajos.
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end


-- Tecla lider, elige la que quieras dentro de las comillas.
vim.g.mapleader = " "       -- Por defecto(Espacio)
vim.g.maplocalleader = "<F1>"  -- Segunda tecla lider, sirve para ejecutar comandos dependiendo el archivo.

-- Aqui estamos en el apartado donde haremos nuestros atajos con comandos.
-- Plantilla para hacer comandos: map("modo", "teclas", "comando", "descripcion")

            -- Modos de Nvim: --
-- "n" → Modo normal (navegación, comandos)
-- "i" → Modo insertar (escritura de texto)
-- "v" → Modo visual (selección de texto)
-- "x" → Modo visual por bloques
-- "c" → Modo comando (cuando se presiona ":")

    -- Teclas especiales que puedes usar en tus atajos: --
-- <C-*>   → Ctrl + tecla (por ejemplo <C-s> para guardar)
-- <S-*>   → Shift + tecla (por ejemplo <S-q> para cerrar forzado)
-- <A-*>   → Alt + tecla (puede variar según el sistema/terminal)
-- <CR>    → Enter
-- <Tab>   → Tabulador
-- <Esc>   → Escape
-- <leader> → Tecla líder, configurada como barra espaciadora (Configurala a tu manera.)


    -- BASICOS --
map("n", "<C-s>", ":w!<CR>", "Guardar Cambios")                             -- Guarda cambios ignorando proteccion del archivo, si quieres un guardado normal configuralo asi ":w<CR>" sin el "!" (ctrl + s)
map("n", "q", ":q!<CR>", "Cerrar archivo - ¡CUIDADO DE SALIR SIN GUARDAR!") -- Cierra el archivo ignorando cambios que no guardaste, quita el "!" que esta en "q!" si no te gusta. (q)
map("n", "<leader>n", ":nohlsearch<CR>", "Limpiar busqueda")                -- Limpia las busquedas que se hacen con "/" (Espacio + n)
map("n", "<F2>", ":Mason<CR>", "Abrir Mason")                               -- Abrir Mason XD (F2)

    -- TELESCOPE --
map("n", "<leader> ", ":Telescope find_files<CR>", "Buscar archivos")       -- Esto busca archivos en la carpeta actual (Espacio + Espacio)
map("n", "<leader>º", ":Telescope buffers<CR>", "Ventanas abiertas")        -- Abrir archivos que estan abiertos y guardados en un espacio de memoria (º)
map("n", "<leader>gs", ":Telescope git_status<CR>", "Git Status")           -- Git status (Espacio + gs)
map("n", "<leader>gf", ":Telescope git_files<CR>", "Git Files")             -- Git Files (Espacio + gf)
map("n", "<leader>gb", ":Telescope git_branches<CR>", "Git Branch")         -- Git Branches nos rive para ver las ramas (Espacio + gb)
map("n", "<leader>gtt", ":Telescope git_stash<CR>", "Git stash")             -- Git Stash esto nos devuelve a nuestro ultimo commit, muy util por si queremos devolver a como estaba el codigo(Espacio + gth)





