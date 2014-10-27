---------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;

---------------------------------------------

entity my_dff is
port(	D:	   in std_logic;
	   Clock:  in std_logic;
	   clear:  in std_logic;
	   Q:      inout std_logic;
	   QNot:   inout std_logic
);
end my_dff;

----------------------------------------------

architecture behavior of my_dff is

begin

    process(D, Clock, clear, Q, QNot)
    begin

        -- clock rising edge
    if clear = '1' then
        Q <= '0';
        QNot <='1';
	elsif rising_edge(Clock) then
	    Q <= D;
	    QNot <= NOT D;
	end if;

    end process;	

end behavior;

----------------------------------------------