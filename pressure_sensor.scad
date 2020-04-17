width = 5;
slop = 1;
pin_r = 2;

act_r = 10.5;
act_hole_r = 3;
act_len = 100;
act_hole_d_to_end = 6;
act_hole_shaft_len = 50;
hinge_plate_dims = [act_r*6, act_r*6, width];
barrel_r = width+pin_r;


$fn = 100;

module actuator_piston () {
  hole_goes=-(act_hole_d_to_end+act_hole_r);
  %translate([hole_goes , 0, act_r]) {
    rotate([0,90,0]) cylinder(act_len, act_r, act_r);
    translate([-hole_goes, act_hole_shaft_len/2 , 0 ]) rotate([90,0,0]) cylinder( act_hole_shaft_len, act_hole_r, act_hole_r); 
  }
}

module ears ( thickness, rad, hole_rad ) {
  translate([0,rad,0]) difference() {
      union () {
          cylinder( thickness, rad, rad );
          translate([-rad*2,-rad,0]) cube([rad*4, rad, thickness]);
      }
      translate([0,0,-0.5]) cylinder( thickness+1, hole_rad, hole_rad);
      translate([ rad*2, 0, -0.5]) cylinder( thickness+1, rad,rad);
      translate([ -rad*2, 0, -0.5]) cylinder( thickness+1, rad,rad);
  }
}
translate([0,0,0.5*act_r]) actuator_piston();

module barrel_cut_out () {
    cylinder(hinge_plate_dims[0]/3+2*slop, barrel_r+slop, barrel_r+slop);
}

module hingetop () {
  // The flangy ear things around the piston
  translate([hinge_plate_dims[0]/2, hinge_plate_dims[1]/3-slop, 0]) rotate([90,0,0]) ears(width, 1.5 * act_r, act_hole_r);
  translate([hinge_plate_dims[0]/2, 2/3*hinge_plate_dims[1]+width+slop, 0]) rotate([90,0,0]) ears(width, 1.5 * act_r, act_hole_r);
  
  difference() {
    union () {
      // The hinge
      translate([0,0,-hinge_plate_dims[2]]) cube(hinge_plate_dims);
  
      // The barrel
      translate([hinge_plate_dims[0], 0, -barrel_r]) rotate([270, 0, 0]) 
      cylinder(hinge_plate_dims[0], barrel_r, barrel_r);
    }
    translate([hinge_plate_dims[0], 0, -barrel_r]) rotate([270, 0, 0]) {
      translate([0,0,-(slop/2)]) cylinder(hinge_plate_dims[0]+2,pin_r,pin_r);
      #translate([0,0,-(slop/2)])  barrel_cut_out();
      #translate([0,0, 2/3 * hinge_plate_dims[1]+slop])  barrel_cut_out();
    }
  }

}

module hingebottom () {
  difference () {
    union () {
      translate([0,0, -hinge_plate_dims[2]]) cube(hinge_plate_dims);
      translate([0, 0, -barrel_r]) rotate([270, 0, 0]) 
        cylinder(hinge_plate_dims[0], barrel_r, barrel_r);
    }
    translate([0, 0, -barrel_r]) rotate([270, 0, 0]) {
      translate([0,0,-(slop/2)]) cylinder(hinge_plate_dims[0]+2,pin_r,pin_r);
      #translate([0,0, hinge_plate_dims[1]/3+(slop/2)])  barrel_cut_out();
    }
  }
}


translate([-hinge_plate_dims[0]/2,-hinge_plate_dims[1]/2,0]) hingetop();

translate([hinge_plate_dims[0]/2+barrel_r*2+2*slop,-hinge_plate_dims[1]/2,0]) hingebottom();
