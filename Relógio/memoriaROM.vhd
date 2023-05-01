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
		tmp(0)    := LDI  & "000" & '0' & x"00";  --ZERNADO O DISPLAY E OS LEDS
        tmp(1)    := STA & "000"  & '1' & x"20";  --HEX0
        tmp(2)    := STA & "000"  & '1' & x"21";  --HEX1 
	    tmp(3)    := STA & "000"  & '1' & x"22";  --HEX2
        tmp(4)    := STA & "000"  & '1' & x"23";  --HEX3
        tmp(5)    := STA  & "000" & '1' & x"24";  --HEX4
        tmp(6)    := STA & "000"  & '1' & x"25";  --HEX5

		tmp(7)    := STA & "000"  & '1' & x"00";  --LEDR 0 a 7
		tmp(8)    := STA & "000"  & '1' & x"01";  --LEDR 8
        tmp(9)    := STA & "000"  & '1' & x"02";  --LEDR 9

        tmp(10)   := LDI & "000"  & '0' & X"00";  --ZERANDO OS ALGARISMOS
        tmp(11)   := STA  & "000" & '0' & x"00";  --UNIDADE 
		tmp(12)   := STA & "000"  & '0' & x"01";  --DEZENAS
		tmp(13)   := STA & "000"  & '0' & x"02";  --CENTENAS 
        tmp(14)   := STA  & "000" & '0' & x"03";  --MILHAR 
        tmp(15)   := STA  & "000" & '0' & x"04";  --DEZENAS DE MILHAR 
        tmp(16)   := STA  & "000" & '0' & x"05";  --CENTENAS DE MILHAR 

        tmp(17)   := LDI & "000"  & '0' & X"00";  
		tmp(18)   := STA & "000"  & '0' & x"06";  --FLAG PARA O KEY 0 E KEY 2

		tmp(19)   := LDI & "000"  & '0' & x"01";  
		tmp(20)   := STA  & "000" & '0' & x"07";  --GUARDA O VALOR 1 PARA SOMA 
        tmp(21)   := STA  & "000" & '0' & x"08";  --FLAG DO RESET

        tmp(22)   := LDI  & "000" & '0' & x"0A";  --GUARDAR O VALOR 10 PARA COMPARAR
		tmp(23)   := STA  & "000" & '0' & x"0A";


        tmp(24)   := LDI & "000"  & '0' & x"01";  --GUARDA O VALOR 1 PARA SUB 
		tmp(25)   := STA & "000"  & '0' & x"0D";  --VARIAVEL DO DECREMENTO
        tmp(26)   := STA & "000"  & '0' & X"0B";  --FLAG DO KEY2



        --INCIO
        tmp(27)   := LDA  & "000" & '1' & X"61"; --KEY1
        tmp(28)   := CEQ  & "000" & '0' & X"08";
        tmp(29)   := JEQ  & "000" & '0' & X"71"; --PULA PARA O RESET

        tmp(30)   := LDA & "000"  & '1' & X"62"; --KEY2
        tmp(31)   := CEQ & "000"  & '0' & X"0B";
        tmp(32)   := JEQ & "000"  & '0' & X"73"; --PULA PARA DECREMENTO

        tmp(33)   := LDA & "000"  & '1' & X"60"; --KEY0
        tmp(34)   := CEQ & "000"  & '0' & X"06";
        tmp(35)   := JEQ & "000"  & '0' & X"25"; --PULA PARA PULA1
        tmp(36)   := JSR & "000"  & '0' & X"27"; --PULA SUB-ROTINA PARA INCREMENTA

        --PULA1 
        tmp(37)   := JSR  & "000" & '0' & X"30"; --PULA SUB-ROTINA PARA DISPLAY
        tmp(38)   := JMP & "000"  & '0' & X"1B"; --PULA PARA O INICIO

        --INCREMENTA UNIDADE
        tmp(39)   := STA & "000"  & '1' & X"FF"; --LIMPA O KEY 0
        tmp(40)   := LDI & "000"  & '0' & X"01";
        tmp(41)   := STA & "000"  & '0' & X"0D";
        tmp(42)   := LDA & "000"  & '0' & X"00";
        tmp(43)   := SOMA & "000" & '0' & X"07";
        tmp(44)   := STA  & "000" & '0' & X"00";
        tmp(45)   := CEQ & "000"  & '0' & X"0A";
        tmp(46)   := JEQ  & "000" & '0' & X"3D"; --PULA PARA AUMENTA_DEZENA
        tmp(47)   := RET  & "000" & '0' & X"00";

        --DISPLAY
        tmp(48)   := LDA & "000"  & '0' & X"00";
        tmp(49)   := STA  & "000" & '1' & X"20";
        tmp(50)   := LDA & "000"  & '0' & X"01";
        tmp(51)   := STA & "000"  & '1' & X"21";
        tmp(52)   := LDA & "000"  & '0' & X"02";
        tmp(53)   := STA & "000"  & '1' & X"22";
        tmp(54)   := LDA & "000"  & '0' & X"03";
        tmp(55)   := STA & "000"  & '1' & X"23";
        tmp(56)   := LDA & "000"  & '0' & X"04";
        tmp(57)   := STA  & "000" & '1' & X"24";
        tmp(58)   := LDA & "000"  & '0' & X"05";
        tmp(59)   := STA & "000"  & '1' & X"25";
        tmp(60)   := RET & "000" & '0' & X"00";

        --AUMENTA DEZENA
        tmp(61)   := LDI & "000"  & '0' & X"00";
        tmp(62)   := STA  & "000" & '0' & X"00";
        tmp(63)   := LDA & "000"  & '0' & X"01";
        tmp(64)   := SOMA & "000" & '0' & X"07";
        tmp(65)   := STA  & "000" & '0' & X"01";
        tmp(66)   := CEQ  & "000" & '0' & X"0A";
        tmp(67)   := JEQ & "000"  & '0' & X"45"; --PULA PARA AUMENTA_CENTENA
        tmp(68)   := RET & "000"  & '0' & X"00";

        --AUMENTA_CENTENA
        tmp(69)   := LDI & "000"  & '0' & X"00";
        tmp(70)   := STA & "000"  & '0' & X"01";
        tmp(71)   := LDA & "000"  & '0' & X"02";
        tmp(72)   := SOMA & "000" & '0' & X"07";
        tmp(73)   := STA  & "000" & '0' & X"02";
        tmp(74)   := CEQ & "000"  & '0' & X"0A";
        tmp(75)   := JEQ & "000"  & '0' & X"4D"; --PULA PARA AUMENTA_MILHAR
        tmp(76)   := RET & "000"  & '0' & X"00";

        --AUMENTA_MILHAR
        tmp(77)   := LDI & "000"  & '0' & X"00";
		tmp(78)   := STA  & "000" & '0' & X"02";
        tmp(79)   := LDA & "000"  & '0' & X"03";
        tmp(80)   := SOMA & "000" & '0' & X"07";
        tmp(81)   := STA  & "000" & '0' & X"03";
        tmp(82)   := CEQ & "000"  & '0' & X"0A";
        tmp(83)   := JEQ & "000"  & '0' & X"55"; --PULA PARA AUMENTA_DEZENA_MILHAR
        tmp(84)   := RET & "000"  & '0' & X"00";

        --AUMENTA DEZENAS DE MILHAR
        tmp(85)   := LDI  & "000" & '0' & X"00";
		tmp(86)   := STA & "000"  & '0' & X"03";
        tmp(87)   := LDA  & "000" & '0' & X"04";
        tmp(88)   := SOMA & "000" & '0' & X"07";
        tmp(89)   := STA & "000"  & '0' & X"04";
        tmp(90)   := CEQ & "000"  & '0' & X"0A";
        tmp(91)   := JEQ & "000"  & '0' & X"5D"; --PULA PARA AUMENTA_CENTENA_MILHAR
        tmp(92)   := RET & "000"  & '0' & X"00";

        --AUMENTA CENTENAS DE MILHAR
        tmp(93)   := LDI & "000"  & '0' & X"00";
		tmp(94)   := STA  & "000" & '0' & X"04";
        tmp(95)   := LDA  & "000" & '0' & X"05";
        tmp(96)   := SOMA & "000" & '0' & X"07";
        tmp(97)   := STA & "000"  & '0' & X"05";
        tmp(98)   := CEQ & "000"  & '0' & X"0A";
        tmp(99)   := JEQ & "000"  & '0' & X"65"; --PULA PARA OVERFLOW
        tmp(100)  := RET & "000"  & '0' & X"00";


        --OVERFLOW
        tmp(101)  := LDI & "000"  & '0' & X"09"; --DEFINE TODOS OS ALGORISMOS QUANDO ACONTECE O OVERFLOW
		tmp(102)  := STA & "000"  & '0' & X"00";
		tmp(103)  := STA & "000"  & '0' & X"01";
		tmp(104)  := STA & "000"  & '0' & X"02";
		tmp(105)  := STA  & "000" & '0' & X"03";
		tmp(106)  := STA & "000"  & '0' & X"04";
		tmp(107)  := STA  & "000" & '0' & X"05";
        tmp(108)  := LDI & "000"  & '0' & X"00";
		tmp(109)  := STA & "000"  & '0' & X"07";
        tmp(110)  := LDI & "000"  & '0' & X"01";
		tmp(111)  := STA & "000"  & '1' & X"02"; --LIGA O LED 9 PARA INFORMAR O OVERFLOW 
        tmp(112)  := RET  & "000" & '0' & X"00";

        --RESET
		tmp(113)   := STA  & "000" & '1' & X"FE"; --LIMPA KEY1  
		tmp(114)   := JMP  & "000" & '0' & X"00";


        --DECREMENTO
        tmp(115)   := LDI & "000"  & '0' & X"00";
		tmp(116)   := STA  & "000" & '0' & X"09";


		tmp(117)   := JSR & "000"  & '0' & X"77"; --PULA PARA MENOS_UNIDADE
        tmp(118)   := JMP & "000"  & '0' & X"25"; --PULA PARA PULA1

        --MENOS_UNIDADE
        tmp(119)   := STA & "000"  & '1' & X"FD"; --LIMPA O KEY2
        tmp(120)   := LDI  & "000" & '0' & X"01";
        tmp(121)   := STA & "000"  & '0' & X"07";

        tmp(122)   := LDI  & "000" & '0' & X"00"; 
        tmp(123)   := STA  & "000" & '1' & X"02"; --DESLIGA O LED 9 QUANDO OCORRER O OVERFLOW E DIMINUIMOS O VALOR 

        tmp(124)   := LDA  & "000" & '0' & X"00";
        tmp(125)   := CEQ  & "000" & '0' & X"09";
        tmp(126)   := JEQ & "000"  & '0' & X"82"; --PULA PARA MENOS_DEZENA

        tmp(127)   := SUB & "000"  & '0' & X"0D";
        tmp(128)   := STA & "000"  & '0' & X"00";

        tmp(129)   := RET  & "000" & '0' & X"00";

        --MENOS_DEZENA
        tmp(130)   := LDI & "000"  & '0' & X"09";
        tmp(131)   := STA & "000"  & '0' & X"00";

        tmp(132)   := LDA & "000"  & '0' & X"01";
        tmp(133)   := CEQ & "000"  & '0' & X"09";
        tmp(134)   := JEQ & "000"  & '0' & X"8A"; --PULA PARA MENOS_CENTENA

       
        tmp(135)   := SUB & "000"  & '0' & X"0D";
        tmp(136)   := STA & "000"  & '0' & X"01";
        
        tmp(137)    := RET & "000"  & '0' & X"00";
       

       --MENOS_CENTENA
        tmp(138)   := LDI & "000"  & '0' & X"09";
        tmp(139)   := STA  & "000" & '0' & X"01";
        tmp(140)   := LDA  & "000" & '0' & X"02";
        tmp(141)   := CEQ  & "000" & '0' & X"09";
        tmp(142)   := JEQ  & "000" & '0' & X"92"; --PULA PARA MENOS_MILHAR

        tmp(143)   := SUB  & "000" & '0' & X"0D";
        tmp(144)   := STA  & "000" & '0' & X"02";
    
        tmp(145)   := RET & "000"  & '0' & X"00";

        --MENOS_MILHAR
        tmp(146)   := LDI & "000"  & '0' & X"09";
        tmp(147)   := STA & "000"  & '0' & X"02";
        tmp(148)   := LDA & "000"  & '0' & X"03";
        tmp(149)   := CEQ & "000"  & '0' & X"09";
        tmp(150)   := JEQ & "000"  & '0' & X"9A"; --PULA PARA MENOS_DEZENA_MI

        tmp(151)   := SUB & "000"  & '0' & X"0D";
        tmp(152)   := STA & "000"  & '0' & X"03";
        

        
        tmp(153)   := RET & "000"  & '0' & X"00";

        --MENOS_DEZENA_MILHAR
        tmp(154)   := LDI & "000"  & '0' & X"09";
        tmp(155)   := STA & "000"  & '0' & X"03";
        tmp(156)   := LDA & "000"  & '0' & X"04";
        tmp(157)   := CEQ & "000"  & '0' & X"09";
        tmp(158)   := JEQ  & "000" & '0' & X"A2"; --PULA PARA MENOS_CENTENA_MI

        tmp(159)   := SUB & "000"  & '0' & X"0D";
        tmp(160)   := STA & "000"  & '0' & X"04";
        

        
        tmp(161)   := RET  & "000" & '0' & X"00";

        --MENOS_CENTENA_MILHAR
        tmp(162)   := LDI  & "000" & '0' & X"09";
        tmp(163)   := STA & "000"  & '0' & X"04";
        tmp(164)   := LDA & "000"  & '0' & X"05";
        tmp(165)   := SUB & "000"  & '0' & X"0D";
        tmp(166)   := STA & "000"  & '0' & X"05";
        tmp(167)   := RET  & "000" & '0' & X"00";



		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;