barrel_r = 3;
pin_r = barrel_r/2;
ear_width = 5;
slop = 1;

act_r = 10.5;
act_hole_r = 3;
act_len = 100;
act_hole_d_to_end = 6;
act_hole_shaft_len = 50;
hinge_plate_dims = [act_r*6, act_r*6, 3];


$fn = 100;

module actuator_piston () {
  %translate([-act_len + act_hole_d_to_end + act_hole_r , 0, act_r]) {
    hole_goes = act_len - act_hole_d_to_end - act_hole_r;
    rotate([0,90,0]) cylinder(act_len, act_r, act_r);
    translate([hole_goes, act_hole_shaft_len/2 , 0 ]) rotate([90,0,0]) cylinder( act_hole_shaft_len, act_hole_r, act_hole_r); 
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

actuator_piston();

translate([0, act_r+ear_width+slop, -0.5*act_r]) rotate([90,0,0]) ears(ear_width, 1.5 * act_r, act_hole_r+slop);
translate([0, -(act_r+slop), -0.5*act_r]) rotate([90,0,0]) ears(ear_width, 1.5 * act_r, act_hole_r+slop);

to_the_top = -0.5*act_r;

difference () {
  union () {
     translate([-hinge_plate_dims[0]/2,-hinge_plate_dims[1]/2,to_the_top-hinge_plate_dims[2]]) cube(hinge_plate_dims);
  
    translate([-1.5*hinge_plate_dims[0]-slop,-hinge_plate_dims[1]/2,to_the_top-hinge_plate_dims[2]]) cube(hinge_plate_dims);
  }
  translate([-hinge_plate_dims[0]/2-slop/2,-hinge_plate_dims[1]/2-1,to_the_top - barrel_r]) rotate([270,0,0]) cylinder(hinge_plate_dims[0]+2,barrel_r+slop,barrel_r+slop);
}


translate([-hinge_plate_dims[0]/2-slop/2,-hinge_plate_dims[1]/2,to_the_top - barrel_r]) rotate([270,0,0]) difference () {
 cylinder(hinge_plate_dims[0],barrel_r,barrel_r);
  translate([0,0,-1]) cylinder(hinge_plate_dims[0]+2,pin_r,pin_r);
}



