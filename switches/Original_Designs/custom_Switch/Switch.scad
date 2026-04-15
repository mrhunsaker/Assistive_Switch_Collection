/* Accessible Switch
(c) 2026 Michael Ryan Hunsaker, M.Ed., Ph.D.
Materials: 
    4 #4 x 5/8" Screws 
        (https://www.amazon.com/dp/B08MTFLXTT)
    ss-3gp Microswitch 
        (https://www.digikey.com/en/products/detail/omron-electronics-inc-emc-div/SS-3GP/664724)
    Mono cable 
        (https://www.digikey.com/en/products/detail/tensility-international-corp/10-00344/2350247)
    Solder
    Soldering Iron
    Designed for 3D Print with PLA Filament
*/
// =============================================
// CUSTOMIZER CONTROLS
// =============================================

// Select what to render
part = "exploded_assembly"; 
// [body, switch_base, flexure_spring, button_top, assembly, exploded_assembly]

// Optional: enable colors in preview (disable for STL export)
use_color = true;

// =============================================
// Flexure Switch Assembly
// Components: switch_base, mount_cylinders, flexure_spring, button_top, body
// =============================================
// --- Global render quality ---
$fn = 256;
// =============================================
// SHARED DIMENSIONS 
// =============================================
// Body inner bore (from base())
body_inner_r = 17.5;
// Radial clearance to avoid rubbing
clearance = 0.5;
// Maximum usable radius
max_r = body_inner_r - clearance;   // 17.0 mm
// =============================================
// MOUNTING SCREW CYLINDERS
// =============================================
cyl_od     = 7;                     // mm
cyl_height = 17;                    // mm
// Position cylinders fully inside body
mount_radius = max_r - cyl_od/2;    // = 13.5 mm
// =============================================
// FLEXURE SPRING 
// =============================================
// Flexure must sit inside bolt circle
outer_radius = mount_radius - 0.8;  // ≈ 12.7 mm
inner_radius   = 5;
arm_width      = 1.8;
thickness      = 0.9; // 0.9 = loose, 1.0 = medium, 1.1 = stiff
num_arms       = 3;
// =============================================
// SCREW + PAD CONSTRAINTS
// =============================================
screw_d = 3.2; // value for #4 screws
// Ensure pads never exceed available radial space
pad_diameter = min(screw_d * 3,
                   (max_r - mount_radius) * 2 - 0.5);
