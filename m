Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68279375AD6;
	Sat, 28 Feb 2026 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301605; cv=none; b=krcLFRAqzPoN+TqbZL4BlznY9le+w7xpUNisEZQjrfgdzy1kqGn4drRH+kBkNwM2ZR2DFWz+eMltRVMIvHi0OA/nMJbNnymqdZ8xRM9nNs6whCwEsbP5TQD4jffmn+3BHz+GeanMmEYbTEvE8iUwiGLAvszChakXU4qu6CKDvUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301605; c=relaxed/simple;
	bh=A2Y0/H9L4DtUQu4WZ/VDsasDvzM+wadvaIOT+9Z7kH8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PW3m5CLEyqvtdS7kx4m09MItZXBZ9iNOlAqwHI/B/JGRGFaOZjN0MxDl1QjeXwZmPFGAMMqaD+qEQyWzifLANBzOaIY1NqYAJ9fcFISaJB7zMS3kjZqFdLxPzFenf27xj/LVycgCIed22pDpXWHMGPm99Dm415gtODFIDWta8H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JtIEm0lT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JtIEm0lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2054DC2BC87;
	Sat, 28 Feb 2026 18:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301605;
	bh=A2Y0/H9L4DtUQu4WZ/VDsasDvzM+wadvaIOT+9Z7kH8=;
	h=From:To:Cc:Subject:Date:From;
	b=JtIEm0lTEgHWC4dcjDw09Rir1WEcltdk60xtVXIK+69UjmcbFNtHWlRqqoZcN7WCr
	 R/6k1hvyFA6+hoJD8cR4k3txigY2xzMSYkRXaL5fKshPWLgnTRem9LKp0x0Hy2fyXt
	 x1Ib0oFANt7a8rCTuNeAGUZrS9IeOr+PtZKcpwlaurUvlgkqtrbVvUexbXj9A0uinQ
	 di9ZgDELFupu7ROVsEstE1Op0+in8AEz62kFf44d8Vo6jiKTFeWmX0Pu8UV6lEj3TZ
	 4XPeJZQnZ8BGWWsL6XVX84OpGHFSHStkCH6CaDcV9eK2/TCjvD8DEhpiTRtMqHfEms
	 3DSI/yDNfw0ww==
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
Subject: [PATCH 6.12 000/385] 6.12.75-rc1 review
Date: Sat, 28 Feb 2026 13:00:01 -0500
Message-ID: <20260228180001.1567994-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.75-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.75-rc1
X-KernelTest-Deadline: 2026-03-02T17:59+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit


This is the start of the stable review cycle for the 6.12.75 release.
There are 385 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Mar  2 05:59:55 PM UTC 2026.
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

Abel Vesa (1):
  arm64: dts: qcom: x1e80100: Fix USB combo PHYs SS1 and SS2 ref clocks

Abhash Kumar Jha (2):
  arm64: dts: ti: k3-j784s4-main.dtsi: Move c71_3 node to appropriate
    order
  arm64: dts: ti: k3-j784s4-j742s2-main-common.dtsi: Refactor watchdog
    instances for j784s4

Abhishek Bapat (1):
  quota: fix livelock between quotactl and freeze_super

Aboorva Devarajan (1):
  cpuidle: Skip governor when only one idle state is available

Adrian Hunter (1):
  i3c: master: Update hot-join flag only on success

Aleks Todorov (1):
  OPP: Return correct value in dev_pm_opp_get_level

Aleksei Oladko (2):
  selftests: forwarding: vxlan_bridge_1d: fix test failure with
    br_netfilter enabled
  selftests: forwarding: vxlan_bridge_1d_ipv6: fix test failure with
    br_netfilter enabled

Alex Elder (1):
  mfd: simple-mfd-i2c: Add SpacemiT P1 support

Alexander Koskovich (1):
  power: reset: nvmem-reboot-mode: respect cell size for
    nvmem_cell_write

Alexander Stein (2):
  arm64: dts: tqma8mpql-mba8mpxl: Fix HDMI CEC pad control settings
  arm64: dts: tqma8mpql-mba8mp-ras314: Fix HDMI CEC pad control settings

Alexey Simakov (1):
  ACPICA: Fix NULL pointer dereference in
    acpi_ev_address_space_dispatch()

Allison Henderson (1):
  net/rds: rds_sendmsg should not discard payload_len

Alok Tiwari (1):
  mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper

Alper Ak (2):
  tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
  tpm: st33zp24: Fix missing cleanup on get_burstcount() error

Anders Grahn (1):
  netfilter: nft_counter: fix reset of counters on 32bit archs

Andreas Gruenbacher (2):
  gfs2: Retries missing in gfs2_{rename,exchange}
  gfs2: Fix slab-use-after-free in qd_put

André Draszik (1):
  regulator: core: move supply check earlier in
    set_machine_constraints()

Andy Shevchenko (1):
  platform/chrome: cros_typec_switch: Don't touch struct
    fwnode_handle::dev

AngeloGioacchino Del Regno (2):
  arm64: dts: mediatek: mt8183-jacuzzi-pico6: Fix typo in pinmux node
  dmaengine: mediatek: uart-apdma: Fix above 4G addressing TX/RX

Anshumali Gaur (1):
  octeontx2-af: Fix PF driver crash with kexec kernel booting

Anthony Iliopoulos (1):
  nfsd: never defer requests during idmap lookup

Anthony Pighin (Nokia) (1):
  vfio/pci: Lock upstream bridge for vfio_pci_core_disable()

Antonio Borneo (1):
  coresight: etm3x: Fix cpulocked warning on cpuhp

Aristeu Rozanski (1):
  selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT

Arnd Bergmann (2):
  scsi: ufs: host: mediatek: Require CONFIG_PM
  soundwire: intel_ace2x: add SND_HDA_CORE dependency

Ashish Kalra (1):
  crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls

Barnabás Czémán (4):
  clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
  clk: qcom: gcc-msm8917: Remove ALWAYS_ON flag from cpp_gdsc
  backlight: qcom-wled: Support ovp values for PMI8994
  backlight: qcom-wled: Change PM8950 WLED configurations

Bartlomiej Kubik (1):
  fs/ntfs3: Initialize new folios before use

Baruch Siach (1):
  Documentation: PCI: endpoint: Fix ntb/vntb copy & paste errors

Ben Dooks (2):
  audit: move the compat_xxx_class[] extern declarations to audit_arch.h
  fs: add <linux/init_task.h> for 'init_fs'

Billy Tsai (1):
  i3c: Move device name assignment after i3c_bus_init

