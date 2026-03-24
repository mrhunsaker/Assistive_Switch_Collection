// Written by Volksswitch <www.volksswitch.org>
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.


// may need to support intermediate spacer lengths since McMaster Carr doesn't have a 15mm spacer


//------------------------------------------------------------------
// User Inputs
//------------------------------------------------------------------

/*[Switch Behavior]*/
//force indexes larger than 0 will include a leaf spring
activation_force_index = 0; // [0:10]
//distances larger than 0 require a force index larger than 0
activation_distance = 0; // [0:5]
evaluation_switch = "no"; // [yes,no]

/*[Spacer Info]*/
spacer_length = 15; // [10,15,20]
spacer_thickness = 10;
spacer_screw_length = 10;
spacer_screw_size = "M6"; // [M4,M5,M6]

/*[Microswitch Info]*/
microswitch_type = "black insulation"; // [black insulation,red and black insulation]

/*[Activation Surface]*/
activation_surface_type = "flat"; // [flat,curved]
activation_surface_thickness = 4; // [4:10]
activation_surface_width = 45; // [30,35,40,45,50,55,65,70,75,80,85,90,95,100]
activation_surface_corner_radius = 5; // [5,10,15,20,25,30,35,40,45,50]
activation_surface_facets = 15; // [4:50]

/*[Switch Info]*/
switch_width=65; // [65,70,75,80,85,90,95,100]
switch_corner_radius = 5; // [5,10,15,20,25,30,35,40,45,50]
// print a "hole size test" part to obtain this value
spacer_hole_test_value = 3;// [1,2,3,4,5]  

/*[Special Settings]*/
section = "no"; // [yes,no]
change_headphone_jack_location = 0; // [-3:3]

/*[Parts to Show in Assembly View]*/
show_activation_surface = "yes"; // [yes,no]
show_spacer = "yes"; // [yes,no]
show_switch_cover = "yes"; // [yes,no]
show_spacer_plug = "yes"; // [yes,no]
show_mini_post = "yes"; // [yes,no]
show_leaf_spring = "yes"; // [yes,no]
show_headphone_jack = "yes"; // [yes,no]
show_microswitch = "yes"; // [yes,no]
show_switch_base = "yes"; // [yes,no]
show_switch_mount = "yes"; // [yes,no]

/*[Part to Print]*/
part = "switch base"; // [activation surface, switch cover, switch base, leaf spring, spacer plug, switch mount, leaf spring collection - same activation distance, leaf spring collection - same activation force index, spacer plug collection - part 1, spacer plug collection - part 2, 10 mini-posts, hole size test, assembled switch]




/*[Hidden]*/
$fn=100;
fudge=0.005;


// spacer related measures
bolt_len = spacer_screw_length;
bolt_dia = (spacer_screw_size=="M2")? 2 :
				 (spacer_screw_size=="M3")? 3 :
				 (spacer_screw_size=="M4")? 4 :
				 (spacer_screw_size=="M5")? 5 : 6;
bolt_scale = 1;
threaded_hole_scale = 1.05;


//microswitch variables
microswitch_width = (microswitch_type == "black insulation") ? 18.3 : 15.33; // the short dimension of the microswitch
microswitch_height = (microswitch_type == "black insulation") ? 18.3 : 16.19; //the long dimension of the microswitch
microswitch_thickness = (microswitch_type == "black insulation") ? 5.5 : 7;
button_thickness= (microswitch_type == "black insulation") ? 1.6 : 0;
m_t = microswitch_thickness + button_thickness + 0.5;  // a little slop for safety

button_dia = (microswitch_type == "black insulation") ? 11.25 : 6.77;
slot_width = (microswitch_type == "black insulation") ? 3 : 12;
r1 = (microswitch_type=="black insulation") ? 0 : -45;
r2 = (microswitch_type=="black insulation") ? -90 : 45;
r3 = (microswitch_type=="black insulation") ? 180 : -135;

retainer_height = (microswitch_type=="black insulation") ? 6 : 10;
retainer_thickness = (microswitch_type=="black insulation") ? 2 : 3;
retainer_width = (microswitch_type=="black insulation") ? 10 : 12;
retainer_slot_width = (microswitch_type=="black insulation") ? 0 : 1.5;
retainer_wall_offset = (microswitch_type == "black insulation") ? 3 : 3;


// switch variables
switch_wall_thickness = 2;
switch_top_thickness = 2;
switch_bottom_thickness = 3;
include_leaf_spring = (activation_force_index > 0 || (activation_force_index==0 && activation_distance>0)) ? "yes" : "no";
switch_height = (spacer_length==10 && include_leaf_spring=="no") ? 27 :
				(spacer_length==15 && include_leaf_spring=="no") ? 30 :
				(spacer_length==20 && include_leaf_spring=="no") ? 35 :
				(spacer_length==10 && include_leaf_spring=="yes") ? 30 :
				(spacer_length==15 && include_leaf_spring=="yes") ? 35 :
				(spacer_length==20 && include_leaf_spring=="yes") ? 40 :
				100;
es_switch_height = (spacer_length==10) ? 30 :
				   (spacer_length==15) ? 35 :
				   (spacer_length==20) ? 40 :
				   100;
switch_base_height = (evaluation_switch=="no") ? switch_height-switch_top_thickness : es_switch_height-switch_top_thickness;
pedestal_height = 14 + switch_bottom_thickness;
top_of_microswitch = switch_bottom_thickness + m_t;

switch_fillet = min(switch_corner_radius,switch_width/2-fudge);
headphone_jack_len = 26.5;

