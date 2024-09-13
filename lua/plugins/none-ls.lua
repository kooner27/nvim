return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")

        -- Setup null-ls with sources for diagnostics and formatting
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.diagnostics.erb_lint,
                null_ls.builtins.diagnostics.rubocop,
                null_ls.builtins.formatting.rubocop,

                -- C++ specific formatters/linters
                null_ls.builtins.formatting.clang_format,
                --null_ls.builtins.diagnostics.cpplint,
            },
            -- Use the new server_capabilities field instead of resolved_capabilities
            on_attach = function(client, bufnr)
                -- Check if the server supports document formatting
                if client.server_capabilities.documentFormattingProvider then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("LspFormatting", {}),
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end,
        })

        -- Keybinding for formatting the current file
        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
}
