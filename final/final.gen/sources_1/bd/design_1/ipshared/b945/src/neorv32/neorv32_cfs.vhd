-- ================================================================================ --
-- NEORV32 SoC - Custom Functions Subsystem (CFS)                                   --
-- AES-128 + GIFT-128 Hardware Co-Processor                                         --
-- -------------------------------------------------------------------------------- --
-- Register Map (word-addressed, 32-bit):                                            --
--   REG[0]  : Control(W) / Status(R)  write: 1=AES enc, 2=AES dec,                 --
--                                            3=GIFT enc, 4=GIFT dec                 --
--                                     read:  bit0=done, bit1=busy                   --
--   REG[1..4] : Key words 0..3 (128-bit, big-endian byte order)                     --
--   REG[5..8] : Input block words 0..3                                              --
--   REG[9..12]: Output block words 0..3 (read-only)                                 --
-- ================================================================================ --
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_cfs is
  port (
    clk_i     : in  std_ulogic;
    rstn_i    : in  std_ulogic;
    bus_req_i : in  bus_req_t;
    bus_rsp_o : out bus_rsp_t;
    irq_o     : out std_ulogic;
    cfs_in_i  : in  std_ulogic_vector(255 downto 0);
    cfs_out_o : out std_ulogic_vector(255 downto 0)
  );
end neorv32_cfs;

