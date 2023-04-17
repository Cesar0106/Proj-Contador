library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logicoDesvio is
    port (
			ent_JMP: in std_logic;
			ent_flag: in std_logic;
			ent_JEQ: in std_logic;
			ent_JSR: in std_logic;
			ent_RET: in std_logic;
			saida: out std_logic_vector (1 downto 0)
	 );
end entity;

architecture comportamento of logicoDesvio is
 begin
		saida <= "01" when (ent_JEQ = '1' and ent_flag = '1') or (ent_JMP = '1') or (ent_JSR = '1') 
		else "10" when (ent_RET = '1') else "00";
	
end architecture;