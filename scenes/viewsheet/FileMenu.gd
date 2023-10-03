extends MenuButton

var export_scene = preload("res://objects/image_exporting/ImageExporting.tscn")

var export_instance = null
@onready var dialog = $"../../../FileDialog"

@onready var popup = self.get_popup()
@onready var canvasLayer = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	popup.connect('id_pressed', self._on_id_pressed)
	
func _on_id_pressed(id: int):
	if id == 0:
		_on_export_pressed(true)
	elif id == 1:
		_on_export_pressed(false)
	elif id == 2:
		self._on_quit_pressed()

func _on_export_pressed(packed: bool):
		if not export_instance == null:
			print("ERROR")
			return
			
		dialog.show()
		var export = export_scene.instantiate()
		export.packed_export = packed
		export.set_values(%SpriteList)
		canvasLayer.add_child(export)
		export_instance = export

func _on_quit_pressed():
	pass


func _on_cmd_cursor_select_pressed():
	pass # Replace with function body.


func _on_file_export_dialog_file_selected(path):
	if export_instance != null:
		export_instance.start(path)
