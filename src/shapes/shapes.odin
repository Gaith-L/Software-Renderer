package shapes

import t "../types"
import rl "vendor:raylib"

make_cube :: proc(size: f32) -> t.Cube {
	s := size / 2

	v: [8]rl.Vector3 = {
		{-s, -s, -s}, //0
		{s, -s, -s},  //1
		{s, s, -s},   //2
		{-s, s, -s},  //3
		{-s, -s, s},  //4
		{s, -s, s},  //5
		{s, s, s},    //6
		{-s, s, s},   //7
	}

	return t.Cube{size = size, vertices = v}
}

get_triangles :: proc(cube: ^t.Cube) -> t.IndexedTriangle {
    vertices := make([]rl.Vector3, 8) // Length = 8
    copy(vertices, cube.vertices[:])

    indices := make([]u32, 24)
    // Length = 24
    edge_indices := [36]u32 {
        //Front face
        0,2,1, 2,3,1,
        1,3,5, 3,7,5,
        2,6,3, 3,6,7,
        4,5,7, 4,7,6,
        0,4,2, 2,4,6,
        0,1,4, 1,5,4,
    }
    copy(indices, edge_indices[:])
	return t.IndexedTriangle{
        vertices, indices
    }
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
