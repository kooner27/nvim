return {
	-- Autopairs plugin for auto-closing brackets/parentheses
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true, -- Use treesitter for better context detection
			})

			-- Setup integration with nvim-cmp for autocompletion with brackets
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
}

