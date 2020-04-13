FUDGE = 0.25;  // extra space for parts to fit
WALL_THK = 2; // how thick the walls are
BOX_OUTER = [60,100,40];  // how big the box is
FLANGE_R = 10;
FLANGE_SCREW_R = 2;

function box_inner() = [BOX_OUTER[0]-WALL_THK*2, BOX_OUTER[1]-WALL_THK*2, BOX_OUTER[2] ]; 

module box_lid() {
// box lid goes over project stuff
  difference() {
    cube(BOX_OUTER);
    union () {
      translate([WALL_THK,WALL_THK, WALL_THK]) cube(   box_inner());
      translate([BOX_OUTER[0]/2, BOX_OUTER[1]/2, -  WALL_THK/2]) cylinder( WALL_THK*2, FLANGE_SCREW_R, FLANGE_SCREW_R);
    }
  } 
}



module box_bottom (BOX_OUTER) {
  // project goes on flat board bottom of box thingy
  box_bottom = [BOX_OUTER[0],BOX_OUTER[1], WALL_THK];
  box_inner = box_inner();
  //union () {
    cube(box_bottom); 
    // make lip
    difference() {
      translate([ WALL_THK, WALL_THK, WALL_THK]) cube([box_inner[0]-FUDGE, box_inner[1]-FUDGE, WALL_THK ]);
      translate([ WALL_THK*2, WALL_THK*2, WALL_THK+  FUDGE]) cube([ box_inner[0]-(2*WALL_THK+FUDGE),box_inner[1]-(2*WALL_THK+FUDGE), WALL_THK ]);
    }
  //}
  
}

box_bottom = [BOX_OUTER[0],BOX_OUTER[1], WALL_THK];
cube(box_bottom);

module screw_flange ( ) {
   translate([0,FLANGE_R,0]) difference() {
       union () {
           cylinder( WALL_THK, FLANGE_R, FLANGE_R );
           translate([-FLANGE_R*2,-FLANGE_R,0]) cube([FLANGE_R*4, FLANGE_R, WALL_THK]);
       }
       translate([0,0,-0.5]) cylinder( WALL_THK+1, FLANGE_SCREW_R, FLANGE_SCREW_R);
       translate([ FLANGE_R*2, 0, -0.5]) cylinder( WALL_THK+1, FLANGE_R,FLANGE_R);
       translate([ -FLANGE_R*2, 0, -0.5]) cylinder( WALL_THK+1, FLANGE_R,FLANGE_R);
   }
   
}

module standoff (height, rad, screw_rad) {
    difference () {
      cylinder(height, rad, rad);
      translate([0,0,WALL_THK]) cylinder(height, screw_rad, screw_rad);
    }   
}

to_the_right = BOX_OUTER[0]+FLANGE_R*2+3*WALL_THK;

// Box Bottom & Top
box_bottom();
translate([to_the_right, 0, 0]) box_lid();

// Flanges
translate([0, BOX_OUTER[1]-FLANGE_R*2, 0]) rotate([0,0,90]) screw_flange( );
translate([0, FLANGE_R*2, 0]) rotate([0,0,90]) screw_flange( );

translate([BOX_OUTER[0], BOX_OUTER[1]-FLANGE_R*2, 0]) rotate([0,0,270]) screw_flange( );
translate([BOX_OUTER[0], FLANGE_R*2, 0]) rotate([0,0,270]) screw_flange( );

// Standoff Post
translate([BOX_OUTER[0]/2, BOX_OUTER[1]/2, 0]) standoff (BOX_OUTER[2]-WALL_THK,3,1);

