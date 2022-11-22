extends BaseButton

func _ready():
# warning-ignore:return_value_discarded
	connect( "mouse_entered", self, "on_hover" )

func on_hover():
		if !self.disabled:
			set_default_cursor_shape( Control.CURSOR_POINTING_HAND )
		else:
			set_default_cursor_shape( Control.CURSOR_FORBIDDEN )
