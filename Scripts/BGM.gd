extends AudioStreamPlayer

export (AudioStream) var Level0Music
export (AudioStream) var Level1Music
export (AudioStream) var Level2Music


const transition_type = 1 # TRANS_SINE

onready var curr_level = -1


func play_music(level:int):
	# No need to change
	if level == curr_level:
		return
	curr_level = level

	if level == 0:
		stream = Level0Music
	elif level == 1:
		stream = Level1Music
	else:
		stream = Level2Music
	volume_db = 0
	play()


func fade_out(duration:float):
	# Tween music down
	$Tween.interpolate_property(self, "volume_db", 0, -80, duration, transition_type, Tween.EASE_IN, 0)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	# Actually stop playback
	object.stop()
	curr_level = -1
