// Ramps cooler bracket/guard. By Justblair (Blair Thompson) 

// This is a design for a front panel for my Prusa Printer, but it is 
// more than likely of use for any of the 3D printers 
// Please take a moment or two to adjust the parameters to your needs.

// Please adjust the hole sizes to match your printer and your preffered mounting
// bolts.  

// To keep up to date with my latest projects check www.justblair.co.uk

// Options

LED_holes = true;
kill_button = false;
SD_card = true;

// Dimensions

lcd_board_width = 120.9;  
lcd_board_length = 88;
lcd_board_thickness = 4;  	// 4mm is pretty thick and solid, I estimate 2mm would do

rotary_encoder_diameter = 7.5;
kill_switch_diameter = 16.4;

sd_card_width = 30;			// The width of the SD card module
sd_card_depth = 50;			// The depth of the SD card module
sd_card_height = 6;			// The height of the SD card module

ard_hole_radius = 1.9; 		// for M3 bolt, adjust to your printer/mounts
LED_Rad = 2.9;  			// for 5mm diameter LED, adjust to your printer...
mount_holes_inset = 6;		// How far in from outside edges shoudl the mount holes be

$fn = 20;					// Adust the smoothness of the holes


// Here comes the code!!

rotate ([180, 0,0])
translate([-lcd_board_width/2, -lcd_board_length/2,-lcd_board_thickness])
lcd_complete();

module lcd_complete(){
	difference() {
		union (){
			base();
			sd_card_support();
		}
		translate ([(lcd_board_width-98)/2, (lcd_board_length - 65),-7])
			#lcd_dummy();
		rotary_encoder();
		if (kill_button == true){
			kill_switch();
		}
		if (SD_card == true){
			sd_card_cutout();
		}
		if (LED_holes == true){
			led_mounts();
		}
	}
}

module lcd_dummy(){		// This is used to create the cutout for the 20*4 LCD
	difference(){
		union(){
			cube ([98, 60, 1.44]);
			translate([2.5+1.4, 11.5, 0])
				cube([90.2 , 37, 10.2]);
			translate([2.5+6,15,0])
				cube([76 +5, 25.2 + 5, 21.5]);
			translate([2.5,2.5,-1])
				cylinder (r=3.5/2, h=22.5);
			translate([2.5, 60-2.5,-1])
				cylinder (r=3.5/2, h=22.5);
			translate([98-2.5,2.5,-1])
				cylinder (r=3.5/2, h=22.5);
			translate([98-2.5, 60-2.5,-1])
				cylinder (r=3.5/2, h=22.5);
		}	
	}
}

module kill_switch(){	// Creates a cutout for a kill switch if required.
	translate ([35, 14,-1])
		cylinder(r = kill_switch_diameter/2, h = lcd_board_thickness + 2);
}

module base(){
	difference()
	{
		translate ([lcd_board_width/2, lcd_board_length/2, 0]) 
		roundedRect([lcd_board_width - 2.5, lcd_board_length - 2.5,lcd_board_thickness], 2.5);
		// translate ([0,lcd_board_length-53.34,0])
		mounting_holes();
		// translate ([99.06, 40.64, 0]) cube ([2.54, 12.7, 1.6]);
	}
}

module sd_card_cutout (){
	translate ([35, 14,-1])
	cube ([sd_card_width,sd_card_height,30], center = false);
}
module sd_card_support (){
	translate ([35, 14 + sd_card_height, lcd_board_thickness - sd_card_depth])
	# cube ([sd_card_width,3, sd_card_depth], center = false);
}

module rotary_encoder(){
		translate ([lcd_board_width-35, 14,-1]) {
			cylinder (r=rotary_encoder_diameter/2, h= lcd_board_thickness +2);
			cube([14.5, 2.2,5], center = true);
			translate ([0,0,-3])
			%cube([14.5,12,7], center = true);
			}
		translate ([lcd_board_width-35, 14, 5])
			%cylinder (r=25/2, h= 17);			
}


module led_mounts(){
	translate ([7.5,lcd_board_length/2-4.5,0]) {
		translate ([0,0,-1]) led_hole();
		translate ([0,27.5/2,-1]) led_hole();
		translate ([0,27.5,-1]) led_hole();
	}
}

module led_hole(){
	cylinder (r=LED_Rad, h=(lcd_board_thickness+2), $fn=50);
}

module mounting_holes(){
	translate ([mount_holes_inset,mount_holes_inset,-1]) hole(); //lower left hole
	translate ([ mount_holes_inset,lcd_board_length -mount_holes_inset, - 1]) hole(); //upper left hole
	translate ([lcd_board_width -mount_holes_inset, mount_holes_inset,-1]) hole(); //lower right hole
	translate ([lcd_board_width -mount_holes_inset,lcd_board_length -mount_holes_inset,-1]) hole(); //upper right hole
}

module hole(){
	cylinder(r=ard_hole_radius, h=(lcd_board_thickness+2), $fn=25);
}

module roundedRect(size, radius) {
	x = size[0]; 
	y = size[1]; 
	z = size[2]; 

	linear_extrude(height=z) 
	hull() { 
		// place 4 circles in the corners, with the given radius 
		translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0]) circle(r=radius); 
		translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0]) circle(r=radius); 
		translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0]) circle(r=radius); 
		translate([(x/2)-(radius/2), (y/2)-(radius/2), 0]) circle(r=radius); 
		translate([0,0,0]);
	} 
}