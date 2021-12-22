local require = GLOBAL.require
local io = GLOBAL.io
local assert = GLOBAL.assert
local table = GLOBAL.table
local ACTIONS = GLOBAL.ACTIONS
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS

--[[
flower_pickup
	0 - no flowers
	1 - default
	
meat_pickup
	0 - no meat
	1 - default
	2 - meat first
	
pickup_order
	0 - pickup last
	1 - default
	2 - pickup first
	
blacklist_enabled
	0 - false
	1 - true
	
whitelist_enabled
	0 - false
	1 - true
--]]

local whitelist = {}
local blacklist = {}

--relative path to put those in mod folder doesn't work, leaving the puf_ files
local whitelist_file =  "puf_whitelist.txt"--"..\\mods\\workshop-1603516353\\settings\\whitelist.txt"
local blacklist_file = "puf_blacklist.txt"--"..\\mods\\workshop-1603516353\\settings\\blacklist.txt"

local flower_pickup = GetModConfigData("flower_pickup")
local winter_food_pickup = GetModConfigData("winter_food_pickup")
local winter_ornament_pickup = GetModConfigData("winter_ornament_pickup")
local meat_pickup = GetModConfigData("meat_pickup")
local lantern_last = GetModConfigData("lantern_last")
local pickup_order = GetModConfigData("pickup_order")
local blacklist_enabled = 1
local whitelist_enabled = 1

local flowers = 
{
	"flower",
	"flower_evil",
	"cave_fern",
	"succulent_plant",
	"flower_rose",
	"flower_withered",
}

local meats = 
{
	"manrabbit_tail",
	"pigskin",
	"meat",
	"cookedmeat",
	"meat_dried",
	"monstermeat",
	"cookedmonstermeat",
	"monstermeat_dried",
	"smallmeat",
	"cookedsmallmeat",
	"smallmeat_dried",
	"drumstick",
	"drumstick_cooked",
	"froglegs",
	"froglegs_cooked",
	"batwing",
	"batwing_cooked",
	"trunk_summer",
	"trunk_winter",
	"trunk_cooked",
	"fish",
	"fish_cooked",
	"eel",
	"eel_cooked",
	"plantmeat",
	"plantmeat_cooked",
}

local winter_foods =
{
	"winter_food1",
	"winter_food2",
	"winter_food3",
	"winter_food4",
	"winter_food5",
	"winter_food6",
	"winter_food7",
	"winter_food8",
	"winter_food9",
}


local winter_ornaments =
{
	"winter_ornament_plain1",
	"winter_ornament_plain2",
	"winter_ornament_plain3",
	"winter_ornament_plain4",
	"winter_ornament_plain5",
	"winter_ornament_plain6",
	"winter_ornament_plain7",
	"winter_ornament_plain8",
	"winter_ornament_plain9",
	"winter_ornament_plain10",
	"winter_ornament_plain11",
	"winter_ornament_plain12",
	
	"winter_ornament_fancy1",
	"winter_ornament_fancy2",
	"winter_ornament_fancy3",
	"winter_ornament_fancy4",
	"winter_ornament_fancy5",
	"winter_ornament_fancy6",
	"winter_ornament_fancy7",
	"winter_ornament_fancy8",

	"winter_ornament_boss_bearger",
	"winter_ornament_boss_deerclops",
	"winter_ornament_boss_moose",
	"winter_ornament_boss_dragonfly",
	"winter_ornament_boss_beequeen",
	"winter_ornament_boss_toadstool",
	
	"winter_ornament_boss_antlion",
	"winter_ornament_boss_fuelweaver",
	"winter_ornament_boss_klaus",
	"winter_ornament_boss_krampus",
	"winter_ornament_boss_noeyered",
	"winter_ornament_boss_noeyeblue",
	
	"winter_ornament_boss_malbatross",
	
	"winter_ornament_boss_crabkingpearl",
	"winter_ornament_boss_crabking",
	"winter_ornament_boss_minotaur",
	"winter_ornament_boss_toadstool_misery",
	
	"winter_ornament_boss_pearl",
	"winter_ornament_boss_hermithouse",
	
	"winter_ornament_festivalevents1",
	"winter_ornament_festivalevents2",
	"winter_ornament_festivalevents3",
	"winter_ornament_festivalevents4",
	"winter_ornament_festivalevents5",
	
	"winter_ornament_light1",
	"winter_ornament_light2",
	"winter_ornament_light3",
	"winter_ornament_light4",
	"winter_ornament_light5",
	"winter_ornament_light6",
	"winter_ornament_light7",
	"winter_ornament_light8",
}


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--list functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function IsDefaultScreen()
	local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
	return ((screen and type(screen.name) == "string") and screen.name or ""):find("HUD") ~= nil
		and not(GLOBAL.ThePlayer.HUD:IsControllerCraftingOpen() or GLOBAL.ThePlayer.HUD:IsControllerInventoryOpen())
