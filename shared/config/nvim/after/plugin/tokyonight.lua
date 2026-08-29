-- Small shared palette used by Ghostty and btop as well.
if vim.fn.filereadable(vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")) == 1 then
  return
end

vim.o.background = "dark"
vim.api.nvim_set_hl(0, "Normal", { fg = "#a9b1d6", bg = "#1a1b26" })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#a9b1d6", bg = "#13141c" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#24283b" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#292e42" })
vim.api.nvim_set_hl(0, "Comment", { fg = "#565f89" })
vim.api.nvim_set_hl(0, "String", { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "Function", { fg = "#7aa2f7" })
vim.api.nvim_set_hl(0, "Keyword", { fg = "#ad8ee6" })
vim.api.nvim_set_hl(0, "Type", { fg = "#449dab" })
vim.api.nvim_set_hl(0, "Constant", { fg = "#eb927b" })
vim.api.nvim_set_hl(0, "Error", { fg = "#ff7a93" })
vim.api.nvim_set_hl(0, "WarningMsg", { fg = "#ff9e64" })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#7da6ff" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#414868" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#7aa2f7" })
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#a9b1d6", bg = "#24283b" })
vim.api.nvim_set_hl(0, "Pmenu", { fg = "#a9b1d6", bg = "#13141c" })
vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#a9b1d6", bg = "#292e42" })
vim.api.nvim_set_hl(0, "Search", { fg = "#1a1b26", bg = "#e0af68" })
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#7aa2f7", bg = "#24283b" })
