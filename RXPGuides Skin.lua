-- RXPGuides Skin - Standalone version (MoP Classic)
-- Provides custom styling for RXPGuides addon to try to match elvui.

-- Use local references to reduce global pollution
local _G = _G
local tonumber, strsplit, print, ipairs, CreateFrame, hooksecurefunc = tonumber, strsplit, print, ipairs, CreateFrame, hooksecurefunc

-- BottomFrame position settings
local bottomFrameOffsets = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 15
}

-- Function to update BottomFrame position
local function UpdateBottomFramePosition()
    local RXPFrame = _G.RXPFrame
    if not (RXPFrame and RXPFrame.BottomFrame) then return end
    local bottomFrame = RXPFrame.BottomFrame
    bottomFrame:ClearAllPoints()
    bottomFrame:SetPoint("TOPLEFT", RXPFrame, "TOPLEFT", bottomFrameOffsets.left, bottomFrameOffsets.top)
    bottomFrame:SetPoint("BOTTOMRIGHT", RXPFrame, "BOTTOMRIGHT", bottomFrameOffsets.right, bottomFrameOffsets.bottom)
    -- Update scroll frame position if it exists
    if bottomFrame.ScrollFrame then
        bottomFrame.ScrollFrame:ClearAllPoints()
        bottomFrame.ScrollFrame:SetPoint("TOPLEFT", bottomFrame, "TOPLEFT", 5, -5)
        bottomFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", bottomFrame, "BOTTOMRIGHT", -20, 7)
    end
    -- Update GuideName frame position if it exists
    if RXPFrame.GuideName then
        RXPFrame.GuideName:ClearAllPoints()
        RXPFrame.GuideName:SetPoint("BOTTOMLEFT", bottomFrame, "TOPLEFT", 0, -9)
        RXPFrame.GuideName:SetPoint("BOTTOMRIGHT", bottomFrame, "TOPRIGHT", 0, -9)
    end
end

-- Slash command handler for position control
SLASH_RXPSKIN1 = "/rxpskin"
SlashCmdList["RXPSKIN"] = function(msg)
    local command, left, right, top, bottom = strsplit(" ", msg or "")
    left, right, top, bottom = tonumber(left), tonumber(right), tonumber(top), tonumber(bottom)
    if command == "reset" then
        bottomFrameOffsets = { left = 0, right = 0, top = 0, bottom = 15 }
        UpdateBottomFramePosition()
        print("RXPGuides Skin: BottomFrame position reset to default")
    elseif command == "set" then
        if left and right and top and bottom then
            bottomFrameOffsets = { left = left, right = right, top = top, bottom = bottom }
            UpdateBottomFramePosition()
            print(string.format("RXPGuides Skin: BottomFrame position set to: L:%d, R:%d, T:%d, B:%d", left, right, top, bottom))
        else
            print("Usage: /rxpskin set <left> <right> <top> <bottom>")
            print("Example: /rxpskin set 0 0 -20 20")
        end
    else
        print("RXPGuides Skin - Position Control")
        print("Usage:")
        print("  /rxpskin set <left> <right> <top> <bottom> - Set position offsets")
        print("  /rxpskin reset - Reset to default position")
        print(string.format("Current offsets: L:%d, R:%d, T:%d, B:%d", bottomFrameOffsets.left, bottomFrameOffsets.right, bottomFrameOffsets.top, bottomFrameOffsets.bottom))
    end
end

-- Individual frame transparency settings (ElvUI style)
local FrameTransparency = {
    RXPFrame = 0.8,
    BottomFrame = 0.8,
    BottomFrameScrollFrame = 0.8,
    ItemFrame = 0.8,
    RXPTargetFrame = 0.8,
    GuideName = 0.8,
    StepFrame = 0.8,
    ScrollBar = 0.8,
}

-- Custom backdrop creation function (ElvUI style)
local function CreateCustomBackdrop(frame, alpha)
    if not frame or frame.__RXP_backdrop then return end
    
    local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
    backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
    backdrop:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    -- ElvUI dark theme colors
    backdrop:SetBackdropColor(0.05, 0.05, 0.05, alpha or 0.8)
    backdrop:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)
    backdrop:SetFrameLevel(math.max(0, frame:GetFrameLevel() - 1))
    
    frame.__RXP_backdrop = backdrop
    return backdrop
end

-- Custom shadow creation function
local function CreateCustomShadow(frame)
    if not frame or frame.__RXP_shadow then return end
    
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 4)
    shadow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -4)
    shadow:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 4,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(0, 0, 0, 0.8)
    shadow:SetFrameLevel(math.max(0, frame:GetFrameLevel() - 2))
    
    frame.__RXP_shadow = shadow
    return shadow
