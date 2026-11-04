frame_counter -= 1;
if (frame_counter == 0) {
	sprite_index = ZombieArrival;
	image_index = image_number;
	image_speed = -1;
	hspeed = 0;
}
