extends Camera2D

@export var min_zoom := 0.5
@export var max_zoom := 10
@export var zoom_factor := 0.1
@export var zoom_duration := 0.2

var _zoom_level = 1.0
var tween = null
var sensitivity:float = 1.0

var dragging_camera = false
var velocity = Vector2.ZERO


func _set_zoom_level(value: float) -> void:
	tween = get_tree().create_tween()
	_zoom_level = clamp(value, min_zoom, max_zoom)
	tween.tween_property(
		self,
		"zoom",
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		_set_zoom_level(_zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)
	
	if Input.is_action_just_pressed("pan_camera"):
		self.dragging_camera = true
	elif Input.is_action_just_released("pan_camera"):
		self.dragging_camera = false
	
	if event is InputEventMouseMotion and self.dragging_camera:
		self.global_position += (-event.relative / zoom) * sensitivity
