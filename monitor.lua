-- Mining Turtle Monitoring and Control Script

local CHANNEL = 123      -- Specify the same channel used by the mining turtle
local TIMEOUT = 5         -- Set the timeout for receiving messages

function clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

function displayStatus(message)
    clearScreen()
    print("Mining Turtle Status:")
    print(message)
end

-- Open the modem on the computer
rednet.open("left")  -- You may need to adjust the side

-- Function to send a command to the mining turtle
local function sendCommand(command)
    rednet.broadcast(command, CHANNEL)
end

-- Main loop
while true do
    local senderId, message = rednet.receive(CHANNEL, TIMEOUT)

    if senderId then
        displayStatus(message)
    else
        -- Display a message indicating that no updates were received
        displayStatus("Waiting for updates...")
    end

    -- Check for user input to send commands
    if os.pullEventRaw("key") == "char" then
        local command = read("Enter command (R)esume, (P)ause, (D)rop and Resume, (S)top: ")
        command = string.lower(command)

        if command == "r" or command == "p" or command == "d" or command == "s" then
            sendCommand(command)
            clearScreen()
            print("Command sent: " .. command)
            os.sleep(2)  -- Display the message for a short duration
        else
            clearScreen()
            print("Invalid command. Please enter R, P, D, or S.")
            os.sleep(2)
        end
    end
end
