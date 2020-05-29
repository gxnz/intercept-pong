----------------
--This file is the Game controller input handler(FSM) of Intercept Pong Game
----------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY game_controller IS

PORT	(	Clock, Bt1, Bt2, Bt3, Sw_0 : IN std_logic;
			Red_in, Green_in, Blue_in : IN std_logic;
			pixel_row_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		    pixel_column_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			 game_win_s,game_over_s : IN std_logic:='0';
			 
			Mode : OUT std_logic:= '1';
			pause :OUT std_logic :='1';
			reset :OUT std_logic :='1';
			Red_out, Green_out, Blue_out : OUT std_logic);


END ENTITY game_controller;

architecture behavior of game_controller is
	--Initialise Game states
	type game_state is (Main,Game,Training,GamePause,Gamewin,Gameover);
	------------------------------------------------------------------
	-- Components of the game controlller-----------------------------
	------------------------------------------------------------------
	component  Main_menu 	
		PORT(
		clock				: 	IN STD_LOGIC ;
		pixel_row_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		pixel_column_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		
		Red,Green,Blue : OUT STD_LOGIC
		);
	END component Main_menu ;
	
	component  	Game_win
		PORT(
		clock				: 	IN STD_LOGIC ;
		pixel_row_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		pixel_column_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		
		Red,Green,Blue : OUT STD_LOGIC
		);
	END component Game_win;
	
	component  Game_over 	
		PORT(
		clock				: 	IN STD_LOGIC ;
		pixel_row_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		pixel_column_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		
		Red,Green,Blue : OUT STD_LOGIC
		);
	END component Game_over;
	
	component  Game_pause 	
		PORT(
		clock				: 	IN STD_LOGIC ;
		pixel_row_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		pixel_column_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		
		Red,Green,Blue : OUT STD_LOGIC
		);
	END component Game_pause;
	
	--Debouncer_0
	component Debouncer_0
		port( clock              : in std_logic;
				pb					  : in std_logic;
				pb_out_0			  : out std_logic
		);
	END component Debouncer_0;
--Debouncer_1
	component Debouncer_1
		port( clock              : in std_logic;
				pb					  : in std_logic;
				pb_out_1			  : out std_logic
		);
	END component Debouncer_1;
--Debouncer_2
	component Debouncer_2
		port( clock              : in std_logic;
				pb					  : in std_logic;
				pb_out_2			  : out std_logic
		);
	END component Debouncer_2;
	--signals for states(current and next)
	SIGNAL CS,NS : game_state := Main;
	--signals for RGB value from each components
	SIGNAL red_game,green_game,blue_game : std_logic;
	SIGNAL red_menu,green_menu,blue_menu : std_logic;
	SIGNAL red_game_win,green_game_win,blue_game_win : std_logic;
	SIGNAL red_game_over,green_game_over,blue_game_over : std_logic;
	SIGNAL red_game_pause,green_game_pause,blue_game_pause : std_logic;
	--signals for Button after debouncer
	SIGNAL button_2,button_1,button_0 : std_logic:='1';
	
	begin
		--Port map of each components
		--main menu scene
		main0 : Main_menu
					port map(clock=>clock, pixel_row_input => pixel_row_input, pixel_column_input =>pixel_column_input, 
					Red=> red_menu, Green=>green_menu, Blue =>Blue_menu);
		--game win scene
		win0 : Game_win
					port map(clock=>clock, pixel_row_input => pixel_row_input, pixel_column_input =>pixel_column_input, 
					Red=> red_game_win, Green=> green_game_win, Blue => Blue_game_win);				
		--game over scene
		over0 : Game_over
					port map(clock=>clock, pixel_row_input => pixel_row_input, pixel_column_input =>pixel_column_input, 
					Red=> red_game_over, Green=> green_game_over, Blue => Blue_game_over);	
		--game pause scene
		pau0 : Game_pause
					port map(clock=>clock, pixel_row_input => pixel_row_input, pixel_column_input =>pixel_column_input, 
					Red=> red_game_pause, Green=> green_game_pause, Blue => Blue_game_pause);	
		--Debouncer for button0
		De_0 : Debouncer_0
					port map(clock => clock, pb => Bt3, pb_out_0 => button_0 );
		--Debouncer for button1
		De_1 : Debouncer_1
					port map(clock => clock, pb => Bt2, pb_out_1 => button_1 );
		--Debouncer for button2
		De_2 : Debouncer_2
					port map(clock => clock, pb => Bt1, pb_out_2 => button_2 );
		------------------------------------------
		-- Sync state logic
		------------------------------------------		
		Synchronous_process: process(Clock)
		begin
			if (rising_edge(Clock)and Clock = '1') then	-- when the clk is at rising_edge 
			CS <= NS;											-- set Nextstate to Currentstate
			end if;
		end process Synchronous_process;
		------------------------------------------
		-- Next state logic
		------------------------------------------
		NextState_logic: process (CS,Sw_0,button_2,game_over_s,game_win_s,button_0,button_1,bt2,bt1,bt3)
		begin
			case CS is 	
					when Main =>
						if ( Sw_0 = '1' ) then
							if(bt1 = '1') then
								NS<=Main;		
							else
								NS <= Game;			-- Main -> Game only when button pressed and DIP switch is high
							end if;
						elsif ( Sw_0 = '0' ) then
							if(bt1 = '1') then
								NS <= Main;
							else
								NS <= Training;   -- Main -> Training only when button pressed and DIP switch is low
							end if;
						else 
						NS <= Main;
					end if;
					
					
					when Game =>
						
						if (game_over_s = '1' OR button_0 = '0') then 
							NS <= Gameover;				---- Game -> Game_over only when button pressed or Game over signal is high
						elsif   button_1 = '0' then
							NS <= GamePause;				---- Game -> Game_pausse only when button pressed 
						elsif game_win_s ='1' then
							NS <= Gamewin;				   ---- Game -> Game_win only when Game win signal is high
						else
							NS <= Game;
						end if;
	
					
					when Training =>
						if (game_win_s ='1' Or button_0 = '0' or game_over_s = '1')then
							NS <= Main;						---- Training -> Main only when button pressed or Game over signal is high or Game win signal is high
