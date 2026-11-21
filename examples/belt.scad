// A belt round two pulleys: two circles joined by their external tangent lines
include <../tangent_lines.scad>

$fn = 100;

// The ends of the belt's two straight runs, in order round the outline. The radii must differ.
function belt_corners(c1, r1, c2, r2) =
    let (
        t = PointForExternal(c1, r1, c2, r2),
        p = TangentPoints(c1, r1, t),
        q = TangentPoints(c2, r2, t)
    ) [p[0], q[0], q[1], p[1]];

module belt(c1, r1, c2, r2) {
    translate(c1) circle(r1);
    translate(c2) circle(r2);
    polygon(belt_corners(c1, r1, c2, r2));
}

belt([-35, 25], 30, [20, -5], 15);
