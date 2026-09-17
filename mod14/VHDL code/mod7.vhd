library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod7 is 
    generic (n: integer := 32); 
    port(
        A, B: in std_logic_vector(n-1 downto 0);
        remainder: out std_logic_vector(3 downto 0)  -- [4-0] signed
    );
end mod7;

architecture dataflow of mod7 is

    signal S: std_logic_vector(n-1 downto 0);
    signal padded_33 : std_logic_vector(32 downto 0);

    -- Correct array type declaration
    type slv4_array is array (natural range <>) of std_logic_vector(2 downto 0);
    signal remainders : slv4_array(0 to 10);
    signal sum_remain : std_logic_vector(6 downto 0);
    type slv7_array is array (natural range <>) of std_logic_vector(6 downto 0);
    -- Adder tree signals
    signal sum_stage1 : slv7_array(0 to 5);
    signal sum_stage2 : slv7_array(0 to 2);
    signal sum_final,sum_final_temp: std_logic_vector(6 downto 0);
    
    -- decide if i want to calculate as if its a negative or positive number
    signal negative:std_logic;
    signal s_first:std_logic_vector(2 downto 0);
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
  
    component comparator_of_7 is
        generic (n: integer := 4); 
        port(
            S: in std_logic_vector(n-1 downto 0);
            negative: in std_logic;
            above: out std_logic; 
            below: out std_logic
        );
    end component;

    component remainder_calculator_7 is generic (n: integer := 4); 
    port (
        data_in      : in  std_logic_vector(n-1 downto 0);
        negative_first: in std_logic; 
        remainder    : out std_logic_vector(n-1 downto 0)
    );
    end component;

    begin
   
    adder : adder_n 
        generic map(n) 
        port map (A, B, '0', S, open);
    
    padded_33 <= (32 downto n => S(n-1)) & S;
    
    negative <= padded_33(32);
    
    s_first <= padded_33(32 downto 30);

    remainder_c : remainder_calculator_7
    generic map(3)
    port map(s_first,negative,
    remainders(10));



    generate_label:
    for i in 0 to 9 generate
    
    
    signal s_in: std_logic_vector(2 downto 0);
    begin

    s_in <= padded_33(2+i*3 downto i*3);

    remainder_c : remainder_calculator_7
    generic map(3)
    port map(s_in,'0',
    remainders(i));    
    end generate;


    -- Adder tree to sum all remainders
    -- Stage 1: Add pairs of remainders

    gen_stage1: for i in 0 to 4 generate

    signal a_padded, b_padded : std_logic_vector(6 downto 0);
begin
    a_padded <= "0000" & remainders(i*2);
    b_padded <= "0000" & remainders(i*2+1);

        adder_st1: adder_n
            generic map(7)
            port map(
                a => a_padded,
                b => b_padded,
                cin => '0',
                sum => sum_stage1(i),
                cout => open
            );
    end generate gen_stage1;
    
    sum_stage1(5)<="0000"&remainders(10);

    -- Stage 2: Add results from stage 1
    gen_stage2: for i in 0 to 2 generate
        adder_st2: adder_n
            generic map(7)
            port map(
                a => sum_stage1(i*2),
                b => sum_stage1(i*2+1),
                cin => '0',
                sum => sum_stage2(i),
                cout => open
            );
    end generate gen_stage2;
       
-- Pre Final adder
    adder_prefinal: adder_n
        generic map(7)
        port map(
            a => sum_stage2(0),
            b => sum_stage2(1),
            cin => '0',
            sum => sum_final_temp,
            cout => open
        ); 
    -- Final adder
    adder_final: adder_n
        generic map(7)
        port map(
            a => sum_stage2(2),
            b => sum_final_temp,
            cin => '0',
            sum => sum_final,
            cout => open
        );

    remainder_sum : remainder_calculator_7
    generic map(7)
    port map(sum_final,'0',
    sum_remain);

    remainder <= sum_remain(3 downto 0);


end dataflow;



