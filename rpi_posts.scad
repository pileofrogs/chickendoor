ROOM = 5;  // space around all the parts
RPI = [ 70, 100, 20 ];  // dimensions of a fictional R PI
RELAYS = [ 46, 32.5, 17 ];  // same for relay board
FUDGE = 0.25;  // extra space for parts to fit
WALL_THK = 2; // how thick the walls are
FLANGE_R = 10; // I like the look of it
FLANGE_SCREW_R = 2.5; // replace with actual screw hole radius
STANDOFF_R = 3; // Radius of round standoffs
STANDOFF_SCREW_R = 1.5; // radius of hole in the standoffs
STH = 5; // standoff height
RPI_HOLE_1 = [45,21,0];
RPI_HOLE_2 = [20,77,0];
WIRE_EXIT_R = 4;
ZIP_TIE_TONGUE = [10,10,WALL_THK];

$fn=100;

specs = [54-18-12.5,85.6-25.5-5,0];

rph1 = [RPI_HOLE_1[0]-RPI_HOLE_2[0],0,0];
rph2 = [0,RPI_HOLE_2[1]-RPI_HOLE_1[1],0];

checkxo = RPI_HOLE_1[0] - RPI_HOLE_2[0];
checkyo = RPI_HOLE_2[1] - RPI_HOLE_1[1];

echo("These should match");
echo([checkxo,checkyo]);
echo([rph1[0]-rph2[0], rph2[1]-rph1[2]]);
echo(specs);

module standoff (height, rad, screw_rad) {
    difference () {
      cylinder(height, rad, rad);
      translate([0,0,WALL_THK]) cylinder(height, screw_rad, screw_rad);
    }   
}

to_render = specs;

//to_render = [rph1[0],rph2[1],0];

center = [to_render[0]/2,to_render[1]/2,WALL_THK-1];

difference () {
  translate([-STANDOFF_R,-STANDOFF_R,0])  
  cube([to_render[0]+2*STANDOFF_R, 
	to_render[1]+2*STANDOFF_R, 
	WALL_THK]);
  translate(center) rotate([0,0,90]) linear_extrude(1.1) text( str(to_render), size=5, halign="center" );
}

translate([to_render[0],0,0]) standoff(STH,STANDOFF_R,STANDOFF_SCREW_R);
translate([0,to_render[1],0]) standoff(STH,STANDOFF_R,STANDOFF_SCREW_R);
