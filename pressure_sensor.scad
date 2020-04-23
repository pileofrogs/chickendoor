button = [6,3.5,3.5];

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
wood_screw_radius = 2;
wood_screw_head_radius = 4.1;
wood_screw_head_height = 3.5;
wsr = wood_screw_radius;
wshr = wood_screw_head_radius;
wshh = wood_screw_head_height;

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
      translate([0,0,-(slop/2)])  barrel_cut_out();
      translate([0,0, 2/3 * hinge_plate_dims[1]+slop])  barrel_cut_out();
    }
    // keeping it shut screw
    #translate([hinge_plate_dims[0]/6, hinge_plate_dims[1]/2, -wshh])
      screw_head();
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
      translate([0,0, hinge_plate_dims[1]/3+(slop/2)])  barrel_cut_out();
    }
    
    sixth = hinge_plate_dims[0]/6;
    screws_at = [ [barrel_r+sixth,sixth,0], 
                  [hinge_plate_dims[1]-sixth, sixth,0],
                  [hinge_plate_dims[1]-sixth, hinge_plate_dims[1]-sixth,0],
   		  [barrel_r+sixth,hinge_plate_dims[1]-sixth,0], 
    ];
    for ( screw_at = screws_at ) {
      translate(screw_at) rotate([180,0,0]) screw_head ();
    }
    // hole for keep-it-closed screw
    translate([hinge_plate_dims[0]-sixth, hinge_plate_dims[1]/2, -width-slop])
        cylinder(width+2*slop,wsr*1.5,wsr*1.5);
    // button trough
    trough_width = button[1]+2*slop;
    translate([-slop,hinge_plate_dims[1]/2-trough_width/2,-1.5*width])
      cube([hinge_plate_dims[0]+2*slop,button[1]+2*slop,width ]);
  }
}


translate([-hinge_plate_dims[0]/2,-hinge_plate_dims[1]/2,0]) hingetop();

translate([hinge_plate_dims[0]/2+barrel_r*2+2*slop,-hinge_plate_dims[1]/2,0]) hingebottom();

module screw_head () {
  overlap = wshh/100;
  translate([0,0,wshh-overlap]) cylinder(wshh,wshr,wshr);
  cylinder(wshh,wsr,wshr);
  translate([0,0,-wshh+slop]) cylinder(width+slop,wsr,wsr);
}

