-- Import libraries
local GUI = require("GUI")
local system = require("System")
local filesystem = require("Filesystem")
local paths = require("paths")

---------------------------------------------------------------------------------


local viruses = {}
local dirToCheck = {}
local systemFiles = {
  "bin",
  "boot",
  "etc",
  "Extensions",
  "home",
  "lib",
  "Libraries",
  "Localizations",
  "MineOS",
  "mnt",
  "Mounts",
  "Pictures",
  "root",
  "Screensavers",
  "Temporary",
  "Users",
  "usr",
  "init.lua",
  "OS.lua",
  "versions.cfg"
}
local virusDelSystemFiles = {}

-- Add a new window to MineOS workspace
local workspace, window = system.addWindow(GUI.filledWindow(1, 1, 35, 25, 0x8E8E8E))

local layout = window:addChild(GUI.layout(1, 2, window.width, window.height-2, 1, 1))

-- Get localization table dependent of current system language
local localization = system.getCurrentScriptLocalization()

local function addToTbl(tbl, a)
  tb1 = {}
  for _, v in pairs(tbl) do
    tb1[v] = 0
  end
  if tb1[a] == nil then table.insert(tbl, a) end
end

local function check(f)
  local lines = filesystem.readLines(f)
  for _, line in pairs(lines) do
    if (line:find "eeprom" ~= nil) and (line:find "set" ~= nil or line:find "flash" ~= nil) then addToTbl(viruses, localization.canFlashTheEEPROM) end
    if line:find "remove" ~= nil or line:find 'rm% %-' ~= nil then
      for _, virus in pairs(systemFiles) do
        if line:find (virus) then
          addToTbl(virusDelSystemFiles, virus)
          addToTbl(viruses, localization.canDeleteSystemFiles)
        end
      end
    end
  end
end
  
--local openFolderBTN = layout:setPosition(1, 1, layout:addChild(GUI.roundedButton(1, 1, 26, 3, 0xEEEEEE, 0x000000, 0xAAAAAA, 0x0, localization.openApp)))
local openFileBTN = layout:setPosition(1, 1, layout:addChild(GUI.roundedButton(1, 1, 26, 3, 0xEEEEEE, 0x000000, 0xAAAAAA, 0x0, localization.openScript)))
local textBox = layout:setPosition(1, 1, layout:addChild(GUI.textBox(2, 2, 32, 16, 0xEEEEEE, 0x2D2D2D, {}, 1, 1, 0)))

filesystemDialog = GUI.addFilesystemDialog(workspace, false, 50, math.floor(workspace.height * 0.8), localization.open1, localization.cancel, localization.scriptName, "/")
filesystemDialog:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
filesystemDialog.onSubmit = function(path)
  viruses = {}
  dirToCheck = {}
  textBox.lines = {}
  check(path)
  if #viruses == 0 then table.insert(textBox.lines, {color=0x00FF00, text=localization.virusNotFound})
  else
    table.insert(textBox.lines, {color=0xFF0000, text=localization.virusFound})
    for _, virus in pairs(viruses) do
      if virus == localization.canDeleteSystemFiles then
        table.insert(textBox.lines, {color=0xD33500, text=virus})
        for _, d in pairs(virusDelSystemFiles) do table.insert(textBox.lines, "  " .. d) end
      else
        table.insert(textBox.lines, {color=0xD33500, text=virus})
        table.insert(textBox.lines, "")
      end
    end
  end
end

openFileBTN.onTouch = function()
  filesystemDialog:show()
end

---------------------------------------------------------------------------------

-- Draw changes on screen after customizing your window
workspace:draw()
