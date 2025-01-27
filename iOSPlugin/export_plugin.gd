@tool
extends EditorPlugin

# A class member to hold the editor export plugin during its lifecycle.
var _plugin_name = "iOSPlugin"
var _autoload_name = "iOSPluginSingleton"
var autoload_dest = "res://addons/iOSPlugin/iOSPluginSingleton.gd"


func _enter_tree():
	# Initialization of the plugin goes here.
	add_autoload_singleton(_autoload_name, autoload_dest)


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton(_autoload_name)