Boris Brezillon (6):
  drm/panthor: Recover from panthor_gpu_flush_caches() failures
  drm/panthor: Fix the full_tick check
  drm/panthor: Fix the group priority rotation logic
  drm/panthor: Fix immediate ticking on a disabled tick
  drm/panthor: Fix the logic that decides when to stop ticking
  drm/panthor: Make sure we resume the tick when new jobs are submitted

Boris Burkov (1):
  btrfs: fix block_group_tree dirty_list corruption

Brian Norris (1):
  PCI/PM: Avoid redundant delays on D3hot->D3cold

Caleb Sander Mateos (1):
  io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED

Carl Lee (1):
  hwmon: (pmbus/mpq8785) fix VOUT_MODE mismatch during identification

Casey Connolly (3):
  arm64: dts: qcom: sdm845-oneplus: Don't mark ts supply boot-on
  arm64: dts: qcom: sdm845-oneplus: Don't keep panel regulator always on
  arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on

Chaitanya Mishra (1):
  staging: greybus: lights: avoid NULL deref

Chen Jinghuang (1):
  sched/rt: Skip currently executing CPU in rto_next_cpu()

Chen-Yu Tsai (1):
  ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property

Chengchang Tang (2):
  RDMA/hns: Fix WQ_MEM_RECLAIM warning
  RDMA/hns: Notify ULP of remaining soft-WCs during reset

Chenghai Huang (1):
  crypto: hisilicon/zip - adjust the way to obtain the req in the
    callback function

Chenyuan Yang (1):
  ALSA: pcm: use new array-copying-wrapper

Chiara Meiohas (1):
  RDMA/mlx5: Fix UMR hang in LAG error state unload

Christoph Böhmwalder (1):
  drbd: always set BLK_FEAT_STABLE_WRITES

Christoph Hellwig (3):
  block: add a bio_add_virt_nofail helper
  rnbd-srv: use bio_add_virt_nofail
  iomap: fix submission side handling of completion side errors

Christophe Leroy (1):
  powerpc/uaccess: Move barrier_nospec() out of
    allow_read_{from/write}_user()

Chuck Lever (4):
  xdrgen: Fix struct prefix for typedef types in program wrappers
  NFS: NFSERR_INVAL is not defined by NFSv2
  xdrgen: Initialize data pointer for zero-length items
  RDMA/core: add rdma_rw_max_sge() helper for SQ sizing

Colin Ian King (1):
  scsi: csiostor: Fix dereference of null pointer rn

Cristian Ciocaltea (3):
  ASoC: nau8821: Consistently clear interrupts before unmasking
  ASoC: nau8821: Avoid unnecessary blocking in IRQ handler
  ASoC: nau8821: Fixup nau8821_enable_jack_detect()

Dan Carpenter (2):
  EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
  EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()

Daniel Machon (2):
  net: sparx5/lan969x: fix DWRR cost max to match hardware register
    width
  net: sparx5/lan969x: fix PTP clock max_adj value

David Heidelberg (3):
  drm/panel: sw43408: Remove manual invocation of unprepare at remove
  media: ccs: Accommodate C-PHY into the calculation
  clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk1_clk_src

Deepanshu Kartikey (1):
  gfs2: Fix use-after-free in iomap inline data write path

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

Dmytro Maluka (1):
  iommu/vt-d: Flush cache for PASID table before using it

Dzmitry Sankouski (1):
  mfd: simple-mfd-i2c: Add MAX77705 support

Edward Adam Davis (1):
  fs/ntfs3: prevent infinite loops caused by the next valid being the
    same

Eric Dumazet (4):
  tcp: tcp_tx_timestamp() must look at the rtx queue
  inet: RAW sockets using IPPROTO_RAW MUST drop incoming ICMP
  ipv6: fix a race in ip6_sock_set_v6only()
  ping: annotate data-races in ping_lookup()

Eric Joyner (1):
  ionic: Rate limit unknown xcvr type messages

Etienne AUJAMES (1):
  IB/cache: update gid cache on client reregister event

Felix Gu (5):
  cpufreq: scmi: Fix device_node reference leak in scmi_cpu_domain_id()
  thermal/of: Fix reference leak in thermal_of_cm_lookup()
  fbdev: of_display_timing: Fix device node reference leak in
    of_get_display_timings()
  fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
  pinctrl: equilibrium: Fix device node reference leak in pinbank_init()

Fernando Fernandez Mancera (3):
  netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
  netfilter: nf_conncount: increase the connection clean up limit to 64
  netfilter: nf_conncount: fix tracking of connections from localhost

Filipe Manana (1):
  btrfs: qgroup: return correct error when deleting qgroup relation item

Florian Westphal (5):
  netfilter: nf_tables: reset table validation state on abort
  netfilter: nft_compat: add more restrictions on netlink attributes
  netfilter: nfnetlink_queue: do shared-unconfirmed check before
    segmentation
  netfilter: nft_set_hash: fix get operation on big endian
  netfilter: nf_conntrack_h323: don't pass uninitialised l3num value

Florian-Ewald Mueller (1):
  rnbd-srv: Fix server side setting of bi_size for special IOs

Francesco Lavra (1):
  spi: tools: Add include folder to .gitignore

Fredrik Markstrom (1):
  i3c: dw: Initialize spinlock to avoid upsetting lockdep

Gao Xiang (2):
  erofs: get rid of raw bi_end_io() usage
  erofs: handle end of filesystem properly for file-backed mounts

Geert Uytterhoeven (1):
  clk: Move clk_{save,restore}_context() to COMMON_CLK section

George Moussalem (1):
  clk: qcom: gcc-ipq5018: flag sleep clock as critical

Giovanni Cabiddu (1):
  crypto: qat - fix warning on adf_pfvf_pf_proto.c

Govindarajulu Varadarajan (1):
  ublk: Validate SQE128 flag before accessing the cmd

Greg Kroah-Hartman (1):
  Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"

Guenter Roeck (1):
  Revert "hwmon: (ibmpex) fix use-after-free in high/low store"

Gui-Dong Han (1):
  PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races

Haotian Zhang (9):
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

Hariprasad Kelam (1):
  octeontx2-pf: Unregister devlink on probe failure

Harshit Mogalapalli (1):
  iio: sca3000: Fix a resource leak in sca3000_probe()

Honggang LI (1):
  RDMA/rtrs: server: remove dead code

Hou Tao (1):
  PCI/P2PDMA: Release per-CPU pgmap ref when vm_insert_page() fails

Huang Chenming (1):
  wifi: cfg80211: Fix use_for flag update on BSS refresh

Håkon Bugge (3):
  PCI: Do not attempt to set ExtTag for VFs
  PCI: Initialize RCB from pci_configure_device()
  PCI/ACPI: Restrict program_hpx_type2() to AER bits

