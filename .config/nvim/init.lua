--:L: Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ================== General Settings ==================
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- UI
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.colorcolumn = "+1"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescroll = 1
vim.opt.fillchars = { vert = "│", fold = "·", eob = " " }
vim.opt.listchars = { tab = "→ ", trail = "·" }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- File handling
vim.opt.autowrite = true

-- Undo
vim.opt.undodir = os.getenv("HOME") .. "/.undodir"
vim.opt.undofile = true

-- ================== Autocommands ==================
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- YAML 2-space indent
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "yaml",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Go: auto format + organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
      for _, action in pairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})

-- C/C++: <leader>rr compile & run, <leader>dd compile & debug
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp" },
  callback = function(args)
    local function compile()
      local src = vim.fn.expand("%:p")
      local bin = vim.fn.expand("%:p:r")
      local is_cpp = vim.bo.filetype == "cpp"
      local cc = is_cpp and "g++-15" or "gcc-15"
      local std_flag = is_cpp and "-std=c++20" or ""
      vim.cmd("write")
      local out = vim.fn.system(("%s %s -g -O0 %s -o %s"):format(
        cc, std_flag, vim.fn.shellescape(src), vim.fn.shellescape(bin)
      ))
      if vim.v.shell_error ~= 0 then
        vim.notify("Compile failed:\n" .. out, vim.log.levels.ERROR)
        return nil
      end
      return bin
    end

    vim.keymap.set("n", "<leader>rr", function()
      local bin = compile()
      if not bin then return end
      vim.cmd("botright 15split | terminal " .. vim.fn.shellescape(bin))
      vim.cmd("startinsert")
    end, { buffer = args.buf, desc = "Compile & run" })

    vim.keymap.set("n", "<leader>dd", function()
      local bin = compile()
      if not bin then return end
      require("dap").run({
        name = "Launch (compiled)",
        type = "codelldb",
        request = "launch",
        program = bin,
        cwd = vim.fn.expand("%:p:h"),
        stopOnEntry = false,
      })
    end, { buffer = args.buf, desc = "Compile & debug" })
  end,
})

-- Go: <leader>rr go run, <leader>dd debug current file with delve
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "go",
  callback = function(args)
    vim.keymap.set("n", "<leader>rr", function()
      vim.cmd("write")
      local src = vim.fn.expand("%:p")
      vim.cmd("botright 15split | terminal go run " .. vim.fn.shellescape(src))
      vim.cmd("startinsert")
    end, { buffer = args.buf, desc = "go run" })

    vim.keymap.set("n", "<leader>dd", function()
      vim.cmd("write")
      require("dap").run({
        name = "Launch (delve)",
        type = "delve",
        request = "launch",
        mode = "debug",
        program = "${file}",
        cwd = vim.fn.expand("%:p:h"),
      })
    end, { buffer = args.buf, desc = "Debug with delve" })

    vim.keymap.set("n", "<leader>dT", function()
      require("dap-go").debug_test()
    end, { buffer = args.buf, desc = "Debug nearest Go test" })
  end,
})

-- Java: <leader>rr compile & run current file
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "java",
  callback = function(args)
    vim.keymap.set("n", "<leader>rr", function()
      vim.cmd("write")
      local src = vim.fn.expand("%:p")
      local dir = vim.fn.expand("%:p:h")
      local class = vim.fn.expand("%:t:r")
      local out = vim.fn.system(("javac %s"):format(vim.fn.shellescape(src)))
      if vim.v.shell_error ~= 0 then
        vim.notify("Compile failed:\n" .. out, vim.log.levels.ERROR)
        return
      end
      vim.cmd(("botright 15split | terminal java -cp %s %s"):format(
        vim.fn.shellescape(dir), vim.fn.shellescape(class)
      ))
      vim.cmd("startinsert")
    end, { buffer = args.buf, desc = "Compile & run (javac + java)" })
  end,
})

