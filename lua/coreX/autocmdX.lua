-- Configuraciones globales, aqui definimos como se comportan cualquier archivo que abramos.
local autocmd = vim.api.nvim_create_autocmd


-- Resalta el texto al hacer yank (copiar)
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})


-- Elimina espacios en blanco al guardar
autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})


-- Restaura la última posición del cursor al abrir un archivo
autocmd("BufReadPost", {
  callback = function()
    if vim.fn.line([['"]]) > 0 and vim.fn.line([['"]]) <= vim.fn.line("$") then
      pcall(vim.cmd, [[normal! g`"]])
    end
  end,
})


-- Refresca el archivo si cambió fuera de Neovim
autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime",
})


-- Ajusta el tipo de archivo automáticamente en algunos casos raros
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  command = "set filetype=markdown",
})
