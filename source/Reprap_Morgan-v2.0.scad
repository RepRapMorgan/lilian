//---------------------------------------------------------------------------------------------------
// RepRap "Lilian Morgan", main ver 2.0 - Single extruder version
// Copyright 2012, 2013, 2014, 2015. Author: Quentin Harley (qharley)
// This original design is licensed under GPLv2.
//
// This is the complete souce code for all the printable components.
// Please be sure to print these components on an accurate machine.
// Some parts, especially the reduction gear wheels can influence print quality negatively
// if not printed precisely.

include <MCAD/bearings.scad>
include <MCAD/materials.scad>
include <lib/roundcube.scad>
include <MCAD/teardrop.scad>
include <MCAD/polyholes.scad>
include <MCAD/nuts_and_bolts.scad>
use     <write/Write.scad>

LMxUU = 12;                     // Choose linear bearing: 8 or 12mm
rodspacing = 190;                // Distance between linear rods for Z:	190 Morgan Pro
Frame_pipe_OD = 25.5;		  // Default 25.4mm - 1inch OD
bedpipe_OD = 16;		          // pipes used on bed support
Drive_pipe_OD = 25;	          // Drive pipe outer diameter: 22mm default
Drive_bearing_OD = 24;         // Bearing gaps on driveshaft
Drive_shaft_OD = 15;            // shaft OD (Drive Bearing ID)

$fn = 100;
holefactor = 1.027;
bearingOD = 24 * holefactor;
bearingH = 5;
pipeOD = 29;  // Arm section pipe
shaftOD = 15;
drivepipeOD = 25;

// Toolhead specifics
e3d_diameter = 27;
e3d_height = 31.8;
front_vent = true;
vent_size = 15;	// Vent size will control flow
WireLoom_OD = 7.5;		      // Wire loom OD
THREADLESS = false;	          // True for use of threadless ball screw in z-bracket
SUPPORTED_ROD = false;	      // Rods held by Z-mounts - False for platform mounted (lasercut)
MORGAN_PRO = true;
Leadnut_thread = true;          // Apply the thread of the leadscrew nut to the Z coupler
Add_toolhead_to_arm = true;   //  Toolhead printed attached to Psi B arm
coupler_hole = 5.5;              // 6.5 for M7 etc

Text_depth = 1;		          // Morgan branding depth5

Pipe_support_mk2 = true;       // Outer pipe support
pipesupportmountholes = false;
Pipe_OD_fit = 1.025;	         // Fit % larger 

print_support_tabs = false;	     // add support tabs for parts prone to lifing on the print bed

ENVELOPE_CHECK = false;

//projection(cut=true)
	//translate([0,0,-1])
//mirror([1,0,0])


MakeMorgan(23);		// Select Part number to make	

//***************************************************************
//**    Select the number of the module to make				    **
//**																**
//**	01:	 PVC pipe support A (Ported, 438.5mm pipe)			**
//**	02:	 PVC pipe support B (non Ported, 431.5mm pipe)		**
//**	03: Z-mount Bottom										**
//**	04: Z-mount Top											**
//**	05: Motormount Short										**
//**	06: Motormount Tall										**
//**	07: Rod mounted Drivewheel								**
//**	08: Tube mounted Drivewheel								**
//**	09: 22mm Tube 6805 bearing adaptor					    **
//**	10: Bed arm Left											**
//**	11: Bed arm Right											**
//** 	12:	 Bed Z-bracket and lead screw holder					**
//**	13: Printbed bracket        								**
//**	15: hall-endstop holders XY                         		**
//**	16: Z-Lead screw motor shaft coupler						**
//**                                                                **
//**	17: Arm drivepipe mount             						**
//**	18: Arm driveshaft mount x 3        						**
//**	19: Arm bearing mount x 2           						**
//**	20: Arm head bearing mount          					**
//**	21: Morgan Tool head                             		**
//**    211: Tool head plate                                       **
//**                                                                **
//**	22: Lead screw nut Igus 8start 25.4mm	                **
//**	23: Leadscrew anti backlash                               **
//**    24: Belt anchor clip                                        **
//**                                                                **
//**	30: Motor cowl                                            **
//**    31: 8mm 12mm adaptor clip // To use 8mm bearings    **
//**    32: Bed lever adjust nuts                                  **
//**    33: Morgan base feet                                      **
//**    35: Spool holder                                           **
//**                                                                **
//***************************************************************
module MakeMorgan(partnumber)
{
	if (partnumber == 1 ){
		if (Pipe_support_mk2 == true){
			MorganPVCsupport_ANG_mk2(Frame_pipe_OD,130,130,420, pipe = false, port=false, version = "1");
		}
		else
		{
			MorganPVCsupport_ANG(PVC_pipe_ID,130,130,420, pipe = false, port=true);	// 458.47
		}
	}
	if (partnumber == 2 ){
		if (Pipe_support_mk2 == true){
			MorganPVCsupport_ANG_mk2(Frame_pipe_OD,70,150,420, pipe = false, version = "2");
		}
		else
		{
			MorganPVCsupport_ANG(PVC_pipe_ID,70,150,420, pipe = false);					// 451.44
		}
	}
	
  rotate([0,0,45]){ 					// parts rotated through 45deg to ease fitting to RepRap heatbed


//MorganPillarMount();
//MorganShaftMount();
	if (partnumber == 3 ){
		if (SUPPORTED_ROD){
			MorganZmountBot(rodspacing, LMxUU);
		}
		else {
			MorganShaftMount();
		}		
	}

	if (partnumber == 4 ){
		if (MORGAN_PRO)		
		{
			difference(){
				MorganPillarMountPro();
				rotate([0,0,45]){
					translate([0,-15,7])
						cube([40,30,16],center=true);
					translate([0,-10.4,7])
						cube([50,10,16],center=true);
				}

			}

			translate([5,-5,3]){
				intersection(){
					MorganPillarMountPro();
					rotate([0,0,45]){
						translate([0,-15,7])
							cube([39.5,30,16],center=true);
						translate([0,-10.4,7])
							cube([49.5,10,16],center=true);
					}

				}

				rotate([0,0,-45])
					translate([-30,-46,-3])
				intersection(){
					linear_extrude(h=3)
						import("../dxf/filler.dxf");
					translate([35,20,0])
						cube([100,50,3]);
				}
			}	
		}
		else{
		if (SUPPORTED_ROD){
			MorganZmountTop(rodspacing, LMxUU);
		}
		else {
			intersection(){
				MorganPillarMount();
				union(){
				translate([0,10,0])
				rotate([0,0,45])
				cube([50,100,10],center = true);
					cylinder(r=25,h=10, $fn = 96);

				}
			}
		}}	
		
	}

  }

	if (partnumber == 5 ){
		MorganMotorMount6(height = 4);
	}
	if (partnumber == 6 ){
		mirror()
			MorganMotorMount6(height = 20);
	}
	if (partnumber == 7 ){
		LilianBeltWheel();			// Rod mounted belt drive wheel
	}
	if (partnumber == 8 ){
		LilianBeltWheel2();			// Tube mounted belt drive wheel
	}

	if (partnumber == 9 ){
		MorganPillar();				// 6805 bearing tube mount
	}
	
//  rotate([0,0,45]){

	if (partnumber == 10 ){
		if(LMxUU == 12){
			
			MorganBedarmLeft(21.5);
			
		}
		else
			MorganBedarmLeft(15.5);
	}
	if (partnumber == 11 ){
		if(LMxUU == 12)
			MorganBedarmRight(21.5);
		else
			MorganBedarmRight(15.5);
	}
	if (partnumber == 12 ){
		//Bed_stabil_bracket(21.5);
		if(LMxUU == 12)
			Bed_stabil_bracket(21.5);
		else
			Bed_stabil_bracket(15.5);
	}

//  }

	if (partnumber == 13 ){
        difference(){
            linear_extrude(height = 20)
                BedMount();
            for (i=[0,170])
                translate([i+60,105,10])
                    rotate([90,0,0]){
                        cylinder(d=3,h=20);
                        translate([0,0,-5])
                            cylinder(d=10, h=10);
                    }
         }
                        
        
	}
	
	if (partnumber == 15 ){
        endstop(Rod = 12, Length = 28, halldim = [5,3], wall = 2, condu = 5);
    }
    
 	
	if (partnumber == 16 ){
		rotate([0,0,45])
			MorganZCoupler();
	}
    
    rotate([90,0,0]){
	if (partnumber == 17 ){
		lilian_joint4();
	}
	if (partnumber == 18 ){
		lilian_joint1();
	}
	if (partnumber == 19 ){
		lilian_joint2();
	}	
	if (partnumber == 20 ){
		lilian_joint3();
	}
	if (partnumber == 21 ){
       toolhead_body();
        translate([0,0,16]) bowden_attachment2();
 	}
    }
    
    if (partnumber == 211 ){
        hotend_saddle();
 	}
    
    if (partnumber == 212 ){
        linear_extrude(height = 5){
            import("lib/lilian_head_lock_plate.dxf");
            
        }
 	}

	if (partnumber == 22 ){
		leadscrew_nut();
	}
	if (partnumber == 23 ){
		anti_backlash();
	}
	if (partnumber == 24 ){
		belt_clip();
	}

	if (partnumber == 30 ){
		mirror()
			MorganMotorCowl(height = 26);
	}
	if (partnumber == 31 ){
		mirror()
			bearing8to12(height = 24);
	}
  	if (partnumber == 32 ){
		bed_adjust_nut();
	}
     if (partnumber == 33 ){
		rotate([180,0,0])
        foot();
	}

	if (partnumber == 35 ){
		spool_holder();
	}
	
}


// **********************************************************
// **  The code
// **  Here be dragons...

//** print envelope check - only in F5 review
if(ENVELOPE_CHECK){
	translate([0,0,50])
		%cube([200,200,100], center=true);
}

module Matrix_test()
{
	for(x=[0:9])
	{
		for (y=[0:9])
		{
			translate([20*x,20*y,1.5])
				difference(){
					cube([20,20,3], center=true);
					cube([19,19,3],center=true);
				}
		}
	}	
}



PipeFactor = 40/39.2;			// Multiplication factor for inner diameter 

//MorganFrame();

pipeselect = false; // Show pipes in frame... default false


module leadscrew_profile()
{  
    circle(d=4.8, $fn = 48);
    for (i=[0:7]){
        rotate([0,0,360/8*i])
            translate([2.15, 0])
            square([2,1], center=true);
    }    
}

module leadscrew_nut(height = 14, pitch= 25.4){
	difference(){
		union(){
			translate([0,0,2])
			minkowski(){
				cylinder(r=(14.8/2)-2.2,h=height-4, $fn=6);
				sphere(r=2, $fn=24);
			
			}
		}
        translate([0,0,height/2])
		  linear_extrude(height = 5 + height, center = true, twist = -360*(5 + height)/25.4)
			scale(1.1)
				leadscrew_profile();
	}

}

