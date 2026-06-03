//                       NUDGE SWITCH - UNIFIED EDITION
//
// Copyright 2026 Michael Ryan Hunsaker, M.Ed., Ph.D.
// Licensed under the Apache License, Version 2.0

/* [Switch Type] */
// Select the physical profile of the switch: 
// "standard" is the taller original version; "low_profile" is compact.
switch_type = "standard"; // [standard, low_profile]

/* [Part Selection] */
// Determines which component or assembly view is rendered in the viewport.
part = "exploded_assembly"; // [assembled, layout_assembly, exploded_assembly, side_by_side_comparison, body, switch_base, button_top, cap, spring]
use_color = true;

/* [Ergonomics] */
// Parameters for fine-tuning the feel and orientation of the switch cap.
cap_erg_bias = 0.35;
cap_erg_angle = 0;
cap_erg_relief = 0.6;
cap_erg_index_height = 0.8;

// =============================================
// PARAMETER LOGIC
// =============================================

// Set render resolution: Low profile uses slightly fewer facets for faster rendering.
$fn = (switch_type == "low_profile") ? 128 : 256; 

// Profile-specific dimensions: These ternary operators adjust heights 
// and spacing to compress or expand the switch design.
cyl_height    = (switch_type == "low_profile") ? 13.5 : 18;     // Height of internal mounting pillars
cap_base_h    = (switch_type == "low_profile") ? 10 : 10;    // Thickness of the cap's vertical base
cap_dome_h    = (switch_type == "low_profile") ? 5.7 : 5.7;   // Height of the ergonomic top dome
base_main_h   = (switch_type == "low_profile") ? 17.5 : 21.75; // Overall height of the base cylinder
base_rim_z    = (switch_type == "low_profile") ? 13.5 : 14;     // Vertical position of the decorative rim
base_rim_h    = (switch_type == "low_profile") ? 4 : 10;     // Height/Thickness of the decorative rim
button_disc_h = (switch_type == "low_profile") ? 2.5 : 2.5;  // Thickness of the internal button plate

// Global Dimensions: Hardware standards and spacing shared by both profiles.
body_inner_r = 17.5; 
clearance = 0.5;
max_r = body_inner_r - clearance; 
bolt_diameter_1_4 = 6.35;    // Standard 1/4" bolt diameter
bolt_head_af = 11.11;       // Across-flats dimension for 1/4" bolt head
nut_af = 11.11;             // Across-flats dimension for 1/4" nut
nut_thickness = 5.2; 
clearance_fit = 0.3;        // Tolerance added for 3D printed fitment
cyl_od = 7;
mount_radius = max_r - cyl_od/2; 
outer_radius = mount_radius - 0.8; 
inner_radius = 5; 
arm_width = 1.8; 
thickness = 0.9;            // Thickness of the 3D printed flexure
num_arms = 3; 
screw_d = 3.2;              // Hole diameter for M3 screws
pad_diameter = min(screw_d * 3, (max_r - mount_radius) * 2 - 0.5);
pad_height = thickness * 1.5; 

// =============================================
// SHARED UTILITY MODULES
// =============================================

// Creates a single cutout path for the flexure spring arms.
module arm_cutout(center_angle) {
    eps = 0.02; // Small overlap to ensure clean boolean subtractions
    rotate([0, 0, center_angle])
    translate([0, 0, thickness/2])
    linear_extrude(height = thickness + eps, center = true)
        hull() {
            // Bridges the inner and outer circles to create the arm shape
            translate([inner_radius, 0]) circle(d = arm_width, $fn = 64);
            translate([outer_radius - 0.5, 0]) circle(d = arm_width, $fn = 64);
        }
}

// Simple base platform used for the standard switch profile's mounting points.
module plinth() { cylinder(h=2, r1=25, r2=25); }

