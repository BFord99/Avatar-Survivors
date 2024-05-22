extends CharacterBody2D

@export var movement_speed = 200
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1
var knockback = Vector2.ZERO

@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var hit_flash_player = $HitAnimPlayer
@onready var hitsound = $sfx_hit
@onready var deathsound = $sfx_death
@onready var critsound = $sfx_crit
@onready var turtleCollision = $TurtleCollision
@onready var hurtBox = $HurtBox
@onready var hitBox = $HitBox
@onready var damage_numbers_point = $DamageNumbersPoint
@onready var critdeath = $sfx_crit_death

var exp_gem = preload("res://Objects/LootConsumables/ExperienceGem.tscn")
var dying: bool = false

signal remove_from_array(object)

func _ready():
	hitBox.damage = enemy_damage

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

func death_view_handler(): 
	hit_flash_player.play("Hit Flash")
	await hit_flash_player.animation_finished 
	visible = false
	hitBox.set_deferred("disabled", true)
	hurtBox.set_deferred("disabled", true)
	turtleCollision.set_deferred("disabled", true)

func hitsound_handler(is_crit: bool): 
	if is_crit: critsound.play()
	else: hitsound.play()

func on_death(is_crit: bool): 
	# the xp bug was this function call was being called while it was running 
	# since the tornado was still inside the rock 
	# poor mans way of fixing it is to have the rock only die once
	if !dying: 
		dying = true
		emit_signal("remove_from_array", self)
		if is_crit: critdeath.play() 
		else: deathsound.play()
		death_view_handler()
		
		# TODO: this should be a func that we can call anywhere
		var new_gem = exp_gem.instantiate()
		new_gem.global_position = global_position
		new_gem.experience = experience
		loot_base.call_deferred("add_child",new_gem)
		
		if is_crit: await critdeath.finished
		else: await deathsound.finished
		print("Enemy Killed")
		queue_free()
	

# TODO: crit chance should be per instance not per attack
# right now damage is calculated on attack creation not on instance of damage
# this will need a big refactor of this method and signal for both player and enemy hb
func _on_hurt_box_hurt(damage, angle, knockback_amount, is_crit, element):
	hp -= damage
	knockback = angle * knockback_amount
	if !dying: 
		DamageText.display_damage(damage, damage_numbers_point.global_position, is_crit, element)
	
	if hp <= 0: 
		on_death(is_crit)
		hit_flash_player.play("Hit Flash")
	else:
		hitsound_handler(is_crit)
		hit_flash_player.play("Hit Flash")
		print("Enemy HP: ", hp)


