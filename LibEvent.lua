local _NAME = "LibEvent"
local _VERSION = "1.0.0"
local _LICENSE = [[
    MIT License

    Copyright (c) 2020 Jayrgo

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
]]

assert(LibMan1, format("%s requires LibMan-1.x.x.", _NAME))
assert(LibMan1:Exists("LibCallback", 1), format("%s requires LibCallback-1.x.x.", _NAME))

local LibEvent --[[ , oldVersion ]] = LibMan1:New(_NAME, _VERSION, "_LICENSE", _LICENSE)
if not LibEvent then return end

LibEvent.callbacks = LibEvent.callbacks or LibMan1:Get("LibCallback", 1):New(LibEvent, "Register", "Unregister")
local callbacks = LibEvent.callbacks

---@type Frame
LibEvent.frame = LibEvent.frame or CreateFrame("Frame")
local frame = LibEvent.frame

---@param self Frame
---@param event string
---@vararg any
frame:SetScript("OnEvent", function(self, event, ...) callbacks:xTriggerEvent(event, ...) end)

---@param event string
function callbacks:OnEventRegistered(event) frame:RegisterEvent(event) end

---@param event string
function callbacks:OnEventUnregistered(event) frame:UnregisterEvent(event) end

LibEvent.FRAMEMIXIN = LibEvent.FRAMEMIXIN or {}
local FRAMEMIXIN = LibEvent.FRAMEMIXIN

---@param self table
---@param event string
---@vararg any
local function OnEvent(self, event, ...) self[event](self, ...) end

function FRAMEMIXIN:OnLoad() self:SetScript("OnEvent", OnEvent) end

local select = select

---@vararg string
function FRAMEMIXIN:RegisterEvents(...) for i = 1, select("#", ...) do self:RegisterEvent(select(i, ...)) end end

---@vararg string
function FRAMEMIXIN:UnregisterEvents(...) for i = 1, select("#", ...) do self:UnregisterEvent(select(i, ...)) end end

---@param unit string
---@vararg string
function FRAMEMIXIN:RegisterEventsForUnit(unit, ...)
    self:UnregisterEvents(...)

    for i = 1, select("#", ...) do self:RegisterUnitEvent(select(i, ...), unit) end
end

---@param unit1 string
---@param unit2 string
---@vararg string
function FRAMEMIXIN:RegisterEventsForUnits(unit1, unit2, ...)
    self:UnregisterEvents(...)

    for i = 1, select("#", ...) do self:RegisterUnitEvent(select(i, ...), unit1, unit2) end
end
