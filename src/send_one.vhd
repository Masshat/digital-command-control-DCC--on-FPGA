library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity send_one is
    Port (  start_1 : in  STD_LOGIC;
			reset : in STD_LOGIC;
		    clk : in STD_LOGIC;
            end_1 : out  STD_LOGIC := '0';
            one_out : out  STD_LOGIC := '0');
end send_one;

architecture Behavioral of send_one is
begin

	process(clk,start_1,reset)
	variable enable_one: std_logic := '0';
	variable cpt: integer range 0 to 116 := 0;
	begin
		if (reset='1') then
		end_1 <= '0';
		one_out <= '0';
		cpt := 0;
		enable_one := '0';
		elsif rising_edge(clk) then
		
			if start_1='1' then
				enable_one := '1';
			end if;
	  
			if(enable_one='1') then
				cpt := cpt + 1;
				
				if cpt=58 then
					one_out <= '1';
				elsif cpt=115 then
					end_1 <= '1';
				elsif cpt=116 then
					one_out <= '0';
					end_1 <= '0';
					enable_one := '0';
					cpt := 0;
				end if;
			end if;
		end if;
   end process;
end Behavioral;
