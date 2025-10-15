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

    local function OpenOrFocusNeoTreeThisTab()
      -- if there's a neo-tree window in the current tab, focus it
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'neo-tree' then
          vim.cmd('Neotree focus')
          return
        end
      end
      -- otherwise open a fresh one in this tab
      vim.cmd('Neotree filesystem reveal left')
    end

    local function ToggleNeoTreeThisTab()
      local neo_win
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'neo-tree' then
          neo_win = win
          break
        end
      end

      if neo_win then
        -- Close just the Neo-tree window in this tab
        vim.api.nvim_win_close(neo_win, true)
      else
        -- Open a fresh Neo-tree in this tab
        vim.cmd('Neotree filesystem reveal left')
      end
    end

    local function ToggleOrFocusNeoTreeThisTab()
      local cur_win = vim.api.nvim_get_current_win()
      local neo_win = nil

      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'neo-tree' then
          neo_win = win
          break
        end
      end

      if neo_win then
        if cur_win == neo_win then
          -- focused on neo-tree -> close it
          vim.api.nvim_win_close(neo_win, true)
        else
          -- neo-tree exists but not focused -> focus it
          vim.api.nvim_set_current_win(neo_win) -- or: vim.cmd('Neotree focus')
        end
      else
        -- no neo-tree in this tab -> open it here
        vim.cmd('Neotree filesystem reveal left')
      end
    end

    -- vim.api.nvim_set_keymap('n', '\\', ':Neotree toggle<CR>', { noremap = true, silent = true })
    -- vim.keymap.set('n', '\\', ToggleOrFocusNeoTree, { noremap = true, silent = true })
    vim.keymap.set('n', '\\', ToggleOrFocusNeoTreeThisTab, { noremap = true, silent = true })
  end,
}