module spool_holder(len = 100){
	
	difference(){
		union(){
			translate([0,0,10])
				rotate([0,90,0])
					cylinder(d=20, h=len);
			translate([len-5,-10,0])
				#cube([5,20,10]);
			translate([10,-10,0])
				#cube([5,20,10]);
			translate([-25/2,0,0])
				cylinder(r=(25/2)+5,h=50);
			translate([-30,9.6,0])
				cube([10,5,20]);
		}
		translate([-25/2,0,-1])
			#polyhole(55,Frame_pipe_OD-1);
		translate([-22,0,-1])
			cube([22,30,100]);
	}	

}

module endstop(Rod = 12, Length = 28, halldim = [5,3], wall = 2, condu = 5){
    difference(){
        union(){
            cylinder (d = Rod + wall, h=20);
            translate([0,(Length + 1.5)/2,(halldim[1] + 3)/2])
                roundcube([halldim[0]+6, Length + 4, halldim[1] + 3], radius = 1, center = true, $fn = 48);
            
            translate([0,Rod/1.7,0])
                cylinder(d= condu + wall, h=20);
        }
        
        translate([0,0,-1])
            //cylinder (d= Rod, h = 22);
            polyhole(22, Rod);
        translate([0,-Rod /3,10])
            cube([Rod * .95,10,22], center=true);
        translate([0,-Rod /1.8,10])
            cube([Rod * 1.5,10,22], center=true);
        
        translate([0,(Length + 1.5)/2,(halldim[1] + 3)/2])
                roundcube([halldim[0], Length, halldim[1]], radius = 1, center = true);
        
        translate([0,Rod/1.7,4])
                cylinder(d= condu, h=22);
    }
    
}

module bearing8to12(height = 24){
	difference(){
		cylinder(r=21/2, h = height);

		translate([0,0,-1])
			polyhole(height+2, 15);

		translate([0,0,6])
			rotate_extrude(convexity = 10)
				translate([22/2, 0, 0])
					circle(r = 1, $fn = 100);

		translate([0,0,height-2])
			#cylinder(r1=14/2, r2=18/2, h=4);

	}

	translate([0,0,3.8])
		rotate_extrude(convexity = 10)
			translate([16/2, 0, 0])
				circle(r = 1, $fn = 100);
	translate([0,0,height-3.8])
		rotate_extrude(convexity = 10)
			translate([16/2, 0, 0])
				circle(r = 1, $fn = 100);

}



module belt_clip($fn = 100, t_rad = 30, t_width = 2.5, t_gap = 2.5)		// Adapted from code by WJ Harley
{
	difference()	{
		translate([t_rad-30,0,0])	
			cylinder(r=t_rad, h=10);
		union()
		{	
			translate([-17,-t_rad-5,-1])
				cube([t_rad*2,t_rad*3,12]);
			translate([t_rad-30,0,-0.2])	
				cylinder(12,r=t_rad-t_width);
			translate([-35,0,5])
				cube([30,t_gap+1,7],center=true);
		}
	}

		difference(){
			for(g=[-1,1])
				translate([-29+6,g*(t_gap/2+1),5])
					rotate([0,0,0])	cube([12,2,10],center=true);
			translate([-t_rad+(t_width*1.35),0,5])
				rotate([90,0,90])
					translate([0,0,t_width/-2])
						linear_extrude(height = t_width, center=true, scale=[t_gap/(t_gap+1),1,])
							square([t_gap+1,7],center=true);

		}
	for(i=[0,1]){
		mirror([0,i,0])
			translate([-25,-3.6-t_gap/2,5]){
				rotate(-45,[0,0,1])
					cube([2,8,10],center=true);
			}
	}
	for (j=[-1,1])
		for(k=[0:3]){
			translate([-17-k*2,j*t_gap/2,0]){	
				intersection(){
					cylinder(10,0.5,0.5,0);
					translate([-2,-1,0])
						cube([2,2,10]);
				}
			}
		}
	
}
		

		



module MorganF(){

		MorganPVCsupport_ANG(29,130,130,420, pipe = pipeselect);		// 458.47
	translate([50,0,0])
		MorganPVCsupport_ANG(29,70,150,420, pipe = pipeselect);			// 451.44
	

}

module MorganFrame(){

	translate([0,0,-4])	
		cube([360,360,8],center = true);
	translate([0,0,0])
		MorganZmountBot();

	translate([150,0,0])
		MorganPVCsupport_ANG(29,-130,130,420, pipe =pipeselect);
	translate([-150,0,0])
		MorganPVCsupport_ANG(29,130,130,420, pipe = pipeselect);
	
	translate([70,150,0])
		MorganPVCsupport_ANG(29,70,-150,420, pipe = pipeselect);
	translate([-70,150,0])
		MorganPVCsupport_ANG(29,-70,-150,420, pipe = pipeselect);

	translate([-180,-40,420])
		cube([360,220,8]);

	translate([0,0,420])
		rotate([0,180,0])
		{
			MorganZmountTop();

			translate([140,0,0])
				MorganPVCsupport_ANG(29,-70,150,420, pipe = pipeselect);
			translate([-140,0,0])
				MorganPVCsupport_ANG(29,70,150,420, pipe = pipeselect);
			translate([20,130,0])
				MorganPVCsupport_ANG(29,130,-130,420, pipe = pipeselect);
			translate([-20,130,0])
				MorganPVCsupport_ANG(29,-130,-130,420, pipe = pipeselect);
		}
}

module Bed_stabil_bracket(bsize = 15.5){
	mirror()
   difference(){
		union(){
			translate([(rodspacing)/2,0,0])
				Bed_stabil_clasp(bsize);
			translate([(rodspacing)/-2,0,0])
				mirror(){
					Bed_stabil_clasp(bsize);
				}
			difference(){
			  union(){
				translate([0,-14.5,25]){
					cube([rodspacing,3,50],center=true);
						
				}
			
				//translate([rodspacing/2,-12,0])
				//	rotate([0,0,-160])
				//		#cube([rodspacing/2, 3, 50]);
				//mirror()
				//	translate([rodspacing/2,-12,0])
				//		rotate([0,0,-160])
				//			cube([rodspacing/2, 3, 50]);

				translate([0,-25.5,1.5]){
					intersection(){
						cube ([rodspacing+20, 25, 3],center=true);
						translate([0,rodspacing*1.5-6,-2])	
							cylinder(r=rodspacing*1.5, h=5, $fn = 100);

					}			
				}
			  }
		
			  translate([rodspacing/2,0,0])
					cylinder(r=bsize*0.8, h=50, $fn=100);
			  translate([rodspacing/-2,0,0])
					cylinder(r=bsize*0.8, h=50, $fn=100);	
			}		

	
			cylinder(r=28,h=50, $fn=100);

			// Lead screw add section
			if (THREADLESS){

			}
			else{
				translate([0,-40,0])
				cylinder(r=11,h=50,$fn=6);

			translate([0,-20,5])
				cube([22,40,10],center=true);
			}

			// Magnet hole support
			//translate([rodspacing/-2+LMxUU, LMxUU*-1.756, 0])
				rotate([0,0,-90])
					translate([16,79,0])
						polyhole(4,7);//r=2.5, h=3);
		}

		cylinder(r=25,h=50, $fn=100);
		translate([-35,-13,0])
		cube([70,50,50]);

		translate([45,-30,22])
			rotate([0,0,90])
				teardrop(16, 50, 90);
				
		translate([-45,-30,22])
			rotate([0,0,90])
				teardrop(16, 50, 90);
				
		// Lead screw subtraction section
		if (THREADLESS){

		}
		else {
			translate([0,-40,0])
				cylinder(r=8,h=6,$fn=6);
			translate([0,-40,9])
				cylinder(r=8,h=41,$fn=6);
			translate([0,-40,6.5])
				#cylinder(r=4.5, h=10);
		}	

		// Magnet hole
			//translate([rodspacing/-2+LMxUU, LMxUU*-1.756, 0])
				rotate([0,0,-90])
					translate([16,79,0])
						polyhole(3,5);//r=2.5, h=3);
	
	}
}

module Bed_stabil_clasp(bsize=15.5){
	difference(){
		
		cylinder(r=bsize/2+8, h=50, $fn=100);
		translate([0,0,4])
			MorganBedarmRight(bsize);
		cylinder(r=bsize/1.9,h=50, $fn=100);
		translate([0,bsize*.75,25])
			cube([bsize*3,bsize*1.5,52],center=true);
	}
}

module BedMountFront(pipe = 15)
{
 translate([0,0,15/2])	
  rotate([0,90,0])	
	difference(){
		cube([15,pipe+10,25], center=true);
		translate([0,0,6.5])
			rotate([0,90,0])
				#cylinder(r=pipe/2, h=20, center=true);	
/*		difference(){
			translate([0,0,6.5])
				rotate([0,90,0])
					cylinder(r=pipe/2+3, h=20, center=true);
			translate([0,0,6.5])
				rotate([0,90,0])
					cylinder(r=pipe/2+2, h=20, center=true);
			translate([0,0,19])
				cube([25,pipe+10,25],center=true);
		}*/
			
		//cube([16,10,10],center=true);
		translate([0,0,10])
			cube([16,pipe-2,10],center=true);

		rotate([0,0,0])
		//teardrop(1.5,30,90);
			translate([0,0,-20])
			polyhole(30,3);


	}
}




module BedMountRear(pipe = 15){
  translate([0,0,0])
    rotate([0,270,0])
	difference(){
		union(){
			translate([0,0,0])
				cube([15,60,4]);
			translate([0,70,19.5])
				rotate([0,90,0])
					polyhole(15,pipe+10);
			translate([0,60,0])
				rotate([60,0,0])
					cube([15,20,6]);
		}
		translate([-1,70,19.5])
			rotate([0,90,0])
				polyhole(22,pipe);
		translate([-1,70,19.5])
			rotate([60,0,0])	
				translate([4.5,10,0])
					cube([32,20,pipe],center=true);
		translate([7.5,6,0])
			polyhole(5,4);
		translate([7.5,14,0])
			polyhole(5,4);
	}
}


module BedMount(){
    import("lib/bed_arm.dxf");
}


