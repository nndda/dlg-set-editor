extends BaseButton

export(String) var file_path = ""
export(String) var file_name = ""
export(String) var raw_array = ""

func _ready():
# warning-ignore:return_value_discarded
	connect( "mouse_entered", self, "on_hover" )
	print("on _set_itm")
	print(file_path)
	print(file_name)
	print(raw_array)
#	connect( "mouse_exited", self, "on_hover", [false] )

func on_hover(is_true = true):
	if is_true:
		if !self.disabled:
			set_default_cursor_shape( Control.CURSOR_POINTING_HAND )
		else:
			set_default_cursor_shape( Control.CURSOR_FORBIDDEN )
