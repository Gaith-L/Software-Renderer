package types

import rl "vendor:raylib"

v2 :: rl.Vector2
v3 :: rl.Vector3

BUFFER_WIDTH :: 800
BUFFER_HEIGHT :: 800

t2dPixelBuffer :: [BUFFER_HEIGHT][BUFFER_WIDTH]rl.Color


State :: struct
{
	cube : Cube,
	cube_original : Cube
}

tPixelBuffer :: struct {
	pixels: [BUFFER_HEIGHT][BUFFER_WIDTH]rl.Color,
	width:  int,
	height: int,
}

program_state :: struct {
	cube : Cube
}

// Shapes ---------------------------->
IndexedLines :: struct {
	vertices: []rl.Vector3,
	indices:  []u32,
}


IndexedTriangle :: struct {
	vertices: []rl.Vector3,
	indices:  []u32,
}


Cube :: struct {
	size:     f32,
	vertices: [8]rl.Vector3,
}

raster_triangle :: struct {
	v0 : ^^rl.Vector2,
	v1 : ^^rl.Vector2,
	v2 : ^^rl.Vector2,
	color : rl.Color
}
