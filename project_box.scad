/*** Constants ***/

RPI = [ 55, 85, 1 ];
RELAYS = [ 32.5, 46, 17 ];

FUDGE = 0.25;  // extra space for parts to fit
WALL_THK = 2; // how thick the walls are
FLANGE_R = 10;
FLANGE_SCREW_R = 2;

BOX_INNER = [ bigger_of(RPI[0], RELAYS[0]) + 10, RPI[1] + RELAYS[1] + 20 , 20 ];
BOX_OUTER = [ BOX_INNER[0]+WALL_THK*2, BOX_INNER[1]+WALL_THK*2, BOX_INNER[2]+WALL_THK*2 ];

echo(BOX_OUTER);
echo(BOX_INNER);

/*** Functions ***/

function bigger_of (thing1, thing2) = thing1>thing2 ? thing1 : thing2;


/*** Modules, aka parts ***/

module box_lid() {
// box lid goes over project stuff
  difference() {
    cube(BOX_OUTER);
    union () {
      translate([WALL_THK,WALL_THK, WALL_THK]) cube([ BOX_INNER[0], BOX_INNER[1], BOX_INNER[2]+WALL_THK*2]);
      translate([BOX_OUTER[0]/2, RPI[1]+10, -  WALL_THK/2]) cylinder( WALL_THK*2, FLANGE_SCREW_R, FLANGE_SCREW_R);
    }
  } 
}



module box_bottom () {
  // project goes on flat board bottom of box thingy
  box_bottom = [BOX_OUTER[0],BOX_OUTER[1], WALL_THK];
 
    translate([-2*WALL_THK, -2*WALL_THK, -WALL_THK]) {
    cube(box_bottom); 
    difference() {
      translate([ WALL_THK, WALL_THK, WALL_THK]) cube([BOX_INNER[0]-FUDGE, BOX_INNER[1]-FUDGE, WALL_THK ]);
      translate([ WALL_THK*2, WALL_THK*2, WALL_THK+  FUDGE]) cube([ BOX_INNER[0]-(2*WALL_THK+FUDGE),BOX_INNER[1]-(2*WALL_THK+FUDGE), WALL_THK ]);
    }
    translate([0, BOX_OUTER[1]-FLANGE_R*2, 0]) rotate([0,0,90]) screw_flange( );
    translate([0, FLANGE_R*2, 0]) rotate([0,0,90]) screw_flange( );

    translate([BOX_OUTER[0], BOX_OUTER[1]-FLANGE_R*2, 0]) rotate([0,0,270]) screw_flange( );
    translate([BOX_OUTER[0], FLANGE_R*2, 0]) rotate([0,0,270]) screw_flange( );
  }
  
}

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

module corner_standoff ( dimensions ) {
 translate([ -0.5*WALL_THK, -0.5*WALL_THK,0]) difference () {
  cube( dimensions );
  union () {
    translate([WALL_THK,WALL_THK  ,-0.5*WALL_THK]) cube( [dimensions[0]+WALL_THK, dimensions[1]+WALL_THK, dimensions[2]+WALL_THK ]);  
    }
    translate([ 0.5*WALL_THK,0.5*WALL_THK, dimensions[2]-WALL_THK]) cube([dimensions[0], dimensions[1], WALL_THK*2]);
  }
}
/*** Laying out the stuff ***/

to_the_right = BOX_OUTER[0]+FLANGE_R*2+3*WALL_THK;

// Box Bottom & Top
box_bottom();
translate([to_the_right, 0, 0]) box_lid();

// Central Standoff Post
translate([(BOX_INNER[0]-WALL_THK)/2, RPI[1]+10, 0]) standoff (BOX_INNER[2]-WALL_THK,3,1);

translate([0, 100, 0]) corner_standoff([5,5,5 ]);