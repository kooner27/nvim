return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    -- Add any other ibl options here, if needed
  },
  config = function()
    require('ibl').setup() -- Initialize the plugin with default options

    -- Define the toggle function
    function ToggleIndentBlankline()
      if vim.g.indent_blankline_enabled then
        vim.g.indent_blankline_enabled = false
        require('ibl').setup { enabled = false } -- Disable ibl by setting enabled = false
      else
        vim.g.indent_blankline_enabled = true
        require('ibl').setup { enabled = true } -- Enable ibl by setting enabled = true
      end
    end

    -- Keybinding to toggle ibl on and off
    vim.api.nvim_set_keymap('n', '<leader>ti', ':lua ToggleIndentBlankline()<CR>', { noremap = true, silent = true })
  end,
}
