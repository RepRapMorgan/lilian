$fn=24;


GT2_profile(l=14);
mirror([0,1,0])
	GT2_profile(l=14);


module GT2_profile(l = 10, w=6){
 translate([2/6,-.963,0]) 
  linear_extrude(height = w)
	difference(){
		union(){
			translate([-2/6,0,0])
			   square([l,.963]);

			for (i = [0:l/2-1]){
				translate([2/3 + i*2,0,0])
					circle(r=2/3);
			}
		}

		for (i = [0:l/2]){
			translate([-2/6 + i*2,0,0])
				circle(r=2/6);
		}
	}
}	