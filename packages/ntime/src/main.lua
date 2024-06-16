-- ntime.lua

local ntime = {}

-- A table to map time units to their corresponding values in seconds
local time_units_in_seconds = {
    sec = 1,
    secs = 1,
    second = 1,
    seconds = 1,
    min = 60,
    mins = 60,
    minute = 60,
    minutes = 60,
    hr = 3600,
    hrs = 3600,
    hour = 3600,
    hours = 3600,
    day = 86400,
    days = 86400,
    week = 604800,
    weeks = 604800
}

-- Function to convert time format to seconds
function ntime.toseconds(time_format)
    local n, unit = time_format:match("(%d+)%-(%a+)")
    
    if not n or not unit then
        error("Invalid time format. Expected format is {n}-{interval unit(s)}")
    end
    
    n = tonumber(n)
    unit = unit:lower()
    
    local seconds = time_units_in_seconds[unit]
    
    if not seconds then
        error("Invalid time unit provided.")
    end
    
    return n * seconds
end

return ntime
