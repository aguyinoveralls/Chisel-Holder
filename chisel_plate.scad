include <MCAD/boxes.scad>

include <./common.scad>

$fn = $preview ? 64 : 128;

// Number of chisels to hold.
chiselCount = 8;

plateDiam = 250;
chiselSlotInner = 16.5; // mm
chiselSlotOuter = 20; // mm
chiselSlotOpeningSize = 25; // mm

angleDifference = 270 / chiselCount;

module chisel_slot () {
    cylinder(h = attachmentDepth, d = chiselSlotInner * 2);
    for (i = [0.2:0.2:(chiselSlotOuter-chiselSlotInner)*2]) {
        translate([0, 0, attachmentDepth - i]) {
            cylinder(h=0.2, r = chiselSlotOuter - i);
        }
    }
    translate([chiselSlotInner - chiselSlotOpeningSize / 2, -chiselSlotOpeningSize / 2, 0]) {
        cube([chiselSlotOpeningSize, chiselSlotOpeningSize, attachmentDepth], center="true");
    }
}

module plate () {
    translate([attachmentDepth + stemWidth / 2 - 5, -stemLength - 25, baseHeight * 1.25]) {
        difference() {
            difference() {
                cylinder(h=attachmentDepth, d=plateDiam);
                for (i = [0.2:0.2:(attachmentDepth/3)]) {
                    translate([0, 0, attachmentDepth - i]) {
                        cylinder(h=i, d=(plateDiam - i - chiselSlotOuter * 4));
                    }
                }
            }

            for (i = [1:chiselCount]) {
                rotate([0, 0, i * angleDifference]) {
                    translate([-plateDiam / 3.3, plateDiam / 3.3, 0]) {
                        rotate([0, 0, 270 - 4 * angleDifference])
                            chisel_slot();
                    }
                }
            }
        }

        translate([stemWidth/2, 25, -attachmentDepth*2.5])
            cube([stemWidth, stemLength / 2, baseHeight / 2]);
        translate([-stemWidth*1.5, 25, -attachmentDepth*2.5])
            cube([stemWidth, stemLength / 2, baseHeight / 2]);
        translate([-stemWidth * 1.5, 5, -attachmentDepth*2.5]) {
            cube([stemWidth * 3, attachmentDepth, baseHeight / 2]);
        }
    }
}

module plate_stem () {
    translate([0, 0, baseHeight * 0.25]) {
        translate([stemWidth + (attachmentDepth * 2), -stemLength + 10, 0]) {
            translate([0, 0, baseHeight - 10]) {
                rotate([0, 270, 0]) {
                    ruthexm5(attachmentDepth * 2 + stemWidth);
                    cylinder(h=10, d = washerDiameter);
                }
            }
            translate([0, 0, baseHeight - 40]) {
                rotate([0, 270, 0]) {
                    ruthexm5(attachmentDepth * 2 + stemWidth);
                    cylinder(h=10, d = washerDiameter);
                }
            }
        }
        translate([stemWidth + (attachmentDepth * 2), -stemLength + 40, 0]) {
            translate([0, 0, baseHeight - 10]) {
                rotate([0, 270, 0]) {
                    ruthexm5(attachmentDepth * 2 + stemWidth);
                    cylinder(h=10, d = washerDiameter);
                }
            }
            translate([0, 0, baseHeight - 40]) {
                rotate([0, 270, 0]) {
                    ruthexm5(attachmentDepth * 2 + stemWidth);
                    cylinder(h=10, d = washerDiameter);
                }
            }
        }
        translate([0, -stemLength + 10, 0]) {
            translate([0, 0, baseHeight - 10]) {
                rotate([0, 270, 0]) {
                    cylinder(h=10, d = washerDiameter);
                }
            }
            translate([0, 0, baseHeight - 40]) {
                rotate([0, 270, 0]) {
                    cylinder(h=10, d = washerDiameter);
                }
            }
        }
        translate([0, -stemLength + 40, 0]) {
            translate([0, 0, baseHeight - 10]) {
                rotate([0, 270, 0]) {
                    cylinder(h=10, d = washerDiameter);
                }
            }
            translate([0, 0, baseHeight - 40]) {
                rotate([0, 270, 0]) {
                    cylinder(h=10, d = washerDiameter);
                }
            }
        }
    }
}

render_preview() {
    stem_base();
    stem();
}

difference() {
    plate();
    plate_stem();
}