Ido Schimmel (1):
  selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2

Ilpo Järvinen (1):
  PCI: Add defines for bridge window indexing

Inseo An (1):
  netfilter: nf_tables: fix use-after-free in nf_tables_addchain()

Ioana Ciornei (2):
  mfd: simple-mfd-i2c: Add compatible strings for Layerscape QIXIS FPGA
  mfd: simple-mfd-i2c: Keep compatible strings in alphabetical order

Jacob Moroni (1):
  RDMA/iwcm: Fix workqueue list corruption by removing work_list

Jagadeesh Kona (5):
  clk: qcom: gcc-sm8450: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-sm4450: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-sdx75: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-x1e80100: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-qdu1000: Update the SDCC RCGs to use shared_floor_ops

Jakub Kicinski (1):
  bpftool: Fix truncated netlink dumps

Jared Kangas (1):
  dmaengine: fsl-edma: don't explicitly disable clocks in .remove()

Jens Axboe (2):
  io_uring/sync: validate passed in offset
  io_uring/cancel: de-unionize file and user_data in struct
    io_cancel_data

Jerome Brunet (7):
  arm64: dts: amlogic: s4: assign mmc b clock to 24MHz
  arm64: dts: amlogic: s4: fix mmc clock assignment
  arm64: dts: amlogic: c3: assign the MMC signal clocks
  arm64: dts: amlogic: axg: assign the MMC signal clocks
  arm64: dts: amlogic: gx: assign the MMC signal clocks
  arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
  arm64: dts: amlogic: g12: assign the MMC A signal clock

Jian Shen (1):
  net: hns3: fix double free issue for tx spare buffer

Jian Zhang (1):
  net: mctp-i2c: fix duplicate reception of old data

Jianpeng Chang (1):
  crypto: caam - fix netdev memory leak in dpaa2_caam_probe

Jiasheng Jiang (2):
  RDMA/rxe: Fix double free in rxe_srq_from_init
  fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot

Jiayuan Chen (5):
  bpf, sockmap: Fix incorrect copied_seq calculation
  bpf, sockmap: Fix FIONREAD for sockmap
  net: atm: fix crash due to unvalidated vcc pointer in sigd_send()
  xfrm: fix ip_rt_bug race in icmp_route_lookup reverse path
  serial: caif: fix use-after-free in caif_serial ldisc_close()

Jinliang Zheng (1):
  procfs: fix missing RCU protection when reading real_parent in
    do_task_stat()

Jiri Olsa (2):
  x86/fgraph,bpf: Fix stack ORC unwind from kprobe_multi return probe
  x86/fgraph,bpf: Switch kprobe_multi program stack unwind to hw_regs
    path

Joel Fernandes (2):
  rcu: Refactor expedited handling check in rcu_read_unlock_special()
  sched/deadline: Clear the defer params

Joel Granados (1):
  iommu/vt-d: Separate page request queue from SVM

Jonathan Marek (1):
  arm64: dts: qcom: x1e: bus is 40-bits (fix 64GB models)

Jonathan McDowell (1):
  hwrng: core - Allow runtime disabling of the HW RNG

Jorge Ramirez-Ortiz (1):
  soc: qcom: smem: handle ENOMEM error during probe

Josh Poimboeuf (1):
  kbuild: Add objtool to top-level clean target

Julian Anastasov (1):
  ipvs: do not keep dest_dst if dev is going down

Junxian Huang (1):
  RDMA/hns: Fix RoCEv1 failure due to DSCP

Justin Chen (1):
  usb: bdc: fix sleep during atomic

Jörg Wedekind (1):
  PCI: Mark 3ware-9650SA Root Port Extended Tags as broken

Kery Qi (2):
  selftests/bpf: Fix resource leak in serial_test_wq on attach failure
  watchdog: starfive-wdt: Fix PM reference leak in probe error path

Ketil Johnsen (1):
  drm/panthor: Evict groups before VM termination

Konrad Dybcio (2):
  arm64: dts: qcom: agatti: Add CX_MEM/DBGC GPU regions
  arm64: dts: qcom: sm6115: Add CX_MEM/DBGC GPU regions

Konstantin Andreev (2):
  smack: /smack/doi must be > 0
  smack: /smack/doi: accept previously used values

Kuniyuki Iwashima (1):
  ipv6: Fix out-of-bound access in fib6_add_rt2node().

Kuppuswamy Sathyanarayanan (1):
  powercap: intel_rapl_tpmi: Remove FW_BUG from invalid version check

Lai Jiangshan (3):
  workqueue: Factor out assign_rescuer_work()
  workqueue: Only assign rescuer work when really needed
  workqueue: Process rescuer work items one-by-one using a cursor

Leo Yan (1):
  perf: arm_spe: Properly set hw.state on failures

Li Chen (1):
  nvdimm: virtio_pmem: serialize flush requests

Li Nan (1):
  md/raid10: fix any_working flag handling in raid10_sync_request

Li Zhijian (1):
  RDMA/rxe: Fix race condition in QP timer handlers

Lianjie Wang (1):
  hwrng: core - use RCU and work_struct to fix race condition

Lu Baolu (3):
  iommu/vt-d: Drain PRQs when domain removed from RID
  iommu/vt-d: Avoid draining PRQ in sva mm release path
  iommu/vt-d: Clear Present bit before tearing down PASID entry

Luca Weiss (1):
  pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition

Mahadevan P (1):
  drm/msm/disp/dpu: add merge3d support for sc7280

Malaya Kumar Rout (1):
  tools/power/x86/intel-speed-select: Fix file descriptor leak in
    isolate_cpus()

Mario Limonciello (AMD) (5):
  drm/amd: Drop "amdgpu kernel modesetting enabled" message
  crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
  crypto: ccp - Add an S4 restore flow
  crypto: ccp - Factor out ring destroy handling to a helper
  crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
    fails

Martin Blumenstingl (1):
  clk: meson: gxbb: Limit the HDMI PLL OD to /4 on GXL/GXM SoCs

Masami Hiramatsu (Google) (6):
  tracing: Add a comment about ftrace_regs definition
  ftrace: Use arch_ftrace_regs() for ftrace_regs_*() macros
  ftrace: Rename ftrace_regs_return_value to
    ftrace_regs_get_return_value
  fgraph: Replace fgraph_ret_regs with ftrace_regs
  tracing: Add ftrace_partial_regs() for converting ftrace_regs to
    pt_regs
  tracing: Add ftrace_fill_perf_regs() for perf event

Matt Johnston (1):
  mctp i2c: initialise event handler read bytes

