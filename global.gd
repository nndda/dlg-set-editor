extends Node

#	idk if im using the right words for naming the variables and stuff

var color_theme = Color8(97,236,240)

var current_set_use_expr = true
var current_portrait

var portrait_grid_size = Vector2()		# Row and Column 
var portrait_size = Vector2()			# Portrait sheet image dimension
var portrait_chr_size = Vector2()
var portrait_gap = Vector2()			

func get_portrait_properties():
	glbl.portrait_size = glbl.current_portrait.get_size()
func set_portrait_gap():
#	( size.x - ( portrait_size.x * column ) ) / column / 2
#	( size.y - ( portrait_size.y * row ) ) / row / 2
	glbl.portrait_gap = Vector2(
		( glbl.portrait_size.x - ( glbl.portrait_chr_size.x * glbl.portrait_grid_size.x ) ) / glbl.portrait_grid_size.x / 2,
		( glbl.portrait_size.y - ( glbl.portrait_chr_size.y * glbl.portrait_grid_size.y ) ) / glbl.portrait_grid_size.y / 2
		)
func portrait_crop(
	column : int,
	row : int	):
#	( ( size.x / column ) * portrait column )	+ gap.x
#	( ( size.y / row ) * portrait row )		+ gap.y
	glbl.set_portrait_gap()
	return Rect2(
		( ( glbl.portrait_size.x / glbl.portrait_grid_size.x ) * column ) + glbl.portrait_gap.x,
		( ( glbl.portrait_size.y / glbl.portrait_grid_size.y ) * row ) + glbl.portrait_gap.y,
		glbl.portrait_chr_size.x,
		glbl.portrait_chr_size.y
		)
#func portrait_crop_byname( expression_name : String ):
#	pass
func portrait2vec2( target: Array ):
	return Vector2( target[0], target[1] )


var current_dict = { }
var dict_chr = { }
var dict_cfg = {}
func set_dict_properties():
	glbl.dict_chr = glbl.current_dict.characters
	glbl.dict_cfg = glbl.current_dict._CONFIG


var current_sets = []

var current_set_filename = ""
var current_set_fullpath = ""
var current_set = []

#				Getting filename + extension from a path, does Godot have something like this built-in?
#			->		C:\Homework\math.mp4
#			->		math.mp4
func get_res_filename( file_name : String ):
	return file_name.right( file_name.find_last( "/" ) + 1 )

func get_default_lines():
	return [
		glbl.dict_chr.keys()[0],
		glbl.dict_chr[ glbl.dict_chr.keys()[0] ]["expressions"].keys()[0],
		"",
		true
		]
