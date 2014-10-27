

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;   

entity my_4bit_FA_Testbench is
end my_4bit_FA_Testbench; 

architecture behavior of my_4bit_FA_Testbench is
 
 component FourBitAdder
  Port ( A : in std_logic_vector (3 downto 0);
           B : in std_logic_vector (3 downto 0);
           Cin : in std_logic;
           Sum : out std_logic_vector (3 downto 0);
           Cout : out std_logic);
 end component;
 
 
 signal A: std_logic_vector (3 downto 0); 
 signal B: std_logic_vector (3 downto 0); 
 signal Cin: std_logic; 
 signal Sum: std_logic_vector (3 downto 0);
 signal Cout : std_logic; --local signal declaration
 
 begin
 -- Component Instantiation
 UUT : FourBitAdder port map( A => A,
							 B => B, 
							 Cin => Cin, 
							 Sum => Sum, 
							 Cout  => Cout);
 
  -- Cycle through test vectors and evaluate the results
process
 begin
 	    A <= "0000";
		B <= "0000";
		Cin <= '0';
		
		wait for 10 ns;
		
	    A <= "1000";
        B <= "0100";
        Cin <= '1';
        				
		wait for 10 ns;
		
		A <= "0111";
        B <= "1000";
        Cin <= '1';
        		
        wait for 10ns;
        
        A <= "1100";
        B <= "0110";
        Cin <= '0';
        
        wait for 10ns;
        
        A <= "1100";
        B <= "0110";
        Cin <= '1';
        
        wait for 10ns;
        
        A <= "0000";
        B <= "1111";
        Cin <= '0';
        
        wait for 10ns;
        
        A <= "0000";
        B <= "1111";
        Cin <= '1';
        
        wait for 10ns;
        
        A <= "1111";
        B <= "0000";
        Cin <= '0';
        
        wait for 10ns;
        
        A <= "1001";
        B <= "0110";
        Cin <= '0';
        
        wait for 10ns;
        
        A <= "1001";
        B <= "0110";
        Cin <= '1';
        
        wait for 10ns;
                              		
	wait;
	
   end process;

END; 	
