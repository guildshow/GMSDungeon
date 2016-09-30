///build menu
if(isbuild){
    isboundbox = false;
    iscollide = false;
    var xx = display_get_gui_width()/2;
    var yy = display_get_gui_height()/2;
    var screenx = device_mouse_x_to_gui(0);
    var screeny = device_mouse_y_to_gui(0); 
    draw_text(xx,16,"BUILD MODE");
    var id_name = "none";
        
    if(pickid != -1){    
        with(pickid){//object id
            id_name = name;
        }
        if(keyboard_check(vk_delete)){
            with(pickid){
                instance_destroy();
            }
            pickid = -1;
            show_debug_message("delete object");
        }
    }    
    draw_text(xx,32,"Select: "+id_name);
    draw_set_halign(fa_left);
    //draw text h menu
    for (var i = 0; i < array_length_1d(buildmenu); i++)
    {
        draw_text(xx+(i*64)-92-32, 64, string( buildmenu[i] ));
        if( (xx+(64*i)+(-16)-112 < screenx ) and screenx < (xx+(64*i)+(+28)-112) and ((32)*2) < screeny and screeny < ((32)*3) ){
            isboundbox = true;
            if(mouse_check_button(mb_left)){
                show_debug_message(string(buildmenu[i]));
                if(buildmenu[i] == "Blocks"){
                    slotlist = tileblock;
                }
                if(buildmenu[i] == "Traps"){
                    slotlist = traps;
                }
            }
        }
        
    }

    //check if icon are bound here min and max
    //if(screeny > (4 + yy -64) and screeny < (5*(32+4) + yy -64)){//size and offsets and items
    //if(screenx > 4 and screenx < (32+4) and screeny > 4 and screeny < (5*(32+4))){//size and offsets
    if(screenx > 4 and screenx < (32+4) and screeny > (4 + yy -64) and screeny < (5*(32+4) + yy -64)){
        //show_debug_message("in bound?");
        isboundbox = true;
        //need to add icon select here to build the dungeon
    }else{
        //show_debug_message("out bound?");   
    }
    
    //if(keyboard_check(ord('S'))){list_index++;}
    //if(keyboard_check(ord('D'))){list_index--;}   
    if(screenx > 4 and screenx < (32+4) and screeny > (yy - ((32+4)*3)) and screeny < (yy - (32*2))){    
        //show_debug_message("in bound?");
        if(mouse_check_button(mb_left) == true and alarm[0] <= 0){
            list_index--;
            alarm[0] = room_speed/6;
        }
        isboundbox = true;
    }else{
        //show_debug_message("out bound?");
    }
    
    if(screenx > 4 and screenx < (32+4) and screeny > (yy + ((32+4)*(3))) and screeny < (yy + (32*(5)))){    
        //show_debug_message("in bound?");
        if(mouse_check_button(mb_left) == true and alarm[0] <= 0){
            list_index++;
            alarm[0] = room_speed/6;
        }
        isboundbox = true;
    }else{
        //show_debug_message("out bound?");
    }
    
    if(screenx > 4 and screenx < (32+4) and screeny > (display_get_gui_height()-32) and screeny < (display_get_gui_height())){    
        //show_debug_message("in bound?");
        if(mouse_check_button(mb_left) == true and alarm[0] <= 0){
            if(issnap){
                issnap = false;
                draw_sprite(spr_grid_off,0,4,display_get_gui_height()-32);
            }else{
                issnap = true;
                draw_sprite(spr_grid_on,0,4,display_get_gui_height()-32);
            }
            alarm[0] = room_speed/6;
            //show_debug_message("snap?");
        }
        isboundbox = true;
    }else{
        //show_debug_message("out bound?");
    }
    if(issnap){
        draw_sprite(spr_grid_on,0,4,display_get_gui_height()-32);
    }else{
        draw_sprite(spr_grid_off,0,4,display_get_gui_height()-32);
    }
    //draw up and down button
    draw_sprite(spr_up,0,4,yy+((32+4)*-1)-64); 
    draw_sprite(spr_down,0,4,yy+((32+4)*5)-64);     
    
    // draw icons
    list_count = 0;
    if(list_index <= 0){
        list_index = 0;
    }
    //check if array list max list to not move
    if(array_height_2d(slotlist) <= list_max){
        list_index = 0;
    }else{
        if(list_index > array_height_2d(slotlist) - list_max){
            list_index = array_height_2d(slotlist) - list_max;
        }
    }
    //draw iamge and check if mouse is press left
    for (i = list_index; i < array_height_2d(slotlist); i++){    
        if(list_count >= list_max){
            break;
        }
        if(screenx > 4 and screenx < (32+4) and screeny > (yy - 64 + (32+4)*list_count) and screeny < (yy - 32 + (32+4)*list_count)){    
            if(mouse_check_button(mb_left) == true and alarm[0] <= 0){
                //show_debug_message(string(slotlist[i,0]));
                //check if select exist destory
                if(selectobject == noone){
                }else{
                    with(selectobject){
                        //show_debug_message("gone?");
                        instance_destroy();
                    } 
                }
                //create object
                selectobject = instance_create((mouse_x div sizegrid)*32,(mouse_y div sizegrid)*32,slotlist[ i, 2]);
                selectobject.visible = true;
                placeobject = slotlist[ i, 3];
                alarm[0] = room_speed/6;
            }
        }
        draw_text(48,yy+((32+4)*list_count)-64,slotlist[ i, 0]);
        if(slotlist[ i, 1] != noone){
            draw_sprite(slotlist[ i, 1],0,4,yy+((32+4)*list_count)-64);
        }else{
            draw_sprite(spr_slot,0,4,yy+((32+4)*list_count)-64);
        }
        list_count++;
    }
    //var xx_p = yy - 64 + 32*0;//top
    //var xx_p = yy - 32 + 32*0;//bottom
    //draw_sprite(spr_up,0,64,xx_p);  
    //if(screenx > 4 and screenx < (32+4) and screeny > (yy - 64 + (32+4)*4) and screeny < (yy - 32 + (32+4)*4)){    
        //show_debug_message("in bound?");
    //}else{
        //show_debug_message("out bound?");
    //}
    
    //place preview
    if(instance_exists(selectobject)){
        //selectobject.visible = true;
        //divide and floor and time
        
        if(selectobject.issnap){
            selectobject.phy_position_x = (mouse_x div sizegrid)*32;
            selectobject.phy_position_y = (mouse_y div sizegrid)*32;
        }else{
            selectobject.phy_position_x = mouse_x;
            selectobject.phy_position_y = mouse_y;
        }
    }else{
        //show_debug_message("error object");
    }

    //if(place_empty(mouse_x, mouse_y)){
        //show_debug_message("Hit something");
    //}else{
        //show_debug_message("miss");
    //}
    
    //if(place_meeting(mouse_x, mouse_y, obj_wall)){
        //show_debug_message("Hit something");
    //}else{
        //show_debug_message("notthing");
    //}
    
    //show_debug_message(string(mouse_x)+":"+string(mouse_x));
    //place object
    if(mouse_check_button_pressed(mb_left) == true and isboundbox = false ){
        if(placeobject !=noone){
            if(instance_exists(obj_level_generate_dungeon)){
                //check if object exist on the grid
                if(obj_level_generate_dungeon.grid_objects[# mouse_x div sizegrid,mouse_y div sizegrid] != noone){
                    var _obj = obj_level_generate_dungeon.grid_objects[# mouse_x div sizegrid,mouse_y div sizegrid];
                    with(_obj){
                        instance_destroy();
                    }
                    //assign grid object
                    //obj_level_generate_dungeon.grid_objects[# mouse_x div sizegrid, mouse_y div sizegrid] = instance_create((mouse_x div sizegrid)*32, (mouse_y div sizegrid)*32, placeobject);            
                    
                    if(selectobject.issnap){
                        instance_create((mouse_x div sizegrid)*32, (mouse_y div sizegrid)*32, placeobject);
                    }else{
                        instance_create(mouse_x, mouse_y, placeobject);
                    }
                }
            }
        }
    }
}else{
    if(instance_exists(selectobject)){
        selectobject.visible = false;
    }
}
