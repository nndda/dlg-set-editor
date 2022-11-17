extends Node

var color_theme = Color8(97,236,240)

var current_set_use_expr = true
var current_expr

var portrait_crop_rect : Rect2
# Dimension // position
# Gap // size
func portrait_crop(
	column : int, row : int	):

	return Rect2(
		Vector2(
			column * portrait_crop_rect.position.x + ( portrait_crop_rect.size.x / 2),
			row * portrait_crop_rect.position.y + ( portrait_crop_rect.size.y / 2 )
		) ,
		Vector2(
			portrait_crop_rect.position.x,
			portrait_crop_rect.position.y )
	)
func portrait_revar( target: Array ):
	return Vector2( target[0], target[1] )


var current_dlg_dict = { }

var current_sets = []

var current_set_filename = ""
var current_set_fullpath = ""
var current_set = []

func get_res_filename( file_name : String ):
	return file_name.right( file_name.find_last( "/" ) + 1 )

func get_default_lines():
	return [
		glbl.current_dlg_dict.keys()[0],
		glbl.current_dlg_dict[ glbl.current_dlg_dict.keys()[0] ]["expressions"].keys()[0],
		"",
		true
	]
