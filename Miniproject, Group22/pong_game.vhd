----------------
--This file is the Main(Actual) Game Mode of Intercept Pong Game
----------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;
LIBRARY work;
USE work.all;

ENTITY pong_game IS
Generic(ADDR_WIDTH: integer := 12; DATA_WIDTH: integer := 1);

   PORT(SIGNAL Clock, Clock_1Hz, vert_sync_in, horiz_sync_in : IN std_logic;
			SIGNAL mouse_column 		: IN std_logic_vector(9 DOWNTO 0);
			SIGNAL mouse_row 		: IN std_logic_vector(9 DOWNTO 0);
			SIGNAL rom_mux_input	:	IN std_logic;
			SIGNAL lfsr				:	IN	std_logic_vector(10 DOWNTO 0);
			SIGNAL pixel_row_in : IN std_logic_vector(9 DOWNTO 0);
			SIGNAL pixel_column_in : IN std_logic_vector(9 DOWNTO 0);
			SIGNAL reset : IN std_logic;
			SIGNAL pause : IN std_logic;
			SIGNAL mode : IN std_logic;
			
			SIGNAL Red_out,Green_out,Blue_out : OUT std_logic;
			SIGNAL ledenable : OUT std_logic;
			SIGNAL Score_out : OUT std_logic_vector(7 DOWNTO 0);
			SIGNAL Timer_out : OUT std_logic_vector(7 DOWNTO 0);
			SIGNAL Level_out : OUT std_logic_vector(2 DOWNTO 0);
			SIGNAL win_out : OUT std_logic;
			SIGNAL game_over_out : OUT std_logic);

END ENTITY pong_game;

architecture behavior of pong_game is

			-- Video Display Signals   
SIGNAL Red_Data, Green_Data, Blue_Data, vert_sync_int, horiz_sync_int,
		Ball_on, Ball_1_on, Ball_2_on, Direction, Platform_on, v_ledenable			: std_logic;
--------------------------------------------------------------------------------
--Signals for Default Ball 0
--------------------------------------------------------------------------------
SIGNAL Size 								: std_logic_vector(9 DOWNTO 0);  
SIGNAL Ball_Y_motion 			: std_logic_vector(9 DOWNTO 0):= "0000000001";
SIGNAL Ball_X_motion 			: std_logic_vector(9 DOWNTO 0):= "0000000010";
SIGNAL Ball_Y_pos				: std_logic_vector(10 DOWNTO 0):= "00001100100";
SIGNAL Ball_X_pos				: std_logic_vector(10 DOWNTO 0):= "00011001000";
--------------------------------------------------------------------------------
--Signals for Default Ball 1
--------------------------------------------------------------------------------
SIGNAL Size_1 								: std_logic_vector(9 DOWNTO 0); 
SIGNAL Ball_1_Y_motion 			: std_logic_vector(9 DOWNTO 0):= "0000000010";
SIGNAL Ball_1_X_motion 			: std_logic_vector(9 DOWNTO 0):= "0000000011";
SIGNAL Ball_1_Y_pos				: std_logic_vector(10 DOWNTO 0):= "00011001000";
SIGNAL Ball_1_X_pos				: std_logic_vector(10 DOWNTO 0):= "00100101100";
--------------------------------------------------------------------------------
--Signals for Default Ball 2
--------------------------------------------------------------------------------
SIGNAL Size_2 								: std_logic_vector(9 DOWNTO 0);  
SIGNAL Ball_2_Y_motion 			: std_logic_vector(9 DOWNTO 0):= "0000000100";
SIGNAL Ball_2_X_motion 			: std_logic_vector(9 DOWNTO 0):= "0000000101";
SIGNAL Ball_2_Y_pos				: std_logic_vector(10 DOWNTO 0):= "00100101100";
SIGNAL Ball_2_X_pos				: std_logic_vector(10 DOWNTO 0):= "00110010000";
--------------------------------------------------------------------------------
--Signals for Default platform 
--------------------------------------------------------------------------------
SIGNAL Platform_Size_X,Platform_Size_Y		: std_logic_vector(9 DOWNTO 0);  
SIGNAL Platform_Y_motion 						: std_logic_vector(9 DOWNTO 0);
SIGNAL Platform_Y_pos, Platform_X_pos				: std_logic_vector(10 DOWNTO 0);


