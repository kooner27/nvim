return {
  -- LSP completion source for nvim-cmp
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  -- Snippet engine and prebuilt snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip", -- LuaSnip integration with nvim-cmp
      "rafamadriz/friendly-snippets", -- Pre-made snippets
    },
  },
  -- Main autocompletion plugin
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load snippets from VSCode-friendly snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- nvim-cmp setup
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- Tab completion logic
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              cmp.confirm({ select = true })  -- Confirm the selected completion
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- LuaSnip snippets
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