end

-- Function to create backdrop with individual transparency (ElvUI style - no shadows)
local function SetBD(frame, frameName)
    if not frame or frame.__RXP_bd then return end
    
    local alpha = FrameTransparency[frameName] or 0.8
    CreateCustomBackdrop(frame, alpha)
    -- No shadows for ElvUI clean look
    
    frame.__RXP_bd = true
end

-- Custom scroll bar reskin function (ElvUI style)
local function ReskinScrollBar(scrollBar)
    if not scrollBar or scrollBar.__RXP_reskinned then return end
    
    -- Hide default textures
    if scrollBar.Track and scrollBar.Track.Background then 
        scrollBar.Track.Background:Hide() 
    end
    if scrollBar.ScrollUpButton then 
        scrollBar.ScrollUpButton:Hide() 
    end
    if scrollBar.ScrollDownButton then 
        scrollBar.ScrollDownButton:Hide() 
    end
    
    -- Create new track background
    local track = CreateFrame("Frame", nil, scrollBar, "BackdropTemplate")
    track:SetPoint("TOPLEFT", scrollBar, "TOPLEFT", 0, 0)
    track:SetPoint("BOTTOMRIGHT", scrollBar, "BOTTOMRIGHT", 0, 0)
    track:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    track:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    track:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)
    
    -- Style the thumb (scroll handle)
    if scrollBar.ThumbTexture then
        -- Hide default thumb texture
        scrollBar.ThumbTexture:SetAlpha(0)
        
        -- Create custom thumb
        local thumb = CreateFrame("Frame", nil, scrollBar, "BackdropTemplate")
        thumb:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        thumb:SetBackdropColor(0.3, 0.3, 0.3, 0.8)
        thumb:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8)
        
        -- Position the thumb
        thumb:SetPoint("TOPLEFT", scrollBar.ThumbTexture, "TOPLEFT", 0, 0)
        thumb:SetPoint("BOTTOMRIGHT", scrollBar.ThumbTexture, "BOTTOMRIGHT", 0, 0)
        
        -- Make thumb slightly smaller than the track
        thumb:SetPoint("LEFT", scrollBar, "LEFT", 2, 0)
        thumb:SetPoint("RIGHT", scrollBar, "RIGHT", -2, 0)
        
        -- Add hover effect
        thumb:SetScript("OnEnter", function()
            thumb:SetBackdropColor(0.4, 0.4, 0.4, 0.9)
        end)
        
        thumb:SetScript("OnLeave", function()
            thumb:SetBackdropColor(0.3, 0.3, 0.3, 0.8)
        end)
        
        -- Store reference
        scrollBar.__RXP_thumb = thumb
    end
    
    -- Make scrollbar thinner
    scrollBar:SetWidth(20)  -- Reduced from default 16-18
    
    -- Style the scroll arrows
    if scrollBar.ScrollUpButton then
        scrollBar.ScrollUpButton:SetAlpha(1)
        scrollBar.ScrollUpButton:SetSize(18, 18)  -- Smaller buttons
        scrollBar.ScrollUpButton:ClearAllPoints()
        scrollBar.ScrollUpButton:SetPoint("BOTTOM", scrollBar, "TOP", 0, -1)  -- Tighter spacing
        
        -- Remove default textures
        for _, region in ipairs({scrollBar.ScrollUpButton:GetRegions()}) do
            if region:IsObjectType("Texture") then
                region:SetTexture(nil)
            end
        end
        
        -- Create custom arrow using default WoW arrow
        local upArrow = scrollBar.ScrollUpButton:CreateTexture(nil, "ARTWORK")
        upArrow:SetTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
        upArrow:SetSize(18, 18)  -- Smaller arrow
        upArrow:SetPoint("CENTER")
        upArrow:SetVertexColor(0.7, 0.7, 0.7, 1)
        
        -- Store reference for hover effects
        scrollBar.ScrollUpButton.arrow = upArrow
        
        -- Hover effect
        scrollBar.ScrollUpButton:HookScript("OnEnter", function(self)
            self.arrow:SetVertexColor(1, 1, 1, 1)
        end)
        
        scrollBar.ScrollUpButton:HookScript("OnLeave", function(self)
            self.arrow:SetVertexColor(0.7, 0.7, 0.7, 1)
        end)
    end
    
    if scrollBar.ScrollDownButton then
        scrollBar.ScrollDownButton:SetAlpha(1)
        scrollBar.ScrollDownButton:SetSize(18, 18)  -- Smaller buttons
        scrollBar.ScrollDownButton:ClearAllPoints()
        scrollBar.ScrollDownButton:SetPoint("TOP", scrollBar, "BOTTOM", 0, 1)  -- Tighter spacing
        
        -- Remove default textures
        for _, region in ipairs({scrollBar.ScrollDownButton:GetRegions()}) do
            if region:IsObjectType("Texture") then
                region:SetTexture(nil)
            end
        end
        
        -- Create custom arrow using default WoW arrow
        local downArrow = scrollBar.ScrollDownButton:CreateTexture(nil, "ARTWORK")
        downArrow:SetTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
        downArrow:SetSize(18, 18)  -- Smaller arrow
        downArrow:SetPoint("CENTER")
        downArrow:SetVertexColor(0.7, 0.7, 0.7, 1)
        
        -- Store reference for hover effects
        scrollBar.ScrollDownButton.arrow = downArrow
        
        -- Hover effect
        scrollBar.ScrollDownButton:HookScript("OnEnter", function(self)
            self.arrow:SetVertexColor(1, 1, 1, 1)
        end)
        
        scrollBar.ScrollDownButton:HookScript("OnLeave", function(self)
            self.arrow:SetVertexColor(0.7, 0.7, 0.7, 1)
        end)
    end
    
    scrollBar.__RXP_reskinned = true
