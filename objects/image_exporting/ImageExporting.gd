extends Control

signal PROCESS_ROUND


var spriteList = null
var ready_to_process = false
var started = false
var packed_export = true
var file_path = ""


func set_values(sprite_list: Node2D):
	self.spriteList = sprite_list
	
func start(_file_path):
	self.ready_to_process = true
	self.file_path = _file_path


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.ready_to_process:
		if not self.started:
			if self.packed_export:
				self._export()
			else:
				self._unpacked_export()
		else:
			PROCESS_ROUND.emit()

func _export():
	self.started = true
	var imgCount = spriteList.get_child_count()
	var arr = []
	for i in range(imgCount):
		arr.append([i, spriteList.get_child(i).position])
		
	arr.sort_custom(_sort_by_pos)
	
	var iSQRT = int(ceil(sqrt(imgCount)))
	var height = iSQRT * 12
	var width = iSQRT * 12
	
	# TODO Dialog for progression bar
	await PROCESS_ROUND
	var target_img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	for i in range(imgCount):
		var sprite = spriteList.get_child(arr[i][0])
		var y = i % iSQRT
		var x = int(i / iSQRT)
		target_img.blit_rect(sprite.texture.get_image(), Rect2i(0, 0, 12 ,12), Vector2i(x * 12, y * 12))
	
	var global_path = ProjectSettings.globalize_path(self.file_path)
	target_img.save_png(global_path)
	OS.shell_open(global_path)
	# TODO Dialog for save
	self.queue_free()

func _unpacked_export():
	self.started = true
	var imgCount = spriteList.get_child_count()
	var arr: Array = spriteList.get_children()
	arr.sort_custom(_sort_by_pos_2)
	
	var min_y = 0
	var max_y = 0
	var min_x = 0
	var max_x = 0
	
	for node in arr:
		var pos_x = node.position.x
		var pos_y = node.position.y
		if pos_x < min_x:
			min_x = pos_x
		
		if pos_x > max_x:
			max_x = pos_x
		
		if pos_y < min_y:
			min_y = pos_y
		
		if pos_y > max_y:
			max_y = pos_y
	
	var origin_zero = Vector2(min_x, min_y)
	var height = max_y - origin_zero.y
	var width = max_x - origin_zero.x
	
	# TODO Dialog for progression bar
	await PROCESS_ROUND
	var target_img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	for sprite in arr:
		var y = sprite.position.y - origin_zero.y
		var x = sprite.position.x - origin_zero.x
		target_img.blit_rect(sprite.texture.get_image(), Rect2i(0, 0, 12 ,12), Vector2i(x, y))
	
	var global_path = ProjectSettings.globalize_path(self.file_path)
	target_img.save_png(global_path)
	OS.shell_open(global_path)
	# TODO Dialog for save
	self.queue_free()

func _sort_by_pos(a, b):
	return a[1] < b[1]
	
func _sort_by_pos_2(a, b):
	return a.position < b.position
