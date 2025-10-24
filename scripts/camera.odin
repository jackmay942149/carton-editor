package scripts

import ctn "../../the-carton"
import la "core:math/linalg"
import log "core:log"

@(private="file")
speed : f32 = 1
@(private="file")
rot_speed: f32 = 0.001

camera_update :: proc(this: ^ctn.Camera) {
	assert(this != nil)

	if ctn.is_key_down(.LEFT_ALT) {
		if ctn.is_key_down(.W) {
			this.position -= speed * la.normalize(ctn.camera_get_directon(this))
			this.look_at_position -= speed * la.normalize(ctn.camera_get_directon(this))
		}
		if ctn.is_key_down(.S) {
			this.position += speed * la.normalize(ctn.camera_get_directon(this))
			this.look_at_position += speed * la.normalize(ctn.camera_get_directon(this))
		}
		if ctn.is_key_down(.A) {
			this.position -= speed * la.normalize(ctn.camera_get_right_vec(this))
			this.look_at_position -= speed * la.normalize(ctn.camera_get_right_vec(this))
		}
		if ctn.is_key_down(.D) {
			this.position += speed * la.normalize(ctn.camera_get_right_vec(this))
			this.look_at_position += speed * la.normalize(ctn.camera_get_right_vec(this))
		}
		rotate_camera_around_point(this)
		zoom_camera(this)
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

	local_pos := this.position - this.look_at_position
	rot_mat := la.matrix4_rotate_f32(f32(mouse_input.x) * rot_speed, la.normalize(ctn.camera_get_up_vec(this)))
	rotated_pos := rot_mat * [4]f32{local_pos.x, local_pos.y, local_pos.z, 1.0}
	new_pos := rotated_pos + [4]f32{this.look_at_position.x, this.look_at_position.y, this.look_at_position.z, 1.0}
	this.position = new_pos.xyz

	local_pos = this.position - this.look_at_position
	rot_mat = la.matrix4_rotate_f32(f32(-mouse_input.y) * rot_speed, la.normalize(ctn.camera_get_right_vec(this)))
	rotated_pos = rot_mat * [4]f32{local_pos.x, local_pos.y, local_pos.z, 1.0}
	new_pos = rotated_pos + [4]f32{this.look_at_position.x, this.look_at_position.y, this.look_at_position.z, 1.0}
	this.position = new_pos.xyz
}
