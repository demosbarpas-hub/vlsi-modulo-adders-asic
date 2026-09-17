library ieee;use ieee.std_logic_1164.all;

entity TestBench is end entity;

architecture dataflow of TestBench is
  component mod_flip_flop is port( 
	clk, rst : in  std_logic;
	a,b : in  std_logic_vector(31 downto 0);
	remainder:out std_logic_vector(5 downto 0));
  end component;
  signal a,b: std_logic_vector(31 downto 0) := (others => '0');
  signal clk,rst : std_logic;
  signal remainder:std_logic_vector(5 downto 0);

begin
  uut: mod_flip_flop generic map (32) port map(clk,rst,a,b,remainder);
  clk_proc: process 
  begin
    wait for 1 ns; 
    loop
      clk <= '0'; wait for 10 ns;
      clk <= '1'; wait for 10 ns;
    end loop;
  end process;

  process begin	

    rst<='0';wait for 1 ns;

    a <= "00000000000000000000000011011000"; 
    b <= "00000000000000000000000100101100"; 
    wait for 40 ns;
    a <= "11111111111111111111111110100100"; 
    b <= "00000000000000000000000001100100"; 
    wait for 40 ns; 

    a <= "00101010101010101010101010101010"; 
    b <= "00010101010101010101010101010101"; 
    wait for 40 ns;
    a <= "11010101010101010101010101010101"; 
    b <= "11101010101010101010101010101011"; 
    wait for 40 ns;

    a <= "01111111111111111111111111111111"; 
    b <= "11111111111111111111111111111111"; 
    wait for 40 ns;

    wait; -- Stop simulation
  end process;
end architecture;