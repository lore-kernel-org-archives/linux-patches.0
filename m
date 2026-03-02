Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD5740F8F4;
	Mon,  2 Mar 2026 16:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467799; cv=none; b=cuT2lp+kzXQudMadbSL04PRZkcv2vktPwuGxIwFvK/anKaXE2hzshDeLnpFd6x3H2VibSmFFZTcPDzDDaMAqeMLu0yqJxbk2+ctmujbmOhg5nm/aZVfXAPrJXJQ32L1Yte5AhvYmvNiopHYRLa/pybaH/YX06cCmReyywa2rBBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467799; c=relaxed/simple;
	bh=1POk3Q4XS39Xm8bmpEIxInzjXCFUrSazvH2zg6tdS7I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SdC9L6U6pM6Dr/vBaGKu2uYkjTFoDz8J0kU6JWqnv2LFes6aqOMkNmhL/80/cwzuv3i+ZxMx03BNID2PfwTvcZ1CHuYaNiOtvKE6LmsGM0Z6Yezp5ZK4Qu3x76ylNUpqgm+kx4GInXsY5P2JMBXNQw+SCyeregCvJuGg9jxRo1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Df9V7t5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Df9V7t5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D411C2BC86;
	Mon,  2 Mar 2026 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772467799;
	bh=1POk3Q4XS39Xm8bmpEIxInzjXCFUrSazvH2zg6tdS7I=;
	h=From:To:Cc:Subject:Date:From;
	b=Df9V7t5pzzwdHWxjkcMsI3DtW+kj/UduBezr9Eodiwz5UXrnCObA7PyzewTxz6xkx
	 SWY+j8kxxKaFyDxtHK/23hmr2wiB1xnS5/MgMhySPD2lfws383b37vsX2YRTv/CVot
	 3SPkwFrIXHyLGRzf3KrMvAxJCI5nlX5Oy8Z2SWqcQjIV8W7nYGiI886TnO0c9S1a5M
	 H7tIqTwyPedPmsHlgQWKbLp7EeiTJjcvPdugOt26+ReBeeWUqIsSKH+rYDQmXe7wta
	 sxOygg+ZrzNV3v9gCxaMj1QpJoMriYGmQqgXOISNNMVJGWxBiqO8jaqBCGu0A9Blcv
	 LoB03FbaAUT5Q==
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
Subject: [PATCH 5.15 000/410] 5.15.202-rc2 review
Date: Mon,  2 Mar 2026 11:09:55 -0500
Message-ID: <20260302160955.2522727-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.202-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.202-rc2
X-KernelTest-Deadline: 2026-03-04T16:09+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit


This is the start of the stable review cycle for the 5.15.202 release.
There are 410 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Mar  4 04:09:54 PM UTC 2026.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.15.y&id2=v5.15.201
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Abdun Nihaal (2):
  media: i2c/tw9903: Fix potential memory leak in tw9903_probe()
  media: i2c/tw9906: Fix potential memory leak in tw9906_probe()

Aboorva Devarajan (1):
  cpuidle: Skip governor when only one idle state is available

Adarsh Das (1):
  btrfs: replace BUG() with error handling in __btrfs_balance()

Aleksandar Gerasimovski (1):
  phy: mvebu-cp110-utmi: fix dr_mode property read from dts

Aleksei Oladko (1):
  selftests: forwarding: vxlan_bridge_1d: fix test failure with
    br_netfilter enabled

Alex Deucher (1):
  drm/amdgpu: keep vga memory on MacBooks with switchable graphics

Alex Williamson (1):
  PCI: Mark ASM1164 SATA controller to avoid bus reset

Alexander Grest (1):
  iommu/arm-smmu-v3: Improve CMDQ lock fairness and efficiency

Alexander Koskovich (1):
  power: reset: nvmem-reboot-mode: respect cell size for
    nvmem_cell_write

Allison Henderson (1):
  net/rds: rds_sendmsg should not discard payload_len

Alok Tiwari (1):
  mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper

Alper Ak (2):
  tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
  tpm: st33zp24: Fix missing cleanup on get_burstcount() error

Andrea Scian (1):
  mtd: rawnand: pl353: Fix software ECC support

Andreas Gruenbacher (2):
  gfs2: Add metapath_dibh helper
  gfs2: fiemap page fault fix

Andreas Larsson (1):
  sparc: Synchronize user stack on fork and clone

André Draszik (1):
  regulator: core: move supply check earlier in
    set_machine_constraints()

AngeloGioacchino Del Regno (1):
  dmaengine: mediatek: uart-apdma: Fix above 4G addressing TX/RX

Anshumali Gaur (1):
  octeontx2-af: Fix PF driver crash with kexec kernel booting

Anthony Iliopoulos (2):
  nfsd: never defer requests during idmap lookup
  nfsd: fix return error code for nfsd_map_name_to_[ug]id

Anthony Pighin (Nokia) (1):
  rtc: interface: Alarm race handling should not discard preceding error

Antonio Borneo (1):
  coresight: etm3x: Fix cpulocked warning on cpuhp

Antoniu Miclaus (1):
  iio: gyro: itg3200: Fix unchecked return value in read_raw

Armin Wolf (1):
  ACPICA: Abort AML bytecode execution when executing AML_FATAL_OP

Arnd Bergmann (3):
  vmw_vsock: bypass false-positive Wnonnull warning with gcc-16
  myri10ge: avoid uninitialized variable use
  scsi: buslogic: Reduce stack usage

Artem Shimko (1):
  serial: 8250_dw: handle clock enable errors in runtime_resume

Barnabás Czémán (2):
  clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
  backlight: qcom-wled: Support ovp values for PMI8994

Bartosz Golaszewski (1):
  clocksource/drivers/timer-integrator-ap: Add missing Kconfig
    dependency on OF

Ben Dooks (1):
  fs: add <linux/init_task.h> for 'init_fs'

Benjamin Marzinski (1):
  dm mpath: make pg_init_delay_msecs settable

Billy Tsai (2):
  i3c: Move device name assignment after i3c_bus_init
  gpio: aspeed-sgpio: Change the macro to support deferred probe

Breno Leitao (1):
  arm64: Disable branch profiling for all arm64 code

Brian Masney (2):
  openrisc: define arch-specific version of nop()
  clk: microchip: core: correct return value on *_get_parent()

Carl Lee (1):
  nfc: nxp-nci: remove interrupt trigger type

Casey Connolly (2):
  arm64: dts: qcom: sdm845-oneplus: Don't mark ts supply boot-on
  arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on

Ce Sun (1):
  drm/amdgpu: Adjust usleep_range in fence wait

Chaitanya Mishra (1):
  staging: greybus: lights: avoid NULL deref

Chen Jinghuang (1):
  sched/rt: Skip currently executing CPU in rto_next_cpu()

Chen-Yu Tsai (1):
  ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property

Chengchang Tang (1):
  RDMA/hns: Notify ULP of remaining soft-WCs during reset

