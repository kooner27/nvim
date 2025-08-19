return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    config = function()
      local image = require("image")
      local is_enabled = false -- start disabled to avoid blocking

      image.setup({
        backend = "kitty", -- or "wezterm"/"ueberzugpp"
        kitty_method = "normal",
        processor = "magick_rock", -- faster than magick_cli
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = true, -- lazy load at cursor
            only_render_image_at_cursor_mode = "inline", -- render inline, not popup
            floating_windows = false,
            filetypes = { "markdown", "vimwiki" },
          },
        },
        -- Hard limits so images don’t blow up your terminal
        max_height_window_percentage = 40,
        max_width_window_percentage = 40,
        max_height = 20,
        max_width = 40,
        window_overlap_clear_enabled = false,
      })

      -------------------------------------------------------------------
      -- Render Obsidian-style embeds in-place (no file modification)
      -------------------------------------------------------------------
      local function render_obsidian_embeds(bufnr)
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        for lnum, line in ipairs(lines) do
          local embed = line:match("!%[%[(.-)%]%]") -- grab inside [[...]]
          if embed and #embed > 0 then
            -- Strip after | (like "file.png|100x100")
            local filename = embed:match("^[^|]+") or embed
            filename = vim.trim(filename)

            -- Path: attachments/<filename>
            local path = "attachments/" .. filename

            -- Escape spaces for image.nvim
            local esc_path = path:gsub(" ", "%%20")

            -- Replace inline with Markdown syntax
            local new_line = line:gsub("!%[%[.-%]%]", function()
              return "![](" .. esc_path .. ")"
            end)

            if new_line ~= line then
              vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { new_line })
            end
          end
        end
      end

      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "*.md",
        callback = function(args)
          render_obsidian_embeds(args.buf)
        end,
      })

      -------------------------------------------------------------------
      -- Toggle command: clears images or refreshes buffer to re-render
      -------------------------------------------------------------------
      vim.api.nvim_create_user_command("ImageToggle", function()
        if is_enabled then
          image.clear()
          print("🖼️ image.nvim: images hidden")
        else
          vim.cmd("edit!") -- re-triggers BufWinEnter + image.nvim
          print("🖼️ image.nvim: images rendered")
        end
        is_enabled = not is_enabled
      end, {})

      vim.keymap.set("n", "<leader>it", "<cmd>ImageToggle<cr>", { desc = "Toggle image rendering" })

      -------------------------------------------------------------------
      -- Cleanup on exit: avoid zombie processes
      -------------------------------------------------------------------
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          require("image").clear()
        end,
      })
    end,
  },
}