--						elsif   button_1 = '0' then
--							NS <= GamePause;
						else
							NS <= Training;	
						end if;
					
					when GamePause =>         
						if button_2='0' then
							NS <= Game;						---- GamePause -> Game only when button pressed at Gamepause state
						else 
							NS <= GamePause;
						end if;
	
					when Gamewin =>
						if  button_0 = '1' then
							NS <= Gamewin;					---- Gamewin ->Main only when button pressed 
						else 
							NS <= Main;
						end if;
	
					when Gameover =>
						if  button_1 = '1' then
							NS <= Gameover;				---- Gameover ->Main only when button pressed 
						else 
							NS <= Main;
						end if;
					when Others=> 
						NS <= CS;
			end case;
		end process NextState_logic;
		----------------------------------------
		-- Output state logic
		----------------------------------------
		Output_logic: process (CS,button_2,button_1,button_0,Sw_0,red_menu,green_menu,blue_menu,red_in,green_in,blue_in
										,red_game_win,green_game_win,blue_game_win,red_game_over,green_game_over,blue_game_over,
										red_game_pause,green_game_pause,blue_game_pause)
		begin
			case CS is 	
					------------------------------------------------------------------
					--Main state:
					--Game should not running => pause = '0';
					--RGB value from main menu
					------------------------------------------------------------------
					when Main =>
						red_out <= red_menu;
						green_out <= green_menu;
						blue_out <= blue_menu;
						pause <= '0';
						
	--					
						if(sw_0 = '0' AND button_2 ='0') then
							mode <= '0';--Training mode signal
							reset<= '0';
						elsif(sw_0 = '1' AND button_2 ='0') then
							mode <= '1'   ;--Game mode signal
							reset <='0';
						else
							mode <= '1'   ;--default Game mode
							reset <= '0';
						end if;
						
						
					
					when Game =>
					------------------------------------------------------------------
					--Game state:
					--Game should running => pause = '1';
					--RGB value from Game
					--mode is on game mode
					------------------------------------------------------------------
						red_out <= red_in;
						green_out <= green_in;
						blue_out <= blue_in;
						reset <='1';
						pause <= '1';
						mode <= '1';
	
	--					
						if( button_1 ='0') then
	
							pause <= '0';   --when button1 pressed game pause
						else
	
							pause <= '1';
						end if;
					
	
					
					when Training =>
					------------------------------------------------------------------
					--Training state:
					--Game should running => pause = '1';
					--RGB value from Game
					--mode is on training mode
					------------------------------------------------------------------
						red_out <= red_in;
						green_out <= green_in;
						blue_out <= blue_in;
						reset <= '1';
						pause <= '1';
						mode<= '0';
						if( button_1 ='0') then
							pause <=   '0';--when button1 pressed game pause
						else
							pause <= '1';
						end if;
	--					
					when GamePause =>
					------------------------------------------------------------------
					--Pause state:
					--Game should  not running => pause = '0'(Active low);
					--RGB value from pause
					
					------------------------------------------------------------------
						red_out <= red_game_pause;
						green_out <= green_game_pause;
						blue_out <= blue_game_pause;
						pause <= '0';
						reset <= '1';
						
						if( button_2 ='0') then
							pause <=   '1'  ;--when button2 pressed game resume
						else
							pause <=   '0'  ;
						end if;
				
					when Gamewin =>
					------------------------------------------------------------------
					--Win state:
					--RGB value from pause
					
					------------------------------------------------------------------
						red_out <= red_game_win;
						green_out <= green_game_win;
						blue_out <= blue_game_win;	
						pause <= '0';
						reset <= '0';
						mode <= '0';
					
					when Gameover =>
					------------------------------------------------------------------
					--Gameover state:
					--RGB value from pause
					
					------------------------------------------------------------------
						red_out <= red_game_over;
						green_out <= green_game_over;
						blue_out <= blue_game_over;
						pause <= '0';
						reset <= '0';
						mode <= '0';

					when Others => 
						red_out <= '0';
						green_out <= '0';
						blue_out <= '0';
						pause <= '0';
						reset <= '0';
						mode <= '0';
	
			end case;
		end process Output_logic;
	
	end architecture behavior;