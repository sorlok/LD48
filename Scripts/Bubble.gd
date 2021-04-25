extends RigidBody2D


const min_speed = 180
const max_speed = 300
onready var on_screen = false


func set_stretch(val:float):
	$Sprite.scale = Vector2(val, val)
	$CollisionShape2D.scale = Vector2(val, val)


# Clear entry when it leaves the screen.
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true