Chenghai Huang (1):
  crypto: hisilicon/trng - modifying the order of header files

Chin-Ting Kuo (1):
  spi: spi-mem: Protect dirmap_create() with spi_mem_access_start/end

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

Colin Lord (1):
  tracing: Fix false sharing in hwlat get_sample()

Cupertino Miranda (1):
  bpf: verifier improvement in 32bit shift sign extension pattern

Dan Carpenter (2):
  EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
  EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()

Daniel Hodges (2):
  SUNRPC: fix gss_auth kref leak in gss_alloc_msg error path
  tipc: fix RCU dereference race in tipc_aead_users_dec()

Daniel Palmer (1):
  m68k: nommu: fix memmove() with differently aligned src and dest for
    68000

Darrick J. Wong (4):
  xfs: mark data structures corrupt on EIO and ENODATA
  xfs: delete attr leaf freemap entries when empty
  xfs: fix freemap adjustments when adding xattrs to leaf blocks
  xfs: fix remote xattr valuelblk check

David Heidelberg (1):
  media: ccs: Accommodate C-PHY into the calculation

David Phillips (1):
  HID: elecom: Add support for ELECOM HUGE Plus M-HT1MRBK

David Plowman (3):
  media: i2c: ov5647: Correct pixel array offset
  media: i2c: ov5647: Correct minimum VBLANK value
  media: i2c: ov5647: Sensor should report RAW color space

Deepak Kumar (1):
  spi: stm32: fix Overrun issue at < 8bpw

Deepanshu Kartikey (1):
  gfs2: Fix use-after-free in iomap inline data write path

Diksha Kumari (1):
  staging: rtl8723bs: fix memory leak on failure path

Ding Hui (1):
  dm: remove fake timeout to avoid leak request

Diogo Ivo (1):
  arm64: tegra: smaug: Add usb-role-switch support

Dmitry Baryshkov (2):
  arm64: dts: qcom: sdm630: fix gpu_speed_bin size
  arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1

Dmytro Maluka (1):
  iommu/vt-d: Flush cache for PASID table before using it

Donet Tom (1):
  drm/amdkfd: Fix GART PTE for non-4K pagesize in svm_migrate_gart_map()

Duoming Zhou (2):
  net: wan: farsync: Fix use-after-free bugs caused by unfinished
    tasklets
  atm: fore200e: fix use-after-free in tasklets during device removal

Edward Adam Davis (1):
  fs/ntfs3: prevent infinite loops caused by the next valid being the
    same

Eric Biggers (1):
  dm-verity: correctly handle dm_bufio_client_create() failure

Eric Dumazet (5):
  tcp: tcp_tx_timestamp() must look at the rtx queue
  ipv6: fix a race in ip6_sock_set_v6only()
  macvlan: observe an RCU grace period in macvlan_common_newlink() error
    path
  ipv6: annotate data-races in ip6_multipath_hash_{policy,fields}()
  ipv6: exthdrs: annotate data-race over multiple sysctl

Eric Joyner (1):
  ionic: Rate limit unknown xcvr type messages

Ethan Nelson-Moore (3):
  net: usb: sr9700: remove code to drive nonexistent multicast filter
  net: ethernet: marvell: skge: remove incorrect conflicting PCI ID
  net: intel: fix PCI device ID conflict between i40e and ipw2200

Ethan Tidmore (1):
  staging: rtl8723bs: fix null dereference in find_network

Etienne AUJAMES (1):
  IB/cache: update gid cache on client reregister event

Felix Gu (2):
  fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
  pinctrl: equilibrium: Fix device node reference leak in pinbank_init()

Fernando Fernandez Mancera (3):
  netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
  netfilter: nf_conncount: increase the connection clean up limit to 64
  netfilter: nf_conncount: fix tracking of connections from localhost

Filipe Manana (2):
  btrfs: qgroup: return correct error when deleting qgroup relation item
  btrfs: fix invalid leaf access in btrfs_quota_enable() if ref key not
    found

Florian Westphal (3):
  netfilter: nft_set_hash: fix get operation on big endian
  netfilter: nf_conntrack_h323: don't pass uninitialised l3num value
  netfilter: xt_tcpmss: check remaining length before reading optlen

Francesco Lavra (1):
  spi: tools: Add include folder to .gitignore

Frank Li (1):
  i3c: master: svc: Initialize 'dev' to NULL in svc_i3c_master_ibi_isr()

Geert Uytterhoeven (1):
  clk: Move clk_{save,restore}_context() to COMMON_CLK section

Geetha sowjanya (1):
  octeontx2-af: Workaround SQM/PSE stalls by disabling sticky

Georgia Garcia (1):
  apparmor: fix invalid deref of rawdata when export_binary is unset

Gerd Rausch (1):
  net/rds: No shortcut out of RDS_CONN_ERROR

Greg Kroah-Hartman (1):
  Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"

Guangshuo Li (1):
  powerpc/smp: Add check for kcalloc() failure in parse_thread_groups()

Gui-Dong Han (2):
  PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races
  rpmsg: core: fix race in driver_override_show() and use core helper

Guoqing Jiang (2):
  RDMA/rtrs-srv: Refactor the handling of failure case in map_cont_bufs
  RDMA/rtrs-srv: Correct the checking of ib_map_mr_sg

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

Hao Chen (5):
  ethtool: add support to set/get tx copybreak buf size via ethtool
  net: hns3: add support to set/get tx copybreak buf size via ethtool
    for hns3 driver
  net: hns3: remove the way to set tx spare buf via module parameter
  net: hns3: fix ethtool tx copybreak buf size indicating not aligned
    issue
  net: hns3: add max order judgement for tx spare buffer

Haotian Zhang (7):
  clk: qcom: Return correct error code in qcom_cc_probe_by_index()
  soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in
    cmd_db_dev_probe
  HID: playstation: Add missing check for input_ff_create_memless
  PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
  power: supply: bq27xxx: fix wrong errno when bus ops are unsupported
  mfd: arizona: Fix regulator resource leak on
    wm5102_clear_write_sequencer() failure
  jfs: Add missing set_freezable() for freezable kthread

Haotien Hsu (1):
  usb: gadget: tegra-xudc: Add handling for BLCG_COREPLL_PWRDN

Haoxiang Li (10):
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

Harshit Mogalapalli (1):
  iio: sca3000: Fix a resource leak in sca3000_probe()

Heiko Carstens (1):
  s390/purgatory: Add -Wno-default-const-init-unsafe to KBUILD_CFLAGS

Helge Deller (1):
  parisc: Prevent interrupts during reboot

Heming Zhao (1):
  ocfs2: fix reflink preserve cleanup issue

Honggang LI (1):
  RDMA/rtrs: server: remove dead code

Hou Wenlong (1):
  x86/xen/pvh: Enable PAE mode for 32-bit guest only when CONFIG_X86_PAE
    is set

Hsieh Hung-En (1):
  ASoC: es8328: Add error unwind in resume

