extends Camera3D
class_name CameraController

func rotate_me(mouse_movement: Vector2, sensitivity: float):
    rotate_x(-mouse_movement.y * sensitivity)
    rotation.x = clamp(rotation.x, -1.4, 1.2)