SIGNAL pixel_row, pixel_column				: std_logic_vector(9 DOWNTO 0); 

SIGNAL collision							: std_logic := '0';
SIGNAL collision_1							: std_logic := '0';
SIGNAL collision_2							: std_logic := '0';

SIGNAL Score : std_logic_vector(7 DOWNTO 0) := "00000000";
SIGNAL Score_1 : std_logic_vector(7 DOWNTO 0) := "00000000";
SIGNAL Score_2 : std_logic_vector(7 DOWNTO 0) := "00000000";
SIGNAL Total_Score : std_logic_vector(7 DOWNTO 0) := "00000000";

------
Signal Score_win : std_logic := '0';
------
SIGNAL Timer : std_logic_vector(7 DOWNTO 0) := "00111100";

SIGNAL Level : std_logic_vector(2 DOWNTO 0) := "001";

SIGNAL Win : std_logic := '0';
SIGNAL Win2 : std_logic := '0';
SIGNAL game_over : std_logic := '0';
SIGNAL game_over2 : std_logic := '0';

BEGIN           

Size <= CONV_STD_LOGIC_VECTOR(12,10);
Size_1 <= CONV_STD_LOGIC_VECTOR(12,10);
Size_2 <= CONV_STD_LOGIC_VECTOR(12,10);

Platform_Size_Y <= CONV_STD_LOGIC_VECTOR(5,10);
Platform_Y_pos <= CONV_STD_LOGIC_VECTOR(465,11);
-------------------------------------------------------------------
-- Colors for pixel data on video signal
Red_out <= Ball_on OR Ball_1_on or Ball_2_on OR NOT(  Platform_on OR '0');
Blue_out <= NOT (rom_mux_input or Ball_on or Ball_1_on or Ball_2_on);
Green_out <= NOT((Ball_on or Ball_1_on or Ball_2_on or Platform_on) OR '0');

pixel_row <= pixel_row_in;
pixel_column <= pixel_column_in;

ledenable <= v_ledenable;



RGB_Display: Process (Ball_X_pos, Ball_Y_pos, pixel_column, pixel_row, Size, Platform_Y_pos, Platform_X_pos, v_ledenable, clock)
BEGIN
		--Detect Collision
	if rising_edge(clock) then	
		
	If( (((Ball_X_Pos - ('0' & pixel_column)) * (Ball_X_Pos - ('0' & pixel_column))) + (((Ball_Y_Pos - ('0' & pixel_row)) * (Ball_Y_Pos - ('0' & pixel_row))))) <= Size*Size) then
		Ball_on <= '1';
		IF (Level = "001") THEN
		
			IF ((Ball_Y_pos > Platform_Y_pos - 18) and (Ball_X_pos < Platform_X_pos + 50) and (Ball_X_pos > Platform_X_pos - 50)) THEN
			collision <= '1';
			else 
			collision <= '0';
			END IF;
		
		ELSIF (Level = "010") THEN
		
			IF ((Ball_Y_pos > Platform_Y_pos - 18) and (Ball_X_pos < Platform_X_pos + 40) and (Ball_X_pos > Platform_X_pos - 40)) THEN
			collision <= '1';
			else 
			collision <= '0';
			END IF;
		
		ELSIF (Level = "011") THEN
		
			IF ((Ball_Y_pos > Platform_Y_pos - 18) and (Ball_X_pos < Platform_X_pos + 30) and (Ball_X_pos > Platform_X_pos - 30)) THEN
			collision <= '1';
			else 
			collision <= '0';
			END IF;
		
		ELSIF (Level = "100") THEN
		
			IF ((Ball_Y_pos > Platform_Y_pos - 18) and (Ball_X_pos < Platform_X_pos + 20) and (Ball_X_pos > Platform_X_pos - 20)) THEN
			collision <= '1';
			else 
			collision <= '0';
			END IF;
		
		END IF;
		
		
 	ELSE
 		Ball_on <= '0';
END IF;
end if;
END process RGB_Display;

