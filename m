Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06016379EF1;
	Sat, 28 Feb 2026 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302023; cv=none; b=A6dM2OdXuRAbMrA461bIfD7FN/+oF6cDejVFlCHIXPltj+ZoHEcX7foa6OhUHrTJ5+A16NY0NF87O6csTjdamKG3qU/ssCff1k9AbUY7BKm56kf5F3QzH66ajs+fRFGeD3dg5/2rR183hyi9fsy+GQpfEuM5b7VnDNrW81jn3zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302023; c=relaxed/simple;
	bh=cdinyd6DFvAWIfxjHSg6nHJEY9HAautxzC/SSRLbng0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HSug6CS0M58DDcvAbHf9P6rCmwnS1XS0CU5yYz3Sh6qyWbJeTUkAef5A9nLGH6KbsPtip9fwnCIT1X7dP/Q/EZBwfNMRSV+EsE9NnhrrXYNKGso0o/WvUD10l8kcFxzffIKTPWQQW+hMrUkxBB2DONVb9vprQcMQ1ffl5qcmlIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0JRBJVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0JRBJVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1DBC116D0;
	Sat, 28 Feb 2026 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302022;
	bh=cdinyd6DFvAWIfxjHSg6nHJEY9HAautxzC/SSRLbng0=;
	h=From:To:Cc:Subject:Date:From;
	b=V0JRBJVPORnCaUD/ZiYNVucFeTORUQ++IPWUdoPs28hqmWn4a/wzoZmnzO0ApAcm7
	 Y14I3snx0iF/XMQ+n+D6zFVQMBk5FBJYUdBo6LXJet3z35xaCfBULHY4niEHJCAnbN
	 m8Y86CeIOEKpZi9eK6zJ/b5ZuPa9tQy3wyfetzXYuQ8eDmAaX2RndF/QnbZFbs8mad
	 4KufP+fzAkK0fFiUhCezoPhRKtBKF2TzDlCDporVVS/foxx68mMqSdExX0/VqFpz3s
	 NGk5Xdtv8ghrkoKAt/xY22QKdVZPUr1WyxqR0fcItHok2EqgxzGVl/hOHBE/0AJCuw
	 cQ19SRsH3AtDw==
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
Subject: [PATCH 6.6 000/283] 6.6.128-rc1 review
Date: Sat, 28 Feb 2026 13:06:59 -0500
Message-ID: <20260228180659.1583364-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.128-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.128-rc1
X-KernelTest-Deadline: 2026-03-02T18:06+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit


This is the start of the stable review cycle for the 6.6.128 release.
There are 283 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Mar  2 06:06:54 PM UTC 2026.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.6.y&id2=v6.6.127
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Abhishek Bapat (1):
  quota: fix livelock between quotactl and freeze_super

Aboorva Devarajan (1):
  cpuidle: Skip governor when only one idle state is available

Adrian Hunter (1):
  i3c: master: Update hot-join flag only on success

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

Alexander Stein (1):
  arm64: dts: tqma8mpql-mba8mpxl: Fix HDMI CEC pad control settings

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
  gfs2: Add metapath_dibh helper

André Draszik (1):
  regulator: core: move supply check earlier in
    set_machine_constraints()

Andy Shevchenko (1):
  platform/chrome: cros_typec_switch: Don't touch struct
    fwnode_handle::dev

AngeloGioacchino Del Regno (1):
  dmaengine: mediatek: uart-apdma: Fix above 4G addressing TX/RX

Anshumali Gaur (1):
  octeontx2-af: Fix PF driver crash with kexec kernel booting

Anthony Iliopoulos (1):
  nfsd: never defer requests during idmap lookup

Antonio Borneo (1):
  coresight: etm3x: Fix cpulocked warning on cpuhp

Aristeu Rozanski (1):
  selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT

Arnd Bergmann (1):
  scsi: ufs: host: mediatek: Require CONFIG_PM

Barnabás Czémán (4):
  clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
  clk: qcom: gcc-msm8917: Remove ALWAYS_ON flag from cpp_gdsc
  backlight: qcom-wled: Support ovp values for PMI8994
  backlight: qcom-wled: Change PM8950 WLED configurations

Baruch Siach (1):
  Documentation: PCI: endpoint: Fix ntb/vntb copy & paste errors

