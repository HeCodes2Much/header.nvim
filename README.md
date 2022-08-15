# header.nvim

The header plugin written in Lua aims to quickly generate readable headers for several programming languages.

Additionally, it also automatically updates the last edited time.

## Installation

Just install using your package manager of choice:

```
use 'The-Repo-Club/header.nvim'
```

## Setup

```
local header = require('header')

header.setup({
	user = 'Example',
	mail = 'example@email.com',
	-- You can also extend filetypes, e.g:
	ft = {
		lua = {
			start_comment = "--",
			end_comment = "--",
			fill_comment = "-",
		}
	}
})
```

## Supported Filetypes by Default

* `c` for C files
* `cpp` for C++ and header files
* `python` for python files
* `lua` for lua files
* `make` for Makefiles
* `vim` for vimscript files

## Mappings

header.nvim does not provide default mappings, but you can map a to the command `<cmd>StrHeader`.

Although this plugins does not provide mappings, it sets up `autocmd` to update the header.