v = (microswitch_type=="black insulation") ? 
	[[65,5,-.5],[65,10,-.5],[65,15,.5],[65,20,1],[65,25,4],[65,30,6],[65,35,7],[65,40,8],[65,45,8],[65,50,8],
	[70,5,-3],[70,10,-3],[70,15,-3],[70,20,-2],[70,25,0],[70,30,2],[70,35,4],[70,40,4],[70,45,4],[70,50,4],
	[75,5,-6],[75,10,-6],[75,15,-6],[75,20,-6],[75,25,-5],[75,30,-3],[75,35,0],[75,40,1],[75,45,1],[75,50,1],
	[80,5,-8],[80,10,-8],[80,15,-8],[80,20,-8],[80,25,-7.5],[80,30,-5.5],[80,35,-4],[80,40,-2],[80,45,-2],[80,50,-2],
	[85,5,-10],[85,10,-10],[85,15,-10],[85,20,-10],[85,25,-10],[85,30,-9],[85,35,-8],[85,40,-6],[85,45,-5],[85,50,-5],
	[90,5,-13],[90,10,-13],[90,15,-13],[90,20,-13],[90,25,-12],[90,30,-12],[90,35,-11],[90,40,-10],[90,45,-8],[90,50,-8],
	[95,5,-15],[95,10,-15],[95,15,-15],[95,20,-15],[95,25,-15],[95,30,-15],[95,35,-14.5],[95,40,-13.5],[95,45,-12],[95,50,-11],
	[100,5,-18],[100,10,-17.5],[100,15,-17.5],[100,20,-17.5],[100,25,-17.5],[100,30,-17.5],[100,35,-17.5],[100,40,-16.5],[100,45,-15.5],[100,50,-14]]
	:
	[[65,5,-.5],[65,10,-.5],[65,15,.5],[65,20,1],[65,25,4],[65,30,6],[65,35,7],[65,40,8],[65,45,8],[65,50,8],
	[70,5,-3],[70,10,-3],[70,15,-3],[70,20,-2],[70,25,0],[70,30,2],[70,35,4],[70,40,4],[70,45,4],[70,50,4],
	[75,5,-6],[75,10,-6],[75,15,-6],[75,20,-6],[75,25,-5],[75,30,-3],[75,35,0],[75,40,1],[75,45,1],[75,50,1],
	[80,5,-8],[80,10,-8],[80,15,-8],[80,20,-8],[80,25,-7.5],[80,30,-5.5],[80,35,-4],[80,40,-2],[80,45,-2],[80,50,-2],
	[85,5,-10],[85,10,-10],[85,15,-10],[85,20,-10],[85,25,-10],[85,30,-9],[85,35,-8],[85,40,-6],[85,45,-5],[85,50,-5],
	[90,5,-13],[90,10,-13],[90,15,-13],[90,20,-13],[90,25,-12],[90,30,-12],[90,35,-11],[90,40,-10],[90,45,-8],[90,50,-8],
	[95,5,-15],[95,10,-15],[95,15,-15],[95,20,-15],[95,25,-15],[95,30,-15],[95,35,-14.5],[95,40,-13.5],[95,45,-12],[95,50,-11],
	[100,5,-18],[100,10,-17.5],[100,15,-17.5],[100,20,-17.5],[100,25,-17.5],[100,30,-17.5],[100,35,-17.5],[100,40,-16.5],[100,45,-15.5],[100,50,-14]];

corner_radius_index = [[5,0],[10,1],[15,2],[20,3],[25,4],[30,5],[35,6],[40,7],[45,8],[50,9]];
cri = search(switch_corner_radius,corner_radius_index,0); // e.g., [1]

headphone_jack_start = v[search(switch_width,v,0,0)[cri[0]] ][2] - 2 - change_headphone_jack_location;


// leaf spring variables
max_activivation_distance = (spacer_length>10 || evaluation_switch=="yes") ?  5 : 3;
max_spring_thickness = (spacer_length>10 || evaluation_switch=="yes") ? 3 : 1.5;
a_d = activation_distance;
act_force_vector = [ [0,0], [1,2], [1,4], [1.5,2], [2,2], [1.5,4], [2.5,2], [2,4], [3,2], [2.5,4], [3,4] ];
a_f_i = activation_force_index;
act_force = act_force_vector[a_f_i];
s_t = (a_f_i==0 && activation_distance>0) ? 1 :act_force[0];
post_len = pedestal_height - m_t - switch_bottom_thickness - a_d;


// switch cover variables
switch_cover_height = 10; // determines the amount of overlap between the switch base and cover
sleeve_dia = 15;
brace_thickness = 3;
leaf_retention_post_length = (evaluation_switch=="yes") ? switch_base_height - pedestal_height-3.5 : 3;
				
hole_adjustment = 0.2; //account for printed hole being slightly smaller than specified - extrusion line width?
st_plus = spacer_thickness + hole_adjustment;
hex_hole_dia1 = (st_plus-.2)/cos(30);
hex_hole_dia2 = (st_plus-.1)/cos(30);
hex_hole_dia3 = (st_plus-0)/cos(30);
hex_hole_dia4 = (st_plus+.1)/cos(30); 
hex_hole_dia5 = (st_plus+.2)/cos(30); 

cover_hole_size = (spacer_hole_test_value==1) ? hex_hole_dia1 :
				  (spacer_hole_test_value==2) ? hex_hole_dia2 :
				  (spacer_hole_test_value==3) ? hex_hole_dia3 :
				  (spacer_hole_test_value==4) ? hex_hole_dia4 : 
				                                hex_hole_dia5;


//spacer plug variables
plug_width = 15;

