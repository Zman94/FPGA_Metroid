	component nios_system is
		port (
			b_emp_export            : out   std_logic;                                        -- export
			bullet1_en_export       : out   std_logic;                                        -- export
			bullet1_x_export        : out   std_logic_vector(9 downto 0);                     -- export
			bullet1_y_export        : out   std_logic_vector(9 downto 0);                     -- export
			bullet2_en_export       : out   std_logic;                                        -- export
			bullet2_x_export        : out   std_logic_vector(9 downto 0);                     -- export
			bullet2_y_export        : out   std_logic_vector(9 downto 0);                     -- export
			bullet3_en_export       : out   std_logic;                                        -- export
			bullet3_x_export        : out   std_logic_vector(9 downto 0);                     -- export
			bullet3_y_export        : out   std_logic_vector(9 downto 0);                     -- export
			clk_clk                 : in    std_logic                     := 'X';             -- clk
			explosion1_en_export    : out   std_logic;                                        -- export
			explosion1_x_export     : out   std_logic_vector(9 downto 0);                     -- export
			explosion1_y_export     : out   std_logic_vector(9 downto 0);                     -- export
			explosion2_en_export    : out   std_logic;                                        -- export
			explosion2_x_export     : out   std_logic_vector(9 downto 0);                     -- export
			explosion2_y_export     : out   std_logic_vector(9 downto 0);                     -- export
			explosion3_en_export    : out   std_logic;                                        -- export
			explosion3_x_export     : out   std_logic_vector(9 downto 0);                     -- export
			explosion3_y_export     : out   std_logic_vector(9 downto 0);                     -- export
			health_export           : out   std_logic_vector(1 downto 0);                     -- export
			key_export              : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			keycode_export          : out   std_logic_vector(15 downto 0);                    -- export
			kraid_as_dir_export     : out   std_logic;                                        -- export
			kraid_dir_export        : out   std_logic;                                        -- export
			kraid_g_en_export       : out   std_logic;                                        -- export
			kraid_n_en_export       : out   std_logic;                                        -- export
			kraid_r_en_export       : out   std_logic;                                        -- export
			kraid_shoot_en_export   : out   std_logic;                                        -- export
			kraid_spike_x_export    : out   std_logic_vector(9 downto 0);                     -- export
			kraid_spike_y_export    : out   std_logic_vector(9 downto 0);                     -- export
			kraid_throw_en_export   : out   std_logic;                                        -- export
			kraid_throw_x_export    : out   std_logic_vector(9 downto 0);                     -- export
			kraid_throw_y_export    : out   std_logic_vector(9 downto 0);                     -- export
			kraid_x_export          : out   std_logic_vector(9 downto 0);                     -- export
			kraid_y_export          : out   std_logic_vector(9 downto 0);                     -- export
			loss_en_export          : out   std_logic;                                        -- export
			monster1_en_export      : out   std_logic;                                        -- export
			monster1_x_export       : out   std_logic_vector(9 downto 0);                     -- export
			monster1_y_export       : out   std_logic_vector(9 downto 0);                     -- export
			monster2_en_export      : out   std_logic;                                        -- export
			monster2_x_export       : out   std_logic_vector(9 downto 0);                     -- export
			monster2_y_export       : out   std_logic_vector(9 downto 0);                     -- export
			monster3_dir_export     : out   std_logic;                                        -- export
			monster3_en_export      : out   std_logic;                                        -- export
			monster3_x_export       : out   std_logic_vector(9 downto 0);                     -- export
			monster3_y_export       : out   std_logic_vector(9 downto 0);                     -- export
			otg_hpi_address_export  : out   std_logic_vector(1 downto 0);                     -- export
			otg_hpi_cs_export       : out   std_logic;                                        -- export
			otg_hpi_data_in_port    : in    std_logic_vector(15 downto 0) := (others => 'X'); -- in_port
			otg_hpi_data_out_port   : out   std_logic_vector(15 downto 0);                    -- out_port
			otg_hpi_r_export        : out   std_logic;                                        -- export
			otg_hpi_w_export        : out   std_logic;                                        -- export
			reset_reset_n           : in    std_logic                     := 'X';             -- reset_n
			samus_dir_export        : out   std_logic;                                        -- export
			samus_en_export         : out   std_logic;                                        -- export
			samus_jump_export       : out   std_logic;                                        -- export
			samus_up_export         : out   std_logic;                                        -- export
			samus_walk_export       : out   std_logic;                                        -- export
			samus_x_export          : out   std_logic_vector(9 downto 0);                     -- export
			samus_y_export          : out   std_logic_vector(9 downto 0);                     -- export
			scene_sel_export        : out   std_logic_vector(2 downto 0);                     -- export
			sdram_clk_clk           : out   std_logic;                                        -- clk
			sdram_wire_addr         : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba           : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n        : out   std_logic;                                        -- cas_n
			sdram_wire_cke          : out   std_logic;                                        -- cke
			sdram_wire_cs_n         : out   std_logic;                                        -- cs_n
			sdram_wire_dq           : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm          : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_wire_ras_n        : out   std_logic;                                        -- ras_n
			sdram_wire_we_n         : out   std_logic;                                        -- we_n
			title_en_export         : out   std_logic;                                        -- export
			win_en_export           : out   std_logic;                                        -- export
			krait_throw_2_en_export : out   std_logic;                                        -- export
			krait_throw_2_x_export  : out   std_logic_vector(9 downto 0);                     -- export
			krait_throw_2_y_export  : out   std_logic_vector(9 downto 0)                      -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			b_emp_export            => CONNECTED_TO_b_emp_export,            --            b_emp.export
			bullet1_en_export       => CONNECTED_TO_bullet1_en_export,       --       bullet1_en.export
			bullet1_x_export        => CONNECTED_TO_bullet1_x_export,        --        bullet1_x.export
			bullet1_y_export        => CONNECTED_TO_bullet1_y_export,        --        bullet1_y.export
			bullet2_en_export       => CONNECTED_TO_bullet2_en_export,       --       bullet2_en.export
			bullet2_x_export        => CONNECTED_TO_bullet2_x_export,        --        bullet2_x.export
			bullet2_y_export        => CONNECTED_TO_bullet2_y_export,        --        bullet2_y.export
			bullet3_en_export       => CONNECTED_TO_bullet3_en_export,       --       bullet3_en.export
			bullet3_x_export        => CONNECTED_TO_bullet3_x_export,        --        bullet3_x.export
			bullet3_y_export        => CONNECTED_TO_bullet3_y_export,        --        bullet3_y.export
			clk_clk                 => CONNECTED_TO_clk_clk,                 --              clk.clk
			explosion1_en_export    => CONNECTED_TO_explosion1_en_export,    --    explosion1_en.export
			explosion1_x_export     => CONNECTED_TO_explosion1_x_export,     --     explosion1_x.export
			explosion1_y_export     => CONNECTED_TO_explosion1_y_export,     --     explosion1_y.export
			explosion2_en_export    => CONNECTED_TO_explosion2_en_export,    --    explosion2_en.export
			explosion2_x_export     => CONNECTED_TO_explosion2_x_export,     --     explosion2_x.export
			explosion2_y_export     => CONNECTED_TO_explosion2_y_export,     --     explosion2_y.export
			explosion3_en_export    => CONNECTED_TO_explosion3_en_export,    --    explosion3_en.export
			explosion3_x_export     => CONNECTED_TO_explosion3_x_export,     --     explosion3_x.export
			explosion3_y_export     => CONNECTED_TO_explosion3_y_export,     --     explosion3_y.export
			health_export           => CONNECTED_TO_health_export,           --           health.export
			key_export              => CONNECTED_TO_key_export,              --              key.export
			keycode_export          => CONNECTED_TO_keycode_export,          --          keycode.export
			kraid_as_dir_export     => CONNECTED_TO_kraid_as_dir_export,     --     kraid_as_dir.export
			kraid_dir_export        => CONNECTED_TO_kraid_dir_export,        --        kraid_dir.export
			kraid_g_en_export       => CONNECTED_TO_kraid_g_en_export,       --       kraid_g_en.export
			kraid_n_en_export       => CONNECTED_TO_kraid_n_en_export,       --       kraid_n_en.export
			kraid_r_en_export       => CONNECTED_TO_kraid_r_en_export,       --       kraid_r_en.export
			kraid_shoot_en_export   => CONNECTED_TO_kraid_shoot_en_export,   --   kraid_shoot_en.export
			kraid_spike_x_export    => CONNECTED_TO_kraid_spike_x_export,    --    kraid_spike_x.export
			kraid_spike_y_export    => CONNECTED_TO_kraid_spike_y_export,    --    kraid_spike_y.export
			kraid_throw_en_export   => CONNECTED_TO_kraid_throw_en_export,   --   kraid_throw_en.export
			kraid_throw_x_export    => CONNECTED_TO_kraid_throw_x_export,    --    kraid_throw_x.export
			kraid_throw_y_export    => CONNECTED_TO_kraid_throw_y_export,    --    kraid_throw_y.export
			kraid_x_export          => CONNECTED_TO_kraid_x_export,          --          kraid_x.export
			kraid_y_export          => CONNECTED_TO_kraid_y_export,          --          kraid_y.export
			loss_en_export          => CONNECTED_TO_loss_en_export,          --          loss_en.export
			monster1_en_export      => CONNECTED_TO_monster1_en_export,      --      monster1_en.export
			monster1_x_export       => CONNECTED_TO_monster1_x_export,       --       monster1_x.export
			monster1_y_export       => CONNECTED_TO_monster1_y_export,       --       monster1_y.export
			monster2_en_export      => CONNECTED_TO_monster2_en_export,      --      monster2_en.export
			monster2_x_export       => CONNECTED_TO_monster2_x_export,       --       monster2_x.export
			monster2_y_export       => CONNECTED_TO_monster2_y_export,       --       monster2_y.export
			monster3_dir_export     => CONNECTED_TO_monster3_dir_export,     --     monster3_dir.export
			monster3_en_export      => CONNECTED_TO_monster3_en_export,      --      monster3_en.export
			monster3_x_export       => CONNECTED_TO_monster3_x_export,       --       monster3_x.export
			monster3_y_export       => CONNECTED_TO_monster3_y_export,       --       monster3_y.export
			otg_hpi_address_export  => CONNECTED_TO_otg_hpi_address_export,  --  otg_hpi_address.export
			otg_hpi_cs_export       => CONNECTED_TO_otg_hpi_cs_export,       --       otg_hpi_cs.export
			otg_hpi_data_in_port    => CONNECTED_TO_otg_hpi_data_in_port,    --     otg_hpi_data.in_port
			otg_hpi_data_out_port   => CONNECTED_TO_otg_hpi_data_out_port,   --                 .out_port
			otg_hpi_r_export        => CONNECTED_TO_otg_hpi_r_export,        --        otg_hpi_r.export
			otg_hpi_w_export        => CONNECTED_TO_otg_hpi_w_export,        --        otg_hpi_w.export
			reset_reset_n           => CONNECTED_TO_reset_reset_n,           --            reset.reset_n
			samus_dir_export        => CONNECTED_TO_samus_dir_export,        --        samus_dir.export
			samus_en_export         => CONNECTED_TO_samus_en_export,         --         samus_en.export
			samus_jump_export       => CONNECTED_TO_samus_jump_export,       --       samus_jump.export
			samus_up_export         => CONNECTED_TO_samus_up_export,         --         samus_up.export
			samus_walk_export       => CONNECTED_TO_samus_walk_export,       --       samus_walk.export
			samus_x_export          => CONNECTED_TO_samus_x_export,          --          samus_x.export
			samus_y_export          => CONNECTED_TO_samus_y_export,          --          samus_y.export
			scene_sel_export        => CONNECTED_TO_scene_sel_export,        --        scene_sel.export
			sdram_clk_clk           => CONNECTED_TO_sdram_clk_clk,           --        sdram_clk.clk
			sdram_wire_addr         => CONNECTED_TO_sdram_wire_addr,         --       sdram_wire.addr
			sdram_wire_ba           => CONNECTED_TO_sdram_wire_ba,           --                 .ba
			sdram_wire_cas_n        => CONNECTED_TO_sdram_wire_cas_n,        --                 .cas_n
			sdram_wire_cke          => CONNECTED_TO_sdram_wire_cke,          --                 .cke
			sdram_wire_cs_n         => CONNECTED_TO_sdram_wire_cs_n,         --                 .cs_n
			sdram_wire_dq           => CONNECTED_TO_sdram_wire_dq,           --                 .dq
			sdram_wire_dqm          => CONNECTED_TO_sdram_wire_dqm,          --                 .dqm
			sdram_wire_ras_n        => CONNECTED_TO_sdram_wire_ras_n,        --                 .ras_n
			sdram_wire_we_n         => CONNECTED_TO_sdram_wire_we_n,         --                 .we_n
			title_en_export         => CONNECTED_TO_title_en_export,         --         title_en.export
			win_en_export           => CONNECTED_TO_win_en_export,           --           win_en.export
			krait_throw_2_en_export => CONNECTED_TO_krait_throw_2_en_export, -- krait_throw_2_en.export
			krait_throw_2_x_export  => CONNECTED_TO_krait_throw_2_x_export,  --  krait_throw_2_x.export
			krait_throw_2_y_export  => CONNECTED_TO_krait_throw_2_y_export   --  krait_throw_2_y.export
		);

