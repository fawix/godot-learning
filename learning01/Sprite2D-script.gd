# GDScript is an indent-based language.
# Every GDScript file is implicitly a class

# defines the class this script inherits or extends
extends Sprite2D 
# our script will get access to all the properties  and functions of the Sprite2D node, including 
# classes it extends, like Node2D, CanvasItem, and Node.

signal health_depleted
signal health_changed(old_value, new_value)

var health = 10

# Member variables
# Every node instance with this script attached to it will have its own copy of these properties
var speed = 400
var angular_speed = PI # Angles in Godot work in radians by default
# but there are built-in functions and properties available to calculate angles in degrees instead.


# This is a special name for our class's constructor.
# The engine calls _init() on every object or  node upon creating it in memory
func _init():
	print("Hello, from init")

func _ready():
	print("Hello from ready!")
	var timer = get_node("Timer") # get a reference to Timer
	timer.timeout.connect(_on_timer_timeout) # define a callback on timeout
	
	
# This is virtual function of the Node class
# Godot will call the function every frame and pass it an argument named delta, the time elapsed 
# since the last frame.
#func _process(delta): # control loop
	#var direction = 0
	#if Input.is_action_pressed("ui_left"): # Input is a singleton with key press events
		#direction = -1
	#if Input.is_action_pressed("ui_right"):
		#direction = 1
	## rotation is a property inherited from the Node2D class
	## It controls the rotation of our node and works with radians.
	#rotation += angular_speed * direction * delta
	#
	## The position itself is of type Vector2, a built-in type in Godot representing a 2D vector.
	#var velocity = Vector2.ZERO
	#if Input.is_action_pressed("ui_up"):
		#velocity = Vector2.UP.rotated(rotation) * speed
		#
	#position += velocity * delta
	## Moving a node like that does not take into account colliding with walls or the floor.
	
func _process(delta):
	rotation += angular_speed * delta
	var velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta
	
# The engine and game developers do their best to update the game world and render images at a 
# constant time interval, but there are always small variations in frame render times. That's why
# the engine provides us with this delta time value, making our motion independent of our framerate.

# This is a callback for a signal; it connects the button pressed event of Button to the Sprite2D
func _on_button_pressed():
	set_process(not is_processing()) # toggles processing

# By convention, we name these callback methods in GDScript as "_on_node_name_signal_name" 
func _on_timer_timeout():
	visible = not visible 
	
# Any node in Godot emits signals when something specific happens to them
func take_damage(amount):
	var old_health = health
	health -= amount
	health_changed.emit(old_health, health)
	if health <= 0:
		health_depleted.emit()

