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
        tmp(0) := NOP & "00" & '0' & x"00";	-- 
        tmp(1) := LDI & "00" & '0' & x"00";	-- ZERANDO O DISPLAY E OS LEDS
        tmp(2) := STA & "00" & '1' & x"20";	-- HEX0
        tmp(3) := STA & "00" & '1' & x"21";	-- HEX1
        tmp(4) := STA & "00" & '1' & x"22";	-- HEX2
        tmp(5) := STA & "00" & '1' & x"23";	-- HEX3
        tmp(6) := STA & "00" & '1' & x"24";	-- HEX4
        tmp(7) := STA & "00" & '1' & x"25";	-- HEX5
        tmp(8) := STA & "00" & '1' & x"00";	-- LEDR 0 a 7
        tmp(9) := STA & "00" & '1' & x"01";	-- LEDR 8
        tmp(10) := STA & "00" & '1' & x"02";	-- LEDR 9
        tmp(11) := LDI & "00" & '0' & x"00";	-- DEFININDO OS ALGARISMOS
        tmp(12) := STA & "00" & '0' & x"00";	-- UNIDADE
        tmp(13) := STA & "00" & '0' & x"01";	-- DEZENA
        tmp(14) := STA & "00" & '0' & x"02";	-- CENTENA
        tmp(15) := STA & "00" & '0' & x"03";	-- MILHAR
        tmp(16) := STA & "00" & '0' & x"04";	-- DEZENAS DE MILHAR
        tmp(17) := STA & "00" & '0' & x"05";	-- CENTENA DE MILHAR
        tmp(18) := LDI & "00" & '0' & x"00";	-- 
        tmp(19) := STA & "00" & '0' & x"06";	-- FLAG PARA O KEY 0
        tmp(20) := LDI & "00" & '0' & x"01";	-- 
        tmp(21) := STA & "00" & '0' & x"07";	-- GUARDA O VALOR 1 PARA SOMA
        tmp(22) := STA & "00" & '0' & x"08";	-- FLAG DO RESET
        tmp(23) := LDI & "00" & '0' & x"06";	-- GUARDAR O VALOR 6 PARA COMPARAR
        tmp(24) := STA & "00" & '0' & x"10";	-- 
        tmp(25) := LDI & "00" & '0' & x"0A";	-- GUARDAR O VALOR 10 PARA COMPARAR
        tmp(26) := STA & "00" & '0' & x"0A";	-- 
        tmp(27) := LDI & "00" & '0' & x"00";	-- CONTADOR HORA
        tmp(28) := STA & "00" & '0' & x"1B";	-- 
        tmp(29) := LDI & "00" & '0' & x"18";	-- GUARDAR O VALOR 24
        tmp(30) := STA & "00" & '0' & x"30";	-- 

--INICIO
        tmp(31) := NOP & "00" & '0' & x"00";	-- INICIO
        tmp(32) := LDA & "01" & '1' & x"61";	-- KEY1
        tmp(33) := CEQ & "01" & '0' & x"08";	-- 
        tmp(34) := JEQ & "01" & '0' & x"79";	-- PULA PARA O RESET
        tmp(35) := LDA & "01" & '1' & x"62";	-- KEY2
        tmp(36) := CEQ & "01" & '0' & x"08";	-- 
        tmp(37) := JEQ & "01" & '0' & x"7C";	-- PULA PARA O SET_MINUTO
        tmp(38) := LDA & "01" & '1' & x"63";	-- KEY3
        tmp(39) := CEQ & "01" & '0' & x"08";	-- 
        tmp(40) := JEQ & "01" & '0' & x"95";	-- PULA PARA O SET_HORA
        tmp(41) := LDA & "01" & '1' & x"60";	-- KEY0
        tmp(42) := CEQ & "01" & '0' & x"06";	-- 
        tmp(43) := JEQ & "01" & '0' & x"2D";	-- PULA PARA PULA1
        tmp(44) := JSR & "01" & '0' & x"30";	-- PULA SUB-ROTINA PARA INCREMENTA

