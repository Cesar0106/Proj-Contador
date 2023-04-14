library ieee;
use ieee.std_logic_1164.all;

entity muxGenerico4x1 is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8);
  port (
    ent0_MUX, ent1_MUX, ent2_MUX, ent3_MUX : in std_logic_vector((larguraDados-1) downto 0);
    seletor_MUX : in std_logic_vector(1 downto 0);
    saida_MUX : out std_logic_vector((larguraDados-1) downto 0)
  );
end entity;

architecture comportamento of muxGenerico4x1 is
  begin
    saida_MUX <= ent0_MUX when seletor_MUX = "00" else ent1_MUX when seletor_MUX = "01" else ent2_MUX 
					when seletor_mux = "10" else ent3_MUX when seletor_mux = "11";
end architecture;