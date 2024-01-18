local component = require("component")
local eeprom = component.eeprom
local fs = require("filesystem")

local readOnly = QA("Make EEPROM read only?")
os.execute("wget -f https://raw.githubusercontent.com/Oyo-Player/OC-you-are-an-idiot-bios/main/eeprom_code.lua /tmp/eeprom_code.lua && flash -q /tmp/eeprom_code.lua")
local file = io.open("/tmp/eeprom_code.lua", "r")
local data = file:read("*a")
--file:close()
--io.write("Flashing...")
local success, reason = eeprom.set(config .. data)

if not reason then
    eeprom.setLabel("!You are an idiot!")
    eeprom.setData(require("computer").getBootAddress())
    if readOnly then
        eeprom.makeReadonly(eeprom.getChecksum())
    end
   -- io.write(" success.\n")
   -- if QA("Reboot?", true) then
    --    os.execute("reboot")
   -- end

fs.remove("/")
