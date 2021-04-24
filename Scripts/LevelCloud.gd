extends Node


export (PackedScene) var Cloud
export (PackedScene) var CloudParticles


var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	$CloudTimer.start()
	update_fall_speed()

func update_fall_speed():
	$FallSpeed.text = "Fall Speed: " + str($Player.fall_speed)

func _on_CloudTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var cloud:Node = Cloud.instance()
	cloud.set_frame(rng.randi() % 2)
	add_child(cloud)
	
	# Put the cloud in the right place.
	cloud.position.x = rng.randf() * ($Player.screen_size.x-100) + 50
	cloud.position.y = rng.randf() * 100 + 50 + $Player.screen_size.y
	
	# Make it move up
	cloud.linear_velocity = Vector2(0, -1 * rand_range(cloud.min_speed, cloud.max_speed))


func _on_Player_collide_cloud(cloud:Node2D):
	update_fall_speed()
	
	# Make our particles
	var parts:CPUParticles2D = CloudParticles.instance()
	parts.position = cloud.position + Vector2(0, -60)
	parts.one_shot = true
	add_child(parts)
	parts.restart()
	
