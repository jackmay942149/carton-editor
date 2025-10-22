package scripts

import ctn "../../the-carton"
import la "core:math/linalg"

@(private="file")
speed : f32 = 0.1

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
	}
}
