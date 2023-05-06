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
			tmp(0) := NOP & "00" & '0' & X"00";	-- SET UP:
			tmp(1) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --ZERANDO O DISPLAY E OS LEDS
			tmp(2) := STA & "00"  & '1' & x"20";	-- STA R0, @288  --HEX0
			tmp(3) := STA  & "00" & '1' & x"21";	-- STA R0, @289  --HEX1
			tmp(4) := STA & "00"  & '1' & x"22";	-- STA R0, @290  --HEX2
			tmp(5) := STA & "00"  & '1' & x"23";  	-- STA R0, @291  --HEX3
			tmp(6) := STA & "00"  & '1' & x"24";	-- STA R0, @292  --HEX4
			tmp(7) := STA & "00"  & '1' & x"25";	-- STA R0, @293  --HEX5
			tmp(8) := STA & "00"  & '1' & x"00";	-- STA R0, @256 --LEDR 0 a 7
			tmp(9) := STA & "00"  & '1' & x"01"; 	-- STA R0, @257 --LEDR 8
			tmp(10):= STA & "00"  & '1' & x"02";	-- STA R0, @258 --LEDR 9
			tmp(11) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --DEFININDO OS ALGARISMOS
			tmp(12) := STA & "00"  & '0' & x"00";	-- STA R0, @0 --UNIDADE			
			tmp(13) := STA & "00" & '0' & x"01";	-- STA R0, @1 --DEZENA		
			tmp(14) := STA & "00"  & '0' & x"02";	-- STA R0, @2 --CENTENA	
			tmp(15) := STA & "00"  & '0' & x"03";	-- STA R0, @3 --MILHAR
			tmp(16) := STA & "00" & '0' & x"04";	-- STA R0, @4 --DEZENAS DE MILHAR
			tmp(17) := STA & "00"  & '0' & x"05";	-- STA R0, @5 --CENTENA DE MILHAR

			tmp(18) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(19) := STA & "00"  & '0' & x"06";	-- STA R0, @6 --FLAG PARA O KEY 0
			tmp(20) := LDI & "00"  & '0' & x"01";	-- LDI R0, $1
			tmp(21) := STA & "00"  & '0' & x"07";	-- STA R0, @7 --GUARDA O VALOR 1 PARA SOMA
			tmp(22) := STA & "00"  & '0' & x"08";	-- STA R0, @8 --FLAG PARA KEYS 1,2 E 3
			tmp(23) := LDI & "00"  & '0' & x"06"; --LDI R0,$6 --GUARDAR O VALOR 6 PARA COMPARAR
			tmp(24) := STA & "00"  & '0' & x"10"; --STA R0,@16
			tmp(25) := LDI & "00"  & '0' & x"0A"; --LDI R0,$10 --GUARDAR O VALOR 10 PARA COMPARAR
			tmp(26) := STA & "00"  & '0' & x"0A"; --STA R0,@10
			tmp(27) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0 --CONTADOR HORA
			tmp(28) := STA & "00"  & '0' & x"1B";	-- STA R0, @27
			tmp(29) := LDI & "00"  & '0' & x"18";	-- LDI R0, $24 --GUARDAR O VALOR 24 
			tmp(30) := STA & "00"  & '0' & x"30";	-- STA R0, @48



-- INICIO:
			tmp(31) := NOP & "00" & '0' & X"00";	-- INICIO:
			tmp(32) := LDA & "00" & '1' & X"61";	-- LDA R0, @353 --KEY1
			tmp(33) := CEQ & "00" & '0' & X"08";	-- CEQ R0, @8
			tmp(34) := JEQ & "00" & '0' & X"79";	-- JEQ R0, @RESET --PULA PARA O RESET
			tmp(35) := LDA & "00" & '1' & X"62";	-- LDA R0,@354 --KEY2
			tmp(36) := CEQ & "00" & '0' & X"08";	-- CEQ R0, @8
			tmp(37) := JEQ & "00" & '0' & X"7C";	-- JEQ R0,SET_MINUTO --PULA PARA O SET_MINUTO
			tmp(38) := LDA & "00"  & '1' & x"63"; --LDA R0,@355 --KEY3
			tmp(39) := CEQ & "00"  & '0' & x"08"; --CEQ R0,@8
			tmp(40) := JEQ & "00"  & '0' & x"95"; --JEQ R0,SET_HORA --PULA PARA O SET_HORA
			tmp(41) := LDA & "00" & '1' & X"60";	-- LDA R0, @352 --KEY0
			tmp(42) := CEQ & "00" & '0' & X"06";	-- CEQ R0, @6 
			tmp(43) := JEQ & "00" & '0' & X"2D";	-- JEQ R0, @PULA1 --PULA PARA PULA1
			tmp(44) := JSR & "00" & '0' & X"30";	-- JSR R0, @INCREMENTA --PULA SUB-ROTINA PARA INCREMENTA


