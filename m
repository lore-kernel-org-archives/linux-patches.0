Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83053FFAB7;
	Mon,  2 Mar 2026 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467761; cv=none; b=qBac2GSNu7U3MQNyJW2S7yNLqfIV9nprbNYUoJv3U8LL8zsFzL4q5EmBcLUn6tXfdpEUW1uQpQnGvu20Jsn3ie4l+H9XbgiR18RxjpAQ6pgUCYpuJ0WfUz5imy8lcKJKhcdYsHsEeOmunU5Pt3o47pDZOtdh4aNkemKMlb7rF5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467761; c=relaxed/simple;
	bh=pnQzmqPGG6fLM/M4hF65fwW7SWWTt2KualKOKiRCLtM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qRIp3XGfkKWJ5HoTerqIFrGgg73vTZ2hzUiXoQoUvPbao5kQDOqRPdCNNcrcKHcWis26cSTAKSuZo+rK5DzKoKpcxCgaihpwePqDWHlhYvb6R062BuFo//chVBmHp7nKH0Z1Pi07XdBOR5wH03qJ8domOvd2G07i2f4eE8cPGTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=asshe1kX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="asshe1kX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1DCC19423;
	Mon,  2 Mar 2026 16:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772467761;
	bh=pnQzmqPGG6fLM/M4hF65fwW7SWWTt2KualKOKiRCLtM=;
	h=From:To:Cc:Subject:Date:From;
	b=asshe1kXBFxi0XyoCM0R3cfs2jUR45BOmEGUb6gf3epXinxPpezgD3z/bi4KtwTbw
	 iSABB8ew9KulhKmLekZH+jE98zYqUNr/171hnIeRY3ta3+G2KYNj1tyKcj1l8wl3Ig
	 4H0V0OMu1w4M+Gy2aMgGQUAvDEDSqzw1KM5wdN6TuiYv1zwPkQbvbniLU5sjHCOoA9
	 PFCRxDJ5nlAi8qgII5GmVmDoKLfRvoKJ7p3STR+q5htOPvGoJXtNbP8/X2xKIYX0Qi
	 de8w61UltETNBe7d0Jo+xGjSRqj0PPabkXSBcWO489W5ZYfxVrbViA8i6jftfLw6Qc
	 Sw45Z/4MzfDrw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.12 000/956] 6.12.75-rc2 review
Date: Mon,  2 Mar 2026 11:09:18 -0500
Message-ID: <20260302160918.2520730-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.75-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.75-rc2
X-KernelTest-Deadline: 2026-03-04T16:09+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit


This is the start of the stable review cycle for the 6.12.75 release.
There are 956 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Mar  4 04:09:04 PM UTC 2026.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Abdun Nihaal (2):
  media: i2c/tw9903: Fix potential memory leak in tw9903_probe()
  media: i2c/tw9906: Fix potential memory leak in tw9906_probe()

Abel Vesa (4):
  arm64: dts: qcom: x1e80100: Fix USB combo PHYs SS1 and SS2 ref clocks
  dt-bindings: phy: qcom-edp: Add missing clock for X Elite
  phy: qcom: edp: Make the number of clocks flexible
  arm64: dts: qcom: x1e80100: Add missing TCSR ref clock to the DP PHYs

Abhash Kumar Jha (2):
  arm64: dts: ti: k3-j784s4-main.dtsi: Move c71_3 node to appropriate
    order
  arm64: dts: ti: k3-j784s4-j742s2-main-common.dtsi: Refactor watchdog
    instances for j784s4

Abhishek Bapat (1):
  quota: fix livelock between quotactl and freeze_super

Aboorva Devarajan (1):
  cpuidle: Skip governor when only one idle state is available

Adarsh Das (1):
  btrfs: replace BUG() with error handling in __btrfs_balance()

Adrian Hunter (2):
  i3c: master: Update hot-join flag only on success
  i3c: mipi-i3c-hci: Reset RING_OPERATION1 fields during init

Ai Chao (1):
  ACPI: resource: Add JWIPC JVC9100 to irq1_level_low_skip_override[]

Alain Volmat (1):
  media: stm32: dcmipp: bytecap: clear all interrupts upon stream stop

Alan Maguire (1):
  kcsan, compiler_types: avoid duplicate type issues in BPF Type Format

Aleks Todorov (1):
  OPP: Return correct value in dev_pm_opp_get_level

Aleksandar Gerasimovski (1):
  phy: mvebu-cp110-utmi: fix dr_mode property read from dts

Aleksei Oladko (2):
  selftests: forwarding: vxlan_bridge_1d: fix test failure with
    br_netfilter enabled
  selftests: forwarding: vxlan_bridge_1d_ipv6: fix test failure with
    br_netfilter enabled

Alex Deucher (2):
  drm/amdgpu: avoid a warning in timedout job handler
  drm/amdgpu: keep vga memory on MacBooks with switchable graphics

Alex Elder (1):
  mfd: simple-mfd-i2c: Add SpacemiT P1 support

Alex Hung (2):
  drm/amd/display: Fix writeback on DCN 3.2+
  drm/amd/display: Remove conditional for shaper 3DLUT power-on

Alex Williamson (1):
  PCI: Mark ASM1164 SATA controller to avoid bus reset

Alexander Egorenkov (1):
  s390/kexec: Make KEXEC_SIG available when CONFIG_MODULES=n

Alexander Grest (1):
  iommu/arm-smmu-v3: Improve CMDQ lock fairness and efficiency

Alexander Koskovich (1):
  power: reset: nvmem-reboot-mode: respect cell size for
    nvmem_cell_write

Alexander Stein (2):
  arm64: dts: tqma8mpql-mba8mpxl: Fix HDMI CEC pad control settings
  arm64: dts: tqma8mpql-mba8mp-ras314: Fix HDMI CEC pad control settings

Alexandre Cassen (1):
  net/mlx5e: Support routed networks during IPsec MACs initialization

Alexandre Ferrieux (1):
  ASoC: codecs: aw88261: Fix erroneous bitmask logic in Awinic init

Alexei Starovoitov (1):
  bpf: Recognize special arithmetic shift in the verifier

Alexey Klimov (1):
  gpu/panel-edp: add AUO panel entry for B140HAN06.4

Alexey Simakov (1):
  ACPICA: Fix NULL pointer dereference in
    acpi_ev_address_space_dispatch()

Allison Henderson (1):
  net/rds: rds_sendmsg should not discard payload_len

Alok Tiwari (1):
  mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper

Alper Ak (4):
  tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
  tpm: st33zp24: Fix missing cleanup on get_burstcount() error
  media: rockchip: rga: Fix possible ERR_PTR dereference in
    rga_buf_init()
  media: qcom: camss: vfe: Fix out-of-bounds access in
    vfe_isr_reg_update()

Amelie Delaunay (1):
  dmaengine: stm32-dma3: use module_platform_driver

Anders Grahn (1):
  netfilter: nft_counter: fix reset of counters on 32bit archs

Andrea Scian (1):
  mtd: rawnand: pl353: Fix software ECC support

Andreas Gruenbacher (3):
  gfs2: Retries missing in gfs2_{rename,exchange}
  gfs2: Fix slab-use-after-free in qd_put
  gfs2: fiemap page fault fix

Andreas Larsson (1):
  sparc: Synchronize user stack on fork and clone

Andrey Vatoropin (1):
  fbcon: check return value of con2fb_acquire_newinfo()

Andrii Nakryiko (1):
  procfs: fix possible double mmput() in do_procmap_query()

André Draszik (1):
  regulator: core: move supply check earlier in
    set_machine_constraints()

Andy Shevchenko (1):
  platform/chrome: cros_typec_switch: Don't touch struct
    fwnode_handle::dev

AngeloGioacchino Del Regno (2):
  arm64: dts: mediatek: mt8183-jacuzzi-pico6: Fix typo in pinmux node
  dmaengine: mediatek: uart-apdma: Fix above 4G addressing TX/RX

Ankit Soni (1):
  iommu/amd: move wait_on_sem() out of spinlock

Anshumali Gaur (1):
  octeontx2-af: Fix PF driver crash with kexec kernel booting

Anthony Iliopoulos (2):
  nfsd: never defer requests during idmap lookup
  nfsd: fix return error code for nfsd_map_name_to_[ug]id

Anthony Pighin (Nokia) (2):
  vfio/pci: Lock upstream bridge for vfio_pci_core_disable()
  rtc: interface: Alarm race handling should not discard preceding error

Antonio Borneo (1):
  coresight: etm3x: Fix cpulocked warning on cpuhp

Antoniu Miclaus (1):
  iio: gyro: itg3200: Fix unchecked return value in read_raw

Ard Biesheuvel (1):
  x86/kexec: Copy ACPI root pointer address from config table

Aristeu Rozanski (1):
  selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT

Armin Wolf (2):
  ACPICA: Abort AML bytecode execution when executing AML_FATAL_OP
  hwmon: (dell-smm) Add support for Dell OptiPlex 7080

Arnd Bergmann (6):
  scsi: ufs: host: mediatek: Require CONFIG_PM
  soundwire: intel_ace2x: add SND_HDA_CORE dependency
  vmw_vsock: bypass false-positive Wnonnull warning with gcc-16
  myri10ge: avoid uninitialized variable use
  scsi: buslogic: Reduce stack usage
  arm64: hugetlbpage: avoid unused-but-set-parameter warning (gcc-16)

Artem Shimko (1):
  serial: 8250_dw: handle clock enable errors in runtime_resume

Ashish Kalra (1):
  crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls

Ata İlhan Köktürk (1):
  ACPI: battery: fix incorrect charging status when current is zero

Baochen Qiang (1):
  wifi: ath12k: fix preferred hardware mode calculation

Baokun Li (1):
  ext4: move ext4_percpu_param_init() before ext4_mb_init()

Bard Liao (1):
  ASoC: soc-acpi-intel-arl-match: change rt722 amp endpoint to
    aggregated

Barnabás Czémán (4):
  clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
  clk: qcom: gcc-msm8917: Remove ALWAYS_ON flag from cpp_gdsc
  backlight: qcom-wled: Support ovp values for PMI8994
  backlight: qcom-wled: Change PM8950 WLED configurations

Bartlomiej Kubik (1):
  fs/ntfs3: Initialize new folios before use

Bartosz Golaszewski (2):
  clocksource/drivers/timer-integrator-ap: Add missing Kconfig
    dependency on OF
  reset: gpio: suppress bind attributes in sysfs

Baruch Siach (1):
  Documentation: PCI: endpoint: Fix ntb/vntb copy & paste errors

Bastien Nocera (1):
  HID: logitech-hidpp: Add support for Logitech K980

Ben Dooks (2):
  audit: move the compat_xxx_class[] extern declarations to audit_arch.h
  fs: add <linux/init_task.h> for 'init_fs'

Benjamin Gaignard (4):
  media: verisilicon: AV1: Fix enable cdef computation
  media: verisilicon: AV1: Fix tx mode bit setting
  media: verisilicon: AV1: Set IDR flag for intra_only frame type
  media: verisilicon: AV1: Fix tile info buffer size

Benjamin Marzinski (1):
  dm mpath: make pg_init_delay_msecs settable

Benson Leung (1):
  usb: typec: ucsi: psy: Fix voltage and current max for non-Fixed PDOs

Bharat Dev Burman (1):
  ALSA: hda/realtek: add HP Victus 16-e0xxx mute LED quirk

Bhavik Sachdev (1):
  statmount: permission check should return EPERM

Billy Tsai (2):
  i3c: Move device name assignment after i3c_bus_init
  gpio: aspeed-sgpio: Change the macro to support deferred probe

Bingbu Cao (2):
  media: ipu6: Fix typo and wrong constant in ipu6-mmu.c
  media: ipu6: Fix RPM reference leak in probe error paths

Bitterblue Smith (3):
  wifi: rtw88: 8822b: Avoid WARNING in rtw8822b_config_trx_mode()
  wifi: rtw88: Use devm_kmemdup() in rtw_set_supported_band()
  wifi: rtw88: Fix inadvertent sharing of struct
    ieee80211_supported_band data

Bluecross (1):
  Bluetooth: btusb: Add support for MediaTek7920 0489:e158

Bo Sun (1):
  octeontx2-af: CGX: fix bitmap leaks

Boris Brezillon (6):
  drm/panthor: Recover from panthor_gpu_flush_caches() failures
  drm/panthor: Fix the full_tick check
  drm/panthor: Fix the group priority rotation logic
  drm/panthor: Fix immediate ticking on a disabled tick
  drm/panthor: Fix the logic that decides when to stop ticking
  drm/panthor: Make sure we resume the tick when new jobs are submitted

Boris Burkov (1):
  btrfs: fix block_group_tree dirty_list corruption

Brandon Brnich (2):
  media: chips-media: wave5: Fix conditional in start_streaming
  media: chips-media: wave5: Process ready frames when CMD_STOP sent to
    Encoder

Breno Leitao (1):
  arm64: Disable branch profiling for all arm64 code

Brian Foster (1):
  ext4: fix dirtyclusters double decrement on fs shutdown

Brian Masney (2):
  openrisc: define arch-specific version of nop()
  clk: microchip: core: correct return value on *_get_parent()

Brian Norris (1):
  PCI/PM: Avoid redundant delays on D3hot->D3cold

Caleb Sander Mateos (1):
  io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED

Carl Lee (2):
  hwmon: (pmbus/mpq8785) fix VOUT_MODE mismatch during identification
  nfc: nxp-nci: remove interrupt trigger type

Casey Connolly (2):
  arm64: dts: qcom: sdm845-oneplus: Don't mark ts supply boot-on
  arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on

Ce Sun (1):
  drm/amdgpu: Adjust usleep_range in fence wait

Chaitanya Mishra (1):
  staging: greybus: lights: avoid NULL deref

Charlene Liu (1):
  drm/amd/display: Fix dsc eDP issue

Chen Jinghuang (1):
  sched/rt: Skip currently executing CPU in rto_next_cpu()

Chen Ni (2):
  ASoC: sunxi: sun50i-dmic: Add missing check for devm_regmap_init_mmio
  ASoC: codecs: max98390: Check return value of
    devm_gpiod_get_optional() in max98390_i2c_probe()

Chen-Yu Tsai (2):
  ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property
  dmaengine: sun6i: Choose appropriate burst length under maxburst

Chengchang Tang (2):
  RDMA/hns: Fix WQ_MEM_RECLAIM warning
  RDMA/hns: Notify ULP of remaining soft-WCs during reset

Chenghai Huang (2):
  crypto: hisilicon/zip - adjust the way to obtain the req in the
    callback function
  crypto: hisilicon/qm - move the barrier before writing to the mailbox
    register

Chenyuan Yang (1):
  ALSA: pcm: use new array-copying-wrapper

Chiara Meiohas (1):
  RDMA/mlx5: Fix UMR hang in LAG error state unload

Chin-Ting Kuo (1):
  spi: spi-mem: Protect dirmap_create() with spi_mem_access_start/end

Chin-Yen Lee (1):
  wifi: rtw89: wow: add reason codes for disassociation in WoWLAN mode

Chris Brandt (2):
  clk: renesas: rzg2l: Fix intin variable size
  clk: renesas: rzg2l: Select correct div round macro

Christoph Böhmwalder (1):
  drbd: always set BLK_FEAT_STABLE_WRITES

Christoph Hellwig (4):
  block: add a bio_add_virt_nofail helper
  rnbd-srv: use bio_add_virt_nofail
  iomap: fix submission side handling of completion side errors
  xfs: remove xfs_attr_leaf_hasname

Christophe Leroy (1):
  powerpc/uaccess: Move barrier_nospec() out of
    allow_read_{from/write}_user()

Chuck Lever (5):
  xdrgen: Fix struct prefix for typedef types in program wrappers
  NFS: NFSERR_INVAL is not defined by NFSv2
  xdrgen: Initialize data pointer for zero-length items
  RDMA/core: add rdma_rw_max_sge() helper for SQ sizing
  SUNRPC: auth_gss: fix memory leaks in XDR decoding error paths

Clay King (1):
  drm/amd/display: bypass post csc for additional color spaces in dal

Clément Le Goffic (1):
  dmaengine: stm32-mdma: initialize m2m_hw_period and ccr to fix
    warnings

Colin Ian King (1):
  scsi: csiostor: Fix dereference of null pointer rn

Colin Lord (1):
  tracing: Fix false sharing in hwlat get_sample()

Cosmin Ratiu (1):
  net/mlx5e: Use unsigned for mlx5e_get_max_num_channels

Cristian Ciocaltea (3):
  ASoC: nau8821: Consistently clear interrupts before unmasking
  ASoC: nau8821: Avoid unnecessary blocking in IRQ handler
  ASoC: nau8821: Fixup nau8821_enable_jack_detect()

Cui Chao (1):
  mm: numa_memblks: Identify the accurate NUMA ID of CFMW

Cupertino Miranda (1):
  bpf: verifier improvement in 32bit shift sign extension pattern

Damien Dagorn (1):
  ALSA: hda/realtek: fix LG Gram Style 14 speakers

Damien Le Moal (1):
  ata: libata-scsi: refactor ata_scsi_translate()

Dan Carpenter (2):
  EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
  EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()

Daniel Gomez (1):
  dm: replace -EEXIST with -EBUSY

Daniel Hodges (2):
  SUNRPC: fix gss_auth kref leak in gss_alloc_msg error path
  tipc: fix RCU dereference race in tipc_aead_users_dec()

