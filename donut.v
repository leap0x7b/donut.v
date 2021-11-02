module main

import term
import math
import time { sleep }

fn render_donut(a f64, b f64) {
	columns, lines := term.get_terminal_size()

	theta_spacing, phi_spacing := 0.07, 0.02

	r1, r2, k2 := 1, 2, 5
	k1 := columns * k2 * 3 / (20 * (r1 + r2))

	cos_a, sin_a := math.cos(a), math.sin(a)
	cos_b, sin_b := math.cos(b), math.sin(b)

	mut output := [][]string{len: columns, init: []string{len: lines, init: ' '}}
	mut z_buffer := [][]f64{len: columns, init: []f64{len: lines, init: 0}}

	for theta := f64(0); theta < 2 * math.pi; theta += theta_spacing {
		cos_theta, sin_theta := math.cos(theta), math.sin(theta)

		for phi := f64(0); phi < 2 * math.pi; phi += phi_spacing {
			cos_phi, sin_phi := math.cos(phi), math.sin(phi)

			circle_x, circle_y := r2 + r1 * cos_theta, r1 * sin_theta
			x := circle_x * (cos_b * cos_phi + sin_a * sin_b * sin_phi) - circle_y * cos_a * sin_b
			y := circle_x * (sin_b * cos_phi - sin_a * cos_b * sin_phi) + circle_y * cos_a * cos_b
			z := k2 + cos_a * circle_x * sin_phi + circle_y * sin_a
			ooz := 1 / z

			xp := int(columns / 2 + k1 * ooz * x)
			yp := int(lines / 2 - k1 * ooz * y)

			l := cos_phi * cos_theta * sin_b - cos_a * cos_theta * sin_phi - sin_a * sin_theta +
				cos_b * (cos_a * sin_theta - cos_theta * sin_a * sin_phi)

			if l > 0 {
				if xp < 0 || yp < 0 || xp >= columns || yp >= lines {
					continue
				}
				if ooz > z_buffer[int(xp)][int(yp)] {
					z_buffer[xp][yp] = ooz
					luminance_index := int(l * 8)
					output[xp][yp] = '.,-~:;=!*#$@'[luminance_index].ascii_str()
				}
			}
		}
	}
	print('\x1b[H')
	for j := 0; j < lines; j++ {
		for i := 0; i < columns; i++ {
			print(output[int(i)][int(j)])
		}
		println('')
	}
}

fn main() {
	mut a, mut b := f64(0), f64(0)
	for {
		render_donut(a, b)
		a += 0.07
		b += 0.03
		sleep(15000)
	}
}