end

local function save_user_data(filename, data)
	local f = assert(io.open(filename, "w"))
	for _, v in ipairs(data) do
		f:write(v,"\n")
	end
	f:close()
end

local function load_user_data(filename, data)
	local f = io.open(filename, "r")
	if f == nil then
		local f = assert(io.open(filename, "w"))
		f:close()
	end
	local f = assert(io.open(filename, "r"))
	local t = f:read("*line")
	while (t ~= nil) do
		table.insert(data, t)
		t = f:read("*line")
	end
	f:close()
end

local function is_in_list(target_name, list)
	for i, v in ipairs(list) do
		if target_name == v then
			return i
		end
	end
	return false
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--key handling
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function change_pickup_order()
	--check if in game
	if type(GLOBAL.ThePlayer) ~= "table" or type(GLOBAL.ThePlayer.HUD) ~= "table" then return end
	if not IsDefaultScreen() then return end
	--change setting
	if pickup_order == 2 then 
		pickup_order = 0
	else
		pickup_order = pickup_order + 1
	end
	--anounce current setting
	if pickup_order == 0 then
		GLOBAL.ThePlayer.components.talker:Say("Pickup Order: Pickup Last")
	elseif pickup_order == 1 then
		GLOBAL.ThePlayer.components.talker:Say("Pickup Order: Default")
	elseif pickup_order == 2 then
		GLOBAL.ThePlayer.components.talker:Say("Pickup Order: Pickup First")
	end
end

local function change_meat_pickup()
	--check if in game
	if type(GLOBAL.ThePlayer) ~= "table" or type(GLOBAL.ThePlayer.HUD) ~= "table" then return end
	if not IsDefaultScreen() then return end
	--change setting
	if meat_pickup == 2 then 
		meat_pickup = 0
	else
		meat_pickup = meat_pickup + 1
	end
	--anounce current setting
	if meat_pickup == 0 then
		GLOBAL.ThePlayer.components.talker:Say("Meat Priority: No meat")
	elseif meat_pickup == 1 then
		GLOBAL.ThePlayer.components.talker:Say("Meat Priority: Default")
	elseif meat_pickup == 2 then
		GLOBAL.ThePlayer.components.talker:Say("Meat Priority: Meat First")
	end
end

local function AddRemove_blacklist()
	--check if in game
	if type(GLOBAL.ThePlayer) ~= "table" or type(GLOBAL.ThePlayer.HUD) ~= "table" then return end
	if not IsDefaultScreen() then return end

	local ent = GLOBAL.TheInput:GetWorldEntityUnderMouse()
	if ent == nil or ent.prefab == nil then return end
	local name = tostring(ent.prefab)
	
	local index = is_in_list(name, blacklist)
	if index then
		table.remove(blacklist, index)
		GLOBAL.ThePlayer.components.talker:Say("Removed " .. name .. " from blacklist" )
	else
		table.insert(blacklist, name)
		GLOBAL.ThePlayer.components.talker:Say("Added " .. name .. " to blacklist" )
	end
	
	if GetModConfigData("save_enabled") == 1 then 
		save_user_data(blacklist_file, blacklist)
	end
end

local function AddRemove_whitelist()
	--check if in game
	if type(GLOBAL.ThePlayer) ~= "table" or type(GLOBAL.ThePlayer.HUD) ~= "table" then return end
	if not IsDefaultScreen() then return end

	local ent = GLOBAL.TheInput:GetWorldEntityUnderMouse()
	if ent == nil or ent.prefab == nil then return end
	local name = tostring(ent.prefab)
	
	local index = is_in_list(name, whitelist)
	if index then
		table.remove(whitelist, index)
		GLOBAL.ThePlayer.components.talker:Say("Removed " .. name .. " from whitelist" )
	else
		table.insert(whitelist, name)
		GLOBAL.ThePlayer.components.talker:Say("Added " .. name .. " to whitelist" )
	end
	
	if GetModConfigData("save_enabled") == 1 then 
		save_user_data(whitelist_file, whitelist)
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--initialize settings
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if GetModConfigData("change_pickup") ~= 0 then
	GLOBAL.TheInput:AddKeyUpHandler(GetModConfigData("change_pickup"), change_pickup_order)
