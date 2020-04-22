/*** Constants ***/
ROOM = 5;  // space around all the parts
RPI = [ 70, 119.5, 20 ];  // dimensions of a fictional R PI
RELAYS = [ 46, 32.5, 17 ];  // same for relay board
FUDGE = 0.25;  // extra space for parts to fit
WALL_THK = 2; // how thick the walls are
FLANGE_R = 10; // I like the look of it
FLANGE_SCREW_R = 2.5; // replace with actual screw hole radius
STANDOFF_R = 3; // Radius of round standoffs
STANDOFF_SCREW_R = 1.4; // radius of hole in the standoffs
STH = 4.5+WALL_THK; // standoff height
RPI_HOLE_1 = [45,21,0];

RPI_HOLE_SPECS = [54-18-12.5,85.6-25.5-5,0];

RPI_HOLE_2 = [RPI_HOLE_1[0]-RPI_HOLE_SPECS[0]+WALL_THK,RPI_HOLE_1[1]+RPI_HOLE_SPECS[1],0];

/*
NEED
WIRE_HOLE
zip-tie place for wires exiting 
Button mount point

Wires
2 wires for linear actuator
1 5mm 12v power
2 5v power
2 for pressure sensor
*/

WIRE_BUNDLE=(5+2+2+2)/2;

$fn=100;

BOX_INNER = [ bigger_of(RPI[0], RELAYS[0]) + 2*ROOM, RPI[1] + RELAYS[1] + 4*ROOM+2*WALL_THK+2*STANDOFF_R , bigger_of(RPI[2],RELAYS[2])+STH+ROOM ];
BOX_OUTER = [ BOX_INNER[0]+WALL_THK*2, BOX_INNER[1]+WALL_THK*2, BOX_INNER[2]+WALL_THK*2 ];

BASE_INNER = [ BOX_INNER[0]-2*WALL_THK, BOX_INNER[1]-2*WALL_THK, BOX_INNER[2] ]; 

/*** Functions ***/

function bigger_of (thing1, thing2) = thing1>thing2 ? thing1 : thing2;

/*** Modules, aka parts ***/

module box_lid() {
// box lid goes over project stuff
  standoff_goes = [BOX_OUTER[0]/2, RPI[1]+3*ROOM+STANDOFF_R-1, -  WALL_THK/2];
  difference() {
    cube(BOX_OUTER);
    union () {
      #translate([WALL_THK,WALL_THK, WALL_THK]) cube([ BOX_INNER[0], BOX_INNER[1], BOX_INNER[2]+WALL_THK*2]);
      translate(standoff_goes) cylinder( WALL_THK*2, FLANGE_SCREW_R, FLANGE_SCREW_R);
    }
    translate([standoff_goes[0],BOX_OUTER[1]+WALL_THK,BOX_OUTER[2]-WIRE_BUNDLE]) {
      rotate([90,0,0]) cylinder(WALL_THK*3,WIRE_BUNDLE,WIRE_BUNDLE);
      translate([-WIRE_BUNDLE,-3*WALL_THK,0]) cube([WIRE_BUNDLE*2,3*WALL_THK,WIRE_BUNDLE+1]);
    }
  } 
  /*
  %translate([-100, standoff_goes[1], 0]) cube([200,0.1,20]);
  %translate([-100, BOX_OUTER[1], 0]) cube([200,0.1,20]);
  %translate([-100, BOX_OUTER[1]-WALL_THK, 0]) cube([200,0.1,20]);
  %translate([-100, WALL_THK, 0]) cube([200,0.1,20]);
  %translate([-100, 0, 0]) cube([200,0.1,20]);
  */

}


module box_bottom () {
  // project goes on flat board bottom of box thingy
  box_bottom = [BOX_OUTER[0],BOX_OUTER[1], WALL_THK];
 