Ben Dooks (2):
  audit: move the compat_xxx_class[] extern declarations to audit_arch.h
  fs: add <linux/init_task.h> for 'init_fs'

Billy Tsai (1):
  i3c: Move device name assignment after i3c_bus_init

Bjorn Helgaas (4):
  PCI: Move pci_read_bridge_windows() below individual window accessors
  PCI: Supply bridge device, not secondary bus, to read window details
  PCI: Log bridge windows conditionally
  PCI: Log bridge info when first enumerating bridge

Boris Burkov (1):
  btrfs: fix block_group_tree dirty_list corruption

Brian Norris (1):
  PCI/PM: Avoid redundant delays on D3hot->D3cold

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

Chenghai Huang (2):
  crypto: hisilicon/zip - adjust the way to obtain the req in the
    callback function
  crypto: hisilicon/trng - modifying the order of header files

Christian Loehle (1):
  cpuidle: menu: Cleanup after loadavg removal

Christoph Hellwig (1):
  iomap: fix submission side handling of completion side errors

Christophe Leroy (1):
  powerpc/uaccess: Move barrier_nospec() out of
    allow_read_{from/write}_user()

Chuck Lever (6):
  RDMA/core: Fix a couple of obvious typos in comments
  svcrdma: Remove queue-shortening warnings
  svcrdma: Clean up comment in svc_rdma_accept()
  svcrdma: Increase the per-transport rw_ctx count
  svcrdma: Reduce the number of rdma_rw contexts per-QP
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

David Heidelberg (1):
  media: ccs: Accommodate C-PHY into the calculation

Deepanshu Kartikey (1):
  gfs2: Fix use-after-free in iomap inline data write path

Dmitry Baryshkov (6):
  arm64: dts: qcom: sdm630: fix gpu_speed_bin size
  arm64: dts: qcom: sdm845-db845c: drop CS from SPIO0
  arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
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

Felix Gu (3):
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

Florian Westphal (4):
  netfilter: nf_tables: reset table validation state on abort
  netfilter: nft_compat: add more restrictions on netlink attributes
  netfilter: nft_set_hash: fix get operation on big endian
  netfilter: nf_conntrack_h323: don't pass uninitialised l3num value

Francesco Lavra (1):
  spi: tools: Add include folder to .gitignore

Frederic Weisbecker (2):
  rcu: s/boost_kthread_mutex/kthread_mutex
  rcu/exp: Move expedited kthread worker creation functions above
    rcutree_prepare_cpu()

Fredrik Markstrom (1):
  i3c: dw: Initialize spinlock to avoid upsetting lockdep

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

Greg Thelen (1):
  selftests/memfd: delete unused declarations

Guenter Roeck (1):
  Revert "hwmon: (ibmpex) fix use-after-free in high/low store"

Gui-Dong Han (1):
  PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races

Haotian Zhang (8):
  clk: qcom: Return correct error code in qcom_cc_probe_by_index()
  soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in
    cmd_db_dev_probe
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

Jagadeesh Kona (3):
  clk: qcom: gcc-sm8450: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-sdx75: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-qdu1000: Update the SDCC RCGs to use shared_floor_ops

Jakub Kicinski (1):
  bpftool: Fix truncated netlink dumps

Jared Kangas (1):
  dmaengine: fsl-edma: don't explicitly disable clocks in .remove()

Jens Axboe (2):
  io_uring/sync: validate passed in offset
  io_uring/cancel: de-unionize file and user_data in struct
    io_cancel_data

Jerome Brunet (4):
  arm64: dts: amlogic: axg: assign the MMC signal clocks
  arm64: dts: amlogic: gx: assign the MMC signal clocks
  arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
  arm64: dts: amlogic: g12: assign the MMC A signal clock

Jian Shen (1):
  net: hns3: fix double free issue for tx spare buffer

Jian Zhang (1):
  net: mctp-i2c: fix duplicate reception of old data

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

Joel Fernandes (1):
  rcu: Refactor expedited handling check in rcu_read_unlock_special()

Jorge Ramirez-Ortiz (1):
  soc: qcom: smem: handle ENOMEM error during probe

Josh Poimboeuf (1):
  kbuild: Add objtool to top-level clean target

