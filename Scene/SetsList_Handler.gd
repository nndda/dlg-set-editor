extends Control



func switch_set( set_name : String, set_path : String, set_array : Array ):
	print( " Switching to :  " + set_name )

	glbl.current_set = set_array

	glbl.current_set_filename = set_name
	glbl.current_set_fullpath = set_path

	get_parent().get_parent().get_parent().get_node("Sets_Dict/DlgEditorPanel/ArraySetEditor").load_set()


func add_set( file_name : String, raw_array : Array ):
	var btn_req = Button.new()

	btn_req.toggle_mode = true
	btn_req.text = glbl.get_res_filename( file_name )
	btn_req.align = Button.ALIGN_LEFT

	btn_req.set_script( load( "res://Scene/SetItem_.gd" ) )

	btn_req.file_path = file_name
	btn_req.file_name = glbl.get_res_filename( file_name )
	btn_req.raw_array = raw_array
	
	btn_req.set_button_group( load("res://Scene/Group/SetList_Group.tres") )

	btn_req.connect(
#		"toggled", self, "switch_set",
		"pressed", self, "switch_set",
		[ btn_req.file_name, btn_req.file_path, btn_req.raw_array ] )

	self.add_child( btn_req )
	btn_req.pressed = true
	btn_req.emit_signal("pressed")
#	btn_req.emit_signal( "toggled", true )

func _process(_delta):
	for btn_chd in self.get_children():
		if btn_chd is Button:
			btn_chd.disabled = btn_chd.pressed


onready var filewindow_node = get_parent().get_parent().get_parent().get_parent().get_node("NewSet")
onready var log_node = get_parent().get_parent().get_parent().get_node("Sets_Dict/DlgEditorPanel/ArraySetEditor/Editor/Hints/Log")

func log_start(message :String):
#	log_node.add_text( message )
	log_node.append_bbcode( message )
	log_node.newline()

var log_msg = {
#	"set_empty"					: "[color=#ff0000]Failed to parse set:[/color] Empty set",
	"set_invalid"				: "[color=#ff0000]Failed to load file:[/color] Invalid dialogue set",

#	"set_blank_expr"		: "[color=#ff0000]Failed to parse dict.:[/color] Blank \"expression\" key on actor \"",
}

func verify_set( target, file_path ):
	var passes = 0
	print("")
	print("")
	print("target:")
	print(target)
	var target_parsed = str2var( target.get_as_text() )
	print("target_parsed:")
	print(target_parsed)
	
	if target_parsed is Array:
		print("target_parsed.size:")
		print(target_parsed.size())
		if target_parsed.size() == 0:
			pass
		elif ( target_parsed.size() / 4 ) is int:
			pass
		else:
			passes += 1
			log_start( log_msg.set_invalid )
	else:
		passes += 1
		log_start( log_msg.set_invalid )
	print("passes:")
	print(passes)
	if passes == 0:
		print("========= Adding Set")
		add_set(
			file_path,
#			Array( str2var( target.get_as_text() ) ) )
			Array( target_parsed ) )


func new_set_file(path):
	var file_add = File.new()

	if filewindow_node.get_mode() == FileDialog.MODE_SAVE_FILE:
		file_add.open( path, File.WRITE )
		file_add.store_string( var2str(
			get_parent().get_parent().get_parent().get_node("Sets_Dict/DlgEditorPanel/ArraySetEditor").default_lines
			) )
		file_add.close()

		file_add.open( path, File.READ )
		verify_set( file_add, path )

	elif filewindow_node.get_mode() == FileDialog.MODE_OPEN_FILE:
		file_add.open( path, File.READ )
		verify_set( file_add, path )

	file_add.close()



func _on_Create_pressed():
	get_parent().get_parent().get_parent().get_parent().get_node("DimBG").visible = true
	filewindow_node.set_mode( FileDialog.MODE_SAVE_FILE )
	filewindow_node.set_title( "Create new set" )
	filewindow_node.popup_centered()

func _on_Browse_pressed():
	get_parent().get_parent().get_parent().get_parent().get_node("DimBG").visible = true
	filewindow_node.set_mode( FileDialog.MODE_OPEN_FILE )
	filewindow_node.set_title( "Load new set" )
	filewindow_node.popup_centered()
