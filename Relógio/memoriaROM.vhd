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
			tmp(1) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --ZERANDO O DISPLAY E OS LEDS
			tmp(2) := STA & "00"  & '1' & x"20";	-- STA R0, @288  --HEX0
			tmp(3)    := STA  & "00" & '1' & x"21";	-- STA R0, @289  --HEX1
			tmp(4)    := STA & "00"  & '1' & x"22";	-- STA R0, @290  --HEX2
			tmp(5)    := STA & "00"  & '1' & x"23";  	-- STA R0, @291  --HEX3
			tmp(6)    := STA & "00"  & '1' & x"24";	-- STA R0, @292  --HEX4
			tmp(7)  := STA & "00"  & '1' & x"25";	-- STA R0, @293  --HEX5
			tmp(8) := STA & "00"  & '1' & x"00";	-- STA R0, @256 --LEDR 0 a 7
			tmp(9) := STA & "00"  & '1' & x"01"; 	-- STA R0, @257 --LEDR 8
			tmp(10) := STA & "00"  & '1' & x"02";	-- STA R0, @258 --LEDR 9


			tmp(11) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --DEFININDO A UNIDADE
			tmp(12) := STA & "00"  & '0' & x"00";	-- STA R0, @0 --UNIDADE
			tmp(13) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --DEFININDO DEZENA
			tmp(14) := STA & "00" & '0' & x"01";	-- STA R0, @1 --DEZENA
			tmp(15) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --DEFININDO CENTENA
			tmp(16) := STA & "00"  & '0' & x"02";	-- STA R0, @2 --CENTENA
			tmp(17) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --DEFININDO MILHAR 
			tmp(18) := STA & "00"  & '0' & x"03";	-- STA R0, @3 --MILHAR
			tmp(19) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --DEFININDO DEZENA DE MILHAR
			tmp(20) := STA & "00" & '0' & x"04";	-- STA R0, @4 --DEZENAS DE MILHAR
			tmp(21) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --DEFININDO CENTENA DE MILHAR
			tmp(22) := STA & "00"  & '0' & x"05";	-- STA R0, @5 --CENTENA DE MILHAR






			tmp(23) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(24) := STA & "00"  & '0' & x"06";	-- STA R0, @6 --FLAG PARA O KEY 0 E KEY 2


			tmp(25) := LDI & "00"  & '0' & x"01";	-- LDI R0, $1
			tmp(26) := STA & "00"  & '0' & x"07";	-- STA R0, @7 --GUARDA O VALOR 1 PARA SOMA
			tmp(27) := STA & "00"  & '0' & x"08";	-- STA R0, @8 --FLAG DO RESET

			tmp(28) := LDI & "00"  & '0' & x"02"; --LDI R0,$2 --GUARDA O VALOR 2
			tmp(29) := STA & "00"  & '0' & x"20"; --STA R0,@32


			tmp(30) := LDI & "00"  & '0' & x"03"; --LDI R0,$3 --GUARDAR O VALOR 3 PARA COMPARAR
			tmp(31) := STA & "00"  & '0' & x"0D"; --STA R0,@13


			tmp(32) := LDI & "00"  & '0' & x"04"; --LDI R0,$4 --GUARDAR O VALOR 4 PARA COMPARAR
			tmp(33) := STA & "00"  & '0' & x"0E"; --STA R0,@14


			tmp(34) := LDI & "00"  & '0' & x"05"; --LDI R0,$5 --GUARDAR O VALOR 5 PARA COMPARAR
			tmp(35) := STA & "00"  & '0' & x"0F"; --STA R0,@15

			tmp(36) := LDI & "00"  & '0' & x"06"; --LDI R0,$6 --GUARDAR O VALOR 6 PARA COMPARAR
			tmp(37) := STA & "00"  & '0' & x"10"; --STA R0,@16

			tmp(38) := LDI & "00"  & '0' & x"07"; --LDI R0,$7 --GUARDAR O VALOR 7 PARA COMPARAR
			tmp(39) := STA & "00"  & '0' & x"11"; --STA R0,@17


			tmp(40) := LDI & "00"  & '0' & x"08"; --LDI R0,$8 --GUARDAR O VALOR 8 PARA COMPARAR
			tmp(41) := STA & "00"  & '0' & x"12"; --STA R0,@18

			tmp(42) := LDI & "00"  & '0' & x"09"; --LDI R0,$9 --GUARDAR O VALOR 9 PARA COMPARAR
			tmp(43) := STA & "00"  & '0' & x"13"; --STA R0,@19


			tmp(44) := LDI & "00"  & '0' & x"0A"; --LDI R0,$10 --GUARDAR O VALOR 10 PARA COMPARAR
			tmp(45) := STA & "00"  & '0' & x"0A"; --STA R0,@10

			tmp(46) := LDI & "00"  & '0' & x"0B"; --LDI R0,$11 --GUARDAR O VALOR 11 PARA COMPARAR
			tmp(47) := STA & "00"  & '0' & x"15"; --STA R0,@21

			tmp(48) := LDI & "00"  & '0' & x"0C"; --LDI R0,$12 --GUARDAR O VALOR 12 PARA COMPARAR
			tmp(49) := STA & "00"  & '0' & x"16"; --STA R0,@22

			tmp(50) := LDI & "00"  & '0' & x"0D"; --LDI R0,$13 --GUARDAR O VALOR 13 PARA COMPARAR
			tmp(51) := STA & "00"  & '0' & x"17"; --STA R0,@23

			tmp(52) := LDI & "00"  & '0' & x"0E"; --LDI R0,$14 --GUARDAR O VALOR 14 PARA COMPARAR
			tmp(53) := STA & "00"  & '0' & x"18"; --STA R0,@24

			tmp(54) := LDI & "00"  & '0' & x"0F"; --LDI R0,$15 --GUARDAR O VALOR 15 PARA COMPARAR
			tmp(55) := STA & "00"  & '0' & x"19"; --STA R0,@25

			tmp(56) := LDI & "00"  & '0' & x"14"; --LDI R0,$20 --GUARDAR O VALOR 20 PARA COMPARAR
			tmp(57) := STA & "00"  & '0' & x"14"; --STA R0,@20


			tmp(58) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --CONTADOR HORA
			tmp(59) := STA & "00"  & '0' & x"1B";	-- STA R0, @27


			tmp(60) := LDI & "00"  & '0' & x"18";	-- LDI R0, $24 --GUARDAR O VALOR 24 
			tmp(61) := STA & "00"  & '0' & x"30";	-- STA R0, @48

			tmp(62) := LDI & "00"  & '0' & x"00"; -- LDI R0,$0 --SET ALGARISMO
			tmp(63) := STA & "00"  & '0' & x"1E"; -- STA R0,@30 



			tmp(64) := "000000000000000";	-- INICIO:


			tmp(65) := LDA & "00" & '1' & X"61";	-- LDA R0, @353 --KEY1
			tmp(66) := CEQ & "00" & '0' & X"08";	-- CEQ R0, @8
			tmp(67) := JEQ & "00" & '0' & X"97";	-- JEQ R0, @RESET --PULA PARA O RESET

			tmp(68) := LDA & "00" & '1' & X"62";	-- LDA R0,@354 --KEY2
			tmp(69) := CEQ & "00" & '0' & X"08";	-- CEQ R0, @8
			tmp(70) := JEQ & "00" & '0' & X"9A";	-- JEQ R0,SET_TIME --PULA PARA O SET_TIME

			tmp(71) := LDA & "00" & '1' & X"60";	-- LDA R0, @352 --KEY0
			tmp(72) := CEQ & "00" & '0' & X"06";	-- CEQ R0, @6 
			tmp(73) := JEQ & "00" & '0' & X"4B";	-- JEQ R0, @PULA1 --PULA PARA PULA1
			tmp(74) := JSR & "00" & '0' & X"4E";	-- JSR R0, @INCREMENTA --PULA SUB-ROTINA PARA INCREMENTA



			tmp(75) := "000000000000000";	-- PULA1:
			tmp(76) := JSR & "00" & '0' & X"56";	-- JSR R0, @DISPLAY --PULA SUB-ROTINA PARA DISPLAY          
			tmp(77) := JMP & "00" & '0' & X"40";	-- JMP R0, @INICIO  --PULA PARA O INICIO




			tmp(78) := "000000000000000";	-- INCREMENTA:    
			tmp(79) :=  STA & "00"  & '1' & x"FF";	-- STA R0, @511 --LIMPA O KEY 0
			tmp(80) :=  LDA & "00" & '0' & X"00";	-- LDA R0, @0
			tmp(81) := SOMA & "00" & '0' & X"07";	-- SOMA R0, @7
			tmp(82) := STA & "00"  & '0' & x"00";	-- STA R0, @0
			tmp(83) := CEQ & "00"  & '0' & x"0A";	-- CEQ R0, @10
			tmp(84) := JEQ & "00" & '0' & X"64";	-- JEQ R0, @AUMENTA_DEZENA --PULA PARA AUMENTA_DEZENA
			tmp(85) := "101000000000000";	-- RET 








			tmp(86) := "000000000000000";	-- DISPLAY:
			tmp(87) := LDA & "00" & '0' & X"00";	-- LDA R0, @0
			tmp(88) := STA & "00" & '1' & X"20";	-- STA R0, @288
			tmp(89) := LDA & "00" & '0' & X"01";	-- LDA R0, @1 
			tmp(90) := STA & "00" & '1' & X"21";	-- STA R0, @289
			tmp(91) := LDA & "00" & '0' & X"02";	-- LDA R0, @2
			tmp(92) := STA & "00" & '1' & X"22";	-- STA R0, @290
			tmp(93) := LDA & "00" & '0' & X"03";	-- LDA R0, @3
			tmp(94) := STA & "00" & '1' & X"23";	-- STA R0, @291
			tmp(95) := LDA & "00" & '0' & X"04";	-- LDA R0, @4
			tmp(96) := STA & "00" & '1' & X"24";	-- STA R0, @292
			tmp(97) := LDA & "00" & '0' & X"05";	-- LDA R0, @5
			tmp(98) := STA & "00" & '1' & X"25";	-- STA R0, @293
			tmp(99) := "101000000000000";	-- RET







			tmp(100) := "000000000000000";	-- AUMENTA_DEZENA:
			tmp(101) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(102) := STA & "00"  & '0' & x"00";	-- STA R0, @0
			tmp(103) := LDA & "00"  & '0' & x"01";	-- LDA R0, @1 
			tmp(104) := SOMA & "00"  & '0' & x"07";	-- SOMA R0, @7
			tmp(105) := STA & "00"  & '0' & x"01";	-- STA R0, @1
			tmp(106) := CEQ & "00"  & '0' & x"10";	-- CEQ R0, @16
			tmp(107) := JEQ & "00"  & '0' & x"6D";	-- JEQ R0, @AUMENTA_CENTENA --PULA PARA AUMENTA_CENTENA
			tmp(108) := "101000000000000";	-- RET





			tmp(109) := "000000000000000";	-- AUMENTA_CENTENA:   
			tmp(110) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(111) := STA & "00"  & '0' & x"01";	-- STA R0, @1
			tmp(112) := LDA & "00"  & '0' & x"02";   -- LDA R0, @2
			tmp(113) := SOMA & "00"  & '0' & x"07";	-- SOMA R0, @7
			tmp(114) := STA & "00"  & '0' & x"02";	-- STA R0, @2
			tmp(115) := CEQ & "00"  & '0' & x"0A";	-- CEQ R0, @10
			tmp(116) := JEQ & "00"  & '0' & x"76";	-- JEQ R0, @AUMENTA_MILHAR --PULA PARA AUMENTA_MILHAR
			tmp(117) := "101000000000000";	-- RET


			tmp(118) := "000000000000000";	-- AUMENTA_MILHAR:  
			tmp(119) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(120) := STA & "00"  & '0' & x"02";	-- STA R0, @2
			tmp(121) := LDA & "00"  & '0' & x"03";	-- LDA R0, @3
			tmp(122) := SOMA & "00"  & '0' & x"07";	-- SOMA R0, @7
			tmp(123) := STA & "00"  & '0' & x"03";	-- STA R0, @3
			tmp(124) := CEQ & "00"  & '0' & x"10";	-- CEQ R0, @16
			tmp(125) := JEQ & "00"  & '0' & x"7F";	-- JEQ R0, @AUMENTA_DEZENA_MILHAR --PULA PARA AUMENTA_DEZENA_MILHAR
			tmp(126) := "101000000000000";	-- RET


			tmp(127) := "000000000000000";	-- AUMENTA_DEZENA_MILHAR: 
			tmp(128) := LDA & "00"  & '0' & x"1B";	-- LDA R0, @27
			tmp(129) := SOMA & "00"  & '0' & x"07";	-- SOMA R0, @7
			tmp(130) := STA & "00"  & '0' & x"1B";	-- STA R0, @27
			tmp(131) := CEQ & "00"  & '0' & x"30";	-- CEQ R0, @24
			tmp(132) := JEQ & "00"  & '0' & x"95";	-- JEQ R0, @MEIA_NOITE
			tmp(133) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(134) := STA & "00"  & '0' & x"03";	-- STA R0, @3
			tmp(135) := LDA & "00"  & '0' & x"04";	-- LDA R0, @4
			tmp(136) := SOMA & "00"  & '0' & x"07";	-- SOMA R0, @7
			tmp(137) := STA & "00"  & '0' & x"04";	-- STA R0, @4
			tmp(138) := CEQ & "00"  & '0' & x"0A";	-- CEQ R0, @10
			tmp(139) := JEQ & "00"  & '0' & x"8D";	-- JEQ R0, @AUMENTA_CENTENA_MILHAR --PULA PARA AUMENTA_CENTENA_MILHAR
			tmp(140) := "101000000000000";	-- RET


			tmp(141) := "000000000000000";	-- AUMENTA_CENTENA_MILHAR:
			tmp(142) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(143) := STA & "00"  & '0' & x"04";	-- STA R0, @4
			tmp(144) := LDA & "00"  & '0' & x"05";	-- LDA R0, @5
			tmp(145) := SOMA & "00" & '0' & x"07";	-- SOMA R0, @7
			tmp(146) := STA & "00"  & '0' & x"05";	-- STA R0, @5
			tmp(147) := CEQ & "00"  & '0' & x"0A";	-- CEQ R0, @10
			tmp(148) := "101000000000000";	-- RET



			tmp(149) := "000000000000000";	-- MEIA_NOITE:
			tmp(150) := JMP & "00"  & '0' & x"00";	-- JMP R0, @TESTE


			tmp(151) := "000000000000000";	-- RESET:
			tmp(152) := STA & "00"  & '1' & x"FE";	-- STA R0, @510 --LIMPA KEY1  
			tmp(153) := JMP & "00"  & '0' & x"00";	-- JMP R0, @TESTE


			tmp(154) := "000000000000000";	-- SET_TIME:
			tmp(155)   := LDA & "00"  & '0' & x"1E"; --LDA R0,@30
			tmp(156)   := SOMA & "00"  & '0' & x"07"; --SOMA R0,@7
			tmp(157)   := STA & "00"  & '0' & x"1E"; --STA R0,@30

			tmp(158)   := CEQ & "00"  & '0' & x"07"; --CEQ R0,@7
			tmp(159)   := JEQ & "00"  & '0' & x"A6"; --JEQ R0,SET_CENTENA

			tmp(160)   := CEQ & "00"  & '0' & x"20"; --CEQ R0,@32
			tmp(161)   := JEQ & "00"  & '0' & x"BD"; --JEQ R0,SET_MILHAR

			tmp(162)   := CEQ & "00"  & '0' & x"0D"; --CEQ R0,@13
			tmp(163)   := JEQ & "00"  & '0' & x"DC"; --JEQ R0,SET_DEZENA_MILHAR

			tmp(164)   := CEQ & "00"  & '0' & x"0E"; --CEQ R0,@14
			tmp(165)   := JEQ & "00"  & '0' & x"F5"; --JEQ R0,SET_CENTENA_MILHAR




			tmp(166) := "000000000000000";	-- SET_CENTENA:
			tmp(167) := STA & "00"  & '1' & x"FD"; --STA R0,@509 --LIMPA KEY2
			tmp(168) := LDA & "00"  & '1' & x"40"; --LDA R0,@320 -- LEITURA SWITCHES
			tmp(169) := CEQ & "00"  & '0' & x"0A"; --CEQ R0,@10 -- COMPARA 10
			tmp(170) := JEQ & "00"  & '0' & x"B8"; --JEQ R0,VALIDA_CENTENA

			tmp(171) := CEQ & "00"  & '0' & x"15"; --CEQ R0,@21 -- COMPARA 11
			tmp(172) := JEQ & "00"  & '0' & x"B8"; --JEQ R0,VALIDA_CENTENA

			tmp(173) := CEQ & "00"  & '0' & x"16"; --CEQ R0,@22 -- COMPARA 12
			tmp(174) := JEQ & "00"  & '0' & x"B8"; --JEQ R0,VALIDA_CENTENA

			tmp(175) := CEQ & "00"  & '0' & x"17"; --CEQ R0,@23 -- COMPARA 13
			tmp(176) := JEQ & "00"  & '0' & x"B8"; --JEQ R0,VALIDA_CENTENA

			tmp(177) := CEQ & "00"  & '0' & x"18"; --CEQ R0,@24 -- COMPARA 14
			tmp(178) := JEQ & "00"  & '0' & x"B8"; --JEQ R0,VALIDA_CENTENA

			tmp(179) := CEQ & "00"  & '0' & x"19"; --CEQ R0,@25 -- COMPARA 15
			tmp(180) := JEQ & "00"  & '0' & x"B8"; --JEQ R0,VALIDA_CENTENA

			tmp(181) := STA & "00"  & '0' & x"02"; --STA R0,@2
			tmp(182) := JSR & "00"  & '0' & x"56"; --JSR R0,DISPLAY
			tmp(183) := JMP & "00"  & '0' & x"40"; --JMP R0, INICIO


			tmp(184) := "000000000000000";	-- VALIDA_CENTENA:
			tmp(185) := LDI & "00"  & '0' & x"09"; --LDI R0,$9
			tmp(186) := STA & "00"  & '0' & x"02"; --STA R0,@2
			tmp(187) := JSR & "00"  & '0' & x"56"; --JSR R0, DISPLAY
			tmp(188) := JMP & "00"  & '0' & x"40"; --JMP R0, INICIO




			tmp(189) := "000000000000000";	-- SET_MILHAR:
			tmp(190) := STA & "00"  & '1' & x"FD"; --STA R0,@509 --LIMPA KEY2
			tmp(191) := LDA & "00"  & '1' & x"40"; --LDA R0,@320 -- LEITURA SWITCHES
			tmp(192) := CEQ & "00"  & '0' & x"10"; --CEQ R0,@16 -- COMPARA 6
			tmp(193) := JEQ & "00"  & '0' & x"D7"; --JEQ R0,VALIDA_MILHAR

			tmp(194) := CEQ & "00"  & '0' & x"11"; --CEQ R0,@17 -- COMPARA 7
			tmp(195) := JEQ & "00"  & '0' & x"D7"; --JEQ R0,VALIDA_MILHAR

			tmp(196) := CEQ & "00"  & '0' & x"12"; --CEQ R0,@18 -- COMPARA 8
			tmp(197) := JEQ & "00"  & '0' & x"D7"; --JEQ R0,VALIDA_MILHAR

			tmp(198) := CEQ & "00"  & '0' & x"13"; --CEQ R0,@19 -- COMPARA 9
			tmp(199) := JEQ & "00"  & '0' & x"D7"; --JEQ R0,VALIDA_MILHAR

			tmp(200) := CEQ & "00"  & '0' & x"0A"; --CEQ R0,@18 -- COMPARA 10
			tmp(201) := JEQ & "00"  & '0' & x"D7"; --JEQ R0,VALIDA_MILHAR

			tmp(202) := CEQ & "00"  & '0' & x"15"; --CEQ R0,@21 -- COMPARA 11
			tmp(203) := JEQ & "00"  & '0' & x"D7"; --JEQ R0,VALIDA_MILHAR

			tmp(204) := CEQ & "00"  & '0' & x"16"; --CEQ R0,@22 -- COMPARA 12
			tmp(205) := JEQ & "00"  & '0' & x"D7"; --JEQ R0,VALIDA_MILHAR

			tmp(206) := CEQ & "00"  & '0' & x"17"; --CEQ R0,@23 -- COMPARA 13
			tmp(207) := JEQ & "00"  & '0' & x"D7"; --JEQ R0,VALIDA_MILHAR

			tmp(208) := CEQ & "00"  & '0' & x"18"; --CEQ R0,@24 -- COMPARA 14
			tmp(209) := JEQ & "00"  & '0' & x"D7"; --JEQ R0,VALIDA_MILHAR

			tmp(210) := CEQ & "00"  & '0' & x"19"; --CEQ R0,@25 -- COMPARA 15
			tmp(211) := JEQ & "00"  & '0' & x"D7"; --JEQ R0,VALIDA_MILHAR

			tmp(212) := STA & "00"  & '0' & x"03"; --STA R0,@3
			tmp(213) := JSR & "00"  & '0' & x"56"; --JSR R0,DISPLAY
			tmp(214) := JMP & "00"  & '0' & x"40"; --JMP R0, INICIO

			tmp(215) := "000000000000000";	-- VALIDA_MILHAR:
			tmp(216) := LDI & "00"  & '0' & x"06"; --LDI R0,$6
			tmp(217) := STA & "00"  & '0' & x"03"; --STA R0,@3
			tmp(218) := JSR & "00"  & '0' & x"56"; --JSR R0, DISPLAY
			tmp(219) := JMP & "00"  & '0' & x"40"; --JMP R0, INICIO


			tmp(220) := "000000000000000";	-- SET_DEZENA_MILHAR:
			tmp(221) := STA & "00"  & '1' & x"FD"; --LIMPA KEY2
			tmp(222) := LDA & "00"  & '1' & x"40"; --LDA R0,@320 --LEITURA SWITCHES

			tmp(223) := CEQ & "00"  & '0' & x"0A"; --CEQ R0,@10 -- COMPARA 10
			tmp(224) := JEQ & "00"  & '0' & x"EF"; --JEQ R0,VALIDA_DEZENA_MILHAR

			tmp(225) := CEQ & "00"  & '0' & x"15"; --CEQ R0,@21 -- COMPARA 11
			tmp(226) := JEQ & "00"  & '0' & x"EF"; --JEQ R0,VALIDA_DEZENA_MILHAR

			tmp(227) := CEQ & "00"  & '0' & x"16"; --CEQ R0,@22 -- COMPARA 12
			tmp(228) := JEQ & "00"  & '0' & x"EF"; --JEQ R0,VALIDA_DEZENA_MILHAR

			tmp(229) := CEQ & "00"  & '0' & x"17"; --CEQ R0,@23 -- COMPARA 13
			tmp(230) := JEQ & "00"  & '0' & x"EF"; --JEQ R0,VALIDA_DEZENA_MILHAR

			tmp(231) := CEQ & "00"  & '0' & x"18"; --CEQ R0,@24 -- COMPARA 14
			tmp(232) := JEQ & "00"  & '0' & x"EF"; --JEQ R0,VALIDA_DEZENA_MILHAR

			tmp(233) := CEQ & "00"  & '0' & x"19"; --CEQ R0,@25 -- COMPARA 15
			tmp(234) := JEQ & "00"  & '0' & x"EF"; --JEQ R0,VALIDA_DEZENA_MILHAR

			tmp(235) := STA & "00"  & '0' & x"04"; --STA R0,@4
			tmp(236) := STA & "00"  & '0' & x"1B"; --STA R0,@27
			tmp(237) := JSR & "00"  & '0' & x"56"; --JSR R0,DISPLAY
			tmp(238) := JMP & "00"  & '0' & x"40"; --JMP R0, INICIO

			tmp(239) := "000000000000000";	-- VALIDA_DEZENA_MILHAR:
			tmp(240) := LDI & "00"  & '0' & x"09"; --LDI R0,$9
			tmp(241) := STA & "00"  & '0' & x"04"; --STA R0,@4
			tmp(242) := STA & "00"  & '0' & x"1B"; --STA R0,@27
			tmp(243) := JSR & "00"  & '0' & x"56"; --JSR R0, DISPLAY
			tmp(244) := JMP & "00"  & '0' & x"40"; --JMP R0, INICIO



			tmp(245) := "000000000000000";	-- SET_CENTENA_MILHAR:
			tmp(246) := STA & "00"  & '1' & x"FD"; --LIMPA KEY2
			tmp(247) := LDA & "00"  & '1' & x"40"; --LDA R0,@320 --LEITURA SWITCHES

			tmp(248) := CEQ & "00"  & '0' & x"20"; --CEQ R0,@32 -- COMPARA 2
			tmp(249) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(250) := CEQ & "00"  & '0' & x"0D"; --CEQ R0,@13 -- COMPARA 3
			tmp(251) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(252) := CEQ & "00"  & '0' & x"0E"; --CEQ R0,@14 -- COMPARA 4
			tmp(253) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(254) := CEQ & "00"  & '0' & x"0F"; --CEQ R0,@15 -- COMPARA 5
			tmp(255) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(256) := CEQ & "00"  & '0' & x"10"; --CEQ R0,@16 -- COMPARA 6
			tmp(257) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(258) := CEQ & "00"  & '0' & x"11"; --CEQ R0,@17 -- COMPARA 7
			tmp(259) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(260) := CEQ & "00"  & '0' & x"12"; --CEQ R0,@18 -- COMPARA 8
			tmp(261) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(262) := CEQ & "00"  & '0' & x"13"; --CEQ R0,@19 -- COMPARA 9
			tmp(263) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR


			tmp(264) := CEQ & "00"  & '0' & x"0A"; --CEQ R0,@10 -- COMPARA 10
			tmp(265) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(266) := CEQ & "00"  & '0' & x"15"; --CEQ R0,@21 -- COMPARA 11
			tmp(267) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(268) := CEQ & "00"  & '0' & x"16"; --CEQ R0,@22 -- COMPARA 12
			tmp(269) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(270) := CEQ & "00"  & '0' & x"17"; --CEQ R0,@23 -- COMPARA 13
			tmp(271) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(272) := CEQ & "00"  & '0' & x"18"; --CEQ R0,@24 -- COMPARA 14
			tmp(273) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(274) := CEQ & "00"  & '0' & x"19"; --CEQ R0,@25 -- COMPARA 15
			tmp(275) := JEQ & "00"  & '1' & x"1A"; --JEQ R0,VALIDA_CENTENA_MILHAR

			tmp(276) := STA & "00"  & '0' & x"05"; --STA R0,@5
			tmp(277) := LDA & "00"  & '0' & x"0A"; --LDA R0,@10
			tmp(278) := SOMA & "00"  & '0' & x"1B"; --SOMA R0,@27
			tmp(279) := STA & "00"  & '0' & x"1B";  --STA R0,@27
			tmp(280) := JSR & "00"  & '0' & x"56";  --JSR R0,DISPLAY
			tmp(281) := JMP & "00"  & '0' & x"40";  --JMP R0, INICIO

			tmp(282) := "000000000000000";	-- VALIDA_CENTENA_MILHAR:
			tmp(283) := LDI & "00"  & '0' & x"02"; --LDI R0,$2
			tmp(284) := STA & "00"  & '0' & x"05"; --STA R0,@5
			tmp(285) := LDA & "00"  & '0' & x"14"; --LDA R0,@20
			tmp(286) := SOMA & "00"  & '0' & x"1B"; --SOMA R0,@27
			tmp(287) := STA & "00"  & '0' & x"1B"; --STA R0,@27
			tmp(288) := JSR & "00"  & '0' & x"56";  --JSR R0,DISPLAY
			tmp(289) := JMP & "00"  & '0' & x"40";  --JMP R0, INICIO



       



		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;