end

-- Custom icon reskin function (ElvUI style)
local function ReskinIcon(icon)
    if not icon or icon.__RXP_icon_reskinned then return end
    
    -- Create ElvUI style border for icon
    local border = CreateFrame("Frame", nil, icon:GetParent(), "BackdropTemplate")
    border:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
    border:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    border:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)
    
    icon.__RXP_icon_border = border
    icon.__RXP_icon_reskinned = true
end

-- Get class texture coordinates
local function GetClassTexCoords()
    local _, class = UnitClass("player")
    local coords = {
        ["WARRIOR"] = {0, 0.25, 0, 0.25},
        ["MAGE"] = {0.25, 0.49609375, 0, 0.25},
        ["ROGUE"] = {0.49609375, 0.7421875, 0, 0.25},
        ["DRUID"] = {0.7421875, 0.98828125, 0, 0.25},
        ["HUNTER"] = {0, 0.25, 0.25, 0.5},
        ["SHAMAN"] = {0.25, 0.49609375, 0.25, 0.5},
        ["PRIEST"] = {0.49609375, 0.7421875, 0.25, 0.5},
        ["WARLOCK"] = {0.7421875, 0.98828125, 0.25, 0.5},
        ["PALADIN"] = {0, 0.25, 0.5, 0.75},
        ["DEATHKNIGHT"] = {0.25, 0.49609375, 0.5, 0.75},
        ["MONK"] = {0.49609375, 0.7421875, 0.5, 0.75},
    }
    return coords[class] or {0, 1, 0, 1}
end

-- Skin generic frames
local function SkinFrame(frame, frameName)
    if not (frame and not frame.__RXP_skinned) then return end
    -- Hide existing textures
    for _, region in ipairs({frame:GetRegions()}) do
        if region:IsObjectType("Texture") then
            region:SetTexture(nil)
        end
    end
    SetBD(frame, frameName)
    frame.__RXP_skinned = true
end

-- Skin main RXPFrame and GuideName
local function SkinRXPFrame()
    local RXPFrame = _G.RXPFrame
    if not RXPFrame then return end
    
    SkinFrame(RXPFrame, "RXPFrame")
    
    if RXPFrame.GuideName then 
        SkinFrame(RXPFrame.GuideName, "GuideName") 
    end
    
    -- Apply custom position after skinning
    C_Timer.After(0.5, function()
        if RXPFrame and RXPFrame.BottomFrame then
            UpdateBottomFramePosition()
            
            -- Hook the RXPFrame's SetPoint method to maintain our position
            hooksecurefunc(RXPFrame, "SetPoint", function()
                C_Timer.After(0.1, UpdateBottomFramePosition)
            end)
        end
    end)
end

-- Skin dynamic frames
local function SkinDynamicFrames()
    local RXPFrame = _G.RXPFrame
    if not RXPFrame then return end
    
    if RXPFrame.BottomFrame then 
        SkinFrame(RXPFrame.BottomFrame, "BottomFrame") 
    end
    
    if RXPFrame.BottomFrameScrollFrame then 
        SkinFrame(RXPFrame.BottomFrameScrollFrame, "BottomFrameScrollFrame") 
    end
    
    local ItemFrame = _G.RXPItemFrame
    if ItemFrame then 
        SkinFrame(ItemFrame, "ItemFrame") 
    end