Juergen Gross (1):
  x86/xen: make some functions static

Justin Chen (1):
  usb: bdc: fix sleep during atomic

Jörg Wedekind (1):
  PCI: Mark 3ware-9650SA Root Port Extended Tags as broken

Kery Qi (1):
  watchdog: starfive-wdt: Fix PM reference leak in probe error path

Konrad Dybcio (1):
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

Luca Weiss (1):
  pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition

Mahadevan P (1):
  drm/msm/disp/dpu: add merge3d support for sc7280

Malaya Kumar Rout (1):
  tools/power/x86/intel-speed-select: Fix file descriptor leak in
    isolate_cpus()

Mario Limonciello (AMD) (3):
  crypto: ccp - Add an S4 restore flow
  crypto: ccp - Factor out ring destroy handling to a helper
  crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
    fails

Martin Blumenstingl (1):
  clk: meson: gxbb: Limit the HDMI PLL OD to /4 on GXL/GXM SoCs

Matt Johnston (1):
  mctp i2c: initialise event handler read bytes

Matthew Schwartz (1):
  mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms

Miaoqian Lin (1):
  tracing: Properly process error handling in event_hist_trigger_parse()

Mikulas Patocka (1):
  dm: use bio_clone_blkg_association

Miquel Raynal (1):
  mtd: spinand: Fix kernel doc

Miri Korenblit (1):
  wifi: cfg80211: stop NAN and P2P in cfg80211_leave

Narayana Murty N (1):
  powerpc/eeh: fix recursive pci_lock_rescan_remove locking in EEH event
    handling

Nicolas Cavallari (1):
  PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]

Nikolay Aleksandrov (1):
  net: bridge: mcast: always update mdb_n_entries for vlan contexts

Nuno Sá (1):
  dma: dma-axi-dmac: fix SW cyclic transfers

Olga Kornievskaia (1):
  pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN

Ondrej Mosnacek (2):
  ipc: don't audit capability check in ipc_permissions()
  ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()

Pablo Neira Ayuso (2):
  netfilter: nft_set_rbtree: check for partial overlaps in anonymous
    sets
  net: remove WARN_ON_ONCE when accessing forward path array

Paolo Abeni (1):
  mptcp: fix receive space timestamp initialization

Paul Chaignon (1):
  bpf: Fix bpf_xdp_store_bytes proto for read-only arg

Paulo Alcantara (1):
  smb: client: fix potential UAF and double free in smb2_open_file()

Petr Hodina (1):
  clk: qcom: dispcc-sdm845: Enable parents for pixel clocks

Petr Mladek (2):
  module: add helper function for reading module_buildid()
  kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()

Petre Rodan (1):
  iio: pressure: mprls0025pa: fix scan_type struct

Puranjay Mohan (1):
  selftests/bpf: veristat: fix printing order in output_stats()

Purva Yeshi (1):
  Documentation: trace: Refactor toctree

Qi Tao (1):
  crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
    queue unavailable

Qing Wang (1):
  ovl: Fix uninit-value in ovl_fill_real

Rafael J. Wysocki (1):
  cpuidle: governors: menu: Always check timers with tick stopped

Randy Dunlap (2):
  serial: imx: change SERIAL_IMX_CONSOLE to bool
  serial: SH_SCI: improve "DMA support" prompt

René Rebe (1):
  net: sunhme: Fix sbus regression

Ricardo Ribalda (1):
  media: uvcvideo: Fix allocation for small frame sizes

Robert Marko (1):
  mfd: simple-mfd-i2c: Add Delta TN48M CPLD support

Roger Pau Monne (1):
  Partial revert "x86/xen: fix balloon target initialization for PVH
    dom0"

Roman Penyaev (1):
  RDMA/rtrs-srv: fix SG mapping

Sagi Grimberg (1):
  fs/nfs: Fix readdir slow-start regression

Sai Ritvik Tanksalkar (1):
  pstore/ram: fix buffer overflow in persistent_ram_save_old()

Salah Triki (1):
  s390/cio: Fix device lifecycle handling in css_alloc_subchannel()

Samuel Wu (1):
  PM: wakeup: Handle empty list in wakeup_sources_walk_start()

Sasha Levin (1):
  Linux 6.6.128-rc1