end
if GetModConfigData("change_meat") ~= 0 then
	GLOBAL.TheInput:AddKeyUpHandler(GetModConfigData("change_meat"), change_meat_pickup)
end
if GetModConfigData("blacklist_key") ~= 0 then
	GLOBAL.TheInput:AddKeyUpHandler(GetModConfigData("blacklist_key"), AddRemove_blacklist)
end
if GetModConfigData("whitelist_key") ~= 0 then
	GLOBAL.TheInput:AddKeyUpHandler(GetModConfigData("whitelist_key"), AddRemove_whitelist)
end

if GetModConfigData("save_enabled") == 1 then 
	load_user_data(whitelist_file, whitelist)
	load_user_data(blacklist_file, blacklist)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--main filtering
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function can_be_picked(self, target)
	return 	target.replica.inventoryitem ~= nil and 
			target.replica.inventoryitem:CanBePickedUp() and not
			(target:HasTag("heavy") or target:HasTag("fire") or target:HasTag("catchable") or target:HasTag("mineactive") or target:HasTag("trapsprung")) and
			(self:HasItemSlots() or target.replica.equippable ~= nil)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function is_valid_target(self, target)
	return self.inst and target.entity:IsVisible() and GLOBAL.CanEntitySeeTarget(self.inst, target)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function choose_pickup_filter(self, ents)
	for _,v in ipairs(ents) do
		if is_valid_target(self, v) and can_be_picked(self, v) then
			--make sure not in any blacklist
			if (blacklist_enabled == 1 and is_in_list(v.prefab, blacklist)) or (meat_pickup == 0 and is_in_list(v.prefab, meats)) or (winter_food_pickup == 0 and is_in_list(v.prefab, winter_foods)) or (winter_ornament_pickup == 0 and is_in_list(v.prefab, winter_ornaments)) then 
				--do nothing
			elseif (whitelist_enabled == 1 and is_in_list(v.prefab, whitelist)) or (meat_pickup == 2 and is_in_list(v.prefab, meats)) then
				return v
			end
		end
	end
	return nil
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function choose_pickup(self, ents)
	for _,v in ipairs(ents) do
		if is_valid_target(self, v) and can_be_picked(self, v) then
			--make sure not in any blacklist
			if (blacklist_enabled == 1 and is_in_list(v.prefab, blacklist)) or (meat_pickup == 0 and is_in_list(v.prefab, meats)) or (winter_food_pickup == 0 and is_in_list(v.prefab, winter_foods)) or (winter_ornament_pickup == 0 and is_in_list(v.prefab, winter_ornaments)) then 
				--do nothing
			else
				return v
			end
		end
	end
	return nil
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetPickupAction(self, tool, target)
    if target:HasTag("smolder") then
        return ACTIONS.SMOTHER
    elseif tool ~= nil then
        for k, v in pairs(GLOBAL.TOOLACTIONS) do
            if target:HasTag(k.."_workable") then
                if tool:HasTag(k.."_tool") then
                    return ACTIONS[k]
                end
                break
            end
        end
    end

    if target:HasTag("quagmireharvestabletree") and not target:HasTag("fire") then
        return ACTIONS.HARVEST_TREE
    elseif target:HasTag("trapsprung") then
        return ACTIONS.CHECKTRAP
    elseif target:HasTag("minesprung") then
        return ACTIONS.RESETMINE
    elseif target:HasTag("inactive") then
        return (not target:HasTag("wall") or self.inst:IsNear(target, 2.5)) and ACTIONS.ACTIVATE or nil
    elseif can_be_picked(self, target) then
        return ACTIONS.PICKUP
    elseif target:HasTag("pickable") and not target:HasTag("fire") then
		if not (flower_pickup == 0 and is_in_list(target.prefab, flowers)) then
			return ACTIONS.PICK
		end
    elseif target:HasTag("harvestable") then
        return ACTIONS.HARVEST
    elseif target:HasTag("readyforharvest") or
        (target:HasTag("notreadyforharvest") and target:HasTag("withered")) then
        return ACTIONS.HARVEST
    elseif target:HasTag("tapped_harvestable") and not target:HasTag("fire") then
		return ACTIONS.HARVEST
    elseif target:HasTag("dried") and not target:HasTag("burnt") then
        return ACTIONS.HARVEST
    elseif target:HasTag("donecooking") and not target:HasTag("burnt") then
        return ACTIONS.HARVEST
    elseif tool ~= nil and tool:HasTag("unsaddler") and target:HasTag("saddled") and (not target.replica.health or not target.replica.health:IsDead()) then
        return ACTIONS.UNSADDLE
    elseif tool ~= nil and tool:HasTag("brush") and target:HasTag("brushable") and (not target.replica.health or not target.replica.health:IsDead()) then
        return ACTIONS.BRUSH
    elseif self.inst.components.revivablecorpse ~= nil and target:HasTag("corpse") and ValidateCorpseReviver(target, self.inst) then
        return ACTIONS.REVIVE_CORPSE
	elseif target:HasTag("tendable_farmplant") then
		return ACTIONS.INTERACT_WITH
    end
    --no action found
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetTargetAction(self, tool, ents)
	--pickup last
	if pickup_order == 0 then
		--look for non pickup entity
		for _,v in ipairs(ents) do
			if is_valid_target(self, v) then
				local action = GetPickupAction(self, tool, v)
				if action ~= nil and action ~= ACTIONS.PICKUP then
					return v, action
				end
			end
		end
		--at this point only pickable ents are left
		local target = choose_pickup_filter(self, ents)
		target = target or choose_pickup(self, ents)
		if target ~= nil then
			return target, ACTIONS.PICKUP
		end
		--no action found
		return nil, nil
	-------------------------------------------------------------------------------------------------------------------
	--default
	elseif pickup_order == 1 then
		--if any of ents is on whitelist, pick him first anyways
		local target = choose_pickup_filter(self, ents)
		if target ~= nil then
			return target, ACTIONS.PICKUP
		end
		--choose action normally
		for _,v in ipairs(ents) do
			if is_valid_target(self, v) then
				local action = GetPickupAction(self, tool, v)
				if action ~= nil then
					--apply blacklist and meat filters
					if action == ACTIONS.PICKUP and choose_pickup(self, {v}) == nil then
						--do nothing
					else
						return v, action
					end
				end
			end
		end
		--no action found
		return nil, nil
	-------------------------------------------------------------------------------------------------------------------
	--pickup first
	elseif pickup_order == 2 then
		--look for pickable entity, first from whitelist then from everything
		local target = choose_pickup_filter(self, ents)
		target = target or choose_pickup(self, ents)
		if target ~= nil then
			return target, ACTIONS.PICKUP
		end
		--only non pickable entities are left
		for _,v in ipairs(ents) do
			if is_valid_target(self, v) then
				local action = GetPickupAction(self, tool, v)
				if action ~= nil then
					--apply blacklist and meat filters
					if action == ACTIONS.PICKUP and choose_pickup(self, {v}) == nil then
						--do nothing
					else
						return v, action
					end
				end
			end
		end
		--no action found
		return nil, nil
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function ValidateHaunt(target)
    return target:HasActionComponent("hauntable")
