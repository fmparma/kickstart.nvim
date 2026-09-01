--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- ============================================================
-- SECTION 1: OPTIONS
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
require 'options'

-- ============================================================
-- SECTION 2: KEYMAPS
-- basic keymaps
-- ============================================================
require 'keymaps'

require 'qf'

-- ============================================================
-- SECTION 3: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
  -- [[ Intro to `vim.pack` ]]
  -- `vim.pack` is a new plugin manager built into Neovim,
  --  which provides a Lua interface for installing and managing plugins.
  --
  --  See `:help vim.pack`, `:help vim.pack-examples` or the
  --  excellent blog post from the creator of vim.pack and mini.nvim:
  --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
  --
  --  To inspect plugin state and pending updates, run
  --    :lua vim.pack.update(nil, { offline = true })
  --
  --  To update plugins, run
  --    :lua vim.pack.update()
  --
  --
  --  Throughout the rest of the config there will be examples
  --  of how to install and configure plugins using `vim.pack`.
  --
  --  In this section we set up some autocommands to run build
  --  steps for certain plugins after they are installed or updated.

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
          run_build(name, { 'make', 'install_jsregexp' },
            ev.data.path)
        end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 4: COLORSHEME (immediate, before first screen)
-- ============================================================
-- Colorscheme must load synchronously to avoid a flash of unstyled text.
require 'kickstart.plugins.colorscheme'

-- Placeholder statusline until lualine loads (deferred below).
-- Avoids an empty/ugly statusline during the brief window before lualine setup.
vim.g.lualine_laststatus = vim.o.laststatus
if vim.fn.argc(-1) > 0 then
  vim.o.statusline = ' '
else
  vim.o.laststatus = 0
end

-- ============================================================
-- SECTION 5: LAZY-LOADED PLUGINS (after first screen update)
-- ============================================================
-- All non-critical plugins are loaded via `vim.schedule` after `VimEnter`.
-- This defers their loading to AFTER "NVIM STARTED", so they do NOT count
-- toward startup time (as measured by `--startuptime`).
--
-- Plugins are loaded one at a time, yielding to the event loop between each
-- load (`vim.schedule(load_next)`) to keep Neovim responsive (input/redraw
-- are processed between loads).
--
-- Load order is by priority: core editing first, then UI, then extras.
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    ---@type string[] Plugin modules in priority order.
    local plugins = {
      -- Core editing (load first: highlighting, LSP, keymaps)
      -- 'kickstart.plugins.treesitter',
      -- 'kickstart.plugins.lspconfig',
      'kickstart.plugins.telescope',
      -- 'kickstart.plugins.gitsigns',
      'kickstart.plugins.which-key',
      -- UI / editor experience
      'kickstart.plugins.autopairs',
      'kickstart.plugins.lint',
      -- 'kickstart.plugins.indent_line',
      'kickstart.plugins.nvimtree',
      -- 'kickstart.plugins.bufferline',
      -- 'kickstart.plugins.lualine',
      -- Custom plugins (auto-session, barbecue, cursor, symboloutline, virtcolumn)
      'custom.plugins',
    }
    local i = 0
    local function load_next()
      i = i + 1
      if not plugins[i] then return end
      local ok, err = pcall(require, plugins[i])
      if not ok then
        vim.notify(('Failed to load %s: %s'):format(plugins[i], tostring(err)), vim.log.levels.ERROR)
      end
      -- Yield to event loop so Neovim can process input/redraw between loads.
      vim.schedule(load_next)
    end
    vim.schedule(load_next)
  end,
})

-- vim.api.nvim_create_autocmd('BufEnter', {
vim.api.nvim_create_autocmd('BufReadPre', {
  once = true,
  callback = function()
    ---@type string[] Plugin modules in priority order.
    local plugins = {
      -- Core editing (load first: highlighting, LSP, keymaps)
      'kickstart.plugins.treesitter',
      'kickstart.plugins.lspconfig',
      -- UI / editor experience
      'kickstart.plugins.autopairs',
      -- 'kickstart.plugins.lint',
      'kickstart.plugins.nvimtree',
      'kickstart.plugins.bufferline',
      'kickstart.plugins.lualine',
      'kickstart.plugins.flash',
      -- Custom plugins (auto-session, barbecue, cursor, symboloutline, virtcolumn)
      -- 'custom.plugins',
    }
    local i = 0
    local function load_next()
      i = i + 1
      if not plugins[i] then return end
      local ok, err = pcall(require, plugins[i])
      if not ok then
        vim.notify(('Failed to load %s: %s'):format(plugins[i], tostring(err)), vim.log.levels.ERROR)
      end
      -- Yield to event loop so Neovim can process input/redraw between loads.
      vim.schedule(load_next)
    end
    vim.schedule(load_next)
  end,
})

-- ============================================================
-- SECTION 6: AUTOCOMPLETE & SNIPPETS (lazy, on first InsertEnter)
-- ============================================================
-- blink.cmp + LuaSnip are only needed when entering insert mode.
-- Loading them on `InsertEnter` saves ~1s of startup time for normal-mode
-- browsing (reading files, git diffs, etc.).
vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    require 'kickstart.plugins.cmp'
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
