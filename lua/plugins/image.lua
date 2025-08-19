-- ~/.config/nvim/lua/plugins/image.lua
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

      -- --- image.nvim setup (ONLY ONCE) ---
      image.setup({
        backend = "kitty",
        kitty_method = "normal",
        processor = "magick_cli", -- or "magick_rock"
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = true, -- 👈 render only at cursor
            only_render_image_at_cursor_mode = "inline", -- "inline" or "popup"
            -- floating_windows = true, -- only needed for popup
            filetypes = { "markdown", "vimwiki" },
          },
        },
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false,
      })

      -- helpers
      local function starts_with(s, prefix)
        return s:sub(1, #prefix) == prefix
      end
      local function percent_encode(path)
        path = path:gsub("%%", "%%25"):gsub(" ", "%%20"):gsub("%(", "%%28"):gsub("%)", "%%29")
        return path
      end
      local function percent_decode(path)
        return (
          path:gsub("%%(%x%x)", function(h)
            local n = tonumber(h, 16)
            return n and string.char(n) or "%" .. h
          end)
        )
      end

      -- resolve an Obsidian embed path to absolute
      local function resolve_obsidian_path(filedir, raw_path)
        local folder_name = vim.fn.fnamemodify(filedir, ":t")
        raw_path = raw_path:gsub("^%./", "")
        local prefix = folder_name .. "/"
        if starts_with(raw_path, prefix) then
          raw_path = raw_path:sub(#prefix + 1)
        end
        if not raw_path:match("/") then
          raw_path = "attachments/" .. raw_path
        end
        return vim.fn.fnamemodify(filedir .. "/" .. raw_path, ":p")
      end

      -- Obsidian ⇄ Markdown conversions
      local function obsidian_line_to_markdown(line, filedir)
        return line:gsub("!%[%[(.-)%]%]", function(inner)
          local abs = resolve_obsidian_path(filedir, vim.trim(inner))
          return "![](" .. percent_encode(abs) .. ")"
        end)
      end

      local function markdown_line_to_obsidian(line, filedir)
        local folder_name = vim.fn.fnamemodify(filedir, ":t")
        return line:gsub("!%[%]%((.-)%)", function(path)
          local decoded = percent_decode(path)
          if starts_with(decoded, filedir .. "/") then
            local rel = decoded:sub(#filedir + 2)
            if not starts_with(rel, folder_name .. "/") then
              rel = folder_name .. "/" .. rel
            end
            return "![[" .. rel .. "]]"
          else
            return "![](" .. path .. ")"
          end
        end)
      end

      -- Autocommands: convert on read, restore on write
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*.md",
        callback = function()
          if not is_enabled then
            return
          end
          local filedir = vim.fn.expand("%:p:h")
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          for i, line in ipairs(lines) do
            lines[i] = obsidian_line_to_markdown(line, filedir)
          end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.md",
        callback = function()
          local filedir = vim.fn.expand("%:p:h")
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          for i, line in ipairs(lines) do
            lines[i] = markdown_line_to_obsidian(line, filedir)
          end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        end,
      })

      -- Toggle command + keymap
      vim.api.nvim_create_user_command("ImageToggle", function()
        is_enabled = not is_enabled
        if is_enabled then
          print("image.nvim enabled")
          vim.cmd("edit") -- re-run BufReadPost conversion
        else
          print("image.nvim disabled")
          image.clear()
        end
      end, {})

      vim.keymap.set("n", "<leader>ti", "<cmd>ImageToggle<cr>", { desc = "Toggle images" })
    end,
  },
}
