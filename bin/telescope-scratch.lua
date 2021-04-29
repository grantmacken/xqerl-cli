local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local finders = require('telescope.finders')
local conf = require("telescope.config").values
require('telescope').setup {}
local opts = opts or {}

pickers.new {
  results_title = 'Resources',
  -- Run an external command and show the results in the finder window
  finder = finders.new_oneshot_job({'xq', 'list', 'http://example.com/examples'}),
  --sorter = sorters.get_fuzzy_file(),
  sorter = conf.file_sorter(opts),
  previewer = previewers.new_termopen_previewer {
    -- Execute another command using the highlighted entry
    get_command = function(entry)
      return {'xq', 'get', entry.value}
    end
  },
}:find()