architecture neorv32_cfs_rtl of neorv32_cfs is

  type word4_t  is array (0 to 3)  of std_ulogic_vector(31 downto 0);
  type word44_t is array (0 to 43) of std_ulogic_vector(31 downto 0);

  -- AES S-box: forward [0..255] + inverse [256..511]
  type rom512x8_t is array (0 to 511) of std_ulogic_vector(7 downto 0);
  constant AES_SBOX : rom512x8_t := (
    x"63",x"7c",x"77",x"7b",x"f2",x"6b",x"6f",x"c5",x"30",x"01",x"67",x"2b",x"fe",x"d7",x"ab",x"76",
    x"ca",x"82",x"c9",x"7d",x"fa",x"59",x"47",x"f0",x"ad",x"d4",x"a2",x"af",x"9c",x"a4",x"72",x"c0",
    x"b7",x"fd",x"93",x"26",x"36",x"3f",x"f7",x"cc",x"34",x"a5",x"e5",x"f1",x"71",x"d8",x"31",x"15",
    x"04",x"c7",x"23",x"c3",x"18",x"96",x"05",x"9a",x"07",x"12",x"80",x"e2",x"eb",x"27",x"b2",x"75",
    x"09",x"83",x"2c",x"1a",x"1b",x"6e",x"5a",x"a0",x"52",x"3b",x"d6",x"b3",x"29",x"e3",x"2f",x"84",
    x"53",x"d1",x"00",x"ed",x"20",x"fc",x"b1",x"5b",x"6a",x"cb",x"be",x"39",x"4a",x"4c",x"58",x"cf",
    x"d0",x"ef",x"aa",x"fb",x"43",x"4d",x"33",x"85",x"45",x"f9",x"02",x"7f",x"50",x"3c",x"9f",x"a8",
    x"51",x"a3",x"40",x"8f",x"92",x"9d",x"38",x"f5",x"bc",x"b6",x"da",x"21",x"10",x"ff",x"f3",x"d2",
    x"cd",x"0c",x"13",x"ec",x"5f",x"97",x"44",x"17",x"c4",x"a7",x"7e",x"3d",x"64",x"5d",x"19",x"73",
    x"60",x"81",x"4f",x"dc",x"22",x"2a",x"90",x"88",x"46",x"ee",x"b8",x"14",x"de",x"5e",x"0b",x"db",
    x"e0",x"32",x"3a",x"0a",x"49",x"06",x"24",x"5c",x"c2",x"d3",x"ac",x"62",x"91",x"95",x"e4",x"79",
    x"e7",x"c8",x"37",x"6d",x"8d",x"d5",x"4e",x"a9",x"6c",x"56",x"f4",x"ea",x"65",x"7a",x"ae",x"08",
    x"ba",x"78",x"25",x"2e",x"1c",x"a6",x"b4",x"c6",x"e8",x"dd",x"74",x"1f",x"4b",x"bd",x"8b",x"8a",
    x"70",x"3e",x"b5",x"66",x"48",x"03",x"f6",x"0e",x"61",x"35",x"57",x"b9",x"86",x"c1",x"1d",x"9e",
    x"e1",x"f8",x"98",x"11",x"69",x"d9",x"8e",x"94",x"9b",x"1e",x"87",x"e9",x"ce",x"55",x"28",x"df",
    x"8c",x"a1",x"89",x"0d",x"bf",x"e6",x"42",x"68",x"41",x"99",x"2d",x"0f",x"b0",x"54",x"bb",x"16",
    x"52",x"09",x"6a",x"d5",x"30",x"36",x"a5",x"38",x"bf",x"40",x"a3",x"9e",x"81",x"f3",x"d7",x"fb",
    x"7c",x"e3",x"39",x"82",x"9b",x"2f",x"ff",x"87",x"34",x"8e",x"43",x"44",x"c4",x"de",x"e9",x"cb",
    x"54",x"7b",x"94",x"32",x"a6",x"c2",x"23",x"3d",x"ee",x"4c",x"95",x"0b",x"42",x"fa",x"c3",x"4e",
    x"08",x"2e",x"a1",x"66",x"28",x"d9",x"24",x"b2",x"76",x"5b",x"a2",x"49",x"6d",x"8b",x"d1",x"25",
    x"72",x"f8",x"f6",x"64",x"86",x"68",x"98",x"16",x"d4",x"a4",x"5c",x"cc",x"5d",x"65",x"b6",x"92",
    x"6c",x"70",x"48",x"50",x"fd",x"ed",x"b9",x"da",x"5e",x"15",x"46",x"57",x"a7",x"8d",x"9d",x"84",
    x"90",x"d8",x"ab",x"00",x"8c",x"bc",x"d3",x"0a",x"f7",x"e4",x"58",x"05",x"b8",x"b3",x"45",x"06",
    x"d0",x"2c",x"1e",x"8f",x"ca",x"3f",x"0f",x"02",x"c1",x"af",x"bd",x"03",x"01",x"13",x"8a",x"6b",
    x"3a",x"91",x"11",x"41",x"4f",x"67",x"dc",x"ea",x"97",x"f2",x"cf",x"ce",x"f0",x"b4",x"e6",x"73",
    x"96",x"ac",x"74",x"22",x"e7",x"ad",x"35",x"85",x"e2",x"f9",x"37",x"e8",x"1c",x"75",x"df",x"6e",
    x"47",x"f1",x"1a",x"71",x"1d",x"29",x"c5",x"89",x"6f",x"b7",x"62",x"0e",x"aa",x"18",x"be",x"1b",
    x"fc",x"56",x"3e",x"4b",x"c6",x"d2",x"79",x"20",x"9a",x"db",x"c0",x"fe",x"78",x"cd",x"5a",x"f4",
    x"1f",x"dd",x"a8",x"33",x"88",x"07",x"c7",x"31",x"b1",x"12",x"10",x"59",x"27",x"80",x"ec",x"5f",
    x"60",x"51",x"7f",x"a9",x"19",x"b5",x"4a",x"0d",x"2d",x"e5",x"7a",x"9f",x"93",x"c9",x"9c",x"ef",
    x"a0",x"e0",x"3b",x"4d",x"ae",x"2a",x"f5",x"b0",x"c8",x"eb",x"bb",x"3c",x"83",x"53",x"99",x"61",
    x"17",x"2b",x"04",x"7e",x"ba",x"77",x"d6",x"26",x"e1",x"69",x"14",x"63",x"55",x"21",x"0c",x"7d"
  );

  type rcon8_t is array (0 to 9) of std_ulogic_vector(7 downto 0);
  constant AES_RCON : rcon8_t := (
    x"01",x"02",x"04",x"08",x"10",x"20",x"40",x"80",x"1b",x"36"
  );

  type gift_rc_t is array (0 to 39) of std_ulogic_vector(5 downto 0);
  constant GIFT_RC : gift_rc_t := (
    "000001","000011","000111","001111","011111","111110","111101","111011",
    "110111","101111","011110","111100","111001","110011","100111","001110",
    "011101","111010","110101","101011","010110","101100","011000","110000",
    "100001","000010","000101","001011","010111","101110","011100","111000",
    "110001","100011","000110","001101","011011","110110","101101","011010"
  );

  function xtime(a : std_ulogic_vector(7 downto 0)) return std_ulogic_vector is
    variable r : std_ulogic_vector(7 downto 0);
  begin
    r := a(6 downto 0) & '0';
    if a(7) = '1' then r := r xor x"1b"; end if;
    return r;
  end function;

  function gmul2(a : std_ulogic_vector(7 downto 0)) return std_ulogic_vector is
  begin return xtime(a); end function;

  function gmul3(a : std_ulogic_vector(7 downto 0)) return std_ulogic_vector is
  begin return xtime(a) xor a; end function;

  function gmul9(a : std_ulogic_vector(7 downto 0)) return std_ulogic_vector is
  begin return xtime(xtime(xtime(a))) xor a; end function;

  function gmulb(a : std_ulogic_vector(7 downto 0)) return std_ulogic_vector is
  begin return xtime(xtime(xtime(a))) xor xtime(a) xor a; end function;

  function gmuld(a : std_ulogic_vector(7 downto 0)) return std_ulogic_vector is
  begin return xtime(xtime(xtime(a))) xor xtime(xtime(a)) xor a; end function;

  function gmule(a : std_ulogic_vector(7 downto 0)) return std_ulogic_vector is
  begin return xtime(xtime(xtime(a))) xor xtime(xtime(a)) xor xtime(a); end function;

  function sub_word(w : std_ulogic_vector(31 downto 0)) return std_ulogic_vector is
    variable r : std_ulogic_vector(31 downto 0);
  begin
    r(31 downto 24) := AES_SBOX(to_integer(unsigned(w(31 downto 24))));
    r(23 downto 16) := AES_SBOX(to_integer(unsigned(w(23 downto 16))));
    r(15 downto  8) := AES_SBOX(to_integer(unsigned(w(15 downto  8))));
    r( 7 downto  0) := AES_SBOX(to_integer(unsigned(w( 7 downto  0))));
    return r;
  end function;

  function rot_word(w : std_ulogic_vector(31 downto 0)) return std_ulogic_vector is
  begin return w(23 downto 0) & w(31 downto 24); end function;

  function get_byte(s : word4_t; row : integer; col : integer)
      return std_ulogic_vector is
  begin
    case row is
      when 0      => return s(col)(31 downto 24);
      when 1      => return s(col)(23 downto 16);
      when 2      => return s(col)(15 downto  8);
      when others => return s(col)( 7 downto  0);
    end case;
  end function;

  function aes_sb_sr_col(s : word4_t; col : integer; inv : std_ulogic)
      return std_ulogic_vector is
    variable b0,b1,b2,b3 : std_ulogic_vector(7 downto 0);
  begin
    if inv = '0' then
      b0 := AES_SBOX(to_integer(unsigned(get_byte(s,0,(col+0) mod 4))));
      b1 := AES_SBOX(to_integer(unsigned(get_byte(s,1,(col+1) mod 4))));
      b2 := AES_SBOX(to_integer(unsigned(get_byte(s,2,(col+2) mod 4))));
      b3 := AES_SBOX(to_integer(unsigned(get_byte(s,3,(col+3) mod 4))));
    else
      b0 := AES_SBOX(256+to_integer(unsigned(get_byte(s,0,(col+0) mod 4))));
      b1 := AES_SBOX(256+to_integer(unsigned(get_byte(s,1,(col+3) mod 4))));
      b2 := AES_SBOX(256+to_integer(unsigned(get_byte(s,2,(col+2) mod 4))));
      b3 := AES_SBOX(256+to_integer(unsigned(get_byte(s,3,(col+1) mod 4))));
    end if;
    return b0 & b1 & b2 & b3;
  end function;

  function mix_col(c : std_ulogic_vector(31 downto 0)) return std_ulogic_vector is
    variable a0,a1,a2,a3 : std_ulogic_vector(7 downto 0);
  begin
    a0:=c(31 downto 24); a1:=c(23 downto 16); a2:=c(15 downto 8); a3:=c(7 downto 0);
    return (gmul2(a0) xor gmul3(a1) xor a2         xor a3        )
         & (a0        xor gmul2(a1) xor gmul3(a2)  xor a3        )
         & (a0        xor a1        xor gmul2(a2)  xor gmul3(a3) )
         & (gmul3(a0) xor a1        xor a2         xor gmul2(a3) );
  end function;

  function mix_col_inv(c : std_ulogic_vector(31 downto 0)) return std_ulogic_vector is
    variable a0,a1,a2,a3 : std_ulogic_vector(7 downto 0);
  begin
    a0:=c(31 downto 24); a1:=c(23 downto 16); a2:=c(15 downto 8); a3:=c(7 downto 0);
    return (gmule(a0) xor gmulb(a1) xor gmuld(a2) xor gmul9(a3))
         & (gmul9(a0) xor gmule(a1) xor gmulb(a2) xor gmuld(a3))
         & (gmuld(a0) xor gmul9(a1) xor gmule(a2) xor gmulb(a3))
         & (gmulb(a0) xor gmuld(a1) xor gmul9(a2) xor gmule(a3));
  end function;

  function gift_sub_cells_f(s : word4_t) return word4_t is
    variable a,b,c,d,t : std_ulogic_vector(31 downto 0);
    variable r : word4_t;
  begin
    a := s(0); b := s(1); c := s(2); d := s(3);
    b := b xor (a and c);
    a := a xor (b and d);
    c := c xor (a or b);
    d := d xor c;
    b := b xor d;
    d := d xor x"ffffffff";
    c := c xor (a and b);
    t := a;
    a := d;
    d := t;
    r(0) := a; r(1) := b; r(2) := c; r(3) := d;
    return r;
  end function;

  function gift_sub_cells_inv_f(s : word4_t) return word4_t is
    variable r : word4_t;
    variable x : std_ulogic_vector(3 downto 0);
    variable y : std_ulogic_vector(3 downto 0);
  begin
    r := (others => (others => '0'));
    for i in 0 to 31 loop
      x(0) := s(0)(i);
      x(1) := s(1)(i);
      x(2) := s(2)(i);
      x(3) := s(3)(i);
      case x is
        when "0000" => y := "1101";
        when "0001" => y := "0000";
        when "0010" => y := "1000";
        when "0011" => y := "0110";
        when "0100" => y := "0010";
        when "0101" => y := "1100";
        when "0110" => y := "0100";
        when "0111" => y := "1011";
        when "1000" => y := "1110";
        when "1001" => y := "0111";
        when "1010" => y := "0001";
        when "1011" => y := "1010";
        when "1100" => y := "0011";
        when "1101" => y := "1001";
        when "1110" => y := "1111";
        when others => y := "0101";
      end case;
      r(0)(i) := y(0);
      r(1)(i) := y(1);
      r(2)(i) := y(2);
      r(3)(i) := y(3);
    end loop;
    return r;
  end function;

  function gift_rowperm_f(
    s      : std_ulogic_vector(31 downto 0);
    b0_pos : natural;
    b1_pos : natural;
    b2_pos : natural;
    b3_pos : natural
  ) return std_ulogic_vector is
    variable t : std_ulogic_vector(31 downto 0);
  begin
    t := (others => '0');
    for b in 0 to 7 loop
      t(b + 8*b0_pos) := s(4*b + 0);
      t(b + 8*b1_pos) := s(4*b + 1);
      t(b + 8*b2_pos) := s(4*b + 2);
      t(b + 8*b3_pos) := s(4*b + 3);
    end loop;
    return t;
  end function;

  function gift_rowperm_inv_f(
    s      : std_ulogic_vector(31 downto 0);
    b0_pos : natural;
    b1_pos : natural;
    b2_pos : natural;
    b3_pos : natural
  ) return std_ulogic_vector is
    variable t : std_ulogic_vector(31 downto 0);
  begin
    t := (others => '0');
    for b in 0 to 7 loop
      t(4*b + 0) := s(b + 8*b0_pos);
      t(4*b + 1) := s(b + 8*b1_pos);
      t(4*b + 2) := s(b + 8*b2_pos);
      t(4*b + 3) := s(b + 8*b3_pos);
    end loop;
    return t;
  end function;

  function gift_perm_bits_f(s : word4_t) return word4_t is
    variable r : word4_t;
  begin
    r(0) := gift_rowperm_f(s(0), 0, 3, 2, 1);
    r(1) := gift_rowperm_f(s(1), 1, 0, 3, 2);
    r(2) := gift_rowperm_f(s(2), 2, 1, 0, 3);
    r(3) := gift_rowperm_f(s(3), 3, 2, 1, 0);
    return r;
  end function;

  function gift_perm_bits_inv_f(s : word4_t) return word4_t is
    variable r : word4_t;
  begin
    r(0) := gift_rowperm_inv_f(s(0), 0, 3, 2, 1);
    r(1) := gift_rowperm_inv_f(s(1), 1, 0, 3, 2);
    r(2) := gift_rowperm_inv_f(s(2), 2, 1, 0, 3);
    r(3) := gift_rowperm_inv_f(s(3), 3, 2, 1, 0);
    return r;
  end function;

  function gift_extract_rk(kw : std_ulogic_vector(127 downto 0))
      return std_ulogic_vector is
  begin
    return kw(95 downto 64) & kw(31 downto 0);
  end function;

  function gift_key_update(kw : std_ulogic_vector(127 downto 0))
      return std_ulogic_vector is
    variable w0,w1,w2,w3,w4,w5,w6,w7 : std_ulogic_vector(15 downto 0);
    variable t6,t7                   : std_ulogic_vector(15 downto 0);
  begin
    w0 := kw(127 downto 112);
    w1 := kw(111 downto 96);
    w2 := kw(95 downto 80);
    w3 := kw(79 downto 64);
    w4 := kw(63 downto 48);
    w5 := kw(47 downto 32);
    w6 := kw(31 downto 16);
    w7 := kw(15 downto 0);
    t6 := w6(1 downto 0) & w6(15 downto 2);
    t7 := w7(11 downto 0) & w7(15 downto 12);
    return t6 & t7 & w0 & w1 & w2 & w3 & w4 & w5;
  end function;

  function gift_add_rk(s   : word4_t;
                       rk  : std_ulogic_vector(63 downto 0);
                       rc  : std_ulogic_vector(5 downto 0)) return word4_t is
    variable r   : word4_t;
    variable rcm : std_ulogic_vector(31 downto 0);
  begin
    r    := s;
    rcm  := (others => '0');
    rcm(5 downto 0) := rc;
    r(1) := s(1) xor rk(31 downto 0);
    r(2) := s(2) xor rk(63 downto 32);
    r(3) := s(3) xor x"80000000" xor rcm;
    return r;
  end function;

  signal cfs_key  : word4_t;
  signal cfs_din  : word4_t;
  signal cfs_dout : word4_t;

  signal status_done : std_ulogic;
  signal status_busy : std_ulogic;
  signal cmd_reg     : std_ulogic_vector(3 downto 0);

  type fsm_t is (ST_IDLE,
                 ST_AES_KEYSCHED, ST_AES_ROUND, ST_AES_DONE,
                 ST_GIFT_KEYGEN,  ST_GIFT_ROUND, ST_GIFT_DONE);
  signal fsm_state : fsm_t;

  signal aes_s         : word4_t;
  signal aes_rk        : word44_t;
  -- Holds the 4 most-recently-computed key words for pipelined key schedule
  signal aes_rk_prev   : word4_t;
  signal aes_round_cnt : integer range 0 to 15;
  signal aes_decrypt   : std_ulogic;

  signal gift_s         : word4_t;
  signal gift_kw        : std_ulogic_vector(127 downto 0);
  signal gift_round_cnt : integer range 0 to 39;
  signal gift_decrypt   : std_ulogic;

  type gift_rk_arr_t is array (0 to 39) of std_ulogic_vector(63 downto 0);
  signal gift_rk_store : gift_rk_arr_t;