module BedMountBar_mk2(pipe = 15, mirr = false){
		difference(){
			union(){
				hull(){
					translate([-9,25,(pipe+10)/2])
						//rotate([0,90,0])
							//cylinder(d=(pipe+15),h=18,$fn=50);
							translate([9,7,27-7])
							cube([18,25,pipe],center=true);
					translate([-9,25,75-pipe])
						rotate([0,90,0])
							cylinder(d=(pipe+15),h=18,$fn=50);
				}
		
				translate([9,32,12])
					rotate([90,0,-90])
						difference(){
						color("red")linear_extrude(height=18)
							projection(cut=false)
								BedMountFront(pipe);
						color("orange") 
						translate([11.5,3.35,9])
						rotate([0,0,6])
						#cube([10.9,10.38,30],center=true);

						}
			   difference(){
				color ("brown") hull(){
					translate([0,150,100])
						cube([18,200,4],center=true);
					translate([-9,25,72-12])
						rotate([0,90,0])
						 cylinder( r=2, h=18);
					translate([-9,45,1])
						rotate([0,90,0])
							cylinder( r=2, h=18);


				}

				translate([1,13,8])
				scale([1,0.87,0.87])
			 	color ("pink") hull(){
					translate([0,150,100])
						cube([18,200,4],center=true);
					translate([-9,25,72-12])
						rotate([0,90,0])
						 cylinder( r=2, h=18);
					translate([-9,45,1])
						rotate([0,90,0])
							cylinder( r=2, h=18);
				}
				}
				rotate([0,90,0])
				translate([-100,240,-9])
					cylinder(d=30, h=0.6);

				if (print_support_tabs){  // Add support tabs to the model on sharp ends

					rotate([0,90,0])
						translate([-12.5,20,-9])
							scale([35,15,1])
							cylinder(r=0.5,0.6,$fn=24);

					rotate([0,90,0])
						translate([-60.5,15,-9])
							scale([25,25,1])
							cylinder(r=0.5,0.6,$fn=24);

				}
			}

			

			translate([-10,25,72-12])
				rotate([0,90,0])
					#polyhole(18+2,pipe);

			translate([-10,63,72])
				rotate([180,0,0])
					teardrop(18,40, angle=90);
		
			translate([-10,110,72])
				rotate([180,0,0])
					teardrop(20,40, angle=90);

			translate([-10,(110+63)/2,40])
				//rotate([180,0,0])
					teardrop(10,40, angle=90);

			translate([-10,(300)/2,80])
				rotate([180,0,0])
					teardrop(13,40, angle=90);

			translate([-10,180,85])
				rotate([180,0,0])
					teardrop(8,40, angle=90);
	

			translate([0,25,72-12+pipe/2+5])
				cube([20, pipe, pipe+10],center=true);

			translate([0,13,72-12+pipe])
				cube([19, pipe, pipe],center=true);

			translate([0,63,87]){
				cylinder(d=10, h=10);
				polyhole(20,3);
			}
			translate([0,235,87]){
				cylinder(d=10, h=10);
				polyhole(20,3);
			}
		}
}

module BedMountBar(pipe = 15){
	//translate([-4.5,188,0])
		//rotate([0,270,180])
			//%MorganBedarmLeft(21.5);
	//translate([-20,138,0])
		//color("red") cube([10,50,10]);

	difference(){
		union(){
			translate([0.5,0,0])
				BedMountFront(pipe);
			translate([-12,93,0])
				mirror([1,0,0])
				BedMountRear(pipe);
			translate([-12,-50,0])
				cube([4,165,15]);
			translate([-12,12,0])
				cube([16,141,4]);
			
			translate([-42,-57.5,2.5])
				minkowski(){
					cube([40,20,10]);
					rotate([0,90,0])
						cylinder(r=2.5, h=1, $fn=12);

				}

			translate([-42,115,2.5])
				minkowski(){
					cube([40,20,10]);
					rotate([0,90,0])
						cylinder(r=2.5, h=1, $fn=12);

				}

			translate([-11,-42,0])
				cube([10,30,15]);
		}
		
		translate([-50,-47,7.5])
			rotate([0,90,0])
				polyhole(60,3);
		translate([-45,-47,7.5])
			rotate([0,90,0])
				cylinder(r=5, h=8);
	
		translate([0,125,0]){
			translate([-50,0,7.5])
				rotate([0,90,0])
					polyhole(60,3);
			translate([-45,0,7.5])
				rotate([0,90,0])
					cylinder(r=5, h=8);
		}
	}
}


module MorganBedScrewmount(){
  
  difference(){
	union(){
		translate([25,22,0])
			ArmEndPiece();
		translate([25,0,2])
			cube([18,68,4],center=true);
		translate([25,-5,12])
			cube([4,74,24],center=true);

		translate([-25,22,0])
			ArmEndPiece();
		translate([-25,0,2])
			cube([18,68,4],center=true);
		translate([-25,-5,12])
			cube([4,74,24],center=true);
	
		translate([0,-42,2])
			cube([68,18,4],center=true);
		translate([0,-42,12])
			cube([54,4,24],center=true);
		translate([0,-42,0])
			cylinder(r=10,h=24,$fn=50);
	}
	translate([0,-42,17])
		cylinder(r=7.5,h=7,$fn=6);
	translate([0,-42,0])
		cylinder(r=8,h=15,$fn=6);
	translate([0,-42,15.4])
		cylinder(r=5,h=15,$fn=50);

	translate([-50,22,12])
		rotate([0,90,0])
			polyhole(100,15.5);

	polyhole(20,36);
  }
}

module ArmEndPiece(){
	difference(){
		union(){
			

			translate([-9,0,12])
				rotate([0,90,0])
					cylinder(r=12,h=18,$fn=50);
			translate([0,6,12])
				cube([18,12,24],center=true);
			
		}
		
		translate([-10,0,12])
				rotate([0,90,0])
					polyhole(20,15.5);

	}
}

module MorganBedarm_mount(){
	difference(){
		cylinder(r=12,h=3*24,$fn=50);
		polyhole(3*24,15.5);
		translate([13,0,0])
			cylinder(r=9.2,h=3*24,$fn=50);
		
		

	}
	rotate([0,0,-45])
		translate([9.85,0,0])
			cylinder(r=2.15,h=3*24, $fn=50);
	rotate([0,0,45])
		translate([9.85,0,0])
			cylinder(r=2.15,h=3*24, $fn=50);

	translate([0,0,4])
		difference(){
			rotate_extrude(convexity = 10)
				translate([8.4, 0, 0])
					circle(r = 1, $fn = 100);
			translate([5,0,0])
				cube([10,10,2], center=true);
		}

	translate([0,0,(3*24)-4])
		difference(){
			rotate_extrude(convexity = 10)
				translate([8.4, 0, 0])
					circle(r = .8, $fn = 100);
			translate([5,0,0])
				cube([10,10,2], center=true);
		}

}

module MorganBedarm_mount12(bearingD = 21, h=77){
	bearingR = bearingD / 2;

	subcyl = sqrt(pow((bearingR+4.25),2)/2);
 translate([0,0,-2.5]){	

	difference(){
		cylinder(r=bearingR + 4.25,h=h,$fn=50);
		translate([0,0,-1])	
			polyhole(h+2,bearingD+1);
		translate([bearingR+4.25,0,-.5])
			cylinder(r=subcyl,h=h+1,$fn=50);
		}
	rotate([0,0,-45])
		translate([bearingR+2.25,0,0])
			
cylinder(r=2.25,h=h, $fn=50);
	rotate([0,0,45])
		translate([bearingR+2.25,0,0])
			cylinder(r=2.25,h=h, $fn=50);


	for(i = [0:4]){
		
			rotate([0,0,60+i*60])
				translate([bearingR+1,0,0])
					cylinder(r=1.25, h=77, $fn=12);
	}
 }	
}

module MorganBedarm(pipe = bedpipe_OD, h=77){  // bedpipe_OD, h=77){

	
	difference(){
		union(){
			translate([0,12.5,36])
				cube([18,25,h],center=true);
			
			hull(){
				translate([-9,25,(pipe+10)/2])
					rotate([0,90,0])
						cylinder(d=(pipe+15),h=18,$fn=50);

				translate([-9,25,59+(16-pipe)/2])
					rotate([0,90,0])
						#cylinder(d=(pipe+15),h=18,$fn=50);
			}
		}
		translate([0,0,-10])
			cylinder(r=11.5,h=100);
		
		translate([-10,25,12])
				rotate([0,90,0])
					polyhole(18+2,pipe);

		translate([-10,25,72-12])
				rotate([0,90,0])
					polyhole(18+2,pipe);
}
}

module MorganBedarmLeft(bsize = 15.5){

	MorganBedarm_mount12(bsize);
	MorganBedarm();
	
}


module MorganBedarmRight(bsize = 15.5){

	rotate([0,0,180])
		MorganBedarm_mount12(bsize);

	MorganBedarm();
	
}


module Motor(MotorH = 50, MotorW = 42){
	translate([0,0,MotorH/2])
		intersection(){
			cube([MotorW*1.285,MotorW*1.285,MotorH],center=true);
			rotate([0,0,45])
				cube([MotorW,MotorW,MotorH],center=true);
		}

}

/*module MorganFlatMotorMount(){
	difference(){
		Motor(3);
		for(i=[0,90,180,270]){
			rotate([0,0,i])
			{
				translate([33,0,Height-8])
					polyhole(12,2);

				translate([22,0,0])
					polyhole(10,3);
			}
		}
		polyhole(2,22);
	}
}
*/
/*module MorganMotorMount5(height = 4){
	difference(){
		union(){
			Motor(height, 46);
			translate([0,0,2]){
				cube([80,10,4],center=true);
				cube([10,80,4],center=true);
			}
		}
		
		for (i= [0:3]){
			rotate([0,0,i*90]){
				translate([0,22,height-1.6])
					polyhole(height+2,3);
				translate([0,35,- 1])
					polyhole(height+2,3);
			}
		}
		for (i= [0:3]){
			rotate([0,0,i*90])
				translate([0,22,-2])
					polyhole(height,6);
		}
		translate([0,0,-1])
			polyhole(height+2,35);
	}	
}*/

module MorganMotorMount6(height = 4){
	difference(){
		union(){
			Motor(height, 46);
			
		}
		
		for (i= [0:3]){
			rotate([0,0,i*90]){
				translate([0,22,-1]){
					#polyhole(height+2,3);
				
					translate([0,0,height-3])
						#polyhole(5, 7);
				}
				
			}
		}
		
		translate([0,0,-1])
			polyhole(height+2,35);

		// Cable port
		translate([10,10,height/2.5-.1])
			rotate([0,90,45]){	
				translate([10-height/2.5,0,0])
					intersection(){
						cylinder(r=10, h=10);
						translate([-10,-10,0])
							cube([11,20,10]);
					}
				//#teardrop(height/2, 10, 90);
				translate([10-height/2.50,-10,0])
				cube([height/2.5-(10-height/2.5),20,10]);
			}
	}	
}

