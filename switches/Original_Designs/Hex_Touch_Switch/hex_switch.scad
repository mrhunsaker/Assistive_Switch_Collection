$fn = 32;

/* [Render Part] */
// Which part to render
part = "cap"; // [cap:Hex Cap, body:Hex Body, cap_slot:Cap Slot Test, assembly:Full Assembly]

/* [Hidden] */

// ─── Imports ────────────────────────────────────────────────────────────────

module hex_cap_ttp223() {
    color("red") {
        import("hextouch_open_base.stl");
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

module switch_hex_cap() {
    union() {
        hex_cap_ttp223();
        switch_top_slot();
    }
}

module switch_hex_body() {
    side   = 20.7;
    wall   = 1.75;
    height = 14;

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
        translate([-15, 8.75, 4.5]) rotate([90, 0, 60]) cylinder(75, 2, 2, $fn = 32);
    }

    rotate([0, 0, -30]) {
        difference() {
            translate([0, 0, 3.99999]) cube([10, 10, 4], center = true);
            translate([0,  0,   11.001]) cube([11, 1.5, 3], center = true);          // Wire channel
            translate([0,  3.25, 23.001]) rotate([ 45, 0, 0]) cube([15, 15, 22], center = true); // Ergonomic taper
            translate([0, -3.25, 23.001]) rotate([-45, 0, 0]) cube([15, 15, 22], center = true); // Ergonomic taper
            translate([0,  10.5,  4.5]) rotate([90, 0,  0]) cube([1, 10, 20]);
            translate([-10, 0,   4.5]) rotate([90, 0, 90]) cylinder(75, 2, 2);
        }
    }
}

module full_assembly() {
    switch_hex_body();
    translate([0, 0, 12.5]) switch_hex_cap();
}

// ─── Customizer dispatch ─────────────────────────────────────────────────────

if (part == "cap") {
    switch_hex_cap();
} else if (part == "body") {
    switch_hex_body();
} else if (part == "cap_slot") {
    switch_top_slot();
} else if (part == "assembly") {
    full_assembly();
}