--PULA1        
        tmp(45) := NOP & "00" & '0' & x"00";	-- PULA1
        tmp(46) := JSR & "01" & '0' & x"38";	-- PULA SUB-ROTINA PARA DISPLAY
        tmp(47) := JMP & "01" & '0' & x"1F";	-- PULA PARA O INICIO

--INCREMENTA
        tmp(48) := NOP & "00" & '0' & x"00";	-- INCREMENTA
        tmp(49) := STA & "10" & '1' & x"FF";	-- LIMPA O KEY 0
        tmp(50) := LDA & "10" & '0' & x"00";	-- 
        tmp(51) := SOMA & "10" & '0' & x"07";	-- 
        tmp(52) := STA & "10" & '0' & x"00";	-- 
        tmp(53) := CEQ & "10" & '0' & x"0A";	-- 
        tmp(54) := JEQ & "10" & '0' & x"46";	-- PULA PARA AUMENTA_DEZENA
        tmp(55) := RET & "00" & '0' & x"00";	-- 

--DISPLAY
        tmp(56) := NOP & "00" & '0' & x"00";	-- DISPLAY
        tmp(57) := LDA & "00" & '0' & x"00";	-- 
        tmp(58) := STA & "00" & '1' & x"20";	-- 
        tmp(59) := LDA & "00" & '0' & x"01";	-- 
        tmp(60) := STA & "00" & '1' & x"21";	-- 
        tmp(61) := LDA & "00" & '0' & x"02";	-- 
        tmp(62) := STA & "00" & '1' & x"22";	-- 
        tmp(63) := LDA & "00" & '0' & x"03";	-- 
        tmp(64) := STA & "00" & '1' & x"23";	-- 
        tmp(65) := LDA & "00" & '0' & x"04";	-- 
        tmp(66) := STA & "00" & '1' & x"24";	-- 
        tmp(67) := LDA & "00" & '0' & x"05";	-- 
        tmp(68) := STA & "00" & '1' & x"25";	-- 
        tmp(69) := RET & "00" & '0' & x"00";	-- 

--AUMENTA_DEZENA
        tmp(70) := NOP & "00" & '0' & x"00";	-- AUMENTA_DEZENA
        tmp(71) := LDI & "10" & '0' & x"00";	-- 
        tmp(72) := STA & "10" & '0' & x"00";	-- 
        tmp(73) := LDA & "10" & '0' & x"01";	-- 
        tmp(74) := SOMA & "10" & '0' & x"07";	-- 
        tmp(75) := STA & "10" & '0' & x"01";	-- 
        tmp(76) := CEQ & "10" & '0' & x"10";	-- 
        tmp(77) := JEQ & "10" & '0' & x"4F";	-- PULA PARA AUMENTA_CENTENA
        tmp(78) := RET & "00" & '0' & x"00";	-- 

--AUMENTA_CENTENA
        tmp(79) := NOP & "00" & '0' & x"00";	-- AUMENTA_CENTENA
        tmp(80) := LDI & "10" & '0' & x"00";	-- 
        tmp(81) := STA & "10" & '0' & x"01";	-- 
        tmp(82) := LDA & "10" & '0' & x"02";	-- 
        tmp(83) := SOMA & "10" & '0' & x"07";	-- 
        tmp(84) := STA & "10" & '0' & x"02";	-- 
        tmp(85) := CEQ & "10" & '0' & x"0A";	-- 
        tmp(86) := JEQ & "10" & '0' & x"58";	-- PULA PARA AUMENTA_MILHAR
        tmp(87) := RET & "00" & '0' & x"00";	-- 

