extends TextureRect

@export var menuPath : NodePath
@export var offset : Vector2

@onready var menuParent = get_node(menuPath)

var enabled := false
var selectedIndex := 0.0

func _process(_delta):
	if enabled:
		var inputVector := Vector2.ZERO
		if Input.is_action_just_pressed("ui_up"):
			inputVector.y -= 1
			$MenuScroll.play()
		if Input.is_action_just_pressed("ui_down"):
			inputVector.y += 1
			$MenuScroll.play()
		if Input.is_action_just_pressed("ui_right"):
			inputVector.x += 1
			$MenuScroll.play()
		if Input.is_action_just_pressed("ui_left"):
			inputVector.x -= 1
			$MenuScroll.play()
	
		if menuParent is VBoxContainer:
			@warning_ignore("narrowing_conversion")
			_setCursor(selectedIndex + inputVector.y)
		elif menuParent is HBoxContainer:
			@warning_ignore("narrowing_conversion")
			_setCursor(selectedIndex + inputVector.x)
		
		if Input.is_action_just_pressed("ui_select"):
			@warning_ignore("narrowing_conversion")
			var currentItem := _getMenuAtIndex(selectedIndex)
			if currentItem != null && currentItem is Label:
				currentItem._cursorSelect()
	
func _getMenuAtIndex(index : int) -> Control:
	if menuParent == null:
		return null
	if index >= menuParent.get_child_count() || index < 0:
		return null
	return menuParent.get_child(index) as Control
	
func _setCursor(index : int) -> void:
	var menuItem = _getMenuAtIndex(index)
	if menuItem == null:
		return
	var cursorPosition = menuItem.global_position
	var cursorSize = menuItem.get_rect().size
	global_position = Vector2(cursorPosition.x, cursorPosition.y + cursorSize.y / 2.0) - (get_rect().size / 2.0) - offset
	selectedIndex = index

func _on_pickup_cursor_enabled():
	enabled = true
	visible = true


func _on_pickup_cursor_disabled():
	visible = false
	enabled = false
