return {
	-- Autopairs plugin for auto-closing brackets/parentheses
	{
		"windwp/nvim-autopairs",
		config = function()
			local npairs = require("nvim-autopairs")

			-- Basic setup
			npairs.setup({
				check_ts = true, -- Use treesitter for better context detection
			})

			-- Setup integration with nvim-cmp for autocompletion with brackets
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			-- Adding a custom rule for C-style comments /* */
			local Rule = require("nvim-autopairs.rule")
			npairs.add_rules({
				Rule("/*", "*/", { "c", "cpp", "java", "javascript", "typescript" })
					:with_pair(function(opts)
						-- Only add the closing pair if not already present
						return opts.line:sub(opts.col, opts.col) ~= "*"
					end)
					:with_move(function(opts)
						-- Move cursor inside the comment pair
						return opts.prev_char == "*" and opts.next_char == "/"
					end)
					:use_key("*"),
			})
		end,
	},
}
