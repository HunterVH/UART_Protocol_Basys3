----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2025 12:42:17 AM
-- Design Name: 
-- Module Name: uart_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_TB is
end uart_TB;

architecture Behavioral of uart_TB is
-- Signals
signal clk_TB : std_logic := '0';
signal rst_TB : std_logic := '1';
signal rx_sdata_TB : std_logic := '1';
signal busy_TB : std_logic := '0';
signal tx_sdata_TB : std_logic := '1';
signal pdata_TB : std_logic_vector(7 downto 0);

-- Types
Type array_type_char is array (0 to 20) of std_logic_vector(7 downto 0);

-- Constants
constant A : std_logic_vector(7 downto 0) := "01000001";
constant L : std_logic_vector(7 downto 0) := "01001100";
constant A_LOWER : std_logic_vector(7 downto 0) := "01100001";
constant CARET : std_logic_vector(7 downto 0) := "01011110";
constant H : std_logic_vector(7 downto 0) := "01001000";
constant U : std_logic_vector(7 downto 0) := "01010101";
constant N : std_logic_vector(7 downto 0) := "01001110";
constant T : std_logic_vector(7 downto 0) := "01010100";
constant E : std_logic_vector(7 downto 0) := "01000101";
constant R : std_logic_vector(7 downto 0) := "01010010";
constant PIPE : std_logic_vector(7 downto 0) := "01111100";
constant TWO : std_logic_vector(7 downto 0) := "00110010";
constant EIGHT : std_logic_vector(7 downto 0) := "00111000";
constant PLUS : std_logic_vector(7 downto 0) := "00101011";
constant M_LOWER : std_logic_vector(7 downto 0) := "01101101";
constant EQUAL : std_logic_vector(7 downto 0) := "00111101";
constant FRWD_SLASH : std_logic_vector(7 downto 0) := "00101111";
constant PERCENT : std_logic_vector(7 downto 0) := "00100101";
constant HASH : std_logic_vector(7 downto 0) := "00100011";
constant EXCLAMATION : std_logic_vector(7 downto 0) := "00100001";
constant AT : std_logic_vector(7 downto 0) := "01000000";
constant char_array : array_type_char := (A,L,A_LOWER,CARET,H,U,N,T,E,R,PIPE,TWO,EIGHT,PLUS,M_LOWER,EQUAL,FRWD_SLASH,PERCENT,HASH,EXCLAMATION,AT);

begin
    uart : entity work.uart
        port map(i_clk => clk_TB,
                 i_rst => rst_TB,
                 i_sdata => rx_sdata_TB,
                 o_busy => busy_TB,
                 o_sdata => tx_sdata_TB,
                 o_pdata => pdata_TB);
                 
    clk_TB <= NOT clk_TB after 5ns;
    process begin
        wait for 2.5ns;
        rst_TB <= '1';
        wait for 5ns;
        rst_TB <= '0';
        for iter in 0 to 20 loop
            wait for 25ns;
            rx_sdata_TB <= '0';                 -- Start Bit
            wait for 8680ns;
            rx_sdata_TB <= char_array(iter)(0);
            wait for 8680ns;
            rx_sdata_TB <= char_array(iter)(1);
            wait for 8680ns;
            rx_sdata_TB <= char_array(iter)(2);
            wait for 8680ns;
            rx_sdata_TB <= char_array(iter)(3);
            wait for 8680ns;
            rx_sdata_TB <= char_array(iter)(4);
            wait for 8680ns;
            rx_sdata_TB <= char_array(iter)(5);
            wait for 8680ns;
            rx_sdata_TB <= char_array(iter)(6);
            wait for 8680ns;
            rx_sdata_TB <= char_array(iter)(7);
            wait for 8680ns;
            rx_sdata_TB <= '1';                 -- Stop Bit
            
            assert pdata_TB = char_array(iter)
                report "BAD RESULT (loop: " & integer'image(iter) & ")";
            assert busy_TB = '1'
                report "NOT REPORTING BUSY (loop: " & integer'image(iter) & ", value: START)";
            assert tx_sdata_TB = '0'
                report "NOT REPORTING CORRECT BIT (loop: " & integer'image(iter) & ", value: START)";
                
            wait for 8680ns;
            
            assert busy_TB = '1'
                report "NOT REPORTING BUSY (loop: " & integer'image(iter) & ", value: 0)";
            assert tx_sdata_TB = char_array(iter)(0)
                report "NOT REPORTING CORRECT BIT (loop: " & integer'image(iter) & ", value: 0)";
                
            wait for 8680ns;
            
            assert busy_TB = '1'
                report "NOT REPORTING BUSY (loop: " & integer'image(iter) & ", value: 1)";
            assert tx_sdata_TB = char_array(iter)(1)
                report "NOT REPORTING CORRECT BIT (loop: " & integer'image(iter) & ", value: 1)";
                
            wait for 8680ns;
            
            assert busy_TB = '1'
                report "NOT REPORTING BUSY (loop: " & integer'image(iter) & ", value: 2)";
            assert tx_sdata_TB = char_array(iter)(2)
                report "NOT REPORTING CORRECT BIT (loop: " & integer'image(iter) & ", value: 2)";
                
            wait for 8680ns;
            
            assert busy_TB = '1'
                report "NOT REPORTING BUSY (loop: " & integer'image(iter) & ", value: 3)";
            assert tx_sdata_TB = char_array(iter)(3)
                report "NOT REPORTING CORRECT BIT (loop: " & integer'image(iter) & ", value: 3)";
                
            wait for 8680ns;
            
            assert busy_TB = '1'
                report "NOT REPORTING BUSY (loop: " & integer'image(iter) & ", value: 4)";
            assert tx_sdata_TB = char_array(iter)(4)
                report "NOT REPORTING CORRECT BIT (loop: " & integer'image(iter) & ", value: 4)";
                
            wait for 8680ns;
            
            assert busy_TB = '1'
                report "NOT REPORTING BUSY (loop: " & integer'image(iter) & ", value: 5)";
            assert tx_sdata_TB = char_array(iter)(5)
                report "NOT REPORTING CORRECT BIT (loop: " & integer'image(iter) & ", value: 5)";
                
            wait for 8680ns;
            
            assert busy_TB = '1'
                report "NOT REPORTING BUSY (loop: " & integer'image(iter) & ", value: 6)";
            assert tx_sdata_TB = char_array(iter)(6)
                report "NOT REPORTING CORRECT BIT (loop: " & integer'image(iter) & ", value: 6)";
                
            wait for 8680ns;
            
            assert busy_TB = '1'
                report "NOT REPORTING BUSY (loop: " & integer'image(iter) & ", value: 7)";
            assert tx_sdata_TB = char_array(iter)(7)
                report "NOT REPORTING CORRECT BIT (loop: " & integer'image(iter) & ", value: 7)";
            
            wait for 8680ns;
            
            assert busy_TB = '1'
                report "NOT REPORTING BUSY (loop: " & integer'image(iter) & ", value: STOP)";
            assert tx_sdata_TB = '1'
                report "NOT REPORTING CORRECT BIT (loop: " & integer'image(iter) & ", value: STOP)";
            
            wait for 4340ns; -- Allow the process to finish
        end loop;
        wait;
    end process;

end Behavioral;
