extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hover_animation_player: AnimationPlayer = $HoverAnimationPlayer
var disabled: bool = false


func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")


func play_discard():
	animation_player.play("discard")


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func select_card():
	disabled = true
	animation_player.play("selected")
	var other_cards = get_tree().get_nodes_in_group("upgrade_card")

	for card in other_cards:
		if card == self: continue
		card.play_discard()

	await animation_player.animation_finished
	selected.emit()


func on_gui_input(event: InputEvent):
	if disabled: return
	if event.is_action_pressed("left_click"): select_card()


func on_mouse_entered():
	if disabled: return
	hover_animation_player.play("hover")


func on_mouse_exited():
	if disabled: return
	hover_animation_player.stop()
	scale = Vector2(1, 1)
