extends Node


export (PackedScene) var Cloud
export (PackedScene) var CloudParticles
export (PackedScene) var CarExplodeParticles
export (PackedScene) var Rocket
export (PackedScene) var Car
export (PackedScene) var CarAlarm

var player_start_pos:Vector2

var rng = RandomNumberGenerator.new()



func _ready():
	# Avoid potential stretching issues on windows (but we still need to stretch on Android)
	if OS.get_name() != "Android":
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, Vector2(720, 1280))
	
	player_start_pos = $Player.position
	
	rng.randomize()
	
	$CloudTimer.start()
	$CarTimer.start()
	$RocketTimer.start()
	
	update_fall_speed()


func update_fall_speed():
	$FallSpeed.text = "Fall Speed: " + str($Player.fall_speed)


func end_level():
	# Only transition from ingame => ending
	if Globals.state == Globals.ST_INGAME:
		Globals.state = Globals.ST_ENDING
		
		# Avoid spawning in clouds that are already offscreen
		var clouds = get_tree().get_nodes_in_group("cloud")
		for cloud in clouds:
			if !cloud.on_screen:
				cloud.queue_free()
			else:
				cloud.gravity_scale = -5.0
		
		# Move all dangerous offscreen quickly
		var cars = get_tree().get_nodes_in_group("car")
		var rockets = get_tree().get_nodes_in_group("rocket")
		for rocket in rockets:
			cars.push_back(rocket)
		for car in cars:
			if !car.on_screen:
				car.queue_free()
			else:
				var dir = 1
				if car.position.x < $Player.position.x:
					dir = -1
				car.linear_velocity.x = 500 * dir
				car.angular_velocity = 10 * dir
				car.stop_particles()
		
		# Move the player to the middle of the screen
		$Player.move_to(player_start_pos)


func _on_CloudTimer_timeout():
	if Globals.state != Globals.ST_INGAME:
		return
	
	# Create a Cloud instance and add it to the scene.
	var cloud:Node = Cloud.instance()
	cloud.set_frame(rng.randi() % 2)
	add_child(cloud)
	
	# Put the cloud in the right place.
	cloud.position.x = rng.randf() * ($Player.screen_size.x-100) + 50
	cloud.position.y = rng.randf() * 100 + 50 + $Player.screen_size.y
	
	# Make it move up
	cloud.linear_velocity = Vector2(0, -1 * rand_range(cloud.min_speed, cloud.max_speed))

	#
	# TEMP: TODO: Trigger end of level.
	#
	end_level()



func _on_Player_collide_cloud(cloud:Node2D):
	update_fall_speed()
	
	# Make our particles
	var parts:CPUParticles2D = CloudParticles.instance()
	parts.position = cloud.position + Vector2(0, -60)
	parts.one_shot = true
	add_child(parts)
	parts.restart()
	


func _on_CarTimer_timeout():
	if Globals.state != Globals.ST_INGAME:
		return
	
	# Create a Car instance and add it to the scene
	var car:Node = Car.instance()
	car.set_frame(rng.randi() % 3)
	add_child(car)
	
	# Connect our "explode" signal
	car.connect("car_explode", self, "_on_Car_car_explode")
	
	# Put the car in the right place.
	car.position.x = rng.randf() * ($Player.screen_size.x-100) + 50
	car.position.y = rng.randf() * 100 + 50 + $Player.screen_size.y

	# Make it move up
	car.linear_velocity = Vector2(0, -1 * rand_range(car.min_speed, car.max_speed))
	
	# Reschedule the timer
	$CarTimer.wait_time = rng.randi_range(2, 4)


func _on_Player_collide_car(car:Node2D):
	update_fall_speed()
	
	# Make our "alarm" visual effect
	var alarm:Sprite = CarAlarm.instance()
	alarm.position = car.position
	add_child(alarm)


func _on_Car_car_explode(car:Node2D):
	# Make our particles
	var parts:CPUParticles2D = CarExplodeParticles.instance()
	parts.position = car.touch_position
	parts.one_shot = true
	add_child(parts)
	parts.restart()




func _on_RocketTimer_timeout():
	if Globals.state != Globals.ST_INGAME:
		return
	
	# Create a Rocket instance and add it to the scene
	var rocket:Node = Rocket.instance()
	add_child(rocket)
	
	# Put the car in the right place.
	rocket.position.x = rng.randf() * ($Player.screen_size.x-100) + 50
	rocket.position.y = rng.randf() * 100 + 50 + $Player.screen_size.y

	# Make it move up
	rocket.linear_velocity = Vector2(0, -1 * rand_range(rocket.min_speed, rocket.max_speed))
	
	# Reschedule the timer
	$RocketTimer.wait_time = rng.randi_range(5, 10)





#
# TODO: Scroll in the other BG now.
#
func _on_Player_first_force_move_done():
	# Set up
	$SkyBgEnd.position.x = 0
	$SkyBgEnd.position.y = $Player.screen_size.y
	
	# Give it "velocity" and a destination
	var amt = 708 # Distance to base
	var mag = -400
	$SkyBg.velocity_y = mag
	$SkyBg.target_y = $SkyBg.position.y - amt
	$SkyBgEnd.velocity_y = mag
	$SkyBgEnd.target_y = $SkyBgEnd.position.y - amt
	
	# Start moving the player
	$Player.move_to_bed()


# Bed is in view
func _on_SkyBgEnd_at_target_y():
	pass # We don't have to do anything here; the player isn't on the bed yet.


func _on_Player_second_force_move_done():
	print("ON BED") 
	pass # Player is on the bed. TODO
















