class_name Ability extends Node

var ability_name = ""
var cooldown = 0.0
var glow_color = Color()
var upgrades = []

var available = true
var unlocked = false
var active = false
var active_upgrades = []


func _init(ability_name:String, cooldown: float, glow_color: Color, upgrades: Array):
	self.ability_name = ability_name
	self.cooldown = cooldown
	self.glow_color = glow_color
	self.upgrades = upgrades
	
