$fn = 32;

/* [Render Part] */
// Which part to render
part = "lid"; // [lid:Lid, box:Box, tpu_base:TPU Base]

/* [Hidden] */

// ─── Imports ────────────────────────────────────────────────────────────────

module electrocookie_import() {
    import("/home/ryhunsaker/GitHubRepos/Assistive_Switch_Collection/switches/Original_Designs/Prototyping_BT_SWITCH/Electrocookie Prototype board enclosures - 4969733/files/ElectroCookie_Enclosure_V3.stl");
}

module mono_jack_mount_import() {
    import("/home/ryhunsaker/GitHubRepos/Assistive_Switch_Collection/switches/Original_Designs/Prototyping_BT_SWITCH/RFS_Sw_Jack_Mount.stl");
}

module jst_3_pin_import() {
    import("/home/ryhunsaker/GitHubRepos/Assistive_Switch_Collection/switches/Original_Designs/Prototyping_BT_SWITCH/3pin.stl");
}

module jst_4_pin_import() {
    import("/home/ryhunsaker/GitHubRepos/Assistive_Switch_Collection/switches/Original_Designs/Prototyping_BT_SWITCH/4pin.stl");
}

// ─── Sub-components ─────────────────────────────────────────────────────────

module jst_3pin_mount() {
    difference() {
        cube([10, 3, 8], center = true);
        cube([8, 3.001, 6], center = true);
    }
}

module jst_4pin_mount() {
    jst_4_pin_import();
}

module mono_jack_mount() {
    difference() {
        mono_jack_mount_import();
        #translate([-25, 2.5, -5]) cube([60, 40, 40]);
        #translate([7, -20, -5])   cube([20, 40, 40]);
        #translate([-16, -20, -5]) cube([10, 40, 40]);
    }
}

// ─── Main assemblies ────────────────────────────────────────────────────────

module electrocookie_lid() {
    difference() {
        electrocookie_import();
        translate([-150, -75, -10]) cube([150, 150, 150]);
    }
}

module electrocookie_enclosure() {
    difference() {
        electrocookie_import();
        // JST slot cutouts
        translate([-4.00, -27, 10]) rotate([0, 0, 90]) cube([8, 10, 6], center = true);
        translate([-4.00, -10, 10]) rotate([0, 0, 90]) cube([8, 10, 6], center = true);
        translate([-4.00,   7, 10]) rotate([0, 0, 90]) cube([8, 10, 6], center = true);
        // Base trim
        translate([-32.75, 0, 0])  cube([50, 90, 1], center = true);
        translate([0, -75, -10])   cube([150, 150, 150]);
    }
    // Front vented wall
    difference() {
        translate([-45, -48, 0]) cube([30, 2, 22]);
        translate([-42, -49,  3]) cube([22, 5, 1]);
        translate([-42, -49,  5]) cube([22, 5, 1]);
        translate([-42, -49,  7]) cube([22, 5, 1]);
        translate([-42, -49,  9]) cube([22, 5, 1]);
        translate([-42, -49, 11]) cube([22, 5, 1]);
        translate([-42, -49, 13]) cube([22, 5, 1]);
        translate([-42, -49, 15]) cube([22, 5, 1]);
        translate([-42, -49, 17]) cube([22, 5, 1]);
        translate([-42, -49, 19]) cube([22, 5, 1]);
    }
    // Rear vented wall
    difference() {
        translate([-45, 46.5, 0]) cube([30, 1.5, 11]);
        translate([-42, 46, 3]) cube([22, 5, 1]);
        translate([-42, 46, 5]) cube([22, 5, 1]);
        translate([-42, 46, 7]) cube([22, 5, 1]);
        translate([-42, 46, 9]) cube([22, 5, 1]);
    }
}

module add_jst_3pin_slots() {
    difference() {
        union() {
            electrocookie_enclosure();
            translate([-5.25, -27, 10]) rotate([0, 0, 90]) color("blue")  { jst_3pin_mount(); }
            translate([-5.25, -10, 10]) rotate([0, 0, 90]) color("blue")  { jst_3pin_mount(); }
            translate([-5.25,   7, 10]) rotate([0, 0, 90]) color("blue")  { jst_3pin_mount(); }
        }
        #translate([-4.75, -27, 16]) rotate([90, 0,  90]) color("pink") { linear_extrude(1) { text("3 pin JST-PH Inputs", size = 3); } }
          translate([-61.5,  16, 16]) rotate([90, 0, -90]) color("blue") { linear_extrude(1) { text("Mono Jack Inputs",   size = 3); } }
    }
}

module add_mono_jack_mounts() {
    difference() {
        add_jst_3pin_slots();
        translate([-65,   0, 5]) rotate([0, 90, 0]) cylinder(10, r1 = 3, r2 = 3);
        translate([-65,  20, 5]) rotate([0, 90, 0]) cylinder(10, r1 = 3, r2 = 3);
        translate([-65, -20, 5]) rotate([0, 90, 0]) cylinder(10, r1 = 3, r2 = 3);
        translate([-60, -35, 1]) cube([15, 70, 1]);
    }
}

module tpu_base() {
    union() {
        translate([100, 0,      0]) cube([50, 90, 1], center = true);
        translate([100, 0, .99999]) cube([60, 95, 2], center = true);
    }
}

// ─── Customizer dispatch ────────────────────────────────────────────────────

if (part == "lid") {
    electrocookie_lid();
} else if (part == "box") {
    add_mono_jack_mounts();
} else if (part == "tpu_base") {
    tpu_base();
}
