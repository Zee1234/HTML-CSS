local files = {
  'outputs/page.output.html';
  'outputs/page.output.min.html';
  'outputs/simplejutsu.output.html';
}

local handles = {}

for i,v in ipairs(files) do
  handles[i] = io.open(v,'w')
end

for _,v in ipairs(handles) do
  v:write('')
  v:close()
end
