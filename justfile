default:
    @just --list

# Run the function checks and render every tutorial section, warnings as errors
test:
    @out=$(openscad --hardwarnings -o - --export-format echo tests/test_tangent_lines.scad 2>/dev/null); echo "$out" | grep -q 'all checks passed' || { echo "$out" | grep -E 'ERROR|WARNING'; exit 1; }; echo "function checks passed"
    @for s in 0 1 2 3 4 5 6 7 8 9; do case $s in 5|9) fmt=binstl;; *) fmt=svg;; esac; log=$(openscad --hardwarnings -D tutorial_section=$s -o - --export-format $fmt tangent_lines_tutorial.scad 2>&1 >/dev/null) || { echo "section $s:"; echo "$log"; exit 1; }; echo "section $s rendered"; done

# Regenerate the README images in assets/ from the tutorial script
images:
    @i=0; for s in 0 1 2 3 4 5 6 7 9; do i=$((i+1)); case $s in 5) view="--camera=0,0,0,60,0,25,0 --projection=p";; *) view="--camera=0,0,0,0,0,0,0 --projection=o";; esac; openscad --hardwarnings -D tutorial_section=$s $view --viewall --autocenter --view=axes,scales --imgsize=800,600 --colorscheme=Cornfield -o assets/tutorial$i.png tangent_lines_tutorial.scad 2>/dev/null || exit 1; echo "section $s -> assets/tutorial$i.png"; done