// Generates the compliant mechanism (flexure) that provides the "spring" feel.
module flexure_spring() {
    eps = 0.02;
    difference() {
        union() {
            // Outer ring of the spring
            difference() {
                cylinder(h = thickness, r = outer_radius);
                translate([0, 0, -eps]) cylinder(h = thickness + 2*eps, r = outer_radius - arm_width);
            }
            // Inner ring of the spring
            difference() {
                cylinder(h = thickness, r = inner_radius + arm_width);
                translate([0, 0, -eps]) cylinder(h = thickness + 2*eps, r = inner_radius);
            }
            // Generate the 3 radial arms
            for (i = [0 : num_arms - 1]) arm_cutout(i * 120 + 60);
            
            // Create mounting pads where screws attach the spring to the base
            for (i = [0 : num_arms - 1]) {
                angle = i * 120 + 60;
                rotate([0, 0, angle]) translate([mount_radius, 0, -(pad_height - thickness)/2])
                cylinder(h = pad_height, d = pad_diameter, $fn = 64);
                
                // Hull to smoothly transition the pad into the spring arm
                rotate([0, 0, angle]) hull() {
                    translate([mount_radius, 0, thickness/2]) cylinder(h = eps, d = pad_diameter, center = true);
                    translate([mount_radius - arm_width, 0, thickness/2]) cylinder(h = eps, d = arm_width * 1.2, center = true);
                }
            }
        }
        // Drill screw holes through the mounting pads
        for (i = [0 : num_arms - 1]) {
            rotate([0, 0, i * 120 + 60]) translate([mount_radius, 0, -eps-1])
            cylinder(h = pad_height+1 + 2*eps, r = screw_d / 2, $fn = 64);
        }
    }
}

// Creates the vertical pillars that support the internal electronics/plate.
module mount_cylinders() {
    for (i = [0 : 2]) {
        rotate([0, 0, i * 120 + 60]) translate([mount_radius, 0, 0])
        difference() {
            cylinder(h = cyl_height, d = cyl_od, $fn = 64); // Pillar body
            cylinder(h = cyl_height + 0.1, d = screw_d, $fn = 32, center = false); // Screw hole
        }
    }
}

// Side-mounted mounting lugs used on the standard profile.
module horizontal_boss(){
    difference() {
        // Rotates and positions the attachment module for side-mounting
        translate([6,-7,-9]) rotate([90,0,90]) attachment();
        // Clean up internal overlaps
        translate([9,0,-4]) cube([35,10,10],center=true);
        translate([24,0,4]) cube([10,10,10],center=true);
        translate([0,0,0]) cylinder(10,17,17);
    }
}

// A generic cylinder with a screw hole used for various mounting points.
module attachment() {
    rotate([0, 0, 60]) translate([mount_radius, 0, 0])
    difference() {
        cylinder(h = cyl_height, d = cyl_od, $fn = 64);
        translate([0,0,-0.01]) cylinder(h = cyl_height + 0.1, d = screw_d, $fn = 32, center = false);
    }
}

// Helper to cut a hex-shaped recessed hole for a 1/4" bolt and nut.
module hex_bolt_hole_1_4inch(thickness, head_depth = 4, clearance = 0.3) {
    hex_d = (bolt_head_af + clearance) / cos(30); // AF to circumradius conversion
    union() {
        // Hexagonal recess
        rotate([0,0,30]) cylinder(h = head_depth, d = hex_d, $fn = 6);
        // Round shaft hole
        translate([0,0,-0.01]) cylinder(h = thickness + 0.02, d = bolt_diameter_1_4 + 0.4, $fn = 32);
    }
}

// TPU (flexible) covers for the internal mounting cylinders.
module spring() {
    difference(){
        translate([50,0,1]) cylinder(h = cyl_height/2, d = cyl_od+2, $fn = 64);
        translate([50,0,0]) cylinder(h = cyl_height/2, d = cyl_od, $fn = 64);
    }
}

// =============================================
// VERSION-SPECIFIC MODULES
// =============================================

// Internal centering post specific to the low-profile switch.
module central_dovetail_pedestal() {
    difference() {
        translate([0, 0, 1]) cube([12, 10, 2], center = true);
        // Cut grooves for dovetail-style sliding alignment
        translate([0, 0, 1]) cube([12.01, 1.2, 3], center = true);
        translate([0, 0, 1]) rotate([0,0,90]) cube([11, 1.2, 3], center = true);
    }
}

// The main foundation of the switch (Standard Profile logic).
module base() {
    difference() {
        cylinder(base_main_h, 20, 20); // Main cylinder
        translate([0, -10, 3]) rotate([90, 0, 0]) cylinder(21, 4, 4); // Wire exit hole
        translate([-3.95, -20, -5]) cube([7.9, 6, 8]); // Cable relief notch
        
        // Hollow out the center based on profile height
        translate([0, 0, (switch_type == "low_profile" ? -1 : -5)]) 
            cylinder((switch_type == "low_profile" ? 14 : 26), 17.5, 17.5);
            
        // Side mounting screw holes (3-way radial)
        for(a=[0, 120, 240]) {
            rotate([0,0,a]) translate([0,-.25,2.75]) rotate([90,90,90]) 
            cylinder(h = cyl_height+9 + 0.1, d = screw_d, $fn = 32, center = false);
        }
    }
    // Decorative/Reinforcement rim around the middle/top
    difference() {
        translate([0,0,base_rim_z]) cylinder(base_rim_h, 22.5, 22.5);
        cylinder((switch_type == "low_profile" ? 15 : 26), 17.5, 17.5);
    }
    // Add the external mounting bosses
    horizontal_boss();
    rotate([0,0,120]) horizontal_boss();
    rotate([0,0,240]) horizontal_boss();
}

