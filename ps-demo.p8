pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--pico-ps particle system
--max kearney
--created: april 2019
--updated: july 2020
---------------------

-------------------------------------------------- globals
show_demo_info = true
my_emitters = nil
emitter_type = 1
emitters = {"basic", "angle spread", "life/speed/size spread", "size over life", "velocity over life", "gravity", "everything", "water spout", "light particles", "burst emission", "explosion", "sprites!", "varying sprites", "fire", "space warp", "rain"}

#include ps.lua

-------------------------------------------------- demo code
-- these are functions to help the demo run. you can copy/model from here,
-- but most of this stuff isn't strictly necessary for an emitter to run
function draw_demo()
 rectfill(0, 0, 128, 6, 5)
 print(emitters[emitter_type], 1, 1, 7)
 if (show_demo_info) then
  rectfill(0, 91, 128, 128, 5)
  if (emitters[emitter_type] ~= "angle spread") then
   print("use arrow keys to move emitters", 1, 92, 7)
  else print("arrow keys changes angle/spread", 1, 92, 7) end
  print("press z to start/stop emitters", 1, 98, 7)
  print("press x to spawn emitter", 1, 104, 7)
  print("press s/f to cycle examples", 1, 110, 7)
  print("press q to show/hide info", 1, 116, 7)
  print("particles: "..get_all_particles(), 1, 122, 7)
 end
 for e in all(my_emitters) do
  e.draw(e)
 end
end

function get_all_particles()
 local p_count = 0
 for i in all(my_emitters) do
  p_count = p_count + #i.particles
 end
 return p_count
end

function update_demo()
 for e in all(my_emitters) do
  e.update(e, delta_time)
 end
 get_input()
end

