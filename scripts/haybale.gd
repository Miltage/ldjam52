extends RigidBody3D

var ground:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (ground):
		$haybale.scale = $haybale.scale.lerp(Vector3.ZERO, 0.1)

func onGrind():
	ground = true
	await get_tree().create_timer(1).timeout
	queue_free()
