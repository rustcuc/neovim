-- OPTIONS
-- ============================================================
vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

-- ============================================================
-- PLUGINS
-- ============================================================
vim.pack.add({
  -- Rust LSP enhancements (rust-analyzer integration)
  {
    src = 'https://github.com/mrcjkb/rustaceanvim',
    version = vim.version.range('^9')
  },
  -- File explorer
  { src = "https://github.com/nvim-tree/nvim-tree.lua" },
  -- Autocompletion
  { src = 'https://github.com/hrsh7th/nvim-cmp' },
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
  -- Fuzzy finder
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  -- Colorscheme
  {src = "https://github.com/ellisonleao/gruvbox.nvim"},
  -- Lazygit
  { src = 'https://github.com/kdheepak/lazygit.nvim' },
  -- GitSigns
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  -- DifView
  { src = 'https://github.com/sindrets/diffview.nvim' },
  -- nvim-autopairs
  {src = "https://github.com/windwp/nvim-autopairs"},
  {src ="https://github.com/nvim-lualine/lualine.nvim"},
  {src ="https://github.com/nvim-tree/nvim-web-devicons"},

})

-- ============================================================
-- COLORSCHEME
-- ============================================================
require("gruvbox").setup()
vim.cmd.colorscheme("gruvbox")
-- ============================================================
-- FILE EXPLORER (nvim-tree)
-- ============================================================
require('nvim-tree').setup({
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')
    api.config.mappings.default_on_attach(bufnr)
    -- use 'l' to open files/folders instead of Enter
    vim.keymap.set('n', 'l', api.node.open.edit, { buffer = bufnr, noremap = true, silent = true })
  end,
  renderer = {
    group_empty = true,
    highlight_git = true,
    icons = {
      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  view = {
    width = 30,
    side = "left",
  },
  git = {
    enable = true,
    ignore = false,
  },
})

-- open nvim-tree automatically when opening a directory (nvim .)
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
      require('nvim-tree.api').tree.open()
    end
  end,
})

-- ============================================================
-- AUTOCOMPLETION (nvim-cmp)
-- ============================================================
local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' }, -- LSP completions (rust-analyzer, etc.)
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>']    = cmp.mapping.confirm({ select = true }), -- confirm selection
    ['<Tab>']   = cmp.mapping.select_next_item(),         -- next item
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),         -- previous item
  }),
})

-- ============================================================
-- FUZZY FINDER (fzf-lua)
-- ============================================================
require('fzf-lua').setup({})

-- ============================================================
-- DIAGNOSTICS
-- ============================================================
vim.diagnostic.config({
  virtual_text = true,  -- show errors inline
  signs = true,         -- show signs in gutter
  underline = true,     -- underline problematic code
  update_in_insert = false,
})

-- ============================================================
-- TERMINAL
-- ============================================================

-- clean up terminal buffer appearance
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.scrolloff = 0
    vim.opt_local.statusline = ' '
    vim.defer_fn(function()
      vim.cmd('startinsert')
    end, 100)
  end,
})

-- ============================================================
-- AUTOPAIRS
-- ============================================================

-- Setup
local autopairs = require("nvim-autopairs")
autopairs.setup({
  check_ts = true,       -- Treesitter-aware pairing
  disable_filetype = { "TelescopePrompt", "vim" },
  fast_wrap = {
    map = "<M-e>",         -- Alt+e to wrap selection
    chars = { "{", "[", "(", '"', "'" },
  },
})

-- ============================================================
-- KEYMAPS
-- ============================================================

-- file explorer
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })

-- fuzzy finder
vim.keymap.set('n', '<leader>ff', require('fzf-lua').files,         { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', require('fzf-lua').live_grep,     { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', require('fzf-lua').buffers,       { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fr', require('fzf-lua').lsp_references,{ desc = 'LSP references' })

--lazygit
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Open LazyGit' })

-- terminal
vim.keymap.set('n', '<leader>/', function()
  vim.cmd('botright split | terminal')
  vim.cmd('resize 15')
end, { desc = 'Open terminal at bottom' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n><C-w>q', { noremap = true, desc = 'Close terminal' })

-- ============================================================
-- GIT (gitsigns)
-- ============================================================
require('gitsigns').setup({
  signs = {
    add          = { text = '+' },
    change       = { text = '▎' },
    delete       = { text = '-'},
    topdelete    = { text = '' },
    changedelete = { text = '▎' },
  },
})

-- keymaps
vim.keymap.set('n', ']g', require('gitsigns').next_hunk, { desc = 'Next git hunk' })
vim.keymap.set('n', '[g', require('gitsigns').prev_hunk, { desc = 'Previous git hunk' })
vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk, { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>gs', require('gitsigns').stage_hunk,   { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>gu', require('gitsigns').undo_stage_hunk, { desc = 'Undo stage hunk' })
vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line,   { desc = 'Blame line' })

-- ============================================================
-- GIT DIFF / LOG (diffview)
-- ============================================================
require('diffview').setup()

vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>',        { desc = 'Git diff' })
vim.keymap.set('n', '<leader>gl', ':DiffviewFileHistory<CR>', { desc = 'Git log' })
vim.keymap.set('n', '<leader>gx', ':DiffviewClose<CR>',       { desc = 'Close diffview' })

-- ============================================================
-- STATUSLINE UPDATE
-- ============================================================

require("lualine").setup({
  options = {
    theme        = "auto",
    globalstatus = true,
    component_separators = { left = "|", right = "|" },
    section_separators  = { left = "", right = "" },
  },
  sections = {
    -- LEFT: mode | git branch | git diff | LSP diagnostics
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      "diff",
      {
        "diagnostics",
        sources = { "nvim_lsp" },
        symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
      },
    },

    -- CENTER: relative/path/to/file  ● if modified
    lualine_c = {
      { "filename", path = 1, symbols = { modified = " ●", readonly = " 🔒" } },
    },

    -- RIGHT: rust toolchain | lsp server | lsp progress | encoding | filetype
    lualine_x = {
      -- Rust toolchain version — only shown in .rs files
      {
                  function()
                        local h = io.popen("rustc --version 2>/dev/null")
                        if h then
                          local r = h:read("*a"):match("rustc ([%d%.]+)")
                          h:close()
                          if r then return "rust:" .. r end
                        end
                        return ""
                  end,
                  cond  = function() return vim.bo.filetype == "rust" end,
                  color = { fg = "#e06c75" },
                },
      -- Active LSP server name(s) for this buffer
      {
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then return "" end
          local names = {}
          for _, c in ipairs(clients) do table.insert(names, c.name) end
          return "lsp:" .. table.concat(names, ",")
        end,
        color = { fg = "#98c379" },
      },

      -- LSP indexing/loading progress (Neovim 0.12 built-in vim.lsp.status())
      {
        function() return vim.lsp.status() end,
        cond  = function() return vim.lsp.status() ~= "" end,
        color = { fg = "#e5c07b" },
      },

      "encoding",
      "filetype",
    },

    -- FAR RIGHT: scroll % | line:col
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
