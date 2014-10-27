

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;   

entity and_or_top_Testbench is
end and_or_top_Testbench; 

architecture behavior of and_or_top_Testbench is
 
  
 
 component and_or_top
 port(   A1 : in std_logic;
	   A2 : in std_logic;
	   A3 : in std_logic;
	   X  : out std_logic;
	   O1 : in std_logic;
	   O2 : in std_logic;
	   O3 : in std_logic;
	   Y  : out std_logic );
 end component;
 
 
 signal A1: std_logic := '0'; 
 signal A2: std_logic := '0'; 
 signal A3: std_logic := '0'; 
 signal O1: std_logic := '0'; 
 signal O2: std_logic := '0'; 
 signal O3: std_logic := '0'; 
 signal X: std_logic;
 signal Y : std_logic; --local signal declaration
 
 begin
 -- Component Instantiation
 UUT : and_or_top port map(  			 A1 => A1,
							 A2 => A2, 
							 A3 => A3, 
							 O1 => O1, 
							 O2 => O2, 
							 O3 => O3, 
							 X  => X, 
							 Y  => Y);
 
  -- Cycle through test vectors and evaluate the results
process
 begin
 	      A1 <= '0';
		A2 <= '0';
		A3 <= '0';
		O1 <= '0';
		O2 <= '0';
		O3 <= '0';
		
		wait for 10 ns;
		
            A1 <= '0';
		A2 <= '0';
		A3 <= '1';
		O1 <= '0';
		O2 <= '0';
		O3 <= '1';
		
		wait for 10 ns;
		
		A1 <= '0';
		A2 <= '1';
		A3 <= '0';
		O1 <= '0';
		O2 <= '1';
		O3 <= '0';
		
		wait for 10 ns;
		
		A1 <= '0';
		A2 <= '1';
		A3 <= '1';
		O1 <= '0';
		O2 <= '1';
		O3 <= '1';
		
		wait for 10 ns;
		
		A1 <= '1';
		A2 <= '0';
		A3 <= '0';
		O1 <= '1';
		O2 <= '0';
		O3 <= '0';
		
		wait for 10 ns;
		
		A1 <= '1';
		A2 <= '0';
		A3 <= '1';
		O1 <= '1';
		O2 <= '0';
		O3 <= '1';
		
		wait for 10 ns;
		
		A1 <= '1';
		A2 <= '1';
		A3 <= '0';
		O1 <= '1';
		O2 <= '1';
		O3 <= '0';
		
		wait for 10 ns;
		
		A1 <= '1';
		A2 <= '1';
		A3 <= '1';
		O1 <= '1';
		O2 <= '1';
		O3 <= '1';

		wait for 10 ns;
	        
	wait;
	
   end process;

END; 	
