extends Node

@export var initialState : State

var currentState : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.stateTransitioned.connect(on_state_transitioned)
		
		if initialState:
			initialState._enterState()
			currentState = initialState

func _process(delta):
	if currentState:
		currentState._update(delta)

func _physics_process(delta):
	if currentState:
		currentState._physicsUpdate(delta)

func on_state_transitioned(state, newStateName):
	if state != currentState:
		return
	
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
	
	if currentState:
		currentState._exitState()
	
	newState._enterState()
	currentState = newState
