-- Cargamos en una variable el apartado de atajos para poder crear nuestros atajos.
-- Podemos ponerle el nombre que quieran, yo lo llamare "map"
-- Usare la tecla <leader> que se define en el archivo "~/.config/nvim/init.lua"

local map = vim.keymap.set

map("n", "<C-s>", ":w<CR>", { desc = 'Guardar cambios actuales' }) -- Atajo para guardar archivo actual undiendo el tipico "ctrl + s"
map("n", "<C-S>", ":w!<CR>", { desc = 'Guardar todo de manera forzada' }) -- Atajo para guardar TODO sin importar si es un archivo protegido o elevado en permisos, usarlos en casos extremos "ctrl + S"

-- Atajos de movimiento y comportamiento de nvim --
-- Existen 4 modos en nvim: "normal(n)", "insertar(i)", "vision(v)", "comandos(":") --

-- Entonces los atajos se manejan de la siguiente manera:  
-- map("Modo", "Teclas o Combinacion de teclas", "Comando o Accion a ejecutar", { desc = 'Descripcion que aparecera de guia' })
-- La combinacion de teclas se pone dentro de las mismas comillas.

-- Ejemplo: "<leader>F" esta combinacion seria "Espacio + F"
-- Cuando usamos "<Tecla>" el menor que y mayor que encerrando una tecla, eso quiere indicar que estamos presionando esa tecla.

-- Ejemplo: "<leader>Q" esto quiere indicar que cuando presionemos una vez "Espacio" los atajos se quedaran esperando que undamos la siguiente tecla puede ser la "q".
-- Esto ejecutara el comando que tengamos definido, lo interesante es que podemos usar la misma tecla encerrada en "<" - ">" para muchos comandos mas.
-- Yo horita mismo puedo elegir despues de undir "Espacio" usar la letra "Q" o "F" para ejecutar el comando que tenga configurado, esto lo veran a continuación.

-- Nota: Cuando hagan una combinacion de teclas, tengan encuenta que la minuscula o mayuscula afectan, ejemplo si usas "<leader>Q", no sera lo mismo que "<leader>q".
-- Esto nos permite hacer muchas combinaciones con las mismas teclas, pero en minuscula y mayuscula, ejecutando diferentes comandos.

-- Este comando "<CR>" indica que se presiono la tecla "Enter", en los siguientes atajos lo veran bastante, esto sirve para ejecutar comandos en el modo cmd.
-- Cuando undimos ":" nos metemos al modo comandos y se ejecuta el comando que le pongamos, en el primer atajo usare el modo comando y le dire que use un plugin que sirve.
-- Para buscar archivos y que se presione "Enter" usando "<CR>", si no usamos el comando de "<CR>" al final nos metera a la linea de comandos y nosotros tendremos que undir el "Enter" nosotros mismos.
-- Por eso es molesto, es preferible usar "<CR>" para que se ejecute al hacer la combinacion de teclas. - Igualmente te invito a que quites el "<CR>" y experimentes que pasa.

-- Diviertete configurando tus atajos, investiga mucho y explora, rompe y modifica todo a tu gusto <3 :D.


-- Exploracion de archivos: 

map("n", "<leader><leader>", ":Telescope find_files<CR>", { desc = 'Buscar archivos' }) -- "Espacio + Espacio" -- Mostrara los archivos de la carpeta actual.
map("n", "<leader>gs", ":Telescope git_status<CR>", { desc = 'Git status' }) -- "Espacio + gs" -- Esto nos enseñara el estatus de nuestros archivos versionados con "git"
map("n", "º", ":Telescope buffers<CR>", { desc = 'Ver buffers abiertos' }) -- "Tecla º" -- Esto nos muestra los archivos en memoria que tenemos abiertos(Si te molesta la tecla cambiala)
map("n", "q", ":q<CR>", { desc = 'Cerrar archivos de manera normal.' }) -- "Tecla q" -- Presionando la letra "q" vamos a cerrar archivos y ventanas que esten abiertos y guardados.
map("n", "<S-q>", ":q!<CR>", { desc = 'Cerrar archivos de manera forzada - ¡CUIDADO!' }) -- "Shift + q" -- Esto hara que se cierre todo de manera forzada, ¡OJO SI NO GUARDASTE TUS ARCHIVOS, ESTA COMBINACION LOS CIERRA SIN GUARDAR, TEN CUIDADO!
-- map("n", "


