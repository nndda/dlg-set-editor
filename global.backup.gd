extends Timer

var backup_system_dir = "user://backups"

func _ready():
	initialize_backup_dir()

func initialize_backup_dir():
	var backup_init = Directory.new()
	if !backup_init.dir_exists( "user://backups" ):
		if backup_init.make_dir( "user://backups" ) == OK:
			backup_system_dir = "user://backups"
		else:
			push_warning( "Unable to create backup folder" )


func get_timestamp():
	return str( "" +
		Time.get_date_string_from_system() + " " +
		str( Time.get_time_dict_from_system().hour ) + "." +
		str( Time.get_time_dict_from_system().minute ) + "." +
		str( Time.get_time_dict_from_system().second ) + " ")

func makefile( target_dir, file_name, vars : String ):

	var dict_copy = File.new()
	print("# Creating backup at: " + str(target_dir + "/" + glbl.backups.get_timestamp() + file_name))
	dict_copy.open( target_dir + "/" + glbl.backups.get_timestamp() + file_name, File.WRITE )

	dict_copy.store_string( vars )
	dict_copy.close()


func copy_dict():

	var dictionary_filename = glbl.get_res_filename( glbl.dict_filepath )
	var backup_dir		= Directory.new()

	if !backup_dir.dir_exists( glbl.backups.backup_system_dir ):
		print("# Backup dir on: " + backup_system_dir + "/" + dictionary_filename )
		if backup_dir.make_dir( backup_system_dir + "/" + dictionary_filename ) != OK:
			push_warning( "Unable to create backup" )

		else:
			glbl.backups.makefile(
				backup_system_dir + "/" + dictionary_filename,
				dictionary_filename,
				var2str( { "characters" : glbl.dict_chr, "_CONFIG" : glbl.dict_cfg } )
				)
	else:
		glbl.backups.makefile(
			backup_system_dir + "/" + dictionary_filename,
			dictionary_filename,
			var2str( { "characters" : glbl.dict_chr, "_CONFIG" : glbl.dict_cfg } )
			)


#func copy_portrait( portrait_filename : String ):
#
#	portrait_filename	= glbl.get_res_filename( glbl.portrait_filepath )
#	var backup_dir		= Directory.new()
#	var target_dir		= backup_system_dir + "/" + glbl.get_res_filename( glbl.portrait_filepath )
#
#	if !backup_dir.dir_exists( glbl.backups.backup_system_dir ):
#		if !backup_dir.dir_exists( target_dir ):
#			push_warning( "Unable to create backup: missing directory" )
#
#		else:
#			glbl.backups.makefile(
#				target_dir + "/" + portrait_filename,
#				portrait_filename,
#				glbl.current_portrait
#				)
#	else:
#		glbl.backups.makefile(
#			target_dir + "/" + portrait_filename,
#			portrait_filename,
#			glbl.current_portrait
#			)


func copy_set( set_filename, content : String ):

	var backup_dir		= Directory.new()
	var target_dir		= backup_system_dir + "/" + set_filename

	if !backup_dir.dir_exists( glbl.backups.backup_system_dir ):
		if backup_dir.make_dir( target_dir ) != OK:
			push_warning( "Unable to create backup: missing directory" )

		else:
			glbl.backups.makefile(
				target_dir + "/" + set_filename,
				set_filename,
				content
				)
	else:
		glbl.backups.makefile(
			target_dir + "/" + set_filename,
			set_filename,
			content
			)