module MorganMotorCowl(height = 4){
	rotate([180,0,0])
	difference(){
		linear_extrude(height=height, scale=.5)
			projection(cut=true)
				Motor(height, 41);	

		translate([0,0,-2])	
		linear_extrude(height=height, scale=.5)
			projection(cut=true)
				polyhole(height+2,35);
		
		for (i= [0:3]){
			rotate([0,0,i*90]){
				translate([0,22,-1])
					polyhole(4.8,3);
				translate([0,22,4])
					#cylinder(d=8, h=15, $fn = 48);
			}
		}
		
		rotate([0,0,45])
			translate([-25,0,-2])		
				cube([50,50,height]);
		
		
	}	
}

module MorganSpoolHolder(PipeOD, PipeID){

	intersection(){
		difference(){	
			union(){
				translate([0,0,PipeOD/2])
					cube([PipeOD+20,PipeOD+10,PipeOD], center = true);
				translate([-PipeOD+10,0,PipeOD/2-5])	
					rotate([0,270,0])
						cylinder(r=PipeID/2,h=25);

				translate([-PipeOD-40,0,0])	
					rotate([0,0,0]){
						cylinder(r=PipeID/2,h=25);
						cylinder(r=PipeID/1.5, h=5);
						translate([0,0,5])
							cylinder(r1=PipeID/1.5, r2=PipeID/2, h=10);
					}
			}
		
			polyhole(PipeOD*2+2,PipeOD);
			
			translate([PipeOD/1.6,PipeOD/1.2,PipeOD/3])
				rotate([90,0,0])
					polyhole(PipeOD+20, 4);

			translate([-PipeOD-40,0,0]){
				translate([0,0,20.4])
					polyhole(25, 8.5);
					//cylinder(r=4,h=25);
				cylinder(r=7.5, h=20, $fn = 6);
			}

			translate([-PipeOD+10,0,PipeOD/2-5])	
					rotate([0,270,0]){
						polyhole(25, 8.5);
						//cylinder(r=4,h=25);
						translate([0,0,-7])
						cylinder(r=7.5, h=20, $fn = 6);
					}
			
			translate([PipeOD / 2,0,PipeOD/2])
				cube([PipeOD, PipeOD - 2, PipeOD],center=true);
			translate([0,0,-PipeOD])
				cube([300,300,PipeOD*2],center=true);
			translate([0,0,+PipeOD*1.85])
				cube([300,300,PipeOD*2],center=true);
		
		}
		translate([PipeOD+10,0,PipeOD/2-5])	
				rotate([0,270,0])
					cylinder(r=PipeID/1.2,h=80+PipeOD*2);
					
	}
}



module MorganPVCsupport_ANG_mk2(PipeOD = 32, target_x = 0, target_y = 0, target_z=1, pipe = false, port = false, version = ""){

	PipeLength = sqrt (pow(target_x,2)+pow(target_y,2)+pow(target_z,2));
	echo (PipeLength-20);		//subtract the 20mm for the pipe support rings...
	
	deg_x = asin ( target_x / PipeLength);
	deg_y = -asin ( target_y / PipeLength) ;
	deg_z = atan ( target_x / target_y) ;			// Straighten the mount

	deg_t = 
	
	echo (deg_z);

	difference(){
		union(){
			#cylinder(r1=(PipeOD+2)/2,r2=(PipeOD)/2, h=8, $fn = 100);
			
			rotate([deg_y,deg_x,deg_z]){	
				difference(){
					union(){
						translate([0,0,-10])
							cylinder(r=(PipeOD+6)/2, h=40, $fn = 100);  // Pipe support base
					
					}
					
						cylinder(r=(PipeOD-6)/2, h=11, $fn=100);
					if (pipesupportmountholes ==true)
						for (r=[0:2]){
							rotate([0,0,(r*120)-deg_z+30])
								translate([PipeOD/2,0,20])
									teardrop(3/2, PipeOD/1.5, 90);

					
					}
				}
				
			}

				
		}
		
		rotate([deg_y,deg_x,deg_z])
			translate([0,0,10])
				//cylinder(r=(PipeOD)/2, h=45, $fn=100);
				polyhole(45, PipeOD*Pipe_OD_fit);
	
			
		// m4 trapped nut
		translate([0,0,3]){
			cylinder(r=8.5/2, h=3.5, $fn=6);
			translate([0,0,3.5]) cylinder(r1=8.5/2, r2=8.2/2, h=0.5, $fn=6);
			cylinder(r=8.2/2, h=10, $fn=6);
		}
			
		translate([0,0,-1])	
			cylinder(r=4/2,h=10, $fn = 20);

		translate([0,0,-10])
			cylinder(r= PipeOD, h=20, center = true);

		if (port == true){
			
				rotate([0,0,270])
					translate([PipeOD/2,0,6])
						teardrop(5, PipeOD/1.5, 90);
				translate([0,-3,6])
					rotate([90,0,0])
						rotate([0,0,6])
						cylinder(r=5, h=PipeOD/4,$fn=30);
						

		}

		writecylinder(version,[0,0,0],15.5-Text_depth,12 + Hotend_H,h=7,up=10, east=-90,font="Letters.dxf",face="bottom",rotate=90);
		
	}

}


module HoleCal(){
	difference(){
		cylinder(r=25, h=3, $fn=200);
		polyhole(3, 40);
		translate([0,0,3])
			rotate([45,0,0])
				cube([60,1,1],center=true);
		translate([0,0,3])
			rotate([0,0,90])
				cube([60,1,1],center=true);		
	}
}

module LilianBeltWheel2(){
	difference(){
		LilianBeltWheel();
		
		translate([0,0,6])			// Only widen pipe section
			polyhole(50,Drive_pipe_OD);
		translate([0,0,2])			// Only widen pipe section
			polyhole(5,24);				// Bearing support
		translate([0,0,-1])
            polyhole(5, 20);
	}
}


module LilianBeltWheel(){
    difference(){
        union(){
            intersection(){   
                linear_extrude(height = 10, $fn=200)
                    import("lib/lilian_wheel_profile.dxf");
                union(){
                    cylinder(r1 = 77, r2 = 67, h=10, $fn=100);
                    cylinder(r1 = 67, r2= 77, h=10, $fn=100);
                    cylinder(r=75, h=10, $fn=200);
                }
            }
            translate([0,0,5]) 
                minkowski(){
                    union(){
            
                        cylinder(d=38, h=3, $fn=100);
                        cylinder(d=35, h=17, $fn=100);
                    }
                    sphere(r=2, $fn=24);
                }
            cylinder(d=40, h=10);
        }
    
        translate([-75,0,5])
        rotate([0,90,0])
        hull(){
            translate([-2,0,0])
                cylinder(d=2.75, h=20, center=true, $fn=48);
            
            translate([2,0,0])
                cylinder(d=2.75, h=20, center=true, $fn=48);
        }
        
        translate([0,0,-1]) polyhole(30, 15);
        
        for (j= [0:2]){
            translate([0,0,16])
                rotate([90,0,j*120+30])
                    cylinder(d=2.5, h=30);
        }
        rotate([0,0,-60])
            translate([69,0,7])
                polyhole(5,5);
    }
    
}



module MorganPillar(){
	difference(){
		union(){
			cylinder(r=12.5,h=27,$fn=100);
			cylinder(r=14.5,h=20);


		}
		translate([0,0,-1])
			polyhole(h=32, d=22*PipeFactor);

	}
}

module MorganPillarMount(){
	difference(){
		union(){
			translate([0,0,1])
				minkowski(){	
					cube([30,30,2], center=true);
					cylinder(r=10,h=1);
				}
			cylinder(r=22,h=10, $fn=100);
		}
		translate([0,0,-1])
				polyhole(12,35);

		translate([0,0,3])
			polyhole(8,37);

		for (sign1 = [1,-1]){
			for (sign2 = [1,-1]){
				translate([sign1*19,sign2*19,-1])
					polyhole(5,4);
			}
		}
		
	}
}

module MorganPillarMountPro(){
	difference(){
		union(){
			translate([0,0,1])
				minkowski(){		
					union(){
						//intersection(){
							//cube([35,35,2], center=true);
							//rotate([0,0,45]){
								//translate([0,3,0])
									//cube([55,6,2],center=true);
								
						//	}
						//}
						intersection(){
							rotate([0,0,0])
								cube([35,35,30], center=true);
							translate([0,0,5])
								rotate([0,0,45])
									cube([50,1,12], center=true);
						}

					}

					cylinder(r=10,h=1);
				}
			cylinder(r=22,h=13, $fn=100);
		}
		translate([0,0,-1])
			polyhole(3,35);
		translate([0,0,2])
			polyhole2(1,35,37);
		translate([0,0,3])
			polyhole(7,37);
		translate([0,0,10])
			polyhole2(1,37,35);
		translate([0,0,11])
			polyhole(3,35);

		for (sign1 = [1,-1]){
			for (sign2 = [1,-1]){
				translate([sign1*19,sign2*19,-1])
					polyhole(20,4);
			}
		}
		translate([0,0,6])
			rotate([0,90,-45]){
				translate([0,21,-15])		
					#polyhole(30,3);
				translate([0,-21,-15])		
					#polyhole(30,3);
				translate([0,21,9])		
					#polyhole(5,6);
				translate([0,-21,9])		
					#polyhole(5,6);

				translate([0,21,-13])		
					#cylinder(r=6.8/2,h=5,$fn=6);
				translate([0,-21,-13])		
					#cylinder(r=6.8/2,h=5,$fn=6);
			}

	}
}


module MorganShaftMount(){
	difference(){
		union(){
			translate([0,0,0])
				minkowski(){	
                    translate([0,0,5])
					cube([32,32,10], center=true);
					cylinder(r=10,h=1);
				}
			cylinder(r=16,h=10, $fn=100);
		}
		translate([0,0,-1])
			polyhole(12,20);

		translate([0,0,5])
			polyhole(9,Drive_bearing_OD);

		for (sign1 = [1,-1]){
			for (sign2 = [1,-1]){
				translate([sign1*19,sign2*19,-1])
					polyhole(20,4);
                translate([sign1*19,sign2*19,-1])
					polyhole(6,8);
                
			}
		}
		
	}
}

module MorganSRodMount(rodsize = 8){
	difference(){
		union(){
			translate([0,0,1.5])
				minkowski(){	
					union(){
						rotate([0,0,45])
							translate([-8,0,0])
								cube([rodsize,1,3], center=true);
						rotate([0,0,-45])
							translate([-8,0,0])
								cube([rodsize,1,3], center=true);
					}
					cylinder(r=6,h=.0001);
				}
			cylinder(r=rodsize/2 +4,h=10, $fn=100);
		}
		translate([0,0,3])
			polyhole(8,rodsize);

		for (sign1 = [1,-1]){
			for (sign2 = [1,-1]){
				translate([sign1*(5+rodsize/2),sign2*(5+rodsize/2),-1])
					polyhole(5,4);
			}
		}
		
	}
}

