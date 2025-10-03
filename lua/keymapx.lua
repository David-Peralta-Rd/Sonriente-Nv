-- Cargamos en una variable el apartado de atajos para poder crear nuestros atajos.
-- Podemos ponerle el nombre que quieran, yo lo llamare "map"
-- Usare la tecla <leader> que se define en el archivo "~/.config/nvim/init.lua"
-- Se llama "<leader>" porque esta es la tecla LIDER, basicamente undiendo esta tecla se pueden iniciar muchas
-- Acciones ya configuradas.

local map = vim.keymap.set

-- Atajo para guardar archivo actual undiendo el tipico "ctrl + s"
map("n", "<C-s>", ":w!<CR>", { desc = 'Guardar cambios actuales' }) -- Yo forzare siempre el guardado, puedes desactivarlo quitanto el "!" que aparece en ":w!<CR>"

-- Atajos de movimiento y comportamiento de nvim --
-- En nvim existen varios modos, estos nos servira para decidir en que modo el atajo se debe ejecutar.
-- La mayoria de modos que se usan son "n(normal)" en este modo nosotros navegamos sin escribir en el codigo.
-- Esto es comodo para crear nuestros comandos.
-- Modos de Neovim:
-- "n" → Modo normal (navegación, comandos)
-- "i" → Modo insertar (escritura de texto)
-- "v" → Modo visual (selección de texto)
-- "x" → Modo visual por bloques
-- "c" → Modo comando (cuando se presiona ":")

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

-- Crea tu propio atajo usando esta plantilla:
-- map("modo", "teclas", "comando", { desc = 'Tu descripción aquí' })

-- Ejemplo:
-- map("n", "<leader>h", ":nohlsearch<CR>", { desc = 'Quitar el resaltado de búsqueda' })

-- Bien arriba en el archivo te deje 2 comandos que sirven para guardar, puedes tomarlos de ejemplo.
-- Si no sabes porque puse "<C-s>", te lo explico rapidamente, La primer letra que es la "C" que esta en mayuscula.
-- Hago referencia a la tecla ctrl de nuestro teclado, la letra que va despues del "-" que es "s" indica la tecla que se presiona despues.
-- Entonces seria algo como esto "<C-Tecla>" con esto le indica a neovim que cuando presione la tecla ctrl y la fusione.
-- Con la tecla "s" hace que se ejecute el comando ":w" que sirve para guardar los cambios en un archivo.

-- Te dejo una lista de teclas que puedes usar :D

-- Teclas especiales que puedes usar en tus atajos: --
-- <C-*>   → Ctrl + tecla (por ejemplo <C-s> para guardar)
-- <S-*>   → Shift + tecla (por ejemplo <S-q> para cerrar forzado)
-- <A-*>   → Alt + tecla (puede variar según el sistema/terminal)
-- <CR>    → Enter
-- <Tab>   → Tabulador
-- <Esc>   → Escape
-- <leader> → Tecla líder, configurada como barra espaciadora (ver init.lua)
-- Usa estas combinaciones para crear tus propios atajos personalizados!

-- Diviertete configurando tus atajos, investiga mucho y explora, rompe y modifica todo a tu gusto <3 :D.


-- Exploracion de archivos: 

map("n", "<leader><leader>", ":Telescope find_files<CR>", { desc = 'Buscar archivos' }) -- "Espacio + Espacio" -- Mostrara los archivos de la carpeta actual.
map("n", "<leader>gs", ":Telescope git_status<CR>", { desc = 'Git status' }) -- "Espacio + gs" -- Esto nos enseñara el estatus de nuestros archivos versionados con "git"
map("n", "º", ":Telescope buffers<CR>", { desc = 'Ver buffers abiertos' }) -- "Tecla º" -- Esto nos muestra los archivos en memoria que tenemos abiertos(Si te molesta la tecla cambiala)
-- map("n", "q", ":q<CR>", { desc = 'Cerrar archivos de manera normal.' }) -- "Tecla q" -- Presionando la letra "q" vamos a cerrar archivos y ventanas que esten abiertos y guardados. (Estara por defecto serar forzadamente, pero si te gusta tenes mas seguridad descomenta esta linea y comenta la forzada)
map("n", "q", ":q!<CR>", { desc = 'Cerrar archivos de manera forzada - ¡CUIDADO!' }) -- "Tecla q" -- Esto hara que se cierre todo de manera forzada, ¡OJO SI NO GUARDASTE TUS ARCHIVOS, ESTA COMBINACION LOS CIERRA SIN GUARDAR, TEN CUIDADO!


-- Para ser organizados dividi los atajos de teclado por categorias en la carpeta "keyConfig", asi lo unico que hago es cargar los atajos que voy a crear.
-- Y asi somos mas organizados y evitamos tener tantos atajos en un mismo lugar, te recomiendo ir y mirar los otros atajos disponibles y configurar los tuyos <3.

-- Usare el comando "require", este comando funciona para cargar archivos ".lua", lo usaremos de la siguiente manera:
-- require("Aqui debes poner la dirrecion del archivo que quires")
-- En la carpeta "keyConfig" estara un archivo llamado "init.lua", abreelo hay te enseño como crear tus atajos en diferentes archivos de manera organizada.

require("keyConfig")


