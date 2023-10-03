class_name SelectionElement

extends Node2D

var selected_nodes = []

var is_dragging = false


func _physics_process(delta):
	if self.is_dragging:
		self.do_dragging()
	
func start_dragging():
	self.is_dragging = true
	self.global_position = get_global_mouse_position()
	for node in self.selected_nodes:
		node.on_drag_start()
	
	self.call_deferred('parent_selection')

func do_dragging():
	self.global_position = get_global_mouse_position()

func stop_dragging():
	self.is_dragging = false
	var keep_select = Input.is_key_pressed(KEY_SHIFT)
	self.global_position = self.global_position.snapped(Vector2(12, 12))
	for child in self.selected_nodes:
		if not keep_select:
			child.on_deselect()
		child.swap_with_overlap()
		child.on_drag_stop()
	
	self.call_deferred('unparent_selection', keep_select)
	

func parent_selection():
	for node in self.selected_nodes:
		var offset = node.global_position - self.global_position
		node.store_parent()
		node.previous_parent.remove_child(node)
		self.add_child(node)
		node.position = offset

func unparent_selection(keep_select):
	for node in self.selected_nodes:
		var old_position = node.global_position
		self.remove_child(node)
		node.previous_parent.add_child(node)
		node.global_position = old_position
	
	if not keep_select:
		self.clear_selection()

func add_to_selection(node: Node2D):
	self.selected_nodes.append(node)
	node.on_select()
	
func add_many_to_selection(nodes: Array):
	self.selected_nodes.append_array(nodes)
	for node in nodes:
		node.on_select()

func remove_from_selection(node: Node2D):
	self.selected_nodes.erase(node)
	node.on_deselect()

func remove_many_from_selection(nodes: Array):
	for node in nodes:
		self.selected_nodes.erase(node)
		node.on_deselect()
		

func replace_selection(nodes: Array):
	self.clear_selection()
	self.add_many_to_selection(nodes)

func clear_selection():
	for node in self.selected_nodes:
		node.on_deselect()
		
	self.selected_nodes.clear()

func is_empty():
	return self.selected_nodes.is_empty()

func contains(node):
	return node in self.selected_nodes
