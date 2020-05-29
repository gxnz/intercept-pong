----------------
--This file is the main_menu scene of Intercept Pong Game
----------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Main_menu IS
	PORT
	(
		clock				: 	IN STD_LOGIC ;
		pixel_row_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		pixel_column_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
    	Red,Green,Blue : OUT STD_LOGIC
		);
END ENTITY Main_menu;

Architecture menu of Main_menu is 

	component  char_rom 	
		PORT
	(
		character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		rom_mux_output		:	OUT STD_LOGIC
	);
	END component char_rom ;
--signal address_var,address_hundred_score,address_hundred_time,address_ten_score,address_ten_time,address_one_score,address_one_time, address_level : STD_LOGIC_VECTOR (5 DOWNTO 0);
--signal int_score,int_time,int_hundred_score,int_ten_score,int_one_score,int_hundred_time,int_ten_time,int_one_time :  integer:=1;
	 signal Main_on, rom_on : std_logic;
	 signal address_var : std_logic_vector(5 downto 0);
begin
	CHAR: char_rom
		PORT MAP(character_address	=> address_var, font_row => pixel_row_input(3 DOWNTO 1), font_col => pixel_column_input(3 DOWNTO 1),
					clock => clock, rom_mux_output => rom_on);

Red <= '0'; 
Green <='0';
Blue <= rom_on and main_on;

conversion: process( pixel_column_input,pixel_row_input)
begin
	