mini_post_length = 7;  // mini post will extend 5 mm below the plug. the hole in the plug is 2 mm deep
mini_post_bottom = switch_bottom_thickness + m_t;
mini_post_top = mini_post_bottom + 5;

ad_offset = (spacer_length==10) ? 3 : 5;
es_prefered_top_of_spacer = es_switch_height + ad_offset + 1.5;
prefered_top_of_spacer = (evaluation_switch=="no") ? switch_height + a_d + 1.5 : es_switch_height + a_d + 1.5;

prefered_bottom_of_spacer = prefered_top_of_spacer - spacer_length;
es_prefered_bottom_of_spacer = es_prefered_top_of_spacer - spacer_length;

top_of_spring = pedestal_height + s_t;
es_top_of_spring = pedestal_height + 3;

prefered_plug_thickness = (include_leaf_spring=="yes") ? prefered_bottom_of_spacer - top_of_spring : prefered_bottom_of_spacer - mini_post_top;
es_prefered_plug_thickness = (include_leaf_spring=="yes") ? es_prefered_bottom_of_spacer - es_top_of_spring : es_prefered_bottom_of_spacer - mini_post_top;

plug_thickness = ceil(max(prefered_plug_thickness,3)*2)/2;
es_plug_thickness = max(es_prefered_plug_thickness,3);

bottom_of_spacer = (include_leaf_spring=="yes") ? top_of_spring+plug_thickness : mini_post_top + plug_thickness;
es_bottom_of_spacer = (include_leaf_spring=="yes") ? es_top_of_spring+es_plug_thickness : mini_post_top + es_plug_thickness;

bottom_of_spacer_plug = bottom_of_spacer-plug_thickness;
top_of_spacer = bottom_of_spacer+spacer_length;

activation_surface_max_deflection = (evaluation_switch=="no") ? top_of_spacer - switch_height : top_of_spacer - es_switch_height;

sleeve_length = (evaluation_switch=="no") ? switch_height - switch_top_thickness - bottom_of_spacer :
                es_switch_height-switch_top_thickness-es_bottom_of_spacer;
bottom_of_sleeve = switch_height - switch_top_thickness - sleeve_length;

// echo();
// echo(switch_height=switch_height);
// echo();
// echo(activation_surface_max_deflection=activation_surface_max_deflection);
// echo(a_d=a_d);
// echo();
// echo(plug_thickness=plug_thickness);
// echo();


// activation surface variables


// switch mount variables
switch_mount_height = 25; // determines the amount of overlap between the switch base and cover
tee_nut_pedestal_height = 5;


// feasibility test variables
feasible = (evaluation_switch=="no") ? (plug_thickness <= switch_height - brace_thickness - s_t - pedestal_height - switch_wall_thickness) && !(activation_force_index==0 && activation_distance>0) :
									   (plug_thickness <= es_switch_height - brace_thickness - s_t - pedestal_height - switch_wall_thickness) && !(activation_force_index==0 && activation_distance>0);

//
//***************** Main ****************
//

difference(){
	if (part == "activation surface"){
		color((feasible) ? "purple" : "red")
		activation_surface();
	}
	else if (part=="spacer plug"){
		color((feasible) ? "grey" : "red")
		spacer_plug(plug_thickness);
	}
	else if (part=="switch cover"){
		color((feasible) ? "yellow" : "red")
		switch_cover();
	}
	else if (part=="switch base"){
		color((feasible) ? "aqua" : "red")
		switch_base();
	}
	else if (part=="leaf spring"){
		color((feasible) ? "lime" : "red")
		leaf_spring(a_f_i,a_d);
	}
	else if (part=="assembled switch"){
	
		if(show_activation_surface=="yes"){
			r = (activation_surface_type=="flat") ? 180 : 0;
			tos = top_of_spacer;
			d = (activation_surface_type=="flat") ? tos+bolt_len+3 : tos;
			
			translate([0,0,d])
			rotate([0,r,0])
			color((feasible) ? "purple" : "red")
			activation_surface();
		}
		
		if(show_switch_cover=="yes"){
			// translate([0,0,switch_height-switch_wall_thickness+2])
			translate([0,0,switch_base_height+switch_top_thickness])
			rotate([0,0,180])
			rotate([0,180,0])
			color((feasible) ? "yellow" : "red")
			switch_cover();
		}
		
		if(show_leaf_spring=="yes"){
			if(include_leaf_spring=="yes"){
				translate([0,0,pedestal_height+s_t]) // after rotation, the leaf spring is entirely below the x/y plane
				rotate([0,180,0])
				color((feasible) ? "lime" : "red")
				leaf_spring(a_f_i,a_d);
			}
		}
		
		if(show_switch_base=="yes"){
			color((feasible) ? "aqua" : "red")
			switch_base();
		}
		
		if(show_spacer=="yes"){
			translate([0,0,bottom_of_spacer])
			color((feasible) ? "black" : "red")
			spacer();
		}
		
		if(show_spacer_plug=="yes"){
			translate([0,0,bottom_of_spacer_plug])
			color((feasible) ? "grey" : "red")
			spacer_plug(plug_thickness);
		}
		
		if(show_mini_post=="yes"){
			translate([0,0,mini_post_bottom])
			color((feasible) ? "black" : "red")
			mini_post();
		}
		
		if(show_microswitch=="yes"){
			translate([0,0,switch_bottom_thickness])
			color((feasible) ? "blue" : "red")
			microswitch();
		}
		if(show_headphone_jack=="yes"){
			translate([headphone_jack_start,(microswitch_width+3)/2,switch_wall_thickness])
			color((feasible) ? "green" : "red")
			headphone_plug();
		}
		if(show_switch_mount=="yes"){
			translate([0,0,-(switch_mount_height-switch_wall_thickness-14.5)])
			color((feasible) ? "pink" : "red")
			switch_mount();
		}
	}
	else if (part=="hole size test"){
		hole_size_test();
	}
	else if (part=="switch mount"){
		color((feasible) ? "pink" : "red")
		switch_mount();
	}
	else if (part=="spacer plug collection - part 1"){
		translate([(plug_width+2)*0,0,0])
		spacer_plug(3);
		
		translate([(plug_width+2)*1,0,0])
		spacer_plug(3.5);
		
		translate([(plug_width+2)*2,0,0])
		spacer_plug(4);
		
		translate([(plug_width+2)*3,0,0])
		spacer_plug(4.5);
		
		translate([(plug_width+2)*0,(plug_width+2)*1,0])
		spacer_plug(5);
		
		translate([(plug_width+2)*1,(plug_width+2)*1,0])
		spacer_plug(5.5);
		
		translate([(plug_width+2)*2,(plug_width+2)*1,0])
		spacer_plug(3);
		
		translate([(plug_width+2)*3,(plug_width+2)*1,0])
		cube([mini_post_length,3,3]);
	}	
	else if (part=="spacer plug collection - part 2"){
		translate([(plug_width+2)*0,0,0])
		spacer_plug(6);
		
		translate([(plug_width+2)*1,0,0])
		spacer_plug(6.5);
		
		translate([(plug_width+2)*2,0,0])
		spacer_plug(7);
		
		translate([(plug_width+2)*3,0,0])
		spacer_plug(7.5);
		
		translate([(plug_width+2)*0,(plug_width+2)*1,0])
		spacer_plug(8);
		
		translate([(plug_width+2)*1,(plug_width+2)*1,0])
		spacer_plug(8.5);
		
		translate([(plug_width+2)*2,(plug_width+2)*1,0])
		spacer_plug(6);
		
		translate([(plug_width+2)*3,(plug_width+2)*1,0])
		cube([mini_post_length,3,3]);
	}
	else if (part=="leaf spring collection - same activation distance"){
		leaf_spring_collection_ad();
	}
	else if (part=="leaf spring collection - same activation force index"){
		leaf_spring_collection_afi();
	}
	else if (part=="10 mini-posts"){
		mini_post_string();
		
		translate([0,5,0])
		mini_post_string();
	}
	
	if (section=="yes"){
		translate([-100,-200,-100])
		cube([200,200,200]);
	}
}


