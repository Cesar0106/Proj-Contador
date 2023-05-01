library ieee;
use ieee.std_logic_1164.all;

entity Contador is
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
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector (6 downto 0);
	 FPGA_RESET_N: in std_logic
  );
end entity;


architecture arquitetura of Contador is
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
  
  
  signal dis0 : std_logic_vector (6 downto 0);
  signal dis1 : std_logic_vector (6 downto 0);
  signal dis2 : std_logic_vector (6 downto 0);
  signal dis3 : std_logic_vector (6 downto 0);
  signal dis4 : std_logic_vector (6 downto 0);
  signal dis5 : std_logic_vector (6 downto 0);
  
  signal hab_sw0a7 : std_logic;
  signal hab_sw8 : std_logic;
  signal hab_sw9 : std_logic;
  
  signal hab_key0 : std_logic;
  signal hab_key1 : std_logic;
  signal hab_key2 : std_logic;
  signal hab_key3 : std_logic;
  signal hab_reset : std_logic;
  
  signal saida_deb0 : std_logic;
  signal saida_ff_deb0: std_logic;
  signal limpaLeitura0: std_logic;
  signal saida_deb1 : std_logic;
  signal saida_ff_deb1: std_logic;
  signal limpaLeitura1: std_logic;
  signal saida_deb2 : std_logic;
  signal saida_ff_deb2: std_logic;
  signal limpaLeitura2: std_logic;
  
begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= CLOCK_50;
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


FF1 : entity work.flipflop port map (DIN => saida_reg(0), DOUT => saida_ff1, ENABLE => hab_ff1, CLK => CLK, RST => '0');

FF2 : entity work.flipflop port map (DIN => saida_reg(0), DOUT => saida_ff2, ENABLE => hab_ff2, CLK => CLK, RST => '0');

REG8 : entity work.registradorGenerico  generic map (larguraDados => 8)
          port map (DIN => saida_reg(7 downto 0), DOUT => saida_reg8, ENABLE => hab_reg8, CLK => CLK, RST => '0');

			 
display : entity work.display
             port map (CLK => CLK, data_out => saida_reg (3 downto 0), wr => wr, bloco_4 => saida_dec1(4),
				          data_adr_5 => data_adr(5), endereco => saida_dec2 (5 downto 0), HEX0 => dis0,
							 HEX1 => dis1, HEX2=>dis2, HEX3 => dis3, HEX4 => dis4, HEX5 => dis5);
							 

							 
							 
sw0a7: entity work.buffer_3_state_8portas
            port map (entrada => SW (7 downto 0), habilita => hab_sw0a7, saida => saida_RAM);
				
sw8: entity work.buffer_3_state_8portas
            port map (entrada => "0000000" & SW(8), habilita => hab_sw8, saida => saida_RAM);

sw9: entity work.buffer_3_state_8portas
            port map (entrada => "0000000" & SW(9), habilita => hab_sw9, saida => saida_RAM);
				
				
				
key0: entity work.buffer_3_state_8portas
            port map (entrada => "0000000" & saida_ff_deb0, habilita => hab_key0, saida => saida_RAM);
				
key1: entity work.buffer_3_state_8portas
            port map (entrada => "0000000" & saida_ff_deb1, habilita => hab_key1, saida => saida_RAM);		
		
key2: entity work.buffer_3_state_8portas
            port map (entrada => "0000000" & saida_ff_deb2, habilita => hab_key2, saida => saida_RAM);	
		
key3: entity work.buffer_3_state_8portas
            port map (entrada => "0000000" & KEY(3), habilita => hab_key3, saida => saida_RAM);	
		
key_reset: entity work.buffer_3_state_8portas
            port map (entrada => "0000000" & FPGA_RESET_N, habilita => hab_reset, saida => saida_RAM);	
				
				
				
debounce0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => saida_deb0);
		
ff_debounce0: entity work.flipflop
        port map (DIN => '1', DOUT => saida_ff_deb0, ENABLE => '1', CLK => saida_deb0, RST => limpaLeitura0);

debounce1: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(1)), saida => saida_deb1);
		
ff_debounce1: entity work.flipflop
        port map (DIN => '1', DOUT => saida_ff_deb1, ENABLE => '1', CLK => saida_deb1, RST => limpaLeitura1);
		  
debounce2: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(2)), saida => saida_deb2);
		
ff_debounce2: entity work.flipflop
        port map (DIN => '1', DOUT => saida_ff_deb2, ENABLE => '1', CLK => saida_deb2, RST => limpaLeitura2);
		
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

HEX0 <= dis0;
HEX1 <= dis1;
HEX2 <= dis2;
HEX3 <= dis3;
HEX4 <= dis4;
HEX5 <= dis5;

limpaLeitura0 <= (wr and data_adr(8) and data_adr(7) and data_adr(6) and data_adr(5) and data_adr(4)
                  and data_adr(3) and data_adr(2) and data_adr(1) and data_adr(0));

limpaLeitura1 <= (wr and data_adr(8) and data_adr(7) and data_adr(6) and data_adr(5) and data_adr(4)
                  and data_adr(3) and data_adr(2) and data_adr(1) and (not data_adr(0)));
						
limpaLeitura2 <= (wr and data_adr(8) and data_adr(7) and data_adr(6) and data_adr(5) and data_adr(4)
                  and data_adr(3) and data_adr(2) and (not data_adr(1)) and data_adr(0));

						
						
hab_sw0a7<=(rd and not(data_adr(5)) and saida_dec2(0) and saida_dec1(5));
hab_sw8 <= (rd and not(data_adr(5)) and saida_dec2(1) and saida_dec1(5));
hab_sw9 <= (rd and not(data_adr(5)) and saida_dec2(2) and saida_dec1(5));

hab_key0 <= (rd and data_adr(5) and saida_dec2(0) and saida_dec1(5));
hab_key1 <= (rd and data_adr(5) and saida_dec2(1) and saida_dec1(5));
hab_key2 <= (rd and data_adr(5) and saida_dec2(2) and saida_dec1(5));
hab_key3 <= (rd and data_adr(5) and saida_dec2(3) and saida_dec1(5));
hab_reset <= (rd and data_adr(5) and saida_dec2(4) and saida_dec1(5));

hab_ff1 <= (wr and saida_dec1(4) and saida_dec2(2) and not(data_adr(5)));
hab_ff2 <= (wr and saida_dec1(4) and saida_dec2(1) and not(data_adr(5)));
hab_reg8 <= (wr and saida_dec1(4) and saida_dec2(0) and not(data_adr(5)));



LEDR(9) <= saida_ff1;
LEDR(8) <= saida_ff2;
LEDR(7 downto 0) <= saida_reg8;
end architecture;