extends RigidBody2D

var min_speed = 450
var max_speed = 500
var hit_player = false


func _ready():
	$AnimatedSprite.play()
