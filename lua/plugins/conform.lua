return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        -- local disable_filetypes = { c = true, cpp = true }
        local disable_filetypes = {}
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = {
          'stylua',
          stop_after_first = true, -- Stops after the first available formatter
        },
        cpp = {
          'clang-format',
          stop_after_first = true,
        },
        c = {
          'clang-format',
          stop_after_first = true,
        },
        sh = {
          'shfmt',
          stop_after_first = true,
        },
        javascript = { 'prettierd', stop_after_first = true },
        typescript = { 'prettierd', stop_after_first = true },
        html = { 'prettierd', stop_after_first = true },
        css = { 'prettierd', stop_after_first = true },
        scss = { 'prettierd', stop_after_first = true },
        json = { 'prettierd', stop_after_first = true },
        jsonc = { 'prettierd', stop_after_first = true },
        -- markdown = { "prettierd", stop_after_first = true },
        yaml = { 'prettierd', stop_after_first = true },
        vue = { 'prettierd', stop_after_first = true },
        svelte = { 'prettierd', stop_after_first = true },
        javascriptreact = { 'prettierd', stop_after_first = true },
        typescriptreact = { 'prettierd', stop_after_first = true },
        -- ["*"] = { "lsp_format" }, -- Fallback to LSP formatting for unsupported filetypes
      },

      -- formatters_by_ft = {
      --   lua = { 'stylua' },
      --   -- Conform can also run multiple formatters sequentially
      --   -- python = { "isort", "black" },
      --   --
      --   -- You can use 'stop_after_first' to run the first available formatter from the list
      --   -- javascript = { "prettierd", "prettier", stop_after_first = true },
      -- },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