//
//************************* modules ****************
//
// microswitch
module microswitch(){
	translate([0,0,microswitch_thickness/2])
	cube([microswitch_width,microswitch_width,microswitch_thickness],center=true);
	
	translate([0,0,microswitch_thickness-fudge])
	cylinder(h=button_thickness,d=button_dia);
}


// activation surface
module activation_surface(){
	a_t = (activation_surface_type=="flat") ? activation_surface_thickness : max(activation_surface_thickness,bolt_len*2+4);
	if(activation_surface_type=="flat"){
		//flat surface
		surface_corner_radius = min(activation_surface_corner_radius,activation_surface_width/2-1-fudge);
		// translate([0,0,1])
		difference(){
			union(){
			translate([0,0,1])
				hull(){
					hull(){
						surface_start(activation_surface_width,surface_corner_radius,a_t-2);
						
						translate([0,0,a_t-1])
						surface_start(activation_surface_width-2,surface_corner_radius,fudge);
					}
					translate([0,0,-1])
					surface_start(activation_surface_width-2,surface_corner_radius,fudge);
				}

				translate([0,0,2])
				cylinder(h=bolt_len+1-fudge,d=spacer_thickness+4);
			}

			if(part!="assembled switch"){
				translate([0,0,max(2,a_t-bolt_len-1)])
				threads(bolt_dia,undef,bolt_len+1,threaded_hole_scale,60);
			}
		}
	}
	else{
		//curved surface
		difference(){
			// resize([activation_surface_width,activation_surface_width,bolt_len*2+4])
			resize([activation_surface_width,activation_surface_width,a_t])
			sphere(d=activation_surface_width,$fn=activation_surface_facets);
			
			translate([0,0,-(bolt_len+2)])
			cube([activation_surface_width*2,activation_surface_width*2,(bolt_len+2)*2],center=true);
			
			if(part!="assembled switch"){
				translate([0,0,-fudge])
				threads(bolt_dia,undef,bolt_len+1,threaded_hole_scale,60);
			}
		}
	}
}


module surface_start(width,diff,thickness){
	linear_extrude(height=thickness)
	offset(r=diff,chamfer=true)
	circle(d=width-diff*2,$fn=activation_surface_facets);
}


//spacer plug
module spacer_plug(p__t){
	difference(){
		union(){
			if(part!="assembled switch"){
				translate([0,0,p__t-fudge])
				threads(bolt_dia,undef,5,bolt_scale,60);
			}
			
			cylinder(d=plug_width,h=p__t,$fn=12);
		}

		translate([0,0,p__t+5+fudge])
		rotate_extrude($fn=200)
		polygon([[bolt_dia/2-bolt_dia/4,0],[bolt_dia/2,0],[bolt_dia/2,-bolt_dia/5]]);
		
		translate([0,0,-1])
		cube([3.2,3.2,6],center=true);
		
		translate([0,0,p__t-.4+fudge])
		linear_extrude(height=.4)
		text(str(floor(p__t),"     ",(p__t-floor(p__t))*10),halign="center",valign="center",size=4);
	}
	
