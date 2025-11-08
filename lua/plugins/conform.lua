return {
  {
    -- Autoformat
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
      {
        '<leader>tf',
        function()
          vim.g.format_on_save = not vim.g.format_on_save
          local msg = vim.g.format_on_save and 'Format on save: ON' or 'Format on save: OFF'
          vim.notify(msg, vim.log.levels.INFO)
        end,
        desc = '[T]oggle format on save',
      },
    },
    opts = {
      notify_on_error = false,

      format_on_save = function(bufnr)
        -- Toggle controlled by global variable
        if not vim.g.format_on_save then
          return
        end

        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        -- local disable_filetypes = { c = true, cpp = true }
        -- Global toggle
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
        lua = { 'stylua', stop_after_first = true },
        cpp = { 'clang-format', stop_after_first = true },
        c = { 'clang-format', stop_after_first = true },
        sh = { 'shfmt', stop_after_first = true },
        javascript = { 'prettierd', stop_after_first = true },
        typescript = { 'prettierd', stop_after_first = true },
        html = { 'prettierd', stop_after_first = true },
        css = { 'prettierd', stop_after_first = true },
        scss = { 'prettierd', stop_after_first = true },
        json = { 'prettierd', stop_after_first = true },
        jsonc = { 'prettierd', stop_after_first = true },
        yaml = { 'prettierd', stop_after_first = true },
        vue = { 'prettierd', stop_after_first = true },
        svelte = { 'prettierd', stop_after_first = true },
        javascriptreact = { 'prettierd', stop_after_first = true },
        typescriptreact = { 'prettierd', stop_after_first = true },
      },
    },
    init = function()
      -- Default: enable format on save
      vim.g.format_on_save = true
    end,
  },
}