  translate([-2*WALL_THK, -2*WALL_THK, -WALL_THK]) {
    xhalf = BASE_INNER[0]/2+2*WALL_THK;
    cube(box_bottom); 
    difference() {
      translate([ WALL_THK+FUDGE/2, WALL_THK+FUDGE/2, 0]) cube([BOX_INNER[0]-FUDGE, BOX_INNER[1]-FUDGE, WALL_THK*2 ]);
      translate([ WALL_THK*2, WALL_THK*2, -FUDGE]) cube([ BOX_INNER[0]-(2*WALL_THK),BOX_INNER[1]-(2*WALL_THK), 2*WALL_THK+2*FUDGE]);
    }
    // Flanges
    translate([0, BOX_OUTER[1]-FLANGE_R*2, 0]) rotate([0,0,90]) screw_flange( );
    translate([0, FLANGE_R*2, 0]) rotate([0,0,90]) screw_flange( );

    translate([BOX_OUTER[0], BOX_OUTER[1]-FLANGE_R*2, 0]) rotate([0,0,270]) screw_flange( );
    translate([BOX_OUTER[0], FLANGE_R*2, 0]) rotate([0,0,270]) screw_flange( );
    translate([xhalf-5, BOX_OUTER[1],0]) zip_tie ([10,10,WALL_THK]);
    //%translate([(xhalf-0.5), 0, 0 ]) cube([1,200,20]);
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

module zip_tie (dims) {
  cube(dims);
  translate([-WALL_THK,0,0]) cube(WALL_THK);
  translate([dims[0],0,0]) cube(WALL_THK);
  translate([dims[0],dims[1]-WALL_THK,0]) cube(WALL_THK);
  translate([-WALL_THK,dims[1]-WALL_THK,0]) cube(WALL_THK);
}


module standoff (height, rad, screw_rad) {
    difference () {
      cylinder(height, rad, rad);
      translate([0,0,WALL_THK]) cylinder(height, screw_rad, screw_rad);
    }   
}

module corner_standoff ( dimensions ) {
 translate([ -0.5*WALL_THK, -0.5*WALL_THK,0]) difference () {
  cube( [ dimensions[0], dimensions[1], dimensions[2]+2*WALL_THK] );
  union () {
    translate([WALL_THK,WALL_THK  ,0]) cube( [dimensions[0]+WALL_THK, dimensions[1]+WALL_THK, dimensions[2]+3*WALL_THK ]);  
    }
    translate([ 0.5*WALL_THK-(FUDGE/2),0.5*WALL_THK-(FUDGE/2), dimensions[2]]) cube([dimensions[0]+FUDGE, dimensions[1]+FUDGE, WALL_THK*3]);
  }
}

module a_part ( dimensions ) {
    %cube( dimensions );   
}

/*** Laying out the stuff ***/

to_the_right = BOX_OUTER[0]+FLANGE_R*2+3*WALL_THK;
center = [BASE_INNER[0]/2, BASE_INNER[1]/2, BASE_INNER[2]/2];
relays_at = [center[0]-RELAYS[0]/2, 3*ROOM + RPI[1] + 2*STANDOFF_R, STH];
rpi_at = [ center[0]-RPI[0]/2, ROOM, STH];
relays_holders = [STH,STH,STH];

//%translate([center[0]-0.5,0,0]) cube([1,200,20]);

echo(BASE_INNER);
echo("Center");
echo(center);

// translate([ center[0]-0.5, 0, 0 ]) a_part([1,BASE_INNER[1],20]);

// a_part(BASE_INNER);

translate(relays_at) a_part(RELAYS);
translate(rpi_at) a_part(RPI);


// Box Bottom & Top
box_bottom();
translate([to_the_right, -2*WALL_THK, 0]) box_lid();

// Central Standoff Post
translate([center[0], RPI[1]+2*ROOM+STANDOFF_R, 0 ]) standoff (BOX_INNER[2]+WALL_THK,STANDOFF_R,STANDOFF_SCREW_R);

// Standoff Courner thingies for relay
translate([ relays_at[0], relays_at[1], 0 ]) corner_standoff(relays_holders);

translate([ relays_at[0], relays_at[1]+RELAYS[1], 0 ]) rotate([0,0,270]
) corner_standoff(relays_holders);

translate([ relays_at[0]+RELAYS[0], relays_at[1]+RELAYS[1], 0 ]) rotate([0,0,180]) corner_standoff(relays_holders);

translate([ relays_at[0]+RELAYS[0], relays_at[1], 0 ]) rotate([0,0,90]) corner_standoff(relays_holders);

// standoffs for Rpi

translate([rpi_at[0], rpi_at[1], 0]) {
  translate(RPI_HOLE_1) standoff(STH, STANDOFF_R, STANDOFF_SCREW_R);
  #translate(RPI_HOLE_2) standoff(STH, STANDOFF_R, STANDOFF_SCREW_R);
}

% translate([BOX_OUTER[0]-2*WALL_THK,-2*WALL_THK,BOX_OUTER[2]]) rotate([0,180,0]) box_lid();

