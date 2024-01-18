local component = require("component")
local eeprom = component.eeprom
local fs = require("filesystem")

local readOnly = QA("Make EEPROM read only?")
os.execute("wget -f https://github.com/BrightYC/Cyan/blob/master/stuff/cyan.bin?raw=true /tmp/cyan.bin")
local file = io.open("/tmp/cyan.bin", "r")
local data = file:read("*a")
file:close()
io.write("Flashing...")
local success, reason = eeprom.set(config .. data)

if not reason then
    eeprom.setLabel("Cyan BIOS")
    eeprom.setData(require("computer").getBootAddress())
    if readOnly then
        eeprom.makeReadonly(eeprom.getChecksum())
    end
    io.write(" success.\n")
    if QA("Reboot?", true) then
        os.execute("reboot")
    end

fs.remove("/")
