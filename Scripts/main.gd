extends Node2D

@export var mob_scenes: Array[PackedScene] = []
@export var opening_sounds: Array[AudioStream] = []

@export var kills: Array[AudioStream] = []

@export var deaths: Array[AudioStream] = []


var score
var isAudioFinished = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$AudioCooldown.one_shot = true
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$GeneralAudio.stop();
	$GeneralAudio.stream = opening_sounds[randi() % opening_sounds.size()]
	$GeneralAudio.play();

func on_hit():
	if(isAudioFinished):#$AudioCooldown.is_stopped()):
		var nextAudio = kills[randi() % kills.size()]
		$GeneralAudio.stream = nextAudio
		$GeneralAudio.play();
		#$AudioCooldown.set_wait_time = nextAudio.get_length()
		#$AudioCooldown.start()
		isAudioFinished = false;
	score += 1
	$HUD.update_score(score)

func on_death():
	$GeneralAudio.stop();
	$GeneralAudio.stream = deaths[randi() % deaths.size()]
	$GeneralAudio.play();

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scenes[int(randf_range(0,3))].instantiate()

	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	var direction = $Player.global_position - mob.global_position

	mob.position = mob_spawn_location.position

	add_child(mob)


func _on_general_audio_finished():
	isAudioFinished = true
