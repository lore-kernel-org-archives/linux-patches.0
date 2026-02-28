Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889DF2737F2;
	Sat, 28 Feb 2026 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302283; cv=none; b=WHqZvqOJc6uAjYxMG6u3vd7xJrc3JvWSU2XSt9+ZH4X8SxzXrIgPWUrrZJouW6NhVBdZdEBVICZ3HB6VDaJpr++7deZlR+Nx0AmhytskqlkqOxjALz1Uxu/gEZYyZ8yBKK76Zekerz4UMUQCB4zMgLbaqld4wIZeSZsEx4XcWSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302283; c=relaxed/simple;
	bh=wd7DHeN41KY8LtM5DKOxaZJIW+YgqSQ0hbSFcle92Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CS3abaTJFxFTDKvfceBLpVUxBPoxIWw9rQKrCmoPAXV9D8l1Wd6HHRktYs/dOvxg/d1ujPFv98A7dAPEMl/nZv8PmWg5RKANSuuvea92WsK2qUWpGygMv/lOy4ta93FRChWLfCdWvS+7wEWWVAvGaPGE859GzXbHdLulSDoG4DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eK9zRbMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eK9zRbMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FED7C116D0;
	Sat, 28 Feb 2026 18:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302283;
	bh=wd7DHeN41KY8LtM5DKOxaZJIW+YgqSQ0hbSFcle92Fo=;
	h=From:To:Cc:Subject:Date:From;
	b=eK9zRbMzFlTeaa7MECE7qy+RYtiRHrhiRsVCFUC/vf0fVdAgmnfssiS1N14i52+VO
	 2ovI2ewIFnAWR8nQkjlrcbJebuwxeWE1oP//gvOeubUp6Q51emNxqSy38bDrckTc+N
	 U7TT9DeuOvq3sR5DaWZgLv9tFJRc7nw2nIEtrb9gxxlx6gzI7a0fZgctz4un0ptvRf
	 nutjOuOSPcuDehqVh9Oyzc1Nx0TLRjlUgisBrJvhkvwj0iK6QqbpKPy2Ryy/CMI4nY
	 mYHsBTbrA46ZFY2maGmACwLOpxvEZJEDbdd9kdExX1ekmOFz7hgUiWne8SKKSWrpQV
	 Rz4MZw5dbsPNw==
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
Subject: [PATCH 6.1 000/232] 6.1.165-rc1 review
Date: Sat, 28 Feb 2026 13:11:19 -0500
Message-ID: <20260228181119.1592516-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.165-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.165-rc1
X-KernelTest-Deadline: 2026-03-02T18:11+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit


This is the start of the stable review cycle for the 6.1.165 release.
There are 232 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Mar  2 06:11:17 PM UTC 2026.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.1.y&id2=v6.1.164
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Aboorva Devarajan (1):
  cpuidle: Skip governor when only one idle state is available

Adrian Hunter (1):
  i3c: master: Update hot-join flag only on success

Aleksei Oladko (2):
  selftests: forwarding: vxlan_bridge_1d: fix test failure with
    br_netfilter enabled
  selftests: forwarding: vxlan_bridge_1d_ipv6: fix test failure with
    br_netfilter enabled

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

Andreas Gruenbacher (1):
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

Arnd Bergmann (1):
  audit: avoid missing-prototype warnings

Barnabás Czémán (2):
  clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
  backlight: qcom-wled: Support ovp values for PMI8994

Baruch Siach (1):
  Documentation: PCI: endpoint: Fix ntb/vntb copy & paste errors

Ben Dooks (2):
  audit: move the compat_xxx_class[] extern declarations to audit_arch.h
  fs: add <linux/init_task.h> for 'init_fs'

Billy Tsai (1):
  i3c: Move device name assignment after i3c_bus_init

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

Christoph Hellwig (1):
  iomap: fix submission side handling of completion side errors

Christophe Leroy (1):
  powerpc/uaccess: Move barrier_nospec() out of
    allow_read_{from/write}_user()

Chuck Lever (7):
  RDMA/core: Fix a couple of obvious typos in comments
  svcrdma: Remove queue-shortening warnings
  svcrdma: Clean up comment in svc_rdma_accept()
  svcrdma: Increase the per-transport rw_ctx count
  svcrdma: Reduce the number of rdma_rw contexts per-QP
  RDMA/core: add rdma_rw_max_sge() helper for SQ sizing
  SUNRPC: auth_gss: fix memory leaks in XDR decoding error paths

