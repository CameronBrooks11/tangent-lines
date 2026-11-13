// Checks for tangent_lines.scad. Each assert tests a geometric property
// of the result, not the formula that produced it.
// Run: openscad --hardwarnings -o /dev/null --export-format echo tests/test_tangent_lines.scad

include <../tangent_lines.scad>

eps = 1e-9;

function near(a, b) = abs(a - b) <= eps * max(1, abs(a), abs(b));
function cross2(u, v) = u.x * v.y - u.y * v.x;
function on_circle(p, c, r) = near(norm(p - c), r);
// p lies on circle (c, r) and the radius to p is perpendicular to the line from q.
function tangent_from(p, c, r, q) = on_circle(p, c, r) && abs((p - c) * (p - q)) <= eps * r * norm(q - c);
function collinear(a, b, c) = abs(cross2(b - a, c - a)) <= eps * max(1, norm(b - a) * norm(c - a));

// Circles used by the tutorial.
C1 = [ -35, 25 ];
R1 = 30;
C2 = [ 20, -5 ];
R2 = 15;

// Common points lie on the line through both centres, at distances in the
// ratio of the radii.
T1 = PointForExternal(C1, R1, C2, R2);
T2 = PointForInternal(C1, R1, C2, R2);
assert(collinear(C1, C2, T1), "external point is on the line of centres");
assert(collinear(C1, C2, T2), "internal point is on the line of centres");
assert(near(norm(T1 - C1) / R1, norm(T1 - C2) / R2), "external point divides the centres by the radii");
assert(near(norm(T2 - C1) / R1, norm(T2 - C2) / R2), "internal point divides the centres by the radii");
assert(near(norm(T2 - C1) + norm(T2 - C2), norm(C2 - C1)), "internal point is between the centres");

// Tangent points from each common point, on each circle.
for (t = [ T1, T2 ], circle = [ [ C1, R1 ], [ C2, R2 ] ])
{
    P = TangentPoints(circle[0], circle[1], t);
    assert(tangent_from(P[0], circle[0], circle[1], t), str("tangent point 0 from ", t));
    assert(tangent_from(P[1], circle[0], circle[1], t), str("tangent point 1 from ", t));
    assert(norm(P[0] - P[1]) > circle[1] / 10, "the two tangent points are distinct");
}

// The same index on both circles lies on the same common tangent line.
for (t = [ T1, T2 ])
{
    P = TangentPoints(C1, R1, t);
    Q = TangentPoints(C2, R2, t);
    assert(collinear(t, P[0], Q[0]), str("first points share a tangent line through ", t));
    assert(collinear(t, P[1], Q[1]), str("second points share a tangent line through ", t));
}

// Overlapping circles: both intersection points are on both circles.
C3 = [ 5, -15 ];
R3 = 40;
K = IntersectionPoints(C1, R1, C3, R3);
for (k = K)
{
    assert(on_circle(k, C1, R1), str("intersection ", k, " is on the first circle"));
    assert(on_circle(k, C3, R3), str("intersection ", k, " is on the second circle"));
}
assert(norm(K[0] - K[1]) > 1, "the two intersection points are distinct");

// Circles touching from outside: the touch point is on both circles.
R4 = 40;
C4 = C1 + (R1 + R4) * [ 1, -1 ] / sqrt(2);
L = TouchPoint(C1, R1, C4, R4);
assert(on_circle(L, C1, R1), "outside touch point is on the first circle");
assert(on_circle(L, C4, R4), "outside touch point is on the second circle");

echo("tangent_lines: all checks passed");
