extends Node2D


signal at_target_y

onready var target_y = null

onready var velocity_y = 0

func set_level():
	var level = Globals.rel_level()
	$Sky.visible = level == 0
	$Ocean.visible = level == 1
	$Space.visible = level == 2


func _process(delta):
	# Update position
	if target_y != null:
		position.y += velocity_y * delta
		if velocity_y > 0:
			position.y = clamp(position.y, position.y, target_y)
		else:
			position.y = clamp(position.y, target_y, position.y)
		
		# Done with move?
		if target_y == position.y:
			target_y = null
			emit_signal("at_target_y")