-- Highlight on yank (replaces vim-highlightedyank)
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

-- ================== Plugins ==================
require("lazy").setup({
  spec = {
    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter").setup({
          ensure_installed = { "go", "gomod", "gosum", "gowork", "python", "c", "cpp", "java" },
        })
      end,
    },

    -- Theme
    {
     "catppuccin/nvim",
     name = "catppuccin",
     priority = 1000,
     config = function()
       require("catppuccin").setup({
           integrations = {
               lualine = true,
           }
       })
       vim.cmd.colorscheme("catppuccin-mocha")
     end,
    },
    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "catppuccin" },
      config = function()
        vim.schedule(function()
          require("lualine").setup({
            options = {
              icons_enabled = false,
              section_separators = "",
              component_separators = "",
            },
            sections = {
              lualine_a = { "mode" },
              lualine_b = { "branch" },
              lualine_c = { { "filename", path = 1 } },
              lualine_x = { "encoding", "fileformat", "filetype" },
              lualine_y = { "progress" },
              lualine_z = { "location" },
            },
          })
        end)
      end,
    },
    -- Fuzzy finder (replaces fzf.vim)
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<C-f>", "<cmd>Telescope find_files<cr>" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>" },
      },
    },

    -- Surround (replaces vim-surround)
    {
      "kylechui/nvim-surround",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup()
      end,
    },

    -- Auto pairs
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup()
      end,
    },


    -- Tmux navigation
    { "christoomey/vim-tmux-navigator" },

    -- Keybinding discoverability
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        preset = "modern",
        delay = 300,
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
      config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.add({
          { "<leader>f", group = "find/format" },
          { "<leader>rn", desc = "LSP: rename" },
          { "<leader>ca", desc = "LSP: code action" },
          { "<leader>oi", desc = "Java: organize imports" },
          { "<leader>d", group = "debug/diagnostics" },
          { "<leader>db", desc = "DAP: toggle breakpoint" },
          { "<leader>dB", desc = "DAP: conditional breakpoint" },
          { "<leader>dc", desc = "DAP: continue" },
          { "<leader>dd", desc = "DAP: compile & debug (C/C++/Go)" },
          { "<leader>dT", desc = "DAP: debug nearest Go test" },
          { "<leader>dl", desc = "DAP: run last" },
          { "<leader>dr", desc = "DAP: repl" },
          { "<leader>dt", desc = "DAP: terminate" },
          { "<leader>du", desc = "DAP: toggle UI" },
          { "<leader>ff", desc = "Telescope: find files" },
          { "<leader>fm", desc = "LSP: format buffer" },
          { "<leader>fg", desc = "Telescope: live grep" },
          { "<leader>fb", desc = "Telescope: buffers" },
        })
      end,
    },

    -- LSP installer
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim" },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "gopls", "pyright", "clangd" },
          -- We enable servers ourselves via vim.lsp.enable() / nvim-jdtls,
          -- so don't let mason-lspconfig auto-attach (avoids double-attaching jdtls).
          -- jdtls is installed via Homebrew (`brew install jdtls`), not mason,
          -- because mason's pinned Eclipse milestone URL 404s once builds rotate.
          automatic_enable = false,
        })
      end,
    },

    -- LSP
    {
      "hrsh7th/cmp-nvim-lsp",
      config = function()
        vim.lsp.config("gopls", {
          cmd = { "gopls" },
          root_markers = { "go.mod", "go.work", ".git" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        })
        vim.lsp.enable("gopls")

        vim.lsp.config("pyright", {
          cmd = { "pyright-langserver", "--stdio" },
          root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
          filetypes = { "python" },
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        })
        vim.lsp.enable("pyright")

        vim.lsp.config("clangd", {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--query-driver=/opt/homebrew/bin/g++-15,/opt/homebrew/bin/gcc-15,/opt/homebrew/Cellar/gcc/*/bin/g++-15,/opt/homebrew/Cellar/gcc/*/bin/gcc-15",
          },
          root_markers = {
            ".clangd",
            ".clang-tidy",
            ".clang-format",
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac",
            ".git",
          },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
        vim.lsp.enable("clangd")

        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local opts = { buffer = args.buf }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "<leader>fm", function()
              vim.lsp.buf.format({ async = true })
            end, opts)
          end,
        })
      end,
    },

    -- Java LSP (jdtls needs special launch/per-project workspace handling)
    {
      "mfussenegger/nvim-jdtls",
      ft = "java",
      dependencies = { "hrsh7th/cmp-nvim-lsp" },
      config = function()
        local function start_jdtls()
          local root = vim.fs.root(0, {
            "gradlew", "mvnw", "pom.xml",
            "build.gradle", "build.gradle.kts", "settings.gradle", ".git",
          }) or vim.fn.getcwd()
          local project = vim.fn.fnamemodify(root, ":p:h:t")
          local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. project

          require("jdtls").start_or_attach({
            cmd = { "/opt/homebrew/bin/jdtls", "-data", workspace },
            root_dir = root,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              java = {
                signatureHelp = { enabled = true },
                completion = {
                  favoriteStaticMembers = {
                    "org.junit.Assert.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "org.mockito.Mockito.*",
                  },
                },
                sources = {
                  organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
                },
              },
            },
          })

          -- jdtls-specific extras on top of the shared LspAttach keymaps
          vim.keymap.set("n", "<leader>oi", require("jdtls").organize_imports,
            { buffer = 0, desc = "Java: organize imports" })
        end

        -- Attach for the buffer that triggered loading, and any future java buffers.
        start_jdtls()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "java",
          callback = start_jdtls,
        })
      end,
    },

    -- Debugger (DAP)
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "jay-babu/mason-nvim-dap.nvim",
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",
      },
      config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local mason_path = vim.fn.stdpath("data") .. "/mason"

        require("mason-nvim-dap").setup({
          ensure_installed = { "codelldb", "delve", "python" },
          automatic_installation = true,
          handlers = {},
        })

        dapui.setup()
        dap.listeners.before.attach.dapui_config = function() dapui.open() end
        dap.listeners.before.launch.dapui_config = function() dapui.open() end
        dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
        dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

        require("dap-go").setup()
        require("dap-python").setup(mason_path .. "/packages/debugpy/venv/bin/python")

        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = mason_path .. "/bin/codelldb",
            args = { "--port", "${port}" },
          },
        }
        for _, lang in ipairs({ "c", "cpp" }) do
          dap.configurations[lang] = {
            {
              name = "Launch executable",
              type = "codelldb",
              request = "launch",
              program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
              stopOnEntry = false,
            },
          }
        end

        local map = vim.keymap.set
        map("n", "<F5>",  dap.continue,           { desc = "DAP: continue" })
        map("n", "<F10>", dap.step_over,          { desc = "DAP: step over" })
        map("n", "<F11>", dap.step_into,          { desc = "DAP: step into" })
        map("n", "<F12>", dap.step_out,           { desc = "DAP: step out" })
        map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: toggle breakpoint" })
        map("n", "<leader>dB", function()
          dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "DAP: conditional breakpoint" })
        map("n", "<leader>dc", dap.continue,    { desc = "DAP: continue" })
        map("n", "<leader>dr", dap.repl.toggle, { desc = "DAP: repl" })
        map("n", "<leader>du", dapui.toggle,    { desc = "DAP: toggle UI" })
        map("n", "<leader>dt", dap.terminate,   { desc = "DAP: terminate" })
        map("n", "<leader>dl", dap.run_last,    { desc = "DAP: run last" })
      end,
    },

    -- Autocompletion
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
          }, {
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end,
    },
  },
  install = { colorscheme = { "catppuccin-mocha" } },
  checker = { enabled = true, notify = false },
})