pad_height = thickness * 1.5;
// =============================================
// MODULE: arm_cutout
// =============================================
module arm_cutout(center_angle) {
    eps = 0.02;
    rotate([0, 0, center_angle])
    translate([0, 0, thickness/2])
    linear_extrude(height = thickness + eps, center = true)
        hull() {
            translate([inner_radius, 0])
                circle(d = arm_width, $fn = 64);
            translate([outer_radius - 0.5, 0])
                circle(d = arm_width, $fn = 64);
        }
}
// =============================================
// MODULE: flexure_spring
// 3-arm flexure disc.
// =============================================
module flexure_spring() {
    eps = 0.02;
    difference() {
        // =============================
        // FULL FLEXURE SOLID
        // =============================
        union() {
            // --- Outer rim ---
            difference() {
                cylinder(h = thickness, r = outer_radius);
                translate([0, 0, -eps])
                    cylinder(h = thickness + 2*eps,
                             r = outer_radius - arm_width);
            }
            // --- Inner hub ---
            difference() {
                cylinder(h = thickness, r = inner_radius + arm_width);
                translate([0, 0, -eps])
                    cylinder(h = thickness + 2*eps,
                             r = inner_radius);
            }
            // --- Arms (aligned with screws) ---
            for (i = [0 : num_arms - 1]) {
                arm_cutout(i * 120 + 60);
            }
            // --- Reinforcement pads ---
            for (i = [0 : num_arms - 1]) {
                angle = i * 120 + 60;
                // Main pad
                rotate([0, 0, angle])
                translate([mount_radius, 0, -(pad_height - thickness)/2])
                cylinder(h = pad_height,
                         d = pad_diameter,
                         $fn = 64);
                // Smooth blend into arm
                rotate([0, 0, angle])
                hull() {
                    translate([mount_radius, 0, thickness/2])
                        cylinder(h = eps,
                                 d = pad_diameter,
                                 center = true);
                    translate([mount_radius - arm_width, 0, thickness/2])
                        cylinder(h = eps,
                                 d = arm_width * 1.2,
                                 center = true);
                }
            }
        }
        // =============================
        // SCREW HOLES
        // =============================
        for (i = [0 : num_arms - 1]) {
            rotate([0, 0, i * 120 + 60])
            translate([mount_radius, 0, -eps-1])
            cylinder(h = pad_height+1 + 2*eps,
                     r = screw_d / 2,
                     $fn = 64);
        }
    }
}
// =============================================
// MODULE: mount_cylinders
// Three boss cylinders at 120° on the bolt circle.
// =============================================
module mount_cylinders() {
    for (i = [0 : 2]) {
        rotate([0, 0, i * 120 + 60])   // 60° phase keeps cylinders
        translate([mount_radius, 0, 0]) // between the clip features
        difference() {
            // Solid boss
            cylinder(h = cyl_height, d = cyl_od, $fn = 64);
            // #4 clearance bore — epsilon on height prevents
            // co-planar artifacts at top and bottom faces
            cylinder(h = cyl_height + 0.1, d = screw_d,
                     $fn = 32, center = false);
        }
    }
}

module horizontal_boss(){
    difference() {
    translate([6,-7,-9])rotate([90,0,90])attachment();
    translate([9,0,-4])cube([35,10,10],center=true);
    translate([24,0,4]){cube([10,10,10],center=true);}
    translate([0,0,5]){sphere(10,center=true);}
}
}

// =============================================
// MODULE: base
// Lower shell of the switch body.
// =============================================
module base() {
    difference() {
        cylinder(20.75, 20, 20);
        // Cable / wire channel
        translate([0, -10, 3])
            rotate([90, 0, 0])
            cylinder(21, 4, 4);
        // Flat on bottom
        translate([-3.95, -20, -5])
            cube([7.9, 6, 8]);
        // Inner bore
        translate([0, 0, -5])
        color("red") {
            cylinder(26, 17.5, 17.5);
        }
        translate([0,-.25,2.75])
        rotate([90,90,90])
        cylinder(h = cyl_height+9 + 0.1, d = screw_d,
                         $fn = 32, center = false);
    }
    difference() {
        translate([0,0,13])
        cylinder(12.999, 22.5, 22.5);
            color("red") {
            cylinder(26, 17.5, 17.5);
        } }
    horizontal_boss();
rotate([0,0,120])horizontal_boss();
rotate([0,0,240])horizontal_boss();
}

// =============================================
// MODULE: top
// Upper cap of the switch body.
// =============================================
module top() {
    difference() {
            cylinder(1, 20, 20);
            translate([0, 0, -1])
                cylinder(5, 15, 15);
    }
}
// =============================================
// MODULE: body
// Full switch body = Union of base + top.
// =============================================
module body() {
        union() {
            base();
            translate([0, 0, 25])
                top();
        }
}
// =============================================
// MODULE: button_top
// Uses flexure spring to not rely on tactile switch for recovery
// =============================================
module button_top() {
    difference() {
    union() {
    // Flat base disc
    cylinder(2.5, 17, 17);
    // Button pressing Surface
    translate([0,0,-3])cylinder(h = 4, r = inner_radius + arm_width+1);
    }
    
    translate([0,0,-3.01])   // start from top surface
        hex_bolt_hole(
            thickness = 10,
            af = 5.56,
            head_depth = 3,
            shaft_d = 3.2,
            clearance = 0.2
        );
    }
}   
// =============================================
// MODULE: hex_pocket
// for #4 bolt
// =============================================
af = 5.56;                 // across flats (mm)
clearance = 0.2;           // adjust for print tolerance
hex_d = (af + clearance) / cos(30);

