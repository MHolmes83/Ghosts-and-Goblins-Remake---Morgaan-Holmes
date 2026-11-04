hp = 2;
iframes = 0;
iframes_max = 60;
right = false;
left = false;
jump = false;
onGround = true;
h_input = 0;
facing = 1;
run_spd = 2;
jump_spd = -5;
move_x = 0;
grv = 0.3;
grv_max = 4;
move_y = 0;
firingdelay = 5;
tilemap = layer_tilemap_get_id("GroundTiles");


 armored_sprites = {
	idle : ArthurArmored,
	run : ArthurArmoredRunning,
	jump : ArthurArmoredJumping,
	crouch : ArthurArmoredCrouched,
	crouchAndThrow : ArthurArmoredCrouchedThrow,
	toss : ArthurArmoredThrow
	
 }
 
 nude_sprites = {
	idle : ArthurNude,
	run : ArthurNudeRunning,
	jump : ArthurNudeJumping,
	crouch : ArthurNudeCrouched,
	crouchAndThrow : ArthurNudeCrouchedThrow,
	toss : ArthurNudeThrow
 }
 
 dead_sprite = {
	dead : ArthurDead
 }
 
 current_sprites = armored_sprites;
 
 animation_end = function() {
	var frame_range = image_speed * sprite_get_speed(sprite_index) / game_get_speed(gamespeed_fps);
	return image_index >= image_number - frame_range && image_index < image_number;
 }
 
 check_onGround = function() {
	onGround = place_meeting(x, y+1, tilemap);
 }
 
 add_gravity = function() {
	if (!onGround) {
		move_y = min(move_y + grv, grv_max);
	}
 }
 
movePlayer = function() {
	var _col_struct  = {x:0, y:0};
	if (place_meeting(x + move_x, y, tilemap)) {
		while(!place_meeting(x + sign(move_x), y, tilemap)) {
			x += sign(move_x);
		}
		_col_struct.x = sign(move_x);
		move_x = 0;
	}
	x += move_x;
	
	if(place_meeting(x, y + move_y, tilemap)) {
		while(!place_meeting(x, y + sign(move_y), tilemap)) {
			y += sign(move_y);
		}
		_col_struct.y = sign(move_y);
		move_y = 0;
	}
	y += move_y;
	return _col_struct;
}

update_facing = function() {
	if (h_input != 0) facing = h_input;
}

 PlayerStateIdle = function() {
	if (sprite_index != current_sprites.idle) {
		sprite_index = current_sprites.idle;
	}
	move_x = 0;
	if(h_input !=0) {
		movePlayer();
		state = PlayerStateRun;
	}
	if (jump && onGround) {
		state = PlayerStateJump;
	}
	if (toss) {
		state = PlayerStateToss;
	}
	if (crouch && onGround) {
		state = PlayerStateCrouch;
	} 
}

PlayerStateRun = function() {
	if (sprite_index != current_sprites.run) {
		sprite_index = current_sprites.run;
		
	}
	movePlayer();
	update_facing();
	move_x = h_input * run_spd;
	if (h_input == 0){
		state = PlayerStateIdle;
	}
	if (jump && onGround) {
		state = PlayerStateJump;
	}
}

PlayerStateJump = function() {
	if (sprite_index != current_sprites.jump) {
		sprite_index = current_sprites.jump;
		move_y = jump_spd
		onGround = false;
	} else {
		add_gravity();
	}
	movePlayer();
	check_onGround();
	if (onGround) {
		if (h_input == 0) {
			state = PlayerStateIdle;
		} else {
			state = PlayerStateRun;
		}
	}
}

PlayerStateToss = function() {
	if(sprite_index != current_sprites.toss) {
		sprite_index = current_sprites.toss;
		image_index = 0;
		}
		if (animation_end()) {
		instance_create_layer(x, y, "Instances", Projectile);
		if (h_input == 0) {
			state = PlayerStateIdle;
		} else {
			state = PlayerStateRun;
		}
	}
}

PlayerStateCrouch = function () {
	if (sprite_index != current_sprites.crouch) {
		sprite_index = current_sprites.crouch;
		
	}
	if (h_input == 0 && crouch) {
		state = PlayerStateCrouch;
	} else {
		state = PlayerStateIdle;
	}
	if (toss) {
		state = PlayerStateCrouchAndThrow;
	}
}

PlayerStateCrouchAndThrow = function() {
	if (sprite_index != current_sprites.crouchAndThrow) {
		sprite_index = current_sprites.crouchAndThrow;
		image_index = 0
	}
	if (h_input == 0 && crouch && toss) {
		state = PlayerStateCrouchAndThrow;
	if (animation_end()) {
		instance_create_layer(x, y, "Instances", Projectile);
			if (h_input == 0) {
			state = PlayerStateIdle;
			} else {
				state = PlayerStateRun;
			}
		}
	}
	show_debug_message(crouch);
	//show_debug_message("Why the fuck aren't you working?");
}

playerStateDead = function() {
	if (sprite_index != current_sprites.dead) {
		sprite_index = current_sprites.dead;
		image_index = 0;
	}
	if (animation_end()) {
		if(hp <= 0) {
			state = PlayerStateDead;
		}
	}
}

get_hit = function() {
	if(iframes > 0) exit;
	iframes = iframes_max;
	hp --;
	if (hp == 1) {
		current_sprites = nude_sprites;
	}
	if (hp <= 0) {
		state = PlayerStateDead;
		instance_destroy();
	}
}

state = PlayerStateIdle;