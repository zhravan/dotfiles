local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
map("n", "<A-Up>", ":resize -2<CR>", opts)
map("n", "<A-Down>", ":resize +2<CR>", opts)
map("n", "<A-Left>", ":vertical resize -2<CR>", opts)
map("n", "<A-Right>", ":vertical resize +2<CR>", opts)

-- Clear highlights
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Save (simple)
map({ "n", "i", "v" }, "<C-s>", function()
  vim.cmd("silent! write")
end, opts)

-- Quit
map("n", "<leader>qq", ":qa!<CR>", opts)

-- Toggle relative number
map("n", "<leader>tn", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, opts)


