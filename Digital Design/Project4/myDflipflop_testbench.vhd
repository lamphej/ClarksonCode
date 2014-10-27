----------------------------------------------------------------
-- Test Bench for D flip-flop
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity my_dff_testbench is		-- entity declaration
end my_dff_testbench;

----------------------------------------------------------------

architecture behavior of my_dff_testbench is

    signal T_data_in: 	std_logic;
    signal T_clock:	std_logic;
    signal T_clear: std_logic;
    signal T_data_out:	std_logic;
    signal T_data_out_bar:	std_logic;
	
    component my_dff
    port(	D:	    in std_logic;
            Clock:	in std_logic;
            clear: in std_logic;
            Q:	    inout std_logic;
            QNot:	inout std_logic
    );
    end component;
		
begin

    U_DFF: my_dff port map (D=>T_data_in, Clock=>T_clock, clear=>T_clear, Q=>T_data_out, QNot=>T_data_out_bar);

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
    T_clear <= '1';
    T_data_in <= '0';
    wait for 2ns;
    
    -- case 1
    T_clear <= '0';		
	T_data_in <= '1';
	wait for 10 ns;		 

	-- case 2
	T_data_in <=  '0';	 
	wait for 28 ns;

	-- case 3
	T_data_in <= '1';					  
	wait for 2 ns;

	-- case 4
	T_data_in <= '0';
	wait for 10 ns;

	-- case 5
	T_data_in <=  '1';		
	wait for 20 ns;		

	wait;

    end process;

end behavior;
