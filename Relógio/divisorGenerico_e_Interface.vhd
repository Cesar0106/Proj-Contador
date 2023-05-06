LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity divisorGenerico_e_Interface is
   port(
		clk      :   in std_logic;
      habilitaLeitura : in std_logic;
      limpaLeitura : in std_logic;
      leituraUmSegundo :   out std_logic;
		selMux: in std_logic
   );
end entity;

architecture interface of divisorGenerico_e_Interface is
  signal sinalUmSegundo : std_logic;
  signal saidaclk_reg1seg : std_logic;
  signal saidaclk_regrapido: std_logic;
  signal saida_velocidade: std_logic;
 
  
begin

baseTempo: entity work.divisorGenerico
           generic map (divisor => 25000000)   -- divide por 10.
           port map (clk => clk, saida_clk => saidaclk_reg1seg);
			  
			  
baseRapido: entity work.divisorGenerico
           generic map (divisor => 25000)   -- divide por 10.
           port map (clk => clk, saida_clk => saidaclk_regrapido);
			  

mux_Velocidade: entity work.muxVelocidade
        port map( entradaA_MUX => saidaclk_reg1seg,
                 entradaB_MUX =>  saidaclk_regrapido,
                 seletor_MUX => selMUX,
                 saida_MUX => saida_velocidade);

registraUmSegundo: entity work.flipflop
   port map (DIN => '1', DOUT => sinalUmSegundo,
         ENABLE => '1', CLK => saida_velocidade,
         RST => limpaLeitura);

-- Faz o tristate de saida:
leituraUmSegundo <= sinalUmSegundo when habilitaLeitura = '1' else 'Z';

end architecture interface;