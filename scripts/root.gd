extends Node3D

const HaybaleScene = preload("res://scenes/haybale.tscn")
const SideFenceScene = preload("res://scenes/side_fence.tscn")
const FenceScene = preload("res://scenes/fence_obstacle.tscn")
const CornStalkScene = preload("res://scenes/corn_stalk.tscn")
const GrassScene = preload("res://scenes/grass.tscn")

const NUM_OBSTACLES:int = 20
const NUM_GRASS:int = 30

var totalDistance:float
var lastPosition:float
var lastSpawn:float
var obstacleCount:int

var fencingLeft:Node3D
var fencingRight:Node3D

var obstacles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.farmer = $Farmer
	Global.playing = false
	$SplashScreen.show()
	
	fencingLeft = SideFenceScene.instantiate()
	add_child(fencingLeft)
	fencingRight = SideFenceScene.instantiate()
	add_child(fencingRight)
	
	for i in NUM_GRASS:
		var grass = GrassScene.instantiate()
		add_child(grass)
	
	reset()

func reset():
	$Harvester.transform.origin.z = -6
	$Farmer.transform.origin.x = 0
	$Farmer.transform.origin.z = 0
	$Camera3D.transform.origin.z = getCameraIdealPosition()
	$Farmer.reset()
	$DeathScreen.hide()
	$HomeScreen.hide()
	$House.hide()
	$House.reset()
	
	for obstacle in obstacles:
		if (obstacle != null):
			obstacle.queue_free()
	obstacles.clear()
	
	fencingLeft.transform.origin = Vector3(-2.8, 0.4, 0)
	fencingRight.transform.origin = Vector3(2.8, 0.4, 0)
	
	totalDistance = 0.0
	lastSpawn = 0.0
	lastPosition = $Farmer.transform.origin.z
	obstacleCount = 0

func end():
	$DeathScreen/Label.text = "You got harvested!"
	$DeathScreen.show()

func win():
	if ($Farmer.home): return
	$Farmer.home = true
	await get_tree().create_timer(1).timeout
	$HomeScreen/Label.text = "You made it home!"
	$HomeScreen.show()
	$Cheer.play()

func start():
	Global.playing = true
	$SplashScreen.hide()
	$Farmer.alive = true
	lastPosition = $Farmer.transform.origin.z

func _process(delta):
	var distToHouse = $Farmer.transform.origin.z - $House.transform.origin.z
	# update side fencing
	if (!$House.visible || distToHouse < -8.0):
		fencingLeft.transform.origin.z = $Farmer.transform.origin.z - fmod($Farmer.transform.origin.z, 1.0) + 8.0
		fencingRight.transform.origin.z = $Farmer.transform.origin.z - fmod($Farmer.transform.origin.z, 1.0) + 8.0
	
	if (!Global.playing): return
	
	if ($House.visible && distToHouse > 2.0):
		$House.shutDoor()
		win()
	
	$Ground.transform.origin.z = $Farmer.transform.origin.z
	$Shadow.transform.origin.x = $Farmer.transform.origin.x
	$Shadow.transform.origin.z = $Farmer.transform.origin.z
	var s = 1.0 - $Farmer.transform.origin.y * 0.5
	$Shadow.scale = Vector3(s, 1, s)
	
	$Camera3D.transform.origin.z = lerp($Camera3D.transform.origin.z, getCameraIdealPosition(), 0.1)
	
	$Camera3D.environment.adjustment_saturation = lerp($Camera3D.environment.adjustment_saturation, 0.1 if !$Farmer.alive else 1.0, 0.2)
	
	if (!$Farmer.alive):
		end()
		return
	
	totalDistance += $Farmer.transform.origin.z - lastPosition
	lastPosition = $Farmer.transform.origin.z
	
	if (!$House.visible && totalDistance - lastSpawn > 8.0):
		lastSpawn = totalDistance
		spawnObstacle()
		
	$Farmer.panic = $Farmer.transform.origin.z - $Harvester.transform.origin.z < 3.0
	
	if ($Farmer.transform.origin.z - $Harvester.transform.origin.z < 1.0):
		$Death.play()
		$Farmer.alive = false
	
	for obstacle in obstacles:
		if (obstacle == null):
			obstacles.erase(obstacle)
		elif (obstacle.transform.origin.z - $Harvester.transform.origin.z < 1.0 && obstacle.transform.origin.x > -3.0 && obstacle.transform.origin.x < 3.0):
			$Harvester.grind()
			obstacle.onGrind()
			obstacles.erase(obstacle)

func spawnObstacle():
	# spawn house after a number of obstacles
	if (obstacleCount >= NUM_OBSTACLES):
		$House.transform.origin.z = getObstacleSpawnPosition()
		$House.show()
		return
	
	obstacleCount += 1
	
	var random_choice = randi_range(1, 3)
	match (random_choice):
		3: spawnCorn()
		2: spawnFence()
		1: spawnHaybales()

func spawnCorn():
	var amount = randi_range(80, 250)
	for i in amount:
		var obstacle = CornStalkScene.instantiate()
		obstacle.transform.origin = Vector3(randf_range(-5.0, 5.0), 0.5, getObstacleSpawnPosition() + randf_range(-4.0, 4.0))
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

# button events
func _on_start_button_pressed():
	start()

func _on_restart_button_pressed():
	reset()
