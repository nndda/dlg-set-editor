extends Node

#	idk if im using the right words for naming the variables and stuff

onready var backups = $Backups

enum SET_TYPE{
	Lines,		# 0
	Pause,		# 1
}


func bool2var( boolean, return_true, return_false ):
	if boolean:
		return return_true
	else:
		return return_false


func set_editor_tooltip( messag ):
	if messag != null:
		get_parent().get_node( "MainApp/EditorContainer/Main/UpperBar/Stats/RightAlign/Tooltip" ).text = messag
	else:
		get_parent().get_node( "MainApp/EditorContainer/Main/UpperBar/Stats/RightAlign/Tooltip" ).text = ""


#	Configurations for the apps
var settings_filename = "preferences.cfg"
var default_settings = {
		"auto_backup":{
			"active":true,
			"interval":15,
			"copies":12,
		},
		"error_fix":{
			"active":true,
			"_config":true,
			"_chr_missing":true,
			"_chr_blank":true,
			"_expr_missing":true,
			"_expr_blank":true,
		}
	}
var current_settings = {}

func read_settings():
	$Backups.stop()
	var app_cfg = File.new()

	if app_cfg.file_exists( "user://" + glbl.settings_filename ):

		app_cfg.open( "user://" + glbl.settings_filename , File.READ)
		if str2var( app_cfg.get_as_text() ) is Dictionary:
			glbl.current_settings = str2var( app_cfg.get_as_text() )
		else:
			push_error("invalid preferences" + glbl.settings_filename )

	else: # First time setting settings

		app_cfg.open( "user://" + glbl.settings_filename , File.WRITE )
		app_cfg.store_string( var2str( glbl.default_settings ) )
		app_cfg.flush()
		glbl.current_settings = str2var( app_cfg.get_as_text() )
		app_cfg.close()

	if glbl.current_settings.auto_backup.active:
		$Backups.set_wait_time( glbl.current_settings.auto_backup.interval )
		$Backups.start()
	else:
		$Backups.stop()

func write_settings():
	var app_cfg = File.new()

	app_cfg.open( "user://" + glbl.settings_filename , File.WRITE )
	app_cfg.store_string( var2str( glbl.default_settings ) )
	app_cfg.close()



var color_theme = Color8(97,236,240)

var current_set_use_expr = true
var current_portrait
var portrait_filepath

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
#	print( "cropping portrait at : " + str( Vector2( column, row ) ) )
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



var dict_filepath = ""
var dict_filename = ""

var current_dict = { }
var dict_chr = { }
var dict_cfg = {}
var dict_template = {
	"_CONFIG"		:	{
		"portrait_size_grid": [ 1, 1 ],
		"portrait_size_px": [ 32, 32 ],
		"use_custom_color": false,
		"use_custom_speed": false,
		"use_portraits": false
	},
	"characters"	:	{
		"label": " ",
		"_BLANK": {
		"color": [ 0, 0, 0 ],
		"expressions": {
			"_empty": [ -1, -1 ]
			}
		}
	}
}
func set_dict_properties():
	glbl.dict_chr = glbl.current_dict.characters
	glbl.dict_cfg = glbl.current_dict._CONFIG
func save_dict_properties( save_file = false ):
	glbl.current_dict.characters = glbl.dict_chr
	glbl.current_dict._CONFIG = glbl.dict_cfg
	if !save_file:
		glbl.main_app.emit_signal( "hint_reloading" )
		var DictSave = File.new()
		print( "Saving dictionary : " + str( glbl.dict_filepath ) )
		DictSave.open( glbl.dict_filepath, File.WRITE )
		DictSave.store_string( var2str( glbl.current_dict ) )
		DictSave.close()


var line_length = 5

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
	print( "on glbl.get_default_lines()" )
	return [
		glbl.dict_chr.keys()[ 0 ],
		glbl.dict_chr[ glbl.dict_chr.keys()[0] ]["expressions"].keys()[0],
		"",
		true,
		1.0
		]

var main_app
var panel_dictionary
var panel_sets_list
var panel_set_editor


var set_crawler
var set_crawler_popup


func _ready():
	glbl.read_settings()