end

local function ValidateBugNet(target)
    return not target.replica.health:IsDead()
end

local HAUNT_TARGET_EXCLUDE_TAGS = { "haunted", "catchable" }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local PlayerController = require("components/playercontroller")
function PlayerController:GetActionButtonAction(force_target)
    --Don't want to spam the action button before the server actually starts the buffered action
    --Also check if playercontroller is enabled
    --Also check if force_target is still valid
    if (not self.ismastersim and (self.remote_controls[CONTROL_ACTION] or 0) > 0) or
        not self:IsEnabled() or
        (force_target ~= nil and (not force_target.entity:IsVisible() or force_target:HasTag("INLIMBO") or force_target:HasTag("NOCLICK"))) then
        --"DECOR" should never change, should be safe to skip that check
        return

    elseif self.actionbuttonoverride ~= nil then
        local buffaction, usedefault = self.actionbuttonoverride(self.inst, force_target)
        if not usedefault or buffaction ~= nil then
            return buffaction
        end

    elseif self.inst.replica.inventory:IsHeavyLifting()
        and not (self.inst.replica.rider ~= nil and self.inst.replica.rider:IsRiding()) then
        --hands are full!
        return

    elseif not self:IsDoingOrWorking() then
        local force_target_distsq = force_target ~= nil and self.inst:GetDistanceSqToInst(force_target) or nil

        if self.inst:HasTag("playerghost") then
            --haunt
            if force_target == nil then
                local target = GLOBAL.FindEntity(self.inst, self.directwalking and 3 or 6, ValidateHaunt, nil, HAUNT_TARGET_EXCLUDE_TAGS)
                if GLOBAL.CanEntitySeeTarget(self.inst, target) then
                    return GLOBAL.BufferedAction(self.inst, target, ACTIONS.HAUNT)
                end
            elseif force_target_distsq <= (self.directwalking and 9 or 36) and
                not (force_target:HasTag("haunted") or force_target:HasTag("catchable")) and
                ValidateHaunt(force_target) then
                return GLOBAL.BufferedAction(self.inst, force_target, ACTIONS.HAUNT)
            end
            return
        end

        local tool = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

        --bug catching (has to go before combat)
        if tool ~= nil and tool:HasTag(ACTIONS.NET.id.."_tool") then
            if force_target == nil then
                local target = GLOBAL.FindEntity(self.inst, 5, ValidateBugNet, { "_health", ACTIONS.NET.id.."_workable" }, TARGET_EXCLUDE_TAGS)
                if GLOBAL.CanEntitySeeTarget(self.inst, target) then
                    return GLOBAL.BufferedAction(self.inst, target, ACTIONS.NET, tool)
                end
            elseif force_target_distsq <= 25 and
                force_target.replica.health ~= nil and
                ValidateBugNet(force_target) and
                force_target:HasTag(ACTIONS.NET.id.."_workable") then
                return GLOBAL.BufferedAction(self.inst, force_target, ACTIONS.NET, tool)
            end
        end

        --catching
        if self.inst:HasTag("cancatch") then
            if force_target == nil then
                local target = GLOBAL.FindEntity(self.inst, 10, nil, { "catchable" }, TARGET_EXCLUDE_TAGS)
                if GLOBAL.CanEntitySeeTarget(self.inst, target) then
                    return GLOBAL.BufferedAction(self.inst, target, ACTIONS.CATCH)
                end
            elseif force_target_distsq <= 100 and
                force_target:HasTag("catchable") then
                return GLOBAL.BufferedAction(self.inst, force_target, ACTIONS.CATCH)
            end
        end

        --unstick
        if force_target == nil then
            local target = GLOBAL.FindEntity(self.inst, self.directwalking and 3 or 6, nil, { "pinned" }, TARGET_EXCLUDE_TAGS)
            if GLOBAL.CanEntitySeeTarget(self.inst, target) then
                return GLOBAL.BufferedAction(self.inst, target, ACTIONS.UNPIN)
            end
        elseif force_target_distsq <= (self.directwalking and 9 or 36) and
            force_target:HasTag("pinned") then
            return GLOBAL.BufferedAction(self.inst, force_target, ACTIONS.UNPIN)
        end

        --revive (only need to do this if i am also revivable)
        if self.inst.components.revivablecorpse ~= nil then
            if force_target == nil then
                local target = GLOBAL.FindEntity(self.inst, 3, ValidateCorpseReviver, { "corpse" }, TARGET_EXCLUDE_TAGS)
                if GLOBAL.CanEntitySeeTarget(self.inst, target) then
                    return GLOBAL.BufferedAction(self.inst, target, ACTIONS.REVIVE_CORPSE)
                end
            elseif force_target_distsq <= 9
                and force_target:HasTag("corpse")
                and ValidateCorpseReviver(force_target, self.inst) then
                return GLOBAL.BufferedAction(self.inst, force_target, ACTIONS.REVIVE_CORPSE)
            end
        end

		--misc: pickup, tool work, smother
		--if force_target == nil then
		local pickup_tags =
		{
			"_inventoryitem",
			"pickable",
			"donecooking",
			"readyforharvest",
			"notreadyforharvest",
			"harvestable",
			"trapsprung",
			"minesprung",
			"dried",
			"inactive",
			"smolder",
			"saddled",
			"brushable",
			"tapped_harvestable",
			"tendable_farmplant",
		}
		if tool ~= nil then
			for k, v in pairs(GLOBAL.TOOLACTIONS) do
				if tool:HasTag(k.."_tool") then
					table.insert(pickup_tags, k.."_workable")
				end
			end
		end
		if self.inst.components.revivablecorpse ~= nil then
			table.insert(pickup_tags, "corpse")
		end
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, self.directwalking and 3 or 6, nil, PICKUP_TARGET_EXCLUDE_TAGS, pickup_tags)

		--if v ~= self.inst and v.entity:IsVisible() and GLOBAL.CanEntitySeeTarget(self.inst, v) then
		local target, action = GetTargetAction(self, tool, ents)
		--print("result from TargetAction:")
		--print("target = " .. tostring(target))
		--print("action = " .. tostring(action))
		if action ~= nil then
			return GLOBAL.BufferedAction(self.inst, target, action, action ~= ACTIONS.SMOTHER and tool or nil)
		end
    end
end
