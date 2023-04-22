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

		tmp(19)   := LDI   & '0' & x"01";  
		tmp(20)   := STA   & '0' & x"07";  --GUARDA O VALOR 1
        tmp(21)   := STA   & '0' & x"08";  --FLAG DO RESET

        tmp(22)   := LDI   & '0' & x"0A";  --GUARDAR O VALOR 10
		tmp(23)   := STA   & '0' & x"0A";

        --INCIO
        tmp(24)   := LDA   & '1' & X"61";
        tmp(25)   := CEQ   & '0' & X"08";
        tmp(26)   := JEQ   & '0' & X"69";

        tmp(27)   := LDA   & '1' & X"60";
        tmp(28)   := CEQ   & '0' & X"06";
        tmp(29)   := JEQ   & '0' & X"1F";
        tmp(30)   := JSR   & '0' & X"21";

        --PULA1 
        tmp(31)   := JSR   & '0' & X"28";
        tmp(32)   := JMP   & '0' & X"18";

        --INCREMENTA UNIDADE
        tmp(33)   := STA   & '1' & X"FF";
        tmp(34)   := LDA   & '0' & X"00";
        tmp(35)   := SOMA  & '0' & X"07";
        tmp(36)   := STA   & '0' & X"00";
        tmp(37)   := CEQ   & '0' & X"0A";
        tmp(38)   := JEQ   & '0' & X"35";
        tmp(39)   := RET   & '0' & X"00";

        --DISPLAY
        tmp(40)   := LDA   & '0' & X"00";
        tmp(41)   := STA   & '1' & X"20";
        tmp(42)   := LDA   & '0' & X"01";
        tmp(43)   := STA   & '1' & X"21";
        tmp(44)   := LDA   & '0' & X"02";
        tmp(45)   := STA   & '1' & X"22";
        tmp(46)   := LDA   & '0' & X"03";
        tmp(47)   := STA   & '1' & X"23";
        tmp(48)   := LDA   & '0' & X"04";
        tmp(49)   := STA   & '1' & X"24";
        tmp(50)   := LDA   & '0' & X"05";
        tmp(51)   := STA   & '1' & X"25";
        tmp(52)   := RET   & '0' & X"00";

        --AUMENTA DEZENA
        tmp(53)   := LDI   & '0' & X"00";
        tmp(54)   := STA   & '0' & X"00";
        tmp(55)   := LDA   & '0' & X"01";
        tmp(56)   := SOMA  & '0' & X"07";
        tmp(57)   := STA   & '0' & X"01";
        tmp(58)   := CEQ   & '0' & X"0A";
        tmp(59)   := JEQ   & '0' & X"3D";
        tmp(60)   := RET   & '0' & X"00";

        --AUMENTA_CENTENA
        tmp(61)   := LDI   & '0' & X"00";
        tmp(62)   := STA   & '0' & X"01";
        tmp(63)   := LDA   & '0' & X"02";
        tmp(64)   := SOMA  & '0' & X"07";
        tmp(65)   := STA   & '0' & X"02";
        tmp(66)   := CEQ   & '0' & X"0A";
        tmp(67)   := JEQ   & '0' & X"45";
        tmp(68)   := RET   & '0' & X"00";

        --AUMENTA_MILHAR
        tmp(69)   := LDI   & '0' & X"00";
		tmp(70)   := STA   & '0' & X"02";
        tmp(71)   := LDA   & '0' & X"03";
        tmp(72)   := SOMA  & '0' & X"07";
        tmp(73)   := STA   & '0' & X"03";
        tmp(74)   := CEQ   & '0' & X"0A";
        tmp(75)   := JEQ   & '0' & X"4D";
        tmp(76)   := RET   & '0' & X"00";

        --AUMENTA DEZENAS DE MILHAR
        tmp(77)   := LDI   & '0' & X"00";
		tmp(78)   := STA   & '0' & X"03";
        tmp(79)   := LDA   & '0' & X"04";
        tmp(80)   := SOMA  & '0' & X"07";
        tmp(81)   := STA   & '0' & X"04";
        tmp(82)   := CEQ   & '0' & X"0A";
        tmp(83)   := JEQ   & '0' & X"55";
        tmp(84)   := RET   & '0' & X"00";

        --AUMENTA CENTENAS DE MILHAR
        tmp(85)   := LDI   & '0' & X"00";
		tmp(86)   := STA   & '0' & X"04";
        tmp(87)   := LDA   & '0' & X"05";
        tmp(88)   := SOMA  & '0' & X"07";
        tmp(89)   := STA   & '0' & X"05";
        tmp(90)   := CEQ   & '0' & X"0A";
        tmp(91)   := JEQ   & '0' & X"5D";
        tmp(92)   := RET   & '0' & X"00";


        --OVERFLOW
        tmp(93)   := LDI   & '0' & X"09";
		tmp(94)   := STA   & '0' & X"00";
		tmp(95)   := STA   & '0' & X"01";
		tmp(96)   := STA   & '0' & X"02";
		tmp(97)   := STA   & '0' & X"03";
		tmp(98)   := STA   & '0' & X"04";
		tmp(99)   := STA   & '0' & X"05";
        tmp(100)   := LDI   & '0' & X"00";
		tmp(101)   := STA   & '0' & X"07";
        tmp(102)   := LDI   & '0' & X"01";
		tmp(103)   := STA   & '1' & X"02";
        tmp(104)   := RET   & '0' & X"00";

        --RESET
		tmp(105)   := STA   & '1' & X"FE";
		tmp(106)   := JMP   & '0' & X"00";




		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;