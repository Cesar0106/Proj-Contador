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
	 HEX0: out std_logic_vector (6 downto 0)
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
  signal saida_dec2 : std_logic_vector (7 downto 0);
  signal hab_flag : std_logic;
  signal saida_ff1 : std_logic;
  signal hab_ff1 : std_logic;
  signal saida_ff2 : std_logic;
  signal hab_ff2 : std_logic;
  signal saida_reg8 : std_logic_vector (7 downto 0);
  signal hab_reg8 : std_logic;
  signal conta: std_logic_vector(6 downto 0);
  
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
			 
DEC1 :  entity work.decoder3x8
        port map( entrada => data_adr (8 downto 6), saida => saida_dec1);
		  
DEC2 :  entity work.decoder3x8
        port map( entrada => data_adr (2 downto 0), saida => saida_dec2);
			 
RAM1 : entity work.memoriaRAM   generic map (dataWidth => 8, addrWidth => 6)
          port map (addr => data_adr (5 downto 0), we => wr, re => rd, habilita  => saida_dec1(0), 
			 dado_in => saida_reg, dado_out => saida_RAM, clk => CLK);
			 
CPU: entity work.CPU
			 port map (WR => wr, RD => rd, rom_adr => entra_ROM, instru_in => saida_ROM, data_adr => data_adr,
			 data_out=> saida_reg, data_in => saida_RAM, clock => CLK);


FF1 : entity work.flipflop port map (DIN => saida_reg(0), DOUT => saida_ff1, ENABLE => hab_ff1, CLK => CLK);

FF2 : entity work.flipflop port map (DIN => saida_reg(0), DOUT => saida_ff2, ENABLE => hab_ff2, CLK => CLK);

REG8 : entity work.registradorGenerico  generic map (larguraDados => 8)
          port map (DIN => saida_reg(7 downto 0), DOUT => saida_reg8, ENABLE => hab_reg8, CLK => CLK, RST => '0');

			 
display0 :  entity work.conversorHex7Seg
        port map(dadoHex => entra_ROM(3 downto 0),
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => conta);			 

HEX0 <= conta;

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



hab_ff1 <= (wr and saida_dec1(4) and saida_dec2(2));
hab_ff2 <= (wr and saida_dec1(4) and saida_dec2(1));
hab_reg8 <= (wr and saida_dec1(4) and saida_dec2(0));

LEDR(9) <= saida_ff1;
LEDR(8) <= saida_ff2;
LEDR(7 downto 0) <= saida_reg8;
end architecture;