Daniel Machon (2):
  net: sparx5/lan969x: fix DWRR cost max to match hardware register
    width
  net: sparx5/lan969x: fix PTP clock max_adj value

Daniel Palmer (1):
  m68k: nommu: fix memmove() with differently aligned src and dest for
    68000

Daniel Peng (1):
  HID: i2c-hid: Add FocalTech FT8112

Daniel Tang (1):
  powercap: intel_rapl: Add PL4 support for Ice Lake

Darrick J. Wong (9):
  xfs: mark data structures corrupt on EIO and ENODATA
  xfs: delete attr leaf freemap entries when empty
  xfs: fix freemap adjustments when adding xattrs to leaf blocks
  xfs: fix the xattr scrub to detect freemap/entries array collisions
  xfs: fix remote xattr valuelblk check
  xfs: only call xf{array,blob}_destroy if we have a valid pointer
  xfs: check return value of xchk_scrub_create_subord
  xfs: check for deleted cursors when revalidating two btrees
  xfs: fix copy-paste error in previous fix

David Heidelberg (3):
  drm/panel: sw43408: Remove manual invocation of unprepare at remove
  media: ccs: Accommodate C-PHY into the calculation
  clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk1_clk_src

David LaPorte (1):
  mtd: spinand: Disable continuous read during probe

David Phillips (1):
  HID: elecom: Add support for ELECOM HUGE Plus M-HT1MRBK

David Plowman (3):
  media: i2c: ov5647: Correct pixel array offset
  media: i2c: ov5647: Correct minimum VBLANK value
  media: i2c: ov5647: Sensor should report RAW color space

Deepak Kumar (1):
  spi: stm32: fix Overrun issue at < 8bpw

Deepakkumar Karn (1):
  fs/buffer: add alert in try_to_free_buffers() for folios without
    buffers

Deepanshu Kartikey (2):
  gfs2: Fix use-after-free in iomap inline data write path
  mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node

Denis Pauk (1):
  hwmon: (nct6775) Add ASUS Pro WS WRX90E-SAGE SE

Detlev Casanova (1):
  ASoC: rockchip: i2s-tdm: Use param rate if not provided by set_sysclk

Dian-Syuan Yang (1):
  wifi: rtw89: pci: restore LDO setting after device resume

Diksha Kumari (1):
  staging: rtl8723bs: fix memory leak on failure path

Dikshita Agarwal (1):
  media: venus: vdec: restrict EOS addr quirk to IRIS2 only

Ding Hui (1):
  dm: remove fake timeout to avoid leak request

Diogo Ivo (1):
  arm64: tegra: smaug: Add usb-role-switch support

Dmitry Baryshkov (9):
  arm64: dts: qcom: sdm630: fix gpu_speed_bin size
  arm64: dts: qcom: qrb4210-rb2: Fix UART3 wakeup IRQ storm
  arm64: dts: qcom: sdm845-db845c: drop CS from SPIO0
  arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
  drm/msm/dpu: fix WD timer handling on DPU 8.x
  drm/msm/disp: set num_planes to 1 for interleaved YUV formats
  drm/msm/dpu: fix CMD panels on DPU 1.x - 3.x
  drm/msm/a2xx: fix pixel shader start on A225
  clk: qcom: gfx3d: add parent to parent request map

Dmytro Laktyushkin (2):
  drm/amd/display: Add signal type check for dcn401 get_phyd32clk_src
  drm/amd/display: only power down dig on phy endpoints

Dmytro Maluka (1):
  iommu/vt-d: Flush cache for PASID table before using it

Donet Tom (2):
  drm/amdkfd: Relax size checking during queue buffer get
  drm/amdkfd: Fix GART PTE for non-4K pagesize in svm_migrate_gart_map()

Douglas Anderson (1):
  mfd: core: Add locking around 'mfd_of_node_list'

Duoming Zhou (2):
  net: wan: farsync: Fix use-after-free bugs caused by unfinished
    tasklets
  atm: fore200e: fix use-after-free in tasklets during device removal

Dzmitry Sankouski (1):
  mfd: simple-mfd-i2c: Add MAX77705 support

Edward Adam Davis (1):
  fs/ntfs3: prevent infinite loops caused by the next valid being the
    same

Eric Biggers (1):
  dm-verity: correctly handle dm_bufio_client_create() failure

Eric Dumazet (12):
  tcp: tcp_tx_timestamp() must look at the rtx queue
  inet: RAW sockets using IPPROTO_RAW MUST drop incoming ICMP
  ipv6: fix a race in ip6_sock_set_v6only()
  ping: annotate data-races in ping_lookup()
  macvlan: observe an RCU grace period in macvlan_common_newlink() error
    path
  icmp: prevent possible overflow in icmp_global_allow()
  inet: move icmp_global_{credit,stamp} to a separate cache line
  ipv6: annotate data-races in ip6_multipath_hash_{policy,fields}()
  ipv6: annotate data-races over sysctl.flowlabel_reflect
  ipv6: exthdrs: annotate data-race over multiple sysctl
  gro: change the BUG_ON() in gro_pull_from_frag0()
  ipv4: igmp: annotate data-races around idev->mr_maxdelay

Eric Joyner (1):
  ionic: Rate limit unknown xcvr type messages

Ethan Nelson-Moore (3):
  net: usb: sr9700: remove code to drive nonexistent multicast filter
  net: ethernet: marvell: skge: remove incorrect conflicting PCI ID
  net: intel: fix PCI device ID conflict between i40e and ipw2200

Ethan Tidmore (2):
  x86/hyperv: Fix error pointer dereference
  staging: rtl8723bs: fix null dereference in find_network

Etienne AUJAMES (1):
  IB/cache: update gid cache on client reregister event

Eugenio Pérez (1):
  vhost: move vdpa group bound check to vhost_vdpa

Ezrak1e (1):
  dlm: validate length in dlm_search_rsb_tree

Fabian Godehardt (1):
  spi: spidev: fix lock inversion between spi_lock and buf_lock

Felix Gu (6):
  cpufreq: scmi: Fix device_node reference leak in scmi_cpu_domain_id()
  thermal/of: Fix reference leak in thermal_of_cm_lookup()
  fbdev: of_display_timing: Fix device node reference leak in
    of_get_display_timings()
  fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
  pinctrl: equilibrium: Fix device node reference leak in pinbank_init()
  spi: wpcm-fiu: Fix potential NULL pointer dereference in
    wpcm_fiu_probe()

Fernando Fernandez Mancera (3):
  netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
  netfilter: nf_conncount: increase the connection clean up limit to 64
  netfilter: nf_conncount: fix tracking of connections from localhost

Filipe Manana (3):
  btrfs: qgroup: return correct error when deleting qgroup relation item
  btrfs: use the correct type to initialize block reserve for delayed
    refs
  btrfs: fix invalid leaf access in btrfs_quota_enable() if ref key not
    found

Florian Westphal (6):
  netfilter: nf_tables: reset table validation state on abort
  netfilter: nft_compat: add more restrictions on netlink attributes
  netfilter: nfnetlink_queue: do shared-unconfirmed check before
    segmentation
  netfilter: nft_set_hash: fix get operation on big endian
  netfilter: nf_conntrack_h323: don't pass uninitialised l3num value
  netfilter: xt_tcpmss: check remaining length before reading optlen

Florian-Ewald Mueller (1):
  rnbd-srv: Fix server side setting of bi_size for special IOs

Francesco Lavra (2):
  spi: tools: Add include folder to .gitignore
  iio: accel: adxl380: Avoid reading more entries than present in FIFO

Frank Li (1):
  i3c: master: svc: Initialize 'dev' to NULL in svc_i3c_master_ibi_isr()

Fredrik Markstrom (1):
  i3c: dw: Initialize spinlock to avoid upsetting lockdep

Gao Xiang (2):
  erofs: get rid of raw bi_end_io() usage
  erofs: handle end of filesystem properly for file-backed mounts

Geert Uytterhoeven (1):
  clk: Move clk_{save,restore}_context() to COMMON_CLK section

Geetha sowjanya (1):
  octeontx2-af: Workaround SQM/PSE stalls by disabling sticky

George Moussalem (1):
  clk: qcom: gcc-ipq5018: flag sleep clock as critical

Georgia Garcia (1):
  apparmor: fix invalid deref of rawdata when export_binary is unset

Gerd Rausch (1):
  net/rds: No shortcut out of RDS_CONN_ERROR

Giovanni Cabiddu (1):
  crypto: qat - fix warning on adf_pfvf_pf_proto.c

Govindarajulu Varadarajan (1):
  ublk: Validate SQE128 flag before accessing the cmd

Greg Kroah-Hartman (1):
  Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"

Guangshuo Li (1):
  powerpc/smp: Add check for kcalloc() failure in parse_thread_groups()

Guenter Roeck (1):
  Revert "hwmon: (ibmpex) fix use-after-free in high/low store"

Gui-Dong Han (2):
  PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races
  rpmsg: core: fix race in driver_override_show() and use core helper

Gustavo Salvini (1):
  ASoC: amd: yc: Add DMI quirk for ASUS Vivobook Pro 15X M6501RR

Günther Noack (3):
  HID: magicmouse: Do not crash on missing msc->input
  HID: prodikeys: Check presence of pm->input_ep82
  HID: logitech-hidpp: Check maxfield in hidpp_get_report_length()

Hangbin Liu (1):
  bonding: alb: fix UAF in rlb_arp_recv during bond up/down

Hans Verkuil (4):
  media: dvb-core: dmxdevfilter must always flush bufs
  media: omap3isp: isp_video_mbus_to_pix/pix_to_mbus fixes
  media: omap3isp: isppreview: always clamp in preview_try_format()
  media: omap3isp: set initial format

Hans de Goede (8):
  media: mt9m114: Avoid a reset low spike during probe()
  media: mt9m114: Return -EPROBE_DEFER if no endpoint is found
  media: i2c: ov01a10: Fix the horizontal flip control
  media: i2c: ov01a10: Fix reported pixel-rate value
  media: i2c: ov01a10: Fix analogue gain range
  media: i2c: ov01a10: Add missing v4l2_subdev_cleanup() calls
  media: i2c: ov01a10: Fix passing stream instead of pad to
    v4l2_subdev_state_get_format()
  media: i2c: ov01a10: Fix test-pattern disabling

Haotian Zhang (10):
  clk: qcom: Return correct error code in qcom_cc_probe_by_index()
  soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in
    cmd_db_dev_probe
  hwspinlock: omap: Handle devm_pm_runtime_enable() errors
  HID: playstation: Add missing check for input_ff_create_memless
  PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
  power: supply: bq27xxx: fix wrong errno when bus ops are unsupported
  clk: mediatek: Fix error handling in runtime PM setup
  mfd: arizona: Fix regulator resource leak on
    wm5102_clear_write_sequencer() failure
  leds: qcom-lpg: Check the return value of regmap_bulk_write()
  jfs: Add missing set_freezable() for freezable kthread

Haotien Hsu (1):
  usb: gadget: tegra-xudc: Add handling for BLCG_COREPLL_PWRDN

Haoxiang Li (12):
  PCI/MSI: Unmap MSI-X region on error
  firmware: arm_ffa: Unmap Rx/Tx buffers on init failure
  media: cx25821: Fix a resource leak in cx25821_dev_setup()
  media: mtk-mdp: Fix error handling in probe function
  media: mtk-mdp: Fix a reference leak bug in mtk_mdp_remove()
  media: cx88: Add missing unmap in snd_cx88_hw_params()
  media: cx23885: Add missing unmap in snd_cx23885_hw_params()
  media: cx25821: Add missing unmap in snd_cx25821_hw_params()
  clk: tegra: tegra124-emc: Fix potential memory leak in
    tegra124_clk_register_emc()
  bus: fsl-mc: fix an error handling in fsl_mc_device_add()
  rapidio: replace rio_free_net() with kfree() in rio_scan_alloc_net()
  parisc: kernel: replace kfree() with put_device() in
    create_tree_node()

Hariprasad Kelam (2):
  octeontx2-pf: Unregister devlink on probe failure
  octeontx2-af: Fix default entries mcam entry action

Harry Yoo (1):
  mm/slab: use unsigned long for orig_size to ensure proper metadata
    align

Harshit Mogalapalli (2):
  iio: sca3000: Fix a resource leak in sca3000_probe()
  x86/kexec: add a sanity check on previous kernel's ima kexec buffer

Heiko Carstens (1):
  s390/purgatory: Add -Wno-default-const-init-unsafe to KBUILD_CFLAGS

Helge Deller (3):
  AppArmor: Allow apparmor to handle unaligned dfa tables
  apparmor: Fix & Optimize table creation from possibly unaligned memory
  parisc: Prevent interrupts during reboot

Heming Zhao (1):
  ocfs2: fix reflink preserve cleanup issue

Henrique Carvalho (2):
  smb: client: add proper locking around ses->iface_last_update
  smb: client: prevent races in ->query_interfaces()

Henry Tseng (1):
  ata: libata: avoid long timeouts on hot-unplugged SATA DAS

Honggang LI (1):
  RDMA/rtrs: server: remove dead code

Hou Tao (1):
  PCI/P2PDMA: Release per-CPU pgmap ref when vm_insert_page() fails

Hou Wenlong (1):
  x86/xen/pvh: Enable PAE mode for 32-bit guest only when CONFIG_X86_PAE
    is set

Hsieh Hung-En (1):
  ASoC: es8328: Add error unwind in resume

Hsiu-Ming Chang (1):
  wifi: rtw88: rtw8821cu: Add ID for Mercusys MU6H

Huacai Chen (1):
  LoongArch: Prefer top-down allocation after arch_mem_init()

Huang Chenming (1):
  wifi: cfg80211: Fix use_for flag update on BSS refresh

Hyunwoo Kim (2):
  espintcp: Fix race condition in espintcp_close()
  tls: Fix race condition in tls_sw_cancel_work_tx()

Håkon Bugge (4):
  PCI: Do not attempt to set ExtTag for VFs
  PCI: Initialize RCB from pci_configure_device()
  PCI/ACPI: Restrict program_hpx_type2() to AER bits
  net/rds: Clear reconnect pending bit

Ian Rogers (5):
  perf test stat: Update test expectations and events
  perf unwind-libdw: Fix invalid reference counts
  perf callchain: Fix srcline printing with inlines
  perf maps: Fix reference count leak in maps__find_ams()
  libperf build: Always place libperf includes first

Ido Schimmel (1):
  selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2

Illia Barbashyn (1):
  ALSA: hda/realtek - Enable mute LEDs on HP ENVY x360 15-es0xxx

Ilpo Järvinen (2):
  PCI: Add defines for bridge window indexing
  mfd: intel-lpss: Add Intel Nova Lake-S PCI IDs

Ilya Dryomov (1):
  libceph: define and enforce CEPH_MAX_KEY_LEN

Inseo An (1):
  netfilter: nf_tables: fix use-after-free in nf_tables_addchain()

Ioana Ciornei (2):
  mfd: simple-mfd-i2c: Add compatible strings for Layerscape QIXIS FPGA
  mfd: simple-mfd-i2c: Keep compatible strings in alphabetical order

Irui Wang (1):
  media: mediatek: encoder: Fix uninitialized scalar variable issue

Iuliana Prodan (1):
  remoteproc: imx_dsp_rproc: Skip RP_MBOX_SUSPEND_SYSTEM when mailbox TX
    channel is uninitialized

Jack Wang (1):
  md/bitmap: fix GPF in write_page caused by resize race

Jacky Bai (1):
  mailbox: imx: Skip the suspend flag for i.MX7ULP

Jacob Moroni (2):
  RDMA/iwcm: Fix workqueue list corruption by removing work_list
  RDMA/umem: Fix double dma_buf_unpin in failure path

Jacopo Scannella (1):
  Bluetooth: btusb: Add device ID for Realtek RTL8761BU

Jaehun Gou (3):
  fs: ntfs3: check return value of indx_find to avoid infinite loop
  fs: ntfs3: fix infinite loop in attr_load_runs_range on inconsistent
    metadata
  fs: ntfs3: fix infinite loop triggered by zero-sized ATTR_LIST

Jagadeesh Kona (5):
  clk: qcom: gcc-sm8450: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-sm4450: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-sdx75: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-x1e80100: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-qdu1000: Update the SDCC RCGs to use shared_floor_ops

Jai Luthra (2):
  media: i2c: ov5647: Initialize subdev before controls
  media: i2c: ov5647: Fix PIXEL_RATE value for VGA mode

Jakob Riemenschneider (1):
  ACPI: x86: s2idle: Invoke Microsoft _DSM Function 9 (Turn On Display)

Jakub Kicinski (2):
  bpftool: Fix truncated netlink dumps
  net: consume xmit errors of GSO frames

James Clark (1):
  libperf: Don't remove -g when EXTRA_CFLAGS are used

Jan Kara (1):
  ext4: use optimized mballoc scanning regardless of inode format

Jan Kiszka (1):
  Drivers: hv: vmbus: Use kthread for vmbus interrupts on PREEMPT_RT

Jani Nikula (1):
  drm/i915/wakeref: clean up INTEL_WAKEREF_PUT_* flag macros

Janne Grunau (2):
  arm64: dts: apple: t8112-j473: Keep the HDMI port powered on
  clk: clk-apple-nco: Add "apple,t8103-nco" compatible

