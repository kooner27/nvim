return {
  {
    'lunarvim/bigfile.nvim',
    config = function()
      -- Helper function to calculate file size in MiB
      local function get_file_size(filepath)
        local stat = vim.loop.fs_stat(filepath)
        if stat and stat.size then
          -- Convert size from bytes to MiB
          return stat.size / (1024 * 1024)
        end
        return 0 -- Default to 0 if size cannot be determined
      end

      require('bigfile').setup {
        filesize = 10, -- File size fallback (in MiB)
        pattern = function(bufnr)
          -- Get the file path
          local file_path = vim.api.nvim_buf_get_name(bufnr)

          -- Calculate the file size
          local file_size_mib = get_file_size(file_path)

          -- Refuse to open files larger than 5 MiB
          if file_size_mib > 5 then
            vim.notify('File is too large to open: ' .. file_path, vim.log.levels.ERROR)
            -- Defer buffer deletion to avoid issues during BufReadPre
            vim.defer_fn(function()
              vim.cmd('bdelete ' .. bufnr)
            end, 10) -- 10ms delay
            return false
          end

          -- Disable features for files between 2 MiB and 5 MiB
          if file_size_mib > 2 then
            return true
          end

          -- Allow smaller files without disabling features
          return false
        end,
        features = { -- Features to disable for big files
          'indent_blankline',
          'illuminate',
          'lsp',
          'treesitter',
          'syntax',
          'matchparen',
          'vimopts',
          'filetype',
        },
      }
    end,
    lazy = true,
    event = 'BufReadPre', -- Trigger on file read
  },
}
-- vim: ts=2 sts=2 sw=2 et
