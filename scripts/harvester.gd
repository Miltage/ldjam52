extends Node3D

const SPEED = 5.4

var timeElapsed:float = 0
var grindVolume:float = -50

# Called when the node enters the scene tree for the first time.
func _ready():
	$Hum.volume_db = -50
	$Grind.volume_db = -50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeElapsed += delta
	if (grindVolume > -50): grindVolume -= delta * 8
	
	$Particles.speed_scale = 1.0 if Global.playing && Global.farmer.alive else 0.0
	
	var volume:float = -20
	if (!Global.playing || Global.farmer.home):
		volume = -50
	$Hum.volume_db = lerp($Hum.volume_db, volume, 0.1)
	$Grind.volume_db = lerp($Grind.volume_db, grindVolume, 0.1)
	$Grind.pitch_scale = 1.5 + grindVolume * 0.01
	
	if (!Global.farmer.alive || !Global.playing || Global.farmer.home): return
	
	transform.origin.z += SPEED * delta
	$harvester/Grinder.rotate_z(-PI * delta)

func grind():
	grindVolume = -5