module MorganZmountTop(rodspacing = 175, rodsize = 8) // Default morgan dimentions
{
  difference(){
	union(){	
		rotate([0,0,45])
			MorganPillarMount();	

		translate([-rodspacing/2,0,0])
			MorganSRodMount(rodsize);	
		translate([rodspacing/2,0,0])
			rotate([0,0,180])	
				MorganSRodMount(rodsize);

		translate([-rodspacing/3.5,0,1.5])
			cube([rodspacing/2.5,16,3], center=true);
		translate([rodspacing/3.5,0,1.5])
			cube([rodspacing/2.5,16,3], center=true);
	}
  

		translate([0,27,4])
			cube([50,10,10],center=true);
  }

}

module MorganZmountBot(rodspacing = 175, rodsize = 8) // Default morgan dimentions
{

 difference(){
  union(){		
	rotate([0,0,45])
		MorganShaftMount();	

	translate([-rodspacing/2,0,0])
			MorganSRodMount(rodsize);	
		translate([rodspacing/2,0,0])
			rotate([0,0,180])	
				MorganSRodMount(rodsize);

	translate([-rodspacing/3.5,0,1.5])
			cube([rodspacing/2.5,16,3], center=true);
		translate([rodspacing/3.5,0,1.5])
			cube([rodspacing/2.5,16,3], center=true);
   }

		translate([0,27,4])
			cube([50,10,10], center = true);
 }

}

module SupportCylinder(r1, r2, h,  slice = 0.4){
	union()
	{
		scale(2){
			for (radius = [r1/2:r2/2]){
				difference(){
					cylinder(r = radius, h/2, $fn = 50);
					cylinder(r = radius - (slice/2), h/2, $fn = 50);
				}
			}
		}
		cylinder(r = r2, h=slice, $fn = 50);
		translate([0,0,h])
			cylinder(r = r2, h=slice, $fn = 50);
	}
}

module Bearing_recess (){		// Single recess
	intersection(){
		union(){
		
			//polyhole(12,22);
		//}
		//translate([0,0,-4])
			polyhole(9,22);
			cylinder(r1=12, r2=10, h=4);	
		}	
		cylinder (r1 = 20, r2=8, h=10);
	}
}

module Bearing_group (){			// Top and bottom
	translate([0,0,-1])
		union(){
			Bearing_recess();
			//cylinder(r=9,h=50);
			polyhole(50,20);
		}	
		translate([0,0,41])
			rotate([0,180,0])
				Bearing_recess();

}

module Bearing_stack()
{
	difference(){
		cylinder(r=15, h=40);	
		Bearing_group();
	}
}



module Extruder_Bowden_adaptor(support = true)
{
	//union(){
	difference(){
		union(){
			translate([-11,11,15])
				difference(){
					import("lib/Base_and_Riser_2.stl");
					cube([50,50,40], center = true);
			}
			
			cylinder(r=15.8/2,h=35, $fn = 50);	
		}
			
		translate([0,0,-1])	
		union(){
			cylinder(r=4,h=80, $fn=36);
		}
		translate([0,0,4.76])	
			difference(){
					
				cylinder(r=(15.8/2), h=4.64, $fn = 50);		
				translate([0,0,4.64 - 2])	
					cylinder(r1=6, r2 = 15.8/2, h=2, $fn = 50);	
				cylinder(r=12/2, h=4.64, $fn=50);
			}
	}

	//SupportCylinder (r1 = 5, r2 = 7, h=10);

	
}


module Fastener_stack()
{
	difference(){
		cylinder(r=15, h=40);
		translate([0,0,-1])
			//linear_extrude(height = 42)
				nutHole(8);//, proj = 1);

		translate([0,0,6])
			polyhole(42, 7.9);
			//cylinder(r=7.5, h=42, $fn=6);

		translate([0,0,34])
			//linear_extrude(height = 42)
				nutHole(8);//, proj = 1);

	}
}

module Driveshaft_stack()
{
	difference(){
		cylinder(r=15, h=40);
		
		translate([0,0,-1])
			polyhole(42, Drive_shaft_OD);

	}
}
module BeamProfile(){
	beamr = 13;
	intersection(){	
		translate([beamr-beamr*.4,0,0])
			//circle(r=beamr);
			projection()
				rotate([0,90,0])
					teardrop(beamr, 1, 90);

		translate([0,-beamr,0])
			square([beamr*2,beamr*2]);
	}
}


module SupBeamProfile(){
	beamr = 13;
	translate([3.5,0,0])
		square([7,beamr*2-7],center=true);
	translate([3.5,9,0])
		circle(r=3.5,$fn=20);
	translate([3.5,-9,0])
		circle(r=3.5,$fn=20);
}

module BeamCross(){

	rotate([0,0,180]){
		difference(){
			BeamProfile();
			translate([2.5,0,0])	
				scale(.8)	
					BeamProfile();	
		}
	}
}

module SupBeamCross(){

	rotate([0,0,180])
		SupBeamProfile();
}

module Beam(StackRadius = 13, BeamLength = 150){
	difference(){
		union(){
			rotate([0,90,0])
				linear_extrude(height = BeamLength)
					BeamCross();
			//translate([BeamLength/2,8,13])
				//rotate([180,0,0])
					//teardrop(3.5, BeamLength, 90);
			//translate([BeamLength/2,10,9.5])
				//rotate([180,0,0])
					//teardrop(2.5, BeamLength, 90);


			//translate([BeamLength/2,-8,13])
				//rotate([180,0,0])
					//teardrop(3.5, BeamLength, 90);
			//translate([BeamLength/2,-10,9.5])
				//rotate([180,0,0])
					//teardrop(2.5, BeamLength, 90);

		}

		cylinder(r=StackRadius, h=40, $fn=50);
		translate([BeamLength,0,0])
			cylinder(r=StackRadius, h=40, $fn = 50);
		//translate([20,0,0])
		//	cylinder(r=4,h=40);
		//translate([BeamLength-20,0,0])
		//	cylinder(r=4,h=40);
	}
}


module SupBeam(){
	difference(){
		rotate([0,90,0])
			linear_extrude(height = 150)
				SupBeamCross();
		cylinder(r=13, h=40);
		translate([150,0,0])
			cylinder(r=13, h=40);
	}
}	



module Primary_Arm(){
	
	Beam();

	difference(){
		Bearing_stack();
		rotate([0,45,0])
					cube([1,30,1],center=true);
	}	

	translate([150,0,0])
		difference(){
			Driveshaft_stack();
			rotate([0,45,0])
					cube([1,30,1],center=true);
		}

}

module Secondary_Arm(){
	difference(){
		union(){
			Beam(StackRadius = 29.95/2);

			translate([150,0,0])
				Fastener_stack();

		}
	
		translate([150,0,0])
			rotate([0,45,0])
					cube([1,30,1],center=true);

		translate([0,0,22.2+2.5])
			minkowski(){
				cylinder(r=20.9-2.5, h=5);
				sphere(r=2.5, $fn=12);
			}
	}
	
}
module Hotend_stack(Hotend_D = 16.2, Hotend_H = 10, Mount_H = 12)
{
	difference(){
		union(){
			//translate([-11,11,Hotend_H-17])
				//difference(){
					//import("lib/Base_and_Riser_2.stl");
					//cube([50,50,14], center = true);
				//}
			
			cylinder(r=30/2, h=14 + Mount_H, $fn=50);
			cylinder(r=27/2, h=15 + Mount_H, $fn = 50);
			if ((2 + Hotend_H) > (23 + Mount_H)){
				translate([-11,11,Hotend_H-17])
				difference(){
					import("lib/Base_and_Riser_2.stl");
					cube([50,50,14], center = true);
				}
				cylinder(r=25/2, h=2 + Hotend_H, $fn = 50);
			}
			else{
				translate([-11,11,5 + Mount_H])
				difference(){
					import("lib/Base_and_Riser_2.stl");
					cube([50,50,14], center = true);
				}
				cylinder(r=25/2, h=23 + Mount_H, $fn = 50);
			}
			
			/*linear_extrude(height = 23 + Hotend_H)
				projection(cut=true)
					translate([-11,11,-10])
						import("lib/Base_and_Riser_2.stl"); */
			//cylinder(r=Hotend_D/2 -2, h=23 + Hotend_H, $fn = 50);	
		}
			
		translate([0,0,-1])	
		union(){
			cylinder(r=Hotend_D/2,h=Hotend_H, $fn = 50);		// Mounting Hole for Hotend
			//translate([0,0,Hotend_H])
			//	cylinder(r=1.5, h=5, $fn=36);
			translate([0,0,Hotend_H])
				cylinder(r=3, h=8, $fn=36);
			translate([0,0,Hotend_H+8])
				cylinder(r1=3,r2 = 3.9,h=16, $fn=36);
		}

		rotate([0,45,0])
			cube([1,30,1],center=true);		
	}

	
}

//Hotend_stack_2();

module Hotend_stack_2(Hotend_D = 16.2, Hotend_H = 12, Mount_H = Hotend_H)
{
	difference(){
		union(){
			translate([-11,11,5 + Hotend_H])
				difference(){
					import("lib/Base_and_Riser_2.stl");
					cube([50,50,14], center = true);
			}
			
			cylinder(r=30/2, h=12 + Hotend_H, $fn=50);
			//cylinder(r=27/2, h=15 + Hotend_H, $fn = 50);
			//cylinder(r=25/2, h=23 + Hotend_H, $fn = 50);	
		}
			
		translate([0,0,-1])	
		union(){
			cylinder(r=Hotend_D/2,h=Hotend_H+3, $fn = 50);		// Mounting Hole for Hotend
			//translate([0,0,Hotend_H])
			//	cylinder(r=1.5, h=5, $fn=36);
			translate([0,0,Hotend_H])
				cylinder(r=3, h=8, $fn=36);
			translate([0,0,Hotend_H+8])
				cylinder(r1=3,r2 = 3.9,h=16, $fn=36);
		}

		rotate([0,45,0])
			cube([1,30,1],center=true);		
	}

	
}



