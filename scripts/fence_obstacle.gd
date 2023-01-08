extends StaticBody3D

var targetRotation:Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	$fence_1.hide()
	$fence_2.hide()
	$fence_3.hide()
	$fence_4.hide()
	$fence_5.hide()
	$collision_1.disabled = true
	$collision_2.disabled = true
	$collision_3.disabled = true
	$collision_4.disabled = true
	$collision_5.disabled = true
	
	var random_choice = randi_range(0, 4)
	match (random_choice):
		0:
			$fence_1.show()
			$collision_1.disabled = false
		1:
			$fence_2.show()
			$collision_1.disabled = false
			$collision_2.disabled = false
		2:
			$fence_3.show()
			$collision_1.disabled = false
			$collision_3.disabled = false
		3:
			$fence_4.show()
			$collision_4.disabled = false
		4:
			$fence_5.show()
			$collision_5.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = rotation.lerp(targetRotation, 0.1)

func onGrind():
	targetRotation.x = PI/2
	await get_tree().create_timer(1).timeout
	queue_free()
