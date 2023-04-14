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
	 SW : in std_logic_vector (9 downto 0);
	 LEDR: out std_logic_vector (9 downto 0);
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector (6 downto 0)
  );
end entity;


architecture arquitetura of Aula7 is
  signal CLK : std_logic;
  signal saida_ROM : std_logic_vector (12 downto 0);
  signal entra_ROM : std_logic_vector (8 downto 0);
  signal saida_RAM : std_logic_vector (7 downto 0);
  signal habilita_ram: std_logic;
  signal wr : std_logic;
  signal rd : std_logic;
  signal data_adr : std_logic_vector (8 downto 0);
  signal saida_reg : std_logic_vector (7 downto 0);
  signal saida_dec1 : std_logic_vector (7 downto 0);
  signal hab_flag : std_logic;
  
  
  
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
          port map (Endereco => entra_ROM, Dado => saida_ROM);
			 
DEC38 :  entity work.decoder3x8
        port map( entrada => data_adr (8 downto 6), saida => saida_dec1);
			 
RAM1 : entity work.memoriaRAM   generic map (dataWidth => 8, addrWidth => 6)
          port map (addr => data_adr (5 downto 0), we => wr, re => rd, habilita  => saida_dec1(0), 
			 dado_in => saida_reg, dado_out => saida_RAM, clk => CLK);
			 
CPU: entity work.CPU
			 port map (WR => wr, RD => rd, rom_adr => entra_ROM, instru_in => saida_ROM, data_adr => data_adr,
			 data_out=> saida_reg, data_in => saida_RAM);


FF1 : entity work.flipflop port map (DIN => dado_, DOUT => saida_flag, ENABLE => hab_flag, CLK => CLK);

FF2 : entity work.flipflop port map (DIN => zero_flag, DOUT => saida_flag, ENABLE => hab_flag, CLK => CLK);



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

end architecture;