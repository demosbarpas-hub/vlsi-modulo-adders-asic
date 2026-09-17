library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod5 is 
    generic (n: integer := 32); 
    port(
        A, B: in std_logic_vector(n-1 downto 0);
        remainder: out std_logic_vector(3 downto 0)  -- [4-0] signed
    );
end mod5;

architecture dataflow of mod5 is

    signal S: std_logic_vector(n-1 downto 0);
    signal padded_32 : std_logic_vector(31 downto 0);
    signal Module, Module_Complement : std_logic_vector(3 downto 0);

    -- Correct array type declaration
    type slv4_array is array (natural range <>) of std_logic_vector(3 downto 0);
    signal remainders : slv4_array(0 to 7);

    type slv6_array is array (natural range <>) of std_logic_vector(5 downto 0);
    -- Adder tree signals
    signal step:slv6_array(0 to 3);


    signal sum_stage1 : slv6_array(0 to 3);
    signal sum_stage2 : slv6_array(0 to 1);
    signal sum_final : std_logic_vector(5 downto 0);
    signal sum_final_temp1,sum_final_temp2:std_logic_vector(3 downto 0);
    signal abovesum, belowsum: std_logic;
    
    -- decide if i want to calculate as if its a negative or positive number
    signal negative:std_logic;
    signal s_first:std_logic_vector(3 downto 0);
    -- Component declarations
    component adder_n is
        generic (n: integer := 4);
        port(
            a, b: in std_logic_vector(n-1 downto 0);
            cin: in std_logic;
            sum: out std_logic_vector(n-1 downto 0);
            cout: out std_logic
        );
    end component;
  
    component comparator_of_5 is
        generic (n: integer := 4); 
        port(
            S: in std_logic_vector(n-1 downto 0);
            negative: in std_logic;
            above: out std_logic; 
            below: out std_logic
        );
    end component;

    component remainder_calculator is generic(n: integer := 32);
	port (
	    data_in      : in  std_logic_vector(n-1 downto 0);
	    negative_first: in std_logic; 
	    remainder    : out std_logic_vector(n-1 downto 0)
	);
    end component;

    begin
    Module <= std_logic_vector(to_signed(5, 4));
    Module_Complement <= std_logic_vector(to_signed(-5, 4));
   
    adder : adder_n 
        generic map(n) 
        port map (A, B, '0', S, open);
    
    padded_32 <= (31 downto n => S(n-1)) & S;
    
    negative <= padded_32(31);
    
    s_first <= padded_32(31 downto 28);

    remainder_c : remainder_calculator
    generic map(4)
    port map(s_first,negative,
    remainders(7));



    generate_label:
    for i in 0 to 6 generate
    
    
    signal s_in: std_logic_vector(3 downto 0);
    begin

    s_in <= padded_32(3+i*4 downto i*4);

    remainder_c : remainder_calculator
	generic map(n=>4)
	port map(s_in,'0',
	remainders(i));    
    end generate;


    -- Adder tree to sum all remainders
    -- Stage 1: Add pairs of remainders

gen_stage1: for i in 0 to 3 generate
    signal a_padded, b_padded : std_logic_vector(5 downto 0);
begin
    a_padded <= "00" & remainders(i*2);
    b_padded <= "00" & remainders(i*2+1);
    
    adder_st1: adder_n
        generic map(n => 6)
        port map(
            a => a_padded,
            b => b_padded,
            cin => '0',
            sum => sum_stage1(i),
            cout => open
        );
end generate gen_stage1;
    
    -- Stage 2: Add results from stage 1
    gen_stage2: for i in 0 to 1 generate
        adder_st2: adder_n
            generic map(6)
            port map(
                a => sum_stage1(i*2),
                b => sum_stage1(i*2+1),
                cin => '0',
                sum => sum_stage2(i),
                cout => open
            );
    end generate gen_stage2;
    
    -- Final adder
    adder_final: adder_n
        generic map(6)
        port map(
            a => sum_stage2(0),
            b => sum_stage2(1),
            cin => '0',
            sum => sum_final,
            cout => open
        );

step(0)<=sum_final;

generate_remainder_out_of_sum:
for i in 0 to 2 generate

    remainder_c : remainder_calculator
	generic map(n=>6)
	port map(step(i),'0',
	step(i+1));    
end generate;

  
        remainder <= step(3)(3 downto 0);

end dataflow;