RGB_1_Display: Process (Ball_1_X_pos, Ball_1_Y_pos, pixel_column, pixel_row, Size_1, Platform_Y_pos, Platform_X_pos, v_ledenable, clock)
BEGIN
--		--Detect Collision
		if rising_edge(clock) then

		If( (((Ball_1_X_Pos - ('0' & pixel_column)) * (Ball_1_X_Pos - ('0' & pixel_column))) + (((Ball_1_Y_Pos - ('0' & pixel_row)) * (Ball_1_Y_Pos - ('0' & pixel_row))))) <= Size_1*Size_1) then
		Ball_1_on <= '1';
		IF (Level = "001") THEN
		
			IF ((Ball_1_Y_pos > Platform_Y_pos - 18) and (Ball_1_X_pos < Platform_X_pos + 50) and (Ball_1_X_pos > Platform_X_pos - 50)) THEN
			collision_1 <= '1';
			else 
			collision_1 <= '0';
			END IF;
		
		ELSIF (Level = "010") THEN
		
			IF ((Ball_1_Y_pos > Platform_Y_pos - 18) and (Ball_1_X_pos < Platform_X_pos + 40) and (Ball_1_X_pos > Platform_X_pos - 40)) THEN
			collision_1 <= '1';
			else 
			collision_1 <= '0';
			END IF;
		
		ELSIF (Level = "011") THEN
		
			IF ((Ball_1_Y_pos > Platform_Y_pos - 18) and (Ball_1_X_pos < Platform_X_pos + 30) and (Ball_1_X_pos > Platform_X_pos - 30)) THEN
			collision_1 <= '1';
			else 
			collision_1 <= '0';
			END IF;
		
		ELSIF (Level = "100") THEN
		
			IF ((Ball_1_Y_pos > Platform_Y_pos - 18) and (Ball_1_X_pos < Platform_X_pos + 20) and (Ball_1_X_pos > Platform_X_pos - 20)) THEN
			collision_1 <= '1';
			else 
			collision_1 <= '0';
			END IF;
		
		END IF;
		
		
 	ELSE
 		Ball_1_on <= '0';
END IF;
end if;
END process RGB_1_Display;

RGB_2_Display: Process (Ball_2_X_pos, Ball_2_Y_pos, pixel_column, pixel_row, Size_2, Platform_Y_pos, Platform_X_pos, v_ledenable, clock)
BEGIN
--	Detect Collision
		if rising_edge(clock) then

		If( (((Ball_2_X_Pos - ('0' & pixel_column)) * (Ball_2_X_Pos - ('0' & pixel_column))) + (((Ball_2_Y_Pos - ('0' & pixel_row)) * (Ball_2_Y_Pos - ('0' & pixel_row))))) <= Size_2*Size_2) then
		Ball_2_on <= '1';
		IF (Level = "001") THEN
		
			IF ((Ball_2_Y_pos > Platform_Y_pos - 18) and (Ball_2_X_pos < Platform_X_pos + 50) and (Ball_2_X_pos > Platform_X_pos - 50)) THEN
			collision_2 <= '1';
			else 
			collision_2 <= '0';
			END IF;
		
		ELSIF (Level = "010") THEN
		
			IF ((Ball_2_Y_pos > Platform_Y_pos - 18) and (Ball_2_X_pos < Platform_X_pos + 40) and (Ball_2_X_pos > Platform_X_pos - 40)) THEN
			collision_2 <= '1';
			else 
			collision_2 <= '0';
			END IF;
		
		ELSIF (Level = "011") THEN
		
			IF ((Ball_2_Y_pos > Platform_Y_pos - 18) and (Ball_2_X_pos < Platform_X_pos + 30) and (Ball_2_X_pos > Platform_X_pos - 30)) THEN
			collision_2 <= '1';
			else 
			collision_2 <= '0';
			END IF;
		
		ELSIF (Level = "100") THEN
		
			IF ((Ball_2_Y_pos > Platform_Y_pos - 18) and (Ball_2_X_pos < Platform_X_pos + 20) and (Ball_2_X_pos > Platform_X_pos - 20)) THEN
			collision_2 <= '1';
			else 
			collision_2 <= '0';
			END IF;
		
		END IF;
		
		
 	ELSE
 		Ball_2_on <= '0';
