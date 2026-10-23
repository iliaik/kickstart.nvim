local M = {}

function M.setup()
  if vim.fn.has 'nvim-0.12' == 0 then
    return
  end

  -- Neovim 0.12 removed all=false: legacy handlers still expect one node per capture.
  local query = vim.treesitter.query
  local registrations = { add_predicate = query.add_predicate, add_directive = query.add_directive }
  for name, register in pairs(registrations) do
    query[name] = function(handler_name, handler, opts)
      if type(opts) == 'table' and opts.all == false then
        local legacy_handler = handler
        handler = function(match, ...)
          local legacy_match = {}
          for capture, nodes in pairs(match) do
            legacy_match[capture] = nodes[#nodes]
          end
          return legacy_handler(legacy_match, ...)
        end
      end
      return register(handler_name, handler, opts)
    end
  end

  -- Reload only this plugin's handlers, then restore the public registration functions.
  package.loaded['nvim-treesitter.query_predicates'] = nil
  local ok, err = pcall(require, 'nvim-treesitter.query_predicates')
  for name, register in pairs(registrations) do
    query[name] = register
  end
  if not ok then
    error(err)
  end
end

return M
