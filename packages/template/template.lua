local template = {}

local function setfenv(fn, env)
    local i = 1
    while true do
        local name = debug.getupvalue(fn, i)
        if name == "_ENV" then
            debug.upvaluejoin(fn, i, (function() return env end), 1)
            break
        elseif not name then
            break
        end
        i = i + 1
    end
    return fn
end

function template.escape(data)
  return tostring(data or ''):gsub("[\">/<'&]", {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;"
  })
end

function template.print(data, args, callback)
  local callback = callback or print
  local function exec(data)
    if type(data) == "function" then
      local args = args or {}
      setmetatable(args, { __index = _G })
      setfenv(data, args)
      data(exec)
    else
      callback(tostring(data or ''))
    end
  end
  exec(data)
end

function template.parse(data, minify)
  local str =
    "return function(_)" ..
      "function __(...)" ..
        "_(require('template').escape(...))" ..
      "end " ..
      "_[=[" ..
      data:
        gsub("[][]=[][]", ']=]_"%1"_[=['):
        gsub("<%%=", "]=]_("):
        gsub("<%%", "]=]__("):
        gsub("%%>", ")_[=["):
        gsub("<%?", "]=] "):
        gsub("%?>", " _[=[") ..
      "]=] " ..
    "end"
  if minify then
    str = str:
      gsub("^[ %s]*", ""):
      gsub("[ %s]*$", ""):
      gsub("%s+", " ")
  end
  return str
end

function template.compile(...)
  return load(template.parse(...))()
end

function template.render(tpl, data)
  local output = ""
  template.print(tpl, data, function (d) output = output .. d end)
  return output
end

return template

