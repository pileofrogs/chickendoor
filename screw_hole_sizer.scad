$fn = 100;

for ( i = [1:10] ) {
  echo(i);
  translate([i*10-10,0,0]){
    difference(){
      cube([11,26,2]);
      translate([5,2,1]) linear_extrude(1.1) text( str(0.5*i), size=5, halign="center" );
    }
    translate([5,19,1]) difference() {
	cylinder(10,4,4);
	translate([0,0,1]) cylinder(11,0.25*i,0.25*i);
    }
  }
}

