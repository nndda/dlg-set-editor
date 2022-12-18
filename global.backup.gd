extends Timer

func get_timestamp():
	return Time.get_datetime_string_from_datetime_dict( 
		Time.get_datetime_dict_from_system(), false )

func create_backup_dir():
	var backup_dir = File.new()
	backup_dir.open( "user://BACKUP-DICT.", File.WRITE )
