return {
  'dhananjaylatkar/cscope_maps.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    -- we want this to work for ANY C project
    cscope = {
      exec = 'cscope', -- use system cscope
      db_file = 'cscope.out', -- don't hardcode path, use filename only

      -- auto-detect DB in parent folders (project agnostic)
      project_rooter = {
        enable = true,
        change_cwd = false, -- don't auto-cd into project root
      },

      picker = 'telescope', -- fancy UI
      skip_picker_for_single_result = true,
    },
  },

  config = function(_, opts)
    require('cscope_maps').setup(opts)
  end,
}
