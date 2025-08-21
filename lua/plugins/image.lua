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
        backend = "kitty",
        kitty_method = "normal",
        processor = "magick_rock",
        max_width = 95,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = nil,
        scale_factor = 1.0,

        -- max_width_window_percentage = 50, -- percent of window
        -- max_height_window_percentage = 50,
        -- window_overlap_clear_enabled = true,

        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            only_render_image_at_cursor_mode = "popup",
            floating_windows = true,
            filetypes = { "markdown" },
          },
        },
      })

      -------------------------------------------------------------------
      -- Markdown → Obsidian (on save/write)
      -------------------------------------------------------------------

      local function markdown_to_obsidian(bufnr)
        local file_dir = vim.fn.expand("%:p:h")
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

        for lnum, line in ipairs(lines) do
          -- match path + optional width attr
          local abs, size = line:match("!%[%]%((.-)%)%s*{%s*width=(%d+)%s*}")
          if not abs then
            abs = line:match("!%[%]%((.-)%)")
          end

          if abs and abs:find(file_dir, 1, true) then
            local rel = abs:gsub("^" .. vim.pesc(file_dir) .. "/", "")
            rel = rel:gsub("%%20", " ")

            if not rel:match("^attachments/") then
              rel = "attachments/" .. rel
            end

            local new_line = "![[" .. rel
            if size then
              new_line = new_line .. "|" .. size
            end
            new_line = new_line .. "]]"

            if new_line ~= line then
              vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { new_line })
            end
          end
        end
      end

      -- Auto run before saving markdown
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.md",
        callback = function(args)
          markdown_to_obsidian(args.buf)
        end,
      })

      -------------------------------------------------------------------
      -- Obsidian → Markdown (on read/open)
      -------------------------------------------------------------------

      local function obsidian_to_markdown(bufnr)
        local file_dir = vim.fn.expand("%:p:h")
        local dir_name = vim.fn.fnamemodify(file_dir, ":t")
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

        for lnum, line in ipairs(lines) do
          local embed = line:match("!%[%[(.-)%]%]")
          if embed then
            -- Split on |
            local filename, size = embed:match("^(.-)|(%d+)$")
            if not filename then
              filename = embed
            end
            filename = vim.trim(filename)

            -- strip leading dir_name/ if present
            if filename:find("^" .. vim.pesc(dir_name) .. "/") then
              filename = filename:gsub("^" .. vim.pesc(dir_name) .. "/", "")
            end

            local abs_path = file_dir .. "/" .. filename
            local esc_path = abs_path:gsub(" ", "%%20")

            local new_line = "![](" .. esc_path .. ")"
            if size then
              new_line = new_line .. "{width=" .. size .. "}"
            end

            if new_line ~= line then
              vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { new_line })
            end
          end
        end
      end

      -------------------------------------------------------------------
      -- Autocommands
      -------------------------------------------------------------------
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*.md",
        callback = function(args)
          obsidian_to_markdown(args.buf)
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.md",
        callback = function(args)
          markdown_to_obsidian(args.buf)
        end,
      })

      -------------------------------------------------------------------
      -- Toggle command
      -------------------------------------------------------------------
      vim.api.nvim_create_user_command("ImageToggle", function()
        if is_enabled then
          image.clear()
          print("🖼️ image.nvim: images hidden")
        else
          vim.cmd("edit!") -- retrigger BufReadPost → render
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
