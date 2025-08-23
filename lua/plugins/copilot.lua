-- add to the readme
-- change default split global and for copilot (right instead of left)
-- vim.opt.splitright = true
-- -- also for copilot
-- vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "popup" }
-- -- disable copilot auto completion, i want it just to be the backend for chat
vim.g.copilot_enabled = false
-- vim.g.copilot_filetypes = { ["*"] = false }

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken", -- optional; only on macOS/Linux
    opts = {
      -- optional config
      model = "gpt-4o", -- or "gpt-4.1", "gpt-3.5", etc.
      agent = "copilot",
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
      window = {
        layout = "vertical",
        width = 0.5,
        height = 0.5,
        title = "Copilot Chat",
      },
    },
    keys = {
      { "<C-M-i>", "<cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
    },
  },
}

-- return {
--   {
--     "CopilotC-Nvim/CopilotChat.nvim",
--     dependencies = {
--       { "github/copilot.vim" },
--       { "nvim-lua/plenary.nvim" },
--     },
--     build = "make tiktoken", -- Only for macOS/Linux
--     cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
--
--     -- or maybe use leader cc for toggle
--     keys = {
--       { "<C-M-i>", "<cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
--     },
--
--     opts = {
--       system_prompt = "COPILOT_INSTRUCTIONS",
--       -- model = "gpt-4o",
--       agent = "copilot",
--       context = nil,
--       sticky = nil,
--       temperature = 0.1,
--       headless = false,
--       stream = nil,
--       callback = nil,
--       remember_as_sticky = true,
--
--       selection = function(source)
--         local select = require("CopilotChat.select")
--         return select.visual(source) or select.buffer(source)
--       end,
--
--       window = {
--         layout = "vertical",
--         width = 0.5,
--         height = 0.5,
--         relative = "editor",
--         border = "single",
--         row = nil,
--         col = nil,
--         title = "Copilot Chat",
--         footer = nil,
--         zindex = 1,
--       },
--
--       show_help = true,
--       highlight_selection = true,
--       highlight_headers = true,
--       references_display = "virtual",
--       auto_follow_cursor = true,
--       auto_insert_mode = false,
--       insert_at_end = false,
--       clear_chat_on_new_prompt = false,
--
--       debug = false,
--       log_level = "info",
--       proxy = nil,
--       allow_insecure = false,
--
--       chat_autocomplete = true,
--
--       log_path = vim.fn.stdpath("state") .. "/CopilotChat.log",
--       history_path = vim.fn.stdpath("data") .. "/copilotchat_history",
--
--       question_header = "# User ",
--       answer_header = "# Copilot ",
--       error_header = "# Error ",
--       separator = "───",
--
--       providers = {
--         copilot = {},
--         github_models = {},
--         copilot_embeddings = {},
--       },
--
--       contexts = {
--         buffer = {},
--         buffers = {},
--         file = {},
--         files = {},
--         git = {},
--         url = {},
--         register = {},
--         quickfix = {},
--         system = {},
--       },
--
--       prompts = {
--         Explain = {
--           prompt = "Write an explanation for the selected code as paragraphs of text.",
--           system_prompt = "COPILOT_EXPLAIN",
--         },
--         Review = {
--           prompt = "Review the selected code.",
--           system_prompt = "COPILOT_REVIEW",
--         },
--         Fix = {
--           prompt = "There is a problem in this code. Identify the issues and rewrite the code with fixes. Explain what was wrong and how your changes address the problems.",
--         },
--         Optimize = {
--           prompt = "Optimize the selected code to improve performance and readability. Explain your optimization strategy and the benefits of your changes.",
--         },
--         Docs = {
--           prompt = "Please add documentation comments to the selected code.",
--         },
--         Tests = {
--           prompt = "Please generate tests for my code.",
--         },
--         Commit = {
--           prompt = "Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.",
--           context = "git:staged",
--         },
--       },
--
--       mappings = {
--         complete = {
--           insert = "<Tab>",
--         },
--         close = {
--           normal = "q",
--           insert = "<C-c>",
--         },
--         reset = {
--           normal = "<C-l>",
--           insert = "<C-l>",
--         },
--         submit_prompt = {
--           normal = "<CR>",
--           insert = "<C-s>",
--         },
--         toggle_sticky = {
--           normal = "grr",
--         },
--         clear_stickies = {
--           normal = "grx",
--         },
--         accept_diff = {
--           normal = "<C-y>",
--           insert = "<C-y>",
--         },
--         jump_to_diff = {
--           normal = "gj",
--         },
--         quickfix_answers = {
--           normal = "gqa",
--         },
--         quickfix_diffs = {
--           normal = "gqd",
--         },
--         yank_diff = {
--           normal = "gy",
--           register = '"',
--         },
--         show_diff = {
--           normal = "gd",
--           full_diff = false,
--         },
--         show_info = {
--           normal = "gi",
--         },
--         show_context = {
--           normal = "gc",
--         },
--         show_help = {
--           normal = "gh",
--         },
--       },
--     },
--   },
-- }
