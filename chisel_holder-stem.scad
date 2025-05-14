include <MCAD/boxes.scad>

include <./common.scad>

$fn = $preview ? 64 : 128;

render_preview() {
    rotate([0, 0, 90]) {
        translate([halfSize + attachmentDepth, 0, baseHeight])
            rotate([0, 180, 0])
                left_mold();
        translate([halfSize + attachmentDepth, 0, 0])
            right_mold();
    }
}

stem_attachment();
stem();

