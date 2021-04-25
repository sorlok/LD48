extends Node2D


signal at_target_y

onready var target_y = null

onready var velocity_y = 0

func set_level():
	var level1 = Globals.level%2 == 0
	$Gradients.visible = level1
	$Bed.visible = level1
	$Gradients2.visible = !level1
	$Bed2.visible = !level1


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


