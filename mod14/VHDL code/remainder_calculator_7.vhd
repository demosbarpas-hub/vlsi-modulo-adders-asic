library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity remainder_calculator_7 is generic (n:integer:=7);
    port (
        data_in      : in  std_logic_vector(n-1 downto 0);
        negative_first: in std_logic;
        remainder    : out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture rtl of remainder_calculator_7 is

    signal mod7, mod7_comp : std_logic_vector(6 downto 0);
    constant all_ones : std_logic_vector(n-1 downto 0) := (others => '1');

    type slv6_array is array (natural range <>) of std_logic_vector(6 downto 0);
    signal data : slv6_array(0 to 10);

component comparator_of_7 is generic (n:integer:=4); port(
        S: in  std_logic_vector(n-1 downto 0);
    negative: in std_logic;
    above: out std_logic;
        below: out std_logic
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
    mod7 <= std_logic_vector(to_signed(7, 7));
    mod7_comp <= std_logic_vector(to_signed(-7, 7));
    


data(0) <= (others => '0') when (data_in = all_ones and negative_first = '0') else
           (6 downto n => data_in(n-1)) & data_in when negative_first ='1' else
           (6 downto n => '0') & data_in;

generate_label:
for i in 0 to 9 generate
    signal above_i, below_i: std_logic;
    signal temp1_i, temp2_i:std_logic_vector(6 downto 0);
begin
    -- First comparison stage
    comp_i: comparator_of_7
        generic map(7)
        port map(data(i), negative_first, above_i, below_i);
    
    -- First arithmetic stage
    add_above_i: adder_n
        generic map(7)
        port map(data(i), mod7_comp, '0', temp1_i, open);
    
    add_below_i: adder_n
        generic map(7)
        port map(data(i), mod7, '0', temp2_i, open);
    
    -- Intermediate mux
    data(i+1) <= temp1_i when above_i = '1' else
                 temp2_i when below_i = '1' else
                 data(i);
    
end generate;
    
    -- Final output selection
    remainder<=data(10)(n-1 downto 0);

end architecture;
