return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- NOTE: The log_level is in `opts.opts`
      opts = {
        log_level = "DEBUG", -- or "TRACE"
      },
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          http = {
            ["chatanywhere"] = function()
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                  url = "https://api.chatanywhere.tech", -- replace with your llama.cpp instance
                  api_key = "sk-njP4pMH2EO2xjP845Fh1GYz4AZ4R06xJj9aDpBU9Dfg3pHgw",
                  chat_url = "/v1/chat/completions",
                },
                schema = {
                  model = {
                    default = "gpt-5-mini",
                  },
                  max_tokens = {
                    default = 4096,
                  },
                },
              })
            end,
          },
        },
        interactions = {
          chat = {
            -- You can specify an adapter by name and model (both ACP and HTTP)
            adapter = {
              name = "chatanywhere",
              model = "gpt-5-mini",
            },
          },
          -- Or, just specify the adapter by name
          inline = {
            adapter = {
              -- name = "copilot",
              name = "chatanywhere",
              -- model = "gpt-5.1",
              model = "gpt-5-mini",
            },
          },
          cmd = {
            adapter = {
              name = "copilot",
              model = "gpt-4.1",
            },
          },
          background = {
            adapter = {
              name = "copilot",
              model = "gpt-4.1",
            },
          },
        },
        rules = {
          default = {
            description = "My default group",
            files = {
              os.getenv("HOME") .. "/.config/rules/tags_rule.md",
            },
          },
          memos_tags = {
            description = "Memos tagging rules (consistent tags)",
            files = {
              {
                os.getenv("HOME") .. "/.config/rules/tags_rule.md",
                -- path = vim.fn.stdpath("config") .. "/codecompanion/rules/memos-tags.rules.md",
                -- parser = "CodeCompanion",
              },
            },
          },
          opts = {
            chat = {
              autoload = "default",
            },
          },
        },
        -- 2) Prompt Library entry (Inline)
        prompt_library = {
          ["Memos: Generate Tags (Top)"] = {
            interaction = "inline",
            description = "Generate consistent tags for the current markdown buffer (insert at top)",
            opts = {
              alias = "memos_tags",
              auto_submit = true,
              ignore_system_prompt = true,
              stop_context_insertion = true,

              -- Load your rules group
              rules = "memos_tags",

              -- Force insertion at the very top (before line 1)
              placement = "replace",
              pre_hook = function(context)
                local bufnr = context.bufnr
                local winnr = context.winnr

                -- 只在 markdown 下生效
                if vim.bo[bufnr].filetype ~= "markdown" then
                  return
                end

                -- 确保至少有 2 行
                local line_count = vim.api.nvim_buf_line_count(bufnr)
                if line_count < 2 then
                  vim.api.nvim_buf_set_lines(bufnr, line_count, line_count, false, { "" })
                end

                -- 如果第 2 行看起来已经是 tags 行（逗号分隔的 token），先清空它
                local line2 = (vim.api.nvim_buf_get_lines(bufnr, 1, 2, false)[1] or "")
                local is_tag_line = line2:match("^%s*[%w_-]+%s*(,%s*[%w_-]+%s*)+$") ~= nil
                if is_tag_line then
                  -- 用空行占位，避免把原来的正文整体上移（你也可以选择直接删除该行）
                  vim.api.nvim_buf_set_lines(bufnr, 1, 2, false, { "" })
                end

                -- 光标移动到第 2 行第 0 列（1-based 行号）
                vim.api.nvim_win_set_cursor(winnr, { 2, 0 })
              end,
            },
            prompts = {
              {
                role = "system",
                content = function()
                  local path = vim.fn.expand(os.getenv("HOME") .. "/.config/rules/tags_rule.md")
                  local lines = vim.fn.readfile(path)
                  return table.concat(lines, "\n")
                end,
              },
              {
                role = "user",
                content = function()
                  local bufnr = vim.api.nvim_get_current_buf()
                  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                  local text = table.concat(lines, "\n")

                  -- 额外把第一行单独给出来，便于“保留/增量”策略

                  -- "Generate tags for this memo buffer:\n\n#{buffer}",
                  return ([[
Generate the tag line for this memo.

%s
]]):format(text)
                end,
                -- 文档建议 inline 场景用 #{buffer} 提供足够上下文。:contentReference[oaicite:3]{index=3}
              },
            },
          },
        },
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(ev)
          vim.keymap.set("n", "<leader>mt", "<cmd>CodeCompanion /memos_tags<CR>", {
            buffer = ev.buf,
            desc = "Memos: generate tags (top)",
          })
        end,
      })
    end,
  },
}
