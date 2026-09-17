library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator_of_7 is
  generic (n: integer := 3);
  port (
    S: in std_logic_vector(n-1 downto 0);
    negative: in std_logic;
    above: out std_logic;
    below: out std_logic
  );
end comparator_of_7;

architecture dataflow of comparator_of_7 is

  signal above_below: std_logic_vector(1 downto 0);
  signal S_padded : std_logic_vector(6 downto 0);  -- always 7 bits
begin
  S_padded <= (6 downto n => '0') & S;

  above_below <= "10" when (
                 (S_padded(6 downto 3) /= "0000" and negative = '0') or 
                 (negative = '0' and S(2) = '1' and S(1) = '1' and S(0) = '1')
                 ) else
                 "01" when (S(n-1) = '1' and negative = '1') else
                 "00";

  above <= above_below(1);
  below <= above_below(0);
end dataflow;

