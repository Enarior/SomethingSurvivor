class_name Ability extends Node

var ability_name = ""
var ability_cooldown = 0.0
var ability_glow_color = Color()

var available = true
var unlocked = false
var active = false

func _init(ability_name:String, ability_cooldown: float, ability_glow_color: Color):
	self.ability_name = ability_name
	self.ability_cooldown = ability_cooldown
	self.ability_glow_color = ability_glow_color
	
