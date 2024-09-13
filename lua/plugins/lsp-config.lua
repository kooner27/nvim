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
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")
      
      -- C++ support using Clangd LSP
      lspconfig.clangd.setup({
        capabilities = capabilities
      })
      
      -- Other language servers...
      lspconfig.ts_ls.setup({ capabilities = capabilities }) -- JavaScript/TypeScript
      lspconfig.html.setup({ capabilities = capabilities }) -- HTML
      lspconfig.lua_ls.setup({ capabilities = capabilities }) -- Lua
      
      -- LSP keybindings for navigation
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {}) -- Hover to see documentation
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {}) -- Go to definition
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {}) -- Find references
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {}) -- Show code actions
    end,
  },
}