Colin Ian King (1):
  scsi: csiostor: Fix dereference of null pointer rn

Cristian Ciocaltea (3):
  ASoC: nau8821: Consistently clear interrupts before unmasking
  ASoC: nau8821: Avoid unnecessary blocking in IRQ handler
  ASoC: nau8821: Fixup nau8821_enable_jack_detect()

Damien Le Moal (1):
  ata: libata-scsi: refactor ata_scsi_translate()

Dan Carpenter (2):
  EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
  EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()

Daniel Hodges (1):
  SUNRPC: fix gss_auth kref leak in gss_alloc_msg error path

Daniel Machon (2):
  net: sparx5/lan969x: fix DWRR cost max to match hardware register
    width
  net: sparx5/lan969x: fix PTP clock max_adj value

David Heidelberg (1):
  media: ccs: Accommodate C-PHY into the calculation

Deepanshu Kartikey (1):
  gfs2: Fix use-after-free in iomap inline data write path

Dmitry Baryshkov (5):
  arm64: dts: qcom: sdm630: fix gpu_speed_bin size
  arm64: dts: qcom: sdm845-db845c: drop CS from SPIO0
  arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
  drm/msm/dpu: fix CMD panels on DPU 1.x - 3.x
  clk: qcom: gfx3d: add parent to parent request map

Dmytro Maluka (1):
  iommu/vt-d: Flush cache for PASID table before using it

Edward Adam Davis (1):
  fs/ntfs3: prevent infinite loops caused by the next valid being the
    same

Eric Dumazet (4):
  tcp: tcp_tx_timestamp() must look at the rtx queue
  ipv6: fix a race in ip6_sock_set_v6only()
  inet: ping: check sock_net() in ping_get_port() and ping_lookup()
  ping: annotate data-races in ping_lookup()

Eric Joyner (1):
  ionic: Rate limit unknown xcvr type messages

Etienne AUJAMES (1):
  IB/cache: update gid cache on client reregister event

Felix Gu (2):
  fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
  pinctrl: equilibrium: Fix device node reference leak in pinbank_init()

Fernando Fernandez Mancera (3):
  netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
  netfilter: nf_conncount: increase the connection clean up limit to 64
  netfilter: nf_conncount: fix tracking of connections from localhost

Filipe Manana (1):
  btrfs: qgroup: return correct error when deleting qgroup relation item

Florian Westphal (3):
  netfilter: nft_compat: add more restrictions on netlink attributes
  netfilter: nft_set_hash: fix get operation on big endian
  netfilter: nf_conntrack_h323: don't pass uninitialised l3num value

Francesco Lavra (1):
  spi: tools: Add include folder to .gitignore

Geert Uytterhoeven (1):
  clk: Move clk_{save,restore}_context() to COMMON_CLK section

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

Guoqing Jiang (2):
  RDMA/rtrs-srv: Refactor the handling of failure case in map_cont_bufs
  RDMA/rtrs-srv: Correct the checking of ib_map_mr_sg

Gustavo A. R. Silva (1):
  scsi: smartpqi: Replace one-element arrays with flexible-array members

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

Håkon Bugge (2):
  PCI: Do not attempt to set ExtTag for VFs
  PCI: Initialize RCB from pci_configure_device()

Ido Schimmel (1):
  selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2

Inseo An (1):
  netfilter: nf_tables: fix use-after-free in nf_tables_addchain()

Jakub Kicinski (1):
  bpftool: Fix truncated netlink dumps

Jan Kara (1):
  ext4: use optimized mballoc scanning regardless of inode format

Jens Axboe (6):
  io_uring/sync: validate passed in offset
  io_uring/cancel: abstract out request match helper
  io_uring/cancel: fix sequence matching for IORING_ASYNC_CANCEL_ANY
  io_uring/cancel: add IORING_ASYNC_CANCEL_USERDATA
  io_uring/cancel: support opcode based lookup and cancelation
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

Jiayuan Chen (4):
  bpf, sockmap: Fix incorrect copied_seq calculation
  net: atm: fix crash due to unvalidated vcc pointer in sigd_send()
  xfrm: fix ip_rt_bug race in icmp_route_lookup reverse path
  serial: caif: fix use-after-free in caif_serial ldisc_close()

Jinliang Zheng (1):
  procfs: fix missing RCU protection when reading real_parent in
    do_task_stat()

Jorge Ramirez-Ortiz (1):
  soc: qcom: smem: handle ENOMEM error during probe

Justin Chen (1):
  usb: bdc: fix sleep during atomic

