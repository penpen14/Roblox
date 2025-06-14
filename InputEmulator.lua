local VirtualInputManager = game:GetService('VirtualInputManager')

local Input = {
    Hold = function(key, time)
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(time)
         VirtualInputManager:SendKeyEvent(false, key, false, game)
    end,
    Press = function(key)
         VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.005)
         VirtualInputManager:SendKeyEvent(false, key, false, game)
    end
}

return input