// A thin cap ring used to close the top of the Standard Profile body.
module top() {
    difference() {
        cylinder(1, 20, 20);
        translate([0, 0, -1]) cylinder(5, 15, 15);
    }
}

// The outer shell of the switch. 
// Uses logic to switch between a single low-profile piece or a multi-part standard body.
module body() {
    if (switch_type == "low_profile") {
        difference() {
            cylinder(base_main_h, 20, 20); // Low-profile outer shell
            translate([0, 0, -1]) cylinder(18.75, 17.5, 17.5); // Internal hollow
            // Low-profile specific screw mounting orientations
            for(a=[0, 120, 240]) {
                rotate([0,0,a]) translate([0, 0, 2.75]) rotate([0, 90, 0]) cylinder(h = 30, d = screw_d);
            }
            translate([0, -10, 3]) rotate([90, 0, 0]) cylinder(21, 4, 4); // Wire port
        }
        // Top lip for low-profile version
        difference(){
            translate([0, 0, base_main_h]) cylinder(1, 20, 20);
            translate([0, 0, base_main_h-.001]) cylinder(h = 5, r = 14.5);
        }
    } else {
        // Standard profile: Combines the base and the top ring
        union() {
            base();
            translate([0, 0, 22]) top();
        }
    }
}

// The internal plate that sits between the spring and the external cap.
module button_top() {
    difference() {
        union() {
            cylinder(button_disc_h, 17.25, 17.25); // Main disc
            // Boss to interface with the spring, height varies by profile
            translate([0,0,(switch_type == "low_profile" ? -2 : -3)]) 
                cylinder(h = (switch_type == "low_profile" ? 3 : 4), r = inner_radius + arm_width+1);
        }
        // Center hole for the 1/4" bolt that links the button to the cap
        translate([0,0,(switch_type == "low_profile" ? -2.01 : -3.01)])
            hex_bolt_hole_1_4inch(thickness = (switch_type == "low_profile" ? 8 : 10), head_depth = 4, clearance = clearance_fit);
    }
}

// The external button you actually press.
module cap() {
    difference() {
        union() {
            cylinder(h = cap_base_h, r = 14, $fn = 64); // Vertical stem
            // Ergonomic dome using Minkowski sum for smooth edges
            translate([0,0,cap_base_h]) minkowski() {
                cylinder(h = 1.5, r = 20, $fn = 96);
                sphere(r = cap_dome_h * 0.8, $fn = 96);
            }
        }
        // Internal shaft hole for the bolt
        translate([0,0,-1]) cylinder(h = (switch_type == "low_profile" ? 11 : cap_base_h + cap_dome_h - 1.2), d = bolt_diameter_1_4, $fn = 32);
        // Small alignment notch for standard profile
        if (switch_type == "standard") translate([0,0,-1]) cylinder(h = 1, d1 = 3.8, d2 = 3.2, $fn = 32);
        
        // Nut pocket to secure the 1/4" bolt inside the cap
        translate([0,0,-0.01]) intersection() {
            translate([-12,-12,(switch_type == "low_profile" ? -1 : -4)]) cube([24,24,(switch_type == "low_profile" ? nut_thickness + 1 : 8)], center = false);
            rotate([0,0,30]) cylinder(h = nut_thickness + 0.5, d = (nut_af + clearance_fit)/cos(30), $fn = 6);
        }
    }
}

// The internal component that holds the microswitch and mounting pillars.
module switch_base() {
    difference() {
        cylinder((switch_type == "low_profile" ? 6 : 10), 22.5, 22.5); // Main base plate
        translate([0, 0, 0.5]) cylinder(10, 20.5, 20.5); // Internal pocket
        translate([0, 11, (switch_type == "low_profile" ? 2.75 : 4)]) rotate([90, 0, 0]) cylinder(50, 2, 2); // Secondary wire hole
        
        // Side mounting screw holes (drilled through pillars)
        if (switch_type == "standard") {
            for(a=[0, 120, 240]) rotate([0,0,a]) translate([0,-.25,2.75]) rotate([90,90,90]) cylinder(h = cyl_height+9 + 0.1, d = screw_d, $fn = 32, center = false);
        } else {
            for(a=[0, 120, 240]) rotate([0,0,a]) translate([0, 0, 2.75]) rotate([0, 90, 0]) cylinder(h = 30, d = screw_d);
        }
    }
    
