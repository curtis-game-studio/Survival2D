extends Node
class_name AudioManager

var registry: AudioRegistry = null
var looping_positional_players: Dictionary = {}  # key: event_name, value: AudioStreamPlayer2D
var ambience_layers: Dictionary = {}
var fade_speed: float = 1.0

func _ready() -> void:
	var root = get_tree().get_current_scene()
	if root == null:
		push_warning("⚠️ No current scene loaded")
		return

	registry = _find_node_recursive(root, "AudioRegistry")
	if registry == null:
		push_warning("⚠️ AudioRegistry node not found in the current scene")

# Recursive helper to find a node by name anywhere in the tree
func _find_node_recursive(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	for child in node.get_children():
		if child is Node:
			var found = _find_node_recursive(child, target_name)
			if found != null:
				return found
	return null

# Helper: get a random stream from SoundEvent, duplicated if looping
func _get_stream(event: SoundEvent, looping: bool = false) -> AudioStream:
	if event.streams.size() == 0:
		return null
	var stream = event.streams[randi() % event.streams.size()]
	if looping:
		stream = stream.duplicate()
		stream.loop = event.loop
	return stream

# Helper: setup AudioStreamPlayer or AudioStreamPlayer2D
func _create_player(event: SoundEvent, stream: AudioStream, positional: bool = false, position: Vector2 = Vector2.ZERO) -> Node:
	var player = AudioStreamPlayer2D.new() if positional else AudioStreamPlayer.new()
	player.stream = stream
	player.bus = event.type
	player.volume_db = event.volume_db
	if positional:
		player.max_distance = event.max_distance
		player.attenuation = event.attenuation
		player.global_position = position
	add_child(player)
	return player

func play_sound2D(event_name: String) -> void:
	if registry == null:
		push_warning("⚠️ AudioRegistry is not set")
		return

	var event = registry.get_event(event_name)
	if event == null:
		push_warning("❌ SoundEvent not found: %s" % event_name)
		return

	var stream = _get_stream(event)
	if stream == null:
		push_warning("❌ No streams in SoundEvent: %s" % event_name)
		return

	var player = _create_player(event, stream, false)
	player.play()
	player.finished.connect(player.queue_free)

func play_sound2D_positional(event_name: String, position: Vector2) -> void:
	if registry == null:
		push_warning("⚠️ AudioRegistry is not set")
		return

	var event = registry.get_event(event_name)
	if event == null:
		push_warning("❌ SoundEvent not found: %s" % event_name)
		return

	var stream = _get_stream(event)
	if stream == null:
		push_warning("❌ No streams in SoundEvent: %s" % event_name)
		return

	var player = _create_player(event, stream, true, position)
	player.play()

	# Cleanup once finished using Timer
	var cleanup_timer = Timer.new()
	cleanup_timer.one_shot = true
	cleanup_timer.wait_time = stream.get_length()
	cleanup_timer.timeout.connect(player.queue_free)
	player.add_child(cleanup_timer)
	cleanup_timer.start()

func play_sound2D_loop(event_name: String) -> AudioStreamPlayer:
	if registry == null:
		push_warning("⚠️ AudioRegistry is not set")
		return null

	var event = registry.get_event(event_name)
	if event == null or event.streams.size() == 0:
		push_warning("❌ SoundEvent not found or empty: %s" % event_name)
		return null

	var stream = _get_stream(event, true)
	var player = _create_player(event, stream, false)
	player.play()
	return player

func play_sound2D_loop_positional(event_name: String, position: Vector2) -> AudioStreamPlayer2D:
	if registry == null:
		push_warning("⚠️ AudioRegistry is not set")
		return null

	var event = registry.get_event(event_name)
	if event == null or event.streams.size() == 0:
		push_warning("❌ SoundEvent not found or empty: %s" % event_name)
		return null

	var stream = _get_stream(event, true)
	var player = _create_player(event, stream, true, position)
	player.play()

	looping_positional_players[event_name] = player
	return player

func stop_sound2D_loop_positional(event_name: String) -> void:
	if looping_positional_players.has(event_name):
		var player = looping_positional_players[event_name]
		player.stop()
		player.queue_free()
		looping_positional_players.erase(event_name)

func stop_all_sound2D_loop_positionals() -> void:
	for player in looping_positional_players.values():
		player.stop()
		player.queue_free()
	looping_positional_players.clear()

func play_ambience2D(event_name: String, fade_in_time: float = 1.5) -> void:
	if registry == null:
		push_warning("⚠️ AudioRegistry is not set")
		return

	if ambience_layers.has(event_name):
		return  # Already playing

	var event = registry.get_event(event_name)
	if event == null or event.streams.size() == 0:
		push_warning("❌ Ambience event not found or empty: %s" % event_name)
		return

	var stream = _get_stream(event, true)
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.bus = event.type
	player.volume_db = -80.0
	add_child(player)
	player.play()

	ambience_layers[event_name] = player

	var tween = create_tween()
	tween.tween_property(player, "volume_db", event.volume_db, fade_in_time)

func stop_ambience2D(event_name: String, fade_out_time: float = 1.5) -> void:
	if not ambience_layers.has(event_name):
		return

	var player: AudioStreamPlayer = ambience_layers[event_name]

	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, fade_out_time)
	tween.tween_callback(Callable(player, "stop"))
	tween.tween_callback(Callable(player, "queue_free"))
	tween.tween_callback(func() -> void:
		ambience_layers.erase(event_name)
	)

func stop_all_ambience2D(fade_out_time: float = 1.5) -> void:
	for name in ambience_layers.keys():
		stop_ambience2D(name, fade_out_time)
