extends Button

@onready var dialog = $"../../FileDialog"

var isSet = false


func _on_pressed():
	dialog.show()

func _on_file_dialog_file_selected(path):
	self.text = path
	get_node("../btnProcess").disabled = false
