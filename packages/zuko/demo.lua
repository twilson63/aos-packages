local zuko = require('src.main')


local rules = {
    username = { type = "string", required = true },
    age = { type = "number", min = 0, max = 120, required = true },
    foo = { type = "table", ["*"] = "string" },
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
    colors = {'red'},
    foo = { x = 1 }
  }
  
  local valid, errors = validate(input)
  
  print('zuko rules')
  print(rules)

  print('input')

  print(input)
  
  print('validation errors')
  if not valid then
    print(errors)
  else
    print("Validation succeeded!")
  end