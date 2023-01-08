extends StaticBody3D

var doorAngle:float = 66.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	doorAngle = 66.2
	transform.origin.z = -100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$house/Door.rotation.y = lerp_angle($house/Door.rotation.y, deg2rad(doorAngle), 0.1)

func shutDoor():
	doorAngle = -90.0

func deg2rad(deg):
	return deg * PI / 180
