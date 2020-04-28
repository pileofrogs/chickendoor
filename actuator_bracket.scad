act_r = 10.5;
act_hole_r = 3;
act_hole_d_to_end = 4;
act_hole_d_to_box = 8;
act_len = act_hole_d_to_end+act_hole_d_to_box+2*act_hole_r;
box = [39,39,39];
act_hole_shaft_len = 50;
clearance = 12; //
width = 5;
slop = 1;
upness = 30;

$fn = 100;

use <common_shapes.scad>;

echo(act_len);

module actuator () {
  hole_goes=act_hole_d_to_box+act_hole_r;
  translate([0,0,hole_goes]) rotate([0,90,0]) {
    translate([-box[0],-box[1]/2,-box[2]/2]) cube(box);
    difference() {
      rotate([0,90,0]) cylinder(act_len, act_r, act_r);
      translate([hole_goes, act_hole_shaft_len/2 , 0 ])
        rotate([90,0,0])
        cylinder( act_hole_shaft_len, act_hole_r, act_hole_r); 
    }
  }
}

module triangle (side,base) {
  hypot = sqrt(pow(side,2)+pow(base,2));
  angle = asin(base/hypot);
  difference () {
    cube([side,base,width]);
    translate([0,0,-1]) rotate([0,0,angle]) cube([hypot,base,width+2]);
  }
}

module ear () {
  translate ([0,0,clearance*2]) {
    rotate([-90,0,0]) {
      circler = act_hole_d_to_end+act_hole_r;
      difference () {
        union () {
          cylinder(width,circler,circler);
          translate([-circler,0,0]) cube([2*circler,2*clearance,width]);
          translate([-width/2,-circler+clearance,width]) 
            rotate([90,0,90])
            triangle(clearance+circler,clearance);
          translate([-circler,clearance,0]) rotate([0,0,90]) triangle(clearance,clearance/2);
          translate([circler,clearance,width]) rotate([180,0,90]) triangle(clearance,clearance/2);
        }
        translate([0,0,-1]) {
          cylinder(width+2,act_hole_r,act_hole_r);
        }
      }
    }
  }
}

translate([0,0,clearance*2]) %actuator();

translate([0,act_r+slop,0]) ear();
translate([0,-act_r-slop,0]) rotate([0,0,180])  ear();

ybase = 2*(clearance+width)+2*act_r+2*slop;
xbase = clearance+3*width;



difference() {
  translate([-xbase/2,-ybase/2,-width]) cube([xbase,ybase,width]);
  screw_head(3.5,4.1,2,width+slop);
  sx_offset = xbase/2-width;
  sy_offset = ybase/2-clearance/2;
  places = [
    [sx_offset,sy_offset,0],
    [-sx_offset,sy_offset,0],
    [sx_offset,-sy_offset,0],
    [-sx_offset,-sy_offset,0],
  ];
  for ( place = places ) {
    echo(place);
    translate(place) screw_head(3.5,4.1,2,width+slop);
  }
}