begin

  cfs_out_o <= (others => '0');
  irq_o     <= '0';

  bus_access: process(rstn_i, clk_i)
    -- Only 4 words needed per pipeline stage (indices 0-3 used)
    variable v_rk   : word44_t;
    variable v_t    : std_ulogic_vector(31 downto 0);
    variable v_ns   : word4_t;
    variable v_rki  : integer;
    variable v_rk64 : std_ulogic_vector(63 downto 0);
  begin
    if rstn_i = '0' then
      cfs_key        <= (others => (others => '0'));
      cfs_din        <= (others => (others => '0'));
      cfs_dout       <= (others => (others => '0'));
      cmd_reg        <= (others => '0');
      status_done    <= '0';
      status_busy    <= '0';
      fsm_state      <= ST_IDLE;
      aes_round_cnt  <= 0;
      aes_decrypt    <= '0';
      aes_s          <= (others => (others => '0'));
      aes_rk         <= (others => (others => '0'));
      aes_rk_prev    <= (others => (others => '0'));
      gift_round_cnt <= 0;
      gift_decrypt   <= '0';
      gift_s         <= (others => (others => '0'));
      gift_kw        <= (others => '0');
      gift_rk_store  <= (others => (others => '0'));
      bus_rsp_o      <= rsp_terminate_c;

    elsif rising_edge(clk_i) then
      bus_rsp_o.ack  <= bus_req_i.stb;
      bus_rsp_o.err  <= '0';
      bus_rsp_o.data <= (others => '0');

      if bus_req_i.stb = '1' then
        if bus_req_i.rw = '1' then
          case to_integer(unsigned(bus_req_i.addr(5 downto 2))) is
            when 0 => cmd_reg <= bus_req_i.data(3 downto 0);
                      status_done <= '0'; status_busy <= '1';
            when 1 => cfs_key(0) <= bus_req_i.data;
            when 2 => cfs_key(1) <= bus_req_i.data;
            when 3 => cfs_key(2) <= bus_req_i.data;
            when 4 => cfs_key(3) <= bus_req_i.data;
            when 5 => cfs_din(0) <= bus_req_i.data;
            when 6 => cfs_din(1) <= bus_req_i.data;
            when 7 => cfs_din(2) <= bus_req_i.data;
            when 8 => cfs_din(3) <= bus_req_i.data;
            when others => null;
          end case;
        else
          case to_integer(unsigned(bus_req_i.addr(5 downto 2))) is
            when 0  => bus_rsp_o.data <= (1 => status_busy, 0 => status_done, others => '0');
            when 9  => bus_rsp_o.data <= cfs_dout(0);
            when 10 => bus_rsp_o.data <= cfs_dout(1);
            when 11 => bus_rsp_o.data <= cfs_dout(2);
            when 12 => bus_rsp_o.data <= cfs_dout(3);
            when others => null;
          end case;
        end if;
      end if;

      case fsm_state is

        when ST_IDLE =>
          if status_busy = '1' then
            case cmd_reg is
              when x"1" | x"2" =>
                aes_decrypt   <= cmd_reg(1);
                aes_round_cnt <= 0;
                fsm_state     <= ST_AES_KEYSCHED;
              when x"3" | x"4" =>
                gift_s(0) <= cfs_din(0); gift_s(1) <= cfs_din(1);
                gift_s(2) <= cfs_din(2); gift_s(3) <= cfs_din(3);
                gift_kw(127 downto 96) <= cfs_key(0);
                gift_kw( 95 downto 64) <= cfs_key(1);
                gift_kw( 63 downto 32) <= cfs_key(2);
                gift_kw( 31 downto  0) <= cfs_key(3);
                gift_decrypt   <= cmd_reg(1);
                gift_round_cnt <= 0;
                if cmd_reg(1) = '1' then
                  fsm_state <= ST_GIFT_KEYGEN;
                else
                  fsm_state <= ST_GIFT_ROUND;
                end if;
              when others =>
                status_busy <= '0'; status_done <= '1';
            end case;
          end if;

        -- ------------------------------------------------------------------ --
        -- AES Key Schedule: pipelined, one round key (4 words) per clock.    --
        --   aes_round_cnt=0  : capture key words 0-3, prime aes_rk_prev      --
        --   aes_round_cnt=1-10: expand next 4 words, store into aes_rk       --
        --   After count=10   : setup initial XOR into aes_s, go to ST_AES_ROUND
        -- Critical path per cycle: RotWord→SubWord→XOR×4 (+MixColInv opt.)  --
        -- Total latency: 11 cycles here + 10 AES rounds = 21 cycles          --
        -- ------------------------------------------------------------------ --
        when ST_AES_KEYSCHED =>
          if aes_round_cnt = 0 then
            -- Cycle 0: store original key as round key 0, prime the pipeline
            aes_rk(0)      <= cfs_key(0);
            aes_rk(1)      <= cfs_key(1);
            aes_rk(2)      <= cfs_key(2);
            aes_rk(3)      <= cfs_key(3);
            aes_rk_prev(0) <= cfs_key(0);
            aes_rk_prev(1) <= cfs_key(1);
            aes_rk_prev(2) <= cfs_key(2);
            aes_rk_prev(3) <= cfs_key(3);
            aes_round_cnt  <= 1;
          else
            -- Cycles 1-10: expand one round of key schedule
            -- w[i] = w[i-4] XOR g(w[i-1]) where g = SubWord(RotWord) XOR Rcon
            v_t     := sub_word(rot_word(aes_rk_prev(3))) xor
                       (AES_RCON(aes_round_cnt - 1) & x"000000");
            v_rk(0) := aes_rk_prev(0) xor v_t;
            v_rk(1) := aes_rk_prev(1) xor v_rk(0);
            v_rk(2) := aes_rk_prev(2) xor v_rk(1);
            v_rk(3) := aes_rk_prev(3) xor v_rk(2);
            v_rki   := aes_round_cnt * 4;  -- base index: 4, 8, ..., 40
            -- For decrypt, apply InvMixColumns to middle round keys (rounds 1-9)
            -- Round 10 (words 40-43) and round 0 are NOT transformed
            if aes_decrypt = '1' and aes_round_cnt < 10 then
              aes_rk(v_rki + 0) <= mix_col_inv(v_rk(0));
              aes_rk(v_rki + 1) <= mix_col_inv(v_rk(1));
              aes_rk(v_rki + 2) <= mix_col_inv(v_rk(2));
              aes_rk(v_rki + 3) <= mix_col_inv(v_rk(3));
            else
              aes_rk(v_rki + 0) <= v_rk(0);
              aes_rk(v_rki + 1) <= v_rk(1);
              aes_rk(v_rki + 2) <= v_rk(2);
              aes_rk(v_rki + 3) <= v_rk(3);
            end if;
            -- Update pipeline register for next cycle
            aes_rk_prev(0) <= v_rk(0);
            aes_rk_prev(1) <= v_rk(1);
            aes_rk_prev(2) <= v_rk(2);
            aes_rk_prev(3) <= v_rk(3);
            if aes_round_cnt = 10 then
              -- Key schedule complete; perform initial AddRoundKey into aes_s
              if aes_decrypt = '1' then
                -- Decrypt: XOR ciphertext with last round key (words 40-43)
                aes_s(0) <= cfs_din(0) xor v_rk(0);
                aes_s(1) <= cfs_din(1) xor v_rk(1);
                aes_s(2) <= cfs_din(2) xor v_rk(2);
                aes_s(3) <= cfs_din(3) xor v_rk(3);
              else
                -- Encrypt: XOR plaintext with first round key (words 0-3 = original key)
                aes_s(0) <= cfs_din(0) xor cfs_key(0);
                aes_s(1) <= cfs_din(1) xor cfs_key(1);
                aes_s(2) <= cfs_din(2) xor cfs_key(2);
                aes_s(3) <= cfs_din(3) xor cfs_key(3);
              end if;
              aes_round_cnt <= 0;
              fsm_state     <= ST_AES_ROUND;
            else
              aes_round_cnt <= aes_round_cnt + 1;
            end if;
          end if;

        when ST_AES_ROUND =>
          if aes_decrypt = '0' then
            v_rki   := 4 * (aes_round_cnt + 1);
            v_ns(0) := aes_sb_sr_col(aes_s, 0, '0');
            v_ns(1) := aes_sb_sr_col(aes_s, 1, '0');
            v_ns(2) := aes_sb_sr_col(aes_s, 2, '0');
            v_ns(3) := aes_sb_sr_col(aes_s, 3, '0');
            if aes_round_cnt < 9 then
              aes_s(0) <= mix_col(v_ns(0)) xor aes_rk(v_rki+0);
              aes_s(1) <= mix_col(v_ns(1)) xor aes_rk(v_rki+1);
              aes_s(2) <= mix_col(v_ns(2)) xor aes_rk(v_rki+2);
              aes_s(3) <= mix_col(v_ns(3)) xor aes_rk(v_rki+3);
            else
              aes_s(0) <= v_ns(0) xor aes_rk(v_rki+0);
              aes_s(1) <= v_ns(1) xor aes_rk(v_rki+1);
              aes_s(2) <= v_ns(2) xor aes_rk(v_rki+2);
              aes_s(3) <= v_ns(3) xor aes_rk(v_rki+3);
            end if;
          else
            v_rki   := 4 * (9 - aes_round_cnt);
            v_ns(0) := aes_sb_sr_col(aes_s, 0, '1');
            v_ns(1) := aes_sb_sr_col(aes_s, 1, '1');
            v_ns(2) := aes_sb_sr_col(aes_s, 2, '1');
            v_ns(3) := aes_sb_sr_col(aes_s, 3, '1');
            if aes_round_cnt < 9 then
              aes_s(0) <= mix_col_inv(v_ns(0)) xor aes_rk(v_rki+0);
              aes_s(1) <= mix_col_inv(v_ns(1)) xor aes_rk(v_rki+1);
              aes_s(2) <= mix_col_inv(v_ns(2)) xor aes_rk(v_rki+2);
              aes_s(3) <= mix_col_inv(v_ns(3)) xor aes_rk(v_rki+3);
            else
              aes_s(0) <= v_ns(0) xor aes_rk(v_rki+0);
              aes_s(1) <= v_ns(1) xor aes_rk(v_rki+1);
              aes_s(2) <= v_ns(2) xor aes_rk(v_rki+2);
              aes_s(3) <= v_ns(3) xor aes_rk(v_rki+3);
            end if;
          end if;
          if aes_round_cnt = 9 then
            fsm_state <= ST_AES_DONE;
          else
            aes_round_cnt <= aes_round_cnt + 1;
          end if;

        when ST_AES_DONE =>
          cfs_dout    <= aes_s;
          status_busy <= '0';
          status_done <= '1';
          fsm_state   <= ST_IDLE;

        when ST_GIFT_KEYGEN =>
          gift_rk_store(gift_round_cnt) <= gift_extract_rk(gift_kw);
          gift_kw <= gift_key_update(gift_kw);
          if gift_round_cnt = 39 then
            gift_s(0) <= cfs_din(0); gift_s(1) <= cfs_din(1);
            gift_s(2) <= cfs_din(2); gift_s(3) <= cfs_din(3);
            gift_round_cnt <= 0;
            fsm_state      <= ST_GIFT_ROUND;
          else
            gift_round_cnt <= gift_round_cnt + 1;
          end if;

        when ST_GIFT_ROUND =>
          if gift_decrypt = '0' then
            v_rk64 := gift_extract_rk(gift_kw);
            v_ns   := gift_sub_cells_f(gift_s);
            v_ns   := gift_perm_bits_f(v_ns);
            v_ns   := gift_add_rk(v_ns, v_rk64, GIFT_RC(gift_round_cnt));
            gift_s  <= v_ns;
            gift_kw <= gift_key_update(gift_kw);
          else
            v_rk64 := gift_rk_store(39 - gift_round_cnt);
            v_ns   := gift_add_rk(gift_s, v_rk64, GIFT_RC(39 - gift_round_cnt));
            v_ns   := gift_perm_bits_inv_f(v_ns);
            v_ns   := gift_sub_cells_inv_f(v_ns);
            gift_s <= v_ns;
          end if;
          if gift_round_cnt = 39 then
            fsm_state <= ST_GIFT_DONE;
          else
            gift_round_cnt <= gift_round_cnt + 1;
          end if;

        when ST_GIFT_DONE =>
          cfs_dout(0) <= gift_s(0);
          cfs_dout(1) <= gift_s(1);
          cfs_dout(2) <= gift_s(2);
          cfs_dout(3) <= gift_s(3);
          status_busy <= '0';
          status_done <= '1';
          fsm_state   <= ST_IDLE;

        when others =>
          fsm_state <= ST_IDLE;

      end case;
    end if;
  end process bus_access;

end neorv32_cfs_rtl;
