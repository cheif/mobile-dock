thickness = 0.7;

mag_centers = [[-16, -16], [-16, 16],
               [16, -16], [16, 16]];

mag_thickness = 2.5;
mag_radius = 5;

coil_thickness = 2;
coil_radius = 25.5;

board_width = 40;
board_depth = 31;
board_thickness = 3;

module high_mag(pos){
    // The magnet, only very high
    radius = mag_radius;
    height = mag_thickness*10;
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
    hollow(pos, mag_radius, mag_thickness);
}

module mag_holders(){
    // All magnet holders
    difference(){
        for (pos = mag_centers){
            mag_holder(pos);
        }
        // Remove a cross in the middle
        rotate(45){
            cube([40, 3, 20], center=true);
            cube([3, 40, 20], center=true);
        }
    }
}

module coil_holder(pos=[0,0,0]){
    // Holder of the charging-coil
    difference(){
        hollow(pos, coil_radius, coil_thickness + mag_thickness);
        // Remove intersection with the mag-holders
        for(pos = mag_centers){
            mag_holder(pos);
            high_mag([pos[0], pos[1], -1]);
        }
        // Remove a channel at the bottom for wires
        translate([0, 10]){
            cube([12, 40, 20], center=true);
        }
    }
}

module front_outline(){
    // Outline for the whole front
    difference(){
        hull(){
            translate([-25, -25, -thickness]) cylinder(r=5, h=thickness);
            translate([25, -25, -thickness]) cylinder(r=5, h=thickness);
            translate([-30, 0, -thickness]){
                cube(size=[60, 40, thickness]);
            }
        }
        hull(){
            translate([-25+thickness, -25+thickness, -1]) cylinder(r=5, h=2);
            translate([25-thickness, -25+thickness, -1]) cylinder(r=5, h=2);
            translate([-30+thickness, -thickness, -1]){
                cube(size=[60-2*thickness, 40, 2]);
            }
        }
    }
}

module qi_logo(){
    //Logotype
    translate([-18, 30, -1]){
        linear_extrude(height=0.5){
            rotate([0, 180, 180]){
                resize([30, 0], auto=true){
                    import("qi-logo.dxf");
                }
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
    qi_logo();
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
    translate([-30, 0, 0]){
        cube([60, 40, thickness]);
    }
}

module thick_board(){
    // The board
        cube([board_width, board_depth, board_thickness+2]);
}

module board_holder() {
    // Corners around the board to hold it in place
    difference() {
    translate([-board_width/2-1, 6, thickness]){
        difference() {
            cube([board_width+2*thickness, board_depth+2*thickness, board_thickness]);
            translate([2, -1, -1]) {
                cube([board_width-2, board_depth+4, board_thickness+2]);
            }
            translate([-1, 2, -1]) {
                cube([board_width+4, board_depth-2, board_thickness+2]);
            }
            translate([thickness, thickness, -1]) {
                thick_board();
            }
        }
    }
    }
}

module main(){
    difference(){
        union(){
            base();
            rotated_front();
            board_holder();
        }
    }
}

//main();
//front();
//rotated_front();
main();