Jared Kangas (1):
  dmaengine: fsl-edma: don't explicitly disable clocks in .remove()

Jason Andryuk (1):
  xenbus: Use .freeze/.thaw to handle xenbus devices

Jason Gunthorpe (1):
  RDMA/efa: Fix typo in efa_alloc_mr()

Jeffrey Bencteux (2):
  audit: add fchmodat2() to change attributes class
  audit: add missing syscalls to read class

Jens Axboe (4):
  io_uring/sync: validate passed in offset
  io_uring/cancel: de-unionize file and user_data in struct
    io_cancel_data
  io_uring/net: don't continue send bundle if poll was required for
    retry
  io_uring/filetable: clamp alloc_hint to the configured alloc range

Jerome Brunet (7):
  arm64: dts: amlogic: s4: assign mmc b clock to 24MHz
  arm64: dts: amlogic: s4: fix mmc clock assignment
  arm64: dts: amlogic: c3: assign the MMC signal clocks
  arm64: dts: amlogic: axg: assign the MMC signal clocks
  arm64: dts: amlogic: gx: assign the MMC signal clocks
  arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
  arm64: dts: amlogic: g12: assign the MMC A signal clock

Ji-Ze Hong (Peter Hong) (1):
  hwmon: (f71882fg) Add F81968 support

Jian Shen (1):
  net: hns3: fix double free issue for tx spare buffer

Jian Zhang (1):
  net: mctp-i2c: fix duplicate reception of old data

Jianbo Liu (1):
  net/mlx5e: Fix "scheduling while atomic" in IPsec MAC address query

Jianpeng Chang (1):
  crypto: caam - fix netdev memory leak in dpaa2_caam_probe

Jiasheng Jiang (3):
  RDMA/rxe: Fix double free in rxe_srq_from_init
  fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot
  md-cluster: fix NULL pointer dereference in process_metadata_update

Jiaxun Yang (1):
  MIPS: rb532: Fix MMIO UART resource registration

Jiayuan Chen (7):
  bpf, sockmap: Fix incorrect copied_seq calculation
  bpf, sockmap: Fix FIONREAD for sockmap
  net: atm: fix crash due to unvalidated vcc pointer in sigd_send()
  xfrm: fix ip_rt_bug race in icmp_route_lookup reverse path
  serial: caif: fix use-after-free in caif_serial ldisc_close()
  xfrm6: fix uninitialized saddr in xfrm6_get_saddr()
  kcm: fix zero-frag skb in frag_list on partial sendmsg error

Jijie Shao (1):
  net: hns3: extend HCLGE_FD_AD_QID to 11 bits

Jinhui Guo (2):
  iommu/vt-d: Flush dev-IOTLB only when PCIe device is accessible in
    scalable mode
  PCI: Fix pci_slot_trylock() error handling

Jinliang Zheng (1):
  procfs: fix missing RCU protection when reading real_parent in
    do_task_stat()

Jinqian Yang (1):
  arm64: Add support for TSV110 Spectre-BHB mitigation

Jinwang Li (1):
  Bluetooth: hci_qca: Cleanup on all setup failures

Jiri Olsa (2):
  x86/fgraph,bpf: Fix stack ORC unwind from kprobe_multi return probe
  x86/fgraph,bpf: Switch kprobe_multi program stack unwind to hw_regs
    path

Jiri Pirko (1):
  RDMA/core: Fix stale RoCE GIDs during netdev events at registration

Jisheng Zhang (1):
  usb: dwc2: fix resume failure if dr_mode is host

Joe Damato (1):
  bnxt_en: Allow ntuple filters for drops

Joel Fernandes (3):
  rcu: Refactor expedited handling check in rcu_read_unlock_special()
  sched/deadline: Clear the defer params
  sched/debug: Fix updating of ppos on server write ops

Joel Granados (1):
  iommu/vt-d: Separate page request queue from SVM

Joey Bednar (1):
  HID: apple: Add "SONiX KN85 Keyboard" to the list of non-apple
    keyboards

Joey Gouly (1):
  arm64: poe: fix stale POR_EL0 values for ptrace

Johan Hovold (5):
  soc: ti: k3-socinfo: Fix regmap leak on probe failure
  bus: omap-ocp2scp: fix OF populate on driver rebind
  mfd: qcom-pm8xxx: Fix OF populate on driver rebind
  mfd: omap-usb-host: Fix OF populate on driver rebind
  most: core: fix leak on early registration failure

Johannes Berg (1):
  wifi: cfg80211: wext: fix IGTK key ID off-by-one

John Garry (2):
  MIPS: Loongson: Make cpumask_of_node() robust against NUMA_NO_NODE
  LoongArch: Make cpumask_of_node() robust against NUMA_NO_NODE

John Johansen (5):
  apparmor: fix NULL sock in aa_sock_file_perm
  apparmor: fix rlimit for posix cpu timers
  apparmor: remove apply_modes_to_perms from label_match
  apparmor: make label_match return a consistent value
  apparmor: fix aa_label to return state from compount and component
    match

Johnny-CC Chang (1):
  PCI: Mark Nvidia GB10 to avoid bus reset

Jonathan Marek (3):
  arm64: dts: qcom: x1e: bus is 40-bits (fix 64GB models)
  spi-geni-qcom: initialize mode related registers to 0
  spi-geni-qcom: use xfer->bits_per_word for can_dma()

Jonathan McDowell (1):
  hwrng: core - Allow runtime disabling of the HW RNG

Jorge Ramirez-Ortiz (1):
  soc: qcom: smem: handle ENOMEM error during probe

Jori Koolstra (2):
  minix: Add required sanity checking to minix_check_superblock()
  jfs: nlink overflow in jfs_rename

Jose Ignacio Tornos Martinez (1):
  wifi: rtw89: 8922a: set random mac if efuse contains zeroes

Josh Poimboeuf (1):
  kbuild: Add objtool to top-level clean target

Julian Anastasov (1):
  ipvs: do not keep dest_dst if dev is going down

Jun Yan (1):
  arm64: dts: rockchip: Do not enable hdmi_sound node on Pinebook Pro

Junrui Luo (1):
  dpaa2-switch: validate num_ifs to prevent out-of-bounds write

Junxian Huang (1):
  RDMA/hns: Fix RoCEv1 failure due to DSCP

Justin Chen (1):
  usb: bdc: fix sleep during atomic

Jörg Wedekind (1):
  PCI: Mark 3ware-9650SA Root Port Extended Tags as broken

Kaushlendra Kumar (3):
  drm/i915/acpi: free _DSM package when no connectors
  tools/power cpupower: Reset errno before strtoull()
  thermal: int340x: Fix sysfs group leak on DLVR registration failure

Kees Cook (1):
  media: solo6x10: Check for out of bounds chip_id

Keita Morisaki (1):
  scsi: ufs: mediatek: Fix page faults in ufs_mtk_clk_scale() trace
    event

Keith Busch (1):
  PCI: Fix pci_slot_lock () device locking

Kery Qi (2):
  selftests/bpf: Fix resource leak in serial_test_wq on attach failure
  watchdog: starfive-wdt: Fix PM reference leak in probe error path

Ketil Johnsen (1):
  drm/panthor: Evict groups before VM termination

Kevin Hao (3):
  net: cpsw_new: Fix unnecessary netdev unregistration in cpsw_probe()
    error path
  net: ti: icssg-prueth: Add optional dependency on HSR
  net: macb: Fix tx/rx malfunction after phy link down and up

Kiryl Shutsemau (Meta) (1):
  efi: Fix reservation of unaccepted memory table

Koichiro Den (1):
  NTB: ntb_transport: Fix too small buffer for debugfs_name

Kommula Shiva Shankar (1):
  vhost: fix caching attributes of MMIO regions by setting them
    explicitly

Konrad Dybcio (3):
  arm64: dts: qcom: agatti: Add CX_MEM/DBGC GPU regions
  arm64: dts: qcom: sm6115: Add CX_MEM/DBGC GPU regions
  cpufreq: dt-platdev: Block the driver from probing on more QC
    platforms

Konstantin Andreev (2):
  smack: /smack/doi must be > 0
  smack: /smack/doi: accept previously used values

Konstantin Komarov (2):
  fs/ntfs3: drop preallocated clusters for sparse and compressed files
  fs/ntfs3: avoid calling run_get_entry() when run == NULL in
    ntfs_read_run_nb_ra()

Krishna Chaitanya Chundru (1):
  PCI: Add ACS quirk for Qualcomm Hamoa & Glymur

Krzysztof Kozlowski (1):
  nvmem: Drop OF node reference on nvmem_add_one_cell() failure

Kuniyuki Iwashima (2):
  ipv6: Fix out-of-bound access in fib6_add_rt2node().
  ipv4: fib: Annotate access to struct fib_alias.fa_state.

Kuppuswamy Sathyanarayanan (1):
  powercap: intel_rapl_tpmi: Remove FW_BUG from invalid version check

Lai Jiangshan (3):
  workqueue: Factor out assign_rescuer_work()
  workqueue: Only assign rescuer work when really needed
  workqueue: Process rescuer work items one-by-one using a cursor

Leo Li (1):
  drm/amd/display: Increase DCN35 SR enter/exit latency

Leo Yan (2):
  perf: arm_spe: Properly set hw.state on failures
  tools: Fix bitfield dependency failure

Leon Romanovsky (2):
  xfrm: skip templates check for packet offload tunnel mode
  net/mlx5e: Separate address related variables to be in struct

Li Chen (4):
  nvdimm: virtio_pmem: serialize flush requests
  ext4: mark group add fast-commit ineligible
  ext4: mark group extend fast-commit ineligible
  kexec: derive purgatory entry from symbol

Li Nan (1):
  md/raid10: fix any_working flag handling in raid10_sync_request

Li Wang (1):
  selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs

Li Zhijian (1):
  RDMA/rxe: Fix race condition in QP timer handlers

Liang Jie (1):
  staging: rtl8723bs: fix missing status update on sdio_alloc_irq()
    failure

Lianjie Wang (1):
  hwrng: core - use RCU and work_struct to fix race condition

Lianqin Hu (1):
  ALSA: usb-audio: Add iface reset and delay quirk for AB13X USB Audio

Likun Gao (1):
  drm/amdgpu: fix NULL pointer issue buffer funcs

LinCheng Ku (1):
  drm/amd/display: Add USB-C DP Alt Mode lane limitation in DCN32

Linus Torvalds (1):
  Remove WARN_ALL_UNSEEDED_RANDOM kernel config option

Linus Walleij (2):
  ata: pata_ftide010: Fix some DMA timings
  net: ethernet: xscale: Check for PTP support properly

Loic Poulain (1):
  drm/bridge: anx7625: Fix invalid EDID size

Longfang Liu (1):
  hisi_acc_vfio_pci: update status after RAS error

Lu Baolu (3):
  iommu/vt-d: Drain PRQs when domain removed from RID
  iommu/vt-d: Avoid draining PRQ in sva mm release path
  iommu/vt-d: Clear Present bit before tearing down PASID entry

Luca Ceresoli (1):
  drm: of: drm_of_panel_bridge_remove(): fix device_node leak

Luca Weiss (1):
  pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition

Ludovic Desroches (3):
  drm/atmel-hlcdc: fix memory leak from the atomic_destroy_state
    callback
  drm/atmel-hlcdc: don't reject the commit if the src rect has
    fractional parts
  drm/atmel-hlcdc: fix use-after-free of drm_crtc_commit after release

Luiz Augusto von Dentz (5):
  Bluetooth: L2CAP: Fix invalid response to L2CAP_ECRED_RECONF_REQ
  Bluetooth: L2CAP: Fix result of L2CAP_ECRED_CONN_RSP when MTU is too
    short
  Bluetooth: L2CAP: Fix response to L2CAP_ECRED_CONN_REQ
  Bluetooth: L2CAP: Fix not checking output MTU is acceptable on
    L2CAP_ECRED_CONN_REQ
  Bluetooth: L2CAP: Fix missing key size check for L2CAP_LE_CONN_REQ

Lukas Wunner (1):
  PCI/AER: Clear stale errors on reporting agents upon probe

Luke Wang (1):
  block: decouple secure erase size limit from discard size limit

Maciej Grochowski (2):
  ntb: ntb_hw_switchtec: Fix array-index-out-of-bounds access
  ntb: ntb_hw_switchtec: Fix shift-out-of-bounds for 0 mw lut

Maciej Strozek (1):
  soundwire: intel_auxdevice: add cs42l45 codec to wake_capable_list

Magnus Lindholm (1):
  alpha: fix user-space corruption during memory compaction

Mahadevan P (1):
  drm/msm/disp/dpu: add merge3d support for sc7280

Malaya Kumar Rout (1):
  tools/power/x86/intel-speed-select: Fix file descriptor leak in
    isolate_cpus()

Manikanta Maddireddy (1):
  PCI: endpoint: Fix swapped parameters in
    pci_{primary/secondary}_epc_epf_unlink() functions

Manivannan Sadhasivam (1):
  PCI: Enable ACS after configuring IOMMU for OF platforms

Marc Zyngier (2):
  arm64: Force the use of CNTVCT_EL0 in __delay()
  arm64: Fix sampling the "stable" virtual counter in preemptible
    section

Marco Elver (1):
  arm64: Fix non-atomic __READ_ONCE() with CONFIG_LTO=y

Marcus Folkesson (1):
  Revert "mfd: da9052-spi: Change read-mask to write-mask"

Marek Behún (1):
  net: sfp: add quirk for Lantech 8330-265D

Marek Vasut (1):
  clk: rs9: Reserve 8 struct clk_hw slots for for 9FGV0841

Mario Kleiner (1):
  drm/amd/display: Use same max plane scaling limits for all 64 bpp
    formats

Mario Limonciello (AMD) (5):
  drm/amd: Drop "amdgpu kernel modesetting enabled" message
  crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
  crypto: ccp - Add an S4 restore flow
  crypto: ccp - Factor out ring destroy handling to a helper
  crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
    fails

Mario Peter (1):
  usb: chipidea: udc: fix DMA and SG cleanup in _ep_nuke()

Mark Brown (1):
  mailbox: pcc: Remove spurious IRQF_ONESHOT usage

Markus Perkins (1):
  misc: eeprom: Fix EWEN/EWDS/ERAL commands for 93xx56 and 93xx66

Martin Blumenstingl (1):
  clk: meson: gxbb: Limit the HDMI PLL OD to /4 on GXL/GXM SoCs

Martin Pålsson (1):
  net: usb: lan78xx: scan all MDIO addresses on LAN7801

Martin Schiller (2):
  perf/x86/msr: Add Airmont NP
  perf/x86/cstate: Add Airmont NP

Masami Hiramatsu (Google) (8):
  tracing: Add a comment about ftrace_regs definition
  ftrace: Use arch_ftrace_regs() for ftrace_regs_*() macros
  ftrace: Rename ftrace_regs_return_value to
    ftrace_regs_get_return_value
  fgraph: Replace fgraph_ret_regs with ftrace_regs
  tracing: Add ftrace_partial_regs() for converting ftrace_regs to
    pt_regs
  tracing: Add ftrace_fill_perf_regs() for perf event
  tracing: Fix to set write permission to per-cpu buffer_size_kb
  tracing: ring-buffer: Fix to check event length before using

Matt Johnston (2):
  mctp i2c: initialise event handler read bytes
  ipmi: ipmb: initialise event handler read bytes

Matt Roper (10):
  drm/xe: Move forcewake to 'gt.pm' substructure
  drm/xe: Create dedicated xe_mmio structure
  drm/xe: Clarify size of MMIO region
  drm/xe: Move GSI offset adjustment fields into 'struct xe_mmio'
  drm/xe: Populate GT's mmio iomap from tile during init
  drm/xe: Switch mmio_ext to use 'struct xe_mmio'
  drm/xe: Add xe_tile backpointer to xe_mmio
  drm/xe: Adjust mmio code to pass VF substructure to SRIOV code
  drm/xe: Switch MMIO interface to take xe_mmio instead of xe_gt
  drm/xe/xe2_hpg: Fix handling of Wa_14019988906 & Wa_14019877138

Matt Whitlock (1):
  dm-unstripe: fix mapping bug when there are multiple targets in a
    table

Matthew Brost (1):
  drm/xe: Only toggle scheduling in TDR if GuC is running

Matthew Schwartz (1):
  mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms

Matthew Stewart (1):
  drm/amd/display: Fix GFX12 family constant checks

Mauro Carvalho Chehab (4):
  EFI/CPER: don't dump the entire memory region
  APEI/GHES: ensure that won't go past CPER allocated record
  APEI/GHES: ARM processor Error: don't go past allocated memory
  EFI/CPER: don't go past the ARM processor CPER record buffer

Md Haris Iqbal (2):
  rnbd-srv: Zero the rsp buffer before using it
  RDMA/rtrs-clt: For conn rejection use actual err number

Mehdi Djait (1):
  media: i2c: ov01a10: Fix digital gain range

Miaoqian Lin (1):
  tracing: Properly process error handling in event_hist_trigger_parse()

Michael Liang (1):
  dm: clear cloned request bio pointer when last clone bio completes

Michael Thalmeier (1):
  net: nfc: nci: Fix parameter validation for packet data

Michał Grzelak (1):
  drm/buddy: release free_trees array on buddy mm teardown

Miguel Ojeda (1):
  rust: kbuild: pass `-Zunstable-options` for Rust 1.95.0

