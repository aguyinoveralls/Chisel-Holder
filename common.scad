include <MCAD/triangles.scad>

// The thickness of the metal.
edgeThickness = 4; // mm

// Distance from one edge of the bolt hole in the stand to the next hole.
holeOffset = 16; // mm

// Side length. The stand is a square, so side length will be the same regardless.
standLength = 54; // mm

// The height of the attachment.
baseHeight = 100; // mm

// The number of mm to add for tolerance.
tolerance = 2; // mm

// The diameter of the bolt hole in the stand.
standBoltHoleDiam = 10; // mm

// The depth of the tool base
attachmentDepth = 20; // mm

// Fraction for base bolts to mount
baseFraction = 4;

// Mounting bolt slots
baseMountingFraction = 8;

// Washer diameter for bolts
washerDiameter = 12; // mm

// Distance between washer and heat set insert
boltOpenDistance = 14; // mm

// The width of the stem.
stemWidth = 20; // mm

// The length of the stem.
stemLength = 100; // mm




// Half-size. Uses tolerance twice, because measure once and print 100 times.
halfSize = (standLength + tolerance) / 2 + tolerance;

// This is the full size, including each side.
fullLength = standLength + 2 * attachmentDepth + 3 * tolerance;

// The depth to send a bolt hole in the mounting base.
boltHoleDepth = halfSize + attachmentDepth - boltOpenDistance;

module render_preview () {
    if ($preview) {
        children();
    }
}

// Use when needing to add a ruthex heat set insert for an M5 bolt.
module ruthexm5 (extendedLength = 0) {
    m5diam = 6.4; // mm
    m5depth = 9.6; // mm
    
    cylinder(h = m5depth + extendedLength, d = m5diam);
}

module m5bolt (length) {
    m5diam = 5; // mm
    boltTolerance = 0.1; // mm
    cylinder(d = m5diam + boltTolerance, h = length);
}

// Use when needing to add distance for a bolt hole in the stand.
module stand_hole () {
    holeDiam = standBoltHoleDiam; // mm
    
    rotate([90, 0, 0]) {
        cylinder(h = edgeThickness, d = holeDiam - tolerance);
    }
}

module stand_attachment (reverse = false) {
    attachmentHeight = baseHeight; // mm
    thickness = edgeThickness + tolerance;
    
    // This cube is the cube that will have the chisel holder mounted to it.
    cube([halfSize + attachmentDepth, attachmentDepth, attachmentHeight]);
    
    // This cube runs along the other two sides
    translate([halfSize, attachmentDepth, 0]) {
        cube([attachmentDepth, standLength + attachmentDepth + tolerance, attachmentHeight]);
    }

    // These move along the edge that is open
    translate([halfSize - thickness * 2 - attachmentDepth / 2, standLength + attachmentDepth + tolerance, 0]) {
        cube([thickness * 2 + attachmentDepth / 2, attachmentDepth, attachmentHeight]);
    }
    
    // This holds it in place along the edge
    translate([halfSize - thickness * 2 - attachmentDepth / 2, standLength + attachmentDepth - thickness + tolerance, 0]) {
        cube([thickness + attachmentDepth / 2, thickness, attachmentHeight]);
    }


    // These are the hole slots
    holeCount = baseHeight / (standBoltHoleDiam + holeOffset);
    for (i = [1:holeCount]) {
        x = standLength - edgeThickness * 2 - attachmentDepth;
        y = attachmentDepth + standLength / 2 + tolerance;
        if (reverse) {
            translate([x, y, i * (holeOffset + standBoltHoleDiam) - holeOffset]) {
                rotate([0, 0, 90]) {
                    stand_hole();
                }
            }
        }
        else {
            translate([x, y, attachmentHeight - i * (holeOffset + standBoltHoleDiam) + holeOffset]) {
                rotate([0, 0, 90]) {
                    stand_hole();
                }
            }
        }
    }
}


module right_mold () {
    boltSlotsY = attachmentDepth / 2;
    difference() {
        stand_attachment();
        translate([0, boltSlotsY, 0]) {
            translate([0, 0, baseHeight / baseMountingFraction]) {
                rotate([0, 90, 0]) {
                    ruthexm5();
                }
            }
    
            translate([0, 0, baseHeight - (baseHeight / baseMountingFraction)]) {
                rotate([0, 90, 0]) {
                    ruthexm5();
                }
            }
        }
    
        translate([halfSize, 0, 0]) {
            translate([0, 0, baseHeight - (baseHeight / baseFraction)]) {
                rotate([-90, 0, 0]) {
                    ruthexm5();
                }
            }
    
            translate([0, 0, baseHeight / baseFraction]) {
                rotate([-90, 0, 0]) {
                    ruthexm5();
                }
            }
        }
    }
}

