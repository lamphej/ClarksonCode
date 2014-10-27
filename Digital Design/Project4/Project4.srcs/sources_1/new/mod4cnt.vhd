library ieee ;
use ieee.std_logic_1164.all;

entity mod4cnt is
    Port ( Cnt : in STD_LOGIC;
              Clock : in STD_LOGIC;
              clear: in STD_LOGIC;
              Q1 : inout STD_LOGIC;
              Q1not : inout STD_LOGIC;
              Q0 : inout STD_LOGIC;
              Q0not : inout STD_LOGIC);
end mod4cnt;

architecture behavior of mod4cnt is

begin
    process(Cnt, Clock, clear, Q1, Q1not, Q0, Q0not)
    begin
        if cnt = '1' then
            if Q1='0' and Q0='0' then
                Q1 <= '0';
                Q0 <= '1';
            elsif Q1='0' and Q0='1' then
                Q1 <= '1';
                Q0 <= '0';
            elsif Q1='1' and Q0='0' then
                Q1 <= '1';
                Q0 <= '1';
            elsif Q1='1' and Q0='1' then
                Q1 <= '0';
                Q0 <= '0';
            end if;
        end if;
    end process;


end behavior;