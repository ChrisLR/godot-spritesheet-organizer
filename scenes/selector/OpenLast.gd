extends Button

var config = null
var config_file_path = "user://config.json"


var configured = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not self.configured:
		if FileAccess.file_exists(config_file_path):
			var config_file = FileAccess.open(config_file_path, FileAccess.READ)
			var content = config_file.get_as_text()
			config = JSON.parse_string(content)
			if config != null:
				self.disabled = false
		self.configured = true


func _on_pressed():
	$"../Panel/GridContainer/btnFileDialog".text = config['img_path']
	$"../Panel/GridContainer/txtTileWidth".text = config['tile_width']
	$"../Panel/GridContainer/txtTileHeight".text = config['tile_height']
	$"../Panel/GridContainer/txtTileOffset".text = config['tile_offset']
	$"../Panel/GridContainer/txtMargin".text = config['img_margin']
	$"../Panel/GridContainer/btnProcess".disabled = false
