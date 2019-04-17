require "aux.olua-aux"
require "aux.olua-cls"
require "aux.olua-ref"
require "aux.olua-arg-type"
require "aux.olua-gen-header"
require "aux.olua-gen-source"
require "aux.olua-gen-class"
require "aux.olua-gen-class-func"
require "aux.olua-gen-callback"
require "aux.olua-gen-conv"

require "conf.lua-ref"

PROJECT_ROOT = '../../'

function gen_module(module)
    gen_header(module)
    gen_source(module)
end

gen_conv(require("conf.lua-conv"))
gen_conv(require("conf.fairygui.lua-fairygui-conv"))
gen_module(require("conf.cocos2d.lua-cocos2d"))
gen_module(require("conf.cocos2d.lua-cocos2d-ui"))
gen_module(require("conf.cocos2d.lua-spine"))
gen_module(require("conf.fairygui.lua-fairygui"))
gen_module(require("conf.xgame.lua-xgame"))

if exist('conf/swf/lua-swf.lua') then
    --gen_module(require('conf.swf.lua-swf'))
end