     library ieee;
use ieee.std_logic_1164.all;

entity CPU is

  port   (
    WR: out std_logic;
	 RD: out std_logic;
	 rom_adr: out std_logic_vector(8 downto 0);
	 instru_in: in std_logic_vector(14 downto 0);
    data_adr: out std_logic_vector(8 downto 0);
	 data_out: out std_logic_vector(7 downto 0);
	 data_in: in std_logic_vector(7 downto 0);
	 clock: in std_logic
  );
end entity;


architecture arquitetura of CPU is

-- Faltam alguns sinais:
signal saida_MUX_ULA : std_logic_vector (7 downto 0);
  signal chavesY_MUX_A : std_logic_vector (7 downto 0);
  signal MUX_REG1 : std_logic_vector (7 downto 0);
  signal saida_reg_mem : std_logic_vector (7 downto 0);
  signal Saida_ULA : std_logic_vector (7 downto 0);
  signal Sinais_Controle : std_logic_vector (11 downto 0);
  signal Endereco : std_logic_vector (8 downto 0);
  signal proxPC : std_logic_vector (8 downto 0);
  signal Chave_Operacao_ULA : std_logic;
  signal CLK : std_logic;
  signal SelMUX : std_logic;
  signal Habilita_Reg : std_logic;
-- signal habEscritaMEM : std_logic;
--  signal habLeituraMEM : std_logic;
--  signal Reset_A : std_logic;
  signal Operacao_ULA : STD_LOGIC_VECTOR(1 downto 0);
  signal saida_ROM : std_logic_vector (12 downto 0);
  signal saida_decoder : std_logic_vector (5 downto 0);
  signal saida_RAM : std_logic_vector (7 downto 0);
  signal instru : std_logic_vector (12 downto 0);
  signal PC_MUX : std_logic_vector (8 downto 0);
  signal JMP : std_logic;
  signal zero_flag : std_logic;
  signal saida_flag : std_logic;
  signal hab_flag : std_logic;
  signal saida_desvio : std_logic_vector (1 downto 0);
  signal JEQ : std_logic;
  signal saida_retorno :  std_logic_vector (8 downto 0);
  signal habEscritaRetorno :  std_logic;
  signal JSR : std_logic;
  signal RET : std_logic;
  
  
  
  
begin

-- Instanciando os componentes:
CLK <= clock;
-- Para simular, fica mais simples tirar o edgeDetector


-- O port map completo do MUX.
MUX_ULA :  entity work.muxGenerico2x1  generic map (larguraDados => 8)
        port map( entradaA_MUX => data_in,
                 entradaB_MUX =>  instru_in(7 downto 0),
                 seletor_MUX => SelMUX,
                 saida_MUX => saida_MUX_ULA);



-- O port map completo do Program Counter.
PC : entity work.registradorGenerico   generic map (larguraDados => 9)
          port map (DIN => PC_MUX, DOUT => Endereco, ENABLE => '1', CLK => CLK, RST => '0');

incrementaPC :  entity work.somaConstante  generic map (larguraDados => 9, constante => 1)
        port map( entrada => Endereco, saida => proxPC);


-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => 8)
          port map (entradaA => saida_reg_mem, entradaB => saida_MUX_ULA, saida => Saida_ULA, zero => zero_flag, seletor => Operacao_ULA);

-- Falta acertar o conteudo da ROM (no arquivo memoriaROM.vhd)
			 
DEC_INSTRUCAO : entity work.decoderInstru 
          port map (opcode => instru_in(14 downto 11), saida => Sinais_Controle);

			 
MUX_PC :  entity work.muxGenerico4x1  generic map (larguraDados => 9)
        port map( ent0_MUX => proxPC,
                 ent1_MUX =>  instru_in(8 downto 0),
					  ent2_MUX => saida_retorno,
					  ent3_MUX => "000000000",
                 seletor_MUX => saida_desvio,
                 saida_MUX => PC_MUX);

FLAG_IGUAL : entity work.flipflop port map (DIN => zero_flag, DOUT => saida_flag, ENABLE => hab_flag, CLK => CLK, RST => '0');

DESVIO : entity work.logicoDesvio port map( ent_JMP => JMP, ent_flag  => saida_flag, ent_JEQ => JEQ,  
															ent_JSR => JSR, ent_RET => RET, saida => saida_desvio); 

REG_RETORNO : entity work.registradorGenerico   generic map (larguraDados => 9)
          port map (DIN => proxPC, DOUT => saida_retorno, ENABLE => habEscritaRetorno, CLK => CLK, RST => '0');
			 
			 
RegMem : entity work.bancoRegistradoresArqRegMem   generic map (larguraDados => 8, larguraEndBancoRegs => 2)
          port map ( clk => CLK,
              endereco => instru_in(10 downto 9),
              dadoEscrita => Saida_ULA,
              habilitaEscrita => Habilita_Reg,
              saida  => saida_reg_mem);			 
			 


rom_adr <= Endereco;

data_adr <= instru_in (8 downto 0);

data_out <= saida_reg_mem;

WR <= Sinais_Controle(0);
RD <= Sinais_Controle(1);
hab_flag <= Sinais_Controle(2);
Operacao_ULA <= Sinais_Controle(4 downto 3);
Habilita_Reg <= Sinais_Controle(5);
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
-- palavra_controle <= Sinais_Controle;

--PC_OUT <= Endereco;

end architecture;