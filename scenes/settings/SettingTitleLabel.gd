@tool
extends Label

func _enter_tree():
	var parent = get_parent()
	
	if not parent.is_node_ready():
		await parent.ready

	print_debug("parent is ", parent, " and its title is ", parent.title)
	
	text = parent.title