Sean V Kelley (1):
  ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs

Sebastian Andrzej Siewior (3):
  scsi: efct: Use IRQF_ONESHOT and default primary handler
  EDAC/altera: Remove IRQF_ONESHOT
  mfd: wm8350-core: Use IRQF_ONESHOT

Shardul Bankar (1):
  hfsplus: return error when node already exists in hfs_bnode_create

Shinas Rasheed (4):
  octeon_ep: support to fetch firmware info
  octeon_ep: restructured interrupt handlers
  octeon_ep: support Octeon CN10K devices
  octeon_ep: set backpressure watermark for RX queues

Shuai Xue (1):
  Documentation: tracing: Add PCI tracepoint documentation

Srinivasan Shanmugam (1):
  drm/amdgpu: Use explicit VCN instance 0 in SR-IOV init

Stanislav Fomichev (2):
  net: Add skb_dstref_steal and skb_dstref_restore
  net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input
    callers

Stefan Metzmacher (1):
  smb: client: correct value for smbd_max_fragmented_recv_size

Steven Rostedt (1):
  tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR
    macros

SurajSonawane2415 (1):
  docs: fix WARNING document not included in any toctree

Svyatoslav Ryhel (1):
  drivers: iio: mpu3050: use dev_err_probe for regulator request

Taniya Das (1):
  clk: qcom: rcg2: compute 2d using duty fraction directly

Teddy Astie (1):
  xen/virtio: Don't use grant-dma-ops when running as Dom0

Thomas Bogendoerfer (1):
  bonding: only set speed/duplex to unknown, if getting speed failed

Thomas Fourier (3):
  auxdisplay: arm-charlcd: fix release_mem_region() size
  crypto: cavium - fix dma_free_coherent() size
  crypto: octeontx - fix dma_free_coherent() size

Thomas Gleixner (1):
  hrtimer: Fix trace oddity

Thomas Weißschuh (1):
  ARM: VDSO: Patch out __vdso_clock_getres() if unavailable

Tom Lendacky (1):
  crypto: ccp - Move direct access to some PSP registers out of TEE

Tuo Li (1):
  of: unittest: fix possible null-pointer dereferences in
    of_unittest_property_copy()

Tzung-Bi Shih (1):
  platform/chrome: cros_ec_lightbar: Fix response size initialization

Uwe Kleine-König (2):
  PCI/portdrv: Fix potential resource leak
  dmaengine: fsl-edma-main: Convert to platform remove callback
    returning void

Val Packett (1):
  power: supply: qcom_battmgr: Recognize "LiP" as lithium-polymer

Varun R Mallya (1):
  libbpf: Fix OOB read in btf_dump_get_bitfield_value

Vimlesh Kumar (2):
  octeon_ep: disable per ring interrupts
  octeon_ep: ensure dbell BADDR updation

Vincent Donnefort (1):
  Documentation: tracing: Add ring-buffer mapping

Vladimir Zapolskiy (3):
  ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
  arm: dts: lpc32xx: add clocks property to Motor Control PWM device
    tree node
  clk: qcom: gcc-sm8550: Use floor ops for SDCC RCGs

Votokina Victoria (1):
  nfc: hci: shdlc: Stop timers and work before freeing context

Waqar Hameed (9):
  power: supply: ab8500: Fix use-after-free in power_supply_changed()
  power: supply: act8945a: Fix use-after-free in power_supply_changed()
  power: supply: bq256xx: Fix use-after-free in power_supply_changed()
  power: supply: bq25980: Fix use-after-free in power_supply_changed()
  power: supply: cpcap-battery: Fix use-after-free in
    power_supply_changed()
  power: supply: goldfish: Fix use-after-free in power_supply_changed()
  power: supply: rt9455: Fix use-after-free in power_supply_changed()
  power: supply: sbs-battery: Fix use-after-free in
    power_supply_changed()
  power: supply: wm97xx: Fix NULL pointer dereference in
    power_supply_changed()

Wei Li (1):
  pinctrl: single: fix refcount leak in pcs_add_gpio_func()

Weigang He (1):
  mtd: parsers: ofpart: fix OF node refcount leak in
    parse_fixed_partitions()

Weili Qian (1):
  crypto: hisilicon/trng - support tfms sharing the device