END IF;
end if;
END process RGB_2_Display;

-- This displays the platform
RGB_Display_Platform: Process (Platform_X_pos, Platform_Y_pos, pixel_column, pixel_row, Platform_Size_X,Platform_Size_Y,level)
BEGIN

if (Level = "001") THEN
Platform_Size_X <= CONV_STD_LOGIC_VECTOR(40,10);
elsif (Level = "010") THEN
Platform_Size_X <= CONV_STD_LOGIC_VECTOR(30,10);
elsif (Level = "011") THEN
Platform_Size_X <= CONV_STD_LOGIC_VECTOR(20,10);
elsif (Level = "100") THEN
Platform_Size_X <= CONV_STD_LOGIC_VECTOR(10,10);
END IF;

			-- Set Platform_on ='1' to display platform
	IF ("00" & Platform_X_pos <= (('0' & pixel_column) + ('0'& Platform_Size_X) )) AND
 			-- compare positive numbers only
		(Platform_X_pos + Platform_Size_X >= '0' & pixel_column) AND
		--('0' & Platform_Y_pos <= pixel_row + Platform_Size) AND
	 	('0' & Platform_Y_pos <= (pixel_row + Platform_Size_Y)) AND
		(Platform_Y_pos + Platform_Size_Y >= '0' & pixel_row ) THEN
 		Platform_on <= '1';
 	ELSE
 		Platform_on <= '0';
END IF;
END process RGB_Display_Platform;

Move_Ball_Y: process
BEGIN 
			-- Move ball once every vertical sync
	WAIT UNTIL vert_sync_in'event and vert_sync_in = '1';
			-- If collision happens
			IF (collision = '0') then
			
			if level = "001" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_Y_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
			ELSIF Ball_Y_pos <= Size THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			END IF;
			 --Compute next ball Y position
				if pause = '1' then
				Ball_Y_pos <= Ball_Y_pos + Ball_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_X_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
			ELSIF ('0' & Ball_X_pos) <= Size THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			END IF;
			
			elsif level = "010" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_Y_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
			ELSIF Ball_Y_pos <= Size THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(3,10);
			END IF;
			 --Compute next ball Y position
				if pause = '1' then
				Ball_Y_pos <= Ball_Y_pos + Ball_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_X_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
			ELSIF ('0' & Ball_X_pos) <= Size THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(3,10);
			END IF;
			
			elsif level = "011" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_Y_motion <= - CONV_STD_LOGIC_VECTOR(5,10);
			ELSIF Ball_Y_pos <= Size THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(5,10);
			END IF;
			 --Compute next ball Y position
				if pause = '1' then
				Ball_Y_pos <= Ball_Y_pos + Ball_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_X_motion <= - CONV_STD_LOGIC_VECTOR(5,10);
			ELSIF ('0' & Ball_X_pos) <= Size THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(5,10);
			END IF;
			
			elsif level = "100" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_Y_motion <= - CONV_STD_LOGIC_VECTOR(6,10);
			ELSIF Ball_Y_pos <= Size THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(6,10);
			END IF;
			 --Compute next ball Y position
			 if pause = '1' then
				Ball_Y_pos <= Ball_Y_pos + Ball_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_X_motion <= - CONV_STD_LOGIC_VECTOR(6,10);
			ELSIF ('0' & Ball_X_pos) <= Size THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(6,10);
			END IF;
			
			end if;
			
			 --Compute next ball X position
			if pause = '1' then
			Ball_X_pos <= Ball_X_pos + Ball_X_motion;
			end if;
				
			ELSE
			
			Ball_X_pos <= (("00" & lfsr(8 downto 0)) + "00000110010");
			Ball_Y_pos <= CONV_STD_LOGIC_VECTOR(10,11);
			Ball_X_motion <=  ("0000000" & lfsr(9 downto 7)) - ("0000000" & lfsr(3 downto 1));
			Ball_Y_motion <= ("0000000" & lfsr(6 downto 4));
			
			END IF;
END process Move_Ball_Y;

