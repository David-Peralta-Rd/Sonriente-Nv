-- Bienvenidos, aqui cargaremos los archivos que tengan nuestros atajos bien organizados.
-- Entonces te explico rapidamente que esta pasando, aqui usamos el comando "return", este comando.

-- Sirve principalmente para que un archivo ejecute una orden, en este caso ejecutara la orden de cargar los archivos.
-- Los archivos que cargamos son los de nuestros atajos, la razon por la que usamos "return" es para cuando cargemos
-- Este archivo en otro lado se ejecuten el comando que puse dentro de "return" que en este caso seria las importaciones de mis atajos.

-- Bien, no nos metamos en tanto tecnisismo, ahora te explicare como usar la importacion de tus atajos aqui, para eso usamos lo siguiente.
-- El comando - require("ubicacion") - usemos de ejemplo un comando que ya tenemos, en la primera importacion de archivos que hacemos.
-- Usamos require("keyConfig.selectFile"), te lo explicare completamente, como bien sabemos dentro de las comillas va la ubicacion del archivo.
-- Entonces ponemos "keyConfig" con esto hacemos referencia a la carpeta "keyConfig" que es la carpeta actual donde estamos, despues ponemos un "."
-- Este nos sirve para indicar que queremos importar algo que esta dentro de esa carpeta, despues ponemos "selectFile" esto indica el nombre del archivo.

-- Con eso le decimos que de la carpeta "keyConfig" quiero importar el archivo "selectFile", tomate el tiempo de mirar los archivos de esta carpeta y notaras.
-- Que el archivo "selectFile" si existe y tiene unos atajos que configure, entonces asi tu tambien haras tus lindos atajos.

-- Dentro de la carpeta de "keyConfig" crea un archivo que tenga al final ".lua", ejemplo "ejemploAtajos.lua", para usar esos atajos que creaste en ese archivo.
-- Lo que tienes que hacer es importarlos, si yo lo hiciera haria el comando -- require("keyConfig.ejemploAtajos") --
-- Cuando importes tu archivo de atajos aqui no pongas el ".lua" del final, simplemente pon el nombre del archivo, toma de ejemplos todas las importacines hechas aqui.

-- NOTA IMPORTANTE: Cuando crees tu archivo de atajos.lua recuerda al inicio de en la primera linea de codigo poner:
-- local map = vim.keymap.set -- Si no pones eso no detectara que son configuraciones de atajos.

return {
  -- Aqui importare todos mis atajos, recuerda al final del comando poner una "coma(,)" para que asi puedas cargar el siguiente archivo de atajos, si no lo pones nvim te dara error.
  require("keyConfig.selectFile") -- Aqui ponemos la coma al terminar el comando -- Atajos de movimiento y comportamiento entre archivos.
  



  -- require("keyConfig.ejemploAtajos"), -- Si quieres quitar o desactivar unos atajos puedes borrar la linea o comentarla con "--" al inicio como hice aqui.

  -- Importa tus archivos de atajos aqui :D
  -- comando: require("ubicacion.archivo"),
  --
}  
