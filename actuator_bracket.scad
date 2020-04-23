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

echo(act_len);

module actuator () {
  hole_goes=act_hole_d_to_box+act_hole_r;
  translate([-box[0],-box[1]/2,-box[2]/2]) cube(box);
  difference() {
    rotate([0,90,0]) cylinder(act_len, act_r, act_r);
    translate([hole_goes, act_hole_shaft_len/2 , 0 ])
      rotate([90,0,0])
      cylinder( act_hole_shaft_len, act_hole_r, act_hole_r); 
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
  circler = act_hole_d_to_end+act_hole_r;
  difference () {
    union () {
      cylinder(width,circler,circler);
      translate([-circler,0,0]) cube([2*circler,2*clearance,width]);
      translate([-width/2,-circler+clearance,width]) 
        rotate([90,0,90])
        triangle(clearance+circler,clearance);
    }
    translate([0,0,-1]) {
      cylinder(width+2,act_hole_r,act_hole_r);
    }
  }
}

up_to_hole = clearance+act_hole_d_to_end+act_hole_r;

translate([0,0,clearance+act_len]) rotate([0,90,0]) %actuator();

translate([0,act_r+slop,up_to_hole]) rotate([-90,0,0]) ear();

