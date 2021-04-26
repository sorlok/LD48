extends RigidBody2D


const min_speed = 300
const max_speed = 350
onready var on_screen = false

func _ready():
	$AnimationPlayer.play("happy")


# Clear entry when it leaves the screen.
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true
