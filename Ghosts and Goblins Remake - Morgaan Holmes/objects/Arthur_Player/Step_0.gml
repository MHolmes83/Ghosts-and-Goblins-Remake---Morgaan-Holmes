right = keyboard_check(ord("D"));
left = keyboard_check(ord("A"));
crouch = keyboard_check(ord("S"));
jump = keyboard_check_pressed(ord("L"));
toss = keyboard_check_pressed(ord("K"));

h_input = right - left;



state();

if (iframes > 0) iframes --;

