-- Nuestras opciones por defecto.

local opt = vim.opt

opt.number = true			-- Esto nos muestra los numeros de linea.
opt.relativenumber = true		-- Esto nos da numeros relativos, con esto nos podemos mover como ninjas.
opt.tabstop = 4				-- Configuramos los tabs a "4" para un correcto funcionamiento.			
opt.shiftwidth = 4			-- Definimos la sangria que se dejara al escribir codigo, igual "4".
opt.expandtab = true			-- Esto hace que los espacios de la tabulacion sean igual a los normales.
opt.smartindent = true			-- Agrega una sangria especial a las "{}" en caso de necesitarlo.
opt.termguicolors = true		-- Habilita soporte de colores a la terminal, para tus temas.
opt.wrap = false			-- Ajusta texto demaciado largo sin hacer saltos de linea, mejor visualización.
opt.ignorecase = true			-- Ayuda con la busqueda de texto, trata las minisculas y mayusculas por igual.
opt.smartcase = true			-- Ayuda con una busqueda mas general o muy directa, super util.
opt.splitbelow = true			-- Cuando se divide la pantalla horizontal abre la nueva ventana abajo.
opt.splitright = true			-- Cuando se divide la pantalla vertical abre la nueva ventana a la derecha.
opt.cursorline = true			-- Resalta la linea en la que nos encontramos.
opt.signcolumn = "yes"			-- Activa que salgan alertas de errores en la parte izquierda de la linea.
opt.clipboard = "unnamedplus"		-- Permite que el texto copiado se pueda pegar facilmente en cualquier lado.

