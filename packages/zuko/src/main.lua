-- zuko.lua (enhanced nested validation and array support)

local function validate_field(value, rule, validator_fn)
    if rule.required and value == nil then
      return "is required"
    elseif value ~= nil then
      if rule.type and type(value) ~= rule.type then
        return "must be of type " .. rule.type
      end
  
      if rule.type == "number" then
        if rule.min and value < rule.min then
          return "must be greater than or equal to " .. rule.min
        elseif rule.max and value > rule.max then
          return "must be less than or equal to " .. rule.max
        end
      end
  
      if rule.type == "string" and rule.pattern then
        if not string.match(value, rule.pattern) then
          return "does not match required pattern"
        end
      end
  
      if rule.type == "table" then
        if rule.schema then
          local nested_validator = validator_fn(rule.schema)
          local valid, nested_errors = nested_validator(value)
          if not valid then
            return nested_errors
          end
        elseif rule.array then
          if type(value) ~= "table" then
            return "must be an array"
          end
          for index, item in ipairs(value) do
            local item_error = validate_field(item, rule.array, validator_fn)
            if item_error then
              return {[index] = item_error}
            end
          end
        end
      end
    end
    return nil
  end
  
  local function zuko(rules)
    local function validator(input)
      local errors = {}
  
      for field, rule in pairs(rules) do
        local err = validate_field(input[field], rule, zuko)
        if err then
          errors[field] = err
        end
      end
  
      return next(errors) == nil, errors
    end
  
    return validator
  end
  
  return zuko
  