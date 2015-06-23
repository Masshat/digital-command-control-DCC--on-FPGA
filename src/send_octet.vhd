library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity send_octet is
Port (  start_b : in  STD_LOGIC;
		reset : in std_logic;
		byte : in std_logic_vector(7 downto 0);
		clk : in STD_LOGIC;
        end_b : out  STD_LOGIC := '0';
        out_octet : out  STD_LOGIC := '0');
			  
end send_octet;

architecture Behavioral of send_octet is

signal temp: std_logic_vector (7 downto 0);

begin

process(clk,start_b,reset)
   variable enable_b : std_logic := '0';
	variable cpt: integer range 0 to 201 := 0;
	variable cpt_bits: integer range 0 to 8:= 0;
	begin
	if (reset='1') then
		end_b <= '0';
		out_octet <= '0';
		cpt := 0;
		enable_b := '0';
		cpt_bits := 0;
	elsif rising_edge(clk) then 
			if start_b='1' then 
				temp <= byte;
				enable_b := '1';
			end if;
	  
			if enable_b='1' then
				cpt := cpt + 1;
				if (cpt=58 and temp(7)='1') or (cpt=100 and temp(7)='0') then
					out_octet <= '1';
				elsif (cpt=116 and temp(7)='1') or (cpt=200 and temp(7)='0') then
					out_octet <= '0';
					cpt_bits := cpt_bits + 1;
					if cpt_bits=8 then
						end_b <='1';
					else
						temp<= temp(6 downto 0) & '0';
						cpt := 0;
					end if;
				elsif (cpt=117 and temp(7)='1') or (cpt=201 and temp(7)='0') then
					end_b <='0';
					enable_b := '0';
					cpt_bits := 0;
					cpt := 0;
				end if;
			end if;
		end if;
   end process;
end Behavioral;
