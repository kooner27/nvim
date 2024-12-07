-- return {
-- 	"nvim-lualine/lualine.nvim",
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
-- 	lazy = false,
-- 	opts = function(_, opts)
-- 		-- Set up Dracula theme and icons globally
-- 		opts.options = opts.options or {}
-- 		opts.options.theme = "dracula"
-- 		opts.options.icons_enabled = true
--
-- 		-- Configure trouble symbols for lualine
-- 		local trouble = require("trouble")
-- 		local symbols = trouble.statusline({
-- 			mode = "lsp_document_symbols",
-- 			groups = {},
-- 			title = false,
-- 			filter = { range = true },
-- 			format = "{kind_icon}{symbol.name:Normal}",
-- 			hl_group = "lualine_c_normal",
-- 		})
--
-- 		-- Ensure lualine_c section exists and add trouble symbols
-- 		opts.sections = opts.sections or {}
-- 		opts.sections.lualine_c = opts.sections.lualine_c or {}
--
-- 		-- Insert trouble symbols into lualine_c section
-- 		table.insert(opts.sections.lualine_c, {
-- 			symbols.get,
-- 			cond = symbols.has,
-- 		})
-- 	end,
-- }

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    local trouble = require("trouble")
    local symbols = trouble.statusline({
      mode = "lsp_document_symbols",
      groups = {},
      title = false,
      filter = { range = true },
      format = "{kind_icon}{symbol.name:Normal}",
      hl_group = "lualine_c_normal",
    })

    -- Initialize opts.sections and opts.sections.lualine_c if not defined
    opts.sections = opts.sections or {}
    opts.sections.lualine_c = opts.sections.lualine_c or {}

    -- Insert trouble symbols into lualine_c
    table.insert(opts.sections.lualine_c, {
      symbols.get,
      cond = symbols.has,
    })
  end,
}

-- return {
-- 	"nvim-lualine/lualine.nvim",
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
-- 	config = function()
-- 		require("lualine").setup({
-- 			options = {
-- 				theme = "dracula",
-- 				icons_enabled = true,
-- 			},
-- 		})
-- 	end,
-- 	lazy = false,
-- }
