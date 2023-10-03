extends Button

var viewsheet_scene = preload("res://scenes/viewsheet/viewsheet.tscn")
var image_processor = preload("res://objects/image_processing/ImageProcessing.tscn")


func _on_pressed():
	var src_img = Image.load_from_file($"../btnFileDialog".text)
	var height = src_img.get_height()
	var width = src_img.get_width()
	var rows = ceil(height / int($"../txtTileHeight".text))
	var cols = ceil(width / int($"../txtTileWidth".text))
	var offset = int($"../txtTileOffset".text)
	var margin = int($"../txtTileOffset".text)
	
	var scene = viewsheet_scene.instantiate()
	var canvasLayer = scene.get_node("CanvasLayer")
	var spriteList = scene.get_node("./SpriteList")
	var root = get_node("/root")
	root.add_child(scene)
	var processor = image_processor.instantiate()
	processor.set_values(rows, cols, margin, offset, src_img, spriteList)
	canvasLayer.add_child(processor)
	processor.start()
	self._save_last_config()
	
	# TODO Start off with a proper main scene
	print('Changing scene')
	
	get_node("/root/selector").visible = false

func _save_last_config():
	var new_config = {
		'img_path': $"../btnFileDialog".text,
		'tile_width': $"../txtTileWidth".text,
		'tile_height': $"../txtTileHeight".text,
		'tile_offset': $"../txtTileOffset".text,
		'img_margin': $"../txtMargin".text
	}
	var config_json = JSON.stringify(new_config)
	var config_file = FileAccess.open("user://config.json", FileAccess.WRITE)
	config_file.store_string(config_json)
