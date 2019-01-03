-- VSC Go extension debug Keybow layout

require "snippets/multibow"

--[[
The Keybow layout is as follows when in landscape orientation, with the USB
cable going off "northwards":

            ┋┋
┌────┐ ┌────┐ ┌────┐ ┌────┐
│ 11 │ │  8 │ │  5 │ │  2 │
└────┘ └────┘ └────┘ └────┘
┌────┐ ┌────┐ ┌────┐ ┌────┐
│ 10 │ │  7 │ │  4 │ │  1 │
└────┘ └────┘ └────┘ └────┘
┌────┐ ┌────┐ ┌────┐ ┌────┐
│  9 │ │  6 │ │  3 │ │  0 │
└────┘ └────┘ └────┘ └────┘

]]--

RED = { r=1, g=0, b=0 }
YELLOW =  { r=1, g=0.8, b=0 }
GREEN = { r=0, g=1, b=0 }
BLUE = { r=0, g=0, b=1 }
BLUECYAN = { r=0, g=0.7, b=1 }
BLUEGRAY = { r=0.7, g=0.7, b=1 }
CYAN = { r=0, g=1, b=1 }


-- AND NOW FOR SOMETHING DIFFERENT: THE REAL MEAT --

function debug_stop(key)
  mb.tap(key, keybow.F5, keybow.LEFT_SHIFT)
end

function debug_restart(key)
  mb.tap(key, keybow.F5, keybow.LEFT_SHIFT, keybow.LEFT_CTRL)
end

function debug_continue(key)
  mb.tap(key, keybow.F5)
end

function debug_stepover(key)
  mb.tap(key, keybow.F10)
end

function debug_stepinto(key)
  mb.tap(key, keybow.F11)
end

function debug_stepout(key)
  mb.tap(key, keybow.F11, keybow.LEFT_SHIFT)
end

function go_test_package(key)
  mb.tap(key, "P", keybow.LEFT_SHIFT, keybow.LEFT_CTRL)
  keybow.sleep(250)
  keybow.text("go test package")
  keybow.tap_enter()
end


mb.register_keymap({
  [10] = {c=RED, h=debug_stop},
  [7] = {c=YELLOW, h=debug_restart},
  [1] = {c=CYAN, h=go_test_package},

  [9] = {c=GREEN, h=debug_continue},
  [6] = {c=BLUECYAN, h=debug_stepinto},
  [3] = {c=BLUE, h=debug_stepover},
  [0] = {c=BLUEGRAY, h=debug_stepout},
}, 'vsc-golang-debug')