module hex_pocket(af, h, clearance=0.2) {
    d = (af + clearance) / cos(30);
    rotate([0,0,30])
        cylinder(h = h, d = d, $fn = 6);
}
// =============================================
// MODULE: hex_pocket
// for #4 bolt
// =============================================
module hex_bolt_hole(
    thickness,
    af = 5.56,
    head_depth = 3,
    shaft_d = 3.2,
    clearance = 0.2
) {
    hex_d = (af + clearance) / cos(30);

    union() {

        // --- Hex pocket (top) ---
        rotate([0,0,30])
            cylinder(h = head_depth, d = hex_d, $fn = 6);

        // --- Through hole (below) ---
        translate([0,0,-0.01])  // slight overlap avoids artifacts
            cylinder(h = thickness + 0.02, d = shaft_d, $fn = 32);
    }
}
// =============================================
// MODULE: hex_nut_trap
// for #4 bolt
// =============================================
module hex_nut_trap(
    af = 7.0,
    thickness = 2.6,
    clearance = 0.2,
    depth = 3
) {
    hex_d = (af + clearance) / cos(30);

    rotate([0,0,30])
        cylinder(h = depth, d = hex_d, $fn = 6);
}
// =====================================================
// BLIND HEX INSERT BOSS SYSTEM (PARAMETRIC)
// =====================================================

module blind_hex_insert_boss(
    boss_h = 15,          // total boss height
    boss_r = 10,          // outer radius

    screw_d = 3.2,        // #4 clearance
    screw_depth = 12,     // blind hole depth

    nut_af = 7.0,         // across flats
    nut_clear = 0.25,     // print clearance
    nut_h = 3.0,          // nut thickness

    nut_z = 4,            // vertical placement of nut center
    wall = 2.0            // minimum wall thickness
) {

    difference() {

        // =========================================
        // OUTER STRUCTURE (BOSS)
        // =========================================
        cylinder(h = boss_h, r = boss_r, $fn = 64);

        // =========================================
        // BLIND SCREW HOLE (Z-AXIS)
        // =========================================
        translate([0,0,-0.5])
            cylinder(
                h = screw_depth,
                d = screw_d,
                $fn = 32
            );

        // chamfer lead-in (bottom)
        translate([0,0,-0.5])
            cylinder(
                h = 1,
                d1 = screw_d + 0.6,
                d2 = screw_d,
                $fn = 32
            );

        // =========================================
        // HEX NUT POCKET (LOCALIZED VOLUME)
        // =========================================
        translate([0,0,nut_z])
        intersection() {

            // bounded cavity region (prevents tunneling)
            translate([-boss_r, -boss_r, -nut_h/2])
                cube([boss_r*2, boss_r*2, nut_h], center = false);

            // hex nut shape
            rotate([0,90,0])
                cylinder(
                    h = boss_r*2,
                    d = (nut_af + nut_clear)/cos(30),
                    $fn = 6
                );
        }
    }
}
module blind_hex_insert_cutter(
    boss_h = 18,
    boss_r = 11,

    screw_d = 3.2,
    screw_depth = 12,

    nut_af = 7.0,
    nut_clear = 0.25,
    nut_h = 3.0,
    nut_z = 5
) {

    union() {

        // =========================
        // BLIND SCREW HOLE
        // =========================
        translate([0,0,-1])
            cylinder(h = screw_depth, d = screw_d, $fn = 32);

        // chamfer
        translate([0,0,-1])
            cylinder(h = 1, d1 = 3.8, d2 = screw_d, $fn = 32);

        // =========================
        // HEX NUT POCKET (BOUNDARY SAFE)
        // =========================
        translate([0,0,nut_z])
        intersection() {

            translate([-boss_r, -boss_r, -nut_h/2])
                cube([boss_r*2, boss_r*2, nut_h], center = false);

            rotate([0,90,0])
                cylinder(
                    h = boss_r*2,
                    d = (nut_af + nut_clear)/cos(30),
                    $fn = 6
                );
        }
    }
}
// =============================================
// MODULE: cap
// =============================================
module cap() {

