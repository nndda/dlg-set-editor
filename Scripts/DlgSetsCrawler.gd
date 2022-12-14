extends Node

export(NodePath) var sets_container

#var logged_target : PoolStringArray
var logged_result : PoolStringArray

func replace_property(
	target_set : Array,
	index_n : int,
	prev_property,
	property
	):


	var prev_prop_set
	var prev_prop = property


	if target_set.size() >= 1:
		for dlg_line in target_set.size():
			target_set[ dlg_line ][ index_n ] = property


func _look_for( 
	index_n : int,
	property : String
#	property_name = ""
	):


	for dlg_set in get_node(sets_container).get_children():
		print( dlg_set.get_name() )
		var file_path = dlg_set.file_path
		var file_name = dlg_set.file_name
		var raw_array = dlg_set.raw_array

		print( file_path )
		print( file_name )
		print( raw_array )

		for idx in raw_array.size():
			if str( raw_array[ idx * index_n ] ) == property:
				logged_result.append( file_path )
				logged_result.append( file_name )
				logged_result.append( str( idx * index_n ) )
				logged_result.append( str( raw_array[ idx + index_n ] ) )

		print( logged_result )

	return logged_result
