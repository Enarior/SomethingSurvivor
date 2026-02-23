class_name Ability extends Node

# Ability specifications
var ability_name = ""
var cooldown
var duration
var speed
var glow_color = Color()
var scale

# Ability state
var available = true
var unlocked = false
var active = false


func _init(ability_name:String, cooldown: float, duration:float, speed:float,scale: Vector2, glow_color: Color):
	self.ability_name = ability_name
	self.cooldown = cooldown
	self.duration = duration
	self.speed = speed
	self.scale = scale
	self.glow_color = glow_color
	
	
