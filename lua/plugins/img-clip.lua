-- ~/.config/nvim/lua/plugins/img-clip.lua
return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      -- Put images in an attachments/ folder next to the current file
      dir_path = function()
        return vim.fn.expand("%:p:h") .. "/attachments"
      end,
      file_name = "Pasted image %Y%m%d%H%M%S.png",

      -- Paste as absolute Markdown with %20 escapes
      template = function(opts)
        local abs_path = opts.dir_path .. "/" .. opts.file_name
        local esc_path = abs_path:gsub(" ", "%%20")
        return "![](" .. esc_path .. ")"
      end,
    },
  },
  keys = {
    {
      "<leader>i",
      function()
        require("img-clip").paste_image()
      end,
      desc = "Paste image (absolute Markdown)",
    },
  },
}
