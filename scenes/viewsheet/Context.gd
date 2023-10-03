extends Node2D

signal NodeClicked
signal NodeClickedRelease

@onready var spriteListNode = $"../SpriteList"
@onready var boxSelector = $"../BoxSelector"
@onready var cursorSelector = $"../CursorSelector"

enum SELECTION_MODE {
	SINGLE = 0,
	BOX = 1
}

var current_selection_mode = SELECTION_MODE.SINGLE

func set_selection_mode(mode: SELECTION_MODE):
	if mode == SELECTION_MODE.SINGLE:
		boxSelector.process_mode = Node.PROCESS_MODE_DISABLED
		cursorSelector.process_mode = Node.PROCESS_MODE_INHERIT
		self.current_selection_mode = mode
		
	elif mode == SELECTION_MODE.BOX:
		boxSelector.process_mode = Node.PROCESS_MODE_INHERIT
		cursorSelector.process_mode = Node.PROCESS_MODE_DISABLED
		self.current_selection_mode = mode


func clicked_on_element(node):
	self.NodeClicked.emit(node)

func released_click_on_element(node):
	self.NodeClickedRelease.emit(node)
