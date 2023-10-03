extends Button

@onready var box_selector = $"../../../../BoxSelector"
@onready var context = $"../../../../Context"


func _on_toggled(button_pressed):
	if button_pressed:
		context.set_selection_mode(context.SELECTION_MODE.BOX)