Move_Ball_1_Y: process
BEGIN 
			-- Move ball once every vertical sync
	WAIT UNTIL vert_sync_in'event and vert_sync_in = '1';
			-- If collision happens
			IF (collision_1 = '0') then
		
			if level = "001" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_1_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_1_Y_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
			ELSIF Ball_1_Y_pos <= Size THEN
				Ball_1_Y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			END IF;
			 --Compute next ball Y position
			 if pause = '1' then
				Ball_1_Y_pos <= Ball_1_Y_pos + Ball_1_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_1_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_1_X_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
			ELSIF ('0' & Ball_1_X_pos) <= Size THEN
				Ball_1_X_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			END IF;
			
			elsif level = "010" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_1_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_1_Y_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
			ELSIF Ball_1_Y_pos <= Size THEN
				Ball_1_Y_motion <= CONV_STD_LOGIC_VECTOR(3,10);
			END IF;
			 --Compute next ball Y position
			 if pause = '1' then
				Ball_1_Y_pos <= Ball_1_Y_pos + Ball_1_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_1_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_1_X_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
			ELSIF ('0' & Ball_1_X_pos) <= Size THEN
				Ball_1_X_motion <= CONV_STD_LOGIC_VECTOR(3,10);
			END IF;
			
			elsif level = "011" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_1_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_1_Y_motion <= - CONV_STD_LOGIC_VECTOR(5,10);
			ELSIF Ball_1_Y_pos <= Size THEN
				Ball_1_Y_motion <= CONV_STD_LOGIC_VECTOR(5,10);
			END IF;
			 --Compute next ball Y position
			 if pause = '1' then
				Ball_1_Y_pos <= Ball_1_Y_pos + Ball_1_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_1_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_1_X_motion <= - CONV_STD_LOGIC_VECTOR(5,10);
			ELSIF ('0' & Ball_1_X_pos) <= Size THEN
				Ball_1_X_motion <= CONV_STD_LOGIC_VECTOR(5,10);
			END IF;
			
			elsif level = "100" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_1_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_1_Y_motion <= - CONV_STD_LOGIC_VECTOR(6,10);
			ELSIF Ball_1_Y_pos <= Size THEN
				Ball_1_Y_motion <= CONV_STD_LOGIC_VECTOR(6,10);
			END IF;
			 --Compute next ball Y position
			 if pause = '1' then
				Ball_1_Y_pos <= Ball_1_Y_pos + Ball_1_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_1_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_1_X_motion <= - CONV_STD_LOGIC_VECTOR(6,10);
			ELSIF ('0' & Ball_1_X_pos) <= Size THEN
				Ball_1_X_motion <= CONV_STD_LOGIC_VECTOR(6,10);
			END IF;
			
			end if;
			
			 --Compute next ball X position
			 if pause = '1' then
			Ball_1_X_pos <= Ball_1_X_pos + Ball_1_X_motion;
			end if;
				
			ELSE
			
			Ball_1_X_pos <= (("00" & lfsr(8 downto 0)) + "00000110010");
			Ball_1_Y_pos <= CONV_STD_LOGIC_VECTOR(10,11);
			Ball_1_X_motion <=  ("0000000" & lfsr(9 downto 7)) - ("0000000" & lfsr(6 downto 4));
			Ball_1_Y_motion <= ("0000000" & lfsr(3 downto 1));
			
			
			END IF;
END process Move_Ball_1_Y;

