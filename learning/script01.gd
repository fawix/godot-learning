# Every GDScript file is implicitly a class

# defines the class this script inherits or 
# extends
extends Sprite2D 
# our script will get access to all the properties
# and functions of the Sprite2D node, including 
# classes it extends, like Node2D, CanvasItem, 
# and Node.



# This is a special name for our class's constructor.
# The engine calls _init() on every object or 
# node upon creating it in memory
func _init():
	print("Hello, world!")

# GDScript is an indent-based language.
