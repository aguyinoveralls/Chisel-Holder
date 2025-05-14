include <MCAD/boxes.scad>

include <./common.scad>

// This creates a mounting base for the Bauer Universal Lathe Stand that other items can be mounted to. This was designed originally so that a chisel holder could be added to the stand.

$fn = $preview ? 64 : 128;

right_mold();
translate([standLength + tolerance, 0, 0])
    left_mold();
