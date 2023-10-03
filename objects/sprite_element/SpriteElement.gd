extends Sprite2D

var original_pos = Vector2.ZERO
@onready var area_2d: Area2D = $Area2D
@onready var polygon = $Polygon2D

var overlapping_areas = []

var hovered = false
var selected = false
var overlapped = false
var dragged = false

var context = null

var previous_parent = null

func _ready():
	context = get_node("/root/viewsheet/Context")


func _determine_modulation():
	if self.overlapped and not self.selected:
		#self.modulate = Color.GREEN
		polygon.visible = true
		polygon.color = Color.GREEN
		polygon.color.a = 0.25
	elif self.selected:
		#self.modulate = Color.WHITE
		polygon.visible = true
		polygon.color = Color.YELLOW
		polygon.color.a = 0.25
	elif self.hovered:
		#self.modulate = Color.YELLOW
		polygon.visible = true
		polygon.color = Color.YELLOW
		polygon.color.a = 0.1
	else:
		#self.modulate = Color.WHITE
		polygon.visible = false
		polygon.color = Color.WHITE


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			self.context.clicked_on_element(self)
		else:
			self.context.released_click_on_element(self)


func _on_area_2d_mouse_exited():
	self.on_unhover()


func _on_area_2d_mouse_entered():
	self.on_hover()


func _on_area_2d_area_entered(area):
	# TODO Should only handle overlaps of selected nodes
	# TODO It should also only hover the one that is going to be replaced
	overlapping_areas.append(area)
	area.get_parent().on_overlapped()


func _on_area_2d_area_exited(area):
	overlapping_areas.erase(area)
	area.get_parent().on_non_overlapped()
	
func on_hover():
	self.hovered = true
	self._determine_modulation()
	

func on_unhover():
	self.hovered = false
	self._determine_modulation()
	
	
func on_select():
	self.selected = true
	self._determine_modulation()
	
func on_deselect():
	self.selected = false
	self._determine_modulation()

func on_overlapped():
	self.overlapped = true
	self._determine_modulation()
	
func on_non_overlapped():
	self.overlapped = false
	self._determine_modulation()

func on_drag_start():
	self.dragged = true
	self.original_pos = Vector2(self.global_position)
	self.z_index = 1

func on_drag_stop():
	self.dragged = false
	self.original_pos = Vector2.ZERO
	self.z_index = 0
	
func swap_with_overlap():
	if not self.overlapping_areas:
		self.global_position = self.global_position.snapped(Vector2(12, 12))
	else:
		# TODO The chosen overlap should be the nearest, not the first
		var first_area_parent = self.overlapping_areas[0].get_parent()
		self.global_position = first_area_parent.global_position
		first_area_parent.global_position = self.original_pos
		for area in self.overlapping_areas:
			area.get_parent().on_non_overlapped()

func store_parent():
	self.previous_parent = self.get_parent()