Jörg Wedekind (1):
  PCI: Mark 3ware-9650SA Root Port Extended Tags as broken

Kai Ye (1):
  crypto: hisilicon/sec - fix spelling mistake 'ckeck' -> 'check'

Konstantin Andreev (2):
  smack: /smack/doi must be > 0
  smack: /smack/doi: accept previously used values

Kuniyuki Iwashima (1):
  ping: Convert hlist_nulls to plain hlist.

Li Chen (1):
  nvdimm: virtio_pmem: serialize flush requests

Li Nan (1):
  md/raid10: fix any_working flag handling in raid10_sync_request

Linus Walleij (1):
  ata: pata_ftide010: Fix some DMA timings

Luca Weiss (1):
  pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition

Mario Limonciello (AMD) (1):
  crypto: ccp - Add an S4 restore flow

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

Miri Korenblit (1):
  wifi: cfg80211: stop NAN and P2P in cfg80211_leave

Narayana Murty N (1):
  powerpc/eeh: fix recursive pci_lock_rescan_remove locking in EEH event
    handling

Nicolas Cavallari (1):
  PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]

Nuno Sá (1):
  dma: dma-axi-dmac: fix SW cyclic transfers

Oleksandr Tyshchenko (2):
  xen/virtio: Optimize the setup of "xen-grant-dma" devices
  xen/virtio: Handle PCI devices which Host controller is described in
    DT

Olga Kornievskaia (1):
  pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN

Ondrej Mosnacek (2):
  ipc: don't audit capability check in ipc_permissions()
  ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()

Pablo Neira Ayuso (2):
  netfilter: nft_set_rbtree: check for partial overlaps in anonymous
    sets
  net: remove WARN_ON_ONCE when accessing forward path array

Paul Chaignon (1):
  bpf: Fix bpf_xdp_store_bytes proto for read-only arg

Paulo Alcantara (1):
  smb: client: fix potential UAF and double free in smb2_open_file()

Petr Hodina (1):
  clk: qcom: dispcc-sdm845: Enable parents for pixel clocks

Petr Mladek (2):
  module: add helper function for reading module_buildid()
  kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()

Puranjay Mohan (1):
  selftests/bpf: veristat: fix printing order in output_stats()

Qi Tao (1):
  crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
    queue unavailable

Qing Wang (1):
  ovl: Fix uninit-value in ovl_fill_real

Randy Dunlap (2):
  serial: imx: change SERIAL_IMX_CONSOLE to bool
  serial: SH_SCI: improve "DMA support" prompt

Ricardo Ribalda (1):
  media: uvcvideo: Fix allocation for small frame sizes

Rob Herring (1):
  soc: mediatek: mtk-svs: Add explicit include for cpu.h

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
  Linux 6.1.165-rc1

Sean V Kelley (1):
  ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs

Sebastian Andrzej Siewior (3):
  scsi: efct: Use IRQF_ONESHOT and default primary handler
  EDAC/altera: Remove IRQF_ONESHOT
  mfd: wm8350-core: Use IRQF_ONESHOT

Shardul Bankar (1):
  hfsplus: return error when node already exists in hfs_bnode_create

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

Tzung-Bi Shih (1):
  platform/chrome: cros_ec_lightbar: Fix response size initialization

Uwe Kleine-König (1):
  PCI/portdrv: Fix potential resource leak

Varun R Mallya (1):
  libbpf: Fix OOB read in btf_dump_get_bitfield_value

Vladimir Zapolskiy (2):
  ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
  arm: dts: lpc32xx: add clocks property to Motor Control PWM device
    tree node

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

Wenkai Lin (1):
  crypto: hisilicon/sec2 - fix for sec spec check

Yang Shen (2):
  crypto: hisilicon/zip - support deflate algorithm
  crypto: hisilicon/zip - remove zlib and gzip

Yao Zi (1):
  MIPS: Work around LLVM bug when gp is used as global register variable

Yi Liu (2):
  RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
  RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc

YunJe Shin (2):
  RDMA/siw: Fix potential NULL pointer dereference in header processing
  RDMA/umad: Reject negative data_len in ib_umad_write

Yuxiong Wang (1):
  cxl: Fix premature commit_end increment on decoder commit failure

Zhai Can (1):
  ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO

Zhang Yi (1):
  ext4: don't cache extent during splitting extent

Zhiyu Zhang (1):
  fat: avoid parent link count underflow in rmdir

