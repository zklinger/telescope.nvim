local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local make_entry = require "telescope.make_entry"
local previewers = require "telescope.previewers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local colors = function(opts)
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
          is_upper = 0,
          display = function(tbl)
            return tbl.is_upper .. "  " .. tbl.value
          end
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    previewer = previewers.file_size.new(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.git_staging_toggle:enhance {
        post = function()
          action_state.get_current_picker(prompt_bufnr):refresh_previewer()
        end,
      }

      map("i", "<tab>", actions.git_staging_toggle)
      map("n", "<tab>", actions.git_staging_toggle)

     return true
    end,
  }):find()
end


colors({})
-- colors(require("telescope.themes").get_dropdown{})