    // Logic to select internal mounting geometry for the specific switch used
    if (switch_type == "low_profile") {
        central_dovetail_pedestal();
        translate([0,0,-1.9]) cylinder(h=2, r=25.4); // Wide base flange
    } else {
        // Standard profile internal switch housing (more complex/angled)
        difference() {
            translate([0, 0, 5.001]) cube([10, 10, 10], center = true);
            translate([0, 0, 9.001]) cube([11, 1.5, 3], center = true); // Wire channel
            translate([0, 3.25, 21.001]) rotate([45, 0, 0]) cube([15, 15, 20], center = true); // Ergonomic taper
            translate([0, -3.25, 21.001]) rotate([-45, 0, 0]) cube([15, 15, 20], center = true); // Ergonomic taper
            translate([0, 10, 2.5]) rotate([90, 0, 0]) cylinder(50, 2, 2);
            translate([-10, 0, 2.5]) rotate([90, 0, 90]) cylinder(20, 2, 2);
        }
        translate([0, 0, 8.75]) cube([2.5, 10, 2.5], center = true); // Top alignment tab
    }
    
    // Add the 3 internal pillars
    mount_cylinders();
    
    // External screw mounting ears (lugs)
    for (i = [0:2]) {
        rotate([0, 0, i * 120]) {
            difference() {
                translate([6,-7,-9]) rotate([90,0,90]) attachment();
                // Profile-specific logic to trim the lug so it doesn't overlap internal parts
                translate([(switch_type == "low_profile" ? 12 : 9), 0, (switch_type == "low_profile" ? 5 : -5)]) cube([(switch_type == "low_profile" ? 13 : 35), 10, 10], center=true);
                if (switch_type == "standard") translate([9,0,-5]) cube([35,10,10],center=true);
                translate([0, 0, 0.5]) cylinder(10, 20.5, 20.5);
            }
            if (switch_type == "standard") translate([0,0,-.9]) plinth(); // Round base for standard lugs
        }
    }
}

// =============================================
// ASSEMBLY & RENDER
// =============================================

// Visualizes how the switch looks fully put together.
module assembled() {
    translate([0,0,(switch_type == "low_profile" ? 10 : 20)]) color("purple") cap();
    color("red") body();
    translate([0, 0, -0.1]) color("yellow") switch_base();
    translate([0, 0, cyl_height + thickness + (switch_type == "low_profile" ? 1 : 2)]) color("green") button_top();
}

// Visualizes parts separated vertically to see the internal stacking.
module exploded_assembly() {
    translate([0,0,(switch_type == "low_profile" ? 20 : 38)]) color("red") body();
    translate([0, 0, -0.1]) color("yellow") switch_base();
    translate([0, 0, cyl_height + thickness + (switch_type == "low_profile" ? 7 : 15)]) color("green") button_top();
    translate([0,0,(switch_type == "low_profile" ? 45 : 60)]) color("purple") cap();
    // Offset for the TPU springs
    z_off = (switch_type == "low_profile" ? 4 : 9);
    translate([-43,11,cyl_height/2+z_off]) spring();
    translate([-43,-12,cyl_height/2+z_off]) spring();
    translate([-63,0,cyl_height/2+z_off]) spring();
}

// =============================================
// NEW COMPARISON MODULES
// =============================================

module side_by_side_comparison() {
    // Render Low Profile on the Left
    translate([-60, 0, 0]) {
        let(switch_type = "low_profile") {
            assembled();
            translate([0, 60, 0]) exploded_assembly();
        }
    }
    
    // Render Standard Profile on the Right
    translate([60, 0, 0]) {
        let(switch_type = "standard") {
            assembled();
            translate([0, 60, 0]) exploded_assembly();
        }
    }
}

// Main logic to render the specific part requested via the Customizer.
module render_selected() {
    if (part == "assembled") assembled(); 
    else if (part == "exploded_assembly") exploded_assembly(); 
    else if (part == "comparison") side_by_side_comparison(); // New Option
    else if (part == "body") color("red") body(); 
    else if (part == "switch_base") color("yellow") switch_base(); 
    else if (part == "button_top") color("green") button_top(); 
    else if (part == "cap") color("purple") cap(); 
    else if (part == "spring") color("teal") spring(); 
}
// Execute the render
render_selected();