Matthew Schwartz (1):
  mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms

Miaoqian Lin (1):
  tracing: Properly process error handling in event_hist_trigger_parse()

Michał Grzelak (1):
  drm/buddy: release free_trees array on buddy mm teardown

Mike Snitzer (2):
  nfs/localio: eliminate unnecessary kref in nfs_local_fsync_ctx
  NFS/localio: use GFP_NOIO and non-memreclaim workqueue in
    nfs_local_commit

Mikulas Patocka (3):
  dm: fix unlocked test for dm_suspended_md
  dm: use READ_ONCE in dm_blk_report_zones
  dm: use bio_clone_blkg_association

Miquel Raynal (1):
  mtd: spinand: Fix kernel doc

Miri Korenblit (1):
  wifi: cfg80211: stop NAN and P2P in cfg80211_leave

Muhammad Usama Anjum (1):
  selftests/mm: pagemap_ioctl: Fix types mismatches shown by compiler
    options

Narayana Murty N (1):
  powerpc/eeh: fix recursive pci_lock_rescan_remove locking in EEH event
    handling

Nicolas Cavallari (1):
  PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]

Nicolas Frattaroli (2):
  interconnect: mediatek: Don't hijack parent device
  interconnect: mediatek: Aggregate bandwidth with saturating add

Nikolay Aleksandrov (1):
  net: bridge: mcast: always update mdb_n_entries for vlan contexts

Nuno Sá (2):
  dma: dma-axi-dmac: fix SW cyclic transfers
  dma: dma-axi-dmac: fix HW scatter-gather not looking at the queue

Olga Kornievskaia (1):
  pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN

Ondrej Mosnacek (2):
  ipc: don't audit capability check in ipc_permissions()
  ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()

Or Har-Toov (1):
  IB/mlx5: Fix port speed query for representors

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

Pawel Dembicki (3):
  hwmon: pmbus: mpq8785: Prepare driver for multiple device support
  hwmon: pmbus: mpq8785: Implement VOUT feedback resistor divider ratio
    configuration
  hwmon: pmbus: mpq8785: Add support for MPM82504

Petr Hodina (1):
  clk: qcom: dispcc-sdm845: Enable parents for pixel clocks

Petr Mladek (2):
  module: add helper function for reading module_buildid()
  kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()

Petre Rodan (5):
  iio: pressure: mprls0025pa: fix spi_transfer struct initialisation
  iio: pressure: mprls0025pa: fix SPI CS delay violation
  iio: pressure: mprls0025pa: fix interrupt flag
  iio: pressure: mprls0025pa: fix scan_type struct
  iio: pressure: mprls0025pa: fix pressure calculation

Puranjay Mohan (2):
  selftests/bpf: veristat: fix printing order in output_stats()
  bpf: Preserve id of register in sync_linked_regs()

Purva Yeshi (1):
  Documentation: trace: Refactor toctree

Qi Tao (1):
  crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
    queue unavailable

Qing Wang (1):
  ovl: Fix uninit-value in ovl_fill_real

Rafael J. Wysocki (2):
  cpuidle: governors: menu: Always check timers with tick stopped
  thermal: intel: x86_pkg_temp_thermal: Handle invalid temperature

Randy Dunlap (3):
  iio: test: drop dangling symbol in gain-time-scale helpers
  serial: imx: change SERIAL_IMX_CONSOLE to bool
  serial: SH_SCI: improve "DMA support" prompt

René Rebe (1):
  net: sunhme: Fix sbus regression

Ricardo Ribalda (1):
  media: uvcvideo: Fix allocation for small frame sizes

Robert Marko (1):
  mfd: simple-mfd-i2c: Add Delta TN48M CPLD support

Roberto Sassu (1):
  evm: Use ordered xattrs list to calculate HMAC in evm_init_hmac()

Roger Pau Monne (1):
  Partial revert "x86/xen: fix balloon target initialization for PVH
    dom0"

Roman Penyaev (1):
  RDMA/rtrs-srv: fix SG mapping

Ryan Lin (1):
  HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients

Sagi Grimberg (1):
  fs/nfs: Fix readdir slow-start regression

Sai Ritvik Tanksalkar (1):
  pstore/ram: fix buffer overflow in persistent_ram_save_old()

Salah Triki (1):
  s390/cio: Fix device lifecycle handling in css_alloc_subchannel()

Samuel Wu (1):
  PM: wakeup: Handle empty list in wakeup_sources_walk_start()

Sandipan Das (1):
  perf/x86/core: Do not set bit width for unavailable counters

Sasha Levin (1):
  Linux 6.12.75-rc1

Scott Mitchell (1):
  netfilter: nfnetlink_queue: optimize verdict lookup with hash table

Sean V Kelley (1):
  ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs

Sebastian Andrzej Siewior (7):
  genirq: Set IRQF_COND_ONESHOT in devm_request_irq().
  platform/x86: int0002: Remove IRQF_ONESHOT from request_irq()
  Bluetooth: btintel_pcie: Use IRQF_ONESHOT and default primary handler
  scsi: efct: Use IRQF_ONESHOT and default primary handler
  EDAC/altera: Remove IRQF_ONESHOT
  mfd: wm8350-core: Use IRQF_ONESHOT
  media: pci: mg4b: Use IRQF_NO_THREAD

Sergey Shtylyov (1):
  PCI: Check parent for NULL in of_pci_bus_release_domain_nr()

Shardul Bankar (1):
  hfsplus: return error when node already exists in hfs_bnode_create

Shuai Xue (1):
  Documentation: tracing: Add PCI tracepoint documentation

Shuicheng Lin (1):
  drm/xe: Unregister drm device on probe error

Shyam Sundar S K (1):
  platform/x86/amd/pmf: Prevent TEE errors after hibernate

Siddarth G (1):
  selftests/mm: convert page_size to unsigned long

Srinivasan Shanmugam (2):
  drm/amdkfd: Fix signal_eviction_fence() bool return value
  drm/amdgpu: Use explicit VCN instance 0 in SR-IOV init

Stanislav Fomichev (2):
  net: Add skb_dstref_steal and skb_dstref_restore
  net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input
    callers

Stefan Metzmacher (1):
  smb: client: correct value for smbd_max_fragmented_recv_size

Steven Rostedt (3):
  ftrace: Make ftrace_regs abstract from direct use
  ftrace: Consolidate ftrace_regs accessor functions for archs using
    pt_regs
  tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR
    macros

Sudeep Holla (1):
  firmware: arm_ffa: Correct 32-bit response handling in
    NOTIFICATION_INFO_GET

SurajSonawane2415 (1):
  docs: fix WARNING document not included in any toctree