--AUMENTA_MILHAR
        tmp(88) := NOP & "00" & '0' & x"00";	-- AUMENTA_MILHAR
        tmp(89) := LDI & "10" & '0' & x"00";	-- 
        tmp(90) := STA & "10" & '0' & x"02";	-- 
        tmp(91) := LDA & "10" & '0' & x"03";	-- 
        tmp(92) := SOMA & "10" & '0' & x"07";	-- 
        tmp(93) := STA & "10" & '0' & x"03";	-- 
        tmp(94) := CEQ & "10" & '0' & x"10";	-- 
        tmp(95) := JEQ & "10" & '0' & x"61";	-- PULA PARA AUMENTA_DEZENA_MILHAR
        tmp(96) := RET & "00" & '0' & x"00";	-- 

--AUMENTA_DEZENA_MILHAR
        tmp(97) := NOP & "00" & '0' & x"00";	-- AUMENTA_DEZENA_MILHAR
        tmp(98) := LDA & "10" & '0' & x"1B";	-- 
        tmp(99) := SOMA & "10" & '0' & x"07";	-- 
        tmp(100) := STA & "10" & '0' & x"1B";	-- 
        tmp(101) := CEQ & "10" & '0' & x"30";	-- 
        tmp(102) := JEQ & "10" & '0' & x"77";	-- MEIA_NOITE
        tmp(103) := LDI & "10" & '0' & x"00";	-- 
        tmp(104) := STA & "10" & '0' & x"03";	-- 
        tmp(105) := LDA & "10" & '0' & x"04";	-- 
        tmp(106) := SOMA & "10" & '0' & x"07";	-- 
        tmp(107) := STA & "10" & '0' & x"04";	-- 
        tmp(108) := CEQ & "10" & '0' & x"0A";	-- 
        tmp(109) := JEQ & "10" & '0' & x"6F";	-- PULA PARA AUMENTA_CENTENA_MILHAR
        tmp(110) := RET & "00" & '0' & x"00";	-- 

--AUMENTA_CENTENA_MILHAR
        tmp(111) := NOP & "00" & '0' & x"00";	-- AUMENTA_CENTENA_MILHAR
        tmp(112) := LDI & "10" & '0' & x"00";	-- 
        tmp(113) := STA & "10" & '0' & x"04";	-- 
        tmp(114) := LDA & "10" & '0' & x"05";	-- 
        tmp(115) := SOMA & "10" & '0' & x"07";	-- 
        tmp(116) := STA & "10" & '0' & x"05";	-- 
        tmp(117) := CEQ & "10" & '0' & x"0A";	-- 
        tmp(118) := RET & "00" & '0' & x"00";	-- 

--MEIA_NOITE
        tmp(119) := NOP & "00" & '0' & x"00";	-- MEIA_NOITE
        tmp(120) := JMP & "01" & '0' & x"00";	-- PULA PARA SET_UP

--RESET
        tmp(121) := NOP & "00" & '0' & x"00";	-- RESET
        tmp(122) := STA & "01" & '1' & x"FE";	-- LIMPA KEY1
        tmp(123) := JMP & "01" & '0' & x"00";	-- PULA PARA SET_UP

--SET_MINUTO
        tmp(124) := NOP & "00" & '0' & x"00";	-- SET_MINUTO
        tmp(125) := JSR & "11" & '0' & x"7F";	-- PULA PARA SET_MINUTO_CENTENA
        tmp(126) := JMP & "11" & '0' & x"2D";	-- PULA PARA PULA1

--SET_MINUTO_CENTENA
        tmp(127) := NOP & "00" & '0' & x"00";	-- SET_MINUTO_CENTENA
        tmp(128) := STA & "11" & '1' & x"FD";	-- LIMPA O KEY2
        tmp(129) := LDA & "11" & '0' & x"02";	-- 
        tmp(130) := SOMA & "11" & '0' & x"07";	-- 
        tmp(131) := STA & "11" & '0' & x"02";	-- 
        tmp(132) := CEQ & "11" & '0' & x"0A";	-- 
        tmp(133) := JEQ & "11" & '0' & x"87";	-- PULA PARA SET_MINUTO_MILHAR
        tmp(134) := RET & "00" & '0' & x"00";	-- 

