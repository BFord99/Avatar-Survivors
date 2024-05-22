extends Area2D

@export var experience = 1

var spr_green = preload("res://Art/Sprites/Gems/LIGHT GREEN/GEM 1 - LIGHT GREEN - 0000.png")
var spr_blue = preload("res://Art/Sprites/Gems/TURQUOISE/GEM 1 - TURQUOISE - 0000.png")
var spr_pink = preload("res://Art/Sprites/Gems/LILAC/GEM 1 - LILAC - 0000.png")
var spr_red = preload("res://Art/Sprites/Gems/RED/GEM 1 - RED - 0000.png")
var spr_gold = preload("res://Art/Sprites/Gems/GOLD/GEM 1 - GOLD - 0000.png")

var target = null
var speed = -3

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_collected

func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = spr_blue
	elif experience < 125:
		sprite.texture = spr_pink
	elif experience < 625:
		sprite.texture = spr_red
	else:
		sprite.texture = spr_gold
		
func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 8*delta 
		
func collect():
	sound.play()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	return experience


func _on_snd_collected_finished():
	queue_free()
