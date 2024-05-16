extends Node


# This solution works with no animation 
# Best way to make this better in the future is to not use tweens, get a sprite
# sheet with numbers 0-9 and just build it ourselves
# I'd like if the animation for crits and normal hits was different
# What could also be cool is that each ability has a 'school' attached to it
# Which would influence the color of the damage text
# Maybe Ill write it
func display_damage(damage: int, position: Vector2, is_crit:bool):
	var number = Label.new() 
	number.global_position = position
	number.text = str(damage)
	number.z_index = 5
	number.label_settings = LabelSettings.new()

	var color = "#FFF"
	if is_crit: color = "B22"

	number.label_settings.font_color = color
	number.label_settings.font_size = damage * 5 
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 15
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true) 
	tween.tween_property( 
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property( 
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property( 
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)

	
	await tween.finished
	number.queue_free()
