library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FourBitAdder is
    port(A, B: in std_logic_vector(3 downto 0); Cin: in std_logic;
        Sum: out std_logic_vector(3 downto 0); Cout: out std_logic);
end entity FourBitAdder;

architecture FourBitAdderFunction of FourBitAdder is
signal C: std_logic_vector(3 downto 0);

component FullAdder is 
    port(A, B: in std_logic; Cin: in std_logic; Sum: out std_logic; Cout: out std_logic);
end component FullAdder;   

begin
    FA1: FullAdder port map(A => A(0), B => B(0), Cin => Cin, Sum => Sum(0), Cout => C(1));
    FA2: FullAdder port map(A => A(1), B => B(1), Cin => C(1), Sum => Sum(1), Cout => C(2));
    FA3: FullAdder port map(A => A(2), B => B(2), Cin => C(2), Sum => Sum(2), Cout => C(3));
    FA4: FullAdder port map(A => A(3), B => B(3), Cin => C(3), Sum => Sum(3), Cout => Cout);
end architecture FourBitAdderFunction;            