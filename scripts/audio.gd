extends Node

var soundEnabled:bool = true

func play_sample(sample:String, position:Vector3, volume:float = 1.0, randomPitch:bool = true) -> AudioStreamPlayer3D:
	if (!soundEnabled): return null
	var player := AudioStreamPlayer3D.new()
	player.stream = load("assets/" + sample)
	player.pitch_scale = 0.9 + randf() * 0.2 if randomPitch else 1.0
	player.volume_db = -20 + 40 * volume
	player.unit_size = 8
	player.transform.origin = position
	add_child(player)
	player.play()
	waitForCompletion(player)
	return player

func waitForCompletion(player:AudioStreamPlayer3D) -> void:
	await player.finished
	remove_child(player)

func playRustle(position:Vector3) -> AudioStreamPlayer3D:
	var samples = ["rustle_1.wav", "rustle_2.wav"]
	var sample = samples[randi() % samples.size()]
	return play_sample(sample, position, 0.3)
