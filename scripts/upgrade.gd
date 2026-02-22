class_name Upgrade extends Node2D

var TYPES = ["PLAYER","ABILITY_WOLF","ABILITY_FROG"]

# Ability specifications
var upgrade_name = ""
var desc = ""
var type
var speed
var cooldown
var duration
var hitbox_modifier


func _init(upgrade_name:String, desc:String, type:String, speed:float=0, cooldown: float=0, duration:float=0, hitbox_modifier: float=0):
	self.upgrade_name = upgrade_name
	self.desc = desc
	if type in TYPES:
		self.type = type
	else :
		print("Assigning incorrect type to upgrade. Must be one of " + array_to_string(TYPES))
	if speed!=0: self.speed = speed
	if cooldown!=0: self.cooldown = cooldown
	if duration!=0: self.duration = duration
	if hitbox_modifier!=0: self.hitbox_modifier = hitbox_modifier
	

func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i) + " "
	return s

func apply(player):
	print("Applying "+ upgrade_name)
	
	if type == "PLAYER":
		print(speed)
		
		player.speed = speed
		player.scale = player.scale*hitbox_modifier
	if type == "ABILITY_WOLF":
		print(speed)
		
		player.wolf_ability.speed = speed
		player.wolf_ability.cooldown = cooldown
		player.wolf_ability.duration = duration
		player.wolf_ability.hitbox_modifier = hitbox_modifier
		
		player.get_node("WolfAbilityActiveTimer").wait_time = duration
		player.get_node("WolfAbilityCooldownTimer").wait_time = cooldown
			
			
	if type == "ABILITY_FROG":
		print(speed)
		
		player.frog_ability.speed = speed
		player.frog_ability.cooldown = cooldown
		player.frog_ability.duration = duration
		player.frog_ability.hitbox_modifier = hitbox_modifier
		
		player.get_node("FrogAbilityActiveTimer").wait_time = duration
		player.get_node("FrogAbilityCooldownTimer").wait_time = cooldown
			
