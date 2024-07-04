--[[
ReaderT or Reader Transform

ReaderTransforms allow you to inject environment information at the time
of running your logic vs the time of defining your logic, the result, creates
a flexible way to manage business logic via multiple configuration environments.

]]
local _ReaderT = function (Monad)
  local function ReaderT(fn)
    local x = { _version = "0.0.1" }
 
    function x:runWith(env)
      return fn(env)
    end

    function x:map(fn)
      return ReaderT(function (e)
        return self:runWith(e):map(fn)
      end)
    end

    function x:chain(fn)
      return ReaderT(function (e)
        self:runWith(e):chain(function (inner)
          return fn(inner):runWith(e)
        end)
      end)
    end

    x.of = function (v)
      return ReaderT(function()
        return Monad.of(v)
      end)

    end
    return x
  end
  local reader = {}

  reader.of = function (v)
    return ReaderT(function ()
      return Monad.of(v)
    end)
  end

  function reader:ask(fn)
    return ReaderT(Monad.of):map(fn)
  end

  function reader:lift(m)
    return ReaderT(function () return m end)
  end

  return reader
end

return _ReaderT