end

-- Skin scroll bars
local function SkinScrollBar(scrollFrame)
    if not scrollFrame or not scrollFrame.ScrollBar then return end
    ReskinScrollBar(scrollFrame.ScrollBar)
end

-- Skin step frames and class icons with proper spacing
local function SkinStepFrames()
    local RXPFrame = _G.RXPFrame
    if not (RXPFrame and RXPFrame.CurrentStepFrame and RXPFrame.CurrentStepFrame.framePool) then return end
    local pool = RXPFrame.CurrentStepFrame.framePool
    for i, stepframe in ipairs(pool) do
        SkinFrame(stepframe, "StepFrame")
        -- Add spacing between step frames
        if i > 1 and stepframe:IsShown() then
            local prevFrame = pool[i-1]
            if prevFrame and prevFrame:IsShown() then
                stepframe:ClearAllPoints()
                stepframe:SetPoint("TOPLEFT", prevFrame, "BOTTOMLEFT", 0, -4)
                stepframe:SetPoint("TOPRIGHT", prevFrame, "BOTTOMRIGHT", 0, -4)
            end
        end
        if stepframe.number then 
            SkinFrame(stepframe.number, "StepFrame") 
        end
        -- Handle class icons
        local icon = stepframe.icon or stepframe.NumberIcon or stepframe.numberIcon
        if icon then
            icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
            local coords = GetClassTexCoords()
            icon:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
            ReskinIcon(icon)
        end
    end
end

-- Skin target frame
local function SkinTargetFrame()
    local tf = _G.RXPTargetFrame
    if not tf or tf.__RXP_skinned then return end
    
    SkinFrame(tf, "RXPTargetFrame")
end

-- Function to change individual frame transparency
function RXPGuides_SetFrameTransparency(frameName, alpha)
    FrameTransparency[frameName] = alpha
    
    local frame = _G[frameName]
    if frame and frame.__RXP_bd then
        frame.__RXP_bd = nil
        if frame.__RXP_backdrop then
            frame.__RXP_backdrop:Hide()
            frame.__RXP_backdrop = nil
        end
        SetBD(frame, frameName)
    end
end

-- Main skin application function
local function SkinRXPGuides()
    local RXPFrame = _G.RXPFrame
    if not RXPFrame then return end

    SkinRXPFrame()
    SkinDynamicFrames()
    SkinStepFrames()
    SkinTargetFrame()
    
    if RXPFrame.ScrollFrame then 
        SkinScrollBar(RXPFrame.ScrollFrame) 
    end

    -- Hook into RXP functions if available
    local RXP = _G.RXP
    if RXP then
        if RXP.UpdateItemFrame then
            hooksecurefunc(RXP, "UpdateItemFrame", function()
                SkinDynamicFrames()
                SkinTargetFrame()
                if RXPFrame.ScrollFrame then 
                    SkinScrollBar(RXPFrame.ScrollFrame) 
                end
            end)
        end
        
        if RXP.SetStep then
            hooksecurefunc(RXP, "SetStep", function()
                SkinDynamicFrames()
                SkinStepFrames()
                SkinTargetFrame()
                if RXPFrame.ScrollFrame then 
                    SkinScrollBar(RXPFrame.ScrollFrame) 
                end
            end)
        end
    end

    -- Fallback periodic update for dynamic frames
    -- Performance improvement: Increase update interval to 2 seconds.
    -- This reduces unnecessary skinning calls and improves efficiency.
    local updateFrame = CreateFrame("Frame")
    local lastUpdate = 0
    updateFrame:SetScript("OnUpdate", function(self, elapsed)
        lastUpdate = lastUpdate + elapsed
        if lastUpdate >= 2 then -- Update every 2 seconds
            SkinDynamicFrames()
            SkinStepFrames()
            SkinTargetFrame()
            if RXPFrame.ScrollFrame then 
                SkinScrollBar(RXPFrame.ScrollFrame) 
            end
            lastUpdate = 0
        end
    end)
end

-- Initialize the skin
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "RXPGuides" or addonName == "RXP" then
        -- Delay to ensure RXP is fully loaded
        C_Timer.After(1, function()
            SkinRXPGuides()
        end)
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

-- Also try to skin immediately if RXP is already loaded
if _G.RXPFrame then
    SkinRXPGuides()
end