	if(part!="assembled switch" && part!="spacer plug collection - part 1" && part!="spacer plug collection - part 2" && include_leaf_spring=="no"){
		translate([10,0,0])
		cube([mini_post_length,3,3]);
	}
}


//switch cover
module switch_cover(){
	difference(){
		union(){
			cover_shell();
				
			translate([0,0,switch_wall_thickness-fudge])
			cylinder(d=sleeve_dia,h=sleeve_length,center=false);
			
			translate([0,0,switch_wall_thickness+brace_thickness/2])
			cube([switch_width-10,brace_thickness,brace_thickness],center=true);
			
			rotate([0,0,90])
			translate([0,0,switch_wall_thickness+brace_thickness/2])
			cube([switch_width-10,brace_thickness,brace_thickness],center=true);
		}
		
		translate([0,0,-1])
		cylinder(d=cover_hole_size,h=switch_height,center=false,$fn=6);
	}
	
	
	// leaf spring retainers
	translate([switch_width/2-switch_wall_thickness-6,0,switch_wall_thickness])
	cylinder(d=8,h=leaf_retention_post_length);

	translate([-switch_width/2+switch_wall_thickness+6,0,switch_wall_thickness])
	cylinder(d=8,h=leaf_retention_post_length);
	
	rotate([0,0,90]){
		// leaf spring retainers
		translate([switch_width/2-switch_wall_thickness-6,0,switch_wall_thickness])
		cylinder(d=8,h=leaf_retention_post_length);

		translate([-switch_width/2+switch_wall_thickness+6,0,switch_wall_thickness])
		cylinder(d=8,h=leaf_retention_post_length);
	}
}


module cover_shell(){
	s_w = switch_width+1;
	translate([0,0,1])
	difference(){
		union(){
			linear_extrude(height=switch_cover_height-2)
			offset(r=switch_fillet+switch_wall_thickness)
			square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
			
			hull(){
				linear_extrude(height=fudge)
				offset(r=switch_fillet+switch_wall_thickness)
				square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
				
				translate([0,0,-1])
				linear_extrude(height=fudge)
				offset(r=switch_fillet+switch_wall_thickness-1)
				square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
			}

			translate([0,0,switch_cover_height-2])
			rotate([180,0,0])
			hull(){
				linear_extrude(height=fudge)
				offset(r=switch_fillet+switch_wall_thickness)
				square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
				
				translate([0,0,-1])
				linear_extrude(height=fudge)
				offset(r=switch_fillet+switch_wall_thickness-1)
				square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
			}
		}
		translate([0,0,switch_wall_thickness-1])
		linear_extrude(height=switch_cover_height)
		offset(r=switch_fillet)
		square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
			
		//clip cuts
		for(i = [0 : 90 : 270]){
			rotate([0,0,i])
			{
				translate([s_w/2, 2.5+1, switch_cover_height+switch_wall_thickness-.5-5+fudge])
				cube([10,2,5],center=true);
				translate([s_w/2, -2.5-1, switch_cover_height+switch_wall_thickness-.5-5+fudge])
				cube([10,2,5],center=true);
			}
		}
	}
	
	//clip wedges
	for(i = [0 : 90 : 270]){
		rotate([0,0,i])
		{
			translate([s_w/2, 0, switch_cover_height-1.5])
			rotate([0,45,0])
			cube([2,4,2],center=true);
		}
	}
}


module switch_mount(){
	s_w = switch_width + 1;
	
	difference(){
		union(){
			translate([0,0,1])
			difference(){
				union(){
					linear_extrude(height=switch_mount_height-2)
					offset(r=switch_fillet+switch_wall_thickness)
					square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
					
					hull(){
						linear_extrude(height=fudge)
						offset(r=switch_fillet+switch_wall_thickness)
						square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
						
						translate([0,0,-1])
						linear_extrude(height=fudge)
						offset(r=switch_fillet+switch_wall_thickness-1)
						square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
					}
					
					translate([0,0,switch_mount_height-2])
					rotate([180,0,0])
					hull(){
						linear_extrude(height=fudge)
						offset(r=switch_fillet+switch_wall_thickness)
						square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
						
						translate([0,0,-1])
						linear_extrude(height=fudge)
						offset(r=switch_fillet+switch_wall_thickness-1)
						square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
					}
				}
				translate([0,0,switch_wall_thickness])
				linear_extrude(height=switch_mount_height)
				offset(r=switch_fillet)
				square([s_w-switch_fillet*2,s_w-switch_fillet*2],center=true);
			}
			
			// tee nut pedestal w/o hole or slots
			cylinder(h=switch_wall_thickness+tee_nut_pedestal_height,r=11.6);
			
			translate([0,0,(switch_wall_thickness+tee_nut_pedestal_height)/2+1.5])
			cube([s_w+switch_wall_thickness*2-1,tee_nut_pedestal_height+3,switch_wall_thickness+tee_nut_pedestal_height+1],center=true);
			
			rotate([0,0,90])
			translate([0,0,(switch_wall_thickness+tee_nut_pedestal_height)/2+1.5])
			cube([s_w+switch_wall_thickness*2-1,tee_nut_pedestal_height+3,switch_wall_thickness+tee_nut_pedestal_height+1],center=true);
		}
		
		//cuts in tee nut pedestal
		translate([0,0,switch_wall_thickness+tee_nut_pedestal_height-fudge])
		cylinder(h=3,r=11.6);
		
		translate([0,0,-.5])
		cylinder(h=switch_wall_thickness+tee_nut_pedestal_height+1,r=4);
		
		translate([0,0,switch_wall_thickness+tee_nut_pedestal_height-1+fudge])
		cylinder(h=1,r1=4.175,r2=4.975);
		
		//slots for headphone jack access
		translate([0,0,switch_wall_thickness+tee_nut_pedestal_height-4/2+fudge])
		for(i = [0 : 90 : 270]){
			rotate([0,0,i])
			translate([7.5,0,0])
			cube([5,1.4,5],center=true);
		}
		
		for(i = [0 : 90 : 270]){
			rotate([0,0,i])
			translate([headphone_jack_start-headphone_jack_len-7,microswitch_width/2+1.5+7.75,switch_wall_thickness*2+5.2+tee_nut_pedestal_height+2])
			union(){
				rotate([0,90,0])
				cylinder(h=switch_wall_thickness+10,d=10,center=true);
			}
		}
		
		//holes to help remove mount from switch
		for(i = [45 : 90 : 315]){
			rotate([0,0,i])
			translate([18,0,0])
			cylinder(h=10,d=10,center=true);
		}

		//clip cuts
		for(i = [0 : 90 : 270]){
			rotate([0,0,i])
			{
				translate([s_w/2, 2.5+1, switch_mount_height+tee_nut_pedestal_height-2.5-5+fudge])
				cube([10,2,5],center=true);
				translate([s_w/2, -2.5-1, switch_mount_height+tee_nut_pedestal_height-2.5-5+fudge])
				cube([10,2,5],center=true);
			}
		}
	}
	
