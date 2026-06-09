$fn = 32;

/* [Render Part] */
// Which part to render
part = "blowup_assembled"; // [cap_base:Hex Cap Base, cap_cover:Hex Cap Cover, hex_cap_with_ridging:Cap with Ridges, body:Hex Body, spring:spring, assembled:Assembled Switch, blowup_assembled:Assembly Part List, assembly:Full Assembly]

/* [Hidden] */

// ─── Imports ────────────────────────────────────────────────────────────────

module hex_cap_ttp223() {
    color("red") {
        import("hextouch_open_base.stl");
    }
}

module hex_cap_ttp223_cover() {
color("violet"){
    import("hextouch_open_lid_noholes.stl");
}
}
// ─── Sub-components ─────────────────────────────────────────────────────────

module switch_top_slot() {
    difference() {
        translate([0, 0, -1.5]) cylinder(3, 8, 8, center = true, $fn = 6);
        translate([0, 0, -2.2]) cube([4.05, 4.05, 2.75], center = true);
    }
}

// ─── Main assemblies ────────────────────────────────────────────────────────
module switch_hex_cap_cover() {
hex_cap_ttp223();
}

module switch_hex_cap() {
    difference() {
    union() {
        translate([-46,0,0])rotate([0,0,0])color("yellow"){hex_cap_ttp223_cover();}
        switch_top_slot();
    }
    translate([-5,8.5,-5])cube([10,3,20]);
}
}




module hex_cap_whole() {
translate([0,0,15.5])switch_hex_cap();
rotate([0,0,180])translate([0,0,25])rotate([180,0,0])hex_cap_ttp223();
}

module hex_cap_with_ridging() {
difference() {
rotate([0,0,-120]){hex_cap_whole();}
translate([0,15,0])cube([2,5,85]);
translate([0,-20,0])cube([2,5,85]);

rotate([0,0,60]) {translate([0,15,0])cube([2,5,85]);
translate([0,-20,0])cube([2,5,85]);}

rotate([0,0,-60]) {translate([0,15,0])cube([2,5,85]);
translate([0,-20,0])cube([2,5,85]);}
}
}


module switch_hex_body() {
    side   = 20.7;
    wall   = 1.75;
    height = 18.5;

    difference() {
        // Outer solid
        linear_extrude(height = height)
            offset(delta = wall)
                circle(r = side, $fn = 6);
        // Inner cavity, leaving a 2 mm bottom
        translate([0, 0, wall + 2])
            linear_extrude(height = height)
                circle(r = side, $fn = 6);
        // Side cable hole
        translate([-15, 8.75, 4.5]) rotate([90, 0, 60]) cylinder(75, 3, 3, $fn = 32);
        // Wide Wire Ribbon Hole
        translate([20, -11, 9]) rotate([90, 0, 60]) cube([10,3,15],center=true);
    }

    rotate([0, 0, -30]) {
        difference() {
            translate([0, 0, 3.99999]) cube([10, 10, 4], center = true);
            translate([0,  0,   11.001]) cube([11, 1.5, 3], center = true);          // Wire channel
            translate([0,  3.25, 23.001]) rotate([ 45, 0, 0]) cube([15, 15, 22], center = true); // Ergonomic taper
            translate([0, -3.25, 23.001]) rotate([-45, 0, 0]) cube([15, 15, 22], center = true); // Ergonomic taper
            translate([-.75,  10.0,  4.5]) rotate([90, 0,  0]) cube([1.5, 10, 20]);
            translate([-10, 0,   4.5]) rotate([90, 0, 90]) cylinder(75, 2, 2);
        }
    }
    translate([0,17,8.5])cube([1,2,9]);
    translate([0,-19,8.5])cube([1,2,9]);

    rotate([0,0,60]) {translate([0,17,8.5])cube([1,2,9]);
    translate([0,-19,12.5])cube([1,2,5]);}

    rotate([0,0,-60]) {translate([0,17,8.5])cube([1,2,9]);
    translate([0,-19,8.5])cube([1,2,9]);}
}

module switch_hex_spring()
{
    sp_side   = 14;
    sp_wall   = 1.25;
    sp_height = 16.5;

    spring_h = 3.0;

    // radial clearance at top of spring zone
    clearance = 0.3;   // 0.2–0.4 mm target

    inner_r = sp_side;
    inner_r_top = sp_side + clearance;

    difference()
    {
        // -----------------------
        // OUTER SHELL (unchanged)
        // -----------------------
        linear_extrude(height = sp_height)
            offset(delta = sp_wall)
                circle(r = sp_side, $fn = 6);

        // ----------------------------------------
        // INNER CAVITY WITH RADIAL TAPER (KEY FIX)
        // ----------------------------------------
        union()
        {
            // lower rigid cavity (no clearance)
            translate([0,0,sp_wall -2])
                linear_extrude(height = sp_height+3)
                    circle(r = inner_r, $fn = 6);

            // upper spring zone cavity (expanded)
            translate([0,0,sp_height - spring_h])
                linear_extrude(height = spring_h)
                    circle(r = inner_r_top, $fn = 6);
        }

        // -----------------------
        // SIDE CABLE HOLE
        // -----------------------
        translate([-15, 8.75, 4.5])
            rotate([90, 0, 60])
                cylinder(h = 75, r = 2, $fn = 32);

        // -----------------------
        // RIBBON SLOT
        // -----------------------
        translate([15, -8, 9])
            rotate([90, 0, 60])
                cube([10, 2.5, 15], center = true);
    }
}
// -----------------------------------------

module assembled() {
switch_hex_body();
translate([0,0,15.5])switch_hex_cap();
translate([-46,0,19])rotate([180,0,0])hex_cap_ttp223_cover();
}

module blowup_assembled() {
switch_hex_body();
translate([0,0,22.5])switch_hex_cap();
translate([-46,0,31])rotate([180,0,0])hex_cap_ttp223_cover();
}

module full_assembly() {
translate([0,0,0])switch_hex_body();
translate([35,-25,0])switch_hex_body();
translate([-35,-25,0])switch_hex_body();
}

// ─── Customizer dispatch ─────────────────────────────────────────────────────

if (part == "cap_base") {
    switch_hex_cap();
} else if (part == "cap_cover") {
    switch_hex_cap_cover();
} else if (part =="hex_cap_with_ridging") {
hex_cap_with_ridging();
} else if (part == "body") {
    switch_hex_body();
} else if (part == "spring") {
    switch_hex_spring();
} else if (part == "assembled") {
    assembled();
} else if (part == "blowup_assembled") {
    blowup_assembled();
} else if (part == "assembly") {
    full_assembly();
}

