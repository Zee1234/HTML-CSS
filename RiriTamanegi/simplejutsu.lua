local prefix = 'znbja_' -- global prefix for classes and IDs
local arg = {'jutsu/Passive/Clan.yaml'}

local function array(tab)
  return tab and setmetatable(tab,{__index = table}) or setmetatable({},{__index = table})
end
-- Add some functions to table to be used as a special metatable
function table:map(func)
  local arr = array{}
  for i=1, #self do
    local ret = func(self[i])
    arr:insert(ret)
  end
  return arr
end
function table:insertArray(arr)
  for i=1, #arr do
    self:insert(arr[i])
  end
  return self
end



--- Create the HAML renderer
local haml = require 'haml'
local hamlOptions = {format = 'html5'}
local engine = haml.new(hamlOptions)
local function renderHAML(file,vars)
  engine:render_file(file,vars)
end

--- Some of the 'renderers' don't support file arguments, and I needed to read Some
-- basic text files into strings anyways, so why not?
local function readFull(file)
  local err
  local handle,string
  handle,err = io.open(file)
  assert(handle,err)
  string,err = handle:read('*a')
  assert(string,err)
  handle:close()
  return string
end

--- YAML renderer
local yaml = require 'yaml'
local function loadYAML(file)
  local tab,err = yaml.load(readFull(file))
  assert(tab,err)
  return array(tab)
end

-- Applies the global prefix to classes and IDs
local function prefixer(string)
  return prefix..string
end
string.prefix = prefixer -- allow the :prefix chainable

-- Allows the automatic creation of unique IDs for elements of similar natures
local iterateID
do
  local tracker = {}
  iterateID = function(class)
    tracker[class] = tracker[class] and tracker[class]+1 or 0
    return ('%s%i'):format(class,tracker[class]):prefix()
  end
end




--- The actual full rendering logic
-- @document will be table.concat'd at the end of this all.
local document = array{}

for i=1, #arg do
  document:insertArray(
    loadYAML(arg[i]):map(function(options)
      options.ID = iterateID('jutsu')
      return renderHAML('haml/jutsu.haml',options)
    end)
  )
end

local output = document:concat('\n')
local handle = io.open('jutsuoutput.html','w')
handle:write(output)
handle:close()
