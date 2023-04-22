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
		tmp(0)    := LDI   & '0' & x"00";  
        tmp(1)    := STA   & '1' & x"20";  --HEX0
        tmp(2)    := STA   & '1' & x"21";  --HEX1 
	    tmp(3)    := STA   & '1' & x"22";  --HEX2
        tmp(4)    := STA   & '1' & x"23";  --HEX3
        tmp(5)    := STA   & '1' & x"24";  --HEX4
        tmp(6)    := STA   & '1' & x"25";  --HEX5

		tmp(7)    := STA   & '1' & x"00";  --LEDR 0 a 7
		tmp(8)    := STA   & '1' & x"01";  --LEDR 8
        tmp(9)    := STA   & '1' & x"02";  --LEDR 9

        tmp(10)   := LDI   & '0' & X"00";  
        tmp(11)   := STA   & '0' & x"00";  --UNIDADE 
		tmp(12)   := STA   & '0' & x"01";  --DEZENAS
		tmp(13)   := STA   & '0' & x"02";  --CENTENAS 
        tmp(14)   := STA   & '0' & x"03";  --MILHAR 
        tmp(15)   := STA   & '0' & x"04";  --DEZENAS DE MILHAR 
        tmp(16)   := STA   & '0' & x"05";  --CENTENAS DE MILHAR 

        tmp(17)   := LDI   & '0' & X"00";
		tmp(18)   := STA   & '0' & x"06";  --FLAG PARA O KEY 0
        tmp(19)   := STA   & '0' & X"0B";  --CONTADOR

		tmp(20)   := LDI   & '0' & x"01";  
		tmp(21)   := STA   & '0' & x"07";  --GUARDA O VALOR 1
        tmp(22)   := STA   & '0' & x"08";  --FLAG DO RESET

        tmp(23)   := LDI   & '0' & x"0A";  --GUARDAR O VALOR 10
		tmp(24)   := STA   & '0' & x"0A";

        tmp(25)   := LDI   & '0' & x"0F";  --GUARDA O LIMITE 
		tmp(26)   := STA   & '0' & x"0C";

        --INCIO
        tmp(27)   := LDA   & '1' & X"61";
        tmp(28)   := CEQ   & '0' & X"08";
        tmp(29)   := JEQ   & '0' & X"72";

        tmp(30)   := LDA   & '1' & X"60";
        tmp(31)   := CEQ   & '0' & X"06";
        tmp(32)   := JEQ   & '0' & X"22";
        tmp(33)   := JSR   & '0' & X"27";

        --PULA1 
        tmp(34)   := JSR   & '0' & X"31";
        tmp(35)   := LDA   & '0' & X"0B";
        tmp(36)   := CEQ   & '0' & X"0C";
        tmp(37)   := JEQ   & '0' & X"74";
        tmp(38)   := JMP   & '0' & X"1B";

        --INCREMENTA UNIDADE
        tmp(39)   := STA   & '1' & X"FF";
        tmp(40)   := LDA   & '0' & X"0B";
        tmp(41)   := SOMA  & '0' & X"07";
        tmp(42)   := STA   & '0' & X"0B";
        tmp(43)   := LDA   & '0' & X"00";
        tmp(44)   := SOMA  & '0' & X"07";
        tmp(45)   := STA   & '0' & X"00";
        tmp(46)   := CEQ   & '0' & X"0A";
        tmp(47)   := JEQ   & '0' & X"3E";
        tmp(48)   := RET   & '0' & X"00";

        --DISPLAY
        tmp(49)   := LDA   & '0' & X"00";
        tmp(50)   := STA   & '1' & X"20";
        tmp(51)   := LDA   & '0' & X"01";
        tmp(52)   := STA   & '1' & X"21";
        tmp(53)   := LDA   & '0' & X"02";
        tmp(54)   := STA   & '1' & X"22";
        tmp(55)   := LDA   & '0' & X"03";
        tmp(56)   := STA   & '1' & X"23";
        tmp(57)   := LDA   & '0' & X"04";
        tmp(58)   := STA   & '1' & X"24";
        tmp(59)   := LDA   & '0' & X"05";
        tmp(60)   := STA   & '1' & X"25";
        tmp(61)   := RET   & '0' & X"00";

        --AUMENTA DEZENA
        tmp(62)   := LDI   & '0' & X"00";
        tmp(63)   := STA   & '0' & X"00";
        tmp(64)   := LDA   & '0' & X"01";
        tmp(65)   := SOMA  & '0' & X"07";
        tmp(66)   := STA   & '0' & X"01";
        tmp(67)   := CEQ   & '0' & X"0A";
        tmp(68)   := JEQ   & '0' & X"46";
        tmp(69)   := RET   & '0' & X"00";

        --AUMENTA_CENTENA
        tmp(70)   := LDI   & '0' & X"00";
        tmp(71)   := STA   & '0' & X"01";
        tmp(72)   := LDA   & '0' & X"02";
        tmp(73)   := SOMA  & '0' & X"07";
        tmp(74)   := STA   & '0' & X"02";
        tmp(75)   := CEQ   & '0' & X"0A";
        tmp(76)   := JEQ   & '0' & X"4E";
        tmp(77)   := RET   & '0' & X"00";

        --AUMENTA_MILHAR
        tmp(78)   := LDI   & '0' & X"00";
		tmp(79)   := STA   & '0' & X"02";
        tmp(80)   := LDA   & '0' & X"03";
        tmp(81)   := SOMA  & '0' & X"07";
        tmp(82)   := STA   & '0' & X"03";
        tmp(83)   := CEQ   & '0' & X"0A";
        tmp(84)   := JEQ   & '0' & X"56";
        tmp(85)   := RET   & '0' & X"00";

        --AUMENTA DEZENAS DE MILHAR
        tmp(86)   := LDI   & '0' & X"00";
		tmp(87)   := STA   & '0' & X"03";
        tmp(88)   := LDA   & '0' & X"04";
        tmp(89)   := SOMA  & '0' & X"07";
        tmp(90)   := STA   & '0' & X"04";
        tmp(91)   := CEQ   & '0' & X"0A";
        tmp(92)   := JEQ   & '0' & X"5E";
        tmp(93)   := RET   & '0' & X"00";

        --AUMENTA CENTENAS DE MILHAR
        tmp(94)   := LDI   & '0' & X"00";
		tmp(95)   := STA   & '0' & X"04";
        tmp(96)   := LDA   & '0' & X"05";
        tmp(97)   := SOMA  & '0' & X"07";
        tmp(98)   := STA   & '0' & X"05";
        tmp(99)   := CEQ   & '0' & X"0A";
        tmp(100)   := JEQ   & '0' & X"66";
        tmp(101)   := RET   & '0' & X"00";


        --OVERFLOW
        tmp(102)   := LDI   & '0' & X"09";
		tmp(103)   := STA   & '0' & X"00";
		tmp(104)   := STA   & '0' & X"01";
		tmp(105)   := STA   & '0' & X"02";
		tmp(106)  := STA   & '0' & X"03";
		tmp(107)  := STA   & '0' & X"04";
		tmp(108)  := STA   & '0' & X"05";
        tmp(109)  := LDI   & '0' & X"00";
		tmp(110)  := STA   & '0' & X"07";
        tmp(111)  := LDI   & '0' & X"01";
		tmp(112)  := STA   & '1' & X"02";
        tmp(113)  := RET   & '0' & X"00";

        --RESET
		tmp(114)   := STA   & '1' & X"FE";
		tmp(115)   := JMP   & '0' & X"00";

        --LIMITE
        tmp(116)   := LDA   & '0' & X"00";
		tmp(117)   := STA   & '0' & X"00";
        tmp(118)   := LDA   & '0' & X"01";
		tmp(119)   := STA   & '0' & X"01";
        tmp(120)   := LDA   & '0' & X"02";
		tmp(121)   := STA   & '0' & X"02";
        tmp(122)   := LDA   & '0' & X"03";
		tmp(123)   := STA   & '0' & X"03";
        tmp(124)   := LDA   & '0' & X"04";
		tmp(125)   := STA   & '0' & X"04";
        tmp(126)   := LDA   & '0' & X"05";
		tmp(127)   := STA   & '0' & X"05";
        tmp(128)   := LDI   & '0' & X"00";
		tmp(129)   := STA   & '0' & X"07";
        tmp(130)   := LDI   & '0' & X"01";
		tmp(131)   := STA   & '1' & X"01";
        tmp(132)   := JMP   & '0' & X"1B";

        




		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;