# Treasure Hunt Coin Game Implementation Documentation

# Endrit Ambari 211541

## Overview
This document explains the implementation of a 3D treasure collection game where players must gather coins within a time limit.

## Core Systems

### 1. Player Movement & Controls (`sophie_character_controller.gd`)
- Movement using WASD/Arrow keys
- Camera control with mouse
- Physics-based movement with acceleration and gravity
- Jumping mechanics
- Collision detection for coin collection

### 2. Game Management (`game_manager.gd`)
#### Timer System
```gdscript
@export var game_time := 120  # 2 minutes
var time_remaining: float

func _ready() -> void:
    timer.connect("timeout", Callable(self, "_on_game_timer_timeout"))
    timer.wait_time = game_time
    timer.start()
```
- Timer counts down from 120 seconds
- Updates UI every frame
- Triggers game over when time runs out

#### Score System
```gdscript
@export var total_treasures := 40
var collected_treasures := 0

func _on_area_3d_area_entered(area: Area3D) -> void:
    if area.is_in_group("coin"):
        collected_treasures += 1
        coin_label.text = "Coin Count: " + str(collected_treasures) + "/" + str(total_treasures)
```
- Tracks collected coins
- Updates UI counter
- Triggers win condition when all coins collected

### 3. Audio System
Audio is managed through AudioStreamPlayer nodes:
- Background Music: Loops continuously during gameplay
- Coin Collection Sound: Plays when collecting coins
- Win/Lose Sounds: Play at game end
```gdscript
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var coin_sound: AudioStreamPlayer = $CoinSound
@onready var win_sound: AudioStreamPlayer = $WinSound
@onready var lose_sound: AudioStreamPlayer = $LoseSound
```

### 4. UI System
Game state information displayed through:
- Timer Label: Shows remaining time
- Coin Counter: Shows collected/total coins
- Game Over Panel: Displays win/lose message
```gdscript
func end_game(victory: bool) -> void:
    timer.stop()
    game_over_panel.show()
    result_label.text = "You Won!" if victory else "You Lost!"
```

### 5. Scene Reset
```gdscript
func _on_restart_button_pressed() -> void:
    get_tree().paused = false
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    get_tree().reload_current_scene()
```
- Resets game state when restart button pressed
- Reloads current scene
- Resets mouse capture for gameplay

## Game Flow
1. Game starts with timer countdown
2. Player moves and collects coins
3. Game ends when either:
   - All coins are collected (Win)
   - Timer runs out (Lose)
4. End screen displays with restart option

# Node Structure

- Node
  - WorldEnvironment
  - Sun
  - Level
    - Grass
    - terrain
    - Water
    - tree_trunk_small
    - tree_trunk_small2
    - tree_trunk_small3
    - tree_trunk_long
    - Trees
    - Bushes
    - Coins
    - GameManager
    - CoinLabel
    - coin
    - SophieCharacterController
      - StepSounds
      - CapsuleCollisionShape
      - RayCollisionShape
      - CameraController
        - CameraSpringArm
          - CameraThirdPersonPivot
        - PlayerCamera
          - CameraRayCast
        - GroundShapeCast
        - CharacterRotationRoot
          - CharacterSkin
        - FloorSlideParticles
        - Area3D
          - CollisionShape3D

- GameManager
  - TimerLabel
  - GameTimer
  - GameOverPanel
    - ResultLabel
    - RestartButton
  - BackgroundMusic
  - CoinSound
  - WinSound
  - LoseSound

- coin
  - CollisionShape3D
  - coin

## Setup Instructions
1. Set game duration via `game_time` export variable
2. Set total coins via `total_treasures` export variable
3. Add audio files to respective AudioStreamPlayer nodes
4. Place coins in scene and add to "coin" group
5. Configure UI element positions in scene tree

## Notes
- All coins must be in "coin" group for collection detection
- GameOverPanel process mode must be "Always" to work while paused
- Audio files should be properly imported with correct loop settings

## Video
-	I’ve attached a video of the gameplay where in the first part I show the win scenario and in the second part with a speed of 4x I show the lose scenario.
