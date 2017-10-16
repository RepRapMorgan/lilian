module roundcube(size, radius, center = false, $fn = 12){
	
	translate([center ? 0 : radius, center ? 0 : radius, center ? 0 : radius])
	minkowski(){
		cube([size[0] - 2*radius,size[1] - 2*radius,size[2] - 2*radius], center = center);
		sphere(r=radius);
	}

}


