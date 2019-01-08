-- Stimulates Keybow "hardware key" presses and releases at the Keybow handler
-- level, thus involving everything starting with the Keybow "firmware" key
-- Lua handlers handle_key_xx.

--[[
Copyright 2019 Harald Albrecht

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local hwk = {} -- module

-- Convenience: returns the name of a Keybow key handler function for the
-- given key number.
function hwk.handler_name(keyno)
    return string.format("handle_key_%02d", keyno)
end

-- Convenience: call Keybow key handler for key presses and releases by key
-- number instead of name.
function hwk.press(keyno)
    _G[hwk.handler_name(keyno)](true)
end

function hwk.release(keyno)
    _G[hwk.handler_name(keyno)](false)
end

-- Convenience: taps a Keybow key, triggering the corresponding key handler
-- twice.
function hwk.tap(keyno)
    hwk.press(keyno)
    hwk.release(keyno)
end

return hwk -- module
