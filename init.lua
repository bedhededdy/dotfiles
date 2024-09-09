-- TODO: FIGURE OUT IF I SHOULD JUST COPY KICKSTART.NVIM INSTEAD OF MAINTAINING THIS CONFIG

-- Bootstrap lazy.nvim
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

-- Make sure to setup 'mapleader' and 'maplocalleader' before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use 4 spaces as a tab
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- Auto indent
vim.opt.smartindent = true

-- Start moving the view down when 8 lines from the bottom
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Trigger plugins quckly
vim.opt.updatetime = 100

-- Color column 80
vim.opt.colorcolumn = "80"

-- Keep long file history for Undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Use relative line numbers and show the actual line number on the current line
vim.wo.number = true
vim.wo.relativenumber = true

-- Remap jj to Escape
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true })

-- When pasting over highlighted word, keep the current paste buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Copy to system clipboard
vim.keymap.set("n", "<leader>y", "\"*y")
vim.keymap.set("v", "<leader>y", "\"*y")
vim.keymap.set("n", "<leader>Y", "\"*y")

-- Delete while keeping the current paste buffer
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Unmap Q
vim.keymap.set("n", "Q", "<nop>")

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- Telescope (fuzzy finder)
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        -- Treesitter (better syntax highlighting)
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function() 
                local configs = require("nvim-treesitter.configs")

                configs.setup({
                    ensure_installed = { "c", "lua", "css", "html", "javascript", "typescript", "java" },
                    sync_install = false,
                    auto_install = true,
                    highlight = { 
                        enable = true,
                        additional_vim_regex_highlighting = false,
                    },
                    indent = { enable = true },
                })
            end
        },
        -- Harpoon (quick-select for pinned files)
        {
            "theprimeagen/harpoon",
        },
        -- Undotree (see file revision history)
        {
            "mbbill/undotree",
        },
        -- Fugitive (Git integration)
        {
            "tpope/vim-fugitive",
        },
        -- LSP Support
        {
            "neovim/nvim-lspconfig",
        },
        {
            "williamboman/mason.nvim",
        },
        {
            "williamboman/mason-lspconfig.nvim",
        },
        {
            "nvim-java/nvim-java"
        },

        -- Autocompletion
        {
           "hrsh7th/nvim-cmp",
        },
        {
           "hrsh7th/cmp-buffer",
        },
        {
           "hrsh7th/cmp-path",
        },
        {
           "saadparwaiz1/cmp_luasnip",
        },
        {
           "hrsh7th/cmp-nvim-lsp",
        },
        {
           "hrsh7th/cmp-nvim-lua",
        },

        -- Snippets
        {
           "L3MON4D3/LuaSnip",
        },
        {
           "rafamadriz/friendly-snippets",
        },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that wil be used when installing plugins.
    -- install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})

-- Set Telescope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Set Harpoon keymaps
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>fa", mark.add_file)
vim.keymap.set("n", "<leader>fq", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>f1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>f1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>f2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>f3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>f4", function() ui.nav_file(4) end)

-- Set Undotree keymaps
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Set Fugitive keymaps
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- Setup LSP
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keybindings',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<leader>h", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  end
})

require("java").setup() -- Java is weird and needs to be setup before requiring the lspconfig

local lspconfig = require("lspconfig")
lspconfig.jdtls.setup({}) -- Now we can truly setup Java
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "ts_ls",
        "lua_ls",
        "html",
        "cssls",
        "clangd",
        "pyright",
        "eslint"
    },
    handlers = {
        function(server)
            lspconfig[server].setup({
                capabilities = lsp_capabilities,
            })
        end,
        lua_ls = function()
            lspconfig.lua_ls.setup({
                capabilities = lsp_capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = {"vim"}
                        },
                        workspace = {
                            library = {
                                vim.env.VIMRUNTIME,
                            }
                        }
                    }
                }
            })
        end
    }
})

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}

--- loads custom snippets from friendly-snippets
-- require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    sources = {
        {name = "path"},
        {name = "nvim_lsp"},
        {name = "nvim_lua"},
        -- {name = "buffer", keyword_length = 3},
        -- {name = "luasnip", keyword_length = 2},
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
    }),
    window = {
        documentation = cmp.config.window.bordered(),
    },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
})

