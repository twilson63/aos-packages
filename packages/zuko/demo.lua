local zuko = require('src.main')


local rules = {
    username = { type = "string", required = true },
    age = { type = "number", min = 0, max = 120, required = true },
    contact = {
      type = "table",
      required = true,
      schema = {
        phone = { type = "string", pattern = "^%d%d%d%-%d%d%d%-%d%d%d%d$" },
        address = {
          type = "table",
          schema = {
            street = { type = "string", required = true },
            city = { type = "string", required = true },
            zip = { type = "string", pattern = "^%d%d%d%d%d$" }
          }
        }
      }
    },
    colors = {
        type = "table",
        required = true,
        array = { type = "string" }
    }
  }
  
  local validate = zuko(rules)
  
  local input = {
    username = "johndoe",
    contact = {
      phone = "123-456-7890",
      address = {
        street = "123 Lua Street",
        city = "Moonville"
      }
    },
    colors = {'red'}
  }
  
  local valid, errors = validate(input)
  
  
  if not valid then
    for field, err in pairs(errors) do
      print(field .. ' - ' .. err)
    end
  else
    print("Validation succeeded!")
  end