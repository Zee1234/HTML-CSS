local prefix = 'znbja_' -- global prefix for classes and IDs
local arg = {'jutsu/Passive/Clan.yaml'}

--- Create the HAML renderer
local haml = require 'haml'
local hamlOptions = {format = 'html5'}


--- YAML renderer
local yaml = require 'yaml'

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
local document = {}

for _,v in ipairs(arg) do
  local tab = yaml.load(readFull(v))
  for _,v in ipairs(tab) do
    table.insert(
      document,
      select(1,haml.new(hamlOptions):render_file('haml/jutsu.haml',v))
    )
  end
end

local output = document:concat('\n')
local handle = io.open('outputs/simplejutsu.output.html','w')
handle:write(output)
handle:close()
