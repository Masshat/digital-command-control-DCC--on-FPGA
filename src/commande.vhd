library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity commande is
port(	Clk : in std_logic;
		reset : in std_logic;
		C : in std_logic;
		Go : out std_logic;
		Consigne :out std_logic_vector(15 downto 0)
);
end commande;

architecture Behavioral of commande is
signal C_enable : std_logic ;

constant valeur: std_logic_vector(15 downto 0):= "0101111100000101"; -- vitesse max pour le train 5


begin

process (Clk,reset,C)
begin
	if (reset='1') then
		Go <='0';
	else
		Go <=C;
		Consigne <= valeur;--"0001111100000101";

	end if;

end process;

end Behavioral;
