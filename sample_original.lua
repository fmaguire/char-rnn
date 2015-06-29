
--[[

Randomly sample lines from text

]]--

require 'torch'
require 'table'
require 'math'

cmd = torch.CmdLine()
cmd:text()
cmd:text('Sample from original text')
cmd:text()
cmd:text('Options')
-- required:
cmd:argument('-text','text to use for sampling')
-- optional parameters
cmd:option('-seed',0,'random number generator\'s seed')
cmd:option('-reservoir',20,'reservoir size')
cmd:text()

-- parse input params
opt = cmd:parse(arg)

-- gated print: simple utility function wrapping a print
function gprint(str)
    if opt.verbose == 1 then print(str) end
end

if opt.seed == 0 then
    math.randomseed(os.time())
else
    math.randomseed(opt.seed)
end

fh, err = io.open(opt.text)

index = 0
res = {}

-- reservoir sampling
for line in fh:lines() do
    if index < opt.reservoir then
        table.insert(res, line)
    else
        r = math.random(0, index+1)
        if r < opt.reservoir then
            res[r] = line
        end
    end
    index = index + 1
end
fh:close()

for index, line in pairs(res) do
    io.write(line)
end
io.write('\n') 
io.flush()