Zilin Guan (3):
  soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()
  scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()
  ext4: fix memory leak in ext4_ext_shift_extents()

Ziyi Guo (6):
  wifi: ath10k: sdio: add missing lock protection in
    ath10k_sdio_fw_crashed_dump()
  net: mscc: ocelot: extract ocelot_xmit_timestamp() helper
  net: mscc: ocelot: split xmit into FDMA and register injection paths
  net: mscc: ocelot: add missing lock protection in
    ocelot_port_xmit_inj()
  net: usb: catc: enable basic endpoint checking
  xen-netback: reject zero-queue configuration from guest

ye xingchen (1):
  timers: Replace in_irq() with in_hardirq()

 Documentation/PCI/endpoint/pci-vntb-howto.rst |  14 +-
 Makefile                                      |   4 +-
 arch/arm/boot/dts/lpc32xx.dtsi                |   3 +-
 arch/arm/boot/dts/sun5i-a13-utoo-p66.dts      |   1 +
 arch/arm/kernel/vdso.c                        |   1 +
 arch/arm/xen/enlighten.c                      |   2 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   6 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi   |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   9 +
 .../freescale/imx8mp-tqma8mpql-mba8mpxl.dts   |   2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |   4 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts    |   8 +-
 .../boot/dts/qcom/sdm845-oneplus-common.dtsi  |   3 +-
 arch/mips/kernel/relocate.c                   |  13 +
 arch/powerpc/include/asm/eeh.h                |   2 +
 arch/powerpc/include/asm/kup.h                |   2 -
 arch/powerpc/include/asm/uaccess.h            |   4 +
 arch/powerpc/kernel/eeh_driver.c              |  11 +-
 arch/powerpc/kernel/eeh_pe.c                  |  74 ++++-
 drivers/acpi/acpica/evregion.c                |   4 +-
 drivers/acpi/cppc_acpi.c                      |   4 +-
 drivers/acpi/power.c                          |  13 +
 drivers/ata/libata-scsi.c                     |  81 +++--
 drivers/ata/pata_ftide010.c                   |   6 +-
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
 drivers/clk/qcom/gcc-msm8953.c                |   1 -
 drivers/cpuidle/cpuidle.c                     |  10 +
 drivers/crypto/cavium/cpt/cptvf_main.c        |   3 +-
 drivers/crypto/ccp/psp-dev.c                  |  11 +
 drivers/crypto/ccp/sp-dev.c                   |  12 +
 drivers/crypto/ccp/sp-dev.h                   |   3 +
 drivers/crypto/ccp/sp-pci.c                   |  16 +-
 drivers/crypto/ccp/tee-dev.c                  |   5 +
 drivers/crypto/ccp/tee-dev.h                  |   1 +
 drivers/crypto/hisilicon/sec2/sec.h           |   1 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c    | 163 +++++-----
 drivers/crypto/hisilicon/trng/trng.c          | 123 ++++---
 drivers/crypto/hisilicon/zip/zip_crypto.c     | 302 +++---------------
 drivers/crypto/hisilicon/zip/zip_main.c       |   4 +-
 .../crypto/marvell/octeontx/otx_cptvf_main.c  |   3 +-
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c |  10 +
 drivers/cxl/core/hdm.c                        |   3 +-
 drivers/dma/dma-axi-dmac.c                    |   3 +-
 drivers/dma/mediatek/mtk-uart-apdma.c         |  10 +-
 drivers/edac/altera_edac.c                    |  11 +-
 drivers/edac/i5000_edac.c                     |   1 +
 drivers/edac/i5400_edac.c                     |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c         |  45 +--
 .../drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c  |   7 +-
 drivers/hid/hid-playstation.c                 |   4 +-
 drivers/hwmon/ibmpex.c                        |   9 +-
 .../coresight/coresight-etm3x-core.c          |  12 +-
 drivers/i3c/master.c                          |   6 +-
 drivers/iio/accel/sca3000.c                   |   6 +-
 drivers/iio/gyro/mpu3050-core.c               |   6 +-
 drivers/infiniband/core/cache.c               |   3 +-
 drivers/infiniband/core/rw.c                  |  53 ++-
 drivers/infiniband/core/user_mad.c            |   8 +-
 drivers/infiniband/core/uverbs_cmd.c          |   7 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  26 +-
 drivers/infiniband/sw/rxe/rxe_srq.c           |   3 +
 drivers/infiniband/sw/siw/siw_qp_rx.c         |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c        |  80 ++---
 drivers/iommu/intel/pasid.c                   |   7 +-
 drivers/leds/rgb/leds-qcom-lpg.c              |   8 +-
 drivers/md/dm.c                               |   2 +
 drivers/md/raid10.c                           |   2 +-
 drivers/media/i2c/ccs/ccs-core.c              |  16 +-
 drivers/media/usb/uvc/uvc_video.c             |   3 +-
 drivers/mfd/arizona-core.c                    |   2 +-
 .../mtd/nand/raw/cadence-nand-controller.c    |   2 +-
 drivers/mtd/parsers/ofpart_core.c             |  16 +-
 drivers/net/bonding/bond_main.c               |  15 +-
 drivers/net/caif/caif_serial.c                |   5 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  11 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  11 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   1 +
 .../ethernet/microchip/sparx5/sparx5_ptp.c    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_qos.h    |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  75 +++--
 .../ethernet/pensando/ionic/ionic_ethtool.c   |   7 +-
 drivers/net/mctp/mctp-i2c.c                   |   9 +
 drivers/net/usb/catc.c                        |  37 ++-
 drivers/net/wireless/ath/ath10k/sdio.c        |   6 +
 drivers/net/xen-netback/xenbus.c              |   5 +-
 drivers/nvdimm/nd_virtio.c                    |   3 +-
 drivers/nvdimm/virtio_pmem.c                  |   1 +
 drivers/nvdimm/virtio_pmem.h                  |   4 +
 drivers/pci/controller/pcie-mediatek.c        |   4 +-
 drivers/pci/pci.c                             |   3 +
 drivers/pci/pcie/portdrv_core.c               |   6 +-
 drivers/pci/probe.c                           |  35 +-
 drivers/pci/quirks.c                          |   5 +
 drivers/pinctrl/pinctrl-equilibrium.c         |   1 +
 drivers/pinctrl/pinctrl-single.c              |   2 +
 .../pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c   |   2 +-
 drivers/platform/chrome/cros_ec_lightbar.c    |   2 +-
 drivers/platform/chrome/cros_typec_switch.c   |   6 +-
 drivers/power/reset/nvmem-reboot-mode.c       |  15 +-
 drivers/power/supply/ab8500_charger.c         |  40 +--
 drivers/power/supply/act8945a_charger.c       |  16 +-
 drivers/power/supply/bq256xx_charger.c        |  12 +-
 drivers/power/supply/bq25980_charger.c        |  12 +-
 drivers/power/supply/bq27xxx_battery.c        |   6 +-
 drivers/power/supply/cpcap-battery.c          |   8 +-
 drivers/power/supply/goldfish_battery.c       |  12 +-
 drivers/power/supply/rt9455_charger.c         |  17 +-
 drivers/power/supply/sbs-battery.c            |  36 +--
 drivers/power/supply/wm97xx_battery.c         |  34 +-
 drivers/regulator/core.c                      |  55 ++--
 drivers/s390/cio/css.c                        |   2 +-
 drivers/scsi/csiostor/csio_scsi.c             |   3 +-
 drivers/scsi/elx/efct/efct_driver.c           |   8 +-
 drivers/scsi/smartpqi/smartpqi.h              |   4 +-
 drivers/scsi/smartpqi/smartpqi_init.c         |  18 +-
 drivers/soc/mediatek/mtk-svs.c                |   6 +-
 drivers/soc/qcom/cmd-db.c                     |   7 +-
 drivers/soc/qcom/smem.c                       |   4 +-
 drivers/staging/greybus/light.c               |   8 +-
 drivers/tty/serial/Kconfig                    |   8 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c         |   4 +-
 drivers/video/backlight/qcom-wled.c           |  41 ++-
 drivers/video/fbdev/au1200fb.c                |   6 +-
 drivers/xen/grant-dma-ops.c                   | 106 +++---
 fs/btrfs/qgroup.c                             |   4 +-
 fs/btrfs/transaction.c                        |   7 -
 fs/ext4/extents.c                             |   9 +-
 fs/ext4/mballoc.c                             |   2 -
 fs/fat/namei_msdos.c                          |   7 +-
 fs/fat/namei_vfat.c                           |   7 +-
 fs/fs_struct.c                                |   1 +
 fs/gfs2/bmap.c                                |  21 +-
 fs/hfsplus/bnode.c                            |   2 +-
 fs/iomap/direct-io.c                          |  10 +-
 fs/nfs/dir.c                                  |   4 +-
 fs/nfs/pnfs.c                                 |   3 +-
 fs/nfsd/nfs4idmap.c                           |  48 ++-
 fs/nfsd/nfs4proc.c                            |   2 -
 fs/nfsd/nfs4xdr.c                             |  16 +
 fs/ntfs3/file.c                               |   8 +-
 fs/ntfs3/fslog.c                              |   3 +
 fs/overlayfs/readdir.c                        |   2 +-
 fs/proc/array.c                               |   2 +-
 fs/pstore/ram_core.c                          |  11 +
 fs/smb/client/smb2file.c                      |   2 +
 fs/smb/client/smbdirect.c                     |  19 +-
 include/linux/audit.h                         |   8 -
 include/linux/audit_arch.h                    |   9 +
 include/linux/capability.h                    |   6 +
 include/linux/clk.h                           |  48 +--
 include/linux/ftrace.h                        |   6 +-
 include/linux/mfd/wm8350/core.h               |   2 +-
 include/linux/module.h                        |   9 +
 include/linux/skbuff.h                        |  32 ++
 include/linux/skmsg.h                         |   2 +
 include/linux/u64_stats_sync.h                |  10 +
 include/net/ipv6.h                            |  11 +-
 include/net/netfilter/nf_conntrack_count.h    |   1 +
 include/rdma/ib_verbs.h                       |   2 +-
 include/rdma/rw.h                             |   2 +
 include/uapi/linux/io_uring.h                 |   4 +
 include/xen/arm/xen-ops.h                     |   4 +-
 include/xen/xen-ops.h                         |  16 -
 io_uring/cancel.c                             |  49 ++-
 io_uring/cancel.h                             |   9 +-
 io_uring/poll.c                               |   3 +-
 io_uring/sync.c                               |   2 +
 ipc/ipc_sysctl.c                              |   2 +-
 kernel/audit.h                                |   2 +-
 kernel/kallsyms.c                             |   4 +-
 kernel/module/kallsyms.c                      |   9 +-
 kernel/sched/rt.c                             |   5 +
 kernel/time/hrtimer.c                         |   2 +-
 kernel/time/timer.c                           |   2 +-
 kernel/trace/ftrace.c                         |   5 +-
 kernel/trace/trace_events.c                   |   5 -
 kernel/trace/trace_events_hist.c              |   2 +-
 kernel/ucount.c                               |   2 +-
 net/atm/signaling.c                           |  56 +++-
 net/core/dev.c                                |   2 +-
 net/core/filter.c                             |   2 +-
 net/core/skmsg.c                              |  27 +-
 net/ipv4/icmp.c                               |  22 +-
 net/ipv4/ip_options.c                         |   5 +-
 net/ipv4/ping.c                               |  86 ++---
 net/ipv4/tcp.c                                |   3 +
 net/ipv4/tcp_bpf.c                            |   5 +-
 net/netfilter/nf_conncount.c                  |  54 +++-
 net/netfilter/nf_conntrack_h323_main.c        |  10 +-
 net/netfilter/nf_tables_api.c                 |   1 +
 net/netfilter/nft_compat.c                    |  13 +-
 net/netfilter/nft_connlimit.c                 |   7 +-
 net/netfilter/nft_counter.c                   |   4 +-
 net/netfilter/nft_set_hash.c                  |   9 +-
 net/netfilter/nft_set_rbtree.c                |  30 +-
 net/nfc/hci/llc_shdlc.c                       |   8 +
 net/rds/send.c                                |   6 +-
 net/sunrpc/auth_gss/auth_gss.c                |   3 +
 net/sunrpc/auth_gss/gss_rpc_xdr.c             |  82 +++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c      |  43 ++-
 net/wireless/core.c                           |   4 +-
 security/smack/smackfs.c                      |  79 +++--
 sound/soc/codecs/nau8821.c                    |  85 ++---
 sound/soc/codecs/nau8821.h                    |   3 +-
 tools/bpf/bpftool/net.c                       |   5 +-
 tools/lib/bpf/btf_dump.c                      |   9 +
 tools/lib/bpf/netlink.c                       |   4 +-
 tools/spi/.gitignore                          |   1 +
 tools/testing/selftests/bpf/veristat.c        |   2 +-
 .../drivers/net/mlxsw/tc_restrictions.sh      |   4 +-
 .../net/forwarding/vxlan_bridge_1d.sh         |  26 +-
 .../net/forwarding/vxlan_bridge_1d_ipv6.sh    |   2 +-
 223 files changed, 2096 insertions(+), 1217 deletions(-)

-- 
2.51.0

