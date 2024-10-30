# template.lua

A template engine (ref: https://github.com/dannote/lua-template )

## Usage

```lua
apm.install('template')
local _ = require('template')

local html = _.compile([[
<!doctype html>
<html>
  <head>
    <title><% title %></title>
  </head>
  <body>
    <%= content %>
  </body>
</html>
]], true)

print(_.render(html, { title = "Hello", content = [[<h1>Hello World</h1>]] }))
```

## Template Syntax

In short, Lua expressions must be included between percent signs and Lua statements must be placed beetween question marks.

### Variables and expressions

```html
<a href="page-<%page + 2%>"><%next%></a>
```

### Variables and expressions without HTML escaping

```html
<body><%= content%></body>
```

### Loops

```html
<ul>
<? for i = 1, 3 do ?>
  <li>item #<%i%></li>
<? end ?> 
</ul>
```

### Conditional

```html
<? if 1 > 2 then ?>
Impossible!
<? else ?>
That's right!
<? end ?>
```

### Template inclusion
Templates are compiled to a general Lua file and hence can be loaded by `require` statement:

```html
<html>
  <script><%= require "scripts" %></script>
  <style><%= require "styles" %></style>
</html>
```

## Methods

### template.compile(templateString : string, minify: boolean) : function

Takes a string and returns a template function.

### template.render(template : function, data: table) : string

Takes a template and a data table and returns a rendered result as a string.