Håkon Bugge (3):
  PCI: Do not attempt to set ExtTag for VFs
  PCI: Initialize RCB from pci_configure_device()
  net/rds: Clear reconnect pending bit

Ian Rogers (2):
  perf callchain: Fix srcline printing with inlines
  libperf build: Always place libperf includes first

Ido Schimmel (1):
  selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2

Ilya Dryomov (1):
  libceph: define and enforce CEPH_MAX_KEY_LEN

Ilya Leoshkevich (1):
  libbpf: Fix dumping big-endian bitfields

Jack Wang (1):
  md/bitmap: fix GPF in write_page caused by resize race

Jacopo Scannella (1):
  Bluetooth: btusb: Add device ID for Realtek RTL8761BU

Jaehun Gou (3):
  fs: ntfs3: check return value of indx_find to avoid infinite loop
  fs: ntfs3: fix infinite loop in attr_load_runs_range on inconsistent
    metadata
  fs: ntfs3: fix infinite loop triggered by zero-sized ATTR_LIST

Jai Luthra (2):
  media: i2c: ov5647: Initialize subdev before controls
  media: i2c: ov5647: Fix PIXEL_RATE value for VGA mode

Jakub Kicinski (2):
  bpftool: Fix truncated netlink dumps
  net: consume xmit errors of GSO frames

James Clark (1):
  libperf: Don't remove -g when EXTRA_CFLAGS are used

Jamie Iles (1):
  i3c: remove i2c board info from i2c_dev_desc

Jan Kara (1):
  ext4: use optimized mballoc scanning regardless of inode format

Jason Andryuk (1):
  xenbus: Use .freeze/.thaw to handle xenbus devices

Jason Gunthorpe (1):
  RDMA/efa: Fix typo in efa_alloc_mr()

Jeffrey Bencteux (2):
  audit: add fchmodat2() to change attributes class
  audit: add missing syscalls to read class

Jerome Brunet (4):
  arm64: dts: amlogic: axg: assign the MMC signal clocks
  arm64: dts: amlogic: gx: assign the MMC signal clocks
  arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
  arm64: dts: amlogic: g12: assign the MMC A signal clock

Jian Shen (1):
  net: hns3: fix double free issue for tx spare buffer

Jiasheng Jiang (2):
  RDMA/rxe: Fix double free in rxe_srq_from_init
  fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot

Jiaxun Yang (1):
  MIPS: rb532: Fix MMIO UART resource registration

Jiayuan Chen (3):
  net: atm: fix crash due to unvalidated vcc pointer in sigd_send()
  serial: caif: fix use-after-free in caif_serial ldisc_close()
  xfrm6: fix uninitialized saddr in xfrm6_get_saddr()

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

Jiri Pirko (1):
  RDMA/core: Fix stale RoCE GIDs during netdev events at registration

Jisheng Zhang (1):
  usb: dwc2: fix resume failure if dr_mode is host

Johan Hovold (1):
  soc: ti: k3-socinfo: Fix regmap leak on probe failure

Johannes Berg (1):
  wifi: cfg80211: wext: fix IGTK key ID off-by-one

John Efstathiades (1):
  lan78xx: Fix memory allocation bug

John Garry (1):
  MIPS: Loongson: Make cpumask_of_node() robust against NUMA_NO_NODE

John Johansen (2):
  apparmor: fix NULL sock in aa_sock_file_perm
  apparmor: fix rlimit for posix cpu timers

Johnny-CC Chang (1):
  PCI: Mark Nvidia GB10 to avoid bus reset

Jori Koolstra (2):
  minix: Add required sanity checking to minix_check_superblock()
  jfs: nlink overflow in jfs_rename

Jun Yan (1):
  arm64: dts: rockchip: Do not enable hdmi_sound node on Pinebook Pro

Junrui Luo (1):
  dpaa2-switch: validate num_ifs to prevent out-of-bounds write

Justin Chen (1):
  usb: bdc: fix sleep during atomic

Jörg Wedekind (1):
  PCI: Mark 3ware-9650SA Root Port Extended Tags as broken

Kaushlendra Kumar (2):
  drm/i915/acpi: free _DSM package when no connectors
  tools/power cpupower: Reset errno before strtoull()

Kees Cook (1):
  media: solo6x10: Check for out of bounds chip_id

Keith Busch (1):
  PCI: Fix pci_slot_lock () device locking

Kevin Hao (1):
  net: cpsw_new: Fix unnecessary netdev unregistration in cpsw_probe()
    error path

Koichiro Den (1):
  NTB: ntb_transport: Fix too small buffer for debugfs_name

Konstantin Andreev (2):
  smack: /smack/doi must be > 0
  smack: /smack/doi: accept previously used values

Konstantin Komarov (1):
  fs/ntfs3: avoid calling run_get_entry() when run == NULL in
    ntfs_read_run_nb_ra()

Krishna Chaitanya Chundru (1):
  PCI: Add ACS quirk for Qualcomm Hamoa & Glymur

Krzysztof Kozlowski (1):
  arm64: dts: qcom: sdm630: correct QFPROM byte offsets

Kuniyuki Iwashima (1):
  ipv4: fib: Annotate access to struct fib_alias.fa_state.

Li Chen (4):
  nvdimm: virtio_pmem: serialize flush requests
  ext4: mark group add fast-commit ineligible
  ext4: mark group extend fast-commit ineligible
  kexec: derive purgatory entry from symbol

Li Nan (1):
  md/raid10: fix any_working flag handling in raid10_sync_request

Li Wang (1):
  selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs

Liang Jie (1):
  staging: rtl8723bs: fix missing status update on sdio_alloc_irq()
    failure

Lianqin Hu (1):
  ALSA: usb-audio: Add iface reset and delay quirk for AB13X USB Audio

Linus Walleij (4):
  power: supply: ab8500_bmdata: Use standard phandle
  power: supply: ab8500: Use core battery parser
  ata: pata_ftide010: Fix some DMA timings
  net: ethernet: xscale: Check for PTP support properly

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

Luiz Augusto von Dentz (3):
  Bluetooth: L2CAP: Fix invalid response to L2CAP_ECRED_RECONF_REQ
  Bluetooth: L2CAP: Fix response to L2CAP_ECRED_CONN_REQ
  Bluetooth: L2CAP: Fix missing key size check for L2CAP_LE_CONN_REQ

Lukas Wunner (1):
  PCI/AER: Clear stale errors on reporting agents upon probe

Maciej Grochowski (2):
  ntb: ntb_hw_switchtec: Fix array-index-out-of-bounds access
  ntb: ntb_hw_switchtec: Fix shift-out-of-bounds for 0 mw lut

Manikanta Maddireddy (1):
  PCI: endpoint: Fix swapped parameters in
    pci_{primary/secondary}_epc_epf_unlink() functions

Manivannan Sadhasivam (1):
  PCI: Enable ACS after configuring IOMMU for OF platforms

