class_name Ability extends Node

# Ability specifications
var ability_name = ""
var cooldown
var duration
var speed
var glow_color = Color()
var hitbox_modifier

# Ability state
var available = true
var unlocked = false
var active = false


func _init(ability_name:String, cooldown: float, duration:float, speed:float,hitbox_modifier: float, glow_color: Color):
	self.ability_name = ability_name
	self.cooldown = cooldown
	self.duration = duration
	self.speed = speed
	self.hitbox_modifier = hitbox_modifier
	self.glow_color = glow_color
	
	
