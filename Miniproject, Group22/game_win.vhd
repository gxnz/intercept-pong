----------------
--This file is the game_win scene of Intercept Pong Game
----------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Game_win IS
	PORT
	(
		clock				: 	IN STD_LOGIC ;
		pixel_row_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		pixel_column_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
    	Red,Green,Blue : OUT STD_LOGIC
		);
END ENTITY Game_win;

Architecture win of Game_win is 

	component  char_rom 	
		PORT
	(
		character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		rom_mux_output		:	OUT STD_LOGIC
	);
	END component char_rom ;
	 --signals to enable display of text for Game win menu
	 signal Main_on, rom_on : std_logic;
	 signal address_var : std_logic_vector(5 downto 0);
begin
	----Port map charector Rom to display text
	CHAR: char_rom
		PORT MAP(character_address	=> address_var, font_row => pixel_row_input(3 DOWNTO 1), font_col => pixel_column_input(3 DOWNTO 1),
					clock => clock, rom_mux_output => rom_on);
	--Display logic:
	--use blue text to display Main Menu page with black background
	Red <= '0'; 
	Green <='0';
	Blue <= rom_on and main_on;
--Display process:
conversion: process( pixel_column_input,pixel_row_input)
begin
	
-----------------------You  Win----------------------
		if (pixel_column_input >=16*14)and (pixel_column_input<16*15) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "011001";--Display Y
			Main_on <= '1';

		elsif (pixel_column_input >=16*15)and (pixel_column_input<16*16) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "001111";--Display O
			Main_on <= '1';
		elsif (pixel_column_input >=16*16)and (pixel_column_input<16*17) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "010101";--Display U
			Main_on <= '1';
		elsif (pixel_column_input >=16*17)and (pixel_column_input<16*18) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "100001";--Display !
			Main_on <= '1';

		elsif (pixel_column_input >=16*19)and (pixel_column_input<16*20) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "010111";  --W
			Main_on <= '1';
		elsif (pixel_column_input >=16*20)and (pixel_column_input<16*21) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "001001";   --Display I
			Main_on <= '1';
		elsif (pixel_column_input >=16*21)and (pixel_column_input<16*22) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "001110";  --Display N
			Main_on <= '1';
		elsif (pixel_column_input >=16*22)and (pixel_column_input<16*23) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "100001";  --Display !
			Main_on <= '1';
		
		--------------------------

-------------------------------------------------------PRESS PUSH BTN0 To RETURN
		elsif (pixel_column_input >=16*8)and (pixel_column_input<16*9) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "010000";--Display P
			Main_on <= '1';
		elsif (pixel_column_input >=16*9)and (pixel_column_input<16*10) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "010010";--Display R
			Main_on <= '1';
		elsif (pixel_column_input >=16*10)and (pixel_column_input<16*11) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "000101";--Display E
			Main_on <= '1';
		elsif (pixel_column_input >=16*11)and (pixel_column_input<16*12)  and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "010011";--  Display S
			Main_on <= '1';
		elsif (pixel_column_input >=16*12)and (pixel_column_input<16*13) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "010011";  -- Display S
			Main_on <= '1';
	
		elsif (pixel_column_input >=16*14)and (pixel_column_input<16*15) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "010000";--Display P
			Main_on <= '1';
		elsif (pixel_column_input >=16*15)and (pixel_column_input<16*16) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "010101";--Display U
			Main_on <= '1';
		elsif (pixel_column_input >=16*16)and (pixel_column_input<16*17)  and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "010011";-- Display  S
			Main_on <= '1';
		elsif (pixel_column_input >=16*17)and (pixel_column_input<16*18) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "001000";  --Display H
			Main_on <= '1';
		
			elsif (pixel_column_input >=16*19)and (pixel_column_input<16*20) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "000010";--Display B
			Main_on <= '1';
		elsif (pixel_column_input >=16*20)and (pixel_column_input<16*21) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "010100";--Display T
			Main_on <= '1';
		elsif (pixel_column_input >=16*21)and (pixel_column_input<16*22)  and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "001110";--Display  N
			Main_on <= '1';
		elsif (pixel_column_input >=16*22)and (pixel_column_input<16*23) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "110000";  --Display 0
			Main_on <= '1';
			
		elsif (pixel_column_input >=16*24)and (pixel_column_input<16*25)  and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "010100";--Display  T
			Main_on <= '1';
		elsif (pixel_column_input >=16*25)and (pixel_column_input<16*26) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "001111";  --Display O
			Main_on <= '1';
			
		elsif (pixel_column_input >=16*27)and (pixel_column_input<16*28)  and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "010010";-- Display R
			Main_on <= '1';
		elsif (pixel_column_input >=16*28)and (pixel_column_input<16*29) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "000101";  --Display E
			Main_on <= '1';
		elsif (pixel_column_input >=16*29)and (pixel_column_input<16*30)  and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "010100";-- Display T
			Main_on <= '1';
		elsif (pixel_column_input >=16*30)and (pixel_column_input<16*31) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "010101";  --Display U
			Main_on <= '1';
		elsif (pixel_column_input >=16*31)and (pixel_column_input<16*32)  and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "010010";-- Display R
			Main_on <= '1';
		elsif (pixel_column_input >=16*32)and (pixel_column_input<16*33) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "001110";  --Display N
			Main_on <= '1';
		else
			address_var<= "100000";--Space for the other situation
			Main_on <= '0';
		end if;
	
end process conversion;





end Architecture win;