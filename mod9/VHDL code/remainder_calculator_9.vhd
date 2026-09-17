library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity remainder_calculator_9 is
    port (
        data_in      : in  std_logic_vector(5 downto 0);
        negative_first: in std_logic;
        remainder    : out std_logic_vector(5 downto 0)
    );
end entity;

architecture rtl of remainder_calculator_9 is
   
    signal mod9, mod9_comp : std_logic_vector(5 downto 0);

    type slv4_array is array (natural range <>) of std_logic_vector(5 downto 0);
    signal data : slv4_array(0 to 6);


component comparator_of_9 is generic (n:integer:=6); port(
        S: in  std_logic_vector(n-1 downto 0);
    negative: in std_logic;
    above: out std_logic;
        below: out std_logic
    );
end component;

    component adder_n is
        generic (n: integer := 6);
        port(
            a, b: in std_logic_vector(n-1 downto 0);
            cin: in std_logic;
            sum: out std_logic_vector(n-1 downto 0);
            cout: out std_logic
        );
    end component;

begin
    mod9 <= std_logic_vector(to_signed(9, 6));
    mod9_comp <= std_logic_vector(to_signed(-9, 6));
    
    data(0) <= "000000" when (data_in ="111111" and negative_first ='0') else --check for last one
             data_in;

generate_label:
for i in 0 to 5 generate
    signal above_i, below_i: std_logic;
    signal temp1_i, temp2_i:std_logic_vector(5 downto 0);
begin
    -- First comparison stage
    comp_i: comparator_of_9
        generic map(6)
        port map(data(i), negative_first, above_i, below_i);
    
    -- First arithmetic stage
    add_above_i: adder_n
        generic map(6)
        port map(data(i), mod9_comp, '0', temp1_i, open);
    
    add_below_i: adder_n
        generic map(6)
        port map(data(i), mod9, '0', temp2_i, open);
    
    -- Intermediate mux
    data(i+1) <= temp1_i when above_i = '1' else
                 temp2_i when below_i = '1' else
                 data(i);
    
end generate;
    -- Final output selection
    remainder <= data(6);
           

end architecture;