	//clip wedges
	for(i = [0 : 90 : 270]){
		rotate([0,0,i])
		{
			translate([s_w/2, 0, switch_mount_height-1.5])
			rotate([0,45,0])
			cube([2,4,2],center=true);
		}
	}
}


//switch base
module switch_base(){
	difference(){
		union(){
			base_shell();
			
			translate([0,0,switch_wall_thickness+4-fudge])
			difference(){
				cube([microswitch_height+3,microswitch_width+3,8],center=true);
				cube([microswitch_height,microswitch_width,12],center=true);
				
				cube([microswitch_height+4,slot_width,12],center=true);
				cube([slot_width,microswitch_width+4,12],center=true);
			}
			
			// wire retainers
			rotate([0,0,r1])
			wire_retainer();
			
			rotate([0,0,r2])
			wire_retainer();
			
			rotate([0,0,r3])
			wire_retainer();
			
			// leaf spring pedestals
			leaf_spring_pedestal();
			
			rotate([0,0,90])
			leaf_spring_pedestal();
			
			rotate([0,0,180])
			leaf_spring_pedestal();
			
			rotate([0,0,270])
			leaf_spring_pedestal();
			
			//retainers for headphone jack
			translate([headphone_jack_start-headphone_jack_len-7,microswitch_width/2+1.5+7.75,switch_wall_thickness+6.5])
			cube([14,14,13],center=true);
		}

		translate([0,0,(switch_height+5)/2-5])
		difference(){
			cube([switch_width+25,switch_width+25,switch_height+5],center=true);
			
			translate([0,0,-(switch_base_height+10)/2])
			linear_extrude(height=switch_base_height+10)
			offset(r=switch_fillet)
			square([switch_width-switch_fillet*2,switch_width-switch_fillet*2],center=true);
		}
				
		//headphone jack mount
		translate([headphone_jack_start-headphone_jack_len-5,microswitch_width/2+1.5+7.75,switch_wall_thickness+5.2])
		rotate([0,90,0])
		cylinder(h=switch_wall_thickness+10,d=6,center=true);

		translate([headphone_jack_start-headphone_jack_len-7,microswitch_width/2+1.5+7.75,switch_wall_thickness+5.2])
		rotate([0,90,0])
		cylinder(h=switch_wall_thickness+10,d=10,center=true);
		
		//recesses for stick-on feet
		loc = switch_width/2 - 9 - switch_corner_radius/4;
		translate([loc,loc,-fudge])
		cylinder(h=2.5,d=13.5);
		translate([-loc,loc,-fudge])
		cylinder(h=2.5,d=13.5);
		translate([loc,-loc,-fudge])
		cylinder(h=2.5,d=13.5);
		translate([-loc,-loc,-fudge])
		cylinder(h=2.5,d=13.5);
	}
}


module base_shell(){
	translate([0,0,1])
	difference(){
		union(){
			linear_extrude(height=switch_base_height-1)
			offset(r=switch_fillet)
			square([switch_width-switch_fillet*2,switch_width-switch_fillet*2],center=true);
			
			hull(){
				linear_extrude(height=fudge)
				offset(r=switch_fillet)
				square([switch_width-switch_fillet*2,switch_width-switch_fillet*2],center=true);

				translate([0,0,-1])
				linear_extrude(height=fudge)
				offset(r=switch_fillet-1)
				square([switch_width-switch_fillet*2,switch_width-switch_fillet*2],center=true);
			}
		}
		

		translate([0,0,switch_wall_thickness])
		linear_extrude(height=switch_base_height)
		offset(r=switch_fillet-switch_wall_thickness)
		square([switch_width-switch_fillet*2,switch_width-switch_fillet*2],center=true);

		//cover clip wedge indents
		for(i = [0 : 90 : 270]){
			rotate([0,0,i])
			{
				translate([switch_width/2, 0, switch_base_height+switch_top_thickness-switch_cover_height+.5])
				rotate([0,45,0])
				cube([2,4,2],center=true);
			}
		}

		//switch mount clip wedge indents
		for(i = [0 : 90 : 270]){
			rotate([0,0,i])
			{
				translate([switch_width/2, 0, switch_mount_height-tee_nut_pedestal_height-2-switch_wall_thickness*2])
				rotate([0,45,0])
				cube([2,4,2],center=true);
			}
		}
	}
}


