return {
  "3rd/image.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local image = require("image")
    local is_enabled = true

    image.setup({
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          only_render_image_at_cursor_mode = "popup",
          floating_windows = false,
          filetypes = { "markdown" },
        },
      },
    })

    vim.api.nvim_create_user_command("ImageToggle", function()
      if is_enabled then
        image.clear()
        print("🖼️ image.nvim: images hidden")
      else
        -- Trick: re-edit buffer to re-trigger autocommands and image matchers
        vim.cmd("edit!")
        print("🖼️ image.nvim: images rendered")
      end
      is_enabled = not is_enabled
    end, {})

    vim.keymap.set("n", "<leader>it", "<cmd>ImageToggle<cr>", { desc = "Toggle image rendering" })
  end,
}
