library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 9
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
		  
		  
	constant NOP  : std_logic_vector(3 downto 0) := "0000";
	constant LDA  : std_logic_vector(3 downto 0) := "0001";
	constant SOMA : std_logic_vector(3 downto 0) := "0010";
	constant SUB  : std_logic_vector(3 downto 0) := "0011";
	constant LDI : std_logic_vector(3 downto 0) :=  "0100";
	constant STA : std_logic_vector(3 downto 0) :=  "0101";
	constant JMP  : std_logic_vector(3 downto 0) := "0110";
	constant JEQ  : std_logic_vector(3 downto 0) := "0111";
	constant CEQ  : std_logic_vector(3 downto 0) := "1000";
	constant JSR  : std_logic_vector(3 downto 0) := "1001";
	constant RET  : std_logic_vector(3 downto 0) := "1010";
  
  begin
      -- Palavra de Controle = SelMUX, Habilita_A, Reset_A, Operacao_ULA
      -- Inicializa os endereços:

        --SET UP
			tmp(0) := "000000000000000";	-- TESTE:
			tmp(1) := "010000000000000";	-- LDI R0, $0 --ZERANDO O DISPLAY E OS LEDS
			tmp(2) := "010100100100000";	-- STA R0, @288  --HEX0
			tmp(3) := "010100100100001";	-- STA R0, @289  --HEX1
			tmp(4) := "010100100100010";	-- STA R0, @290  --HEX2
			tmp(5) := "010100100100011";	-- STA R0, @291  --HEX3
			tmp(6) := "010100100100100";	-- STA R0, @292  --HEX4
			tmp(7) := "010100100100101";	-- STA R0, @293  --HEX5
