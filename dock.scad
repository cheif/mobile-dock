thickness = 0.7;

mag_centers = [[-16, -16], [-16, 16],
               [16, -16], [16, 16]];

module high_mag(pos){
    // The magnet, only very high
    radius = 6;
    height = 100;
    translate(pos){
        cylinder(h=height, r=radius);
    }
}

module hollow(pos, radius, height) {
    // Hollow cylinder
    translate(pos){
        difference() {
            cylinder(h=height, r=radius+thickness);
            translate([0,0,-1]){
                cylinder(h=height+2, r=radius);
            }
        }
    }
}
module mag_holder(pos){
    // Holder of one magnet
    hollow(pos, 6, 3);
}

module mag_holders(){
    // All magnet holders
    for (pos = mag_centers){
        mag_holder(pos);
    }
}

module coil_holder(pos=[0,0,0]){
    // Holder of the charging-coil
    difference(){
        hollow(pos, 25, 5);
        // Remove intersection with the mag-holders
        for(pos = mag_centers){
            mag_holder(pos);
            high_mag([pos[0], pos[1], -1]);
        }
    }
}

module front(){
    // The front-plate
    hull(){
        translate([-40, -25, -thickness]) cylinder(r=5, h=thickness);
        translate([40, -25, -thickness]) cylinder(r=5, h=thickness);
        translate([-45, 0, -thickness]){
            cube(size=[90, 40, thickness]);
    }
    }
}
module front_piece(){
    // The whole front-piece
    union(){
        coil_holder();
        mag_holders();
        front();
    }
}

module rotated_front(){
    rotate([-110]){
        translate([0, -40]){
            front_piece();
        }
    }
}
module base(){
    // The base
    translate([-45, 0, 0]){
        cube([90, 70, thickness]);
    }
}
union(){
    base();
    rotated_front();
}

