----------------------------------------------------------------
-- Test Bench for Modulo-4 counter
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity my_mod4cnt_testbench is		-- entity declaration
end my_mod4cnt_testbench;

----------------------------------------------------------------

architecture behavior of my_mod4cnt_testbench is

    signal T_data_in: 	std_logic;
    signal T_clock:	std_logic;
    signal T_clear: std_logic;
    signal T_Q1 :	std_logic;
    signal T_Q1_bar :	std_logic;
	signal T_Q0 :	std_logic;
    signal T_Q0_bar :	std_logic;
    	
    component mod4cnt
    Port ( Cnt : in STD_LOGIC;
              Clock : in STD_LOGIC;
              clear: in STD_LOGIC;
              Q1 : inout STD_LOGIC;
              Q1not : inout STD_LOGIC;
              Q0 : inout STD_LOGIC;
              Q0not : inout STD_LOGIC);
    end component;
		
begin

    U_MOD4CNT: mod4cnt port map (Cnt=>T_data_in, Clock=>T_clock, clear=>T_clear, Q1=>T_Q1, Q1not=>T_Q1_bar,Q0=>T_Q0, Q0not=>T_Q0_bar);

    -- concurrent process to offer clock signal	
    process
    begin
	T_clock <= '0';
	wait for 5 ns;
	T_clock <= '1';
	wait for 5 ns;
    end process;
	
    process

    begin
    T_data_in <= '0';
    T_clear <= '1';
    wait for 2 ns;		 
		
	-- case 1
	T_clear <= '0';
	T_data_in <= '0';
	wait for 10 ns;		 

	-- case 2
	T_data_in <=  '1';	 
	wait for 28 ns;

	-- case 3
	T_data_in <= '0';					  
	wait for 18 ns;

	-- case 4
	T_data_in <= '1';
	wait for 40 ns;

	wait;

    end process;

end behavior;
