library ieee; use ieee.std_logic_1164.all;

entity comparator_of_9 is generic (n:integer:=6); port(
    S: in  std_logic_vector(n-1 downto 0);
    negative: in std_logic;
    above: out std_logic;
    below: out std_logic
    );
end comparator_of_9;

architecture dataflow of comparator_of_9 is

    signal above_below : std_logic_vector(1 downto 0);
begin
  above_below<="10" when ((S(5)='1'or S(4)='1') and negative='0') or (negative='0' and S(3) = '1' and (S(2)='1' or S(1) = '1' or S(0) = '1')) else
               "01" when (S(n-1) = '1' and negative='1') else
               "00";

  above <= above_below(1);            
  below <= above_below(0);   

end dataflow;


