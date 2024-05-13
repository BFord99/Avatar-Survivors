extends CharacterBody2D

var movement_speed = 300
var hp = 80

#Attacks
var rockShard = preload("res://Player/Attacks/rock_shard.tscn")

#AttackNodes
@onready var rockShardTimer = get_node("%RockShardTimer")
@onready var rockShardAttackTimer = get_node("%RockShardAttackTimer")

#RockShard
var rockshard_ammo = 0
var rockshard_baseammo = 1
var rockshard_attackspeed = 1.5
var rockshard_level = 1

#Enemy Related
var enemy_close = []

@onready var sprite =$Sprite2D

func _ready():
	attack()

@warning_ignore("unused_parameter")
func _physics_process(delta):
	movement()
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
		
	velocity = mov.normalized()*movement_speed
	move_and_slide()
	
func attack():
	if rockshard_level > 0:
		rockShardTimer.wait_time = rockshard_attackspeed
		if rockShardTimer.is_stopped():
			rockShardTimer.start()

func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= damage
	print("Player HP: " , hp)


func _on_rock_shard_timer_timeout():
	rockshard_ammo += rockshard_baseammo
	rockShardAttackTimer.start()

func _on_rock_shard_attack_timer_timeout():
	if rockshard_ammo > 0:
		var rockshard_attack = rockShard.instantiate()
		rockshard_attack.position = position
		rockshard_attack.target = get_random_target()
		rockshard_attack.level = rockshard_level
		add_child(rockshard_attack)
		rockshard_ammo -= 1
		if rockshard_ammo > 0:
			rockShardAttackTimer.start()
		else:
			rockShardAttackTimer.stop()
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
