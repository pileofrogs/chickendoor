
use <common_shapes.scad>

$fn = 100;


height    = 6;
screw_rad = 1.4; 
rad       = 3;

places = [ [ height, height, 0],
           [ -height, -height, 0],
           [ height, -height, 0],
           [ -height, height, 0]
         ];

for ( place = places ) {
  translate(place) standoff(height,rad,screw_rad);
}
  
