local haml = require "haml"
local hamlOptions = {format = "html5"}
local engine = haml.new(hamlOptions)
local function renderFile(file,vars)
  engine:render_file(file,vars)
end

local function sass(file,args)
  local handle = io.popen("sass "..args.." "..file)
  local result = handle:read("*a")
  handle:close()
  return result
end

local yaml = require "yaml"
