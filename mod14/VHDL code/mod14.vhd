library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod14 is 
    generic (n: integer := 32); 
    port(
        A, B: in std_logic_vector(n-1 downto 0);
        remainder: out std_logic_vector(3 downto 0)  -- [4-0] signed
    );
end mod14;

architecture dataflow of mod14 is


    signal S: std_logic_vector(n-1 downto 0);
    signal mod7_remainder:std_logic_vector(3 downto 0);


    component mod7 is 
    generic (n: integer := 32); 
    port(
        A, B: in std_logic_vector(n-1 downto 0);
        remainder: out std_logic_vector(3 downto 0)  -- [3-0] signed
    );
    end component;
    component adder_n is
        generic (n: integer := 4);
        port(
            a, b: in std_logic_vector(n-1 downto 0);
            cin: in std_logic;
            sum: out std_logic_vector(n-1 downto 0);
            cout: out std_logic
        );
    end component;

    begin
   
    adder : adder_n 
        generic map(n) 
        port map (A, B, '0', S, open);
    mod7_module: mod7
        generic map(n)
        port map (A, B, mod7_remainder);

remainder <= "0000" when (S(0) = '0' and unsigned(mod7_remainder) = 0) else -- 0
             "1000" when (S(0) = '0' and unsigned(mod7_remainder) = 1) else -- 8
             "0010" when (S(0) = '0' and unsigned(mod7_remainder) = 2) else -- 2
             "1010" when (S(0) = '0' and unsigned(mod7_remainder) = 3) else -- 10
             "0100" when (S(0) = '0' and unsigned(mod7_remainder) = 4) else -- 4
             "1100" when (S(0) = '0' and unsigned(mod7_remainder) = 5) else -- 12
             "0110" when (S(0) = '0' and unsigned(mod7_remainder) = 6) else -- 6

             "0111" when (S(0) = '1' and unsigned(mod7_remainder) = 0) else -- 7
             "0001" when (S(0) = '1' and unsigned(mod7_remainder) = 1) else -- 1
             "1001" when (S(0) = '1' and unsigned(mod7_remainder) = 2) else -- 9
             "0011" when (S(0) = '1' and unsigned(mod7_remainder) = 3) else -- 3
             "1011" when (S(0) = '1' and unsigned(mod7_remainder) = 4) else -- 11
             "0101" when (S(0) = '1' and unsigned(mod7_remainder) = 5) else -- 5
             "1101" when (S(0) = '1' and unsigned(mod7_remainder) = 6) else -- 13

             "1111"; -- default fallback (error or undefined)


end dataflow;


