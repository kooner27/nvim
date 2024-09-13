return {
  -- Mason: manages external tools like language servers
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  -- Mason LSP Config: automatically installs and configures language servers
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true, -- Automatically install configured LSPs
    },
  },
  -- LSP Config: Sets up language servers and their keybindings
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- Capabilities for completion, integrated with cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Setup for different language servers
      local lspconfig = require("lspconfig")
      
      -- TypeScript/JavaScript
      lspconfig.ts_ls.setup({
        capabilities = capabilities
      })
      -- Ruby Solargraph
      lspconfig.solargraph.setup({
        capabilities = capabilities
      })
      -- HTML LSP
      lspconfig.html.setup({
        capabilities = capabilities
      })
      -- Lua LSP
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })

      -- Keybindings for LSP actions (hover, go to definition, references)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {}) -- Hover to see documentation
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {}) -- Go to definition
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {}) -- Find references
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {}) -- Show code actions
    end,
  },
}
