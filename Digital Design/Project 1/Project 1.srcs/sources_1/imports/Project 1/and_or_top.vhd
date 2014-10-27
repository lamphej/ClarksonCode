library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_or_top is
    Port ( A1 : in  STD_LOGIC;	-- input of AND gate
           A2 : in  STD_LOGIC;	-- input of AND gate
	       A3 : in  STD_LOGIC;	-- input of AND gate
           X  : out STD_LOGIC;	-- output of AND gate
           
           O1 : in  STD_LOGIC;	-- input of OR gate
           O2 : in  STD_LOGIC;	-- input of OR gate
           O3 : in  STD_LOGIC;	-- input of OR gate
           Y  : out STD_LOGIC);	-- output of OR gate
end and_or_top;

architecture Behavioral of and_or_top is
begin

X <= A1 and A2 and A3;   
Y <= O1 or O2 or O3;    

end Behavioral;