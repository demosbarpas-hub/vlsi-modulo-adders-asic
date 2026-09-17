library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity remainder_calculator is generic (n:integer:=6);
    port (
        data_in      : in  std_logic_vector(n-1 downto 0);
        negative_first: in std_logic;
        remainder    : out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture rtl of remainder_calculator is
    signal above1, below1 : std_logic;
    signal above2, below2 : std_logic;
    signal temp1, temp2   : std_logic_vector(n-1 downto 0);
    signal stage2_in      : std_logic_vector(n-1 downto 0);
    signal stage2_temp1, stage2_temp2 : std_logic_vector(n-1 downto 0);
    signal data : std_logic_vector(n-1 downto 0);
    signal mod5, mod5_comp : std_logic_vector(n-1 downto 0);
    constant all_ones : std_logic_vector(n-1 downto 0) := (others => '1');

component comparator_of_5 is generic (n:integer:=4); port(
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
    mod5 <= std_logic_vector(to_signed(5, n));
    mod5_comp <= std_logic_vector(to_signed(-5, n));
    


data <= (others => '0') when (data_in = all_ones and negative_first = '0') else
        data_in;
    -- First comparison stage
    comp1: comparator_of_5
        generic map(n)
        port map(data, negative_first, above1, below1);
    
    -- First arithmetic stage
    add_above: adder_n
        generic map(n)
        port map(data, mod5_comp, '0', temp1, open);
    
    add_below: adder_n
        generic map(n)
        port map(data, mod5, '0', temp2, open);
    
    -- Intermediate mux
    stage2_in <= temp1 when above1 = '1' else
                 temp2 when below1 = '1' else
                 data;
    
    -- Second comparison stage
    comp2: comparator_of_5
        generic map(n)
        port map(stage2_in, negative_first, above2, below2);
    
    -- Second arithmetic stage
    add_above2: adder_n
        generic map(n)
        port map(stage2_in, mod5_comp, '0', stage2_temp1, open);
    
    add_below2: adder_n
        generic map(n)
        port map(stage2_in, mod5, '0', stage2_temp2, open);
    
    -- Final output selection
    remainder <= stage2_temp1 when above2 = '1' else
                 stage2_temp2 when below2 = '1' else
		 (others => '0') when (data_in = all_ones and negative_first = '0') else--for 15
                 stage2_in;

end architecture;
