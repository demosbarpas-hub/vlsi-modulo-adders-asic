library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod9 is 
    generic (n: integer := 32); 
    port(
        A, B: in std_logic_vector(n-1 downto 0);
        remainder: out std_logic_vector(5 downto 0)  -- [5-0] signed
    );
end mod9;

architecture dataflow of mod9 is

    signal S: std_logic_vector(n-1 downto 0);
    signal padded_36 : std_logic_vector(35 downto 0);
    signal Module, Module_Complement : std_logic_vector(5 downto 0);

    -- Correct array type declaration
    type slv6_array is array (natural range <>) of std_logic_vector(5 downto 0);
    signal remainders : slv6_array(0 to 5);

    -- Adder tree signals
    signal sum_stage1 : slv6_array(0 to 2);
    signal sum_stage2 : slv6_array(0 to 0);

    signal sum_final : std_logic_vector(5 downto 0);
    signal sum_final_temp1,sum_final_temp2:std_logic_vector(5 downto 0);
    signal abovesum, belowsum: std_logic;
    
    -- decide if i want to calculate as if its a negative or positive number
    signal negative:std_logic;
    signal s_first:std_logic_vector(5 downto 0);
    -- Component declarations
    component adder_n is
        generic (n: integer := 6);
        port(
            a, b: in std_logic_vector(n-1 downto 0);
            cin: in std_logic;
            sum: out std_logic_vector(n-1 downto 0);
            cout: out std_logic
        );
    end component;
  
    component comparator_of_9 is
        generic (n: integer := 6); 
        port(
            S: in std_logic_vector(n-1 downto 0);
            negative: in std_logic;
            above: out std_logic; 
            below: out std_logic
        );
    end component;

    component remainder_calculator_9 is
	port (
	    data_in      : in  std_logic_vector(5 downto 0);
	    negative_first: in std_logic; 
	    remainder    : out std_logic_vector(5 downto 0)
	);
    end component;

    begin
    Module <= std_logic_vector(to_signed(9, 6));
    Module_Complement <= std_logic_vector(to_signed(-9, 6));
   
    adder : adder_n 
        generic map(n) 
        port map (A, B, '0', S, open);
    
    padded_36 <= (35 downto n => S(n-1)) & S;
    
    negative <= padded_36(35);
    
    s_first <= padded_36(35 downto 30);

    remainder_c : remainder_calculator_9
    port map(s_first,negative,
    remainders(5));



    generate_label:
    for i in 0 to 4 generate
    
    signal s_in: std_logic_vector(5 downto 0);
    begin

    s_in <= padded_36(5+i*6 downto i*6);

    remainder_c : remainder_calculator_9
	port map(s_in,'0',
	remainders(i));    
    end generate;


    -- Adder tree to sum all remainders
    -- Stage 1: Add pairs of remainders

    gen_stage1: for i in 0 to 2 generate
        adder_st1: adder_n
            generic map(6)
            port map(
                a => remainders(i*2),
                b => remainders(i*2+1),
                cin => '0',
                sum => sum_stage1(i),
                cout => open
            );
    end generate gen_stage1;
    
    -- Stage 2: Add results from stage 1

        adder_st2: adder_n
            generic map(6)
            port map(
                a => sum_stage1(0),
                b => sum_stage1(1),
                cin => '0',
                sum => sum_stage2(0),
                cout => open
            );
 
    
    -- Final adder
    adder_final: adder_n
        generic map(6)
        port map(
            a => sum_stage1(2),
            b => sum_stage2(0),
            cin => '0',
            sum => sum_final,
            cout => open
        );


    remainder_sum : remainder_calculator_9
	port map(sum_final,'0',
	remainder);    



end dataflow;
