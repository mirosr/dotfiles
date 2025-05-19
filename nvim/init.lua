local cmd = vim.cmd
local g = vim.g
local o = vim.o
local opt = vim.opt
local keymap = vim.keymap

-- Set <space> as the leader key
-- Must happen before plugins are required (otherwise wrong leader will be used)
g.mapleader = ' '
g.maplocalleader = ' '

-- Packer -------------------------------------------------------------------------------------------------------------
require('plugins')

cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
------------------------------------------------------------------------------------------------------------------------

-- General -------------------------------------------------------------------------------------------------------------
--
-- Turn off backup and swap files
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Automatically re-read when a file is changed from outside
opt.autoread = true

-- Allow buffers to be switched without saving
opt.hidden = true

-- Forbid setting variables specific to a file
opt.modeline = false

-- Don't stop on dashes on word motion
--set iskeyword+=-
opt.iskeyword:append('-')

-- Decrease update time
-- opt.updatetime = 250
-- opt.timeoutlen = 300

-- Improve completion experience (always show the popup menu and force item selection)
opt.completeopt = 'menuone,noselect'
------------------------------------------------------------------------------------------------------------------------

-- Appearance ----------------------------------------------------------------------------------------------------------
--
-- Prefer 24-bit color
opt.termguicolors = true

-- Theme
require('onedark').setup { style = 'darker' }
-- require('onedark').load()
require('everforest').setup({
  background = 'hard'
})
require('everforest').load()

-- Highlight current line
opt.cursorline = true

-- Show line numbers relative to the current line
opt.number = true
opt.relativenumber = true

cmd([[
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  augroup END
]])

-- Don’t update screen during macro and script execution
opt.lazyredraw = true

-- Don't show the current mode (the statusline plugin handles this)
opt.showmode = false

-- Don't show the cursor position (the statusline plugin handles this)
opt.ruler = false

-- Make some context visible around the current line
opt.scrolloff = 3

-- Show some invisible characters
opt.list = true
opt.listchars:append({ tab = '→ ', trail = '·', precedes = '«', extends = '»' })

-- Update terminal window title
opt.title = true

if g.neovide then
  o.guifont = "Hack:h14"
  g.neovide_hide_mouse_when_typing = true
end
------------------------------------------------------------------------------------------------------------------------

-- Searching -----------------------------------------------------------------------------------------------------------
--
-- Don't highlith all matches
-- opt.hlsearch = false

-- Ignore case in search patterns unless they contain a capital letter
opt.ignorecase = true
opt.smartcase = true

-- Global search by default (/g to turn it off)
opt.gdefault = true
------------------------------------------------------------------------------------------------------------------------

-- Formating -----------------------------------------------------------------------------------------------------------
--
-- Prefer using spaces over tabs
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- Show matching parenthesis
opt.showmatch = true

-- Continue every wrapped line visually indented
opt.breakindent = true
------------------------------------------------------------------------------------------------------------------------

-- Folding -------------------------------------------------------------------------------------------------------------
opt.foldenable = false
opt.foldmethod = 'indent'
opt.foldnestmax = 10
opt.foldlevel = 1
------------------------------------------------------------------------------------------------------------------------

-- Windows -------------------------------------------------------------------------------------------------------------
--
-- Put the new window below the current one
opt.splitbelow = true

-- Put the new window right of the current one
opt.splitright = true
------------------------------------------------------------------------------------------------------------------------

-- Automatic commands --------------------------------------------------------------------------------------------------
--
-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Git
cmd([[
  autocmd Filetype gitcommit setlocal spell textwidth=72
]])

-- Markdown
cmd([[
  autocmd Filetype markdown setlocal spell textwidth=120
]])
------------------------------------------------------------------------------------------------------------------------

-- Key mappings --------------------------------------------------------------------------------------------------------
local map = vim.api.nvim_set_keymap
local silent = { silent = true, noremap = true }

-- Edit the config file
map('n', '<leader>ec', ':tabe $MYVIMRC<cr>', silent)
-- Source the config file
map('n', '<leader>sc', ':source $MYVIMRC<cr>', silent)
-- Edit the plugins file
map('n', '<leader>ep', ':tabe ~/.config/nvim/lua/plugins.lua<cr>', silent)

-- Disable entering Ex mode with Q
map('', 'Q', '<nop>', silent)

-- Switch between windows
map('', '<C-k>', '<C-w>k', silent)
map('', '<C-j>', '<C-w>j', silent)
map('', '<C-h>', '<C-w>h', silent)
map('', '<C-l>', '<C-w>l', silent)

-- Swapping windows
map('', '<C-s>', '<C-w>r', silent)

-- Cycle through windows
map('n', '<tab>', ':wincmd w<cr>', silent)

-- Cycle through tabs
map('', '<PageUp>', 'gT', silent)
map('', '<PageDown>', 'gt', silent)

-- Copy to clipboard
map('v', '<leader>y', '"+y', silent)
map('n', '<leader>y', '"+y', silent)
map('n', '<leader>Y', '"+yg_', silent)

