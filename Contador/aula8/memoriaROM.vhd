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
		tmp(0)    := LDI   & '0' & x"00";  
        tmp(1)    := STA   & '1' & x"20";  
        tmp(2)    := STA   & '1' & x"21";   
	    tmp(3)    := STA   & '1' & x"22";   
        tmp(4)    := STA   & '1' & x"23";  
        tmp(5)    := STA   & '1' & x"24";  
        tmp(6)    := STA   & '1' & x"25";

		tmp(7)    := STA   & '1' & x"00";
		tmp(8)    := STA   & '1' & x"01";  
        tmp(9)    := STA   & '1' & x"02";

        tmp(10)   := STA   & '0' & x"00";   
		tmp(11)   := STA   & '0' & x"01";
		tmp(12)   := STA   & '0' & x"02";  
        tmp(13)   := STA   & '0' & x"03";  
        tmp(14)   := STA   & '0' & x"04";   
		tmp(15)   := STA   & '0' & x"05";
		tmp(16)   := STA   & '0' & x"06";

		tmp(17)   := LDI   & '0' & x"01";
		tmp(18)   := STA   & '0' & x"07";

        tmp(19)   := LDI   & '0' & x"10";
		tmp(20)   := STA   & '0' & x"10";

        tmp(21)   := LDA   & '1' & X"61";
        tmp(22)   := CEQ   & '0' & X"07";
        tmp(23)   := JEQ   & '0' & X"    ";

        tmp(24)   := LDA   & '1' & X"60";
        tmp(25)   := CEQ   & '0' & X"06";
        tmp(26)   := JEQ   & '0' & X"1C";

        tmp(27)   := JSR   & '0' & X"1E";

        tmp(28)   := JSR   & '0' & X"25";
        tmp(29)   := JMP   & '0' & X"15";

        tmp(30)   := STA   & '1' & X"FF";
        tmp(31)   := LDA   & '0' & X"00";
        tmp(32)   := SOMA  & '0' & X"07";
        tmp(33)   := STA   & '0' & X"00";
        tmp(34)   := CEQ   & '0' & X"0A";
        tmp(35)   := JEQ   & '0' & X"  ";
        tmp(36)   := RET   & '0' & X"00";


        tmp(37)   := LDA   & '0' & X"00";
        tmp(38)   := STA   & '1' & X"20";
        tmp(39)   := LDA   & '0' & X"01";
        tmp(40)   := STA   & '1' & X"21";
        tmp(41)   := LDA   & '0' & X"02";
        tmp(42)   := STA   & '1' & X"22";
        tmp(43)   := LDA   & '0' & X"03";
        tmp(44)   := STA   & '1' & X"23";
        tmp(45)   := LDA   & '0' & X"04";
        tmp(46)   := STA   & '1' & X"24";
        tmp(47)   := LDA   & '0' & X"05";
        tmp(48)   := STA   & '1' & X"25";
        tmp(49)   := RET   & '0' & X"00";

		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;