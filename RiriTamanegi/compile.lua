local prefix = 'znbcp_' -- global prefix for classes and IDs




--- Create the HAML renderer
local haml = require 'haml'
local hamlOptions = {format = 'html5'}


--- Really god damn dirty way to get SCSS compiled
-- I know, this is *really* bad
-- But I spent hours trying to get a good solution that didn't involve a submodule
-- I'm obviously not experienced enough to manage it atm
local function sass(file,args)
  local handle = io.popen('sass '..args..' '..file)
  local result = handle:read('*a')
  handle:close()
  return result
end

--- YAML renderer
local yaml = require 'yaml'
local loadYAML = yaml.load

--- Some of the 'renderers' don't support file arguments, and I needed to read Some
-- basic text files into strings anyways, so why not?
local function readFull(file)
  local err
  local file,string
  file,err = io.open(file)
  assert(file,err)
  string,err = file:read('*a')
  assert(string,err)
  file:close()
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
local document = setmetatable({},{__index = table}) -- allow :insert and :concat

local options = loadYAML(readFull('info.yaml'))

options.generals.appearance = readFull('characterinfo/appearance')
options.generals.history = readFull('characterinfo/history')
options.generals.personality = readFull('characterinfo/personality')


document:insert(
  select(
    1,
    haml.new(hamlOptions):render_file(
      'haml/main.haml',
      options
    )
  )
)

local handle = io.open('outputs/page.output.html','w')
handle:write(document:concat())
handle:close()
