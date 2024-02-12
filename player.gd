extends Area2D
signal hit
signal score

@export var speed = 400
var screen_size

@onready var hitTreeSound = $Hit

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1

	rotation = 0
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "down"
		if velocity.x > 0:
			rotation = -PI/4
		elif velocity.x < 0:
			rotation = PI/4
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "down"
		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body):
	hitTreeSound.play()
	print(get_node("Scoring/ScoringShape2D") == body)
	print(body.name)
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_scoring_body_entered(body):
	score.emit()
