-- ~/.config/nvim/lua/plugins/img-clip.lua
return {
  'HakonHarnes/img-clip.nvim',
  event = 'VeryLazy',
  opts = {
    default = {
      dir_path = 'attachments', -- save images in ./attachments relative to current file
      extension = 'png',
      file_name = 'Pasted image %Y%m%d%H%M%S',
      prompt_for_file_name = false,
      relative_to_current_file = true,
      relative_template_path = true,
      url_encode_path = true,
    },

    filetypes = {
      markdown = {
        url_encode_path = true,
        download_images = false,
        template = '<img src="$FILE_PATH">', -- same as html default
      },

      html = {
        url_encode_path = true,
        template = '<img src="$FILE_PATH">',
      },
    },
  },

  keys = {
    {
      '<leader>i',
      '<cmd>PasteImage<cr>',
      desc = 'Paste image as HTML <img>',
    },
  },
}
