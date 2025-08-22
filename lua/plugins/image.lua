return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = { rocks = { "magick" } },
  },
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    config = function()
      local image = require("image")
      local is_enabled = true

      image.setup({
        backend = "kitty", -- or "wezterm" / "ueberzug"
        kitty_method = "normal", -- "normal" or "kitten"
        processor = "magick_rock", -- enables resizing/format convert

        -- keep it simple; let the plugin size things automatically
        max_width = 94, -- optional: cap width in terminal columns
        max_height = nil,
        scale_factor = 1.0,

        integrations = {
          -- HTML-only integration; this renders <img src="..."> in .html & .md
          html = {
            enabled = true,
            download_remote_images = true,
            clear_in_insert_mode = false,
            only_render_image_at_cursor = true, -- perf-friendly
            only_render_image_at_cursor_mode = "inline", -- inline instead of float
            floating_windows = false,
            window_overlap_clear_enabled = true,
            filetypes = { "html", "xhtml", "htm", "markdown" },
          },
        },
      })

      -- Toggle command
      vim.api.nvim_create_user_command("ImageToggle", function()
        if is_enabled then
          image.clear()
          print("🖼️ image.nvim: images hidden")
        else
          vim.cmd("edit!") -- re-open buffer to trigger render
          print("🖼️ image.nvim: images rendered")
        end
        is_enabled = not is_enabled
      end, {})

      vim.keymap.set("n", "<leader>it", "<cmd>ImageToggle<cr>", { desc = "Toggle image rendering" })

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          require("image").clear()
        end,
      })
    end,
  },
}
