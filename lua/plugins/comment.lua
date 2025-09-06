return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup {
      -- Ensure only linewise comments are used for all modes
      toggler = {
        line = 'gcc', -- For single-line toggle in normal mode
      },
      opleader = {
        line = 'gc', -- For visual mode toggle, ensuring linewise comments
      },
      mappings = {
        basic = false, -- Disable default mappings
        extra = false,
      },
    }

    -- Function to reselect visual range
    local function reselect_visual_range()
      vim.cmd 'normal! gv'
    end

    -- Normal mode: Toggle comment on the current line with Ctrl + /
    vim.keymap.set('n', '<C-_>', function()
      require('Comment.api').toggle.linewise.current()
    end, { noremap = true, silent = true })

    -- Visual mode: Toggle linewise comments only on selected lines with Ctrl + /
    vim.keymap.set('v', '<C-_>', function()
      -- Save the visual selection range
      local _, s_row, s_col, _ = unpack(vim.fn.getpos 'v')
      local _, e_row, e_col, _ = unpack(vim.fn.getpos '.')

      -- Toggle comments for each line in the visual selection
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'nx', false)
      require('Comment.api').toggle.linewise(vim.fn.visualmode())

      -- Restore the visual selection range
      vim.fn.setpos("'<", { 0, s_row, s_col, 0 })
      vim.fn.setpos("'>", { 0, e_row, e_col, 0 })
      reselect_visual_range()
    end, { noremap = true, silent = true })

    -- Alternative mappings for Ctrl + / in case <C-_> doesn’t work
    vim.keymap.set('n', '<C-/>', function()
      require('Comment.api').toggle.linewise.current()
    end, { noremap = true, silent = true })

    vim.keymap.set('v', '<C-/>', function()
      local _, s_row, s_col, _ = unpack(vim.fn.getpos 'v')
      local _, e_row, e_col, _ = unpack(vim.fn.getpos '.')

      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'nx', false)
      require('Comment.api').toggle.linewise(vim.fn.visualmode())

      vim.fn.setpos("'<", { 0, s_row, s_col, 0 })
      vim.fn.setpos("'>", { 0, e_row, e_col, 0 })
      reselect_visual_range()
    end, { noremap = true, silent = true })
  end,
}