-- Paste from clipboard
map('n', '<leader>p', '"+p', silent)
map('v', '<leader>p', '"+p', silent)
map('n', '<leader>P', '"+P', silent)
map('v', '<leader>P', '"+P', silent)

-- Paste from the most recent yank command
map('n', '<leader>v', '"0p', silent)

-- Explore files
-- map('n', '<leader>e', ':Lexplore %:h<cr><cr>', silent)
-- map('n', '<leader>E', ':Lexplore .<cr>', silent)
map('n', '<leader>e', ':Neotree dir=%:h<cr>', silent)
map('n', '<leader>E', ':Neotree dir=$PWD<cr>', silent)

-- Re-select visual block after indenting
map('v', '<', '<gv', silent)
map('v', '>', '>gv', silent)

-- Folding
map('', '<leader>z', 'zMzvzz', silent)

-- Quickfix navigation
map('n', '[g', '<Cmd>colder<cr>', silent)
map('n', ']g', '<Cmd>cnewer<cr>', silent)

-- Open the selected file from a quickfix window in a new tab
cmd([[
  autocmd FileType qf nnoremap <buffer> <C-t> <C-w><Enter><C-w>T
]])

-- Run git-blame and open the results in a vertical split
map('n', '<leader>gb', ':Git blame<cr>', silent)

-- Open a gv browser and list commits that affected the current file
map('n', '<leader>gv', ':GV!<cr>', silent)

-- Pretify JSON
map('n', '<leader>jq', ':set ft=json<cr>:%!jq "."<cr>', silent)

-- Running tests
map('n', '<leader>T', ':TestLast<cr>', silent)
map('n', '<leader>tn', ':TestNearest<cr>', silent)
map('n', '<leader>tf', ':TestFile<cr>', silent)
map('n', '<leader>ta', ':TestSuite<cr>', silent)
map('n', '<leader>tl', ':TestLast<cr>', silent)
map('n', '<leader>tg', ':TestVisit<cr>', silent)

-- Force write as superuser
map('c', 'w!!', 'execute "write !sudo tee % >/dev/null" <bar> edit!', silent)

-- Stop the highlighting
map('', '<F2>', ':noh<cr>', silent)

-- Toogle relative line numbers
map('', '<F3>', ':set relativenumber!<cr>', silent)
------------------------------------------------------------------------------------------------------------------------

-- Netrw ---------------------------------------------------------------------------------------------------------------
--
-- Tree style listing
g['netrw_liststyle'] = 3
-- Window size in percentage
g['netrw_winsize'] = 30
-- Suppress the banner
g['netrw_banner'] = 0
------------------------------------------------------------------------------------------------------------------------

-- Plugins -------------------------------------------------------------------------------------------------------------
require('Comment').setup()
require('nvim-surround').setup()
require('nvim-autopairs').setup()

require('nvim-web-devicons').setup()
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'filename'},
    lualine_c = {'diff', 'diagnostics', 'searchcount'},
    lualine_x = {'branch', 'encoding', 'filetype', '%03.3b'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}

cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
require('neo-tree').setup {
  close_if_last_window = true,
  enable_diagnostics = false,
  enable_git_status = false,
}

-- require('indent_blankline').setup {
--   char = '┊',
--   show_trailing_blankline_indent = false,
-- }
require('ibl').setup()

require('neoscroll').setup {
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = false, -- The cursor won't keep on scrolling even if the window cannot scroll further
}

require('trim').setup {
  ft_blocklist = {'markdown'},
  patterns = {
    [[%s/\(\n\n\)\n\+/\1/]], -- replace multiple blank lines with a single line
  },
  trim_on_write = false
}

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}
-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
-- See `:help telescope.builtin`
keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = 'all',

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      -- init_selection = '<c-space>',
      -- node_incremental = '<c-space>',
      -- scope_incremental = '<c-s>',
      -- node_decremental = '<m-space>',
      init_selection = '<cr>',
      node_incremental = '<cr>',
      node_decremental = '<bs>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },

  -- Integration with nvim-treesitter-endwise
  endwise = { enable = true }
}

-- LSP
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Setup mason so it can manage external tooling
require('mason').setup()

require("mason-lspconfig").setup {
  automatic_enable = {
    "lua_ls",
    "solargraph",
    "ts_ls",
    "html",
    "cssls",
    "graphql",
    "sqlls",
    "marksman",
    "eslint"
  },
  ensure_installed = { "lua_ls" }
}

local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'cmdline' },
  },
}

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Integration with nvim-autopairs
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

require('gitsigns').setup({
  signs = {
  add = { text = '+' },
  change = { text = '~' },
  delete = { text = '_' },
  topdelete = { text = '‾' },
  changedelete = { text = '~' },
  }
})
-- require('neotest').setup({
--   adapters = {
--     require('neotest-rspec')
--   }
-- })
require('treesj').setup()
require('nvim-ts-autotag').setup()
require('pretty-fold').setup({
  sections = {
    left = {
       '+ ', 'content',
    },
    right = {
       ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
       function(config) return config.fill_char:rep(3) end
    }
  }
})
------------------------------------------------------------------------------------------------------------------------