-- PULA1:
			tmp(45) := NOP & "00" & '0' & X"00";	-- PULA1:
			tmp(46) := JSR & "00" & '0' & X"38";	-- JSR R0, @DISPLAY --PULA SUB-ROTINA PARA DISPLAY          
			tmp(47) := JMP & "00" & '0' & X"1F";	-- JMP R0, @INICIO  --PULA PARA O INICIO



-- INCREMENTA:
			tmp(48) := NOP & "00" & '0' & X"00";	-- INCREMENTA:    
			tmp(49) :=  STA & "00"  & '1' & x"FF";	-- STA R0, @511 --LIMPA O KEY 0
			tmp(50) :=  LDA & "00" & '0' & X"00";	-- LDA R0, @0
			tmp(51) := SOMA & "00" & '0' & X"07";	-- SOMA R0, @7
			tmp(52) := STA & "00"  & '0' & x"00";	-- STA R0, @0
			tmp(53) := CEQ & "00"  & '0' & x"0A";	-- CEQ R0, @10
			tmp(54) := JEQ & "00" & '0' & X"46";	-- JEQ R0, @AUMENTA_DEZENA --PULA PARA AUMENTA_DEZENA
			tmp(55) := RET & "00" & '0' & X"00";	-- RET 







-- DISPLAY
			tmp(56) := NOP & "00" & '0' & X"00";	-- DISPLAY:
			tmp(57) := LDA & "00" & '0' & X"00";	-- LDA R0, @0
			tmp(58) := STA & "00" & '1' & X"20";	-- STA R0, @288
			tmp(59) := LDA & "00" & '0' & X"01";	-- LDA R0, @1 
			tmp(60) := STA & "00" & '1' & X"21";	-- STA R0, @289
			tmp(61) := LDA & "00" & '0' & X"02";	-- LDA R0, @2
			tmp(62) := STA & "00" & '1' & X"22";	-- STA R0, @290
			tmp(63) := LDA & "00" & '0' & X"03";	-- LDA R0, @3
			tmp(64) := STA & "00" & '1' & X"23";	-- STA R0, @291
			tmp(65) := LDA & "00" & '0' & X"04";	-- LDA R0, @4
			tmp(66) := STA & "00" & '1' & X"24";	-- STA R0, @292
			tmp(67) := LDA & "00" & '0' & X"05";	-- LDA R0, @5
			tmp(68) := STA & "00" & '1' & X"25";	-- STA R0, @293
			tmp(69) := RET & "00" & '0' & X"00";	-- RET






--AUMENTA_DEZENA
			tmp(70) := NOP & "00" & '0' & X"00";	-- AUMENTA_DEZENA:
			tmp(71) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(72) := STA & "00"  & '0' & x"00";	-- STA R0, @0
			tmp(73) := LDA & "00"  & '0' & x"01";	-- LDA R0, @1 
			tmp(74) := SOMA & "00"  & '0' & x"07";	-- SOMA R0, @7
			tmp(75) := STA & "00"  & '0' & x"01";	-- STA R0, @1
			tmp(76) := CEQ & "00"  & '0' & x"10";	-- CEQ R0, @16
			tmp(77) := JEQ & "00"  & '0' & x"4F";	-- JEQ R0, @AUMENTA_CENTENA --PULA PARA AUMENTA_CENTENA
			tmp(78) := RET & "00" & '0' & X"00";	-- RET




-- AUMENTA_CENTENA
			tmp(79) := NOP & "00" & '0' & X"00";	-- AUMENTA_CENTENA:   
			tmp(80) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(81) := STA & "00"  & '0' & x"01";	-- STA R0, @1
			tmp(82) := LDA & "00"  & '0' & x"02";   -- LDA R0, @2
			tmp(83) := SOMA & "00"  & '0' & x"07";	-- SOMA R0, @7
			tmp(84) := STA & "00"  & '0' & x"02";	-- STA R0, @2
			tmp(85) := CEQ & "00"  & '0' & x"0A";	-- CEQ R0, @10
			tmp(86) := JEQ & "00"  & '0' & x"58";	-- JEQ R0, @AUMENTA_MILHAR --PULA PARA AUMENTA_MILHAR
			tmp(87) := RET & "00" & '0' & X"00";	-- RET

