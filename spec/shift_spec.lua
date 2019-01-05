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

require "mocked-keybow"
require "snippets/multibow"
local kbh = require("spec/keybowhandler")
local mb = require("snippets/multibow")

describe("SHIFT multibow keymap", function()

    insl(function()

        it("installs the SHIFT keymap", function()
            -- Sanity check that there are no registered keymaps yet.
            assert.is.equal(#mb.registered_keymaps(), 0)

            local shift = require("layouts/shift")
            assert.is_not_nil(shift) -- we're going slightly over the top here...
            assert.is_not_nil(shift.keymap)

            -- SHIFT must register exactly two keymaps, a primary and a secondary one.
            local kms = mb.registered_keymaps()
            assert.is.equal(#kms, 2)
            for idx, keymap in ipairs(kms) do
                if keymap == "shift" then
                    assert.is_falsy(keymap.permanent)
                    assert.is_falsy(keymap.secondary)
                elseif keymap == "shift-shifted" then
                    assert.is_falsy(keymap.permanent)
                    assert.is_true(keymap.secondary)
                end
            end

            default_key_shift = shift.KEY_SHIFT
        end)

    end)

    insl(function()

        it("accepts changes form default", function()
            local override = 42

            _G.shift = { KEY_SHIFT=override }
            local shift = require("layouts/shift")
            assert.is.equal(shift.KEY_SHIFT, override)
        end)

    end)

    describe("SHIFTY", function()

        -- ensure to get a fresh SHIFT layout instance each time we run
        -- an isolated, erm, insulated test.
        local shift

        before_each(function()
            shift = require("layouts/shift")
        end)

        insl(function()
            it("SHIFT grabs", function()
                spy.on(mb, "grab")
                spy.on(mb, "ungrab")

                -- route in the SHIFT permanent keymap
                kbh.handle_key(shift.KEY_SHIFT, true)
                assert.spy(mb.grab).was.called(1)
                assert.spy(mb.grab).was.called_with(shift.keymap_shifted.name)

                -- route in the shifted(!) SHIFT keymap, so this checks
                -- that we ungrab correctly
                mb.grab:clear()
                kbh.handle_key(shift.KEY_SHIFT, false)
                assert.spy(mb.grab).was_not.called()
                assert.spy(mb.ungrab).was.called(1)

                mb.grab:revert()
                mb.ungrab:revert()
            end)
        end)

        insl(function()
            it("only lonely SHIFT triggers shift", function()
                stub(shift, "shift_secondary_keymap")

                -- test that lonely SHIFT triggers...
                kbh.tap(shift.KEY_SHIFT)
                assert.stub(shift.shift_secondary_keymap).was.called(1)

                -- but that SHIFT followed by another function doesn't shift.
                shift.shift_secondary_keymap:clear()
                for idx, key in ipairs({
                    shift.KEY_LAYOUT,
                    shift.KEY_BRIGHTNESS
                }) do
                    kbh.handle_key(shift.KEY_SHIFT, true)
                    kbh.tap(key)
                    kbh.handle_key(shift.KEY_SHIFT, false)
                    assert.stub(shift.shift_secondary_keymap).was_not.called()
                end
            end)
        end)

        insl(function()
            it("lonly SHIFTs shift around", function()
                local keymap = {
                    name="test"
                }
                local keymap_shifted = {
                    name="test-shifted"
                }
                keymap.shift_to = keymap_shifted
                keymap_shifted.shift_to = keymap
                mb.register_keymap(keymap)
                mb.register_keymap(keymap_shifted)
                assert.is.equal(mb.current_keymap, keymap)

                spy.on(mb, "activate_keymap")

                kbh.tap(shift.KEY_SHIFT)
                assert.spy(mb.activate_keymap).was.called_with(keymap_shifted.name)
                assert.is.equal(mb.current_keymap, keymap_shifted)
                kbh.tap(shift.KEY_SHIFT)
                assert.is.equal(mb.current_keymap, keymap)

                mb.activate_keymap:revert()
            end)
        end)

        insl(function()
            describe("while SHIFTed", function()

                before_each(function()
                    kbh.handle_key(shift.KEY_SHIFT, true)
                end)

                after_each(function()
                    kbh.handle_key(shift.KEY_SHIFT, false)
                end)

                it("cycles primary keymaps", function()
                    stub(mb, "cycle_primary_keymaps")

                    kbh.tap(shift.KEY_LAYOUT)
                    assert.stub(mb.cycle_primary_keymaps).was.called(1)

                    mb.cycle_primary_keymaps:revert()
                end)

                it("changes brightness", function()
                    stub(mb, "set_brightness")

                    kbh.tap(shift.KEY_BRIGHTNESS)
                    kbh.tap(shift.KEY_BRIGHTNESS)
                    assert.stub(mb.set_brightness).was.called(2)

                    mb.set_brightness:revert()
                end)

            end)
        end)

    end)

end)
