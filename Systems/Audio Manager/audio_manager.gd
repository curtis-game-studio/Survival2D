extends Node
class_name AudioManager

var registry: AudioRegistry = null
var looping_positional_players := {}  # key: String (event_name), value: AudioStreamPlayer2D
var ambience_layers := {}
var fade_speed := 1.0

func _ready():
	
	registry = get_tree().get_root().find_child("AudioRegistry", true, false)

	if registry == null:
		print("⚠️ AudioRegistry is not set")
		return

func play_sound2D(event_name: String):
	var event := registry.get_event(event_name)
	if event == null:
		print("❌ SoundEvent not found: ", event_name)
		return

	if event.streams.is_empty():
		print("❌ No streams in SoundEvent: ", event_name)
		return

	var stream := event.streams[randi() % event.streams.size()]

	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = event.type
	player.volume_db = event.volume_db
	add_child(player)
	player.play()

	player.finished.connect(player.queue_free)

func play_sound2D_positional(event_name: String, position: Vector2):
	if registry == null:
		print("⚠️ AudioRegistry is not set")
		return

	var event := registry.get_event(event_name)
	if event == null:
		print("❌ SoundEvent not found: ", event_name)
		return

	if event.streams.is_empty():
		print("❌ No streams in SoundEvent: ", event_name)
		return

	var stream := event.streams[randi() % event.streams.size()]

	var player := AudioStreamPlayer2D.new()
	player.stream = stream
	player.bus = event.type
	player.volume_db = event.volume_db
	player.max_distance = event.max_distance
	player.attenuation = event.attenuation
	player.global_position = position
	add_child(player)

	player.play()

	# Cleanup once finished

	var cleanup_timer := Timer.new()
	cleanup_timer.one_shot = true
	cleanup_timer.wait_time = stream.get_length()
	cleanup_timer.timeout.connect(player.queue_free)
	player.add_child(cleanup_timer)
	cleanup_timer.start()

func play_sound2D_loop(event_name: String) -> AudioStreamPlayer:
	if registry == null:
		print("⚠️ AudioRegistry is not set")
		return
	
	var event := registry.get_event(event_name)

	if event == null or event.streams.is_empty():
		print("❌ SoundEvent not found or empty: ", event_name)
		return null
	
	var stream := event.streams[randi() % event.streams.size()]
	stream = stream.duplicate()
	stream.loop = event.loop

	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = event.type
	player.volume_db = event.volume_db

	add_child(player)

	player.play()

	return player

func play_sound2D_loop_positional(event_name: String, position: Vector2) -> AudioStreamPlayer2D:
	if registry == null:
		print("⚠️ AudioRegistry is not set")
		return
	
	var event := registry.get_event(event_name)

	if event == null or event.streams.is_empty():
		print("❌ SoundEvent not found or empty: ", event_name)
		return null
	
	var stream := event.streams[randi() % event.streams.size()]
	stream = stream.duplicate()
	stream.loop = event.loop

	var player := AudioStreamPlayer2D.new()
	player.stream = stream
	player.bus = event.type
	player.volume_db = event.volume_db
	player.max_distance = event.max_distance
	player.attenuation = event.attenuation
	add_child(player)
	player.global_position = position
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

func play_ambience2D(event_name: String, fade_in_time := 1.5) -> void:
	if registry == null:
		print("⚠️ AudioRegistry is not set")
		return

	if ambience_layers.has(event_name):
		return  # Already playing

	var event := registry.get_event(event_name)
	if event == null or event.streams.is_empty():
		print("❌ Ambience event not found or empty: ", event_name)
		return

	var stream := event.streams[randi() %  event.streams.size()].duplicate()
	stream.loop = event.loop

	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = event.type
	player.volume_db = -80.0
	add_child(player)
	player.play()

	ambience_layers[event_name] = player

	var tween := create_tween()
	tween.tween_property(player, "volume_db", event.volume_db, fade_in_time)

func stop_ambience2D(event_name: String , fade_out_time := 1.5) -> void:
	if not ambience_layers.has(event_name):
		return

	var player: AudioStreamPlayer = ambience_layers[event_name]

	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, fade_out_time)
	tween.tween_callback(Callable(player, "stop"))
	tween.tween_callback(Callable(player, "queue_free"))
	tween.tween_callback(func(): ambience_layers.erase(event_name))

func stop_all_ambience2D(fade_out_time := 1.5):
	for name in ambience_layers.keys():
		stop_ambience2D(name, fade_out_time)
