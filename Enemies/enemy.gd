extends CharacterBody2D

@export var movement_speed = 200
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
var knockback = Vector2.ZERO

@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var hit_flash_player = $HitAnimPlayer
@onready var hitsound = $sfx_hit
@onready var deathsound = $sfx_death
@onready var turtleCollision = $TurtleCollision
@onready var hurtBox = $HurtBox
@onready var hitBox = $HitBox

var exp_gem = preload("res://Objects/ExperienceGem.tscn")

signal remove_from_array(object)

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	velocity += knockback
	move_and_slide()
	
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false
		
func on_death(): 
	emit_signal("remove_from_array", self)
	deathsound.play()
	hit_flash_player.play("Hit Flash")
	hitBox.set_deferred("disabled", true)
	hurtBox.set_deferred("disabled", true)
	turtleCollision.set_deferred("disabled", true)
	await hit_flash_player.animation_finished 
	# Maybe have to disable hitbox/hurtbox 
	visible = false
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child",new_gem)
	await deathsound.finished
	print("Enemy Killed")
	queue_free()
	
func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	
	# TODO: check if freeing the queue kills the current function call 
	if hp <= 0: 
		on_death()
		hit_flash_player.play("Hit Flash")
	else:
		hitsound.play()
		hit_flash_player.play("Hit Flash")
		print("Enemy HP: ", hp)
	