--	if (pixel_column_input >= "0000010000") and (pixel_column_input<32)and (pixel_row_input >=16)and (pixel_row_input<32) then
--	address_var<= "010011";
--	Main_on <= '1';
--	
--	--S
--	elsif ((pixel_column_input >=32)and (pixel_column_input<48))and (pixel_row_input >=16)and (pixel_row_input<32) then
--	address_var<= "000011";
--	Main_on <= '1';
--	--C
--	elsif ((pixel_column_input >=16*5)and (pixel_column_input<16*6))and (pixel_row_input >=16)and (pixel_row_input<32) then
--	address_var<= "001111";
--	Main_on <= '1';
--	--O
--	elsif ((pixel_column_input >=16*6)and (pixel_column_input<80))and (pixel_row_input >=16)and (pixel_row_input<32) then
--	address_var<= "010010";
--	Main_on <= '1';
--	--R
--	elsif ((pixel_column_input >=80)and (pixel_column_input<16*8))and (pixel_row_input >=16)and (pixel_row_input<32) then
--	address_var<= "000101";
--	Main_on <= '1';
--	--E
--	
--	else
--	address_var<= "100000";--Space for the other situation
--	Main_on <= '0';
--	end if;--spoace
		-----------------------MAIN MENU----------------------
		if (pixel_column_input >=16*14)and (pixel_column_input<16*15) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "001101";--M
			Main_on <= '1';

		elsif (pixel_column_input >=16*15)and (pixel_column_input<16*16) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "000001";--A
			Main_on <= '1';
		elsif (pixel_column_input >=16*16)and (pixel_column_input<16*17) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "001001";--I
			Main_on <= '1';
		elsif (pixel_column_input >=16*17)and (pixel_column_input<16*18) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "001110";--N
			Main_on <= '1';
		elsif (pixel_column_input >=16*18)and (pixel_column_input<16*19)  and (pixel_row_input >=16*5)and (pixel_row_input<16*6)then
			address_var<= "100000";--  
			Main_on <= '1';
		elsif (pixel_column_input >=16*19)and (pixel_column_input<16*20) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "001101";  --M
			Main_on <= '1';
		elsif (pixel_column_input >=16*20)and (pixel_column_input<16*21) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "000101";   --E
			Main_on <= '1';
		elsif (pixel_column_input >=16*21)and (pixel_column_input<16*22) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "001110";  --N
			Main_on <= '1';
		elsif (pixel_column_input >=16*22)and (pixel_column_input<16*23) and (pixel_row_input >=16*5)and (pixel_row_input<16*6) then
			address_var<= "010101";  --U
			Main_on <= '1';
		
		--------------------------Trianing SW0 => 0
		elsif (pixel_column_input >=16*11)and (pixel_column_input<16*12) and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "010100";--T
			Main_on <= '1';
		elsif (pixel_column_input >=16*12)and (pixel_column_input<16*13) and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "010010";--R
			Main_on <= '1';
		elsif (pixel_column_input >=16*13)and (pixel_column_input<16*14) and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "000001";--A
			Main_on <= '1';
		elsif (pixel_column_input >=16*14)and (pixel_column_input<16*15) and (pixel_row_input >=16*8)and (pixel_row_input<16*9)then
			address_var<= "001001";-- I
			Main_on <= '1';
		elsif (pixel_column_input >=16*15)and (pixel_column_input<16*16) and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "001110";  --N
			Main_on <= '1';
		elsif (pixel_column_input >=16*16)and (pixel_column_input<16*17)and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "001001";   --I
			Main_on <= '1';
		elsif (pixel_column_input >=16*17)and (pixel_column_input<16*18) and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "001110";  --N
			Main_on <= '1';
		elsif (pixel_column_input >=16*18)and (pixel_column_input<16*19) and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "000111";  --G
			Main_on <= '1';
		
		elsif (pixel_column_input >=16*20)and (pixel_column_input<16*21) and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "010011";--S
			Main_on <= '1';
		elsif (pixel_column_input >=16*21)and (pixel_column_input<16*22)and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "010111";--W
			Main_on <= '1';
		elsif (pixel_column_input >=16*22)and (pixel_column_input<16*23) and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "110000";--0
			Main_on <= '1';
		elsif (pixel_column_input >=16*23)and (pixel_column_input<16*24) and (pixel_row_input >=16*8)and (pixel_row_input<16*9)then
			address_var<= "011111";--  left arrow
			Main_on <= '1';
		elsif (pixel_column_input >=16*24)and (pixel_column_input<16*25) and (pixel_row_input >=16*8)and (pixel_row_input<16*9) then
			address_var<= "110000";  --0
			Main_on <= '1';

		
		--------------------------Game SW0=> 1
		elsif (pixel_column_input >=16*11)and (pixel_column_input<16*12) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "000111";--G
			Main_on <= '1';
		elsif (pixel_column_input >=16*12)and (pixel_column_input<16*13) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "000001";--A
			Main_on <= '1';
		elsif (pixel_column_input >=16*13)and (pixel_column_input<16*14) and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "001101";--M
			Main_on <= '1';
		elsif (pixel_column_input >=16*14)and (pixel_column_input<16*15) and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "000101";-- E
			Main_on <= '1';
		elsif (pixel_column_input >=16*15)and (pixel_column_input<16*16) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "001101";  --M
			Main_on <= '1';
		elsif (pixel_column_input >=16*16)and (pixel_column_input<16*17) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "001111";   --O
			Main_on <= '1';
		elsif (pixel_column_input >=16*17)and (pixel_column_input<16*18) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "000100";  --D
			Main_on <= '1';
		elsif (pixel_column_input >=16*18)and (pixel_column_input<16*19) and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "000101";  --E
			Main_on <= '1';		
		
		
		elsif (pixel_column_input >=16*20)and (pixel_column_input<16*21) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "010011";--S
			Main_on <= '1';
		elsif (pixel_column_input >=16*21)and (pixel_column_input<16*22) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "010111";--W
			Main_on <= '1';
		elsif (pixel_column_input >=16*22)and (pixel_column_input<16*23) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "110000";--0
			Main_on <= '1';
		elsif (pixel_column_input >=16*23)and (pixel_column_input<16*24)  and (pixel_row_input >=16*9)and (pixel_row_input<16*10)then
			address_var<= "011111";--  left arrow
			Main_on <= '1';
		elsif (pixel_column_input >=16*24)and (pixel_column_input<16*25) and (pixel_row_input >=16*9)and (pixel_row_input<16*10) then
			address_var<= "110001";  --1
			Main_on <= '1';
		-------------------------------------------------------PRESS PUSH BTN2 TO START---------------
		elsif (pixel_column_input >=16*8)and (pixel_column_input<16*9) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "010000";--P
			Main_on <= '1';
		elsif (pixel_column_input >=16*9)and (pixel_column_input<16*10) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "010010";--R
			Main_on <= '1';
		elsif (pixel_column_input >=16*10)and (pixel_column_input<16*11) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "000101";--E
			Main_on <= '1';
		elsif (pixel_column_input >=16*11)and (pixel_column_input<16*12)  and (pixel_row_input >=16*12)and (pixel_row_input<16*13)then
			address_var<= "010011";--  S
			Main_on <= '1';
		elsif (pixel_column_input >=16*12)and (pixel_column_input<16*13) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "010011";  -- S
			Main_on <= '1';
	
		elsif (pixel_column_input >=16*14)and (pixel_column_input<16*15) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "010000";--P
			Main_on <= '1';
		elsif (pixel_column_input >=16*15)and (pixel_column_input<16*16) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "010101";--U
			Main_on <= '1';
		elsif (pixel_column_input >=16*16)and (pixel_column_input<16*17)  and (pixel_row_input >=16*12)and (pixel_row_input<16*13)then
			address_var<= "010011";--  S
			Main_on <= '1';
		elsif (pixel_column_input >=16*17)and (pixel_column_input<16*18) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "001000";  --H
			Main_on <= '1';
		
			elsif (pixel_column_input >=16*19)and (pixel_column_input<16*20) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "000010";--B
			Main_on <= '1';
		elsif (pixel_column_input >=16*20)and (pixel_column_input<16*21) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "010100";--T
			Main_on <= '1';
		elsif (pixel_column_input >=16*21)and (pixel_column_input<16*22)  and (pixel_row_input >=16*12)and (pixel_row_input<16*13)then
			address_var<= "001110";-- N
			Main_on <= '1';
		elsif (pixel_column_input >=16*22)and (pixel_column_input<16*23) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "110010";  --2
			Main_on <= '1';
			
		elsif (pixel_column_input >=16*24)and (pixel_column_input<16*25)  and (pixel_row_input >=16*12)and (pixel_row_input<16*13)then
			address_var<= "010100";-- T
			Main_on <= '1';
		elsif (pixel_column_input >=16*25)and (pixel_column_input<16*26) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "001111";  --O
			Main_on <= '1';
			
		elsif (pixel_column_input >=16*27)and (pixel_column_input<16*28)  and (pixel_row_input >=16*12)and (pixel_row_input<16*13)then
			address_var<= "010011";-- S
			Main_on <= '1';
		elsif (pixel_column_input >=16*28)and (pixel_column_input<16*29) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "010100";  --T
			Main_on <= '1';
		elsif (pixel_column_input >=16*29)and (pixel_column_input<16*30)  and (pixel_row_input >=16*12)and (pixel_row_input<16*13)then
			address_var<= "000001";-- A
			Main_on <= '1';
		elsif (pixel_column_input >=16*30)and (pixel_column_input<16*31) and (pixel_row_input >=16*12)and (pixel_row_input<16*13) then
			address_var<= "010010";  --R
			Main_on <= '1';
		elsif (pixel_column_input >=16*31)and (pixel_column_input<16*32)  and (pixel_row_input >=16*12)and (pixel_row_input<16*13)then
			address_var<= "010100";-- T
			Main_on <= '1';
	
		else
			address_var<= "100000";--Space for the other situation
			Main_on <= '0';
		end if;
	
end process conversion;





end Architecture menu;