module Secondary_Arm_hotend_holder(Hotend_D = 16.2, Hotend_H = 12){
	difference(){
		
		union(){
			Hotend_stack(Hotend_D = Hotend_D, Hotend_H = Hotend_H);
			// mounting piece
			difference(){
				translate([13,0,Hotend_H-1])
					cube([8,12,20],center = true);
				
				translate([17,0,Hotend_H-10])
					rotate([0,45,0])
						cube([12,12,12],center = true);
			}
		}
		
	
		union(){

		// Arm mounting holes with "drop" openings
		translate([-3,8,Hotend_H+3])
			rotate([0,90,0])
				cylinder(r=2, h=45, $fn = 10);
		translate([-6,8,Hotend_H+3])
			rotate([0,90,0])
				cylinder(r=3.5, r2 = 2, h=3, $fn = 10);
		translate([-16,8,Hotend_H+3])
			rotate([0,90,0])
				cylinder(r=4,h=10, $fn = 50);
		translate([-11,8,Hotend_H+5.828])
			rotate([45,0,0])
				cube([10,4,4], center = true);

		
		translate([-3,-8,Hotend_H+3])
			rotate([0,90,0])
				cylinder(r=2, h=45, $fn = 10);
		translate([-6,-8,Hotend_H+3])
			rotate([0,90,0])
				cylinder(r=3.5, r2 = 2, h=3, $fn = 10);
		
		translate([-16,-8,Hotend_H+3])
			rotate([0,90,0])
				cylinder(r=4,h=10, $fn = 50);
		translate([-11,-8,Hotend_H+5.828])
			rotate([45,0,0])
				cube([10,4,4], center = true);
	
		// mounting holes for J-Head

		translate([6,20,Hotend_H-7])
			rotate([90,0,0])
				cylinder(r=1.5, h=40, $fn = 10);
		translate([-6,20,Hotend_H-7])
			rotate([90,0,0])
				cylinder(r=1.5, h=40, $fn = 10);

		// Subtract the beam
		translate([0,0,Hotend_H-10])
			Beam(StackRadius = 30/2);

		// M4 inner section  for 1.75 filament support
		translate([0,0,0])
			linear_extrude(h=400)
				projection()
					nutHole(4, tolerance = 0.5);
		}
	}
	//SupportCylinder (r1 = 2, r2 = 7, h=10);
	translate([0,0,Hotend_H-1])
		cylinder(r=Hotend_D / 2, h=.4);
}

module Secondary_Arm_hotend_holder_2(Hotend_D = 16.2, Hotend_H = 12){
	difference(){
		
		union(){
			Hotend_stack_2(Hotend_D = Hotend_D, Hotend_H = Hotend_H);
			// mounting piece
			difference(){
				translate([13,0,Hotend_H+2])
					cube([9,12,20],center = true);
				
				translate([17,0,Hotend_H-12])
					rotate([0,45,0])
						cube([12,12,15],center = true);
			}
		}
		
	
		union(){

	
		// mounting holes for J-Head

		translate([6,20,Hotend_H-7])
			rotate([90,0,0])
				cylinder(r=1.5, h=40, $fn = 10);
		translate([-6,20,Hotend_H-7])
			rotate([90,0,0])
				cylinder(r=1.5, h=40, $fn = 10);

		// Subtract the beam
		//translate([0,0,Hotend_H-10])
			//Beam(StackRadius = 30/2);

		// M4 inner section  for 1.75 filament support
		translate([0,0,0])
			linear_extrude(h=400)
				projection()
					nutHole(4, tolerance = 0.5);
		}
	}
	//SupportCylinder (r1 = 2, r2 = 7, h=10);
	translate([0,0,Hotend_H-1+3])
		cylinder(r=Hotend_D / 2, h=.4);
}

module Secondary_Arm_hotend_holder_mk2(Hotend_D = 16.2, Hotend_H = 12,Mount_H = 12, mountpiece = true){
	difference(){
		
		union(){
			Hotend_stack(Hotend_D = Hotend_D, Hotend_H = Hotend_H, Mount_H = Mount_H);
			// mounting piece
			if (mountpiece){
				difference(){
					translate([13,0,Mount_H-1])
						cube([8,12,20],center = true);
				
					translate([17,0,Mount_H-10])
						rotate([0,45,0])
							cube([12,13,12],center = true);
				}
			}
		}
		
	
		union(){

		// Arm mounting holes with "drop" openings
		translate([-3,8,Mount_H+3])
			rotate([0,90,0])
				cylinder(r=2, h=45, $fn = 10);
		translate([-6,8,Mount_H+3])
			rotate([0,90,0])
				cylinder(r=3.5, r2 = 2, h=3, $fn = 10);
		translate([-16,8,Mount_H+3])
			rotate([0,90,0])
				cylinder(r=4,h=10, $fn = 50);
		translate([-11,8,Mount_H+5.828])
			rotate([45,0,0])
				cube([10,4,4], center = true);

		
		translate([-3,-8,Mount_H+3])
			rotate([0,90,0])
				cylinder(r=2, h=45, $fn = 10);
		translate([-6,-8,Mount_H+3])
			rotate([0,90,0])
				cylinder(r=3.5, r2 = 2, h=3, $fn = 10);
		
		translate([-16,-8,Mount_H+3])
			rotate([0,90,0])
				cylinder(r=4,h=10, $fn = 50);
		translate([-11,-8,Mount_H+5.828])
			rotate([45,0,0])
				cube([10,4,4], center = true);
	
		// mounting holes for J-Head

		translate([6,20,Hotend_H-7])
			rotate([90,0,0])
				cylinder(r=1.5, h=40, $fn = 10);
		translate([-6,20,Hotend_H-7])
			rotate([90,0,0])
				cylinder(r=1.5, h=40, $fn = 10);

		// Subtract the beam
		translate([0,0,Mount_H-10])
			Beam(StackRadius = 30/2);

		// M4 inner section  for 1.75 filament support
		translate([0,0,0])
			linear_extrude(h=400)
				projection()
					nutHole(4, tolerance = 0.75);
		}
	}
	//SupportCylinder (r1 = 2, r2 = 7, h=10);
	translate([0,0,Hotend_H-1])
		cylinder(r=Hotend_D / 2, h=.4);
}

module Secondary_Arm_hotend_holder_mk3(Hotend_D = 16.2, Hotend_H = 12,Mount_H = 12, mountpiece = true){
	difference(){
		
		union(){
			Hotend_stack(Hotend_D = Hotend_D, Hotend_H = Hotend_H, Mount_H = Mount_H);
/*			// mounting piece
			if (mountpiece){
				difference(){
					translate([13,0,Mount_H-1])
						cube([8,12,20],center = true);
				
					translate([17,0,Mount_H-10])
						rotate([0,45,0])
							cube([12,13,12],center = true);
				}
			}
*/			
		}
		
	
		union(){

		// mounting holes for J-Head

		translate([6,20,Hotend_H-7])
			rotate([90,0,0]){
				cylinder(r=1.5, h=40, $fn = 10);
				translate([0,0,2.5])
					cylinder(r=3, h=5, $fn=12);
				translate([0,0,32.5])
					cylinder(r=3, h=5, $fn=12);
			}
		translate([-6,20,Hotend_H-7])
			rotate([90,0,0]){
				cylinder(r=1.5, h=40, $fn = 10);
				translate([0,0,4])
					cylinder(r=3, h=5, $fn=12);
				translate([0,0,31])
					cylinder(r=3, h=5, $fn=12);
			}


		// Subtract the beam
//		translate([0,0,Mount_H-10])
//			Beam(StackRadius = 30/2);

		// M4 inner section  for 1.75 filament support
		translate([0,0,0])
			linear_extrude(h=400)
				projection()
					nutHole(4, tolerance = 0.75);
		}

		// Name...

		writecylinder("RepRap",[0,0,0],15.5-Text_depth,12 + Hotend_H,h=5,up=5, east=-90,font="orbitron.dxf");
			writecylinder("Morgan",[0,0,0],15.5-Text_depth,12 + Hotend_H,h=5,down=0, east=-90,font="orbitron.dxf");
	}
	//SupportCylinder (r1 = 2, r2 = 7, h=10);
	translate([0,0,Hotend_H-1])
		cylinder(r=Hotend_D / 2, h=.4);
}

module Hotend_stack4(Hotend_D = 16.2, Hotend_H = 10, Mount_H = 12, base = true)
{
	difference(){
		union(){
			//translate([-11,11,Hotend_H-17])
				//difference(){
					//import("lib/Base_and_Riser_2.stl");
					//cube([50,50,14], center = true);
				//}
			if (base == true) {
              difference(){
				#linear_extrude(height = 14.7)
					rotate([0,0,-90])
						scale([1,1,1])
							import("lib/Head_profile.dxf", $fn = 200);			
				translate([20,0,10])
					cube([12,5.2,20],center=true);
			    }
            }
			cylinder(r=22/2, h=19.7, $fn=100);
			cylinder(r=17/2, h=29.5, $fn = 100);
			if ((2 + Hotend_H) > (23 + Mount_H)){
				translate([-11,11,Hotend_H-17])
				difference(){
					import("lib/Base_and_Riser_2.stl");
					cube([50,50,14], center = true);
				}
				cylinder(r=15/2, h=2 + Hotend_H, $fn = 50);
			}
			else{
				translate([-11,11,23])
				difference(){
					scale([0.98, 0.98, 1])
					import("lib/Base_and_Riser_2.stl");
					cube([50,50,14], center = true);
				}
				//cylinder(r=15/2, h=19.7+10, $fn = 50);
			}
			
			/*linear_extrude(height = 23 + Hotend_H)
				projection(cut=true)
					translate([-11,11,-10])
						import("lib/Base_and_Riser_2.stl"); */
			//cylinder(r=Hotend_D/2 -2, h=23 + Hotend_H, $fn = 50);	
		}
			
		translate([0,0,-1])	
		union(){
			cylinder(r=Hotend_D/2,h=Hotend_H, $fn = 50);		// Mounting Hole for Hotend
			//translate([0,0,Hotend_H])
			//	cylinder(r=1.5, h=5, $fn=36);
			translate([0,0,Hotend_H])
				cylinder(r=3, h=8, $fn=36);
			translate([0,0,Hotend_H+8])
				cylinder(r1=3,r2 = 3.9,h=16, $fn=36);
		}

		rotate([0,45,0])
			cube([1,30,1],center=true);		
	}

	
}

module Secondary_Arm_hotend_holder_mk4(Hotend_D = 16.2, Hotend_H = 12,Mount_H = 12, mountpiece = true){
	difference(){
		
		union(){
			Hotend_stack4(Hotend_D = Hotend_D, Hotend_H = Hotend_H, Mount_H = Mount_H);
		
		}
		
	
		union(){

		// mounting holes for J-Head

		for (i=[-1,1]){
		translate([7*i,20,Hotend_H-7])
			rotate([90,0,0]){
				cylinder(r=1.5, h=40, $fn = 10);
				translate([0,0,2.5])
					cylinder(r=3, h=5, $fn=12);
				translate([0,0,32.5])
					cylinder(r=3, h=5, $fn=12);
			}
      }

		// M4 inner section  for 1.75 filament support
		translate([0,0,0])
			linear_extrude(h=400)
				projection()
					nutHole(4, tolerance = 0.75);
		}

		// Name...

		writecylinder("RepRap",[0,0,0],15.5-Text_depth,Hotend_H,h=5,up=5, east=-90,font="orbitron.dxf");
			writecylinder("Morgan",[0,0,0],15.5-Text_depth,Hotend_H,h=5,down=0, east=-90,font="orbitron.dxf");
	}
	//SupportCylinder (r1 = 2, r2 = 7, h=10);
	translate([0,0,Hotend_H-1])
		cylinder(r=Hotend_D / 2, h=.4);
}

