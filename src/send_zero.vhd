library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity send_zero is
    Port (  start_0 : in  STD_LOGIC;
			reset : in std_logic;
		    clk : in STD_LOGIC;
            end_0 : out  STD_LOGIC := '0';
            zero_out : out  STD_LOGIC := '0');
end send_zero;

architecture Behavioral of send_zero is
begin
	process(clk,start_0, reset)
	variable enable_zero: std_logic := '0';
	variable cpt: integer range 0 to 201:= 0;
	begin
	if (reset='1') then
		end_0 <= '0';
		zero_out <= '0';
		cpt := 0;
		enable_zero := '0';
		
	elsif rising_edge(clk)  then
		if start_0='1' then
				enable_zero := '1';
		end if;
			
	  if(enable_zero='1' ) then
		 cpt := cpt + 1;
	    if cpt=100 then
	      zero_out <= '1';
		 elsif cpt=200 then
			end_0 <= '1';
			elsif cpt= 201 then
			end_0 <= '0';
			cpt := 0;
			zero_out <= '0';
			enable_zero := '0';
			end if;
		end if;
	  end if;
   end process;
end Behavioral;
