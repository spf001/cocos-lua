local class         = require "xgame.class"
local util          = require "xgame.util"
local runtime       = require "xgame.runtime"
local audio         = require "xgame.audio"
local filesystem    = require "xgame.filesystem"
local Array         = require "xgame.Array"
local assetloader   = require "xgame.assetloader"
local Event         = require "xgame.event.Event"
local UILayer       = require "xgame.ui.UILayer"
local Sprite        = require "cc.Sprite"
local PixelFormat   = require "ccb.PixelFormat"

local trace = util.trace("[SceneStack]")

local SceneStack = class("SceneStack")

function SceneStack:ctor(stage)
    self._currentMusic = false
    self._musicAudios = {}
    self._musicStack = Array.new()
    self._sceneStack = Array.new()
    self._sceneLayer = UILayer.new()
    self._sceneLayer.percentWidth = 100
    self._sceneLayer.percentHeight = 100
    stage:addChild(self._sceneLayer)
end

function SceneStack:show(cls, ...)
    local scene = assert(self:topScene(), cls.classname)
    local view = cls.new(...)
    scene:addChild(view)
end

function SceneStack:startScene(cls, ...)
    local entry = self:_getSceneEntry(-1)
    if entry then
        entry.sceneWrapper.visible = false
        entry.sceneWrapper.cobj:onExit()
    end
    self:_doStartScene(cls, ...)
end

function SceneStack:replaceScene(cls, ...)
    self:_doPopScene(true)
    self:_doStartScene(cls, ...)
end

function SceneStack:popScene()
    self:_doPopScene(false)
    runtime.once(Event.RUNTIME_UPDATE, function ()
        runtime.gc()
    end)
    self:_updateMusic()
end

function SceneStack:popAll()
    while #self._sceneStack > 1 do
        self:_doPopScene(true)
    end
    self:popScene()
end

function SceneStack:topScene()
    return self:_getScene(-1)
end

function SceneStack:_doCaptureScene(entry)
    if not entry then
        return
    end
    if not entry.snapshot then
        entry.snapshot = runtime.capture(entry.sceneWrapper.cobj, PixelFormat.RGB565)
    end
    return entry.snapshot
end

function SceneStack:_doCaptureScene(entry, newEntry, callback)
    if not entry or entry.snapshot or not newEntry.scene.renderOption.snapshot then
        callback(nil)
    else
        local snapshotPath = string.format('%s/scene_snapshot_%d.jpg',
            filesystem.dir.cache, #self._sceneStack)
        entry.sceneWrapper.visible = true
        runtime.captureScreen(function (success, path)
            entry.sceneWrapper.visible = false
            if success then
                local snapshot = Sprite.create(path)
                snapshot.ignoreAnchorPointForPosition = true
                callback(snapshot)
            else
                callback(nil)
            end
        end, snapshotPath)
    end
end

function SceneStack:_doStartScene(cls, ...)
    local entry = self._sceneStack:pushBack({
        scene = false,
        sceneWrapper = false,
        snapshot = false,
    })
    trace("create scene: %s", cls.classname)
    local scene = cls.new(...)
    entry.scene = scene
    entry.sceneWrapper = self:_createSceneWrapper(scene)
    self:_updateMusic()
    self:_doCaptureScene(self:_getSceneEntry(-2), entry, function (snapshot)
        if scene.renderOption.snapshot and snapshot then
            entry.sceneWrapper.cobj:addProtectedChild(snapshot)
        end
        self._sceneLayer:addChild(entry.sceneWrapper)
        assetloader.loadSceneAssets(scene)
    end)
end

function SceneStack:_doPopScene(onlypop)
    local numScenes = #self._sceneStack
    local entry = self._sceneStack[numScenes]

    if entry then
        trace("destory scene: %s", entry.scene.classname)
        self._sceneStack[numScenes] = nil
        self._sceneLayer:removeChild(entry.sceneWrapper)
    end

    if not onlypop and numScenes > 1 then
        entry = self._sceneStack[numScenes - 1]
        entry.scene.visible = true
        entry.snapshot = false
        assetloader.loadSceneAssets(entry.scene)
        entry.sceneWrapper.visible = true
        entry.sceneWrapper.cobj:onEnter()
    end
end

function SceneStack:_createSceneWrapper(scene)
    local wrapper = UILayer.new()
    wrapper.percentWidth = 100
    wrapper.percentHeight = 100
    wrapper:addChild(scene)
    return wrapper
end

function SceneStack:_getSceneEntry(index)
    if index < 0 then
        index = #self._sceneStack + index + 1
    end

    if index <= #self._sceneStack then
        return self._sceneStack[index]
    end
end

function SceneStack:_getScene(index)
    local entry = self:_getSceneEntry(index)
    if entry then
        return entry.scene
    end
end

function SceneStack:playMusic(path, volume)
    local entry = self._sceneStack[#self._sceneStack]
    local musicEntry = self._musicStack[#self._musicStack]
    if musicEntry and musicEntry.path ~= path then
        if musicEntry.audio then
            musicEntry.audio:pause()
        end

        musicEntry.path = path
        musicEntry.audio = self:_createMusic(path)

        if musicEntry.audio then
            if volume then
                musicEntry.audio.volume = volume
            end
            musicEntry.audio:resume()
        end

        entry.scene.musicOption.path = path
    end
    self:_purgeMusic()
end

function SceneStack:_createMusic(path)
    if path then
        local audioObj = self._musicAudios[path]
        if not audioObj then
            audioObj = audio.play(path, true)
            self._musicAudios[path] = audioObj
        end
        return audioObj
    end
end

function SceneStack:_updateMusic()
    self:_purgeMusic()

    local musicLen = #self._musicStack
    local sceneLen = #self._sceneStack

    if sceneLen > musicLen then
        -- start new scene
        assert(sceneLen == musicLen + 1, sceneLen .. '#' .. musicLen)
        local nextPath = self:_nextMusicPath()
        local nextMusic = {
            path = nextPath,
            audio = self:_createMusic(nextPath),
        }

        -- stop prev music if different
        if self._currentMusic and self._currentMusic.audio
                and self._currentMusic.audio ~= nextMusic.audio then
            self._currentMusic.audio:pause()
        end

        self._musicStack[#self._sceneStack] = nextMusic
        self._currentMusic = nextMusic

        if self._currentMusic.audio then
            self._currentMusic.audio:resume()
        end
    elseif musicLen > 0 then
        local music = self._musicStack[musicLen]
        local path = self:_nextMusicPath()
        if path ~= music.path then
            self:playMusic(path)
        elseif music.audio then
            music.audio:resume()
        end
        self._currentMusic = music
    end
end

function SceneStack:_nextMusicPath()
    local len = #self._sceneStack
    if len == 0 then
        return
    end

    local musicOption = self._sceneStack[len].scene.musicOption
    if musicOption.keep and len > 1 then
        local prevOption = self._sceneStack[len - 1].scene.musicOption
        musicOption.path = prevOption.path
    end

    return musicOption.path
end

function SceneStack:_purgeMusic()
    local filter = {}
    for k, v in pairs(self._musicAudios) do
        filter[k] = v
    end
    for _, entry in ipairs(self._sceneStack) do
        local option = entry.scene.musicOption
        if option.path then
            filter[option.path] = nil
        end
    end
    for i = #self._sceneStack + 1, #self._musicStack do
        self._musicStack[i] = nil
    end
    local current = self._currentMusic
    for path, audioObj in pairs(filter) do
        if current and current.path == path then
            current = false
            self._currentMusic = false
        end
        audioObj:stop()
        self._musicAudios[path] = nil
    end
end

return SceneStack