-- lua/plugins/colorscheme.lua
local sysname = vim.loop.os_uname().sysname
local is_linux = sysname == "Linux"
local is_mac = sysname == "Darwin"

if is_linux then
  return {
    "itsfernn/auto-gnome-theme.nvim",
    dependencies = {
      "rose-pine/neovim",
    },
    config = function()
      require("auto-gnome-theme").setup({
        theme = "rose-pine",
      })
    end,
  }
end

if is_mac then
  return {
    "f-person/auto-dark-mode.nvim",
    dependencies = {
      "rose-pine/neovim",
    },
    config = function()
      require("auto-dark-mode").setup({
        update_interval = 3000,
        set_dark_mode = function()
          vim.o.background = "dark"
          -- vim.cmd("colorscheme rose-pine")
        end,
        set_light_mode = function()
          vim.o.background = "light"
          -- vim.cmd("colorscheme rose-pine")
        end,
      })
    end,
  }
end

return {}