module leaf_spring(afi,ad){
	post_len = pedestal_height - m_t - switch_bottom_thickness - ad;
	af = act_force_vector[afi];
	thick = af[0];
	arms = af[1];
	
	if(arms>0){
		difference(){
			union(){
				linear_extrude(height=thick)
				offset(delta=2,chamfer=true)
				square([switch_width-switch_wall_thickness-9,7],center=true);
				if (arms==4){
					rotate([0,0,90])
					linear_extrude(height=thick)
					offset(delta=2,chamfer=true)
					square([switch_width-switch_wall_thickness-9,7],center=true);
				}
				
				translate([0,0,(post_len-1)/2+thick])
				hull(){
					translate([0,0,(post_len)/2])
					cylinder(d=4,h=1,center=true);
					cylinder(d=5,h=post_len-1,center=true);
				}
			}
		
			translate([0,0,.4-fudge])
			rotate([0,180,0])
			linear_extrude(height=.4)
			text(str(afi,"-",ad),halign="center",valign="center",size=7);
		}
	}
}
	

module leaf_spring_pedestal(){
	difference(){
		translate([switch_width/2-switch_wall_thickness,0,7+switch_wall_thickness])
		rotate([90,0,0])
		translate([0,0,-7.5])
		linear_extrude(height=15)
		polygon([[0,0],[0,13],[-5,13],[-5,11]]);
		
		translate([switch_width/2-6-3,0,pedestal_height+2.5+fudge])
		cube([12,12,5],center=true);
	}
}

module wire_retainer(){

	difference(){
		union(){
			translate([switch_width/2-switch_wall_thickness-retainer_wall_offset-1,0,retainer_height/2+switch_wall_thickness])
			cube([retainer_thickness,retainer_width,retainer_height],center=true);

			translate([switch_width/2-switch_wall_thickness-retainer_wall_offset-1,0,switch_wall_thickness+retainer_height])
			rotate([90,0,0])
			cylinder(d=retainer_thickness,h=retainer_width,center=true);
		}
		
		if(microswitch_type!="black insulation"){
			translate([switch_width/2-switch_wall_thickness-retainer_wall_offset-1,retainer_width/6+retainer_slot_width/6,0])
			cube([retainer_thickness+2,retainer_slot_width,retainer_height*3],center=true);
			
			translate([switch_width/2-switch_wall_thickness-retainer_wall_offset-1,-(retainer_width/6+retainer_slot_width/6),0])
			cube([retainer_thickness+2,retainer_slot_width,retainer_height*3],center=true);
		}
	}
}

module hole_size_test(){
	$fn=100;
	barrel_dia = spacer_thickness+4;
	barrel_height = 15;
	difference(){
		union(){
			translate([0,0,-barrel_height/2-1])
			cube([100,20,2],center=true);
			
			translate([-40,0,0])
			cylinder(d=barrel_dia,h=barrel_height,center=true);
			
			translate([-20,0,0])
			cylinder(d=barrel_dia,h=barrel_height,center=true);
			
			translate([0,0,0])
			cylinder(d=barrel_dia,h=barrel_height,center=true);
			
			translate([20,0,0])
			cylinder(d=barrel_dia,h=barrel_height,center=true);
			
			translate([40,0,0])
			cylinder(d=barrel_dia,h=barrel_height,center=true);
			
			translate([48,0,-barrel_height/2])
			sphere(r=1);
		}
			
		translate([-40,0,-1])
		cylinder(d=hex_hole_dia5,h=20,center=true,$fn=6);
			
		translate([-20,0,-1])
		cylinder(d=hex_hole_dia4,h=20,center=true,$fn=6);
			
		translate([0,0,-1])
		cylinder(d=hex_hole_dia3,h=20,center=true,$fn=6);
			
		translate([20,0,-1])
		cylinder(d=hex_hole_dia2,h=20,center=true,$fn=6);
			
		translate([40,0,-1])
		cylinder(d=hex_hole_dia1,h=20,center=true,$fn=6);
	}
}


module spacer(){
	cylinder(h=spacer_length,d=spacer_thickness,$fn=6);
	translate([0,0,spacer_length-fudge])
	cylinder(h=spacer_thickness,d=bolt_dia);
}


module mini_post(){
	if(include_leaf_spring=="no"){
		translate([0,0,3.5])
		cube([3,3,7],center=true);
	}
}


module headphone_plug(){
	rotate([0,0,90])
	linear_extrude(height=12.5)
	polygon([[15.5,0],[15.5,10],[13,14],[13,22],[12,22],[12,26.5],[4,26.5],[4,22],[3,22],[3,14],[0,10],[0,0]]);
	
	translate([-26.5-2.25,15.5/2,5])
	rotate([0,90,0])
	cylinder(h=4.5,d=6,center=true);
}

module mini_post_string(){

		translate([(mini_post_length+1)*0,0,0])
		cube([mini_post_length,3,3]);

		translate([(mini_post_length+1)*1,0,0])
		cube([mini_post_length,3,3]);

		translate([(mini_post_length+1)*2,0,0])
		cube([mini_post_length,3,3]);

		translate([(mini_post_length+1)*3,0,0])
		cube([mini_post_length,3,3]);

		translate([(mini_post_length+1)*4,0,0])
		cube([mini_post_length,3,3]);
		
		
}

module leaf_spring_collection_ad(){
	translate([0,-20,0])
	leaf_spring(1,a_d);

	translate([0,-160,0])
	leaf_spring(3,a_d);

	translate([0,-35,0])
	leaf_spring(4,a_d);

	translate([0,-175,0])
	leaf_spring(6,a_d);