Yang Shen (2):
  crypto: hisilicon/zip - support deflate algorithm
  crypto: hisilicon/zip - remove zlib and gzip

Yao Kai (1):
  rcu: Fix rcu_read_unlock() deadloop due to softirq

Yi Liu (2):
  RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
  RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc

Yoshihiro Shimoda (1):
  PCI: Add PCIE_MSG_CODE_ASSERT_INTx message macros

YunJe Shin (2):
  RDMA/siw: Fix potential NULL pointer dereference in header processing
  RDMA/umad: Reject negative data_len in ib_umad_write

Yuxiong Wang (1):
  cxl: Fix premature commit_end increment on decoder commit failure

Zhai Can (1):
  ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO

Zhiyu Zhang (1):
  fat: avoid parent link count underflow in rmdir

Zilin Guan (3):
  soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()
  mtd: parsers: Fix memory leak in mtd_parser_tplink_safeloader_parse()
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

 Documentation/PCI/endpoint/pci-vntb-howto.rst |  14 +-
 .../ethernet/marvell/octeon_ep.rst            |   4 +
 Documentation/trace/events-pci.rst            |  74 ++
 Documentation/trace/index.rst                 |  95 +-
 Documentation/trace/ring-buffer-map.rst       | 106 ++
 Makefile                                      |  15 +-
 .../boot/dts/allwinner/sun5i-a13-utoo-p66.dts |   1 +
 arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi        |   3 +-
 arch/arm/kernel/vdso.c                        |   1 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   6 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi   |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   9 +
 .../freescale/imx8mp-tqma8mpql-mba8mpxl.dts   |   2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |   4 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts    |   8 +-
 .../boot/dts/qcom/sdm845-oneplus-common.dtsi  |   3 +-
 arch/arm64/boot/dts/qcom/sm6115.dtsi          |   8 +-
 arch/powerpc/include/asm/eeh.h                |   2 +
 arch/powerpc/include/asm/kup.h                |   2 -
 arch/powerpc/include/asm/uaccess.h            |   4 +
 arch/powerpc/kernel/eeh_driver.c              |  11 +-
 arch/powerpc/kernel/eeh_pe.c                  |  74 +-
 arch/x86/xen/enlighten.c                      |   2 +-
 arch/x86/xen/mmu.h                            |   4 -
 arch/x86/xen/mmu_pv.c                         |  11 +-
 arch/x86/xen/xen-ops.h                        |   1 -
 drivers/acpi/acpica/evregion.c                |   4 +-
 drivers/acpi/cppc_acpi.c                      |   4 +-
 drivers/acpi/power.c                          |  13 +
 drivers/auxdisplay/arm-charlcd.c              |   2 +-
 drivers/base/power/wakeirq.c                  |   9 +-
 drivers/base/power/wakeup.c                   |   4 +-
 drivers/block/ublk_drv.c                      |   6 +-
 drivers/char/tpm/st33zp24/st33zp24.c          |   6 +-
 drivers/char/tpm/tpm_i2c_infineon.c           |   6 +-
 drivers/clk/mediatek/clk-mtk.c                |  12 +-
 drivers/clk/meson/gxbb.c                      |  17 +-
 drivers/clk/qcom/clk-rcg2.c                   |   7 +-
 drivers/clk/qcom/common.c                     |   2 +-
 drivers/clk/qcom/dispcc-sdm845.c              |   4 +-
 drivers/clk/qcom/gcc-ipq5018.c                |   1 +
 drivers/clk/qcom/gcc-msm8917.c                |   1 -
 drivers/clk/qcom/gcc-msm8953.c                |   1 -
 drivers/clk/qcom/gcc-qdu1000.c                |   4 +-
 drivers/clk/qcom/gcc-sdx75.c                  |   4 +-
 drivers/clk/qcom/gcc-sm8450.c                 |   4 +-
 drivers/clk/qcom/gcc-sm8550.c                 |   4 +-
 drivers/cpuidle/cpuidle.c                     |  10 +
 drivers/cpuidle/governors/menu.c              |  39 +-
 drivers/crypto/cavium/cpt/cptvf_main.c        |   3 +-
 drivers/crypto/ccp/psp-dev.c                  |  71 ++
 drivers/crypto/ccp/psp-dev.h                  |  18 +
 drivers/crypto/ccp/sp-dev.c                   |  12 +
 drivers/crypto/ccp/sp-dev.h                   |   6 +
 drivers/crypto/ccp/sp-pci.c                   |  34 +-
 drivers/crypto/ccp/tee-dev.c                  |  95 +-
 drivers/crypto/ccp/tee-dev.h                  |  16 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c    |  62 +-
 drivers/crypto/hisilicon/trng/trng.c          | 123 ++-
 drivers/crypto/hisilicon/zip/zip_crypto.c     | 302 +-----
 drivers/crypto/hisilicon/zip/zip_main.c       |   4 +-
 .../intel/qat/qat_common/adf_pfvf_pf_proto.c  |  10 +
 .../crypto/marvell/octeontx/otx_cptvf_main.c  |   3 +-
 drivers/cxl/core/hdm.c                        |   3 +-
 drivers/dma/dma-axi-dmac.c                    |   3 +-
 drivers/dma/fsl-edma-main.c                   |   7 +-
 drivers/dma/mediatek/mtk-uart-apdma.c         |  10 +-
 drivers/edac/altera_edac.c                    |  11 +-
 drivers/edac/i5000_edac.c                     |   1 +
 drivers/edac/i5400_edac.c                     |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c         |  45 +-
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c         |   5 +-
 .../msm/disp/dpu1/catalog/dpu_7_2_sc7280.h    |  14 +-
 .../drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c  |   7 +-
 drivers/hid/hid-playstation.c                 |   4 +-
 drivers/hwmon/ibmpex.c                        |   9 +-
 .../coresight/coresight-etm3x-core.c          |  12 +-
 drivers/i3c/master.c                          |   6 +-
 drivers/i3c/master/dw-i3c-master.c            |   2 +
 drivers/iio/accel/sca3000.c                   |   6 +-
 drivers/iio/gyro/mpu3050-core.c               |   6 +-
 drivers/iio/pressure/mprls0025pa.c            |   4 +-
 drivers/infiniband/core/cache.c               |   3 +-
 drivers/infiniband/core/rw.c                  |  53 +-
 drivers/infiniband/core/user_mad.c            |   8 +-
 drivers/infiniband/core/uverbs_cmd.c          |   7 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  26 +-
 drivers/infiniband/sw/rxe/rxe_comp.c          |   3 +
 drivers/infiniband/sw/rxe/rxe_req.c           |   3 +
 drivers/infiniband/sw/rxe/rxe_srq.c           |   6 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c         |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c        |  33 +-
 drivers/iommu/intel/pasid.c                   |   7 +-
 drivers/leds/rgb/leds-qcom-lpg.c              |   8 +-
 drivers/md/dm.c                               |   2 +
 drivers/md/raid10.c                           |   2 +-
 drivers/media/i2c/ccs/ccs-core.c              |  16 +-
 drivers/media/usb/uvc/uvc_video.c             |   3 +-
 drivers/mfd/Kconfig                           |  24 +
 drivers/mfd/arizona-core.c                    |   2 +-
 drivers/mfd/simple-mfd-i2c.c                  |  33 +-
 .../mtd/nand/raw/cadence-nand-controller.c    |   2 +-
 drivers/mtd/parsers/ofpart_core.c             |  16 +-
 drivers/mtd/parsers/tplink_safeloader.c       |   1 +
 drivers/net/bonding/bond_main.c               |  15 +-
 drivers/net/caif/caif_serial.c                |   5 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  11 +-
 .../net/ethernet/marvell/octeon_ep/Makefile   |   3 +-
 .../marvell/octeon_ep/octep_cn9k_pf.c         | 189 +++-
 .../marvell/octeon_ep/octep_cnxk_pf.c         | 935 ++++++++++++++++++
 .../ethernet/marvell/octeon_ep/octep_config.h |  32 +-
 .../marvell/octeon_ep/octep_ctrl_net.c        |  24 +-
 .../marvell/octeon_ep/octep_ctrl_net.h        |  18 +
 .../ethernet/marvell/octeon_ep/octep_main.c   | 233 ++++-
 .../ethernet/marvell/octeon_ep/octep_main.h   |  21 +-
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |   5 +
 .../marvell/octeon_ep/octep_regs_cnxk_pf.h    | 404 ++++++++
 .../net/ethernet/marvell/octeon_ep/octep_rx.c |   8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  11 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   1 +
 .../ethernet/microchip/sparx5/sparx5_ptp.c    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_qos.h    |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  75 +-
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
 drivers/pci/controller/pcie-mediatek.c        |   4 +-
 drivers/pci/p2pdma.c                          |   1 +
 drivers/pci/pci-acpi.c                        |  59 +-
 drivers/pci/pci.c                             |   3 +
 drivers/pci/pci.h                             |  25 +
 drivers/pci/pcie/aer.c                        |   3 -
 drivers/pci/pcie/portdrv.c                    |   6 +-
 drivers/pci/probe.c                           | 189 ++--
 drivers/pci/quirks.c                          |   5 +
 drivers/perf/arm_spe_pmu.c                    |  18 +-
 drivers/pinctrl/pinctrl-equilibrium.c         |   1 +
 drivers/pinctrl/pinctrl-single.c              |   2 +
 .../pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c   |   2 +-
 drivers/platform/chrome/cros_ec_lightbar.c    |   2 +-
 drivers/platform/chrome/cros_typec_switch.c   |   6 +-
 drivers/power/reset/nvmem-reboot-mode.c       |  15 +-
 drivers/power/supply/ab8500_charger.c         |  40 +-
 drivers/power/supply/act8945a_charger.c       |  16 +-
 drivers/power/supply/bq256xx_charger.c        |  12 +-
 drivers/power/supply/bq25980_charger.c        |  12 +-
 drivers/power/supply/bq27xxx_battery.c        |   6 +-
 drivers/power/supply/cpcap-battery.c          |   8 +-
 drivers/power/supply/goldfish_battery.c       |  12 +-
 drivers/power/supply/qcom_battmgr.c           |   3 +-
 drivers/power/supply/rt9455_charger.c         |  17 +-
 drivers/power/supply/sbs-battery.c            |  36 +-
 drivers/power/supply/wm97xx_battery.c         |  34 +-
 drivers/powercap/intel_rapl_tpmi.c            |   2 +-
 drivers/regulator/core.c                      |  55 +-
 drivers/s390/cio/css.c                        |   2 +-
 drivers/scsi/csiostor/csio_scsi.c             |   3 +-
 drivers/scsi/elx/efct/efct_driver.c           |   8 +-
 drivers/scsi/smartpqi/smartpqi_init.c         |  13 +-
 drivers/soc/mediatek/mtk-svs.c                |   5 +-
 drivers/soc/qcom/cmd-db.c                     |   7 +-
 drivers/soc/qcom/smem.c                       |   4 +-
 drivers/staging/greybus/light.c               |   8 +-
 drivers/tty/serial/Kconfig                    |   8 +-
 drivers/ufs/host/Kconfig                      |   1 +
 drivers/ufs/host/ufs-mediatek.c               |  12 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c         |   4 +-
 drivers/video/backlight/qcom-wled.c           |  42 +-
 drivers/video/fbdev/au1200fb.c                |   6 +-
 drivers/video/of_display_timing.c             |   6 +-
 drivers/watchdog/starfive-wdt.c               |   2 +-
 drivers/xen/balloon.c                         |  19 +-
 drivers/xen/grant-dma-ops.c                   |   3 +-
 drivers/xen/unpopulated-alloc.c               |   3 +
 fs/btrfs/qgroup.c                             |   4 +-
 fs/btrfs/transaction.c                        |   7 -
 fs/fat/namei_msdos.c                          |   7 +-
 fs/fat/namei_vfat.c                           |   7 +-
 fs/fs_struct.c                                |   1 +
 fs/gfs2/bmap.c                                |  21 +-
 fs/gfs2/glock.c                               |  36 +-
 fs/gfs2/glock.h                               |   3 +-
 fs/gfs2/inode.c                               |  18 +-
 fs/hfsplus/bnode.c                            |   2 +-
 fs/iomap/direct-io.c                          |  10 +-
 fs/nfs/dir.c                                  |   4 +-
 fs/nfs/pnfs.c                                 |   3 +-
 fs/nfsd/nfs4idmap.c                           |  48 +-
 fs/nfsd/nfs4proc.c                            |   2 -
 fs/nfsd/nfs4xdr.c                             |  16 +
 fs/ntfs3/file.c                               |   8 +-
 fs/ntfs3/fslog.c                              |   3 +
 fs/overlayfs/readdir.c                        |   2 +-
 fs/proc/array.c                               |   2 +-
 fs/pstore/ram_core.c                          |  11 +
 fs/quota/quota.c                              |   1 +
 fs/smb/client/smb2file.c                      |   2 +
 fs/smb/client/smbdirect.c                     |  19 +-
 include/linux/audit.h                         |   6 -
 include/linux/audit_arch.h                    |   7 +
 include/linux/capability.h                    |   6 +
 include/linux/clk.h                           |  48 +-
 include/linux/ftrace.h                        |   6 +-
 include/linux/mfd/wm8350/core.h               |   2 +-
 include/linux/module.h                        |   9 +
 include/linux/mtd/spinand.h                   |   2 +-
 include/linux/psp.h                           |   1 +
 include/linux/skbuff.h                        |  32 +
 include/linux/skmsg.h                         |  70 +-
 include/linux/u64_stats_sync.h                |  10 +
 include/net/ipv6.h                            |  11 +-
 include/net/netfilter/nf_conntrack_count.h    |   1 +
 include/rdma/ib_verbs.h                       |   2 +-
 include/rdma/rw.h                             |   2 +
 include/ufs/ufshcd.h                          |   4 -
 include/xen/xen.h                             |   2 +
 io_uring/cancel.h                             |   6 +-
 io_uring/sync.c                               |   2 +
 ipc/ipc_sysctl.c                              |   2 +-
 kernel/kallsyms.c                             |   4 +-
 kernel/module/kallsyms.c                      |   9 +-
 kernel/rcu/tree.c                             |  98 +-
 kernel/rcu/tree.h                             |   4 +-
 kernel/rcu/tree_plugin.h                      | 109 +-
 kernel/sched/rt.c                             |   5 +
 kernel/time/hrtimer.c                         |   2 +-
 kernel/trace/ftrace.c                         |   5 +-
 kernel/trace/trace_events.c                   |   5 -
 kernel/trace/trace_events_hist.c              |   2 +-
 kernel/ucount.c                               |   2 +-
 kernel/workqueue.c                            |  92 +-
 net/atm/signaling.c                           |  56 +-
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
 net/netfilter/nf_conncount.c                  |  54 +-
 net/netfilter/nf_conntrack_h323_main.c        |  10 +-
 net/netfilter/nf_tables_api.c                 |   8 +
 net/netfilter/nft_compat.c                    |  13 +-
 net/netfilter/nft_connlimit.c                 |   7 +-
 net/netfilter/nft_counter.c                   |   4 +-
 net/netfilter/nft_set_hash.c                  |   9 +-
 net/netfilter/nft_set_rbtree.c                |  30 +-
 net/nfc/hci/llc_shdlc.c                       |   8 +
 net/rds/send.c                                |   6 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c      |  43 +-
 net/wireless/core.c                           |   4 +-
 security/smack/smackfs.c                      |  79 +-
 sound/soc/codecs/nau8821.c                    |  85 +-
 sound/soc/codecs/nau8821.h                    |   3 +-
 tools/bpf/bpftool/net.c                       |   5 +-
 tools/lib/bpf/btf_dump.c                      |   9 +
 tools/lib/bpf/netlink.c                       |   4 +-
 tools/objtool/Makefile                        |   2 +
 .../x86/intel-speed-select/isst-config.c      |   2 +
 tools/spi/.gitignore                          |   1 +
 tools/testing/selftests/bpf/veristat.c        |   2 +-
 .../drivers/net/mlxsw/tc_restrictions.sh      |   4 +-
 tools/testing/selftests/memfd/memfd_test.c    | 123 ++-
 .../net/forwarding/vxlan_bridge_1d.sh         |  26 +-
 .../net/forwarding/vxlan_bridge_1d_ipv6.sh    |   2 +-
 280 files changed, 4807 insertions(+), 1468 deletions(-)
 create mode 100644 Documentation/trace/events-pci.rst
 create mode 100644 Documentation/trace/ring-buffer-map.rst
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h

-- 
2.51.0