    difference() {

        // =========================
        // OUTER SHELL (cosmetic only)
        // =========================
        union() {

            // TOP DOME (safe to minkowski)
            translate([0,0,6])
                minkowski() {
                    cylinder(5,20,20);
                    sphere(0.8);
                }

            // IMPORTANT: DO NOT use minkowski for base anymore
            // Replace with clean cylinder core
            cylinder(h = 10, r1 = 10, r2 = 10, $fn = 64);
        }

        // =========================
        // BLIND SCREW HOLE
        // =========================
        translate([0,0,-1])
            cylinder(h = 12, d = 3.2, $fn = 32);

        translate([0,0,-1])
            cylinder(h = 1, d1 = 3.8, d2 = 3.2, $fn = 32);

        // =========================
        // HEX NUT POCKET (NOW HAS REAL SEAT)
        // =========================
        #translate([0,0,-0.001])
            rotate([0,0,0])
                intersection() {

                    // bounded region inside ONLY bottom cylinder
                    translate([-12,-12,-2])
                        cube([24,24,6], center = false);

                    // hex nut cavity
                    cylinder(
                        h = 10,
                        d = (7.0 + 0.25)/cos(30),
                        $fn = 6
                    );
                }
    }
}
// =============================================
// MODULE: switch_base
// Outer ring, clip post, cross-bar, and internal mounting features.
// =============================================
module switch_base() {
    // --- Outer ring ---
    difference() {
        cylinder(10, 22.5, 22.5);
        // Inner bore
        translate([0, 0, 0.5])
            cylinder(10, 20.5, 20.5);
        // Cable notch
        translate([0, 11, 4])
            rotate([90, 0, 0])
            cylinder(50, 2, 2);
        translate([0,-.25,2.75])rotate([90,90,90])cylinder(h = cyl_height+9 + 0.1, d = screw_d, $fn = 32, center = false);
     rotate([0,0,120])translate([0,-.25,2.75])rotate([90,90,90])cylinder(h = cyl_height+9 + 0.1, d = screw_d, $fn = 32, center = false);
    rotate([0,0,240])translate([0,-.25,2.75])rotate([90,90,90])cylinder(h = cyl_height+9 + 0.1, d = screw_d, $fn = 32, center = false);
    }
    // --- Clip post with dovetail cuts ---
    difference() {
        translate([0, 0, 5.001])cube([10, 10, 10], center = true);
        // Front dovetail slot
        translate([0, 0, 9.001])cube([11, 1.5, 3], center = true);
        // Upper angled clip cuts
        translate([0, 3.25, 21.001])rotate([45, 0, 0])cube([15, 15, 20], center = true);
        translate([0, -3.25, 21.001])rotate([-45, 0, 0])cube([15, 15, 20], center = true);
            translate([0, 10, 2.5])rotate([90, 0, 0])cylinder(50, 2, 2);
        translate([-10, 0, 2.5])rotate([90, 0, 90])cylinder(20, 2, 2);
    }
    translate([0, 0, 8.75])
        cube([2.5, 10, 2.5], center = true);
    mount_cylinders();
    difference() {
    translate([6,-7,-9])rotate([90,0,90])attachment();
    translate([12,0,5])cube([13,10,10],center=true);
    translate([9,0,-5])cube([35,10,10],center=true);
    translate([0, 0, 0.5])cylinder(10, 20.5, 20.5);
    }
    rotate([0,0,120])difference() {
    translate([6,-7,-9])rotate([90,0,90])attachment();
    translate([12,0,5])cube([13,10,10],center=true);
    translate([9,0,-5])cube([35,10,10],center=true);
    translate([0, 0, 0.5])cylinder(10, 20.5, 20.5);
    }
    rotate([0,0,240])difference() {
    translate([6,-7,-9])rotate([90,0,90])attachment();
    translate([12,0,5])cube([13,10,10],center=true);
    translate([9,0,-5])cube([35,10,10],center=true);
    translate([0, 0, 0.5])cylinder(10, 20.5, 20.5);
    }
}
// =============================================
// SIDE SCREW ATTACHMENT
// =============================================
module attachment() {
    for (i = [0 : 0]) {
        rotate([0, 0, i * 120 + 60])   // 60° phase keeps cylinders
        translate([mount_radius, 0, 0]) // between the clip features
        difference() {
            // Solid boss
            cylinder(h = cyl_height, d = cyl_od, $fn = 64);
            // #4 screw clearance bore — epsilon on height prevents
            // co-planar artifacts at top and bottom faces
            translate([0,0,-.01])cylinder(h = cyl_height + 0.1, d = screw_d,
                     $fn = 32, center = false);
        }
    }
}
// =============================================
// ASSEMBLY / PREVIEW
// =============================================
module assembly() {
color("red", alpha=0.5){body();}
translate([0, 0, -0.1])color("yellow", alpha=0.5)switch_base();
translate([0, 0, cyl_height])color("blue", alpha=0.5){flexure_spring();}
translate([0, 0, cyl_height + thickness + 2])color("green", alpha=0.5)button_top();
}