Marco Elver (1):
  arm64: Fix non-atomic __READ_ONCE() with CONFIG_LTO=y

Marcus Folkesson (1):
  Revert "mfd: da9052-spi: Change read-mask to write-mask"

Mario Limonciello (AMD) (1):
  crypto: ccp - Add an S4 restore flow

Markus Perkins (1):
  misc: eeprom: Fix EWEN/EWDS/ERAL commands for 93xx56 and 93xx66

Martin Blumenstingl (1):
  clk: meson: gxbb: Limit the HDMI PLL OD to /4 on GXL/GXM SoCs

Martin Pålsson (1):
  net: usb: lan78xx: scan all MDIO addresses on LAN7801

Masami Hiramatsu (Google) (1):
  tracing: Fix to set write permission to per-cpu buffer_size_kb

Matt Whitlock (1):
  dm-unstripe: fix mapping bug when there are multiple targets in a
    table

Matthew Schwartz (1):
  mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms

Mauro Carvalho Chehab (3):
  EFI/CPER: don't dump the entire memory region
  APEI/GHES: ensure that won't go past CPER allocated record
  EFI/CPER: don't go past the ARM processor CPER record buffer

Md Haris Iqbal (2):
  rnbd-srv: Zero the rsp buffer before using it
  RDMA/rtrs-clt: For conn rejection use actual err number

Michael Liang (1):
  dm: clear cloned request bio pointer when last clone bio completes

Michael Thalmeier (1):
  net: nfc: nci: Fix parameter validation for packet data

Mikulas Patocka (1):
  dm-integrity: fix a typo in the code for write/discard race

Mingj Ye (1):
  net: usb: r8152: fix transmit queue timeout

Miri Korenblit (1):
  wifi: cfg80211: stop NAN and P2P in cfg80211_leave

Moteen Shah (1):
  serial: 8250: 8250_omap.c: Clear DMA RX running status only after DMA
    termination is done

Narayana Murty N (1):
  powerpc/eeh: fix recursive pci_lock_rescan_remove locking in EEH event
    handling

Niklas Schnelle (3):
  s390/pci: Handle futile config accesses of disabled devices directly
  Revert "PCI/IOV: Add PCI rescan-remove locking when enabling/disabling
    SR-IOV"
  PCI/IOV: Fix race between SR-IOV enable/disable and hotplug

Niklas Söderlund (1):
  clocksource/drivers/sh_tmu: Always leave device running after probe

Nuno Sá (1):
  dma: dma-axi-dmac: fix SW cyclic transfers

Olga Kornievskaia (1):
  pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN

Oliver Neukum (1):
  HID: hid-pl: handle probe errors

Ondrej Mosnacek (1):
  ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()

Otto Pflüger (2):
  mailbox: sprd: mask interrupts that are not handled
  mailbox: sprd: clear delivery flag before handling TX done

Pablo Neira Ayuso (2):
  netfilter: nft_set_rbtree: check for partial overlaps in anonymous
    sets
  net: remove WARN_ON_ONCE when accessing forward path array

Peng Fan (1):
  remoteproc: imx_rproc: Fix invalid loaded resource table detection

Petr Hodina (1):
  clk: qcom: dispcc-sdm845: Enable parents for pixel clocks

Phil Sutter (1):
  include: uapi: netfilter_bridge.h: Cover for musl libc

Qanux (1):
  ipv6: ioam: fix heap buffer overflow in __ioam6_fill_trace_data()

Qing Wang (1):
  ovl: Fix uninit-value in ovl_fill_real

Randy Dunlap (2):
  serial: imx: change SERIAL_IMX_CONSOLE to bool
  serial: SH_SCI: improve "DMA support" prompt

Renjiang Han (1):
  media: venus: vdec: fix error state assignment for zero bytesused

René Rebe (3):
  modpost: Amend ppc64 save/restfpr symnames for -Os build
  fix it87_wdt early reboot by reporting running timer
  fbdev: ffb: fix corrupted video output on Sun FFB1

Ricardo Ribalda (1):
  media: uvcvideo: Fix allocation for small frame sizes

Roman Penyaev (1):
  RDMA/rtrs-srv: fix SG mapping

Ruipeng Qi (1):
  pstore: ram_core: fix incorrect success return when vmap() fails

Sai Ritvik Tanksalkar (1):
  pstore/ram: fix buffer overflow in persistent_ram_save_old()

Sakari Ailus (1):
  media: ccs: Avoid possible division by zero

Salah Triki (1):
  s390/cio: Fix device lifecycle handling in css_alloc_subchannel()

Sam James (1):
  sparc: don't reference obsolete termio struct for TC* constants

Samuel Wu (1):
  PM: wakeup: Handle empty list in wakeup_sources_walk_start()

Sasha Levin (1):
  Linux 5.15.202-rc2

Sean Christopherson (1):
  KVM: nSVM: Remove a user-triggerable WARN on nested_svm_load_cr3()
    succeeding

Sean V Kelley (1):
  ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs

Sebastian Andrzej Siewior (7):
  scsi: efct: Use IRQF_ONESHOT and default primary handler
  EDAC/altera: Remove IRQF_ONESHOT
  mfd: wm8350-core: Use IRQF_ONESHOT
  mailbox: bcm-ferxrm-mailbox: Use default primary handler
  char: tpm: cr50: Remove IRQF_ONESHOT
  iio: Use IRQF_NO_THREAD
  iio: magnetometer: Remove IRQF_ONESHOT

Sebastian Krzyszkowiak (2):
  ASoC: wm8962: Add WM8962_ADC_MONOMIX to "3D Coefficients" mask
  ASoC: wm8962: Don't report a microphone if it's shorted to ground on
    plug

Shardul Bankar (1):
  hfsplus: return error when node already exists in hfs_bnode_create

Shaurya Rane (1):
  media: radio-keene: fix memory leak in error path

Srinivasa Rao Mandadapu (3):
  pinctrl: qcom: Update macro name to LPI specific
  pinctrl: qcom: Update lpi pin group custiom functions with framework
    generic functions
  pinctrl: qcom: Extract chip specific LPASS LPI code

Srinivasan Shanmugam (1):
  drm/amdgpu: Use explicit VCN instance 0 in SR-IOV init

Stefan Sørensen (1):
  Bluetooth: hci_conn: use mod_delayed_work for active mode timeout

Steven Rostedt (1):
  tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR
    macros

Sunday Clement (1):
  drm/amdkfd: Fix out-of-bounds write in kfd_event_page_set()

Svyatoslav Ryhel (1):
  drivers: iio: mpu3050: use dev_err_probe for regulator request

Szymon Wilczek (2):
  media: pvrusb2: fix URB leak in pvr2_send_request_ex
  wifi: libertas: fix WARNING in usb_tx_block

Takashi Iwai (2):
  ALSA: usb-audio: Update the number of packets properly at receiving
  ALSA: usb-audio: Add sanity check for OOB writes at silencing

Taniya Das (1):
  clk: qcom: rcg2: compute 2d using duty fraction directly

