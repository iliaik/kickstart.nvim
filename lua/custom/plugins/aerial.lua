return {
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'AerialToggle',
  keys = {
    { '<leader>o', '<cmd>AerialToggle!<CR>', desc = 'Toggle outline' },
  },
  opts = {},
}
