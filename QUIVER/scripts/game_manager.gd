extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name game_manager

const saveManager = preload("res://addons/MetroidvaniaSystem/Template/Scripts/SaveManager.gd")
const savePath = "user://save.sav"

@onready var fullHeart = preload("res://QUIVER/scenes/full_heart.tscn")
@onready var halfHeart = preload("res://QUIVER/scenes/half_heart.tscn")
@onready var emptyHeart = preload("res://QUIVER/scenes/empty_heart.tscn")
@onready var saveCursor = preload("res://QUIVER/scenes/menu_cursor.tscn")
@onready var heartsContainer = $HUD/Main/HeartsContainer
@onready var prompt = $HUD/Pickup

@export var startingRoom: String

var newGame := false
var generatedRooms : Array[Vector3i]

func _ready():
	AudioServer.set_bus_mute(1, false)
	AudioManager._playAmbient()
	set_player($Player)
	if newGame:
		MetSys.set_save_data()
	elif FileAccess.file_exists(savePath):
		var saveManagerInstance := saveManager.new()
		saveManagerInstance.load_from_text(savePath)
		player.maxHealth = saveManagerInstance.get_value("maxHealth")
		player.currentHealth = player.maxHealth
		player.hasBow = saveManagerInstance.get_value("hasBow")
		player.hasBooster = saveManagerInstance.get_value("hasBooster")
		player.normalCapacity = saveManagerInstance.get_value("normalCapacity")
		player.upgradedCapacity = saveManagerInstance.get_value("upgradedCapacity")
		if player.hasBooster:
			player.maxJumps = 2
		var loadedStartingMap : String = saveManagerInstance.get_value("currentRoom")
		if not loadedStartingMap.is_empty():
			startingRoom = loadedStartingMap
	else:
		MetSys.set_save_data()
	room_loaded.connect(_initRoom, CONNECT_DEFERRED)
	add_module("RoomTransitions.gd")
	load_room(startingRoom)
	_renderHearts()
	if $Player.normalCapacity[1] > 0:
		$Player._updateAmmo($Player.normalCapacity, $HUD/Main/StandardAmmo/StandardAmmoLabel)
		$HUD/Main/SelectBox/SelectedItem.texture = $Player.selectIcons[0]
		$HUD/Main/StandardAmmo.visible = true
	if $Player.upgradedCapacity[1] > 0:
		$Player._updateAmmo($Player.upgradedCapacity, $HUD/Main/UpgradedAmmo/UpgradedAmmoLabel)
		$HUD/Main/UpgradedAmmo.visible = true
	var start := map.get_node_or_null("SavePodium")
	if start:
		player.position = start.position
	
func _initRoom():
	MetSys.get_current_room_instance().adjust_camera_limits($Player/Camera2D)

func _renderHearts() -> void:
	for i in heartsContainer.get_children():
		i.queue_free()
	for i in $Player.currentHealth / 2:
		heartsContainer.add_child(fullHeart.instantiate())
	if $Player.currentHealth % 2 == 1:
		heartsContainer.add_child(halfHeart.instantiate())
	for i in ($Player.maxHealth - $Player.currentHealth) / 2:
		heartsContainer.add_child(emptyHeart.instantiate())

func _saveInitiated() -> void:
	$Player.currentHealth = $Player.maxHealth
	_renderHearts()
	$Player.normalCapacity[0] = $Player.normalCapacity[1]
	$Player.upgradedCapacity[0] = $Player.upgradedCapacity[1]
	$Player._updateAmmo($Player.normalCapacity, $HUD/Main/StandardAmmo/StandardAmmoLabel)
	$Player._updateAmmo($Player.upgradedCapacity, $HUD/Main/UpgradedAmmo/UpgradedAmmoLabel)
	prompt._pickup("SAVE", "DO YOU WISH TO SAVE YOUR PROGRESS?")
	prompt._savePrompt()

func _on_no_label_cursor_selected():
	prompt._closePrompt()

func _on_yes_label_cursor_selected():
	_saveGame()
	prompt._closePrompt()

func _saveGame() -> void:
	var saveManagerInstance := saveManager.new()
	saveManagerInstance.set_value("maxHealth", $Player.maxHealth)
	saveManagerInstance.set_value("hasBow", $Player.hasBow)
	saveManagerInstance.set_value("hasBooster", $Player.hasBooster)
	saveManagerInstance.set_value("normalCapacity", $Player.normalCapacity)
	saveManagerInstance.set_value("upgradedCapacity", $Player.upgradedCapacity)
	saveManagerInstance.set_value("currentRoom", MetSys.get_current_room_name())
	saveManagerInstance.save_as_text(savePath)

func _on_room_loaded():
	for node in get_tree().get_nodes_in_group("pickupItem"):
		node.queue_free()
	if(MetSys.get_current_room_name() == "castle_beginning.tscn"):
		AudioServer.set_bus_volume_db(1, -6.0)
	else:
		AudioServer.set_bus_volume_db(1, -12.0)
	if(len(get_tree().get_nodes_in_group("save")) > 0):
		get_tree().get_nodes_in_group("save")[0].connect("saveInitiated", _saveInitiated)
