extends Node2D

@export var selection_element : SelectionElement = null
@export var context : Node = null

var last_clicked_on = null

var stopping_drag = false
var starting_drag = false
var is_dragging = false


# Called when the node enters the scene tree for the first time.
func _ready():
	context.NodeClicked.connect(self.on_node_clicked)
	context.NodeClickedRelease.connect(self.on_node_click_release)
	

func _physics_process(delta):
	if self.starting_drag:
		self.is_dragging = true
		self.starting_drag = false
		selection_element.start_dragging()
	elif self.stopping_drag:
		self.is_dragging = false
		self.stopping_drag = false
		selection_element.stop_dragging()


func on_node_clicked(node):
	# TODO COULD WE JUST USE THE CLICK RELEASE?
	# TODO THAT WAY WE KNOW IF WE ARE CLICKING TO DRAG OR TO SELECT
	if Input.is_key_pressed(KEY_SHIFT):
		if not selection_element.contains(node):
			selection_element.add_to_selection(node)
	else:
		if selection_element.contains(node):
			return
		
		if not selection_element.is_empty():
			selection_element.clear_selection()
		
		selection_element.add_to_selection(node)
	
	
func on_node_click_release(node):
	if last_clicked_on == null:
		self.last_clicked_on = node
	elif last_clicked_on == node:
		self.last_clicked_on = null
		if Input.is_key_pressed(KEY_SHIFT):
			if node in self.selected_nodes:
				self.selected_nodes.erase(node)
				node.on_deselect()
	else:
		self.last_clicked_on = null


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and self.is_dragging:
			self.stopping_drag = true
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not self.is_dragging and (abs(event.velocity.x) > 0.2 or abs(event.velocity.y) > 0.2):
			self.starting_drag = true
