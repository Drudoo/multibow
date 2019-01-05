local busted=require "busted"

require "keybow"
busted.stub(keybow, "auto_lights")
busted.stub(keybow, "clear_lights")
busted.stub(keybow, "load_pattern")
busted.stub(keybow, "set_pixel")
busted.stub(keybow, "set_key")
busted.stub(keybow, "set_modifier")
busted.stub(keybow, "tap_key")

busted.stub(keybow, "sleep") -- FIXME
busted.stub(keybow, "usleep") -- FIXME