Svyatoslav Ryhel (1):
  drivers: iio: mpu3050: use dev_err_probe for regulator request

Takashi Iwai (2):
  ALSA: pcm: Relax __free() variable declarations
  ALSA: vmaster: Relax __free() variable declarations

Taniya Das (1):
  clk: qcom: rcg2: compute 2d using duty fraction directly

Teddy Astie (1):
  xen/virtio: Don't use grant-dma-ops when running as Dom0

Teguh Sobirin (1):
  drm/msm/dpu: Set vsync source irrespective of mdp top support

Thomas Bogendoerfer (1):
  bonding: only set speed/duplex to unknown, if getting speed failed

Thomas Fourier (3):
  auxdisplay: arm-charlcd: fix release_mem_region() size
  crypto: cavium - fix dma_free_coherent() size
  crypto: octeontx - fix dma_free_coherent() size

Thomas Gleixner (1):
  hrtimer: Fix trace oddity

Thomas Richard (1):
  phy: freescale: imx8qm-hsio: fix NULL pointer dereference

Thomas Weißschuh (1):
  ARM: VDSO: Patch out __vdso_clock_getres() if unavailable

Titouan Ameline de Cadeville (1):
  fs/tests: exec: drop duplicate bprm_stack_limits test vectors

Tuo Li (1):
  of: unittest: fix possible null-pointer dereferences in
    of_unittest_property_copy()

Tycho Andersen (AMD) (1):
  crypto: ccp - narrow scope of snp_range_list

Tzung-Bi Shih (1):
  platform/chrome: cros_ec_lightbar: Fix response size initialization

Uwe Kleine-König (1):
  PCI/portdrv: Fix potential resource leak

Val Packett (1):
  power: supply: qcom_battmgr: Recognize "LiP" as lithium-polymer

Varun R Mallya (1):
  libbpf: Fix OOB read in btf_dump_get_bitfield_value

Vimlesh Kumar (3):
  octeon_ep: disable per ring interrupts
  octeon_ep: ensure dbell BADDR updation
  octeon_ep_vf: ensure dbell BADDR updation

Vladimir Zapolskiy (5):
  arm64: dts: qcom: msm8994-octagon: Fix Analog Devices vendor prefix of
    AD7147
  ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
  arm: dts: lpc32xx: add clocks property to Motor Control PWM device
    tree node
  clk: qcom: gcc-sm8550: Use floor ops for SDCC RCGs
  clk: qcom: gcc-sm8650: Use floor ops for SDCC RCGs

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

Wei Li (1):
  pinctrl: single: fix refcount leak in pcs_add_gpio_func()

Weigang He (1):
  mtd: parsers: ofpart: fix OF node refcount leak in
    parse_fixed_partitions()

Weili Qian (1):
  crypto: hisilicon/trng - support tfms sharing the device

Yao Kai (1):
  rcu: Fix rcu_read_unlock() deadloop due to softirq

Yaxiong Tian (1):
  cpufreq: intel_pstate: Enable asym capacity only when CPU SMT is not
    possible

Yi Liu (2):
  RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
  RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc

Yu Kuai (1):
  md/raid5: fix raid5_run() to return error when log_init() fails

YunJe Shin (2):
  RDMA/siw: Fix potential NULL pointer dereference in header processing
  RDMA/umad: Reject negative data_len in ib_umad_write

Yuxiong Wang (1):
  cxl: Fix premature commit_end increment on decoder commit failure

Zhai Can (1):
  ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO

Zheng Qixing (1):
  md/raid1: fix memory leak in raid1_run() if no active rdev

Zhiyu Zhang (1):
  fat: avoid parent link count underflow in rmdir

Zilin Guan (8):
  i3c: dw: Fix memory leak in dw_i3c_master_i2c_xfers()
  md/raid1: fix memory leak in raid1_run()
  crypto: starfive - Fix memory leak in starfive_aes_aead_do_one_req()
  soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()
  media: chips-media: wave5: Fix memory leak on codec_info allocation
    failure
  mtd: parsers: Fix memory leak in mtd_parser_tplink_safeloader_parse()
  RDMA/mlx5: Fix memory leak in GET_DATA_DIRECT_SYSFS_PATH handler
  scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()

Ziyi Guo (6):
  wifi: ath10k: sdio: add missing lock protection in
    ath10k_sdio_fw_crashed_dump()
  net: mscc: ocelot: extract ocelot_xmit_timestamp() helper
  net: mscc: ocelot: split xmit into FDMA and register injection paths
  net: mscc: ocelot: add missing lock protection in
    ocelot_port_xmit_inj()
  net: usb: catc: enable basic endpoint checking
  xen-netback: reject zero-queue configuration from guest

Zqiang (1):
  rcu: Remove local_irq_save/restore() in
    rcu_preempt_deferred_qs_handler()

