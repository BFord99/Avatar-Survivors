extends CharacterBody2D

@export var movement_speed = 200
@export var hp = 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var hit_flash_player = $HitAnimPlayer
@onready var hitsound = $sfx_hit
@onready var deathsound = $sfx_death

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
	await hit_flash_player.animation_finished 
	visible = false
	await deathsound.finished
	queue_free()
	
func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	
	# TODO: check if freeing the queue kills the current function call 
	if hp <= 0: on_death()

	hitsound.play()
	hit_flash_player.play("Hit Flash")
	print("Enemy HP: ", hp)
	

