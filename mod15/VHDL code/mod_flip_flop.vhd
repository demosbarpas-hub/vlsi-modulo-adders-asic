library ieee; use ieee.std_logic_1164.all;

	entity mod_flip_flop is generic (n:integer:=32); port(
	clk, rst : in  std_logic;
        A,B: in  std_logic_vector(n-1 downto 0);
	remainder: out std_logic_vector(3 downto 0)); end mod_flip_flop;

architecture dataflow of mod_flip_flop is 

	component mod15 is 
    		generic (n:integer:=32); 
    		port(
      		  A,B: in  std_logic_vector(n-1 downto 0);
       		 remainder: out std_logic_vector(3 downto 0)
   		 ); 
	end component mod15;

    	component qd generic(n:integer:=32); port(
        q   : in  std_logic_vector(n-1 downto 0); clk, rst : in  std_logic;
        d   : out std_logic_vector(n-1 downto 0)); end component;

    	signal a_ff, b_ff: std_logic_vector(n-1 downto 0);
        signal remainder_ff,remainder_vec: std_logic_vector(3 downto 0);
begin
    --first flip flop
    a_qd: qd generic map(n) port map(a, clk, rst, a_ff); 
    b_qd: qd generic map (n) port map(b, clk, rst, b_ff);

    --carry select adder
    adder: mod15 generic map(n) port map(a_ff, b_ff, remainder_vec);
   
    --second flip flop
    rem_qd: qd generic map (4) port map(remainder_vec, clk, rst, remainder_ff);
    remainder<=remainder_ff;

end dataflow;