Tetsuo Handa (1):
  hfsplus: pretend special inodes as regular files

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

Thomas Richter (1):
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

Thorsten Schmelzer (2):
  media: adv7180: fix frame interval in progressive mode
  HID: multitouch: add eGalaxTouch EXC3188 support

Tung Nguyen (1):
  tipc: fix duplicate publication key in tipc_service_insert_publ()

Tuo Li (1):
  ACPI: processor: Fix NULL-pointer dereference in
    acpi_processor_errata_piix4()

Tzung-Bi Shih (2):
  platform/chrome: cros_ec_lightbar: Fix response size initialization
  remoteproc: mediatek: Break lock dependency to `prepare_lock`

Uwe Kleine-König (1):
  PCI/portdrv: Fix potential resource leak

Vahagn Vardanian (1):
  netfilter: nf_conntrack_h323: fix OOB read in decode_choice()

Varun R Mallya (1):
  libbpf: Fix OOB read in btf_dump_get_bitfield_value

Viacheslav Dubeyko (1):
  hfsplus: fix volume corruption issue for generic/498

Vladimir Oltean (1):
  net: ixp4xx_eth: convert to ndo_hwtstamp_get() and ndo_hwtstamp_set()

Vladimir Zapolskiy (2):
  ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
  arm: dts: lpc32xx: add clocks property to Motor Control PWM device
    tree node

Vlastimil Babka (1):
  mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP
    allocations

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

Wentao Liang (1):
  soc: ti: pruss: Fix double free in pruss_clk_mux_setup()

Xiao Kan (1):
  drm: Account property blob allocations to memcg

Xiaolei Wang (2):
  drm/v3d: Set DMA segment size to avoid debug warnings
  media: i2c: ov5647: use our own mutex for the ctrl lock

Xu Yang (1):
  phy: fsl-imx8mq-usb: disable bind/unbind platform driver feature

Yao Zi (1):
  MIPS: Work around LLVM bug when gp is used as global register variable

Yi Liu (2):
  RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
  RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc

Yosry Ahmed (1):
  KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation

Yu Kuai (1):
  blk-mq-debugfs: add missing debugfs_mutex in
    blk_mq_debugfs_register_hctxs()

YunJe Shin (2):
  RDMA/siw: Fix potential NULL pointer dereference in header processing
  RDMA/umad: Reject negative data_len in ib_umad_write

Yuto Hamaguchi (1):
  netfilter: nf_conntrack: Add allow_clash to generic protocol handler

Zhang Yi (1):
  ext4: don't cache extent during splitting extent

Zhiyu Zhang (1):
  fat: avoid parent link count underflow in rmdir

Zilin Guan (1):
  ext4: fix memory leak in ext4_ext_shift_extents()

Ziyi Guo (8):
  wifi: ath10k: sdio: add missing lock protection in
    ath10k_sdio_fw_crashed_dump()
  xen-netback: reject zero-queue configuration from guest
  ASoC: fsl_xcvr: Revert fix missing lock in fsl_xcvr_mode_put()
  wifi: iwlegacy: add missing mutex protection in
    il4965_store_tx_power()
  wifi: iwlegacy: add missing mutex protection in
    il3945_store_measurement()
  wifi: ath10k: fix lock protection in
    ath10k_wmi_event_peer_sta_ps_state_chg()
  net: usb: kaweth: remove TX queue manipulation in kaweth_set_rx_mode
  net: usb: pegasus: enable basic endpoint checking

decce6 (2):
  drm/amdgpu: Add HAINAN clock adjustment
  drm/radeon: Add HAINAN clock adjustment

ethanwu (1):
  ceph: supply snapshot context in ceph_zero_partial_object()

jinbaohong (1):
  btrfs: continue trimming remaining devices on failure