--AUMENTA_MILHAR
			tmp(88) := NOP & "00" & '0' & X"00";	-- AUMENTA_MILHAR:  
			tmp(89) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(90) := STA & "00"  & '0' & x"02";	-- STA R0, @2
			tmp(91) := LDA & "00"  & '0' & x"03";	-- LDA R0, @3
			tmp(92) := SOMA & "00"  & '0' & x"07";	-- SOMA R0, @7
			tmp(93) := STA & "00"  & '0' & x"03";	-- STA R0, @3
			tmp(94) := CEQ & "00"  & '0' & x"10";	-- CEQ R0, @16
			tmp(95) := JEQ & "00"  & '0' & x"61";	-- JEQ R0, @AUMENTA_DEZENA_MILHAR --PULA PARA AUMENTA_DEZENA_MILHAR
			tmp(96) := RET & "00" & '0' & X"00";	-- RET

-- AUMENTA_DEZENA_MILHAR
			tmp(97) := NOP & "00" & '0' & X"00";	-- AUMENTA_DEZENA_MILHAR: 
			tmp(98) := LDA & "00"  & '0' & x"1B";	-- LDA R0, @27
			tmp(99) := SOMA & "00"  & '0' & x"07";	-- SOMA R0, @7
			tmp(100) := STA & "00"  & '0' & x"1B";	-- STA R0, @27
			tmp(101) := CEQ & "00"  & '0' & x"30";	-- CEQ R0, @48                                         
			tmp(102) := JEQ & "00"  & '0' & x"77";	-- JEQ R0, @MEIA_NOITE
			tmp(103) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(104) := STA & "00"  & '0' & x"03";	-- STA R0, @3
			tmp(105) := LDA & "00"  & '0' & x"04";	-- LDA R0, @4
			tmp(106) := SOMA & "00"  & '0' & x"07";	-- SOMA R0, @7
			tmp(107) := STA & "00"  & '0' & x"04";	-- STA R0, @4
			tmp(108) := CEQ & "00"  & '0' & x"0A";	-- CEQ R0, @10
			tmp(109) := JEQ & "00"  & '0' & x"6F";	-- JEQ R0, @AUMENTA_CENTENA_MILHAR --PULA PARA AUMENTA_CENTENA_MILHAR
			tmp(110) := RET & "00" & '0' & X"00";	-- RET


-- AUMENTA_CENTENA_MILHAR
			tmp(111) := NOP & "00" & '0' & X"00";	-- AUMENTA_CENTENA_MILHAR:
			tmp(112) := LDI & "00"  & '0' & x"00";	-- LDI R0, $0
			tmp(113) := STA & "00"  & '0' & x"04";	-- STA R0, @4
			tmp(114) := LDA & "00"  & '0' & x"05";	-- LDA R0, @5
			tmp(115) := SOMA & "00" & '0' & x"07";	-- SOMA R0, @7
			tmp(116) := STA & "00"  & '0' & x"05";	-- STA R0, @5
			tmp(117) := CEQ & "00"  & '0' & x"0A";	-- CEQ R0, @10
			tmp(118) := RET & "00" & '0' & X"00";	-- RET


-- MEIA_NOITE
			tmp(119) := NOP & "00" & '0' & X"00";	-- MEIA_NOITE:
			tmp(120) := JMP & "00"  & '0' & x"00";	-- JMP R0, @SET_UP

--RESET
			tmp(121) := NOP & "00" & '0' & X"00";	-- RESET:
			tmp(122) := STA & "00"  & '1' & x"FE";	-- STA R0, @510 --LIMPA KEY1  
			tmp(123) := JMP & "00"  & '0' & x"00";	-- JMP R0, @SET_UP

--SET_MINUTO
			tmp(124) := NOP & "00" & '0' & X"00";	-- SET_MINUTO:
			tmp(125) := JSR & "00"  & '0' & x"7F"; --JSR R0,SET_MINUTO_CENTENA
			tmp(126) := JMP & "00"  & '0' & x"2D"; --JMP R0,PULA1

-- SET_MINUTO_CENTENA
			tmp(127) := NOP & "00" & '0' & X"00";	-- SET_MINUTO_CENTENA:
			tmp(128) := STA & "00"  & '1' & x"FD"; --STA R0,@509 --LIMPA KEY2
			tmp(129) := LDA & "00"  & '0' & x"02"; --LDA R0,@2
			tmp(130)   := SOMA & "00"  & '0' & x"07"; --SOMA R0,@7
			tmp(131)   := STA & "00"  & '0' & x"02"; --STA R0,@2
			tmp(132)   := CEQ & "00"  & '0' & x"0A"; --CEQ R0,@10
			tmp(133)   := JEQ & "00"  & '0' & x"87"; --JEQ R0,SET_MINUTO_MILHAR --SET_MINUTO_MILHAR
			tmp(134)   := RET & "00" & '0' & X"00";	-- RET

