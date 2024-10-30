package shapes

import t "../types"
import rl "vendor:raylib"

make_cube :: proc(size: f32) -> t.Cube {
	s := size / 2

	// v: [8]rl.Vector3 = {
	// 	{-s, -s, -s}, //0
	// 	{s, -s, -s},  //1
	// 	{s, s, -s},   //2
	// 	{-s, s, -s},  //3
	// 	{-s, -s, s},  //4
	// 	{s, -s, s},  //5
	// 	{s, s, s},    //6
	// 	{-s, s, s},   //7
	// }

    // NOTE: for testing (as we are ignoring z atm)
	s2 := s / 2
	v: [8]rl.Vector3 = {
		{-s, -s, -s}, //0
		{s, -s, -s},  //1
		{s, s, -s},   //2
		{-s, s, -s},  //3
		{-s2, -s2, s2},  //4
		{s2, -s2, s2},  //5
		{s2, s2, s2},    //6
		{-s2, s2, s2},   //7
	}

	return t.Cube{size = size, vertices = v}
}

get_cube_lines :: proc(cube: ^t.Cube) -> t.IndexedLines {
    vertices := make([]rl.Vector3, 8) // Length = 8
    copy(vertices, cube.vertices[:])

    indices := make([]u32, 24)
    // Length = 24
    edge_indices := [24]u32 {
        //Front face
        0,1,
        1,2,
        2,3,
        3,0,

        //Back face
        4,5,
        5,6,
        6,7,
        7,4,

        0,4,
        1,5,
        2,6,
        3,7,
    }
    copy(indices, edge_indices[:])
	return t.IndexedLines{
        vertices, indices
    }
}
