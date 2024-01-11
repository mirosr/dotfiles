local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) == 0 then
    return false
  end

  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]

  return true
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- General
  use 'numToStr/Comment.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {'nvim-treesitter/nvim-treesitter-textobjects'},
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end
  }
  use {'kylechui/nvim-surround',
      tag = "*", -- Use for stability; omit to use `main` branch for the latest features
  }
  use 'windwp/nvim-autopairs'
  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/plenary.nvim'}
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }

  -- Appearance
  use 'navarasu/onedark.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'nvim-tree/nvim-web-devicons'}
  }
  use 'lukas-reineke/indent-blankline.nvim'
  use 'karb94/neoscroll.nvim'
  use {
    'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      requires = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons'
    }
  }
  use 'cappyzawa/trim.nvim'

  -- Development
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
      'folke/neodev.nvim'
    }
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline'
   }
  }
  use 'lewis6991/gitsigns.nvim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'junegunn/gv.vim'
  use 'rhysd/git-messenger.vim'
  use 'janko-m/vim-test'
  use {
    'nvim-neotest/neotest',
    requires = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'olimorris/neotest-rspec'
    }
  }
  use 'Wansmer/treesj'
  use 'anuvyklack/pretty-fold.nvim'
  -- Dext
  use 'github/copilot.vim'

  -- Language Specific
  use 'RRethy/nvim-treesitter-endwise'
  use 'windwp/nvim-ts-autotag'
  use {
    'cuducos/yaml.nvim',
    ft = {'yaml'}
  }
  use 'tpope/vim-rails'
  use 'slim-template/vim-slim'
  use 'kchmck/vim-coffee-script'

  -- Automatically set the configuration after cloning packer.nvim
  -- Keep at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