zhouwenhao (1):
  objpool: fix the overestimation of object pooling metadata size

 Documentation/PCI/endpoint/pci-vntb-howto.rst |  14 +-
 Documentation/hwmon/mpq8785.rst               |  20 +-
 Documentation/trace/events-pci.rst            |  74 ++++
 Documentation/trace/index.rst                 |  96 ++++-
 Makefile                                      |  15 +-
 .../boot/dts/allwinner/sun5i-a13-utoo-p66.dts |   1 +
 arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi        |   3 +-
 arch/arm/kernel/vdso.c                        |   1 +
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi   |   7 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   6 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi   |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   9 +
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi     |  13 +-
 .../imx8mp-tqma8mpql-mba8mp-ras314.dts        |   2 +-
 .../freescale/imx8mp-tqma8mpql-mba8mpxl.dts   |   2 +-
 .../mediatek/mt8183-kukui-jacuzzi-pico6.dts   |   2 +-
 .../dts/qcom/msm8994-msft-lumia-octagon.dtsi  |   2 +-
 arch/arm64/boot/dts/qcom/qcm2290.dtsi         |   8 +-
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts      |   2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |   4 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts    |   8 +-
 .../boot/dts/qcom/sdm845-oneplus-common.dtsi  |   3 +-
 arch/arm64/boot/dts/qcom/sm6115.dtsi          |   8 +-
 arch/arm64/boot/dts/qcom/x1e80100.dtsi        |   8 +-
 .../dts/ti/k3-j784s4-j742s2-main-common.dtsi  |  36 --
 arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi    |  58 ++-
 arch/arm64/include/asm/ftrace.h               |  64 +--
 arch/arm64/kernel/asm-offsets.c               |  34 +-
 arch/arm64/kernel/entry-ftrace.S              |  32 +-
 arch/arm64/kernel/ftrace.c                    |  10 +-
 arch/loongarch/Kconfig                        |   2 +-
 arch/loongarch/include/asm/ftrace.h           |  53 +--
 arch/loongarch/kernel/asm-offsets.c           |  12 -
 arch/loongarch/kernel/ftrace_dyn.c            |   2 +-
 arch/loongarch/kernel/mcount.S                |  17 +-
 arch/loongarch/kernel/mcount_dyn.S            |  14 +-
 arch/powerpc/include/asm/eeh.h                |   2 +
 arch/powerpc/include/asm/ftrace.h             |  34 +-
 arch/powerpc/include/asm/kup.h                |   2 -
 arch/powerpc/include/asm/uaccess.h            |   4 +
 arch/powerpc/kernel/eeh_driver.c              |  11 +-
 arch/powerpc/kernel/eeh_pe.c                  |  74 +++-
 arch/powerpc/kernel/trace/ftrace.c            |   4 +-
 arch/powerpc/kernel/trace/ftrace_64_pg.c      |   2 +-
 arch/riscv/Kconfig                            |   2 +-
 arch/riscv/include/asm/ftrace.h               |  62 +--
 arch/riscv/kernel/asm-offsets.c               |  28 +-
 arch/riscv/kernel/ftrace.c                    |   2 +-
 arch/riscv/kernel/mcount.S                    |  24 +-
 arch/s390/Kconfig                             |   2 +-
 arch/s390/include/asm/ftrace.h                |  55 +--
 arch/s390/kernel/asm-offsets.c                |  10 +-
 arch/s390/kernel/ftrace.c                     |   2 +-
 arch/s390/kernel/mcount.S                     |  12 +-
 arch/s390/lib/test_unwind.c                   |   4 +-
 arch/x86/Kconfig                              |   2 +-
 arch/x86/events/core.c                        |   4 +-
 arch/x86/include/asm/ftrace.h                 |  62 +--
 arch/x86/kernel/ftrace.c                      |   2 +-
 arch/x86/kernel/ftrace_32.S                   |  13 +-
 arch/x86/kernel/ftrace_64.S                   |  23 +-
 arch/x86/xen/enlighten.c                      |   2 +-
 block/bio.c                                   |  16 +
 drivers/acpi/acpica/evregion.c                |   4 +-
 drivers/acpi/cppc_acpi.c                      |   4 +-
 drivers/acpi/power.c                          |  13 +
 drivers/auxdisplay/arm-charlcd.c              |   2 +-
 drivers/base/power/wakeirq.c                  |   9 +-
 drivers/base/power/wakeup.c                   |   4 +-
 drivers/block/drbd/drbd_main.c                |   3 -
 drivers/block/drbd/drbd_nl.c                  |  20 +-
 drivers/block/rnbd/rnbd-srv.c                 |  34 +-
 drivers/block/ublk_drv.c                      |   6 +-
 drivers/bluetooth/btintel_pcie.c              |   9 +-
 drivers/char/hw_random/core.c                 | 173 +++++---
 drivers/char/tpm/st33zp24/st33zp24.c          |   6 +-
 drivers/char/tpm/tpm_i2c_infineon.c           |   6 +-
 drivers/clk/mediatek/clk-mtk.c                |  12 +-
 drivers/clk/meson/gxbb.c                      |  17 +-
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
 drivers/edac/altera_edac.c                    |  11 +-
 drivers/edac/i5000_edac.c                     |   1 +
 drivers/edac/i5400_edac.c                     |   2 +-
 drivers/firmware/arm_ffa/driver.c             |  33 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c       |   1 -
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c         |  45 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c      |   2 +-
 drivers/gpu/drm/drm_buddy.c                   |   1 +
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c         |   5 +-
 .../msm/disp/dpu1/catalog/dpu_7_2_sc7280.h    |  14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c   |  18 +-
 .../drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c  |   7 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c   |  49 ++-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.h   |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_top.c    |   7 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h   |   7 +
 drivers/gpu/drm/msm/disp/mdp_format.c         |   8 +-
 drivers/gpu/drm/panel/panel-lg-sw43408.c      |   4 -
 drivers/gpu/drm/panthor/panthor_gpu.c         |  19 +-
 drivers/gpu/drm/panthor/panthor_mmu.c         |   4 +
 drivers/gpu/drm/panthor/panthor_sched.c       | 167 +++++---
 drivers/gpu/drm/panthor/panthor_sched.h       |   1 +
 drivers/gpu/drm/xe/xe_device.c                |   1 +
 drivers/hid/hid-playstation.c                 |   4 +-
 drivers/hid/intel-ish-hid/ishtp/bus.c         |   2 +-
 drivers/hwmon/ibmpex.c                        |   9 +-
 drivers/hwmon/pmbus/mpq8785.c                 | 111 ++++-
 drivers/hwspinlock/omap_hwspinlock.c          |   4 +-
 .../coresight/coresight-etm3x-core.c          |  12 +-
 drivers/i3c/master.c                          |   6 +-
 drivers/i3c/master/dw-i3c-master.c            |   3 +
 drivers/iio/accel/sca3000.c                   |   6 +-
 drivers/iio/gyro/mpu3050-core.c               |   6 +-
 drivers/iio/pressure/mprls0025pa.c            |  36 +-
 drivers/iio/pressure/mprls0025pa.h            |   2 -
 drivers/iio/pressure/mprls0025pa_spi.c        |  19 +-
 drivers/iio/test/Kconfig                      |   1 -
 drivers/infiniband/core/cache.c               |   3 +-
 drivers/infiniband/core/iwcm.c                |  56 +--
 drivers/infiniband/core/iwcm.h                |   1 -
 drivers/infiniband/core/rw.c                  |  53 ++-
 drivers/infiniband/core/user_mad.c            |   8 +-
 drivers/infiniband/core/uverbs_cmd.c          |   7 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c       |  23 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  54 ++-
 drivers/infiniband/hw/mlx5/main.c             |  95 ++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   2 +
 drivers/infiniband/hw/mlx5/std_types.c        |   4 +-
 drivers/infiniband/sw/rxe/rxe_comp.c          |   3 +
 drivers/infiniband/sw/rxe/rxe_req.c           |   3 +
 drivers/infiniband/sw/rxe/rxe_srq.c           |   6 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c         |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c        |  33 +-
 drivers/interconnect/mediatek/icc-emi.c       |   9 +-
 drivers/iommu/intel/Makefile                  |   2 +-
 drivers/iommu/intel/iommu.c                   |  19 +-
 drivers/iommu/intel/iommu.h                   |  14 +-
 drivers/iommu/intel/pasid.c                   |  15 +-
 drivers/iommu/intel/pasid.h                   |  14 +
 drivers/iommu/intel/prq.c                     | 402 ++++++++++++++++++
 drivers/iommu/intel/svm.c                     | 397 -----------------
 drivers/leds/rgb/leds-qcom-lpg.c              |   8 +-
 drivers/md/dm-zone.c                          |  11 +-
 drivers/md/dm.c                               |   2 +
 drivers/md/raid1.c                            |   9 +-
 drivers/md/raid10.c                           |   2 +-
 drivers/md/raid5.c                            |   3 +-
 drivers/media/i2c/ccs/ccs-core.c              |  16 +-
 drivers/media/pci/mgb4/mgb4_trigger.c         |   2 +-
 .../chips-media/wave5/wave5-vpu-dec.c         |   4 +-
 .../chips-media/wave5/wave5-vpu-enc.c         |   4 +-
 drivers/media/usb/uvc/uvc_video.c             |   3 +-
 drivers/mfd/Kconfig                           |  24 ++
 drivers/mfd/arizona-core.c                    |   2 +-
 drivers/mfd/simple-mfd-i2c.c                  |  33 +-
 .../mtd/nand/raw/cadence-nand-controller.c    |   2 +-
 drivers/mtd/parsers/ofpart_core.c             |  16 +-
 drivers/mtd/parsers/tplink_safeloader.c       |   1 +
 drivers/net/bonding/bond_main.c               |  15 +-
 drivers/net/caif/caif_serial.c                |   5 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  11 +-
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
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  11 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   1 +
 .../ethernet/microchip/sparx5/sparx5_ptp.c    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_qos.h    |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  75 +++-
 .../ethernet/pensando/ionic/ionic_ethtool.c   |   7 +-
 drivers/net/ethernet/sun/sunhme.c             |   3 +
 drivers/net/mctp/mctp-i2c.c                   |   9 +
 drivers/net/usb/catc.c                        |  37 +-
 drivers/net/wireless/ath/ath10k/sdio.c        |   6 +
 drivers/net/xen-netback/xenbus.c              |   5 +-
 drivers/nvdimm/nd_virtio.c                    |   3 +-
 drivers/nvdimm/virtio_pmem.c                  |   1 +
 drivers/nvdimm/virtio_pmem.h                  |   4 +
 drivers/of/unittest.c                         |   6 +-
 drivers/opp/core.c                            |   2 +-
 drivers/pci/controller/pcie-mediatek.c        |   4 +-
 drivers/pci/p2pdma.c                          |   1 +
 drivers/pci/pci-acpi.c                        |  59 ++-
 drivers/pci/pci.c                             |   5 +-
 drivers/pci/pci.h                             |   7 +
 drivers/pci/pcie/aer.c                        |   3 -
 drivers/pci/pcie/portdrv.c                    |   6 +-
 drivers/pci/probe.c                           |  45 +-
 drivers/pci/quirks.c                          |   5 +
 drivers/perf/arm_spe_pmu.c                    |  18 +-
 drivers/phy/freescale/phy-fsl-imx8qm-hsio.c   |   2 +-
 drivers/pinctrl/pinctrl-equilibrium.c         |   1 +
 drivers/pinctrl/pinctrl-single.c              |   2 +
 .../pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c   |   2 +-
 drivers/platform/chrome/cros_ec_lightbar.c    |   2 +-
 drivers/platform/chrome/cros_typec_switch.c   |   6 +-
 drivers/platform/x86/amd/pmf/core.c           |  62 ++-
 drivers/platform/x86/amd/pmf/pmf.h            |  10 +
 drivers/platform/x86/amd/pmf/tee-if.c         |  12 +-
 drivers/platform/x86/intel/int0002_vgpio.c    |   4 +-
 drivers/power/reset/nvmem-reboot-mode.c       |  15 +-
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
 drivers/powercap/intel_rapl_tpmi.c            |   2 +-
 drivers/regulator/core.c                      |  55 +--
 drivers/s390/cio/css.c                        |   2 +-
 drivers/scsi/csiostor/csio_scsi.c             |   3 +-
 drivers/scsi/elx/efct/efct_driver.c           |   8 +-
 drivers/scsi/smartpqi/smartpqi_init.c         |  13 +-
 drivers/soc/mediatek/mtk-svs.c                |   5 +-
 drivers/soc/qcom/cmd-db.c                     |   7 +-
 drivers/soc/qcom/smem.c                       |   4 +-
 drivers/soundwire/Kconfig                     |   1 +
 drivers/staging/greybus/light.c               |   8 +-
 drivers/thermal/intel/x86_pkg_temp_thermal.c  |   3 +
 drivers/thermal/thermal_of.c                  |   4 +-
 drivers/tty/serial/Kconfig                    |   8 +-
 drivers/ufs/host/Kconfig                      |   1 +
 drivers/ufs/host/ufs-mediatek.c               |  12 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c         |   4 +-
 drivers/vfio/pci/vfio_pci_core.c              |  17 +-
 drivers/video/backlight/qcom-wled.c           |  42 +-
 drivers/video/fbdev/au1200fb.c                |   6 +-
 drivers/video/of_display_timing.c             |   6 +-
 drivers/watchdog/starfive-wdt.c               |   2 +-
 drivers/xen/balloon.c                         |  19 +-
 drivers/xen/grant-dma-ops.c                   |   3 +-
 drivers/xen/unpopulated-alloc.c               |   3 +
 fs/btrfs/qgroup.c                             |   4 +-
 fs/btrfs/transaction.c                        |   7 -
 fs/erofs/fileio.c                             |  22 +-
 fs/erofs/fscache.c                            |   4 +-
 fs/fat/namei_msdos.c                          |   7 +-
 fs/fat/namei_vfat.c                           |   7 +-
 fs/fs_struct.c                                |   1 +
 fs/gfs2/bmap.c                                |  13 +-
 fs/gfs2/glock.c                               |  36 +-
 fs/gfs2/glock.h                               |   3 +-
 fs/gfs2/inode.c                               |  18 +-
 fs/gfs2/quota.c                               |   1 +
 fs/hfsplus/bnode.c                            |   2 +-
 fs/iomap/direct-io.c                          |  10 +-
 fs/nfs/dir.c                                  |   4 +-
 fs/nfs/localio.c                              |  31 +-
 fs/nfs/pnfs.c                                 |   3 +-
 fs/nfsd/nfs2acl.c                             |   2 +-
 fs/nfsd/nfs4idmap.c                           |  48 ++-
 fs/nfsd/nfs4proc.c                            |   2 -
 fs/nfsd/nfs4xdr.c                             |  16 +
 fs/nfsd/nfsproc.c                             |   2 +-
 fs/ntfs3/file.c                               |  10 +-
 fs/ntfs3/fslog.c                              |   3 +
 fs/overlayfs/readdir.c                        |   2 +-
 fs/proc/array.c                               |   2 +-
 fs/pstore/ram_core.c                          |  11 +
 fs/quota/quota.c                              |   1 +
 fs/smb/client/smb2file.c                      |   2 +
 fs/smb/client/smbdirect.c                     |  19 +-
 fs/tests/exec_kunit.c                         |   6 -
 include/linux/audit.h                         |   6 -
 include/linux/audit_arch.h                    |   7 +
 include/linux/bio.h                           |   2 +
 include/linux/capability.h                    |   6 +
 include/linux/clk.h                           |  48 +--
 include/linux/ftrace.h                        | 139 ++++--
 include/linux/ftrace_regs.h                   |  38 ++
 include/linux/hw_random.h                     |   2 +
 include/linux/interrupt.h                     |   2 +-
 include/linux/mfd/wm8350/core.h               |   2 +-
 include/linux/module.h                        |   9 +
 include/linux/mtd/spinand.h                   |   2 +-
 include/linux/psp.h                           |   1 +
 include/linux/skbuff.h                        |  32 ++
 include/linux/skmsg.h                         |  70 ++-
 include/linux/sunrpc/xdrgen/_builtins.h       |  20 +-
 include/linux/u64_stats_sync.h                |  10 +
 include/net/ipv6.h                            |  11 +-
 include/net/netfilter/nf_conntrack_count.h    |   1 +
 include/net/netfilter/nf_queue.h              |   4 +
 include/rdma/rw.h                             |   2 +
 include/uapi/linux/nfs.h                      |   2 +-
 include/ufs/ufshcd.h                          |   4 -
 include/xen/xen.h                             |   2 +
 io_uring/cancel.h                             |   6 +-
 io_uring/io_uring.c                           |   6 +-
 io_uring/msg_ring.c                           |  12 +-
 io_uring/register.c                           |   3 +-
 io_uring/sync.c                               |   2 +
 ipc/ipc_sysctl.c                              |   2 +-
 kernel/bpf/verifier.c                         |   4 +-
 kernel/kallsyms.c                             |   4 +-
 kernel/module/kallsyms.c                      |   9 +-
 kernel/rcu/tree.h                             |   2 +-
 kernel/rcu/tree_plugin.h                      |  99 ++++-
 kernel/sched/deadline.c                       |   3 +
 kernel/sched/rt.c                             |   5 +
 kernel/time/hrtimer.c                         |   2 +-
 kernel/trace/Kconfig                          |   4 +-
 kernel/trace/fgraph.c                         |  21 +-
 kernel/trace/ftrace.c                         |   7 +-
 kernel/trace/trace_events.c                   |   5 -
 kernel/trace/trace_events_hist.c              |   2 +-
 kernel/ucount.c                               |   2 +-
 kernel/workqueue.c                            |  92 +++-
 lib/objpool.c                                 |   2 +-
 net/atm/signaling.c                           |  56 ++-
 net/bridge/br_multicast.c                     |  45 +-
 net/core/dev.c                                |   2 +-
 net/core/filter.c                             |   2 +-
 net/core/skmsg.c                              |  30 +-
 net/ipv4/icmp.c                               |  36 +-
 net/ipv4/ip_options.c                         |   5 +-
 net/ipv4/ping.c                               |  31 +-
 net/ipv4/tcp.c                                |   3 +
 net/ipv4/tcp_bpf.c                            |  25 +-
 net/ipv4/udp_bpf.c                            |  23 +-
 net/ipv6/icmp.c                               |   6 +
 net/ipv6/ip6_fib.c                            |   2 +-
 net/mptcp/protocol.c                          |   8 +-
 net/mptcp/protocol.h                          |   5 +
 net/netfilter/ipvs/ip_vs_xmit.c               |  46 +-
 net/netfilter/nf_conncount.c                  |  54 ++-
 net/netfilter/nf_conntrack_h323_main.c        |  10 +-
 net/netfilter/nf_tables_api.c                 |  13 +
 net/netfilter/nfnetlink_queue.c               | 267 ++++++++----
 net/netfilter/nft_compat.c                    |  13 +-
 net/netfilter/nft_connlimit.c                 |   7 +-
 net/netfilter/nft_counter.c                   |   4 +-
 net/netfilter/nft_set_hash.c                  |   9 +-
 net/netfilter/nft_set_rbtree.c                |  43 +-
 net/nfc/hci/llc_shdlc.c                       |   8 +
 net/rds/send.c                                |   6 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c      |   8 +-
 net/wireless/core.c                           |   4 +-
 net/wireless/scan.c                           |   2 +-
 security/integrity/evm/evm_crypto.c           |  14 +-
 security/smack/smackfs.c                      |  79 ++--
 sound/core/pcm.c                              |   4 +-
 sound/core/pcm_compat.c                       |   9 +-
 sound/core/pcm_native.c                       |  50 +--
 sound/core/vmaster.c                          |  12 +-
 sound/soc/codecs/nau8821.c                    |  85 ++--
 sound/soc/codecs/nau8821.h                    |   3 +-
 tools/bpf/bpftool/net.c                       |   5 +-
 tools/lib/bpf/btf_dump.c                      |   9 +
 tools/lib/bpf/netlink.c                       |   4 +-
 .../net/sunrpc/xdrgen/generators/__init__.py  |   3 +-
 .../templates/C/program/decoder/argument.j2   |   4 +
 .../templates/C/program/encoder/result.j2     |   6 +
 tools/objtool/Makefile                        |   2 +
 .../x86/intel-speed-select/isst-config.c      |   2 +
 tools/spi/.gitignore                          |   1 +
 tools/testing/selftests/bpf/prog_tests/wq.c   |   5 +-
 tools/testing/selftests/bpf/veristat.c        |   2 +-
 .../drivers/net/mlxsw/tc_restrictions.sh      |   4 +-
 tools/testing/selftests/memfd/memfd_test.c    | 113 ++++-
 tools/testing/selftests/mm/pagemap_ioctl.c    | 116 ++---
 tools/testing/selftests/mm/vm_util.c          |   2 +-
 .../net/forwarding/vxlan_bridge_1d.sh         |  26 +-
 .../net/forwarding/vxlan_bridge_1d_ipv6.sh    |   2 +-
 417 files changed, 5025 insertions(+), 2483 deletions(-)
 create mode 100644 Documentation/trace/events-pci.rst
 create mode 100644 drivers/iommu/intel/prq.c
 create mode 100644 include/linux/ftrace_regs.h

-- 
2.51.0

