# minitrack.nvim

A fast and minimalist time tracking plugin for Neovim.

Don't waste time tracking your time. 

I hate time tracking tools so much I made one. It is meant to be used as a quick scratchpad to store each time I switch from one topic (project, ticket, ...) from another during my workday. The report part provide the total time spent on each topic. So at the end of the day, you can seize them on any corporate tracking software you use.  

![Minitrack preview](minitrack.gif)

## Installation
### Package managers

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'davlord/minitrack.nvim',
}
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'davlord/minitrack.nvim
}
```
### Setup
```lua
require('minitrack').setup()
```

## Usage

### Startup
From within Neovim startup with `:Minitrack` command.

Or just start Neovim directly with Minitrack `nvim -c ":Minitrack"`.
