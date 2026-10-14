vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

local autopairs = require("nvim-autopairs")
-- Quotes pair everywhere, prose included: the default rules already skip pairing
-- after a letter/digit, so apostrophes in contractions ("it's") stay single.
autopairs.setup({})
