return {
    {
    "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = {
                --"c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
                --"cpp", "python", "bash",
                --"html", "css", "javascript"
                -- "javascript", "html", "css",
                -- "rust", "bash",
                -- "vim", "vimdoc", "query", "elixir", "heex"
                },
            auto_install = true,
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true }
            })
    end
    },
}
