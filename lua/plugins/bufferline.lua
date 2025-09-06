-- File: ~/.config/nvim/lua/plugins/bufferline.lua
return {
  -- Add bufferline.nvim plugin with lazy.nvim
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      -- Bufferline setup
      require('bufferline').setup {
        options = {
          numbers = 'ordinal', -- Show numbers for each buffer
          close_command = 'bdelete! %d', -- Close buffer command
          right_mouse_command = 'bdelete! %d', -- Close buffer with right-click
          middle_mouse_command = nil, -- Disable middle-click close
          offsets = {
            { filetype = 'NvimTree', text = 'File Explorer', padding = 1 },
          },
          separator_style = 'slant', -- You can also choose "thick" or "thin"
          always_show_bufferline = true, -- Always show bufferline
        },
      }

      -- for i = 1, 9 do
      --   vim.keymap.set('n', '<leader>' .. i, function()
      --     require('bufferline').go_to_buffer(i, true) -- true = absolute index
      --   end, { noremap = true, silent = true, desc = 'Go to buffer ' .. i })
      -- end
      for i = 1, 9 do
        vim.keymap.set('n', '<leader>' .. i, function()
          require('bufferline').go_to_buffer(i, true)

          local buf = vim.api.nvim_get_current_buf()
          local name = vim.api.nvim_buf_get_name(buf)
          local line_count = vim.api.nvim_buf_line_count(buf)

          -- If it's a [No Name] buffer with no content, close it
          if name == '' and line_count == 1 then
            local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
            if first_line == '' then
              vim.cmd 'bdelete!'
            end
          end
        end, { noremap = true, silent = true, desc = 'Go to buffer ' .. i })
      end

      -- Key mappings for moving buffers left and right
      vim.api.nvim_set_keymap('n', '<A-h>', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<A-l>', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })

      -- Toggle bufferline visibility
      local bufferline_visible = true
      vim.api.nvim_set_keymap('n', '<leader>bl', ':lua ToggleBufferline()<CR>', { noremap = true, silent = true })

      _G.ToggleBufferline = function()
        bufferline_visible = not bufferline_visible
        if bufferline_visible then
          vim.o.showtabline = 2 -- Show the bufferline
        else
          vim.o.showtabline = 0 -- Hide the bufferline
        end
      end
    end,
  },
}
