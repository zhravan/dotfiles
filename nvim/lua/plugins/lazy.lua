return {
  -- Include packer (requested), though lazy.nvim is used as the active manager
  { "wbthomason/packer.nvim", lazy = true },
  -- Core UX
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = { options = { theme = "auto", section_separators = "", component_separators = "" } },
  },
  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, opts = {} },
  { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "akinsho/nvim-bufferline.lua", event = "VeryLazy", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {} },
  { "norcalli/nvim-colorizer.lua", event = { "BufReadPost", "BufNewFile" }, config = function()
      require("colorizer").setup()
    end },
  { "folke/zen-mode.nvim", cmd = "ZenMode", opts = {} },
  { "dinhhuy258/git.nvim", event = "VeryLazy", opts = {} },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = { hide_gitignored = false },
      },
      window = { position = "left", width = 32 },
      default_component_configs = { indent = { with_markers = false } },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      -- Auto-open on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if not vim.g.neotree_opened then
            vim.cmd("Neotree filesystem reveal left")
            vim.g.neotree_opened = true
          end
        end,
      })
    end,
  },

  -- Colorscheme
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-file-browser.nvim" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          mappings = {
            i = { ["<C-j>"] = actions.move_selection_next, ["<C-k>"] = actions.move_selection_previous },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "file_browser")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash", "lua", "json", "markdown", "markdown_inline", "vim", "vimdoc", "yaml",
        "python", "javascript", "typescript", "tsx", "html", "css", "c", "cpp", "go", "rust",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  { "windwp/nvim-ts-autotag", event = { "BufReadPost", "BufNewFile" }, opts = {} },

  -- LSP + completion
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "rafamadriz/friendly-snippets" },
      { "onsails/lspkind-nvim" },
      { "glepnir/lspsaga.nvim", opts = { symbol_in_winbar = { enable = false } } },
      { "windwp/nvim-autopairs", opts = {} },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp" }, { name = "luasnip" } },
          { { name = "buffer" } }
        ),
        formatting = {
          format = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50, ellipsis_char = "…" }),
        },
      })

      -- autopairs integration
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("nvim-autopairs").setup({})
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "tsserver", "pyright", "bashls", "jsonls", "yamlls",
          "clangd", "gopls", "rust_analyzer", "html", "cssls",
        },
        automatic_installation = true,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local on_attach = function(_, bufnr)
        local bufmap = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true })
        end
        bufmap("n", "gd", vim.lsp.buf.definition)
        bufmap("n", "gr", vim.lsp.buf.references)
        bufmap("n", "K", vim.lsp.buf.hover)
        bufmap("n", "<leader>rn", vim.lsp.buf.rename)
        bufmap("n", "<leader>ca", vim.lsp.buf.code_action)
        bufmap("n", "<leader>fd", function()
          vim.lsp.buf.format({ async = true })
        end)
        -- lspsaga keybinds (optional)
        pcall(function()
          bufmap("n", "gh", require("lspsaga.finder").lsp_finder)
          bufmap("n", "ga", require("lspsaga.codeaction").code_action)
          bufmap("n", "gp", require("lspsaga.peek.definition").peek_definition)
        end)
      end

      local servers = { "lua_ls", "tsserver", "pyright", "bashls", "jsonls", "yamlls", "clangd", "gopls", "rust_analyzer", "html", "cssls" }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({ capabilities = capabilities, on_attach = on_attach })
      end

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = { Lua = { workspace = { checkThirdParty = false }, diagnostics = { globals = { "vim" } } } },
      })
    end,
  },

  -- Formatting and diagnostics source integration (null-ls successor)
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "jay-babu/mason-null-ls.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      require("mason-null-ls").setup({
        ensure_installed = { "prettier", "eslint_d", "stylua", "black", "isort", "gofumpt", "goimports", "rustfmt", "clang-format" },
        automatic_installation = true,
      })
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
        },
      })
    end,
  },

  -- Prettier helper (optional, provides :Prettier)
  { "MunifTanjim/prettier.nvim", cmd = { "Prettier" }, opts = {} },

  -- Git UX
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}


