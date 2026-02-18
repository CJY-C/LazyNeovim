-- init.lua / lua/plugins/colorscheme.lua
local is_linux = vim.loop.os_uname().sysname == "Linux"

if not is_linux then
  return {}
end

return {
  "itsfernn/auto-gnome-theme.nvim",
  -- Ensure your chosen themes are installed!
  dependencies = {
    -- "folke/tokyonight.nvim",
    "rose-pine/neovim",
  },

  -- Configuration runs after the plugin is loaded
  config = function()
    require("auto-gnome-theme").setup({
      -- See Configuration section below
      theme = "rose-pine",
      -- dark_theme = "tokyonight",
      -- light_theme = "rose-pine",
    })
  end,
}