ye xingchen (1):
  timers: Replace in_irq() with in_hardirq()

 Makefile                                      |   4 +-
 arch/arm/boot/dts/lpc32xx.dtsi                |   3 +-
 arch/arm/boot/dts/sun5i-a13-utoo-p66.dts      |   1 +
 arch/arm/kernel/vdso.c                        |   1 +
 arch/arm/mm/physaddr.c                        |   2 +-
 arch/arm64/Kbuild                             |   4 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   6 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi   |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   9 +
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts |   2 +
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |   8 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts    |   7 +
 .../boot/dts/qcom/sdm845-oneplus-common.dtsi  |   2 +-
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts |   4 -
 arch/arm64/include/asm/rwonce.h               |   2 +-
 arch/arm64/kernel/proton-pack.c               |   1 +
 arch/m68k/lib/memmove.c                       |  18 ++
 .../include/asm/mach-loongson64/topology.h    |   2 +-
 arch/mips/kernel/relocate.c                   |  13 +
 arch/mips/rb532/devices.c                     |   5 +-
 arch/openrisc/include/asm/barrier.h           |   2 +
 arch/parisc/kernel/drivers.c                  |   2 +-
 arch/parisc/kernel/process.c                  |   3 +
 arch/powerpc/include/asm/eeh.h                |   2 +
 arch/powerpc/include/asm/kup.h                |   2 -
 arch/powerpc/include/asm/uaccess.h            |   4 +
 arch/powerpc/kernel/eeh_driver.c              |  11 +-
 arch/powerpc/kernel/eeh_pe.c                  |  74 ++++-
 arch/powerpc/kernel/smp.c                     |   2 +
 arch/s390/kernel/perf_cpum_sf.c               |   2 +-
 arch/s390/pci/pci.c                           |  25 +-
 arch/s390/purgatory/Makefile                  |   1 +
 arch/sparc/include/uapi/asm/ioctls.h          |   8 +-
 arch/sparc/kernel/process.c                   |  38 ++-
 arch/x86/kvm/svm/nested.c                     |   3 +-
 arch/x86/kvm/svm/svm.c                        |   5 +-
 arch/x86/platform/pvh/head.S                  |   2 +
 block/blk-mq-debugfs.c                        |   2 +
 drivers/acpi/acpi_processor.c                 |  28 +-
 drivers/acpi/acpica/exoparg3.c                |  46 ++-
 drivers/acpi/apei/ghes.c                      |   6 +-
 drivers/acpi/cppc_acpi.c                      |   4 +-
 drivers/android/binder.c                      |   2 +-
 drivers/android/binder_alloc.c                |   6 +-
 drivers/ata/pata_ftide010.c                   |   6 +-
 drivers/atm/fore200e.c                        |   4 +
 drivers/auxdisplay/arm-charlcd.c              |   2 +-
 drivers/base/power/wakeirq.c                  |   9 +-
 drivers/base/power/wakeup.c                   |   4 +-
 drivers/block/rnbd/rnbd-srv.c                 |   3 +
 drivers/bluetooth/btusb.c                     |   1 +
 drivers/bluetooth/hci_qca.c                   |  24 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c               |   6 +-
 drivers/char/tpm/st33zp24/st33zp24.c          |   6 +-
 drivers/char/tpm/tpm_i2c_infineon.c           |   6 +-
 drivers/char/tpm/tpm_tis_i2c_cr50.c           |   3 +-
 drivers/char/tpm/tpm_tis_spi_cr50.c           |   2 +-
 drivers/clk/meson/gxbb.c                      |  17 +-
 drivers/clk/microchip/clk-core.c              |  25 +-
 drivers/clk/qcom/clk-rcg2.c                   |   6 +-
 drivers/clk/qcom/common.c                     |   2 +-
 drivers/clk/qcom/dispcc-sdm845.c              |   4 +-
 drivers/clk/qcom/gcc-msm8953.c                |   1 -
 drivers/clk/tegra/clk-tegra124-emc.c          |   4 +-
 drivers/clocksource/Kconfig                   |   1 +
 drivers/clocksource/sh_tmu.c                  |  18 --
 drivers/cpuidle/cpuidle.c                     |  10 +
 drivers/crypto/cavium/cpt/cptvf_main.c        |   3 +-
 drivers/crypto/ccp/psp-dev.c                  |  11 +
 drivers/crypto/ccp/sp-dev.c                   |  12 +
 drivers/crypto/ccp/sp-dev.h                   |   3 +
 drivers/crypto/ccp/sp-pci.c                   |  16 +-
 drivers/crypto/ccp/tee-dev.c                  |   5 +
 drivers/crypto/ccp/tee-dev.h                  |   1 +
 drivers/crypto/hisilicon/trng/trng.c          | 123 ++++---
 .../crypto/marvell/octeontx/otx_cptvf_main.c  |   3 +-
 drivers/dma/dma-axi-dmac.c                    |   3 +-
 drivers/dma/mediatek/mtk-uart-apdma.c         |  10 +-
 drivers/edac/altera_edac.c                    |  11 +-
 drivers/edac/i5000_edac.c                     |   1 +
 drivers/edac/i5400_edac.c                     |   2 +-
 drivers/firmware/efi/cper-arm.c               |  12 +-
 drivers/firmware/efi/cper.c                   |   8 +-
 drivers/fpga/dfl.c                            |   2 +-
 drivers/gpio/gpio-aspeed-sgpio.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c       |  10 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c       |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c         |  45 +--
 drivers/gpu/drm/amd/amdkfd/kfd_events.c       |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c      |   2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   2 +-
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c     |   5 +
 .../gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c   |  25 +-
 drivers/gpu/drm/drm_property.c                |   2 +-
 drivers/gpu/drm/i915/display/intel_acpi.c     |   1 +
 drivers/gpu/drm/radeon/si_dpm.c               |   5 +
 drivers/gpu/drm/v3d/v3d_drv.c                 |   2 +
 drivers/hid/Kconfig                           |   1 +
 drivers/hid/hid-elecom.c                      |  16 +
 drivers/hid/hid-ids.h                         |   4 +
 drivers/hid/hid-logitech-hidpp.c              |   2 +-
 drivers/hid/hid-magicmouse.c                  |   5 +
 drivers/hid/hid-multitouch.c                  |   3 +
 drivers/hid/hid-pl.c                          |   7 +-
 drivers/hid/hid-playstation.c                 |   4 +-
 drivers/hid/hid-prodikeys.c                   |   4 +
 drivers/hid/hid-quirks.c                      |   3 +
 .../coresight/coresight-etm3x-core.c          |  12 +-
 drivers/i3c/master.c                          |  21 +-
 drivers/i3c/master/svc-i3c-master.c           |   4 +-
 drivers/iio/accel/bma180.c                    |   5 +-
 drivers/iio/accel/sca3000.c                   |   6 +-
 drivers/iio/adc/ad7766.c                      |   2 +-
 drivers/iio/gyro/itg3200_buffer.c             |   8 +-
 drivers/iio/gyro/itg3200_core.c               |   2 +
 drivers/iio/gyro/mpu3050-core.c               |   6 +-
 drivers/iio/light/si1145.c                    |   2 +-
 drivers/iio/magnetometer/ak8975.c             |   2 +-
 drivers/infiniband/core/cache.c               |  16 +-
 drivers/infiniband/core/core_priv.h           |   3 +
 drivers/infiniband/core/device.c              |  34 +-
 drivers/infiniband/core/rw.c                  |  53 ++-
 drivers/infiniband/core/user_mad.c            |   8 +-
 drivers/infiniband/core/uverbs_cmd.c          |   7 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  23 ++
 drivers/infiniband/sw/rxe/rxe_srq.c           |   3 +
 drivers/infiniband/sw/siw/siw_qp_rx.c         |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |   4 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c        |  80 ++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  31 +-
 drivers/iommu/intel/pasid.c                   |   9 +-
 drivers/mailbox/bcm-flexrm-mailbox.c          |  14 +-
 drivers/mailbox/sprd-mailbox.c                |  20 +-
 drivers/md/dm-integrity.c                     |   2 +-
 drivers/md/dm-mpath.c                         |   2 +-
 drivers/md/dm-rq.c                            |  16 +-
 drivers/md/dm-unstripe.c                      |   2 +-
 drivers/md/dm-verity-fec.c                    |   4 +-
 drivers/md/md-bitmap.c                        |   3 +-
 drivers/md/raid10.c                           |   2 +-
 drivers/media/dvb-core/dmxdev.c               |   8 +-
 drivers/media/dvb-core/dvb_vb2.c              |   5 +-
 drivers/media/i2c/adv7180.c                   |   7 +
 drivers/media/i2c/ccs/ccs-core.c              |  18 +-
 drivers/media/i2c/ov5647.c                    |  24 +-
 drivers/media/i2c/tw9903.c                    |   1 +
 drivers/media/i2c/tw9906.c                    |   1 +
 drivers/media/pci/cx23885/cx23885-alsa.c      |   4 +-
 drivers/media/pci/cx25821/cx25821-alsa.c      |   1 +
 drivers/media/pci/cx25821/cx25821-core.c      |   1 +
 drivers/media/pci/cx88/cx88-alsa.c            |   4 +-
 drivers/media/pci/solo6x10/solo6x10-tw28.c    |   8 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c |  17 +-
 drivers/media/platform/omap3isp/isppreview.c  |  21 +-
 drivers/media/platform/omap3isp/ispvideo.c    |  14 +-
 drivers/media/platform/qcom/venus/vdec.c      |   6 +-
 drivers/media/radio/radio-keene.c             |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c       |   5 +
 drivers/media/usb/uvc/uvc_video.c             |   3 +-
 drivers/mfd/arizona-core.c                    |   2 +-
 drivers/mfd/da9052-spi.c                      |   2 +-
 drivers/misc/eeprom/eeprom_93xx46.c           |  11 +-
 .../mtd/nand/raw/cadence-nand-controller.c    |   2 +-
 drivers/mtd/nand/raw/pl35x-nand-controller.c  |   1 +
 drivers/mtd/parsers/ofpart_core.c             |  16 +-
 drivers/net/bonding/bond_main.c               |  21 +-
 drivers/net/caif/caif_serial.c                |   5 +-
 drivers/net/ethernet/ec_bhf.c                 |   2 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   7 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  44 ++-
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   2 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  57 ++++
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |   5 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  11 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  12 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  41 +--
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   1 +
 drivers/net/ethernet/marvell/skge.c           |   1 -
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  28 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   |   7 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  12 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |  60 ++--
 drivers/net/ethernet/xscale/ptp_ixp46x.c      |   3 +
 drivers/net/macvlan.c                         |   5 +
 drivers/net/usb/Kconfig                       |   1 -
 drivers/net/usb/kaweth.c                      |   2 -
 drivers/net/usb/lan78xx.c                     |  40 +--
 drivers/net/usb/pegasus.c                     |  35 +-
 drivers/net/usb/r8152.c                       |   2 +
 drivers/net/usb/sr9700.c                      |  25 +-
 drivers/net/usb/sr9700.h                      |   7 +-
 drivers/net/wan/farsync.c                     |   2 +
 drivers/net/wan/fsl_ucc_hdlc.c                |   8 +-
 drivers/net/wireless/ath/ath10k/sdio.c        |   6 +
 drivers/net/wireless/ath/ath10k/wmi.c         |   4 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |   8 +-
 .../net/wireless/intel/iwlegacy/3945-mac.c    |   2 +
 .../net/wireless/intel/iwlegacy/4965-mac.c    |   2 +
 .../net/wireless/marvell/libertas/if_usb.c    |   2 +
 drivers/net/xen-netback/xenbus.c              |   5 +-
 drivers/nfc/nxp-nci/i2c.c                     |   2 +-
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c        |  12 +-
 drivers/ntb/ntb_transport.c                   |   4 +-
 drivers/nvdimm/nd_virtio.c                    |   3 +-
 drivers/nvdimm/virtio_pmem.c                  |   1 +
 drivers/nvdimm/virtio_pmem.h                  |   4 +
 drivers/pci/controller/pcie-mediatek.c        |   4 +-
 drivers/pci/endpoint/pci-ep-cfs.c             |   8 +-
 drivers/pci/iov.c                             |   9 +-
 drivers/pci/pci-driver.c                      |   8 +
 drivers/pci/pci.c                             |  37 +--
 drivers/pci/pci.h                             |   1 +
 drivers/pci/pcie/aer.c                        |  26 +-
 drivers/pci/pcie/portdrv_core.c               |   6 +-
 drivers/pci/probe.c                           |  35 +-
 drivers/pci/quirks.c                          |  23 ++
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c    |   1 +
 drivers/phy/marvell/phy-mvebu-cp110-utmi.c    |   2 +-
 drivers/pinctrl/pinctrl-equilibrium.c         |   1 +
 drivers/pinctrl/pinctrl-single.c              |   2 +
 drivers/pinctrl/qcom/Kconfig                  |  10 +
 drivers/pinctrl/qcom/Makefile                 |   1 +
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c      | 301 +++---------------
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.h      |  85 +++++
 .../pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c   | 163 ++++++++++
 drivers/platform/chrome/cros_ec_lightbar.c    |   2 +-
 drivers/power/reset/nvmem-reboot-mode.c       |  15 +-
 drivers/power/supply/ab8500-bm.h              |   3 +-
 drivers/power/supply/ab8500_bmdata.c          |  32 +-
 drivers/power/supply/ab8500_charger.c         |  56 ++--
 drivers/power/supply/act8945a_charger.c       |  16 +-
 drivers/power/supply/bq256xx_charger.c        |  12 +-
 drivers/power/supply/bq25980_charger.c        |  12 +-
 drivers/power/supply/bq27xxx_battery.c        |   6 +-
 drivers/power/supply/cpcap-battery.c          |   8 +-
 drivers/power/supply/goldfish_battery.c       |  12 +-
 drivers/power/supply/rt9455_charger.c         |  17 +-
 drivers/power/supply/sbs-battery.c            |  36 +--
 drivers/power/supply/wm97xx_battery.c         |  34 +-
 drivers/rapidio/rio-scan.c                    |   3 +-
 drivers/regulator/core.c                      |  55 ++--
 drivers/remoteproc/imx_rproc.c                |   4 +
 drivers/remoteproc/mtk_scp.c                  |  39 ++-
 drivers/remoteproc/mtk_scp_ipi.c              |   4 +-
 drivers/rpmsg/rpmsg_core.c                    |  66 ++--
 drivers/rtc/interface.c                       |   2 +-
 drivers/s390/cio/css.c                        |   2 +-
 drivers/scsi/BusLogic.c                       |   6 +-
 drivers/scsi/csiostor/csio_scsi.c             |   3 +-
 drivers/scsi/elx/efct/efct_driver.c           |   8 +-
 drivers/scsi/ufs/ufshcd.c                     |   2 +
 drivers/soc/qcom/cmd-db.c                     |   7 +-
 drivers/soc/ti/k3-socinfo.c                   |   2 +-
 drivers/soc/ti/pruss.c                        |   6 +-
 drivers/spi/spi-mem.c                         |  11 +-
 drivers/spi/spi-stm32.c                       |   9 +-
 drivers/staging/greybus/light.c               |   8 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c     |   6 +-
 .../staging/rtl8723bs/os_dep/ioctl_cfg80211.c |   3 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c  |   3 +-
 drivers/tty/serial/8250/8250_dw.c             |  11 +-
 drivers/tty/serial/8250/8250_omap.c           |   2 +-
 drivers/tty/serial/Kconfig                    |   8 +-
 drivers/usb/dwc2/core.c                       |   1 +
 drivers/usb/gadget/udc/bdc/bdc_core.c         |   4 +-
 drivers/usb/gadget/udc/tegra-xudc.c           |  12 +-
 drivers/video/backlight/qcom-wled.c           |  41 ++-
 drivers/video/fbdev/au1200fb.c                |   6 +-
 drivers/video/fbdev/ffb.c                     |  14 +-
 drivers/video/fbdev/vt8500lcdfb.c             |   5 +-
 drivers/video/of_display_timing.c             |   4 +-
 drivers/watchdog/it87_wdt.c                   |  12 +
 drivers/xen/xenbus/xenbus_probe_frontend.c    |   4 +-
 fs/btrfs/extent-tree.c                        |   2 +-
 fs/btrfs/qgroup.c                             |  15 +-
 fs/btrfs/volumes.c                            |  10 +-
 fs/ceph/file.c                                |  17 +-
 fs/ext4/extents.c                             |   9 +-
 fs/ext4/ioctl.c                               |   3 +
 fs/ext4/mballoc.c                             |   2 -
 fs/fat/namei_msdos.c                          |   7 +-
 fs/fat/namei_vfat.c                           |   7 +-
 fs/fs_struct.c                                |   1 +
 fs/gfs2/bmap.c                                |  21 +-
 fs/gfs2/inode.c                               |  16 +
 fs/hfsplus/bnode.c                            |   2 +-
 fs/hfsplus/inode.c                            |  12 +-
 fs/hfsplus/super.c                            |   6 +
 fs/iomap/direct-io.c                          |  10 +-
 fs/jfs/jfs_logmgr.c                           |   1 +
 fs/jfs/namei.c                                |   6 +-
 fs/minix/inode.c                              |  50 +--
 fs/nfs/pnfs.c                                 |   3 +-
 fs/nfsd/nfs4idmap.c                           |  52 ++-
 fs/nfsd/nfs4proc.c                            |   2 -
 fs/nfsd/nfs4xdr.c                             |  16 +
 fs/ntfs3/attrib.c                             |  15 +-
 fs/ntfs3/attrlist.c                           |   9 +
 fs/ntfs3/file.c                               |   8 +-
 fs/ntfs3/fslog.c                              |   3 +
 fs/ntfs3/fsntfs.c                             |   6 +
 fs/ntfs3/index.c                              |   7 +-
 fs/ocfs2/xattr.c                              |   4 +
 fs/overlayfs/readdir.c                        |   2 +-
 fs/proc/array.c                               |   2 +-
 fs/pstore/ram_core.c                          |  18 ++
 fs/xfs/libxfs/xfs_attr_leaf.c                 |  49 ++-
 fs/xfs/scrub/attr.c                           |   5 +-
 fs/xfs/scrub/btree.c                          |   2 +
 fs/xfs/scrub/common.c                         |   4 +
 fs/xfs/scrub/dabtree.c                        |   2 +
 include/acpi/ghes.h                           |   1 +
 include/asm-generic/audit_change_attr.h       |   3 +
 include/asm-generic/audit_read.h              |   6 +
 include/drm/drm_of.h                          |   3 +
 include/linux/clk.h                           |  48 +--
 include/linux/cper.h                          |   3 +-
 include/linux/i3c/master.h                    |   1 -
 include/linux/mfd/wm8350/core.h               |   2 +-
 include/media/dvb_vb2.h                       |   6 +-
 include/net/bluetooth/l2cap.h                 |   2 +
 include/net/ioam6.h                           |   2 +
 include/net/ipv6.h                            |  15 +-
 include/net/netfilter/nf_conntrack_count.h    |   1 +
 include/rdma/ib_verbs.h                       |   2 +-
 include/rdma/rw.h                             |   2 +
 include/uapi/linux/ethtool.h                  |   1 +
 include/uapi/linux/hyperv.h                   |   2 +-
 include/uapi/linux/netfilter_bridge.h         |   4 +
 include/uapi/linux/vbox_vmmdev_types.h        |   4 +-
 kernel/bpf/verifier.c                         |  18 +-
 kernel/kexec_file.c                           | 131 ++++----
 kernel/sched/rt.c                             |   5 +
 kernel/time/hrtimer.c                         |   2 +-
 kernel/time/timer.c                           |   2 +-
 kernel/trace/trace.c                          |   2 +-
 kernel/trace/trace_events.c                   |   5 -
 kernel/trace/trace_hwlat.c                    |  15 +-
 kernel/ucount.c                               |   2 +-
 mm/page_alloc.c                               |  14 +
 net/atm/signaling.c                           |  56 +++-
 net/bluetooth/hci_conn.c                      |   4 +-
 net/bluetooth/l2cap_core.c                    |  73 +++--
 net/ceph/crypto.c                             |   8 +-
 net/ceph/crypto.h                             |   2 +-
 net/ceph/messenger_v2.c                       |   2 +-
 net/core/dev.c                                |  25 +-
 net/ethtool/common.c                          |   1 +
 net/ethtool/ioctl.c                           |   1 +
 net/ipv4/fib_lookup.h                         |   6 +-
 net/ipv4/fib_trie.c                           |   4 +-
 net/ipv4/tcp.c                                |   3 +
 net/ipv6/exthdrs.c                            |  15 +-
 net/ipv6/ioam6.c                              |  14 +
 net/ipv6/ioam6_iptunnel.c                     |  10 +-
 net/ipv6/xfrm6_policy.c                       |   7 +-
 net/netfilter/nf_conncount.c                  |  54 +++-
 net/netfilter/nf_conntrack_h323_asn1.c        |   2 +-
 net/netfilter/nf_conntrack_h323_main.c        |  10 +-
 net/netfilter/nf_conntrack_proto_generic.c    |   1 +
 net/netfilter/nft_connlimit.c                 |   7 +-
 net/netfilter/nft_set_hash.c                  |   9 +-
 net/netfilter/nft_set_rbtree.c                |  30 +-
 net/netfilter/xt_tcpmss.c                     |   2 +-
 net/nfc/hci/llc_shdlc.c                       |   8 +
 net/nfc/nci/ntf.c                             | 159 +++++++--
 net/rds/connection.c                          |   4 +
 net/rds/send.c                                |   6 +-
 net/rds/tcp_listen.c                          |   5 -
 net/sunrpc/auth_gss/auth_gss.c                |   3 +
 net/sunrpc/auth_gss/gss_rpc_xdr.c             |  82 +++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c      |  43 ++-
 net/tipc/crypto.c                             |   2 +-
 net/tipc/name_table.c                         |   6 +-
 net/vmw_vsock/vmci_transport.c                |   2 +-
 net/wireless/core.c                           |   4 +-
 net/wireless/wext-compat.c                    |   2 +-
 scripts/mod/modpost.c                         |   4 +
 security/apparmor/apparmorfs.c                |   9 +
 security/apparmor/net.c                       |   6 +-
 security/apparmor/resource.c                  |   5 +
 security/smack/smackfs.c                      |  79 +++--
 sound/soc/codecs/es8328.c                     |  10 +-
 sound/soc/codecs/wm8962.c                     |  12 +-
 sound/soc/fsl/fsl_xcvr.c                      |   3 -
 sound/usb/endpoint.c                          |  40 ++-
 sound/usb/quirks.c                            |   2 +
 tools/bpf/bpftool/net.c                       |   5 +-
 tools/lib/bpf/btf_dump.c                      |  24 +-
 tools/lib/bpf/netlink.c                       |   4 +-
 tools/lib/perf/Makefile                       |  14 +-
 tools/perf/util/evsel_fprintf.c               |   8 +-
 tools/power/cpupower/lib/cpuidle.c            |   1 +
 tools/spi/.gitignore                          |   1 +
 .../drivers/net/mlxsw/tc_restrictions.sh      |   4 +-
 .../net/forwarding/vxlan_bridge_1d.sh         |  26 +-
 .../selftests/vm/charge_reserved_hugetlb.sh   |   4 +-
 401 files changed, 3398 insertions(+), 1653 deletions(-)
 create mode 100644 drivers/pinctrl/qcom/pinctrl-lpass-lpi.h
 create mode 100644 drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c

-- 
2.51.0

