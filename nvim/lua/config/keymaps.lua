local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Eclipse-style navigation (back/forward)
map("n", "<A-Left>", "<C-o>", opts)   -- Back
map("n", "<A-Right>", "<C-i>", opts)  -- Forward

-- Clear highlights
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Save (simple)
map({ "n", "i", "v" }, "<C-s>", function()
  vim.cmd("silent! write")
end, opts)

-- Help: discover shortcuts
map("n", "<leader>?", function()
  require("telescope.builtin").keymaps()
end, opts)
map("n", "<leader>h?", function()
  require("which-key").show("<leader>", { mode = "n" })
end, opts)

-- VSCode-like: Toggle sidebar (Ctrl+B)
map("n", "<C-b>", ":Neotree toggle left<CR>", opts)

-- Eclipse: Search dialog → project search (approx): Ctrl+H
map("n", "<C-h>", function()
  require("telescope.builtin").live_grep({})
end, opts)

-- Eclipse: Open Resource (Ctrl+Shift+R) → files
map("n", "<C-R>", function()
  require("telescope.builtin").find_files({ hidden = true })
end, opts)

-- Eclipse: Open Type (Ctrl+Shift+T) → workspace symbols
map("n", "<C-T>", function()
  require("telescope.builtin").lsp_dynamic_workspace_symbols()
end, opts)

-- Eclipse: Quick Outline (Ctrl+O) → document symbols
map("n", "<C-o>", function()
  require("telescope.builtin").lsp_document_symbols()
end, opts)

-- Eclipse: Go to definition (F3)
map("n", "<F3>", vim.lsp.buf.definition, opts)

-- Eclipse: Find References (Ctrl+Shift+G)
map("n", "gR", function()
  require("telescope.builtin").lsp_references()
end, opts)

-- Eclipse: Quick Fix (Ctrl+1)
map("n", "<C-1>", vim.lsp.buf.code_action, opts)

-- Eclipse: Rename (Alt+Shift+R)
map({ "n", "v" }, "<A-S-r>", vim.lsp.buf.rename, opts)

-- Eclipse: Format (Ctrl+Shift+F)
map({ "n", "v" }, "<C-F>", function()
  vim.lsp.buf.format({ async = true })
end, opts)

-- Eclipse: Organize Imports (Ctrl+Shift+O)
local function organize_imports()
  local params = {
    context = { only = { "source.organizeImports" } },
    textDocument = vim.lsp.util.make_text_document_params(),
  }
  vim.lsp.buf.code_action({
    context = params.context,
    apply = true,
  })
end
map("n", "<C-O>", organize_imports, opts)

-- Quit
map("n", "<leader>qq", ":qa!<CR>", opts)

-- Toggle relative number
map("n", "<leader>tn", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, opts)