module left_mold () {
    boltSlotsY = attachmentDepth / 2;
    difference() {
        stand_attachment(true);
    
        translate([0, boltSlotsY, 0]) {
            translate([0, 0, baseHeight / baseMountingFraction]) {
                rotate([0, 90, 0]) {
                    m5bolt(14);
                }
            }
    
            translate([0, 0, baseHeight - (baseHeight / baseMountingFraction)]) {
                rotate([0, 90, 0]) {
                    m5bolt(boltOpenDistance);
                }
            }
        }
    
        translate([halfSize + attachmentDepth - boltHoleDepth, boltSlotsY, 0]) {
            translate([0, 0, baseHeight / baseMountingFraction]) {
                rotate([0, 90, 0]) {
                    cylinder(h = boltHoleDepth, d = washerDiameter);
                }
            }
    
            translate([0, 0, baseHeight - (baseHeight / baseMountingFraction)]) {
                rotate([0, 90, 0]) {
                    cylinder(h = boltHoleDepth, d = washerDiameter);
                }
            }
        }
    
        translate([halfSize, 0, 0]) {
            translate([0, 0, baseHeight - (baseHeight / baseFraction)]) {
                rotate([-90, 0, 0]) {
                    ruthexm5();
                }
            }
            translate([0, 0, baseHeight / baseFraction]) {
                rotate([-90, 0, 0]) {
                    ruthexm5();
                }
            }
        }
    }
}

module bolt_insert (z, boltSize = 14) {
    translate([boltSize, 0, z])
        rotate([0, 90, 0])
            cylinder(h = boltHoleDepth, d = washerDiameter);
    translate([0, 0, z])
        rotate([0, 90, 0])
            m5bolt(boltSize);

}

module triangle_stabilizer (y, z, xRot = 180, zMod = (halfSize - washerDiameter)/2) {
    translate([attachmentDepth, y, z + zMod])
        rotate([xRot, 0, 0])
            triangle(halfSize - washerDiameter, 10, halfSize - washerDiameter);
}

module stem_base () {
    cube([attachmentDepth + halfSize, fullLength, fullLength]);
}

module stem_attachment () {
    difference() {
        stem_base();
        translate([0, halfSize - 10, 0]) {
            bolt_insert(baseHeight - (baseHeight / baseFraction));
            bolt_insert(baseHeight / baseFraction);
        }
        translate([0, fullLength - attachmentDepth / 2 - 10, 0]) {
            bolt_insert(baseHeight - (baseHeight / baseFraction));
            bolt_insert(baseHeight / baseFraction);
        }
    }
}

module stem_neck (xPos, botMod, topMod) {
    translate([xPos, 0, baseHeight * (1 - botMod)]) {
        difference() {
            translate([0, -stemLength, 0]) {
                cube([stemWidth, stemLength, baseHeight]);
            }
            translate([0, -stemLength, 0])
                rotate([90, 0, 90])
                    triangle(baseHeight * botMod, stemLength * botMod, stemWidth);
            translate([0, 0, baseHeight])
                rotate([270, 0, 270])
                    triangle(baseHeight * topMod, stemLength * topMod, stemWidth);
        }

    }
    translate([xPos, 0, 0]) {
        translate([0, 0, baseHeight * (1 - botMod)])
            rotate([270, 0, 270])
                triangle(baseHeight * 0.25, stemLength * 0.25, stemWidth);
        translate([stemWidth, 0, baseHeight]) {
            rotate([0, 90, 180]) {
                triangle(stemLength * 0.25, baseHeight * 0.25, stemWidth);
            }
        }
        translate([0, -stemLength, baseHeight * botMod]) {
            cube([stemWidth, stemLength / 2, baseHeight /2]);
        }
    }
}

module stem () {
    xPos = (attachmentDepth + halfSize) / 2 - stemWidth / 2;
    botMod = 0.75;
    topMod = 0.5;
    difference() {
        stem_neck(xPos, botMod, topMod);
        translate([0, 0, baseHeight * (1 - botMod)]) {
            translate([stemWidth + xPos, -stemLength + 10, 0]) {
                translate([0, 0, baseHeight -10]) {
                    rotate([0, 270, 0])
                        ruthexm5(stemWidth);
                }
                translate([0, 0, baseHeight - 40]) {
                    rotate([0, 270, 0]) {
                        ruthexm5(stemWidth);
                    }
                }
            }
            translate([stemWidth + xPos, -stemLength + 40, 0]) {
                translate([0, 0, baseHeight -10]) {
                    rotate([0, 270, 0])
                        ruthexm5(stemWidth);
                }
                translate([0, 0, baseHeight - 40]) {
                    rotate([0, 270, 0]) {
                        ruthexm5(stemWidth);
                    }
                }
            }

        }
    }
}


