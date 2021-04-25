extends RigidBody2D


const min_speed = 200
const max_speed = 250
onready var on_screen = false


func set_frame(fr:int):
	$AnimatedSprite.frame = fr


# Clear entry when it leaves the screen.
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true
