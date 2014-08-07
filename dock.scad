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

module front_outline(){
    // Outline for the whole front
    difference(){
        hull(){
            translate([-40, -25, -thickness]) cylinder(r=5, h=thickness);
            translate([40, -25, -thickness]) cylinder(r=5, h=thickness);
            translate([-45, 0, -thickness]){
                cube(size=[90, 40, thickness]);
            }
        }
        hull(){
            translate([-40+thickness, -25+thickness, -1]) cylinder(r=5, h=2);
            translate([40-thickness, -25+thickness, -1]) cylinder(r=5, h=2);
            translate([-45+thickness, -thickness, -1]){
                cube(size=[90-2*thickness, 40, 2]);
            }
        }
    }
}

module front_plate(){
    // The front-plate
    hull(){
        front_outline();
    }
    translate([0,0,5]){
        resize([0, 0, 5]) front_outline();
    }
}
module front(){
    // The whole front-piece
    union(){
        coil_holder();
        mag_holders();
        front_plate();
    }
}

module rotated_front(){
    difference() {
    rotate([-110]){
        translate([0, -40]){
            front();
        }
    }
    rotate([180, 0, 180]){
        translate([-50, 0]){
            cube([100, 100, 10]);
        }
    }
    }
}

module base(){
    // The base
    translate([-45, 0, 0]){
        cube([90, 70, thickness]);
    }
}

module main(){
    difference(){
        union(){
            base();
            rotated_front();
        }
    }
}

main();
//front();
//rotated_front();
