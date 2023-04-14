library ieee;
use ieee.std_logic_1164.all;

entity Aula7 is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
        larguraEnderecos : natural := 9;
        simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
    KEY: in std_logic_vector(3 downto 0);
--    SW: in std_logic_vector(9 downto 0);
   PC_OUT: out std_logic_vector(larguraEnderecos-1 downto 0);
	palavra_controle: out std_logic_vector(11 downto 0);
	LEDR  : out std_logic_vector(9 downto 0)
	--LEDR  : out std_logic_vector(larguraDados-1 downto 0)
  );
end entity;


architecture arquitetura of Aula7 is
  signal CLK : std_logic;
  signal saida_ROM : std_logic_vector (12 downto 0);
  signal saida_RAM : std_logic_vector (7 downto 0);
  signal instru : std_logic_vector (8 downto 0);
  signal habilita_ram: std_logic;
  
  
  
begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY(0);
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
end generate;



-- Falta acertar o conteudo da ROM (no arquivo memoriaROM.vhd)
ROM1 : entity work.memoriaROM   generic map (dataWidth => 13, addrWidth => 9)
          port map (Endereco => Endereco, Dado => instru);
			 
DEC_INSTRUCAO : entity work.decoderInstru   generic map (larguraDados => larguraDados)
          port map (opcode => instru(12 downto 9), saida => Sinais_Controle);
			 
RAM1 : entity work.memoriaRAM   generic map (dataWidth => larguraDados, addrWidth => larguraEnderecos-1)
          port map (addr => instru(5 downto 0), we => Sinais_Controle(0), re => Sinais_Controle(1), 
			 habilita  => instru(8), dado_in => REG1_ULA_A, dado_out => saida_RAM, clk => CLK);
			 
CPU: entity work.CPU generic map (dataWidth => larguraDados, addrWidth => larguraEnderecos-1)
			 port map (rd => RD


habEscritaMEM <= Sinais_Controle(0);
habLeituraMEM <= Sinais_Controle(1);
hab_flag <= Sinais_Controle(2);
Operacao_ULA <= Sinais_Controle(4 downto 3);
Habilita_A <= Sinais_Controle(5);
selMUX <= Sinais_Controle(6);
JEQ <= Sinais_Controle(7);
JSR <= Sinais_Controle(8);
RET <= Sinais_Controle(9);
JMP <= Sinais_Controle(10);
habEscritaRetorno <= Sinais_Controle(11);



-- I/O
--chavesY_MUX_A <= SW(3 downto 0);
--chavesX_ULA_B <= SW(9 downto 6);

-- A ligacao dos LEDs:
--LEDR (9) <= SelMUX;
--LEDR (8) <= Habilita_A;
--LEDR (7) <= Reset_A;
--LEDR (6) <= Operacao_ULA;
--LEDR (5) <= '0';    -- Apagado.
--LEDR (4) <= '0';    -- Apagado.
--LEDR (3 downto 0) <= REG1_ULA_A;

--LEDR(7 downto 0) <= REG1_ULA_A;
--LEDR(9 downto 8) <= Operacao_ULA;
palavra_controle <= Sinais_Controle;

PC_OUT <= Endereco;

end architecture;