-----------------------------------------------------
Move_Ball_2_Y: process
BEGIN 
			-- Move ball once every vertical sync
	WAIT UNTIL vert_sync_in'event and vert_sync_in = '1';
			-- If collision happens
			IF (collision_2 = '0') then
		
			if level = "001" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_2_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_2_Y_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
			ELSIF Ball_2_Y_pos <= Size THEN
				Ball_2_Y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			END IF;
			 --Compute next ball Y position
			 if pause = '1' then
				Ball_2_Y_pos <= Ball_2_Y_pos + Ball_2_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_2_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_2_X_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
			ELSIF ('0' & Ball_2_X_pos) <= Size THEN
				Ball_2_X_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			END IF;
			
			elsif level = "010" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_2_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_2_Y_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
			ELSIF Ball_2_Y_pos <= Size THEN
				Ball_2_Y_motion <= CONV_STD_LOGIC_VECTOR(3,10);
			END IF;
			 --Compute next ball Y position
			 if pause = '1' then
				Ball_2_Y_pos <= Ball_2_Y_pos + Ball_2_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_2_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_2_X_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
			ELSIF ('0' & Ball_2_X_pos) <= Size THEN
				Ball_2_X_motion <= CONV_STD_LOGIC_VECTOR(3,10);
			END IF;
			
			elsif level = "011" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_2_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_2_Y_motion <= - CONV_STD_LOGIC_VECTOR(5,10);
			ELSIF Ball_2_Y_pos <= Size THEN
				Ball_2_Y_motion <= CONV_STD_LOGIC_VECTOR(5,10);
			END IF;
			 --Compute next ball Y position
			 if pause = '1' then
				Ball_2_Y_pos <= Ball_2_Y_pos + Ball_2_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_2_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_2_X_motion <= - CONV_STD_LOGIC_VECTOR(5,10);
			ELSIF ('0' & Ball_2_X_pos) <= Size THEN
				Ball_2_X_motion <= CONV_STD_LOGIC_VECTOR(5,10);
			END IF;
			
			elsif level = "100" then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_2_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Ball_2_Y_motion <= - CONV_STD_LOGIC_VECTOR(6,10);
			ELSIF Ball_2_Y_pos <= Size THEN
				Ball_2_Y_motion <= CONV_STD_LOGIC_VECTOR(6,10);
			END IF;
			 --Compute next ball Y position
			 if pause = '1' then
				Ball_2_Y_pos <= Ball_2_Y_pos + Ball_2_Y_motion;	
				end if;
			-- Bounce off left or right of screen
			IF ('0' & Ball_2_X_pos) >= CONV_STD_LOGIC_VECTOR(640,11) - Size THEN
				Ball_2_X_motion <= - CONV_STD_LOGIC_VECTOR(6,10);
			ELSIF ('0' & Ball_2_X_pos) <= Size THEN
				Ball_2_X_motion <= CONV_STD_LOGIC_VECTOR(6,10);
			END IF;
			
			end if;
			
			 --Compute next ball X position
			 if pause = '1' then
			Ball_2_X_pos <= Ball_2_X_pos + Ball_2_X_motion;
			end if;
				
			ELSE
			
			Ball_2_X_pos <= (("00" & lfsr(8 downto 0)) + "00000110010");
			Ball_2_Y_pos <= CONV_STD_LOGIC_VECTOR(10,11);
			Ball_2_X_motion <=  ("0000000" & lfsr(2 downto 0)) - ("0000000" & lfsr(5 downto 3));
			Ball_2_Y_motion <= ("0000000" & lfsr(8 downto 6));
			
			END IF;
END process Move_Ball_2_Y;


----------------------------------------------------------

