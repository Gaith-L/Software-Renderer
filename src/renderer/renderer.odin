package renderer

import "../shapes"
import t "../types"

import "base:runtime"
import "core:fmt"
import "core:math"

import rl "vendor:raylib"

draw_pixel :: proc(buffer: ^t.tPixelBuffer, x, y: int, color: rl.Color) {
	if x >= 0 && x < buffer.width && y >= 0 && y < buffer.height {
		buffer.pixels[y][x] = color
	}
}

draw_flat_top_triangle :: proc(
	buffer: ^t.tPixelBuffer,
	v0, v1, v2: ^rl.Vector3,
	color: rl.Color,
) {
	m0: f32 = (v2.x - v0.x) / (v2.y - v0.y)
	m1: f32 = (v2.x - v1.x) / (v2.y - v1.y)

	y_start := int(math.ceil(v0.y - 0.5))
	y_end := int(math.ceil(v2.y - 0.5))

	for y: int = y_start; y < y_end; y += 1 {
		px0 := m0 * (f32(y) + 0.5 - v0.y) + v0.x
		px1 := m1 * (f32(y) + 0.5 - v1.y) + v1.x

		x_start := int(math.ceil(px0 - 0.5))
		x_end := int(math.ceil(px1 - 0.5))

		for x := x_start; x < x_end; x += 1 {
			draw_pixel(buffer, x, y, color)
		}
	}
}


draw_flat_bottom_triangle :: proc(buffer: ^t.tPixelBuffer, v0, v1, v2: ^rl.Vector3, color: rl.Color) {
	m0: f32 = (v1.x - v0.x) / (v1.y - v0.y)
	m1: f32 = (v2.x - v0.x) / (v2.y - v0.y)

	y_start := int(math.ceil(v0.y - 0.5))
	y_end := int(math.ceil(v2.y - 0.5))

	for y: int = y_start; y < y_end; y += 1 {
		px0 := m0 * (f32(y) + 0.5 - v0.y) + v0.x
		px1 := m1 * (f32(y) + 0.5 - v0.y) + v0.x

		x_start := int(math.ceil(px0 - 0.5))
		x_end := int(math.ceil(px1 - 0.5))

		for x := x_start; x < x_end; x += 1 {
			draw_pixel(buffer, x, y, color)
		}
	}
}


draw_triangle :: proc(buffer: ^t.tPixelBuffer, v0, v1, v2: ^^rl.Vector3, color: rl.Color) {
	if v1^.y < v0^.y {swap_pointers(v0, v1)}
	if v2^.y < v1^.y {swap_pointers(v1, v2)}
	if v1^.y < v0^.y {swap_pointers(v0, v1)}

	// flat top
	if v0^.y == v1^.y {
		if v1^.x < v0^.x {swap_pointers(v0, v1)}
		draw_flat_top_triangle(buffer, v0^, v1^, v2^, color)
	} else if v1^.y == v2^.y {
		// flat bottom
		if v2^.x < v1^.x {swap_pointers(v1, v2)}
		draw_flat_top_triangle(buffer, v0^, v1^, v2^, color)
	} else { 	// general triangle
		alphaSplit := (v1^.y - v0^.y) / (v2^.y - v0^.y)
		vi: rl.Vector3 = v0^^ + (v2^^ - v0^^) * alphaSplit // (^^) double dereference is used here, not sure of the semantics

		if v1^.x < vi.x {
			draw_flat_bottom_triangle(buffer, v0^, v1^, &vi, color)
			draw_flat_top_triangle(buffer, v1^, &vi, v2^, color)
		} else {
			draw_flat_bottom_triangle(buffer, v0^, &vi, v1^, color)
			draw_flat_top_triangle(buffer, &vi, v1^, v2^, color)
		}
	}
}

draw_line :: proc(buffer: ^t.tPixelBuffer, x0, y0, x1, y1: int, color: rl.Color) {
	dx := abs(x1 - x0)
	dy := abs(y1 - y0)

	sx := x1 > x0 ? 1 : -1
	sy := y1 > y0 ? 1 : -1

	err := dx - dy

	x, y := x0, y0
	for {
		draw_pixel(buffer, x, y, color)
		if x == x1 && y == y1 do break

		e2 := 2 * err
		if e2 > -dy {
			err -= dy
			x += sx
		}
		if e2 < dx {
			err += dx
			y += sy
		}
	}
}

draw_square :: proc(buffer: ^t.tPixelBuffer, x, y, size: int) {
	start_x := x - size / 2
	start_y := y - size / 2

	for dy := 0; dy < size; dy += 1 {
		for dx := 0; dx < size; dx += 1 {
			px := start_x + dx
			py := start_y + dy
			draw_pixel(buffer, px, py, rl.BLUE)
		}
	}
}

draw_cube_lines :: proc(buffer: ^t.tPixelBuffer, lines: t.IndexedLines) {
	for i := 0; i < len(lines.indices); i += 2 {
		draw_line(
			buffer,
			int(_3d_to_screen(lines.vertices[lines.indices[i]]).x),
			int(_3d_to_screen(lines.vertices[lines.indices[i]]).y),
			int(_3d_to_screen(lines.vertices[lines.indices[i + 1]]).x),
			int(_3d_to_screen(lines.vertices[lines.indices[i + 1]]).y),
			rl.RED,
		)
	}
}

draw_triangles :: proc(buffer: ^t.tPixelBuffer, triangles: t.IndexedTriangle) {
	for i := 0; i <	 len(triangles.indices); i += 3 {
		v0 := _3d_to_screen(triangles.vertices[triangles.indices[i]])
		v1 := _3d_to_screen(triangles.vertices[triangles.indices[i + 1]])
		v2 := _3d_to_screen(triangles.vertices[triangles.indices[i + 2]])

		pv0 := &v0
		pv1 := &v1
		pv2 := &v2
		draw_triangle(buffer, &pv0, &pv1, &pv2, rl.GREEN)
	}
}

update :: proc(state: ^t.State) {
	@(static) angle: f32 = 0.0005

	for &v in state.cube.vertices {
		v.xy = rl.Vector2Rotate({v.x, v.y}, angle) // SPIN THE CUBE
		v.xz = rl.Vector2Rotate({v.x, v.z}, angle) // SPIN IT IN 3D!

		v.z += 2
	}
}

render :: proc(buffer: ^t.tPixelBuffer, state: ^t.State) {
	cube_lines: t.IndexedLines = shapes.get_cube_lines(&state.cube)
	triangles := shapes.get_triangles(&state.cube)
	draw_triangles(buffer, triangles)
	// draw_cube_lines(buffer, cube_lines)
}


main_loop :: proc(buffer: ^t.tPixelBuffer, state: ^t.State) {
	update(state)
	render(buffer, state)
	for &v in state.cube.vertices {
		v.z -= 2
	}
}
