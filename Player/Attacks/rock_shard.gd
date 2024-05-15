extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)
@onready var rockShardAnimation = $RockShardAnimation
@onready var rockShardDeathAnimation = $RockShardDeathAnimation
@onready var rockCollision = $CollisionShape2D
@onready var sndPlay = $snd_play

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(0)
	match level:
		1:
			hp = 3
			speed = 400
			damage = 5
			knockback_amount = 200
			attack_size = 1.0
			
	var tween = create_tween()
	tween.tween_property(self,"scale", Vector2(5,5)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
		
func _physics_process(delta):
	position += angle*speed*delta
	
func enemy_hit(charge = 1):
	hp -= charge
	if hp == 1:
		rockShardAnimation.visible = false
		rockShardDeathAnimation.visible = true
		rockShardDeathAnimation.play()
	if hp <= 0:
		visible = false
		rockCollision.set_deferred("disabled", true)
		await sndPlay.finished
		emit_signal("remove_from_array",self)
		queue_free()
		
		


func _on_timer_timeout():
	emit_signal("remove_from_array",self)
	queue_free()