--SET_MINUTO_MILHAR
        tmp(135) := NOP & "00" & '0' & x"00";	-- SET_MINUTO_MILHAR
        tmp(136) := LDI & "11" & '0' & x"00";	-- 
        tmp(137) := STA & "11" & '0' & x"02";	-- 
        tmp(138) := LDA & "11" & '0' & x"03";	-- 
        tmp(139) := SOMA & "11" & '0' & x"07";	-- 
        tmp(140) := STA & "11" & '0' & x"03";	-- 
        tmp(141) := CEQ & "11" & '0' & x"10";	-- 
        tmp(142) := JEQ & "11" & '0' & x"90";	-- PULA PARA OVERFLOW_MINUTO_MILHAR
        tmp(143) := RET & "00" & '0' & x"00";	-- 


--OVERFLOW_MINUTO_MILHAR
        tmp(144) := NOP & "00" & '0' & x"00";	-- OVERFLOW_MINUTO_MILHAR
        tmp(145) := LDI & "11" & '0' & x"00";	-- DEFINE TODOS OS ALGORISMOS QUANDO ACONTECE O OVERFLOW
        tmp(146) := STA & "11" & '0' & x"02";	-- 
        tmp(147) := STA & "11" & '0' & x"03";	-- 
        tmp(148) := RET & "00" & '0' & x"00";	--

--SET_HORA
        tmp(149) := NOP & "00" & '0' & x"00";	-- SET_HORA
        tmp(150) := JSR & "11" & '0' & x"98";	-- PULA PARA SET_HORA_DEZENA_MILHAR
        tmp(151) := JMP & "11" & '0' & x"2D";	-- PULA PARA PULA1

--SET_HORA_DEZENA_MILHAR
        tmp(152) := NOP & "00" & '0' & x"00";	-- SET_HORA_DEZENA_MILHAR
        tmp(153) := STA & "11" & '1' & x"FC";	-- LIMPA O KEY3
        tmp(154) := LDA & "11" & '0' & x"1B";	-- 
        tmp(155) := SOMA & "11" & '0' & x"07";	-- 
        tmp(156) := STA & "11" & '0' & x"1B";	-- 
        tmp(157) := CEQ & "11" & '0' & x"30";	-- 
        tmp(158) := JEQ & "11" & '0' & x"AC";	-- PULA PARA OVERFLOW_HORA
        tmp(159) := LDA & "11" & '0' & x"04";	-- 
        tmp(160) := SOMA & "11" & '0' & x"07";	-- 
        tmp(161) := STA & "11" & '0' & x"04";	-- 
        tmp(162) := CEQ & "11" & '0' & x"0A";	-- 
        tmp(163) := JEQ & "11" & '0' & x"A5";	-- PULA PARA SET_HORA_CENTENA_MILHAR
        tmp(164) := RET & "00" & '0' & x"00";	-- 

--SET_HORA_CENTENA_MILHAR
        tmp(165) := NOP & "00" & '0' & x"00";	-- SET_HORA_CENTENA_MILHAR
        tmp(166) := LDI & "11" & '0' & x"00";	-- 
        tmp(167) := STA & "11" & '0' & x"04";	-- 
        tmp(168) := LDA & "11" & '0' & x"05";	-- 
        tmp(169) := SOMA & "11" & '0' & x"07";	-- 
        tmp(170) := STA & "11" & '0' & x"05";	-- 
        tmp(171) := RET & "00" & '0' & x"00";	-- 

--OVERFLOW_HORA
        tmp(172) := NOP & "00" & '0' & x"00";	-- OVERFLOW_HORA
        tmp(173) := LDI & "11" & '0' & x"00";	-- 
        tmp(174) := STA & "11" & '0' & x"04";	-- 
        tmp(175) := STA & "11" & '0' & x"05";	-- 
        tmp(176) := STA & "11" & '0' & x"1B";	-- 
        tmp(177) := RET & "00" & '0' & x"00";	-- 





		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;