// =============================================
// EXPLODED ASSEMBLY / PREVIEW
// =============================================
module exploded_assembly() {
translate([0,0,33])color("red", alpha=0.5){body();}
translate([0, 0, -0.1])color("yellow", alpha=0.5)switch_base();
translate([0, 0, cyl_height+1])color("blue", alpha=0.5){flexure_spring();}
translate([0, 0, cyl_height + thickness + 5])color("green", alpha=0.5)button_top();
}

// =============================================
// CROSS-SECTION ASSEMBLY / PREVIEW
// =============================================
module cross_section_assembly() {
difference(){
translate([0,0,0])color("red"){body();}
translate([0,-50,-5])cube([50,100,100]);
}
difference(){
translate([0, 0, -0.1])color("yellow")switch_base();
translate([0,-50,-5])cube([50,100,100]);
}
difference(){
translate([0, 0, cyl_height])color("blue"){flexure_spring();}
translate([0,-50,-5])cube([50,100,100]);
}
difference(){
translate([0, 0, cyl_height + thickness + 2])color("green",alpha=.5)button_top();
translate([0,-50,-5])cube([50,100,100]);
}
}

// =============================================
// LAYOUT / PREVIEW
// =============================================
module layout() {
color("red"){body();}
translate([45, 0, 0])color("yellow")switch_base();
translate([-35, 0, 0])color("blue"){flexure_spring();}
translate([0, 40, 0])color("green")button_top();
}

// =============================================
// RENDER DISPATCHER (Customizer-driven)
// =============================================

module render_selected() {

    if (part == "body") {

        if (use_color) color("red") body();
        else body();

    } else if (part == "switch_base") {

        if (use_color) color("yellow") switch_base();
        else switch_base();

    } else if (part == "flexure_spring") {

        if (use_color) color("blue") flexure_spring();
        else flexure_spring();

    } else if (part == "button_top") {

        if (use_color) color("green") button_top();
        else button_top();

    } else if (part == "assembly") {

        assembly();

    } else if (part == "exploded_assembly") {

        exploded_assembly();

    } else if (part == "cross_section_assembly") {

        cross_section_assembly();

    } else if (part == "layout") {

        layout();
    } else if (part == "cap") {
    
        cap();
    
    } else {

        echo("Invalid part selection");

    }
}

// Call the dispatcher
render_selected();