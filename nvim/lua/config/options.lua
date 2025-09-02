local o = vim.opt

o.termguicolors = true
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8
o.splitright = true
o.splitbelow = true
o.ignorecase = true
o.smartcase = true
o.updatetime = 200
o.timeoutlen = 400
o.clipboard = "unnamedplus"
o.undofile = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Mouse: enable full support like typical IDEs
o.mouse = "a"          -- allow mouse in all modes
o.mousemodel = "extend" -- right-click extends selection
o.mousefocus = true     -- focus windows on mouse move
o.mousescroll = "ver:3,hor:6" -- smooth scrolling amounts
o.keymodel = "startsel,stopsel" -- Shift+Click starts/stops selection
o.selectmode = "mouse,key"     -- mouse and keyboard select mode


