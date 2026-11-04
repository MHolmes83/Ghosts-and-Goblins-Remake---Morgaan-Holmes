if (num_enemies < max_enemies) {
	instance_create_layer(random(room_width), y, "Enemies", ZombieArrival_obj);
	num_enemies += 1;
	alarm[0] = random(360);
	
}

if (x < Arthur_Player) {
	image_xscale = -1;
}