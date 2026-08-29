local theme = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

if vim.fn.filereadable(theme) == 0 then
  return {}
end

local ok, spec = pcall(dofile, theme)
return ok and spec or {}
