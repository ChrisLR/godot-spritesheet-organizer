extends Control

signal PROCESS_ROUND

var sprite_element_scene = preload("res://objects/sprite_element/SpriteElement.tscn")

var ready_to_process = false
var started = false

var rows = 0
var cols = 0
var margin = 0
var offset = 0
var src_img: Image = null
var spriteList: Node2D = null


func set_values(_rows: int, _cols: int, _margin: int, _offset:int, _src_img: Image, _spriteList: Node2D):
	self.rows = _rows
	self.cols = _cols
	self.margin = _margin
	self.offset = _offset
	self.src_img = _src_img
	self.spriteList = _spriteList

func start():
	self.ready_to_process = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if self.ready_to_process:
		if not self.started:
			process_image()
		else:
			PROCESS_ROUND.emit()

func process_image():
	self.started = true
	var progressBar = $Panel/VBoxContainer/ProgressBar
	progressBar.max_value = rows * cols
	for y in range(rows):
		for x in range(cols):
			var img = Image.create(12, 12, false, src_img.get_format())
			img.blit_rect(src_img, Rect2i(margin + (x * 12) + (x * offset), margin + (y * 12) + (y * offset), 12, 12), Vector2i(0, 0))
			if img.is_empty() or img.is_invisible():
				continue
				
			var sprite = sprite_element_scene.instantiate()
			sprite.texture = ImageTexture.create_from_image(img)
			sprite.global_position = Vector2(x * 12, y * 12)
			spriteList.add_child(sprite)
			progressBar.value += 1
		await PROCESS_ROUND
			
	self.ready_to_process = false
	self.queue_free()