tmp(8) := "010100100000000";	-- STA R0, @256 --LEDR 0 a 7
tmp(9) := "010100100000001";	-- STA R0, @257 --LEDR 8
tmp(10) := "010100100000010";	-- STA R0, @258 --LEDR 9
tmp(11) := "010000000000000";	-- LDI R0, $0 --DEFININDO A UNIDADE
tmp(12) := "010100000000000";	-- STA R0, @0 --UNIDADE
tmp(13) := "010000000000000";	-- LDI R0, $0 --DEFININDO DEZENA
tmp(14) := "010100000000001";	-- STA R0, @1 --DEZENA
tmp(15) := "010000000000000";	-- LDI R0, $0 --DEFININDO CENTENA
tmp(16) := "010100000000010";	-- STA R0, @2 --CENTENA
tmp(17) := "010000000000000";	-- LDI R0, $0 --DEFININDO MILHAR 
tmp(18) := "010100000000011";	-- STA R0, @3 --MILHAR
tmp(19) := "010000000000000";	-- LDI R0, $0 --DEFININDO DEZENA DE MILHAR
tmp(20) := "010100000000100";	-- STA R0, @4 --DEZENAS DE MILHAR
tmp(21) := "010000000000000";	-- LDI R0, $0 --DEFININDO CENTENA DE MILHAR
tmp(22) := "010100000000101";	-- STA R0, @5 --CENTENA DE MILHAR
tmp(23) := "010000000000000";	-- LDI R0, $0
tmp(24) := "010100000000110";	-- STA R0, @6 --FLAG PARA O KEY 0 E KEY 2
tmp(25) := "010000000000001";	-- LDI R0, $1
tmp(26) := "010100000000111";	-- STA R0, @7 --GUARDA O VALOR 1 PARA SOMA
tmp(27) := "010100000001000";	-- STA R0, @8 --FLAG DO RESET
tmp(28) := "010000000001010";	-- LDI R0, $10 --GUARDAR O VALOR 10 PARA COMPARAR
tmp(29) := "010100000001010";	-- STA R0, @10
tmp(30) := "010000000000110";	-- LDI R0, $6 --GUARDAR O VALOR 6 PARA COMPARAR
tmp(31) := "010100000010000";	-- STA R0, @16
tmp(32) := "010000000000000";	-- LDI R0, $0 --CONTADOR HORA
tmp(33) := "010100000010001";	-- STA R0, @17
tmp(34) := "010000000011000";	-- LDI R0, $24 --GUARDAR O VALOR 24 
tmp(35) := "010100000011000";	-- STA R0, @24
tmp(36) := "000000000000000";	-- INICIO:     
tmp(37) := "000100101100001";	-- LDA R0, @353 --KEY1
tmp(38) := "100000000001000";	-- CEQ R0, @8
tmp(39) := "011100001111000";	-- JEQ R0, @RESET --PULA PARA O RESET
tmp(40) := "000100101100000";	-- LDA R0, @352 --KEY0
tmp(41) := "100000000000110";	-- CEQ R0, @6 
tmp(42) := "011100000101100";	-- JEQ R0, @PULA1 --PULA PARA PULA1
tmp(43) := "100100000101111";	-- JSR R0, @INCREMENTA --PULA SUB-ROTINA PARA INCREMENTA 
tmp(44) := "000000000000000";	-- PULA1:    
tmp(45) := "100100000110111";	-- JSR R0, @DISPLAY --PULA SUB-ROTINA PARA DISPLAY          
tmp(46) := "011000000100100";	-- JMP R0, @INICIO  --PULA PARA O INICIO
tmp(47) := "000000000000000";	-- INCREMENTA:    
tmp(48) := "010100111111111";	-- STA R0, @511 --LIMPA O KEY 0
tmp(49) := "000100000000000";	-- LDA R0, @0
tmp(50) := "001000000000111";	-- SOMA R0, @7
tmp(51) := "010100000000000";	-- STA R0, @0
tmp(52) := "100000000001010";	-- CEQ R0, @10
tmp(53) := "011100001000101";	-- JEQ R0, @AUMENTA_DEZENA --PULA PARA AUMENTA_DEZENA
tmp(54) := "101000000000000";	-- RET 
tmp(55) := "000000000000000";	-- DISPLAY:
tmp(56) := "000100000000000";	-- LDA R0, @0
tmp(57) := "010100100100000";	-- STA R0, @288
tmp(58) := "000100000000001";	-- LDA R0, @1 
tmp(59) := "010100100100001";	-- STA R0, @289
tmp(60) := "000100000000010";	-- LDA R0, @2
tmp(61) := "010100100100010";	-- STA R0, @290
tmp(62) := "000100000000011";	-- LDA R0, @3
tmp(63) := "010100100100011";	-- STA R0, @291
tmp(64) := "000100000000100";	-- LDA R0, @4
tmp(65) := "010100100100100";	-- STA R0, @292
tmp(66) := "000100000000101";	-- LDA R0, @5
tmp(67) := "010100100100101";	-- STA R0, @293
tmp(68) := "101000000000000";	-- RET
tmp(69) := "000000000000000";	-- AUMENTA_DEZENA:
tmp(70) := "010000000000000";	-- LDI R0, $0
tmp(71) := "010100000000000";	-- STA R0, @0
tmp(72) := "000100000000001";	-- LDA R0, @1 
tmp(73) := "001000000000111";	-- SOMA R0, @7
tmp(74) := "010100000000001";	-- STA R0, @1
tmp(75) := "100000000010000";	-- CEQ R0, @16
tmp(76) := "011100001001110";	-- JEQ R0, @AUMENTA_CENTENA --PULA PARA AUMENTA_CENTENA
tmp(77) := "101000000000000";	-- RET
tmp(78) := "000000000000000";	-- AUMENTA_CENTENA:   
tmp(79) := "010000000000000";	-- LDI R0, $0
tmp(80) := "010100000000001";	-- STA R0, @1
tmp(81) := "000100000000010";	-- LDA R0, @2
tmp(82) := "001000000000111";	-- SOMA R0, @7
tmp(83) := "010100000000010";	-- STA R0, @2
tmp(84) := "100000000001010";	-- CEQ R0, @10
tmp(85) := "011100001010111";	-- JEQ R0, @AUMENTA_MILHAR --PULA PARA AUMENTA_MILHAR
tmp(86) := "101000000000000";	-- RET
tmp(87) := "000000000000000";	-- AUMENTA_MILHAR:  
tmp(88) := "010000000000000";	-- LDI R0, $0
tmp(89) := "010100000000010";	-- STA R0, @2
tmp(90) := "000100000000011";	-- LDA R0, @3
tmp(91) := "001000000000111";	-- SOMA R0, @7
tmp(92) := "010100000000011";	-- STA R0, @3
tmp(93) := "100000000010000";	-- CEQ R0, @16
tmp(94) := "011100001100000";	-- JEQ R0, @AUMENTA_DEZENA_MILHAR --PULA PARA AUMENTA_DEZENA_MILHAR
tmp(95) := "101000000000000";	-- RET
tmp(96) := "000000000000000";	-- AUMENTA_DEZENA_MILHAR: 
tmp(97) := "000100000010001";	-- LDA R0, @17
tmp(98) := "001000000000111";	-- SOMA R0, @7
tmp(99) := "010100000010001";	-- STA R0, @17
tmp(100) := "100000000011000";	-- CEQ R0, @24
tmp(101) := "011100001110110";	-- JEQ R0, @MEIA_NOITE
tmp(102) := "010000000000000";	-- LDI R0, $0
tmp(103) := "010100000000011";	-- STA R0, @3
tmp(104) := "000100000000100";	-- LDA R0, @4
tmp(105) := "001000000000111";	-- SOMA R0, @7
tmp(106) := "010100000000100";	-- STA R0, @4
tmp(107) := "100000000001010";	-- CEQ R0, @10
tmp(108) := "011100001101110";	-- JEQ R0, @AUMENTA_CENTENA_MILHAR --PULA PARA AUMENTA_CENTENA_MILHAR
tmp(109) := "101000000000000";	-- RET
tmp(110) := "000000000000000";	-- AUMENTA_CENTENA_MILHAR:
tmp(111) := "010000000000000";	-- LDI R0, $0
tmp(112) := "010100000000100";	-- STA R0, @4
tmp(113) := "000100000000101";	-- LDA R0, @5
tmp(114) := "001000000000111";	-- SOMA R0, @7
tmp(115) := "010100000000101";	-- STA R0, @5
tmp(116) := "100000000001010";	-- CEQ R0, @10
tmp(117) := "101000000000000";	-- RET
tmp(118) := "000000000000000";	-- MEIA_NOITE:
tmp(119) := "011000000000000";	-- JMP R0, @TESTE
tmp(120) := "000000000000000";	-- RESET:
tmp(121) := "010100111111110";	-- STA R0, @510 --LIMPA KEY1  
tmp(122) := "011000000000000";	-- JMP R0, @TESTE

       



		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;