Mike Snitzer (2):
  nfs/localio: eliminate unnecessary kref in nfs_local_fsync_ctx
  NFS/localio: use GFP_NOIO and non-memreclaim workqueue in
    nfs_local_commit

Mikulas Patocka (5):
  dm: fix unlocked test for dm_suspended_md
  dm: use READ_ONCE in dm_blk_report_zones
  dm: use bio_clone_blkg_association
  dm-integrity: fix a typo in the code for write/discard race
  dm-integrity: fix recalculation in bitmap mode

Ming Qian (2):
  media: amphion: Clear last_buffer_dequeued flag for DEC_CMD_START
  media: amphion: Drop min_queued_buffers assignment

Mingj Ye (1):
  net: usb: r8152: fix transmit queue timeout

Miquel Raynal (2):
  mtd: spinand: Fix kernel doc
  spi: spi-mem: Limit octal DTR constraints to octal DTR situations

Miri Korenblit (3):
  wifi: cfg80211: stop NAN and P2P in cfg80211_leave
  wifi: cfg80211: allow only one NAN interface, also in multi radio
  wifi: iwlwifi: mvm: check the validity of noa_len

Moteen Shah (2):
  serial: 8250: 8250_omap.c: Add support for handling UART error
    conditions
  serial: 8250: 8250_omap.c: Clear DMA RX running status only after DMA
    termination is done

Muhammad Usama Anjum (1):
  selftests/mm: pagemap_ioctl: Fix types mismatches shown by compiler
    options

Narayana Murty N (1):
  powerpc/eeh: fix recursive pci_lock_rescan_remove locking in EEH event
    handling

Nathan Chancellor (1):
  ALSA: pcm: Revert bufs move in snd_pcm_xfern_frames_ioctl()

Navaneeth K (1):
  most: core: fix resource leak in most_register_interface error paths

Nicholas Kazlauskas (1):
  drm/amd/display: Ensure link output is disabled in backend reset for
    PLL_ON

Nicolas Cavallari (1):
  PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]

Nicolas Dufresne (1):
  media: mediatek: vcodec: Don't try to decode 422/444 VP9

Nicolas Frattaroli (2):
  interconnect: mediatek: Don't hijack parent device
  interconnect: mediatek: Aggregate bandwidth with saturating add

Niklas Cassel (2):
  Revert "PCI: qcom: Enable MSI interrupts together with Link up if
    'Global IRQ' is supported"
  PCI: dwc: Fix msg_atu_index assignment

Niklas Schnelle (3):
  s390/pci: Handle futile config accesses of disabled devices directly
  Revert "PCI/IOV: Add PCI rescan-remove locking when enabling/disabling
    SR-IOV"
  PCI/IOV: Fix race between SR-IOV enable/disable and hotplug

Niklas Söderlund (1):
  clocksource/drivers/sh_tmu: Always leave device running after probe

Nikolay Aleksandrov (1):
  net: bridge: mcast: always update mdb_n_entries for vlan contexts

Nuno Sá (2):
  dma: dma-axi-dmac: fix SW cyclic transfers
  dma: dma-axi-dmac: fix HW scatter-gather not looking at the queue

Ojaswin Mujoo (1):
  ext4: propagate flags to convert_initialized_extent()

Oleksandr Suvorov (1):
  watchdog: imx7ulp_wdt: handle the nowayout option

Olga Kornievskaia (1):
  pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN

Oliver Neukum (1):
  HID: hid-pl: handle probe errors

Ondrej Mosnacek (2):
  ipc: don't audit capability check in ipc_permissions()
  ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()

Or Har-Toov (1):
  IB/mlx5: Fix port speed query for representors

Otto Pflüger (2):
  mailbox: sprd: mask interrupts that are not handled
  mailbox: sprd: clear delivery flag before handling TX done

Ovidiu Bunea (1):
  drm/amd/display: Disable FEC when powering down encoders

Pablo Neira Ayuso (3):
  netfilter: nft_set_rbtree: fix bogus EEXIST with NLM_F_CREATE with
    null interval
  netfilter: nft_set_rbtree: check for partial overlaps in anonymous
    sets
  net: remove WARN_ON_ONCE when accessing forward path array

Paolo Abeni (1):
  mptcp: fix receive space timestamp initialization

Paul Chaignon (1):
  bpf: Fix bpf_xdp_store_bytes proto for read-only arg

Paulo Alcantara (1):
  smb: client: fix potential UAF and double free in smb2_open_file()

Pavan Chebbi (2):
  bnxt_en: Fix RSS context delete logic
  bnxt_en: Fix deleting of Ntuple filters

Pawel Dembicki (3):
  hwmon: pmbus: mpq8785: Prepare driver for multiple device support
  hwmon: pmbus: mpq8785: Implement VOUT feedback resistor divider ratio
    configuration
  hwmon: pmbus: mpq8785: Add support for MPM82504

Peng Fan (1):
  remoteproc: imx_rproc: Fix invalid loaded resource table detection

Peter Ujfalusi (7):
  ASoC: SOF: ipc4: Support for sending payload along with
    LARGE_CONFIG_GET
  PCI: Add Intel Nova Lake audio Device ID
  soundwire: dmi-quirks: add mapping for Avell B.ON (OEM rebranded of
    NUC15)
  ASoC: SOF: ipc4-control: If there is no data do not send bytes update
  ASoC: SOF: ipc4-topology: Correct the allocation size for bytes
    controls
  ASoC: SOF: ipc4-control: Use the correct size for
    scontrol->ipc_control_data
  ASoC: SOF: ipc4-control: Keep the payload size up to date

Petr Hodina (1):
  clk: qcom: dispcc-sdm845: Enable parents for pixel clocks

Petr Mladek (2):
  module: add helper function for reading module_buildid()
  kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()

Petr Pavlu (2):
  tracing: Fix checking of freed trace_event_file for hist files
  tracing: Wake up poll waiters for hist files when removing an event

Petre Rodan (5):
  iio: pressure: mprls0025pa: fix spi_transfer struct initialisation
  iio: pressure: mprls0025pa: fix SPI CS delay violation
  iio: pressure: mprls0025pa: fix interrupt flag
  iio: pressure: mprls0025pa: fix scan_type struct
  iio: pressure: mprls0025pa: fix pressure calculation

Phil Sutter (1):
  include: uapi: netfilter_bridge.h: Cover for musl libc

Philip Yang (1):
  drm/amdkfd: Handle GPU reset and drain retry fault race

Pierre-Eric Pelloux-Prayer (1):
  drm/amdgpu: fix sync handling in amdgpu_dma_buf_move_notify

Ping-Ke Shih (1):
  wifi: rtw89: mac: correct page number for CSI response

Po-Hao Huang (2):
  wifi: rtw89: fix unable to receive probe responses under MLO
    connection
  wifi: rtw89: 8922a: add digital compensation for 2GHz

Prashanth K (1):
  usb: dwc3: gadget: Move vbus draw to workqueue context

Praveen Talari (1):
  spi: geni-qcom: Fix abort sequence execution for serial engine errors

Puranjay Mohan (2):
  selftests/bpf: veristat: fix printing order in output_stats()
  bpf: Preserve id of register in sync_linked_regs()

Purva Yeshi (1):
  Documentation: trace: Refactor toctree

Qanux (1):
  ipv6: ioam: fix heap buffer overflow in __ioam6_fill_trace_data()

Qi Tao (1):
  crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
    queue unavailable

Qian Zhang (1):
  wifi: ath11k: Fix failure to connect to a 6 GHz AP

Qing Wang (1):
  ovl: Fix uninit-value in ovl_fill_real

Qu Wenruo (1):
  btrfs: fallback to buffered IO if the data profile has duplication

Raag Jadav (1):
  pinctrl: intel: Add code name documentation

Rafael J. Wysocki (2):
  cpuidle: governors: menu: Always check timers with tick stopped
  thermal: intel: x86_pkg_temp_thermal: Handle invalid temperature

Randy Dunlap (3):
  iio: test: drop dangling symbol in gain-time-scale helpers
  serial: imx: change SERIAL_IMX_CONSOLE to bool
  serial: SH_SCI: improve "DMA support" prompt

Ranjani Sridharan (1):
  ASoC: SOF: Intel: hda: Fix NULL pointer dereference

Renjiang Han (1):
  media: venus: vdec: fix error state assignment for zero bytesused

René Rebe (4):
  net: sunhme: Fix sbus regression
  modpost: Amend ppc64 save/restfpr symnames for -Os build
  fix it87_wdt early reboot by reporting running timer
  fbdev: ffb: fix corrupted video output on Sun FFB1

Ricardo Ribalda (1):
  media: uvcvideo: Fix allocation for small frame sizes

Robert Marko (1):
  mfd: simple-mfd-i2c: Add Delta TN48M CPLD support

Roberto Sassu (1):
  evm: Use ordered xattrs list to calculate HMAC in evm_init_hmac()

Robin Murphy (2):
  perf/arm-cmn: Support CMN-600AE
  perf/arm-cmn: Reject unsupported hardware configurations

Roger Pau Monne (1):
  Partial revert "x86/xen: fix balloon target initialization for PVH
    dom0"

Romain Gantois (1):
  fpga: of-fpga-region: Fail if any bridge is missing

Roman Penyaev (1):
  RDMA/rtrs-srv: fix SG mapping

Roman Peshkichev (1):
  wifi: rtw88: fix DTIM period handling when conf->dtim_period is zero

Ross Vandegrift (1):
  wifi: ath11k: add pm quirk for Thinkpad Z13/Z16 Gen1

Rui Wang (1):
  media: rkisp1: Fix filter mode register configuration

Ruipeng Qi (1):
  pstore: ram_core: fix incorrect success return when vmap() fails

Ruitong Liu (1):
  net/sched: act_skbedit: fix divide-by-zero in tcf_skbedit_hash()

Ryan Lee (1):
  apparmor: return -ENOMEM in unpack_perms_table upon alloc failure

Ryan Lin (1):
  HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients

Sagi Grimberg (1):
  fs/nfs: Fix readdir slow-start regression

Sai Ritvik Tanksalkar (1):
  pstore/ram: fix buffer overflow in persistent_ram_save_old()

Sakari Ailus (6):
  media: v4l2-async: Fix error handling on steps after finding a match
  media: ipu6: Ensure stream_mutex is acquired when dealing with node
    list
  media: ipu6: Close firmware streams on streaming enable failure
  media: ipu6: Always close firmware stream
  media: ccs: Avoid possible division by zero
  media: ccs: Fix setting initial sub-device state

Salah Triki (1):
  s390/cio: Fix device lifecycle handling in css_alloc_subchannel()

Sam Day (2):
  usb: gadget: f_fs: fix DMA-BUF OUT queues
  usb: gadget: f_fs: Fix ioctl error handling

Sam James (1):
  sparc: don't reference obsolete termio struct for TC* constants

Sami Tolvanen (1):
  bpf: crypto: Use the correct destructor kfunc type

Samuel Wu (1):
  PM: wakeup: Handle empty list in wakeup_sources_walk_start()

Sandipan Das (2):
  perf/x86/core: Do not set bit width for unavailable counters
  perf vendor events amd: Fix Zen 5 MAB allocation events

Sanjay Yadav (1):
  drm/buddy: Prevent BUG_ON by validating rounded allocation

Sasha Levin (1):
  Linux 6.12.75-rc2

Scott Mitchell (1):
  netfilter: nfnetlink_queue: optimize verdict lookup with hash table

Sean Christopherson (2):
  KVM: x86: Return "unsupported" instead of "invalid" on access to
    unsupported PV MSR
  KVM: nSVM: Remove a user-triggerable WARN on nested_svm_load_cr3()
    succeeding

Sean V Kelley (1):
  ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs

Sebastian Andrzej Siewior (12):
  genirq: Set IRQF_COND_ONESHOT in devm_request_irq().
  platform/x86: int0002: Remove IRQF_ONESHOT from request_irq()
  Bluetooth: btintel_pcie: Use IRQF_ONESHOT and default primary handler
  scsi: efct: Use IRQF_ONESHOT and default primary handler
  EDAC/altera: Remove IRQF_ONESHOT
  mfd: wm8350-core: Use IRQF_ONESHOT
  media: pci: mg4b: Use IRQF_NO_THREAD
  perf/cxlpmu: Replace IRQF_ONESHOT with IRQF_NO_THREAD
  mailbox: bcm-ferxrm-mailbox: Use default primary handler
  char: tpm: cr50: Remove IRQF_ONESHOT
  iio: Use IRQF_NO_THREAD
  iio: magnetometer: Remove IRQF_ONESHOT

Sebastian Krzyszkowiak (2):
  ASoC: wm8962: Add WM8962_ADC_MONOMIX to "3D Coefficients" mask
  ASoC: wm8962: Don't report a microphone if it's shorted to ground on
    plug

Sergey Matyukevich (1):
  riscv: vector: init vector context with proper vlenb

Sergey Shtylyov (1):
  PCI: Check parent for NULL in of_pci_bus_release_domain_nr()

Shardul Bankar (1):
  hfsplus: return error when node already exists in hfs_bnode_create

Shaurya Rane (1):
  media: radio-keene: fix memory leak in error path

Shawn Lin (2):
  soc: rockchip: grf: Fix wrong RK3576_IOCGRF_MISC_CON definition
  soc: rockchip: grf: Support multiple grf to be handled

Shay Drory (4):
  net/mlx5: Fix multiport device check over light SFs
  net/mlx5: DR, Fix circular locking dependency in dump
  net/mlx5: E-switch, Clear legacy flag when moving to switchdev
  net/mlx5: Fix missing devlink lock in SRIOV enable error path

Shekhar Chauhan (1):
  drm/xe/xe2_hpg: Add set of workarounds

Shell Chen (1):
  Bluetooth: btusb: Add new VID/PID for RTL8852CE

Shengjiu Wang (3):
  ASoC: dt-bindings: asahi-kasei,ak4458: set unevaluatedProperties:false
  ASoC: dt-bindings: asahi-kasei,ak4458: Fix the supply names
  ASoC: dt-bindings: asahi-kasei,ak5558: Fix the supply names

Shengming Hu (2):
  watchdog/softlockup: fix sample ring index wrap in
    need_counting_irqs()
  function_graph: Restore direct mode when callbacks drop to one

Shuai Xue (1):
  Documentation: tracing: Add PCI tracepoint documentation

Shuicheng Lin (2):
  drm/xe: Unregister drm device on probe error
  drm/xe/mmio: Avoid double-adjust in 64-bit reads

Shyam Prasad N (2):
  cifs: Fix locking usage for tcon fields
  cifs: some missing initializations on replay

Shyam Sundar S K (1):
  platform/x86/amd/pmf: Prevent TEE errors after hibernate

Siddarth G (1):
  selftests/mm: convert page_size to unsigned long

Slark Xiao (1):
  net: wwan: mhi: Add network support for Foxconn T99W760

Sri Jayaramappa (1):
  libsubcmd: Fix null intersection case in exclude_cmds()

Srinivas Pandruvada (1):
  platform/x86: ISST: Add missing write block check

Srinivasan Shanmugam (4):
  drm/amdkfd: Fix signal_eviction_fence() bool return value
  drm/amdgpu: Use explicit VCN instance 0 in SR-IOV init
  drm/amdkfd: Fix watch_id bounds checking in debug address watch v2
  drm/amd/display: Fix out-of-bounds stream encoder index v3

Stanislav Fomichev (2):
  net: Add skb_dstref_steal and skb_dstref_restore
  net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input
    callers

Stefan Metzmacher (1):
  smb: client: correct value for smbd_max_fragmented_recv_size

Stefan Sørensen (2):
  Bluetooth: hci_conn: Set link_policy on incoming ACL connections
  Bluetooth: hci_conn: use mod_delayed_work for active mode timeout

Stefano Stabellini (1):
  9p/xen: protect xen_9pfs_front_free against concurrent calls

Steven Rostedt (4):
  ftrace: Make ftrace_regs abstract from direct use
  ftrace: Consolidate ftrace_regs accessor functions for archs using
    pt_regs
  tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR
    macros
  fgraph: Do not call handlers direct when not using ftrace_ops

Suchit Karunakaran (1):
  perf annotate: Fix memcpy size in arch__grow_instructions()

Sudeep Holla (1):
  firmware: arm_ffa: Correct 32-bit response handling in
    NOTIFICATION_INFO_GET

Sunday Clement (1):
  drm/amdkfd: Fix out-of-bounds write in kfd_event_page_set()

Suraj Kandpal (1):
  drm/display/dp_mst: Add protection against 0 vcpi

SurajSonawane2415 (1):
  docs: fix WARNING document not included in any toctree

Svyatoslav Ryhel (1):
  drivers: iio: mpu3050: use dev_err_probe for regulator request

Szymon Wilczek (2):
  media: pvrusb2: fix URB leak in pvr2_send_request_ex
  wifi: libertas: fix WARNING in usb_tx_block

Takashi Iwai (5):
  ALSA: pcm: Relax __free() variable declarations
  ALSA: vmaster: Relax __free() variable declarations
  ALSA: mixer: oss: Add card disconnect checkpoints
  ALSA: usb-audio: Update the number of packets properly at receiving
  ALSA: usb-audio: Add sanity check for OOB writes at silencing

Taniya Das (1):
  clk: qcom: rcg2: compute 2d using duty fraction directly

