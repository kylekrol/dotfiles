
--------------------------------------------------------------------------------
-- Load plugins
--------------------------------------------------------------------------------

-- Bootstrap packer if not already installed
local ensure_packer = function()
    local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]

        return true
    end

    return false
end

local packer_bootstrap = ensure_packer()

-- Declare plugins
require('packer').startup(function(use)
    -- Packer manages itself
    use { 'wbthomason/packer.nvim' }

    -- Color schemes
    use { "ellisonleao/gruvbox.nvim" }

    -- File tree
    use {
        'nvim-tree/nvim-tree.lua',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            {
                'nvim-treesitter/nvim-treesitter',
                run = (function()
                    if packer_bootstrap then
                        return function()
                            (require('nvim-treesitter.install').update({ with_sync = true }))()
                        end
                    else
                        return ':TSUpdate'
                    end
			    end)()
            }
        }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope-project.nvim' }

    -- Language servers, linting, and autocompletion
    use {
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/nvim-cmp'
    }

    -- Markdown Preview
    use {
        'iamcco/markdown-preview.nvim',
        run = function() vim.fn["mkdp#util#install"]() end
    }

    -- Snippets
    use { 'dcampos/nvim-snippy', 'dcampos/cmp-snippy' }

    -- Status bar
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)

--------------------------------------------------------------------------------
-- General Settings
--------------------------------------------------------------------------------

vim.g.mapleader = ' '

vim.opt.breakindent = true
vim.opt.colorcolumn = { 81, 101, 121 }
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.smartcase = true
vim.opt.tabstop = 4

--------------------------------------------------------------------------------
-- Plugin Configuration
--------------------------------------------------------------------------------

vim.o.background = "dark"
vim.cmd [[ colorscheme gruvbox ]]

require('lualine').setup {
    options = { icons_enabled = true,
                theme  = 'gruvbox' }
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup()

vim.keymap.set('n', '<leader>tc', ':NvimTreeClose<CR>', { desc = '[T]ree [C]lose' })
vim.keymap.set('n', '<leader>tf', ':NvimTreeFocus<CR>', { desc = '[T]ree [F]ocus' })
vim.keymap.set('n', '<leader>tk', ':NvimTreeCollapseKeepBuffers<CR>', { desc = '[T]ree Collapse and [K]eep Buffers' })
vim.keymap.set('n', '<leader>to', ':NvimTreeOpen<CR>', { desc = '[T]ree [O]pen' })
vim.keymap.set('n', '<leader>tr', ':NvimTreeRefresh<CR>', { desc = '[T]ree [R]efresh' })
vim.keymap.set('n', '<leader>ts', ':NvimTreeFindFile<CR>', { desc = '[T]ree [S]how File' })
vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { desc = '[T]ree [T]oggle' })

require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case'
        }
    }
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('project')

vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { desc = '[F]ind [B]uffers' })
vim.keymap.set('n', '<leader>fc', ':Telescope commands<CR>', { desc = '[F]ind [C]ommands' })
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = '[F]ind [G]rep' })
vim.keymap.set('n', '<leader>fp', ':Telescope projects<CR>', { desc = '[F]ind [P]rojects' })

local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args)
            require('snippy').expand_snippet(args.body)
        end
    },
    mapping = (function()
        local visible = function(action)
            return cmp.mapping(function(fallback)
                if cmp.visible() then
                    action()
                else
                    fallback()
                end
            end)
        end

        return {
            ['<C-Space>'] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.abort()
                else
                    cmp.complete()
                end
            end),
            ['<CR>'] = visible(function() cmp.confirm({ select = true }) end),
            ['<Tab>'] = visible(cmp.select_next_item),
            ['<S-Tab>'] = visible(cmp.select_prev_item),
        }
    end)(),
    sources = cmp.config.sources {
        { name = 'buffer' },
        { name = 'nvim_lsp' },
        { name = 'snippy'   },
    }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')['clangd'].setup { capabilities = capabilities }
require('lspconfig')['pyright'].setup { capabilities = capabilities }
require('lspconfig')['sumneko_lua'].setup {
    settings = {
        Lua = {
            capabilities = capabilities,
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false }
        }
    }
}

vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>', { desc = '[M]arkdown [P]review' })
vim.keymap.set('n', '<leader>ms', ':MarkdownPreviewStop<CR>', { desc = '[M]arkdown Preview [S]top' })
vim.keymap.set('n', '<leader>mt', ':MarkdownPreviewToggle<CR>', { desc = '[M]arkdown Preview [T]oggle' })