function get_input()
 if (btnp(5,1)) then
  if (show_demo_info) then show_demo_info = false
  else show_demo_info = true end
 end

 if (btnp(4, 0)) then
  if (my_emitters[1].is_emitting(my_emitters[1])) then
   for e in all(my_emitters) do
    e.stop_emit(e)
   end
  else
   for e in all(my_emitters) do
    e.start_emit(e)
   end
  end
 end
 if (btnp(5, 0)) then
  spawn_emitter(emitters[emitter_type])
 end

 local x = 0
 local y = 0
 if (btn(0,0)) then
  x =  -1
 elseif (btn(1,0)) then
  x = 1
 end
 if (btn(2,0)) then
  y = -1
 elseif (btn(3,0)) then
  y = 1
 end
 for e in all(my_emitters) do
  if (emitters[emitter_type] ~= "angle spread") then
   e.pos.x = e.pos.x + x
   e.pos.y = e.pos.y + y
  else
   e.p_angle = e.p_angle + -x
   if (e.p_angle_spread > 0) then
    e.p_angle_spread = e.p_angle_spread + y
   else e.p_angle_spread = 1 end
  end
 end

 if (btnp(0,1)) then
  emitter_type = emitter_type - 1
  if (emitter_type < 1) then
   emitter_type = #emitters
  end
  my_emitters = {}
  spawn_emitter(emitters[emitter_type])
 elseif (btnp(1,1)) then
  emitter_type = emitter_type + 1
  if (emitter_type > #emitters) then
   emitter_type = 1
  end
  my_emitters = {}
  spawn_emitter(emitters[emitter_type])
 end
end

function spawn_emitter(emitter_string)
 if (emitter_string == "basic") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0,    50,  false, false, false,   7,   nil,     1,    2,      0,     360,      10,      10,      10,       1,      1,      0))
 elseif (emitter_string == "angle spread") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0,    0,   false, false, false,   8,   nil,     2,    2,      90,    10,       10,      10,      10,       2,      1,      0))
 elseif (emitter_string == "life/speed/size spread") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0,    0,   false, false, false,   3,   nil,     0,    5,      0,     360,      1,       1,       40,       1,      1,      4))
 elseif (emitter_string == "size over life") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0.5,  0,   false, false, false,   10,  nil,     1,    1,      0,     360,      20,      20,      0,        0,      5,      0))
 elseif (emitter_string == "velocity over life") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0,    0,   false, false, false,   11,  nil,     2,    0,      0,     360,      0,       50,      0,        1,      1,      0))
 elseif (emitter_string == "gravity") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0,    0,   false, true,  false,   9,   nil,     2,    3,      0,     180,      20,      20,      10,       2,      2,      0))
 elseif (emitter_string == "everything") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0,    0,   false, false, true,    12,  nil,     1,    4,      0,     360,      20,      0,       20,       3,      0,      3))
 elseif (emitter_string == "water spout") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0,    50,  false,  true, false,   12,  nil,     1,    4,      150,   20,       30,      0,       20,       4,      1,      0))
  add(my_emitters, emitter.create(64, 64, 0,    50,  false,  true, false,   12,  nil,     1,    4,      20,    20,       30,      0,       20,       4,      1,      0))
  add(my_emitters, emitter.create(64, 64, 0,    50,  false,  true, false,   12,  nil,     1,    4,      60,    20,       30,      0,       20,       4,      1,      0))
  add(my_emitters, emitter.create(64, 64, 0,    50,  false,  true, false,   12,  nil,     1,    4,      100,   20,       30,      0,       20,       4,      1,      0))
 elseif (emitter_string == "light particles") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(40, 40, 0.2,  0,   false, false, false,   10,  nil,     2,    1,      0,     360,      20,      0,       10,       2,      0,      0))
  add(my_emitters, emitter.create(86, 40, 0.2,  0,   false, false, false,   10,  nil,     2,    1,      0,     360,      20,      0,       10,       2,      0,      0))
  add(my_emitters, emitter.create(64, 80, 0.2,  0,   false, false, false,   10,  nil,     2,    1,      0,     360,      20,      0,       10,       2,      0,      0))
 elseif (emitter_string == "burst emission") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 90, 0,    20,  true,  false, false,   15,  nil,     1,    3,      70,    40,       10,      15,      10,       0,      3,      0))
 elseif (emitter_string == "explosion") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites,    life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0,    50,  true,  false, false,   5,   nil,        1,    2,      0,     360,      20,      0,       10,       1,      0,      0))
  add(my_emitters, emitter.create(64, 64, 0,    50,  true,  false, false,   8,   {10,11,12}, 0,    2,      0,     360,      20,      0,       10,       3,      0,      0))
  add(my_emitters, emitter.create(64, 64, 0,    50,  true,  false, false,   8,   {13,14,15}, 0,    1.5,    0,     360,      15,      0,       10,       3,      0,      0))
 elseif (emitter_string == "sprites!") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites, life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0,    0,   false, false, false,   10,  {1},     2,    1,      0,     360,      20,      0,       10,       2,      0,      0))
 elseif (emitter_string == "varying sprites") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites,         life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 64, 0.1,  0,   false, false, false,   10,  {2,3,4,5,6,7,8}, 1,    5,      60,    60,       5,       0,       25,       2,      0,      0))
 elseif (emitter_string == "fire") then
  --                              x,  y,  freq, max, burst, grav,  rnd_col, col, sprites,       life, life_s, angle, angle_sp, speed_i, speed_f, speed_sp, size_i, size_f, size_sp
  add(my_emitters, emitter.create(64, 80, 0.1,  30,  false, false, false,   8,   nil,           2,    3,      60,    60,       10,      5,       10,       2,      0,      0))
  add(my_emitters, emitter.create(64, 80, 0.2,  30,  false, false, false,   8,   {16,17},       2,    0,      60,    60,       5,       0,       10,       2,      0,      0))
  add(my_emitters, emitter.create(64, 80, 0.2,  30,  false, false, false,   8,   {18,19,20,21}, 2,    3,      60,    60,       5,       5,       10,       2,      0,      0))
 -- here is an example of using the set functions to create an emitter
 elseif (emitter_string == "space warp") then
  -- create the emitter using x,  y,  frequency, max_p
  local warp = emitter.create(64, 64, 0, 0)
  -- the emitter.create() function has optional arguments 
  -- set the stuff you want to change
  warp.set_speed(warp, 30, 200)
  warp.set_life(warp, 0.7)
  warp.set_size(warp, 0, 2)
  add(my_emitters, warp)
 elseif (emitter_string == "rain") then
  local rain = emitter.create(64, 7, 0, 0)
  rain.set_area(rain, true, 128, 0)
  rain.set_gravity(rain, true)
  rain.set_speed(rain, 0)
  rain.set_colour(rain, 12)
  rain.set_size(rain, 0)
  rain.set_life(rain, 2, 1)
  add(my_emitters, rain)
 end
