extends CanvasLayer

@onready var reticle_sprite = $Center/ReticleSprite if has_node("Center/ReticleSprite") else null
@onready var progress_ring = $Center/ProgressRing if has_node("Center/ProgressRing") else null

enum State { IDLE, HOVER, DWELL }
var current_state = State.IDLE

func _ready():
	reset()

func set_progress(value: float):
	if value > 0.0:
		current_state = State.DWELL
		if progress_ring:
			progress_ring.value = value * 100
			progress_ring.visible = true
	else:
		current_state = State.IDLE
		if progress_ring:
			progress_ring.visible = false

func set_hover(active: bool):
	if active:
		current_state = State.HOVER
		if reticle_sprite:
			reticle_sprite.scale = Vector2(1.5, 1.5)
	else:
		current_state = State.IDLE
		if reticle_sprite:
			reticle_sprite.scale = Vector2(1.0, 1.0)

func reset():
	current_state = State.IDLE
	if progress_ring:
		progress_ring.value = 0
		progress_ring.visible = false
	if reticle_sprite:
		reticle_sprite.scale = Vector2(1.0, 1.0)
