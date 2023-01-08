extends Node3D

var targetRotation:Vector3
var initialRotation:Vector3
var ground:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	$corn_stalk/Cylinder.rotate_y(randf() * PI * 2)
	ground = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dist = transform.origin.distance_to(Global.farmer.transform.origin)
	var v1 = Vector3(Global.farmer.transform.origin.x, 0, Global.farmer.transform.origin.z)
	var v2 = Vector3(transform.origin.x, 0, transform.origin.z)
	var d:Vector3 = v2 - v1
	if (dist < 0.6):
		if (!$Rustle.playing && Global.farmer.alive):
			$Rustle.play()
		Global.farmer.impede()
		targetRotation.x = d.normalized().z * PI * 0.2
		targetRotation.z = -d.normalized().x * PI * 0.2
	elif (ground):
		targetRotation.x = PI/2
	else:
		targetRotation = initialRotation

	rotation = rotation.lerp(targetRotation, 0.1)
	
	if (Global.farmer.transform.origin.z - transform.origin.z > 20):
		queue_free()

func onGrind():
	ground = true
	await get_tree().create_timer(1).timeout
	queue_free()
