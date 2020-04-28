// wood_screw_head_height
// wood_screw_head_radius
// wood_screw_radius
// wood_screw_screw_height

module screw_head (wshh,wshr,wsr,wssh) {
  overlap = wshh/100;
  cylinder(1,wshr,wshr);
  translate([0,0,-wshh+overlap]) cylinder(wshh+overlap,wsr,wshr);
  translate([0,0,-wssh+overlap]) cylinder(wssh-wshh+overlap,wsr,wsr);
}

