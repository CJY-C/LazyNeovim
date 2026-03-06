-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Early macOS theme detection (no flicker)
if vim.loop.os_uname().sysname == "Darwin" then
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result:match("Dark") then
      vim.o.background = "dark"
    else
      vim.o.background = "light"
    end
  end
  vim.cmd("colorscheme rose-pine")
end
