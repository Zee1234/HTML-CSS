local prefix = 'znbcp_' -- global prefix for classes and IDs
local fs = require 'fs'




--- Create the HAML renderer
local haml = require 'haml'
local hamlOptions = {format = 'html5'}
local function render_file(file,options)
  haml.new(hamlOptions):render_file(file,options)
end


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
local function readFull(path)
  local err
  local file,string
  file,err = io.open(path)
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
local options = loadYAML(readFull('info.yaml'))

local laters = {}
laters.appearance = readFull('characterinfo/appearance')
options.generals.appearance = '{$appearance}'
laters.history = readFull('characterinfo/history')
options.generals.history = '{$history}'
laters.personality = readFull('characterinfo/personality')
options.generals.personality = '{$personality}'

local cssFile = io.open('outputs/generic.output.css','w')
cssFile:write(
  ('%s%s%s'):format(
    "<style>",
    sass('source.scss','-t compressed --scss'),
    "</style>"
  )
)
cssFile:close()

local htmlFile = io.open('outputs/page.output.html','w')
htmlFile:write(select(1, render_file('haml/main.haml', options)))
htmlFile:close()
local minifier = io.popen('html-minifier --collapse-boolean-attributes --collapse-whitespace --decode-entities --html5 --minify-css --minify-js --remove-attribute-quotes --remove-empty-attributes outputs/page.output.html')
local minified = minifier:read('*a')
minifier:close()
local minFile = io.open('outputs/page.output.min.html','w')
minFile:write(
  minified
    :gsub(options.generals.appearance,laters.appearance)
    :gsub(options.generals.history,laters.history)
    :gsub(options.generals.personality,laters.personality)
)
minFile:close()


local jutsus = {files={};folders={}}
local iter = fs.scandirsync('jutsu')
for name,type in iter() do
  if type == 'file' then
    jutsus.files[#jutsu.files+1] = name
  elseif type == 'directory' then
    jutsu.folders[#jutsu.folders+1] = name
  end
end
local function renderSpoiler(options)
  render_file('haml/spoiler.haml',options)
end
local function renderJutsu(options)
  render_file('haml/jutsu.haml',options)
end

local genericJutsu = {}
for _,file in ipairs(jutsu.files) do
  local container = yaml.load('jutsu/'..file)
  local arr = {}
  for _,v in ipairs(container) do
    v.ID = v.url
    table.insert(arr,renderJutsu(v))
  end
  table.insert(genericJutsu,table.concat(arr,"\n"))
end
