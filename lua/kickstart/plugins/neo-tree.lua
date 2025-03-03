-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
  config = function()
    require('neo-tree').setup {
      filesystem = {
        filtered_items = {
          -- visible = true,
          show_hidden_count = true,

          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        follow_symlinks = true,
      },
      buffers = { follow_current_file = { enable = true } },
    }
    -- Define the function as a local helper
    local function ToggleOrFocusNeoTree()
      -- If the current buffer is neo-tree, toggle (close) it
      if vim.bo.filetype == 'neo-tree' then
        vim.cmd 'Neotree toggle'
        return
      end

      -- Look for an existing neo-tree window
      local neo_tree_win = nil
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
        if ft == 'neo-tree' then
          neo_tree_win = win
          break
        end
      end

      if neo_tree_win then
        -- Focus the neo-tree window if found
        vim.api.nvim_set_current_win(neo_tree_win)
      else
        -- Otherwise, open neo-tree
        vim.cmd 'Neotree toggle'
      end
    end
    -- vim.api.nvim_set_keymap('n', '\\', ':Neotree toggle<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '\\', ToggleOrFocusNeoTree, { noremap = true, silent = true })
  end,
}
