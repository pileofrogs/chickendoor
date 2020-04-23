act_r = 10.5;
act_hole_r = 3;
act_hole_d_to_end = 4;
act_hole_d_to_box = 8;
act_len = act_hole_d_to_end+act_hole_d_to_box+2*act_hole_r;
box = [39,39,39];
act_hole_shaft_len = 50;
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

module ear () {
  circler = act_hole_d_to_end+act_hole_r;
  difference () {
    union () {
      cylinder(width,circler,circler);
      translate([0,-circler,0]) cube([upness,upness/2,width]);
      translate([-circler,0,0]) cube([upness/2,upness,width]);
    }
    translate([0,0,-1]) {
      cylinder(width+2,act_hole_r,act_hole_r);
      translate([upness,-upness/2,0]) rotate([0,0,45]) cube([upness*2,upness*2,width+2]);
    }
  }
}

//translate([0,0,upness]) rotate([0,90,0]) %actuator();

ear();