Teddy Astie (1):
  xen/virtio: Don't use grant-dma-ops when running as Dom0

Teguh Sobirin (1):
  drm/msm/dpu: Set vsync source irrespective of mdp top support

Tetsuo Handa (2):
  hfsplus: pretend special inodes as regular files
  xfrm: always flush state and policy upon NETDEV_UNREGISTER event

Thadeu Lima de Souza Cascardo (1):
  fpga: dfl: use subsys_initcall to allow built-in drivers to be added

Thomas Bogendoerfer (1):
  bonding: only set speed/duplex to unknown, if getting speed failed

Thomas Fourier (6):
  auxdisplay: arm-charlcd: fix release_mem_region() size
  crypto: cavium - fix dma_free_coherent() size
  crypto: octeontx - fix dma_free_coherent() size
  net: wan/fsl_ucc_hdlc: Fix dma_free_coherent() in uhdlc_memclean()
  fbdev: vt8500lcdfb: fix missing dma_free_coherent()
  net: ethernet: ec_bhf: Fix dma_free_coherent() dma handle

Thomas Gleixner (1):
  hrtimer: Fix trace oddity

Thomas Richard (1):
  phy: freescale: imx8qm-hsio: fix NULL pointer dereference

Thomas Richard (TI.com) (2):
  phy: ti: phy-j721e-wiz: restore mux selection during resume
  phy: cadence-torrent: restore parent clock for refclk during resume

Thomas Richter (2):
  perf test stat tests: Fix for virtualized machines
  s390/perf: Disable register readout on sampling events

Thomas Weissschuh (1):
  ARM: 9467/1: mm: Don't use %pK through printk

Thomas Weißschuh (4):
  ARM: VDSO: Patch out __vdso_clock_getres() if unavailable
  hyper-v: Mark inner union in hv_kvp_exchg_msg_value as packed
  virt: vbox: uapi: Mark inner unions in packed structs as packed
  binder: don't use %pK through printk

Thomas Yen (1):
  scsi: ufs: core: Flush exception handling work when RPM level is zero

Thomas Zimmermann (2):
  drm/tests: shmem: Swap names of export tests
  fbcon: Remove struct fbcon_display.inverse

Thorsten Schmelzer (2):
  media: adv7180: fix frame interval in progressive mode
  HID: multitouch: add eGalaxTouch EXC3188 support

Tiezhu Yang (3):
  LoongArch: Use %px to print unmodified unwinding address
  LoongArch: Guard percpu handler under !CONFIG_PREEMPT_RT
  LoongArch: Disable instrumentation for setup_ptwalker()

Tim Huang (1):
  drm/amdgpu: add support for HDP IP version 6.1.1

Timur Kristóf (1):
  drm/amd/display: Reject cursor plane on DCE when scaled differently
    than primary

Titouan Ameline de Cadeville (1):
  fs/tests: exec: drop duplicate bprm_stack_limits test vectors

Tom Chung (1):
  drm/amd/display: Fix system resume lag issue

Tomas Melin (2):
  Revert "arm64: zynqmp: Add an OP-TEE node to the device tree"
  rtc: zynqmp: correct frequency value

Tung Nguyen (1):
  tipc: fix duplicate publication key in tipc_service_insert_publ()

Tuo Li (4):
  of: unittest: fix possible null-pointer dereferences in
    of_unittest_property_copy()
  ACPI: processor: Fix NULL-pointer dereference in
    acpi_processor_errata_piix4()
  drm/panel: Fix a possible null-pointer dereference in
    jdi_panel_dsi_remove()
  misc: bcm_vk: Fix possible null-pointer dereferences in bcm_vk_read()

Tycho Andersen (AMD) (1):
  crypto: ccp - narrow scope of snp_range_list

Tzung-Bi Shih (2):
  platform/chrome: cros_ec_lightbar: Fix response size initialization
  remoteproc: mediatek: Break lock dependency to `prepare_lock`

Uwe Kleine-König (1):
  PCI/portdrv: Fix potential resource leak

Vahagn Vardanian (1):
  netfilter: nf_conntrack_h323: fix OOB read in decode_choice()

Val Packett (1):
  power: supply: qcom_battmgr: Recognize "LiP" as lithium-polymer

Varun R Mallya (1):
  libbpf: Fix OOB read in btf_dump_get_bitfield_value

Vasiliy Kovalev (1):
  KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()

Viacheslav Dubeyko (1):
  hfsplus: fix volume corruption issue for generic/498

Vimlesh Kumar (3):
  octeon_ep: disable per ring interrupts
  octeon_ep: ensure dbell BADDR updation
  octeon_ep_vf: ensure dbell BADDR updation

Vinay Belgaumkar (1):
  drm/xe/ptl: Apply Wa_13011645652

Vladimir Oltean (1):
  net: ixp4xx_eth: convert to ndo_hwtstamp_get() and ndo_hwtstamp_set()

Vladimir Zapolskiy (5):
  arm64: dts: qcom: msm8994-octagon: Fix Analog Devices vendor prefix of
    AD7147
  ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
  arm: dts: lpc32xx: add clocks property to Motor Control PWM device
    tree node
  clk: qcom: gcc-sm8550: Use floor ops for SDCC RCGs
  clk: qcom: gcc-sm8650: Use floor ops for SDCC RCGs

Vlastimil Babka (1):
  mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP
    allocations

Votokina Victoria (1):
  nfc: hci: shdlc: Stop timers and work before freeing context

Waqar Hameed (12):
  power: supply: ab8500: Fix use-after-free in power_supply_changed()
  power: supply: act8945a: Fix use-after-free in power_supply_changed()
  power: supply: bq256xx: Fix use-after-free in power_supply_changed()
  power: supply: bq25980: Fix use-after-free in power_supply_changed()
  power: supply: cpcap-battery: Fix use-after-free in
    power_supply_changed()
  power: supply: goldfish: Fix use-after-free in power_supply_changed()
  power: supply: pm8916_bms_vm: Fix use-after-free in
    power_supply_changed()
  power: supply: pm8916_lbc: Fix use-after-free in
    power_supply_changed()
  power: supply: rt9455: Fix use-after-free in power_supply_changed()
  power: supply: sbs-battery: Fix use-after-free in
    power_supply_changed()
  power: supply: wm97xx: Fix NULL pointer dereference in
    power_supply_changed()
  power: supply: pm8916_lbc: Fix use-after-free for extcon in IRQ
    handler

Wayne Lin (1):
  drm/amd/display: Avoid updating surface with the same surface under
    MPO

Wei Li (1):
  pinctrl: single: fix refcount leak in pcs_add_gpio_func()

Weigang He (2):
  mtd: parsers: ofpart: fix OF node refcount leak in
    parse_fixed_partitions()
  fbdev: of: display_timing: fix refcount leak in
    of_get_display_timings()

Weili Qian (1):
  crypto: hisilicon/trng - support tfms sharing the device

Wentao Liang (2):
  ARM: omap2: Fix reference count leaks in omap_control_init()
  soc: ti: pruss: Fix double free in pruss_clk_mux_setup()

William Tambe (1):
  mm/highmem: fix __kmap_to_page() build error

Xiao Kan (1):
  drm: Account property blob allocations to memcg

Xiaolei Wang (2):
  drm/v3d: Set DMA segment size to avoid debug warnings
  media: i2c: ov5647: use our own mutex for the ctrl lock

Xu Yang (1):
  phy: fsl-imx8mq-usb: disable bind/unbind platform driver feature

Xulin Sun (2):
  media: chips-media: wave5: Fix kthread worker destruction in polling
    mode
  media: chips-media: wave5: Fix device cleanup order to prevent kernel
    panic

Yao Kai (1):
  rcu: Fix rcu_read_unlock() deadloop due to softirq

Yao Zi (1):
  MIPS: Work around LLVM bug when gp is used as global register variable

Yauhen Kharuzhy (1):
  ACPI: x86: Force enabling of PWM2 on the Yogabook YB1-X90

Yaxiong Tian (1):
  cpufreq: intel_pstate: Enable asym capacity only when CPU SMT is not
    possible

Yi Liu (2):
  RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
  RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc

Yongjian Sun (1):
  ext4: fix e4b bitmap inconsistency reports

Yosry Ahmed (1):
  KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation

Yu Kuai (2):
  md/raid5: fix raid5_run() to return error when log_init() fails
  blk-mq-debugfs: add missing debugfs_mutex in
    blk_mq_debugfs_register_hctxs()

YuBiao Wang (1):
  drm/amdgpu: Skip loading SDMA_RS64 in VF

YunJe Shin (2):
  RDMA/siw: Fix potential NULL pointer dereference in header processing
  RDMA/umad: Reject negative data_len in ib_umad_write

Yuto Hamaguchi (1):
  netfilter: nf_conntrack: Add allow_clash to generic protocol handler

Yuxiong Wang (1):
  cxl: Fix premature commit_end increment on decoder commit failure

Zhai Can (1):
  ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO

Zhang Yi (6):
  ext4: subdivide EXT4_EXT_DATA_VALID1
  ext4: don't zero the entire extent if EXT4_EXT_DATA_PARTIAL_VALID1
  ext4: don't cache extent during splitting extent
  ext4: drop extent cache after doing PARTIAL_VALID1 zeroout
  ext4: drop extent cache when splitting extent fails
  ext4: use reserved metadata blocks when splitting extent on endio

Zheng Qixing (1):
  md/raid1: fix memory leak in raid1_run() if no active rdev

Zhengmian Hu (1):
  apparmor: avoid per-cpu hold underflow in aa_get_buffer

Zhiyu Zhang (1):
  fat: avoid parent link count underflow in rmdir

Zhongwei (1):
  drm/amd/display: avoid dig reg access timeout on usb4 link training
    fail

Zilin Guan (12):
  i3c: dw: Fix memory leak in dw_i3c_master_i2c_xfers()
  md/raid1: fix memory leak in raid1_run()
  crypto: starfive - Fix memory leak in starfive_aes_aead_do_one_req()
  soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()
  media: chips-media: wave5: Fix memory leak on codec_info allocation
    failure
  mtd: parsers: Fix memory leak in mtd_parser_tplink_safeloader_parse()
  RDMA/mlx5: Fix memory leak in GET_DATA_DIRECT_SYSFS_PATH handler
  scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()
  drm/amdgpu: Fix memory leak in amdgpu_acpi_enumerate_xcc()
  drm/amdgpu: Use kvfree instead of kfree in
    amdgpu_gmc_get_nps_memranges()
  drm/amdgpu: Fix memory leak in amdgpu_ras_init()
  ext4: fix memory leak in ext4_ext_shift_extents()

Ziyi Guo (14):
  wifi: ath10k: sdio: add missing lock protection in
    ath10k_sdio_fw_crashed_dump()
  net: mscc: ocelot: extract ocelot_xmit_timestamp() helper
  net: mscc: ocelot: split xmit into FDMA and register injection paths
  net: mscc: ocelot: add missing lock protection in
    ocelot_port_xmit_inj()
  net: usb: catc: enable basic endpoint checking
  xen-netback: reject zero-queue configuration from guest
  ASoC: fsl_xcvr: Revert fix missing lock in fsl_xcvr_mode_put()
  power: sequencing: fix missing state_lock in pwrseq_power_on() error
    path
  ASoC: fsl: imx-rpmsg: use snd_soc_find_dai_with_mutex() in probe
  wifi: iwlegacy: add missing mutex protection in
    il4965_store_tx_power()
  wifi: iwlegacy: add missing mutex protection in
    il3945_store_measurement()
  wifi: ath10k: fix lock protection in
    ath10k_wmi_event_peer_sta_ps_state_chg()
  net: usb: kaweth: remove TX queue manipulation in kaweth_set_rx_mode
  net: usb: pegasus: enable basic endpoint checking

Zong-Zhe Yang (1):
  wifi: rtw89: ser: enable error IMR after recovering from L1

Zqiang (1):
  rcu: Remove local_irq_save/restore() in
    rcu_preempt_deferred_qs_handler()

decce6 (2):
  drm/amdgpu: Add HAINAN clock adjustment
  drm/radeon: Add HAINAN clock adjustment

ethanwu (2):
  ceph: supply snapshot context in ceph_uninline_data()
  ceph: supply snapshot context in ceph_zero_partial_object()

gongqi (1):
  ALSA: hda/conexant: Add headset mic fix for MECHREVO Wujie 15X Pro

jinbaohong (2):
  btrfs: handle user interrupt properly in btrfs_trim_fs()
  btrfs: continue trimming remaining devices on failure

