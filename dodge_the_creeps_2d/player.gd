extends Area2D

signal hit

# Using the export keyword on the first variable speed allows us to set its value in the Inspector.
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var sprite_size # Size or character sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size #- Vector2(100,100)
	
	# Get the SpriteFrames component of your AnimatedSprite2D node:
	var sprite_frames = $AnimatedSprite2D.sprite_frames
	# Get the first texture of the wanted animation
	var texture = sprite_frames.get_frame_texture("walk", 0)
	# Get frame size:
	var texture_size = texture.get_size()
	# multiply by the scale to get the actual size (in case you changed the scale)
	sprite_size = texture_size * $AnimatedSprite2D.get_scale()
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		# $ returns the node at the relative path
		
	position += velocity * delta
	
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	position = position.clamp(sprite_size / 2, screen_size - sprite_size / 2)


func _on_body_entered(_body):
	hide()
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	# Disabling the area's collision shape can cause an error if it happens in the middle of the 
	# engine's collision processing. Using set_deferred() tells Godot to wait to disable the shape 
	# until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
