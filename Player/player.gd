extends CharacterBody2D

var movement_speed = 300
var hp = 100
var maxhp = 100
var last_movement = Vector2.UP
var time = 0
var pass_time = 0

var experience = 0
var experience_level = 1
var collected_experience = 0

#Attacks
var rockShard = preload("res://Player/Attacks/rock_shard.tscn")
var waterTornado = preload("res://Player/Attacks/water_tornado.tscn")

#AttackNodes
@onready var rockShardTimer = get_node("%RockShardTimer")
@onready var rockShardAttackTimer = get_node("%RockShardAttackTimer")
@onready var waterTornadoTimer = get_node("%WaterTornadoTimer")
@onready var waterTornadoAttackTimer = get_node("%WaterTornadoAttackTimer")

#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

#RockShard
var rockshard_ammo = 0
var rockshard_baseammo = 0
var rockshard_attackspeed = 1.5
var rockshard_level = 0

#WaterTornado
var watertornado_ammo = 0
var watertornado_baseammo = 0
var watertornado_attackspeed = 3
var watertornado_level = 0

#Enemy Related
var enemy_close = []

@onready var sprite =$Sprite2D

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%lbl_levelCount")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var sndLevelUp = get_node("%snd_levelup")
@onready var healthBar = get_node("%HealthBar")
@onready var lblTimer = get_node("%lblTimer")
@onready var collectedAbilities = get_node("%CollectedAbilities")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Player/GUI/item_container.tscn")
@onready var deathPanel = get_node("%PlayerDeath")
@onready var sndPlayerDeath = get_node("%snd_playerdeath")
@onready var lblDeathTimer = get_node("%lbl_deathTimer")
@onready var lblDeathLevel = get_node("%lbl_deathLevel")

func _ready():
	attack()
	set_expbar(experience, calculate_experiencecap())
	healthBar.max_value = maxhp
	healthBar.value = hp

@warning_ignore("unused_parameter")
func _physics_process(delta):
	movement()
	pass_time += delta
	change_time()
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
	
	if mov != Vector2.ZERO:
		last_movement = mov
		
	velocity = mov.normalized()*movement_speed
	move_and_slide()
	
func attack():
	if rockshard_level > 0:
		rockShardTimer.wait_time = rockshard_attackspeed * (1-spell_cooldown)
		if rockShardTimer.is_stopped():
			rockShardTimer.start()
			
	if watertornado_level > 0:
		waterTornadoTimer.wait_time = watertornado_attackspeed * (1-spell_cooldown)
		if waterTornadoTimer.is_stopped():
			waterTornadoTimer.start()

func _on_hurt_box_hurt(damage, _angle, _knockback, crit_chance, element):
	hp -= clamp(damage-armor, 1.0, 999.0)
	healthBar.value = hp
	if hp <= 0:
		on_death()

func _on_rock_shard_timer_timeout():
	rockshard_ammo += rockshard_baseammo + additional_attacks
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
			
func _on_water_tornado_timer_timeout():
	watertornado_ammo += watertornado_baseammo + additional_attacks
	waterTornadoAttackTimer.start()


func _on_water_tornado_attack_timer_timeout():
	if watertornado_ammo > 0:
		var watertornado_attack = waterTornado.instantiate()
		watertornado_attack.position = position
		watertornado_attack.last_movement = last_movement
		watertornado_attack.level = watertornado_level
		add_child(watertornado_attack)
		watertornado_ammo -= 1
		if watertornado_ammo > 0:
			waterTornadoAttackTimer.start()
		else:
			waterTornadoAttackTimer.stop()
		
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


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)
		
func calculate_experience(gen_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gen_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required-experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
		
	else:
		experience += collected_experience
		collected_experience = 0
		
	set_expbar(experience, exp_required)
	
func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap = 95 + (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
		
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value
	
func levelup():
	sndLevelUp.play()
	lblLevel.text = str("Level: ", experience_level)
	# Moving Level Up UI onto screen
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel,"position",Vector2(620,206),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true
	
func upgrade_character(upgrade):
	match upgrade:
		"rockShard1":
			rockshard_level = 1
			rockshard_baseammo += 1
		"rockShard2":
			rockshard_level = 2
		"rockShard3":
			rockshard_level = 3
			rockshard_baseammo += 1
		"rockShard4":
			rockshard_level = 4
			rockshard_baseammo += 2
		"waterTornado1":
			watertornado_level = 1
			watertornado_baseammo += 1
		"waterTornado2":
			watertornado_level = 2
			watertornado_baseammo += 1
		"waterTornado3":
			watertornado_level = 3
			watertornado_baseammo += 1
			watertornado_attackspeed -= .5
		"waterTornado4":
			watertornado_level = 4
			watertornado_baseammo += 1
			watertornado_attackspeed -= .5
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"hat1","hat2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,maxhp)
			healthBar.value = hp
	
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(2500,140)
	get_tree().paused = false
	calculate_experience(0)
	
func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: # Find already collected upgrades
			pass
		elif i in upgrade_options: # If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": # Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: # Check for prereq
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					pass
				else:
					dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomItem = dblist.pick_random()
		upgrade_options.append(randomItem)
		return randomItem
	else:
		return null
		
			
func change_time():
	var time = int(pass_time)
	var m = int(time / 60.0)
	var s = time % 60
	if m < 10:
		m = str(0, m)
	if s < 10:
		s = str(0, s)
		
	lblTimer.text = str(m, ":", s)

func adjust_gui_collection(upgrade):
	var get_upgraded_displaynames = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displaynames in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedAbilities.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)
					
func on_death():
	sndPlayerDeath.play()
	lblLevel.visible = false
	lblTimer.visible = false
	lblDeathLevel.text = str(experience_level)
	lblDeathTimer.text = str(lblTimer.text)
	# Moving PlayerDeath UI onto screen
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel,"position",Vector2(620,206),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	deathPanel.visible = true
	get_tree().paused = true



