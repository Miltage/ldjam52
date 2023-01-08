extends Node3D

var targetRotation:Vector3
var initialRotation:Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	$corn_stalk/Cylinder.rotate_y(randf() * PI * 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dist = transform.origin.distance_to(Global.farmer.transform.origin)
	var v1 = Vector3(Global.farmer.transform.origin.x, 0, Global.farmer.transform.origin.z)
	var v2 = Vector3(transform.origin.x, 0, transform.origin.z)
	var d:Vector3 = v2 - v1
	if (dist < 0.6):
		Global.farmer.current_speed *= 0.995
		targetRotation.x = d.normalized().z * PI * 0.2
		targetRotation.z = -d.normalized().x * PI * 0.2
	else:
		targetRotation = initialRotation

	rotation = rotation.lerp(targetRotation, 0.1)