zhouwenhao (1):
  objpool: fix the overestimation of object pooling metadata size

 Documentation/PCI/endpoint/pci-vntb-howto.rst |  14 +-
 .../devicetree/bindings/phy/qcom,edp-phy.yaml |  28 +-
 .../bindings/sound/asahi-kasei,ak4458.yaml    |   6 +-
 .../bindings/sound/asahi-kasei,ak5558.yaml    |   4 +-
 Documentation/hwmon/mpq8785.rst               |  20 +-
 Documentation/trace/events-pci.rst            |  74 ++++
 Documentation/trace/index.rst                 |  96 ++++-
 Makefile                                      |  15 +-
 arch/alpha/include/asm/pgtable.h              |  33 +-
 arch/alpha/include/asm/tlbflush.h             |   4 +-
 arch/alpha/mm/Makefile                        |   2 +-
 arch/alpha/mm/tlbflush.c                      | 112 +++++
 .../boot/dts/allwinner/sun5i-a13-utoo-p66.dts |   1 +
 arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi        |   3 +-
 arch/arm/kernel/vdso.c                        |   1 +
 arch/arm/mach-omap2/control.c                 |  14 +-
 arch/arm/mm/physaddr.c                        |   2 +-
 arch/arm64/Kbuild                             |   4 +
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi   |   7 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   6 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi   |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   9 +
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi     |  13 +-
 arch/arm64/boot/dts/apple/t8112-j473.dts      |  19 +
 .../imx8mp-tqma8mpql-mba8mp-ras314.dts        |   2 +-
 .../freescale/imx8mp-tqma8mpql-mba8mpxl.dts   |   2 +-
 .../mediatek/mt8183-kukui-jacuzzi-pico6.dts   |   2 +-
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts |   2 +
 .../dts/qcom/msm8994-msft-lumia-octagon.dtsi  |   2 +-
 arch/arm64/boot/dts/qcom/qcm2290.dtsi         |   8 +-
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts      |   2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |   4 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts    |   8 +-
 .../boot/dts/qcom/sdm845-oneplus-common.dtsi  |   2 +-
 arch/arm64/boot/dts/qcom/sm6115.dtsi          |   8 +-
 arch/arm64/boot/dts/qcom/x1e80100.dtsi        |  20 +-
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts |   4 -
 .../dts/ti/k3-j784s4-j742s2-main-common.dtsi  |  36 --
 arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi    |  58 ++-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi        |   5 -
 arch/arm64/include/asm/ftrace.h               |  64 +--
 arch/arm64/include/asm/pgtable.h              |   9 +-
 arch/arm64/include/asm/rwonce.h               |   2 +-
 arch/arm64/kernel/asm-offsets.c               |  34 +-
 arch/arm64/kernel/entry-ftrace.S              |  32 +-
 arch/arm64/kernel/ftrace.c                    |  10 +-
 arch/arm64/kernel/proton-pack.c               |   1 +
 arch/arm64/kernel/ptrace.c                    |   3 +
 arch/arm64/lib/delay.c                        |  23 +-
 arch/loongarch/Kconfig                        |   2 +-
 arch/loongarch/include/asm/ftrace.h           |  53 +--
 arch/loongarch/include/asm/topology.h         |   2 +-
 arch/loongarch/kernel/asm-offsets.c           |  12 -
 arch/loongarch/kernel/ftrace_dyn.c            |   2 +-
 arch/loongarch/kernel/mcount.S                |  17 +-
 arch/loongarch/kernel/mcount_dyn.S            |  14 +-
 arch/loongarch/kernel/setup.c                 |   1 +
 arch/loongarch/kernel/unwind_orc.c            |   2 +-
 arch/loongarch/kernel/unwind_prologue.c       |   2 +-
 arch/loongarch/mm/tlb.c                       |   2 +-
 arch/m68k/lib/memmove.c                       |  18 +
 .../include/asm/mach-loongson64/topology.h    |   2 +-
 arch/mips/kernel/relocate.c                   |  13 +
 arch/mips/rb532/devices.c                     |   5 +-
 arch/openrisc/include/asm/barrier.h           |   2 +
 arch/parisc/kernel/drivers.c                  |   2 +-
 arch/parisc/kernel/process.c                  |   3 +
 arch/powerpc/include/asm/eeh.h                |   2 +
 arch/powerpc/include/asm/ftrace.h             |  34 +-
 arch/powerpc/include/asm/kup.h                |   2 -
 arch/powerpc/include/asm/uaccess.h            |   4 +
 arch/powerpc/kernel/eeh_driver.c              |  11 +-
 arch/powerpc/kernel/eeh_pe.c                  |  74 +++-
 arch/powerpc/kernel/smp.c                     |   2 +
 arch/powerpc/kernel/trace/ftrace.c            |   4 +-
 arch/powerpc/kernel/trace/ftrace_64_pg.c      |   2 +-
 arch/riscv/Kconfig                            |   2 +-
 arch/riscv/include/asm/ftrace.h               |  62 +--
 arch/riscv/kernel/asm-offsets.c               |  28 +-
 arch/riscv/kernel/ftrace.c                    |   2 +-
 arch/riscv/kernel/mcount.S                    |  24 +-
 arch/riscv/kernel/vector.c                    |  12 +-
 arch/s390/Kconfig                             |   5 +-
 arch/s390/include/asm/ftrace.h                |  55 +--
 arch/s390/kernel/asm-offsets.c                |  10 +-
 arch/s390/kernel/ftrace.c                     |   2 +-
 arch/s390/kernel/mcount.S                     |  12 +-
 arch/s390/kernel/perf_cpum_sf.c               |   2 +-
 arch/s390/lib/test_unwind.c                   |   4 +-
 arch/s390/pci/pci.c                           |  25 +-
 arch/s390/purgatory/Makefile                  |   1 +
 arch/sparc/include/uapi/asm/ioctls.h          |   8 +-
 arch/sparc/kernel/process.c                   |  38 +-
 arch/x86/Kconfig                              |   2 +-
 arch/x86/events/core.c                        |   4 +-
 arch/x86/events/intel/cstate.c                |   1 +
 arch/x86/events/msr.c                         |   1 +
 arch/x86/hyperv/hv_vtl.c                      |   8 +-
 arch/x86/include/asm/ftrace.h                 |  62 +--
 arch/x86/kernel/ftrace.c                      |   2 +-
 arch/x86/kernel/ftrace_32.S                   |  13 +-
 arch/x86/kernel/ftrace_64.S                   |  23 +-
 arch/x86/kernel/kexec-bzimage64.c             |   7 +
 arch/x86/kernel/setup.c                       |   6 +
 arch/x86/kvm/svm/nested.c                     |   3 +-
 arch/x86/kvm/svm/svm.c                        |   5 +-
 arch/x86/kvm/x86.c                            |  42 +-
 arch/x86/platform/pvh/head.S                  |   2 +
 arch/x86/xen/enlighten.c                      |   2 +-
 block/bio.c                                   |  16 +
 block/blk-merge.c                             |  21 +-
 block/blk-mq-debugfs.c                        |   2 +
 block/blk.h                                   |   6 +-
 drivers/acpi/acpi_processor.c                 |  28 +-
 drivers/acpi/acpica/evregion.c                |   4 +-
 drivers/acpi/acpica/exoparg3.c                |  46 +-
 drivers/acpi/apei/ghes.c                      |  38 +-
 drivers/acpi/battery.c                        |   9 +-
 drivers/acpi/cppc_acpi.c                      |   4 +-
 drivers/acpi/power.c                          |  13 +
 drivers/acpi/resource.c                       |   8 +
 drivers/acpi/x86/s2idle.c                     |   6 +
 drivers/acpi/x86/utils.c                      |  12 +
 drivers/android/binder.c                      |   2 +-
 drivers/android/binder_alloc.c                |   6 +-
 drivers/ata/libata-core.c                     |  24 ++
 drivers/ata/libata-eh.c                       |   3 +-
 drivers/ata/libata-scsi.c                     |  84 ++--
 drivers/ata/libata.h                          |   1 +
 drivers/ata/pata_ftide010.c                   |   6 +-
 drivers/atm/fore200e.c                        |   4 +
 drivers/auxdisplay/arm-charlcd.c              |   2 +-
 drivers/base/power/wakeirq.c                  |   9 +-
 drivers/base/power/wakeup.c                   |   4 +-
 drivers/block/drbd/drbd_main.c                |   3 -
 drivers/block/drbd/drbd_nl.c                  |  20 +-
 drivers/block/rnbd/rnbd-srv.c                 |  37 +-
 drivers/block/ublk_drv.c                      |   6 +-
 drivers/bluetooth/btintel_pcie.c              |   9 +-
 drivers/bluetooth/btusb.c                     |   5 +
 drivers/bluetooth/hci_qca.c                   |  24 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c               |   6 +-
 drivers/bus/omap-ocp2scp.c                    |  13 +-
 drivers/char/hw_random/core.c                 | 173 +++++---
 drivers/char/ipmi/ipmi_ipmb.c                 |   5 +
 drivers/char/random.c                         |  12 +-
 drivers/char/tpm/st33zp24/st33zp24.c          |   6 +-
 drivers/char/tpm/tpm_i2c_infineon.c           |   6 +-
 drivers/char/tpm/tpm_tis_i2c_cr50.c           |   3 +-
 drivers/char/tpm/tpm_tis_spi_cr50.c           |   2 +-
 drivers/clk/clk-apple-nco.c                   |   1 +
 drivers/clk/clk-renesas-pcie.c                |   2 +-
 drivers/clk/mediatek/clk-mtk.c                |  12 +-
 drivers/clk/meson/gxbb.c                      |  17 +-
 drivers/clk/microchip/clk-core.c              |  25 +-
 drivers/clk/qcom/clk-rcg2.c                   |   7 +-
 drivers/clk/qcom/common.c                     |   2 +-
 drivers/clk/qcom/dispcc-sdm845.c              |   4 +-
 drivers/clk/qcom/dispcc-sm7150.c              |   2 +-
 drivers/clk/qcom/gcc-ipq5018.c                |   1 +
 drivers/clk/qcom/gcc-msm8917.c                |   1 -
 drivers/clk/qcom/gcc-msm8953.c                |   1 -
 drivers/clk/qcom/gcc-qdu1000.c                |   4 +-
 drivers/clk/qcom/gcc-sdx75.c                  |   4 +-
 drivers/clk/qcom/gcc-sm4450.c                 |   6 +-
 drivers/clk/qcom/gcc-sm8450.c                 |   4 +-
 drivers/clk/qcom/gcc-sm8550.c                 |   4 +-
 drivers/clk/qcom/gcc-sm8650.c                 |   4 +-
 drivers/clk/qcom/gcc-x1e80100.c               |   4 +-
 drivers/clk/renesas/rzg2l-cpg.c               |   6 +-
 drivers/clk/tegra/clk-tegra124-emc.c          |   4 +-
 drivers/clocksource/Kconfig                   |   1 +
 drivers/clocksource/sh_tmu.c                  |  18 -
 drivers/cpufreq/cpufreq-dt-platdev.c          |   3 +
 drivers/cpufreq/intel_pstate.c                |   2 +-
 drivers/cpufreq/scmi-cpufreq.c                |   1 +
 drivers/cpuidle/cpuidle.c                     |  10 +
 drivers/cpuidle/governors/menu.c              |  22 +-
 drivers/crypto/caam/caamalg_qi2.c             |  27 +-
 drivers/crypto/caam/caamalg_qi2.h             |   2 +
 drivers/crypto/cavium/cpt/cptvf_main.c        |   3 +-
 drivers/crypto/ccp/psp-dev.c                  |  11 +
 drivers/crypto/ccp/sev-dev.c                  | 153 +++++--
 drivers/crypto/ccp/sp-dev.c                   |  12 +
 drivers/crypto/ccp/sp-dev.h                   |   3 +
 drivers/crypto/ccp/sp-pci.c                   |  16 +-
 drivers/crypto/ccp/tee-dev.c                  |  56 ++-
 drivers/crypto/ccp/tee-dev.h                  |   1 +
 drivers/crypto/hisilicon/qm.c                 |   6 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c    |  62 ++-
 drivers/crypto/hisilicon/trng/trng.c          | 121 ++++--
 drivers/crypto/hisilicon/zip/zip_crypto.c     |  24 +-
 .../intel/qat/qat_common/adf_pfvf_pf_proto.c  |  10 +
 .../crypto/marvell/octeontx/otx_cptvf_main.c  |   3 +-
 drivers/crypto/starfive/jh7110-aes.c          |   9 +-
 drivers/cxl/core/hdm.c                        |   3 +-
 drivers/dma/dma-axi-dmac.c                    |  11 +-
 drivers/dma/fsl-edma-main.c                   |   1 -
 drivers/dma/mediatek/mtk-uart-apdma.c         |  10 +-
 drivers/dma/stm32/stm32-dma3.c                |   7 +-
 drivers/dma/stm32/stm32-mdma.c                |   2 +-
 drivers/dma/sun6i-dma.c                       |  26 +-
 drivers/edac/altera_edac.c                    |  11 +-
 drivers/edac/i5000_edac.c                     |   1 +
 drivers/edac/i5400_edac.c                     |   2 +-
 drivers/firmware/arm_ffa/driver.c             |  34 +-
 drivers/firmware/efi/cper-arm.c               |  12 +-
 drivers/firmware/efi/cper.c                   |   8 +-
 drivers/firmware/efi/efi.c                    |   8 +-
 drivers/fpga/dfl.c                            |   2 +-
 drivers/fpga/of-fpga-region.c                 |   8 +-
 drivers/gpio/gpio-aspeed-sgpio.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c      |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c    |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c   |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c       |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c       |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c       |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c       |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c       |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c      |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c         |  45 +-
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c        |  20 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c       |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c      |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c      |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c        |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c          |   7 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  44 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_plane.c   |   9 +-
 .../display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c  |  16 +-
 .../dc/dio/dcn32/dcn32_dio_link_encoder.c     |  15 +-
 .../drm/amd/display/dc/dml/dcn35/dcn35_fpu.c  |   4 +-
 .../drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c  |  21 +-
 .../drm/amd/display/dc/dpp/dcn30/dcn30_dpp.h  |   4 +
 .../amd/display/dc/dpp/dcn401/dcn401_dpp.c    |   6 +-
 .../amd/display/dc/hwss/dce110/dce110_hwseq.c |  36 +-
 .../amd/display/dc/hwss/dcn20/dcn20_hwseq.c   |  12 +-
 .../amd/display/dc/hwss/dcn31/dcn31_hwseq.c   |  16 +-
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.c |   8 +-
 .../drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c  |   3 +-
 .../dc/resource/dcn315/dcn315_resource.c      |   8 +-
 .../dc/resource/dcn316/dcn316_resource.c      |   8 +-
 .../dc/resource/dcn32/dcn32_resource.c        |   8 +-
 .../dc/resource/dcn321/dcn321_resource.c      |   8 +-
 .../dc/resource/dcn35/dcn35_resource.c        |   8 +-
 .../dc/resource/dcn351/dcn351_resource.c      |   8 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c    |   5 +
 .../gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c   |  25 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c     |   2 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c |   3 +-
 drivers/gpu/drm/drm_buddy.c                   |  10 +
 drivers/gpu/drm/drm_property.c                |   2 +-
 drivers/gpu/drm/i915/display/intel_acpi.c     |   1 +
 drivers/gpu/drm/i915/intel_wakeref.c          |   2 +-
 drivers/gpu/drm/i915/intel_wakeref.h          |  14 +-
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c         |   5 +-
 .../msm/disp/dpu1/catalog/dpu_7_2_sc7280.h    |  14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c   |  18 +-
 .../drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c  |   7 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c   |  49 ++-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.h   |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_top.c    |   7 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h   |   7 +
 drivers/gpu/drm/msm/disp/mdp_format.c         |   8 +-
 drivers/gpu/drm/panel/panel-edp.c             |   1 +
 drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c |   4 +-
 drivers/gpu/drm/panel/panel-lg-sw43408.c      |   4 -
 drivers/gpu/drm/panthor/panthor_gpu.c         |  19 +-
 drivers/gpu/drm/panthor/panthor_mmu.c         |   4 +
 drivers/gpu/drm/panthor/panthor_sched.c       | 167 +++++---
 drivers/gpu/drm/panthor/panthor_sched.h       |   1 +
 drivers/gpu/drm/radeon/si_dpm.c               |   5 +
 drivers/gpu/drm/tests/drm_gem_shmem_test.c    |   6 +-
 drivers/gpu/drm/v3d/v3d_drv.c                 |   2 +
 drivers/gpu/drm/xe/xe_assert.h                |   2 +-
 drivers/gpu/drm/xe/xe_device.c                |   1 +
 drivers/gpu/drm/xe/xe_device.h                |   3 +-
 drivers/gpu/drm/xe/xe_device_types.h          |  56 ++-
 drivers/gpu/drm/xe/xe_gt_freq.c               |   2 +-
 drivers/gpu/drm/xe/xe_gt_printk.h             |   2 +-
 drivers/gpu/drm/xe/xe_gt_types.h              |  22 +-
 drivers/gpu/drm/xe/xe_guc_submit.c            |   3 +-
 drivers/gpu/drm/xe/xe_mmio.c                  | 150 +++----
 drivers/gpu/drm/xe/xe_mmio.h                  |  76 +++-
 drivers/gpu/drm/xe/xe_pci.c                   |  11 +
 drivers/gpu/drm/xe/xe_reg_sr.c                |   9 +-
 drivers/gpu/drm/xe/xe_trace.h                 |   7 +-
 drivers/gpu/drm/xe/xe_wa.c                    |  56 +--
 drivers/gpu/drm/xe/xe_wa_oob.rules            |   5 +-
 drivers/hid/Kconfig                           |   1 +
 drivers/hid/hid-apple.c                       |   1 +
 drivers/hid/hid-elecom.c                      |  16 +
 drivers/hid/hid-ids.h                         |   4 +
 drivers/hid/hid-logitech-hidpp.c              |   4 +-
 drivers/hid/hid-magicmouse.c                  |   5 +
 drivers/hid/hid-multitouch.c                  |   3 +
 drivers/hid/hid-pl.c                          |   7 +-
 drivers/hid/hid-playstation.c                 |   4 +-
 drivers/hid/hid-prodikeys.c                   |   4 +
 drivers/hid/hid-quirks.c                      |   3 +
 drivers/hid/i2c-hid/i2c-hid-of-elan.c         |   8 +
 drivers/hid/intel-ish-hid/ishtp/bus.c         |   2 +-
 drivers/hv/vmbus_drv.c                        |  66 ++-
 drivers/hwmon/dell-smm-hwmon.c                |   7 +
 drivers/hwmon/f71882fg.c                      |   6 +-
 drivers/hwmon/ibmpex.c                        |   9 +-
 drivers/hwmon/nct6775-platform.c              |   1 +
 drivers/hwmon/pmbus/mpq8785.c                 | 111 ++++-
 drivers/hwspinlock/omap_hwspinlock.c          |   4 +-
 .../coresight/coresight-etm3x-core.c          |  12 +-
 drivers/i3c/master.c                          |   6 +-
 drivers/i3c/master/dw-i3c-master.c            |   3 +
 drivers/i3c/master/mipi-i3c-hci/dma.c         |   8 +
 drivers/i3c/master/svc-i3c-master.c           |   4 +-
 drivers/iio/accel/adxl380.c                   |   1 +
 drivers/iio/accel/bma180.c                    |   5 +-
 drivers/iio/accel/sca3000.c                   |   6 +-
 drivers/iio/adc/ad7766.c                      |   2 +-
 drivers/iio/gyro/itg3200_buffer.c             |   8 +-
 drivers/iio/gyro/itg3200_core.c               |   2 +
 drivers/iio/gyro/mpu3050-core.c               |   6 +-
 drivers/iio/light/si1145.c                    |   2 +-
 drivers/iio/magnetometer/ak8975.c             |   2 +-
 drivers/iio/pressure/mprls0025pa.c            |  36 +-
 drivers/iio/pressure/mprls0025pa.h            |   2 -
 drivers/iio/pressure/mprls0025pa_spi.c        |  19 +-
 drivers/iio/test/Kconfig                      |   1 -
 drivers/infiniband/core/cache.c               |  16 +-
 drivers/infiniband/core/core_priv.h           |   3 +
 drivers/infiniband/core/device.c              |  34 +-
 drivers/infiniband/core/iwcm.c                |  56 +--
 drivers/infiniband/core/iwcm.h                |   1 -
 drivers/infiniband/core/rw.c                  |  53 ++-
 drivers/infiniband/core/umem_dmabuf.c         |   4 +-
 drivers/infiniband/core/user_mad.c            |   8 +-
 drivers/infiniband/core/uverbs_cmd.c          |   7 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |   2 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c       |  23 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  54 ++-
 drivers/infiniband/hw/mlx5/main.c             |  95 ++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   2 +
 drivers/infiniband/hw/mlx5/std_types.c        |   4 +-
 drivers/infiniband/sw/rxe/rxe_comp.c          |   3 +
 drivers/infiniband/sw/rxe/rxe_req.c           |   3 +
 drivers/infiniband/sw/rxe/rxe_srq.c           |   6 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c         |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |   4 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c        |  33 +-
 drivers/interconnect/mediatek/icc-emi.c       |   9 +-
 drivers/iommu/amd/iommu.c                     |  25 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  31 +-
 drivers/iommu/intel/Makefile                  |   2 +-
 drivers/iommu/intel/iommu.c                   |  19 +-
 drivers/iommu/intel/iommu.h                   |  14 +-
 drivers/iommu/intel/pasid.c                   |  17 +-
 drivers/iommu/intel/pasid.h                   |  14 +
 drivers/iommu/intel/prq.c                     | 402 ++++++++++++++++++
 drivers/iommu/intel/svm.c                     | 397 -----------------
 drivers/leds/rgb/leds-qcom-lpg.c              |   8 +-
 drivers/mailbox/bcm-flexrm-mailbox.c          |  14 +-
 drivers/mailbox/imx-mailbox.c                 |   8 +-
 drivers/mailbox/pcc.c                         |   2 +-
 drivers/mailbox/sprd-mailbox.c                |  20 +-
 drivers/md/dm-exception-store.c               |   2 +-
 drivers/md/dm-integrity.c                     |  15 +-
 drivers/md/dm-log.c                           |   2 +-
 drivers/md/dm-mpath.c                         |   2 +-
 drivers/md/dm-path-selector.c                 |   2 +-
 drivers/md/dm-rq.c                            |  16 +-
 drivers/md/dm-target.c                        |   2 +-
 drivers/md/dm-unstripe.c                      |   2 +-
 drivers/md/dm-verity-fec.c                    |   4 +-
 drivers/md/dm-zone.c                          |  11 +-
 drivers/md/dm.c                               |   2 +
 drivers/md/md-bitmap.c                        |   3 +-
 drivers/md/md-cluster.c                       |   7 +-
 drivers/md/raid1.c                            |   9 +-
 drivers/md/raid10.c                           |   2 +-
 drivers/md/raid5.c                            |   3 +-
 drivers/media/dvb-core/dmxdev.c               |   8 +-
 drivers/media/dvb-core/dvb_vb2.c              |   5 +-
 drivers/media/i2c/adv7180.c                   |   7 +
 drivers/media/i2c/ccs/ccs-core.c              |  28 +-
 drivers/media/i2c/mt9m114.c                   |  16 +-
 drivers/media/i2c/ov01a10.c                   |  46 +-
 drivers/media/i2c/ov5647.c                    |  24 +-
 drivers/media/i2c/tw9903.c                    |   1 +
 drivers/media/i2c/tw9906.c                    |   1 +
 drivers/media/pci/cx23885/cx23885-alsa.c      |   4 +-
 drivers/media/pci/cx25821/cx25821-alsa.c      |   1 +
 drivers/media/pci/cx25821/cx25821-core.c      |   1 +
 drivers/media/pci/cx88/cx88-alsa.c            |   4 +-
 .../media/pci/intel/ipu6/ipu6-isys-queue.c    |   8 +-
 .../media/pci/intel/ipu6/ipu6-isys-video.c    |   6 +-
 drivers/media/pci/intel/ipu6/ipu6-mmu.c       |   4 +-
 drivers/media/pci/intel/ipu6/ipu6.c           |  10 +-
 drivers/media/pci/mgb4/mgb4_trigger.c         |   2 +-
 drivers/media/pci/solo6x10/solo6x10-tw28.c    |   8 +-
 drivers/media/platform/amphion/vdec.c         |   1 +
 drivers/media/platform/amphion/vpu_v4l2.c     |   2 -
 .../chips-media/wave5/wave5-vpu-dec.c         |   4 +-
 .../chips-media/wave5/wave5-vpu-enc.c         |   9 +-
 .../platform/chips-media/wave5/wave5-vpu.c    |  10 +-
 .../platform/mediatek/mdp/mtk_mdp_core.c      |  17 +-
 .../vcodec/decoder/mtk_vcodec_dec_stateless.c |   6 +
 .../mediatek/vcodec/encoder/mtk_vcodec_enc.c  |   6 +-
 .../media/platform/qcom/camss/camss-vfe-480.c |   6 +-
 drivers/media/platform/qcom/venus/vdec.c      |  14 +-
 drivers/media/platform/rockchip/rga/rga-buf.c |   3 +
 .../platform/rockchip/rkisp1/rkisp1-params.c  |   6 -
 .../st/stm32/stm32-dcmipp/dcmipp-bytecap.c    |   3 +
 .../media/platform/ti/omap3isp/isppreview.c   |  21 +-
 drivers/media/platform/ti/omap3isp/ispvideo.c |  14 +-
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c  |  43 +-
 drivers/media/radio/radio-keene.c             |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c       |   5 +
 drivers/media/usb/uvc/uvc_video.c             |   3 +-
 drivers/media/v4l2-core/v4l2-async.c          |  45 +-
 drivers/mfd/Kconfig                           |  24 ++
 drivers/mfd/arizona-core.c                    |   2 +-
 drivers/mfd/da9052-spi.c                      |   2 +-
 drivers/mfd/intel-lpss-pci.c                  |  13 +
 drivers/mfd/mfd-core.c                        |  36 +-
 drivers/mfd/omap-usb-host.c                   |   6 +-
 drivers/mfd/qcom-pm8xxx.c                     |   8 +-
 drivers/mfd/simple-mfd-i2c.c                  |  33 +-
 drivers/misc/bcm-vk/bcm_vk_msg.c              |  12 +-
 drivers/misc/eeprom/eeprom_93xx46.c           |  11 +-
 drivers/most/core.c                           |  15 +-
 .../mtd/nand/raw/cadence-nand-controller.c    |   2 +-
 drivers/mtd/nand/raw/pl35x-nand-controller.c  |   1 +
 drivers/mtd/nand/spi/core.c                   |   8 +
 drivers/mtd/parsers/ofpart_core.c             |  16 +-
 drivers/mtd/parsers/tplink_safeloader.c       |   1 +
 drivers/net/bonding/bond_main.c               |  21 +-
 drivers/net/caif/caif_serial.c                |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  13 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  13 +-
 drivers/net/ethernet/cadence/macb_main.c      |  11 +-
 drivers/net/ethernet/ec_bhf.c                 |   2 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   7 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  11 +-
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |   5 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   8 +-
 .../marvell/octeon_ep/octep_cn9k_pf.c         |  21 +-
 .../marvell/octeon_ep/octep_cnxk_pf.c         |  64 ++-
 .../ethernet/marvell/octeon_ep/octep_main.h   |   2 +-
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |   1 +
 .../marvell/octeon_ep/octep_regs_cnxk_pf.h    |   1 +
 .../net/ethernet/marvell/octeon_ep/octep_rx.c |   8 +-
 .../marvell/octeon_ep_vf/octep_vf_cn9k.c      |   3 +-
 .../marvell/octeon_ep_vf/octep_vf_cnxk.c      |  39 +-
 .../marvell/octeon_ep_vf/octep_vf_main.h      |   2 +-
 .../marvell/octeon_ep_vf/octep_vf_rx.c        |   8 +-
 .../net/ethernet/marvell/octeontx2/af/cgx.c   |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  11 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  12 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  41 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   1 +
 drivers/net/ethernet/marvell/skge.c           |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   3 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 113 ++++-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  26 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  75 ++--
 .../mellanox/mlx5/core/eswitch_offloads.c     |   2 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |   2 +
 .../mellanox/mlx5/core/steering/dr_dbg.c      |   4 +-
 .../ethernet/microchip/sparx5/sparx5_ptp.c    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_qos.h    |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  75 +++-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  28 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   |   7 +-
 drivers/net/ethernet/sun/sunhme.c             |   3 +
 drivers/net/ethernet/ti/Kconfig               |   1 +
 drivers/net/ethernet/ti/cpsw_new.c            |  12 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |  60 ++-
 drivers/net/ethernet/xscale/ptp_ixp46x.c      |   3 +
 drivers/net/macvlan.c                         |   5 +
 drivers/net/mctp/mctp-i2c.c                   |   9 +
 drivers/net/phy/sfp.c                         |   8 +-
 drivers/net/usb/Kconfig                       |   1 -
 drivers/net/usb/catc.c                        |  37 +-
 drivers/net/usb/kaweth.c                      |   2 -
 drivers/net/usb/lan78xx.c                     |   2 -
 drivers/net/usb/pegasus.c                     |  35 +-
 drivers/net/usb/r8152.c                       |   2 +
 drivers/net/usb/sr9700.c                      |  25 +-
 drivers/net/usb/sr9700.h                      |   7 +-
 drivers/net/wan/farsync.c                     |   2 +
 drivers/net/wan/fsl_ucc_hdlc.c                |   8 +-
 drivers/net/wireless/ath/ath10k/sdio.c        |   6 +
 drivers/net/wireless/ath/ath10k/wmi.c         |   4 +-
 drivers/net/wireless/ath/ath11k/core.c        |  28 ++
 drivers/net/wireless/ath/ath11k/reg.c         |   9 +-
 drivers/net/wireless/ath/ath12k/wmi.c         |   2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |   8 +-
 .../net/wireless/intel/iwlegacy/3945-mac.c    |   2 +
 .../net/wireless/intel/iwlegacy/4965-mac.c    |   2 +
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  14 +
 .../net/wireless/marvell/libertas/if_usb.c    |   2 +
 drivers/net/wireless/realtek/rtw88/main.c     |  47 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   2 +-
 .../net/wireless/realtek/rtw88/rtw8821cu.c    |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |   3 +-
 drivers/net/wireless/realtek/rtw89/fw.c       |   3 +
 drivers/net/wireless/realtek/rtw89/mac.c      |   1 +
 drivers/net/wireless/realtek/rtw89/mac.h      |   1 +
 drivers/net/wireless/realtek/rtw89/mac_be.c   |   3 +-
 drivers/net/wireless/realtek/rtw89/pci.c      |   1 +
 drivers/net/wireless/realtek/rtw89/rtw8922a.c |  79 +++-
 drivers/net/wireless/realtek/rtw89/ser.c      |  10 +
 drivers/net/wireless/realtek/rtw89/wow.c      |   4 +
 drivers/net/wireless/realtek/rtw89/wow.h      |   1 +
 drivers/net/wwan/mhi_wwan_mbim.c              |   3 +-
 drivers/net/xen-netback/xenbus.c              |   5 +-
 drivers/nfc/nxp-nci/i2c.c                     |   2 +-
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c        |  12 +-
 drivers/ntb/ntb_transport.c                   |   4 +-
 drivers/nvdimm/nd_virtio.c                    |   3 +-
 drivers/nvdimm/virtio_pmem.c                  |   1 +
 drivers/nvdimm/virtio_pmem.h                  |   4 +
 drivers/nvmem/core.c                          |   1 +
 drivers/of/unittest.c                         |   6 +-
 drivers/opp/core.c                            |   2 +-
 .../pci/controller/dwc/pcie-designware-host.c |   9 +-
 drivers/pci/controller/dwc/pcie-qcom.c        |   4 +-
 drivers/pci/controller/pcie-mediatek.c        |   4 +-
 drivers/pci/endpoint/pci-ep-cfs.c             |   8 +-
 drivers/pci/iov.c                             |   9 +-
 drivers/pci/msi/msi.c                         |   4 +-
 drivers/pci/p2pdma.c                          |   1 +
 drivers/pci/pci-acpi.c                        |  59 ++-
 drivers/pci/pci-driver.c                      |   8 +
 drivers/pci/pci.c                             |  42 +-
 drivers/pci/pci.h                             |   8 +
 drivers/pci/pcie/aer.c                        |  29 +-
 drivers/pci/pcie/portdrv.c                    |   6 +-
 drivers/pci/probe.c                           |  45 +-
 drivers/pci/quirks.c                          |  27 ++
 drivers/perf/arm-cmn.c                        |  19 +-
 drivers/perf/arm_spe_pmu.c                    |  18 +-
 drivers/perf/cxl_pmu.c                        |   2 +-
 drivers/phy/cadence/phy-cadence-torrent.c     |  23 +
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c    |   1 +
 drivers/phy/freescale/phy-fsl-imx8qm-hsio.c   |   2 +-
 drivers/phy/marvell/phy-mvebu-cp110-utmi.c    |   2 +-
 drivers/phy/qualcomm/phy-qcom-edp.c           |  16 +-
 drivers/phy/ti/phy-j721e-wiz.c                |  19 +-
 drivers/pinctrl/intel/Kconfig                 |  21 +-
 drivers/pinctrl/pinctrl-equilibrium.c         |   1 +
 drivers/pinctrl/pinctrl-single.c              |   2 +
 .../pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c   |   2 +-
 drivers/platform/chrome/cros_ec_lightbar.c    |   2 +-
 drivers/platform/chrome/cros_typec_switch.c   |   6 +-
 drivers/platform/x86/amd/pmf/core.c           |  62 ++-
 drivers/platform/x86/amd/pmf/pmf.h            |  10 +
 drivers/platform/x86/amd/pmf/tee-if.c         |  12 +-
 drivers/platform/x86/intel/int0002_vgpio.c    |   4 +-
 .../intel/speed_select_if/isst_tpmi_core.c    |   3 +
 drivers/power/reset/nvmem-reboot-mode.c       |  15 +-
 drivers/power/sequencing/core.c               |   6 +-
 drivers/power/supply/ab8500_charger.c         |  40 +-
 drivers/power/supply/act8945a_charger.c       |  16 +-
 drivers/power/supply/bq256xx_charger.c        |  12 +-
 drivers/power/supply/bq25980_charger.c        |  12 +-
 drivers/power/supply/bq27xxx_battery.c        |   6 +-
 drivers/power/supply/cpcap-battery.c          |   8 +-
 drivers/power/supply/goldfish_battery.c       |  12 +-
 drivers/power/supply/pm8916_bms_vm.c          |  18 +-
 drivers/power/supply/pm8916_lbc.c             |  18 +-
 drivers/power/supply/qcom_battmgr.c           |   3 +-
 drivers/power/supply/rt9455_charger.c         |  17 +-
 drivers/power/supply/sbs-battery.c            |  36 +-
 drivers/power/supply/wm97xx_battery.c         |  34 +-
 drivers/powercap/intel_rapl_msr.c             |   1 +
 drivers/powercap/intel_rapl_tpmi.c            |   2 +-
 drivers/rapidio/rio-scan.c                    |   3 +-
 drivers/ras/ras.c                             |   6 +-
 drivers/regulator/core.c                      |  55 +--
 drivers/remoteproc/imx_dsp_rproc.c            |   9 +
 drivers/remoteproc/imx_rproc.c                |   4 +
 drivers/remoteproc/mtk_scp.c                  |  39 +-
 drivers/remoteproc/mtk_scp_ipi.c              |   4 +-
 drivers/reset/reset-gpio.c                    |   1 +
 drivers/rpmsg/rpmsg_core.c                    |  66 ++-
 drivers/rtc/interface.c                       |   2 +-
 drivers/rtc/rtc-zynqmp.c                      |   3 +
 drivers/s390/cio/css.c                        |   2 +-
 drivers/scsi/BusLogic.c                       |   6 +-
 drivers/scsi/csiostor/csio_scsi.c             |   3 +-
 drivers/scsi/elx/efct/efct_driver.c           |   8 +-
 drivers/scsi/smartpqi/smartpqi_init.c         |  13 +-
 drivers/soc/mediatek/mtk-svs.c                |   5 +-
 drivers/soc/qcom/cmd-db.c                     |   7 +-
 drivers/soc/qcom/smem.c                       |   4 +-
 drivers/soc/rockchip/grf.c                    |  57 ++-
 drivers/soc/ti/k3-socinfo.c                   |   2 +-
 drivers/soc/ti/pruss.c                        |   6 +-
 drivers/soundwire/Kconfig                     |   1 +
 drivers/soundwire/dmi-quirks.c                |  11 +
 drivers/soundwire/intel_auxdevice.c           |   1 +
 drivers/spi/spi-geni-qcom.c                   |  38 +-
 drivers/spi/spi-mem.c                         |  26 +-
 drivers/spi/spi-stm32.c                       |   9 +-
 drivers/spi/spi-wpcm-fiu.c                    |   2 +-
 drivers/spi/spidev.c                          |  63 +--
 drivers/staging/greybus/light.c               |   8 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c     |   6 +-
 .../staging/rtl8723bs/os_dep/ioctl_cfg80211.c |   3 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c  |   3 +-
 .../int340x_thermal/processor_thermal_rfim.c  |   5 +-
 drivers/thermal/intel/x86_pkg_temp_thermal.c  |   3 +
 drivers/thermal/thermal_of.c                  |   4 +-
 drivers/tty/serial/8250/8250_dw.c             |  11 +-
 drivers/tty/serial/8250/8250_omap.c           |  25 +-
 drivers/tty/serial/Kconfig                    |   8 +-
 drivers/ufs/core/ufshcd.c                     |   2 +
 drivers/ufs/host/Kconfig                      |   1 +
 drivers/ufs/host/ufs-mediatek-trace.h         |   6 +-
 drivers/ufs/host/ufs-mediatek.c               |  12 +-
 drivers/usb/chipidea/udc.c                    |   7 +
 drivers/usb/dwc2/core.c                       |   1 +
 drivers/usb/dwc3/core.c                       |  19 +-
 drivers/usb/dwc3/core.h                       |   4 +
 drivers/usb/dwc3/gadget.c                     |   8 +-
 drivers/usb/gadget/function/f_fs.c            |  24 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c         |   4 +-
 drivers/usb/gadget/udc/tegra-xudc.c           |  12 +-
 drivers/usb/typec/ucsi/psy.c                  |  30 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c             |   3 -
 drivers/vdpa/vdpa_sim/vdpa_sim.c              |   6 -
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   3 +-
 drivers/vfio/pci/vfio_pci_core.c              |  17 +-
 drivers/vhost/vdpa.c                          |   3 +-
 drivers/video/backlight/qcom-wled.c           |  42 +-
 drivers/video/fbdev/au1200fb.c                |   6 +-
 drivers/video/fbdev/core/fbcon.c              |   3 +-
 drivers/video/fbdev/core/fbcon.h              |   1 -
 drivers/video/fbdev/ffb.c                     |  14 +-
 drivers/video/fbdev/vt8500lcdfb.c             |   5 +-
 drivers/video/of_display_timing.c             |  10 +-
 drivers/watchdog/imx7ulp_wdt.c                |   1 +
 drivers/watchdog/it87_wdt.c                   |  12 +
 drivers/watchdog/starfive-wdt.c               |   2 +-
 drivers/xen/balloon.c                         |  19 +-
 drivers/xen/grant-dma-ops.c                   |   3 +-
 drivers/xen/unpopulated-alloc.c               |   3 +
 drivers/xen/xenbus/xenbus_probe_frontend.c    |   4 +-
 fs/btrfs/block-rsv.c                          |   7 +-
 fs/btrfs/direct-io.c                          |  12 +
 fs/btrfs/extent-tree.c                        |  13 +-
 fs/btrfs/qgroup.c                             |  15 +-
 fs/btrfs/transaction.c                        |   9 +-
 fs/btrfs/volumes.c                            |  10 +-
 fs/buffer.c                                   |   4 +
 fs/ceph/addr.c                                |  24 +-
 fs/ceph/file.c                                |  17 +-
 fs/dlm/lock.c                                 |   3 +-
 fs/erofs/fileio.c                             |  22 +-
 fs/erofs/fscache.c                            |   4 +-
 fs/ext4/extents.c                             |  65 ++-
 fs/ext4/ioctl.c                               |   3 +
 fs/ext4/mballoc-test.c                        |   2 +-
 fs/ext4/mballoc.c                             |  44 +-
 fs/ext4/super.c                               |  10 +-
 fs/fat/namei_msdos.c                          |   7 +-
 fs/fat/namei_vfat.c                           |   7 +-
 fs/fs_struct.c                                |   1 +
 fs/gfs2/bmap.c                                |  13 +-
 fs/gfs2/glock.c                               |  36 +-
 fs/gfs2/glock.h                               |   3 +-
 fs/gfs2/inode.c                               |  34 +-
 fs/gfs2/quota.c                               |   1 +
 fs/hfsplus/bnode.c                            |   2 +-
 fs/hfsplus/inode.c                            |  12 +-
 fs/hfsplus/super.c                            |   6 +
 fs/iomap/direct-io.c                          |  10 +-
 fs/jfs/jfs_logmgr.c                           |   1 +
 fs/jfs/namei.c                                |   6 +-
 fs/minix/inode.c                              |  50 ++-
 fs/namespace.c                                |   2 +-
 fs/nfs/dir.c                                  |   4 +-
 fs/nfs/localio.c                              |  31 +-
 fs/nfs/pnfs.c                                 |   3 +-
 fs/nfsd/nfs2acl.c                             |   2 +-
 fs/nfsd/nfs4idmap.c                           |  52 ++-
 fs/nfsd/nfs4proc.c                            |   2 -
 fs/nfsd/nfs4xdr.c                             |  16 +
 fs/nfsd/nfsproc.c                             |   2 +-
 fs/ntfs3/attrib.c                             |  19 +-
 fs/ntfs3/attrlist.c                           |   9 +
 fs/ntfs3/file.c                               |  10 +-
 fs/ntfs3/fslog.c                              |   3 +
 fs/ntfs3/fsntfs.c                             |   6 +
 fs/ntfs3/index.c                              |   7 +-
 fs/ocfs2/xattr.c                              |   4 +
 fs/overlayfs/readdir.c                        |   2 +-
 fs/proc/array.c                               |   2 +-
 fs/proc/task_mmu.c                            |   3 +-
 fs/pstore/ram_core.c                          |  18 +
 fs/quota/quota.c                              |   1 +
 fs/smb/client/cached_dir.c                    |   4 +-
 fs/smb/client/connect.c                       |   2 +
 fs/smb/client/smb2file.c                      |   2 +
 fs/smb/client/smb2misc.c                      |   6 +-
 fs/smb/client/smb2ops.c                       |  29 +-
 fs/smb/client/smb2pdu.c                       |   3 +
 fs/smb/client/smbdirect.c                     |  19 +-
 fs/smb/client/trace.h                         |   1 +
 fs/tests/exec_kunit.c                         |   6 -
 fs/xfs/libxfs/xfs_attr.c                      |  75 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c                 |  49 ++-
 fs/xfs/scrub/agheader_repair.c                |   8 +-
 fs/xfs/scrub/alloc_repair.c                   |  15 +
 fs/xfs/scrub/attr.c                           |  59 +--
 fs/xfs/scrub/attr_repair.c                    |   6 +-
 fs/xfs/scrub/btree.c                          |   2 +
 fs/xfs/scrub/common.c                         |   7 +
 fs/xfs/scrub/dabtree.c                        |   2 +
 fs/xfs/scrub/dir_repair.c                     |   8 +-
 fs/xfs/scrub/dirtree.c                        |   8 +-
 fs/xfs/scrub/ialloc_repair.c                  |  20 +-
 fs/xfs/scrub/nlinks.c                         |   3 +-
 fs/xfs/scrub/repair.c                         |   3 +
 fs/xfs/scrub/scrub.c                          |   2 +-
 include/acpi/ghes.h                           |   1 +
 include/asm-generic/audit_change_attr.h       |   3 +
 include/asm-generic/audit_read.h              |   6 +
 include/drm/drm_of.h                          |   3 +
 include/linux/audit.h                         |   6 -
 include/linux/audit_arch.h                    |   7 +
 include/linux/bio.h                           |   2 +
 include/linux/capability.h                    |   6 +
 include/linux/clk.h                           |  48 +--
 include/linux/compiler_types.h                |  23 +-
 include/linux/cper.h                          |   3 +-
 include/linux/ftrace.h                        | 152 +++++--
 include/linux/ftrace_regs.h                   |  38 ++
 include/linux/hw_random.h                     |   2 +
 include/linux/inetdevice.h                    |   2 +-
 include/linux/interrupt.h                     |   2 +-
 include/linux/mfd/wm8350/core.h               |   2 +-
 include/linux/mlx5/driver.h                   |   4 +-
 include/linux/module.h                        |   9 +
 include/linux/mtd/spinand.h                   |   2 +-
 include/linux/pci_ids.h                       |   1 +
 include/linux/psp.h                           |   1 +
 include/linux/skbuff.h                        |  32 ++
 include/linux/skmsg.h                         |  70 ++-
 include/linux/sunrpc/xdrgen/_builtins.h       |  20 +-
 include/linux/trace_events.h                  |   5 +
 include/linux/u64_stats_sync.h                |  10 +
 include/media/dvb_vb2.h                       |   6 +-
 include/net/bluetooth/l2cap.h                 |   8 +-
 include/net/ioam6.h                           |   2 +
 include/net/ipv6.h                            |  15 +-
 include/net/netfilter/nf_conntrack_count.h    |   1 +
 include/net/netfilter/nf_queue.h              |   4 +
 include/net/netns/ipv4.h                      |   9 +-
 include/rdma/rw.h                             |   2 +
 include/uapi/linux/hyperv.h                   |   2 +-
 include/uapi/linux/netfilter_bridge.h         |   4 +
 include/uapi/linux/nfs.h                      |   2 +-
 include/uapi/linux/vbox_vmmdev_types.h        |   4 +-
 include/ufs/ufshcd.h                          |   4 -
 include/xen/xen.h                             |   2 +
 io_uring/cancel.h                             |   6 +-
 io_uring/filetable.c                          |   4 +
 io_uring/io_uring.c                           |   6 +-
 io_uring/msg_ring.c                           |  12 +-
 io_uring/net.c                                |   6 +-
 io_uring/register.c                           |   3 +-
 io_uring/sync.c                               |   2 +
 ipc/ipc_sysctl.c                              |   2 +-
 kernel/bpf/crypto.c                           |   8 +-
 kernel/bpf/verifier.c                         |  61 ++-
 kernel/configs/debug.config                   |   1 -
 kernel/kallsyms.c                             |   4 +-
 kernel/kexec_file.c                           | 131 +++---
 kernel/module/kallsyms.c                      |   9 +-
 kernel/rcu/tree.h                             |   2 +-
 kernel/rcu/tree_plugin.h                      |  99 ++++-
 kernel/sched/deadline.c                       |   3 +
 kernel/sched/debug.c                          |   7 +-
 kernel/sched/rt.c                             |   5 +
 kernel/time/hrtimer.c                         |   2 +-
 kernel/trace/Kconfig                          |   4 +-
 kernel/trace/fgraph.c                         |  35 +-
 kernel/trace/ftrace.c                         |   7 +-
 kernel/trace/ring_buffer.c                    |   6 +-
 kernel/trace/trace.c                          |   2 +-
 kernel/trace/trace_events.c                   |   8 +-
 kernel/trace/trace_events_hist.c              |   6 +-
 kernel/trace/trace_hwlat.c                    |  15 +-
 kernel/ucount.c                               |   2 +-
 kernel/watchdog.c                             |   2 +-
 kernel/workqueue.c                            |  92 +++-
 lib/Kconfig.debug                             |  27 --
 lib/objpool.c                                 |   2 +-
 mm/highmem.c                                  |   3 +-
 mm/numa_memblks.c                             |   9 +-
 mm/page_alloc.c                               |  14 +
 mm/slub.c                                     |  14 +-
 mm/vmalloc.c                                  |   8 +
 net/9p/trans_xen.c                            |  85 ++--
 net/atm/signaling.c                           |  56 ++-
 net/bluetooth/hci_conn.c                      |   5 +-
 net/bluetooth/hci_sync.c                      |   2 -
 net/bluetooth/l2cap_core.c                    |  95 +++--
 net/bluetooth/l2cap_sock.c                    |  15 +-
 net/bridge/br_multicast.c                     |  45 +-
 net/ceph/crypto.c                             |   8 +-
 net/ceph/crypto.h                             |   2 +-
 net/ceph/messenger_v2.c                       |   2 +-
 net/core/dev.c                                |  25 +-
 net/core/filter.c                             |   2 +-
 net/core/gro.c                                |   2 +-
 net/core/skmsg.c                              |  30 +-
 net/ipv4/fib_lookup.h                         |   6 +-
 net/ipv4/fib_trie.c                           |   4 +-
 net/ipv4/icmp.c                               |  39 +-
 net/ipv4/igmp.c                               |   4 +-
 net/ipv4/ip_options.c                         |   5 +-
 net/ipv4/ping.c                               |  31 +-
 net/ipv4/tcp.c                                |   3 +
 net/ipv4/tcp_bpf.c                            |  25 +-
 net/ipv4/udp_bpf.c                            |  23 +-
 net/ipv6/af_inet6.c                           |   4 +-
 net/ipv6/exthdrs.c                            |  15 +-
 net/ipv6/icmp.c                               |   9 +-
 net/ipv6/ioam6.c                              |  14 +
 net/ipv6/ioam6_iptunnel.c                     |  10 +-
 net/ipv6/ip6_fib.c                            |   2 +-
 net/ipv6/tcp_ipv6.c                           |   3 +-
 net/ipv6/xfrm6_policy.c                       |   7 +-
 net/kcm/kcmsock.c                             |  21 +-
 net/mptcp/protocol.c                          |   8 +-
 net/mptcp/protocol.h                          |   5 +
 net/netfilter/ipvs/ip_vs_xmit.c               |  46 +-
 net/netfilter/nf_conncount.c                  |  54 ++-
 net/netfilter/nf_conntrack_h323_asn1.c        |   2 +-
 net/netfilter/nf_conntrack_h323_main.c        |  10 +-
 net/netfilter/nf_conntrack_proto_generic.c    |   1 +
 net/netfilter/nf_tables_api.c                 |  13 +
 net/netfilter/nfnetlink_queue.c               | 267 ++++++++----
 net/netfilter/nft_compat.c                    |  13 +-
 net/netfilter/nft_connlimit.c                 |   7 +-
 net/netfilter/nft_counter.c                   |   4 +-
 net/netfilter/nft_set_hash.c                  |   9 +-
 net/netfilter/nft_set_rbtree.c                |  43 +-
 net/netfilter/xt_tcpmss.c                     |   2 +-
 net/nfc/hci/llc_shdlc.c                       |   8 +
 net/nfc/nci/ntf.c                             | 159 ++++++-
 net/rds/connection.c                          |   4 +
 net/rds/send.c                                |   6 +-
 net/rds/tcp_listen.c                          |   5 -
 net/sched/act_skbedit.c                       |   6 +-
 net/sunrpc/auth_gss/auth_gss.c                |   3 +
 net/sunrpc/auth_gss/gss_rpc_xdr.c             |  82 +++-
 net/sunrpc/xprtrdma/svc_rdma_transport.c      |   8 +-
 net/tipc/crypto.c                             |   2 +-
 net/tipc/name_table.c                         |   6 +-
 net/tls/tls_sw.c                              |   2 +-
 net/vmw_vsock/vmci_transport.c                |   2 +-
 net/wireless/core.c                           |  12 +-
 net/wireless/scan.c                           |   2 +-
 net/wireless/wext-compat.c                    |   2 +-
 net/xfrm/espintcp.c                           |   2 +-
 net/xfrm/xfrm_device.c                        |  12 +-
 net/xfrm/xfrm_policy.c                        |  11 +-
 rust/Makefile                                 |   3 +
 scripts/mod/modpost.c                         |   4 +
 security/apparmor/apparmorfs.c                |   9 +
 security/apparmor/include/match.h             |  12 +-
 security/apparmor/label.c                     |  33 +-
 security/apparmor/lsm.c                       |   3 +-
 security/apparmor/match.c                     |  22 +-
 security/apparmor/net.c                       |   6 +-
 security/apparmor/policy_unpack.c             |   6 +-
 security/apparmor/resource.c                  |   5 +
 security/integrity/evm/evm_crypto.c           |  14 +-
 security/smack/smackfs.c                      |  79 ++--
 sound/core/oss/mixer_oss.c                    |  16 +
 sound/core/pcm.c                              |   4 +-
 sound/core/pcm_compat.c                       |   9 +-
 sound/core/pcm_native.c                       |  48 ++-
 sound/core/vmaster.c                          |  12 +-
 sound/pci/hda/patch_conexant.c                |   1 +
 sound/pci/hda/patch_realtek.c                 | 205 +++++++++
 sound/soc/amd/yc/acp6x-mach.c                 |   8 +-
 sound/soc/codecs/aw88261.c                    |   3 +-
 sound/soc/codecs/es8328.c                     |  10 +-
 sound/soc/codecs/max98390.c                   |   3 +
 sound/soc/codecs/nau8821.c                    |  85 ++--
 sound/soc/codecs/nau8821.h                    |   3 +-
 sound/soc/codecs/wm8962.c                     |  12 +-
 sound/soc/fsl/fsl_xcvr.c                      |   3 -
 sound/soc/fsl/imx-rpmsg.c                     |   2 +-
 .../intel/common/soc-acpi-intel-arl-match.c   |  23 +-
 sound/soc/rockchip/rockchip_i2s_tdm.c         |  10 +
 sound/soc/sof/intel/hda-dai.c                 |  14 +-
 sound/soc/sof/ipc4-control.c                  |  41 +-
 sound/soc/sof/ipc4-topology.c                 |  35 +-
 sound/soc/sof/ipc4.c                          |  44 +-
 sound/soc/sunxi/sun50i-dmic.c                 |   3 +
 sound/usb/endpoint.c                          |  40 +-
 sound/usb/quirks.c                            |   2 +
 tools/bpf/bpftool/net.c                       |   5 +-
 tools/include/linux/bitfield.h                |   1 +
 tools/lib/bpf/btf_dump.c                      |   9 +
 tools/lib/bpf/netlink.c                       |   4 +-
 tools/lib/perf/Makefile                       |  14 +-
 tools/lib/subcmd/help.c                       |  10 +-
 .../net/sunrpc/xdrgen/generators/__init__.py  |   3 +-
 .../templates/C/program/decoder/argument.j2   |   4 +
 .../templates/C/program/encoder/result.j2     |   6 +
 tools/objtool/Makefile                        |   2 +
 .../arch/x86/amdzen5/load-store.json          |   6 +-
 tools/perf/tests/shell/stat.sh                |   6 +-
 tools/perf/util/disasm.c                      |   2 +-
 tools/perf/util/evsel_fprintf.c               |   8 +-
 tools/perf/util/maps.c                        |   1 +
 tools/perf/util/unwind-libdw.c                |   7 +-
 tools/power/cpupower/lib/cpuidle.c            |   1 +
 .../x86/intel-speed-select/isst-config.c      |   2 +
 tools/spi/.gitignore                          |   1 +
 tools/testing/selftests/bpf/prog_tests/wq.c   |   5 +-
 tools/testing/selftests/bpf/veristat.c        |   2 +-
 .../drivers/net/mlxsw/tc_restrictions.sh      |   4 +-
 tools/testing/selftests/memfd/memfd_test.c    | 113 ++++-
 .../selftests/mm/charge_reserved_hugetlb.sh   |   4 +-
 tools/testing/selftests/mm/pagemap_ioctl.c    | 116 ++---
 tools/testing/selftests/mm/vm_util.c          |   2 +-
 .../net/forwarding/vxlan_bridge_1d.sh         |  26 +-
 .../net/forwarding/vxlan_bridge_1d_ipv6.sh    |   2 +-
 940 files changed, 9754 insertions(+), 4501 deletions(-)
 create mode 100644 Documentation/trace/events-pci.rst
 create mode 100644 arch/alpha/mm/tlbflush.c
 create mode 100644 drivers/iommu/intel/prq.c
 create mode 100644 include/linux/ftrace_regs.h

-- 
2.51.0

