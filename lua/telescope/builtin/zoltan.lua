local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local make_entry = require "telescope.make_entry"
local previewers = require "telescope.previewers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local file_size = function(opts)
  pickers.new(opts, {
    prompt_title = "File size",
    finder = finders.new_table {
      results = {
         "Makefile",
         "README.md",
         "CONTRIBUTING.md",
      },
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry,
          human_readable = false,
          display = function(tbl)
            local indicator_char = tbl.human_readable and "*" or " "
            return indicator_char .. " " .. tbl.value
          end
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    previewer = previewers.file_size.new(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.file_size_toggle:enhance {
        post = function()
          action_state.get_current_picker(prompt_bufnr):refresh()
        end,
      }

      map("i", "<tab>", actions.file_size_toggle)
      map("n", "<tab>", actions.file_size_toggle)

     return true
    end,
  }):find()
end


file_size({})

