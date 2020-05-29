----------------
--This file is the game scene text generator of Intercept Pong Game
----------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.NUMERIC_STD.ALL;

ENTITY char_gen IS
	PORT
	(
		clock				: 	IN STD_LOGIC ;
		pixel_row_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		pixel_column_input : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		Score_input     : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Time_input      : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Level_input		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		mode				: IN STD_LOGIC;
		character_address_output	:	OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row_output, font_col_output	:	OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
		
		);
END ENTITY char_gen;

Architecture beh of char_gen is 
--signals for score time level display
signal address_var,address_hundred_score,address_hundred_time,address_ten_score,address_ten_time,address_one_score,address_one_time, address_level : STD_LOGIC_VECTOR (5 DOWNTO 0);
signal int_score,int_time,int_hundred_score,int_ten_score,int_one_score,int_hundred_time,int_ten_time,int_one_time :  integer:=1;

begin


--seperate each digit of score
int_score <= to_integer(unsigned(score_input));
int_hundred_score <= int_score/100;
int_ten_score <= (int_score - int_hundred_score * 100)/10;
int_one_score <= int_score - int_hundred_score * 100 - int_ten_score*10;


--seperate each digit of time
int_time <= to_integer(unsigned(Time_input));
int_hundred_time <= int_time/100;
int_ten_time <= (int_time - int_hundred_time * 100)/10;
int_one_time <= int_time - int_hundred_time * 100 - int_ten_time*10;

--convertion for X00 of score
with int_hundred_score select address_hundred_score<=
				"110000" when 0,
				"110001" when 1,
				"110010" when 2,
				"110011" when 3,
				"110100" when 4,
				"110101" when 5,
				"110110" when 6,
				"110111" when 7,
				"111000" when 8,
				"111001" when 9,
				"100000" when others;
				
--convertion for 0X0 of score
with int_ten_score select address_ten_score<=
				"110000" when 0,
				"110001" when 1,
				"110010" when 2,
				"110011" when 3,
				"110100" when 4,
				"110101" when 5,
				"110110" when 6,
				"110111" when 7,
				"111000" when 8,
				"111001" when 9,
				"100000" when others;
				
--convertion for 00X of score
with int_one_score select address_one_score<=
				"110000" when 0,
				"110001" when 1,
				"110010" when 2,
				"110011" when 3,
				"110100" when 4,
				"110101" when 5,
				"110110" when 6,
				"110111" when 7,
				"111000" when 8,
				"111001" when 9,
				"100000" when others;
--convertion for X00 of time			
with int_hundred_time select address_hundred_time<=
				"110000" when 0,
				"110001" when 1,
				"110010" when 2,
				"110011" when 3,
				"110100" when 4,
				"110101" when 5,
				"110110" when 6,
				"110111" when 7,
				"111000" when 8,
				"111001" when 9,
				"100000" when others;
--convertion for 0X0 of time				
with int_ten_time select address_ten_time<=
				"110000" when 0,
				"110001" when 1,
				"110010" when 2,
				"110011" when 3,
				"110100" when 4,
				"110101" when 5,
				"110110" when 6,
				"110111" when 7,
				"111000" when 8,
				"111001" when 9,
				"100000" when others;
--convertion for 00X of time				
with int_one_time select address_one_time<=
				"110000" when 0,
				"110001" when 1,
				"110010" when 2,
				"110011" when 3,
				"110100" when 4,
				"110101" when 5,
				"110110" when 6,
				"110111" when 7,
				"111000" when 8,
				"111001" when 9,
				"100000" when others;
--convertion for X of level			
with level_input select address_level<=
				"110000" when "000",
				"110001" when "001",
				"110010" when "010",
				"110011" when "011",
				"110100" when "100",
				"110100" when others;

