Game_obj.points += 200;

instance_destroy(other);

instance_create_depth(x, y, depth-1, EnemyBlood_obj);

instance_destroy();