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
    translate([0,0,-thickness/2]){
        cube(size=[70, 55, thickness], center=true);
    }
}
union(){
    coil_holder();
    mag_holders();
    front();
}