-- This increments the score based off collisions from ball
Increment_Score: process(collision, collision_1, collision_2, score_win, timer, reset)
BEGIN
	IF (collision'event and collision = '1') THEN
			
			case score_win is
			when '0' => Score <= (Score + "00000100" - "00000011");
			when others => Score <= Score;
			end case;
			
			END IF;
			
			if score_win = '1' or reset = '0' then
			Score <= ("00000000");
			end if;

			if timer = "00000000" then
			Score <= ("00000000");
			end if;
			
END process Increment_Score;

-- This increments the score based off collisions from ball 1
Increment_1_Score: process(collision, collision_1, collision_2, score_win, timer,reset)
BEGIN
	IF (collision_1'event and collision_1 = '1') THEN
			
			case score_win is
			when '0' => Score_1 <= (Score_1 + "00000100" - "00000011");
			when others => Score_1 <= Score_1;
			end case;
			
			END IF;
			
			if score_win = '1' or reset = '0' then
			Score_1 <= ("00000000");
			end if;
			
			if timer = "00000000" then
			Score_1 <= ("00000000");
			end if;
					
END process Increment_1_Score;

-- This increments the score based off collisions from ball 2
Increment_2_Score: process(collision, collision_1, collision_2, score_win, timer,reset)
BEGIN
	IF (collision_2'event and collision_2 = '1') THEN
			
			case score_win is
			when '0' => Score_2 <= (Score_2 + "00000100" - "00000011");
			when others => Score_2 <= Score_2;
			end case;
			END IF;
			
			if score_win = '1' or reset = '0' then
			Score_2 <= ("00000000");
			end if;
			
			if timer = "00000000" then
			Score_2 <= ("00000000");
			end if;
			
END process Increment_2_Score;

-- This adds 3 scores into one and outputs it to char gen
Increment_Total_Score: process(Score, Score_1, Score_2, clock, timer)
BEGIN
	if rising_edge(clock) then
	Total_Score <= Score + Score_1 + Score_2;
	
	Score_out <= Total_Score;
	
	if level = "001" then
	if (Total_Score = "00010100") THEN
	Score_win <= '1';
	else
	Score_win <= '0';
	end if;
	
	elsif level = "010" then
	if (Total_Score = "00101000") THEN
	Score_win <= '1';
	
	else
	
	Score_win <= '0';
	end if;
	
	elsif level = "011" then
	if (Total_Score = "00111100") THEN
	Score_win <= '1';
	
	else
	
	Score_win <= '0';
	end if;
	
	elsif level = "100" then
	if (Total_Score = "01010000") THEN
	Score_win <= '1';
	
	else
	
	Score_win <= '0';
	
	end if;
	
	else
	if (Total_Score = "00010100") THEN
	Score_win <= '1';

	else
	
	Score_win <= '0';
	
	end if;
	end if;
	end if;

END process Increment_Total_Score;

-- This increments the level based on win conditions and mode
levelout: process(Score_win, timer,clock, clock_1Hz, reset,level)
begin
	
	if (rising_edge(score_win)) then
	if Level = "100" and mode = '1' then
		Level <= "001";
		
	
		
	elsif mode = '1' then
		Level <= Level + "001";
		
	end if;
	end if;

	Level_out <= Level;
end process levelout;

-- This outputs the level win condition to controller to display win screen
wincondition: process(Score_win, clock,win,reset)
begin

	if rising_edge(score_win) then
	if Level = "100" then
	
	win <= '1';

	elsif mode = '0' then
	win <= '1';

	end if;
	end if;
	
	if reset = '0' then
	win <= '0';
	end if;
	
	win_out <= win;
end process;


detectgameover: process(clock,timer,total_score,reset,level, clock_1Hz)
begin



	if (timer <= "00000000") and (total_score < "00010100") and (reset = '1') and (level = "001") then
	game_over <= '1';
	
	
	elsif timer <= "00000000" and total_score < "00101000" and reset = '1' and level = "010" then
	game_over <= '1';
	
	
	
	elsif timer <= "00000000" and total_score < "00111100" and reset = '1' and level = "011" then
	game_over <= '1';
	
	
	
	elsif timer <= "00000000" and total_score < "01010000" and reset = '1' and level = "100" then
	game_over <= '1';
	else
	game_over <= '0';
	end if;
	

	
end process;


-- This decrements the time value each second
Decrement_Timer: process(Clock_1Hz, score_win, reset, clock, level, total_score, timer)
BEGIN

IF rising_edge(Clock_1Hz) THEN
	if pause = '1' and mode = '1' then
	Timer <= Timer - "00000001";
	end if;
	END IF;
	
	IF timer = "00000000" or score_win = '1' or reset = '0' THEN
	
	timer <= "00111100";
	END IF;
	
	Timer_out <= Timer;
END process Decrement_Timer;


-- This outpus the gameover signal resettable by reset
gameoverprocess: process(game_over, reset)
begin

if reset = '0' then
game_over_out <= '0';

elsif game_over = '1' then
game_over_out <= '1';
end if;

end process;


-- This moves the platform based on mouse position from mouse.vhd
Move_Platform_X: process
BEGIN
WAIT UNTIL HORIZ_sync_in'event and horiz_sync_in = '1';
Platform_X_pos <= '0' & mouse_column;
END process Move_Platform_X;


END behavior;
