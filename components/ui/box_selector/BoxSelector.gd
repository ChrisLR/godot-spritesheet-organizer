extends Node2D

@export var context: Node2D = null
@export var selection_element: SelectionElement = null

var box = null
var is_dragging = false
@onready var pg = $Polygon2D
var origin = null
@onready var area: Area2D = $Area2D
@onready var area_shape: CollisionShape2D = $Area2D/CollisionShape2D

var current_selection = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_dragging and origin != null:
		var arr = pg.polygon
		var mouse_gp = get_global_mouse_position()
		
		
		var resarr = PackedVector2Array([
			Vector2(origin.x, origin.y),
			Vector2(mouse_gp.x, origin.y),
			Vector2(mouse_gp.x, mouse_gp.y),
			Vector2(origin.x, mouse_gp.y)
		])
		pg.polygon = resarr
		var dist = mouse_gp - origin
		area_shape.shape.size = abs(dist)
		area.position = origin + dist / 2
		
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and self.is_dragging:
			self.is_dragging = false
			self.origin = null
			pg.visible = false
			self.push_selection_to_context()
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not self.is_dragging and (abs(event.velocity.x) > 0.2 or abs(event.velocity.y) > 0.2):
			origin = get_global_mouse_position()
			self.is_dragging = true
			pg.visible = true
			area_shape.shape.size = Vector2(1, 1)
			area.position = origin

func push_selection_to_context():
	if self.context:
		var selected_nodes = []
		for area in self.current_selection:
			var parent = area.get_parent()
			selected_nodes.append(parent)
			parent.on_unhover()
			parent.on_select()
		
		if Input.is_key_pressed(KEY_SHIFT):
			self.selection_element.add_many_to_selection(selected_nodes)
		else:
			self.selection_element.replace_selection(selected_nodes)
		self.current_selection.clear()


func _on_area_2d_area_entered(area):
	if is_dragging and area not in self.current_selection:
		self.current_selection.append(area)
		area.get_parent().on_hover()


func _on_area_2d_area_exited(area):
	if is_dragging and area in self.current_selection:
		self.current_selection.erase(area)
		area.get_parent().on_unhover()
