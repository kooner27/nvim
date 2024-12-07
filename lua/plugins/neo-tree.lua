-- file explorer. nvim-tree is wrapper for neotree
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    vim.keymap.set("n", "<C-n>", function()
      vim.cmd("normal! 0") -- Move cursor to the beginning of the line
      vim.cmd("Neotree toggle reveal=true") -- Toggle Neo-tree
    end, { noremap = true, silent = true })
  end,
}
