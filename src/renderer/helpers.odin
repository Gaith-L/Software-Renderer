package renderer

swap_pointers :: proc(p0, p1 : ^^[3]f32)
{
    tmp := p0^
    p0^ = p1^
    p1^ = tmp
}
