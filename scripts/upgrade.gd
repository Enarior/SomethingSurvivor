class_name Upgrade extends Node2D

var TYPES = ["PLAYER","ABILITY_WOLF","ABILITY_FROG"]

# Ability specifications
var upgrade_name = ""
var desc = ""
var type
var carac
var value


func _init(upgrade_name:String, desc:String, type:String, carac:String, value):
	self.upgrade_name = upgrade_name
	self.desc = desc
	if type in TYPES:
		self.type = type
	else :
		print("Assigning incorrect type to upgrade. Must be one of " + array_to_string(TYPES))
		
	self.carac = carac
	self.value = value
	

func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i) + " "
	return s

func apply(player):
	print("Applying "+ upgrade_name)
	print(carac)
	
	if type == "PLAYER":
		print(carac)
		print(value)
		
		player.set(carac, value)
	if type == "ABILITY_WOLF":
		var old_value = player.wolf_ability.get(carac)
		if carac == "speed":
			player.wolf_ability.set(carac,old_value + value)
		elif carac == "scale":
			player.wolf_ability.set(carac,old_value + value)
		elif carac == "cooldown":
			player.wolf_ability.set(carac,old_value - value)
			player.get_node("WolfAbilityCooldownTimer").wait_time = old_value - value
		elif carac=="duration":
			player.wolf_ability.set(carac,old_value + value)
			player.get_node("WolfAbilityActiveTimer").wait_time = old_value + value

			
	if type == "ABILITY_FROG":
		player.frog_ability.set("carac",value)
		
		if carac=="duration":
			player.get_node("FrogAbilityActiveTimer").wait_time = value
		elif carac == "cooldown":
			player.get_node("FrogAbilityCooldownTimer").wait_time = value
		