end

-------------------------------------------------- system functions
function _init()
 prev_time = time()
 delta_time = time()-prev_time
 my_emitters = {}
 emitter_type = 1
 spawn_emitter(emitters[emitter_type])
end

function _draw()
 cls()
 draw_demo()
end

function _update60()
 update_time()
 update_demo()
end
__gfx__
0000000000a99a0000022000000bb000000aa0000009900000088000000ee0000001100009898980006060000060600000600000080000000880000000000000
000000000a9aa9a0002c720000bc7b0000ac7a00909c7909008c780000ec7e00001c710000009000006760000766660006760000898000008998000000888800
00700700a9a7aa9a0027720000b77b0000a77a00909779090087780000e77e000017710000008000667676606676766067676000080000008998000008899880
000770009a7a7aa900022022000bb000a00aa00a0909909000088000000ee0001001100100009000076767000667660006760000000000000880000008999980
000770009aa7a7a9022222200bbbbbb0a0aaaa0a009999000888888000eeee001001100100008000667676606676766000600000000000000000000008999980
00700700a9aa7a9a220220000b0bb0b00a0aa0a0000990008008800800eeee000111111000009000006760000666670000000000000000000000000008899880
000000000a9aa9a000022000000bb000000aa000000990000008800000eeee000001100009008000006060000060600000000000000000000000000000888800
0000000000a99a000020020000b00b0000a00a00009009000080080000e00e000010010000890000000000000000000000000000000000000000000000000000
0000a000000000000880000008880000008000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0089a900008080000898000089000000089000008090000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0989a980008080800098000008900000890000008900000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09898980808080800980000000800000080000000889000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88898888888080888800000008900000000000000098000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888880888980000089000000000000000980000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880088888800098000008800000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800008888000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
55555555555555555555555555555555e55555555555555555555555555588855595555555555555555555555555555555555555555555555555555555555555
57775757577757775757577757575777577555775555555555555555555558555555555555555555555555555555555555555555555555555555555555555555
575557575755575757575575575755755757575555555555e5555555555555555555555555555555555555555555555555555555555555555555555555575555
577557575775577557775575577755755757575555555555555555555555555555555555b5555555555555555555555555555555555555555555555555777555
575557775755575755575575575755755757575a5555555555555555555555555555555bbb555555555555555555555555555555555555555555555555575555
5777557557775757577755755757e777575757aaa5555555555555555555555555555555b5555555555555555555555555555555555555555555555555555555
555555555555555515555555555555555555555a5555555555555555555555555555555555555555555555555555555555555555c55555555555555555555555
00000000000000000000000000003000000000000000000000000000000000000000000000000000000009990000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000099999000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000099999000000000000000000000000000000000000000
00000000000000000000000000000000000007000000000000000000000000000000000000000000000099999000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000fff00000000000009990000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000002000000000000fffff000000000000000000000000000000000000f00000000000000f000
00000000000000000000000000000000000000000000000000000022200000000000fffff0000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000002000000100000fffff0000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000011100000fff00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
0000000008000000000000000000000000000000000000000006000000000000000000000000000000000000eee000000000000000000000000000000000000b
000000000000000000000000000000000000000000000000000000000000000004000000000000000000000eeeee0000000000000000000000000000000000bb
00000000000000000000000000000f000000000000000000000000000000000044400000000000000000000eeeee00000000000000000000000000000000000b
000000000000000000000000000000000000000000000fff000000000000000004000000000000000000000eeeee00000000000000000000000000000000000d
00000000000000000000000000000000000000000000fffff000000000000000000000000000000000000000eee0000000000000000000000000000000000000
00000000000000000000000000000000000000000000fffffd000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002000000000000000000002220000000000fffffdd00000000000000000000000000000000000000000000005000000000000000000000000000000
000000000222000f00000000000000522220000000000fffddd0000000000000000e0000000000000000000000200000555000000000000a0000000000000000
0000000000200000000000000000055522200000000000ddddd000000000000000eee00000000000000000000222000005000000000000000000000000000000
000000000000000000000000000040522220000000000001dd000000b0000000000e000000088800004000000020008000000000700000000000000000000000
00000000000000000000000000046662220000000000001110000000000000000000000000888880044400000006488800000007770000000000000000000000
00000000000000000000000000066666000000000777000100000000000000000000000008888888004005000066648000000000700000000000002000000000
00000000000000000000000000066666000000007777000000000700000000000000000008888888700000000006400000003007000000000000022200000000
0000000000000000000000000006666600000000777000000000000000000ccc0000000008898888770000000000000000000000000000000000002000000000
000000000000000000000000000066600000000077700080000000000000c999c000000000999880700000000000000000000000000000000000000000000000
000000000000000000000000000000000000000007700888000000b0000099999000000000098800000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000010000008000000000000999999900000000000000000000000000000000000000000000000000000000000000
000000000000000300000000000000000000001c222000000006000ccc0999999000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000e0222220000002220777cc999990000000000000000000000300000000000000000000000000000000000000000
7000000000000000000000000000000000000002222200000222277777cc99900000000000000080000003330001110000000000000000000000000000000000
0000000000000000000000000090000055500002222200002222277777cc0990000000000000004440000030c011111008000000000000000000000000000000
000000000000000000000000099900055c550000222700002222977777cddd0000000000000004444400000ccc1e311000000000000000000000000000000000
00000000000000000000000000900005ccc50000777770002229997779ddddd0000000000000044444000000c0eee310f000000a000005000000000000000000
000000000000000000000000088800055c55000077777000022999999ddddddd000000000000044444000000000e366600000000000055500000000000000000
0050000000000000000000008888eee055500000777770000029999bbddddddd0000000000000044c00000000000666660000000000005000000000000000000
055500000000000000000000888eeeee0000000007770000ddd099bbbddddddd0000bbb66600000ccc0b00000000666660000000000000000000000700000000
005000000000000000000011188eeeee00000000000000888d888bbbbbddddd5000bbb6666600000c0bbb0000000666660000000000000000000000000000000
000000000000000000000111118eeeee000000000000088111888bbbbbbddd0000cccb6666600000000b10000000066600000000000000000000000000000000
0000000000000000000001111100eee0000000000000881111188bbbbbbb6bbb0ccccc6666600000000111033300000000000000000000000000000000000000
00000000000000000000011111000000000000d000008811111888bbbbb6bbbbbcccccb666000000011110333330000010040000000000000000000000000000
0000000000000000000000111000000000000ddd000088111117788bbb6bbbbbbbcccc0000002000777111333330000111000000000000000000000000000000
00000000000000000000000000000000000000deee005551117777aac66bbbbbbbccc6600002220777771133333000001000e000000000000000007770000000
00000000000000000000000000000033300000eeeee555557777777aaa0bbbbbbbaaa660000020777777711333000000000eee00000000000000077777000000
0000000000000000000000000000033333000eeeeee555557777777aaaa0bbbbbaaaaa660000007777777111100000000000e000000000000000077777000000
0000000000000000000000000000033333000ee5eee566657222777aaaa06bbba555aad660000777777771110000000000000000000000000000077777000000
000000000000f000000000000000033333000eeeeee6ddd6222227aaa555eeea55555ad66000077777774400000000000000000000000c000000007770000000
00000000000fff000000000000000033300d00eeeeeddddd222227aa55555ee5555555d600000777777444ccc000000f000000000000cc700000000000000000
000000000000f00000000000000000000000eeeeeeddddddd22277755555559ddd55556000000077444444cccc0000f00000000000000c000005000000000000
000000000000000000000e0050000000000eeee100ddddddd22227c5555559ddddd55888ff00009888444ccccccee00000000000000000000055500000000000
00200000000000000000000555000000000eee1110ddddddd222222555559ddddddd88888ff009888884ccaaacceee0000000000000000000005000000000000
0000000000000000000000005000a000000eeaa10b0ddddd4222222b55559ddddddd888888f008888888caaaaaceee000000a000000400000000000000030000
a00000000000000000000000000aaa100000eea00000ddd56642222bb55ddddddddd888888fbb88888884aaaaaeeee0000000000000000000000000000000000
0000000000000000000000000000a0000000000000000055566222cc1cdd000dddd88888880bb88888884aaaaaeee000000bbb00000000000000000000000000
0000000000000000000ccc00000000000000000000000065666222cc1dd00000ddd088888bb0aa88ddd444aaa222200000bbbbb0000000000000000000000000
000000000000000000ccccc0000000000000000000000066666022cc1d00000555dd5888abbaaaaddddd40042222203000bbbbb0000000000000000000000000
000000000000000000ccccc000000000eee00000000000666600022ccd000055555dd566aaa77aadddd777444222000000bbbbb0000000000000000000000000
000000000000000000ccccc00000000eeeee0000afff066666000000cc0005555555d56aaaaa77addd77777400000000000bbb00000500000000000000000000
0000000000000000006ccc00000000eeeeeee00afffff666666f0444000005555555eddaaaaaa77ad77777770000002220000000005550000000000000000000
000000000000000000060000000000eeeeeee0aaffff666666622244aaa005555555edddaaaaa77ad77777770000022222000000000500000000000000000000
000000000000000000000000000000eeeeeee0aafff666666622222aaaaab755555eeddddaaaa775077777770000022222000000000000000000000000000000
000000000000000000000d000000000eeeee00aaaff66666662222aaaaabb77555eedddddaaa7755507777700f2222222200000000000000000000f000000000
000000000000000f0000ddd000000000eee0000aaaa66666662222aaaaabb777eee7dddddaa777555007779bf222222220000000000000000000000000000000
000000000000000000000d000000000000000000aaa06666622222aaaaabbb77777ddddd0777775fff0009bbb222220000000000000000000000000000000000
000000000000000000000000000000000000000000000666c322222aaaaabbb77700ddd0077777fffff0009bf222220000022200000000000000000000000000
00000000000000000000000000000ccc00000000f0000000cc322255aaa13bbb3330000077777fffffffaaa88f22280000222220000000000000000000000000
0000000000000000000000000000ccccc000000ff0000000cc35555522213333333b000297779fffffaaaaaa8888880000222f20000000000000000000000000
000000000000100000000000000ccccccc00000fff0000000c0055522f0133333334442666669ffffaaaa7778888880000222220000000000000000000000000
000000000000000000000000000ccccccc00000fff00000000000022fff0133333444466666660fffaaa777778888000000222000000000c0000000000000000
000000000000000000000051000ccccccc000000fff000000000d8990f000133344446666666661ffaa77777778800000000000c000000ccc000000000000004
0000000000000000000005553330ccccc00000000d000000000d888990009999b44446666666665110a77777770002220000000d0000000c0000000000000044
00000000000000000000075333330ccc000000000000000000dd88889990999994444666666666ae11b7777777002222200000ddd00000000000000000000004
00000000000000000000777333330000000000000000000000dd88888880c9999944446666666eee110b7777700022222800a00d000000000000000000000000
00000000000200000d0077733333005550000000fff0000000d998888800cc999dd444166666eeee1100077700002222c000e000000100000000000000000000
0000000000000000ddd07777333005555590000fffff09990099998880000cddddddd15555557ee1100000000000022ccc0eee00001110000000000000000000
d0000000000000000d000777000005555599000fffff9999909ddd905550002ddddd005555577e110000000000000000c000e000000100000000000000000000
000000000000000006000000000005555599000fffff999990ddddd555550000dd90001555557000000000000000111000007000000000000001000000000000
0000000000000000666000000000005559990444fff0999990ddddd5555550000999001155555000000111000001111100000000000000000011100000000000
00000000000000000600000000000000999044444000099900ddddd5555550ccc09000015999500000111110000111110000000000000000c001000000000000
000000000000000000000000000000000000444443000005000ddd5555555c888c000000999991000111111100011111000000000000000ccc00000000000000
000000000f0000000000000000000000000444444000000000000105555333888800000099999b1001111111000011100000f00000000000c000000000000000
000000000000000000000000000000000004444400000000000011105533333888000eee99999bb00111111150000000000fff00000000000000000000000005
00000000000000000000000000000000000444440a00000000000100003333388800eeeeb999bbb00b111115500000000000f000000000000000000000000055
0000000000000000000000000000000000004440aaa0000000000000003333388000eeeebbbbbbbcbbb111555010000000000000000000000000000000000005
0000000000000000000000000000ccc0000000000a0999000000077600a333110000eeee7bbbbbc0bbbee5550000000000000000000000000000000000000000
000000000000000000000000000ccccc0000000000999990000077777aaa111000000eee07bbb00ebbeeeee00000000000000000000000000000000000000000
00000000000000000000000000000ccc00000000009999900000777774a4400000000000000000eeebeeeeec0000000000000000000000000000000000000000
000000000000000000000000000000cc00000050009999900000777774444000000000000000000e00eeeee00000000000000000000000000000000000010000
000000000000000000000000100000c000000555000999000000077744444000000000000000000000deeed00000020200000000000000000000000000111006
0000000000000000000000011000000000000050000000000000d7ddd44400000000001110000000000ddd000000222000000000000000000000000000010000
000000000000000000000000100000000000000000000000000ddddddd00000000000b1111000000000000000000020000000000000000000000000000000000
000000000000000000000000008000000000000000000004000ddd222d0000000000bbb1110000000000000000000000000000000000000000ccc00000000000
00000000000000000000000008880000000000000000d022200dddddddd0000000000b1111000000000006000c08000000000000000e00000ccccc0000000000
0000000000000000000000000080000000000000000ddd222200dddddd000000000000222000000000006660000000000000000000eee0000ccccc0000000000
00000000b00000000000000000000044400000000003d2222200ddddd20000001000022222000000000006000000000000000000000e00000ccccc0000000000
00000000000000000000000000000444440000307733322c2200ddddd000006111000222220000000000000000000000000000000010000000ccc00000000000
00000000000000000000000000000444440003377773002220000ddd000006661000022222000000000000000000000000400000011100000000000000000000
00000000000000000000000600000444440000377777000b00000000000000600000002228000040000000008880000004440000001000000000000000000000
0000000000000000000000e660000044400000077777000d000000d0000000000000000080000444000000088888000000400000000000000000000000000000
000000000000000000000eee0000000000000000777000ddd0000ddd0050000000000000000000400000000eee88000000000000000000000000000000000000
0000000000000000000000e000000000000000000000000ddd0000d0000b00000000000000000000000000eeeee8000000000000000000000000000000000000
000000000000000000000e000000000000000000000000ddddd0000000bbb0000000000000000000000000eeeee000000000c0000000000000000000000b0000
0000000000000000000000000000000000000000000000ddddd00000000b00000000000000000000000000eeeee0000000000000000000000000000000bbb000
0000000000000000000000000000000000000000000000ddddd0000000000000000000000000d0000000000eee000000000000000000000000000000000b0000
00000000000000000000000000000000000000000000000ddd000002000000004000000000000d00000000000000000000000000bbb000000000000000000000
0000000000000000000000000000000000000000000000044400000000000004440000000000d00000000080000000000000000bbbbb00000000000000000000
0000000000000000000000000000000000000000000000004000000000000000400d00000000000000000888000000000000000bbbbb00000000000000000000
0000000000000000000000010000000000000000000000000000000000000000000000000000000000000080000000000000000bbbbb00000000000000000000
0000000000000000000000000000000000000000000d000000000000000000000000000000000003000000000000000000000000bbb000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000003000000000033300000000006000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000003000000000066600000000000000000000000000000000000
00000000000000060000000000000000000000000000000000000000000000000000600000000000000000000006000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000f00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000006660000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000006000000000000000000b0000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000b0000000000000000000000000000000000000000000000000000
00000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

