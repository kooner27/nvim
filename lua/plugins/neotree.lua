-- file explorer
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    vim.keymap.set('n', '<C-n>', function()
      vim.cmd 'normal! 0'
      vim.cmd 'Neotree toggle reveal=true'
    end, { noremap = true, silent = true })

    require('neo-tree').setup {
      -- Natural/version sort (like `ls -v`)
      sort_case_insensitive = true,
      sort_function = function(a, b)
        -- Some nodes may not have a.name; fall back.
        local aname = (a.name or a.path or '')
        local bname = (b.name or b.path or '')

        -- Put directories first (then files, then others)
        local function type_rank(t)
          if t == 'directory' then
            return 0
          end
          if t == 'file' then
            return 1
          end
          return 2
        end
        local ra, rb = type_rank(a.type), type_rank(b.type)
        if ra ~= rb then
          return ra < rb
        end

        -- Split into alternating number/text chunks
        local function chunks(s)
          s = s or ''
          local out, i = {}, 1
          while i <= #s do
            local num = s:match('^%d+', i)
            if num then
              out[#out + 1] = tonumber(num)
              i = i + #num
            else
              local txt = s:match('^[^%d]+', i) or s:sub(i, i)
              out[#out + 1] = txt:lower()
              i = i + #txt
            end
          end
          return out
        end

        local A, B = chunks(aname), chunks(bname)
        local n = math.max(#A, #B)
        for i = 1, n do
          local x, y = A[i], B[i]
          if x == nil then
            return true
          end -- a ran out first
          if y == nil then
            return false
          end -- b ran out first
          local tx, ty = type(x), type(y)
          if tx == 'number' and ty == 'number' then
            if x ~= y then
              return x < y
            end
          elseif tx == 'number' and ty == 'string' then
            return true -- numbers come before text
          elseif tx == 'string' and ty == 'number' then
            return false -- text after numbers
          else
            if x ~= y then
              return x < y
            end -- string vs string
          end
        end
        return false
      end,

      filesystem = {
        -- your other filesystem options if any
      },
    }
  end,
}
