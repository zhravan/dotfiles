local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", {}),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Open help in a vertical split
autocmd("FileType", {
  group = augroup("help_vertical", {}),
  pattern = { "help" },
  callback = function()
    vim.cmd.wincmd("L")
  end,
})


