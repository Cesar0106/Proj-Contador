library ieee;
use ieee.std_logic_1164.all;

entity display is
  -- Total de bits das entradas e saidas
  port   (
    CLK : in std_logic;
    data_out: in std_logic_vector(3 downto 0);
	 wr : in std_logic;
	 bloco_4: in std_logic;
	 data_adr_5: in std_logic;
	 endereco: in std_logic_vector(5 downto 0);
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector (6 downto 0)
  );
end entity;


architecture arquitetura of display is
  signal hab_reg0: std_logic;
  signal hab_reg1: std_logic;
  signal hab_reg2: std_logic;
  signal hab_reg3: std_logic;
  signal hab_reg4: std_logic;
  signal hab_reg5: std_logic;
  
  signal saida_h0: std_logic_vector(3 downto 0);
  signal saida_h1: std_logic_vector(3 downto 0);
  signal saida_h2: std_logic_vector(3 downto 0);
  signal saida_h3: std_logic_vector(3 downto 0);
  signal saida_h4: std_logic_vector(3 downto 0);
  signal saida_h5: std_logic_vector(3 downto 0);
  
  signal h0: std_logic_vector(6 downto 0);
  signal h1: std_logic_vector(6 downto 0);
  signal h2: std_logic_vector(6 downto 0);
  signal h3: std_logic_vector(6 downto 0);
  signal h4: std_logic_vector(6 downto 0);
  signal h5: std_logic_vector(6 downto 0);
  
begin



REG0 : entity work.registradorGenerico  generic map (larguraDados => 4)
          port map (DIN => data_out, DOUT => saida_h0, ENABLE => hab_reg0, CLK => CLK, RST => '0');

			 
display0 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_h0,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => h0);
			
REG1 : entity work.registradorGenerico  generic map (larguraDados => 4)
          port map (DIN => data_out, DOUT => saida_h1, ENABLE => hab_reg1, CLK => CLK, RST => '0');

			 
display1 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_h1,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => h1);
				
				
				
REG2 : entity work.registradorGenerico  generic map (larguraDados => 4)
          port map (DIN => data_out, DOUT => saida_h2, ENABLE => hab_reg2, CLK => CLK, RST => '0');

			 
display2 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_h2,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => h2);			

					  

	
REG3 : entity work.registradorGenerico  generic map (larguraDados => 4)
          port map (DIN => data_out, DOUT => saida_h3, ENABLE => hab_reg3, CLK => CLK, RST => '0');

			 
display3 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_h3,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => h3);	
					  
					  
REG4 : entity work.registradorGenerico  generic map (larguraDados => 4)
          port map (DIN => data_out, DOUT => saida_h4, ENABLE => hab_reg4, CLK => CLK, RST => '0');

			 
display4 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_h4,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => h4);
					  
					  
REG5 : entity work.registradorGenerico  generic map (larguraDados => 4)
          port map (DIN => data_out, DOUT => saida_h5, ENABLE => hab_reg5, CLK => CLK, RST => '0');

			 
display5 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_h5,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => h5);
					  
HEX0 <= h0;
HEX1 <= h1;
HEX2 <= h2;
HEX3 <= h3;
HEX4 <= h4;
HEX5 <= h5;





hab_reg0 <= (wr and bloco_4 and data_adr_5 and endereco(0));
hab_reg1 <= (wr and bloco_4 and data_adr_5 and endereco(1));
hab_reg2 <= (wr and bloco_4 and data_adr_5 and endereco(2));
hab_reg3 <= (wr and bloco_4 and data_adr_5 and endereco(3));
hab_reg4 <= (wr and bloco_4 and data_adr_5 and endereco(4));
hab_reg5 <= (wr and bloco_4 and data_adr_5 and endereco(5));



end architecture;