extends Area2D

var level = 1
var hp = 1
var speed = 100

var is_crit: bool
var damage: int

var damage_min = 4
var damage_max = 9
var crit_chance = 0.5

var knockback_amount = 100
var attack_size = 1.0

var last_movement = Vector2.ZERO
var angle = Vector2.ZERO
var angle_less = Vector2.ZERO
var angle_more = Vector2.ZERO

var element = GlobalEnums.attackElement.WATER

signal remove_from_array(object)

@onready var player =get_tree().get_first_node_in_group("player")

func _ready():
	match level:
		1:
			hp = 9999
			speed = 600.0
			is_crit = randf() < crit_chance 
			damage = damage_gen() * 2 if is_crit else damage_gen()
			knockback_amount = 150
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 9999
			speed = 600.0
			is_crit = randf() < crit_chance 
			damage = damage_gen() * 2 if is_crit else damage_gen()
			knockback_amount = 225
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 9999
			speed = 600.0
			is_crit = randf() < crit_chance 
			damage = damage_gen() * 2 if is_crit else damage_gen()
			knockback_amount = 225
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 9999
			speed = 600.0
			is_crit = randf() < crit_chance 
			damage = damage_gen() * 2 if is_crit else damage_gen()
			knockback_amount = 225
			attack_size = 1.0 * (1 + player.spell_size)
			
	var move_to_less = Vector2.ZERO
	var move_to_more = Vector2.ZERO
	match last_movement:
		Vector2.UP, Vector2.DOWN:
			move_to_less = global_position + Vector2(randf_range(-1,-0.25), last_movement.y)*500
			move_to_more = global_position + Vector2(randf_range(0.25,1), last_movement.y)*500
		Vector2.RIGHT, Vector2.LEFT:
			move_to_less = global_position + Vector2(last_movement.x, randf_range(-1, -0.25))*500
			move_to_more = global_position + Vector2(last_movement.x, randf_range(0.25,1))*500
		Vector2(1,1), Vector2(-1,-1), Vector2(1,-1),Vector2(-1,1):
			move_to_less = global_position + Vector2(last_movement.x, last_movement.y)*500
			move_to_more = global_position + Vector2(last_movement.x * randf_range(0,0.75), last_movement.y)*500
			
	angle_less = global_position.direction_to(move_to_less)
	angle_more = global_position.direction_to(move_to_more)
	
	var initial_tween = create_tween().set_parallel(true)
	initial_tween.tween_property(self,"scale",Vector2(10,10)*attack_size,3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var final_speed = speed
	speed = speed/8
	initial_tween.tween_property(self,"speed",final_speed,6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	initial_tween.play()
	
	var tween = create_tween()
	var set_angle = randi_range(0,1)
	angle = angle_less if set_angle == 1 else angle_more
	var alternate_angle = angle_more if set_angle == 1 else angle_less
	for i in range(6):
		tween.tween_property(self, "angle", alternate_angle, 4)
		# Why does the interpreter not like the expr below
		# angle, alternate_angle = alternate_angle, angle
		var temp = angle
		angle = alternate_angle
		alternate_angle = temp
	if set_angle != 1: tween.play()
	
func damage_gen(): return randi() % damage_max + damage_min  

func _physics_process(delta):
	position += angle*speed*delta

func _on_timer_timeout(_charge = 1):
	emit_signal("remove_from_array",self)
	queue_free()
