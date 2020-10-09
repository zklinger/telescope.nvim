
vim.deepcopy = (function()
  local function _id(v)
    return v
  end

  local deepcopy_funcs = {
    table = function(orig)
      local copy = {}

      if vim._empty_dict_mt ~= nil and getmetatable(orig) == vim._empty_dict_mt then
        copy = vim.empty_dict()
      end

      for k, v in pairs(orig) do
        copy[vim.deepcopy(k)] = vim.deepcopy(v)
      end

      if getmetatable(orig) then
        setmetatable(copy, getmetatable(orig))
      end

      return copy
    end,
    ['function'] = _id or function(orig)
      local ok, dumped = pcall(string.dump, orig)
      if not ok then
        error(debug.traceback(dumped))
      end

      local cloned = loadstring(dumped)
      local i = 1
      while true do
        local name = debug.getupvalue(orig, i)
        if not name then
          break
        end
        debug.upvaluejoin(cloned, i, orig, i)
        i = i + 1
      end
      return cloned
    end,
    number = _id,
    string = _id,
    ['nil'] = _id,
    boolean = _id,
  }

  return function(orig)
    local f = deepcopy_funcs[type(orig)]
    if f then
      return f(orig)
    else
      error("Cannot deepcopy object of type "..type(orig))
    end
  end
end)()



table.clear = table.clear or function(t)
  for k in pairs (t) do
      t[k] = nil
  end
end

table.pop = table.pop or function(t, k)
  local val = t[k]
  t[k] = nil
  return val
end

if TELESCOPE_DEBUG then
  if not _OldSetLines then
    _OldSetLines = vim.api.nvim_buf_set_lines
  end

  vim.api.nvim_buf_set_lines = function(bufnr, start, finish, _, lines)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      error(debug.traceback('invalid bufnr'))
    end

    require('telescope.log').file_info({bufnr, start, finish, lines}, {info_level = 4})

    local ok, msg = pcall(_OldSetLines, bufnr, start, finish, false, lines)
    if not ok then
      error(debug.traceback(msg))
    end
  end
end