conversion: process( pixel_column_input,pixel_row_input,mode)
begin

   --------------------------------------------------------------------------------------------------------------------
	--Score Display
	--------------------------------------------------------------------------------------------------------------------
	if (pixel_column_input >=16)and (pixel_column_input<32)and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= "010011";
	--Display S 
	elsif ((pixel_column_input >=32)and (pixel_column_input<48))and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= "000011";
	--Display C
	elsif ((pixel_column_input >=48)and (pixel_column_input<64))and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= "001111";
	--Display O
	elsif ((pixel_column_input >=64)and (pixel_column_input<80))and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= "010010";
	--Display R
	elsif ((pixel_column_input >=80)and (pixel_column_input<96))and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= "000101";
	--Display E
	--------------------------------------------------------------------------------------------------------------------
	--Dynamic numbers of the score or displaying Training Mode
	--------------------------------------------------------------------------------------------------------------------
	elsif ((pixel_column_input >=112)and (pixel_column_input<128))and (pixel_row_input >=16)and (pixel_row_input<32) then
	--SCORE X00
	address_var <= address_hundred_score;
	-- 
	elsif ((pixel_column_input >=128)and (pixel_column_input<144))and (pixel_row_input >=16)and (pixel_row_input<32) then
	--SCORE 0X0
	address_var <= address_ten_score;
	elsif ((pixel_column_input >=144)and (pixel_column_input<160))and (pixel_row_input >=16)and (pixel_row_input<32) then
	--SCORE 00X
	address_var <= address_one_score;
	
	---------------------------------------------------------------------------------------------------------------------
	--Time display / Training
	---------------------------------------------------------------------------------------------------------------------

	elsif ((pixel_column_input >=286)and (pixel_column_input<302))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '1' then
	--Time X00
	address_var <= address_hundred_time;
	elsif ((pixel_column_input >=302)and (pixel_column_input<318))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '1' then
	--Time 0X0
	address_var <= address_ten_time;	
	elsif ((pixel_column_input >=318)and (pixel_column_input<334))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '1' then
	--TIme 00X
	address_var <= address_one_time;
	
		elsif ((pixel_column_input >=16*16)and (pixel_column_input<16*17))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '0' then
	--Display T
	address_var <= "010100";
	elsif ((pixel_column_input >=16*17)and (pixel_column_input<16*18))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '0' then
	--Display R
	address_var <= "010010";
	elsif ((pixel_column_input >=16*18)and (pixel_column_input<16*19))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '0' then
	--Display A
	address_var <= "000001";
	elsif ((pixel_column_input >=16*19)and (pixel_column_input<16*20))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '0' then
	--Display I
	address_var <= "001001";
	elsif ((pixel_column_input >=16*20)and (pixel_column_input<16*21))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '0' then
	--Display N
	address_var <= "001110";
	elsif ((pixel_column_input >=16*21)and (pixel_column_input<16*22))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '0' then
	--Display I
	address_var <= "001001";
	elsif ((pixel_column_input >=16*22)and (pixel_column_input<16*23))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '0' then
	--Display N
	address_var <= "001110";
	elsif ((pixel_column_input >=16*23)and (pixel_column_input<16*24))and (pixel_row_input >=16)and (pixel_row_input<32) and mode = '0' then
	--Display G
	address_var <= "000111";

	
	---------------------------------------------------------------------------------------------------------------------
	--Level display
	---------------------------------------------------------------------------------------------------------------------
	elsif (pixel_column_input >=512)and (pixel_column_input<528)and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= "001100";
	--Display L
	elsif ((pixel_column_input >=528)and (pixel_column_input<544))and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= "000101";
	--Display E
	elsif ((pixel_column_input >=544)and (pixel_column_input<560))and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= "010110";
	--Display V
	elsif ((pixel_column_input >=560)and (pixel_column_input<576))and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= "000101";
	--Display E
	elsif ((pixel_column_input >=576)and (pixel_column_input<592))and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= "001100";
	--Display L
	elsif ((pixel_column_input >=608)and (pixel_column_input<624))and (pixel_row_input >=16)and (pixel_row_input<32) then
	address_var<= address_level;
	--Display Level "X"
	--End Level display
	
	else
	address_var<= "100000";--Space for the other situation
	end if;
	
end process conversion;


--assign to Output
character_address_output <= address_var;
font_col_output <= pixel_column_input(3 DOWNTO 1);
font_row_output <= pixel_row_input(3 DOWNTO 1);

end Architecture beh;