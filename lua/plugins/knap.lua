return {
  "frabjous/knap",
  lazy = true,
  config = function()
    local gknapsettings = {
      texoutputext = "pdf",
      textopdf = "xelatex -synctex=1 -halt-on-error -interaction=batchmode %docroot%",
      textopdfviewerlaunch = "sioyek %outputfile%",
      textopdfforwardjump = "sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,%3)\"' --reuse-window --forward-search-file %srcfile% --forward-search-line %line% %outputfile%",
      textopdfviewerrefresh = "kill -HUP %pid%",
    }
    vim.g.knap_settings = gknapsettings
    local kmap = vim.keymap.set

    -- <F6> processes the document once, and refreshes the view
    kmap({ "n", "v", "i" }, "<F6>", function()
      require("knap").process_once()
    end)

    -- <F8> toggles the auto-processing on and off
    kmap({ "n", "v", "i" }, "<F8>", function()
      require("knap").toggle_autopreviewing()
    end)

    -- <F9> invokes a SyncTeX forward search, or similar, where appropriate
    kmap({ "n", "v", "i" }, "<F9>", function()
      require("knap").forward_jump()
    end)

    -- <F10> closes the viewer application, and allows settings to be reset
    kmap({ "n", "v", "i" }, "<F10>", function()
      require("knap").close_viewer()
    end)
  end,
  ft = { "tex" },
}
