library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
  port(
        a,b,cin: in  std_logic;
        sum,cout: out std_logic
    );
end full_adder;

architecture dataflow of full_adder is
  begin
    sum  <= a xor b xor cin;
    cout <= (a and b) or (a and cin) or (b and cin);
end dataflow;

library ieee;use ieee.std_logic_1164.all;

entity adder_n is generic (n:integer:=8); port(
  a,b : in std_logic_vector (n-1 downto 0);
  cin: in std_logic;
  sum: out std_logic_vector (n-1 downto 0);
  cout: out std_logic); end adder_n;

architecture dataflow of adder_n is
 
 component full_adder port(
    a,b,cin: in std_logic;
    sum,cout: out std_logic); end component;
 
 signal wire_carry:std_logic_vector(n downto 0);
 
 begin
   
   wire_carry(0) <= cin;
   
   generate_label:
   for i in  0 to n-1 generate
     full_adder_i : full_adder port map (a(i),b(i),wire_carry(i),sum(i),wire_carry(i+1));
   end generate;
   cout <= wire_carry(n);
   
end dataflow;

library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;

entity qd is generic (n:integer:=8); port (q:in std_logic_vector(n-1 downto 0); clk,rst:std_logic; 
		      			   d:out std_logic_vector(n-1 downto 0)); 
end qd;

architecture my_arch of qd is begin process(clk,rst) 
begin
	if rst='1' then
		d<=(others=>'0');
	elsif clk'event and clk='1' then
		d<=q;
	end if;
end process;
end my_arch;
