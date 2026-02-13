return {
  {
    "CJY-C/memos.nvim",
    branch = "dev-cjy",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      -- lua/plugins/memos.lua
      require("memos").setup({
        -- api_version = "v0.21",
        list_sort_presets = {
          "pinned desc, display_time desc",
          "pinned desc, display_time asc",
          "display_time desc",
          "display_time asc",
          "create_time desc",
          "create_time asc",
        },
        list_relations_mode = "out",
        list_relations_auto_expand = true,
        -- Number of memos to fetch per page
        page_size = 30,

        -- Auto-save the memo when leaving insert mode or holding the cursor.
        auto_save = false,
        -- Window configuration
        window = {
          enable_float = true, -- Set to true to open the list in a floating window
          width = 0.85, -- Width ratio (0.0 to 1.0)
          height = 0.85, -- Height ratio (0.0 to 1.0)
          border = "rounded", -- Border style: "single", "double", "rounded", "solid", "shadow"
        },

        -- Set to false or nil to disable a keymap
        keymaps = {
          -- Keymap to open the memos list. Default: <leader>mm
          start_memos = "<leader>mm",
          switch_user = "<leader>mc",

          -- Keymaps for the memo list window
          list = {
            add_memo = "a",
            delete_memo = "d",
            delete_memo_visual = "dd",
            -- Assign both <CR> and 'i' to edit a memo
            edit_memo = { "<CR>", "i" },
            vsplit_edit_memo = "<C-v>",
            -- search_memos = "f",
            refresh_list = "r",
            next_page = ".",
            quit = "q",
          },
          -- Keymaps for the editing/creating buffer
          buffer = {
            save = "<leader>ms",
            edit_metadata = "<leader>me",
            -- Back to list from a memo
            back_to_list = "<Esc>",
          },
        },
      })
    end,
  },
}
