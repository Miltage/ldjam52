extends Node3D

const HaybaleScene = preload("res://scenes/haybale.tscn")
const SideFenceScene = preload("res://scenes/side_fence.tscn")
const FenceScene = preload("res://scenes/fence_obstacle.tscn")
const CornStalkScene = preload("res://scenes/corn_stalk.tscn")

const MOVE_SPEED = 4.0

var totalDistance:float
var lastPosition:float
var lastSpawn:float

var fencingLeft:Node3D
var fencingRight:Node3D

var obstacles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera3D.transform.origin.z = getCameraIdealPosition()
	Global.farmer = $Farmer
	start()

func start():
	$Farmer.alive = true
	lastPosition = $Farmer.transform.origin.z
	
	fencingLeft = SideFenceScene.instantiate()
	fencingLeft.transform.origin = Vector3(-2.8, 0.4, 0)
	add_child(fencingLeft)
	fencingRight = SideFenceScene.instantiate()
	fencingRight.transform.origin = Vector3(2.8, 0.4, 0)
	add_child(fencingRight)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Ground.transform.origin.z = $Farmer.transform.origin.z
	$Camera3D.transform.origin.z = lerp($Camera3D.transform.origin.z, getCameraIdealPosition(), 0.1)
		
	fencingLeft.transform.origin.z = $Farmer.transform.origin.z - fmod($Farmer.transform.origin.z, 1.0) + 8.0
	fencingRight.transform.origin.z = $Farmer.transform.origin.z - fmod($Farmer.transform.origin.z, 1.0) + 8.0
	
	if (!$Farmer.alive): return
	
	totalDistance += $Farmer.transform.origin.z - lastPosition
	lastPosition = $Farmer.transform.origin.z
	
	if (totalDistance - lastSpawn > 8.0):
		lastSpawn = totalDistance
		spawnObstacle()
	
	if ($Farmer.transform.origin.z - $Harvester.transform.origin.z < 1.0):
		$Farmer.alive = false
	
	for obstacle in obstacles:
		if (obstacle.transform.origin.z - $Harvester.transform.origin.z < 1.0):
			obstacle.queue_free()
			obstacles.erase(obstacle)


func spawnObstacle():
	var random_choice = randi_range(1, 3)
	match (random_choice):
		3: spawnCorn()
		2: spawnFence()
		1: spawnHaybales()

func spawnCorn():
	var amount = randi_range(50, 150)
	for i in amount:
		var obstacle = CornStalkScene.instantiate()
		obstacle.transform.origin = Vector3(randf_range(-5.0, 5.0), 0.5, getObstacleSpawnPosition() + randf_range(-2.0, 2.0))
		add_child(obstacle)
		obstacles.append(obstacle)

func spawnFence():
	var obstacle = FenceScene.instantiate()
	obstacle.transform.origin = Vector3(2.5, 0.4, getObstacleSpawnPosition())
	add_child(obstacle)
	obstacles.append(obstacle)

func spawnHaybales():
	var amount = randi_range(3, 8)
	for i in amount:
		var obstacle = HaybaleScene.instantiate()
		obstacle.transform.origin = Vector3(randf_range(-2.0, 2.0), 2, getObstacleSpawnPosition())
		obstacle.rotation = Vector3(randf_range(0, PI), randf_range(0, PI), randf_range(0, PI))
		add_child(obstacle)
		obstacles.append(obstacle)

func getCameraIdealPosition():
	return $Farmer.transform.origin.z + 4.0

func getObstacleSpawnPosition():
	return $Farmer.transform.origin.z + 15.0 + randf_range(-1.0, 1.0)
