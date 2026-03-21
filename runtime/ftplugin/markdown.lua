vim.treesitter.start()

vim.keymap.set('n', 'gO', function()
  require('vim.treesitter._headings').show_toc()
end, { buffer = 0, silent = true, desc = 'Show an Outline of the current buffer' })

vim.keymap.set('n', ']]', function()
  require('vim.treesitter._headings').jump({ count = 1 })
end, { buffer = 0, silent = false, desc = 'Jump to next section' })
vim.keymap.set('n', '[[', function()
  require('vim.treesitter._headings').jump({ count = -1 })
end, { buffer = 0, silent = false, desc = 'Jump to previous section' })

-- expereminting with a theme respecting dynamic modularized renderer
local function render( )
  local current_buffer = vim.api.nvim_get_current_buf()
    print(vim.inspect(require('vim.treesitter._headings').Get_headings(current_buffer)))
  local col = vim.api.nvim_get_hl(0, { name = "WarningMsg" }).fg
  for _,item in ipairs(require('vim.treesitter._headings').Get_headings(current_buffer)) do

      vim.api.nvim_set_hl(0, "H", { fg = col, bold = true, underline = true })

      vim.api.nvim_buf_add_highlight(current_buffer,-1, "H",item.lnum-1, 0, -1)
    end
end

vim.api.nvim_create_autocmd('PresentationEnter', {
  callback = function()
    vim.wo.conceallevel = 2
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.cursorline = false
    vim.wo.scrollbind =true
    -- render()
  end}
)

vim.api.nvim_create_autocmd('PresentationLeave', {
  callback = function()
    vim.wo.conceallevel = 0
    vim.wo.wrap = false
    vim.wo.linebreak = false
    vim.wo.number = true
    vim.wo.relativenumber = false
    vim.wo.cursorline = true 
  end,
})
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '\n sil! exe "nunmap <buffer> gO"'
  .. '\n sil! exe "nunmap <buffer> ]]" | sil! exe "nunmap <buffer> [["'
