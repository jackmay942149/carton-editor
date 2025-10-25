package scripts

import ctn "../../the-carton"
import la "core:math/linalg"
import log "core:log"

@(private="file")
speed : f32 = 0.1
@(private="file")
rot_speed: f32 = 0.001

camera_update :: proc(this: ^ctn.Camera) {
	assert(this != nil)

	if ctn.is_key_down(.LEFT_ALT) {
		if ctn.is_key_down(.W) {
			this.position -= speed * ctn.camera_get_directon(this)
			this.look_at_position -= speed * ctn.camera_get_directon(this)
		}
		if ctn.is_key_down(.S) {
			this.position += speed * ctn.camera_get_directon(this)
			this.look_at_position += speed * ctn.camera_get_directon(this)
		}
		if ctn.is_key_down(.A) {
			this.position -= speed * ctn.camera_get_right_vec(this)
			this.look_at_position -= speed * ctn.camera_get_right_vec(this)
		}
		if ctn.is_key_down(.D) {
			this.position += speed * ctn.camera_get_right_vec(this)
			this.look_at_position += speed * ctn.camera_get_right_vec(this)
		}
		if ctn.is_mouse_down(.LEFT) {
			rotate_camera_around_point(this)
		}
		if ctn.is_mouse_down(.MIDDLE) {
			pan_camera(this)
		}
		zoom_camera(this)
	}

	if ctn.is_key_down(.ESCAPE) {
		ctn.close_window()
	}
}

@(private="file")
zoom_camera :: proc(this: ^ctn.Camera) {
	// Move in the direction of the camera by the input on 10 divide distance
	direction := la.normalize(ctn.camera_get_directon(this))
	distance := la.distance(this.position, this.look_at_position)
	_, input := ctn.get_scroll_input()
	assert(ctn.g_scroll_input.y == 0)
	this.position -= direction * distance * (input / 10)
}

@(private="file")
rotate_camera_around_point :: proc(this: ^ctn.Camera) {
	assert(this != nil)

	mouse_input: [2]f64
	mouse_input.x, mouse_input.y = ctn.get_mouse_delta()

	this.position = ctn.rotate_point_around_pivot(this.position, this.look_at_position, ctn.camera_get_up_vec(this), f32(-mouse_input.x) * rot_speed)
	this.position = ctn.rotate_point_around_pivot(this.position, this.look_at_position, ctn.camera_get_right_vec(this), f32(-mouse_input.y) * rot_speed)
}

@(private="file")
pan_camera :: proc(this: ^ctn.Camera) {
	mouse_input: [2]f64
	mouse_input.x, mouse_input.y = ctn.get_mouse_delta()

	this.position += speed * f32(mouse_input.x) * ctn.camera_get_right_vec(this)
	this.look_at_position += speed * f32(mouse_input.x) * ctn.camera_get_right_vec(this)
	this.position += speed * f32(-mouse_input.y) * ctn.camera_get_up_vec(this)
	this.look_at_position += speed * f32(-mouse_input.y) * ctn.camera_get_up_vec(this)
}
