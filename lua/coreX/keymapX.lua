-- Configuración que define comportamiento de atajos.
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end


-- Tecla lider, elige la que quieras dentro de las comillas.
vim.g.mapleader = " "       -- Por defecto(Espacio)
vim.g.maplocalleader = "°"  -- Segunda tecla lider, sirve para ejecutar comandos dependiendo el archivo.

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
map("n", "<C-s>", ":w!<CR>", "Guardar Cambios") -- Guarda cambios ignorando proteccion del archivo, si quieres un guardado normal configuralo asi ":w<CR>" sin el "!"
map("n", "q", ":q!<CR>", "Cerrar archivo - ¡CUIDADO DE SALIR SIN GUARDAR!") -- Cierra el archivo ignorando cambios que no guardaste, quita el "!" que esta en "q!" si no te gusta.





