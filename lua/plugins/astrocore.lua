-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
        -- 去掉wsl时粘贴的^M
        ["p"] = {
          function()
            if not os.getenv "WSLENV" then vim.cmd "normal! p" end

            function Trim()
              local save = vim.fn.winsaveview()
              -- 使用 Vim 命令去除空格
              vim.cmd "keeppatterns %s/\\s\\+$\\|\\r$//e"
              vim.fn.winrestview(save)
            end
            vim.cmd "normal! p"
            -- 调用 Trim 函数
            vim.schedule(function() Trim() end)
          end,
        },
        ["P"] = {
          function()
            if not os.getenv "WSLENV" then vim.cmd "normal! P" end

            function Trim()
              local save = vim.fn.winsaveview()
              -- 使用 Vim 命令去除空格
              vim.cmd "keeppatterns %s/\\s\\+$\\|\\r$//e"
              vim.fn.winrestview(save)
            end
            vim.cmd "normal! P"
            -- 调用 Trim 函数
            vim.schedule(function() Trim() end)
          end,
        },
      },
    },
    autocmds = {
      -- 添加新的 formatoptions 配置组
      format_options = {
        {
          event = "FileType",
          desc = "Disable auto comment for all file types",
          pattern = "*",
          command = "set formatoptions-=cro",
        },
      },
      -- WSL 相关的输入法切换配置组
      wsl_ime = (function()
        if not os.getenv "WSLENV" then return {} end

        return {
          {
            event = "InsertLeave",
            desc = "Switch to English input method when leaving insert mode",
            callback = function() vim.cmd ":silent :!/mnt/d/typewriting/switch/im-select.exe 1033" end,
          },
          {
            event = "InsertEnter",
            desc = "Switch to Chinese input method when entering insert mode",
            callback = function() vim.cmd ":silent :!/mnt/d/typewriting/switch/im-select.exe 2052" end,
          },
          {
            event = "VimLeave",
            desc = "Switch to Chinese input method when leaving Vim",
            callback = function() vim.cmd ":silent :!/mnt/d/typewriting/switch/im-select.exe 2052" end,
          },
          {
            event = "FocusGained",
            desc = "Switch to Chinese input method when Vim gains focus",
            callback = function() vim.cmd ":silent :!/mnt/d/typewriting/switch/im-select.exe 2052" end,
          },
          {
            event = "FocusLost",
            desc = "Switch to Chinese input method when Vim loses focus",
            callback = function() vim.cmd ":silent :!/mnt/d/typewriting/switch/im-select.exe 2052" end,
          },
        }
      end)(),
    },
  },
}