-- SET_MINUTO_MILHAR
			tmp(135) := NOP & "00" & '0' & X"00";	-- SET_MINUTO_MILHAR:
			tmp(136) := LDI & "00"  & '0' & x"00";	--LDI R0,$0
			tmp(137) := STA & "00"  & '0' & x"02"; --STA R0,@2
			tmp(138) := LDA & "00"  & '0' & x"03"; --LDA R0,@3
			tmp(139) := SOMA  & "00"  & '0' & x"07"; --SOMA R0,@7
			tmp(140) := STA & "00"  & '0' & x"03"; --STA R0,@3
			tmp(141) := CEQ & "00"  & '0' & x"10"; --CEQ R0,@16
			tmp(142) := JEQ & "00"  & '0' & x"90"; --JEQ R0,OVERFLOW_MINUTO --PULA PARA OVERFLOW_MINUTO
			tmp(143) := RET & "00" & '0' & X"00";	-- RET


--OVERFLOW_MINUTO_MILHAR
			tmp(144) := NOP & "00" & '0' & X"00";	-- OVERFLOW_MINUTO_MILHAR:
			tmp(145) := LDI & "00"  & '0' & x"00";	--LDI R0,$0
			tmp(146) := STA & "00"  & '0' & x"02"; --STA R0,@2
			tmp(147) := STA & "00"  & '0' & x"03"; --STA R0,@3
			tmp(148) := RET & "00" & '0' & X"00";	-- RET





--SET_HORA:
			tmp(149)   := NOP & "00" & '0' & X"00";	-- SET_HORA: 
			tmp(150)   := JSR & "00"  & '0' & x"98"; --JSR R0,SET_HORA_DEZENA_MILHAR
			tmp(151)   := JMP & "00"  & '0' & x"2D"; --JMP R0,PULA1

			
			
--SET_HORA_DEZENA_MILHAR
			tmp(152) := NOP & "00"  & '0' & X"00";	--SET_HORA_DEZENA_MILHAR:
			tmp(153) := STA & "00"  & '1' & x"FC"; --STA R0,@508 --LIMPA O KEY3
			tmp(154) := LDA & "00"  & '0' & x"1B"; --LDA R0,@27
			tmp(155) := SOMA  & "00"  & '0' & x"07"; --SOMA R0,@7
			tmp(156) := STA & "00"  & '0' & x"1B"; --STA R0,@27
			tmp(157) := CEQ & "00"  & '0' & x"30"; --CEQ R0,@48
			tmp(158) := JEQ & "00"  & '0' & x"AC"; --JEQ R0,OVERFLOW_HORA --PULA PARA OVERFLOW_HORA
			tmp(159) := LDA & "00"  & '0' & x"04"; --LDA R0,@4
			tmp(160) := SOMA  & "00"  & '0' & x"07"; --SOMA R0,@7
			tmp(161) := STA & "00"  & '0' & x"04"; --STA R0,@4
			tmp(162) := CEQ & "00"  & '0' & x"0A"; --CEQ R0,@10
			tmp(163) := JEQ & "00"  & '0' & x"A5"; --JEQ R0,SET_HORA_CENTENA_MILHAR --PULA PARA SET_HORA_CENTENA_MILHAR
			tmp(164) := RET & "00" & '0' & X"00";	-- RET
			
			
			
--SET_HORA_CENTENA_MILHAR
			tmp(165) := NOP & "00" & '0' & X"00";	--SET_HORA_CENTENA_MILHAR:
			tmp(166) := LDI & "00"  & '0' & x"00"; --LDI R0,$0
			tmp(167) := STA & "00"  & '0' & x"04"; --STA R0,@4
			tmp(168) := LDA  & "00"  & '0' & x"05"; --LDA R0,@5
			tmp(169) := SOMA & "00"  & '0' & x"07"; --SOMA R0,@7
			tmp(170) := STA & "00"  & '0' & x"05"; --STA R0,@5
			tmp(171) := RET & "00" & '0' & X"00";	-- RET

			
			
--OVERFLOW_HORA:
			tmp(172) := NOP & "00" & '0' & X"00";	--OVERFLOW_HORA:
			tmp(173) := LDI & "00"  & '0' & x"00"; --LDI R0,$0
			tmp(174) := STA & "00"  & '0' & x"04"; --STA R0,@4
			tmp(175) := STA & "00"  & '0' & x"05"; --STA R0,@5
			tmp(176) := STA & "00"  & '0' & x"1B"; --STA R0,@27
			tmp(177) := RET & "00" & '0' & X"00";	-- RET
		



		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;