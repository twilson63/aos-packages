# markdown.lua

This is a package for apm created to provide support for markdown in ao. This source file is from https://github.com/mpeterv/markdown/tree/master and is currently unmodified.

## Usage

```lua
apm.install('@apm/markdown')
local md = require("markdown")

local html = md [[
# My First Post

Hello World


]]
print(html)
```