	translate([0,-50,0])
	leaf_spring(8,a_d);



	translate([0,-105,0])
	leaf_spring(2,a_d);

	translate([70,-70,0])
	leaf_spring(5,a_d);

	translate([125,-85,0])
	leaf_spring(7,a_d);

	translate([55,-125,0])
	leaf_spring(9,a_d);

	translate([110,-140,0])
	leaf_spring(10,a_d);
}

module leaf_spring_collection_afi(){
	translate([0,-105,0])
	leaf_spring(a_f_i,0);

	translate([70,-70,0])
	leaf_spring(a_f_i,1);

	translate([125,-85,0])
	leaf_spring(a_f_i,2);

	translate([55,-125,0])
	leaf_spring(a_f_i,3);

	translate([110,-140,0])
	leaf_spring(a_f_i,4);

	translate([15,-50,0])
	leaf_spring(a_f_i,5);
}


//****** the following code has generously been created by Ron Butcher, Trevor Moseley, and Rudolf Huttary ***********

//sine_thread.scad by Ron Butcher (aka. Ming of Mongo), 
//with bits borrowed from ISOThread by Trevor Moseley
//
//Thread libs for OpenSCAD are hideously slow.  I love OpenSCAD, but that's the fact.
//But I found that, if you are cool with approximating iso threads with a sine wave,
//you can make very smooth threads really fast just by spinning a circle around.
//
//Actually, you could make near perfect threads by specifying a polygon other than a circle
//with the exact screw cross-section you need, but I leave that as an excersize for those
//who care more than I do.  Circle works for me.
//
//threads module gives a threaded rod
//hex_nut(diameter) does just what you think
//hex_screw(diameter, length) gives an M(diameter) hex head screw with length mm of thread.
//
//defaults get you an M4 x 10mm bolt and an M4 nut.  If you want something non standard,
//you can supply the pitch, head height and diameter, rez(olution) and a scaling factor
//to help make up for the oddities of everyone's individual printers and settings.
//
//Finer layering gets you better results.  At .1mm layer height, my M4 threads kick ass.
//
//This is all metric, but you can translate US diameters and pitch to mm easily enough.


module threads(diameter=4,pitch=undef,length=10,scale=1,rez=20){
	pitch = (pitch!=undef) ? pitch : get_coarse_pitch(diameter);
	twist = length/pitch*360;
	depth=pitch*.6;
	linear_extrude(height = length, center = false, convexity = 10, twist = -twist, $fn = rez)
		translate([depth/2, 0, 0]){
			circle(r = scale*diameter/2-depth/2);
		}
}	

module hex_nut(	diameter = 4,
				height = undef, 
				span = undef,  
				pitch = undef, 
				scale = 1, 
				rez = 20){
	height = (height!=undef) ? height : hex_nut_hi(diameter);
	span = (span!=undef) ? span : hex_nut_dia(diameter);
	
	difference(){
		cylinder(h=height,r=span/2, $fn=6); //six sided cylinder
		threads(diameter,pitch,height,scale,rez);
		cylinder(h=diameter/2, r1=diameter/2, r2=0, $fn=rez);
		translate([0,0,height+.0001])
		rotate([180,0,0])
		cylinder(h=diameter/2, r1=diameter/2, r2=0, $fn=rez);
	}
}

module hex_screw(diameter = 4, 
				length = 10, 
				height = undef, 
				span = undef, 
				pitch = undef, 
				scale = 1, 
				rez = 20){
	height = (height!=undef) ? height : hex_bolt_hi(diameter);
	span = (span!=undef) ? span : hex_bolt_dia(diameter);
	cylinder(h=height,r=span/2,$fn=6); //six sided cylinder
	translate([0,0,height])
	threads(diameter,pitch,length,scale,rez);
}

// Lookups shamelessly stolen from ISOThread.scad by Trevor Moseley
// function for thread pitch
function get_coarse_pitch(dia) = lookup(dia, [
[1,0.25],[1.2,0.25],[1.4,0.3],[1.6,0.35],[1.8,0.35],[2,0.4],[2.5,0.45],[3,0.5],[3.5,0.6],[4,0.7],[5,0.8],[6,1],[7,1],[8,1.25],[10,1.5],[12,1.75],[14,2],[16,2],[18,2.5],[20,2.5],[22,2.5],[24,3],[27,3],[30,3.5],[33,3.5],[36,4],[39,4],[42,4.5],[45,4.5],[48,5],[52,5],[56,5.5],[60,5.5],[64,6],[78,5]]);

// function for hex nut diameter from thread size
function hex_nut_dia(dia) = lookup(dia, [
[3,6.4],[4,8.1],[5,9.2],[6,11.5],[8,16.0],[10,19.6],[12,22.1],[16,27.7],[20,34.6],[24,41.6],[30,53.1],[36,63.5]]);
// function for hex nut height from thread size
function hex_nut_hi(dia) = lookup(dia, [
[3,2.4],[4,3.2],[5,4],[6,3],[8,5],[10,5],[12,10],[16,13],[20,16],[24,19],[30,24],[36,29]]);


// function for hex bolt head diameter from thread size
function hex_bolt_dia(dia) = lookup(dia, [
[3,6.4],[4,8.1],[5,9.2],[6,11.5],[8,14.0],[10,16],[12,22.1],[16,27.7],[20,34.6],[24,41.6],[30,53.1],[36,63.5]]);
// function for hex bolt head height from thread size
function hex_bolt_hi(dia) = lookup(dia, [
[3,2.4],[4,3.2],[5,4],[6,3.5],[8,4.5],[10,5],[12,10],[16,13],[20,16],[24,19],[30,24],[36,29]]);