module Sup_Arm1(){

	intersection(){
		union(){
			

			difference(){
				union(){
					SupBeam();
					cylinder(r=30/2, h=7, $fn = 50);
				}
				//cylinder(r=22/2, h=7, $fn = 50);
				translate([0,0,-1])
					polyhole(10,22);
				rotate([0,45,0])
					cube([1,30,1],center=true);
			}			

			//translate([150,0,0])
			//	Fastener_stack();
		}
		translate([-50,-25,0])
			cube([250,50,7]);
	}
	translate([150,0,0])
		difference(){
			cylinder(r=30/2, h=30, $fn = 50);
			translate([0,0,7])
				polyhole(32, Drive_pipe_OD);
			translate([0,0,-1])
				polyhole(32, Drive_bearing_OD);	// bearing cavity
			translate([0,0,20])
				rotate([90,0,0])
					cylinder(r=2,h=40, center=true);
			rotate([0,45,0])
					cube([1,30,1],center=true);
		}	
		
}

module Sup_Arm2(){

	intersection(){
		union(){
			

			difference(){
				union(){
					SupBeam();
					cylinder(r=45/2, h=7, $fn = 50);

					// Flat area for 90deg calibration - Set square
			translate([150*.75, -11.5, 3.5])
				cube([75,7,7], center=true);
				}
				cylinder(r=37/2, h=7, $fn = 50);
				rotate([0,45,0])
					cube([1,50,1],center=true);
			}			

			translate([150,0,0])
				difference(){
					Fastener_stack();
					rotate([0,45,0])
						cube([1,30,1],center=true);
				}
		}
		translate([-50,-25,0])
			cube([250,50,7]);

		
	}

	difference(){
				cylinder(r=45/2, h=10, $fn = 50);
				translate([0,0,8])
					cylinder(r1=37/2, r2=35/2, h=1, $fn=50);
				cylinder(r=35/2,h=10, $fn=50);
				cylinder(r=37/2, h=8, $fn = 50);
				rotate([0,45,0])
					cube([1,50,1],center=true);
	}	



}


motorshaft = 5.2;
motorshaftlenght = 15;
nutdiameter = 6;
nutheight = 3;
grubdiameter = 3;

leadscrewshaft = 7.5;
leadscrewshaftlenght = 13;
couplertopdiameter = 22;

module MorganZCoupler ()
{
	couplheight = motorshaftlenght+leadscrewshaftlenght+2;

	difference(){
		union(){
			cylinder(r=couplertopdiameter/2, h=couplheight);
			intersection(){
				translate([0,0,(couplheight*.75+5)/2])
					cube([couplertopdiameter,couplertopdiameter,couplheight*.75+5],center=true);
				cylinder(r1 = couplertopdiameter/1.45, r2=couplertopdiameter/2, h=couplheight*.75);
			}
		}

		if (Leadnut_thread){
			intersection(){
				rotate([180,0,0])
					linear_extrude(height = 120/4, center = true, twist = -360)
						scale(1.1)
							leadscrew_profile();
				translate([0,0,-1])
					polyhole (leadscrewshaftlenght+1,leadscrewshaft+2);
			}
		} else {
			translate([0,0,-1])
					polyhole (leadscrewshaftlenght+1,leadscrewshaft);
		}
		translate([0,0,(leadscrewshaftlenght-1)/2 -1 ])
			cube([2,couplertopdiameter+1,leadscrewshaftlenght],center=true);

		translate([0,0,leadscrewshaftlenght+2])
			polyhole(motorshaftlenght+1,motorshaft);

		for (i=[0:2]){
			rotate([0,0,i*(360/3)])
				translate([0,0,couplheight - (motorshaftlenght*.3)])
					rotate([0,90,0]){
						polyhole(couplertopdiameter, grubdiameter);
						
						translate([0,0,couplertopdiameter/5])
							for(j=[0:2])
								translate([-grubdiameter*j,0,0])//{
									scale(1.1)
										nutHole(3);
									//translate([0,0,-0.5])
										//nutHole(3);					
								//}
					}

		}
		for (k=[-1,1])
			translate([-couplertopdiameter/2+2,k*(0.5+(leadscrewshaft/2)+grubdiameter/2),4])
				rotate([0,90,0]){
					translate([0,0,-1])
						polyhole(couplertopdiameter,3);
					boltHole(3,lenght=30);
					translate([0,0,couplertopdiameter-5])
						scale([1.05,1.05,1.5]) #nutHole(3);
				}
		
	}


}



//intersection(){
//    rotate([90,0,0])
    //lilian_joint4( );
  // cube([10,50,100],center=true);
//}    
   
 //blower();
    
    //lilian_joint2();
//translate([50,0,0])
//	lilian_joint2();
//translate([100,0,0])

//projection(cut=true)
//translate([0,0,-1])
//translate([0,0,-10])
//hotend_saddle();
//toolhead_body();
//translate([0,0,30])
//bowden_attachment();
//bowden_attachment2();
//lilian_toolhead2();
//projection(cut=true)
//translate([0,0,10])
//lilian_armholders();

//anti_backlash();
//translate([17,0,0])
//leadscrew_nut(20);

//bed_adjust_nut();

module bed_adjust_nut(){
    difference(){
        union(){
            cylinder(d=10, h=20);
            cylinder(d=14, h=5);
            translate([0,0,5])
                cylinder(d1=12,d2 = 10, h = 1);
        
            for (i=[0:5]){
                rotate([0,0,360/6*i])
                    translate([7,0,0])
                        cylinder(d=4, h=5);
            
            }
        }
        translate([0,0,-1]){
            polyhole(25,3);
            
            cylinder(d=6.5, h=5, $fn=6);
            translate([0,0,4.999])
                cylinder(d1=6.5, d2 = 3, h=1, $fn = 6);
            //color("red") cylinder (d=6, h=1);
        }    
        
        
    }
}

module anti_backlash(){
    leadscrew_nut(height = 20);

    difference(){
        translate([0,12.5,7])
            roundcube([8,25,14],2, center=true, $fn = 48);
        translate([0,0,8])
            cube([9,9,16], center=true);
       
    }
    
}

module lilian_armholders(){
    rotate([90,0,0])
    intersection(){
    
    difference(){
        union(){
            MorganBedarm();
            translate([0,0,36]){
                //#roundcube([30, 32, 77.2], 3, center=true);
                hull(){
                    cylinder(d=27, h=90, center=true);
                    translate([0,-30,0])
                        cylinder(d=27, h=90, center=true);
                    
                }
                
                hull(){
                    translate([0,26,-45])
                        cylinder(d=10, h=10);
                    translate([0,0,-45])
                        cylinder(d=10, h=10);
                    
                }
            }    
        }
        
        translate([0,0,36]){
             hull(){
                    cylinder(d=12, h=100, center=true);
                    translate([0,-30,0])
                        cylinder(d=12, h=100, center=true);
                 
                    
                }
            }
        translate([0,0,0])
            hull(){
                polyhole(30,21);
                translate([0,-30,0])
                    polyhole(30,21);
                
            }
        translate([0,0,42])
            hull(){
                polyhole(30,21);
                translate([0,-30,0])
                    polyhole(30,21);
                
            }
        
        translate([0,0,-20])
            polyhole(120,14);
        
        for (i=[0,40,80])
            for (j=[-1,1])    
                translate([j*9.5,-2,-4+i])
                    rotate([90,0,0])
                        cylinder(d=5, h=10);
    
        translate([0,26,-10])
             cylinder(d=5, h=3);
          
        translate([-25,40,36]) 
           //hull(){ 
             //rotate([0,90,0])
               // #cylinder(d=10, h=40);
             ///translate([0,25,0])  
             rotate([0,90,0])
                cylinder(d=25, h=40);
           //}
           
    }
    translate([0,39,30])
        cube([100,100,100],center=true);
}
    
}


module MorganBedarm_mount12(bearingD = 21, h=77){
	bearingR = bearingD / 2;

	subcyl = sqrt(pow((bearingR+4.25),2)/2);
 translate([0,0,-2.5]){	

	difference(){
		cylinder(r=bearingR + 4.25,h=h,$fn=50);
		translate([0,0,-1])	
			polyhole(h+2,bearingD+1);
		translate([bearingR+4.25,0,-.5])
			cylinder(r=subcyl,h=h+1,$fn=50);
		}
	rotate([0,0,-45])
		translate([bearingR+2.25,0,0])
			
cylinder(r=2.25,h=h, $fn=50);
	rotate([0,0,45])
		translate([bearingR+2.25,0,0])
			cylinder(r=2.25,h=h, $fn=50);


	for(i = [0:4]){
		
			rotate([0,0,60+i*60])
				translate([bearingR+1,0,0])
					cylinder(r=1.25, h=77, $fn=12);
	}
 }	
}

module hotend_saddle(){
    difference(){
        intersection(){
            lilian_toolhead2();

            union(){
                //cube([30,45,15.7],center=true);
                //%cube([40,47.8,11],center=true);
                 translate([(bearingOD + 10)/-2,-((pipeOD+4.1)/1.8 + 5),-2])
                    cube([bearingOD + 10,(pipeOD+4)*2 , 7.51] );

            }
        }
        
        // Saddle mount
        for(i=[-1,1]){
            translate([i*8,-11,-0.1]){
                polyhole(20,3);     
                cylinder(r1 = 3.5, r2 = 1.5, h=2, $fn=48);
            }
        }
    }
}

module bowden_attachment(){
    intersection(){
        difference(){
            lilian_toolhead2();

            union(){
                cube([30,43.8,11],center=true);
        
            }
        }
        
        union(){
            //translate([0,0,16.25])
              //  cylinder(d=16, h=60);
            
            translate([0,0,16.25])
                cylinder(d=20, h=60);
            
        }
    }
}   

module bowden_attachment2(){  //pneumatic adaptor
    
