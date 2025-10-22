package scripts

import ctn "../../the-carton"
import la "core:math/linalg"

@(private="file")
speed : f32 = 1
rot_speed: f32 = 0.1

camera_update :: proc(this: ^ctn.Camera) {
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
		if ctn.is_key_down(.E) {
			local_pos := this.position - this.look_at_position
			rot_mat := la.matrix4_rotate_f32(rot_speed, {0, 1, 0})
			rotated_pos := rot_mat * [4]f32{local_pos.x, local_pos.y, local_pos.z, 1.0}
			new_pos := rotated_pos + [4]f32{this.look_at_position.x, this.look_at_position.y, this.look_at_position.z, 1.0}
			this.position = new_pos.xyz
		}
	}
}
