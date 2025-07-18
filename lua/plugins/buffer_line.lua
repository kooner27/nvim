-- File: ~/.config/nvim/lua/plugins/bufferline.lua
return {
  -- Add bufferline.nvim plugin with lazy.nvim
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      -- Bufferline setup
      require("bufferline").setup({
        options = {
          numbers = "ordinal", -- Show numbers for each buffer
          close_command = "bdelete! %d", -- Close buffer command
          right_mouse_command = "bdelete! %d", -- Close buffer with right-click
          middle_mouse_command = nil, -- Disable middle-click close
          offsets = {
            { filetype = "NvimTree", text = "File Explorer", padding = 1 },
          },
          separator_style = "slant", -- You can also choose "thick" or "thin"
          always_show_bufferline = true, -- Always show bufferline
        },
      })

      -- Key mappings for switching between buffers using Alt + number keys
      for i = 1, 9 do
        vim.api.nvim_set_keymap(
          "n",
          "<A-" .. i .. ">",
          ":BufferLineGoToBuffer " .. i .. "<CR>",
          { noremap = true, silent = true }
        )
      end
      -- fallback if Alt+number doesn't work in Ghostty
      for i = 1, 9 do
        vim.keymap.set("n", "<leader>" .. i, function()
          -- Get list of listed buffers (in bufferline order)
          local buffers = vim.fn.getbufinfo({ buflisted = 1 })
          table.sort(buffers, function(a, b)
            return a.bufnr < b.bufnr
          end)

          local target = buffers[i]
          if not target then
            return
          end -- No such buffer

          local name = target.name
          local bufnr = target.bufnr
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

          if name == "" and #lines == 1 and lines[1] == "" then
            -- [No Name] and empty → delete it
            vim.api.nvim_buf_delete(bufnr, { force = true })
          else
            -- valid buffer → go to it
            vim.cmd("BufferLineGoToBuffer " .. i)
          end
        end, { noremap = true, silent = true })
      end

      -- Key mappings for moving buffers left and right
      vim.api.nvim_set_keymap("n", "<A-h>", ":BufferLineMovePrev<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<A-l>", ":BufferLineMoveNext<CR>", { noremap = true, silent = true })

      -- Toggle bufferline visibility
      local bufferline_visible = true
      vim.api.nvim_set_keymap("n", "<leader>bl", ":lua ToggleBufferline()<CR>", { noremap = true, silent = true })

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