    difference(){
        union(){
            cylinder(d=20, h=17);
            cylinder(d=16.5, h=23);
            cylinder(d=15, h=28);
            translate([0,0,28]) cylinder(d1=15, d2=15.2, h=0.5);
            translate([0,0,28.5]) cylinder(d1=15.2, d2=15.0, h=1);
        }
        translate([0,0,-1])
            polyhole(33, 4.2);
        translate([0,0,18])
            polyhole(20, coupler_hole);
        translate([0,0,23])
            polyhole(20, 12);
    }
    
}   

module toolhead_body(){
    difference(){
        lilian_toolhead2();

        union(){
            translate([(bearingOD + 10)/-2,-((pipeOD+4.1)/1.8 + 5),-2])
                         cube([bearingOD + 10,(pipeOD+4)*2 , 7.51] );
            
            translate([0,0,16.25])
                cylinder(d=20, h=60);
            
            // Saddle mount
                for(i=[-1,1]){
                    translate([i*8,-11,-0.1]){
                        polyhole(20,4);
                        translate([0,0,5.5])
                            #cylinder(r=3, h=0.7, $fn=48);
                    }   
                }
         }
    }
} 


module lilian_joint1() // rod mounted joint
{
		difference(){
			union(){
				// Main cylinder body
				cylinder (r=(bearingOD + 4)/2, h=pipeOD+4);
				
				// Pipe adaptor
				translate([0,0,(pipeOD+4)/2])
					rotate([90,0,0])
					{
						cylinder(r=(pipeOD+4)/2, h=50);	

						scale([1,1,1])
							sphere(r=(pipeOD+4)/2);

					}
			}

			translate([0,0,-0.5])
			{
				// Inner pipe cavity
				cylinder (r=(shaftOD*holefactor)/2, h=pipeOD+5);	
			}

			// Pipe adaptor cavity
			translate([0,0,(pipeOD+4)/2])
					rotate([90,0,0])
						polyhole(51,pipeOD*holefactor);			

			// Inner cavity
			translate([0,0,(pipeOD+4)/2])
				scale([1,1,1])
					sphere(r=pipeOD/2*holefactor);
			// Wire outlet
			translate([0,shaftOD*2,pipeOD/2+2])
				rotate([90,0,0])
					cylinder(d=10, h=30);
		}
}

module lilian_joint4() // pipe mounted joint
{
		difference(){
			union(){
				// Main cylinder body
				cylinder (r=(drivepipeOD + 4)/2, h=pipeOD+4);
				
				// Pipe adaptor
				translate([0,0,(pipeOD+4)/2])
					rotate([90,0,0])
					{
						cylinder(r=(pipeOD+4)/2, h=50);	

						scale([1,1,1])
							sphere(r=(pipeOD+4)/2);

					}
			}
			// Upper bearing cavity
			translate([0,0,pipeOD+4-10])
			   cylinder(r=bearingOD/2, h=8);

			translate([0,0,-0.5])
			{
				// Inner pipe cavity
				cylinder (r=(drivepipeOD)/2, h=pipeOD+3.5 - bearingH);	
                
                // Inner bearing cavity
				cylinder (r=(bearingOD/2) - 2, h=pipeOD+5);	

			}

			// Pipe adaptor cavity
			translate([0,-15,(pipeOD+4)/2])
					rotate([90,0,0])
						polyhole(51,pipeOD*holefactor);			

		}
}

module lilian_joint2() // Bearing mounted joint
{
		difference(){
			union(){
				// Main cylinder body
				cylinder (r=(bearingOD + 4)/2, h=pipeOD+4);
				
				// Pipe adaptor
				translate([0,0,(pipeOD+4)/2])
					rotate([90,0,0])
					{
						cylinder(r=(pipeOD+4)/2, h=50);	
						scale([1,1,1])
							sphere(r=(pipeOD+4)/2);

					}
			}

			translate([0,0,-0.5])
			{
				// Lower bearing cavity
				cylinder(r=bearingOD/2,h=bearingH + 1);
	
				// Inner bearing cavity
				cylinder (r=(bearingOD/2) - 2, h=pipeOD+5);	
			}

			// Upper bearing cavity
			translate([0,0,pipeOD+4-bearingH])
			   cylinder(r=bearingOD/2, h=bearingH + 1);

				
			// Pipe adaptor cavity
			translate([0,-shaftOD,(pipeOD+4)/2])
					rotate([90,0,0])
						scale([1,1,1])
						polyhole(51,pipeOD*holefactor);			
			translate([0,0,(pipeOD+4)/2])
					rotate([90,0,0])
						scale([1,.65,1])
						polyhole(51,pipeOD*holefactor);			

			// Upper bearing ledge supportless printing slope
			//translate([0,0,24.99])
				//cylinder(r1=bearingOD/2, r2=bearingOD/2 - 3, h=3);

			// Lower bearing ledge 
			//translate([0,0,7.49])
				//cylinder(r1=bearingOD/2, r2=bearingOD/2 - 3, h=3);

			// Inner cavity
			translate([0,0,(pipeOD+4)/2])
				scale([1,1,.65])
					sphere(r=pipeOD/2*holefactor);
//			translate([0,0,11])
	//			cylinder(r=bearingOD/2, h=pipeOD+4-16-6);

			// Marker
			//translate([0,0,0])
				//rotate([45,0,0])
					//cube([2*pipeOD,1,1], center= true);

			// Wire outlet
			translate([0,shaftOD*2,pipeOD/2+2])
				rotate([90,0,0])
					cylinder(d=10, h=30);

		}
}

module lilian_joint3() // toolhead bearing mounted joint
{
		difference(){
			union(){
				// Main cylinder body
				cylinder (r=(bearingOD + 7)/2, h=pipeOD-4);
				
				// Pipe adaptor
				translate([0,0,(pipeOD+4)/2])
					rotate([90,0,0])
					{
						cylinder(r=(pipeOD+4)/2, h=50);	
						scale([1,1,1])
							sphere(r=(pipeOD+4)/2);


					}
			}

			translate([0,0,-0.5])
			{
				// Lower bearing cavity
                translate([0,0,2])
                    cylinder(r=bearingOD/2,h=bearingH);
                translate([0,0,-0.1])
                    cylinder(d1=bearingOD+0.4, d2=bearingOD-0.8,h=1.6);
                translate([0,0,1.49])
                    cylinder(d=bearingOD-0.8, h=1.02);
                
				// Inner bearing cavity
				cylinder (r=(bearingOD/2) - 1, h=pipeOD+5);	
			}

			
			// Pipe adaptor cavity
			translate([0,-shaftOD,(pipeOD+4)/2])
					rotate([90,0,0])
						scale([1,1,1])
						polyhole(51,pipeOD*holefactor);			
			
            translate([0,6,23 + bearingH]) {
                    roundcube([80,40,40], 10, center = true, $fn = 48);
            }
 		}
}


module lilian_toolhead2(Hotend_D = 16){
    
    difference(){
        union(){
    
    Hotend_stack4(Hotend_D = Hotend_D, Hotend_H = 17.25, Mount_H = 18, base = false);
   	difference(){
			union(){
				// Main cylinder body
				cylinder (r=(bearingOD + 4)/2, h=pipeOD+4);
                cylinder (r=(bearingOD + 8)/2, h=pipeOD/2+4);
                
                
                
                
                translate([0,0,pipeOD+3])
                difference(){
                    union(){
                        cylinder(d=17, h=5);
                        cylinder(d=15, h=10);
                    }    
                    translate([0,0,.5])
                    cylinder(d=8, h=7);
                }
				
				// Pipe adaptor
				translate([0,0,(pipeOD+4)/2])
					rotate([90,0,0])
					{
                        cylinder(r=(pipeOD+4)/2, h=54);
                        scale([1,1,1])
							sphere(r=(pipeOD+4)/2);

					}
                translate([(bearingOD + 8)/-2,-((pipeOD+4)/1.8 + 5),0])
                            //cube([(pipeOD+4)/2, bearingOD + 8, (pipeOD+4)/1.8 + 5]);
                        cube([bearingOD + 8,(pipeOD+4)/1.8 + 5 , (pipeOD+4)/2 ] );
                        
			}

			translate([0,0,-0.5])
			{
				// Inner pipe cavity
				//cylinder (r=(Hotend_D *holefactor)/2, h=pipeOD+5);	
                polyhole(pipeOD+5, Hotend_D);
			}
            
            // Blower
            //translate([-10,-35,25])
              //  rotate([0,0,0])
                //rotate([0,90,0])
                  //  #blower();
            
   			// Pipe adaptor cavity
			translate([0,-15.5,(pipeOD+4)/2])
					rotate([90,0,0])
						polyhole(50,pipeOD);			

			// Inner cavity
			//translate([0,0,(pipeOD+4)/2])
				//scale([1,1,1])
					//sphere(r=pipeOD/2*holefactor);
			// Wire outlet
			//translate([0,shaftOD*2,pipeOD/2+2])
			//	rotate([90,0,0])
			//		#cylinder(d=10, h=30);
            
            //Connector
            translate([0,-19,((pipeOD+4)/1.8)/2-2])
                            cube([23, 4, (pipeOD+4)/1.8], center=true);
            translate([0,-19,((pipeOD+4)/1.8)/2+1.5])
                            cube([26, 7, (pipeOD+4)/1.8], center=true);
            
            translate([0,-21.5,0])
                            cube([3.5, 2, 20], center=true);
                            
            
            
            // Morgan M Logo
            difference(){
                translate([0,10,pipeOD/2+5])
                    rotate([90,0,180])
                        scale([.5,.5,1])
                            linear_extrude(height = 10)
                                import("Morgan_M.dxf");
                translate([0,-.5,(pipeOD+4)/2])					
                    sphere(r=(pipeOD+4)/2);

					}
		}
    
    }
     // M4 inner section  for 1.75 filament support
		translate([0,0,0])
			linear_extrude(h=400)
				projection()
					nutHole(4, tolerance = 0.75);
    
      // Quick change slot

            translate([0,0,5.5])
                linear_extrude(height = 6){
                    import("lib/lilian_head_lock_plug.dxf");
                    
                }
        }
    }
    
    
module footshape(){
  
        intersection(){
            union(){
                hull(){
                    cylinder(d=55,h=10);
                    translate([0,0,53.1])
                        scale([1,1,.75])
                        sphere(d=55);
                }
            }
            
            cylinder(d=150, h=68.1);
        }   
}
        
    
module foot($fn = 150){
    difference(){   
         footshape();
         translate([0,0,-4])
         scale([.94, .94, 1])
            footshape();
    }
    intersection (){
        footshape();
        for (i=[0:3]){
            rotate([0,0,i*360/4])
                translate([23,0,40])
                #cube([40,2,80],center=true);
        }
    }
    translate([0,0,68])
    cylinder(d=38, h=2);
    
    difference([0,0,0]){
        cylinder(d=10, h=70);
        translate([0,0,-1])
           cylinder(d=5, h=13);
    }
}    

